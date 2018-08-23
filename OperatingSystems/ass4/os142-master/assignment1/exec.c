#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

#include "our_header.h"

char* strcpy(char *, char *);

//int first_visit = 1;

//struct PATH {
static int path_counter = 0;
static char search_paths[MAX_PATH_ENTRIES][MAX_ENTRY_LEN+1] = {{""}}; // +1 for NULL terminated
//};
//static struct PATH* ev_path;


int
exec(char *path, char **argv)
{
  char *s, *last ;
  int i,off,stop;
  char full_path_cmd[MAX_ENTRY_LEN]; // assignment 1 - 1.1
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  stop = 0;
/*  if (first_visit == 1) {
	  ev_path->path_counter = 0 ;
	  first_visit = 0 ;
  }*/
  if((ip = namei(path)) == 0) {
	  // assignment 1 - 1.1 - search in PATH if didn't found in working dir
	  for (i = 0 ; i < path_counter && !stop ; ++i) {
	  	strcpy(full_path_cmd, search_paths[i]);
	  	strcpy(full_path_cmd+strlen(search_paths[i]), path);
	  	if((ip = namei(full_path_cmd)) != 0) {
	  		stop = 1;
	  	}
	  }
	  if (!stop)
		  return -1;
  }


  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
  proc->tf->esp = sp;
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip)
    iunlockput(ip);
  return -1;
}

char*
strcpy(char *s, char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}

int add_path(char* path) {
	int next_char = 0;
	if (path_counter > MAX_PATH_ENTRIES) {
		return path_counter;
	}
	while(*path != 0 && *path != '\n' && *path != '\t' && *path != '\r' && *path != ' ') {
		search_paths[path_counter][next_char] = *path;
		next_char++;
		path++;
	}
	path_counter++;
	return 0;
}

