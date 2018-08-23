// File system implementation.  Five layers:
//   + Blocks: allocator for raw disk blocks.
//   + Log: crash recovery for multi-step updates.
//   + Files: inode allocator, reading, writing, metadata.
//   + Directories: inode with special contents (list of other inodes!)
//   + Names: paths like /usr/rtm/xv6/fs.c for convenient naming.
//
// This file contains the low-level file system manipulation
// routines.  The (higher-level) system call implementations
// are in sysfile.c.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"
#include "file.h"

#define min(a, b) ((a) < (b) ? (a) : (b))
static void itrunc(struct inode*);
// there should be one superblock per disk device, but we run with
// only one device
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
}

// Zero a block.
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
  memset(bp->data, 0, BSIZE);
  log_write(bp);
  brelse(bp);
}

// Blocks.
//int count = 0;
// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
  int b, bi, m;
  struct buf *bp;
  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){ //iterate on bits (??)
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
        log_write(bp);
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
  log_write(bp);
  brelse(bp);
}

// Inodes.
//
// An inode describes a single unnamed file.
// The inode disk structure holds metadata: the file's type,
// its size, the number of links referring to it, and the
// list of blocks holding the file's content.
//
// The inodes are laid out sequentially on disk at
// sb.startinode. Each inode has a number, indicating its
// position on the disk.
//
// The kernel keeps a cache of in-use inodes in memory
// to provide a place for synchronizing access
// to inodes used by multiple processes. The cached
// inodes include book-keeping information that is
// not stored on disk: ip->ref and ip->valid.
//
// An inode and its in-memory representation go through a
// sequence of states before they can be used by the
// rest of the file system code.
//
// * Allocation: an inode is allocated if its type (on disk)
//   is non-zero. ialloc() allocates, and iput() frees if
//   the reference and link counts have fallen to zero.
//
// * Referencing in cache: an entry in the inode cache
//   is free if ip->ref is zero. Otherwise ip->ref tracks
//   the number of in-memory pointers to the entry (open
//   files and current directories). iget() finds or
//   creates a cache entry and increments its ref; iput()
//   decrements ref.
//
// * Valid: the information (type, size, &c) in an inode
//   cache entry is only correct when ip->valid is 1.
//   ilock() reads the inode from
//   the disk and sets ip->valid, while iput() clears
//   ip->valid if ip->ref has fallen to zero.
//
// * Locked: file system code may only examine and modify
//   the information in an inode and its content if it
//   has first locked the inode.
//
// Thus a typical sequence is:
//   ip = iget(dev, inum)
//   ilock(ip)
//   ... examine and modify ip->xxx ...
//   iunlock(ip)
//   iput(ip)
//
// ilock() is separate from iget() so that system calls can
// get a long-term reference to an inode (as for an open file)
// and only lock it for short periods (e.g., in read()).
// The separation also helps avoid deadlock and races during
// pathname lookup. iget() increments ip->ref so that the inode
// stays cached and pointers to it remain valid.
//
// Many internal file system functions expect the caller to
// have locked the inodes involved; this lets callers create
// multi-step atomic operations.
//
// The icache.lock spin-lock protects the allocation of icache
// entries. Since ip->ref indicates whether an entry is free,
// and ip->dev and ip->inum indicate which i-node an entry
// holds, one must hold icache.lock while using any of those fields.
//
// An ip->lock sleep-lock protects all ip-> fields other than ref,
// dev, and inum.  One must hold ip->lock in order to
// read or write that inode's ip->valid, ip->size, ip->type, &c.

struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}

static struct inode* iget(uint dev, uint inum);

//PAGEBREAK!
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}

// Copy a modified in-memory inode to disk.
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  dip->tags = ip->tags;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
}

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
  ip->ref++;
  release(&icache.lock);
  return ip;
}

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
}

// Drop a reference to an in-memory inode.
// If that was the last reference, the inode cache entry can
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
}

//PAGEBREAK!
// Inode content
//
// The content (data) associated with each inode is stored
// in blocks on the disk. The first NDIRECT block numbers
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.

//12 direct, 1 indirect, 1 double-indirect
//bn can be from 0-11 (direct), 12-139(indirect), or 140-??? double-indirect
static uint
bmap(struct inode *ip, uint bn)
{
  uint addr, *a;
  short entry, offset;
  struct buf *bp;
  
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev); // possibly just now allocating because we save space by allocating only when asked for
    return addr;
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr); //get a block of addresses. bread returns a struct buf*, which is the block. 'data' field is the char[]. 
    a = (uint*)bp->data; //treat the data as blocks size 4. a points to the data
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }

  bn -= NINDIRECT;

  // double indirect
  if(bn < NDOUBLE_INDIRECT){
    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT + 1]) == 0) //now addrs is a block of addresses - each one of them is supposed to (eventually) be also a block of addresses. 
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    
    // get the double indirect table, first level
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    
    // calculate the entry number and the index
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
    
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
      a[entry] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);

    // get the double indirect table, second level
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;

    // if the offset doesnt exist, assign a block to this entry
    if((addr = a[offset]) == 0){
      a[offset] = addr = balloc(ip->dev);
      log_write(bp);
    }

    brelse(bp);
    return addr;
  }


  panic("bmap: out of range");
}

// Truncate inode (discard contents).
// Only called when the inode has no links
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
  st->dev = ip->dev;
  st->ino = ip->inum;
  st->type = ip->type;
  st->nlink = ip->nlink;
  st->size = ip->size;
}

//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}

// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}

//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
}

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
      // entry matches path element
      if(poff)
        *poff = off;
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");

  return 0;
}

//PAGEBREAK!
// Paths

// Copy the next path element from path into name.
// Return a pointer to the element following the copied one.
// The returned path has no leading slashes,
// so the caller can check *path=='\0' to see if the name is the last one.
// If no name to remove, return 0.
//
// Examples:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  return path;
}

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
struct inode*
namex(char *path, int nameiparent, char *name, uint l_counter, struct inode *last_pos, int noderef, char* pathbuffer, int* index, int pathbufsize)
{
  struct inode *ip, *next;
  char buf[100], tname[DIRSIZ];
  struct proc* proc = myproc();

  if (l_counter > MAX_DEREFERENCE) {
    return 0;  // probably infinite loop.
  }

  if(*path == '/'){
    *index = 1;
    pathbuffer[0] = '/';
    pathbuffer[1] = '\0';
    ip = iget(ROOTDEV, ROOTINO);
  }
  else if (last_pos)
  ip = idup(last_pos);    // need to remember last inode
  else
  ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0) {
    
    if(namecmp(name, "..") == 0){
        // Need to delete last element from full path
        if((*index) && !(*index == 1 && pathbuffer[0] == '/')){
            while(*index && pathbuffer[*index] != '/')
                    *index = (*index) - 1;
            if(*index == 0 && pathbuffer[0] == '/')
                    *index = (*index) + 1;
            pathbuffer[*index] = '\0';
        }
    }
    
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlock(ip);
    ilock(next); 
    if(next->type == T_SYMLINK) {
      if(noderef && *path == '\0'){
            iunlock(next);
            iput(ip);
            return next;
        }
        
        if(readi(next, buf, 0, next->size) != next->size) {
        iunlockput(next);
        iput(ip);
        return 0;
      }
    buf[next->size] = 0; 
    iunlockput(next);
    next = namex(buf, 0, tname, l_counter+1, ip, 0, pathbuffer, index, pathbufsize);
    }  else {
        // Check if we need to update pathbuffer
        iunlock(next);
        
        if (namecmp(name, "..") != 0)
        {
            int len = strlen(name);
            // Add '/' if necessary
            if (*index && pathbufsize - *index > 0 && pathbuffer[(*index)-1] != '/'){
                    pathbuffer[(*index)++] = '/';
            }
            
            // case pathbuffer is full 
            if(len >= pathbufsize - (*index)){
                    iput(ip);
                    *index = 0;
                    buf[0] = '\0';
                    return 0;
            }
            
            memmove(pathbuffer + (*index), name, len);
            *index = (*index) + len;
            pathbuffer[(*index)] = '\0';
        }
    }
    iput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}

struct inode*
namei(char *path, int noderef)
{
  char name[DIRSIZ];
  char pathbuffer[MAXPATH];
  int index = 0;
  return namex(path, 0, name, 1, 0, noderef, pathbuffer, &index, MAXPATH);
}


struct inode*
nameiparent(char *path, char *name)
{
  char pathbuffer[MAXPATH];
  int index = 0;
  return namex(path, 1, name, 1, 0, 0, pathbuffer, &index, MAXPATH);
}

void printMem(char* loc, int nbytes){
  int i;
  for(i=0; i<nbytes; i++){
    cprintf("%d ", loc[i]);
  }
}

//returns location for the value
int
searchKey(const char* key, char* str)
{
  //cprintf("start search. searching for key: %s\n", key);
  //int BSIZE = 512;
  printMem(str, 512);
  int i = 0;
  int keyLength = strlen((char*)key);
  for (i = 0; i < BSIZE; i += 42){ 
      if(strncmp(key, str+i, keyLength) == 0){
        //cprintf("search: found key\n");
        i += 11; //for the location of future value  
        //cprintf("returing location %d\n", i);
        return i;
      }
  }
  //cprintf("search: didnt find key\n");
  return -1;
}

int
findEmptyLocation(char* str)
{
  //printMem(str, 512);
  int i = 0;
  for (i = 0; i < BSIZE; i += 42){ 
      if(!str[i]) 
        return i;
  }
  return -1;
}



int
ftag(int fd, char* key, char* value)
{
  struct proc* proc = myproc();
  struct file *f;
  struct buf *bp;
  char *str; //str is the data of the tags block 
  int keyLength, valueLength;
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0) return -1;
  if (f->type != FD_INODE || !f->writable || !f->ip) return -1;
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) return -1;
  if (!value || (valueLength = strlen(value)) < 1 || valueLength > 30) return -1;
  ilock(f->ip);
  if (!f->ip->tags){
    begin_op();
    f->ip->tags = balloc(f->ip->dev);
    end_op();
  }  
  bp = bread(f->ip->dev, f->ip->tags);
  str = (char*)bp->data;
  int endPos = searchKey(key, str);
  if (endPos < 0) {
    if((endPos = findEmptyLocation(str)) < 0){
      brelse(bp);
      iunlock(f->ip);
      return -1;
    }
    //cprintf("key not found. putting key %s in location %d\n", key, endPos);
    memset((void*)((uint)str + (uint)endPos), 0, 42);
    memmove((void*)((uint)str + (uint)endPos), (void*)key, (uint)keyLength);
    memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
    bwrite(bp);
    brelse(bp);
    iunlock(f->ip);
    return 0;
  }
  memset((void*)((uint)str + (uint)endPos + 11), 0, 30);
  memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}


int funtag(int fd, const char* key){
  struct proc* proc = myproc();
  struct file *f;
  int keyLength;
  struct buf *bp;
  char *str;
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0) return -1;
  if (f->type != FD_INODE || !f->writable || !f->ip || !f->ip->tags) return -1;
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) return -1;
  ilock(f->ip);
  bp = bread(f->ip->dev, f->ip->tags);
  str = (char*)bp->data;
  int keyPos = searchKey(key, str);
  if (keyPos < 0) {
    brelse(bp);
    iunlock(f->ip);
    return -1;    
  }
  memset((void*)((uint)str + (uint)keyPos), 0, 42); //the deletion of the key and value
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}



int gettag(int fd, const char* key, char* buf){
  //cprintf("gettag: the key is: %s\n", key);
  struct proc* proc = myproc();
  struct file *f;
  int keyLength;
  int valueLength;
  struct buf *bp;
  char str[BSIZE];
  uint valuePtr;
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0) {
    return -1;
  }
  if (f->type != FD_INODE || !f->readable || !f->ip)
  {
    return -1;
  }
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) {
    return -1; 
  }
  if (!buf){
    return -1; 
  } 
  ilock(f->ip);
  if (!f->ip->tags) {
    iunlock(f->ip);
    return -1;
  }
  bp = bread(f->ip->dev, f->ip->tags);
  memmove((void*)str, (void*)bp->data, (uint)BSIZE);
  brelse(bp);
  iunlock(f->ip);  
  int keyPos = searchKey(key, str);
  if (keyPos < 0){
    //cprintf("didnt find key\n");
    return -1;
  }
  //cprintf("found key, the value position is: %d\n", keyPos);
  valuePtr = ((uint)str + (uint)keyPos);
  valueLength = (uint)strlen((char*) valuePtr);
  memmove((void*)buf, (void*)valuePtr, valueLength);
  return valueLength;
}












































