
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 37 10 80       	mov    $0x80103710,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 79 10 80       	push   $0x801079e0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 f5 49 00 00       	call   80104a50 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 79 10 80       	push   $0x801079e7
80100097:	50                   	push   %eax
80100098:	e8 a3 48 00 00       	call   80104940 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 67 4a 00 00       	call   80104b50 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 09 4b 00 00       	call   80104c70 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 48 00 00       	call   80104980 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 1d 28 00 00       	call   801029a0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 79 10 80       	push   $0x801079ee
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 6d 48 00 00       	call   80104a20 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 d7 27 00 00       	jmp    801029a0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 79 10 80       	push   $0x801079ff
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 2c 48 00 00       	call   80104a20 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 47 00 00       	call   801049e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 40 49 00 00       	call   80104b50 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 0f 4a 00 00       	jmp    80104c70 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 7a 10 80       	push   $0x80107a06
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 15 00 00       	call   80101860 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 48 00 00       	call   80104b50 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 1e 43 00 00       	call   801045e0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 59 3d 00 00       	call   80104030 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 85 49 00 00       	call   80104c70 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 8d 14 00 00       	call   80101780 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 25 49 00 00       	call   80104c70 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 2d 14 00 00       	call   80101780 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 12 2c 00 00       	call   80102fa0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 0d 7a 10 80       	push   $0x80107a0d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 67 83 10 80 	movl   $0x80108367,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 b3 46 00 00       	call   80104a70 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 21 7a 10 80       	push   $0x80107a21
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 61 00 00       	call   801065b0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 d8 60 00 00       	call   801065b0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 cc 60 00 00       	call   801065b0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 c0 60 00 00       	call   801065b0 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 57 48 00 00       	call   80104d70 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 92 47 00 00       	call   80104cc0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 25 7a 10 80       	push   $0x80107a25
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 50 7a 10 80 	movzbl -0x7fef85b0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 4c 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 45 00 00       	call   80104b50 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 24 46 00 00       	call   80104c70 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 11 00 00       	call   80101780 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 5e 45 00 00       	call   80104c70 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 38 7a 10 80       	mov    $0x80107a38,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 83 43 00 00       	call   80104b50 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 3f 7a 10 80       	push   $0x80107a3f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 48 43 00 00       	call   80104b50 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 03 44 00 00       	call   80104c70 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 95 3e 00 00       	call   80104790 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 04 3f 00 00       	jmp    80104880 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 48 7a 10 80       	push   $0x80107a48
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 9b 40 00 00       	call   80104a50 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 72 21 00 00       	call   80102b50 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 2f 36 00 00       	call   80104030 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  
  begin_op();
80100a07:	e8 f4 29 00 00       	call   80103400 <begin_op>

  if((ip = namei(path,0)) == 0){
80100a0c:	83 ec 08             	sub    $0x8,%esp
80100a0f:	6a 00                	push   $0x0
80100a11:	ff 75 08             	pushl  0x8(%ebp)
80100a14:	e8 17 18 00 00       	call   80102230 <namei>
80100a19:	83 c4 10             	add    $0x10,%esp
80100a1c:	85 c0                	test   %eax,%eax
80100a1e:	0f 84 a2 01 00 00    	je     80100bc6 <exec+0x1d6>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a24:	83 ec 0c             	sub    $0xc,%esp
80100a27:	89 c3                	mov    %eax,%ebx
80100a29:	50                   	push   %eax
80100a2a:	e8 51 0d 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2f:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a35:	6a 34                	push   $0x34
80100a37:	6a 00                	push   $0x0
80100a39:	50                   	push   %eax
80100a3a:	53                   	push   %ebx
80100a3b:	e8 20 10 00 00       	call   80101a60 <readi>
80100a40:	83 c4 20             	add    $0x20,%esp
80100a43:	83 f8 34             	cmp    $0x34,%eax
80100a46:	74 28                	je     80100a70 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a48:	83 ec 0c             	sub    $0xc,%esp
80100a4b:	53                   	push   %ebx
80100a4c:	e8 bf 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100a51:	e8 1a 2a 00 00       	call   80103470 <end_op>
80100a56:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a61:	5b                   	pop    %ebx
80100a62:	5e                   	pop    %esi
80100a63:	5f                   	pop    %edi
80100a64:	5d                   	pop    %ebp
80100a65:	c3                   	ret    
80100a66:	8d 76 00             	lea    0x0(%esi),%esi
80100a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a77:	45 4c 46 
80100a7a:	75 cc                	jne    80100a48 <exec+0x58>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a7c:	e8 bf 6c 00 00       	call   80107740 <setupkvm>
80100a81:	85 c0                	test   %eax,%eax
80100a83:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a89:	74 bd                	je     80100a48 <exec+0x58>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a92:	00 
80100a93:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a99:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100aa0:	00 00 00 
80100aa3:	0f 84 c5 00 00 00    	je     80100b6e <exec+0x17e>
80100aa9:	31 ff                	xor    %edi,%edi
80100aab:	eb 18                	jmp    80100ac5 <exec+0xd5>
80100aad:	8d 76 00             	lea    0x0(%esi),%esi
80100ab0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ab7:	83 c7 01             	add    $0x1,%edi
80100aba:	83 c6 20             	add    $0x20,%esi
80100abd:	39 f8                	cmp    %edi,%eax
80100abf:	0f 8e a9 00 00 00    	jle    80100b6e <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ac5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100acb:	6a 20                	push   $0x20
80100acd:	56                   	push   %esi
80100ace:	50                   	push   %eax
80100acf:	53                   	push   %ebx
80100ad0:	e8 8b 0f 00 00       	call   80101a60 <readi>
80100ad5:	83 c4 10             	add    $0x10,%esp
80100ad8:	83 f8 20             	cmp    $0x20,%eax
80100adb:	75 7b                	jne    80100b58 <exec+0x168>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100add:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ae4:	75 ca                	jne    80100ab0 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100ae6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aec:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100af2:	72 64                	jb     80100b58 <exec+0x168>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100af4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100afa:	72 5c                	jb     80100b58 <exec+0x168>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100afc:	83 ec 04             	sub    $0x4,%esp
80100aff:	50                   	push   %eax
80100b00:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b06:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b0c:	e8 7f 6a 00 00       	call   80107590 <allocuvm>
80100b11:	83 c4 10             	add    $0x10,%esp
80100b14:	85 c0                	test   %eax,%eax
80100b16:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b1c:	74 3a                	je     80100b58 <exec+0x168>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b1e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b24:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b29:	75 2d                	jne    80100b58 <exec+0x168>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b2b:	83 ec 0c             	sub    $0xc,%esp
80100b2e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b34:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b3a:	53                   	push   %ebx
80100b3b:	50                   	push   %eax
80100b3c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b42:	e8 89 69 00 00       	call   801074d0 <loaduvm>
80100b47:	83 c4 20             	add    $0x20,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 89 5e ff ff ff    	jns    80100ab0 <exec+0xc0>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b58:	83 ec 0c             	sub    $0xc,%esp
80100b5b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b61:	e8 5a 6b 00 00       	call   801076c0 <freevm>
80100b66:	83 c4 10             	add    $0x10,%esp
80100b69:	e9 da fe ff ff       	jmp    80100a48 <exec+0x58>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b6e:	83 ec 0c             	sub    $0xc,%esp
80100b71:	53                   	push   %ebx
80100b72:	e8 99 0e 00 00       	call   80101a10 <iunlockput>
  end_op();
80100b77:	e8 f4 28 00 00       	call   80103470 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b82:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b85:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b8f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b95:	52                   	push   %edx
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b9d:	e8 ee 69 00 00       	call   80107590 <allocuvm>
80100ba2:	83 c4 10             	add    $0x10,%esp
80100ba5:	85 c0                	test   %eax,%eax
80100ba7:	89 c6                	mov    %eax,%esi
80100ba9:	75 3a                	jne    80100be5 <exec+0x1f5>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bab:	83 ec 0c             	sub    $0xc,%esp
80100bae:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bb4:	e8 07 6b 00 00       	call   801076c0 <freevm>
80100bb9:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc1:	e9 98 fe ff ff       	jmp    80100a5e <exec+0x6e>
  struct proc *curproc = myproc();
  
  begin_op();

  if((ip = namei(path,0)) == 0){
    end_op();
80100bc6:	e8 a5 28 00 00       	call   80103470 <end_op>
    cprintf("exec: fail\n");
80100bcb:	83 ec 0c             	sub    $0xc,%esp
80100bce:	68 61 7a 10 80       	push   $0x80107a61
80100bd3:	e8 88 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd8:	83 c4 10             	add    $0x10,%esp
80100bdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be0:	e9 79 fe ff ff       	jmp    80100a5e <exec+0x6e>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100be5:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100beb:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bee:	31 ff                	xor    %edi,%edi
80100bf0:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	50                   	push   %eax
80100bf3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf9:	e8 e2 6b 00 00       	call   801077e0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c01:	83 c4 10             	add    $0x10,%esp
80100c04:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c0a:	8b 00                	mov    (%eax),%eax
80100c0c:	85 c0                	test   %eax,%eax
80100c0e:	74 6d                	je     80100c7d <exec+0x28d>
80100c10:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c16:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c1c:	eb 07                	jmp    80100c25 <exec+0x235>
80100c1e:	66 90                	xchg   %ax,%ax
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	74 86                	je     80100bab <exec+0x1bb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c25:	83 ec 0c             	sub    $0xc,%esp
80100c28:	50                   	push   %eax
80100c29:	e8 d2 42 00 00       	call   80104f00 <strlen>
80100c2e:	f7 d0                	not    %eax
80100c30:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c32:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c35:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c36:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c39:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c3c:	e8 bf 42 00 00       	call   80104f00 <strlen>
80100c41:	83 c0 01             	add    $0x1,%eax
80100c44:	50                   	push   %eax
80100c45:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c48:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4b:	53                   	push   %ebx
80100c4c:	56                   	push   %esi
80100c4d:	e8 ee 6c 00 00       	call   80107940 <copyout>
80100c52:	83 c4 20             	add    $0x20,%esp
80100c55:	85 c0                	test   %eax,%eax
80100c57:	0f 88 4e ff ff ff    	js     80100bab <exec+0x1bb>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c60:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c67:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c70:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c73:	85 c0                	test   %eax,%eax
80100c75:	75 a9                	jne    80100c20 <exec+0x230>
80100c77:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c84:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c86:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c8d:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  ustack[1] = argc;
80100c9b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca1:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca3:	83 c0 0c             	add    $0xc,%eax
80100ca6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca8:	50                   	push   %eax
80100ca9:	52                   	push   %edx
80100caa:	53                   	push   %ebx
80100cab:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb7:	e8 84 6c 00 00       	call   80107940 <copyout>
80100cbc:	83 c4 10             	add    $0x10,%esp
80100cbf:	85 c0                	test   %eax,%eax
80100cc1:	0f 88 e4 fe ff ff    	js     80100bab <exec+0x1bb>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cca:	0f b6 10             	movzbl (%eax),%edx
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	74 19                	je     80100cea <exec+0x2fa>
80100cd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd4:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cd7:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cda:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cdd:	0f 44 c8             	cmove  %eax,%ecx
80100ce0:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce3:	84 d2                	test   %dl,%dl
80100ce5:	75 f0                	jne    80100cd7 <exec+0x2e7>
80100ce7:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cea:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf0:	50                   	push   %eax
80100cf1:	6a 10                	push   $0x10
80100cf3:	ff 75 08             	pushl  0x8(%ebp)
80100cf6:	89 f8                	mov    %edi,%eax
80100cf8:	83 c0 6c             	add    $0x6c,%eax
80100cfb:	50                   	push   %eax
80100cfc:	e8 bf 41 00 00       	call   80104ec0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d01:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d07:	89 f8                	mov    %edi,%eax
80100d09:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d0c:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d0e:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d11:	89 c1                	mov    %eax,%ecx
80100d13:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d19:	8b 40 18             	mov    0x18(%eax),%eax
80100d1c:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d1f:	8b 41 18             	mov    0x18(%ecx),%eax
80100d22:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d25:	89 0c 24             	mov    %ecx,(%esp)
80100d28:	e8 13 66 00 00       	call   80107340 <switchuvm>
  freevm(oldpgdir);
80100d2d:	89 3c 24             	mov    %edi,(%esp)
80100d30:	e8 8b 69 00 00       	call   801076c0 <freevm>
  return 0;
80100d35:	83 c4 10             	add    $0x10,%esp
80100d38:	31 c0                	xor    %eax,%eax
80100d3a:	e9 1f fd ff ff       	jmp    80100a5e <exec+0x6e>
80100d3f:	90                   	nop

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	68 6d 7a 10 80       	push   $0x80107a6d
80100d4b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d50:	e8 fb 3c 00 00       	call   80104a50 <initlock>
}
80100d55:	83 c4 10             	add    $0x10,%esp
80100d58:	c9                   	leave  
80100d59:	c3                   	ret    
80100d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	68 c0 0f 11 80       	push   $0x80110fc0
80100d71:	e8 da 3d 00 00       	call   80104b50 <acquire>
80100d76:	83 c4 10             	add    $0x10,%esp
80100d79:	eb 10                	jmp    80100d8b <filealloc+0x2b>
80100d7b:	90                   	nop
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100d89:	74 25                	je     80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d9c:	68 c0 0f 11 80       	push   $0x80110fc0
80100da1:	e8 ca 3e 00 00       	call   80104c70 <release>
      return f;
80100da6:	89 d8                	mov    %ebx,%eax
80100da8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dae:	c9                   	leave  
80100daf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db0:	83 ec 0c             	sub    $0xc,%esp
80100db3:	68 c0 0f 11 80       	push   $0x80110fc0
80100db8:	e8 b3 3e 00 00       	call   80104c70 <release>
  return 0;
80100dbd:	83 c4 10             	add    $0x10,%esp
80100dc0:	31 c0                	xor    %eax,%eax
}
80100dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc5:	c9                   	leave  
80100dc6:	c3                   	ret    
80100dc7:	89 f6                	mov    %esi,%esi
80100dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 10             	sub    $0x10,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	68 c0 0f 11 80       	push   $0x80110fc0
80100ddf:	e8 6c 3d 00 00       	call   80104b50 <acquire>
  if(f->ref < 1)
80100de4:	8b 43 04             	mov    0x4(%ebx),%eax
80100de7:	83 c4 10             	add    $0x10,%esp
80100dea:	85 c0                	test   %eax,%eax
80100dec:	7e 1a                	jle    80100e08 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100df1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100df4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df7:	68 c0 0f 11 80       	push   $0x80110fc0
80100dfc:	e8 6f 3e 00 00       	call   80104c70 <release>
  return f;
}
80100e01:	89 d8                	mov    %ebx,%eax
80100e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e06:	c9                   	leave  
80100e07:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e08:	83 ec 0c             	sub    $0xc,%esp
80100e0b:	68 74 7a 10 80       	push   $0x80107a74
80100e10:	e8 5b f5 ff ff       	call   80100370 <panic>
80100e15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 28             	sub    $0x28,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e31:	e8 1a 3d 00 00       	call   80104b50 <acquire>
  if(f->ref < 1)
80100e36:	8b 47 04             	mov    0x4(%edi),%eax
80100e39:	83 c4 10             	add    $0x10,%esp
80100e3c:	85 c0                	test   %eax,%eax
80100e3e:	0f 8e 9b 00 00 00    	jle    80100edf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e44:	83 e8 01             	sub    $0x1,%eax
80100e47:	85 c0                	test   %eax,%eax
80100e49:	89 47 04             	mov    %eax,0x4(%edi)
80100e4c:	74 1a                	je     80100e68 <fileclose+0x48>
    release(&ftable.lock);
80100e4e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e58:	5b                   	pop    %ebx
80100e59:	5e                   	pop    %esi
80100e5a:	5f                   	pop    %edi
80100e5b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e5c:	e9 0f 3e 00 00       	jmp    80104c70 <release>
80100e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e68:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e6c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e6e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e71:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e74:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e7d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e80:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e88:	e8 e3 3d 00 00       	call   80104c70 <release>

  if(ff.type == FD_PIPE)
80100e8d:	83 c4 10             	add    $0x10,%esp
80100e90:	83 fb 01             	cmp    $0x1,%ebx
80100e93:	74 13                	je     80100ea8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e95:	83 fb 02             	cmp    $0x2,%ebx
80100e98:	74 26                	je     80100ec0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e9d:	5b                   	pop    %ebx
80100e9e:	5e                   	pop    %esi
80100e9f:	5f                   	pop    %edi
80100ea0:	5d                   	pop    %ebp
80100ea1:	c3                   	ret    
80100ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eac:	83 ec 08             	sub    $0x8,%esp
80100eaf:	53                   	push   %ebx
80100eb0:	56                   	push   %esi
80100eb1:	e8 ea 2c 00 00       	call   80103ba0 <pipeclose>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb df                	jmp    80100e9a <fileclose+0x7a>
80100ebb:	90                   	nop
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 3b 25 00 00       	call   80103400 <begin_op>
    iput(ff.ip);
80100ec5:	83 ec 0c             	sub    $0xc,%esp
80100ec8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ecb:	e8 e0 09 00 00       	call   801018b0 <iput>
    end_op();
80100ed0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed6:	5b                   	pop    %ebx
80100ed7:	5e                   	pop    %esi
80100ed8:	5f                   	pop    %edi
80100ed9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eda:	e9 91 25 00 00       	jmp    80103470 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	68 7c 7a 10 80       	push   $0x80107a7c
80100ee7:	e8 84 f4 ff ff       	call   80100370 <panic>
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 04             	sub    $0x4,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	ff 73 10             	pushl  0x10(%ebx)
80100f05:	e8 76 08 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100f0a:	58                   	pop    %eax
80100f0b:	5a                   	pop    %edx
80100f0c:	ff 75 0c             	pushl  0xc(%ebp)
80100f0f:	ff 73 10             	pushl  0x10(%ebx)
80100f12:	e8 19 0b 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100f17:	59                   	pop    %ecx
80100f18:	ff 73 10             	pushl  0x10(%ebx)
80100f1b:	e8 40 09 00 00       	call   80101860 <iunlock>
    return 0;
80100f20:	83 c4 10             	add    $0x10,%esp
80100f23:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 0c             	sub    $0xc,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 60                	je     80100fb8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 41                	je     80100fa0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 5b                	jne    80100fbf <fileread+0x7f>
    ilock(f->ip);
80100f64:	83 ec 0c             	sub    $0xc,%esp
80100f67:	ff 73 10             	pushl  0x10(%ebx)
80100f6a:	e8 11 08 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	57                   	push   %edi
80100f70:	ff 73 14             	pushl  0x14(%ebx)
80100f73:	56                   	push   %esi
80100f74:	ff 73 10             	pushl  0x10(%ebx)
80100f77:	e8 e4 0a 00 00       	call   80101a60 <readi>
80100f7c:	83 c4 20             	add    $0x20,%esp
80100f7f:	85 c0                	test   %eax,%eax
80100f81:	89 c6                	mov    %eax,%esi
80100f83:	7e 03                	jle    80100f88 <fileread+0x48>
      f->off += r;
80100f85:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	ff 73 10             	pushl  0x10(%ebx)
80100f8e:	e8 cd 08 00 00       	call   80101860 <iunlock>
    return r;
80100f93:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f96:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9b:	5b                   	pop    %ebx
80100f9c:	5e                   	pop    %esi
80100f9d:	5f                   	pop    %edi
80100f9e:	5d                   	pop    %ebp
80100f9f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fa3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa9:	5b                   	pop    %ebx
80100faa:	5e                   	pop    %esi
80100fab:	5f                   	pop    %edi
80100fac:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fad:	e9 8e 2d 00 00       	jmp    80103d40 <piperead>
80100fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fbd:	eb d9                	jmp    80100f98 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	68 86 7a 10 80       	push   $0x80107a86
80100fc7:	e8 a4 f3 ff ff       	call   80100370 <panic>
80100fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 1c             	sub    $0x1c,%esp
80100fd9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fdf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fec:	0f 84 aa 00 00 00    	je     8010109c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 06                	mov    (%esi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 d8 00 00 00    	jne    801010de <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 ff                	xor    %edi,%edi
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 34                	jg     80101043 <filewrite+0x73>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101018:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010101b:	83 ec 0c             	sub    $0xc,%esp
8010101e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101021:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101024:	e8 37 08 00 00       	call   80101860 <iunlock>
      end_op();
80101029:	e8 42 24 00 00       	call   80103470 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101031:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101034:	39 d8                	cmp    %ebx,%eax
80101036:	0f 85 95 00 00 00    	jne    801010d1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010103c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010103e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101041:	7e 6d                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101043:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101046:	b8 00 06 00 00       	mov    $0x600,%eax
8010104b:	29 fb                	sub    %edi,%ebx
8010104d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101053:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101056:	e8 a5 23 00 00       	call   80103400 <begin_op>
      ilock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
80101061:	e8 1a 07 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101066:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101069:	53                   	push   %ebx
8010106a:	ff 76 14             	pushl  0x14(%esi)
8010106d:	01 f8                	add    %edi,%eax
8010106f:	50                   	push   %eax
80101070:	ff 76 10             	pushl  0x10(%esi)
80101073:	e8 e8 0a 00 00       	call   80101b60 <writei>
80101078:	83 c4 20             	add    $0x20,%esp
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 99                	jg     80101018 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	ff 76 10             	pushl  0x10(%esi)
80101085:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101088:	e8 d3 07 00 00       	call   80101860 <iunlock>
      end_op();
8010108d:	e8 de 23 00 00       	call   80103470 <end_op>

      if(r < 0)
80101092:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101095:	83 c4 10             	add    $0x10,%esp
80101098:	85 c0                	test   %eax,%eax
8010109a:	74 98                	je     80101034 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010109c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010109f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010a4:	5b                   	pop    %ebx
801010a5:	5e                   	pop    %esi
801010a6:	5f                   	pop    %edi
801010a7:	5d                   	pop    %ebp
801010a8:	c3                   	ret    
801010a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010b0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010b3:	75 e7                	jne    8010109c <filewrite+0xcc>
  }
  panic("filewrite");
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	89 f8                	mov    %edi,%eax
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 46 0c             	mov    0xc(%esi),%eax
801010c2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cc:	e9 6f 2b 00 00       	jmp    80103c40 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	68 8f 7a 10 80       	push   $0x80107a8f
801010d9:	e8 92 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010de:	83 ec 0c             	sub    $0xc,%esp
801010e1:	68 95 7a 10 80       	push   $0x80107a95
801010e6:	e8 85 f2 ff ff       	call   80100370 <panic>
801010eb:	66 90                	xchg   %ax,%ax
801010ed:	66 90                	xchg   %ax,%ax
801010ef:	90                   	nop

801010f0 <balloc>:
// Blocks.
//int count = 0;
// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;
  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010f9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.
//int count = 0;
// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;
  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101102:	85 c9                	test   %ecx,%ecx
80101104:	0f 84 85 00 00 00    	je     8010118f <balloc+0x9f>
8010110a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101111:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101114:	83 ec 08             	sub    $0x8,%esp
80101117:	89 f0                	mov    %esi,%eax
80101119:	c1 f8 0c             	sar    $0xc,%eax
8010111c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101122:	50                   	push   %eax
80101123:	ff 75 d8             	pushl  -0x28(%ebp)
80101126:	e8 a5 ef ff ff       	call   801000d0 <bread>
8010112b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010112e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101133:	83 c4 10             	add    $0x10,%esp
80101136:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){ //iterate on bits (??)
80101139:	31 c0                	xor    %eax,%eax
8010113b:	eb 2d                	jmp    8010116a <balloc+0x7a>
8010113d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101140:	89 c1                	mov    %eax,%ecx
80101142:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101147:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  struct buf *bp;
  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){ //iterate on bits (??)
      m = 1 << (bi % 8);
8010114a:	83 e1 07             	and    $0x7,%ecx
8010114d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010114f:	89 c1                	mov    %eax,%ecx
80101151:	c1 f9 03             	sar    $0x3,%ecx
80101154:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101159:	85 d7                	test   %edx,%edi
8010115b:	74 43                	je     801011a0 <balloc+0xb0>
  int b, bi, m;
  struct buf *bp;
  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){ //iterate on bits (??)
8010115d:	83 c0 01             	add    $0x1,%eax
80101160:	83 c6 01             	add    $0x1,%esi
80101163:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101168:	74 05                	je     8010116f <balloc+0x7f>
8010116a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010116d:	72 d1                	jb     80101140 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	ff 75 e4             	pushl  -0x1c(%ebp)
80101175:	e8 66 f0 ff ff       	call   801001e0 <brelse>
balloc(uint dev)
{
  int b, bi, m;
  struct buf *bp;
  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101181:	83 c4 10             	add    $0x10,%esp
80101184:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101187:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010118d:	77 82                	ja     80101111 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	68 9f 7a 10 80       	push   $0x80107a9f
80101197:	e8 d4 f1 ff ff       	call   80100370 <panic>
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){ //iterate on bits (??)
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a0:	09 fa                	or     %edi,%edx
801011a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011a5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){ //iterate on bits (??)
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011ac:	57                   	push   %edi
801011ad:	e8 2e 24 00 00       	call   801035e0 <log_write>
        brelse(bp);
801011b2:	89 3c 24             	mov    %edi,(%esp)
801011b5:	e8 26 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ba:	58                   	pop    %eax
801011bb:	5a                   	pop    %edx
801011bc:	56                   	push   %esi
801011bd:	ff 75 d8             	pushl  -0x28(%ebp)
801011c0:	e8 0b ef ff ff       	call   801000d0 <bread>
801011c5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ca:	83 c4 0c             	add    $0xc,%esp
801011cd:	68 00 02 00 00       	push   $0x200
801011d2:	6a 00                	push   $0x0
801011d4:	50                   	push   %eax
801011d5:	e8 e6 3a 00 00       	call   80104cc0 <memset>
  log_write(bp);
801011da:	89 1c 24             	mov    %ebx,(%esp)
801011dd:	e8 fe 23 00 00       	call   801035e0 <log_write>
  brelse(bp);
801011e2:	89 1c 24             	mov    %ebx,(%esp)
801011e5:	e8 f6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ed:	89 f0                	mov    %esi,%eax
801011ef:	5b                   	pop    %ebx
801011f0:	5e                   	pop    %esi
801011f1:	5f                   	pop    %edi
801011f2:	5d                   	pop    %ebp
801011f3:	c3                   	ret    
801011f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101200 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101208:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010120f:	83 ec 28             	sub    $0x28,%esp
80101212:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101215:	68 e0 19 11 80       	push   $0x801119e0
8010121a:	e8 31 39 00 00       	call   80104b50 <acquire>
8010121f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101222:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101225:	eb 1b                	jmp    80101242 <iget+0x42>
80101227:	89 f6                	mov    %esi,%esi
80101229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101230:	85 f6                	test   %esi,%esi
80101232:	74 44                	je     80101278 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101234:	81 c3 98 00 00 00    	add    $0x98,%ebx
8010123a:	81 fb c4 37 11 80    	cmp    $0x801137c4,%ebx
80101240:	74 4e                	je     80101290 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101242:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101245:	85 c9                	test   %ecx,%ecx
80101247:	7e e7                	jle    80101230 <iget+0x30>
80101249:	39 3b                	cmp    %edi,(%ebx)
8010124b:	75 e3                	jne    80101230 <iget+0x30>
8010124d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101250:	75 de                	jne    80101230 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101252:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101255:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101258:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010125a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010125f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101262:	e8 09 3a 00 00       	call   80104c70 <release>
      return ip;
80101267:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101278:	85 c9                	test   %ecx,%ecx
8010127a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127d:	81 c3 98 00 00 00    	add    $0x98,%ebx
80101283:	81 fb c4 37 11 80    	cmp    $0x801137c4,%ebx
80101289:	75 b7                	jne    80101242 <iget+0x42>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 2d                	je     801012c1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101294:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101297:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101299:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010129c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012aa:	68 e0 19 11 80       	push   $0x801119e0
801012af:	e8 bc 39 00 00       	call   80104c70 <release>

  return ip;
801012b4:	83 c4 10             	add    $0x10,%esp
}
801012b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ba:	89 f0                	mov    %esi,%eax
801012bc:	5b                   	pop    %ebx
801012bd:	5e                   	pop    %esi
801012be:	5f                   	pop    %edi
801012bf:	5d                   	pop    %ebp
801012c0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	68 b5 7a 10 80       	push   $0x80107ab5
801012c9:	e8 a2 f0 ff ff       	call   80100370 <panic>
801012ce:	66 90                	xchg   %ax,%ax

801012d0 <bmap>:

//12 direct, 1 indirect, 1 double-indirect
//bn can be from 0-11 (direct), 12-139(indirect), or 140-??? double-indirect
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c6                	mov    %eax,%esi
801012d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  short entry, offset;
  struct buf *bp;
  
  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	77 20                	ja     80101300 <bmap+0x30>
801012e0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012e3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	0f 84 f2 00 00 00    	je     801013e0 <bmap+0x110>
    return addr;
  }


  panic("bmap: out of range");
}
801012ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f1:	5b                   	pop    %ebx
801012f2:	5e                   	pop    %esi
801012f3:	5f                   	pop    %edi
801012f4:	5d                   	pop    %ebp
801012f5:	c3                   	ret    
801012f6:	8d 76 00             	lea    0x0(%esi),%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev); // possibly just now allocating because we save space by allocating only when asked for
    return addr;
  }
  bn -= NDIRECT;
80101300:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101303:	83 fb 7f             	cmp    $0x7f,%ebx
80101306:	0f 86 8c 00 00 00    	jbe    80101398 <bmap+0xc8>
    }
    brelse(bp);
    return addr;
  }

  bn -= NINDIRECT;
8010130c:	8d 9a 74 ff ff ff    	lea    -0x8c(%edx),%ebx

  // double indirect
  if(bn < NDOUBLE_INDIRECT){
80101312:	81 fb ff 3f 00 00    	cmp    $0x3fff,%ebx
80101318:	0f 87 84 01 00 00    	ja     801014a2 <bmap+0x1d2>
    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT + 1]) == 0) //now addrs is a block of addresses - each one of them is supposed to (eventually) be also a block of addresses. 
8010131e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80101324:	85 c0                	test   %eax,%eax
80101326:	0f 84 64 01 00 00    	je     80101490 <bmap+0x1c0>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    
    // get the double indirect table, first level
    bp = bread(ip->dev, addr);
8010132c:	83 ec 08             	sub    $0x8,%esp
    a = (uint*)bp->data;
    
    // calculate the entry number and the index
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
8010132f:	89 df                	mov    %ebx,%edi
    
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
80101331:	c1 eb 07             	shr    $0x7,%ebx
    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT + 1]) == 0) //now addrs is a block of addresses - each one of them is supposed to (eventually) be also a block of addresses. 
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    
    // get the double indirect table, first level
    bp = bread(ip->dev, addr);
80101334:	50                   	push   %eax
80101335:	ff 36                	pushl  (%esi)
    a = (uint*)bp->data;
    
    // calculate the entry number and the index
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
80101337:	83 e7 7f             	and    $0x7f,%edi
    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT + 1]) == 0) //now addrs is a block of addresses - each one of them is supposed to (eventually) be also a block of addresses. 
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    
    // get the double indirect table, first level
    bp = bread(ip->dev, addr);
8010133a:	e8 91 ed ff ff       	call   801000d0 <bread>
    // calculate the entry number and the index
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
    
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
8010133f:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
80101343:	83 c4 10             	add    $0x10,%esp
    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT + 1]) == 0) //now addrs is a block of addresses - each one of them is supposed to (eventually) be also a block of addresses. 
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    
    // get the double indirect table, first level
    bp = bread(ip->dev, addr);
80101346:	89 c1                	mov    %eax,%ecx
    // calculate the entry number and the index
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
    
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
80101348:	8b 1a                	mov    (%edx),%ebx
8010134a:	85 db                	test   %ebx,%ebx
8010134c:	0f 84 0e 01 00 00    	je     80101460 <bmap+0x190>
      a[entry] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101352:	83 ec 0c             	sub    $0xc,%esp
    // get the double indirect table, second level
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;

    // if the offset doesnt exist, assign a block to this entry
    if((addr = a[offset]) == 0){
80101355:	0f bf ff             	movswl %di,%edi
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
      a[entry] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101358:	51                   	push   %ecx
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>

    // get the double indirect table, second level
    bp = bread(ip->dev, addr);
8010135e:	58                   	pop    %eax
8010135f:	5a                   	pop    %edx
80101360:	53                   	push   %ebx
80101361:	ff 36                	pushl  (%esi)
80101363:	e8 68 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;

    // if the offset doesnt exist, assign a block to this entry
    if((addr = a[offset]) == 0){
80101368:	8d 7c b8 5c          	lea    0x5c(%eax,%edi,4),%edi
8010136c:	83 c4 10             	add    $0x10,%esp
      log_write(bp);
    }
    brelse(bp);

    // get the double indirect table, second level
    bp = bread(ip->dev, addr);
8010136f:	89 c2                	mov    %eax,%edx
    a = (uint*)bp->data;

    // if the offset doesnt exist, assign a block to this entry
    if((addr = a[offset]) == 0){
80101371:	8b 1f                	mov    (%edi),%ebx
80101373:	85 db                	test   %ebx,%ebx
80101375:	0f 84 a5 00 00 00    	je     80101420 <bmap+0x150>
      a[offset] = addr = balloc(ip->dev);
      log_write(bp);
    }

    brelse(bp);
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	52                   	push   %edx
8010137f:	e8 5c ee ff ff       	call   801001e0 <brelse>
80101384:	83 c4 10             	add    $0x10,%esp
    return addr;
  }


  panic("bmap: out of range");
}
80101387:	8d 65 f4             	lea    -0xc(%ebp),%esp
      a[offset] = addr = balloc(ip->dev);
      log_write(bp);
    }

    brelse(bp);
    return addr;
8010138a:	89 d8                	mov    %ebx,%eax
  }


  panic("bmap: out of range");
}
8010138c:	5b                   	pop    %ebx
8010138d:	5e                   	pop    %esi
8010138e:	5f                   	pop    %edi
8010138f:	5d                   	pop    %ebp
80101390:	c3                   	ret    
80101391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101398:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010139e:	85 c0                	test   %eax,%eax
801013a0:	0f 84 a2 00 00 00    	je     80101448 <bmap+0x178>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr); //get a block of addresses. bread returns a struct buf*, which is the block. 'data' field is the char[]. 
801013a6:	83 ec 08             	sub    $0x8,%esp
801013a9:	50                   	push   %eax
801013aa:	ff 36                	pushl  (%esi)
801013ac:	e8 1f ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data; //treat the data as blocks size 4. a points to the data
    if((addr = a[bn]) == 0){
801013b1:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013b5:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr); //get a block of addresses. bread returns a struct buf*, which is the block. 'data' field is the char[]. 
801013b8:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data; //treat the data as blocks size 4. a points to the data
    if((addr = a[bn]) == 0){
801013ba:	8b 1a                	mov    (%edx),%ebx
801013bc:	85 db                	test   %ebx,%ebx
801013be:	74 38                	je     801013f8 <bmap+0x128>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013c0:	83 ec 0c             	sub    $0xc,%esp
801013c3:	57                   	push   %edi
801013c4:	e8 17 ee ff ff       	call   801001e0 <brelse>
801013c9:	83 c4 10             	add    $0x10,%esp
    return addr;
  }


  panic("bmap: out of range");
}
801013cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    return addr;
801013cf:	89 d8                	mov    %ebx,%eax
    return addr;
  }


  panic("bmap: out of range");
}
801013d1:	5b                   	pop    %ebx
801013d2:	5e                   	pop    %esi
801013d3:	5f                   	pop    %edi
801013d4:	5d                   	pop    %ebp
801013d5:	c3                   	ret    
801013d6:	8d 76 00             	lea    0x0(%esi),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  short entry, offset;
  struct buf *bp;
  
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev); // possibly just now allocating because we save space by allocating only when asked for
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	e8 09 fd ff ff       	call   801010f0 <balloc>
801013e7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    return addr;
  }


  panic("bmap: out of range");
}
801013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr); //get a block of addresses. bread returns a struct buf*, which is the block. 'data' field is the char[]. 
    a = (uint*)bp->data; //treat the data as blocks size 4. a points to the data
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013f8:	8b 06                	mov    (%esi),%eax
801013fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013fd:	e8 ee fc ff ff       	call   801010f0 <balloc>
80101402:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101405:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr); //get a block of addresses. bread returns a struct buf*, which is the block. 'data' field is the char[]. 
    a = (uint*)bp->data; //treat the data as blocks size 4. a points to the data
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101408:	89 c3                	mov    %eax,%ebx
8010140a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010140c:	57                   	push   %edi
8010140d:	e8 ce 21 00 00       	call   801035e0 <log_write>
80101412:	83 c4 10             	add    $0x10,%esp
80101415:	eb a9                	jmp    801013c0 <bmap+0xf0>
80101417:	89 f6                	mov    %esi,%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;

    // if the offset doesnt exist, assign a block to this entry
    if((addr = a[offset]) == 0){
      a[offset] = addr = balloc(ip->dev);
80101423:	8b 06                	mov    (%esi),%eax
80101425:	e8 c6 fc ff ff       	call   801010f0 <balloc>
      log_write(bp);
8010142a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010142d:	83 ec 0c             	sub    $0xc,%esp
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;

    // if the offset doesnt exist, assign a block to this entry
    if((addr = a[offset]) == 0){
      a[offset] = addr = balloc(ip->dev);
80101430:	89 07                	mov    %eax,(%edi)
80101432:	89 c3                	mov    %eax,%ebx
      log_write(bp);
80101434:	52                   	push   %edx
80101435:	e8 a6 21 00 00       	call   801035e0 <log_write>
8010143a:	83 c4 10             	add    $0x10,%esp
8010143d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101440:	e9 36 ff ff ff       	jmp    8010137b <bmap+0xab>
80101445:	8d 76 00             	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101448:	8b 06                	mov    (%esi),%eax
8010144a:	e8 a1 fc ff ff       	call   801010f0 <balloc>
8010144f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101455:	e9 4c ff ff ff       	jmp    801013a6 <bmap+0xd6>
8010145a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
    
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
      a[entry] = addr = balloc(ip->dev);
80101463:	8b 06                	mov    (%esi),%eax
80101465:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101468:	e8 83 fc ff ff       	call   801010f0 <balloc>
      log_write(bp);
8010146d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
    
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
      a[entry] = addr = balloc(ip->dev);
80101470:	8b 55 e0             	mov    -0x20(%ebp),%edx
      log_write(bp);
80101473:	83 ec 0c             	sub    $0xc,%esp
    entry = bn / NDINDIRECT_PER_ENTRY;
    offset = bn % NDINDIRECT_PER_ENTRY;
    
    // load level B table, allocating if necessary
    if((addr = a[entry]) == 0){
      a[entry] = addr = balloc(ip->dev);
80101476:	89 c3                	mov    %eax,%ebx
80101478:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010147a:	51                   	push   %ecx
8010147b:	e8 60 21 00 00       	call   801035e0 <log_write>
80101480:	83 c4 10             	add    $0x10,%esp
80101483:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101486:	e9 c7 fe ff ff       	jmp    80101352 <bmap+0x82>
8010148b:	90                   	nop
8010148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // double indirect
  if(bn < NDOUBLE_INDIRECT){
    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT + 1]) == 0) //now addrs is a block of addresses - each one of them is supposed to (eventually) be also a block of addresses. 
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	e8 59 fc ff ff       	call   801010f0 <balloc>
80101497:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
8010149d:	e9 8a fe ff ff       	jmp    8010132c <bmap+0x5c>
    brelse(bp);
    return addr;
  }


  panic("bmap: out of range");
801014a2:	83 ec 0c             	sub    $0xc,%esp
801014a5:	68 c5 7a 10 80       	push   $0x80107ac5
801014aa:	e8 c1 ee ff ff       	call   80100370 <panic>
801014af:	90                   	nop

801014b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	56                   	push   %esi
801014b4:	53                   	push   %ebx
801014b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801014b8:	83 ec 08             	sub    $0x8,%esp
801014bb:	6a 01                	push   $0x1
801014bd:	ff 75 08             	pushl  0x8(%ebp)
801014c0:	e8 0b ec ff ff       	call   801000d0 <bread>
801014c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ca:	83 c4 0c             	add    $0xc,%esp
801014cd:	6a 1c                	push   $0x1c
801014cf:	50                   	push   %eax
801014d0:	56                   	push   %esi
801014d1:	e8 9a 38 00 00       	call   80104d70 <memmove>
  brelse(bp);
801014d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014d9:	83 c4 10             	add    $0x10,%esp
}
801014dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014df:	5b                   	pop    %ebx
801014e0:	5e                   	pop    %esi
801014e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801014e2:	e9 f9 ec ff ff       	jmp    801001e0 <brelse>
801014e7:	89 f6                	mov    %esi,%esi
801014e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	56                   	push   %esi
801014f4:	53                   	push   %ebx
801014f5:	89 d3                	mov    %edx,%ebx
801014f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801014f9:	83 ec 08             	sub    $0x8,%esp
801014fc:	68 c0 19 11 80       	push   $0x801119c0
80101501:	50                   	push   %eax
80101502:	e8 a9 ff ff ff       	call   801014b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101507:	58                   	pop    %eax
80101508:	5a                   	pop    %edx
80101509:	89 da                	mov    %ebx,%edx
8010150b:	c1 ea 0c             	shr    $0xc,%edx
8010150e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101514:	52                   	push   %edx
80101515:	56                   	push   %esi
80101516:	e8 b5 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010151b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010151d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101523:	ba 01 00 00 00       	mov    $0x1,%edx
80101528:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010152b:	c1 fb 03             	sar    $0x3,%ebx
8010152e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101531:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101533:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101538:	85 d1                	test   %edx,%ecx
8010153a:	74 27                	je     80101563 <bfree+0x73>
8010153c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010153e:	f7 d2                	not    %edx
80101540:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101542:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101545:	21 d0                	and    %edx,%eax
80101547:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010154b:	56                   	push   %esi
8010154c:	e8 8f 20 00 00       	call   801035e0 <log_write>
  brelse(bp);
80101551:	89 34 24             	mov    %esi,(%esp)
80101554:	e8 87 ec ff ff       	call   801001e0 <brelse>
}
80101559:	83 c4 10             	add    $0x10,%esp
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
80101562:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101563:	83 ec 0c             	sub    $0xc,%esp
80101566:	68 d8 7a 10 80       	push   $0x80107ad8
8010156b:	e8 00 ee ff ff       	call   80100370 <panic>

80101570 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010157c:	68 eb 7a 10 80       	push   $0x80107aeb
80101581:	68 e0 19 11 80       	push   $0x801119e0
80101586:	e8 c5 34 00 00       	call   80104a50 <initlock>
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 f2 7a 10 80       	push   $0x80107af2
80101598:	53                   	push   %ebx
80101599:	81 c3 98 00 00 00    	add    $0x98,%ebx
8010159f:	e8 9c 33 00 00       	call   80104940 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb d0 37 11 80    	cmp    $0x801137d0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	68 c0 19 11 80       	push   $0x801119c0
801015b7:	ff 75 08             	pushl  0x8(%ebp)
801015ba:	e8 f1 fe ff ff       	call   801014b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015bf:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015c5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015cb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015d1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015d7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015dd:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015e3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015e9:	68 5c 7b 10 80       	push   $0x80107b5c
801015ee:	e8 6d f0 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801015f3:	83 c4 30             	add    $0x30,%esp
801015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015f9:	c9                   	leave  
801015fa:	c3                   	ret    
801015fb:	90                   	nop
801015fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101600 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101609:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101610:	8b 45 0c             	mov    0xc(%ebp),%eax
80101613:	8b 75 08             	mov    0x8(%ebp),%esi
80101616:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101619:	0f 86 94 00 00 00    	jbe    801016b3 <ialloc+0xb3>
8010161f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101624:	eb 21                	jmp    80101647 <ialloc+0x47>
80101626:	8d 76 00             	lea    0x0(%esi),%esi
80101629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101630:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101633:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101636:	57                   	push   %edi
80101637:	e8 a4 eb ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 c4 10             	add    $0x10,%esp
8010163f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101645:	76 6c                	jbe    801016b3 <ialloc+0xb3>
    bp = bread(dev, IBLOCK(inum, sb));
80101647:	89 d8                	mov    %ebx,%eax
80101649:	83 ec 08             	sub    $0x8,%esp
8010164c:	c1 e8 02             	shr    $0x2,%eax
8010164f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101655:	50                   	push   %eax
80101656:	56                   	push   %esi
80101657:	e8 74 ea ff ff       	call   801000d0 <bread>
8010165c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010165e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101660:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101663:	83 e0 03             	and    $0x3,%eax
80101666:	c1 e0 07             	shl    $0x7,%eax
80101669:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010166d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101671:	75 bd                	jne    80101630 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101673:	83 ec 04             	sub    $0x4,%esp
80101676:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101679:	68 80 00 00 00       	push   $0x80
8010167e:	6a 00                	push   $0x0
80101680:	51                   	push   %ecx
80101681:	e8 3a 36 00 00       	call   80104cc0 <memset>
      dip->type = type;
80101686:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010168a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010168d:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101690:	89 3c 24             	mov    %edi,(%esp)
80101693:	e8 48 1f 00 00       	call   801035e0 <log_write>
      brelse(bp);
80101698:	89 3c 24             	mov    %edi,(%esp)
8010169b:	e8 40 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801016a0:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801016a6:	89 da                	mov    %ebx,%edx
801016a8:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016aa:	5b                   	pop    %ebx
801016ab:	5e                   	pop    %esi
801016ac:	5f                   	pop    %edi
801016ad:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801016ae:	e9 4d fb ff ff       	jmp    80101200 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016b3:	83 ec 0c             	sub    $0xc,%esp
801016b6:	68 f8 7a 10 80       	push   $0x80107af8
801016bb:	e8 b0 ec ff ff       	call   80100370 <panic>

801016c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c8:	83 ec 08             	sub    $0x8,%esp
801016cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  dip->tags = ip->tags;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d1:	c1 e8 02             	shr    $0x2,%eax
801016d4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016da:	50                   	push   %eax
801016db:	ff 73 a4             	pushl  -0x5c(%ebx)
801016de:	e8 ed e9 ff ff       	call   801000d0 <bread>
801016e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  dip->tags = ip->tags;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 03             	and    $0x3,%eax
801016f2:	c1 e0 07             	shl    $0x7,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  dip->tags = ip->tags;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101700:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101703:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101707:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010170b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010170f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101713:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101717:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010171a:	89 50 fc             	mov    %edx,-0x4(%eax)
  dip->tags = ip->tags;
8010171d:	8b 53 38             	mov    0x38(%ebx),%edx
80101720:	89 50 38             	mov    %edx,0x38(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101723:	6a 38                	push   $0x38
80101725:	53                   	push   %ebx
80101726:	50                   	push   %eax
80101727:	e8 44 36 00 00       	call   80104d70 <memmove>
  log_write(bp);
8010172c:	89 34 24             	mov    %esi,(%esp)
8010172f:	e8 ac 1e 00 00       	call   801035e0 <log_write>
  brelse(bp);
80101734:	89 75 08             	mov    %esi,0x8(%ebp)
80101737:	83 c4 10             	add    $0x10,%esp
}
8010173a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010173d:	5b                   	pop    %ebx
8010173e:	5e                   	pop    %esi
8010173f:	5d                   	pop    %ebp
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  dip->tags = ip->tags;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101740:	e9 9b ea ff ff       	jmp    801001e0 <brelse>
80101745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101750 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 e0 19 11 80       	push   $0x801119e0
8010175f:	e8 ec 33 00 00       	call   80104b50 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010176f:	e8 fc 34 00 00       	call   80104c70 <release>
  return ip;
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	90                   	nop
8010177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101780 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010179b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010179e:	83 ec 0c             	sub    $0xc,%esp
801017a1:	50                   	push   %eax
801017a2:	e8 d9 31 00 00       	call   80104980 <acquiresleep>

  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	90                   	nop
801017b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 02             	shr    $0x2,%eax
801017c9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	pushl  (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
801017d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017d9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017df:	83 e0 03             	and    $0x3,%eax
801017e2:	c1 e0 07             	shl    $0x7,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 38                	push   $0x38
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 53 35 00 00       	call   80104d70 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 bb e9 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 10 7b 10 80       	push   $0x80107b10
80101842:	e8 29 eb ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 0a 7b 10 80       	push   $0x80107b0a
8010184f:	e8 1c eb ff ff       	call   80100370 <panic>
80101854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010185a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101860 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010186f:	83 ec 0c             	sub    $0xc,%esp
80101872:	56                   	push   %esi
80101873:	e8 a8 31 00 00       	call   80104a20 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010188f:	e9 4c 31 00 00       	jmp    801049e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 1f 7b 10 80       	push   $0x80107b1f
8010189c:	e8 cf ea ff ff       	call   80100370 <panic>
801018a1:	eb 0d                	jmp    801018b0 <iput>
801018a3:	90                   	nop
801018a4:	90                   	nop
801018a5:	90                   	nop
801018a6:	90                   	nop
801018a7:	90                   	nop
801018a8:	90                   	nop
801018a9:	90                   	nop
801018aa:	90                   	nop
801018ab:	90                   	nop
801018ac:	90                   	nop
801018ad:	90                   	nop
801018ae:	90                   	nop
801018af:	90                   	nop

801018b0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801018bc:	8d 7e 0c             	lea    0xc(%esi),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 bb 30 00 00       	call   80104980 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 56 4c             	mov    0x4c(%esi),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801018d4:	74 32                	je     80101908 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 01 31 00 00       	call   801049e0 <releasesleep>

  acquire(&icache.lock);
801018df:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018e6:	e8 65 32 00 00       	call   80104b50 <acquire>
  ip->ref--;
801018eb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101900:	e9 6b 33 00 00       	jmp    80104c70 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 e0 19 11 80       	push   $0x801119e0
80101910:	e8 3b 32 00 00       	call   80104b50 <acquire>
    int r = ip->ref;
80101915:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101918:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010191f:	e8 4c 33 00 00       	call   80104c70 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fb 01             	cmp    $0x1,%ebx
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101940:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101943:	39 fb                	cmp    %edi,%ebx
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 13                	mov    (%ebx),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 06                	mov    (%esi),%eax
8010194f:	e8 9c fb ff ff       	call   801014f0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 33                	jne    801019a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101970:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101977:	56                   	push   %esi
80101978:	e8 43 fd ff ff       	call   801016c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101983:	89 34 24             	mov    %esi,(%esp)
80101986:	e8 35 fd ff ff       	call   801016c0 <iupdate>
      ip->valid = 0;
8010198b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
8010199a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019a0:	83 ec 08             	sub    $0x8,%esp
801019a3:	50                   	push   %eax
801019a4:	ff 36                	pushl  (%esi)
801019a6:	e8 25 e7 ff ff       	call   801000d0 <bread>
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801019b7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801019ba:	83 c4 10             	add    $0x10,%esp
801019bd:	89 cf                	mov    %ecx,%edi
801019bf:	eb 0e                	jmp    801019cf <iput+0x11f>
801019c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801019cb:	39 fb                	cmp    %edi,%ebx
801019cd:	74 0f                	je     801019de <iput+0x12e>
      if(a[j])
801019cf:	8b 13                	mov    (%ebx),%edx
801019d1:	85 d2                	test   %edx,%edx
801019d3:	74 f3                	je     801019c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801019d5:	8b 06                	mov    (%esi),%eax
801019d7:	e8 14 fb ff ff       	call   801014f0 <bfree>
801019dc:	eb ea                	jmp    801019c8 <iput+0x118>
    }
    brelse(bp);
801019de:	83 ec 0c             	sub    $0xc,%esp
801019e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e7:	e8 f4 e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ec:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801019f2:	8b 06                	mov    (%esi),%eax
801019f4:	e8 f7 fa ff ff       	call   801014f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101a00:	00 00 00 
80101a03:	83 c4 10             	add    $0x10,%esp
80101a06:	e9 62 ff ff ff       	jmp    8010196d <iput+0xbd>
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a10 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	53                   	push   %ebx
80101a14:	83 ec 10             	sub    $0x10,%esp
80101a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1a:	53                   	push   %ebx
80101a1b:	e8 40 fe ff ff       	call   80101860 <iunlock>
  iput(ip);
80101a20:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a23:	83 c4 10             	add    $0x10,%esp
}
80101a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a29:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101a2a:	e9 81 fe ff ff       	jmp    801018b0 <iput>
80101a2f:	90                   	nop

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	8b 55 08             	mov    0x8(%ebp),%edx
80101a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a39:	8b 0a                	mov    (%edx),%ecx
80101a3b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a3e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a41:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a44:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a48:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a4f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a53:	8b 52 58             	mov    0x58(%edx),%edx
80101a56:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a59:	5d                   	pop    %ebp
80101a5a:	c3                   	ret    
80101a5b:	90                   	nop
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a6f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a77:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a7a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a83:	0f 84 a7 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	8b 40 58             	mov    0x58(%eax),%eax
80101a8f:	39 f0                	cmp    %esi,%eax
80101a91:	0f 82 c1 00 00 00    	jb     80101b58 <readi+0xf8>
80101a97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a9a:	89 fa                	mov    %edi,%edx
80101a9c:	01 f2                	add    %esi,%edx
80101a9e:	0f 82 b4 00 00 00    	jb     80101b58 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aa4:	89 c1                	mov    %eax,%ecx
80101aa6:	29 f1                	sub    %esi,%ecx
80101aa8:	39 d0                	cmp    %edx,%eax
80101aaa:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aad:	31 ff                	xor    %edi,%edi
80101aaf:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101ab1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab4:	74 6d                	je     80101b23 <readi+0xc3>
80101ab6:	8d 76 00             	lea    0x0(%esi),%esi
80101ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 01 f8 ff ff       	call   801012d0 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ada:	e8 f1 e5 ff ff       	call   801000d0 <bread>
80101adf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ae4:	89 f1                	mov    %esi,%ecx
80101ae6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101aec:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101aef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	29 cb                	sub    %ecx,%ebx
80101af4:	29 f8                	sub    %edi,%eax
80101af6:	39 c3                	cmp    %eax,%ebx
80101af8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101aff:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b00:	01 df                	add    %ebx,%edi
80101b02:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101b04:	50                   	push   %eax
80101b05:	ff 75 e0             	pushl  -0x20(%ebp)
80101b08:	e8 63 32 00 00       	call   80104d70 <memmove>
    brelse(bp);
80101b0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b10:	89 14 24             	mov    %edx,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1b:	83 c4 10             	add    $0x10,%esp
80101b1e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b21:	77 9d                	ja     80101ac0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b29:	5b                   	pop    %ebx
80101b2a:	5e                   	pop    %esi
80101b2b:	5f                   	pop    %edi
80101b2c:	5d                   	pop    %ebp
80101b2d:	c3                   	ret    
80101b2e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 1e                	ja     80101b58 <readi+0xf8>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 13                	je     80101b58 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b5d:	eb c7                	jmp    80101b26 <readi+0xc6>
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	57                   	push   %edi
80101b64:	56                   	push   %esi
80101b65:	53                   	push   %ebx
80101b66:	83 ec 1c             	sub    $0x1c,%esp
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b83:	0f 84 b7 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b8f:	0f 82 eb 00 00 00    	jb     80101c80 <writei+0x120>
80101b95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b98:	89 f8                	mov    %edi,%eax
80101b9a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b9c:	3d 00 18 81 00       	cmp    $0x811800,%eax
80101ba1:	0f 87 d9 00 00 00    	ja     80101c80 <writei+0x120>
80101ba7:	39 c6                	cmp    %eax,%esi
80101ba9:	0f 87 d1 00 00 00    	ja     80101c80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101baf:	85 ff                	test   %edi,%edi
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	74 78                	je     80101c32 <writei+0xd2>
80101bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bca:	c1 ea 09             	shr    $0x9,%edx
80101bcd:	89 f8                	mov    %edi,%eax
80101bcf:	e8 fc f6 ff ff       	call   801012d0 <bmap>
80101bd4:	83 ec 08             	sub    $0x8,%esp
80101bd7:	50                   	push   %eax
80101bd8:	ff 37                	pushl  (%edi)
80101bda:	e8 f1 e4 ff ff       	call   801000d0 <bread>
80101bdf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101be4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101be7:	89 f1                	mov    %esi,%ecx
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101bf2:	29 cb                	sub    %ecx,%ebx
80101bf4:	39 c3                	cmp    %eax,%ebx
80101bf6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bf9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101bfd:	53                   	push   %ebx
80101bfe:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c01:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	50                   	push   %eax
80101c04:	e8 67 31 00 00       	call   80104d70 <memmove>
    log_write(bp);
80101c09:	89 3c 24             	mov    %edi,(%esp)
80101c0c:	e8 cf 19 00 00       	call   801035e0 <log_write>
    brelse(bp);
80101c11:	89 3c 24             	mov    %edi,(%esp)
80101c14:	e8 c7 e5 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c1f:	83 c4 10             	add    $0x10,%esp
80101c22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c25:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101c28:	77 96                	ja     80101bc0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101c2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2d:	3b 70 58             	cmp    0x58(%eax),%esi
80101c30:	77 36                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c38:	5b                   	pop    %ebx
80101c39:	5e                   	pop    %esi
80101c3a:	5f                   	pop    %edi
80101c3b:	5d                   	pop    %ebp
80101c3c:	c3                   	ret    
80101c3d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 36                	ja     80101c80 <writei+0x120>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 2b                	je     80101c80 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 49 fa ff ff       	call   801016c0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b6                	jmp    80101c32 <writei+0xd2>
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c85:	eb ae                	jmp    80101c35 <writei+0xd5>
80101c87:	89 f6                	mov    %esi,%esi
80101c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c96:	6a 0e                	push   $0xe
80101c98:	ff 75 0c             	pushl  0xc(%ebp)
80101c9b:	ff 75 08             	pushl  0x8(%ebp)
80101c9e:	e8 4d 31 00 00       	call   80104df0 <strncmp>
}
80101ca3:	c9                   	leave  
80101ca4:	c3                   	ret    
80101ca5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	56                   	push   %esi
80101cb5:	53                   	push   %ebx
80101cb6:	83 ec 1c             	sub    $0x1c,%esp
80101cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc1:	0f 85 80 00 00 00    	jne    80101d47 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cca:	31 ff                	xor    %edi,%edi
80101ccc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ccf:	85 d2                	test   %edx,%edx
80101cd1:	75 0d                	jne    80101ce0 <dirlookup+0x30>
80101cd3:	eb 5b                	jmp    80101d30 <dirlookup+0x80>
80101cd5:	8d 76 00             	lea    0x0(%esi),%esi
80101cd8:	83 c7 10             	add    $0x10,%edi
80101cdb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101cde:	76 50                	jbe    80101d30 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 48                	jne    80101d3a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 df                	je     80101cd8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101cf9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cfc:	83 ec 04             	sub    $0x4,%esp
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 e6 30 00 00       	call   80104df0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	75 c7                	jne    80101cd8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101d11:	8b 45 10             	mov    0x10(%ebp),%eax
80101d14:	85 c0                	test   %eax,%eax
80101d16:	74 05                	je     80101d1d <dirlookup+0x6d>
        *poff = off;
80101d18:	8b 45 10             	mov    0x10(%ebp),%eax
80101d1b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101d1d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101d21:	8b 03                	mov    (%ebx),%eax
80101d23:	e8 d8 f4 ff ff       	call   80101200 <iget>
    }
  }

  return 0;
}
80101d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d2b:	5b                   	pop    %ebx
80101d2c:	5e                   	pop    %esi
80101d2d:	5f                   	pop    %edi
80101d2e:	5d                   	pop    %ebp
80101d2f:	c3                   	ret    
80101d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101d33:	31 c0                	xor    %eax,%eax
}
80101d35:	5b                   	pop    %ebx
80101d36:	5e                   	pop    %esi
80101d37:	5f                   	pop    %edi
80101d38:	5d                   	pop    %ebp
80101d39:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101d3a:	83 ec 0c             	sub    $0xc,%esp
80101d3d:	68 39 7b 10 80       	push   $0x80107b39
80101d42:	e8 29 e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 27 7b 10 80       	push   $0x80107b27
80101d4f:	e8 1c e6 ff ff       	call   80100370 <panic>
80101d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d60 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 20             	sub    $0x20,%esp
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101d6c:	6a 00                	push   $0x0
80101d6e:	ff 75 0c             	pushl  0xc(%ebp)
80101d71:	53                   	push   %ebx
80101d72:	e8 39 ff ff ff       	call   80101cb0 <dirlookup>
80101d77:	83 c4 10             	add    $0x10,%esp
80101d7a:	85 c0                	test   %eax,%eax
80101d7c:	75 67                	jne    80101de5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101d81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d84:	85 ff                	test   %edi,%edi
80101d86:	74 29                	je     80101db1 <dirlink+0x51>
80101d88:	31 ff                	xor    %edi,%edi
80101d8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d8d:	eb 09                	jmp    80101d98 <dirlink+0x38>
80101d8f:	90                   	nop
80101d90:	83 c7 10             	add    $0x10,%edi
80101d93:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101d96:	76 19                	jbe    80101db1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d98:	6a 10                	push   $0x10
80101d9a:	57                   	push   %edi
80101d9b:	56                   	push   %esi
80101d9c:	53                   	push   %ebx
80101d9d:	e8 be fc ff ff       	call   80101a60 <readi>
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	83 f8 10             	cmp    $0x10,%eax
80101da8:	75 4e                	jne    80101df8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101daa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101daf:	75 df                	jne    80101d90 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101db1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101db4:	83 ec 04             	sub    $0x4,%esp
80101db7:	6a 0e                	push   $0xe
80101db9:	ff 75 0c             	pushl  0xc(%ebp)
80101dbc:	50                   	push   %eax
80101dbd:	e8 9e 30 00 00       	call   80104e60 <strncpy>
  de.inum = inum;
80101dc2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dc5:	6a 10                	push   $0x10
80101dc7:	57                   	push   %edi
80101dc8:	56                   	push   %esi
80101dc9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101dca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dce:	e8 8d fd ff ff       	call   80101b60 <writei>
80101dd3:	83 c4 20             	add    $0x20,%esp
80101dd6:	83 f8 10             	cmp    $0x10,%eax
80101dd9:	75 2a                	jne    80101e05 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101ddb:	31 c0                	xor    %eax,%eax
}
80101ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de0:	5b                   	pop    %ebx
80101de1:	5e                   	pop    %esi
80101de2:	5f                   	pop    %edi
80101de3:	5d                   	pop    %ebp
80101de4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101de5:	83 ec 0c             	sub    $0xc,%esp
80101de8:	50                   	push   %eax
80101de9:	e8 c2 fa ff ff       	call   801018b0 <iput>
    return -1;
80101dee:	83 c4 10             	add    $0x10,%esp
80101df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101df6:	eb e5                	jmp    80101ddd <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101df8:	83 ec 0c             	sub    $0xc,%esp
80101dfb:	68 48 7b 10 80       	push   $0x80107b48
80101e00:	e8 6b e5 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e05:	83 ec 0c             	sub    $0xc,%esp
80101e08:	68 4f 81 10 80       	push   $0x8010814f
80101e0d:	e8 5e e5 ff ff       	call   80100370 <panic>
80101e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
struct inode*
namex(char *path, int nameiparent, char *name, uint l_counter, struct inode *last_pos, int noderef, char* pathbuffer, int* index, int pathbufsize)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
80101e2c:	8b 75 14             	mov    0x14(%ebp),%esi
80101e2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101e32:	8b 7d 18             	mov    0x18(%ebp),%edi
  struct inode *ip, *next;
  char buf[100], tname[DIRSIZ];
  struct proc* proc = myproc();
80101e35:	e8 f6 21 00 00       	call   80104030 <myproc>

  if (l_counter > MAX_DEREFERENCE) {
80101e3a:	83 fe 10             	cmp    $0x10,%esi
80101e3d:	0f 87 76 03 00 00    	ja     801021b9 <namex+0x399>
    return 0;  // probably infinite loop.
  }

  if(*path == '/'){
80101e43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e46:	0f 84 3c 03 00 00    	je     80102188 <namex+0x368>
    *index = 1;
    pathbuffer[0] = '/';
    pathbuffer[1] = '\0';
    ip = iget(ROOTDEV, ROOTINO);
  }
  else if (last_pos)
80101e4c:	85 ff                	test   %edi,%edi
80101e4e:	0f 84 5d 03 00 00    	je     801021b1 <namex+0x391>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101e54:	83 ec 0c             	sub    $0xc,%esp
80101e57:	68 e0 19 11 80       	push   $0x801119e0
80101e5c:	e8 ef 2c 00 00       	call   80104b50 <acquire>
  ip->ref++;
80101e61:	83 47 08 01          	addl   $0x1,0x8(%edi)
  release(&icache.lock);
80101e65:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101e6c:	e8 ff 2d 00 00       	call   80104c70 <release>
80101e71:	83 c4 10             	add    $0x10,%esp
        iput(ip);
        return 0;
      }
    buf[next->size] = 0; 
    iunlockput(next);
    next = namex(buf, 0, tname, l_counter+1, ip, 0, pathbuffer, index, pathbufsize);
80101e74:	8d 46 01             	lea    0x1(%esi),%eax
80101e77:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
80101e7d:	eb 04                	jmp    80101e83 <namex+0x63>
80101e7f:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101e80:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101e83:	0f b6 03             	movzbl (%ebx),%eax
80101e86:	3c 2f                	cmp    $0x2f,%al
80101e88:	74 f6                	je     80101e80 <namex+0x60>
    path++;
  if(*path == 0)
80101e8a:	84 c0                	test   %al,%al
80101e8c:	0f 84 88 02 00 00    	je     8010211a <namex+0x2fa>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e92:	0f b6 03             	movzbl (%ebx),%eax
80101e95:	89 de                	mov    %ebx,%esi
80101e97:	84 c0                	test   %al,%al
80101e99:	0f 84 45 02 00 00    	je     801020e4 <namex+0x2c4>
80101e9f:	3c 2f                	cmp    $0x2f,%al
80101ea1:	75 11                	jne    80101eb4 <namex+0x94>
80101ea3:	e9 3c 02 00 00       	jmp    801020e4 <namex+0x2c4>
80101ea8:	90                   	nop
80101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb0:	84 c0                	test   %al,%al
80101eb2:	74 0a                	je     80101ebe <namex+0x9e>
    path++;
80101eb4:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101eb7:	0f b6 06             	movzbl (%esi),%eax
80101eba:	3c 2f                	cmp    $0x2f,%al
80101ebc:	75 f2                	jne    80101eb0 <namex+0x90>
80101ebe:	89 f1                	mov    %esi,%ecx
80101ec0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ec2:	83 f9 0d             	cmp    $0xd,%ecx
80101ec5:	0f 8e 25 02 00 00    	jle    801020f0 <namex+0x2d0>
    memmove(name, s, DIRSIZ);
80101ecb:	83 ec 04             	sub    $0x4,%esp
80101ece:	6a 0e                	push   $0xe
80101ed0:	53                   	push   %ebx
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101ed1:	89 f3                	mov    %esi,%ebx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ed3:	ff 75 10             	pushl  0x10(%ebp)
80101ed6:	e8 95 2e 00 00       	call   80104d70 <memmove>
80101edb:	83 c4 10             	add    $0x10,%esp
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ede:	80 3e 2f             	cmpb   $0x2f,(%esi)
80101ee1:	75 0d                	jne    80101ef0 <namex+0xd0>
80101ee3:	90                   	nop
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101eeb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eee:	74 f8                	je     80101ee8 <namex+0xc8>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101ef0:	83 ec 04             	sub    $0x4,%esp
80101ef3:	6a 0e                	push   $0xe
80101ef5:	68 55 7b 10 80       	push   $0x80107b55
80101efa:	ff 75 10             	pushl  0x10(%ebp)
80101efd:	e8 ee 2e 00 00       	call   80104df0 <strncmp>
  else
  ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0) {
    
    if(namecmp(name, "..") == 0){
80101f02:	83 c4 10             	add    $0x10,%esp
80101f05:	85 c0                	test   %eax,%eax
80101f07:	75 4b                	jne    80101f54 <namex+0x134>
        // Need to delete last element from full path
        if((*index) && !(*index == 1 && pathbuffer[0] == '/')){
80101f09:	8b 45 24             	mov    0x24(%ebp),%eax
80101f0c:	8b 00                	mov    (%eax),%eax
80101f0e:	85 c0                	test   %eax,%eax
80101f10:	74 42                	je     80101f54 <namex+0x134>
80101f12:	83 f8 01             	cmp    $0x1,%eax
80101f15:	0f 84 14 02 00 00    	je     8010212f <namex+0x30f>
            while(*index && pathbuffer[*index] != '/')
80101f1b:	8b 4d 20             	mov    0x20(%ebp),%ecx
80101f1e:	01 c1                	add    %eax,%ecx
80101f20:	83 e8 01             	sub    $0x1,%eax
80101f23:	80 39 2f             	cmpb   $0x2f,(%ecx)
80101f26:	74 29                	je     80101f51 <namex+0x131>
80101f28:	8b 55 20             	mov    0x20(%ebp),%edx
80101f2b:	8b 75 24             	mov    0x24(%ebp),%esi
80101f2e:	eb 0d                	jmp    80101f3d <namex+0x11d>
80101f30:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101f33:	83 e8 01             	sub    $0x1,%eax
80101f36:	80 7c 02 01 2f       	cmpb   $0x2f,0x1(%edx,%eax,1)
80101f3b:	74 14                	je     80101f51 <namex+0x131>
80101f3d:	85 c0                	test   %eax,%eax
                    *index = (*index) - 1;
80101f3f:	89 06                	mov    %eax,(%esi)
  while((path = skipelem(path, name)) != 0) {
    
    if(namecmp(name, "..") == 0){
        // Need to delete last element from full path
        if((*index) && !(*index == 1 && pathbuffer[0] == '/')){
            while(*index && pathbuffer[*index] != '/')
80101f41:	75 ed                	jne    80101f30 <namex+0x110>
                    *index = (*index) - 1;
            if(*index == 0 && pathbuffer[0] == '/')
80101f43:	8b 45 20             	mov    0x20(%ebp),%eax
80101f46:	80 38 2f             	cmpb   $0x2f,(%eax)
80101f49:	89 c1                	mov    %eax,%ecx
80101f4b:	0f 84 0d 02 00 00    	je     8010215e <namex+0x33e>
                    *index = (*index) + 1;
            pathbuffer[*index] = '\0';
80101f51:	c6 01 00             	movb   $0x0,(%ecx)
        }
    }
    
    ilock(ip);
80101f54:	83 ec 0c             	sub    $0xc,%esp
80101f57:	57                   	push   %edi
80101f58:	e8 23 f8 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101f5d:	83 c4 10             	add    $0x10,%esp
80101f60:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101f65:	0f 85 d5 01 00 00    	jne    80102140 <namex+0x320>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f6e:	85 f6                	test   %esi,%esi
80101f70:	74 09                	je     80101f7b <namex+0x15b>
80101f72:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f75:	0f 84 f7 01 00 00    	je     80102172 <namex+0x352>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f7b:	83 ec 04             	sub    $0x4,%esp
80101f7e:	6a 00                	push   $0x0
80101f80:	ff 75 10             	pushl  0x10(%ebp)
80101f83:	57                   	push   %edi
80101f84:	e8 27 fd ff ff       	call   80101cb0 <dirlookup>
80101f89:	83 c4 10             	add    $0x10,%esp
80101f8c:	85 c0                	test   %eax,%eax
80101f8e:	89 c6                	mov    %eax,%esi
80101f90:	0f 84 aa 01 00 00    	je     80102140 <namex+0x320>
      iunlockput(ip);
      return 0;
    }
    iunlock(ip);
80101f96:	83 ec 0c             	sub    $0xc,%esp
80101f99:	57                   	push   %edi
80101f9a:	e8 c1 f8 ff ff       	call   80101860 <iunlock>
    ilock(next); 
80101f9f:	89 34 24             	mov    %esi,(%esp)
80101fa2:	e8 d9 f7 ff ff       	call   80101780 <ilock>
    if(next->type == T_SYMLINK) {
80101fa7:	83 c4 10             	add    $0x10,%esp
80101faa:	66 83 7e 50 04       	cmpw   $0x4,0x50(%esi)
80101faf:	75 7f                	jne    80102030 <namex+0x210>
      if(noderef && *path == '\0'){
80101fb1:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
80101fb4:	85 c9                	test   %ecx,%ecx
80101fb6:	74 09                	je     80101fc1 <namex+0x1a1>
80101fb8:	80 3b 00             	cmpb   $0x0,(%ebx)
80101fbb:	0f 84 25 02 00 00    	je     801021e6 <namex+0x3c6>
            iunlock(next);
            iput(ip);
            return next;
        }
        
        if(readi(next, buf, 0, next->size) != next->size) {
80101fc1:	8d 45 84             	lea    -0x7c(%ebp),%eax
80101fc4:	ff 76 58             	pushl  0x58(%esi)
80101fc7:	6a 00                	push   $0x0
80101fc9:	50                   	push   %eax
80101fca:	56                   	push   %esi
80101fcb:	e8 90 fa ff ff       	call   80101a60 <readi>
80101fd0:	83 c4 10             	add    $0x10,%esp
80101fd3:	3b 46 58             	cmp    0x58(%esi),%eax
80101fd6:	0f 85 e7 01 00 00    	jne    801021c3 <namex+0x3a3>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101fdc:	83 ec 0c             	sub    $0xc,%esp
        if(readi(next, buf, 0, next->size) != next->size) {
        iunlockput(next);
        iput(ip);
        return 0;
      }
    buf[next->size] = 0; 
80101fdf:	c6 44 05 84 00       	movb   $0x0,-0x7c(%ebp,%eax,1)

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101fe4:	56                   	push   %esi
80101fe5:	e8 76 f8 ff ff       	call   80101860 <iunlock>
  iput(ip);
80101fea:	89 34 24             	mov    %esi,(%esp)
80101fed:	e8 be f8 ff ff       	call   801018b0 <iput>
        iput(ip);
        return 0;
      }
    buf[next->size] = 0; 
    iunlockput(next);
    next = namex(buf, 0, tname, l_counter+1, ip, 0, pathbuffer, index, pathbufsize);
80101ff2:	8d 85 76 ff ff ff    	lea    -0x8a(%ebp),%eax
80101ff8:	5a                   	pop    %edx
80101ff9:	ff 75 28             	pushl  0x28(%ebp)
80101ffc:	ff 75 24             	pushl  0x24(%ebp)
80101fff:	ff 75 20             	pushl  0x20(%ebp)
80102002:	6a 00                	push   $0x0
80102004:	57                   	push   %edi
80102005:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
8010200b:	50                   	push   %eax
8010200c:	8d 45 84             	lea    -0x7c(%ebp),%eax
8010200f:	6a 00                	push   $0x0
80102011:	50                   	push   %eax
80102012:	e8 09 fe ff ff       	call   80101e20 <namex>
80102017:	83 c4 30             	add    $0x30,%esp
8010201a:	89 c6                	mov    %eax,%esi
            memmove(pathbuffer + (*index), name, len);
            *index = (*index) + len;
            pathbuffer[(*index)] = '\0';
        }
    }
    iput(ip);
8010201c:	83 ec 0c             	sub    $0xc,%esp
8010201f:	57                   	push   %edi
    ip = next;
80102020:	89 f7                	mov    %esi,%edi
            memmove(pathbuffer + (*index), name, len);
            *index = (*index) + len;
            pathbuffer[(*index)] = '\0';
        }
    }
    iput(ip);
80102022:	e8 89 f8 ff ff       	call   801018b0 <iput>
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	e9 54 fe ff ff       	jmp    80101e83 <namex+0x63>
8010202f:	90                   	nop
    buf[next->size] = 0; 
    iunlockput(next);
    next = namex(buf, 0, tname, l_counter+1, ip, 0, pathbuffer, index, pathbufsize);
    }  else {
        // Check if we need to update pathbuffer
        iunlock(next);
80102030:	83 ec 0c             	sub    $0xc,%esp
80102033:	56                   	push   %esi
80102034:	e8 27 f8 ff ff       	call   80101860 <iunlock>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80102039:	83 c4 0c             	add    $0xc,%esp
8010203c:	6a 0e                	push   $0xe
8010203e:	68 55 7b 10 80       	push   $0x80107b55
80102043:	ff 75 10             	pushl  0x10(%ebp)
80102046:	e8 a5 2d 00 00       	call   80104df0 <strncmp>
    next = namex(buf, 0, tname, l_counter+1, ip, 0, pathbuffer, index, pathbufsize);
    }  else {
        // Check if we need to update pathbuffer
        iunlock(next);
        
        if (namecmp(name, "..") != 0)
8010204b:	83 c4 10             	add    $0x10,%esp
8010204e:	85 c0                	test   %eax,%eax
80102050:	74 ca                	je     8010201c <namex+0x1fc>
        {
            int len = strlen(name);
80102052:	83 ec 0c             	sub    $0xc,%esp
80102055:	ff 75 10             	pushl  0x10(%ebp)
80102058:	e8 a3 2e 00 00       	call   80104f00 <strlen>
8010205d:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
            // Add '/' if necessary
            if (*index && pathbufsize - *index > 0 && pathbuffer[(*index)-1] != '/'){
80102063:	8b 45 24             	mov    0x24(%ebp),%eax
80102066:	83 c4 10             	add    $0x10,%esp
80102069:	8b 10                	mov    (%eax),%edx
8010206b:	8b 45 28             	mov    0x28(%ebp),%eax
8010206e:	85 d2                	test   %edx,%edx
80102070:	74 33                	je     801020a5 <namex+0x285>
80102072:	89 c1                	mov    %eax,%ecx
80102074:	29 d1                	sub    %edx,%ecx
80102076:	85 c9                	test   %ecx,%ecx
80102078:	89 c8                	mov    %ecx,%eax
8010207a:	7e 29                	jle    801020a5 <namex+0x285>
8010207c:	8b 4d 20             	mov    0x20(%ebp),%ecx
8010207f:	80 7c 11 ff 2f       	cmpb   $0x2f,-0x1(%ecx,%edx,1)
80102084:	74 1f                	je     801020a5 <namex+0x285>
                    pathbuffer[(*index)++] = '/';
80102086:	8b 45 24             	mov    0x24(%ebp),%eax
80102089:	89 d1                	mov    %edx,%ecx
8010208b:	83 c1 01             	add    $0x1,%ecx
8010208e:	89 08                	mov    %ecx,(%eax)
80102090:	8b 45 20             	mov    0x20(%ebp),%eax
80102093:	8b 4d 28             	mov    0x28(%ebp),%ecx
80102096:	c6 04 10 2f          	movb   $0x2f,(%eax,%edx,1)
8010209a:	8b 45 24             	mov    0x24(%ebp),%eax
8010209d:	8b 00                	mov    (%eax),%eax
8010209f:	29 c1                	sub    %eax,%ecx
801020a1:	89 c2                	mov    %eax,%edx
801020a3:	89 c8                	mov    %ecx,%eax
            }
            
            // case pathbuffer is full 
            if(len >= pathbufsize - (*index)){
801020a5:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
801020ab:	0f 8d 50 01 00 00    	jge    80102201 <namex+0x3e1>
                    *index = 0;
                    buf[0] = '\0';
                    return 0;
            }
            
            memmove(pathbuffer + (*index), name, len);
801020b1:	8b 45 20             	mov    0x20(%ebp),%eax
801020b4:	83 ec 04             	sub    $0x4,%esp
801020b7:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
801020bd:	ff 75 10             	pushl  0x10(%ebp)
801020c0:	01 d0                	add    %edx,%eax
801020c2:	50                   	push   %eax
801020c3:	e8 a8 2c 00 00       	call   80104d70 <memmove>
            *index = (*index) + len;
801020c8:	8b 4d 24             	mov    0x24(%ebp),%ecx
801020cb:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
            pathbuffer[(*index)] = '\0';
801020d1:	83 c4 10             	add    $0x10,%esp
801020d4:	8b 55 20             	mov    0x20(%ebp),%edx
                    buf[0] = '\0';
                    return 0;
            }
            
            memmove(pathbuffer + (*index), name, len);
            *index = (*index) + len;
801020d7:	03 01                	add    (%ecx),%eax
801020d9:	89 01                	mov    %eax,(%ecx)
            pathbuffer[(*index)] = '\0';
801020db:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
801020df:	e9 38 ff ff ff       	jmp    8010201c <namex+0x1fc>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801020e4:	31 c9                	xor    %ecx,%ecx
801020e6:	8d 76 00             	lea    0x0(%esi),%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801020f0:	83 ec 04             	sub    $0x4,%esp
801020f3:	89 8d 64 ff ff ff    	mov    %ecx,-0x9c(%ebp)
801020f9:	51                   	push   %ecx
801020fa:	53                   	push   %ebx
    name[len] = 0;
801020fb:	89 f3                	mov    %esi,%ebx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801020fd:	ff 75 10             	pushl  0x10(%ebp)
80102100:	e8 6b 2c 00 00       	call   80104d70 <memmove>
    name[len] = 0;
80102105:	8b 45 10             	mov    0x10(%ebp),%eax
80102108:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
8010210e:	83 c4 10             	add    $0x10,%esp
80102111:	c6 04 08 00          	movb   $0x0,(%eax,%ecx,1)
80102115:	e9 c4 fd ff ff       	jmp    80101ede <namex+0xbe>
        }
    }
    iput(ip);
    ip = next;
  }
  if(nameiparent){
8010211a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010211d:	85 c0                	test   %eax,%eax
8010211f:	0f 85 f8 00 00 00    	jne    8010221d <namex+0x3fd>
80102125:	89 f8                	mov    %edi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80102127:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212a:	5b                   	pop    %ebx
8010212b:	5e                   	pop    %esi
8010212c:	5f                   	pop    %edi
8010212d:	5d                   	pop    %ebp
8010212e:	c3                   	ret    

  while((path = skipelem(path, name)) != 0) {
    
    if(namecmp(name, "..") == 0){
        // Need to delete last element from full path
        if((*index) && !(*index == 1 && pathbuffer[0] == '/')){
8010212f:	8b 55 20             	mov    0x20(%ebp),%edx
80102132:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102135:	0f 85 e0 fd ff ff    	jne    80101f1b <namex+0xfb>
8010213b:	e9 14 fe ff ff       	jmp    80101f54 <namex+0x134>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	57                   	push   %edi
80102144:	e8 17 f7 ff ff       	call   80101860 <iunlock>
  iput(ip);
80102149:	89 3c 24             	mov    %edi,(%esp)
8010214c:	e8 5f f7 ff ff       	call   801018b0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80102151:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102154:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80102157:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102159:	5b                   	pop    %ebx
8010215a:	5e                   	pop    %esi
8010215b:	5f                   	pop    %edi
8010215c:	5d                   	pop    %ebp
8010215d:	c3                   	ret    
        // Need to delete last element from full path
        if((*index) && !(*index == 1 && pathbuffer[0] == '/')){
            while(*index && pathbuffer[*index] != '/')
                    *index = (*index) - 1;
            if(*index == 0 && pathbuffer[0] == '/')
                    *index = (*index) + 1;
8010215e:	8b 45 24             	mov    0x24(%ebp),%eax
80102161:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80102167:	8b 45 20             	mov    0x20(%ebp),%eax
8010216a:	8d 48 01             	lea    0x1(%eax),%ecx
8010216d:	e9 df fd ff ff       	jmp    80101f51 <namex+0x131>
    if(ip->type != T_DIR){
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      iunlock(ip);
80102172:	83 ec 0c             	sub    $0xc,%esp
80102175:	57                   	push   %edi
80102176:	e8 e5 f6 ff ff       	call   80101860 <iunlock>
      return ip;
8010217b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
8010217e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      iunlock(ip);
      return ip;
80102181:	89 f8                	mov    %edi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102183:	5b                   	pop    %ebx
80102184:	5e                   	pop    %esi
80102185:	5f                   	pop    %edi
80102186:	5d                   	pop    %ebp
80102187:	c3                   	ret    
  if (l_counter > MAX_DEREFERENCE) {
    return 0;  // probably infinite loop.
  }

  if(*path == '/'){
    *index = 1;
80102188:	8b 45 24             	mov    0x24(%ebp),%eax
    pathbuffer[0] = '/';
    pathbuffer[1] = '\0';
    ip = iget(ROOTDEV, ROOTINO);
8010218b:	ba 01 00 00 00       	mov    $0x1,%edx
  if (l_counter > MAX_DEREFERENCE) {
    return 0;  // probably infinite loop.
  }

  if(*path == '/'){
    *index = 1;
80102190:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    pathbuffer[0] = '/';
80102196:	8b 45 20             	mov    0x20(%ebp),%eax
80102199:	c6 00 2f             	movb   $0x2f,(%eax)
    pathbuffer[1] = '\0';
8010219c:	c6 40 01 00          	movb   $0x0,0x1(%eax)
    ip = iget(ROOTDEV, ROOTINO);
801021a0:	b8 01 00 00 00       	mov    $0x1,%eax
801021a5:	e8 56 f0 ff ff       	call   80101200 <iget>
801021aa:	89 c7                	mov    %eax,%edi
801021ac:	e9 c3 fc ff ff       	jmp    80101e74 <namex+0x54>
  }
  else if (last_pos)
  ip = idup(last_pos);    // need to remember last inode
  else
  ip = idup(proc->cwd);
801021b1:	8b 78 68             	mov    0x68(%eax),%edi
801021b4:	e9 9b fc ff ff       	jmp    80101e54 <namex+0x34>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  struct inode *ip, *next;
  char buf[100], tname[DIRSIZ];
  struct proc* proc = myproc();

  if (l_counter > MAX_DEREFERENCE) {
    return 0;  // probably infinite loop.
801021bc:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021be:	5b                   	pop    %ebx
801021bf:	5e                   	pop    %esi
801021c0:	5f                   	pop    %edi
801021c1:	5d                   	pop    %ebp
801021c2:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801021c3:	83 ec 0c             	sub    $0xc,%esp
801021c6:	56                   	push   %esi
801021c7:	e8 94 f6 ff ff       	call   80101860 <iunlock>
  iput(ip);
801021cc:	89 34 24             	mov    %esi,(%esp)
801021cf:	e8 dc f6 ff ff       	call   801018b0 <iput>
            return next;
        }
        
        if(readi(next, buf, 0, next->size) != next->size) {
        iunlockput(next);
        iput(ip);
801021d4:	89 3c 24             	mov    %edi,(%esp)
801021d7:	e8 d4 f6 ff ff       	call   801018b0 <iput>
        return 0;
801021dc:	83 c4 10             	add    $0x10,%esp
801021df:	31 c0                	xor    %eax,%eax
801021e1:	e9 41 ff ff ff       	jmp    80102127 <namex+0x307>
    }
    iunlock(ip);
    ilock(next); 
    if(next->type == T_SYMLINK) {
      if(noderef && *path == '\0'){
            iunlock(next);
801021e6:	83 ec 0c             	sub    $0xc,%esp
801021e9:	56                   	push   %esi
801021ea:	e8 71 f6 ff ff       	call   80101860 <iunlock>
            iput(ip);
801021ef:	89 3c 24             	mov    %edi,(%esp)
801021f2:	e8 b9 f6 ff ff       	call   801018b0 <iput>
            return next;
801021f7:	83 c4 10             	add    $0x10,%esp
    }
    if(nameiparent && *path == '\0'){
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801021fa:	89 f0                	mov    %esi,%eax
    ilock(next); 
    if(next->type == T_SYMLINK) {
      if(noderef && *path == '\0'){
            iunlock(next);
            iput(ip);
            return next;
801021fc:	e9 26 ff ff ff       	jmp    80102127 <namex+0x307>
                    pathbuffer[(*index)++] = '/';
            }
            
            // case pathbuffer is full 
            if(len >= pathbufsize - (*index)){
                    iput(ip);
80102201:	83 ec 0c             	sub    $0xc,%esp
80102204:	57                   	push   %edi
80102205:	e8 a6 f6 ff ff       	call   801018b0 <iput>
                    *index = 0;
8010220a:	8b 45 24             	mov    0x24(%ebp),%eax
                    buf[0] = '\0';
                    return 0;
8010220d:	83 c4 10             	add    $0x10,%esp
            }
            
            // case pathbuffer is full 
            if(len >= pathbufsize - (*index)){
                    iput(ip);
                    *index = 0;
80102210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    buf[0] = '\0';
                    return 0;
80102216:	31 c0                	xor    %eax,%eax
80102218:	e9 0a ff ff ff       	jmp    80102127 <namex+0x307>
    }
    iput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
8010221d:	83 ec 0c             	sub    $0xc,%esp
80102220:	57                   	push   %edi
80102221:	e8 8a f6 ff ff       	call   801018b0 <iput>
    return 0;
80102226:	83 c4 10             	add    $0x10,%esp
80102229:	31 c0                	xor    %eax,%eax
8010222b:	e9 f7 fe ff ff       	jmp    80102127 <namex+0x307>

80102230 <namei>:
  return ip;
}

struct inode*
namei(char *path, int noderef)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	81 ec 34 04 00 00    	sub    $0x434,%esp
  char name[DIRSIZ];
  char pathbuffer[MAXPATH];
  int index = 0;
  return namex(path, 0, name, 1, 0, noderef, pathbuffer, &index, MAXPATH);
80102239:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
8010223f:	68 00 04 00 00       	push   $0x400
struct inode*
namei(char *path, int noderef)
{
  char name[DIRSIZ];
  char pathbuffer[MAXPATH];
  int index = 0;
80102244:	c7 85 e4 fb ff ff 00 	movl   $0x0,-0x41c(%ebp)
8010224b:	00 00 00 
  return namex(path, 0, name, 1, 0, noderef, pathbuffer, &index, MAXPATH);
8010224e:	50                   	push   %eax
8010224f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
80102255:	50                   	push   %eax
80102256:	8d 85 ea fb ff ff    	lea    -0x416(%ebp),%eax
8010225c:	ff 75 0c             	pushl  0xc(%ebp)
8010225f:	6a 00                	push   $0x0
80102261:	6a 01                	push   $0x1
80102263:	50                   	push   %eax
80102264:	6a 00                	push   $0x0
80102266:	ff 75 08             	pushl  0x8(%ebp)
80102269:	e8 b2 fb ff ff       	call   80101e20 <namex>
}
8010226e:	c9                   	leave  
8010226f:	c3                   	ret    

80102270 <nameiparent>:


struct inode*
nameiparent(char *path, char *name)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	81 ec 24 04 00 00    	sub    $0x424,%esp
  char pathbuffer[MAXPATH];
  int index = 0;
  return namex(path, 1, name, 1, 0, 0, pathbuffer, &index, MAXPATH);
80102279:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
8010227f:	68 00 04 00 00       	push   $0x400

struct inode*
nameiparent(char *path, char *name)
{
  char pathbuffer[MAXPATH];
  int index = 0;
80102284:	c7 85 f4 fb ff ff 00 	movl   $0x0,-0x40c(%ebp)
8010228b:	00 00 00 
  return namex(path, 1, name, 1, 0, 0, pathbuffer, &index, MAXPATH);
8010228e:	50                   	push   %eax
8010228f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
80102295:	50                   	push   %eax
80102296:	6a 00                	push   $0x0
80102298:	6a 00                	push   $0x0
8010229a:	6a 01                	push   $0x1
8010229c:	ff 75 0c             	pushl  0xc(%ebp)
8010229f:	6a 01                	push   $0x1
801022a1:	ff 75 08             	pushl  0x8(%ebp)
801022a4:	e8 77 fb ff ff       	call   80101e20 <namex>
}
801022a9:	c9                   	leave  
801022aa:	c3                   	ret    
801022ab:	90                   	nop
801022ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022b0 <printMem>:

void printMem(char* loc, int nbytes){
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	56                   	push   %esi
801022b4:	53                   	push   %ebx
801022b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801022b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  for(i=0; i<nbytes; i++){
801022bb:	85 c0                	test   %eax,%eax
801022bd:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801022c0:	7e 21                	jle    801022e3 <printMem+0x33>
801022c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d ", loc[i]);
801022c8:	0f be 03             	movsbl (%ebx),%eax
801022cb:	83 ec 08             	sub    $0x8,%esp
801022ce:	83 c3 01             	add    $0x1,%ebx
801022d1:	50                   	push   %eax
801022d2:	68 58 7b 10 80       	push   $0x80107b58
801022d7:	e8 84 e3 ff ff       	call   80100660 <cprintf>
  return namex(path, 1, name, 1, 0, 0, pathbuffer, &index, MAXPATH);
}

void printMem(char* loc, int nbytes){
  int i;
  for(i=0; i<nbytes; i++){
801022dc:	83 c4 10             	add    $0x10,%esp
801022df:	39 f3                	cmp    %esi,%ebx
801022e1:	75 e5                	jne    801022c8 <printMem+0x18>
    cprintf("%d ", loc[i]);
  }
}
801022e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022e6:	5b                   	pop    %ebx
801022e7:	5e                   	pop    %esi
801022e8:	5d                   	pop    %ebp
801022e9:	c3                   	ret    
801022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022f0 <searchKey>:

//returns location for the value
int
searchKey(const char* key, char* str)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 0c             	sub    $0xc,%esp
801022f9:	8b 75 0c             	mov    0xc(%ebp),%esi
801022fc:	8d 9e 00 02 00 00    	lea    0x200(%esi),%ebx
80102302:	89 f7                	mov    %esi,%edi
80102304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

void printMem(char* loc, int nbytes){
  int i;
  for(i=0; i<nbytes; i++){
    cprintf("%d ", loc[i]);
80102308:	0f be 17             	movsbl (%edi),%edx
8010230b:	83 ec 08             	sub    $0x8,%esp
8010230e:	83 c7 01             	add    $0x1,%edi
80102311:	52                   	push   %edx
80102312:	68 58 7b 10 80       	push   $0x80107b58
80102317:	e8 44 e3 ff ff       	call   80100660 <cprintf>
  return namex(path, 1, name, 1, 0, 0, pathbuffer, &index, MAXPATH);
}

void printMem(char* loc, int nbytes){
  int i;
  for(i=0; i<nbytes; i++){
8010231c:	83 c4 10             	add    $0x10,%esp
8010231f:	39 fb                	cmp    %edi,%ebx
80102321:	75 e5                	jne    80102308 <searchKey+0x18>
{
  //cprintf("start search. searching for key: %s\n", key);
  //int BSIZE = 512;
  printMem(str, 512);
  int i = 0;
  int keyLength = strlen((char*)key);
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	ff 75 08             	pushl  0x8(%ebp)
  for (i = 0; i < BSIZE; i += 42){ 
80102329:	31 ff                	xor    %edi,%edi
{
  //cprintf("start search. searching for key: %s\n", key);
  //int BSIZE = 512;
  printMem(str, 512);
  int i = 0;
  int keyLength = strlen((char*)key);
8010232b:	e8 d0 2b 00 00       	call   80104f00 <strlen>
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	89 c3                	mov    %eax,%ebx
80102335:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < BSIZE; i += 42){ 
      if(strncmp(key, str+i, keyLength) == 0){
80102338:	8d 04 3e             	lea    (%esi,%edi,1),%eax
8010233b:	83 ec 04             	sub    $0x4,%esp
8010233e:	53                   	push   %ebx
8010233f:	50                   	push   %eax
80102340:	ff 75 08             	pushl  0x8(%ebp)
80102343:	e8 a8 2a 00 00       	call   80104df0 <strncmp>
80102348:	83 c4 10             	add    $0x10,%esp
8010234b:	85 c0                	test   %eax,%eax
8010234d:	74 18                	je     80102367 <searchKey+0x77>
  //cprintf("start search. searching for key: %s\n", key);
  //int BSIZE = 512;
  printMem(str, 512);
  int i = 0;
  int keyLength = strlen((char*)key);
  for (i = 0; i < BSIZE; i += 42){ 
8010234f:	83 c7 2a             	add    $0x2a,%edi
80102352:	81 ff 22 02 00 00    	cmp    $0x222,%edi
80102358:	75 de                	jne    80102338 <searchKey+0x48>
        return i;
      }
  }
  //cprintf("search: didnt find key\n");
  return -1;
}
8010235a:	8d 65 f4             	lea    -0xc(%ebp),%esp
        //cprintf("returing location %d\n", i);
        return i;
      }
  }
  //cprintf("search: didnt find key\n");
  return -1;
8010235d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102362:	5b                   	pop    %ebx
80102363:	5e                   	pop    %esi
80102364:	5f                   	pop    %edi
80102365:	5d                   	pop    %ebp
80102366:	c3                   	ret    
80102367:	8d 65 f4             	lea    -0xc(%ebp),%esp
  for (i = 0; i < BSIZE; i += 42){ 
      if(strncmp(key, str+i, keyLength) == 0){
        //cprintf("search: found key\n");
        i += 11; //for the location of future value  
        //cprintf("returing location %d\n", i);
        return i;
8010236a:	8d 47 0b             	lea    0xb(%edi),%eax
      }
  }
  //cprintf("search: didnt find key\n");
  return -1;
}
8010236d:	5b                   	pop    %ebx
8010236e:	5e                   	pop    %esi
8010236f:	5f                   	pop    %edi
80102370:	5d                   	pop    %ebp
80102371:	c3                   	ret    
80102372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102380 <findEmptyLocation>:

int
findEmptyLocation(char* str)
{
80102380:	55                   	push   %ebp
  //printMem(str, 512);
  int i = 0;
  for (i = 0; i < BSIZE; i += 42){ 
80102381:	31 c0                	xor    %eax,%eax
  return -1;
}

int
findEmptyLocation(char* str)
{
80102383:	89 e5                	mov    %esp,%ebp
80102385:	8b 55 08             	mov    0x8(%ebp),%edx
80102388:	90                   	nop
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  //printMem(str, 512);
  int i = 0;
  for (i = 0; i < BSIZE; i += 42){ 
      if(!str[i]) 
80102390:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80102394:	74 0f                	je     801023a5 <findEmptyLocation+0x25>
int
findEmptyLocation(char* str)
{
  //printMem(str, 512);
  int i = 0;
  for (i = 0; i < BSIZE; i += 42){ 
80102396:	83 c0 2a             	add    $0x2a,%eax
80102399:	3d 22 02 00 00       	cmp    $0x222,%eax
8010239e:	75 f0                	jne    80102390 <findEmptyLocation+0x10>
      if(!str[i]) 
        return i;
  }
  return -1;
801023a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801023a5:	5d                   	pop    %ebp
801023a6:	c3                   	ret    
801023a7:	89 f6                	mov    %esi,%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023b0 <ftag>:



int
ftag(int fd, char* key, char* value)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	57                   	push   %edi
801023b4:	56                   	push   %esi
801023b5:	53                   	push   %ebx
801023b6:	83 ec 1c             	sub    $0x1c,%esp
801023b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* proc = myproc();
801023bc:	e8 6f 1c 00 00       	call   80104030 <myproc>
  struct file *f;
  struct buf *bp;
  char *str; //str is the data of the tags block 
  int keyLength, valueLength;
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0) return -1;
801023c1:	83 fb 0f             	cmp    $0xf,%ebx
801023c4:	0f 87 33 01 00 00    	ja     801024fd <ftag+0x14d>
801023ca:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801023ce:	85 f6                	test   %esi,%esi
801023d0:	0f 84 27 01 00 00    	je     801024fd <ftag+0x14d>
  if (f->type != FD_INODE || !f->writable || !f->ip) return -1;
801023d6:	83 3e 02             	cmpl   $0x2,(%esi)
801023d9:	0f 85 1e 01 00 00    	jne    801024fd <ftag+0x14d>
801023df:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
801023e3:	0f 84 14 01 00 00    	je     801024fd <ftag+0x14d>
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) return -1;
801023e9:	8b 46 10             	mov    0x10(%esi),%eax
801023ec:	85 c0                	test   %eax,%eax
801023ee:	0f 84 09 01 00 00    	je     801024fd <ftag+0x14d>
801023f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801023f7:	85 c0                	test   %eax,%eax
801023f9:	0f 84 fe 00 00 00    	je     801024fd <ftag+0x14d>
801023ff:	83 ec 0c             	sub    $0xc,%esp
80102402:	ff 75 0c             	pushl  0xc(%ebp)
80102405:	e8 f6 2a 00 00       	call   80104f00 <strlen>
8010240a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (!value || (valueLength = strlen(value)) < 1 || valueLength > 30) return -1;
8010240d:	83 e8 01             	sub    $0x1,%eax
80102410:	83 c4 10             	add    $0x10,%esp
80102413:	83 f8 09             	cmp    $0x9,%eax
80102416:	0f 87 e1 00 00 00    	ja     801024fd <ftag+0x14d>
8010241c:	8b 45 10             	mov    0x10(%ebp),%eax
8010241f:	85 c0                	test   %eax,%eax
80102421:	0f 84 d6 00 00 00    	je     801024fd <ftag+0x14d>
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	ff 75 10             	pushl  0x10(%ebp)
8010242d:	e8 ce 2a 00 00       	call   80104f00 <strlen>
80102432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102435:	83 e8 01             	sub    $0x1,%eax
80102438:	83 c4 10             	add    $0x10,%esp
8010243b:	83 f8 1d             	cmp    $0x1d,%eax
8010243e:	0f 87 b9 00 00 00    	ja     801024fd <ftag+0x14d>
  ilock(f->ip);
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	ff 76 10             	pushl  0x10(%esi)
8010244a:	e8 31 f3 ff ff       	call   80101780 <ilock>
  if (!f->ip->tags){
8010244f:	8b 46 10             	mov    0x10(%esi),%eax
80102452:	83 c4 10             	add    $0x10,%esp
80102455:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010245b:	85 d2                	test   %edx,%edx
8010245d:	0f 84 dd 00 00 00    	je     80102540 <ftag+0x190>
    begin_op();
    f->ip->tags = balloc(f->ip->dev);
    end_op();
  }  
  bp = bread(f->ip->dev, f->ip->tags);
80102463:	83 ec 08             	sub    $0x8,%esp
80102466:	52                   	push   %edx
80102467:	ff 30                	pushl  (%eax)
80102469:	e8 62 dc ff ff       	call   801000d0 <bread>
  str = (char*)bp->data;
  int endPos = searchKey(key, str);
8010246e:	59                   	pop    %ecx
    begin_op();
    f->ip->tags = balloc(f->ip->dev);
    end_op();
  }  
  bp = bread(f->ip->dev, f->ip->tags);
  str = (char*)bp->data;
8010246f:	8d 58 5c             	lea    0x5c(%eax),%ebx
  if (!f->ip->tags){
    begin_op();
    f->ip->tags = balloc(f->ip->dev);
    end_op();
  }  
  bp = bread(f->ip->dev, f->ip->tags);
80102472:	89 c7                	mov    %eax,%edi
  str = (char*)bp->data;
  int endPos = searchKey(key, str);
80102474:	58                   	pop    %eax
80102475:	53                   	push   %ebx
80102476:	ff 75 0c             	pushl  0xc(%ebp)
80102479:	e8 72 fe ff ff       	call   801022f0 <searchKey>
  if (endPos < 0) {
8010247e:	83 c4 10             	add    $0x10,%esp
80102481:	85 c0                	test   %eax,%eax
80102483:	78 4b                	js     801024d0 <ftag+0x120>
    bwrite(bp);
    brelse(bp);
    iunlock(f->ip);
    return 0;
  }
  memset((void*)((uint)str + (uint)endPos + 11), 0, 30);
80102485:	8d 5c 07 67          	lea    0x67(%edi,%eax,1),%ebx
80102489:	83 ec 04             	sub    $0x4,%esp
8010248c:	6a 1e                	push   $0x1e
8010248e:	6a 00                	push   $0x0
80102490:	53                   	push   %ebx
80102491:	e8 2a 28 00 00       	call   80104cc0 <memset>
  memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
80102496:	83 c4 0c             	add    $0xc,%esp
80102499:	ff 75 e4             	pushl  -0x1c(%ebp)
8010249c:	ff 75 10             	pushl  0x10(%ebp)
      return -1;
    }
    //cprintf("key not found. putting key %s in location %d\n", key, endPos);
    memset((void*)((uint)str + (uint)endPos), 0, 42);
    memmove((void*)((uint)str + (uint)endPos), (void*)key, (uint)keyLength);
    memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
8010249f:	53                   	push   %ebx
801024a0:	e8 cb 28 00 00       	call   80104d70 <memmove>
    bwrite(bp);
801024a5:	89 3c 24             	mov    %edi,(%esp)
801024a8:	e8 f3 dc ff ff       	call   801001a0 <bwrite>
    brelse(bp);
801024ad:	89 3c 24             	mov    %edi,(%esp)
801024b0:	e8 2b dd ff ff       	call   801001e0 <brelse>
    iunlock(f->ip);
801024b5:	5a                   	pop    %edx
801024b6:	ff 76 10             	pushl  0x10(%esi)
801024b9:	e8 a2 f3 ff ff       	call   80101860 <iunlock>
    return 0;
801024be:	83 c4 10             	add    $0x10,%esp
  memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}
801024c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove((void*)((uint)str + (uint)endPos), (void*)key, (uint)keyLength);
    memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
    bwrite(bp);
    brelse(bp);
    iunlock(f->ip);
    return 0;
801024c4:	31 c0                	xor    %eax,%eax
  memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}
801024c6:	5b                   	pop    %ebx
801024c7:	5e                   	pop    %esi
801024c8:	5f                   	pop    %edi
801024c9:	5d                   	pop    %ebp
801024ca:	c3                   	ret    
801024cb:	90                   	nop
801024cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d0:	31 c0                	xor    %eax,%eax
801024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
findEmptyLocation(char* str)
{
  //printMem(str, 512);
  int i = 0;
  for (i = 0; i < BSIZE; i += 42){ 
      if(!str[i]) 
801024d8:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
801024dc:	74 32                	je     80102510 <ftag+0x160>
int
findEmptyLocation(char* str)
{
  //printMem(str, 512);
  int i = 0;
  for (i = 0; i < BSIZE; i += 42){ 
801024de:	83 c0 2a             	add    $0x2a,%eax
801024e1:	3d 22 02 00 00       	cmp    $0x222,%eax
801024e6:	75 f0                	jne    801024d8 <ftag+0x128>
  bp = bread(f->ip->dev, f->ip->tags);
  str = (char*)bp->data;
  int endPos = searchKey(key, str);
  if (endPos < 0) {
    if((endPos = findEmptyLocation(str)) < 0){
      brelse(bp);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	57                   	push   %edi
801024ec:	e8 ef dc ff ff       	call   801001e0 <brelse>
      iunlock(f->ip);
801024f1:	58                   	pop    %eax
801024f2:	ff 76 10             	pushl  0x10(%esi)
801024f5:	e8 66 f3 ff ff       	call   80101860 <iunlock>
      return -1;
801024fa:	83 c4 10             	add    $0x10,%esp
  memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}
801024fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  int endPos = searchKey(key, str);
  if (endPos < 0) {
    if((endPos = findEmptyLocation(str)) < 0){
      brelse(bp);
      iunlock(f->ip);
      return -1;
80102500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}
80102505:	5b                   	pop    %ebx
80102506:	5e                   	pop    %esi
80102507:	5f                   	pop    %edi
80102508:	5d                   	pop    %ebp
80102509:	c3                   	ret    
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      brelse(bp);
      iunlock(f->ip);
      return -1;
    }
    //cprintf("key not found. putting key %s in location %d\n", key, endPos);
    memset((void*)((uint)str + (uint)endPos), 0, 42);
80102510:	83 ec 04             	sub    $0x4,%esp
80102513:	01 c3                	add    %eax,%ebx
80102515:	6a 2a                	push   $0x2a
80102517:	6a 00                	push   $0x0
80102519:	53                   	push   %ebx
8010251a:	e8 a1 27 00 00       	call   80104cc0 <memset>
    memmove((void*)((uint)str + (uint)endPos), (void*)key, (uint)keyLength);
8010251f:	83 c4 0c             	add    $0xc,%esp
80102522:	ff 75 e0             	pushl  -0x20(%ebp)
80102525:	ff 75 0c             	pushl  0xc(%ebp)
80102528:	53                   	push   %ebx
    memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
80102529:	83 c3 0b             	add    $0xb,%ebx
      iunlock(f->ip);
      return -1;
    }
    //cprintf("key not found. putting key %s in location %d\n", key, endPos);
    memset((void*)((uint)str + (uint)endPos), 0, 42);
    memmove((void*)((uint)str + (uint)endPos), (void*)key, (uint)keyLength);
8010252c:	e8 3f 28 00 00       	call   80104d70 <memmove>
    memmove((void*)((uint)str + (uint)endPos + 11), (void*)value, (uint)valueLength);
80102531:	83 c4 0c             	add    $0xc,%esp
80102534:	ff 75 e4             	pushl  -0x1c(%ebp)
80102537:	ff 75 10             	pushl  0x10(%ebp)
8010253a:	e9 60 ff ff ff       	jmp    8010249f <ftag+0xef>
8010253f:	90                   	nop
  if (f->type != FD_INODE || !f->writable || !f->ip) return -1;
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) return -1;
  if (!value || (valueLength = strlen(value)) < 1 || valueLength > 30) return -1;
  ilock(f->ip);
  if (!f->ip->tags){
    begin_op();
80102540:	e8 bb 0e 00 00       	call   80103400 <begin_op>
    f->ip->tags = balloc(f->ip->dev);
80102545:	8b 5e 10             	mov    0x10(%esi),%ebx
80102548:	8b 03                	mov    (%ebx),%eax
8010254a:	e8 a1 eb ff ff       	call   801010f0 <balloc>
8010254f:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
    end_op();
80102555:	e8 16 0f 00 00       	call   80103470 <end_op>
8010255a:	8b 46 10             	mov    0x10(%esi),%eax
8010255d:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80102563:	e9 fb fe ff ff       	jmp    80102463 <ftag+0xb3>
80102568:	90                   	nop
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102570 <funtag>:
  iunlock(f->ip);
  return 0;
}


int funtag(int fd, const char* key){
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	57                   	push   %edi
80102574:	56                   	push   %esi
80102575:	53                   	push   %ebx
80102576:	83 ec 0c             	sub    $0xc,%esp
80102579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* proc = myproc();
8010257c:	e8 af 1a 00 00       	call   80104030 <myproc>
  struct file *f;
  int keyLength;
  struct buf *bp;
  char *str;
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0) return -1;
80102581:	83 fb 0f             	cmp    $0xf,%ebx
80102584:	0f 87 db 00 00 00    	ja     80102665 <funtag+0xf5>
8010258a:	8b 5c 98 28          	mov    0x28(%eax,%ebx,4),%ebx
8010258e:	85 db                	test   %ebx,%ebx
80102590:	0f 84 cf 00 00 00    	je     80102665 <funtag+0xf5>
  if (f->type != FD_INODE || !f->writable || !f->ip || !f->ip->tags) return -1;
80102596:	83 3b 02             	cmpl   $0x2,(%ebx)
80102599:	0f 85 c6 00 00 00    	jne    80102665 <funtag+0xf5>
8010259f:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
801025a3:	0f 84 bc 00 00 00    	je     80102665 <funtag+0xf5>
801025a9:	8b 43 10             	mov    0x10(%ebx),%eax
801025ac:	85 c0                	test   %eax,%eax
801025ae:	0f 84 b1 00 00 00    	je     80102665 <funtag+0xf5>
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) return -1;
801025b4:	8b b0 94 00 00 00    	mov    0x94(%eax),%esi
801025ba:	85 f6                	test   %esi,%esi
801025bc:	0f 84 a3 00 00 00    	je     80102665 <funtag+0xf5>
801025c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025c5:	85 c9                	test   %ecx,%ecx
801025c7:	0f 84 98 00 00 00    	je     80102665 <funtag+0xf5>
801025cd:	83 ec 0c             	sub    $0xc,%esp
801025d0:	ff 75 0c             	pushl  0xc(%ebp)
801025d3:	e8 28 29 00 00       	call   80104f00 <strlen>
801025d8:	83 e8 01             	sub    $0x1,%eax
801025db:	83 c4 10             	add    $0x10,%esp
801025de:	83 f8 09             	cmp    $0x9,%eax
801025e1:	0f 87 7e 00 00 00    	ja     80102665 <funtag+0xf5>
  ilock(f->ip);
801025e7:	83 ec 0c             	sub    $0xc,%esp
801025ea:	ff 73 10             	pushl  0x10(%ebx)
801025ed:	e8 8e f1 ff ff       	call   80101780 <ilock>
  bp = bread(f->ip->dev, f->ip->tags);
801025f2:	8b 43 10             	mov    0x10(%ebx),%eax
801025f5:	59                   	pop    %ecx
801025f6:	5e                   	pop    %esi
801025f7:	ff b0 94 00 00 00    	pushl  0x94(%eax)
801025fd:	ff 30                	pushl  (%eax)
801025ff:	e8 cc da ff ff       	call   801000d0 <bread>
  str = (char*)bp->data;
80102604:	8d 78 5c             	lea    0x5c(%eax),%edi
  char *str;
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0) return -1;
  if (f->type != FD_INODE || !f->writable || !f->ip || !f->ip->tags) return -1;
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) return -1;
  ilock(f->ip);
  bp = bread(f->ip->dev, f->ip->tags);
80102607:	89 c6                	mov    %eax,%esi
  str = (char*)bp->data;
  int keyPos = searchKey(key, str);
80102609:	58                   	pop    %eax
8010260a:	5a                   	pop    %edx
8010260b:	57                   	push   %edi
8010260c:	ff 75 0c             	pushl  0xc(%ebp)
8010260f:	e8 dc fc ff ff       	call   801022f0 <searchKey>
  if (keyPos < 0) {
80102614:	83 c4 10             	add    $0x10,%esp
80102617:	85 c0                	test   %eax,%eax
80102619:	78 35                	js     80102650 <funtag+0xe0>
    brelse(bp);
    iunlock(f->ip);
    return -1;    
  }
  memset((void*)((uint)str + (uint)keyPos), 0, 42); //the deletion of the key and value
8010261b:	83 ec 04             	sub    $0x4,%esp
8010261e:	01 f8                	add    %edi,%eax
80102620:	6a 2a                	push   $0x2a
80102622:	6a 00                	push   $0x0
80102624:	50                   	push   %eax
80102625:	e8 96 26 00 00       	call   80104cc0 <memset>
  bwrite(bp);
8010262a:	89 34 24             	mov    %esi,(%esp)
8010262d:	e8 6e db ff ff       	call   801001a0 <bwrite>
  brelse(bp);
80102632:	89 34 24             	mov    %esi,(%esp)
80102635:	e8 a6 db ff ff       	call   801001e0 <brelse>
  iunlock(f->ip);
8010263a:	58                   	pop    %eax
8010263b:	ff 73 10             	pushl  0x10(%ebx)
8010263e:	e8 1d f2 ff ff       	call   80101860 <iunlock>
  return 0;
80102643:	83 c4 10             	add    $0x10,%esp
}
80102646:	8d 65 f4             	lea    -0xc(%ebp),%esp
  }
  memset((void*)((uint)str + (uint)keyPos), 0, 42); //the deletion of the key and value
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
80102649:	31 c0                	xor    %eax,%eax
}
8010264b:	5b                   	pop    %ebx
8010264c:	5e                   	pop    %esi
8010264d:	5f                   	pop    %edi
8010264e:	5d                   	pop    %ebp
8010264f:	c3                   	ret    
  ilock(f->ip);
  bp = bread(f->ip->dev, f->ip->tags);
  str = (char*)bp->data;
  int keyPos = searchKey(key, str);
  if (keyPos < 0) {
    brelse(bp);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	56                   	push   %esi
80102654:	e8 87 db ff ff       	call   801001e0 <brelse>
    iunlock(f->ip);
80102659:	5a                   	pop    %edx
8010265a:	ff 73 10             	pushl  0x10(%ebx)
8010265d:	e8 fe f1 ff ff       	call   80101860 <iunlock>
    return -1;    
80102662:	83 c4 10             	add    $0x10,%esp
  memset((void*)((uint)str + (uint)keyPos), 0, 42); //the deletion of the key and value
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}
80102665:	8d 65 f4             	lea    -0xc(%ebp),%esp
  str = (char*)bp->data;
  int keyPos = searchKey(key, str);
  if (keyPos < 0) {
    brelse(bp);
    iunlock(f->ip);
    return -1;    
80102668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  memset((void*)((uint)str + (uint)keyPos), 0, 42); //the deletion of the key and value
  bwrite(bp);
  brelse(bp);
  iunlock(f->ip);
  return 0;
}
8010266d:	5b                   	pop    %ebx
8010266e:	5e                   	pop    %esi
8010266f:	5f                   	pop    %edi
80102670:	5d                   	pop    %ebp
80102671:	c3                   	ret    
80102672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <gettag>:



int gettag(int fd, const char* key, char* buf){
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	57                   	push   %edi
80102684:	56                   	push   %esi
80102685:	53                   	push   %ebx
80102686:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
8010268c:	8b 75 08             	mov    0x8(%ebp),%esi
  //cprintf("gettag: the key is: %s\n", key);
  struct proc* proc = myproc();
8010268f:	e8 9c 19 00 00       	call   80104030 <myproc>
  int keyLength;
  int valueLength;
  struct buf *bp;
  char str[BSIZE];
  uint valuePtr;
  if (fd < 0 || fd >= NOFILE || (f = proc->ofile[fd]) == 0) {
80102694:	83 fe 0f             	cmp    $0xf,%esi
80102697:	0f 87 f7 00 00 00    	ja     80102794 <gettag+0x114>
8010269d:	8b 7c b0 28          	mov    0x28(%eax,%esi,4),%edi
801026a1:	85 ff                	test   %edi,%edi
801026a3:	0f 84 eb 00 00 00    	je     80102794 <gettag+0x114>
    return -1;
  }
  if (f->type != FD_INODE || !f->readable || !f->ip)
801026a9:	83 3f 02             	cmpl   $0x2,(%edi)
801026ac:	0f 85 e2 00 00 00    	jne    80102794 <gettag+0x114>
801026b2:	80 7f 08 00          	cmpb   $0x0,0x8(%edi)
801026b6:	0f 84 d8 00 00 00    	je     80102794 <gettag+0x114>
  {
    return -1;
  }
  if (!key || (keyLength = strlen(key)) < 1 || keyLength > 10) {
801026bc:	8b 47 10             	mov    0x10(%edi),%eax
801026bf:	85 c0                	test   %eax,%eax
801026c1:	0f 84 cd 00 00 00    	je     80102794 <gettag+0x114>
801026c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ca:	85 f6                	test   %esi,%esi
801026cc:	0f 84 c2 00 00 00    	je     80102794 <gettag+0x114>
801026d2:	83 ec 0c             	sub    $0xc,%esp
801026d5:	ff 75 0c             	pushl  0xc(%ebp)
801026d8:	e8 23 28 00 00       	call   80104f00 <strlen>
    return -1; 
  }
  if (!buf){
801026dd:	83 e8 01             	sub    $0x1,%eax
801026e0:	83 c4 10             	add    $0x10,%esp
801026e3:	83 f8 09             	cmp    $0x9,%eax
801026e6:	0f 87 a8 00 00 00    	ja     80102794 <gettag+0x114>
801026ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
801026ef:	85 db                	test   %ebx,%ebx
801026f1:	0f 84 9d 00 00 00    	je     80102794 <gettag+0x114>
    return -1; 
  } 
  ilock(f->ip);
801026f7:	83 ec 0c             	sub    $0xc,%esp
801026fa:	ff 77 10             	pushl  0x10(%edi)
801026fd:	e8 7e f0 ff ff       	call   80101780 <ilock>
  if (!f->ip->tags) {
80102702:	8b 47 10             	mov    0x10(%edi),%eax
80102705:	83 c4 10             	add    $0x10,%esp
80102708:	8b 88 94 00 00 00    	mov    0x94(%eax),%ecx
8010270e:	85 c9                	test   %ecx,%ecx
80102710:	74 76                	je     80102788 <gettag+0x108>
    iunlock(f->ip);
    return -1;
  }
  bp = bread(f->ip->dev, f->ip->tags);
80102712:	83 ec 08             	sub    $0x8,%esp
  memmove((void*)str, (void*)bp->data, (uint)BSIZE);
80102715:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
  ilock(f->ip);
  if (!f->ip->tags) {
    iunlock(f->ip);
    return -1;
  }
  bp = bread(f->ip->dev, f->ip->tags);
8010271b:	51                   	push   %ecx
8010271c:	ff 30                	pushl  (%eax)
8010271e:	e8 ad d9 ff ff       	call   801000d0 <bread>
80102723:	89 c3                	mov    %eax,%ebx
  memmove((void*)str, (void*)bp->data, (uint)BSIZE);
80102725:	8d 40 5c             	lea    0x5c(%eax),%eax
80102728:	83 c4 0c             	add    $0xc,%esp
8010272b:	68 00 02 00 00       	push   $0x200
80102730:	50                   	push   %eax
80102731:	56                   	push   %esi
80102732:	e8 39 26 00 00       	call   80104d70 <memmove>
  brelse(bp);
80102737:	89 1c 24             	mov    %ebx,(%esp)
8010273a:	e8 a1 da ff ff       	call   801001e0 <brelse>
  iunlock(f->ip);  
8010273f:	58                   	pop    %eax
80102740:	ff 77 10             	pushl  0x10(%edi)
80102743:	e8 18 f1 ff ff       	call   80101860 <iunlock>
  int keyPos = searchKey(key, str);
80102748:	5a                   	pop    %edx
80102749:	59                   	pop    %ecx
8010274a:	56                   	push   %esi
8010274b:	ff 75 0c             	pushl  0xc(%ebp)
8010274e:	e8 9d fb ff ff       	call   801022f0 <searchKey>
  if (keyPos < 0){
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	85 c0                	test   %eax,%eax
80102758:	78 3a                	js     80102794 <gettag+0x114>
    //cprintf("didnt find key\n");
    return -1;
  }
  //cprintf("found key, the value position is: %d\n", keyPos);
  valuePtr = ((uint)str + (uint)keyPos);
  valueLength = (uint)strlen((char*) valuePtr);
8010275a:	01 c6                	add    %eax,%esi
8010275c:	83 ec 0c             	sub    $0xc,%esp
8010275f:	56                   	push   %esi
80102760:	e8 9b 27 00 00       	call   80104f00 <strlen>
  memmove((void*)buf, (void*)valuePtr, valueLength);
80102765:	83 c4 0c             	add    $0xc,%esp
    //cprintf("didnt find key\n");
    return -1;
  }
  //cprintf("found key, the value position is: %d\n", keyPos);
  valuePtr = ((uint)str + (uint)keyPos);
  valueLength = (uint)strlen((char*) valuePtr);
80102768:	89 c3                	mov    %eax,%ebx
  memmove((void*)buf, (void*)valuePtr, valueLength);
8010276a:	50                   	push   %eax
8010276b:	56                   	push   %esi
8010276c:	ff 75 10             	pushl  0x10(%ebp)
8010276f:	e8 fc 25 00 00       	call   80104d70 <memmove>
  return valueLength;
80102774:	83 c4 10             	add    $0x10,%esp
}
80102777:	8d 65 f4             	lea    -0xc(%ebp),%esp
  }
  //cprintf("found key, the value position is: %d\n", keyPos);
  valuePtr = ((uint)str + (uint)keyPos);
  valueLength = (uint)strlen((char*) valuePtr);
  memmove((void*)buf, (void*)valuePtr, valueLength);
  return valueLength;
8010277a:	89 d8                	mov    %ebx,%eax
}
8010277c:	5b                   	pop    %ebx
8010277d:	5e                   	pop    %esi
8010277e:	5f                   	pop    %edi
8010277f:	5d                   	pop    %ebp
80102780:	c3                   	ret    
80102781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (!buf){
    return -1; 
  } 
  ilock(f->ip);
  if (!f->ip->tags) {
    iunlock(f->ip);
80102788:	83 ec 0c             	sub    $0xc,%esp
8010278b:	50                   	push   %eax
8010278c:	e8 cf f0 ff ff       	call   80101860 <iunlock>
    return -1;
80102791:	83 c4 10             	add    $0x10,%esp
  //cprintf("found key, the value position is: %d\n", keyPos);
  valuePtr = ((uint)str + (uint)keyPos);
  valueLength = (uint)strlen((char*) valuePtr);
  memmove((void*)buf, (void*)valuePtr, valueLength);
  return valueLength;
}
80102794:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1; 
  } 
  ilock(f->ip);
  if (!f->ip->tags) {
    iunlock(f->ip);
    return -1;
80102797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  //cprintf("found key, the value position is: %d\n", keyPos);
  valuePtr = ((uint)str + (uint)keyPos);
  valueLength = (uint)strlen((char*) valuePtr);
  memmove((void*)buf, (void*)valuePtr, valueLength);
  return valueLength;
}
8010279c:	5b                   	pop    %ebx
8010279d:	5e                   	pop    %esi
8010279e:	5f                   	pop    %edi
8010279f:	5d                   	pop    %ebp
801027a0:	c3                   	ret    
801027a1:	66 90                	xchg   %ax,%ax
801027a3:	66 90                	xchg   %ax,%ax
801027a5:	66 90                	xchg   %ax,%ax
801027a7:	66 90                	xchg   %ax,%ax
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027b0:	55                   	push   %ebp
  if(b == 0)
801027b1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027b3:	89 e5                	mov    %esp,%ebp
801027b5:	56                   	push   %esi
801027b6:	53                   	push   %ebx
  if(b == 0)
801027b7:	0f 84 ad 00 00 00    	je     8010286a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801027bd:	8b 58 08             	mov    0x8(%eax),%ebx
801027c0:	89 c1                	mov    %eax,%ecx
801027c2:	81 fb ff 7f 00 00    	cmp    $0x7fff,%ebx
801027c8:	0f 87 8f 00 00 00    	ja     8010285d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027d3:	90                   	nop
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027d8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027d9:	83 e0 c0             	and    $0xffffffc0,%eax
801027dc:	3c 40                	cmp    $0x40,%al
801027de:	75 f8                	jne    801027d8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e0:	31 f6                	xor    %esi,%esi
801027e2:	ba f6 03 00 00       	mov    $0x3f6,%edx
801027e7:	89 f0                	mov    %esi,%eax
801027e9:	ee                   	out    %al,(%dx)
801027ea:	ba f2 01 00 00       	mov    $0x1f2,%edx
801027ef:	b8 01 00 00 00       	mov    $0x1,%eax
801027f4:	ee                   	out    %al,(%dx)
801027f5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801027fa:	89 d8                	mov    %ebx,%eax
801027fc:	ee                   	out    %al,(%dx)
801027fd:	89 d8                	mov    %ebx,%eax
801027ff:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102804:	c1 f8 08             	sar    $0x8,%eax
80102807:	ee                   	out    %al,(%dx)
80102808:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010280d:	89 f0                	mov    %esi,%eax
8010280f:	ee                   	out    %al,(%dx)
80102810:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102814:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102819:	83 e0 01             	and    $0x1,%eax
8010281c:	c1 e0 04             	shl    $0x4,%eax
8010281f:	83 c8 e0             	or     $0xffffffe0,%eax
80102822:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102823:	f6 01 04             	testb  $0x4,(%ecx)
80102826:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010282b:	75 13                	jne    80102840 <idestart+0x90>
8010282d:	b8 20 00 00 00       	mov    $0x20,%eax
80102832:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102833:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102836:	5b                   	pop    %ebx
80102837:	5e                   	pop    %esi
80102838:	5d                   	pop    %ebp
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102840:	b8 30 00 00 00       	mov    $0x30,%eax
80102845:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102846:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010284b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010284e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102853:	fc                   	cld    
80102854:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102856:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102859:	5b                   	pop    %ebx
8010285a:	5e                   	pop    %esi
8010285b:	5d                   	pop    %ebp
8010285c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010285d:	83 ec 0c             	sub    $0xc,%esp
80102860:	68 b8 7b 10 80       	push   $0x80107bb8
80102865:	e8 06 db ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010286a:	83 ec 0c             	sub    $0xc,%esp
8010286d:	68 af 7b 10 80       	push   $0x80107baf
80102872:	e8 f9 da ff ff       	call   80100370 <panic>
80102877:	89 f6                	mov    %esi,%esi
80102879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102880 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102886:	68 ca 7b 10 80       	push   $0x80107bca
8010288b:	68 80 b5 10 80       	push   $0x8010b580
80102890:	e8 bb 21 00 00       	call   80104a50 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102895:	58                   	pop    %eax
80102896:	a1 a0 3e 11 80       	mov    0x80113ea0,%eax
8010289b:	5a                   	pop    %edx
8010289c:	83 e8 01             	sub    $0x1,%eax
8010289f:	50                   	push   %eax
801028a0:	6a 0e                	push   $0xe
801028a2:	e8 a9 02 00 00       	call   80102b50 <ioapicenable>
801028a7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028aa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028af:	90                   	nop
801028b0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028b1:	83 e0 c0             	and    $0xffffffc0,%eax
801028b4:	3c 40                	cmp    $0x40,%al
801028b6:	75 f8                	jne    801028b0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028bd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801028c2:	ee                   	out    %al,(%dx)
801028c3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028cd:	eb 06                	jmp    801028d5 <ideinit+0x55>
801028cf:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801028d0:	83 e9 01             	sub    $0x1,%ecx
801028d3:	74 0f                	je     801028e4 <ideinit+0x64>
801028d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801028d6:	84 c0                	test   %al,%al
801028d8:	74 f6                	je     801028d0 <ideinit+0x50>
      havedisk1 = 1;
801028da:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801028e1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028e9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801028ee:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801028ef:	c9                   	leave  
801028f0:	c3                   	ret    
801028f1:	eb 0d                	jmp    80102900 <ideintr>
801028f3:	90                   	nop
801028f4:	90                   	nop
801028f5:	90                   	nop
801028f6:	90                   	nop
801028f7:	90                   	nop
801028f8:	90                   	nop
801028f9:	90                   	nop
801028fa:	90                   	nop
801028fb:	90                   	nop
801028fc:	90                   	nop
801028fd:	90                   	nop
801028fe:	90                   	nop
801028ff:	90                   	nop

80102900 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	57                   	push   %edi
80102904:	56                   	push   %esi
80102905:	53                   	push   %ebx
80102906:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102909:	68 80 b5 10 80       	push   $0x8010b580
8010290e:	e8 3d 22 00 00       	call   80104b50 <acquire>

  if((b = idequeue) == 0){
80102913:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102919:	83 c4 10             	add    $0x10,%esp
8010291c:	85 db                	test   %ebx,%ebx
8010291e:	74 34                	je     80102954 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102920:	8b 43 58             	mov    0x58(%ebx),%eax
80102923:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102928:	8b 33                	mov    (%ebx),%esi
8010292a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102930:	74 3e                	je     80102970 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102932:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102935:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102938:	83 ce 02             	or     $0x2,%esi
8010293b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010293d:	53                   	push   %ebx
8010293e:	e8 4d 1e 00 00       	call   80104790 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102943:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102948:	83 c4 10             	add    $0x10,%esp
8010294b:	85 c0                	test   %eax,%eax
8010294d:	74 05                	je     80102954 <ideintr+0x54>
    idestart(idequeue);
8010294f:	e8 5c fe ff ff       	call   801027b0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102954:	83 ec 0c             	sub    $0xc,%esp
80102957:	68 80 b5 10 80       	push   $0x8010b580
8010295c:	e8 0f 23 00 00       	call   80104c70 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102964:	5b                   	pop    %ebx
80102965:	5e                   	pop    %esi
80102966:	5f                   	pop    %edi
80102967:	5d                   	pop    %ebp
80102968:	c3                   	ret    
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102970:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102975:	8d 76 00             	lea    0x0(%esi),%esi
80102978:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102979:	89 c1                	mov    %eax,%ecx
8010297b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010297e:	80 f9 40             	cmp    $0x40,%cl
80102981:	75 f5                	jne    80102978 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102983:	a8 21                	test   $0x21,%al
80102985:	75 ab                	jne    80102932 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102987:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010298a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010298f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102994:	fc                   	cld    
80102995:	f3 6d                	rep insl (%dx),%es:(%edi)
80102997:	8b 33                	mov    (%ebx),%esi
80102999:	eb 97                	jmp    80102932 <ideintr+0x32>
8010299b:	90                   	nop
8010299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	53                   	push   %ebx
801029a4:	83 ec 10             	sub    $0x10,%esp
801029a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801029aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801029ad:	50                   	push   %eax
801029ae:	e8 6d 20 00 00       	call   80104a20 <holdingsleep>
801029b3:	83 c4 10             	add    $0x10,%esp
801029b6:	85 c0                	test   %eax,%eax
801029b8:	0f 84 ad 00 00 00    	je     80102a6b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029be:	8b 03                	mov    (%ebx),%eax
801029c0:	83 e0 06             	and    $0x6,%eax
801029c3:	83 f8 02             	cmp    $0x2,%eax
801029c6:	0f 84 b9 00 00 00    	je     80102a85 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801029cc:	8b 53 04             	mov    0x4(%ebx),%edx
801029cf:	85 d2                	test   %edx,%edx
801029d1:	74 0d                	je     801029e0 <iderw+0x40>
801029d3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801029d8:	85 c0                	test   %eax,%eax
801029da:	0f 84 98 00 00 00    	je     80102a78 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801029e0:	83 ec 0c             	sub    $0xc,%esp
801029e3:	68 80 b5 10 80       	push   $0x8010b580
801029e8:	e8 63 21 00 00       	call   80104b50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029ed:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801029f3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801029f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029fd:	85 d2                	test   %edx,%edx
801029ff:	75 09                	jne    80102a0a <iderw+0x6a>
80102a01:	eb 58                	jmp    80102a5b <iderw+0xbb>
80102a03:	90                   	nop
80102a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a08:	89 c2                	mov    %eax,%edx
80102a0a:	8b 42 58             	mov    0x58(%edx),%eax
80102a0d:	85 c0                	test   %eax,%eax
80102a0f:	75 f7                	jne    80102a08 <iderw+0x68>
80102a11:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102a14:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102a16:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
80102a1c:	74 44                	je     80102a62 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a1e:	8b 03                	mov    (%ebx),%eax
80102a20:	83 e0 06             	and    $0x6,%eax
80102a23:	83 f8 02             	cmp    $0x2,%eax
80102a26:	74 23                	je     80102a4b <iderw+0xab>
80102a28:	90                   	nop
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102a30:	83 ec 08             	sub    $0x8,%esp
80102a33:	68 80 b5 10 80       	push   $0x8010b580
80102a38:	53                   	push   %ebx
80102a39:	e8 a2 1b 00 00       	call   801045e0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a3e:	8b 03                	mov    (%ebx),%eax
80102a40:	83 c4 10             	add    $0x10,%esp
80102a43:	83 e0 06             	and    $0x6,%eax
80102a46:	83 f8 02             	cmp    $0x2,%eax
80102a49:	75 e5                	jne    80102a30 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
80102a4b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a55:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102a56:	e9 15 22 00 00       	jmp    80104c70 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a5b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102a60:	eb b2                	jmp    80102a14 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102a62:	89 d8                	mov    %ebx,%eax
80102a64:	e8 47 fd ff ff       	call   801027b0 <idestart>
80102a69:	eb b3                	jmp    80102a1e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
80102a6b:	83 ec 0c             	sub    $0xc,%esp
80102a6e:	68 ce 7b 10 80       	push   $0x80107bce
80102a73:	e8 f8 d8 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102a78:	83 ec 0c             	sub    $0xc,%esp
80102a7b:	68 f9 7b 10 80       	push   $0x80107bf9
80102a80:	e8 eb d8 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102a85:	83 ec 0c             	sub    $0xc,%esp
80102a88:	68 e4 7b 10 80       	push   $0x80107be4
80102a8d:	e8 de d8 ff ff       	call   80100370 <panic>
80102a92:	66 90                	xchg   %ax,%ax
80102a94:	66 90                	xchg   %ax,%ax
80102a96:	66 90                	xchg   %ax,%ax
80102a98:	66 90                	xchg   %ax,%ax
80102a9a:	66 90                	xchg   %ax,%ax
80102a9c:	66 90                	xchg   %ax,%ax
80102a9e:	66 90                	xchg   %ax,%ax

80102aa0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102aa0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102aa1:	c7 05 c4 37 11 80 00 	movl   $0xfec00000,0x801137c4
80102aa8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102aab:	89 e5                	mov    %esp,%ebp
80102aad:	56                   	push   %esi
80102aae:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102aaf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102ab6:	00 00 00 
  return ioapic->data;
80102ab9:	8b 15 c4 37 11 80    	mov    0x801137c4,%edx
80102abf:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102ac2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102ac8:	8b 0d c4 37 11 80    	mov    0x801137c4,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102ace:	0f b6 15 00 39 11 80 	movzbl 0x80113900,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ad5:	89 f0                	mov    %esi,%eax
80102ad7:	c1 e8 10             	shr    $0x10,%eax
80102ada:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
80102add:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102ae0:	c1 e8 18             	shr    $0x18,%eax
80102ae3:	39 d0                	cmp    %edx,%eax
80102ae5:	74 16                	je     80102afd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ae7:	83 ec 0c             	sub    $0xc,%esp
80102aea:	68 18 7c 10 80       	push   $0x80107c18
80102aef:	e8 6c db ff ff       	call   80100660 <cprintf>
80102af4:	8b 0d c4 37 11 80    	mov    0x801137c4,%ecx
80102afa:	83 c4 10             	add    $0x10,%esp
80102afd:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102b00:	ba 10 00 00 00       	mov    $0x10,%edx
80102b05:	b8 20 00 00 00       	mov    $0x20,%eax
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102b10:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102b12:	8b 0d c4 37 11 80    	mov    0x801137c4,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b18:	89 c3                	mov    %eax,%ebx
80102b1a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102b20:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102b23:	89 59 10             	mov    %ebx,0x10(%ecx)
80102b26:	8d 5a 01             	lea    0x1(%edx),%ebx
80102b29:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b2c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102b2e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102b30:	8b 0d c4 37 11 80    	mov    0x801137c4,%ecx
80102b36:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b3d:	75 d1                	jne    80102b10 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b42:	5b                   	pop    %ebx
80102b43:	5e                   	pop    %esi
80102b44:	5d                   	pop    %ebp
80102b45:	c3                   	ret    
80102b46:	8d 76 00             	lea    0x0(%esi),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b50:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102b51:	8b 0d c4 37 11 80    	mov    0x801137c4,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102b57:	89 e5                	mov    %esp,%ebp
80102b59:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b5c:	8d 50 20             	lea    0x20(%eax),%edx
80102b5f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102b63:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b65:	8b 0d c4 37 11 80    	mov    0x801137c4,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102b6b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102b6e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b71:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102b74:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b76:	a1 c4 37 11 80       	mov    0x801137c4,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b7b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102b7e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102b81:	5d                   	pop    %ebp
80102b82:	c3                   	ret    
80102b83:	66 90                	xchg   %ax,%ax
80102b85:	66 90                	xchg   %ax,%ax
80102b87:	66 90                	xchg   %ax,%ax
80102b89:	66 90                	xchg   %ax,%ax
80102b8b:	66 90                	xchg   %ax,%ax
80102b8d:	66 90                	xchg   %ax,%ax
80102b8f:	90                   	nop

80102b90 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	53                   	push   %ebx
80102b94:	83 ec 04             	sub    $0x4,%esp
80102b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b9a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102ba0:	75 70                	jne    80102c12 <kfree+0x82>
80102ba2:	81 fb 48 66 11 80    	cmp    $0x80116648,%ebx
80102ba8:	72 68                	jb     80102c12 <kfree+0x82>
80102baa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102bb0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bb5:	77 5b                	ja     80102c12 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bb7:	83 ec 04             	sub    $0x4,%esp
80102bba:	68 00 10 00 00       	push   $0x1000
80102bbf:	6a 01                	push   $0x1
80102bc1:	53                   	push   %ebx
80102bc2:	e8 f9 20 00 00       	call   80104cc0 <memset>

  if(kmem.use_lock)
80102bc7:	8b 15 14 38 11 80    	mov    0x80113814,%edx
80102bcd:	83 c4 10             	add    $0x10,%esp
80102bd0:	85 d2                	test   %edx,%edx
80102bd2:	75 2c                	jne    80102c00 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102bd4:	a1 18 38 11 80       	mov    0x80113818,%eax
80102bd9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102bdb:	a1 14 38 11 80       	mov    0x80113814,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102be0:	89 1d 18 38 11 80    	mov    %ebx,0x80113818
  if(kmem.use_lock)
80102be6:	85 c0                	test   %eax,%eax
80102be8:	75 06                	jne    80102bf0 <kfree+0x60>
    release(&kmem.lock);
}
80102bea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bed:	c9                   	leave  
80102bee:	c3                   	ret    
80102bef:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102bf0:	c7 45 08 e0 37 11 80 	movl   $0x801137e0,0x8(%ebp)
}
80102bf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bfa:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102bfb:	e9 70 20 00 00       	jmp    80104c70 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102c00:	83 ec 0c             	sub    $0xc,%esp
80102c03:	68 e0 37 11 80       	push   $0x801137e0
80102c08:	e8 43 1f 00 00       	call   80104b50 <acquire>
80102c0d:	83 c4 10             	add    $0x10,%esp
80102c10:	eb c2                	jmp    80102bd4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	68 4a 7c 10 80       	push   $0x80107c4a
80102c1a:	e8 51 d7 ff ff       	call   80100370 <panic>
80102c1f:	90                   	nop

80102c20 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	56                   	push   %esi
80102c24:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c25:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102c28:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c3d:	39 de                	cmp    %ebx,%esi
80102c3f:	72 23                	jb     80102c64 <freerange+0x44>
80102c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c48:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c4e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c57:	50                   	push   %eax
80102c58:	e8 33 ff ff ff       	call   80102b90 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c5d:	83 c4 10             	add    $0x10,%esp
80102c60:	39 f3                	cmp    %esi,%ebx
80102c62:	76 e4                	jbe    80102c48 <freerange+0x28>
    kfree(p);
}
80102c64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c67:	5b                   	pop    %ebx
80102c68:	5e                   	pop    %esi
80102c69:	5d                   	pop    %ebp
80102c6a:	c3                   	ret    
80102c6b:	90                   	nop
80102c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c70 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	56                   	push   %esi
80102c74:	53                   	push   %ebx
80102c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c78:	83 ec 08             	sub    $0x8,%esp
80102c7b:	68 50 7c 10 80       	push   $0x80107c50
80102c80:	68 e0 37 11 80       	push   $0x801137e0
80102c85:	e8 c6 1d 00 00       	call   80104a50 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c8d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102c90:	c7 05 14 38 11 80 00 	movl   $0x0,0x80113814
80102c97:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c9a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ca0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ca6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cac:	39 de                	cmp    %ebx,%esi
80102cae:	72 1c                	jb     80102ccc <kinit1+0x5c>
    kfree(p);
80102cb0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102cb6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102cbf:	50                   	push   %eax
80102cc0:	e8 cb fe ff ff       	call   80102b90 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cc5:	83 c4 10             	add    $0x10,%esp
80102cc8:	39 de                	cmp    %ebx,%esi
80102cca:	73 e4                	jae    80102cb0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
80102ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ccf:	5b                   	pop    %ebx
80102cd0:	5e                   	pop    %esi
80102cd1:	5d                   	pop    %ebp
80102cd2:	c3                   	ret    
80102cd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ce0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	56                   	push   %esi
80102ce4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102ce8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ceb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cf1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cf7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cfd:	39 de                	cmp    %ebx,%esi
80102cff:	72 23                	jb     80102d24 <kinit2+0x44>
80102d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102d08:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102d0e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102d17:	50                   	push   %eax
80102d18:	e8 73 fe ff ff       	call   80102b90 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d1d:	83 c4 10             	add    $0x10,%esp
80102d20:	39 de                	cmp    %ebx,%esi
80102d22:	73 e4                	jae    80102d08 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102d24:	c7 05 14 38 11 80 01 	movl   $0x1,0x80113814
80102d2b:	00 00 00 
}
80102d2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d31:	5b                   	pop    %ebx
80102d32:	5e                   	pop    %esi
80102d33:	5d                   	pop    %ebp
80102d34:	c3                   	ret    
80102d35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d40 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102d47:	a1 14 38 11 80       	mov    0x80113814,%eax
80102d4c:	85 c0                	test   %eax,%eax
80102d4e:	75 30                	jne    80102d80 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d50:	8b 1d 18 38 11 80    	mov    0x80113818,%ebx
  if(r)
80102d56:	85 db                	test   %ebx,%ebx
80102d58:	74 1c                	je     80102d76 <kalloc+0x36>
    kmem.freelist = r->next;
80102d5a:	8b 13                	mov    (%ebx),%edx
80102d5c:	89 15 18 38 11 80    	mov    %edx,0x80113818
  if(kmem.use_lock)
80102d62:	85 c0                	test   %eax,%eax
80102d64:	74 10                	je     80102d76 <kalloc+0x36>
    release(&kmem.lock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	68 e0 37 11 80       	push   $0x801137e0
80102d6e:	e8 fd 1e 00 00       	call   80104c70 <release>
80102d73:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102d76:	89 d8                	mov    %ebx,%eax
80102d78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d7b:	c9                   	leave  
80102d7c:	c3                   	ret    
80102d7d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	68 e0 37 11 80       	push   $0x801137e0
80102d88:	e8 c3 1d 00 00       	call   80104b50 <acquire>
  r = kmem.freelist;
80102d8d:	8b 1d 18 38 11 80    	mov    0x80113818,%ebx
  if(r)
80102d93:	83 c4 10             	add    $0x10,%esp
80102d96:	a1 14 38 11 80       	mov    0x80113814,%eax
80102d9b:	85 db                	test   %ebx,%ebx
80102d9d:	75 bb                	jne    80102d5a <kalloc+0x1a>
80102d9f:	eb c1                	jmp    80102d62 <kalloc+0x22>
80102da1:	66 90                	xchg   %ax,%ax
80102da3:	66 90                	xchg   %ax,%ax
80102da5:	66 90                	xchg   %ax,%ax
80102da7:	66 90                	xchg   %ax,%ax
80102da9:	66 90                	xchg   %ax,%ax
80102dab:	66 90                	xchg   %ax,%ax
80102dad:	66 90                	xchg   %ax,%ax
80102daf:	90                   	nop

80102db0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102db0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102db1:	ba 64 00 00 00       	mov    $0x64,%edx
80102db6:	89 e5                	mov    %esp,%ebp
80102db8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102db9:	a8 01                	test   $0x1,%al
80102dbb:	0f 84 af 00 00 00    	je     80102e70 <kbdgetc+0xc0>
80102dc1:	ba 60 00 00 00       	mov    $0x60,%edx
80102dc6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102dc7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102dca:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102dd0:	74 7e                	je     80102e50 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102dd2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102dd4:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102dda:	79 24                	jns    80102e00 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ddc:	f6 c1 40             	test   $0x40,%cl
80102ddf:	75 05                	jne    80102de6 <kbdgetc+0x36>
80102de1:	89 c2                	mov    %eax,%edx
80102de3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102de6:	0f b6 82 80 7d 10 80 	movzbl -0x7fef8280(%edx),%eax
80102ded:	83 c8 40             	or     $0x40,%eax
80102df0:	0f b6 c0             	movzbl %al,%eax
80102df3:	f7 d0                	not    %eax
80102df5:	21 c8                	and    %ecx,%eax
80102df7:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
80102dfc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102dfe:	5d                   	pop    %ebp
80102dff:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102e00:	f6 c1 40             	test   $0x40,%cl
80102e03:	74 09                	je     80102e0e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e05:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102e08:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e0b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102e0e:	0f b6 82 80 7d 10 80 	movzbl -0x7fef8280(%edx),%eax
80102e15:	09 c1                	or     %eax,%ecx
80102e17:	0f b6 82 80 7c 10 80 	movzbl -0x7fef8380(%edx),%eax
80102e1e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e20:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102e22:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102e28:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102e2b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
80102e2e:	8b 04 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%eax
80102e35:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102e39:	74 c3                	je     80102dfe <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
80102e3b:	8d 50 9f             	lea    -0x61(%eax),%edx
80102e3e:	83 fa 19             	cmp    $0x19,%edx
80102e41:	77 1d                	ja     80102e60 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102e43:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret    
80102e48:	90                   	nop
80102e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102e50:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102e52:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e59:	5d                   	pop    %ebp
80102e5a:	c3                   	ret    
80102e5b:	90                   	nop
80102e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102e60:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e63:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102e66:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102e67:	83 f9 19             	cmp    $0x19,%ecx
80102e6a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
80102e6d:	c3                   	ret    
80102e6e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e75:	5d                   	pop    %ebp
80102e76:	c3                   	ret    
80102e77:	89 f6                	mov    %esi,%esi
80102e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e80 <kbdintr>:

void
kbdintr(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e86:	68 b0 2d 10 80       	push   $0x80102db0
80102e8b:	e8 60 d9 ff ff       	call   801007f0 <consoleintr>
}
80102e90:	83 c4 10             	add    $0x10,%esp
80102e93:	c9                   	leave  
80102e94:	c3                   	ret    
80102e95:	66 90                	xchg   %ax,%ax
80102e97:	66 90                	xchg   %ax,%ax
80102e99:	66 90                	xchg   %ax,%ax
80102e9b:	66 90                	xchg   %ax,%ax
80102e9d:	66 90                	xchg   %ax,%ax
80102e9f:	90                   	nop

80102ea0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ea0:	a1 1c 38 11 80       	mov    0x8011381c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102ea5:	55                   	push   %ebp
80102ea6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ea8:	85 c0                	test   %eax,%eax
80102eaa:	0f 84 c8 00 00 00    	je     80102f78 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102eb0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102eb7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eba:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ebd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ec4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102eca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ed1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ed7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ede:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ee1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ee4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102eeb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102eee:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ef1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ef8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102efb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102efe:	8b 50 30             	mov    0x30(%eax),%edx
80102f01:	c1 ea 10             	shr    $0x10,%edx
80102f04:	80 fa 03             	cmp    $0x3,%dl
80102f07:	77 77                	ja     80102f80 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102f10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f13:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f20:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f3a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f47:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f54:	8b 50 20             	mov    0x20(%eax),%edx
80102f57:	89 f6                	mov    %esi,%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f66:	80 e6 10             	and    $0x10,%dh
80102f69:	75 f5                	jne    80102f60 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f75:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102f80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f8a:	8b 50 20             	mov    0x20(%eax),%edx
80102f8d:	e9 77 ff ff ff       	jmp    80102f09 <lapicinit+0x69>
80102f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102fa0:	a1 1c 38 11 80       	mov    0x8011381c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102fa5:	55                   	push   %ebp
80102fa6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fa8:	85 c0                	test   %eax,%eax
80102faa:	74 0c                	je     80102fb8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102fac:	8b 40 20             	mov    0x20(%eax),%eax
}
80102faf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102fb0:	c1 e8 18             	shr    $0x18,%eax
}
80102fb3:	c3                   	ret    
80102fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102fb8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102fba:	5d                   	pop    %ebp
80102fbb:	c3                   	ret    
80102fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fc0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102fc0:	a1 1c 38 11 80       	mov    0x8011381c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fc5:	55                   	push   %ebp
80102fc6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fc8:	85 c0                	test   %eax,%eax
80102fca:	74 0d                	je     80102fd9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102fcc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102fd3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fd6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102fd9:	5d                   	pop    %ebp
80102fda:	c3                   	ret    
80102fdb:	90                   	nop
80102fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fe0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
}
80102fe3:	5d                   	pop    %ebp
80102fe4:	c3                   	ret    
80102fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ff0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ff1:	ba 70 00 00 00       	mov    $0x70,%edx
80102ff6:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ffb:	89 e5                	mov    %esp,%ebp
80102ffd:	53                   	push   %ebx
80102ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103001:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103004:	ee                   	out    %al,(%dx)
80103005:	ba 71 00 00 00       	mov    $0x71,%edx
8010300a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010300f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103010:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80103012:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103015:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010301b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010301d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80103020:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80103023:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103025:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80103028:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010302e:	a1 1c 38 11 80       	mov    0x8011381c,%eax
80103033:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103039:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010303c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103043:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103046:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80103049:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103050:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103053:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80103056:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010305c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010305f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103065:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80103068:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010306e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80103071:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103077:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010307a:	5b                   	pop    %ebx
8010307b:	5d                   	pop    %ebp
8010307c:	c3                   	ret    
8010307d:	8d 76 00             	lea    0x0(%esi),%esi

80103080 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103080:	55                   	push   %ebp
80103081:	ba 70 00 00 00       	mov    $0x70,%edx
80103086:	b8 0b 00 00 00       	mov    $0xb,%eax
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	57                   	push   %edi
8010308e:	56                   	push   %esi
8010308f:	53                   	push   %ebx
80103090:	83 ec 4c             	sub    $0x4c,%esp
80103093:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103094:	ba 71 00 00 00       	mov    $0x71,%edx
80103099:	ec                   	in     (%dx),%al
8010309a:	83 e0 04             	and    $0x4,%eax
8010309d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030a0:	31 db                	xor    %ebx,%ebx
801030a2:	88 45 b7             	mov    %al,-0x49(%ebp)
801030a5:	bf 70 00 00 00       	mov    $0x70,%edi
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030b0:	89 d8                	mov    %ebx,%eax
801030b2:	89 fa                	mov    %edi,%edx
801030b4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b5:	b9 71 00 00 00       	mov    $0x71,%ecx
801030ba:	89 ca                	mov    %ecx,%edx
801030bc:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801030bd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c0:	89 fa                	mov    %edi,%edx
801030c2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801030c5:	b8 02 00 00 00       	mov    $0x2,%eax
801030ca:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030cb:	89 ca                	mov    %ecx,%edx
801030cd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801030ce:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030d1:	89 fa                	mov    %edi,%edx
801030d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801030d6:	b8 04 00 00 00       	mov    $0x4,%eax
801030db:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030dc:	89 ca                	mov    %ecx,%edx
801030de:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801030df:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e2:	89 fa                	mov    %edi,%edx
801030e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801030e7:	b8 07 00 00 00       	mov    $0x7,%eax
801030ec:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ed:	89 ca                	mov    %ecx,%edx
801030ef:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801030f0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f3:	89 fa                	mov    %edi,%edx
801030f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030f8:	b8 08 00 00 00       	mov    $0x8,%eax
801030fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030fe:	89 ca                	mov    %ecx,%edx
80103100:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80103101:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103104:	89 fa                	mov    %edi,%edx
80103106:	89 45 c8             	mov    %eax,-0x38(%ebp)
80103109:	b8 09 00 00 00       	mov    $0x9,%eax
8010310e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010310f:	89 ca                	mov    %ecx,%edx
80103111:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80103112:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103115:	89 fa                	mov    %edi,%edx
80103117:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010311a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010311f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103120:	89 ca                	mov    %ecx,%edx
80103122:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103123:	84 c0                	test   %al,%al
80103125:	78 89                	js     801030b0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103127:	89 d8                	mov    %ebx,%eax
80103129:	89 fa                	mov    %edi,%edx
8010312b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010312c:	89 ca                	mov    %ecx,%edx
8010312e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010312f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103132:	89 fa                	mov    %edi,%edx
80103134:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103137:	b8 02 00 00 00       	mov    $0x2,%eax
8010313c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010313d:	89 ca                	mov    %ecx,%edx
8010313f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80103140:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103143:	89 fa                	mov    %edi,%edx
80103145:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103148:	b8 04 00 00 00       	mov    $0x4,%eax
8010314d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010314e:	89 ca                	mov    %ecx,%edx
80103150:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80103151:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103154:	89 fa                	mov    %edi,%edx
80103156:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103159:	b8 07 00 00 00       	mov    $0x7,%eax
8010315e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010315f:	89 ca                	mov    %ecx,%edx
80103161:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80103162:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103165:	89 fa                	mov    %edi,%edx
80103167:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010316a:	b8 08 00 00 00       	mov    $0x8,%eax
8010316f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103170:	89 ca                	mov    %ecx,%edx
80103172:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80103173:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103176:	89 fa                	mov    %edi,%edx
80103178:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010317b:	b8 09 00 00 00       	mov    $0x9,%eax
80103180:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103181:	89 ca                	mov    %ecx,%edx
80103183:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80103184:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103187:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010318a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010318d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103190:	6a 18                	push   $0x18
80103192:	56                   	push   %esi
80103193:	50                   	push   %eax
80103194:	e8 77 1b 00 00       	call   80104d10 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	0f 85 0c ff ff ff    	jne    801030b0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801031a4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801031a8:	75 78                	jne    80103222 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031aa:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031ad:	89 c2                	mov    %eax,%edx
801031af:	83 e0 0f             	and    $0xf,%eax
801031b2:	c1 ea 04             	shr    $0x4,%edx
801031b5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031b8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031bb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801031be:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031c1:	89 c2                	mov    %eax,%edx
801031c3:	83 e0 0f             	and    $0xf,%eax
801031c6:	c1 ea 04             	shr    $0x4,%edx
801031c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031cc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031cf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801031d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031d5:	89 c2                	mov    %eax,%edx
801031d7:	83 e0 0f             	and    $0xf,%eax
801031da:	c1 ea 04             	shr    $0x4,%edx
801031dd:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031e0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031e3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031e9:	89 c2                	mov    %eax,%edx
801031eb:	83 e0 0f             	and    $0xf,%eax
801031ee:	c1 ea 04             	shr    $0x4,%edx
801031f1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031f4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031f7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801031fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031fd:	89 c2                	mov    %eax,%edx
801031ff:	83 e0 0f             	and    $0xf,%eax
80103202:	c1 ea 04             	shr    $0x4,%edx
80103205:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103208:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010320b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010320e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103211:	89 c2                	mov    %eax,%edx
80103213:	83 e0 0f             	and    $0xf,%eax
80103216:	c1 ea 04             	shr    $0x4,%edx
80103219:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010321c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010321f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103222:	8b 75 08             	mov    0x8(%ebp),%esi
80103225:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103228:	89 06                	mov    %eax,(%esi)
8010322a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010322d:	89 46 04             	mov    %eax,0x4(%esi)
80103230:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103233:	89 46 08             	mov    %eax,0x8(%esi)
80103236:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103239:	89 46 0c             	mov    %eax,0xc(%esi)
8010323c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010323f:	89 46 10             	mov    %eax,0x10(%esi)
80103242:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103245:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103248:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010324f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103252:	5b                   	pop    %ebx
80103253:	5e                   	pop    %esi
80103254:	5f                   	pop    %edi
80103255:	5d                   	pop    %ebp
80103256:	c3                   	ret    
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103260:	8b 0d 68 38 11 80    	mov    0x80113868,%ecx
80103266:	85 c9                	test   %ecx,%ecx
80103268:	0f 8e 85 00 00 00    	jle    801032f3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010326e:	55                   	push   %ebp
8010326f:	89 e5                	mov    %esp,%ebp
80103271:	57                   	push   %edi
80103272:	56                   	push   %esi
80103273:	53                   	push   %ebx
80103274:	31 db                	xor    %ebx,%ebx
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103280:	a1 54 38 11 80       	mov    0x80113854,%eax
80103285:	83 ec 08             	sub    $0x8,%esp
80103288:	01 d8                	add    %ebx,%eax
8010328a:	83 c0 01             	add    $0x1,%eax
8010328d:	50                   	push   %eax
8010328e:	ff 35 64 38 11 80    	pushl  0x80113864
80103294:	e8 37 ce ff ff       	call   801000d0 <bread>
80103299:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010329b:	58                   	pop    %eax
8010329c:	5a                   	pop    %edx
8010329d:	ff 34 9d 6c 38 11 80 	pushl  -0x7feec794(,%ebx,4)
801032a4:	ff 35 64 38 11 80    	pushl  0x80113864
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032ad:	e8 1e ce ff ff       	call   801000d0 <bread>
801032b2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032b4:	8d 47 5c             	lea    0x5c(%edi),%eax
801032b7:	83 c4 0c             	add    $0xc,%esp
801032ba:	68 00 02 00 00       	push   $0x200
801032bf:	50                   	push   %eax
801032c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801032c3:	50                   	push   %eax
801032c4:	e8 a7 1a 00 00       	call   80104d70 <memmove>
    bwrite(dbuf);  // write dst to disk
801032c9:	89 34 24             	mov    %esi,(%esp)
801032cc:	e8 cf ce ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801032d1:	89 3c 24             	mov    %edi,(%esp)
801032d4:	e8 07 cf ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801032d9:	89 34 24             	mov    %esi,(%esp)
801032dc:	e8 ff ce ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032e1:	83 c4 10             	add    $0x10,%esp
801032e4:	39 1d 68 38 11 80    	cmp    %ebx,0x80113868
801032ea:	7f 94                	jg     80103280 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801032ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ef:	5b                   	pop    %ebx
801032f0:	5e                   	pop    %esi
801032f1:	5f                   	pop    %edi
801032f2:	5d                   	pop    %ebp
801032f3:	f3 c3                	repz ret 
801032f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103300 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	53                   	push   %ebx
80103304:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103307:	ff 35 54 38 11 80    	pushl  0x80113854
8010330d:	ff 35 64 38 11 80    	pushl  0x80113864
80103313:	e8 b8 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103318:	8b 0d 68 38 11 80    	mov    0x80113868,%ecx
  for (i = 0; i < log.lh.n; i++) {
8010331e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80103321:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103323:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103325:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103328:	7e 1f                	jle    80103349 <write_head+0x49>
8010332a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80103331:	31 d2                	xor    %edx,%edx
80103333:	90                   	nop
80103334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103338:	8b 8a 6c 38 11 80    	mov    -0x7feec794(%edx),%ecx
8010333e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80103342:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103345:	39 c2                	cmp    %eax,%edx
80103347:	75 ef                	jne    80103338 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103349:	83 ec 0c             	sub    $0xc,%esp
8010334c:	53                   	push   %ebx
8010334d:	e8 4e ce ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80103352:	89 1c 24             	mov    %ebx,(%esp)
80103355:	e8 86 ce ff ff       	call   801001e0 <brelse>
}
8010335a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010335d:	c9                   	leave  
8010335e:	c3                   	ret    
8010335f:	90                   	nop

80103360 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	53                   	push   %ebx
80103364:	83 ec 2c             	sub    $0x2c,%esp
80103367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010336a:	68 80 7e 10 80       	push   $0x80107e80
8010336f:	68 20 38 11 80       	push   $0x80113820
80103374:	e8 d7 16 00 00       	call   80104a50 <initlock>
  readsb(dev, &sb);
80103379:	58                   	pop    %eax
8010337a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010337d:	5a                   	pop    %edx
8010337e:	50                   	push   %eax
8010337f:	53                   	push   %ebx
80103380:	e8 2b e1 ff ff       	call   801014b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80103385:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80103388:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
8010338b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
8010338c:	89 1d 64 38 11 80    	mov    %ebx,0x80113864

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80103392:	89 15 58 38 11 80    	mov    %edx,0x80113858
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80103398:	a3 54 38 11 80       	mov    %eax,0x80113854

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
8010339d:	5a                   	pop    %edx
8010339e:	50                   	push   %eax
8010339f:	53                   	push   %ebx
801033a0:	e8 2b cd ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801033a5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
801033a8:	83 c4 10             	add    $0x10,%esp
801033ab:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801033ad:	89 0d 68 38 11 80    	mov    %ecx,0x80113868
  for (i = 0; i < log.lh.n; i++) {
801033b3:	7e 1c                	jle    801033d1 <initlog+0x71>
801033b5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
801033bc:	31 d2                	xor    %edx,%edx
801033be:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801033c0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801033c4:	83 c2 04             	add    $0x4,%edx
801033c7:	89 8a 68 38 11 80    	mov    %ecx,-0x7feec798(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033cd:	39 da                	cmp    %ebx,%edx
801033cf:	75 ef                	jne    801033c0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801033d1:	83 ec 0c             	sub    $0xc,%esp
801033d4:	50                   	push   %eax
801033d5:	e8 06 ce ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801033da:	e8 81 fe ff ff       	call   80103260 <install_trans>
  log.lh.n = 0;
801033df:	c7 05 68 38 11 80 00 	movl   $0x0,0x80113868
801033e6:	00 00 00 
  write_head(); // clear the log
801033e9:	e8 12 ff ff ff       	call   80103300 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
801033ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033f1:	c9                   	leave  
801033f2:	c3                   	ret    
801033f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103400 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103406:	68 20 38 11 80       	push   $0x80113820
8010340b:	e8 40 17 00 00       	call   80104b50 <acquire>
80103410:	83 c4 10             	add    $0x10,%esp
80103413:	eb 18                	jmp    8010342d <begin_op+0x2d>
80103415:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103418:	83 ec 08             	sub    $0x8,%esp
8010341b:	68 20 38 11 80       	push   $0x80113820
80103420:	68 20 38 11 80       	push   $0x80113820
80103425:	e8 b6 11 00 00       	call   801045e0 <sleep>
8010342a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
8010342d:	a1 60 38 11 80       	mov    0x80113860,%eax
80103432:	85 c0                	test   %eax,%eax
80103434:	75 e2                	jne    80103418 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103436:	a1 5c 38 11 80       	mov    0x8011385c,%eax
8010343b:	8b 15 68 38 11 80    	mov    0x80113868,%edx
80103441:	83 c0 01             	add    $0x1,%eax
80103444:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103447:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010344a:	83 fa 1e             	cmp    $0x1e,%edx
8010344d:	7f c9                	jg     80103418 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010344f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80103452:	a3 5c 38 11 80       	mov    %eax,0x8011385c
      release(&log.lock);
80103457:	68 20 38 11 80       	push   $0x80113820
8010345c:	e8 0f 18 00 00       	call   80104c70 <release>
      break;
    }
  }
}
80103461:	83 c4 10             	add    $0x10,%esp
80103464:	c9                   	leave  
80103465:	c3                   	ret    
80103466:	8d 76 00             	lea    0x0(%esi),%esi
80103469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103470 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
80103475:	53                   	push   %ebx
80103476:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103479:	68 20 38 11 80       	push   $0x80113820
8010347e:	e8 cd 16 00 00       	call   80104b50 <acquire>
  log.outstanding -= 1;
80103483:	a1 5c 38 11 80       	mov    0x8011385c,%eax
  if(log.committing)
80103488:	8b 1d 60 38 11 80    	mov    0x80113860,%ebx
8010348e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103491:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80103494:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103496:	a3 5c 38 11 80       	mov    %eax,0x8011385c
  if(log.committing)
8010349b:	0f 85 23 01 00 00    	jne    801035c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801034a1:	85 c0                	test   %eax,%eax
801034a3:	0f 85 f7 00 00 00    	jne    801035a0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801034a9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
801034ac:	c7 05 60 38 11 80 01 	movl   $0x1,0x80113860
801034b3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
801034b6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801034b8:	68 20 38 11 80       	push   $0x80113820
801034bd:	e8 ae 17 00 00       	call   80104c70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801034c2:	8b 0d 68 38 11 80    	mov    0x80113868,%ecx
801034c8:	83 c4 10             	add    $0x10,%esp
801034cb:	85 c9                	test   %ecx,%ecx
801034cd:	0f 8e 8a 00 00 00    	jle    8010355d <end_op+0xed>
801034d3:	90                   	nop
801034d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034d8:	a1 54 38 11 80       	mov    0x80113854,%eax
801034dd:	83 ec 08             	sub    $0x8,%esp
801034e0:	01 d8                	add    %ebx,%eax
801034e2:	83 c0 01             	add    $0x1,%eax
801034e5:	50                   	push   %eax
801034e6:	ff 35 64 38 11 80    	pushl  0x80113864
801034ec:	e8 df cb ff ff       	call   801000d0 <bread>
801034f1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034f3:	58                   	pop    %eax
801034f4:	5a                   	pop    %edx
801034f5:	ff 34 9d 6c 38 11 80 	pushl  -0x7feec794(,%ebx,4)
801034fc:	ff 35 64 38 11 80    	pushl  0x80113864
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103502:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103505:	e8 c6 cb ff ff       	call   801000d0 <bread>
8010350a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010350c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010350f:	83 c4 0c             	add    $0xc,%esp
80103512:	68 00 02 00 00       	push   $0x200
80103517:	50                   	push   %eax
80103518:	8d 46 5c             	lea    0x5c(%esi),%eax
8010351b:	50                   	push   %eax
8010351c:	e8 4f 18 00 00       	call   80104d70 <memmove>
    bwrite(to);  // write the log
80103521:	89 34 24             	mov    %esi,(%esp)
80103524:	e8 77 cc ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103529:	89 3c 24             	mov    %edi,(%esp)
8010352c:	e8 af cc ff ff       	call   801001e0 <brelse>
    brelse(to);
80103531:	89 34 24             	mov    %esi,(%esp)
80103534:	e8 a7 cc ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103539:	83 c4 10             	add    $0x10,%esp
8010353c:	3b 1d 68 38 11 80    	cmp    0x80113868,%ebx
80103542:	7c 94                	jl     801034d8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103544:	e8 b7 fd ff ff       	call   80103300 <write_head>
    install_trans(); // Now install writes to home locations
80103549:	e8 12 fd ff ff       	call   80103260 <install_trans>
    log.lh.n = 0;
8010354e:	c7 05 68 38 11 80 00 	movl   $0x0,0x80113868
80103555:	00 00 00 
    write_head();    // Erase the transaction from the log
80103558:	e8 a3 fd ff ff       	call   80103300 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010355d:	83 ec 0c             	sub    $0xc,%esp
80103560:	68 20 38 11 80       	push   $0x80113820
80103565:	e8 e6 15 00 00       	call   80104b50 <acquire>
    log.committing = 0;
    wakeup(&log);
8010356a:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103571:	c7 05 60 38 11 80 00 	movl   $0x0,0x80113860
80103578:	00 00 00 
    wakeup(&log);
8010357b:	e8 10 12 00 00       	call   80104790 <wakeup>
    release(&log.lock);
80103580:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80103587:	e8 e4 16 00 00       	call   80104c70 <release>
8010358c:	83 c4 10             	add    $0x10,%esp
  }
}
8010358f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5f                   	pop    %edi
80103595:	5d                   	pop    %ebp
80103596:	c3                   	ret    
80103597:	89 f6                	mov    %esi,%esi
80103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	68 20 38 11 80       	push   $0x80113820
801035a8:	e8 e3 11 00 00       	call   80104790 <wakeup>
  }
  release(&log.lock);
801035ad:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
801035b4:	e8 b7 16 00 00       	call   80104c70 <release>
801035b9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
801035bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035bf:	5b                   	pop    %ebx
801035c0:	5e                   	pop    %esi
801035c1:	5f                   	pop    %edi
801035c2:	5d                   	pop    %ebp
801035c3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
801035c4:	83 ec 0c             	sub    $0xc,%esp
801035c7:	68 84 7e 10 80       	push   $0x80107e84
801035cc:	e8 9f cd ff ff       	call   80100370 <panic>
801035d1:	eb 0d                	jmp    801035e0 <log_write>
801035d3:	90                   	nop
801035d4:	90                   	nop
801035d5:	90                   	nop
801035d6:	90                   	nop
801035d7:	90                   	nop
801035d8:	90                   	nop
801035d9:	90                   	nop
801035da:	90                   	nop
801035db:	90                   	nop
801035dc:	90                   	nop
801035dd:	90                   	nop
801035de:	90                   	nop
801035df:	90                   	nop

801035e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	53                   	push   %ebx
801035e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035e7:	8b 15 68 38 11 80    	mov    0x80113868,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035f0:	83 fa 1d             	cmp    $0x1d,%edx
801035f3:	0f 8f 97 00 00 00    	jg     80103690 <log_write+0xb0>
801035f9:	a1 58 38 11 80       	mov    0x80113858,%eax
801035fe:	83 e8 01             	sub    $0x1,%eax
80103601:	39 c2                	cmp    %eax,%edx
80103603:	0f 8d 87 00 00 00    	jge    80103690 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103609:	a1 5c 38 11 80       	mov    0x8011385c,%eax
8010360e:	85 c0                	test   %eax,%eax
80103610:	0f 8e 87 00 00 00    	jle    8010369d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103616:	83 ec 0c             	sub    $0xc,%esp
80103619:	68 20 38 11 80       	push   $0x80113820
8010361e:	e8 2d 15 00 00       	call   80104b50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103623:	8b 15 68 38 11 80    	mov    0x80113868,%edx
80103629:	83 c4 10             	add    $0x10,%esp
8010362c:	83 fa 00             	cmp    $0x0,%edx
8010362f:	7e 50                	jle    80103681 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103631:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103634:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103636:	3b 0d 6c 38 11 80    	cmp    0x8011386c,%ecx
8010363c:	75 0b                	jne    80103649 <log_write+0x69>
8010363e:	eb 38                	jmp    80103678 <log_write+0x98>
80103640:	39 0c 85 6c 38 11 80 	cmp    %ecx,-0x7feec794(,%eax,4)
80103647:	74 2f                	je     80103678 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103649:	83 c0 01             	add    $0x1,%eax
8010364c:	39 d0                	cmp    %edx,%eax
8010364e:	75 f0                	jne    80103640 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103650:	89 0c 95 6c 38 11 80 	mov    %ecx,-0x7feec794(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103657:	83 c2 01             	add    $0x1,%edx
8010365a:	89 15 68 38 11 80    	mov    %edx,0x80113868
  b->flags |= B_DIRTY; // prevent eviction
80103660:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103663:	c7 45 08 20 38 11 80 	movl   $0x80113820,0x8(%ebp)
}
8010366a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010366d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010366e:	e9 fd 15 00 00       	jmp    80104c70 <release>
80103673:	90                   	nop
80103674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103678:	89 0c 85 6c 38 11 80 	mov    %ecx,-0x7feec794(,%eax,4)
8010367f:	eb df                	jmp    80103660 <log_write+0x80>
80103681:	8b 43 08             	mov    0x8(%ebx),%eax
80103684:	a3 6c 38 11 80       	mov    %eax,0x8011386c
  if (i == log.lh.n)
80103689:	75 d5                	jne    80103660 <log_write+0x80>
8010368b:	eb ca                	jmp    80103657 <log_write+0x77>
8010368d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	68 93 7e 10 80       	push   $0x80107e93
80103698:	e8 d3 cc ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010369d:	83 ec 0c             	sub    $0xc,%esp
801036a0:	68 a9 7e 10 80       	push   $0x80107ea9
801036a5:	e8 c6 cc ff ff       	call   80100370 <panic>
801036aa:	66 90                	xchg   %ax,%ax
801036ac:	66 90                	xchg   %ax,%ax
801036ae:	66 90                	xchg   %ax,%ax

801036b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	53                   	push   %ebx
801036b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801036b7:	e8 54 09 00 00       	call   80104010 <cpuid>
801036bc:	89 c3                	mov    %eax,%ebx
801036be:	e8 4d 09 00 00       	call   80104010 <cpuid>
801036c3:	83 ec 04             	sub    $0x4,%esp
801036c6:	53                   	push   %ebx
801036c7:	50                   	push   %eax
801036c8:	68 c4 7e 10 80       	push   $0x80107ec4
801036cd:	e8 8e cf ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801036d2:	e8 29 2b 00 00       	call   80106200 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801036d7:	e8 b4 08 00 00       	call   80103f90 <mycpu>
801036dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801036de:	b8 01 00 00 00       	mov    $0x1,%eax
801036e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036ea:	e8 01 0c 00 00       	call   801042f0 <scheduler>
801036ef:	90                   	nop

801036f0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036f6:	e8 25 3c 00 00       	call   80107320 <switchkvm>
  seginit();
801036fb:	e8 20 3b 00 00       	call   80107220 <seginit>
  lapicinit();
80103700:	e8 9b f7 ff ff       	call   80102ea0 <lapicinit>
  mpmain();
80103705:	e8 a6 ff ff ff       	call   801036b0 <mpmain>
8010370a:	66 90                	xchg   %ax,%ax
8010370c:	66 90                	xchg   %ax,%ax
8010370e:	66 90                	xchg   %ax,%ax

80103710 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103710:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103714:	83 e4 f0             	and    $0xfffffff0,%esp
80103717:	ff 71 fc             	pushl  -0x4(%ecx)
8010371a:	55                   	push   %ebp
8010371b:	89 e5                	mov    %esp,%ebp
8010371d:	53                   	push   %ebx
8010371e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010371f:	bb 20 39 11 80       	mov    $0x80113920,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103724:	83 ec 08             	sub    $0x8,%esp
80103727:	68 00 00 40 80       	push   $0x80400000
8010372c:	68 48 66 11 80       	push   $0x80116648
80103731:	e8 3a f5 ff ff       	call   80102c70 <kinit1>
  kvmalloc();      // kernel page table
80103736:	e8 85 40 00 00       	call   801077c0 <kvmalloc>
  mpinit();        // detect other processors
8010373b:	e8 70 01 00 00       	call   801038b0 <mpinit>
  lapicinit();     // interrupt controller
80103740:	e8 5b f7 ff ff       	call   80102ea0 <lapicinit>
  seginit();       // segment descriptors
80103745:	e8 d6 3a 00 00       	call   80107220 <seginit>
  picinit();       // disable pic
8010374a:	e8 31 03 00 00       	call   80103a80 <picinit>
  ioapicinit();    // another interrupt controller
8010374f:	e8 4c f3 ff ff       	call   80102aa0 <ioapicinit>
  consoleinit();   // console hardware
80103754:	e8 47 d2 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103759:	e8 92 2d 00 00       	call   801064f0 <uartinit>
  pinit();         // process table
8010375e:	e8 0d 08 00 00       	call   80103f70 <pinit>
  tvinit();        // trap vectors
80103763:	e8 f8 29 00 00       	call   80106160 <tvinit>
  binit();         // buffer cache
80103768:	e8 d3 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010376d:	e8 ce d5 ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk 
80103772:	e8 09 f1 ff ff       	call   80102880 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103777:	83 c4 0c             	add    $0xc,%esp
8010377a:	68 8a 00 00 00       	push   $0x8a
8010377f:	68 8c b4 10 80       	push   $0x8010b48c
80103784:	68 00 70 00 80       	push   $0x80007000
80103789:	e8 e2 15 00 00       	call   80104d70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010378e:	69 05 a0 3e 11 80 b0 	imul   $0xb0,0x80113ea0,%eax
80103795:	00 00 00 
80103798:	83 c4 10             	add    $0x10,%esp
8010379b:	05 20 39 11 80       	add    $0x80113920,%eax
801037a0:	39 d8                	cmp    %ebx,%eax
801037a2:	76 6f                	jbe    80103813 <main+0x103>
801037a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801037a8:	e8 e3 07 00 00       	call   80103f90 <mycpu>
801037ad:	39 d8                	cmp    %ebx,%eax
801037af:	74 49                	je     801037fa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801037b1:	e8 8a f5 ff ff       	call   80102d40 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801037b6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801037bb:	c7 05 f8 6f 00 80 f0 	movl   $0x801036f0,0x80006ff8
801037c2:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037c5:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801037cc:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801037cf:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801037d4:	0f b6 03             	movzbl (%ebx),%eax
801037d7:	83 ec 08             	sub    $0x8,%esp
801037da:	68 00 70 00 00       	push   $0x7000
801037df:	50                   	push   %eax
801037e0:	e8 0b f8 ff ff       	call   80102ff0 <lapicstartap>
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	90                   	nop
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037f6:	85 c0                	test   %eax,%eax
801037f8:	74 f6                	je     801037f0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801037fa:	69 05 a0 3e 11 80 b0 	imul   $0xb0,0x80113ea0,%eax
80103801:	00 00 00 
80103804:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010380a:	05 20 39 11 80       	add    $0x80113920,%eax
8010380f:	39 c3                	cmp    %eax,%ebx
80103811:	72 95                	jb     801037a8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103813:	83 ec 08             	sub    $0x8,%esp
80103816:	68 00 00 00 8e       	push   $0x8e000000
8010381b:	68 00 00 40 80       	push   $0x80400000
80103820:	e8 bb f4 ff ff       	call   80102ce0 <kinit2>
  userinit();      // first user process
80103825:	e8 36 08 00 00       	call   80104060 <userinit>
  mpmain();        // finish this processor's setup
8010382a:	e8 81 fe ff ff       	call   801036b0 <mpmain>
8010382f:	90                   	nop

80103830 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103835:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010383b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010383c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010383f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103842:	39 de                	cmp    %ebx,%esi
80103844:	73 48                	jae    8010388e <mpsearch1+0x5e>
80103846:	8d 76 00             	lea    0x0(%esi),%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103850:	83 ec 04             	sub    $0x4,%esp
80103853:	8d 7e 10             	lea    0x10(%esi),%edi
80103856:	6a 04                	push   $0x4
80103858:	68 d8 7e 10 80       	push   $0x80107ed8
8010385d:	56                   	push   %esi
8010385e:	e8 ad 14 00 00       	call   80104d10 <memcmp>
80103863:	83 c4 10             	add    $0x10,%esp
80103866:	85 c0                	test   %eax,%eax
80103868:	75 1e                	jne    80103888 <mpsearch1+0x58>
8010386a:	8d 7e 10             	lea    0x10(%esi),%edi
8010386d:	89 f2                	mov    %esi,%edx
8010386f:	31 c9                	xor    %ecx,%ecx
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103878:	0f b6 02             	movzbl (%edx),%eax
8010387b:	83 c2 01             	add    $0x1,%edx
8010387e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103880:	39 fa                	cmp    %edi,%edx
80103882:	75 f4                	jne    80103878 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103884:	84 c9                	test   %cl,%cl
80103886:	74 10                	je     80103898 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103888:	39 fb                	cmp    %edi,%ebx
8010388a:	89 fe                	mov    %edi,%esi
8010388c:	77 c2                	ja     80103850 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010388e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103891:	31 c0                	xor    %eax,%eax
}
80103893:	5b                   	pop    %ebx
80103894:	5e                   	pop    %esi
80103895:	5f                   	pop    %edi
80103896:	5d                   	pop    %ebp
80103897:	c3                   	ret    
80103898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010389b:	89 f0                	mov    %esi,%eax
8010389d:	5b                   	pop    %ebx
8010389e:	5e                   	pop    %esi
8010389f:	5f                   	pop    %edi
801038a0:	5d                   	pop    %ebp
801038a1:	c3                   	ret    
801038a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801038b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038c7:	c1 e0 08             	shl    $0x8,%eax
801038ca:	09 d0                	or     %edx,%eax
801038cc:	c1 e0 04             	shl    $0x4,%eax
801038cf:	85 c0                	test   %eax,%eax
801038d1:	75 1b                	jne    801038ee <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801038d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038e1:	c1 e0 08             	shl    $0x8,%eax
801038e4:	09 d0                	or     %edx,%eax
801038e6:	c1 e0 0a             	shl    $0xa,%eax
801038e9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801038ee:	ba 00 04 00 00       	mov    $0x400,%edx
801038f3:	e8 38 ff ff ff       	call   80103830 <mpsearch1>
801038f8:	85 c0                	test   %eax,%eax
801038fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038fd:	0f 84 37 01 00 00    	je     80103a3a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103906:	8b 58 04             	mov    0x4(%eax),%ebx
80103909:	85 db                	test   %ebx,%ebx
8010390b:	0f 84 43 01 00 00    	je     80103a54 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103911:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103917:	83 ec 04             	sub    $0x4,%esp
8010391a:	6a 04                	push   $0x4
8010391c:	68 dd 7e 10 80       	push   $0x80107edd
80103921:	56                   	push   %esi
80103922:	e8 e9 13 00 00       	call   80104d10 <memcmp>
80103927:	83 c4 10             	add    $0x10,%esp
8010392a:	85 c0                	test   %eax,%eax
8010392c:	0f 85 22 01 00 00    	jne    80103a54 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103932:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103939:	3c 01                	cmp    $0x1,%al
8010393b:	74 08                	je     80103945 <mpinit+0x95>
8010393d:	3c 04                	cmp    $0x4,%al
8010393f:	0f 85 0f 01 00 00    	jne    80103a54 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103945:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010394c:	85 ff                	test   %edi,%edi
8010394e:	74 21                	je     80103971 <mpinit+0xc1>
80103950:	31 d2                	xor    %edx,%edx
80103952:	31 c0                	xor    %eax,%eax
80103954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103958:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010395f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103960:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103963:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103965:	39 c7                	cmp    %eax,%edi
80103967:	75 ef                	jne    80103958 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103969:	84 d2                	test   %dl,%dl
8010396b:	0f 85 e3 00 00 00    	jne    80103a54 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103971:	85 f6                	test   %esi,%esi
80103973:	0f 84 db 00 00 00    	je     80103a54 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103979:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010397f:	a3 1c 38 11 80       	mov    %eax,0x8011381c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103984:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010398b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103991:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103996:	01 d6                	add    %edx,%esi
80103998:	90                   	nop
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039a0:	39 c6                	cmp    %eax,%esi
801039a2:	76 23                	jbe    801039c7 <mpinit+0x117>
801039a4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801039a7:	80 fa 04             	cmp    $0x4,%dl
801039aa:	0f 87 c0 00 00 00    	ja     80103a70 <mpinit+0x1c0>
801039b0:	ff 24 95 1c 7f 10 80 	jmp    *-0x7fef80e4(,%edx,4)
801039b7:	89 f6                	mov    %esi,%esi
801039b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039c0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039c3:	39 c6                	cmp    %eax,%esi
801039c5:	77 dd                	ja     801039a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801039c7:	85 db                	test   %ebx,%ebx
801039c9:	0f 84 92 00 00 00    	je     80103a61 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039d2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801039d6:	74 15                	je     801039ed <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039d8:	ba 22 00 00 00       	mov    $0x22,%edx
801039dd:	b8 70 00 00 00       	mov    $0x70,%eax
801039e2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039e3:	ba 23 00 00 00       	mov    $0x23,%edx
801039e8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039e9:	83 c8 01             	or     $0x1,%eax
801039ec:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801039ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039f0:	5b                   	pop    %ebx
801039f1:	5e                   	pop    %esi
801039f2:	5f                   	pop    %edi
801039f3:	5d                   	pop    %ebp
801039f4:	c3                   	ret    
801039f5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801039f8:	8b 0d a0 3e 11 80    	mov    0x80113ea0,%ecx
801039fe:	83 f9 07             	cmp    $0x7,%ecx
80103a01:	7f 19                	jg     80103a1c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a03:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103a07:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
80103a0d:	83 c1 01             	add    $0x1,%ecx
80103a10:	89 0d a0 3e 11 80    	mov    %ecx,0x80113ea0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a16:	88 97 20 39 11 80    	mov    %dl,-0x7feec6e0(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103a1c:	83 c0 14             	add    $0x14,%eax
      continue;
80103a1f:	e9 7c ff ff ff       	jmp    801039a0 <mpinit+0xf0>
80103a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103a28:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103a2c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103a2f:	88 15 00 39 11 80    	mov    %dl,0x80113900
      p += sizeof(struct mpioapic);
      continue;
80103a35:	e9 66 ff ff ff       	jmp    801039a0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103a3a:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a3f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a44:	e8 e7 fd ff ff       	call   80103830 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a49:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103a4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a4e:	0f 85 af fe ff ff    	jne    80103903 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103a54:	83 ec 0c             	sub    $0xc,%esp
80103a57:	68 e2 7e 10 80       	push   $0x80107ee2
80103a5c:	e8 0f c9 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103a61:	83 ec 0c             	sub    $0xc,%esp
80103a64:	68 fc 7e 10 80       	push   $0x80107efc
80103a69:	e8 02 c9 ff ff       	call   80100370 <panic>
80103a6e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103a70:	31 db                	xor    %ebx,%ebx
80103a72:	e9 30 ff ff ff       	jmp    801039a7 <mpinit+0xf7>
80103a77:	66 90                	xchg   %ax,%ax
80103a79:	66 90                	xchg   %ax,%ax
80103a7b:	66 90                	xchg   %ax,%ax
80103a7d:	66 90                	xchg   %ax,%ax
80103a7f:	90                   	nop

80103a80 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a80:	55                   	push   %ebp
80103a81:	ba 21 00 00 00       	mov    $0x21,%edx
80103a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a8b:	89 e5                	mov    %esp,%ebp
80103a8d:	ee                   	out    %al,(%dx)
80103a8e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a93:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a94:	5d                   	pop    %ebp
80103a95:	c3                   	ret    
80103a96:	66 90                	xchg   %ax,%ax
80103a98:	66 90                	xchg   %ax,%ax
80103a9a:	66 90                	xchg   %ax,%ax
80103a9c:	66 90                	xchg   %ax,%ax
80103a9e:	66 90                	xchg   %ax,%ax

80103aa0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 0c             	sub    $0xc,%esp
80103aa9:	8b 75 08             	mov    0x8(%ebp),%esi
80103aac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103aaf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ab5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103abb:	e8 a0 d2 ff ff       	call   80100d60 <filealloc>
80103ac0:	85 c0                	test   %eax,%eax
80103ac2:	89 06                	mov    %eax,(%esi)
80103ac4:	0f 84 a8 00 00 00    	je     80103b72 <pipealloc+0xd2>
80103aca:	e8 91 d2 ff ff       	call   80100d60 <filealloc>
80103acf:	85 c0                	test   %eax,%eax
80103ad1:	89 03                	mov    %eax,(%ebx)
80103ad3:	0f 84 87 00 00 00    	je     80103b60 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ad9:	e8 62 f2 ff ff       	call   80102d40 <kalloc>
80103ade:	85 c0                	test   %eax,%eax
80103ae0:	89 c7                	mov    %eax,%edi
80103ae2:	0f 84 b0 00 00 00    	je     80103b98 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ae8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
80103aeb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103af2:	00 00 00 
  p->writeopen = 1;
80103af5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103afc:	00 00 00 
  p->nwrite = 0;
80103aff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b06:	00 00 00 
  p->nread = 0;
80103b09:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b10:	00 00 00 
  initlock(&p->lock, "pipe");
80103b13:	68 30 7f 10 80       	push   $0x80107f30
80103b18:	50                   	push   %eax
80103b19:	e8 32 0f 00 00       	call   80104a50 <initlock>
  (*f0)->type = FD_PIPE;
80103b1e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b20:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103b23:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b29:	8b 06                	mov    (%esi),%eax
80103b2b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b2f:	8b 06                	mov    (%esi),%eax
80103b31:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b35:	8b 06                	mov    (%esi),%eax
80103b37:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b3a:	8b 03                	mov    (%ebx),%eax
80103b3c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b42:	8b 03                	mov    (%ebx),%eax
80103b44:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b48:	8b 03                	mov    (%ebx),%eax
80103b4a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b4e:	8b 03                	mov    (%ebx),%eax
80103b50:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b56:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b58:	5b                   	pop    %ebx
80103b59:	5e                   	pop    %esi
80103b5a:	5f                   	pop    %edi
80103b5b:	5d                   	pop    %ebp
80103b5c:	c3                   	ret    
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103b60:	8b 06                	mov    (%esi),%eax
80103b62:	85 c0                	test   %eax,%eax
80103b64:	74 1e                	je     80103b84 <pipealloc+0xe4>
    fileclose(*f0);
80103b66:	83 ec 0c             	sub    $0xc,%esp
80103b69:	50                   	push   %eax
80103b6a:	e8 b1 d2 ff ff       	call   80100e20 <fileclose>
80103b6f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b72:	8b 03                	mov    (%ebx),%eax
80103b74:	85 c0                	test   %eax,%eax
80103b76:	74 0c                	je     80103b84 <pipealloc+0xe4>
    fileclose(*f1);
80103b78:	83 ec 0c             	sub    $0xc,%esp
80103b7b:	50                   	push   %eax
80103b7c:	e8 9f d2 ff ff       	call   80100e20 <fileclose>
80103b81:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103b84:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b8c:	5b                   	pop    %ebx
80103b8d:	5e                   	pop    %esi
80103b8e:	5f                   	pop    %edi
80103b8f:	5d                   	pop    %ebp
80103b90:	c3                   	ret    
80103b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103b98:	8b 06                	mov    (%esi),%eax
80103b9a:	85 c0                	test   %eax,%eax
80103b9c:	75 c8                	jne    80103b66 <pipealloc+0xc6>
80103b9e:	eb d2                	jmp    80103b72 <pipealloc+0xd2>

80103ba0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
80103ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103bab:	83 ec 0c             	sub    $0xc,%esp
80103bae:	53                   	push   %ebx
80103baf:	e8 9c 0f 00 00       	call   80104b50 <acquire>
  if(writable){
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	85 f6                	test   %esi,%esi
80103bb9:	74 45                	je     80103c00 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bbb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bc1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103bc4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103bcb:	00 00 00 
    wakeup(&p->nread);
80103bce:	50                   	push   %eax
80103bcf:	e8 bc 0b 00 00       	call   80104790 <wakeup>
80103bd4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103bd7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103bdd:	85 d2                	test   %edx,%edx
80103bdf:	75 0a                	jne    80103beb <pipeclose+0x4b>
80103be1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103be7:	85 c0                	test   %eax,%eax
80103be9:	74 35                	je     80103c20 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103beb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103bee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf1:	5b                   	pop    %ebx
80103bf2:	5e                   	pop    %esi
80103bf3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103bf4:	e9 77 10 00 00       	jmp    80104c70 <release>
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103c00:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103c06:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103c09:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c10:	00 00 00 
    wakeup(&p->nwrite);
80103c13:	50                   	push   %eax
80103c14:	e8 77 0b 00 00       	call   80104790 <wakeup>
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	eb b9                	jmp    80103bd7 <pipeclose+0x37>
80103c1e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	53                   	push   %ebx
80103c24:	e8 47 10 00 00       	call   80104c70 <release>
    kfree((char*)p);
80103c29:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c2c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
80103c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c32:	5b                   	pop    %ebx
80103c33:	5e                   	pop    %esi
80103c34:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103c35:	e9 56 ef ff ff       	jmp    80102b90 <kfree>
80103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c40 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 28             	sub    $0x28,%esp
80103c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c4c:	53                   	push   %ebx
80103c4d:	e8 fe 0e 00 00       	call   80104b50 <acquire>
  for(i = 0; i < n; i++){
80103c52:	8b 45 10             	mov    0x10(%ebp),%eax
80103c55:	83 c4 10             	add    $0x10,%esp
80103c58:	85 c0                	test   %eax,%eax
80103c5a:	0f 8e b9 00 00 00    	jle    80103d19 <pipewrite+0xd9>
80103c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c63:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c69:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c6f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103c75:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103c78:	03 4d 10             	add    0x10(%ebp),%ecx
80103c7b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c7e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103c84:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103c8a:	39 d0                	cmp    %edx,%eax
80103c8c:	74 38                	je     80103cc6 <pipewrite+0x86>
80103c8e:	eb 59                	jmp    80103ce9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103c90:	e8 9b 03 00 00       	call   80104030 <myproc>
80103c95:	8b 48 24             	mov    0x24(%eax),%ecx
80103c98:	85 c9                	test   %ecx,%ecx
80103c9a:	75 34                	jne    80103cd0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c9c:	83 ec 0c             	sub    $0xc,%esp
80103c9f:	57                   	push   %edi
80103ca0:	e8 eb 0a 00 00       	call   80104790 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	53                   	push   %ebx
80103ca8:	56                   	push   %esi
80103ca9:	e8 32 09 00 00       	call   801045e0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cae:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cb4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103cba:	83 c4 10             	add    $0x10,%esp
80103cbd:	05 00 02 00 00       	add    $0x200,%eax
80103cc2:	39 c2                	cmp    %eax,%edx
80103cc4:	75 2a                	jne    80103cf0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103cc6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ccc:	85 c0                	test   %eax,%eax
80103cce:	75 c0                	jne    80103c90 <pipewrite+0x50>
        release(&p->lock);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	53                   	push   %ebx
80103cd4:	e8 97 0f 00 00       	call   80104c70 <release>
        return -1;
80103cd9:	83 c4 10             	add    $0x10,%esp
80103cdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ce4:	5b                   	pop    %ebx
80103ce5:	5e                   	pop    %esi
80103ce6:	5f                   	pop    %edi
80103ce7:	5d                   	pop    %ebp
80103ce8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ce9:	89 c2                	mov    %eax,%edx
80103ceb:	90                   	nop
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103cf0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cf3:	8d 42 01             	lea    0x1(%edx),%eax
80103cf6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103cfa:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d00:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103d06:	0f b6 09             	movzbl (%ecx),%ecx
80103d09:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103d10:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103d13:	0f 85 65 ff ff ff    	jne    80103c7e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d19:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d1f:	83 ec 0c             	sub    $0xc,%esp
80103d22:	50                   	push   %eax
80103d23:	e8 68 0a 00 00       	call   80104790 <wakeup>
  release(&p->lock);
80103d28:	89 1c 24             	mov    %ebx,(%esp)
80103d2b:	e8 40 0f 00 00       	call   80104c70 <release>
  return n;
80103d30:	83 c4 10             	add    $0x10,%esp
80103d33:	8b 45 10             	mov    0x10(%ebp),%eax
80103d36:	eb a9                	jmp    80103ce1 <pipewrite+0xa1>
80103d38:	90                   	nop
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d40 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 18             	sub    $0x18,%esp
80103d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d4f:	53                   	push   %ebx
80103d50:	e8 fb 0d 00 00       	call   80104b50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d55:	83 c4 10             	add    $0x10,%esp
80103d58:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103d5e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103d64:	75 6a                	jne    80103dd0 <piperead+0x90>
80103d66:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80103d6c:	85 f6                	test   %esi,%esi
80103d6e:	0f 84 cc 00 00 00    	je     80103e40 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d74:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103d7a:	eb 2d                	jmp    80103da9 <piperead+0x69>
80103d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d80:	83 ec 08             	sub    $0x8,%esp
80103d83:	53                   	push   %ebx
80103d84:	56                   	push   %esi
80103d85:	e8 56 08 00 00       	call   801045e0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d8a:	83 c4 10             	add    $0x10,%esp
80103d8d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103d93:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103d99:	75 35                	jne    80103dd0 <piperead+0x90>
80103d9b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103da1:	85 d2                	test   %edx,%edx
80103da3:	0f 84 97 00 00 00    	je     80103e40 <piperead+0x100>
    if(myproc()->killed){
80103da9:	e8 82 02 00 00       	call   80104030 <myproc>
80103dae:	8b 48 24             	mov    0x24(%eax),%ecx
80103db1:	85 c9                	test   %ecx,%ecx
80103db3:	74 cb                	je     80103d80 <piperead+0x40>
      release(&p->lock);
80103db5:	83 ec 0c             	sub    $0xc,%esp
80103db8:	53                   	push   %ebx
80103db9:	e8 b2 0e 00 00       	call   80104c70 <release>
      return -1;
80103dbe:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103dc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103dc9:	5b                   	pop    %ebx
80103dca:	5e                   	pop    %esi
80103dcb:	5f                   	pop    %edi
80103dcc:	5d                   	pop    %ebp
80103dcd:	c3                   	ret    
80103dce:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103dd0:	8b 45 10             	mov    0x10(%ebp),%eax
80103dd3:	85 c0                	test   %eax,%eax
80103dd5:	7e 69                	jle    80103e40 <piperead+0x100>
    if(p->nread == p->nwrite)
80103dd7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103ddd:	31 c9                	xor    %ecx,%ecx
80103ddf:	eb 15                	jmp    80103df6 <piperead+0xb6>
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103de8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103dee:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103df4:	74 5a                	je     80103e50 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103df6:	8d 70 01             	lea    0x1(%eax),%esi
80103df9:	25 ff 01 00 00       	and    $0x1ff,%eax
80103dfe:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103e04:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103e09:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e0c:	83 c1 01             	add    $0x1,%ecx
80103e0f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103e12:	75 d4                	jne    80103de8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e14:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	50                   	push   %eax
80103e1e:	e8 6d 09 00 00       	call   80104790 <wakeup>
  release(&p->lock);
80103e23:	89 1c 24             	mov    %ebx,(%esp)
80103e26:	e8 45 0e 00 00       	call   80104c70 <release>
  return i;
80103e2b:	8b 45 10             	mov    0x10(%ebp),%eax
80103e2e:	83 c4 10             	add    $0x10,%esp
}
80103e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e34:	5b                   	pop    %ebx
80103e35:	5e                   	pop    %esi
80103e36:	5f                   	pop    %edi
80103e37:	5d                   	pop    %ebp
80103e38:	c3                   	ret    
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e40:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103e47:	eb cb                	jmp    80103e14 <piperead+0xd4>
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e50:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103e53:	eb bf                	jmp    80103e14 <piperead+0xd4>
80103e55:	66 90                	xchg   %ax,%ax
80103e57:	66 90                	xchg   %ax,%ax
80103e59:	66 90                	xchg   %ax,%ax
80103e5b:	66 90                	xchg   %ax,%ax
80103e5d:	66 90                	xchg   %ax,%ax
80103e5f:	90                   	nop

80103e60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e64:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e69:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103e6c:	68 c0 3e 11 80       	push   $0x80113ec0
80103e71:	e8 da 0c 00 00       	call   80104b50 <acquire>
80103e76:	83 c4 10             	add    $0x10,%esp
80103e79:	eb 10                	jmp    80103e8b <allocproc+0x2b>
80103e7b:	90                   	nop
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e80:	83 c3 7c             	add    $0x7c,%ebx
80103e83:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80103e89:	74 75                	je     80103f00 <allocproc+0xa0>
    if(p->state == UNUSED)
80103e8b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e8e:	85 c0                	test   %eax,%eax
80103e90:	75 ee                	jne    80103e80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e92:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103e97:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103e9a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103ea1:	68 c0 3e 11 80       	push   $0x80113ec0
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ea6:	8d 50 01             	lea    0x1(%eax),%edx
80103ea9:	89 43 10             	mov    %eax,0x10(%ebx)
80103eac:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  release(&ptable.lock);
80103eb2:	e8 b9 0d 00 00       	call   80104c70 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103eb7:	e8 84 ee ff ff       	call   80102d40 <kalloc>
80103ebc:	83 c4 10             	add    $0x10,%esp
80103ebf:	85 c0                	test   %eax,%eax
80103ec1:	89 43 08             	mov    %eax,0x8(%ebx)
80103ec4:	74 51                	je     80103f17 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ec6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ecc:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103ecf:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ed4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103ed7:	c7 40 14 52 61 10 80 	movl   $0x80106152,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ede:	6a 14                	push   $0x14
80103ee0:	6a 00                	push   $0x0
80103ee2:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103ee3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ee6:	e8 d5 0d 00 00       	call   80104cc0 <memset>
  p->context->eip = (uint)forkret;
80103eeb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103eee:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103ef1:	c7 40 10 20 3f 10 80 	movl   $0x80103f20,0x10(%eax)

  return p;
80103ef8:	89 d8                	mov    %ebx,%eax
}
80103efa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103efd:	c9                   	leave  
80103efe:	c3                   	ret    
80103eff:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103f00:	83 ec 0c             	sub    $0xc,%esp
80103f03:	68 c0 3e 11 80       	push   $0x80113ec0
80103f08:	e8 63 0d 00 00       	call   80104c70 <release>
  return 0;
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f15:	c9                   	leave  
80103f16:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103f17:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103f1e:	eb da                	jmp    80103efa <allocproc+0x9a>

80103f20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103f26:	68 c0 3e 11 80       	push   $0x80113ec0
80103f2b:	e8 40 0d 00 00       	call   80104c70 <release>

  if (first) {
80103f30:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103f35:	83 c4 10             	add    $0x10,%esp
80103f38:	85 c0                	test   %eax,%eax
80103f3a:	75 04                	jne    80103f40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f3c:	c9                   	leave  
80103f3d:	c3                   	ret    
80103f3e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103f40:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103f43:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103f4a:	00 00 00 
    iinit(ROOTDEV);
80103f4d:	6a 01                	push   $0x1
80103f4f:	e8 1c d6 ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103f54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f5b:	e8 00 f4 ff ff       	call   80103360 <initlog>
80103f60:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f63:	c9                   	leave  
80103f64:	c3                   	ret    
80103f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f76:	68 35 7f 10 80       	push   $0x80107f35
80103f7b:	68 c0 3e 11 80       	push   $0x80113ec0
80103f80:	e8 cb 0a 00 00       	call   80104a50 <initlock>
}
80103f85:	83 c4 10             	add    $0x10,%esp
80103f88:	c9                   	leave  
80103f89:	c3                   	ret    
80103f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f90 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f95:	9c                   	pushf  
80103f96:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103f97:	f6 c4 02             	test   $0x2,%ah
80103f9a:	75 5b                	jne    80103ff7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103f9c:	e8 ff ef ff ff       	call   80102fa0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103fa1:	8b 35 a0 3e 11 80    	mov    0x80113ea0,%esi
80103fa7:	85 f6                	test   %esi,%esi
80103fa9:	7e 3f                	jle    80103fea <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103fab:	0f b6 15 20 39 11 80 	movzbl 0x80113920,%edx
80103fb2:	39 d0                	cmp    %edx,%eax
80103fb4:	74 30                	je     80103fe6 <mycpu+0x56>
80103fb6:	b9 d0 39 11 80       	mov    $0x801139d0,%ecx
80103fbb:	31 d2                	xor    %edx,%edx
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103fc0:	83 c2 01             	add    $0x1,%edx
80103fc3:	39 f2                	cmp    %esi,%edx
80103fc5:	74 23                	je     80103fea <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103fc7:	0f b6 19             	movzbl (%ecx),%ebx
80103fca:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103fd0:	39 d8                	cmp    %ebx,%eax
80103fd2:	75 ec                	jne    80103fc0 <mycpu+0x30>
      return &cpus[i];
80103fd4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103fda:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fdd:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103fde:	05 20 39 11 80       	add    $0x80113920,%eax
  }
  panic("unknown apicid\n");
}
80103fe3:	5e                   	pop    %esi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103fe6:	31 d2                	xor    %edx,%edx
80103fe8:	eb ea                	jmp    80103fd4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 3c 7f 10 80       	push   $0x80107f3c
80103ff2:	e8 79 c3 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103ff7:	83 ec 0c             	sub    $0xc,%esp
80103ffa:	68 18 80 10 80       	push   $0x80108018
80103fff:	e8 6c c3 ff ff       	call   80100370 <panic>
80104004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010400a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104010 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104016:	e8 75 ff ff ff       	call   80103f90 <mycpu>
8010401b:	2d 20 39 11 80       	sub    $0x80113920,%eax
}
80104020:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80104021:	c1 f8 04             	sar    $0x4,%eax
80104024:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010402a:	c3                   	ret    
8010402b:	90                   	nop
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104030 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	53                   	push   %ebx
80104034:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104037:	e8 d4 0a 00 00       	call   80104b10 <pushcli>
  c = mycpu();
8010403c:	e8 4f ff ff ff       	call   80103f90 <mycpu>
  p = c->proc;
80104041:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104047:	e8 b4 0b 00 00       	call   80104c00 <popcli>
  return p;
}
8010404c:	83 c4 04             	add    $0x4,%esp
8010404f:	89 d8                	mov    %ebx,%eax
80104051:	5b                   	pop    %ebx
80104052:	5d                   	pop    %ebp
80104053:	c3                   	ret    
80104054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010405a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104060 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104067:	e8 f4 fd ff ff       	call   80103e60 <allocproc>
8010406c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010406e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104073:	e8 c8 36 00 00       	call   80107740 <setupkvm>
80104078:	85 c0                	test   %eax,%eax
8010407a:	89 43 04             	mov    %eax,0x4(%ebx)
8010407d:	0f 84 bf 00 00 00    	je     80104142 <userinit+0xe2>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104083:	83 ec 04             	sub    $0x4,%esp
80104086:	68 2c 00 00 00       	push   $0x2c
8010408b:	68 60 b4 10 80       	push   $0x8010b460
80104090:	50                   	push   %eax
80104091:	e8 ba 33 00 00       	call   80107450 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80104096:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80104099:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010409f:	6a 4c                	push   $0x4c
801040a1:	6a 00                	push   $0x0
801040a3:	ff 73 18             	pushl  0x18(%ebx)
801040a6:	e8 15 0c 00 00       	call   80104cc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040ab:	8b 43 18             	mov    0x18(%ebx),%eax
801040ae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040b3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801040b8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040bb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040bf:	8b 43 18             	mov    0x18(%ebx),%eax
801040c2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040c6:	8b 43 18             	mov    0x18(%ebx),%eax
801040c9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040cd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040d1:	8b 43 18             	mov    0x18(%ebx),%eax
801040d4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040d8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040dc:	8b 43 18             	mov    0x18(%ebx),%eax
801040df:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801040e6:	8b 43 18             	mov    0x18(%ebx),%eax
801040e9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801040f0:	8b 43 18             	mov    0x18(%ebx),%eax
801040f3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801040fa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040fd:	6a 10                	push   $0x10
801040ff:	68 65 7f 10 80       	push   $0x80107f65
80104104:	50                   	push   %eax
80104105:	e8 b6 0d 00 00       	call   80104ec0 <safestrcpy>
  p->cwd = namei("/",0);
8010410a:	58                   	pop    %eax
8010410b:	5a                   	pop    %edx
8010410c:	6a 00                	push   $0x0
8010410e:	68 6e 7f 10 80       	push   $0x80107f6e
80104113:	e8 18 e1 ff ff       	call   80102230 <namei>
80104118:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010411b:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104122:	e8 29 0a 00 00       	call   80104b50 <acquire>

  p->state = RUNNABLE;
80104127:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010412e:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104135:	e8 36 0b 00 00       	call   80104c70 <release>
}
8010413a:	83 c4 10             	add    $0x10,%esp
8010413d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104140:	c9                   	leave  
80104141:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80104142:	83 ec 0c             	sub    $0xc,%esp
80104145:	68 4c 7f 10 80       	push   $0x80107f4c
8010414a:	e8 21 c2 ff ff       	call   80100370 <panic>
8010414f:	90                   	nop

80104150 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
80104155:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104158:	e8 b3 09 00 00       	call   80104b10 <pushcli>
  c = mycpu();
8010415d:	e8 2e fe ff ff       	call   80103f90 <mycpu>
  p = c->proc;
80104162:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104168:	e8 93 0a 00 00       	call   80104c00 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010416d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80104170:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104172:	7e 34                	jle    801041a8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104174:	83 ec 04             	sub    $0x4,%esp
80104177:	01 c6                	add    %eax,%esi
80104179:	56                   	push   %esi
8010417a:	50                   	push   %eax
8010417b:	ff 73 04             	pushl  0x4(%ebx)
8010417e:	e8 0d 34 00 00       	call   80107590 <allocuvm>
80104183:	83 c4 10             	add    $0x10,%esp
80104186:	85 c0                	test   %eax,%eax
80104188:	74 36                	je     801041c0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010418a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010418d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010418f:	53                   	push   %ebx
80104190:	e8 ab 31 00 00       	call   80107340 <switchuvm>
  return 0;
80104195:	83 c4 10             	add    $0x10,%esp
80104198:	31 c0                	xor    %eax,%eax
}
8010419a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010419d:	5b                   	pop    %ebx
8010419e:	5e                   	pop    %esi
8010419f:	5d                   	pop    %ebp
801041a0:	c3                   	ret    
801041a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801041a8:	74 e0                	je     8010418a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041aa:	83 ec 04             	sub    $0x4,%esp
801041ad:	01 c6                	add    %eax,%esi
801041af:	56                   	push   %esi
801041b0:	50                   	push   %eax
801041b1:	ff 73 04             	pushl  0x4(%ebx)
801041b4:	e8 d7 34 00 00       	call   80107690 <deallocuvm>
801041b9:	83 c4 10             	add    $0x10,%esp
801041bc:	85 c0                	test   %eax,%eax
801041be:	75 ca                	jne    8010418a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801041c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041c5:	eb d3                	jmp    8010419a <growproc+0x4a>
801041c7:	89 f6                	mov    %esi,%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041d0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041d9:	e8 32 09 00 00       	call   80104b10 <pushcli>
  c = mycpu();
801041de:	e8 ad fd ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801041e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041e9:	e8 12 0a 00 00       	call   80104c00 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
801041ee:	e8 6d fc ff ff       	call   80103e60 <allocproc>
801041f3:	85 c0                	test   %eax,%eax
801041f5:	89 c7                	mov    %eax,%edi
801041f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801041fa:	0f 84 b5 00 00 00    	je     801042b5 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104200:	83 ec 08             	sub    $0x8,%esp
80104203:	ff 33                	pushl  (%ebx)
80104205:	ff 73 04             	pushl  0x4(%ebx)
80104208:	e8 03 36 00 00       	call   80107810 <copyuvm>
8010420d:	83 c4 10             	add    $0x10,%esp
80104210:	85 c0                	test   %eax,%eax
80104212:	89 47 04             	mov    %eax,0x4(%edi)
80104215:	0f 84 a1 00 00 00    	je     801042bc <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010421b:	8b 03                	mov    (%ebx),%eax
8010421d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104220:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80104222:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104225:	89 c8                	mov    %ecx,%eax
80104227:	8b 79 18             	mov    0x18(%ecx),%edi
8010422a:	8b 73 18             	mov    0x18(%ebx),%esi
8010422d:	b9 13 00 00 00       	mov    $0x13,%ecx
80104232:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104234:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104236:	8b 40 18             	mov    0x18(%eax),%eax
80104239:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80104240:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104244:	85 c0                	test   %eax,%eax
80104246:	74 13                	je     8010425b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	50                   	push   %eax
8010424c:	e8 7f cb ff ff       	call   80100dd0 <filedup>
80104251:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104254:	83 c4 10             	add    $0x10,%esp
80104257:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010425b:	83 c6 01             	add    $0x1,%esi
8010425e:	83 fe 10             	cmp    $0x10,%esi
80104261:	75 dd                	jne    80104240 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104269:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010426c:	e8 df d4 ff ff       	call   80101750 <idup>
80104271:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104274:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80104277:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010427a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010427d:	6a 10                	push   $0x10
8010427f:	53                   	push   %ebx
80104280:	50                   	push   %eax
80104281:	e8 3a 0c 00 00       	call   80104ec0 <safestrcpy>

  pid = np->pid;
80104286:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80104289:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104290:	e8 bb 08 00 00       	call   80104b50 <acquire>

  np->state = RUNNABLE;
80104295:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
8010429c:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
801042a3:	e8 c8 09 00 00       	call   80104c70 <release>

  return pid;
801042a8:	83 c4 10             	add    $0x10,%esp
801042ab:	89 d8                	mov    %ebx,%eax
}
801042ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b0:	5b                   	pop    %ebx
801042b1:	5e                   	pop    %esi
801042b2:	5f                   	pop    %edi
801042b3:	5d                   	pop    %ebp
801042b4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801042b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042ba:	eb f1                	jmp    801042ad <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
801042bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801042bf:	83 ec 0c             	sub    $0xc,%esp
801042c2:	ff 77 08             	pushl  0x8(%edi)
801042c5:	e8 c6 e8 ff ff       	call   80102b90 <kfree>
    np->kstack = 0;
801042ca:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
801042d1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042e0:	eb cb                	jmp    801042ad <fork+0xdd>
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042f0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801042f9:	e8 92 fc ff ff       	call   80103f90 <mycpu>
801042fe:	8d 78 04             	lea    0x4(%eax),%edi
80104301:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104303:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010430a:	00 00 00 
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80104310:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104311:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104314:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104319:	68 c0 3e 11 80       	push   $0x80113ec0
8010431e:	e8 2d 08 00 00       	call   80104b50 <acquire>
80104323:	83 c4 10             	add    $0x10,%esp
80104326:	eb 13                	jmp    8010433b <scheduler+0x4b>
80104328:	90                   	nop
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104330:	83 c3 7c             	add    $0x7c,%ebx
80104333:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80104339:	74 45                	je     80104380 <scheduler+0x90>
      if(p->state != RUNNABLE)
8010433b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010433f:	75 ef                	jne    80104330 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80104341:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104344:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010434a:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010434b:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
8010434e:	e8 ed 2f 00 00       	call   80107340 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80104353:	58                   	pop    %eax
80104354:	5a                   	pop    %edx
80104355:	ff 73 a0             	pushl  -0x60(%ebx)
80104358:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80104359:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80104360:	e8 b6 0b 00 00       	call   80104f1b <swtch>
      switchkvm();
80104365:	e8 b6 2f 00 00       	call   80107320 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010436a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010436d:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104373:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010437a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010437d:	75 bc                	jne    8010433b <scheduler+0x4b>
8010437f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104380:	83 ec 0c             	sub    $0xc,%esp
80104383:	68 c0 3e 11 80       	push   $0x80113ec0
80104388:	e8 e3 08 00 00       	call   80104c70 <release>

  }
8010438d:	83 c4 10             	add    $0x10,%esp
80104390:	e9 7b ff ff ff       	jmp    80104310 <scheduler+0x20>
80104395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043a5:	e8 66 07 00 00       	call   80104b10 <pushcli>
  c = mycpu();
801043aa:	e8 e1 fb ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801043af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043b5:	e8 46 08 00 00       	call   80104c00 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 c0 3e 11 80       	push   $0x80113ec0
801043c2:	e8 09 07 00 00       	call   80104ad0 <holding>
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	85 c0                	test   %eax,%eax
801043cc:	74 4f                	je     8010441d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
801043ce:	e8 bd fb ff ff       	call   80103f90 <mycpu>
801043d3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801043da:	75 68                	jne    80104444 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
801043dc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801043e0:	74 55                	je     80104437 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e2:	9c                   	pushf  
801043e3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
801043e4:	f6 c4 02             	test   $0x2,%ah
801043e7:	75 41                	jne    8010442a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
801043e9:	e8 a2 fb ff ff       	call   80103f90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801043ee:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
801043f1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801043f7:	e8 94 fb ff ff       	call   80103f90 <mycpu>
801043fc:	83 ec 08             	sub    $0x8,%esp
801043ff:	ff 70 04             	pushl  0x4(%eax)
80104402:	53                   	push   %ebx
80104403:	e8 13 0b 00 00       	call   80104f1b <swtch>
  mycpu()->intena = intena;
80104408:	e8 83 fb ff ff       	call   80103f90 <mycpu>
}
8010440d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104410:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104416:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104419:	5b                   	pop    %ebx
8010441a:	5e                   	pop    %esi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010441d:	83 ec 0c             	sub    $0xc,%esp
80104420:	68 70 7f 10 80       	push   $0x80107f70
80104425:	e8 46 bf ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010442a:	83 ec 0c             	sub    $0xc,%esp
8010442d:	68 9c 7f 10 80       	push   $0x80107f9c
80104432:	e8 39 bf ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80104437:	83 ec 0c             	sub    $0xc,%esp
8010443a:	68 8e 7f 10 80       	push   $0x80107f8e
8010443f:	e8 2c bf ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	68 82 7f 10 80       	push   $0x80107f82
8010444c:	e8 1f bf ff ff       	call   80100370 <panic>
80104451:	eb 0d                	jmp    80104460 <exit>
80104453:	90                   	nop
80104454:	90                   	nop
80104455:	90                   	nop
80104456:	90                   	nop
80104457:	90                   	nop
80104458:	90                   	nop
80104459:	90                   	nop
8010445a:	90                   	nop
8010445b:	90                   	nop
8010445c:	90                   	nop
8010445d:	90                   	nop
8010445e:	90                   	nop
8010445f:	90                   	nop

80104460 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104469:	e8 a2 06 00 00       	call   80104b10 <pushcli>
  c = mycpu();
8010446e:	e8 1d fb ff ff       	call   80103f90 <mycpu>
  p = c->proc;
80104473:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104479:	e8 82 07 00 00       	call   80104c00 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010447e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104484:	8d 5e 28             	lea    0x28(%esi),%ebx
80104487:	8d 7e 68             	lea    0x68(%esi),%edi
8010448a:	0f 84 e7 00 00 00    	je     80104577 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104490:	8b 03                	mov    (%ebx),%eax
80104492:	85 c0                	test   %eax,%eax
80104494:	74 12                	je     801044a8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	50                   	push   %eax
8010449a:	e8 81 c9 ff ff       	call   80100e20 <fileclose>
      curproc->ofile[fd] = 0;
8010449f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801044a5:	83 c4 10             	add    $0x10,%esp
801044a8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044ab:	39 df                	cmp    %ebx,%edi
801044ad:	75 e1                	jne    80104490 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801044af:	e8 4c ef ff ff       	call   80103400 <begin_op>
  iput(curproc->cwd);
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	ff 76 68             	pushl  0x68(%esi)
801044ba:	e8 f1 d3 ff ff       	call   801018b0 <iput>
  end_op();
801044bf:	e8 ac ef ff ff       	call   80103470 <end_op>
  curproc->cwd = 0;
801044c4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
801044cb:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
801044d2:	e8 79 06 00 00       	call   80104b50 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801044d7:	8b 56 14             	mov    0x14(%esi),%edx
801044da:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044dd:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
801044e2:	eb 0e                	jmp    801044f2 <exit+0x92>
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	83 c0 7c             	add    $0x7c,%eax
801044eb:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
801044f0:	74 1c                	je     8010450e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
801044f2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044f6:	75 f0                	jne    801044e8 <exit+0x88>
801044f8:	3b 50 20             	cmp    0x20(%eax),%edx
801044fb:	75 eb                	jne    801044e8 <exit+0x88>
      p->state = RUNNABLE;
801044fd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104504:	83 c0 7c             	add    $0x7c,%eax
80104507:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
8010450c:	75 e4                	jne    801044f2 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
8010450e:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104514:	ba f4 3e 11 80       	mov    $0x80113ef4,%edx
80104519:	eb 10                	jmp    8010452b <exit+0xcb>
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104520:	83 c2 7c             	add    $0x7c,%edx
80104523:	81 fa f4 5d 11 80    	cmp    $0x80115df4,%edx
80104529:	74 33                	je     8010455e <exit+0xfe>
    if(p->parent == curproc){
8010452b:	39 72 14             	cmp    %esi,0x14(%edx)
8010452e:	75 f0                	jne    80104520 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104530:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104534:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104537:	75 e7                	jne    80104520 <exit+0xc0>
80104539:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
8010453e:	eb 0a                	jmp    8010454a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104540:	83 c0 7c             	add    $0x7c,%eax
80104543:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104548:	74 d6                	je     80104520 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010454a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010454e:	75 f0                	jne    80104540 <exit+0xe0>
80104550:	3b 48 20             	cmp    0x20(%eax),%ecx
80104553:	75 eb                	jne    80104540 <exit+0xe0>
      p->state = RUNNABLE;
80104555:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010455c:	eb e2                	jmp    80104540 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010455e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104565:	e8 36 fe ff ff       	call   801043a0 <sched>
  panic("zombie exit");
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 bd 7f 10 80       	push   $0x80107fbd
80104572:	e8 f9 bd ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	68 b0 7f 10 80       	push   $0x80107fb0
8010457f:	e8 ec bd ff ff       	call   80100370 <panic>
80104584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010458a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104590 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104597:	68 c0 3e 11 80       	push   $0x80113ec0
8010459c:	e8 af 05 00 00       	call   80104b50 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801045a1:	e8 6a 05 00 00       	call   80104b10 <pushcli>
  c = mycpu();
801045a6:	e8 e5 f9 ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801045ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045b1:	e8 4a 06 00 00       	call   80104c00 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
801045b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801045bd:	e8 de fd ff ff       	call   801043a0 <sched>
  release(&ptable.lock);
801045c2:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
801045c9:	e8 a2 06 00 00       	call   80104c70 <release>
}
801045ce:	83 c4 10             	add    $0x10,%esp
801045d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d4:	c9                   	leave  
801045d5:	c3                   	ret    
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	83 ec 0c             	sub    $0xc,%esp
801045e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045ec:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801045ef:	e8 1c 05 00 00       	call   80104b10 <pushcli>
  c = mycpu();
801045f4:	e8 97 f9 ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801045f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045ff:	e8 fc 05 00 00       	call   80104c00 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104604:	85 db                	test   %ebx,%ebx
80104606:	0f 84 87 00 00 00    	je     80104693 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010460c:	85 f6                	test   %esi,%esi
8010460e:	74 76                	je     80104686 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104610:	81 fe c0 3e 11 80    	cmp    $0x80113ec0,%esi
80104616:	74 50                	je     80104668 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	68 c0 3e 11 80       	push   $0x80113ec0
80104620:	e8 2b 05 00 00       	call   80104b50 <acquire>
    release(lk);
80104625:	89 34 24             	mov    %esi,(%esp)
80104628:	e8 43 06 00 00       	call   80104c70 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010462d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104630:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104637:	e8 64 fd ff ff       	call   801043a0 <sched>

  // Tidy up.
  p->chan = 0;
8010463c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104643:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
8010464a:	e8 21 06 00 00       	call   80104c70 <release>
    acquire(lk);
8010464f:	89 75 08             	mov    %esi,0x8(%ebp)
80104652:	83 c4 10             	add    $0x10,%esp
  }
}
80104655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104658:	5b                   	pop    %ebx
80104659:	5e                   	pop    %esi
8010465a:	5f                   	pop    %edi
8010465b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010465c:	e9 ef 04 00 00       	jmp    80104b50 <acquire>
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104668:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010466b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104672:	e8 29 fd ff ff       	call   801043a0 <sched>

  // Tidy up.
  p->chan = 0;
80104677:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010467e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104681:	5b                   	pop    %ebx
80104682:	5e                   	pop    %esi
80104683:	5f                   	pop    %edi
80104684:	5d                   	pop    %ebp
80104685:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104686:	83 ec 0c             	sub    $0xc,%esp
80104689:	68 cf 7f 10 80       	push   $0x80107fcf
8010468e:	e8 dd bc ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104693:	83 ec 0c             	sub    $0xc,%esp
80104696:	68 c9 7f 10 80       	push   $0x80107fc9
8010469b:	e8 d0 bc ff ff       	call   80100370 <panic>

801046a0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801046a5:	e8 66 04 00 00       	call   80104b10 <pushcli>
  c = mycpu();
801046aa:	e8 e1 f8 ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801046af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046b5:	e8 46 05 00 00       	call   80104c00 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
801046ba:	83 ec 0c             	sub    $0xc,%esp
801046bd:	68 c0 3e 11 80       	push   $0x80113ec0
801046c2:	e8 89 04 00 00       	call   80104b50 <acquire>
801046c7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801046ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046cc:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
801046d1:	eb 10                	jmp    801046e3 <wait+0x43>
801046d3:	90                   	nop
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d8:	83 c3 7c             	add    $0x7c,%ebx
801046db:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
801046e1:	74 1d                	je     80104700 <wait+0x60>
      if(p->parent != curproc)
801046e3:	39 73 14             	cmp    %esi,0x14(%ebx)
801046e6:	75 f0                	jne    801046d8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801046e8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801046ec:	74 30                	je     8010471e <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ee:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
801046f1:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f6:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
801046fc:	75 e5                	jne    801046e3 <wait+0x43>
801046fe:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104700:	85 c0                	test   %eax,%eax
80104702:	74 70                	je     80104774 <wait+0xd4>
80104704:	8b 46 24             	mov    0x24(%esi),%eax
80104707:	85 c0                	test   %eax,%eax
80104709:	75 69                	jne    80104774 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010470b:	83 ec 08             	sub    $0x8,%esp
8010470e:	68 c0 3e 11 80       	push   $0x80113ec0
80104713:	56                   	push   %esi
80104714:	e8 c7 fe ff ff       	call   801045e0 <sleep>
  }
80104719:	83 c4 10             	add    $0x10,%esp
8010471c:	eb ac                	jmp    801046ca <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
8010471e:	83 ec 0c             	sub    $0xc,%esp
80104721:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80104724:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104727:	e8 64 e4 ff ff       	call   80102b90 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
8010472c:	5a                   	pop    %edx
8010472d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104730:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104737:	e8 84 2f 00 00       	call   801076c0 <freevm>
        p->pid = 0;
8010473c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104743:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010474a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010474e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104755:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010475c:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104763:	e8 08 05 00 00       	call   80104c70 <release>
        return pid;
80104768:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010476b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
8010476e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104770:	5b                   	pop    %ebx
80104771:	5e                   	pop    %esi
80104772:	5d                   	pop    %ebp
80104773:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80104774:	83 ec 0c             	sub    $0xc,%esp
80104777:	68 c0 3e 11 80       	push   $0x80113ec0
8010477c:	e8 ef 04 00 00       	call   80104c70 <release>
      return -1;
80104781:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104784:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80104787:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010478c:	5b                   	pop    %ebx
8010478d:	5e                   	pop    %esi
8010478e:	5d                   	pop    %ebp
8010478f:	c3                   	ret    

80104790 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 10             	sub    $0x10,%esp
80104797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010479a:	68 c0 3e 11 80       	push   $0x80113ec0
8010479f:	e8 ac 03 00 00       	call   80104b50 <acquire>
801047a4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047a7:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
801047ac:	eb 0c                	jmp    801047ba <wakeup+0x2a>
801047ae:	66 90                	xchg   %ax,%ax
801047b0:	83 c0 7c             	add    $0x7c,%eax
801047b3:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
801047b8:	74 1c                	je     801047d6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801047ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047be:	75 f0                	jne    801047b0 <wakeup+0x20>
801047c0:	3b 58 20             	cmp    0x20(%eax),%ebx
801047c3:	75 eb                	jne    801047b0 <wakeup+0x20>
      p->state = RUNNABLE;
801047c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047cc:	83 c0 7c             	add    $0x7c,%eax
801047cf:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
801047d4:	75 e4                	jne    801047ba <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801047d6:	c7 45 08 c0 3e 11 80 	movl   $0x80113ec0,0x8(%ebp)
}
801047dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e0:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801047e1:	e9 8a 04 00 00       	jmp    80104c70 <release>
801047e6:	8d 76 00             	lea    0x0(%esi),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 10             	sub    $0x10,%esp
801047f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801047fa:	68 c0 3e 11 80       	push   $0x80113ec0
801047ff:	e8 4c 03 00 00       	call   80104b50 <acquire>
80104804:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104807:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
8010480c:	eb 0c                	jmp    8010481a <kill+0x2a>
8010480e:	66 90                	xchg   %ax,%ax
80104810:	83 c0 7c             	add    $0x7c,%eax
80104813:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104818:	74 3e                	je     80104858 <kill+0x68>
    if(p->pid == pid){
8010481a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010481d:	75 f1                	jne    80104810 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010481f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104823:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010482a:	74 1c                	je     80104848 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010482c:	83 ec 0c             	sub    $0xc,%esp
8010482f:	68 c0 3e 11 80       	push   $0x80113ec0
80104834:	e8 37 04 00 00       	call   80104c70 <release>
      return 0;
80104839:	83 c4 10             	add    $0x10,%esp
8010483c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010483e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104841:	c9                   	leave  
80104842:	c3                   	ret    
80104843:	90                   	nop
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104848:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010484f:	eb db                	jmp    8010482c <kill+0x3c>
80104851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	68 c0 3e 11 80       	push   $0x80113ec0
80104860:	e8 0b 04 00 00       	call   80104c70 <release>
  return -1;
80104865:	83 c4 10             	add    $0x10,%esp
80104868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010486d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104870:	c9                   	leave  
80104871:	c3                   	ret    
80104872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	56                   	push   %esi
80104885:	53                   	push   %ebx
80104886:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104889:	bb 60 3f 11 80       	mov    $0x80113f60,%ebx
8010488e:	83 ec 3c             	sub    $0x3c,%esp
80104891:	eb 24                	jmp    801048b7 <procdump+0x37>
80104893:	90                   	nop
80104894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104898:	83 ec 0c             	sub    $0xc,%esp
8010489b:	68 67 83 10 80       	push   $0x80108367
801048a0:	e8 bb bd ff ff       	call   80100660 <cprintf>
801048a5:	83 c4 10             	add    $0x10,%esp
801048a8:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ab:	81 fb 60 5e 11 80    	cmp    $0x80115e60,%ebx
801048b1:	0f 84 81 00 00 00    	je     80104938 <procdump+0xb8>
    if(p->state == UNUSED)
801048b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801048ba:	85 c0                	test   %eax,%eax
801048bc:	74 ea                	je     801048a8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048be:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801048c1:	ba e0 7f 10 80       	mov    $0x80107fe0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048c6:	77 11                	ja     801048d9 <procdump+0x59>
801048c8:	8b 14 85 40 80 10 80 	mov    -0x7fef7fc0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801048cf:	b8 e0 7f 10 80       	mov    $0x80107fe0,%eax
801048d4:	85 d2                	test   %edx,%edx
801048d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801048d9:	53                   	push   %ebx
801048da:	52                   	push   %edx
801048db:	ff 73 a4             	pushl  -0x5c(%ebx)
801048de:	68 e4 7f 10 80       	push   $0x80107fe4
801048e3:	e8 78 bd ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801048e8:	83 c4 10             	add    $0x10,%esp
801048eb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801048ef:	75 a7                	jne    80104898 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048f1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048f4:	83 ec 08             	sub    $0x8,%esp
801048f7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048fa:	50                   	push   %eax
801048fb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801048fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104901:	83 c0 08             	add    $0x8,%eax
80104904:	50                   	push   %eax
80104905:	e8 66 01 00 00       	call   80104a70 <getcallerpcs>
8010490a:	83 c4 10             	add    $0x10,%esp
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104910:	8b 17                	mov    (%edi),%edx
80104912:	85 d2                	test   %edx,%edx
80104914:	74 82                	je     80104898 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104916:	83 ec 08             	sub    $0x8,%esp
80104919:	83 c7 04             	add    $0x4,%edi
8010491c:	52                   	push   %edx
8010491d:	68 21 7a 10 80       	push   $0x80107a21
80104922:	e8 39 bd ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104927:	83 c4 10             	add    $0x10,%esp
8010492a:	39 f7                	cmp    %esi,%edi
8010492c:	75 e2                	jne    80104910 <procdump+0x90>
8010492e:	e9 65 ff ff ff       	jmp    80104898 <procdump+0x18>
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104938:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010493b:	5b                   	pop    %ebx
8010493c:	5e                   	pop    %esi
8010493d:	5f                   	pop    %edi
8010493e:	5d                   	pop    %ebp
8010493f:	c3                   	ret    

80104940 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 0c             	sub    $0xc,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010494a:	68 58 80 10 80       	push   $0x80108058
8010494f:	8d 43 04             	lea    0x4(%ebx),%eax
80104952:	50                   	push   %eax
80104953:	e8 f8 00 00 00       	call   80104a50 <initlock>
  lk->name = name;
80104958:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010495b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104961:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104964:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010496b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010496e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104971:	c9                   	leave  
80104972:	c3                   	ret    
80104973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
8010498e:	56                   	push   %esi
8010498f:	e8 bc 01 00 00       	call   80104b50 <acquire>
  while (lk->locked) {
80104994:	8b 13                	mov    (%ebx),%edx
80104996:	83 c4 10             	add    $0x10,%esp
80104999:	85 d2                	test   %edx,%edx
8010499b:	74 16                	je     801049b3 <acquiresleep+0x33>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049a0:	83 ec 08             	sub    $0x8,%esp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	e8 36 fc ff ff       	call   801045e0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801049aa:	8b 03                	mov    (%ebx),%eax
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	85 c0                	test   %eax,%eax
801049b1:	75 ed                	jne    801049a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801049b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049b9:	e8 72 f6 ff ff       	call   80104030 <myproc>
801049be:	8b 40 10             	mov    0x10(%eax),%eax
801049c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801049cd:	e9 9e 02 00 00       	jmp    80104c70 <release>
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ee:	56                   	push   %esi
801049ef:	e8 5c 01 00 00       	call   80104b50 <acquire>
  lk->locked = 0;
801049f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a01:	89 1c 24             	mov    %ebx,(%esp)
80104a04:	e8 87 fd ff ff       	call   80104790 <wakeup>
  release(&lk->lk);
80104a09:	89 75 08             	mov    %esi,0x8(%ebp)
80104a0c:	83 c4 10             	add    $0x10,%esp
}
80104a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104a15:	e9 56 02 00 00       	jmp    80104c70 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	8d 5e 04             	lea    0x4(%esi),%ebx
80104a2e:	53                   	push   %ebx
80104a2f:	e8 1c 01 00 00       	call   80104b50 <acquire>
  r = lk->locked;
80104a34:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104a36:	89 1c 24             	mov    %ebx,(%esp)
80104a39:	e8 32 02 00 00       	call   80104c70 <release>
  return r;
}
80104a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a41:	89 f0                	mov    %esi,%eax
80104a43:	5b                   	pop    %ebx
80104a44:	5e                   	pop    %esi
80104a45:	5d                   	pop    %ebp
80104a46:	c3                   	ret    
80104a47:	66 90                	xchg   %ax,%ax
80104a49:	66 90                	xchg   %ax,%ax
80104a4b:	66 90                	xchg   %ax,%ax
80104a4d:	66 90                	xchg   %ax,%ax
80104a4f:	90                   	nop

80104a50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104a5f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104a62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret    
80104a6b:	90                   	nop
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a74:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a7a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104a7d:	31 c0                	xor    %eax,%eax
80104a7f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a80:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a8c:	77 1a                	ja     80104aa8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a8e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104a91:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a94:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104a97:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a99:	83 f8 0a             	cmp    $0xa,%eax
80104a9c:	75 e2                	jne    80104a80 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a9e:	5b                   	pop    %ebx
80104a9f:	5d                   	pop    %ebp
80104aa0:	c3                   	ret    
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104aa8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104aaf:	83 c0 01             	add    $0x1,%eax
80104ab2:	83 f8 0a             	cmp    $0xa,%eax
80104ab5:	74 e7                	je     80104a9e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104ab7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104abe:	83 c0 01             	add    $0x1,%eax
80104ac1:	83 f8 0a             	cmp    $0xa,%eax
80104ac4:	75 e2                	jne    80104aa8 <getcallerpcs+0x38>
80104ac6:	eb d6                	jmp    80104a9e <getcallerpcs+0x2e>
80104ac8:	90                   	nop
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104ada:	8b 02                	mov    (%edx),%eax
80104adc:	85 c0                	test   %eax,%eax
80104ade:	75 10                	jne    80104af0 <holding+0x20>
}
80104ae0:	83 c4 04             	add    $0x4,%esp
80104ae3:	31 c0                	xor    %eax,%eax
80104ae5:	5b                   	pop    %ebx
80104ae6:	5d                   	pop    %ebp
80104ae7:	c3                   	ret    
80104ae8:	90                   	nop
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104af0:	8b 5a 08             	mov    0x8(%edx),%ebx
80104af3:	e8 98 f4 ff ff       	call   80103f90 <mycpu>
80104af8:	39 c3                	cmp    %eax,%ebx
80104afa:	0f 94 c0             	sete   %al
}
80104afd:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104b00:	0f b6 c0             	movzbl %al,%eax
}
80104b03:	5b                   	pop    %ebx
80104b04:	5d                   	pop    %ebp
80104b05:	c3                   	ret    
80104b06:	8d 76 00             	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	9c                   	pushf  
80104b18:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104b19:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b1a:	e8 71 f4 ff ff       	call   80103f90 <mycpu>
80104b1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b25:	85 c0                	test   %eax,%eax
80104b27:	75 11                	jne    80104b3a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b29:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b2f:	e8 5c f4 ff ff       	call   80103f90 <mycpu>
80104b34:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b3a:	e8 51 f4 ff ff       	call   80103f90 <mycpu>
80104b3f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b46:	83 c4 04             	add    $0x4,%esp
80104b49:	5b                   	pop    %ebx
80104b4a:	5d                   	pop    %ebp
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b55:	e8 b6 ff ff ff       	call   80104b10 <pushcli>
  if(holding(lk))
80104b5a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104b5d:	8b 03                	mov    (%ebx),%eax
80104b5f:	85 c0                	test   %eax,%eax
80104b61:	75 7d                	jne    80104be0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104b63:	ba 01 00 00 00       	mov    $0x1,%edx
80104b68:	eb 09                	jmp    80104b73 <acquire+0x23>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b73:	89 d0                	mov    %edx,%eax
80104b75:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104b78:	85 c0                	test   %eax,%eax
80104b7a:	75 f4                	jne    80104b70 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104b7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104b81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b84:	e8 07 f4 ff ff       	call   80103f90 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b89:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104b8b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104b8e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b91:	31 c0                	xor    %eax,%eax
80104b93:	90                   	nop
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b98:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ba4:	77 1a                	ja     80104bc0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ba6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104ba9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bac:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104baf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bb1:	83 f8 0a             	cmp    $0xa,%eax
80104bb4:	75 e2                	jne    80104b98 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104bc0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104bc7:	83 c0 01             	add    $0x1,%eax
80104bca:	83 f8 0a             	cmp    $0xa,%eax
80104bcd:	74 e7                	je     80104bb6 <acquire+0x66>
    pcs[i] = 0;
80104bcf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104bd6:	83 c0 01             	add    $0x1,%eax
80104bd9:	83 f8 0a             	cmp    $0xa,%eax
80104bdc:	75 e2                	jne    80104bc0 <acquire+0x70>
80104bde:	eb d6                	jmp    80104bb6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104be0:	8b 73 08             	mov    0x8(%ebx),%esi
80104be3:	e8 a8 f3 ff ff       	call   80103f90 <mycpu>
80104be8:	39 c6                	cmp    %eax,%esi
80104bea:	0f 85 73 ff ff ff    	jne    80104b63 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104bf0:	83 ec 0c             	sub    $0xc,%esp
80104bf3:	68 63 80 10 80       	push   $0x80108063
80104bf8:	e8 73 b7 ff ff       	call   80100370 <panic>
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c06:	9c                   	pushf  
80104c07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c08:	f6 c4 02             	test   $0x2,%ah
80104c0b:	75 52                	jne    80104c5f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c0d:	e8 7e f3 ff ff       	call   80103f90 <mycpu>
80104c12:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104c18:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104c1b:	85 d2                	test   %edx,%edx
80104c1d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104c23:	78 2d                	js     80104c52 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c25:	e8 66 f3 ff ff       	call   80103f90 <mycpu>
80104c2a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c30:	85 d2                	test   %edx,%edx
80104c32:	74 0c                	je     80104c40 <popcli+0x40>
    sti();
}
80104c34:	c9                   	leave  
80104c35:	c3                   	ret    
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c40:	e8 4b f3 ff ff       	call   80103f90 <mycpu>
80104c45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c4b:	85 c0                	test   %eax,%eax
80104c4d:	74 e5                	je     80104c34 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104c4f:	fb                   	sti    
    sti();
}
80104c50:	c9                   	leave  
80104c51:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104c52:	83 ec 0c             	sub    $0xc,%esp
80104c55:	68 82 80 10 80       	push   $0x80108082
80104c5a:	e8 11 b7 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104c5f:	83 ec 0c             	sub    $0xc,%esp
80104c62:	68 6b 80 10 80       	push   $0x8010806b
80104c67:	e8 04 b7 ff ff       	call   80100370 <panic>
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c70 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104c78:	8b 03                	mov    (%ebx),%eax
80104c7a:	85 c0                	test   %eax,%eax
80104c7c:	75 12                	jne    80104c90 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104c7e:	83 ec 0c             	sub    $0xc,%esp
80104c81:	68 89 80 10 80       	push   $0x80108089
80104c86:	e8 e5 b6 ff ff       	call   80100370 <panic>
80104c8b:	90                   	nop
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104c90:	8b 73 08             	mov    0x8(%ebx),%esi
80104c93:	e8 f8 f2 ff ff       	call   80103f90 <mycpu>
80104c98:	39 c6                	cmp    %eax,%esi
80104c9a:	75 e2                	jne    80104c7e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
80104c9c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ca3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104caa:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104caf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104cb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb8:	5b                   	pop    %ebx
80104cb9:	5e                   	pop    %esi
80104cba:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104cbb:	e9 40 ff ff ff       	jmp    80104c00 <popcli>

80104cc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104ccb:	f6 c2 03             	test   $0x3,%dl
80104cce:	75 05                	jne    80104cd5 <memset+0x15>
80104cd0:	f6 c1 03             	test   $0x3,%cl
80104cd3:	74 13                	je     80104ce8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104cd5:	89 d7                	mov    %edx,%edi
80104cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cda:	fc                   	cld    
80104cdb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cdd:	5b                   	pop    %ebx
80104cde:	89 d0                	mov    %edx,%eax
80104ce0:	5f                   	pop    %edi
80104ce1:	5d                   	pop    %ebp
80104ce2:	c3                   	ret    
80104ce3:	90                   	nop
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104ce8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104cec:	c1 e9 02             	shr    $0x2,%ecx
80104cef:	89 fb                	mov    %edi,%ebx
80104cf1:	89 f8                	mov    %edi,%eax
80104cf3:	c1 e3 18             	shl    $0x18,%ebx
80104cf6:	c1 e0 10             	shl    $0x10,%eax
80104cf9:	09 d8                	or     %ebx,%eax
80104cfb:	09 f8                	or     %edi,%eax
80104cfd:	c1 e7 08             	shl    $0x8,%edi
80104d00:	09 f8                	or     %edi,%eax
80104d02:	89 d7                	mov    %edx,%edi
80104d04:	fc                   	cld    
80104d05:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d07:	5b                   	pop    %ebx
80104d08:	89 d0                	mov    %edx,%eax
80104d0a:	5f                   	pop    %edi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi

80104d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	8b 45 10             	mov    0x10(%ebp),%eax
80104d18:	53                   	push   %ebx
80104d19:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d1f:	85 c0                	test   %eax,%eax
80104d21:	74 29                	je     80104d4c <memcmp+0x3c>
    if(*s1 != *s2)
80104d23:	0f b6 13             	movzbl (%ebx),%edx
80104d26:	0f b6 0e             	movzbl (%esi),%ecx
80104d29:	38 d1                	cmp    %dl,%cl
80104d2b:	75 2b                	jne    80104d58 <memcmp+0x48>
80104d2d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104d30:	31 c0                	xor    %eax,%eax
80104d32:	eb 14                	jmp    80104d48 <memcmp+0x38>
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d38:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104d3d:	83 c0 01             	add    $0x1,%eax
80104d40:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d44:	38 ca                	cmp    %cl,%dl
80104d46:	75 10                	jne    80104d58 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d48:	39 f8                	cmp    %edi,%eax
80104d4a:	75 ec                	jne    80104d38 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d4c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104d4d:	31 c0                	xor    %eax,%eax
}
80104d4f:	5e                   	pop    %esi
80104d50:	5f                   	pop    %edi
80104d51:	5d                   	pop    %ebp
80104d52:	c3                   	ret    
80104d53:	90                   	nop
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d58:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104d5b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d5c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104d5e:	5e                   	pop    %esi
80104d5f:	5f                   	pop    %edi
80104d60:	5d                   	pop    %ebp
80104d61:	c3                   	ret    
80104d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 45 08             	mov    0x8(%ebp),%eax
80104d78:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d7e:	39 c6                	cmp    %eax,%esi
80104d80:	73 2e                	jae    80104db0 <memmove+0x40>
80104d82:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104d85:	39 c8                	cmp    %ecx,%eax
80104d87:	73 27                	jae    80104db0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104d89:	85 db                	test   %ebx,%ebx
80104d8b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104d8e:	74 17                	je     80104da7 <memmove+0x37>
      *--d = *--s;
80104d90:	29 d9                	sub    %ebx,%ecx
80104d92:	89 cb                	mov    %ecx,%ebx
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d98:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d9c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104d9f:	83 ea 01             	sub    $0x1,%edx
80104da2:	83 fa ff             	cmp    $0xffffffff,%edx
80104da5:	75 f1                	jne    80104d98 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104da7:	5b                   	pop    %ebx
80104da8:	5e                   	pop    %esi
80104da9:	5d                   	pop    %ebp
80104daa:	c3                   	ret    
80104dab:	90                   	nop
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104db0:	31 d2                	xor    %edx,%edx
80104db2:	85 db                	test   %ebx,%ebx
80104db4:	74 f1                	je     80104da7 <memmove+0x37>
80104db6:	8d 76 00             	lea    0x0(%esi),%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104dc0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104dc4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104dc7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104dca:	39 d3                	cmp    %edx,%ebx
80104dcc:	75 f2                	jne    80104dc0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104dce:	5b                   	pop    %ebx
80104dcf:	5e                   	pop    %esi
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    
80104dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104de3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104de4:	eb 8a                	jmp    80104d70 <memmove>
80104de6:	8d 76 00             	lea    0x0(%esi),%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
80104df5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104df8:	53                   	push   %ebx
80104df9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104dff:	85 c9                	test   %ecx,%ecx
80104e01:	74 37                	je     80104e3a <strncmp+0x4a>
80104e03:	0f b6 17             	movzbl (%edi),%edx
80104e06:	0f b6 1e             	movzbl (%esi),%ebx
80104e09:	84 d2                	test   %dl,%dl
80104e0b:	74 3f                	je     80104e4c <strncmp+0x5c>
80104e0d:	38 d3                	cmp    %dl,%bl
80104e0f:	75 3b                	jne    80104e4c <strncmp+0x5c>
80104e11:	8d 47 01             	lea    0x1(%edi),%eax
80104e14:	01 cf                	add    %ecx,%edi
80104e16:	eb 1b                	jmp    80104e33 <strncmp+0x43>
80104e18:	90                   	nop
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e20:	0f b6 10             	movzbl (%eax),%edx
80104e23:	84 d2                	test   %dl,%dl
80104e25:	74 21                	je     80104e48 <strncmp+0x58>
80104e27:	0f b6 19             	movzbl (%ecx),%ebx
80104e2a:	83 c0 01             	add    $0x1,%eax
80104e2d:	89 ce                	mov    %ecx,%esi
80104e2f:	38 da                	cmp    %bl,%dl
80104e31:	75 19                	jne    80104e4c <strncmp+0x5c>
80104e33:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104e35:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e38:	75 e6                	jne    80104e20 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e3a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104e3b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104e3d:	5e                   	pop    %esi
80104e3e:	5f                   	pop    %edi
80104e3f:	5d                   	pop    %ebp
80104e40:	c3                   	ret    
80104e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e48:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e4c:	0f b6 c2             	movzbl %dl,%eax
80104e4f:	29 d8                	sub    %ebx,%eax
}
80104e51:	5b                   	pop    %ebx
80104e52:	5e                   	pop    %esi
80104e53:	5f                   	pop    %edi
80104e54:	5d                   	pop    %ebp
80104e55:	c3                   	ret    
80104e56:	8d 76 00             	lea    0x0(%esi),%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	8b 45 08             	mov    0x8(%ebp),%eax
80104e68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e6e:	89 c2                	mov    %eax,%edx
80104e70:	eb 19                	jmp    80104e8b <strncpy+0x2b>
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e78:	83 c3 01             	add    $0x1,%ebx
80104e7b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e7f:	83 c2 01             	add    $0x1,%edx
80104e82:	84 c9                	test   %cl,%cl
80104e84:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e87:	74 09                	je     80104e92 <strncpy+0x32>
80104e89:	89 f1                	mov    %esi,%ecx
80104e8b:	85 c9                	test   %ecx,%ecx
80104e8d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e90:	7f e6                	jg     80104e78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e92:	31 c9                	xor    %ecx,%ecx
80104e94:	85 f6                	test   %esi,%esi
80104e96:	7e 17                	jle    80104eaf <strncpy+0x4f>
80104e98:	90                   	nop
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ea0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ea4:	89 f3                	mov    %esi,%ebx
80104ea6:	83 c1 01             	add    $0x1,%ecx
80104ea9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104eab:	85 db                	test   %ebx,%ebx
80104ead:	7f f1                	jg     80104ea0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104eaf:	5b                   	pop    %ebx
80104eb0:	5e                   	pop    %esi
80104eb1:	5d                   	pop    %ebp
80104eb2:	c3                   	ret    
80104eb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
80104ec5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80104ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104ece:	85 c9                	test   %ecx,%ecx
80104ed0:	7e 26                	jle    80104ef8 <safestrcpy+0x38>
80104ed2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ed6:	89 c1                	mov    %eax,%ecx
80104ed8:	eb 17                	jmp    80104ef1 <safestrcpy+0x31>
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ee0:	83 c2 01             	add    $0x1,%edx
80104ee3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ee7:	83 c1 01             	add    $0x1,%ecx
80104eea:	84 db                	test   %bl,%bl
80104eec:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104eef:	74 04                	je     80104ef5 <safestrcpy+0x35>
80104ef1:	39 f2                	cmp    %esi,%edx
80104ef3:	75 eb                	jne    80104ee0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ef5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ef8:	5b                   	pop    %ebx
80104ef9:	5e                   	pop    %esi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f00 <strlen>:

int
strlen(const char *s)
{
80104f00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f01:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104f03:	89 e5                	mov    %esp,%ebp
80104f05:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104f08:	80 3a 00             	cmpb   $0x0,(%edx)
80104f0b:	74 0c                	je     80104f19 <strlen+0x19>
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	83 c0 01             	add    $0x1,%eax
80104f13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f17:	75 f7                	jne    80104f10 <strlen+0x10>
    ;
  return n;
}
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    

80104f1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104f23:	55                   	push   %ebp
  pushl %ebx
80104f24:	53                   	push   %ebx
  pushl %esi
80104f25:	56                   	push   %esi
  pushl %edi
80104f26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f29:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104f2b:	5f                   	pop    %edi
  popl %esi
80104f2c:	5e                   	pop    %esi
  popl %ebx
80104f2d:	5b                   	pop    %ebx
  popl %ebp
80104f2e:	5d                   	pop    %ebp
  ret
80104f2f:	c3                   	ret    

80104f30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 04             	sub    $0x4,%esp
80104f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f3a:	e8 f1 f0 ff ff       	call   80104030 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f3f:	8b 00                	mov    (%eax),%eax
80104f41:	39 d8                	cmp    %ebx,%eax
80104f43:	76 1b                	jbe    80104f60 <fetchint+0x30>
80104f45:	8d 53 04             	lea    0x4(%ebx),%edx
80104f48:	39 d0                	cmp    %edx,%eax
80104f4a:	72 14                	jb     80104f60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f4f:	8b 13                	mov    (%ebx),%edx
80104f51:	89 10                	mov    %edx,(%eax)
  return 0;
80104f53:	31 c0                	xor    %eax,%eax
}
80104f55:	83 c4 04             	add    $0x4,%esp
80104f58:	5b                   	pop    %ebx
80104f59:	5d                   	pop    %ebp
80104f5a:	c3                   	ret    
80104f5b:	90                   	nop
80104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f65:	eb ee                	jmp    80104f55 <fetchint+0x25>
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	53                   	push   %ebx
80104f74:	83 ec 04             	sub    $0x4,%esp
80104f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f7a:	e8 b1 f0 ff ff       	call   80104030 <myproc>

  if(addr >= curproc->sz)
80104f7f:	39 18                	cmp    %ebx,(%eax)
80104f81:	76 29                	jbe    80104fac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f86:	89 da                	mov    %ebx,%edx
80104f88:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f8a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f8c:	39 c3                	cmp    %eax,%ebx
80104f8e:	73 1c                	jae    80104fac <fetchstr+0x3c>
    if(*s == 0)
80104f90:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f93:	75 10                	jne    80104fa5 <fetchstr+0x35>
80104f95:	eb 29                	jmp    80104fc0 <fetchstr+0x50>
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fa0:	80 3a 00             	cmpb   $0x0,(%edx)
80104fa3:	74 1b                	je     80104fc0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104fa5:	83 c2 01             	add    $0x1,%edx
80104fa8:	39 d0                	cmp    %edx,%eax
80104faa:	77 f4                	ja     80104fa0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104fac:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104fb4:	5b                   	pop    %ebx
80104fb5:	5d                   	pop    %ebp
80104fb6:	c3                   	ret    
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fc0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104fc3:	89 d0                	mov    %edx,%eax
80104fc5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104fc7:	5b                   	pop    %ebx
80104fc8:	5d                   	pop    %ebp
80104fc9:	c3                   	ret    
80104fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fd5:	e8 56 f0 ff ff       	call   80104030 <myproc>
80104fda:	8b 40 18             	mov    0x18(%eax),%eax
80104fdd:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe0:	8b 40 44             	mov    0x44(%eax),%eax
80104fe3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104fe6:	e8 45 f0 ff ff       	call   80104030 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104feb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fed:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ff0:	39 c6                	cmp    %eax,%esi
80104ff2:	73 1c                	jae    80105010 <argint+0x40>
80104ff4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ff7:	39 d0                	cmp    %edx,%eax
80104ff9:	72 15                	jb     80105010 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ffe:	8b 53 04             	mov    0x4(%ebx),%edx
80105001:	89 10                	mov    %edx,(%eax)
  return 0;
80105003:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80105005:	5b                   	pop    %ebx
80105006:	5e                   	pop    %esi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105015:	eb ee                	jmp    80105005 <argint+0x35>
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
80105025:	83 ec 10             	sub    $0x10,%esp
80105028:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010502b:	e8 00 f0 ff ff       	call   80104030 <myproc>
80105030:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105032:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105035:	83 ec 08             	sub    $0x8,%esp
80105038:	50                   	push   %eax
80105039:	ff 75 08             	pushl  0x8(%ebp)
8010503c:	e8 8f ff ff ff       	call   80104fd0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105041:	c1 e8 1f             	shr    $0x1f,%eax
80105044:	83 c4 10             	add    $0x10,%esp
80105047:	84 c0                	test   %al,%al
80105049:	75 2d                	jne    80105078 <argptr+0x58>
8010504b:	89 d8                	mov    %ebx,%eax
8010504d:	c1 e8 1f             	shr    $0x1f,%eax
80105050:	84 c0                	test   %al,%al
80105052:	75 24                	jne    80105078 <argptr+0x58>
80105054:	8b 16                	mov    (%esi),%edx
80105056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105059:	39 c2                	cmp    %eax,%edx
8010505b:	76 1b                	jbe    80105078 <argptr+0x58>
8010505d:	01 c3                	add    %eax,%ebx
8010505f:	39 da                	cmp    %ebx,%edx
80105061:	72 15                	jb     80105078 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105063:	8b 55 0c             	mov    0xc(%ebp),%edx
80105066:	89 02                	mov    %eax,(%edx)
  return 0;
80105068:	31 c0                	xor    %eax,%eax
}
8010506a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010506d:	5b                   	pop    %ebx
8010506e:	5e                   	pop    %esi
8010506f:	5d                   	pop    %ebp
80105070:	c3                   	ret    
80105071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507d:	eb eb                	jmp    8010506a <argptr+0x4a>
8010507f:	90                   	nop

80105080 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105086:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105089:	50                   	push   %eax
8010508a:	ff 75 08             	pushl  0x8(%ebp)
8010508d:	e8 3e ff ff ff       	call   80104fd0 <argint>
80105092:	83 c4 10             	add    $0x10,%esp
80105095:	85 c0                	test   %eax,%eax
80105097:	78 17                	js     801050b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105099:	83 ec 08             	sub    $0x8,%esp
8010509c:	ff 75 0c             	pushl  0xc(%ebp)
8010509f:	ff 75 f4             	pushl  -0xc(%ebp)
801050a2:	e8 c9 fe ff ff       	call   80104f70 <fetchstr>
801050a7:	83 c4 10             	add    $0x10,%esp
}
801050aa:	c9                   	leave  
801050ab:	c3                   	ret    
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <syscall>:
[SYS_gettag] sys_gettag,
};

void
syscall(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801050c5:	e8 66 ef ff ff       	call   80104030 <myproc>

  num = curproc->tf->eax;
801050ca:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801050cd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050cf:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050d2:	8d 50 ff             	lea    -0x1(%eax),%edx
801050d5:	83 fa 19             	cmp    $0x19,%edx
801050d8:	77 1e                	ja     801050f8 <syscall+0x38>
801050da:	8b 14 85 c0 80 10 80 	mov    -0x7fef7f40(,%eax,4),%edx
801050e1:	85 d2                	test   %edx,%edx
801050e3:	74 13                	je     801050f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050e5:	ff d2                	call   *%edx
801050e7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ed:	5b                   	pop    %ebx
801050ee:	5e                   	pop    %esi
801050ef:	5d                   	pop    %ebp
801050f0:	c3                   	ret    
801050f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801050f8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050f9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801050fc:	50                   	push   %eax
801050fd:	ff 73 10             	pushl  0x10(%ebx)
80105100:	68 91 80 10 80       	push   $0x80108091
80105105:	e8 56 b5 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010510a:	8b 43 18             	mov    0x18(%ebx),%eax
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105117:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010511a:	5b                   	pop    %ebx
8010511b:	5e                   	pop    %esi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax

80105120 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105126:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105129:	83 ec 44             	sub    $0x44,%esp
8010512c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010512f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105132:	56                   	push   %esi
80105133:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105134:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105137:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010513a:	e8 31 d1 ff ff       	call   80102270 <nameiparent>
8010513f:	83 c4 10             	add    $0x10,%esp
80105142:	85 c0                	test   %eax,%eax
80105144:	0f 84 fe 00 00 00    	je     80105248 <create+0x128>
    return 0;
  ilock(dp);
8010514a:	83 ec 0c             	sub    $0xc,%esp
8010514d:	89 c7                	mov    %eax,%edi
8010514f:	50                   	push   %eax
80105150:	e8 2b c6 ff ff       	call   80101780 <ilock>
    
  if((ip = dirlookup(dp, name, &off)) != 0){
80105155:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105158:	83 c4 0c             	add    $0xc,%esp
8010515b:	50                   	push   %eax
8010515c:	56                   	push   %esi
8010515d:	57                   	push   %edi
8010515e:	e8 4d cb ff ff       	call   80101cb0 <dirlookup>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	89 c3                	mov    %eax,%ebx
8010516a:	74 54                	je     801051c0 <create+0xa0>
    iunlockput(dp);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	57                   	push   %edi
80105170:	e8 9b c8 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105175:	89 1c 24             	mov    %ebx,(%esp)
80105178:	e8 03 c6 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105185:	75 19                	jne    801051a0 <create+0x80>
80105187:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010518c:	89 d8                	mov    %ebx,%eax
8010518e:	75 10                	jne    801051a0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);
  end_op();
  return ip;
}
80105190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105193:	5b                   	pop    %ebx
80105194:	5e                   	pop    %esi
80105195:	5f                   	pop    %edi
80105196:	5d                   	pop    %ebp
80105197:	c3                   	ret    
80105198:	90                   	nop
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	53                   	push   %ebx
801051a4:	e8 67 c8 ff ff       	call   80101a10 <iunlockput>
    return 0;
801051a9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);
  end_op();
  return ip;
}
801051ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801051af:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);
  end_op();
  return ip;
}
801051b1:	5b                   	pop    %ebx
801051b2:	5e                   	pop    %esi
801051b3:	5f                   	pop    %edi
801051b4:	5d                   	pop    %ebp
801051b5:	c3                   	ret    
801051b6:	8d 76 00             	lea    0x0(%esi),%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
  }
  begin_op();  
801051c0:	e8 3b e2 ff ff       	call   80103400 <begin_op>
  if((ip = ialloc(dp->dev, type)) == 0)
801051c5:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801051c9:	83 ec 08             	sub    $0x8,%esp
801051cc:	50                   	push   %eax
801051cd:	ff 37                	pushl  (%edi)
801051cf:	e8 2c c4 ff ff       	call   80101600 <ialloc>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	89 c3                	mov    %eax,%ebx
801051db:	0f 84 c7 00 00 00    	je     801052a8 <create+0x188>
    panic("create: ialloc");
  

  
  ilock(ip);
801051e1:	83 ec 0c             	sub    $0xc,%esp
801051e4:	50                   	push   %eax
801051e5:	e8 96 c5 ff ff       	call   80101780 <ilock>
  ip->major = major;
801051ea:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801051ee:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801051f2:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801051f6:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801051fa:	b8 01 00 00 00       	mov    $0x1,%eax
801051ff:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80105203:	89 1c 24             	mov    %ebx,(%esp)
80105206:	e8 b5 c4 ff ff       	call   801016c0 <iupdate>
  
  if(type == T_DIR){  // Create . and .. entries.
8010520b:	83 c4 10             	add    $0x10,%esp
8010520e:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80105213:	74 3b                	je     80105250 <create+0x130>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  

  if(dirlink(dp, name, ip->inum) < 0)
80105215:	83 ec 04             	sub    $0x4,%esp
80105218:	ff 73 04             	pushl  0x4(%ebx)
8010521b:	56                   	push   %esi
8010521c:	57                   	push   %edi
8010521d:	e8 3e cb ff ff       	call   80101d60 <dirlink>
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	85 c0                	test   %eax,%eax
80105227:	78 72                	js     8010529b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	57                   	push   %edi
8010522d:	e8 de c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105232:	e8 39 e2 ff ff       	call   80103470 <end_op>
  return ip;
80105237:	83 c4 10             	add    $0x10,%esp
}
8010523a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);
  end_op();
  return ip;
8010523d:	89 d8                	mov    %ebx,%eax
}
8010523f:	5b                   	pop    %ebx
80105240:	5e                   	pop    %esi
80105241:	5f                   	pop    %edi
80105242:	5d                   	pop    %ebp
80105243:	c3                   	ret    
80105244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105248:	31 c0                	xor    %eax,%eax
8010524a:	e9 41 ff ff ff       	jmp    80105190 <create+0x70>
8010524f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105250:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	57                   	push   %edi
80105259:	e8 62 c4 ff ff       	call   801016c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010525e:	83 c4 0c             	add    $0xc,%esp
80105261:	ff 73 04             	pushl  0x4(%ebx)
80105264:	68 56 7b 10 80       	push   $0x80107b56
80105269:	53                   	push   %ebx
8010526a:	e8 f1 ca ff ff       	call   80101d60 <dirlink>
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	85 c0                	test   %eax,%eax
80105274:	78 18                	js     8010528e <create+0x16e>
80105276:	83 ec 04             	sub    $0x4,%esp
80105279:	ff 77 04             	pushl  0x4(%edi)
8010527c:	68 55 7b 10 80       	push   $0x80107b55
80105281:	53                   	push   %ebx
80105282:	e8 d9 ca ff ff       	call   80101d60 <dirlink>
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	85 c0                	test   %eax,%eax
8010528c:	79 87                	jns    80105215 <create+0xf5>
      panic("create dots");
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	68 3b 81 10 80       	push   $0x8010813b
80105296:	e8 d5 b0 ff ff       	call   80100370 <panic>
  }
  

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010529b:	83 ec 0c             	sub    $0xc,%esp
8010529e:	68 47 81 10 80       	push   $0x80108147
801052a3:	e8 c8 b0 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }
  begin_op();  
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	68 2c 81 10 80       	push   $0x8010812c
801052b0:	e8 bb b0 ff ff       	call   80100370 <panic>
801052b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	53                   	push   %ebx
801052c5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801052c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801052ca:	89 d3                	mov    %edx,%ebx
801052cc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801052cf:	50                   	push   %eax
801052d0:	6a 00                	push   $0x0
801052d2:	e8 f9 fc ff ff       	call   80104fd0 <argint>
801052d7:	83 c4 10             	add    $0x10,%esp
801052da:	85 c0                	test   %eax,%eax
801052dc:	78 32                	js     80105310 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052e2:	77 2c                	ja     80105310 <argfd.constprop.0+0x50>
801052e4:	e8 47 ed ff ff       	call   80104030 <myproc>
801052e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052ec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801052f0:	85 c0                	test   %eax,%eax
801052f2:	74 1c                	je     80105310 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801052f4:	85 f6                	test   %esi,%esi
801052f6:	74 02                	je     801052fa <argfd.constprop.0+0x3a>
    *pfd = fd;
801052f8:	89 16                	mov    %edx,(%esi)
  if(pf)
801052fa:	85 db                	test   %ebx,%ebx
801052fc:	74 22                	je     80105320 <argfd.constprop.0+0x60>
    *pf = f;
801052fe:	89 03                	mov    %eax,(%ebx)
  return 0;
80105300:	31 c0                	xor    %eax,%eax
}
80105302:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105305:	5b                   	pop    %ebx
80105306:	5e                   	pop    %esi
80105307:	5d                   	pop    %ebp
80105308:	c3                   	ret    
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105310:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105318:	5b                   	pop    %ebx
80105319:	5e                   	pop    %esi
8010531a:	5d                   	pop    %ebp
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105320:	31 c0                	xor    %eax,%eax
80105322:	eb de                	jmp    80105302 <argfd.constprop.0+0x42>
80105324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010532a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105330 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105330:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105331:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105333:	89 e5                	mov    %esp,%ebp
80105335:	56                   	push   %esi
80105336:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105337:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010533a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010533d:	e8 7e ff ff ff       	call   801052c0 <argfd.constprop.0>
80105342:	85 c0                	test   %eax,%eax
80105344:	78 1a                	js     80105360 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105346:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105348:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010534b:	e8 e0 ec ff ff       	call   80104030 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105350:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105354:	85 d2                	test   %edx,%edx
80105356:	74 18                	je     80105370 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105358:	83 c3 01             	add    $0x1,%ebx
8010535b:	83 fb 10             	cmp    $0x10,%ebx
8010535e:	75 f0                	jne    80105350 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105360:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105368:	5b                   	pop    %ebx
80105369:	5e                   	pop    %esi
8010536a:	5d                   	pop    %ebp
8010536b:	c3                   	ret    
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105370:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	ff 75 f4             	pushl  -0xc(%ebp)
8010537a:	e8 51 ba ff ff       	call   80100dd0 <filedup>
  return fd;
8010537f:	83 c4 10             	add    $0x10,%esp
}
80105382:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105385:	89 d8                	mov    %ebx,%eax
}
80105387:	5b                   	pop    %ebx
80105388:	5e                   	pop    %esi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	90                   	nop
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_read>:

int
sys_read(void)
{
80105390:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105391:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105393:	89 e5                	mov    %esp,%ebp
80105395:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105398:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010539b:	e8 20 ff ff ff       	call   801052c0 <argfd.constprop.0>
801053a0:	85 c0                	test   %eax,%eax
801053a2:	78 4c                	js     801053f0 <sys_read+0x60>
801053a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053a7:	83 ec 08             	sub    $0x8,%esp
801053aa:	50                   	push   %eax
801053ab:	6a 02                	push   $0x2
801053ad:	e8 1e fc ff ff       	call   80104fd0 <argint>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	85 c0                	test   %eax,%eax
801053b7:	78 37                	js     801053f0 <sys_read+0x60>
801053b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053bc:	83 ec 04             	sub    $0x4,%esp
801053bf:	ff 75 f0             	pushl  -0x10(%ebp)
801053c2:	50                   	push   %eax
801053c3:	6a 01                	push   $0x1
801053c5:	e8 56 fc ff ff       	call   80105020 <argptr>
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	85 c0                	test   %eax,%eax
801053cf:	78 1f                	js     801053f0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801053d1:	83 ec 04             	sub    $0x4,%esp
801053d4:	ff 75 f0             	pushl  -0x10(%ebp)
801053d7:	ff 75 f4             	pushl  -0xc(%ebp)
801053da:	ff 75 ec             	pushl  -0x14(%ebp)
801053dd:	e8 5e bb ff ff       	call   80100f40 <fileread>
801053e2:	83 c4 10             	add    $0x10,%esp
}
801053e5:	c9                   	leave  
801053e6:	c3                   	ret    
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    
801053f7:	89 f6                	mov    %esi,%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105400 <sys_write>:

int
sys_write(void)
{
80105400:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105401:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105403:	89 e5                	mov    %esp,%ebp
80105405:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105408:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010540b:	e8 b0 fe ff ff       	call   801052c0 <argfd.constprop.0>
80105410:	85 c0                	test   %eax,%eax
80105412:	78 4c                	js     80105460 <sys_write+0x60>
80105414:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105417:	83 ec 08             	sub    $0x8,%esp
8010541a:	50                   	push   %eax
8010541b:	6a 02                	push   $0x2
8010541d:	e8 ae fb ff ff       	call   80104fd0 <argint>
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	85 c0                	test   %eax,%eax
80105427:	78 37                	js     80105460 <sys_write+0x60>
80105429:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542c:	83 ec 04             	sub    $0x4,%esp
8010542f:	ff 75 f0             	pushl  -0x10(%ebp)
80105432:	50                   	push   %eax
80105433:	6a 01                	push   $0x1
80105435:	e8 e6 fb ff ff       	call   80105020 <argptr>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	85 c0                	test   %eax,%eax
8010543f:	78 1f                	js     80105460 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105441:	83 ec 04             	sub    $0x4,%esp
80105444:	ff 75 f0             	pushl  -0x10(%ebp)
80105447:	ff 75 f4             	pushl  -0xc(%ebp)
8010544a:	ff 75 ec             	pushl  -0x14(%ebp)
8010544d:	e8 7e bb ff ff       	call   80100fd0 <filewrite>
80105452:	83 c4 10             	add    $0x10,%esp
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_close>:

int
sys_close(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105476:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105479:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547c:	e8 3f fe ff ff       	call   801052c0 <argfd.constprop.0>
80105481:	85 c0                	test   %eax,%eax
80105483:	78 2b                	js     801054b0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105485:	e8 a6 eb ff ff       	call   80104030 <myproc>
8010548a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010548d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105490:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105497:	00 
  fileclose(f);
80105498:	ff 75 f4             	pushl  -0xc(%ebp)
8010549b:	e8 80 b9 ff ff       	call   80100e20 <fileclose>
  return 0;
801054a0:	83 c4 10             	add    $0x10,%esp
801054a3:	31 c0                	xor    %eax,%eax
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801054b5:	c9                   	leave  
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <sys_fstat>:

int
sys_fstat(void)
{
801054c0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054c1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801054c3:	89 e5                	mov    %esp,%ebp
801054c5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054cb:	e8 f0 fd ff ff       	call   801052c0 <argfd.constprop.0>
801054d0:	85 c0                	test   %eax,%eax
801054d2:	78 2c                	js     80105500 <sys_fstat+0x40>
801054d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054d7:	83 ec 04             	sub    $0x4,%esp
801054da:	6a 14                	push   $0x14
801054dc:	50                   	push   %eax
801054dd:	6a 01                	push   $0x1
801054df:	e8 3c fb ff ff       	call   80105020 <argptr>
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	85 c0                	test   %eax,%eax
801054e9:	78 15                	js     80105500 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801054eb:	83 ec 08             	sub    $0x8,%esp
801054ee:	ff 75 f4             	pushl  -0xc(%ebp)
801054f1:	ff 75 f0             	pushl  -0x10(%ebp)
801054f4:	e8 f7 b9 ff ff       	call   80100ef0 <filestat>
801054f9:	83 c4 10             	add    $0x10,%esp
}
801054fc:	c9                   	leave  
801054fd:	c3                   	ret    
801054fe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105505:	c9                   	leave  
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105516:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105519:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010551c:	50                   	push   %eax
8010551d:	6a 00                	push   $0x0
8010551f:	e8 5c fb ff ff       	call   80105080 <argstr>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	0f 88 fb 00 00 00    	js     8010562a <sys_link+0x11a>
8010552f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105532:	83 ec 08             	sub    $0x8,%esp
80105535:	50                   	push   %eax
80105536:	6a 01                	push   $0x1
80105538:	e8 43 fb ff ff       	call   80105080 <argstr>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	0f 88 e2 00 00 00    	js     8010562a <sys_link+0x11a>
    return -1;

  begin_op();
80105548:	e8 b3 de ff ff       	call   80103400 <begin_op>
  if((ip = namei(old,0)) == 0){
8010554d:	83 ec 08             	sub    $0x8,%esp
80105550:	6a 00                	push   $0x0
80105552:	ff 75 d4             	pushl  -0x2c(%ebp)
80105555:	e8 d6 cc ff ff       	call   80102230 <namei>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	89 c3                	mov    %eax,%ebx
80105561:	0f 84 f1 00 00 00    	je     80105658 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105567:	83 ec 0c             	sub    $0xc,%esp
8010556a:	50                   	push   %eax
8010556b:	e8 10 c2 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80105570:	83 c4 10             	add    $0x10,%esp
80105573:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105578:	0f 84 c2 00 00 00    	je     80105640 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010557e:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105583:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105586:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105589:	53                   	push   %ebx
8010558a:	e8 31 c1 ff ff       	call   801016c0 <iupdate>
  iunlock(ip);
8010558f:	89 1c 24             	mov    %ebx,(%esp)
80105592:	e8 c9 c2 ff ff       	call   80101860 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105597:	58                   	pop    %eax
80105598:	5a                   	pop    %edx
80105599:	57                   	push   %edi
8010559a:	ff 75 d0             	pushl  -0x30(%ebp)
8010559d:	e8 ce cc ff ff       	call   80102270 <nameiparent>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	89 c6                	mov    %eax,%esi
801055a9:	74 59                	je     80105604 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801055ab:	83 ec 0c             	sub    $0xc,%esp
801055ae:	50                   	push   %eax
801055af:	e8 cc c1 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	8b 03                	mov    (%ebx),%eax
801055b9:	39 06                	cmp    %eax,(%esi)
801055bb:	75 3b                	jne    801055f8 <sys_link+0xe8>
801055bd:	83 ec 04             	sub    $0x4,%esp
801055c0:	ff 73 04             	pushl  0x4(%ebx)
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	e8 96 c7 ff ff       	call   80101d60 <dirlink>
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	85 c0                	test   %eax,%eax
801055cf:	78 27                	js     801055f8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801055d1:	83 ec 0c             	sub    $0xc,%esp
801055d4:	56                   	push   %esi
801055d5:	e8 36 c4 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801055da:	89 1c 24             	mov    %ebx,(%esp)
801055dd:	e8 ce c2 ff ff       	call   801018b0 <iput>

  end_op();
801055e2:	e8 89 de ff ff       	call   80103470 <end_op>

  return 0;
801055e7:	83 c4 10             	add    $0x10,%esp
801055ea:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801055ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055ef:	5b                   	pop    %ebx
801055f0:	5e                   	pop    %esi
801055f1:	5f                   	pop    %edi
801055f2:	5d                   	pop    %ebp
801055f3:	c3                   	ret    
801055f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801055f8:	83 ec 0c             	sub    $0xc,%esp
801055fb:	56                   	push   %esi
801055fc:	e8 0f c4 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105601:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105604:	83 ec 0c             	sub    $0xc,%esp
80105607:	53                   	push   %ebx
80105608:	e8 73 c1 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010560d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105612:	89 1c 24             	mov    %ebx,(%esp)
80105615:	e8 a6 c0 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
8010561a:	89 1c 24             	mov    %ebx,(%esp)
8010561d:	e8 ee c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105622:	e8 49 de ff ff       	call   80103470 <end_op>
  return -1;
80105627:	83 c4 10             	add    $0x10,%esp
}
8010562a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010562d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105632:	5b                   	pop    %ebx
80105633:	5e                   	pop    %esi
80105634:	5f                   	pop    %edi
80105635:	5d                   	pop    %ebp
80105636:	c3                   	ret    
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	53                   	push   %ebx
80105644:	e8 c7 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105649:	e8 22 de ff ff       	call   80103470 <end_op>
    return -1;
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105656:	eb 94                	jmp    801055ec <sys_link+0xdc>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old,0)) == 0){
    end_op();
80105658:	e8 13 de ff ff       	call   80103470 <end_op>
    return -1;
8010565d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105662:	eb 88                	jmp    801055ec <sys_link+0xdc>
80105664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010566a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105670 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
80105675:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105676:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105679:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010567c:	50                   	push   %eax
8010567d:	6a 00                	push   $0x0
8010567f:	e8 fc f9 ff ff       	call   80105080 <argstr>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	85 c0                	test   %eax,%eax
80105689:	0f 88 82 01 00 00    	js     80105811 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010568f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105692:	e8 69 dd ff ff       	call   80103400 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105697:	83 ec 08             	sub    $0x8,%esp
8010569a:	53                   	push   %ebx
8010569b:	ff 75 c0             	pushl  -0x40(%ebp)
8010569e:	e8 cd cb ff ff       	call   80102270 <nameiparent>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801056ab:	0f 84 6a 01 00 00    	je     8010581b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
801056b1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	56                   	push   %esi
801056b8:	e8 c3 c0 ff ff       	call   80101780 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056bd:	58                   	pop    %eax
801056be:	5a                   	pop    %edx
801056bf:	68 56 7b 10 80       	push   $0x80107b56
801056c4:	53                   	push   %ebx
801056c5:	e8 c6 c5 ff ff       	call   80101c90 <namecmp>
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	85 c0                	test   %eax,%eax
801056cf:	0f 84 fc 00 00 00    	je     801057d1 <sys_unlink+0x161>
801056d5:	83 ec 08             	sub    $0x8,%esp
801056d8:	68 55 7b 10 80       	push   $0x80107b55
801056dd:	53                   	push   %ebx
801056de:	e8 ad c5 ff ff       	call   80101c90 <namecmp>
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	0f 84 e3 00 00 00    	je     801057d1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801056ee:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056f1:	83 ec 04             	sub    $0x4,%esp
801056f4:	50                   	push   %eax
801056f5:	53                   	push   %ebx
801056f6:	56                   	push   %esi
801056f7:	e8 b4 c5 ff ff       	call   80101cb0 <dirlookup>
801056fc:	83 c4 10             	add    $0x10,%esp
801056ff:	85 c0                	test   %eax,%eax
80105701:	89 c3                	mov    %eax,%ebx
80105703:	0f 84 c8 00 00 00    	je     801057d1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	50                   	push   %eax
8010570d:	e8 6e c0 ff ff       	call   80101780 <ilock>

  if(ip->nlink < 1)
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010571a:	0f 8e 24 01 00 00    	jle    80105844 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105720:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105725:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105728:	74 66                	je     80105790 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010572a:	83 ec 04             	sub    $0x4,%esp
8010572d:	6a 10                	push   $0x10
8010572f:	6a 00                	push   $0x0
80105731:	56                   	push   %esi
80105732:	e8 89 f5 ff ff       	call   80104cc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105737:	6a 10                	push   $0x10
80105739:	ff 75 c4             	pushl  -0x3c(%ebp)
8010573c:	56                   	push   %esi
8010573d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105740:	e8 1b c4 ff ff       	call   80101b60 <writei>
80105745:	83 c4 20             	add    $0x20,%esp
80105748:	83 f8 10             	cmp    $0x10,%eax
8010574b:	0f 85 e6 00 00 00    	jne    80105837 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105751:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105756:	0f 84 9c 00 00 00    	je     801057f8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105762:	e8 a9 c2 ff ff       	call   80101a10 <iunlockput>

  ip->nlink--;
80105767:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010576c:	89 1c 24             	mov    %ebx,(%esp)
8010576f:	e8 4c bf ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80105774:	89 1c 24             	mov    %ebx,(%esp)
80105777:	e8 94 c2 ff ff       	call   80101a10 <iunlockput>

  end_op();
8010577c:	e8 ef dc ff ff       	call   80103470 <end_op>

  return 0;
80105781:	83 c4 10             	add    $0x10,%esp
80105784:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105789:	5b                   	pop    %ebx
8010578a:	5e                   	pop    %esi
8010578b:	5f                   	pop    %edi
8010578c:	5d                   	pop    %ebp
8010578d:	c3                   	ret    
8010578e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105790:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105794:	76 94                	jbe    8010572a <sys_unlink+0xba>
80105796:	bf 20 00 00 00       	mov    $0x20,%edi
8010579b:	eb 0f                	jmp    801057ac <sys_unlink+0x13c>
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
801057a0:	83 c7 10             	add    $0x10,%edi
801057a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801057a6:	0f 83 7e ff ff ff    	jae    8010572a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057ac:	6a 10                	push   $0x10
801057ae:	57                   	push   %edi
801057af:	56                   	push   %esi
801057b0:	53                   	push   %ebx
801057b1:	e8 aa c2 ff ff       	call   80101a60 <readi>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	83 f8 10             	cmp    $0x10,%eax
801057bc:	75 6c                	jne    8010582a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
801057be:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057c3:	74 db                	je     801057a0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	53                   	push   %ebx
801057c9:	e8 42 c2 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801057ce:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801057d1:	83 ec 0c             	sub    $0xc,%esp
801057d4:	ff 75 b4             	pushl  -0x4c(%ebp)
801057d7:	e8 34 c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
801057dc:	e8 8f dc ff ff       	call   80103470 <end_op>
  return -1;
801057e1:	83 c4 10             	add    $0x10,%esp
}
801057e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801057e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ec:	5b                   	pop    %ebx
801057ed:	5e                   	pop    %esi
801057ee:	5f                   	pop    %edi
801057ef:	5d                   	pop    %ebp
801057f0:	c3                   	ret    
801057f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801057f8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801057fb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801057fe:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105803:	50                   	push   %eax
80105804:	e8 b7 be ff ff       	call   801016c0 <iupdate>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	e9 4b ff ff ff       	jmp    8010575c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105816:	e9 6b ff ff ff       	jmp    80105786 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010581b:	e8 50 dc ff ff       	call   80103470 <end_op>
    return -1;
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105825:	e9 5c ff ff ff       	jmp    80105786 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010582a:	83 ec 0c             	sub    $0xc,%esp
8010582d:	68 69 81 10 80       	push   $0x80108169
80105832:	e8 39 ab ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105837:	83 ec 0c             	sub    $0xc,%esp
8010583a:	68 7b 81 10 80       	push   $0x8010817b
8010583f:	e8 2c ab ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	68 57 81 10 80       	push   $0x80108157
8010584c:	e8 1f ab ff ff       	call   80100370 <panic>
80105851:	eb 0d                	jmp    80105860 <sys_open>
80105853:	90                   	nop
80105854:	90                   	nop
80105855:	90                   	nop
80105856:	90                   	nop
80105857:	90                   	nop
80105858:	90                   	nop
80105859:	90                   	nop
8010585a:	90                   	nop
8010585b:	90                   	nop
8010585c:	90                   	nop
8010585d:	90                   	nop
8010585e:	90                   	nop
8010585f:	90                   	nop

80105860 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  char *path;
  int fd, omode, noderef;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105866:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105869:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode, noderef;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010586c:	50                   	push   %eax
8010586d:	6a 00                	push   $0x0
8010586f:	e8 0c f8 ff ff       	call   80105080 <argstr>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	0f 88 9e 00 00 00    	js     8010591d <sys_open+0xbd>
8010587f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105882:	83 ec 08             	sub    $0x8,%esp
80105885:	50                   	push   %eax
80105886:	6a 01                	push   $0x1
80105888:	e8 43 f7 ff ff       	call   80104fd0 <argint>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	0f 88 85 00 00 00    	js     8010591d <sys_open+0xbd>
    return -1;

  begin_op();
80105898:	e8 63 db ff ff       	call   80103400 <begin_op>

  if(omode & O_CREATE){
8010589d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058a0:	f6 c4 02             	test   $0x2,%ah
801058a3:	0f 85 87 00 00 00    	jne    80105930 <sys_open+0xd0>
      end_op();
      return -1;
    }
  } else {
    noderef = omode & O_NODEREF;
    if((ip = namei(path,noderef)) == 0){
801058a9:	83 ec 08             	sub    $0x8,%esp
801058ac:	83 e0 04             	and    $0x4,%eax
801058af:	50                   	push   %eax
801058b0:	ff 75 e0             	pushl  -0x20(%ebp)
801058b3:	e8 78 c9 ff ff       	call   80102230 <namei>
801058b8:	83 c4 10             	add    $0x10,%esp
801058bb:	85 c0                	test   %eax,%eax
801058bd:	89 c6                	mov    %eax,%esi
801058bf:	0f 84 88 00 00 00    	je     8010594d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801058c5:	83 ec 0c             	sub    $0xc,%esp
801058c8:	50                   	push   %eax
801058c9:	e8 b2 be ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY && omode != O_NODEREF){
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058d6:	0f 84 cc 00 00 00    	je     801059a8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058dc:	e8 7f b4 ff ff       	call   80100d60 <filealloc>
801058e1:	85 c0                	test   %eax,%eax
801058e3:	89 c7                	mov    %eax,%edi
801058e5:	74 25                	je     8010590c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801058e7:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801058e9:	e8 42 e7 ff ff       	call   80104030 <myproc>
801058ee:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801058f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058f4:	85 d2                	test   %edx,%edx
801058f6:	74 68                	je     80105960 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801058f8:	83 c3 01             	add    $0x1,%ebx
801058fb:	83 fb 10             	cmp    $0x10,%ebx
801058fe:	75 f0                	jne    801058f0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	57                   	push   %edi
80105904:	e8 17 b5 ff ff       	call   80100e20 <fileclose>
80105909:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010590c:	83 ec 0c             	sub    $0xc,%esp
8010590f:	56                   	push   %esi
80105910:	e8 fb c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105915:	e8 56 db ff ff       	call   80103470 <end_op>
    return -1;
8010591a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010591d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105925:	5b                   	pop    %ebx
80105926:	5e                   	pop    %esi
80105927:	5f                   	pop    %edi
80105928:	5d                   	pop    %ebp
80105929:	c3                   	ret    
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105936:	31 c9                	xor    %ecx,%ecx
80105938:	6a 00                	push   $0x0
8010593a:	ba 02 00 00 00       	mov    $0x2,%edx
8010593f:	e8 dc f7 ff ff       	call   80105120 <create>
    if(ip == 0){
80105944:	83 c4 10             	add    $0x10,%esp
80105947:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105949:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010594b:	75 8f                	jne    801058dc <sys_open+0x7c>
      end_op();
8010594d:	e8 1e db ff ff       	call   80103470 <end_op>
      return -1;
80105952:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105957:	eb 43                	jmp    8010599c <sys_open+0x13c>
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105960:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105963:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105967:	56                   	push   %esi
80105968:	e8 f3 be ff ff       	call   80101860 <iunlock>
  end_op();
8010596d:	e8 fe da ff ff       	call   80103470 <end_op>

  f->type = FD_INODE;
80105972:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105978:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010597b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010597e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105981:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105988:	89 d0                	mov    %edx,%eax
8010598a:	83 e0 01             	and    $0x1,%eax
8010598d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105990:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105993:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105996:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010599a:	89 d8                	mov    %ebx,%eax
}
8010599c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010599f:	5b                   	pop    %ebx
801059a0:	5e                   	pop    %esi
801059a1:	5f                   	pop    %edi
801059a2:	5d                   	pop    %ebp
801059a3:	c3                   	ret    
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path,noderef)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY && omode != O_NODEREF){
801059a8:	f7 45 e4 fb ff ff ff 	testl  $0xfffffffb,-0x1c(%ebp)
801059af:	0f 84 27 ff ff ff    	je     801058dc <sys_open+0x7c>
801059b5:	e9 52 ff ff ff       	jmp    8010590c <sys_open+0xac>
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059c0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059c6:	e8 35 da ff ff       	call   80103400 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	50                   	push   %eax
801059d2:	6a 00                	push   $0x0
801059d4:	e8 a7 f6 ff ff       	call   80105080 <argstr>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	85 c0                	test   %eax,%eax
801059de:	78 30                	js     80105a10 <sys_mkdir+0x50>
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e6:	31 c9                	xor    %ecx,%ecx
801059e8:	6a 00                	push   $0x0
801059ea:	ba 01 00 00 00       	mov    $0x1,%edx
801059ef:	e8 2c f7 ff ff       	call   80105120 <create>
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	85 c0                	test   %eax,%eax
801059f9:	74 15                	je     80105a10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059fb:	83 ec 0c             	sub    $0xc,%esp
801059fe:	50                   	push   %eax
801059ff:	e8 0c c0 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a04:	e8 67 da ff ff       	call   80103470 <end_op>
  return 0;
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	31 c0                	xor    %eax,%eax
}
80105a0e:	c9                   	leave  
80105a0f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105a10:	e8 5b da ff ff       	call   80103470 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_mknod>:

int
sys_mknod(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a26:	e8 d5 d9 ff ff       	call   80103400 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2e:	83 ec 08             	sub    $0x8,%esp
80105a31:	50                   	push   %eax
80105a32:	6a 00                	push   $0x0
80105a34:	e8 47 f6 ff ff       	call   80105080 <argstr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	78 60                	js     80105aa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	50                   	push   %eax
80105a47:	6a 01                	push   $0x1
80105a49:	e8 82 f5 ff ff       	call   80104fd0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	78 4b                	js     80105aa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105a55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	50                   	push   %eax
80105a5c:	6a 02                	push   $0x2
80105a5e:	e8 6d f5 ff ff       	call   80104fd0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 36                	js     80105aa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a6e:	83 ec 0c             	sub    $0xc,%esp
80105a71:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a75:	ba 03 00 00 00       	mov    $0x3,%edx
80105a7a:	50                   	push   %eax
80105a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a7e:	e8 9d f6 ff ff       	call   80105120 <create>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	74 16                	je     80105aa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	50                   	push   %eax
80105a8e:	e8 7d bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a93:	e8 d8 d9 ff ff       	call   80103470 <end_op>
  return 0;
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	31 c0                	xor    %eax,%eax
}
80105a9d:	c9                   	leave  
80105a9e:	c3                   	ret    
80105a9f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105aa0:	e8 cb d9 ff ff       	call   80103470 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_chdir>:

int
sys_chdir(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ab8:	e8 73 e5 ff ff       	call   80104030 <myproc>
80105abd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105abf:	e8 3c d9 ff ff       	call   80103400 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path,0)) == 0){
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac7:	83 ec 08             	sub    $0x8,%esp
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 ae f5 ff ff       	call   80105080 <argstr>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 77                	js     80105b50 <sys_chdir+0xa0>
80105ad9:	83 ec 08             	sub    $0x8,%esp
80105adc:	6a 00                	push   $0x0
80105ade:	ff 75 f4             	pushl  -0xc(%ebp)
80105ae1:	e8 4a c7 ff ff       	call   80102230 <namei>
80105ae6:	83 c4 10             	add    $0x10,%esp
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	89 c3                	mov    %eax,%ebx
80105aed:	74 61                	je     80105b50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aef:	83 ec 0c             	sub    $0xc,%esp
80105af2:	50                   	push   %eax
80105af3:	e8 88 bc ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105af8:	83 c4 10             	add    $0x10,%esp
80105afb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b00:	75 2e                	jne    80105b30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b02:	83 ec 0c             	sub    $0xc,%esp
80105b05:	53                   	push   %ebx
80105b06:	e8 55 bd ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105b0b:	58                   	pop    %eax
80105b0c:	ff 76 68             	pushl  0x68(%esi)
80105b0f:	e8 9c bd ff ff       	call   801018b0 <iput>
  end_op();
80105b14:	e8 57 d9 ff ff       	call   80103470 <end_op>
  curproc->cwd = ip;
80105b19:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b1c:	83 c4 10             	add    $0x10,%esp
80105b1f:	31 c0                	xor    %eax,%eax
}
80105b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b24:	5b                   	pop    %ebx
80105b25:	5e                   	pop    %esi
80105b26:	5d                   	pop    %ebp
80105b27:	c3                   	ret    
80105b28:	90                   	nop
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 d7 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b39:	e8 32 d9 ff ff       	call   80103470 <end_op>
    return -1;
80105b3e:	83 c4 10             	add    $0x10,%esp
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b46:	eb d9                	jmp    80105b21 <sys_chdir+0x71>
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path,0)) == 0){
    end_op();
80105b50:	e8 1b d9 ff ff       	call   80103470 <end_op>
    return -1;
80105b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5a:	eb c5                	jmp    80105b21 <sys_chdir+0x71>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
  int i;
  uint uargv, uarg;
  struct inode *ip;


  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b66:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105b6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  int i;
  uint uargv, uarg;
  struct inode *ip;


  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 06 f5 ff ff       	call   80105080 <argstr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	78 7f                	js     80105c00 <sys_exec+0xa0>
80105b81:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b87:	83 ec 08             	sub    $0x8,%esp
80105b8a:	50                   	push   %eax
80105b8b:	6a 01                	push   $0x1
80105b8d:	e8 3e f4 ff ff       	call   80104fd0 <argint>
80105b92:	83 c4 10             	add    $0x10,%esp
80105b95:	85 c0                	test   %eax,%eax
80105b97:	78 67                	js     80105c00 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b99:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b9f:	83 ec 04             	sub    $0x4,%esp
80105ba2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105ba8:	68 80 00 00 00       	push   $0x80
80105bad:	6a 00                	push   $0x0
80105baf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bb5:	50                   	push   %eax
80105bb6:	31 db                	xor    %ebx,%ebx
80105bb8:	e8 03 f1 ff ff       	call   80104cc0 <memset>
80105bbd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bc0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bc6:	83 ec 08             	sub    $0x8,%esp
80105bc9:	57                   	push   %edi
80105bca:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105bcd:	50                   	push   %eax
80105bce:	e8 5d f3 ff ff       	call   80104f30 <fetchint>
80105bd3:	83 c4 10             	add    $0x10,%esp
80105bd6:	85 c0                	test   %eax,%eax
80105bd8:	78 26                	js     80105c00 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105bda:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105be0:	85 c0                	test   %eax,%eax
80105be2:	74 2c                	je     80105c10 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105be4:	83 ec 08             	sub    $0x8,%esp
80105be7:	56                   	push   %esi
80105be8:	50                   	push   %eax
80105be9:	e8 82 f3 ff ff       	call   80104f70 <fetchstr>
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	85 c0                	test   %eax,%eax
80105bf3:	78 0b                	js     80105c00 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105bf5:	83 c3 01             	add    $0x1,%ebx
80105bf8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105bfb:	83 fb 20             	cmp    $0x20,%ebx
80105bfe:	75 c0                	jne    80105bc0 <sys_exec+0x60>
  
    if((ip = namei(path,0)) == 0)  // task2 - find i-node
      return -1;
  
  return exec(path, argv);
}
80105c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  uint uargv, uarg;
  struct inode *ip;


  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105c03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  
    if((ip = namei(path,0)) == 0)  // task2 - find i-node
      return -1;
  
  return exec(path, argv);
}
80105c08:	5b                   	pop    %ebx
80105c09:	5e                   	pop    %esi
80105c0a:	5f                   	pop    %edi
80105c0b:	5d                   	pop    %ebp
80105c0c:	c3                   	ret    
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  
    if((ip = namei(path,0)) == 0)  // task2 - find i-node
80105c10:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105c13:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c1a:	00 00 00 00 
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  
    if((ip = namei(path,0)) == 0)  // task2 - find i-node
80105c1e:	6a 00                	push   $0x0
80105c20:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c26:	e8 05 c6 ff ff       	call   80102230 <namei>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	74 ce                	je     80105c00 <sys_exec+0xa0>
      return -1;
  
  return exec(path, argv);
80105c32:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c38:	83 ec 08             	sub    $0x8,%esp
80105c3b:	50                   	push   %eax
80105c3c:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c42:	e8 a9 ad ff ff       	call   801009f0 <exec>
80105c47:	83 c4 10             	add    $0x10,%esp
}
80105c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c4d:	5b                   	pop    %ebx
80105c4e:	5e                   	pop    %esi
80105c4f:	5f                   	pop    %edi
80105c50:	5d                   	pop    %ebp
80105c51:	c3                   	ret    
80105c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_pipe>:

int
sys_pipe(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c66:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105c69:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c6c:	6a 08                	push   $0x8
80105c6e:	50                   	push   %eax
80105c6f:	6a 00                	push   $0x0
80105c71:	e8 aa f3 ff ff       	call   80105020 <argptr>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	78 4a                	js     80105cc7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c7d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c80:	83 ec 08             	sub    $0x8,%esp
80105c83:	50                   	push   %eax
80105c84:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c87:	50                   	push   %eax
80105c88:	e8 13 de ff ff       	call   80103aa0 <pipealloc>
80105c8d:	83 c4 10             	add    $0x10,%esp
80105c90:	85 c0                	test   %eax,%eax
80105c92:	78 33                	js     80105cc7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c94:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c96:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105c99:	e8 92 e3 ff ff       	call   80104030 <myproc>
80105c9e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105ca0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ca4:	85 f6                	test   %esi,%esi
80105ca6:	74 30                	je     80105cd8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ca8:	83 c3 01             	add    $0x1,%ebx
80105cab:	83 fb 10             	cmp    $0x10,%ebx
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	ff 75 e0             	pushl  -0x20(%ebp)
80105cb6:	e8 65 b1 ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
80105cbb:	58                   	pop    %eax
80105cbc:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cbf:	e8 5c b1 ff ff       	call   80100e20 <fileclose>
    return -1;
80105cc4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105cca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105ccf:	5b                   	pop    %ebx
80105cd0:	5e                   	pop    %esi
80105cd1:	5f                   	pop    %edi
80105cd2:	5d                   	pop    %ebp
80105cd3:	c3                   	ret    
80105cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105cd8:	8d 73 08             	lea    0x8(%ebx),%esi
80105cdb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cdf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105ce2:	e8 49 e3 ff ff       	call   80104030 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105ce7:	31 d2                	xor    %edx,%edx
80105ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105cf0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cf4:	85 c9                	test   %ecx,%ecx
80105cf6:	74 18                	je     80105d10 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105cf8:	83 c2 01             	add    $0x1,%edx
80105cfb:	83 fa 10             	cmp    $0x10,%edx
80105cfe:	75 f0                	jne    80105cf0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105d00:	e8 2b e3 ff ff       	call   80104030 <myproc>
80105d05:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d0c:	00 
80105d0d:	eb a1                	jmp    80105cb0 <sys_pipe+0x50>
80105d0f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105d10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105d14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105d22:	31 c0                	xor    %eax,%eax
}
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_symlink>:

int
sys_symlink(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	53                   	push   %ebx
   char *oldpath, *newpath;
   struct inode *ip;

    if(argstr(0, &oldpath) < 0 || argstr(1, &newpath) < 0)
80105d34:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_symlink(void)
{
80105d37:	83 ec 1c             	sub    $0x1c,%esp
   char *oldpath, *newpath;
   struct inode *ip;

    if(argstr(0, &oldpath) < 0 || argstr(1, &newpath) < 0)
80105d3a:	50                   	push   %eax
80105d3b:	6a 00                	push   $0x0
80105d3d:	e8 3e f3 ff ff       	call   80105080 <argstr>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	78 77                	js     80105dc0 <sys_symlink+0x90>
80105d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d4c:	83 ec 08             	sub    $0x8,%esp
80105d4f:	50                   	push   %eax
80105d50:	6a 01                	push   $0x1
80105d52:	e8 29 f3 ff ff       	call   80105080 <argstr>
80105d57:	83 c4 10             	add    $0x10,%esp
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	78 62                	js     80105dc0 <sys_symlink+0x90>
      return -1;
    //begin_trans();
    if((ip = create(newpath, T_SYMLINK, 0, 0)) == 0){
80105d5e:	83 ec 0c             	sub    $0xc,%esp
80105d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d64:	31 c9                	xor    %ecx,%ecx
80105d66:	6a 00                	push   $0x0
80105d68:	ba 04 00 00 00       	mov    $0x4,%edx
80105d6d:	e8 ae f3 ff ff       	call   80105120 <create>
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	85 c0                	test   %eax,%eax
80105d77:	89 c3                	mov    %eax,%ebx
80105d79:	74 45                	je     80105dc0 <sys_symlink+0x90>
      //commit_trans();
      return -1;
    }
    
    begin_op();
80105d7b:	e8 80 d6 ff ff       	call   80103400 <begin_op>
    ip->type = T_SYMLINK;
    iupdate(ip);      // update on-disk data
80105d80:	83 ec 0c             	sub    $0xc,%esp
      //commit_trans();
      return -1;
    }
    
    begin_op();
    ip->type = T_SYMLINK;
80105d83:	b8 04 00 00 00       	mov    $0x4,%eax
80105d88:	66 89 43 50          	mov    %ax,0x50(%ebx)
    iupdate(ip);      // update on-disk data
80105d8c:	53                   	push   %ebx
80105d8d:	e8 2e b9 ff ff       	call   801016c0 <iupdate>
    
    writei(ip, oldpath, 0, strlen(oldpath));    // write the old path into the inode of the new one
80105d92:	5a                   	pop    %edx
80105d93:	ff 75 f0             	pushl  -0x10(%ebp)
80105d96:	e8 65 f1 ff ff       	call   80104f00 <strlen>
80105d9b:	50                   	push   %eax
80105d9c:	6a 00                	push   $0x0
80105d9e:	ff 75 f0             	pushl  -0x10(%ebp)
80105da1:	53                   	push   %ebx
80105da2:	e8 b9 bd ff ff       	call   80101b60 <writei>
    
    iunlockput(ip);
80105da7:	83 c4 14             	add    $0x14,%esp
80105daa:	53                   	push   %ebx
80105dab:	e8 60 bc ff ff       	call   80101a10 <iunlockput>
    end_op();
80105db0:	e8 bb d6 ff ff       	call   80103470 <end_op>
    //commit_trans();
    return 0;
80105db5:	83 c4 10             	add    $0x10,%esp
80105db8:	31 c0                	xor    %eax,%eax
}
80105dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dbd:	c9                   	leave  
80105dbe:	c3                   	ret    
80105dbf:	90                   	nop
{
   char *oldpath, *newpath;
   struct inode *ip;

    if(argstr(0, &oldpath) < 0 || argstr(1, &newpath) < 0)
      return -1;
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc5:	eb f3                	jmp    80105dba <sys_symlink+0x8a>
80105dc7:	89 f6                	mov    %esi,%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dd0 <sys_readlink>:
    return 0;
}

int
sys_readlink(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 30             	sub    $0x30,%esp
  char *pathname, *buf;
  int bufsize;
    
  if(argstr(0, &pathname) < 0 || argstr(1, &buf) < 0 || argint(2, &bufsize) < 0)
80105dd6:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105dd9:	50                   	push   %eax
80105dda:	6a 00                	push   $0x0
80105ddc:	e8 9f f2 ff ff       	call   80105080 <argstr>
80105de1:	83 c4 10             	add    $0x10,%esp
80105de4:	85 c0                	test   %eax,%eax
80105de6:	78 68                	js     80105e50 <sys_readlink+0x80>
80105de8:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105deb:	83 ec 08             	sub    $0x8,%esp
80105dee:	50                   	push   %eax
80105def:	6a 01                	push   $0x1
80105df1:	e8 8a f2 ff ff       	call   80105080 <argstr>
80105df6:	83 c4 10             	add    $0x10,%esp
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	78 53                	js     80105e50 <sys_readlink+0x80>
80105dfd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e00:	83 ec 08             	sub    $0x8,%esp
80105e03:	50                   	push   %eax
80105e04:	6a 02                	push   $0x2
80105e06:	e8 c5 f1 ff ff       	call   80104fd0 <argint>
80105e0b:	83 c4 10             	add    $0x10,%esp
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	78 3e                	js     80105e50 <sys_readlink+0x80>
        return -1;

    char name[DIRSIZ];
    int index = 0;
    buf[0] = '\0';
80105e12:	8b 45 dc             	mov    -0x24(%ebp),%eax
    
  if(argstr(0, &pathname) < 0 || argstr(1, &buf) < 0 || argint(2, &bufsize) < 0)
        return -1;

    char name[DIRSIZ];
    int index = 0;
80105e15:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    buf[0] = '\0';
    if (namex(pathname,0, name, 0, 0, 0, buf, &index, bufsize) == 0)
80105e1c:	83 ec 0c             	sub    $0xc,%esp
  if(argstr(0, &pathname) < 0 || argstr(1, &buf) < 0 || argint(2, &bufsize) < 0)
        return -1;

    char name[DIRSIZ];
    int index = 0;
    buf[0] = '\0';
80105e1f:	c6 00 00             	movb   $0x0,(%eax)
    if (namex(pathname,0, name, 0, 0, 0, buf, &index, bufsize) == 0)
80105e22:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e25:	ff 75 e0             	pushl  -0x20(%ebp)
80105e28:	50                   	push   %eax
80105e29:	8d 45 ea             	lea    -0x16(%ebp),%eax
80105e2c:	ff 75 dc             	pushl  -0x24(%ebp)
80105e2f:	6a 00                	push   $0x0
80105e31:	6a 00                	push   $0x0
80105e33:	6a 00                	push   $0x0
80105e35:	50                   	push   %eax
80105e36:	6a 00                	push   $0x0
80105e38:	ff 75 d8             	pushl  -0x28(%ebp)
80105e3b:	e8 e0 bf ff ff       	call   80101e20 <namex>
80105e40:	83 c4 30             	add    $0x30,%esp
80105e43:	85 c0                	test   %eax,%eax
80105e45:	74 09                	je     80105e50 <sys_readlink+0x80>
    return -1;
    
  return index;
80105e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80105e4a:	c9                   	leave  
80105e4b:	c3                   	ret    
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *pathname, *buf;
  int bufsize;
    
  if(argstr(0, &pathname) < 0 || argstr(1, &buf) < 0 || argint(2, &bufsize) < 0)
        return -1;
80105e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    buf[0] = '\0';
    if (namex(pathname,0, name, 0, 0, 0, buf, &index, bufsize) == 0)
    return -1;
    
  return index;
}
80105e55:	c9                   	leave  
80105e56:	c3                   	ret    
80105e57:	89 f6                	mov    %esi,%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e60 <sys_ftag>:

int
sys_ftag(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 20             	sub    $0x20,%esp
    int fd;
    char* key;
    char* value; 
    
    if(argint(0, &fd)<0 || argstr(1, &key)<0 || argstr(2, &value)<0)
80105e66:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e69:	50                   	push   %eax
80105e6a:	6a 00                	push   $0x0
80105e6c:	e8 5f f1 ff ff       	call   80104fd0 <argint>
80105e71:	83 c4 10             	add    $0x10,%esp
80105e74:	85 c0                	test   %eax,%eax
80105e76:	78 48                	js     80105ec0 <sys_ftag+0x60>
80105e78:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e7b:	83 ec 08             	sub    $0x8,%esp
80105e7e:	50                   	push   %eax
80105e7f:	6a 01                	push   $0x1
80105e81:	e8 fa f1 ff ff       	call   80105080 <argstr>
80105e86:	83 c4 10             	add    $0x10,%esp
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	78 33                	js     80105ec0 <sys_ftag+0x60>
80105e8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e90:	83 ec 08             	sub    $0x8,%esp
80105e93:	50                   	push   %eax
80105e94:	6a 02                	push   $0x2
80105e96:	e8 e5 f1 ff ff       	call   80105080 <argstr>
80105e9b:	83 c4 10             	add    $0x10,%esp
80105e9e:	85 c0                	test   %eax,%eax
80105ea0:	78 1e                	js     80105ec0 <sys_ftag+0x60>
        return -1;
    //cprintf("fd: %d\nkey: %s\nvalue: %s\n", fd, key, value);  
    return ftag(fd, key, value);
80105ea2:	83 ec 04             	sub    $0x4,%esp
80105ea5:	ff 75 f4             	pushl  -0xc(%ebp)
80105ea8:	ff 75 f0             	pushl  -0x10(%ebp)
80105eab:	ff 75 ec             	pushl  -0x14(%ebp)
80105eae:	e8 fd c4 ff ff       	call   801023b0 <ftag>
80105eb3:	83 c4 10             	add    $0x10,%esp
}
80105eb6:	c9                   	leave  
80105eb7:	c3                   	ret    
80105eb8:	90                   	nop
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    int fd;
    char* key;
    char* value; 
    
    if(argint(0, &fd)<0 || argstr(1, &key)<0 || argstr(2, &value)<0)
        return -1;
80105ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    //cprintf("fd: %d\nkey: %s\nvalue: %s\n", fd, key, value);  
    return ftag(fd, key, value);
}
80105ec5:	c9                   	leave  
80105ec6:	c3                   	ret    
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ed0 <sys_funtag>:

int
sys_funtag(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 20             	sub    $0x20,%esp
    int fd;
    char* key;
    if(argint(0, &fd)<0 || argstr(1, &key)<0)
80105ed6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ed9:	50                   	push   %eax
80105eda:	6a 00                	push   $0x0
80105edc:	e8 ef f0 ff ff       	call   80104fd0 <argint>
80105ee1:	83 c4 10             	add    $0x10,%esp
80105ee4:	85 c0                	test   %eax,%eax
80105ee6:	78 28                	js     80105f10 <sys_funtag+0x40>
80105ee8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eeb:	83 ec 08             	sub    $0x8,%esp
80105eee:	50                   	push   %eax
80105eef:	6a 01                	push   $0x1
80105ef1:	e8 8a f1 ff ff       	call   80105080 <argstr>
80105ef6:	83 c4 10             	add    $0x10,%esp
80105ef9:	85 c0                	test   %eax,%eax
80105efb:	78 13                	js     80105f10 <sys_funtag+0x40>
        return -1;  
    return funtag(fd, key);
80105efd:	83 ec 08             	sub    $0x8,%esp
80105f00:	ff 75 f4             	pushl  -0xc(%ebp)
80105f03:	ff 75 f0             	pushl  -0x10(%ebp)
80105f06:	e8 65 c6 ff ff       	call   80102570 <funtag>
80105f0b:	83 c4 10             	add    $0x10,%esp
}
80105f0e:	c9                   	leave  
80105f0f:	c3                   	ret    
sys_funtag(void)
{
    int fd;
    char* key;
    if(argint(0, &fd)<0 || argstr(1, &key)<0)
        return -1;  
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return funtag(fd, key);
}
80105f15:	c9                   	leave  
80105f16:	c3                   	ret    
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f20 <sys_gettag>:

int
sys_gettag(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 20             	sub    $0x20,%esp
    int fd;
    char* key;
    char* buf; 
    if(argint(0, &fd)<0 || argstr(1, &key)<0 || argstr(2, &buf)<0)
80105f26:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f29:	50                   	push   %eax
80105f2a:	6a 00                	push   $0x0
80105f2c:	e8 9f f0 ff ff       	call   80104fd0 <argint>
80105f31:	83 c4 10             	add    $0x10,%esp
80105f34:	85 c0                	test   %eax,%eax
80105f36:	78 48                	js     80105f80 <sys_gettag+0x60>
80105f38:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f3b:	83 ec 08             	sub    $0x8,%esp
80105f3e:	50                   	push   %eax
80105f3f:	6a 01                	push   $0x1
80105f41:	e8 3a f1 ff ff       	call   80105080 <argstr>
80105f46:	83 c4 10             	add    $0x10,%esp
80105f49:	85 c0                	test   %eax,%eax
80105f4b:	78 33                	js     80105f80 <sys_gettag+0x60>
80105f4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f50:	83 ec 08             	sub    $0x8,%esp
80105f53:	50                   	push   %eax
80105f54:	6a 02                	push   $0x2
80105f56:	e8 25 f1 ff ff       	call   80105080 <argstr>
80105f5b:	83 c4 10             	add    $0x10,%esp
80105f5e:	85 c0                	test   %eax,%eax
80105f60:	78 1e                	js     80105f80 <sys_gettag+0x60>
        return -1;  
    //cprintf("fd: %d\nkey: %s\nbuf: %s\n", fd, key, buf);  
    return gettag(fd, key, buf);
80105f62:	83 ec 04             	sub    $0x4,%esp
80105f65:	ff 75 f4             	pushl  -0xc(%ebp)
80105f68:	ff 75 f0             	pushl  -0x10(%ebp)
80105f6b:	ff 75 ec             	pushl  -0x14(%ebp)
80105f6e:	e8 0d c7 ff ff       	call   80102680 <gettag>
80105f73:	83 c4 10             	add    $0x10,%esp
}
80105f76:	c9                   	leave  
80105f77:	c3                   	ret    
80105f78:	90                   	nop
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
    int fd;
    char* key;
    char* buf; 
    if(argint(0, &fd)<0 || argstr(1, &key)<0 || argstr(2, &buf)<0)
        return -1;  
80105f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    //cprintf("fd: %d\nkey: %s\nbuf: %s\n", fd, key, buf);  
    return gettag(fd, key, buf);
}
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    
80105f87:	66 90                	xchg   %ax,%ax
80105f89:	66 90                	xchg   %ax,%ax
80105f8b:	66 90                	xchg   %ax,%ax
80105f8d:	66 90                	xchg   %ax,%ax
80105f8f:	90                   	nop

80105f90 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105f93:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105f94:	e9 37 e2 ff ff       	jmp    801041d0 <fork>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <sys_exit>:
}

int
sys_exit(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fa6:	e8 b5 e4 ff ff       	call   80104460 <exit>
  return 0;  // not reached
}
80105fab:	31 c0                	xor    %eax,%eax
80105fad:	c9                   	leave  
80105fae:	c3                   	ret    
80105faf:	90                   	nop

80105fb0 <sys_wait>:

int
sys_wait(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105fb3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105fb4:	e9 e7 e6 ff ff       	jmp    801046a0 <wait>
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fc0 <sys_kill>:
}

int
sys_kill(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0)
80105fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc9:	50                   	push   %eax
80105fca:	6a 00                	push   $0x0
80105fcc:	e8 ff ef ff ff       	call   80104fd0 <argint>
80105fd1:	83 c4 10             	add    $0x10,%esp
80105fd4:	85 c0                	test   %eax,%eax
80105fd6:	78 18                	js     80105ff0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fd8:	83 ec 0c             	sub    $0xc,%esp
80105fdb:	ff 75 f4             	pushl  -0xc(%ebp)
80105fde:	e8 0d e8 ff ff       	call   801047f0 <kill>
80105fe3:	83 c4 10             	add    $0x10,%esp
}
80105fe6:	c9                   	leave  
80105fe7:	c3                   	ret    
80105fe8:	90                   	nop
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int
sys_kill(void)
{
  int pid;
  if(argint(0, &pid) < 0)
    return -1;
80105ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105ff5:	c9                   	leave  
80105ff6:	c3                   	ret    
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106000 <sys_getpid>:

int
sys_getpid(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106006:	e8 25 e0 ff ff       	call   80104030 <myproc>
8010600b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010600e:	c9                   	leave  
8010600f:	c3                   	ret    

80106010 <sys_sbrk>:

int
sys_sbrk(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106014:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80106017:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010601a:	50                   	push   %eax
8010601b:	6a 00                	push   $0x0
8010601d:	e8 ae ef ff ff       	call   80104fd0 <argint>
80106022:	83 c4 10             	add    $0x10,%esp
80106025:	85 c0                	test   %eax,%eax
80106027:	78 27                	js     80106050 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106029:	e8 02 e0 ff ff       	call   80104030 <myproc>
  if(growproc(n) < 0)
8010602e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80106031:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106033:	ff 75 f4             	pushl  -0xc(%ebp)
80106036:	e8 15 e1 ff ff       	call   80104150 <growproc>
8010603b:	83 c4 10             	add    $0x10,%esp
8010603e:	85 c0                	test   %eax,%eax
80106040:	78 0e                	js     80106050 <sys_sbrk+0x40>
    return -1;
  return addr;
80106042:	89 d8                	mov    %ebx,%eax
}
80106044:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106047:	c9                   	leave  
80106048:	c3                   	ret    
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80106050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106055:	eb ed                	jmp    80106044 <sys_sbrk+0x34>
80106057:	89 f6                	mov    %esi,%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106060 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106064:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80106067:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010606a:	50                   	push   %eax
8010606b:	6a 00                	push   $0x0
8010606d:	e8 5e ef ff ff       	call   80104fd0 <argint>
80106072:	83 c4 10             	add    $0x10,%esp
80106075:	85 c0                	test   %eax,%eax
80106077:	0f 88 8a 00 00 00    	js     80106107 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010607d:	83 ec 0c             	sub    $0xc,%esp
80106080:	68 00 5e 11 80       	push   $0x80115e00
80106085:	e8 c6 ea ff ff       	call   80104b50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010608a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010608d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80106090:	8b 1d 40 66 11 80    	mov    0x80116640,%ebx
  while(ticks - ticks0 < n){
80106096:	85 d2                	test   %edx,%edx
80106098:	75 27                	jne    801060c1 <sys_sleep+0x61>
8010609a:	eb 54                	jmp    801060f0 <sys_sleep+0x90>
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801060a0:	83 ec 08             	sub    $0x8,%esp
801060a3:	68 00 5e 11 80       	push   $0x80115e00
801060a8:	68 40 66 11 80       	push   $0x80116640
801060ad:	e8 2e e5 ff ff       	call   801045e0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060b2:	a1 40 66 11 80       	mov    0x80116640,%eax
801060b7:	83 c4 10             	add    $0x10,%esp
801060ba:	29 d8                	sub    %ebx,%eax
801060bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060bf:	73 2f                	jae    801060f0 <sys_sleep+0x90>
    if(myproc()->killed){
801060c1:	e8 6a df ff ff       	call   80104030 <myproc>
801060c6:	8b 40 24             	mov    0x24(%eax),%eax
801060c9:	85 c0                	test   %eax,%eax
801060cb:	74 d3                	je     801060a0 <sys_sleep+0x40>
      release(&tickslock);
801060cd:	83 ec 0c             	sub    $0xc,%esp
801060d0:	68 00 5e 11 80       	push   $0x80115e00
801060d5:	e8 96 eb ff ff       	call   80104c70 <release>
      return -1;
801060da:	83 c4 10             	add    $0x10,%esp
801060dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801060e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
801060e7:	89 f6                	mov    %esi,%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	68 00 5e 11 80       	push   $0x80115e00
801060f8:	e8 73 eb ff ff       	call   80104c70 <release>
  return 0;
801060fd:	83 c4 10             	add    $0x10,%esp
80106100:	31 c0                	xor    %eax,%eax
}
80106102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106105:	c9                   	leave  
80106106:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80106107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610c:	eb d4                	jmp    801060e2 <sys_sleep+0x82>
8010610e:	66 90                	xchg   %ax,%ax

80106110 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	53                   	push   %ebx
80106114:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106117:	68 00 5e 11 80       	push   $0x80115e00
8010611c:	e8 2f ea ff ff       	call   80104b50 <acquire>
  xticks = ticks;
80106121:	8b 1d 40 66 11 80    	mov    0x80116640,%ebx
  release(&tickslock);
80106127:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
8010612e:	e8 3d eb ff ff       	call   80104c70 <release>
  return xticks;
}
80106133:	89 d8                	mov    %ebx,%eax
80106135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106138:	c9                   	leave  
80106139:	c3                   	ret    

8010613a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010613a:	1e                   	push   %ds
  pushl %es
8010613b:	06                   	push   %es
  pushl %fs
8010613c:	0f a0                	push   %fs
  pushl %gs
8010613e:	0f a8                	push   %gs
  pushal
80106140:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106141:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106145:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106147:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106149:	54                   	push   %esp
  call trap
8010614a:	e8 e1 00 00 00       	call   80106230 <trap>
  addl $4, %esp
8010614f:	83 c4 04             	add    $0x4,%esp

80106152 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106152:	61                   	popa   
  popl %gs
80106153:	0f a9                	pop    %gs
  popl %fs
80106155:	0f a1                	pop    %fs
  popl %es
80106157:	07                   	pop    %es
  popl %ds
80106158:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106159:	83 c4 08             	add    $0x8,%esp
  iret
8010615c:	cf                   	iret   
8010615d:	66 90                	xchg   %ax,%ax
8010615f:	90                   	nop

80106160 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106160:	31 c0                	xor    %eax,%eax
80106162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106168:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
8010616f:	b9 08 00 00 00       	mov    $0x8,%ecx
80106174:	c6 04 c5 44 5e 11 80 	movb   $0x0,-0x7feea1bc(,%eax,8)
8010617b:	00 
8010617c:	66 89 0c c5 42 5e 11 	mov    %cx,-0x7feea1be(,%eax,8)
80106183:	80 
80106184:	c6 04 c5 45 5e 11 80 	movb   $0x8e,-0x7feea1bb(,%eax,8)
8010618b:	8e 
8010618c:	66 89 14 c5 40 5e 11 	mov    %dx,-0x7feea1c0(,%eax,8)
80106193:	80 
80106194:	c1 ea 10             	shr    $0x10,%edx
80106197:	66 89 14 c5 46 5e 11 	mov    %dx,-0x7feea1ba(,%eax,8)
8010619e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010619f:	83 c0 01             	add    $0x1,%eax
801061a2:	3d 00 01 00 00       	cmp    $0x100,%eax
801061a7:	75 bf                	jne    80106168 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061a9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061aa:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061af:	89 e5                	mov    %esp,%ebp
801061b1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061b4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801061b9:	68 8a 81 10 80       	push   $0x8010818a
801061be:	68 00 5e 11 80       	push   $0x80115e00
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061c3:	66 89 15 42 60 11 80 	mov    %dx,0x80116042
801061ca:	c6 05 44 60 11 80 00 	movb   $0x0,0x80116044
801061d1:	66 a3 40 60 11 80    	mov    %ax,0x80116040
801061d7:	c1 e8 10             	shr    $0x10,%eax
801061da:	c6 05 45 60 11 80 ef 	movb   $0xef,0x80116045
801061e1:	66 a3 46 60 11 80    	mov    %ax,0x80116046

  initlock(&tickslock, "time");
801061e7:	e8 64 e8 ff ff       	call   80104a50 <initlock>
}
801061ec:	83 c4 10             	add    $0x10,%esp
801061ef:	c9                   	leave  
801061f0:	c3                   	ret    
801061f1:	eb 0d                	jmp    80106200 <idtinit>
801061f3:	90                   	nop
801061f4:	90                   	nop
801061f5:	90                   	nop
801061f6:	90                   	nop
801061f7:	90                   	nop
801061f8:	90                   	nop
801061f9:	90                   	nop
801061fa:	90                   	nop
801061fb:	90                   	nop
801061fc:	90                   	nop
801061fd:	90                   	nop
801061fe:	90                   	nop
801061ff:	90                   	nop

80106200 <idtinit>:

void
idtinit(void)
{
80106200:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106201:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106206:	89 e5                	mov    %esp,%ebp
80106208:	83 ec 10             	sub    $0x10,%esp
8010620b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010620f:	b8 40 5e 11 80       	mov    $0x80115e40,%eax
80106214:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106218:	c1 e8 10             	shr    $0x10,%eax
8010621b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010621f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106222:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106225:	c9                   	leave  
80106226:	c3                   	ret    
80106227:	89 f6                	mov    %esi,%esi
80106229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106230 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	57                   	push   %edi
80106234:	56                   	push   %esi
80106235:	53                   	push   %ebx
80106236:	83 ec 1c             	sub    $0x1c,%esp
80106239:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010623c:	8b 47 30             	mov    0x30(%edi),%eax
8010623f:	83 f8 40             	cmp    $0x40,%eax
80106242:	0f 84 88 01 00 00    	je     801063d0 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106248:	83 e8 20             	sub    $0x20,%eax
8010624b:	83 f8 1f             	cmp    $0x1f,%eax
8010624e:	77 10                	ja     80106260 <trap+0x30>
80106250:	ff 24 85 30 82 10 80 	jmp    *-0x7fef7dd0(,%eax,4)
80106257:	89 f6                	mov    %esi,%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106260:	e8 cb dd ff ff       	call   80104030 <myproc>
80106265:	85 c0                	test   %eax,%eax
80106267:	0f 84 d7 01 00 00    	je     80106444 <trap+0x214>
8010626d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106271:	0f 84 cd 01 00 00    	je     80106444 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106277:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010627a:	8b 57 38             	mov    0x38(%edi),%edx
8010627d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106280:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106283:	e8 88 dd ff ff       	call   80104010 <cpuid>
80106288:	8b 77 34             	mov    0x34(%edi),%esi
8010628b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010628e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106291:	e8 9a dd ff ff       	call   80104030 <myproc>
80106296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106299:	e8 92 dd ff ff       	call   80104030 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062a4:	51                   	push   %ecx
801062a5:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801062a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801062ac:	56                   	push   %esi
801062ad:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801062ae:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062b1:	52                   	push   %edx
801062b2:	ff 70 10             	pushl  0x10(%eax)
801062b5:	68 ec 81 10 80       	push   $0x801081ec
801062ba:	e8 a1 a3 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062bf:	83 c4 20             	add    $0x20,%esp
801062c2:	e8 69 dd ff ff       	call   80104030 <myproc>
801062c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801062ce:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062d0:	e8 5b dd ff ff       	call   80104030 <myproc>
801062d5:	85 c0                	test   %eax,%eax
801062d7:	74 0c                	je     801062e5 <trap+0xb5>
801062d9:	e8 52 dd ff ff       	call   80104030 <myproc>
801062de:	8b 50 24             	mov    0x24(%eax),%edx
801062e1:	85 d2                	test   %edx,%edx
801062e3:	75 4b                	jne    80106330 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062e5:	e8 46 dd ff ff       	call   80104030 <myproc>
801062ea:	85 c0                	test   %eax,%eax
801062ec:	74 0b                	je     801062f9 <trap+0xc9>
801062ee:	e8 3d dd ff ff       	call   80104030 <myproc>
801062f3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062f7:	74 4f                	je     80106348 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062f9:	e8 32 dd ff ff       	call   80104030 <myproc>
801062fe:	85 c0                	test   %eax,%eax
80106300:	74 1d                	je     8010631f <trap+0xef>
80106302:	e8 29 dd ff ff       	call   80104030 <myproc>
80106307:	8b 40 24             	mov    0x24(%eax),%eax
8010630a:	85 c0                	test   %eax,%eax
8010630c:	74 11                	je     8010631f <trap+0xef>
8010630e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106312:	83 e0 03             	and    $0x3,%eax
80106315:	66 83 f8 03          	cmp    $0x3,%ax
80106319:	0f 84 da 00 00 00    	je     801063f9 <trap+0x1c9>
    exit();
}
8010631f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106322:	5b                   	pop    %ebx
80106323:	5e                   	pop    %esi
80106324:	5f                   	pop    %edi
80106325:	5d                   	pop    %ebp
80106326:	c3                   	ret    
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106330:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106334:	83 e0 03             	and    $0x3,%eax
80106337:	66 83 f8 03          	cmp    $0x3,%ax
8010633b:	75 a8                	jne    801062e5 <trap+0xb5>
    exit();
8010633d:	e8 1e e1 ff ff       	call   80104460 <exit>
80106342:	eb a1                	jmp    801062e5 <trap+0xb5>
80106344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106348:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010634c:	75 ab                	jne    801062f9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010634e:	e8 3d e2 ff ff       	call   80104590 <yield>
80106353:	eb a4                	jmp    801062f9 <trap+0xc9>
80106355:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106358:	e8 b3 dc ff ff       	call   80104010 <cpuid>
8010635d:	85 c0                	test   %eax,%eax
8010635f:	0f 84 ab 00 00 00    	je     80106410 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106365:	e8 56 cc ff ff       	call   80102fc0 <lapiceoi>
    break;
8010636a:	e9 61 ff ff ff       	jmp    801062d0 <trap+0xa0>
8010636f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106370:	e8 0b cb ff ff       	call   80102e80 <kbdintr>
    lapiceoi();
80106375:	e8 46 cc ff ff       	call   80102fc0 <lapiceoi>
    break;
8010637a:	e9 51 ff ff ff       	jmp    801062d0 <trap+0xa0>
8010637f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106380:	e8 5b 02 00 00       	call   801065e0 <uartintr>
    lapiceoi();
80106385:	e8 36 cc ff ff       	call   80102fc0 <lapiceoi>
    break;
8010638a:	e9 41 ff ff ff       	jmp    801062d0 <trap+0xa0>
8010638f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106390:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106394:	8b 77 38             	mov    0x38(%edi),%esi
80106397:	e8 74 dc ff ff       	call   80104010 <cpuid>
8010639c:	56                   	push   %esi
8010639d:	53                   	push   %ebx
8010639e:	50                   	push   %eax
8010639f:	68 94 81 10 80       	push   $0x80108194
801063a4:	e8 b7 a2 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801063a9:	e8 12 cc ff ff       	call   80102fc0 <lapiceoi>
    break;
801063ae:	83 c4 10             	add    $0x10,%esp
801063b1:	e9 1a ff ff ff       	jmp    801062d0 <trap+0xa0>
801063b6:	8d 76 00             	lea    0x0(%esi),%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801063c0:	e8 3b c5 ff ff       	call   80102900 <ideintr>
801063c5:	eb 9e                	jmp    80106365 <trap+0x135>
801063c7:	89 f6                	mov    %esi,%esi
801063c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801063d0:	e8 5b dc ff ff       	call   80104030 <myproc>
801063d5:	8b 58 24             	mov    0x24(%eax),%ebx
801063d8:	85 db                	test   %ebx,%ebx
801063da:	75 2c                	jne    80106408 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
801063dc:	e8 4f dc ff ff       	call   80104030 <myproc>
801063e1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801063e4:	e8 d7 ec ff ff       	call   801050c0 <syscall>
    if(myproc()->killed)
801063e9:	e8 42 dc ff ff       	call   80104030 <myproc>
801063ee:	8b 48 24             	mov    0x24(%eax),%ecx
801063f1:	85 c9                	test   %ecx,%ecx
801063f3:	0f 84 26 ff ff ff    	je     8010631f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801063f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063fc:	5b                   	pop    %ebx
801063fd:	5e                   	pop    %esi
801063fe:	5f                   	pop    %edi
801063ff:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106400:	e9 5b e0 ff ff       	jmp    80104460 <exit>
80106405:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106408:	e8 53 e0 ff ff       	call   80104460 <exit>
8010640d:	eb cd                	jmp    801063dc <trap+0x1ac>
8010640f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106410:	83 ec 0c             	sub    $0xc,%esp
80106413:	68 00 5e 11 80       	push   $0x80115e00
80106418:	e8 33 e7 ff ff       	call   80104b50 <acquire>
      ticks++;
      wakeup(&ticks);
8010641d:	c7 04 24 40 66 11 80 	movl   $0x80116640,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106424:	83 05 40 66 11 80 01 	addl   $0x1,0x80116640
      wakeup(&ticks);
8010642b:	e8 60 e3 ff ff       	call   80104790 <wakeup>
      release(&tickslock);
80106430:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
80106437:	e8 34 e8 ff ff       	call   80104c70 <release>
8010643c:	83 c4 10             	add    $0x10,%esp
8010643f:	e9 21 ff ff ff       	jmp    80106365 <trap+0x135>
80106444:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106447:	8b 5f 38             	mov    0x38(%edi),%ebx
8010644a:	e8 c1 db ff ff       	call   80104010 <cpuid>
8010644f:	83 ec 0c             	sub    $0xc,%esp
80106452:	56                   	push   %esi
80106453:	53                   	push   %ebx
80106454:	50                   	push   %eax
80106455:	ff 77 30             	pushl  0x30(%edi)
80106458:	68 b8 81 10 80       	push   $0x801081b8
8010645d:	e8 fe a1 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106462:	83 c4 14             	add    $0x14,%esp
80106465:	68 8f 81 10 80       	push   $0x8010818f
8010646a:	e8 01 9f ff ff       	call   80100370 <panic>
8010646f:	90                   	nop

80106470 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106470:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106475:	55                   	push   %ebp
80106476:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106478:	85 c0                	test   %eax,%eax
8010647a:	74 1c                	je     80106498 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010647c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106481:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106482:	a8 01                	test   $0x1,%al
80106484:	74 12                	je     80106498 <uartgetc+0x28>
80106486:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010648c:	0f b6 c0             	movzbl %al,%eax
}
8010648f:	5d                   	pop    %ebp
80106490:	c3                   	ret    
80106491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010649d:	5d                   	pop    %ebp
8010649e:	c3                   	ret    
8010649f:	90                   	nop

801064a0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	56                   	push   %esi
801064a5:	53                   	push   %ebx
801064a6:	89 c7                	mov    %eax,%edi
801064a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801064ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801064b2:	83 ec 0c             	sub    $0xc,%esp
801064b5:	eb 1b                	jmp    801064d2 <uartputc.part.0+0x32>
801064b7:	89 f6                	mov    %esi,%esi
801064b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	6a 0a                	push   $0xa
801064c5:	e8 16 cb ff ff       	call   80102fe0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ca:	83 c4 10             	add    $0x10,%esp
801064cd:	83 eb 01             	sub    $0x1,%ebx
801064d0:	74 07                	je     801064d9 <uartputc.part.0+0x39>
801064d2:	89 f2                	mov    %esi,%edx
801064d4:	ec                   	in     (%dx),%al
801064d5:	a8 20                	test   $0x20,%al
801064d7:	74 e7                	je     801064c0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064de:	89 f8                	mov    %edi,%eax
801064e0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
801064e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e4:	5b                   	pop    %ebx
801064e5:	5e                   	pop    %esi
801064e6:	5f                   	pop    %edi
801064e7:	5d                   	pop    %ebp
801064e8:	c3                   	ret    
801064e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064f0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801064f0:	55                   	push   %ebp
801064f1:	31 c9                	xor    %ecx,%ecx
801064f3:	89 c8                	mov    %ecx,%eax
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	57                   	push   %edi
801064f8:	56                   	push   %esi
801064f9:	53                   	push   %ebx
801064fa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064ff:	89 da                	mov    %ebx,%edx
80106501:	83 ec 0c             	sub    $0xc,%esp
80106504:	ee                   	out    %al,(%dx)
80106505:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010650a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010650f:	89 fa                	mov    %edi,%edx
80106511:	ee                   	out    %al,(%dx)
80106512:	b8 0c 00 00 00       	mov    $0xc,%eax
80106517:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010651c:	ee                   	out    %al,(%dx)
8010651d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106522:	89 c8                	mov    %ecx,%eax
80106524:	89 f2                	mov    %esi,%edx
80106526:	ee                   	out    %al,(%dx)
80106527:	b8 03 00 00 00       	mov    $0x3,%eax
8010652c:	89 fa                	mov    %edi,%edx
8010652e:	ee                   	out    %al,(%dx)
8010652f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106534:	89 c8                	mov    %ecx,%eax
80106536:	ee                   	out    %al,(%dx)
80106537:	b8 01 00 00 00       	mov    $0x1,%eax
8010653c:	89 f2                	mov    %esi,%edx
8010653e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010653f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106544:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106545:	3c ff                	cmp    $0xff,%al
80106547:	74 5a                	je     801065a3 <uartinit+0xb3>
    return;
  uart = 1;
80106549:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106550:	00 00 00 
80106553:	89 da                	mov    %ebx,%edx
80106555:	ec                   	in     (%dx),%al
80106556:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010655c:	83 ec 08             	sub    $0x8,%esp
8010655f:	bb b0 82 10 80       	mov    $0x801082b0,%ebx
80106564:	6a 00                	push   $0x0
80106566:	6a 04                	push   $0x4
80106568:	e8 e3 c5 ff ff       	call   80102b50 <ioapicenable>
8010656d:	83 c4 10             	add    $0x10,%esp
80106570:	b8 78 00 00 00       	mov    $0x78,%eax
80106575:	eb 13                	jmp    8010658a <uartinit+0x9a>
80106577:	89 f6                	mov    %esi,%esi
80106579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106580:	83 c3 01             	add    $0x1,%ebx
80106583:	0f be 03             	movsbl (%ebx),%eax
80106586:	84 c0                	test   %al,%al
80106588:	74 19                	je     801065a3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010658a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106590:	85 d2                	test   %edx,%edx
80106592:	74 ec                	je     80106580 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106594:	83 c3 01             	add    $0x1,%ebx
80106597:	e8 04 ff ff ff       	call   801064a0 <uartputc.part.0>
8010659c:	0f be 03             	movsbl (%ebx),%eax
8010659f:	84 c0                	test   %al,%al
801065a1:	75 e7                	jne    8010658a <uartinit+0x9a>
    uartputc(*p);
}
801065a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065a6:	5b                   	pop    %ebx
801065a7:	5e                   	pop    %esi
801065a8:	5f                   	pop    %edi
801065a9:	5d                   	pop    %ebp
801065aa:	c3                   	ret    
801065ab:	90                   	nop
801065ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065b0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801065b0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801065b6:	55                   	push   %ebp
801065b7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
801065b9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801065bb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
801065be:	74 10                	je     801065d0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801065c0:	5d                   	pop    %ebp
801065c1:	e9 da fe ff ff       	jmp    801064a0 <uartputc.part.0>
801065c6:	8d 76 00             	lea    0x0(%esi),%esi
801065c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret    
801065d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065e6:	68 70 64 10 80       	push   $0x80106470
801065eb:	e8 00 a2 ff ff       	call   801007f0 <consoleintr>
}
801065f0:	83 c4 10             	add    $0x10,%esp
801065f3:	c9                   	leave  
801065f4:	c3                   	ret    

801065f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $0
801065f7:	6a 00                	push   $0x0
  jmp alltraps
801065f9:	e9 3c fb ff ff       	jmp    8010613a <alltraps>

801065fe <vector1>:
.globl vector1
vector1:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $1
80106600:	6a 01                	push   $0x1
  jmp alltraps
80106602:	e9 33 fb ff ff       	jmp    8010613a <alltraps>

80106607 <vector2>:
.globl vector2
vector2:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $2
80106609:	6a 02                	push   $0x2
  jmp alltraps
8010660b:	e9 2a fb ff ff       	jmp    8010613a <alltraps>

80106610 <vector3>:
.globl vector3
vector3:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $3
80106612:	6a 03                	push   $0x3
  jmp alltraps
80106614:	e9 21 fb ff ff       	jmp    8010613a <alltraps>

80106619 <vector4>:
.globl vector4
vector4:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $4
8010661b:	6a 04                	push   $0x4
  jmp alltraps
8010661d:	e9 18 fb ff ff       	jmp    8010613a <alltraps>

80106622 <vector5>:
.globl vector5
vector5:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $5
80106624:	6a 05                	push   $0x5
  jmp alltraps
80106626:	e9 0f fb ff ff       	jmp    8010613a <alltraps>

8010662b <vector6>:
.globl vector6
vector6:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $6
8010662d:	6a 06                	push   $0x6
  jmp alltraps
8010662f:	e9 06 fb ff ff       	jmp    8010613a <alltraps>

80106634 <vector7>:
.globl vector7
vector7:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $7
80106636:	6a 07                	push   $0x7
  jmp alltraps
80106638:	e9 fd fa ff ff       	jmp    8010613a <alltraps>

8010663d <vector8>:
.globl vector8
vector8:
  pushl $8
8010663d:	6a 08                	push   $0x8
  jmp alltraps
8010663f:	e9 f6 fa ff ff       	jmp    8010613a <alltraps>

80106644 <vector9>:
.globl vector9
vector9:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $9
80106646:	6a 09                	push   $0x9
  jmp alltraps
80106648:	e9 ed fa ff ff       	jmp    8010613a <alltraps>

8010664d <vector10>:
.globl vector10
vector10:
  pushl $10
8010664d:	6a 0a                	push   $0xa
  jmp alltraps
8010664f:	e9 e6 fa ff ff       	jmp    8010613a <alltraps>

80106654 <vector11>:
.globl vector11
vector11:
  pushl $11
80106654:	6a 0b                	push   $0xb
  jmp alltraps
80106656:	e9 df fa ff ff       	jmp    8010613a <alltraps>

8010665b <vector12>:
.globl vector12
vector12:
  pushl $12
8010665b:	6a 0c                	push   $0xc
  jmp alltraps
8010665d:	e9 d8 fa ff ff       	jmp    8010613a <alltraps>

80106662 <vector13>:
.globl vector13
vector13:
  pushl $13
80106662:	6a 0d                	push   $0xd
  jmp alltraps
80106664:	e9 d1 fa ff ff       	jmp    8010613a <alltraps>

80106669 <vector14>:
.globl vector14
vector14:
  pushl $14
80106669:	6a 0e                	push   $0xe
  jmp alltraps
8010666b:	e9 ca fa ff ff       	jmp    8010613a <alltraps>

80106670 <vector15>:
.globl vector15
vector15:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $15
80106672:	6a 0f                	push   $0xf
  jmp alltraps
80106674:	e9 c1 fa ff ff       	jmp    8010613a <alltraps>

80106679 <vector16>:
.globl vector16
vector16:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $16
8010667b:	6a 10                	push   $0x10
  jmp alltraps
8010667d:	e9 b8 fa ff ff       	jmp    8010613a <alltraps>

80106682 <vector17>:
.globl vector17
vector17:
  pushl $17
80106682:	6a 11                	push   $0x11
  jmp alltraps
80106684:	e9 b1 fa ff ff       	jmp    8010613a <alltraps>

80106689 <vector18>:
.globl vector18
vector18:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $18
8010668b:	6a 12                	push   $0x12
  jmp alltraps
8010668d:	e9 a8 fa ff ff       	jmp    8010613a <alltraps>

80106692 <vector19>:
.globl vector19
vector19:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $19
80106694:	6a 13                	push   $0x13
  jmp alltraps
80106696:	e9 9f fa ff ff       	jmp    8010613a <alltraps>

8010669b <vector20>:
.globl vector20
vector20:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $20
8010669d:	6a 14                	push   $0x14
  jmp alltraps
8010669f:	e9 96 fa ff ff       	jmp    8010613a <alltraps>

801066a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $21
801066a6:	6a 15                	push   $0x15
  jmp alltraps
801066a8:	e9 8d fa ff ff       	jmp    8010613a <alltraps>

801066ad <vector22>:
.globl vector22
vector22:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $22
801066af:	6a 16                	push   $0x16
  jmp alltraps
801066b1:	e9 84 fa ff ff       	jmp    8010613a <alltraps>

801066b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $23
801066b8:	6a 17                	push   $0x17
  jmp alltraps
801066ba:	e9 7b fa ff ff       	jmp    8010613a <alltraps>

801066bf <vector24>:
.globl vector24
vector24:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $24
801066c1:	6a 18                	push   $0x18
  jmp alltraps
801066c3:	e9 72 fa ff ff       	jmp    8010613a <alltraps>

801066c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $25
801066ca:	6a 19                	push   $0x19
  jmp alltraps
801066cc:	e9 69 fa ff ff       	jmp    8010613a <alltraps>

801066d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $26
801066d3:	6a 1a                	push   $0x1a
  jmp alltraps
801066d5:	e9 60 fa ff ff       	jmp    8010613a <alltraps>

801066da <vector27>:
.globl vector27
vector27:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $27
801066dc:	6a 1b                	push   $0x1b
  jmp alltraps
801066de:	e9 57 fa ff ff       	jmp    8010613a <alltraps>

801066e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $28
801066e5:	6a 1c                	push   $0x1c
  jmp alltraps
801066e7:	e9 4e fa ff ff       	jmp    8010613a <alltraps>

801066ec <vector29>:
.globl vector29
vector29:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $29
801066ee:	6a 1d                	push   $0x1d
  jmp alltraps
801066f0:	e9 45 fa ff ff       	jmp    8010613a <alltraps>

801066f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $30
801066f7:	6a 1e                	push   $0x1e
  jmp alltraps
801066f9:	e9 3c fa ff ff       	jmp    8010613a <alltraps>

801066fe <vector31>:
.globl vector31
vector31:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $31
80106700:	6a 1f                	push   $0x1f
  jmp alltraps
80106702:	e9 33 fa ff ff       	jmp    8010613a <alltraps>

80106707 <vector32>:
.globl vector32
vector32:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $32
80106709:	6a 20                	push   $0x20
  jmp alltraps
8010670b:	e9 2a fa ff ff       	jmp    8010613a <alltraps>

80106710 <vector33>:
.globl vector33
vector33:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $33
80106712:	6a 21                	push   $0x21
  jmp alltraps
80106714:	e9 21 fa ff ff       	jmp    8010613a <alltraps>

80106719 <vector34>:
.globl vector34
vector34:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $34
8010671b:	6a 22                	push   $0x22
  jmp alltraps
8010671d:	e9 18 fa ff ff       	jmp    8010613a <alltraps>

80106722 <vector35>:
.globl vector35
vector35:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $35
80106724:	6a 23                	push   $0x23
  jmp alltraps
80106726:	e9 0f fa ff ff       	jmp    8010613a <alltraps>

8010672b <vector36>:
.globl vector36
vector36:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $36
8010672d:	6a 24                	push   $0x24
  jmp alltraps
8010672f:	e9 06 fa ff ff       	jmp    8010613a <alltraps>

80106734 <vector37>:
.globl vector37
vector37:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $37
80106736:	6a 25                	push   $0x25
  jmp alltraps
80106738:	e9 fd f9 ff ff       	jmp    8010613a <alltraps>

8010673d <vector38>:
.globl vector38
vector38:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $38
8010673f:	6a 26                	push   $0x26
  jmp alltraps
80106741:	e9 f4 f9 ff ff       	jmp    8010613a <alltraps>

80106746 <vector39>:
.globl vector39
vector39:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $39
80106748:	6a 27                	push   $0x27
  jmp alltraps
8010674a:	e9 eb f9 ff ff       	jmp    8010613a <alltraps>

8010674f <vector40>:
.globl vector40
vector40:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $40
80106751:	6a 28                	push   $0x28
  jmp alltraps
80106753:	e9 e2 f9 ff ff       	jmp    8010613a <alltraps>

80106758 <vector41>:
.globl vector41
vector41:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $41
8010675a:	6a 29                	push   $0x29
  jmp alltraps
8010675c:	e9 d9 f9 ff ff       	jmp    8010613a <alltraps>

80106761 <vector42>:
.globl vector42
vector42:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $42
80106763:	6a 2a                	push   $0x2a
  jmp alltraps
80106765:	e9 d0 f9 ff ff       	jmp    8010613a <alltraps>

8010676a <vector43>:
.globl vector43
vector43:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $43
8010676c:	6a 2b                	push   $0x2b
  jmp alltraps
8010676e:	e9 c7 f9 ff ff       	jmp    8010613a <alltraps>

80106773 <vector44>:
.globl vector44
vector44:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $44
80106775:	6a 2c                	push   $0x2c
  jmp alltraps
80106777:	e9 be f9 ff ff       	jmp    8010613a <alltraps>

8010677c <vector45>:
.globl vector45
vector45:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $45
8010677e:	6a 2d                	push   $0x2d
  jmp alltraps
80106780:	e9 b5 f9 ff ff       	jmp    8010613a <alltraps>

80106785 <vector46>:
.globl vector46
vector46:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $46
80106787:	6a 2e                	push   $0x2e
  jmp alltraps
80106789:	e9 ac f9 ff ff       	jmp    8010613a <alltraps>

8010678e <vector47>:
.globl vector47
vector47:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $47
80106790:	6a 2f                	push   $0x2f
  jmp alltraps
80106792:	e9 a3 f9 ff ff       	jmp    8010613a <alltraps>

80106797 <vector48>:
.globl vector48
vector48:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $48
80106799:	6a 30                	push   $0x30
  jmp alltraps
8010679b:	e9 9a f9 ff ff       	jmp    8010613a <alltraps>

801067a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $49
801067a2:	6a 31                	push   $0x31
  jmp alltraps
801067a4:	e9 91 f9 ff ff       	jmp    8010613a <alltraps>

801067a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $50
801067ab:	6a 32                	push   $0x32
  jmp alltraps
801067ad:	e9 88 f9 ff ff       	jmp    8010613a <alltraps>

801067b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $51
801067b4:	6a 33                	push   $0x33
  jmp alltraps
801067b6:	e9 7f f9 ff ff       	jmp    8010613a <alltraps>

801067bb <vector52>:
.globl vector52
vector52:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $52
801067bd:	6a 34                	push   $0x34
  jmp alltraps
801067bf:	e9 76 f9 ff ff       	jmp    8010613a <alltraps>

801067c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $53
801067c6:	6a 35                	push   $0x35
  jmp alltraps
801067c8:	e9 6d f9 ff ff       	jmp    8010613a <alltraps>

801067cd <vector54>:
.globl vector54
vector54:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $54
801067cf:	6a 36                	push   $0x36
  jmp alltraps
801067d1:	e9 64 f9 ff ff       	jmp    8010613a <alltraps>

801067d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $55
801067d8:	6a 37                	push   $0x37
  jmp alltraps
801067da:	e9 5b f9 ff ff       	jmp    8010613a <alltraps>

801067df <vector56>:
.globl vector56
vector56:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $56
801067e1:	6a 38                	push   $0x38
  jmp alltraps
801067e3:	e9 52 f9 ff ff       	jmp    8010613a <alltraps>

801067e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $57
801067ea:	6a 39                	push   $0x39
  jmp alltraps
801067ec:	e9 49 f9 ff ff       	jmp    8010613a <alltraps>

801067f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $58
801067f3:	6a 3a                	push   $0x3a
  jmp alltraps
801067f5:	e9 40 f9 ff ff       	jmp    8010613a <alltraps>

801067fa <vector59>:
.globl vector59
vector59:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $59
801067fc:	6a 3b                	push   $0x3b
  jmp alltraps
801067fe:	e9 37 f9 ff ff       	jmp    8010613a <alltraps>

80106803 <vector60>:
.globl vector60
vector60:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $60
80106805:	6a 3c                	push   $0x3c
  jmp alltraps
80106807:	e9 2e f9 ff ff       	jmp    8010613a <alltraps>

8010680c <vector61>:
.globl vector61
vector61:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $61
8010680e:	6a 3d                	push   $0x3d
  jmp alltraps
80106810:	e9 25 f9 ff ff       	jmp    8010613a <alltraps>

80106815 <vector62>:
.globl vector62
vector62:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $62
80106817:	6a 3e                	push   $0x3e
  jmp alltraps
80106819:	e9 1c f9 ff ff       	jmp    8010613a <alltraps>

8010681e <vector63>:
.globl vector63
vector63:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $63
80106820:	6a 3f                	push   $0x3f
  jmp alltraps
80106822:	e9 13 f9 ff ff       	jmp    8010613a <alltraps>

80106827 <vector64>:
.globl vector64
vector64:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $64
80106829:	6a 40                	push   $0x40
  jmp alltraps
8010682b:	e9 0a f9 ff ff       	jmp    8010613a <alltraps>

80106830 <vector65>:
.globl vector65
vector65:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $65
80106832:	6a 41                	push   $0x41
  jmp alltraps
80106834:	e9 01 f9 ff ff       	jmp    8010613a <alltraps>

80106839 <vector66>:
.globl vector66
vector66:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $66
8010683b:	6a 42                	push   $0x42
  jmp alltraps
8010683d:	e9 f8 f8 ff ff       	jmp    8010613a <alltraps>

80106842 <vector67>:
.globl vector67
vector67:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $67
80106844:	6a 43                	push   $0x43
  jmp alltraps
80106846:	e9 ef f8 ff ff       	jmp    8010613a <alltraps>

8010684b <vector68>:
.globl vector68
vector68:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $68
8010684d:	6a 44                	push   $0x44
  jmp alltraps
8010684f:	e9 e6 f8 ff ff       	jmp    8010613a <alltraps>

80106854 <vector69>:
.globl vector69
vector69:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $69
80106856:	6a 45                	push   $0x45
  jmp alltraps
80106858:	e9 dd f8 ff ff       	jmp    8010613a <alltraps>

8010685d <vector70>:
.globl vector70
vector70:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $70
8010685f:	6a 46                	push   $0x46
  jmp alltraps
80106861:	e9 d4 f8 ff ff       	jmp    8010613a <alltraps>

80106866 <vector71>:
.globl vector71
vector71:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $71
80106868:	6a 47                	push   $0x47
  jmp alltraps
8010686a:	e9 cb f8 ff ff       	jmp    8010613a <alltraps>

8010686f <vector72>:
.globl vector72
vector72:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $72
80106871:	6a 48                	push   $0x48
  jmp alltraps
80106873:	e9 c2 f8 ff ff       	jmp    8010613a <alltraps>

80106878 <vector73>:
.globl vector73
vector73:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $73
8010687a:	6a 49                	push   $0x49
  jmp alltraps
8010687c:	e9 b9 f8 ff ff       	jmp    8010613a <alltraps>

80106881 <vector74>:
.globl vector74
vector74:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $74
80106883:	6a 4a                	push   $0x4a
  jmp alltraps
80106885:	e9 b0 f8 ff ff       	jmp    8010613a <alltraps>

8010688a <vector75>:
.globl vector75
vector75:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $75
8010688c:	6a 4b                	push   $0x4b
  jmp alltraps
8010688e:	e9 a7 f8 ff ff       	jmp    8010613a <alltraps>

80106893 <vector76>:
.globl vector76
vector76:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $76
80106895:	6a 4c                	push   $0x4c
  jmp alltraps
80106897:	e9 9e f8 ff ff       	jmp    8010613a <alltraps>

8010689c <vector77>:
.globl vector77
vector77:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $77
8010689e:	6a 4d                	push   $0x4d
  jmp alltraps
801068a0:	e9 95 f8 ff ff       	jmp    8010613a <alltraps>

801068a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $78
801068a7:	6a 4e                	push   $0x4e
  jmp alltraps
801068a9:	e9 8c f8 ff ff       	jmp    8010613a <alltraps>

801068ae <vector79>:
.globl vector79
vector79:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $79
801068b0:	6a 4f                	push   $0x4f
  jmp alltraps
801068b2:	e9 83 f8 ff ff       	jmp    8010613a <alltraps>

801068b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $80
801068b9:	6a 50                	push   $0x50
  jmp alltraps
801068bb:	e9 7a f8 ff ff       	jmp    8010613a <alltraps>

801068c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $81
801068c2:	6a 51                	push   $0x51
  jmp alltraps
801068c4:	e9 71 f8 ff ff       	jmp    8010613a <alltraps>

801068c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $82
801068cb:	6a 52                	push   $0x52
  jmp alltraps
801068cd:	e9 68 f8 ff ff       	jmp    8010613a <alltraps>

801068d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $83
801068d4:	6a 53                	push   $0x53
  jmp alltraps
801068d6:	e9 5f f8 ff ff       	jmp    8010613a <alltraps>

801068db <vector84>:
.globl vector84
vector84:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $84
801068dd:	6a 54                	push   $0x54
  jmp alltraps
801068df:	e9 56 f8 ff ff       	jmp    8010613a <alltraps>

801068e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $85
801068e6:	6a 55                	push   $0x55
  jmp alltraps
801068e8:	e9 4d f8 ff ff       	jmp    8010613a <alltraps>

801068ed <vector86>:
.globl vector86
vector86:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $86
801068ef:	6a 56                	push   $0x56
  jmp alltraps
801068f1:	e9 44 f8 ff ff       	jmp    8010613a <alltraps>

801068f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $87
801068f8:	6a 57                	push   $0x57
  jmp alltraps
801068fa:	e9 3b f8 ff ff       	jmp    8010613a <alltraps>

801068ff <vector88>:
.globl vector88
vector88:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $88
80106901:	6a 58                	push   $0x58
  jmp alltraps
80106903:	e9 32 f8 ff ff       	jmp    8010613a <alltraps>

80106908 <vector89>:
.globl vector89
vector89:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $89
8010690a:	6a 59                	push   $0x59
  jmp alltraps
8010690c:	e9 29 f8 ff ff       	jmp    8010613a <alltraps>

80106911 <vector90>:
.globl vector90
vector90:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $90
80106913:	6a 5a                	push   $0x5a
  jmp alltraps
80106915:	e9 20 f8 ff ff       	jmp    8010613a <alltraps>

8010691a <vector91>:
.globl vector91
vector91:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $91
8010691c:	6a 5b                	push   $0x5b
  jmp alltraps
8010691e:	e9 17 f8 ff ff       	jmp    8010613a <alltraps>

80106923 <vector92>:
.globl vector92
vector92:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $92
80106925:	6a 5c                	push   $0x5c
  jmp alltraps
80106927:	e9 0e f8 ff ff       	jmp    8010613a <alltraps>

8010692c <vector93>:
.globl vector93
vector93:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $93
8010692e:	6a 5d                	push   $0x5d
  jmp alltraps
80106930:	e9 05 f8 ff ff       	jmp    8010613a <alltraps>

80106935 <vector94>:
.globl vector94
vector94:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $94
80106937:	6a 5e                	push   $0x5e
  jmp alltraps
80106939:	e9 fc f7 ff ff       	jmp    8010613a <alltraps>

8010693e <vector95>:
.globl vector95
vector95:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $95
80106940:	6a 5f                	push   $0x5f
  jmp alltraps
80106942:	e9 f3 f7 ff ff       	jmp    8010613a <alltraps>

80106947 <vector96>:
.globl vector96
vector96:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $96
80106949:	6a 60                	push   $0x60
  jmp alltraps
8010694b:	e9 ea f7 ff ff       	jmp    8010613a <alltraps>

80106950 <vector97>:
.globl vector97
vector97:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $97
80106952:	6a 61                	push   $0x61
  jmp alltraps
80106954:	e9 e1 f7 ff ff       	jmp    8010613a <alltraps>

80106959 <vector98>:
.globl vector98
vector98:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $98
8010695b:	6a 62                	push   $0x62
  jmp alltraps
8010695d:	e9 d8 f7 ff ff       	jmp    8010613a <alltraps>

80106962 <vector99>:
.globl vector99
vector99:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $99
80106964:	6a 63                	push   $0x63
  jmp alltraps
80106966:	e9 cf f7 ff ff       	jmp    8010613a <alltraps>

8010696b <vector100>:
.globl vector100
vector100:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $100
8010696d:	6a 64                	push   $0x64
  jmp alltraps
8010696f:	e9 c6 f7 ff ff       	jmp    8010613a <alltraps>

80106974 <vector101>:
.globl vector101
vector101:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $101
80106976:	6a 65                	push   $0x65
  jmp alltraps
80106978:	e9 bd f7 ff ff       	jmp    8010613a <alltraps>

8010697d <vector102>:
.globl vector102
vector102:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $102
8010697f:	6a 66                	push   $0x66
  jmp alltraps
80106981:	e9 b4 f7 ff ff       	jmp    8010613a <alltraps>

80106986 <vector103>:
.globl vector103
vector103:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $103
80106988:	6a 67                	push   $0x67
  jmp alltraps
8010698a:	e9 ab f7 ff ff       	jmp    8010613a <alltraps>

8010698f <vector104>:
.globl vector104
vector104:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $104
80106991:	6a 68                	push   $0x68
  jmp alltraps
80106993:	e9 a2 f7 ff ff       	jmp    8010613a <alltraps>

80106998 <vector105>:
.globl vector105
vector105:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $105
8010699a:	6a 69                	push   $0x69
  jmp alltraps
8010699c:	e9 99 f7 ff ff       	jmp    8010613a <alltraps>

801069a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $106
801069a3:	6a 6a                	push   $0x6a
  jmp alltraps
801069a5:	e9 90 f7 ff ff       	jmp    8010613a <alltraps>

801069aa <vector107>:
.globl vector107
vector107:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $107
801069ac:	6a 6b                	push   $0x6b
  jmp alltraps
801069ae:	e9 87 f7 ff ff       	jmp    8010613a <alltraps>

801069b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $108
801069b5:	6a 6c                	push   $0x6c
  jmp alltraps
801069b7:	e9 7e f7 ff ff       	jmp    8010613a <alltraps>

801069bc <vector109>:
.globl vector109
vector109:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $109
801069be:	6a 6d                	push   $0x6d
  jmp alltraps
801069c0:	e9 75 f7 ff ff       	jmp    8010613a <alltraps>

801069c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $110
801069c7:	6a 6e                	push   $0x6e
  jmp alltraps
801069c9:	e9 6c f7 ff ff       	jmp    8010613a <alltraps>

801069ce <vector111>:
.globl vector111
vector111:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $111
801069d0:	6a 6f                	push   $0x6f
  jmp alltraps
801069d2:	e9 63 f7 ff ff       	jmp    8010613a <alltraps>

801069d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $112
801069d9:	6a 70                	push   $0x70
  jmp alltraps
801069db:	e9 5a f7 ff ff       	jmp    8010613a <alltraps>

801069e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $113
801069e2:	6a 71                	push   $0x71
  jmp alltraps
801069e4:	e9 51 f7 ff ff       	jmp    8010613a <alltraps>

801069e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $114
801069eb:	6a 72                	push   $0x72
  jmp alltraps
801069ed:	e9 48 f7 ff ff       	jmp    8010613a <alltraps>

801069f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $115
801069f4:	6a 73                	push   $0x73
  jmp alltraps
801069f6:	e9 3f f7 ff ff       	jmp    8010613a <alltraps>

801069fb <vector116>:
.globl vector116
vector116:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $116
801069fd:	6a 74                	push   $0x74
  jmp alltraps
801069ff:	e9 36 f7 ff ff       	jmp    8010613a <alltraps>

80106a04 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $117
80106a06:	6a 75                	push   $0x75
  jmp alltraps
80106a08:	e9 2d f7 ff ff       	jmp    8010613a <alltraps>

80106a0d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $118
80106a0f:	6a 76                	push   $0x76
  jmp alltraps
80106a11:	e9 24 f7 ff ff       	jmp    8010613a <alltraps>

80106a16 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $119
80106a18:	6a 77                	push   $0x77
  jmp alltraps
80106a1a:	e9 1b f7 ff ff       	jmp    8010613a <alltraps>

80106a1f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $120
80106a21:	6a 78                	push   $0x78
  jmp alltraps
80106a23:	e9 12 f7 ff ff       	jmp    8010613a <alltraps>

80106a28 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $121
80106a2a:	6a 79                	push   $0x79
  jmp alltraps
80106a2c:	e9 09 f7 ff ff       	jmp    8010613a <alltraps>

80106a31 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $122
80106a33:	6a 7a                	push   $0x7a
  jmp alltraps
80106a35:	e9 00 f7 ff ff       	jmp    8010613a <alltraps>

80106a3a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $123
80106a3c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a3e:	e9 f7 f6 ff ff       	jmp    8010613a <alltraps>

80106a43 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $124
80106a45:	6a 7c                	push   $0x7c
  jmp alltraps
80106a47:	e9 ee f6 ff ff       	jmp    8010613a <alltraps>

80106a4c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $125
80106a4e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a50:	e9 e5 f6 ff ff       	jmp    8010613a <alltraps>

80106a55 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $126
80106a57:	6a 7e                	push   $0x7e
  jmp alltraps
80106a59:	e9 dc f6 ff ff       	jmp    8010613a <alltraps>

80106a5e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $127
80106a60:	6a 7f                	push   $0x7f
  jmp alltraps
80106a62:	e9 d3 f6 ff ff       	jmp    8010613a <alltraps>

80106a67 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $128
80106a69:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a6e:	e9 c7 f6 ff ff       	jmp    8010613a <alltraps>

80106a73 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $129
80106a75:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a7a:	e9 bb f6 ff ff       	jmp    8010613a <alltraps>

80106a7f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $130
80106a81:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a86:	e9 af f6 ff ff       	jmp    8010613a <alltraps>

80106a8b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $131
80106a8d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a92:	e9 a3 f6 ff ff       	jmp    8010613a <alltraps>

80106a97 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $132
80106a99:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a9e:	e9 97 f6 ff ff       	jmp    8010613a <alltraps>

80106aa3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $133
80106aa5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106aaa:	e9 8b f6 ff ff       	jmp    8010613a <alltraps>

80106aaf <vector134>:
.globl vector134
vector134:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $134
80106ab1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ab6:	e9 7f f6 ff ff       	jmp    8010613a <alltraps>

80106abb <vector135>:
.globl vector135
vector135:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $135
80106abd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ac2:	e9 73 f6 ff ff       	jmp    8010613a <alltraps>

80106ac7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $136
80106ac9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ace:	e9 67 f6 ff ff       	jmp    8010613a <alltraps>

80106ad3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $137
80106ad5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ada:	e9 5b f6 ff ff       	jmp    8010613a <alltraps>

80106adf <vector138>:
.globl vector138
vector138:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $138
80106ae1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ae6:	e9 4f f6 ff ff       	jmp    8010613a <alltraps>

80106aeb <vector139>:
.globl vector139
vector139:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $139
80106aed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106af2:	e9 43 f6 ff ff       	jmp    8010613a <alltraps>

80106af7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $140
80106af9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106afe:	e9 37 f6 ff ff       	jmp    8010613a <alltraps>

80106b03 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $141
80106b05:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b0a:	e9 2b f6 ff ff       	jmp    8010613a <alltraps>

80106b0f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $142
80106b11:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b16:	e9 1f f6 ff ff       	jmp    8010613a <alltraps>

80106b1b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $143
80106b1d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b22:	e9 13 f6 ff ff       	jmp    8010613a <alltraps>

80106b27 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $144
80106b29:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b2e:	e9 07 f6 ff ff       	jmp    8010613a <alltraps>

80106b33 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $145
80106b35:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b3a:	e9 fb f5 ff ff       	jmp    8010613a <alltraps>

80106b3f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $146
80106b41:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b46:	e9 ef f5 ff ff       	jmp    8010613a <alltraps>

80106b4b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $147
80106b4d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b52:	e9 e3 f5 ff ff       	jmp    8010613a <alltraps>

80106b57 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $148
80106b59:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b5e:	e9 d7 f5 ff ff       	jmp    8010613a <alltraps>

80106b63 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $149
80106b65:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b6a:	e9 cb f5 ff ff       	jmp    8010613a <alltraps>

80106b6f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $150
80106b71:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b76:	e9 bf f5 ff ff       	jmp    8010613a <alltraps>

80106b7b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $151
80106b7d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b82:	e9 b3 f5 ff ff       	jmp    8010613a <alltraps>

80106b87 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $152
80106b89:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b8e:	e9 a7 f5 ff ff       	jmp    8010613a <alltraps>

80106b93 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $153
80106b95:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b9a:	e9 9b f5 ff ff       	jmp    8010613a <alltraps>

80106b9f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $154
80106ba1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ba6:	e9 8f f5 ff ff       	jmp    8010613a <alltraps>

80106bab <vector155>:
.globl vector155
vector155:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $155
80106bad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bb2:	e9 83 f5 ff ff       	jmp    8010613a <alltraps>

80106bb7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $156
80106bb9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bbe:	e9 77 f5 ff ff       	jmp    8010613a <alltraps>

80106bc3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $157
80106bc5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bca:	e9 6b f5 ff ff       	jmp    8010613a <alltraps>

80106bcf <vector158>:
.globl vector158
vector158:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $158
80106bd1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bd6:	e9 5f f5 ff ff       	jmp    8010613a <alltraps>

80106bdb <vector159>:
.globl vector159
vector159:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $159
80106bdd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106be2:	e9 53 f5 ff ff       	jmp    8010613a <alltraps>

80106be7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $160
80106be9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bee:	e9 47 f5 ff ff       	jmp    8010613a <alltraps>

80106bf3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $161
80106bf5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bfa:	e9 3b f5 ff ff       	jmp    8010613a <alltraps>

80106bff <vector162>:
.globl vector162
vector162:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $162
80106c01:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c06:	e9 2f f5 ff ff       	jmp    8010613a <alltraps>

80106c0b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $163
80106c0d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c12:	e9 23 f5 ff ff       	jmp    8010613a <alltraps>

80106c17 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $164
80106c19:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c1e:	e9 17 f5 ff ff       	jmp    8010613a <alltraps>

80106c23 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $165
80106c25:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c2a:	e9 0b f5 ff ff       	jmp    8010613a <alltraps>

80106c2f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $166
80106c31:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c36:	e9 ff f4 ff ff       	jmp    8010613a <alltraps>

80106c3b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $167
80106c3d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c42:	e9 f3 f4 ff ff       	jmp    8010613a <alltraps>

80106c47 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $168
80106c49:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c4e:	e9 e7 f4 ff ff       	jmp    8010613a <alltraps>

80106c53 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $169
80106c55:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c5a:	e9 db f4 ff ff       	jmp    8010613a <alltraps>

80106c5f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $170
80106c61:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c66:	e9 cf f4 ff ff       	jmp    8010613a <alltraps>

80106c6b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $171
80106c6d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c72:	e9 c3 f4 ff ff       	jmp    8010613a <alltraps>

80106c77 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $172
80106c79:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c7e:	e9 b7 f4 ff ff       	jmp    8010613a <alltraps>

80106c83 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $173
80106c85:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c8a:	e9 ab f4 ff ff       	jmp    8010613a <alltraps>

80106c8f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $174
80106c91:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c96:	e9 9f f4 ff ff       	jmp    8010613a <alltraps>

80106c9b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $175
80106c9d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ca2:	e9 93 f4 ff ff       	jmp    8010613a <alltraps>

80106ca7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $176
80106ca9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cae:	e9 87 f4 ff ff       	jmp    8010613a <alltraps>

80106cb3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $177
80106cb5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cba:	e9 7b f4 ff ff       	jmp    8010613a <alltraps>

80106cbf <vector178>:
.globl vector178
vector178:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $178
80106cc1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cc6:	e9 6f f4 ff ff       	jmp    8010613a <alltraps>

80106ccb <vector179>:
.globl vector179
vector179:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $179
80106ccd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cd2:	e9 63 f4 ff ff       	jmp    8010613a <alltraps>

80106cd7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $180
80106cd9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cde:	e9 57 f4 ff ff       	jmp    8010613a <alltraps>

80106ce3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $181
80106ce5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cea:	e9 4b f4 ff ff       	jmp    8010613a <alltraps>

80106cef <vector182>:
.globl vector182
vector182:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $182
80106cf1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cf6:	e9 3f f4 ff ff       	jmp    8010613a <alltraps>

80106cfb <vector183>:
.globl vector183
vector183:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $183
80106cfd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d02:	e9 33 f4 ff ff       	jmp    8010613a <alltraps>

80106d07 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $184
80106d09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d0e:	e9 27 f4 ff ff       	jmp    8010613a <alltraps>

80106d13 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $185
80106d15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d1a:	e9 1b f4 ff ff       	jmp    8010613a <alltraps>

80106d1f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $186
80106d21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d26:	e9 0f f4 ff ff       	jmp    8010613a <alltraps>

80106d2b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $187
80106d2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d32:	e9 03 f4 ff ff       	jmp    8010613a <alltraps>

80106d37 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $188
80106d39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d3e:	e9 f7 f3 ff ff       	jmp    8010613a <alltraps>

80106d43 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $189
80106d45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d4a:	e9 eb f3 ff ff       	jmp    8010613a <alltraps>

80106d4f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $190
80106d51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d56:	e9 df f3 ff ff       	jmp    8010613a <alltraps>

80106d5b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $191
80106d5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d62:	e9 d3 f3 ff ff       	jmp    8010613a <alltraps>

80106d67 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $192
80106d69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d6e:	e9 c7 f3 ff ff       	jmp    8010613a <alltraps>

80106d73 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $193
80106d75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d7a:	e9 bb f3 ff ff       	jmp    8010613a <alltraps>

80106d7f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $194
80106d81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d86:	e9 af f3 ff ff       	jmp    8010613a <alltraps>

80106d8b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $195
80106d8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d92:	e9 a3 f3 ff ff       	jmp    8010613a <alltraps>

80106d97 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $196
80106d99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d9e:	e9 97 f3 ff ff       	jmp    8010613a <alltraps>

80106da3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $197
80106da5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106daa:	e9 8b f3 ff ff       	jmp    8010613a <alltraps>

80106daf <vector198>:
.globl vector198
vector198:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $198
80106db1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106db6:	e9 7f f3 ff ff       	jmp    8010613a <alltraps>

80106dbb <vector199>:
.globl vector199
vector199:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $199
80106dbd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106dc2:	e9 73 f3 ff ff       	jmp    8010613a <alltraps>

80106dc7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $200
80106dc9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dce:	e9 67 f3 ff ff       	jmp    8010613a <alltraps>

80106dd3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $201
80106dd5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dda:	e9 5b f3 ff ff       	jmp    8010613a <alltraps>

80106ddf <vector202>:
.globl vector202
vector202:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $202
80106de1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106de6:	e9 4f f3 ff ff       	jmp    8010613a <alltraps>

80106deb <vector203>:
.globl vector203
vector203:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $203
80106ded:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106df2:	e9 43 f3 ff ff       	jmp    8010613a <alltraps>

80106df7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $204
80106df9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dfe:	e9 37 f3 ff ff       	jmp    8010613a <alltraps>

80106e03 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $205
80106e05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e0a:	e9 2b f3 ff ff       	jmp    8010613a <alltraps>

80106e0f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $206
80106e11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e16:	e9 1f f3 ff ff       	jmp    8010613a <alltraps>

80106e1b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $207
80106e1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e22:	e9 13 f3 ff ff       	jmp    8010613a <alltraps>

80106e27 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $208
80106e29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e2e:	e9 07 f3 ff ff       	jmp    8010613a <alltraps>

80106e33 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $209
80106e35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e3a:	e9 fb f2 ff ff       	jmp    8010613a <alltraps>

80106e3f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $210
80106e41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e46:	e9 ef f2 ff ff       	jmp    8010613a <alltraps>

80106e4b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $211
80106e4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e52:	e9 e3 f2 ff ff       	jmp    8010613a <alltraps>

80106e57 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $212
80106e59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e5e:	e9 d7 f2 ff ff       	jmp    8010613a <alltraps>

80106e63 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $213
80106e65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e6a:	e9 cb f2 ff ff       	jmp    8010613a <alltraps>

80106e6f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $214
80106e71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e76:	e9 bf f2 ff ff       	jmp    8010613a <alltraps>

80106e7b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $215
80106e7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e82:	e9 b3 f2 ff ff       	jmp    8010613a <alltraps>

80106e87 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $216
80106e89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e8e:	e9 a7 f2 ff ff       	jmp    8010613a <alltraps>

80106e93 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $217
80106e95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e9a:	e9 9b f2 ff ff       	jmp    8010613a <alltraps>

80106e9f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $218
80106ea1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ea6:	e9 8f f2 ff ff       	jmp    8010613a <alltraps>

80106eab <vector219>:
.globl vector219
vector219:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $219
80106ead:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106eb2:	e9 83 f2 ff ff       	jmp    8010613a <alltraps>

80106eb7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $220
80106eb9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ebe:	e9 77 f2 ff ff       	jmp    8010613a <alltraps>

80106ec3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $221
80106ec5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eca:	e9 6b f2 ff ff       	jmp    8010613a <alltraps>

80106ecf <vector222>:
.globl vector222
vector222:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $222
80106ed1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ed6:	e9 5f f2 ff ff       	jmp    8010613a <alltraps>

80106edb <vector223>:
.globl vector223
vector223:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $223
80106edd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ee2:	e9 53 f2 ff ff       	jmp    8010613a <alltraps>

80106ee7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $224
80106ee9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106eee:	e9 47 f2 ff ff       	jmp    8010613a <alltraps>

80106ef3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $225
80106ef5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106efa:	e9 3b f2 ff ff       	jmp    8010613a <alltraps>

80106eff <vector226>:
.globl vector226
vector226:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $226
80106f01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f06:	e9 2f f2 ff ff       	jmp    8010613a <alltraps>

80106f0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $227
80106f0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f12:	e9 23 f2 ff ff       	jmp    8010613a <alltraps>

80106f17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $228
80106f19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f1e:	e9 17 f2 ff ff       	jmp    8010613a <alltraps>

80106f23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $229
80106f25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f2a:	e9 0b f2 ff ff       	jmp    8010613a <alltraps>

80106f2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $230
80106f31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f36:	e9 ff f1 ff ff       	jmp    8010613a <alltraps>

80106f3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $231
80106f3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f42:	e9 f3 f1 ff ff       	jmp    8010613a <alltraps>

80106f47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $232
80106f49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f4e:	e9 e7 f1 ff ff       	jmp    8010613a <alltraps>

80106f53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $233
80106f55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f5a:	e9 db f1 ff ff       	jmp    8010613a <alltraps>

80106f5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $234
80106f61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f66:	e9 cf f1 ff ff       	jmp    8010613a <alltraps>

80106f6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $235
80106f6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f72:	e9 c3 f1 ff ff       	jmp    8010613a <alltraps>

80106f77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $236
80106f79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f7e:	e9 b7 f1 ff ff       	jmp    8010613a <alltraps>

80106f83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $237
80106f85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f8a:	e9 ab f1 ff ff       	jmp    8010613a <alltraps>

80106f8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $238
80106f91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f96:	e9 9f f1 ff ff       	jmp    8010613a <alltraps>

80106f9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $239
80106f9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fa2:	e9 93 f1 ff ff       	jmp    8010613a <alltraps>

80106fa7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $240
80106fa9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fae:	e9 87 f1 ff ff       	jmp    8010613a <alltraps>

80106fb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $241
80106fb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fba:	e9 7b f1 ff ff       	jmp    8010613a <alltraps>

80106fbf <vector242>:
.globl vector242
vector242:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $242
80106fc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fc6:	e9 6f f1 ff ff       	jmp    8010613a <alltraps>

80106fcb <vector243>:
.globl vector243
vector243:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $243
80106fcd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fd2:	e9 63 f1 ff ff       	jmp    8010613a <alltraps>

80106fd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $244
80106fd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fde:	e9 57 f1 ff ff       	jmp    8010613a <alltraps>

80106fe3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $245
80106fe5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fea:	e9 4b f1 ff ff       	jmp    8010613a <alltraps>

80106fef <vector246>:
.globl vector246
vector246:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $246
80106ff1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ff6:	e9 3f f1 ff ff       	jmp    8010613a <alltraps>

80106ffb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $247
80106ffd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107002:	e9 33 f1 ff ff       	jmp    8010613a <alltraps>

80107007 <vector248>:
.globl vector248
vector248:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $248
80107009:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010700e:	e9 27 f1 ff ff       	jmp    8010613a <alltraps>

80107013 <vector249>:
.globl vector249
vector249:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $249
80107015:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010701a:	e9 1b f1 ff ff       	jmp    8010613a <alltraps>

8010701f <vector250>:
.globl vector250
vector250:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $250
80107021:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107026:	e9 0f f1 ff ff       	jmp    8010613a <alltraps>

8010702b <vector251>:
.globl vector251
vector251:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $251
8010702d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107032:	e9 03 f1 ff ff       	jmp    8010613a <alltraps>

80107037 <vector252>:
.globl vector252
vector252:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $252
80107039:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010703e:	e9 f7 f0 ff ff       	jmp    8010613a <alltraps>

80107043 <vector253>:
.globl vector253
vector253:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $253
80107045:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010704a:	e9 eb f0 ff ff       	jmp    8010613a <alltraps>

8010704f <vector254>:
.globl vector254
vector254:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $254
80107051:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107056:	e9 df f0 ff ff       	jmp    8010613a <alltraps>

8010705b <vector255>:
.globl vector255
vector255:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $255
8010705d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107062:	e9 d3 f0 ff ff       	jmp    8010613a <alltraps>
80107067:	66 90                	xchg   %ax,%ax
80107069:	66 90                	xchg   %ax,%ax
8010706b:	66 90                	xchg   %ax,%ax
8010706d:	66 90                	xchg   %ax,%ax
8010706f:	90                   	nop

80107070 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107078:	c1 ea 16             	shr    $0x16,%edx
8010707b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010707e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80107081:	8b 07                	mov    (%edi),%eax
80107083:	a8 01                	test   $0x1,%al
80107085:	74 29                	je     801070b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010708c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107092:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107095:	c1 eb 0a             	shr    $0xa,%ebx
80107098:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010709e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
801070a1:	5b                   	pop    %ebx
801070a2:	5e                   	pop    %esi
801070a3:	5f                   	pop    %edi
801070a4:	5d                   	pop    %ebp
801070a5:	c3                   	ret    
801070a6:	8d 76 00             	lea    0x0(%esi),%esi
801070a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070b0:	85 c9                	test   %ecx,%ecx
801070b2:	74 2c                	je     801070e0 <walkpgdir+0x70>
801070b4:	e8 87 bc ff ff       	call   80102d40 <kalloc>
801070b9:	85 c0                	test   %eax,%eax
801070bb:	89 c6                	mov    %eax,%esi
801070bd:	74 21                	je     801070e0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801070bf:	83 ec 04             	sub    $0x4,%esp
801070c2:	68 00 10 00 00       	push   $0x1000
801070c7:	6a 00                	push   $0x0
801070c9:	50                   	push   %eax
801070ca:	e8 f1 db ff ff       	call   80104cc0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070cf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070d5:	83 c4 10             	add    $0x10,%esp
801070d8:	83 c8 07             	or     $0x7,%eax
801070db:	89 07                	mov    %eax,(%edi)
801070dd:	eb b3                	jmp    80107092 <walkpgdir+0x22>
801070df:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801070e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801070e3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801070e5:	5b                   	pop    %ebx
801070e6:	5e                   	pop    %esi
801070e7:	5f                   	pop    %edi
801070e8:	5d                   	pop    %ebp
801070e9:	c3                   	ret    
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801070f6:	89 d3                	mov    %edx,%ebx
801070f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070fe:	83 ec 1c             	sub    $0x1c,%esp
80107101:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107104:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107108:	8b 7d 08             	mov    0x8(%ebp),%edi
8010710b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107110:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107113:	8b 45 0c             	mov    0xc(%ebp),%eax
80107116:	29 df                	sub    %ebx,%edi
80107118:	83 c8 01             	or     $0x1,%eax
8010711b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010711e:	eb 15                	jmp    80107135 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107120:	f6 00 01             	testb  $0x1,(%eax)
80107123:	75 45                	jne    8010716a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107125:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107128:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010712b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010712d:	74 31                	je     80107160 <mappages+0x70>
      break;
    a += PGSIZE;
8010712f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107138:	b9 01 00 00 00       	mov    $0x1,%ecx
8010713d:	89 da                	mov    %ebx,%edx
8010713f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107142:	e8 29 ff ff ff       	call   80107070 <walkpgdir>
80107147:	85 c0                	test   %eax,%eax
80107149:	75 d5                	jne    80107120 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010714b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010714e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107153:	5b                   	pop    %ebx
80107154:	5e                   	pop    %esi
80107155:	5f                   	pop    %edi
80107156:	5d                   	pop    %ebp
80107157:	c3                   	ret    
80107158:	90                   	nop
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107163:	31 c0                	xor    %eax,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	68 b8 82 10 80       	push   $0x801082b8
80107172:	e8 f9 91 ff ff       	call   80100370 <panic>
80107177:	89 f6                	mov    %esi,%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107186:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010718c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010718e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107194:	83 ec 1c             	sub    $0x1c,%esp
80107197:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010719a:	39 d3                	cmp    %edx,%ebx
8010719c:	73 66                	jae    80107204 <deallocuvm.part.0+0x84>
8010719e:	89 d6                	mov    %edx,%esi
801071a0:	eb 3d                	jmp    801071df <deallocuvm.part.0+0x5f>
801071a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071a8:	8b 10                	mov    (%eax),%edx
801071aa:	f6 c2 01             	test   $0x1,%dl
801071ad:	74 26                	je     801071d5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071af:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801071b5:	74 58                	je     8010720f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801071b7:	83 ec 0c             	sub    $0xc,%esp
801071ba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801071c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071c3:	52                   	push   %edx
801071c4:	e8 c7 b9 ff ff       	call   80102b90 <kfree>
      *pte = 0;
801071c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071cc:	83 c4 10             	add    $0x10,%esp
801071cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801071d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071db:	39 f3                	cmp    %esi,%ebx
801071dd:	73 25                	jae    80107204 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071df:	31 c9                	xor    %ecx,%ecx
801071e1:	89 da                	mov    %ebx,%edx
801071e3:	89 f8                	mov    %edi,%eax
801071e5:	e8 86 fe ff ff       	call   80107070 <walkpgdir>
    if(!pte)
801071ea:	85 c0                	test   %eax,%eax
801071ec:	75 ba                	jne    801071a8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071ee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801071f4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801071fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107200:	39 f3                	cmp    %esi,%ebx
80107202:	72 db                	jb     801071df <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107204:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107207:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720a:	5b                   	pop    %ebx
8010720b:	5e                   	pop    %esi
8010720c:	5f                   	pop    %edi
8010720d:	5d                   	pop    %ebp
8010720e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010720f:	83 ec 0c             	sub    $0xc,%esp
80107212:	68 4a 7c 10 80       	push   $0x80107c4a
80107217:	e8 54 91 ff ff       	call   80100370 <panic>
8010721c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107220 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107226:	e8 e5 cd ff ff       	call   80104010 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010722b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107231:	31 c9                	xor    %ecx,%ecx
80107233:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107238:	66 89 90 98 39 11 80 	mov    %dx,-0x7feec668(%eax)
8010723f:	66 89 88 9a 39 11 80 	mov    %cx,-0x7feec666(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107246:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010724b:	31 c9                	xor    %ecx,%ecx
8010724d:	66 89 90 a0 39 11 80 	mov    %dx,-0x7feec660(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107254:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107259:	66 89 88 a2 39 11 80 	mov    %cx,-0x7feec65e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107260:	31 c9                	xor    %ecx,%ecx
80107262:	66 89 90 a8 39 11 80 	mov    %dx,-0x7feec658(%eax)
80107269:	66 89 88 aa 39 11 80 	mov    %cx,-0x7feec656(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107270:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107275:	31 c9                	xor    %ecx,%ecx
80107277:	66 89 90 b0 39 11 80 	mov    %dx,-0x7feec650(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010727e:	c6 80 9c 39 11 80 00 	movb   $0x0,-0x7feec664(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107285:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010728a:	c6 80 9d 39 11 80 9a 	movb   $0x9a,-0x7feec663(%eax)
80107291:	c6 80 9e 39 11 80 cf 	movb   $0xcf,-0x7feec662(%eax)
80107298:	c6 80 9f 39 11 80 00 	movb   $0x0,-0x7feec661(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010729f:	c6 80 a4 39 11 80 00 	movb   $0x0,-0x7feec65c(%eax)
801072a6:	c6 80 a5 39 11 80 92 	movb   $0x92,-0x7feec65b(%eax)
801072ad:	c6 80 a6 39 11 80 cf 	movb   $0xcf,-0x7feec65a(%eax)
801072b4:	c6 80 a7 39 11 80 00 	movb   $0x0,-0x7feec659(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072bb:	c6 80 ac 39 11 80 00 	movb   $0x0,-0x7feec654(%eax)
801072c2:	c6 80 ad 39 11 80 fa 	movb   $0xfa,-0x7feec653(%eax)
801072c9:	c6 80 ae 39 11 80 cf 	movb   $0xcf,-0x7feec652(%eax)
801072d0:	c6 80 af 39 11 80 00 	movb   $0x0,-0x7feec651(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072d7:	66 89 88 b2 39 11 80 	mov    %cx,-0x7feec64e(%eax)
801072de:	c6 80 b4 39 11 80 00 	movb   $0x0,-0x7feec64c(%eax)
801072e5:	c6 80 b5 39 11 80 f2 	movb   $0xf2,-0x7feec64b(%eax)
801072ec:	c6 80 b6 39 11 80 cf 	movb   $0xcf,-0x7feec64a(%eax)
801072f3:	c6 80 b7 39 11 80 00 	movb   $0x0,-0x7feec649(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801072fa:	05 90 39 11 80       	add    $0x80113990,%eax
801072ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107303:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107307:	c1 e8 10             	shr    $0x10,%eax
8010730a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010730e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107311:	0f 01 10             	lgdtl  (%eax)
}
80107314:	c9                   	leave  
80107315:	c3                   	ret    
80107316:	8d 76 00             	lea    0x0(%esi),%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107320 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107320:	a1 44 66 11 80       	mov    0x80116644,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107325:	55                   	push   %ebp
80107326:	89 e5                	mov    %esp,%ebp
80107328:	05 00 00 00 80       	add    $0x80000000,%eax
8010732d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107330:	5d                   	pop    %ebp
80107331:	c3                   	ret    
80107332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107340 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 1c             	sub    $0x1c,%esp
80107349:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010734c:	85 f6                	test   %esi,%esi
8010734e:	0f 84 cd 00 00 00    	je     80107421 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107354:	8b 46 08             	mov    0x8(%esi),%eax
80107357:	85 c0                	test   %eax,%eax
80107359:	0f 84 dc 00 00 00    	je     8010743b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010735f:	8b 7e 04             	mov    0x4(%esi),%edi
80107362:	85 ff                	test   %edi,%edi
80107364:	0f 84 c4 00 00 00    	je     8010742e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010736a:	e8 a1 d7 ff ff       	call   80104b10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010736f:	e8 1c cc ff ff       	call   80103f90 <mycpu>
80107374:	89 c3                	mov    %eax,%ebx
80107376:	e8 15 cc ff ff       	call   80103f90 <mycpu>
8010737b:	89 c7                	mov    %eax,%edi
8010737d:	e8 0e cc ff ff       	call   80103f90 <mycpu>
80107382:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107385:	83 c7 08             	add    $0x8,%edi
80107388:	e8 03 cc ff ff       	call   80103f90 <mycpu>
8010738d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107390:	83 c0 08             	add    $0x8,%eax
80107393:	ba 67 00 00 00       	mov    $0x67,%edx
80107398:	c1 e8 18             	shr    $0x18,%eax
8010739b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801073a2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801073a9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801073b0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801073b7:	83 c1 08             	add    $0x8,%ecx
801073ba:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801073c0:	c1 e9 10             	shr    $0x10,%ecx
801073c3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073c9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801073ce:	e8 bd cb ff ff       	call   80103f90 <mycpu>
801073d3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073da:	e8 b1 cb ff ff       	call   80103f90 <mycpu>
801073df:	b9 10 00 00 00       	mov    $0x10,%ecx
801073e4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073e8:	e8 a3 cb ff ff       	call   80103f90 <mycpu>
801073ed:	8b 56 08             	mov    0x8(%esi),%edx
801073f0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801073f6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073f9:	e8 92 cb ff ff       	call   80103f90 <mycpu>
801073fe:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107402:	b8 28 00 00 00       	mov    $0x28,%eax
80107407:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010740a:	8b 46 04             	mov    0x4(%esi),%eax
8010740d:	05 00 00 00 80       	add    $0x80000000,%eax
80107412:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107415:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107418:	5b                   	pop    %ebx
80107419:	5e                   	pop    %esi
8010741a:	5f                   	pop    %edi
8010741b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010741c:	e9 df d7 ff ff       	jmp    80104c00 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107421:	83 ec 0c             	sub    $0xc,%esp
80107424:	68 be 82 10 80       	push   $0x801082be
80107429:	e8 42 8f ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010742e:	83 ec 0c             	sub    $0xc,%esp
80107431:	68 e9 82 10 80       	push   $0x801082e9
80107436:	e8 35 8f ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010743b:	83 ec 0c             	sub    $0xc,%esp
8010743e:	68 d4 82 10 80       	push   $0x801082d4
80107443:	e8 28 8f ff ff       	call   80100370 <panic>
80107448:	90                   	nop
80107449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107450 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 1c             	sub    $0x1c,%esp
80107459:	8b 75 10             	mov    0x10(%ebp),%esi
8010745c:	8b 45 08             	mov    0x8(%ebp),%eax
8010745f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107462:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010746b:	77 49                	ja     801074b6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010746d:	e8 ce b8 ff ff       	call   80102d40 <kalloc>
  memset(mem, 0, PGSIZE);
80107472:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107475:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107477:	68 00 10 00 00       	push   $0x1000
8010747c:	6a 00                	push   $0x0
8010747e:	50                   	push   %eax
8010747f:	e8 3c d8 ff ff       	call   80104cc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107484:	58                   	pop    %eax
80107485:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010748b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107490:	5a                   	pop    %edx
80107491:	6a 06                	push   $0x6
80107493:	50                   	push   %eax
80107494:	31 d2                	xor    %edx,%edx
80107496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107499:	e8 52 fc ff ff       	call   801070f0 <mappages>
  memmove(mem, init, sz);
8010749e:	89 75 10             	mov    %esi,0x10(%ebp)
801074a1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801074a4:	83 c4 10             	add    $0x10,%esp
801074a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801074aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801074b1:	e9 ba d8 ff ff       	jmp    80104d70 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801074b6:	83 ec 0c             	sub    $0xc,%esp
801074b9:	68 fd 82 10 80       	push   $0x801082fd
801074be:	e8 ad 8e ff ff       	call   80100370 <panic>
801074c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074d0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801074d9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801074e0:	0f 85 91 00 00 00    	jne    80107577 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801074e6:	8b 75 18             	mov    0x18(%ebp),%esi
801074e9:	31 db                	xor    %ebx,%ebx
801074eb:	85 f6                	test   %esi,%esi
801074ed:	75 1a                	jne    80107509 <loaduvm+0x39>
801074ef:	eb 6f                	jmp    80107560 <loaduvm+0x90>
801074f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074fe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107504:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107507:	76 57                	jbe    80107560 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107509:	8b 55 0c             	mov    0xc(%ebp),%edx
8010750c:	8b 45 08             	mov    0x8(%ebp),%eax
8010750f:	31 c9                	xor    %ecx,%ecx
80107511:	01 da                	add    %ebx,%edx
80107513:	e8 58 fb ff ff       	call   80107070 <walkpgdir>
80107518:	85 c0                	test   %eax,%eax
8010751a:	74 4e                	je     8010756a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010751c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010751e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107521:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107526:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010752b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107531:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107534:	01 d9                	add    %ebx,%ecx
80107536:	05 00 00 00 80       	add    $0x80000000,%eax
8010753b:	57                   	push   %edi
8010753c:	51                   	push   %ecx
8010753d:	50                   	push   %eax
8010753e:	ff 75 10             	pushl  0x10(%ebp)
80107541:	e8 1a a5 ff ff       	call   80101a60 <readi>
80107546:	83 c4 10             	add    $0x10,%esp
80107549:	39 c7                	cmp    %eax,%edi
8010754b:	74 ab                	je     801074f8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010754d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
8010755a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107560:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107563:	31 c0                	xor    %eax,%eax
}
80107565:	5b                   	pop    %ebx
80107566:	5e                   	pop    %esi
80107567:	5f                   	pop    %edi
80107568:	5d                   	pop    %ebp
80107569:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010756a:	83 ec 0c             	sub    $0xc,%esp
8010756d:	68 17 83 10 80       	push   $0x80108317
80107572:	e8 f9 8d ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107577:	83 ec 0c             	sub    $0xc,%esp
8010757a:	68 b8 83 10 80       	push   $0x801083b8
8010757f:	e8 ec 8d ff ff       	call   80100370 <panic>
80107584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010758a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107590 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	57                   	push   %edi
80107594:	56                   	push   %esi
80107595:	53                   	push   %ebx
80107596:	83 ec 0c             	sub    $0xc,%esp
80107599:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010759c:	85 ff                	test   %edi,%edi
8010759e:	0f 88 ca 00 00 00    	js     8010766e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
801075a4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801075a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801075aa:	0f 82 82 00 00 00    	jb     80107632 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
801075b0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801075b6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801075bc:	39 df                	cmp    %ebx,%edi
801075be:	77 43                	ja     80107603 <allocuvm+0x73>
801075c0:	e9 bb 00 00 00       	jmp    80107680 <allocuvm+0xf0>
801075c5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801075c8:	83 ec 04             	sub    $0x4,%esp
801075cb:	68 00 10 00 00       	push   $0x1000
801075d0:	6a 00                	push   $0x0
801075d2:	50                   	push   %eax
801075d3:	e8 e8 d6 ff ff       	call   80104cc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075d8:	58                   	pop    %eax
801075d9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075df:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075e4:	5a                   	pop    %edx
801075e5:	6a 06                	push   $0x6
801075e7:	50                   	push   %eax
801075e8:	89 da                	mov    %ebx,%edx
801075ea:	8b 45 08             	mov    0x8(%ebp),%eax
801075ed:	e8 fe fa ff ff       	call   801070f0 <mappages>
801075f2:	83 c4 10             	add    $0x10,%esp
801075f5:	85 c0                	test   %eax,%eax
801075f7:	78 47                	js     80107640 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801075f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075ff:	39 df                	cmp    %ebx,%edi
80107601:	76 7d                	jbe    80107680 <allocuvm+0xf0>
    mem = kalloc();
80107603:	e8 38 b7 ff ff       	call   80102d40 <kalloc>
    if(mem == 0){
80107608:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010760a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010760c:	75 ba                	jne    801075c8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010760e:	83 ec 0c             	sub    $0xc,%esp
80107611:	68 35 83 10 80       	push   $0x80108335
80107616:	e8 45 90 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010761b:	83 c4 10             	add    $0x10,%esp
8010761e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107621:	76 4b                	jbe    8010766e <allocuvm+0xde>
80107623:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107626:	8b 45 08             	mov    0x8(%ebp),%eax
80107629:	89 fa                	mov    %edi,%edx
8010762b:	e8 50 fb ff ff       	call   80107180 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107630:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107632:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107635:	5b                   	pop    %ebx
80107636:	5e                   	pop    %esi
80107637:	5f                   	pop    %edi
80107638:	5d                   	pop    %ebp
80107639:	c3                   	ret    
8010763a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107640:	83 ec 0c             	sub    $0xc,%esp
80107643:	68 4d 83 10 80       	push   $0x8010834d
80107648:	e8 13 90 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010764d:	83 c4 10             	add    $0x10,%esp
80107650:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107653:	76 0d                	jbe    80107662 <allocuvm+0xd2>
80107655:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107658:	8b 45 08             	mov    0x8(%ebp),%eax
8010765b:	89 fa                	mov    %edi,%edx
8010765d:	e8 1e fb ff ff       	call   80107180 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107662:	83 ec 0c             	sub    $0xc,%esp
80107665:	56                   	push   %esi
80107666:	e8 25 b5 ff ff       	call   80102b90 <kfree>
      return 0;
8010766b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010766e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107671:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107673:	5b                   	pop    %ebx
80107674:	5e                   	pop    %esi
80107675:	5f                   	pop    %edi
80107676:	5d                   	pop    %ebp
80107677:	c3                   	ret    
80107678:	90                   	nop
80107679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107680:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107683:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107685:	5b                   	pop    %ebx
80107686:	5e                   	pop    %esi
80107687:	5f                   	pop    %edi
80107688:	5d                   	pop    %ebp
80107689:	c3                   	ret    
8010768a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107690 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	8b 55 0c             	mov    0xc(%ebp),%edx
80107696:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107699:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010769c:	39 d1                	cmp    %edx,%ecx
8010769e:	73 10                	jae    801076b0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801076a0:	5d                   	pop    %ebp
801076a1:	e9 da fa ff ff       	jmp    80107180 <deallocuvm.part.0>
801076a6:	8d 76 00             	lea    0x0(%esi),%esi
801076a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801076b0:	89 d0                	mov    %edx,%eax
801076b2:	5d                   	pop    %ebp
801076b3:	c3                   	ret    
801076b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801076c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076c0:	55                   	push   %ebp
801076c1:	89 e5                	mov    %esp,%ebp
801076c3:	57                   	push   %edi
801076c4:	56                   	push   %esi
801076c5:	53                   	push   %ebx
801076c6:	83 ec 0c             	sub    $0xc,%esp
801076c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076cc:	85 f6                	test   %esi,%esi
801076ce:	74 59                	je     80107729 <freevm+0x69>
801076d0:	31 c9                	xor    %ecx,%ecx
801076d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076d7:	89 f0                	mov    %esi,%eax
801076d9:	e8 a2 fa ff ff       	call   80107180 <deallocuvm.part.0>
801076de:	89 f3                	mov    %esi,%ebx
801076e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076e6:	eb 0f                	jmp    801076f7 <freevm+0x37>
801076e8:	90                   	nop
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076f3:	39 fb                	cmp    %edi,%ebx
801076f5:	74 23                	je     8010771a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076f7:	8b 03                	mov    (%ebx),%eax
801076f9:	a8 01                	test   $0x1,%al
801076fb:	74 f3                	je     801076f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801076fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107702:	83 ec 0c             	sub    $0xc,%esp
80107705:	83 c3 04             	add    $0x4,%ebx
80107708:	05 00 00 00 80       	add    $0x80000000,%eax
8010770d:	50                   	push   %eax
8010770e:	e8 7d b4 ff ff       	call   80102b90 <kfree>
80107713:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107716:	39 fb                	cmp    %edi,%ebx
80107718:	75 dd                	jne    801076f7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010771a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010771d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107720:	5b                   	pop    %ebx
80107721:	5e                   	pop    %esi
80107722:	5f                   	pop    %edi
80107723:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107724:	e9 67 b4 ff ff       	jmp    80102b90 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107729:	83 ec 0c             	sub    $0xc,%esp
8010772c:	68 69 83 10 80       	push   $0x80108369
80107731:	e8 3a 8c ff ff       	call   80100370 <panic>
80107736:	8d 76 00             	lea    0x0(%esi),%esi
80107739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107740 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	56                   	push   %esi
80107744:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107745:	e8 f6 b5 ff ff       	call   80102d40 <kalloc>
8010774a:	85 c0                	test   %eax,%eax
8010774c:	74 6a                	je     801077b8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010774e:	83 ec 04             	sub    $0x4,%esp
80107751:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107753:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107758:	68 00 10 00 00       	push   $0x1000
8010775d:	6a 00                	push   $0x0
8010775f:	50                   	push   %eax
80107760:	e8 5b d5 ff ff       	call   80104cc0 <memset>
80107765:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107768:	8b 43 04             	mov    0x4(%ebx),%eax
8010776b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010776e:	83 ec 08             	sub    $0x8,%esp
80107771:	8b 13                	mov    (%ebx),%edx
80107773:	ff 73 0c             	pushl  0xc(%ebx)
80107776:	50                   	push   %eax
80107777:	29 c1                	sub    %eax,%ecx
80107779:	89 f0                	mov    %esi,%eax
8010777b:	e8 70 f9 ff ff       	call   801070f0 <mappages>
80107780:	83 c4 10             	add    $0x10,%esp
80107783:	85 c0                	test   %eax,%eax
80107785:	78 19                	js     801077a0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107787:	83 c3 10             	add    $0x10,%ebx
8010778a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107790:	75 d6                	jne    80107768 <setupkvm+0x28>
80107792:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107794:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107797:	5b                   	pop    %ebx
80107798:	5e                   	pop    %esi
80107799:	5d                   	pop    %ebp
8010779a:	c3                   	ret    
8010779b:	90                   	nop
8010779c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
801077a0:	83 ec 0c             	sub    $0xc,%esp
801077a3:	56                   	push   %esi
801077a4:	e8 17 ff ff ff       	call   801076c0 <freevm>
      return 0;
801077a9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
801077ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
801077af:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801077b1:	5b                   	pop    %ebx
801077b2:	5e                   	pop    %esi
801077b3:	5d                   	pop    %ebp
801077b4:	c3                   	ret    
801077b5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801077b8:	31 c0                	xor    %eax,%eax
801077ba:	eb d8                	jmp    80107794 <setupkvm+0x54>
801077bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077c0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077c6:	e8 75 ff ff ff       	call   80107740 <setupkvm>
801077cb:	a3 44 66 11 80       	mov    %eax,0x80116644
801077d0:	05 00 00 00 80       	add    $0x80000000,%eax
801077d5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801077d8:	c9                   	leave  
801077d9:	c3                   	ret    
801077da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077e1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077e3:	89 e5                	mov    %esp,%ebp
801077e5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801077eb:	8b 45 08             	mov    0x8(%ebp),%eax
801077ee:	e8 7d f8 ff ff       	call   80107070 <walkpgdir>
  if(pte == 0)
801077f3:	85 c0                	test   %eax,%eax
801077f5:	74 05                	je     801077fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077fa:	c9                   	leave  
801077fb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801077fc:	83 ec 0c             	sub    $0xc,%esp
801077ff:	68 7a 83 10 80       	push   $0x8010837a
80107804:	e8 67 8b ff ff       	call   80100370 <panic>
80107809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107810 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	57                   	push   %edi
80107814:	56                   	push   %esi
80107815:	53                   	push   %ebx
80107816:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107819:	e8 22 ff ff ff       	call   80107740 <setupkvm>
8010781e:	85 c0                	test   %eax,%eax
80107820:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107823:	0f 84 b2 00 00 00    	je     801078db <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107829:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010782c:	85 c9                	test   %ecx,%ecx
8010782e:	0f 84 9c 00 00 00    	je     801078d0 <copyuvm+0xc0>
80107834:	31 f6                	xor    %esi,%esi
80107836:	eb 4a                	jmp    80107882 <copyuvm+0x72>
80107838:	90                   	nop
80107839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107840:	83 ec 04             	sub    $0x4,%esp
80107843:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107849:	68 00 10 00 00       	push   $0x1000
8010784e:	57                   	push   %edi
8010784f:	50                   	push   %eax
80107850:	e8 1b d5 ff ff       	call   80104d70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107855:	58                   	pop    %eax
80107856:	5a                   	pop    %edx
80107857:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010785d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107860:	ff 75 e4             	pushl  -0x1c(%ebp)
80107863:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107868:	52                   	push   %edx
80107869:	89 f2                	mov    %esi,%edx
8010786b:	e8 80 f8 ff ff       	call   801070f0 <mappages>
80107870:	83 c4 10             	add    $0x10,%esp
80107873:	85 c0                	test   %eax,%eax
80107875:	78 3e                	js     801078b5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107877:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010787d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107880:	76 4e                	jbe    801078d0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107882:	8b 45 08             	mov    0x8(%ebp),%eax
80107885:	31 c9                	xor    %ecx,%ecx
80107887:	89 f2                	mov    %esi,%edx
80107889:	e8 e2 f7 ff ff       	call   80107070 <walkpgdir>
8010788e:	85 c0                	test   %eax,%eax
80107890:	74 5a                	je     801078ec <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107892:	8b 18                	mov    (%eax),%ebx
80107894:	f6 c3 01             	test   $0x1,%bl
80107897:	74 46                	je     801078df <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107899:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010789b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801078a1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078a4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801078aa:	e8 91 b4 ff ff       	call   80102d40 <kalloc>
801078af:	85 c0                	test   %eax,%eax
801078b1:	89 c3                	mov    %eax,%ebx
801078b3:	75 8b                	jne    80107840 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801078b5:	83 ec 0c             	sub    $0xc,%esp
801078b8:	ff 75 e0             	pushl  -0x20(%ebp)
801078bb:	e8 00 fe ff ff       	call   801076c0 <freevm>
  return 0;
801078c0:	83 c4 10             	add    $0x10,%esp
801078c3:	31 c0                	xor    %eax,%eax
}
801078c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c8:	5b                   	pop    %ebx
801078c9:	5e                   	pop    %esi
801078ca:	5f                   	pop    %edi
801078cb:	5d                   	pop    %ebp
801078cc:	c3                   	ret    
801078cd:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801078d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d6:	5b                   	pop    %ebx
801078d7:	5e                   	pop    %esi
801078d8:	5f                   	pop    %edi
801078d9:	5d                   	pop    %ebp
801078da:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801078db:	31 c0                	xor    %eax,%eax
801078dd:	eb e6                	jmp    801078c5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801078df:	83 ec 0c             	sub    $0xc,%esp
801078e2:	68 9e 83 10 80       	push   $0x8010839e
801078e7:	e8 84 8a ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801078ec:	83 ec 0c             	sub    $0xc,%esp
801078ef:	68 84 83 10 80       	push   $0x80108384
801078f4:	e8 77 8a ff ff       	call   80100370 <panic>
801078f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107900 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107900:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107901:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107903:	89 e5                	mov    %esp,%ebp
80107905:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107908:	8b 55 0c             	mov    0xc(%ebp),%edx
8010790b:	8b 45 08             	mov    0x8(%ebp),%eax
8010790e:	e8 5d f7 ff ff       	call   80107070 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107913:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107915:	89 c2                	mov    %eax,%edx
80107917:	83 e2 05             	and    $0x5,%edx
8010791a:	83 fa 05             	cmp    $0x5,%edx
8010791d:	75 11                	jne    80107930 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010791f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107924:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107925:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010792a:	c3                   	ret    
8010792b:	90                   	nop
8010792c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107930:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107932:	c9                   	leave  
80107933:	c3                   	ret    
80107934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010793a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107940 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	53                   	push   %ebx
80107946:	83 ec 1c             	sub    $0x1c,%esp
80107949:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010794c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010794f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107952:	85 db                	test   %ebx,%ebx
80107954:	75 40                	jne    80107996 <copyout+0x56>
80107956:	eb 70                	jmp    801079c8 <copyout+0x88>
80107958:	90                   	nop
80107959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107960:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107963:	89 f1                	mov    %esi,%ecx
80107965:	29 d1                	sub    %edx,%ecx
80107967:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010796d:	39 d9                	cmp    %ebx,%ecx
8010796f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107972:	29 f2                	sub    %esi,%edx
80107974:	83 ec 04             	sub    $0x4,%esp
80107977:	01 d0                	add    %edx,%eax
80107979:	51                   	push   %ecx
8010797a:	57                   	push   %edi
8010797b:	50                   	push   %eax
8010797c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010797f:	e8 ec d3 ff ff       	call   80104d70 <memmove>
    len -= n;
    buf += n;
80107984:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107987:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010798a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107990:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107992:	29 cb                	sub    %ecx,%ebx
80107994:	74 32                	je     801079c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107996:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107998:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010799b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010799e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801079a4:	56                   	push   %esi
801079a5:	ff 75 08             	pushl  0x8(%ebp)
801079a8:	e8 53 ff ff ff       	call   80107900 <uva2ka>
    if(pa0 == 0)
801079ad:	83 c4 10             	add    $0x10,%esp
801079b0:	85 c0                	test   %eax,%eax
801079b2:	75 ac                	jne    80107960 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801079b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801079b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801079bc:	5b                   	pop    %ebx
801079bd:	5e                   	pop    %esi
801079be:	5f                   	pop    %edi
801079bf:	5d                   	pop    %ebp
801079c0:	c3                   	ret    
801079c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801079cb:	31 c0                	xor    %eax,%eax
}
801079cd:	5b                   	pop    %ebx
801079ce:	5e                   	pop    %esi
801079cf:	5f                   	pop    %edi
801079d0:	5d                   	pop    %ebp
801079d1:	c3                   	ret    
