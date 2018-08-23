#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

#define BUF_SIZE PGSIZE/4
#define MAX_POSSIBLE ~0x80000000
//using 0x80000000 introduces "negative" numbers which r a pain in the ass!
#define ADD_TO_AGE 0x40000000
#define DEBUG 0

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()
struct segdesc gdt[NSEGS];

int deallocCount = 0;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

void
checkProcAccBit(){
  int i;
  pte_t *pte1;

  //cprintf("checkAccessedBit\n");
  for (i = 0; i < MAX_PSYC_PAGES; i++)
    if (proc->freepages[i].va != (char*)0xffffffff){
      pte1 = walkpgdir(proc->pgdir, (void*)proc->freepages[i].va, 0);
      if (!*pte1){
        cprintf("checkAccessedBit: pte1 is empty\n");
        continue;
      }
      cprintf("checkAccessedBit: pte1 & PTE_A == %d\n", (*pte1) & PTE_A);
    }
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(v2p(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(v2p(p->pgdir));  // switch to new address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

void scRecord(char *va)
{
  int i;
  //TODO delete   cprintf("sc/aq Record!\n");
  for (i = 0; i < MAX_PSYC_PAGES; i++)
    if (proc->freepages[i].va == (char*)0xffffffff)
      goto foundrnp;
  cprintf("panic follows, pid:%d, name:%s\n", proc->pid, proc->name);
  panic("recordNewPage: no free pages");
foundrnp:
  //TODO delete cprintf("found unused page!\n");
  proc->freepages[i].va = va;
  proc->freepages[i].next = proc->head;
  proc->freepages[i].prev = 0;
  if(proc->head != 0)// old head points back to new head
    proc->head->prev = &proc->freepages[i];
  else//head == 0 so first link inserted is also the tail
    proc->tail = &proc->freepages[i];
  proc->head = &proc->freepages[i];
}

void nfuaRecord(char *va){
  int i;
  //TODO delete cprintf("nfuRecord!\n");
  for (i = 0; i < MAX_PSYC_PAGES; i++)
    if (proc->freepages[i].va == (char*)0xffffffff)
      goto foundrnp;
  cprintf("panic follows, pid:%d, name:%s\n", proc->pid, proc->name);
  panic("recordNewPage: no free pages");
foundrnp:
  //TODO delete cprintf("found unused page!\n");
  proc->freepages[i].va = va;
}

void lapaRecord(char *va){
  int i;
  //TODO delete cprintf("nfuRecord!\n");
  for (i = 0; i < MAX_PSYC_PAGES; i++)
    if (proc->freepages[i].va == (char*)0xffffffff)
      goto foundrnp;
  cprintf("panic follows, pid:%d, name:%s\n", proc->pid, proc->name);
  panic("recordNewPage: no free pages");
foundrnp:
  //TODO delete cprintf("found unused page!\n");
  proc->freepages[i].va = va;
  proc->freepages[i].age = 0xffffffff;
  //cprintf("proc id: %d. lapa record. the age of the page with address 0x%x is 0x%x\n", proc->pid, proc->freepages[i].va,proc->freepages[i].age);
}

void aqRecord(char *va)
{
  int i;
  struct freepg *iter, *oldTail;

  //TODO delete   cprintf("sc/aq Record!\n");
  for (i = 0; i < MAX_PSYC_PAGES; i++)
    if (proc->freepages[i].va == (char*)0xffffffff)
      goto foundrnp;

  cprintf("panic follows, pid:%d, name:%s\n", proc->pid, proc->name);
  panic("recordNewPage: no free pages");

foundrnp:
if (proc->head == 0)
  proc->head = &proc->freepages[i];
else
  {
    iter = proc->head;
    oldTail = proc->tail;
    do{
      iter = iter->next;
    } while (iter != oldTail);
    //TODO delete cprintf("found unused page!\n");
    proc->freepages[i].va = va;
    proc->freepages[i].next = 0;
    proc->freepages[i].prev = iter;
    iter->next = &proc->freepages[i];
    // if(proc->head != 0)// old head points back to new head
    //   proc->head->prev = &proc->freepages[i];
    // else//head == 0 so first link inserted is also the tail
    proc->tail = &proc->freepages[i];
    // proc->head = &proc->freepages[i];
  }
}


void recordNewPage(char *va) {
  //TODO delete $$$cprintf("record page\n");
#if SCFIFO
  //TODO cprintf("recordNewPage: %s is calling scRecord with: 0x%x\n", proc->name, va);
  scRecord(va);
#elif NFUA
  nfuaRecord(va);
#elif LAPA
  lapaRecord(va);
#elif AQ
  aqRecord(va);
#endif

  proc->pagesinmem++;
  //TODO delete cprintf("\n++++++++++++++++++ proc->pagesinmem+++++++++++++ : %d\n", proc->pagesinmem);
}


int checkAccBit(char *va){
  uint accessed;
  pte_t *pte = walkpgdir(proc->pgdir, (void*)va, 0);
  if (!*pte)
    panic("checkAccBit: pte1 is empty");
  accessed = (*pte) & PTE_A;
  (*pte) &= ~PTE_A;
  return accessed;
}

struct freepg *scWrite(char *va) {
  //TODO delete  
  cprintf("scWrite: \n");
  int i;
  struct freepg *mover, *oldTail;
  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)0xffffffff)
      goto foundswappedpageslot;
  }
  panic("writePageToSwapFile: SCFIFO no slot for swapped page");

foundswappedpageslot:
    //link = proc->head;
  if (proc->head == 0)
    panic("scWrite: proc->head is NULL");
  if (proc->head->next == 0)
    panic("scWrite: single page in phys mem");


  mover = proc->tail;
  oldTail = proc->tail;// to avoid infinite loop if everyone was accessed
  do{
    //move mover from tail to head
    proc->tail = proc->tail->prev;
    proc->tail->next = 0;
    mover->prev = 0;
    mover->next = proc->head;
    proc->head->prev = mover;
    proc->head = mover;
    mover = proc->tail;
  }while(checkAccBit(proc->head->va) && mover != oldTail);

  if(DEBUG){
    //cprintf("address between 0x%x and 0x%x was accessed but was on disk.\n\n", addr, addr+PGSIZE);
    cprintf("SCFIFO chose to page out page starting at 0x%x \n\n", proc->head->va);
  }

  cprintf("page moved to file: 0x%x\n", proc->head->va);

  //make the swap
  proc->swappedpages[i].va = proc->head->va;
  int num = 0;
  if ((num = writeToSwapFile(proc, (char*)PTE_ADDR(proc->head->va), i * PGSIZE, PGSIZE)) == 0)
    return 0;

  pte_t *pte1 = walkpgdir(proc->pgdir, (void*)proc->head->va, 0);
  if (!*pte1)
    panic("writePageToSwapFile: pte1 is empty");

  kfree((char*)PTE_ADDR(P2V_WO(*walkpgdir(proc->pgdir, proc->head->va, 0))));
  *pte1 = PTE_W | PTE_U | PTE_PG;
  ++proc->totalPagedOutCount;
  ++proc->pagesinswapfile;

  //TODO delete   cprintf("++proc->pagesinswapfile : %d", proc->pagesinswapfile);

  lcr3(v2p(proc->pgdir));
  proc->head->va = va;

  //TODO cprintf("scWrite: new addr in head: 0x%x\n", va);

  // unnecessary but will do for now
  return proc->head;
}

struct freepg *aqWrite(char *va) {
  //TODO delete  
  cprintf("aqWrite: \n");
  int i;
  struct freepg *iter, *oldTail, *temp;

  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)0xffffffff)
      goto foundswappedpageslot;
  }
  panic("writePageToSwapFile: AQ no slot for swapped page");

foundswappedpageslot:
    //link = proc->head;
  if (proc->head == 0)
    panic("aqWrite: proc->head is NULL");
  if (proc->head->next == 0)
    panic("aqWrite: single page in phys mem");

  cprintf("aq before: \n");

  iter = proc->head;
  int h = 0;
  do{
    cprintf("%d: 0x%x\n", h++, iter->va);
    iter = iter->next;
  } while (iter != proc->tail);

  // pte_t     *pte;
  // uint      accessed;
  // uint      accessedNext;
  oldTail = proc->tail;
  iter    = proc->head;
  do{
    // pte = walkpgdir(proc->pgdir, (void*)iter->va, 0);
    // accessed = (*pte) & PTE_A;
    // pte = walkpgdir(proc->pgdir, (void*)iter->next->va, 0);
    // accessedNext = (*pte) & PTE_A;
    // if (accessed && !accessedNext){
      temp = temp->next;
      temp->prev = iter->prev;
      iter->next = temp->next;
      temp->next = iter;
      iter->prev = temp;
    // } else {
    //   iter = iter->next;
    // }
  } while (checkAccBit(proc->head->va) && iter != oldTail);
  // do{
  //   pte = walkpgdir(proc->pgdir, (void*)iter->va, 0);
  //   accessed = (*pte) & PTE_A;
  //   pte = walkpgdir(proc->pgdir, (void*)iter->prev->va, 0);
  //   accessedPrev = (*pte) & PTE_A;
  //   if (!accessed && accessedPrev){
  //     temp = iter;
  //     temp->prev = iter->prev;
  //     iter->next = temp->next;
  //     temp->next = iter;
  //     iter->prev = temp;
  //   }
  //   iter = temp;
  // } while (iter != oldTail);

  if(DEBUG){
    //cprintf("address between 0x%x and 0x%x was accessed but was on disk.\n\n", addr, addr+PGSIZE);
    cprintf("AQ chose to page out page starting at 0x%x \n\n", proc->head->va);
  }


  cprintf("aq after: \n");
  iter = proc->head;
  h = 0;
  do{
    cprintf("%d: 0x%x\n", h++, iter->va);
    iter = iter->next;
  } while (iter != proc->tail);



  cprintf("page moved to file: 0x%x\n", proc->head->va);

  //make the swap
  proc->swappedpages[i].va = proc->tail->va;
  int num = 0;
  if ((num = writeToSwapFile(proc, (char*)PTE_ADDR(proc->tail->va), i * PGSIZE, PGSIZE)) == 0)
    return 0;

  pte_t *pte1 = walkpgdir(proc->pgdir, (void*)proc->tail->va, 0);
  if (!*pte1)
    panic("writePageToSwapFile: pte1 is empty");

  kfree((char*)PTE_ADDR(P2V_WO(*walkpgdir(proc->pgdir, proc->tail->va, 0))));
  *pte1 = PTE_W | PTE_U | PTE_PG;
  ++proc->totalPagedOutCount;
  ++proc->pagesinswapfile;

  //TODO delete   cprintf("++proc->pagesinswapfile : %d", proc->pagesinswapfile);

  lcr3(v2p(proc->pgdir));
  proc->tail->va = va;

  //TODO cprintf("scWrite: new addr in tail: 0x%x\n", va);

  // unnecessary but will do for now
return proc->tail;
}

struct freepg *nfuaWrite(char *va) {
  cprintf("Reached nfuWrite\n");
  int i, j;
  uint minIndx = -1, minOnes = 33; //MAX_POSSIBLE;
  struct freepg *chosen;

  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)0xffffffff)
      goto foundswappedpageslot;
  }
  panic("writePageToSwapFile: NFU no slot for swapped page");

foundswappedpageslot:

  for (j = 0; j < MAX_PSYC_PAGES; j++)
    if (proc->freepages[j].va != (char*)0xffffffff){
      // cprintf("the age of page %d is 0x%x\n", j ,proc->freepages[j].age);
      //TODO delete      if(proc->freepages[j].age > 0)      cprintf("i=%d, age=%d, || ", j, proc->freepages[j].age);
      int onesCounter = 0;
      int age = proc->freepages[j].age;
      while(age > 0){
        if(age % 2 == 1)
          onesCounter++;
        age /= 2;  
      }
      cprintf("the age of page %d with address 0x%x is 0x%x\n", j, proc->freepages[j].va ,proc->freepages[j].age);
      if (onesCounter < minOnes){//TODO should be <= not < just wanted to see different indexes than 14
        //maxAge = proc->freepages[j].age;
        minOnes = proc->freepages[j].age;
        minIndx = j;
      }
    }

  if(minIndx == -1)
    panic("nfuWrite: no free page to swap???");
  chosen = &proc->freepages[minIndx];

  if(DEBUG){
    //cprintf("\naddress between 0x%x and 0x%x was accessed but was on disk.\n", addr, addr+PGSIZE);
    cprintf("NFU chose to page out page starting at 0x%X \n\n", chosen->va);
  }

  cprintf("nfu write: page moved to file: 0x%x\n", chosen->va);

  pte_t *pte1 = walkpgdir(proc->pgdir, (void*)chosen->va, 0);
  if (!*pte1)
    panic("writePageToSwapFile: pte1 is empty");
/*
//  TODO verify: b4 accessing by writing to file,
//  update accessed bit and age in case it misses a clock tick?
//  be extra careful not to double add by locking
  acquire(&tickslock);
  //TODO delete cprintf("acquire(&tickslock)\n");
  if((*pte1) & PTE_A){
    ++chosen->age;
    *pte1 &= ~PTE_A;
    //TODO delete cprintf("========\n\nWOW! Matan was right!\n(never saw this actually printed)=======\n\n");
  }
  release(&tickslock);
*/
  //make swap
  proc->swappedpages[i].va = chosen->va;
  int num = 0;
  if ((num = writeToSwapFile(proc, (char*)PTE_ADDR(chosen->va), i * PGSIZE, PGSIZE)) == 0)
    return 0;

  kfree((char*)PTE_ADDR(P2V_WO(*walkpgdir(proc->pgdir, chosen->va, 0))));
  *pte1 = PTE_W | PTE_U | PTE_PG;
  ++proc->totalPagedOutCount;
  ++proc->pagesinswapfile;

  //TODO delete   cprintf("++proc->pagesinswapfile : %d", proc->pagesinswapfile);

  lcr3(v2p(proc->pgdir));
  chosen->va = va;
  chosen->age = 0; 

  // unnecessary but will do for now
  return chosen;
}

struct freepg *lapaWrite(char *va) {
  cprintf("Reached lapaWrite\n");
  int i, j;
  uint minIndx = -1, minOnes = 33; //MAX_POSSIBLE;
  struct freepg *chosen;

  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)0xffffffff)
      goto foundswappedpageslot;
  }
  panic("writePageToSwapFile: lapa no slot for swapped page");

foundswappedpageslot:

  for (j = 0; j < MAX_PSYC_PAGES; j++)
    if (proc->freepages[j].va != (char*)0xffffffff){
      // cprintf("the age of page %d is 0x%x\n", j ,proc->freepages[j].age);
      //TODO delete      if(proc->freepages[j].age > 0)      cprintf("i=%d, age=%d, || ", j, proc->freepages[j].age);
      int onesCounter = 0;
      int age = proc->freepages[j].age;
      while(age > 0){
        if(age % 2 == 1)
          onesCounter++;
        age /= 2;  
      }
      cprintf("the age of page %d with address 0x%x is 0x%x\n", j, proc->freepages[j].va ,proc->freepages[j].age);
      if (onesCounter < minOnes){//TODO should be <= not < just wanted to see different indexes than 14
        //maxAge = proc->freepages[j].age;
        minOnes = proc->freepages[j].age;
        minIndx = j;
      }
    }

  if(minIndx == -1)
    panic("lapaWrite: no free page to swap???");
  chosen = &proc->freepages[minIndx];

  if(DEBUG){
    //cprintf("\naddress between 0x%x and 0x%x was accessed but was on disk.\n", addr, addr+PGSIZE);
    cprintf("lapa chose to page out page starting at 0x%X \n\n", chosen->va);
  }

  cprintf("lapa write: page moved to file (swapped out): 0x%x\n", chosen->va);



  pte_t *pte1 = walkpgdir(proc->pgdir, (void*)chosen->va, 0);
  if (!*pte1)
    panic("writePageToSwapFile: pte1 is empty");

  //make swap
  proc->swappedpages[i].va = chosen->va;
  int num = 0;
  if ((num = writeToSwapFile(proc, (char*)PTE_ADDR(chosen->va), i * PGSIZE, PGSIZE)) == 0)
    return 0;

  kfree((char*)PTE_ADDR(P2V_WO(*walkpgdir(proc->pgdir, chosen->va, 0))));
  *pte1 = PTE_W | PTE_U | PTE_PG;
  ++proc->totalPagedOutCount;
  ++proc->pagesinswapfile;

  //TODO delete   cprintf("++proc->pagesinswapfile : %d", proc->pagesinswapfile);

  lcr3(v2p(proc->pgdir));
  chosen->va = va;
  chosen->age = 0xffffffff; 

  // unnecessary but will do for now
  return chosen;
}


struct freepg *writePageToSwapFile(char* va) {
  //TODO delete $$$

#if SCFIFO
  //TODO cprintf("writePageToSwapFile: calling scWrite\n");
  return scWrite(va);
#elif NFUA
  return nfuaWrite(va);
#elif LAPA
  return lapaWrite(va);
#elif AQ
  return aqWrite(va);
#endif
  //TODO: delete cprintf("none of the above...\n");
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;

#ifndef NONE
  uint newpage = 1;
  struct freepg *l;
#endif

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
#ifndef NONE
    //TODO delete   cprintf("inside #ifndef NONE: checking pages in mem: %d\n", proc->pagesinmem);
    // TODO: check if we should add another test for init and shel here...
    if(proc->pagesinmem >= MAX_PSYC_PAGES) {
      // TODO delete cprintf("writing to swap file, proc->name: %s, pagesinmem: %d\n", proc->name, proc->pagesinmem);
      //int i;
      //for (i = 0; i < MAX_PSYC_PAGES; i++)
        //cprintf("allocuvm. the age of the page with address 0x%x is 0x%x\n", proc->freepages[i].va,proc->freepages[i].age);

      cprintf("moving a page to the file\n");
      //TODO remove l! it doesn't belong here
      if ((l = writePageToSwapFile((char*)a)) == 0)
        panic("allocuvm: error writing page to swap file");

      //TODO: these FIFO specific steps don't belong here!
      // they should move to a FIFO specific functiom!
      /*
      #if FIFO
      //TODO cprintf("allocuvm: FIFO's little part\n");
      l->va = (char*)a;
      l->next = proc->head;
      proc->head = l;
      #endif
*/    cprintf("end of allocuvm. the age of the page with address 0x%x is 0x%x\n", l->va, l->age);

      newpage = 0;
    }
#endif
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      // TODO delete proc->pagesNo--;
      return 0;
    }
    #ifndef NONE
    if (newpage){
      //TODO delete cprintf("nepage = 1");
      //if(proc->pagesinmem >= 11)
        //TODO delete cprintf("recorded new page, proc->name: %s, pagesinmem: %d\n", proc->name, proc->pagesinmem);
      recordNewPage((char*)a);
    }
    #endif




    memset(mem, 0, PGSIZE);
    //TODO delete cprintf("mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);\n");
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;
  int i;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      if (proc->pgdir == pgdir) {
        /*
        The process itself is deallocating pages via sbrk() with a negative
        argument. Update proc's data structure accordingly.
        */
#ifndef NONE
        for (i = 0; i < MAX_PSYC_PAGES; i++) {
          if (proc->freepages[i].va == (char*)a)
            goto founddeallocuvmPTEP;
        }

        panic("deallocuvm: entry not found in proc->freepages");
founddeallocuvmPTEP:
        proc->freepages[i].va = (char*) 0xffffffff;

#if SCFIFO
        //TODO  cprintf("deallocuvm: entering SCFIFO part\n");

        if (proc->head == &proc->freepages[i]){
          proc->head = proc->freepages[i].next;
          if(proc->head != 0)
            proc->head->prev = 0;
          goto doneLooking;
        }
        if (proc->tail == &proc->freepages[i]){
          proc->tail = proc->freepages[i].prev;
          if(proc->tail != 0)// should allways be true but lets be extra safe...
            proc->tail->next = 0;
          goto doneLooking;
        }
        struct freepg *l = proc->head;
        while (l->next != 0 && l->next != &proc->freepages[i]){
          l = l->next;
        }
        l->next = proc->freepages[i].next;
        if (proc->freepages[i].next != 0){
          proc->freepages[i].next->prev = l;
        }

doneLooking:
        //TODO delete cprintf("deallocCount = %d\n", ++deallocCount);
        proc->freepages[i].next = 0;
        proc->freepages[i].prev = 0;

 #if AQ
        //TODO  
        cprintf("deallocuvm: entering AQ part\n");
        if (proc->head == &proc->freepages[i]){
          proc->head = proc->freepages[i].next;
          if(proc->head != 0)
            proc->head->prev = 0;
          goto doneLooking;
        }
        if (proc->tail == &proc->freepages[i]){
          proc->tail = proc->freepages[i].prev;
          if(proc->tail != 0)// should allways be true but lets be extra safe...
            proc->tail->next = 0;
          goto doneLooking;
        }
        struct freepg *l = proc->head;
        while (l->next != 0 && l->next != &proc->freepages[i]){
          l = l->next;
        }
        l->next = proc->freepages[i].next;
        if (proc->freepages[i].next != 0){
          proc->freepages[i].next->prev = l;
        }

doneLooking:
        //TODO delete cprintf("deallocCount = %d\n", ++deallocCount);
        proc->freepages[i].next = 0;
        proc->freepages[i].prev = 0;

#elif NFUA
        proc->freepages[i].age = 0;
#endif
#elif LAPA
        proc->freepages[i].age = 0xffffffff;
#endif
#endif

        proc->pagesinmem--;
      }
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
    else if (*pte & PTE_PG && proc->pgdir == pgdir) {
      /*
      The process itself is deallocating pages via sbrk() with a negative
      argument. Update proc's data structure accordingly.
      */
        for (i = 0; i < MAX_PSYC_PAGES; i++) {
          if (proc->swappedpages[i].va == (char*)a)
            goto founddeallocuvmPTEPG;
        }
        panic("deallocuvm: entry not found in proc->swappedpages");
founddeallocuvmPTEPG:
        proc->swappedpages[i].va = (char*) 0xffffffff;
        proc->swappedpages[i].age = 0;
        proc->swappedpages[i].swaploc = 0;
        proc->pagesinswapfile--;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  // TODO delete cprintf("freevm pid %d\n", proc->pid);
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
      panic("copyuvm: page not present");
    if (*pte & PTE_PG) {
      // cprintf("copyuvm PTR_PG\n"); // TODO delete
      pte = walkpgdir(d, (void*) i, 1);
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;

    // TODO delete cprintf("copyuvm:kalloc pid %d\n", proc->pid);
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)p2v(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

void scSwap(uint addr) {
  int i, j;
  char buf[BUF_SIZE];
  pte_t *pte1, *pte2;
  struct freepg *mover, *oldTail;

  if (proc->head == 0)
    panic("scSwap: proc->head is NULL");
  if (proc->head->next == 0)
    panic("scSwap: single page in phys mem");

  mover = proc->tail;
  oldTail = proc->tail;// to avoid infinite loop if somehow everyone was accessed
  do{
    //move mover from tail to head
    proc->tail = proc->tail->prev;
    proc->tail->next = 0;
    mover->prev = 0;
    mover->next = proc->head;
    proc->head->prev = mover;
    proc->head = mover;
    mover = proc->tail;
  }while(checkAccBit(proc->head->va) && mover != oldTail);

  if(DEBUG){
    //cprintf("\naddress between 0x%x and 0x%x was accessed but was on disk.\n", addr, addr+PGSIZE);
    cprintf("SCFIFO chose to page out page starting at 0x%x \n\n", proc->head->va);
  }

  cprintf("the pages swapped is: 0x%x\n", proc->head->va);


  //find the address of the page table entry to copy into the swap file
  pte1 = walkpgdir(proc->pgdir, (void*)proc->head->va, 0);
  if (!*pte1)
    panic("swapFile: SCFIFO pte1 is empty");

  //find a swap file page descriptor slot
  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)PTE_ADDR(addr))
      goto foundswappedpageslot;
  }
  panic("scSwap: SCFIFO no slot for swapped page");

foundswappedpageslot:

  proc->swappedpages[i].va = proc->head->va;
  //assign the physical page to addr in the relevant page table
  pte2 = walkpgdir(proc->pgdir, (void*)addr, 0);
  if (!*pte2)
    panic("swapFile: SCFIFO pte2 is empty");
  //set page table entry
  //TODO verify we're not setting PTE_U where we shouldn't be...
  *pte2 = PTE_ADDR(*pte1) | PTE_U | PTE_W | PTE_P;// access bit is zeroed...

  for (j = 0; j < 4; j++) {
    int loc = (i * PGSIZE) + ((PGSIZE / 4) * j);
    // cprintf("i:%d j:%d loc:0x%x\n", i,j,loc);//TODO delete
    int addroffset = ((PGSIZE / 4) * j);
    // int read, written;
    memset(buf, 0, BUF_SIZE);
    //copy the new page from the swap file to buf
    // read =
    readFromSwapFile(proc, buf, loc, BUF_SIZE);
    // cprintf("read:%d\n", read);//TODO delete
    //copy the old page from the memory to the swap file
    //written =
    writeToSwapFile(proc, (char*)(P2V_WO(PTE_ADDR(*pte1)) + addroffset), loc, BUF_SIZE);
    // cprintf("written:%d\n", written);//TODO delete
    //copy the new page from buf to the memory
    memmove((void*)(PTE_ADDR(addr) + addroffset), (void*)buf, BUF_SIZE);
  }
  //update the page table entry flags, reset the physical page address
  *pte1 = PTE_U | PTE_W | PTE_PG;
  //update l to hold the new va
  //l->next = proc->head;
  //proc->head = l;
  proc->head->va = (char*)PTE_ADDR(addr);

}

void aqSwap(uint addr) {
  cprintf("aq swap\n");
  int i, j;
  char buf[BUF_SIZE];
  pte_t *pte1, *pte2;
  struct freepg *iter, *oldTail, *temp;

  if (proc->head == 0)
    panic("aqSwap: proc->head is NULL");
  if (proc->head->next == 0)
    panic("aqSwap: single page in phys mem");


  // pte_t     *pte;
  // uint      accessed;
  // uint      accessedNext;
  oldTail = proc->tail;
  iter    = proc->head;

  do{
    // pte = walkpgdir(proc->pgdir, (void*)iter->va, 0);
    // accessed = (*pte) & PTE_A;
    // pte = walkpgdir(proc->pgdir, (void*)iter->next->va, 0);
    // accessedNext = (*pte) & PTE_A;
    // if (accessed && !accessedNext){
      temp = temp->next;
      temp->prev = iter->prev;
      iter->next = temp->next;
      temp->next = iter;
      iter->prev = temp;
    // } else {
    //   iter = iter->next;
    // }
  } while (checkAccBit(proc->head->va) && iter != oldTail);

  if(DEBUG){
    //cprintf("\naddress between 0x%x and 0x%x was accessed but was on disk.\n", addr, addr+PGSIZE);
    cprintf("AQ chose to page out page starting at 0x%x \n\n", proc->head->va);
  }

  cprintf("the pages swapped is: 0x%x\n", proc->tail->va);


  //find the address of the page table entry to copy into the swap file
  pte1 = walkpgdir(proc->pgdir, (void*)proc->tail->va, 0);
  if (!*pte1)
    panic("swapFile: AQ pte1 is empty");

  //find a swap file page descriptor slot
  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)PTE_ADDR(addr))
      goto foundswappedpageslot;
  }
  panic("aqSwap: AQ no slot for swapped page");

foundswappedpageslot:

  proc->swappedpages[i].va = proc->tail->va;
  //assign the physical page to addr in the relevant page table
  pte2 = walkpgdir(proc->pgdir, (void*)addr, 0);
  if (!*pte2)
    panic("swapFile: AQ pte2 is empty");
  //set page table entry
  //TODO verify we're not setting PTE_U where we shouldn't be...
  *pte2 = PTE_ADDR(*pte1) | PTE_U | PTE_W | PTE_P;// access bit is zeroed...

  for (j = 0; j < 4; j++) {
    int loc = (i * PGSIZE) + ((PGSIZE / 4) * j);
    // cprintf("i:%d j:%d loc:0x%x\n", i,j,loc);//TODO delete
    int addroffset = ((PGSIZE / 4) * j);
    // int read, written;
    memset(buf, 0, BUF_SIZE);
    //copy the new page from the swap file to buf
    // read =
    readFromSwapFile(proc, buf, loc, BUF_SIZE);
    // cprintf("read:%d\n", read);//TODO delete
    //copy the old page from the memory to the swap file
    //written =
    writeToSwapFile(proc, (char*)(P2V_WO(PTE_ADDR(*pte1)) + addroffset), loc, BUF_SIZE);
    // cprintf("written:%d\n", written);//TODO delete
    //copy the new page from buf to the memory
    memmove((void*)(PTE_ADDR(addr) + addroffset), (void*)buf, BUF_SIZE);
  }
  //update the page table entry flags, reset the physical page address
  *pte1 = PTE_U | PTE_W | PTE_PG;
  //update l to hold the new va
  //l->next = proc->tail;
  //proc->tail = l;
  proc->tail->va = (char*)PTE_ADDR(addr);

}

void nfuaSwap(uint addr) {
  int i, j;
  uint minIndx = -1, minCounter = 0xffffffff;// MAX_POSSIBLE;
  char buf[BUF_SIZE];
  pte_t *pte1, *pte2;
  struct freepg *chosen;

  //TODO delete   cprintf("MAX_POSSIBLE = %d\n", MAX_POSSIBLE);

  for (j = 0; j < MAX_PSYC_PAGES; j++)
    if (proc->freepages[j].va != (char*)0xffffffff){
      cprintf("the age of page %d is 0x%x\n", j ,proc->freepages[j].age);
      //int age = proc->freepages[j].age;
      if (proc->freepages[j].age < minCounter){//TODO should be <= not < just wanted to see different indexes than 14
        minCounter = proc->freepages[j].age;
        minIndx = j;
      }
    }

  if(minIndx == -1)
    panic("nfuSwap: no free page to swap???");
  chosen = &proc->freepages[minIndx];

  if(DEBUG){
    //cprintf("\naddress between 0x%x and 0x%x was accessed but was on disk.\n", addr, addr+PGSIZE);
    cprintf("NFU chose to page out page starting at 0x%x \n\n", chosen->va);
  }

  cprintf("the pages swapped is: 0x%x\n", chosen->va);
  cprintf("nfu swap: swapping page with index: %d\n", minIndx);


  //find the address of the page table entry to copy into the swap file
  pte1 = walkpgdir(proc->pgdir, (void*)chosen->va, 0);
  if (!*pte1)
    panic("nfuSwap: pte1 is empty");

  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)PTE_ADDR(addr))
      goto foundswappedpageslot;
  }
  panic("nfuSwap: no slot for swapped page");

foundswappedpageslot:

  proc->swappedpages[i].va = chosen->va;
  //assign the physical page to addr in the relevant page table
  pte2 = walkpgdir(proc->pgdir, (void*)addr, 0);
  if (!*pte2)
    panic("nfuSwap: pte2 is empty");
  //set page table entry
  //TODO verify we're not setting PTE_U where we shouldn't be...
  *pte2 = PTE_ADDR(*pte1) | PTE_U | PTE_W | PTE_P;// access bit is zeroed...

  for (j = 0; j < 4; j++) {
    int loc = (i * PGSIZE) + ((PGSIZE / 4) * j);
    int addroffset = ((PGSIZE / 4) * j);
    memset(buf, 0, BUF_SIZE);
    readFromSwapFile(proc, buf, loc, BUF_SIZE);
    writeToSwapFile(proc, (char*)(P2V_WO(PTE_ADDR(*pte1)) + addroffset), loc, BUF_SIZE);
    memmove((void*)(PTE_ADDR(addr) + addroffset), (void*)buf, BUF_SIZE);
  }
  *pte1 = PTE_U | PTE_W | PTE_PG;
  chosen->va = (char*)PTE_ADDR(addr);
  chosen->age = 0;
}

void lapaSwap(uint addr) {
  cprintf("lapa swap\n");
  int i, j;
  uint minIndx = -1, minCounter = 0xffffffff;// MAX_POSSIBLE;
  char buf[BUF_SIZE];
  pte_t *pte1, *pte2;
  struct freepg *chosen;

  //TODO delete   cprintf("MAX_POSSIBLE = %d\n", MAX_POSSIBLE);

  for (j = 0; j < MAX_PSYC_PAGES; j++)
    if (proc->freepages[j].va != (char*)0xffffffff){
      cprintf("the age of page %d is 0x%x\n", j ,proc->freepages[j].age);
      //TODO delete      if(proc->freepages[j].age > 0)      cprintf("i=%d, age=%d, || ", j, proc->freepages[j].age);

      if (proc->freepages[j].age < minCounter){//TODO should be <= not < just wanted to see different indexes than 14
        //maxAge = proc->freepages[j].age;
        minCounter = proc->freepages[j].age;
        minIndx = j;
      }
    }



  if(minIndx == -1)
    panic("lapaSwap: no free page to swap???");
  chosen = &proc->freepages[minIndx];

  if(DEBUG){
    //cprintf("\naddress between 0x%x and 0x%x was accessed but was on disk.\n", addr, addr+PGSIZE);
    cprintf("lapa chose to page out page starting at 0x%x \n\n", chosen->va);
  }

    


  //cprintf("swapping page with index: %d\n", minIndx);




  //find the address of the page table entry to copy into the swap file
  pte1 = walkpgdir(proc->pgdir, (void*)chosen->va, 0);
  if (!*pte1)
    panic("nfuSwap: pte1 is empty");

  for (i = 0; i < MAX_PSYC_PAGES; i++){
    if (proc->swappedpages[i].va == (char*)PTE_ADDR(addr))
      goto foundswappedpageslot;
  }
  panic("nfuSwap: no slot for swapped page");

foundswappedpageslot:
  cprintf("the page swapped out is: 0x%x. ", chosen->va);
  cprintf("the page swapped in is: 0x%x\n", proc->swappedpages[i].va);

  proc->swappedpages[i].va = chosen->va;
  //assign the physical page to addr in the relevant page table
  pte2 = walkpgdir(proc->pgdir, (void*)addr, 0);
  if (!*pte2)
    panic("nfuSwap: pte2 is empty");
  //set page table entry
  //TODO verify we're not setting PTE_U where we shouldn't be...
  *pte2 = PTE_ADDR(*pte1) | PTE_U | PTE_W | PTE_P;// access bit is zeroed...

  for (j = 0; j < 4; j++) {
    int loc = (i * PGSIZE) + ((PGSIZE / 4) * j);
    int addroffset = ((PGSIZE / 4) * j);
    memset(buf, 0, BUF_SIZE);
    readFromSwapFile(proc, buf, loc, BUF_SIZE);
    writeToSwapFile(proc, (char*)(P2V_WO(PTE_ADDR(*pte1)) + addroffset), loc, BUF_SIZE);
    memmove((void*)(PTE_ADDR(addr) + addroffset), (void*)buf, BUF_SIZE);
  }
  *pte1 = PTE_U | PTE_W | PTE_PG;
  chosen->va = (char*)PTE_ADDR(addr);
  chosen->age = 0xffffffff;
}

void swapPages(uint addr) {
  cprintf("reached swapPages!\n");
  if (strcmp(proc->name, "init") == 0 || strcmp(proc->name, "sh") == 0) {
    proc->pagesinmem++;
    return;
  }

  #if SCFIFO
    cprintf("swapPages: calling scSwap\n");
    scSwap(addr);
  #elif NFUA
    cprintf("swapPages: calling nfuSwap\n");
    nfuaSwap(addr);
  #elif LAPA
    cprintf("swapPages: calling lapaSwap\n");
    lapaSwap(addr);
   #elif AQ
    cprintf("swapPages: calling aqSwap\n");
    aqSwap(addr);
  #endif
    lcr3(v2p(proc->pgdir));
    ++proc->totalPagedOutCount;
    // cprintf("swapPages:proc->totalPagedOutCount:%d\n", ++proc->totalPagedOutCount);//TODO delete
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
