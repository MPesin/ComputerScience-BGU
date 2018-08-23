
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 10 e6 10 80       	mov    $0x8010e610,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 57 3b 10 80       	mov    $0x80103b57,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 34 8d 10 	movl   $0x80108d34,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 20 e6 10 80 	movl   $0x8010e620,(%esp)
80100049:	e8 3c 55 00 00       	call   8010558a <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 50 fb 10 80 44 	movl   $0x8010fb44,0x8010fb50
80100055:	fb 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 54 fb 10 80 44 	movl   $0x8010fb44,0x8010fb54
8010005f:	fb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 54 e6 10 80 	movl   $0x8010e654,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 54 fb 10 80    	mov    0x8010fb54,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 44 fb 10 80 	movl   $0x8010fb44,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 54 fb 10 80       	mov    0x8010fb54,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 54 fb 10 80       	mov    %eax,0x8010fb54

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 44 fb 10 80 	cmpl   $0x8010fb44,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 20 e6 10 80 	movl   $0x8010e620,(%esp)
801000bd:	e8 e9 54 00 00       	call   801055ab <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 54 fb 10 80       	mov    0x8010fb54,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 20 e6 10 80 	movl   $0x8010e620,(%esp)
80100104:	e8 04 55 00 00       	call   8010560d <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 20 e6 10 	movl   $0x8010e620,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 0f 51 00 00       	call   80105233 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 44 fb 10 80 	cmpl   $0x8010fb44,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 50 fb 10 80       	mov    0x8010fb50,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 20 e6 10 80 	movl   $0x8010e620,(%esp)
8010017c:	e8 8c 54 00 00       	call   8010560d <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 44 fb 10 80 	cmpl   $0x8010fb44,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 3b 8d 10 80 	movl   $0x80108d3b,(%esp)
8010019f:	e8 99 03 00 00       	call   8010053d <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 2c 2d 00 00       	call   80102f04 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 4c 8d 10 80 	movl   $0x80108d4c,(%esp)
801001f6:	e8 42 03 00 00       	call   8010053d <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 ef 2c 00 00       	call   80102f04 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 53 8d 10 80 	movl   $0x80108d53,(%esp)
80100230:	e8 08 03 00 00       	call   8010053d <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 20 e6 10 80 	movl   $0x8010e620,(%esp)
8010023c:	e8 6a 53 00 00       	call   801055ab <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 54 fb 10 80    	mov    0x8010fb54,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 44 fb 10 80 	movl   $0x8010fb44,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 54 fb 10 80       	mov    0x8010fb54,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 54 fb 10 80       	mov    %eax,0x8010fb54

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 ff 50 00 00       	call   801053a1 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 20 e6 10 80 	movl   $0x8010e620,(%esp)
801002a9:	e8 5f 53 00 00       	call   8010560d <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801002c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801002ca:	ec                   	in     (%dx),%al
801002cb:	89 c3                	mov    %eax,%ebx
801002cd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801002d4:	83 c4 14             	add    $0x14,%esp
801002d7:	5b                   	pop    %ebx
801002d8:	5d                   	pop    %ebp
801002d9:	c3                   	ret    

801002da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002da:	55                   	push   %ebp
801002db:	89 e5                	mov    %esp,%ebp
801002dd:	83 ec 08             	sub    $0x8,%esp
801002e0:	8b 55 08             	mov    0x8(%ebp),%edx
801002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801002e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002f5:	ee                   	out    %al,(%dx)
}
801002f6:	c9                   	leave  
801002f7:	c3                   	ret    

801002f8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002fb:	fa                   	cli    
}
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    

801002fe <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 19                	je     80100323 <printint+0x25>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	89 45 10             	mov    %eax,0x10(%ebp)
80100313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100317:	74 0a                	je     80100323 <printint+0x25>
    x = -xx;
80100319:	8b 45 08             	mov    0x8(%ebp),%eax
8010031c:	f7 d8                	neg    %eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100321:	eb 06                	jmp    80100329 <printint+0x2b>
  else
    x = xx;
80100323:	8b 45 08             	mov    0x8(%ebp),%eax
80100326:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100329:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100330:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100333:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100336:	ba 00 00 00 00       	mov    $0x0,%edx
8010033b:	f7 f1                	div    %ecx
8010033d:	89 d0                	mov    %edx,%eax
8010033f:	0f b6 90 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%edx
80100346:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100349:	03 45 f4             	add    -0xc(%ebp),%eax
8010034c:	88 10                	mov    %dl,(%eax)
8010034e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
80100352:	8b 55 0c             	mov    0xc(%ebp),%edx
80100355:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035b:	ba 00 00 00 00       	mov    $0x0,%edx
80100360:	f7 75 d4             	divl   -0x2c(%ebp)
80100363:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036a:	75 c4                	jne    80100330 <printint+0x32>

  if(sign)
8010036c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100370:	74 23                	je     80100395 <printint+0x97>
    buf[i++] = '-';
80100372:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100375:	03 45 f4             	add    -0xc(%ebp),%eax
80100378:	c6 00 2d             	movb   $0x2d,(%eax)
8010037b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
8010037f:	eb 14                	jmp    80100395 <printint+0x97>
    consputc(buf[i]);
80100381:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100384:	03 45 f4             	add    -0xc(%ebp),%eax
80100387:	0f b6 00             	movzbl (%eax),%eax
8010038a:	0f be c0             	movsbl %al,%eax
8010038d:	89 04 24             	mov    %eax,(%esp)
80100390:	e8 e2 03 00 00       	call   80100777 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100395:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010039d:	79 e2                	jns    80100381 <printint+0x83>
    consputc(buf[i]);
}
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
801003a4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a7:	a1 74 d0 10 80       	mov    0x8010d074,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 40 d0 10 80 	movl   $0x8010d040,(%esp)
801003bc:	e8 ea 51 00 00       	call   801055ab <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 5a 8d 10 80 	movl   $0x80108d5a,(%esp)
801003cf:	e8 69 01 00 00       	call   8010053d <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e1:	e9 20 01 00 00       	jmp    80100506 <cprintf+0x165>
    if(c != '%'){
801003e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003ea:	74 10                	je     801003fc <cprintf+0x5b>
      consputc(c);
801003ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ef:	89 04 24             	mov    %eax,(%esp)
801003f2:	e8 80 03 00 00       	call   80100777 <consputc>
      continue;
801003f7:	e9 06 01 00 00       	jmp    80100502 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
801003fc:	8b 55 08             	mov    0x8(%ebp),%edx
801003ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100406:	01 d0                	add    %edx,%eax
80100408:	0f b6 00             	movzbl (%eax),%eax
8010040b:	0f be c0             	movsbl %al,%eax
8010040e:	25 ff 00 00 00       	and    $0xff,%eax
80100413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100416:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010041a:	0f 84 08 01 00 00    	je     80100528 <cprintf+0x187>
      break;
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4d                	je     80100475 <cprintf+0xd4>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0x9f>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13b>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xae>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x149>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 53                	je     80100498 <cprintf+0xf7>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2b                	je     80100475 <cprintf+0xd4>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x149>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8b 00                	mov    (%eax),%eax
80100454:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045f:	00 
80100460:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100467:	00 
80100468:	89 04 24             	mov    %eax,(%esp)
8010046b:	e8 8e fe ff ff       	call   801002fe <printint>
      break;
80100470:	e9 8d 00 00 00       	jmp    80100502 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100478:	8b 00                	mov    (%eax),%eax
8010047a:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100485:	00 
80100486:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048d:	00 
8010048e:	89 04 24             	mov    %eax,(%esp)
80100491:	e8 68 fe ff ff       	call   801002fe <printint>
      break;
80100496:	eb 6a                	jmp    80100502 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
80100498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049b:	8b 00                	mov    (%eax),%eax
8010049d:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004a4:	0f 94 c0             	sete   %al
801004a7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004ab:	84 c0                	test   %al,%al
801004ad:	74 20                	je     801004cf <cprintf+0x12e>
        s = "(null)";
801004af:	c7 45 ec 63 8d 10 80 	movl   $0x80108d63,-0x14(%ebp)
      for(; *s; s++)
801004b6:	eb 17                	jmp    801004cf <cprintf+0x12e>
        consputc(*s);
801004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004bb:	0f b6 00             	movzbl (%eax),%eax
801004be:	0f be c0             	movsbl %al,%eax
801004c1:	89 04 24             	mov    %eax,(%esp)
801004c4:	e8 ae 02 00 00       	call   80100777 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004cd:	eb 01                	jmp    801004d0 <cprintf+0x12f>
801004cf:	90                   	nop
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 de                	jne    801004b8 <cprintf+0x117>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x161>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 8f 02 00 00       	call   80100777 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 81 02 00 00       	call   80100777 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 76 02 00 00       	call   80100777 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 c0 fe ff ff    	jne    801003e6 <cprintf+0x45>
80100526:	eb 01                	jmp    80100529 <cprintf+0x188>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100528:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100529:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052d:	74 0c                	je     8010053b <cprintf+0x19a>
    release(&cons.lock);
8010052f:	c7 04 24 40 d0 10 80 	movl   $0x8010d040,(%esp)
80100536:	e8 d2 50 00 00       	call   8010560d <release>
}
8010053b:	c9                   	leave  
8010053c:	c3                   	ret    

8010053d <panic>:

void
panic(char *s)
{
8010053d:	55                   	push   %ebp
8010053e:	89 e5                	mov    %esp,%ebp
80100540:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100543:	e8 b0 fd ff ff       	call   801002f8 <cli>
  cons.locking = 0;
80100548:	c7 05 74 d0 10 80 00 	movl   $0x0,0x8010d074
8010054f:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100552:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f b6 c0             	movzbl %al,%eax
8010055e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100562:	c7 04 24 6a 8d 10 80 	movl   $0x80108d6a,(%esp)
80100569:	e8 33 fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
8010056e:	8b 45 08             	mov    0x8(%ebp),%eax
80100571:	89 04 24             	mov    %eax,(%esp)
80100574:	e8 28 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100579:	c7 04 24 79 8d 10 80 	movl   $0x80108d79,(%esp)
80100580:	e8 1c fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
80100585:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010058c:	8d 45 08             	lea    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 c5 50 00 00       	call   8010565c <getcallerpcs>
  for(i=0; i<10; i++)
80100597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059e:	eb 1b                	jmp    801005bb <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005ab:	c7 04 24 7b 8d 10 80 	movl   $0x80108d7b,(%esp)
801005b2:	e8 ea fd ff ff       	call   801003a1 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005bb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bf:	7e df                	jle    801005a0 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005c1:	c7 05 30 d0 10 80 01 	movl   $0x1,0x8010d030
801005c8:	00 00 00 
  for(;;)
    ;
801005cb:	eb fe                	jmp    801005cb <panic+0x8e>

801005cd <cgaputc>:
#define KEY_DN 0xE3

static uint arrows_counter = 0; // counter from right to left    3 2 1 0 <-
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void cgaputc(int c) {
801005cd:	55                   	push   %ebp
801005ce:	89 e5                	mov    %esp,%ebp
801005d0:	83 ec 28             	sub    $0x28,%esp
	int pos;
	// Cursor position: col + 80*row.
	outb(CRTPORT, 14);
801005d3:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005da:	00 
801005db:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005e2:	e8 f3 fc ff ff       	call   801002da <outb>
	pos = inb(CRTPORT+1) << 8;
801005e7:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005ee:	e8 bd fc ff ff       	call   801002b0 <inb>
801005f3:	0f b6 c0             	movzbl %al,%eax
801005f6:	c1 e0 08             	shl    $0x8,%eax
801005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	outb(CRTPORT, 15);
801005fc:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100603:	00 
80100604:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010060b:	e8 ca fc ff ff       	call   801002da <outb>
	pos |= inb(CRTPORT+1);
80100610:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100617:	e8 94 fc ff ff       	call   801002b0 <inb>
8010061c:	0f b6 c0             	movzbl %al,%eax
8010061f:	09 45 f4             	or     %eax,-0xc(%ebp)
	if(c == '\n')
80100622:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100626:	75 30                	jne    80100658 <cgaputc+0x8b>
		pos += 80 - pos%80;
80100628:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010062b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100630:	89 c8                	mov    %ecx,%eax
80100632:	f7 ea                	imul   %edx
80100634:	c1 fa 05             	sar    $0x5,%edx
80100637:	89 c8                	mov    %ecx,%eax
80100639:	c1 f8 1f             	sar    $0x1f,%eax
8010063c:	29 c2                	sub    %eax,%edx
8010063e:	89 d0                	mov    %edx,%eax
80100640:	c1 e0 02             	shl    $0x2,%eax
80100643:	01 d0                	add    %edx,%eax
80100645:	c1 e0 04             	shl    $0x4,%eax
80100648:	89 ca                	mov    %ecx,%edx
8010064a:	29 c2                	sub    %eax,%edx
8010064c:	b8 50 00 00 00       	mov    $0x50,%eax
80100651:	29 d0                	sub    %edx,%eax
80100653:	01 45 f4             	add    %eax,-0xc(%ebp)
80100656:	eb 50                	jmp    801006a8 <cgaputc+0xdb>
	else if (c == BACKSPACE || c == KEY_LF) {
80100658:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065f:	74 09                	je     8010066a <cgaputc+0x9d>
80100661:	81 7d 08 e4 00 00 00 	cmpl   $0xe4,0x8(%ebp)
80100668:	75 0c                	jne    80100676 <cgaputc+0xa9>
		if (pos > 0) { pos--; }
8010066a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010066e:	7e 38                	jle    801006a8 <cgaputc+0xdb>
80100670:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100674:	eb 32                	jmp    801006a8 <cgaputc+0xdb>
	} else if (c == KEY_RT) {
80100676:	81 7d 08 e5 00 00 00 	cmpl   $0xe5,0x8(%ebp)
8010067d:	75 0c                	jne    8010068b <cgaputc+0xbe>
		if (pos > 0) { pos++; }
8010067f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100683:	7e 23                	jle    801006a8 <cgaputc+0xdb>
80100685:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100689:	eb 1d                	jmp    801006a8 <cgaputc+0xdb>
	} else
		crt[pos++] = (c & 0xff) | 0x0700;  // black on white
8010068b:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100690:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100693:	01 d2                	add    %edx,%edx
80100695:	01 c2                	add    %eax,%edx
80100697:	8b 45 08             	mov    0x8(%ebp),%eax
8010069a:	66 25 ff 00          	and    $0xff,%ax
8010069e:	80 cc 07             	or     $0x7,%ah
801006a1:	66 89 02             	mov    %ax,(%edx)
801006a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

	if((pos/80) >= 24){  // Scroll up.
801006a8:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006af:	7e 53                	jle    80100704 <cgaputc+0x137>
		memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006b1:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006b6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006bc:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006c1:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c8:	00 
801006c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801006cd:	89 04 24             	mov    %eax,(%esp)
801006d0:	e8 f8 51 00 00       	call   801058cd <memmove>
		pos -= 80;
801006d5:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
		memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d9:	b8 80 07 00 00       	mov    $0x780,%eax
801006de:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006e1:	01 c0                	add    %eax,%eax
801006e3:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801006e9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ec:	01 c9                	add    %ecx,%ecx
801006ee:	01 ca                	add    %ecx,%edx
801006f0:	89 44 24 08          	mov    %eax,0x8(%esp)
801006f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006fb:	00 
801006fc:	89 14 24             	mov    %edx,(%esp)
801006ff:	e8 f6 50 00 00       	call   801057fa <memset>
	}

	outb(CRTPORT, 14);
80100704:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
8010070b:	00 
8010070c:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100713:	e8 c2 fb ff ff       	call   801002da <outb>
	outb(CRTPORT+1, pos>>8);
80100718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010071b:	c1 f8 08             	sar    $0x8,%eax
8010071e:	0f b6 c0             	movzbl %al,%eax
80100721:	89 44 24 04          	mov    %eax,0x4(%esp)
80100725:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010072c:	e8 a9 fb ff ff       	call   801002da <outb>
	outb(CRTPORT, 15);
80100731:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100738:	00 
80100739:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100740:	e8 95 fb ff ff       	call   801002da <outb>
	outb(CRTPORT+1, pos);
80100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100748:	0f b6 c0             	movzbl %al,%eax
8010074b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100756:	e8 7f fb ff ff       	call   801002da <outb>
	if(c == BACKSPACE)
8010075b:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100762:	75 11                	jne    80100775 <cgaputc+0x1a8>
		crt[pos] = ' ' | 0x0700;
80100764:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100769:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010076c:	01 d2                	add    %edx,%edx
8010076e:	01 d0                	add    %edx,%eax
80100770:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100775:	c9                   	leave  
80100776:	c3                   	ret    

80100777 <consputc>:

void consputc(int c) {
80100777:	55                   	push   %ebp
80100778:	89 e5                	mov    %esp,%ebp
8010077a:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010077d:	a1 30 d0 10 80       	mov    0x8010d030,%eax
80100782:	85 c0                	test   %eax,%eax
80100784:	74 07                	je     8010078d <consputc+0x16>
    cli();
80100786:	e8 6d fb ff ff       	call   801002f8 <cli>
    for(;;)
      ;
8010078b:	eb fe                	jmp    8010078b <consputc+0x14>
  }

  if(c == BACKSPACE){
8010078d:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100794:	75 26                	jne    801007bc <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100796:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010079d:	e8 f7 6b 00 00       	call   80107399 <uartputc>
801007a2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007a9:	e8 eb 6b 00 00       	call   80107399 <uartputc>
801007ae:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007b5:	e8 df 6b 00 00       	call   80107399 <uartputc>
801007ba:	eb 0b                	jmp    801007c7 <consputc+0x50>
  } else
    uartputc(c);
801007bc:	8b 45 08             	mov    0x8(%ebp),%eax
801007bf:	89 04 24             	mov    %eax,(%esp)
801007c2:	e8 d2 6b 00 00       	call   80107399 <uartputc>
  cgaputc(c);
801007c7:	8b 45 08             	mov    0x8(%ebp),%eax
801007ca:	89 04 24             	mov    %eax,(%esp)
801007cd:	e8 fb fd ff ff       	call   801005cd <cgaputc>
}
801007d2:	c9                   	leave  
801007d3:	c3                   	ret    

801007d4 <consoleintr>:

struct history_data history = {0,0,0,0};

#define C(x)  ((x)-'@')  // Control-x

void consoleintr(int (*getc)(void)) {
801007d4:	55                   	push   %ebp
801007d5:	89 e5                	mov    %esp,%ebp
801007d7:	83 ec 28             	sub    $0x28,%esp
  int c,i;
  uint e_pos;
  acquire(&input.lock);
801007da:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
801007e1:	e8 c5 4d 00 00       	call   801055ab <acquire>
  while((c = getc()) >= 0){
801007e6:	e9 1d 06 00 00       	jmp    80100e08 <consoleintr+0x634>
    switch(c) {
801007eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801007ee:	83 f8 7f             	cmp    $0x7f,%eax
801007f1:	0f 84 ae 00 00 00    	je     801008a5 <consoleintr+0xd1>
801007f7:	83 f8 7f             	cmp    $0x7f,%eax
801007fa:	7f 18                	jg     80100814 <consoleintr+0x40>
801007fc:	83 f8 10             	cmp    $0x10,%eax
801007ff:	74 50                	je     80100851 <consoleintr+0x7d>
80100801:	83 f8 15             	cmp    $0x15,%eax
80100804:	74 70                	je     80100876 <consoleintr+0xa2>
80100806:	83 f8 08             	cmp    $0x8,%eax
80100809:	0f 84 96 00 00 00    	je     801008a5 <consoleintr+0xd1>
8010080f:	e9 33 04 00 00       	jmp    80100c47 <consoleintr+0x473>
80100814:	3d e3 00 00 00       	cmp    $0xe3,%eax
80100819:	0f 84 0c 03 00 00    	je     80100b2b <consoleintr+0x357>
8010081f:	3d e3 00 00 00       	cmp    $0xe3,%eax
80100824:	7f 10                	jg     80100836 <consoleintr+0x62>
80100826:	3d e2 00 00 00       	cmp    $0xe2,%eax
8010082b:	0f 84 e3 01 00 00    	je     80100a14 <consoleintr+0x240>
80100831:	e9 11 04 00 00       	jmp    80100c47 <consoleintr+0x473>
80100836:	3d e4 00 00 00       	cmp    $0xe4,%eax
8010083b:	0f 84 72 01 00 00    	je     801009b3 <consoleintr+0x1df>
80100841:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100846:	0f 84 9e 01 00 00    	je     801009ea <consoleintr+0x216>
8010084c:	e9 f6 03 00 00       	jmp    80100c47 <consoleintr+0x473>
		case C('P'):  // Process listing.
		  procdump();
80100851:	e8 f1 4b 00 00       	call   80105447 <procdump>
		  break;
80100856:	e9 ad 05 00 00       	jmp    80100e08 <consoleintr+0x634>

		case C('U'):  // Kill line.
		  while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n'){
			input.e--;
8010085b:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100860:	83 e8 01             	sub    $0x1,%eax
80100863:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
			consputc(BACKSPACE);
80100868:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010086f:	e8 03 ff ff ff       	call   80100777 <consputc>
80100874:	eb 01                	jmp    80100877 <consoleintr+0xa3>
		case C('P'):  // Process listing.
		  procdump();
		  break;

		case C('U'):  // Kill line.
		  while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100876:	90                   	nop
80100877:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
8010087d:	a1 18 fe 10 80       	mov    0x8010fe18,%eax
80100882:	39 c2                	cmp    %eax,%edx
80100884:	0f 84 71 05 00 00    	je     80100dfb <consoleintr+0x627>
8010088a:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
8010088f:	83 e8 01             	sub    $0x1,%eax
80100892:	83 e0 7f             	and    $0x7f,%eax
80100895:	0f b6 80 94 fd 10 80 	movzbl -0x7fef026c(%eax),%eax
8010089c:	3c 0a                	cmp    $0xa,%al
8010089e:	75 bb                	jne    8010085b <consoleintr+0x87>
			input.e--;
			consputc(BACKSPACE);
		  }
		  break;
801008a0:	e9 56 05 00 00       	jmp    80100dfb <consoleintr+0x627>

		case C('H'): case '\x7f':  // Backspace
		  if(input.e-arrows_counter != input.w){
801008a5:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
801008ab:	a1 78 d0 10 80       	mov    0x8010d078,%eax
801008b0:	29 c2                	sub    %eax,%edx
801008b2:	a1 18 fe 10 80       	mov    0x8010fe18,%eax
801008b7:	39 c2                	cmp    %eax,%edx
801008b9:	0f 84 3f 05 00 00    	je     80100dfe <consoleintr+0x62a>
			if (arrows_counter == 0)
801008bf:	a1 78 d0 10 80       	mov    0x8010d078,%eax
801008c4:	85 c0                	test   %eax,%eax
801008c6:	75 0f                	jne    801008d7 <consoleintr+0x103>
				input.e--;
801008c8:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
801008cd:	83 e8 01             	sub    $0x1,%eax
801008d0:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
801008d5:	eb 14                	jmp    801008eb <consoleintr+0x117>
			else
				input.e -= arrows_counter+1;
801008d7:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
801008dc:	8b 15 78 d0 10 80    	mov    0x8010d078,%edx
801008e2:	f7 d2                	not    %edx
801008e4:	01 d0                	add    %edx,%eax
801008e6:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
			for(i = 0; i < arrows_counter; i++) {		// when in the middle of a word, shifting
801008eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801008f2:	eb 2c                	jmp    80100920 <consoleintr+0x14c>
			  input.buf[input.e] = input.buf[input.e+1];
801008f4:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
801008f9:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
801008ff:	83 c2 01             	add    $0x1,%edx
80100902:	0f b6 92 94 fd 10 80 	movzbl -0x7fef026c(%edx),%edx
80100909:	88 90 94 fd 10 80    	mov    %dl,-0x7fef026c(%eax)
			  input.e++;
8010090f:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100914:	83 c0 01             	add    $0x1,%eax
80100917:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
		  if(input.e-arrows_counter != input.w){
			if (arrows_counter == 0)
				input.e--;
			else
				input.e -= arrows_counter+1;
			for(i = 0; i < arrows_counter; i++) {		// when in the middle of a word, shifting
8010091c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100920:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100923:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100928:	39 c2                	cmp    %eax,%edx
8010092a:	72 c8                	jb     801008f4 <consoleintr+0x120>
			  input.buf[input.e] = input.buf[input.e+1];
			  input.e++;
			}
			input.buf[input.e] = '\0';
8010092c:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100931:	c6 80 94 fd 10 80 00 	movb   $0x0,-0x7fef026c(%eax)
			consputc(BACKSPACE);
80100938:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010093f:	e8 33 fe ff ff       	call   80100777 <consputc>
			for(i = 0; i < arrows_counter+1; i++)
80100944:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010094b:	eb 28                	jmp    80100975 <consoleintr+0x1a1>
				consputc(input.buf[input.e - arrows_counter +i ]);
8010094d:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
80100953:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100958:	29 c2                	sub    %eax,%edx
8010095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010095d:	01 d0                	add    %edx,%eax
8010095f:	0f b6 80 94 fd 10 80 	movzbl -0x7fef026c(%eax),%eax
80100966:	0f be c0             	movsbl %al,%eax
80100969:	89 04 24             	mov    %eax,(%esp)
8010096c:	e8 06 fe ff ff       	call   80100777 <consputc>
			  input.buf[input.e] = input.buf[input.e+1];
			  input.e++;
			}
			input.buf[input.e] = '\0';
			consputc(BACKSPACE);
			for(i = 0; i < arrows_counter+1; i++)
80100971:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100978:	8b 15 78 d0 10 80    	mov    0x8010d078,%edx
8010097e:	83 c2 01             	add    $0x1,%edx
80100981:	39 d0                	cmp    %edx,%eax
80100983:	72 c8                	jb     8010094d <consoleintr+0x179>
				consputc(input.buf[input.e - arrows_counter +i ]);
			for(i = 0; i < arrows_counter+1; i++)
80100985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010098c:	eb 10                	jmp    8010099e <consoleintr+0x1ca>
				consputc(KEY_LF);
8010098e:	c7 04 24 e4 00 00 00 	movl   $0xe4,(%esp)
80100995:	e8 dd fd ff ff       	call   80100777 <consputc>
			}
			input.buf[input.e] = '\0';
			consputc(BACKSPACE);
			for(i = 0; i < arrows_counter+1; i++)
				consputc(input.buf[input.e - arrows_counter +i ]);
			for(i = 0; i < arrows_counter+1; i++)
8010099a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010099e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801009a1:	8b 15 78 d0 10 80    	mov    0x8010d078,%edx
801009a7:	83 c2 01             	add    $0x1,%edx
801009aa:	39 d0                	cmp    %edx,%eax
801009ac:	72 e0                	jb     8010098e <consoleintr+0x1ba>
				consputc(KEY_LF);
		  }
		  break;
801009ae:	e9 4b 04 00 00       	jmp    80100dfe <consoleintr+0x62a>

		case KEY_LF:
		  if(arrows_counter < input.e - input.r) {
801009b3:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
801009b9:	a1 14 fe 10 80       	mov    0x8010fe14,%eax
801009be:	29 c2                	sub    %eax,%edx
801009c0:	a1 78 d0 10 80       	mov    0x8010d078,%eax
801009c5:	39 c2                	cmp    %eax,%edx
801009c7:	0f 86 34 04 00 00    	jbe    80100e01 <consoleintr+0x62d>
			  arrows_counter++;
801009cd:	a1 78 d0 10 80       	mov    0x8010d078,%eax
801009d2:	83 c0 01             	add    $0x1,%eax
801009d5:	a3 78 d0 10 80       	mov    %eax,0x8010d078
			  consputc(c);
801009da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009dd:	89 04 24             	mov    %eax,(%esp)
801009e0:	e8 92 fd ff ff       	call   80100777 <consputc>
		  }
		  break;
801009e5:	e9 17 04 00 00       	jmp    80100e01 <consoleintr+0x62d>

		case KEY_RT:
			if(arrows_counter > 0) {
801009ea:	a1 78 d0 10 80       	mov    0x8010d078,%eax
801009ef:	85 c0                	test   %eax,%eax
801009f1:	0f 84 0d 04 00 00    	je     80100e04 <consoleintr+0x630>
				arrows_counter--;
801009f7:	a1 78 d0 10 80       	mov    0x8010d078,%eax
801009fc:	83 e8 01             	sub    $0x1,%eax
801009ff:	a3 78 d0 10 80       	mov    %eax,0x8010d078
				consputc(c);
80100a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100a07:	89 04 24             	mov    %eax,(%esp)
80100a0a:	e8 68 fd ff ff       	call   80100777 <consputc>
			}
			break;
80100a0f:	e9 f0 03 00 00       	jmp    80100e04 <consoleintr+0x630>

		case KEY_UP: // up arrow
			for (i = 0; i < arrows_counter ; i++) {	// fixing POS with RightKey
80100a14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a1b:	eb 10                	jmp    80100a2d <consoleintr+0x259>
				consputc(KEY_RT);
80100a1d:	c7 04 24 e5 00 00 00 	movl   $0xe5,(%esp)
80100a24:	e8 4e fd ff ff       	call   80100777 <consputc>
				consputc(c);
			}
			break;

		case KEY_UP: // up arrow
			for (i = 0; i < arrows_counter ; i++) {	// fixing POS with RightKey
80100a29:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a30:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100a35:	39 c2                	cmp    %eax,%edx
80100a37:	72 e4                	jb     80100a1d <consoleintr+0x249>
				consputc(KEY_RT);
			}

			while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n') {
80100a39:	eb 19                	jmp    80100a54 <consoleintr+0x280>
				input.e--;
80100a3b:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100a40:	83 e8 01             	sub    $0x1,%eax
80100a43:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
				consputc(BACKSPACE);
80100a48:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100a4f:	e8 23 fd ff ff       	call   80100777 <consputc>
		case KEY_UP: // up arrow
			for (i = 0; i < arrows_counter ; i++) {	// fixing POS with RightKey
				consputc(KEY_RT);
			}

			while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n') {
80100a54:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
80100a5a:	a1 18 fe 10 80       	mov    0x8010fe18,%eax
80100a5f:	39 c2                	cmp    %eax,%edx
80100a61:	74 16                	je     80100a79 <consoleintr+0x2a5>
80100a63:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100a68:	83 e8 01             	sub    $0x1,%eax
80100a6b:	83 e0 7f             	and    $0x7f,%eax
80100a6e:	0f b6 80 94 fd 10 80 	movzbl -0x7fef026c(%eax),%eax
80100a75:	3c 0a                	cmp    $0xa,%al
80100a77:	75 c2                	jne    80100a3b <consoleintr+0x267>
				input.e--;
				consputc(BACKSPACE);
			}

			if (history.iter-1 == -1)
80100a79:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100a7e:	85 c0                	test   %eax,%eax
80100a80:	75 0f                	jne    80100a91 <consoleintr+0x2bd>
				history.iter = history.num_of_curr_entries-1;
80100a82:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100a87:	83 e8 01             	sub    $0x1,%eax
80100a8a:	a3 a8 c5 10 80       	mov    %eax,0x8010c5a8
80100a8f:	eb 0d                	jmp    80100a9e <consoleintr+0x2ca>
			else
				history.iter--;
80100a91:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100a96:	83 e8 01             	sub    $0x1,%eax
80100a99:	a3 a8 c5 10 80       	mov    %eax,0x8010c5a8

			for (i = 0; i < strlen(history.commands[history.iter]); i++) {
80100a9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100aa5:	eb 4f                	jmp    80100af6 <consoleintr+0x322>
			  input.buf[input.e] = history.commands[history.iter][i];
80100aa7:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100aac:	8b 15 a8 c5 10 80    	mov    0x8010c5a8,%edx
80100ab2:	c1 e2 07             	shl    $0x7,%edx
80100ab5:	03 55 f4             	add    -0xc(%ebp),%edx
80100ab8:	81 c2 30 c6 10 80    	add    $0x8010c630,%edx
80100abe:	0f b6 12             	movzbl (%edx),%edx
80100ac1:	88 90 94 fd 10 80    	mov    %dl,-0x7fef026c(%eax)
			  consputc(history.commands[history.iter][i]);
80100ac7:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100acc:	c1 e0 07             	shl    $0x7,%eax
80100acf:	03 45 f4             	add    -0xc(%ebp),%eax
80100ad2:	05 30 c6 10 80       	add    $0x8010c630,%eax
80100ad7:	0f b6 00             	movzbl (%eax),%eax
80100ada:	0f be c0             	movsbl %al,%eax
80100add:	89 04 24             	mov    %eax,(%esp)
80100ae0:	e8 92 fc ff ff       	call   80100777 <consputc>
			  input.e++;
80100ae5:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100aea:	83 c0 01             	add    $0x1,%eax
80100aed:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
			if (history.iter-1 == -1)
				history.iter = history.num_of_curr_entries-1;
			else
				history.iter--;

			for (i = 0; i < strlen(history.commands[history.iter]); i++) {
80100af2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100af6:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100afb:	c1 e0 07             	shl    $0x7,%eax
80100afe:	05 30 c6 10 80       	add    $0x8010c630,%eax
80100b03:	89 04 24             	mov    %eax,(%esp)
80100b06:	e8 6d 4f 00 00       	call   80105a78 <strlen>
80100b0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100b0e:	7f 97                	jg     80100aa7 <consoleintr+0x2d3>
			  input.buf[input.e] = history.commands[history.iter][i];
			  consputc(history.commands[history.iter][i]);
			  input.e++;
			}

			arrows_counter = 0; // reset arrows counter because its a new line
80100b10:	c7 05 78 d0 10 80 00 	movl   $0x0,0x8010d078
80100b17:	00 00 00 
			input.buf[input.e] = '\0';
80100b1a:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100b1f:	c6 80 94 fd 10 80 00 	movb   $0x0,-0x7fef026c(%eax)
			break;
80100b26:	e9 dd 02 00 00       	jmp    80100e08 <consoleintr+0x634>

		case KEY_DN: // down arrow
			for (i=0 ; i < arrows_counter ; i++) {	// fixing POS with RightKey
80100b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b32:	eb 10                	jmp    80100b44 <consoleintr+0x370>
				consputc(KEY_RT);
80100b34:	c7 04 24 e5 00 00 00 	movl   $0xe5,(%esp)
80100b3b:	e8 37 fc ff ff       	call   80100777 <consputc>
			arrows_counter = 0; // reset arrows counter because its a new line
			input.buf[input.e] = '\0';
			break;

		case KEY_DN: // down arrow
			for (i=0 ; i < arrows_counter ; i++) {	// fixing POS with RightKey
80100b40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b47:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100b4c:	39 c2                	cmp    %eax,%edx
80100b4e:	72 e4                	jb     80100b34 <consoleintr+0x360>
				consputc(KEY_RT);
			}
			while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n') {
80100b50:	eb 19                	jmp    80100b6b <consoleintr+0x397>
				input.e--;
80100b52:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100b57:	83 e8 01             	sub    $0x1,%eax
80100b5a:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
				consputc(BACKSPACE);
80100b5f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100b66:	e8 0c fc ff ff       	call   80100777 <consputc>

		case KEY_DN: // down arrow
			for (i=0 ; i < arrows_counter ; i++) {	// fixing POS with RightKey
				consputc(KEY_RT);
			}
			while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n') {
80100b6b:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
80100b71:	a1 18 fe 10 80       	mov    0x8010fe18,%eax
80100b76:	39 c2                	cmp    %eax,%edx
80100b78:	74 16                	je     80100b90 <consoleintr+0x3bc>
80100b7a:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100b7f:	83 e8 01             	sub    $0x1,%eax
80100b82:	83 e0 7f             	and    $0x7f,%eax
80100b85:	0f b6 80 94 fd 10 80 	movzbl -0x7fef026c(%eax),%eax
80100b8c:	3c 0a                	cmp    $0xa,%al
80100b8e:	75 c2                	jne    80100b52 <consoleintr+0x37e>
				input.e--;
				consputc(BACKSPACE);
			}

			if (history.iter+1 == history.num_of_curr_entries)
80100b90:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100b95:	8d 50 01             	lea    0x1(%eax),%edx
80100b98:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100b9d:	39 c2                	cmp    %eax,%edx
80100b9f:	75 0c                	jne    80100bad <consoleintr+0x3d9>
				history.iter = 0;
80100ba1:	c7 05 a8 c5 10 80 00 	movl   $0x0,0x8010c5a8
80100ba8:	00 00 00 
80100bab:	eb 0d                	jmp    80100bba <consoleintr+0x3e6>
			else
				history.iter++;
80100bad:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100bb2:	83 c0 01             	add    $0x1,%eax
80100bb5:	a3 a8 c5 10 80       	mov    %eax,0x8010c5a8

			for(i=0; i < strlen(history.commands[history.iter]); i++) {
80100bba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100bc1:	eb 4f                	jmp    80100c12 <consoleintr+0x43e>
			  input.buf[input.e] = history.commands[history.iter][i];
80100bc3:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100bc8:	8b 15 a8 c5 10 80    	mov    0x8010c5a8,%edx
80100bce:	c1 e2 07             	shl    $0x7,%edx
80100bd1:	03 55 f4             	add    -0xc(%ebp),%edx
80100bd4:	81 c2 30 c6 10 80    	add    $0x8010c630,%edx
80100bda:	0f b6 12             	movzbl (%edx),%edx
80100bdd:	88 90 94 fd 10 80    	mov    %dl,-0x7fef026c(%eax)
			  consputc(history.commands[history.iter][i]);
80100be3:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100be8:	c1 e0 07             	shl    $0x7,%eax
80100beb:	03 45 f4             	add    -0xc(%ebp),%eax
80100bee:	05 30 c6 10 80       	add    $0x8010c630,%eax
80100bf3:	0f b6 00             	movzbl (%eax),%eax
80100bf6:	0f be c0             	movsbl %al,%eax
80100bf9:	89 04 24             	mov    %eax,(%esp)
80100bfc:	e8 76 fb ff ff       	call   80100777 <consputc>
			  input.e++;
80100c01:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100c06:	83 c0 01             	add    $0x1,%eax
80100c09:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
			if (history.iter+1 == history.num_of_curr_entries)
				history.iter = 0;
			else
				history.iter++;

			for(i=0; i < strlen(history.commands[history.iter]); i++) {
80100c0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100c12:	a1 a8 c5 10 80       	mov    0x8010c5a8,%eax
80100c17:	c1 e0 07             	shl    $0x7,%eax
80100c1a:	05 30 c6 10 80       	add    $0x8010c630,%eax
80100c1f:	89 04 24             	mov    %eax,(%esp)
80100c22:	e8 51 4e 00 00       	call   80105a78 <strlen>
80100c27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100c2a:	7f 97                	jg     80100bc3 <consoleintr+0x3ef>
			  input.buf[input.e] = history.commands[history.iter][i];
			  consputc(history.commands[history.iter][i]);
			  input.e++;
			}

			arrows_counter = 0;
80100c2c:	c7 05 78 d0 10 80 00 	movl   $0x0,0x8010d078
80100c33:	00 00 00 
			input.buf[input.e] = '\0';
80100c36:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100c3b:	c6 80 94 fd 10 80 00 	movb   $0x0,-0x7fef026c(%eax)
			break;
80100c42:	e9 c1 01 00 00       	jmp    80100e08 <consoleintr+0x634>

		default:
		  if(c != 0 && input.e-input.r < INPUT_BUF) {
80100c47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100c4b:	0f 84 b6 01 00 00    	je     80100e07 <consoleintr+0x633>
80100c51:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
80100c57:	a1 14 fe 10 80       	mov    0x8010fe14,%eax
80100c5c:	89 d1                	mov    %edx,%ecx
80100c5e:	29 c1                	sub    %eax,%ecx
80100c60:	89 c8                	mov    %ecx,%eax
80100c62:	83 f8 7f             	cmp    $0x7f,%eax
80100c65:	0f 87 9c 01 00 00    	ja     80100e07 <consoleintr+0x633>
			  if(arrows_counter > 0 && c != '\n' && c != C('D') && input.e != input.r+INPUT_BUF) {
80100c6b:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100c70:	85 c0                	test   %eax,%eax
80100c72:	0f 84 fd 00 00 00    	je     80100d75 <consoleintr+0x5a1>
80100c78:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100c7c:	0f 84 f3 00 00 00    	je     80100d75 <consoleintr+0x5a1>
80100c82:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100c86:	0f 84 e9 00 00 00    	je     80100d75 <consoleintr+0x5a1>
80100c8c:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100c91:	8b 15 14 fe 10 80    	mov    0x8010fe14,%edx
80100c97:	83 ea 80             	sub    $0xffffff80,%edx
80100c9a:	39 d0                	cmp    %edx,%eax
80100c9c:	0f 84 d3 00 00 00    	je     80100d75 <consoleintr+0x5a1>
				  e_pos = input.e;
80100ca2:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100ca7:	89 45 ec             	mov    %eax,-0x14(%ebp)
				  //shift characters left
				  for(i = 0; i < arrows_counter; ++i) {
80100caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100cb1:	eb 2c                	jmp    80100cdf <consoleintr+0x50b>
					input.buf[input.e] = input.buf[input.e-1];
80100cb3:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100cb8:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
80100cbe:	83 ea 01             	sub    $0x1,%edx
80100cc1:	0f b6 92 94 fd 10 80 	movzbl -0x7fef026c(%edx),%edx
80100cc8:	88 90 94 fd 10 80    	mov    %dl,-0x7fef026c(%eax)
					input.e--;
80100cce:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100cd3:	83 e8 01             	sub    $0x1,%eax
80100cd6:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
		default:
		  if(c != 0 && input.e-input.r < INPUT_BUF) {
			  if(arrows_counter > 0 && c != '\n' && c != C('D') && input.e != input.r+INPUT_BUF) {
				  e_pos = input.e;
				  //shift characters left
				  for(i = 0; i < arrows_counter; ++i) {
80100cdb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ce2:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100ce7:	39 c2                	cmp    %eax,%edx
80100ce9:	72 c8                	jb     80100cb3 <consoleintr+0x4df>
					input.buf[input.e] = input.buf[input.e-1];
					input.e--;
				  }
				  input.buf[input.e % INPUT_BUF] = c;
80100ceb:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100cf0:	89 c2                	mov    %eax,%edx
80100cf2:	83 e2 7f             	and    $0x7f,%edx
80100cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cf8:	88 82 94 fd 10 80    	mov    %al,-0x7fef026c(%edx)
				  consputc(c);
80100cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d01:	89 04 24             	mov    %eax,(%esp)
80100d04:	e8 6e fa ff ff       	call   80100777 <consputc>
				  for(i = 0; i < arrows_counter; ++i) {
80100d09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100d10:	eb 24                	jmp    80100d36 <consoleintr+0x562>
					  consputc(input.buf[input.e+i+1]);
80100d12:	8b 15 1c fe 10 80    	mov    0x8010fe1c,%edx
80100d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100d1b:	01 d0                	add    %edx,%eax
80100d1d:	83 c0 01             	add    $0x1,%eax
80100d20:	0f b6 80 94 fd 10 80 	movzbl -0x7fef026c(%eax),%eax
80100d27:	0f be c0             	movsbl %al,%eax
80100d2a:	89 04 24             	mov    %eax,(%esp)
80100d2d:	e8 45 fa ff ff       	call   80100777 <consputc>
					input.buf[input.e] = input.buf[input.e-1];
					input.e--;
				  }
				  input.buf[input.e % INPUT_BUF] = c;
				  consputc(c);
				  for(i = 0; i < arrows_counter; ++i) {
80100d32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100d39:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100d3e:	39 c2                	cmp    %eax,%edx
80100d40:	72 d0                	jb     80100d12 <consoleintr+0x53e>
					  consputc(input.buf[input.e+i+1]);
				  }
				  for(i = 0; i < arrows_counter; ++i) {
80100d42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100d49:	eb 10                	jmp    80100d5b <consoleintr+0x587>
					  cgaputc(KEY_LF);
80100d4b:	c7 04 24 e4 00 00 00 	movl   $0xe4,(%esp)
80100d52:	e8 76 f8 ff ff       	call   801005cd <cgaputc>
				  input.buf[input.e % INPUT_BUF] = c;
				  consputc(c);
				  for(i = 0; i < arrows_counter; ++i) {
					  consputc(input.buf[input.e+i+1]);
				  }
				  for(i = 0; i < arrows_counter; ++i) {
80100d57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100d5e:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100d63:	39 c2                	cmp    %eax,%edx
80100d65:	72 e4                	jb     80100d4b <consoleintr+0x577>
					  cgaputc(KEY_LF);
				  }
				  e_pos++;
80100d67:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
				  input.e = e_pos;
80100d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100d6e:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c
80100d73:	eb 1b                	jmp    80100d90 <consoleintr+0x5bc>
			  } else
				  input.buf[input.e++ % INPUT_BUF] = c;		// "regular" char to buffer
80100d75:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100d7a:	89 c1                	mov    %eax,%ecx
80100d7c:	83 e1 7f             	and    $0x7f,%ecx
80100d7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100d82:	88 91 94 fd 10 80    	mov    %dl,-0x7fef026c(%ecx)
80100d88:	83 c0 01             	add    $0x1,%eax
80100d8b:	a3 1c fe 10 80       	mov    %eax,0x8010fe1c

			  if (arrows_counter == 0 && c != '\n' && c != C('D'))
80100d90:	a1 78 d0 10 80       	mov    0x8010d078,%eax
80100d95:	85 c0                	test   %eax,%eax
80100d97:	75 17                	jne    80100db0 <consoleintr+0x5dc>
80100d99:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100d9d:	74 11                	je     80100db0 <consoleintr+0x5dc>
80100d9f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100da3:	74 0b                	je     80100db0 <consoleintr+0x5dc>
				  consputc(c);								// "regular" char to console
80100da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100da8:	89 04 24             	mov    %eax,(%esp)
80100dab:	e8 c7 f9 ff ff       	call   80100777 <consputc>

			  if (c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF) {
80100db0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100db4:	74 18                	je     80100dce <consoleintr+0x5fa>
80100db6:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100dba:	74 12                	je     80100dce <consoleintr+0x5fa>
80100dbc:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100dc1:	8b 15 14 fe 10 80    	mov    0x8010fe14,%edx
80100dc7:	83 ea 80             	sub    $0xffffff80,%edx
80100dca:	39 d0                	cmp    %edx,%eax
80100dcc:	75 39                	jne    80100e07 <consoleintr+0x633>
				  input.w = input.e;
80100dce:	a1 1c fe 10 80       	mov    0x8010fe1c,%eax
80100dd3:	a3 18 fe 10 80       	mov    %eax,0x8010fe18
				  arrows_counter = 0;
80100dd8:	c7 05 78 d0 10 80 00 	movl   $0x0,0x8010d078
80100ddf:	00 00 00 
				  wakeup(&input.r);
80100de2:	c7 04 24 14 fe 10 80 	movl   $0x8010fe14,(%esp)
80100de9:	e8 b3 45 00 00       	call   801053a1 <wakeup>
				  consputc(c);
80100dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100df1:	89 04 24             	mov    %eax,(%esp)
80100df4:	e8 7e f9 ff ff       	call   80100777 <consputc>
			  }
		  }
      break;
80100df9:	eb 0c                	jmp    80100e07 <consoleintr+0x633>
		case C('U'):  // Kill line.
		  while(input.e != input.w && input.buf[(input.e-1) % INPUT_BUF] != '\n'){
			input.e--;
			consputc(BACKSPACE);
		  }
		  break;
80100dfb:	90                   	nop
80100dfc:	eb 0a                	jmp    80100e08 <consoleintr+0x634>
			for(i = 0; i < arrows_counter+1; i++)
				consputc(input.buf[input.e - arrows_counter +i ]);
			for(i = 0; i < arrows_counter+1; i++)
				consputc(KEY_LF);
		  }
		  break;
80100dfe:	90                   	nop
80100dff:	eb 07                	jmp    80100e08 <consoleintr+0x634>
		case KEY_LF:
		  if(arrows_counter < input.e - input.r) {
			  arrows_counter++;
			  consputc(c);
		  }
		  break;
80100e01:	90                   	nop
80100e02:	eb 04                	jmp    80100e08 <consoleintr+0x634>
		case KEY_RT:
			if(arrows_counter > 0) {
				arrows_counter--;
				consputc(c);
			}
			break;
80100e04:	90                   	nop
80100e05:	eb 01                	jmp    80100e08 <consoleintr+0x634>
				  arrows_counter = 0;
				  wakeup(&input.r);
				  consputc(c);
			  }
		  }
      break;
80100e07:	90                   	nop

void consoleintr(int (*getc)(void)) {
  int c,i;
  uint e_pos;
  acquire(&input.lock);
  while((c = getc()) >= 0){
80100e08:	8b 45 08             	mov    0x8(%ebp),%eax
80100e0b:	ff d0                	call   *%eax
80100e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100e14:	0f 89 d1 f9 ff ff    	jns    801007eb <consoleintr+0x17>
			  }
		  }
      break;
    } // end of switch
  } // end of while
  release(&input.lock);
80100e1a:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80100e21:	e8 e7 47 00 00       	call   8010560d <release>
}
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    

80100e28 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100e28:	55                   	push   %ebp
80100e29:	89 e5                	mov    %esp,%ebp
80100e2b:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c,i;

  iunlock(ip);
80100e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80100e31:	89 04 24             	mov    %eax,(%esp)
80100e34:	e8 cd 12 00 00       	call   80102106 <iunlock>
  target = n;
80100e39:	8b 45 10             	mov    0x10(%ebp),%eax
80100e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  acquire(&input.lock);
80100e3f:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80100e46:	e8 60 47 00 00       	call   801055ab <acquire>
  while(n > 0){
80100e4b:	e9 95 01 00 00       	jmp    80100fe5 <consoleread+0x1bd>
	  while(input.r == input.w){
		  if(proc->killed){
80100e50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e56:	8b 40 24             	mov    0x24(%eax),%eax
80100e59:	85 c0                	test   %eax,%eax
80100e5b:	74 21                	je     80100e7e <consoleread+0x56>
			release(&input.lock);
80100e5d:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80100e64:	e8 a4 47 00 00       	call   8010560d <release>
			ilock(ip);
80100e69:	8b 45 08             	mov    0x8(%ebp),%eax
80100e6c:	89 04 24             	mov    %eax,(%esp)
80100e6f:	e8 44 11 00 00       	call   80101fb8 <ilock>
			return -1;
80100e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e79:	e9 97 01 00 00       	jmp    80101015 <consoleread+0x1ed>
		  }
		  sleep(&input.r, &input.lock);
80100e7e:	c7 44 24 04 60 fd 10 	movl   $0x8010fd60,0x4(%esp)
80100e85:	80 
80100e86:	c7 04 24 14 fe 10 80 	movl   $0x8010fe14,(%esp)
80100e8d:	e8 a1 43 00 00       	call   80105233 <sleep>
80100e92:	eb 01                	jmp    80100e95 <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
	  while(input.r == input.w){
80100e94:	90                   	nop
80100e95:	8b 15 14 fe 10 80    	mov    0x8010fe14,%edx
80100e9b:	a1 18 fe 10 80       	mov    0x8010fe18,%eax
80100ea0:	39 c2                	cmp    %eax,%edx
80100ea2:	74 ac                	je     80100e50 <consoleread+0x28>
			ilock(ip);
			return -1;
		  }
		  sleep(&input.r, &input.lock);
	  }
	  c = input.buf[input.r++ % INPUT_BUF];
80100ea4:	a1 14 fe 10 80       	mov    0x8010fe14,%eax
80100ea9:	89 c2                	mov    %eax,%edx
80100eab:	83 e2 7f             	and    $0x7f,%edx
80100eae:	0f b6 92 94 fd 10 80 	movzbl -0x7fef026c(%edx),%edx
80100eb5:	0f be d2             	movsbl %dl,%edx
80100eb8:	89 55 ec             	mov    %edx,-0x14(%ebp)
80100ebb:	83 c0 01             	add    $0x1,%eax
80100ebe:	a3 14 fe 10 80       	mov    %eax,0x8010fe14
	  if(c == C('D')){  // EOF
80100ec3:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
80100ec7:	75 1e                	jne    80100ee7 <consoleread+0xbf>
		  if(n < target){
80100ec9:	8b 45 10             	mov    0x10(%ebp),%eax
80100ecc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80100ecf:	0f 83 1c 01 00 00    	jae    80100ff1 <consoleread+0x1c9>
			  // Save ^D for next time, to make sure
			  // caller gets a 0-byte result.
			  input.r--;
80100ed5:	a1 14 fe 10 80       	mov    0x8010fe14,%eax
80100eda:	83 e8 01             	sub    $0x1,%eax
80100edd:	a3 14 fe 10 80       	mov    %eax,0x8010fe14
		  }
		  break;
80100ee2:	e9 0a 01 00 00       	jmp    80100ff1 <consoleread+0x1c9>
	  }
	  history.buf[history.c_buf++] = c;
80100ee7:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
80100eec:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100eef:	88 90 b0 c5 10 80    	mov    %dl,-0x7fef3a50(%eax)
80100ef5:	83 c0 01             	add    $0x1,%eax
80100ef8:	a3 ac c5 10 80       	mov    %eax,0x8010c5ac
	  *dst++ = c;
80100efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100f00:	89 c2                	mov    %eax,%edx
80100f02:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f05:	88 10                	mov    %dl,(%eax)
80100f07:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	  n--;
80100f0b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
	  if(c == '\n') {
80100f0f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
80100f13:	0f 85 cc 00 00 00    	jne    80100fe5 <consoleread+0x1bd>
		  if (1 != history.c_buf) {
80100f19:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
80100f1e:	83 f8 01             	cmp    $0x1,%eax
80100f21:	0f 84 ab 00 00 00    	je     80100fd2 <consoleread+0x1aa>
			  // save history_buf in history_commands
			  for(i = 0; i < history.c_buf-1; i++)
80100f27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100f2e:	eb 23                	jmp    80100f53 <consoleread+0x12b>
				  history.commands[history.entry_point][i] = history.buf[i];
80100f30:	8b 15 a0 c5 10 80    	mov    0x8010c5a0,%edx
80100f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f39:	05 b0 c5 10 80       	add    $0x8010c5b0,%eax
80100f3e:	0f b6 00             	movzbl (%eax),%eax
80100f41:	c1 e2 07             	shl    $0x7,%edx
80100f44:	03 55 f4             	add    -0xc(%ebp),%edx
80100f47:	81 c2 30 c6 10 80    	add    $0x8010c630,%edx
80100f4d:	88 02                	mov    %al,(%edx)
	  *dst++ = c;
	  n--;
	  if(c == '\n') {
		  if (1 != history.c_buf) {
			  // save history_buf in history_commands
			  for(i = 0; i < history.c_buf-1; i++)
80100f4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f53:	a1 ac c5 10 80       	mov    0x8010c5ac,%eax
80100f58:	83 e8 01             	sub    $0x1,%eax
80100f5b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100f5e:	7f d0                	jg     80100f30 <consoleread+0x108>
				  history.commands[history.entry_point][i] = history.buf[i];

			  history.commands[history.entry_point][i] = '\0';
80100f60:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100f65:	c1 e0 07             	shl    $0x7,%eax
80100f68:	03 45 f4             	add    -0xc(%ebp),%eax
80100f6b:	05 30 c6 10 80       	add    $0x8010c630,%eax
80100f70:	c6 00 00             	movb   $0x0,(%eax)
			  history.entry_point++;
80100f73:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100f78:	83 c0 01             	add    $0x1,%eax
80100f7b:	a3 a0 c5 10 80       	mov    %eax,0x8010c5a0
			  history.entry_point %= MAX_HISTORY_LENGTH;  // FIFO 18 19 0 1 2..
80100f80:	8b 0d a0 c5 10 80    	mov    0x8010c5a0,%ecx
80100f86:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100f8b:	89 c8                	mov    %ecx,%eax
80100f8d:	f7 ea                	imul   %edx
80100f8f:	c1 fa 03             	sar    $0x3,%edx
80100f92:	89 c8                	mov    %ecx,%eax
80100f94:	c1 f8 1f             	sar    $0x1f,%eax
80100f97:	29 c2                	sub    %eax,%edx
80100f99:	89 d0                	mov    %edx,%eax
80100f9b:	c1 e0 02             	shl    $0x2,%eax
80100f9e:	01 d0                	add    %edx,%eax
80100fa0:	c1 e0 02             	shl    $0x2,%eax
80100fa3:	89 ca                	mov    %ecx,%edx
80100fa5:	29 c2                	sub    %eax,%edx
80100fa7:	89 15 a0 c5 10 80    	mov    %edx,0x8010c5a0
			  history.iter = history.entry_point;
80100fad:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100fb2:	a3 a8 c5 10 80       	mov    %eax,0x8010c5a8

			  // updates number of current entries (when maxed out - will not change)
			  history.num_of_curr_entries = (history.num_of_curr_entries < MAX_HISTORY_LENGTH-1) ? history.entry_point : MAX_HISTORY_LENGTH;
80100fb7:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
80100fbc:	83 f8 12             	cmp    $0x12,%eax
80100fbf:	7f 07                	jg     80100fc8 <consoleread+0x1a0>
80100fc1:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100fc6:	eb 05                	jmp    80100fcd <consoleread+0x1a5>
80100fc8:	b8 14 00 00 00       	mov    $0x14,%eax
80100fcd:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4
		  }
		  history.c_buf = 0;
80100fd2:	c7 05 ac c5 10 80 00 	movl   $0x0,0x8010c5ac
80100fd9:	00 00 00 
		  history.buf[0] = '\0';
80100fdc:	c6 05 b0 c5 10 80 00 	movb   $0x0,0x8010c5b0
		  break;
80100fe3:	eb 0d                	jmp    80100ff2 <consoleread+0x1ca>
  int c,i;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100fe5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100fe9:	0f 8f a5 fe ff ff    	jg     80100e94 <consoleread+0x6c>
80100fef:	eb 01                	jmp    80100ff2 <consoleread+0x1ca>
		  if(n < target){
			  // Save ^D for next time, to make sure
			  // caller gets a 0-byte result.
			  input.r--;
		  }
		  break;
80100ff1:	90                   	nop
		  history.c_buf = 0;
		  history.buf[0] = '\0';
		  break;
	  }
  }
  release(&input.lock);
80100ff2:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
80100ff9:	e8 0f 46 00 00       	call   8010560d <release>
  ilock(ip);
80100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80101001:	89 04 24             	mov    %eax,(%esp)
80101004:	e8 af 0f 00 00       	call   80101fb8 <ilock>

  return target - n;
80101009:	8b 45 10             	mov    0x10(%ebp),%eax
8010100c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010100f:	89 d1                	mov    %edx,%ecx
80101011:	29 c1                	sub    %eax,%ecx
80101013:	89 c8                	mov    %ecx,%eax
}
80101015:	c9                   	leave  
80101016:	c3                   	ret    

80101017 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80101017:	55                   	push   %ebp
80101018:	89 e5                	mov    %esp,%ebp
8010101a:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
8010101d:	8b 45 08             	mov    0x8(%ebp),%eax
80101020:	89 04 24             	mov    %eax,(%esp)
80101023:	e8 de 10 00 00       	call   80102106 <iunlock>
  acquire(&cons.lock);
80101028:	c7 04 24 40 d0 10 80 	movl   $0x8010d040,(%esp)
8010102f:	e8 77 45 00 00       	call   801055ab <acquire>
  for(i = 0; i < n; i++)
80101034:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010103b:	eb 1d                	jmp    8010105a <consolewrite+0x43>
    consputc(buf[i] & 0xff);
8010103d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101040:	03 45 0c             	add    0xc(%ebp),%eax
80101043:	0f b6 00             	movzbl (%eax),%eax
80101046:	0f be c0             	movsbl %al,%eax
80101049:	25 ff 00 00 00       	and    $0xff,%eax
8010104e:	89 04 24             	mov    %eax,(%esp)
80101051:	e8 21 f7 ff ff       	call   80100777 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80101056:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010105d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101060:	7c db                	jl     8010103d <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80101062:	c7 04 24 40 d0 10 80 	movl   $0x8010d040,(%esp)
80101069:	e8 9f 45 00 00       	call   8010560d <release>
  ilock(ip);
8010106e:	8b 45 08             	mov    0x8(%ebp),%eax
80101071:	89 04 24             	mov    %eax,(%esp)
80101074:	e8 3f 0f 00 00       	call   80101fb8 <ilock>

  return n;
80101079:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010107c:	c9                   	leave  
8010107d:	c3                   	ret    

8010107e <consoleinit>:

void
consoleinit(void)
{
8010107e:	55                   	push   %ebp
8010107f:	89 e5                	mov    %esp,%ebp
80101081:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80101084:	c7 44 24 04 7f 8d 10 	movl   $0x80108d7f,0x4(%esp)
8010108b:	80 
8010108c:	c7 04 24 40 d0 10 80 	movl   $0x8010d040,(%esp)
80101093:	e8 f2 44 00 00       	call   8010558a <initlock>
  initlock(&input.lock, "input");
80101098:	c7 44 24 04 87 8d 10 	movl   $0x80108d87,0x4(%esp)
8010109f:	80 
801010a0:	c7 04 24 60 fd 10 80 	movl   $0x8010fd60,(%esp)
801010a7:	e8 de 44 00 00       	call   8010558a <initlock>

  devsw[CONSOLE].write = consolewrite;
801010ac:	c7 05 cc 07 11 80 17 	movl   $0x80101017,0x801107cc
801010b3:	10 10 80 
  devsw[CONSOLE].read = consoleread;
801010b6:	c7 05 c8 07 11 80 28 	movl   $0x80100e28,0x801107c8
801010bd:	0e 10 80 
  cons.locking = 1;
801010c0:	c7 05 74 d0 10 80 01 	movl   $0x1,0x8010d074
801010c7:	00 00 00 

  picenable(IRQ_KBD);
801010ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801010d1:	e8 3b 31 00 00       	call   80104211 <picenable>
  ioapicenable(IRQ_KBD, 0);
801010d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801010dd:	00 
801010de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801010e5:	e8 dc 1f 00 00       	call   801030c6 <ioapicenable>
}
801010ea:	c9                   	leave  
801010eb:	c3                   	ret    

801010ec <exec>:
//static struct PATH* ev_path;


int
exec(char *path, char **argv)
{
801010ec:	55                   	push   %ebp
801010ed:	89 e5                	mov    %esp,%ebp
801010ef:	81 ec b8 01 00 00    	sub    $0x1b8,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  stop = 0;
801010f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
/*  if (first_visit == 1) {
	  ev_path->path_counter = 0 ;
	  first_visit = 0 ;
  }*/
  if((ip = namei(path)) == 0) {
801010fc:	8b 45 08             	mov    0x8(%ebp),%eax
801010ff:	89 04 24             	mov    %eax,(%esp)
80101102:	e8 53 1a 00 00       	call   80102b5a <namei>
80101107:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010110a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010110e:	0f 85 9e 00 00 00    	jne    801011b2 <exec+0xc6>
	  // assignment 1 - 1.1 - search in PATH if didn't found in working dir
	  for (i = 0 ; i < path_counter && !stop ; ++i) {
80101114:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010111b:	eb 71                	jmp    8010118e <exec+0xa2>
	  	strcpy(full_path_cmd, search_paths[i]);
8010111d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101120:	89 d0                	mov    %edx,%eax
80101122:	c1 e0 07             	shl    $0x7,%eax
80101125:	01 d0                	add    %edx,%eax
80101127:	05 a0 d0 10 80       	add    $0x8010d0a0,%eax
8010112c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101130:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
80101136:	89 04 24             	mov    %eax,(%esp)
80101139:	e8 50 04 00 00       	call   8010158e <strcpy>
	  	strcpy(full_path_cmd+strlen(search_paths[i]), path);
8010113e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101141:	89 d0                	mov    %edx,%eax
80101143:	c1 e0 07             	shl    $0x7,%eax
80101146:	01 d0                	add    %edx,%eax
80101148:	05 a0 d0 10 80       	add    $0x8010d0a0,%eax
8010114d:	89 04 24             	mov    %eax,(%esp)
80101150:	e8 23 49 00 00       	call   80105a78 <strlen>
80101155:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
8010115b:	01 c2                	add    %eax,%edx
8010115d:	8b 45 08             	mov    0x8(%ebp),%eax
80101160:	89 44 24 04          	mov    %eax,0x4(%esp)
80101164:	89 14 24             	mov    %edx,(%esp)
80101167:	e8 22 04 00 00       	call   8010158e <strcpy>
	  	if((ip = namei(full_path_cmd)) != 0) {
8010116c:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
80101172:	89 04 24             	mov    %eax,(%esp)
80101175:	e8 e0 19 00 00       	call   80102b5a <namei>
8010117a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010117d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101181:	74 07                	je     8010118a <exec+0x9e>
	  		stop = 1;
80101183:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	  ev_path->path_counter = 0 ;
	  first_visit = 0 ;
  }*/
  if((ip = namei(path)) == 0) {
	  // assignment 1 - 1.1 - search in PATH if didn't found in working dir
	  for (i = 0 ; i < path_counter && !stop ; ++i) {
8010118a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010118e:	a1 80 d0 10 80       	mov    0x8010d080,%eax
80101193:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80101196:	7d 0a                	jge    801011a2 <exec+0xb6>
80101198:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010119c:	0f 84 7b ff ff ff    	je     8010111d <exec+0x31>
	  	strcpy(full_path_cmd+strlen(search_paths[i]), path);
	  	if((ip = namei(full_path_cmd)) != 0) {
	  		stop = 1;
	  	}
	  }
	  if (!stop)
801011a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801011a6:	75 0a                	jne    801011b2 <exec+0xc6>
		  return -1;
801011a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ad:	e9 da 03 00 00       	jmp    8010158c <exec+0x4a0>
  }


  ilock(ip);
801011b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801011b5:	89 04 24             	mov    %eax,(%esp)
801011b8:	e8 fb 0d 00 00       	call   80101fb8 <ilock>
  pgdir = 0;
801011bd:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
801011c4:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801011cb:	00 
801011cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801011d3:	00 
801011d4:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
801011da:	89 44 24 04          	mov    %eax,0x4(%esp)
801011de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801011e1:	89 04 24             	mov    %eax,(%esp)
801011e4:	e8 c5 12 00 00       	call   801024ae <readi>
801011e9:	83 f8 33             	cmp    $0x33,%eax
801011ec:	0f 86 54 03 00 00    	jbe    80101546 <exec+0x45a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801011f2:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
801011f8:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
801011fd:	0f 85 46 03 00 00    	jne    80101549 <exec+0x45d>
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
80101203:	c7 04 24 4f 32 10 80 	movl   $0x8010324f,(%esp)
8010120a:	e8 ce 72 00 00       	call   801084dd <setupkvm>
8010120f:	89 45 d0             	mov    %eax,-0x30(%ebp)
80101212:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80101216:	0f 84 30 03 00 00    	je     8010154c <exec+0x460>
    goto bad;

  // Load program into memory.
  sz = 0;
8010121c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101223:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010122a:	8b 85 a4 fe ff ff    	mov    -0x15c(%ebp),%eax
80101230:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101233:	e9 c5 00 00 00       	jmp    801012fd <exec+0x211>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101238:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010123b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80101242:	00 
80101243:	89 44 24 08          	mov    %eax,0x8(%esp)
80101247:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
8010124d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101251:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101254:	89 04 24             	mov    %eax,(%esp)
80101257:	e8 52 12 00 00       	call   801024ae <readi>
8010125c:	83 f8 20             	cmp    $0x20,%eax
8010125f:	0f 85 ea 02 00 00    	jne    8010154f <exec+0x463>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101265:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
8010126b:	83 f8 01             	cmp    $0x1,%eax
8010126e:	75 7f                	jne    801012ef <exec+0x203>
      continue;
    if(ph.memsz < ph.filesz)
80101270:	8b 95 7c fe ff ff    	mov    -0x184(%ebp),%edx
80101276:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
8010127c:	39 c2                	cmp    %eax,%edx
8010127e:	0f 82 ce 02 00 00    	jb     80101552 <exec+0x466>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101284:	8b 95 70 fe ff ff    	mov    -0x190(%ebp),%edx
8010128a:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
80101290:	01 d0                	add    %edx,%eax
80101292:	89 44 24 08          	mov    %eax,0x8(%esp)
80101296:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010129d:	8b 45 d0             	mov    -0x30(%ebp),%eax
801012a0:	89 04 24             	mov    %eax,(%esp)
801012a3:	e8 07 76 00 00       	call   801088af <allocuvm>
801012a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801012ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801012af:	0f 84 a0 02 00 00    	je     80101555 <exec+0x469>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801012b5:	8b 8d 78 fe ff ff    	mov    -0x188(%ebp),%ecx
801012bb:	8b 95 6c fe ff ff    	mov    -0x194(%ebp),%edx
801012c1:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
801012c7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801012cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
801012cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801012d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801012d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801012da:	8b 45 d0             	mov    -0x30(%ebp),%eax
801012dd:	89 04 24             	mov    %eax,(%esp)
801012e0:	e8 db 74 00 00       	call   801087c0 <loaduvm>
801012e5:	85 c0                	test   %eax,%eax
801012e7:	0f 88 6b 02 00 00    	js     80101558 <exec+0x46c>
801012ed:	eb 01                	jmp    801012f0 <exec+0x204>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
801012ef:	90                   	nop
  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012f0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801012f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f7:	83 c0 20             	add    $0x20,%eax
801012fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012fd:	0f b7 85 b4 fe ff ff 	movzwl -0x14c(%ebp),%eax
80101304:	0f b7 c0             	movzwl %ax,%eax
80101307:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010130a:	0f 8f 28 ff ff ff    	jg     80101238 <exec+0x14c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80101310:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101313:	89 04 24             	mov    %eax,(%esp)
80101316:	e8 21 0f 00 00       	call   8010223c <iunlockput>
  ip = 0;
8010131b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80101322:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101325:	05 ff 0f 00 00       	add    $0xfff,%eax
8010132a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010132f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101332:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101335:	05 00 20 00 00       	add    $0x2000,%eax
8010133a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010133e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101341:	89 44 24 04          	mov    %eax,0x4(%esp)
80101345:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101348:	89 04 24             	mov    %eax,(%esp)
8010134b:	e8 5f 75 00 00       	call   801088af <allocuvm>
80101350:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101353:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101357:	0f 84 fe 01 00 00    	je     8010155b <exec+0x46f>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010135d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101360:	2d 00 20 00 00       	sub    $0x2000,%eax
80101365:	89 44 24 04          	mov    %eax,0x4(%esp)
80101369:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010136c:	89 04 24             	mov    %eax,(%esp)
8010136f:	e8 5f 77 00 00       	call   80108ad3 <clearpteu>
  sp = sz;
80101374:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101377:	89 45 d8             	mov    %eax,-0x28(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010137a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80101381:	e9 81 00 00 00       	jmp    80101407 <exec+0x31b>
    if(argc >= MAXARG)
80101386:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
8010138a:	0f 87 ce 01 00 00    	ja     8010155e <exec+0x472>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101390:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101393:	c1 e0 02             	shl    $0x2,%eax
80101396:	03 45 0c             	add    0xc(%ebp),%eax
80101399:	8b 00                	mov    (%eax),%eax
8010139b:	89 04 24             	mov    %eax,(%esp)
8010139e:	e8 d5 46 00 00       	call   80105a78 <strlen>
801013a3:	f7 d0                	not    %eax
801013a5:	03 45 d8             	add    -0x28(%ebp),%eax
801013a8:	83 e0 fc             	and    $0xfffffffc,%eax
801013ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801013ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013b1:	c1 e0 02             	shl    $0x2,%eax
801013b4:	03 45 0c             	add    0xc(%ebp),%eax
801013b7:	8b 00                	mov    (%eax),%eax
801013b9:	89 04 24             	mov    %eax,(%esp)
801013bc:	e8 b7 46 00 00       	call   80105a78 <strlen>
801013c1:	83 c0 01             	add    $0x1,%eax
801013c4:	89 c2                	mov    %eax,%edx
801013c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013c9:	c1 e0 02             	shl    $0x2,%eax
801013cc:	03 45 0c             	add    0xc(%ebp),%eax
801013cf:	8b 00                	mov    (%eax),%eax
801013d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
801013d5:	89 44 24 08          	mov    %eax,0x8(%esp)
801013d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801013dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
801013e3:	89 04 24             	mov    %eax,(%esp)
801013e6:	e8 9c 78 00 00       	call   80108c87 <copyout>
801013eb:	85 c0                	test   %eax,%eax
801013ed:	0f 88 6e 01 00 00    	js     80101561 <exec+0x475>
      goto bad;
    ustack[3+argc] = sp;
801013f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013f6:	8d 50 03             	lea    0x3(%eax),%edx
801013f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801013fc:	89 84 95 bc fe ff ff 	mov    %eax,-0x144(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101403:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80101407:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010140a:	c1 e0 02             	shl    $0x2,%eax
8010140d:	03 45 0c             	add    0xc(%ebp),%eax
80101410:	8b 00                	mov    (%eax),%eax
80101412:	85 c0                	test   %eax,%eax
80101414:	0f 85 6c ff ff ff    	jne    80101386 <exec+0x29a>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
8010141a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010141d:	83 c0 03             	add    $0x3,%eax
80101420:	c7 84 85 bc fe ff ff 	movl   $0x0,-0x144(%ebp,%eax,4)
80101427:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
8010142b:	c7 85 bc fe ff ff ff 	movl   $0xffffffff,-0x144(%ebp)
80101432:	ff ff ff 
  ustack[1] = argc;
80101435:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101438:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010143e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101441:	83 c0 01             	add    $0x1,%eax
80101444:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010144b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010144e:	29 d0                	sub    %edx,%eax
80101450:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)

  sp -= (3+argc+1) * 4;
80101456:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101459:	83 c0 04             	add    $0x4,%eax
8010145c:	c1 e0 02             	shl    $0x2,%eax
8010145f:	29 45 d8             	sub    %eax,-0x28(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101462:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101465:	83 c0 04             	add    $0x4,%eax
80101468:	c1 e0 02             	shl    $0x2,%eax
8010146b:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010146f:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
80101475:	89 44 24 08          	mov    %eax,0x8(%esp)
80101479:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010147c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101480:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101483:	89 04 24             	mov    %eax,(%esp)
80101486:	e8 fc 77 00 00       	call   80108c87 <copyout>
8010148b:	85 c0                	test   %eax,%eax
8010148d:	0f 88 d1 00 00 00    	js     80101564 <exec+0x478>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101493:	8b 45 08             	mov    0x8(%ebp),%eax
80101496:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101499:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010149c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010149f:	eb 17                	jmp    801014b8 <exec+0x3cc>
    if(*s == '/')
801014a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a4:	0f b6 00             	movzbl (%eax),%eax
801014a7:	3c 2f                	cmp    $0x2f,%al
801014a9:	75 09                	jne    801014b4 <exec+0x3c8>
      last = s+1;
801014ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ae:	83 c0 01             	add    $0x1,%eax
801014b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801014b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014bb:	0f b6 00             	movzbl (%eax),%eax
801014be:	84 c0                	test   %al,%al
801014c0:	75 df                	jne    801014a1 <exec+0x3b5>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
801014c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801014c8:	8d 50 6c             	lea    0x6c(%eax),%edx
801014cb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801014d2:	00 
801014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801014da:	89 14 24             	mov    %edx,(%esp)
801014dd:	e8 48 45 00 00       	call   80105a2a <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
801014e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801014e8:	8b 40 04             	mov    0x4(%eax),%eax
801014eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
801014ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801014f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
801014f7:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
801014fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101500:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101503:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80101505:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010150b:	8b 40 18             	mov    0x18(%eax),%eax
8010150e:	8b 95 a0 fe ff ff    	mov    -0x160(%ebp),%edx
80101514:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80101517:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010151d:	8b 40 18             	mov    0x18(%eax),%eax
80101520:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101523:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80101526:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010152c:	89 04 24             	mov    %eax,(%esp)
8010152f:	e8 9a 70 00 00       	call   801085ce <switchuvm>
  freevm(oldpgdir);
80101534:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101537:	89 04 24             	mov    %eax,(%esp)
8010153a:	e8 06 75 00 00       	call   80108a45 <freevm>
  return 0;
8010153f:	b8 00 00 00 00       	mov    $0x0,%eax
80101544:	eb 46                	jmp    8010158c <exec+0x4a0>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101546:	90                   	nop
80101547:	eb 1c                	jmp    80101565 <exec+0x479>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101549:	90                   	nop
8010154a:	eb 19                	jmp    80101565 <exec+0x479>

  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;
8010154c:	90                   	nop
8010154d:	eb 16                	jmp    80101565 <exec+0x479>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
8010154f:	90                   	nop
80101550:	eb 13                	jmp    80101565 <exec+0x479>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80101552:	90                   	nop
80101553:	eb 10                	jmp    80101565 <exec+0x479>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101555:	90                   	nop
80101556:	eb 0d                	jmp    80101565 <exec+0x479>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101558:	90                   	nop
80101559:	eb 0a                	jmp    80101565 <exec+0x479>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
8010155b:	90                   	nop
8010155c:	eb 07                	jmp    80101565 <exec+0x479>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010155e:	90                   	nop
8010155f:	eb 04                	jmp    80101565 <exec+0x479>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80101561:	90                   	nop
80101562:	eb 01                	jmp    80101565 <exec+0x479>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101564:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101565:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80101569:	74 0b                	je     80101576 <exec+0x48a>
    freevm(pgdir);
8010156b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010156e:	89 04 24             	mov    %eax,(%esp)
80101571:	e8 cf 74 00 00       	call   80108a45 <freevm>
  if(ip)
80101576:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010157a:	74 0b                	je     80101587 <exec+0x49b>
    iunlockput(ip);
8010157c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010157f:	89 04 24             	mov    %eax,(%esp)
80101582:	e8 b5 0c 00 00       	call   8010223c <iunlockput>
  return -1;
80101587:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010158c:	c9                   	leave  
8010158d:	c3                   	ret    

8010158e <strcpy>:

char*
strcpy(char *s, char *t)
{
8010158e:	55                   	push   %ebp
8010158f:	89 e5                	mov    %esp,%ebp
80101591:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80101594:	8b 45 08             	mov    0x8(%ebp),%eax
80101597:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
8010159a:	90                   	nop
8010159b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010159e:	0f b6 10             	movzbl (%eax),%edx
801015a1:	8b 45 08             	mov    0x8(%ebp),%eax
801015a4:	88 10                	mov    %dl,(%eax)
801015a6:	8b 45 08             	mov    0x8(%ebp),%eax
801015a9:	0f b6 00             	movzbl (%eax),%eax
801015ac:	84 c0                	test   %al,%al
801015ae:	0f 95 c0             	setne  %al
801015b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801015b5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801015b9:	84 c0                	test   %al,%al
801015bb:	75 de                	jne    8010159b <strcpy+0xd>
    ;
  return os;
801015bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801015c0:	c9                   	leave  
801015c1:	c3                   	ret    

801015c2 <add_path>:

int add_path(char* path) {
801015c2:	55                   	push   %ebp
801015c3:	89 e5                	mov    %esp,%ebp
801015c5:	83 ec 10             	sub    $0x10,%esp
	int next_char = 0;
801015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	if (path_counter > MAX_PATH_ENTRIES) {
801015cf:	a1 80 d0 10 80       	mov    0x8010d080,%eax
801015d4:	83 f8 0a             	cmp    $0xa,%eax
801015d7:	7e 2e                	jle    80101607 <add_path+0x45>
		return path_counter;
801015d9:	a1 80 d0 10 80       	mov    0x8010d080,%eax
801015de:	eb 6c                	jmp    8010164c <add_path+0x8a>
	}
	while(*path != 0 && *path != '\n' && *path != '\t' && *path != '\r' && *path != ' ') {
		search_paths[path_counter][next_char] = *path;
801015e0:	8b 15 80 d0 10 80    	mov    0x8010d080,%edx
801015e6:	8b 45 08             	mov    0x8(%ebp),%eax
801015e9:	0f b6 08             	movzbl (%eax),%ecx
801015ec:	89 d0                	mov    %edx,%eax
801015ee:	c1 e0 07             	shl    $0x7,%eax
801015f1:	01 d0                	add    %edx,%eax
801015f3:	03 45 fc             	add    -0x4(%ebp),%eax
801015f6:	05 a0 d0 10 80       	add    $0x8010d0a0,%eax
801015fb:	88 08                	mov    %cl,(%eax)
		next_char++;
801015fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
		path++;
80101601:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80101605:	eb 01                	jmp    80101608 <add_path+0x46>
int add_path(char* path) {
	int next_char = 0;
	if (path_counter > MAX_PATH_ENTRIES) {
		return path_counter;
	}
	while(*path != 0 && *path != '\n' && *path != '\t' && *path != '\r' && *path != ' ') {
80101607:	90                   	nop
80101608:	8b 45 08             	mov    0x8(%ebp),%eax
8010160b:	0f b6 00             	movzbl (%eax),%eax
8010160e:	84 c0                	test   %al,%al
80101610:	74 28                	je     8010163a <add_path+0x78>
80101612:	8b 45 08             	mov    0x8(%ebp),%eax
80101615:	0f b6 00             	movzbl (%eax),%eax
80101618:	3c 0a                	cmp    $0xa,%al
8010161a:	74 1e                	je     8010163a <add_path+0x78>
8010161c:	8b 45 08             	mov    0x8(%ebp),%eax
8010161f:	0f b6 00             	movzbl (%eax),%eax
80101622:	3c 09                	cmp    $0x9,%al
80101624:	74 14                	je     8010163a <add_path+0x78>
80101626:	8b 45 08             	mov    0x8(%ebp),%eax
80101629:	0f b6 00             	movzbl (%eax),%eax
8010162c:	3c 0d                	cmp    $0xd,%al
8010162e:	74 0a                	je     8010163a <add_path+0x78>
80101630:	8b 45 08             	mov    0x8(%ebp),%eax
80101633:	0f b6 00             	movzbl (%eax),%eax
80101636:	3c 20                	cmp    $0x20,%al
80101638:	75 a6                	jne    801015e0 <add_path+0x1e>
		search_paths[path_counter][next_char] = *path;
		next_char++;
		path++;
	}
	path_counter++;
8010163a:	a1 80 d0 10 80       	mov    0x8010d080,%eax
8010163f:	83 c0 01             	add    $0x1,%eax
80101642:	a3 80 d0 10 80       	mov    %eax,0x8010d080
	return 0;
80101647:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010164c:	c9                   	leave  
8010164d:	c3                   	ret    
	...

80101650 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80101656:	c7 44 24 04 8d 8d 10 	movl   $0x80108d8d,0x4(%esp)
8010165d:	80 
8010165e:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
80101665:	e8 20 3f 00 00       	call   8010558a <initlock>
}
8010166a:	c9                   	leave  
8010166b:	c3                   	ret    

8010166c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010166c:	55                   	push   %ebp
8010166d:	89 e5                	mov    %esp,%ebp
8010166f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80101672:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
80101679:	e8 2d 3f 00 00       	call   801055ab <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010167e:	c7 45 f4 54 fe 10 80 	movl   $0x8010fe54,-0xc(%ebp)
80101685:	eb 29                	jmp    801016b0 <filealloc+0x44>
    if(f->ref == 0){
80101687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010168a:	8b 40 04             	mov    0x4(%eax),%eax
8010168d:	85 c0                	test   %eax,%eax
8010168f:	75 1b                	jne    801016ac <filealloc+0x40>
      f->ref = 1;
80101691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101694:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010169b:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
801016a2:	e8 66 3f 00 00       	call   8010560d <release>
      return f;
801016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016aa:	eb 1e                	jmp    801016ca <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801016ac:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801016b0:	81 7d f4 b4 07 11 80 	cmpl   $0x801107b4,-0xc(%ebp)
801016b7:	72 ce                	jb     80101687 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801016b9:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
801016c0:	e8 48 3f 00 00       	call   8010560d <release>
  return 0;
801016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801016ca:	c9                   	leave  
801016cb:	c3                   	ret    

801016cc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801016cc:	55                   	push   %ebp
801016cd:	89 e5                	mov    %esp,%ebp
801016cf:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
801016d2:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
801016d9:	e8 cd 3e 00 00       	call   801055ab <acquire>
  if(f->ref < 1)
801016de:	8b 45 08             	mov    0x8(%ebp),%eax
801016e1:	8b 40 04             	mov    0x4(%eax),%eax
801016e4:	85 c0                	test   %eax,%eax
801016e6:	7f 0c                	jg     801016f4 <filedup+0x28>
    panic("filedup");
801016e8:	c7 04 24 94 8d 10 80 	movl   $0x80108d94,(%esp)
801016ef:	e8 49 ee ff ff       	call   8010053d <panic>
  f->ref++;
801016f4:	8b 45 08             	mov    0x8(%ebp),%eax
801016f7:	8b 40 04             	mov    0x4(%eax),%eax
801016fa:	8d 50 01             	lea    0x1(%eax),%edx
801016fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101700:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101703:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
8010170a:	e8 fe 3e 00 00       	call   8010560d <release>
  return f;
8010170f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101712:	c9                   	leave  
80101713:	c3                   	ret    

80101714 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101714:	55                   	push   %ebp
80101715:	89 e5                	mov    %esp,%ebp
80101717:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
8010171a:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
80101721:	e8 85 3e 00 00       	call   801055ab <acquire>
  if(f->ref < 1)
80101726:	8b 45 08             	mov    0x8(%ebp),%eax
80101729:	8b 40 04             	mov    0x4(%eax),%eax
8010172c:	85 c0                	test   %eax,%eax
8010172e:	7f 0c                	jg     8010173c <fileclose+0x28>
    panic("fileclose");
80101730:	c7 04 24 9c 8d 10 80 	movl   $0x80108d9c,(%esp)
80101737:	e8 01 ee ff ff       	call   8010053d <panic>
  if(--f->ref > 0){
8010173c:	8b 45 08             	mov    0x8(%ebp),%eax
8010173f:	8b 40 04             	mov    0x4(%eax),%eax
80101742:	8d 50 ff             	lea    -0x1(%eax),%edx
80101745:	8b 45 08             	mov    0x8(%ebp),%eax
80101748:	89 50 04             	mov    %edx,0x4(%eax)
8010174b:	8b 45 08             	mov    0x8(%ebp),%eax
8010174e:	8b 40 04             	mov    0x4(%eax),%eax
80101751:	85 c0                	test   %eax,%eax
80101753:	7e 11                	jle    80101766 <fileclose+0x52>
    release(&ftable.lock);
80101755:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
8010175c:	e8 ac 3e 00 00       	call   8010560d <release>
    return;
80101761:	e9 82 00 00 00       	jmp    801017e8 <fileclose+0xd4>
  }
  ff = *f;
80101766:	8b 45 08             	mov    0x8(%ebp),%eax
80101769:	8b 10                	mov    (%eax),%edx
8010176b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010176e:	8b 50 04             	mov    0x4(%eax),%edx
80101771:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101774:	8b 50 08             	mov    0x8(%eax),%edx
80101777:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010177a:	8b 50 0c             	mov    0xc(%eax),%edx
8010177d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101780:	8b 50 10             	mov    0x10(%eax),%edx
80101783:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101786:	8b 40 14             	mov    0x14(%eax),%eax
80101789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010178c:	8b 45 08             	mov    0x8(%ebp),%eax
8010178f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101796:	8b 45 08             	mov    0x8(%ebp),%eax
80101799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010179f:	c7 04 24 20 fe 10 80 	movl   $0x8010fe20,(%esp)
801017a6:	e8 62 3e 00 00       	call   8010560d <release>
  
  if(ff.type == FD_PIPE)
801017ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801017ae:	83 f8 01             	cmp    $0x1,%eax
801017b1:	75 18                	jne    801017cb <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801017b3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801017b7:	0f be d0             	movsbl %al,%edx
801017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801017c1:	89 04 24             	mov    %eax,(%esp)
801017c4:	e8 02 2d 00 00       	call   801044cb <pipeclose>
801017c9:	eb 1d                	jmp    801017e8 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801017cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801017ce:	83 f8 02             	cmp    $0x2,%eax
801017d1:	75 15                	jne    801017e8 <fileclose+0xd4>
    begin_trans();
801017d3:	e8 95 21 00 00       	call   8010396d <begin_trans>
    iput(ff.ip);
801017d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017db:	89 04 24             	mov    %eax,(%esp)
801017de:	e8 88 09 00 00       	call   8010216b <iput>
    commit_trans();
801017e3:	e8 ce 21 00 00       	call   801039b6 <commit_trans>
  }
}
801017e8:	c9                   	leave  
801017e9:	c3                   	ret    

801017ea <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801017ea:	55                   	push   %ebp
801017eb:	89 e5                	mov    %esp,%ebp
801017ed:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801017f0:	8b 45 08             	mov    0x8(%ebp),%eax
801017f3:	8b 00                	mov    (%eax),%eax
801017f5:	83 f8 02             	cmp    $0x2,%eax
801017f8:	75 38                	jne    80101832 <filestat+0x48>
    ilock(f->ip);
801017fa:	8b 45 08             	mov    0x8(%ebp),%eax
801017fd:	8b 40 10             	mov    0x10(%eax),%eax
80101800:	89 04 24             	mov    %eax,(%esp)
80101803:	e8 b0 07 00 00       	call   80101fb8 <ilock>
    stati(f->ip, st);
80101808:	8b 45 08             	mov    0x8(%ebp),%eax
8010180b:	8b 40 10             	mov    0x10(%eax),%eax
8010180e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101811:	89 54 24 04          	mov    %edx,0x4(%esp)
80101815:	89 04 24             	mov    %eax,(%esp)
80101818:	e8 4c 0c 00 00       	call   80102469 <stati>
    iunlock(f->ip);
8010181d:	8b 45 08             	mov    0x8(%ebp),%eax
80101820:	8b 40 10             	mov    0x10(%eax),%eax
80101823:	89 04 24             	mov    %eax,(%esp)
80101826:	e8 db 08 00 00       	call   80102106 <iunlock>
    return 0;
8010182b:	b8 00 00 00 00       	mov    $0x0,%eax
80101830:	eb 05                	jmp    80101837 <filestat+0x4d>
  }
  return -1;
80101832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101837:	c9                   	leave  
80101838:	c3                   	ret    

80101839 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101839:	55                   	push   %ebp
8010183a:	89 e5                	mov    %esp,%ebp
8010183c:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010183f:	8b 45 08             	mov    0x8(%ebp),%eax
80101842:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101846:	84 c0                	test   %al,%al
80101848:	75 0a                	jne    80101854 <fileread+0x1b>
    return -1;
8010184a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010184f:	e9 9f 00 00 00       	jmp    801018f3 <fileread+0xba>
  if(f->type == FD_PIPE)
80101854:	8b 45 08             	mov    0x8(%ebp),%eax
80101857:	8b 00                	mov    (%eax),%eax
80101859:	83 f8 01             	cmp    $0x1,%eax
8010185c:	75 1e                	jne    8010187c <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010185e:	8b 45 08             	mov    0x8(%ebp),%eax
80101861:	8b 40 0c             	mov    0xc(%eax),%eax
80101864:	8b 55 10             	mov    0x10(%ebp),%edx
80101867:	89 54 24 08          	mov    %edx,0x8(%esp)
8010186b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010186e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101872:	89 04 24             	mov    %eax,(%esp)
80101875:	e8 d3 2d 00 00       	call   8010464d <piperead>
8010187a:	eb 77                	jmp    801018f3 <fileread+0xba>
  if(f->type == FD_INODE){
8010187c:	8b 45 08             	mov    0x8(%ebp),%eax
8010187f:	8b 00                	mov    (%eax),%eax
80101881:	83 f8 02             	cmp    $0x2,%eax
80101884:	75 61                	jne    801018e7 <fileread+0xae>
    ilock(f->ip);
80101886:	8b 45 08             	mov    0x8(%ebp),%eax
80101889:	8b 40 10             	mov    0x10(%eax),%eax
8010188c:	89 04 24             	mov    %eax,(%esp)
8010188f:	e8 24 07 00 00       	call   80101fb8 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101894:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101897:	8b 45 08             	mov    0x8(%ebp),%eax
8010189a:	8b 50 14             	mov    0x14(%eax),%edx
8010189d:	8b 45 08             	mov    0x8(%ebp),%eax
801018a0:	8b 40 10             	mov    0x10(%eax),%eax
801018a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801018a7:	89 54 24 08          	mov    %edx,0x8(%esp)
801018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801018ae:	89 54 24 04          	mov    %edx,0x4(%esp)
801018b2:	89 04 24             	mov    %eax,(%esp)
801018b5:	e8 f4 0b 00 00       	call   801024ae <readi>
801018ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
801018bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801018c1:	7e 11                	jle    801018d4 <fileread+0x9b>
      f->off += r;
801018c3:	8b 45 08             	mov    0x8(%ebp),%eax
801018c6:	8b 50 14             	mov    0x14(%eax),%edx
801018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cc:	01 c2                	add    %eax,%edx
801018ce:	8b 45 08             	mov    0x8(%ebp),%eax
801018d1:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801018d4:	8b 45 08             	mov    0x8(%ebp),%eax
801018d7:	8b 40 10             	mov    0x10(%eax),%eax
801018da:	89 04 24             	mov    %eax,(%esp)
801018dd:	e8 24 08 00 00       	call   80102106 <iunlock>
    return r;
801018e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e5:	eb 0c                	jmp    801018f3 <fileread+0xba>
  }
  panic("fileread");
801018e7:	c7 04 24 a6 8d 10 80 	movl   $0x80108da6,(%esp)
801018ee:	e8 4a ec ff ff       	call   8010053d <panic>
}
801018f3:	c9                   	leave  
801018f4:	c3                   	ret    

801018f5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801018f5:	55                   	push   %ebp
801018f6:	89 e5                	mov    %esp,%ebp
801018f8:	53                   	push   %ebx
801018f9:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
801018ff:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101903:	84 c0                	test   %al,%al
80101905:	75 0a                	jne    80101911 <filewrite+0x1c>
    return -1;
80101907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010190c:	e9 23 01 00 00       	jmp    80101a34 <filewrite+0x13f>
  if(f->type == FD_PIPE)
80101911:	8b 45 08             	mov    0x8(%ebp),%eax
80101914:	8b 00                	mov    (%eax),%eax
80101916:	83 f8 01             	cmp    $0x1,%eax
80101919:	75 21                	jne    8010193c <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
8010191b:	8b 45 08             	mov    0x8(%ebp),%eax
8010191e:	8b 40 0c             	mov    0xc(%eax),%eax
80101921:	8b 55 10             	mov    0x10(%ebp),%edx
80101924:	89 54 24 08          	mov    %edx,0x8(%esp)
80101928:	8b 55 0c             	mov    0xc(%ebp),%edx
8010192b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010192f:	89 04 24             	mov    %eax,(%esp)
80101932:	e8 26 2c 00 00       	call   8010455d <pipewrite>
80101937:	e9 f8 00 00 00       	jmp    80101a34 <filewrite+0x13f>
  if(f->type == FD_INODE){
8010193c:	8b 45 08             	mov    0x8(%ebp),%eax
8010193f:	8b 00                	mov    (%eax),%eax
80101941:	83 f8 02             	cmp    $0x2,%eax
80101944:	0f 85 de 00 00 00    	jne    80101a28 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010194a:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101958:	e9 a8 00 00 00       	jmp    80101a05 <filewrite+0x110>
      int n1 = n - i;
8010195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101960:	8b 55 10             	mov    0x10(%ebp),%edx
80101963:	89 d1                	mov    %edx,%ecx
80101965:	29 c1                	sub    %eax,%ecx
80101967:	89 c8                	mov    %ecx,%eax
80101969:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101972:	7e 06                	jle    8010197a <filewrite+0x85>
        n1 = max;
80101974:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101977:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010197a:	e8 ee 1f 00 00       	call   8010396d <begin_trans>
      ilock(f->ip);
8010197f:	8b 45 08             	mov    0x8(%ebp),%eax
80101982:	8b 40 10             	mov    0x10(%eax),%eax
80101985:	89 04 24             	mov    %eax,(%esp)
80101988:	e8 2b 06 00 00       	call   80101fb8 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010198d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80101990:	8b 45 08             	mov    0x8(%ebp),%eax
80101993:	8b 48 14             	mov    0x14(%eax),%ecx
80101996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101999:	89 c2                	mov    %eax,%edx
8010199b:	03 55 0c             	add    0xc(%ebp),%edx
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	8b 40 10             	mov    0x10(%eax),%eax
801019a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801019a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801019ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801019b0:	89 04 24             	mov    %eax,(%esp)
801019b3:	e8 61 0c 00 00       	call   80102619 <writei>
801019b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
801019bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801019bf:	7e 11                	jle    801019d2 <filewrite+0xdd>
        f->off += r;
801019c1:	8b 45 08             	mov    0x8(%ebp),%eax
801019c4:	8b 50 14             	mov    0x14(%eax),%edx
801019c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801019ca:	01 c2                	add    %eax,%edx
801019cc:	8b 45 08             	mov    0x8(%ebp),%eax
801019cf:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801019d2:	8b 45 08             	mov    0x8(%ebp),%eax
801019d5:	8b 40 10             	mov    0x10(%eax),%eax
801019d8:	89 04 24             	mov    %eax,(%esp)
801019db:	e8 26 07 00 00       	call   80102106 <iunlock>
      commit_trans();
801019e0:	e8 d1 1f 00 00       	call   801039b6 <commit_trans>

      if(r < 0)
801019e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801019e9:	78 28                	js     80101a13 <filewrite+0x11e>
        break;
      if(r != n1)
801019eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801019ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801019f1:	74 0c                	je     801019ff <filewrite+0x10a>
        panic("short filewrite");
801019f3:	c7 04 24 af 8d 10 80 	movl   $0x80108daf,(%esp)
801019fa:	e8 3e eb ff ff       	call   8010053d <panic>
      i += r;
801019ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101a02:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a08:	3b 45 10             	cmp    0x10(%ebp),%eax
80101a0b:	0f 8c 4c ff ff ff    	jl     8010195d <filewrite+0x68>
80101a11:	eb 01                	jmp    80101a14 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
80101a13:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a17:	3b 45 10             	cmp    0x10(%ebp),%eax
80101a1a:	75 05                	jne    80101a21 <filewrite+0x12c>
80101a1c:	8b 45 10             	mov    0x10(%ebp),%eax
80101a1f:	eb 05                	jmp    80101a26 <filewrite+0x131>
80101a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a26:	eb 0c                	jmp    80101a34 <filewrite+0x13f>
  }
  panic("filewrite");
80101a28:	c7 04 24 bf 8d 10 80 	movl   $0x80108dbf,(%esp)
80101a2f:	e8 09 eb ff ff       	call   8010053d <panic>
}
80101a34:	83 c4 24             	add    $0x24,%esp
80101a37:	5b                   	pop    %ebx
80101a38:	5d                   	pop    %ebp
80101a39:	c3                   	ret    
	...

80101a3c <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101a3c:	55                   	push   %ebp
80101a3d:	89 e5                	mov    %esp,%ebp
80101a3f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101a42:	8b 45 08             	mov    0x8(%ebp),%eax
80101a45:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101a4c:	00 
80101a4d:	89 04 24             	mov    %eax,(%esp)
80101a50:	e8 51 e7 ff ff       	call   801001a6 <bread>
80101a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5b:	83 c0 18             	add    $0x18,%eax
80101a5e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101a65:	00 
80101a66:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a6d:	89 04 24             	mov    %eax,(%esp)
80101a70:	e8 58 3e 00 00       	call   801058cd <memmove>
  brelse(bp);
80101a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a78:	89 04 24             	mov    %eax,(%esp)
80101a7b:	e8 97 e7 ff ff       	call   80100217 <brelse>
}
80101a80:	c9                   	leave  
80101a81:	c3                   	ret    

80101a82 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101a82:	55                   	push   %ebp
80101a83:	89 e5                	mov    %esp,%ebp
80101a85:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101a88:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a92:	89 04 24             	mov    %eax,(%esp)
80101a95:	e8 0c e7 ff ff       	call   801001a6 <bread>
80101a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa0:	83 c0 18             	add    $0x18,%eax
80101aa3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101aaa:	00 
80101aab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101ab2:	00 
80101ab3:	89 04 24             	mov    %eax,(%esp)
80101ab6:	e8 3f 3d 00 00       	call   801057fa <memset>
  log_write(bp);
80101abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101abe:	89 04 24             	mov    %eax,(%esp)
80101ac1:	e8 48 1f 00 00       	call   80103a0e <log_write>
  brelse(bp);
80101ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac9:	89 04 24             	mov    %eax,(%esp)
80101acc:	e8 46 e7 ff ff       	call   80100217 <brelse>
}
80101ad1:	c9                   	leave  
80101ad2:	c3                   	ret    

80101ad3 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101ad3:	55                   	push   %ebp
80101ad4:	89 e5                	mov    %esp,%ebp
80101ad6:	53                   	push   %ebx
80101ad7:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101ada:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101ae7:	89 54 24 04          	mov    %edx,0x4(%esp)
80101aeb:	89 04 24             	mov    %eax,(%esp)
80101aee:	e8 49 ff ff ff       	call   80101a3c <readsb>
  for(b = 0; b < sb.size; b += BPB){
80101af3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101afa:	e9 11 01 00 00       	jmp    80101c10 <balloc+0x13d>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
80101aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b02:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101b08:	85 c0                	test   %eax,%eax
80101b0a:	0f 48 c2             	cmovs  %edx,%eax
80101b0d:	c1 f8 0c             	sar    $0xc,%eax
80101b10:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101b13:	c1 ea 03             	shr    $0x3,%edx
80101b16:	01 d0                	add    %edx,%eax
80101b18:	83 c0 03             	add    $0x3,%eax
80101b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	89 04 24             	mov    %eax,(%esp)
80101b25:	e8 7c e6 ff ff       	call   801001a6 <bread>
80101b2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101b2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101b34:	e9 a7 00 00 00       	jmp    80101be0 <balloc+0x10d>
      m = 1 << (bi % 8);
80101b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b3c:	89 c2                	mov    %eax,%edx
80101b3e:	c1 fa 1f             	sar    $0x1f,%edx
80101b41:	c1 ea 1d             	shr    $0x1d,%edx
80101b44:	01 d0                	add    %edx,%eax
80101b46:	83 e0 07             	and    $0x7,%eax
80101b49:	29 d0                	sub    %edx,%eax
80101b4b:	ba 01 00 00 00       	mov    $0x1,%edx
80101b50:	89 d3                	mov    %edx,%ebx
80101b52:	89 c1                	mov    %eax,%ecx
80101b54:	d3 e3                	shl    %cl,%ebx
80101b56:	89 d8                	mov    %ebx,%eax
80101b58:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b5e:	8d 50 07             	lea    0x7(%eax),%edx
80101b61:	85 c0                	test   %eax,%eax
80101b63:	0f 48 c2             	cmovs  %edx,%eax
80101b66:	c1 f8 03             	sar    $0x3,%eax
80101b69:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b6c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101b71:	0f b6 c0             	movzbl %al,%eax
80101b74:	23 45 e8             	and    -0x18(%ebp),%eax
80101b77:	85 c0                	test   %eax,%eax
80101b79:	75 61                	jne    80101bdc <balloc+0x109>
        bp->data[bi/8] |= m;  // Mark block in use.
80101b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b7e:	8d 50 07             	lea    0x7(%eax),%edx
80101b81:	85 c0                	test   %eax,%eax
80101b83:	0f 48 c2             	cmovs  %edx,%eax
80101b86:	c1 f8 03             	sar    $0x3,%eax
80101b89:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b8c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101b91:	89 d1                	mov    %edx,%ecx
80101b93:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101b96:	09 ca                	or     %ecx,%edx
80101b98:	89 d1                	mov    %edx,%ecx
80101b9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b9d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ba4:	89 04 24             	mov    %eax,(%esp)
80101ba7:	e8 62 1e 00 00       	call   80103a0e <log_write>
        brelse(bp);
80101bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101baf:	89 04 24             	mov    %eax,(%esp)
80101bb2:	e8 60 e6 ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bbd:	01 c2                	add    %eax,%edx
80101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bc6:	89 04 24             	mov    %eax,(%esp)
80101bc9:	e8 b4 fe ff ff       	call   80101a82 <bzero>
        return b + bi;
80101bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bd4:	01 d0                	add    %edx,%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101bd6:	83 c4 34             	add    $0x34,%esp
80101bd9:	5b                   	pop    %ebx
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101bdc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101be0:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101be7:	7f 15                	jg     80101bfe <balloc+0x12b>
80101be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bef:	01 d0                	add    %edx,%eax
80101bf1:	89 c2                	mov    %eax,%edx
80101bf3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bf6:	39 c2                	cmp    %eax,%edx
80101bf8:	0f 82 3b ff ff ff    	jb     80101b39 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101bfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c01:	89 04 24             	mov    %eax,(%esp)
80101c04:	e8 0e e6 ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
80101c09:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c13:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c16:	39 c2                	cmp    %eax,%edx
80101c18:	0f 82 e1 fe ff ff    	jb     80101aff <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101c1e:	c7 04 24 c9 8d 10 80 	movl   $0x80108dc9,(%esp)
80101c25:	e8 13 e9 ff ff       	call   8010053d <panic>

80101c2a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101c2a:	55                   	push   %ebp
80101c2b:	89 e5                	mov    %esp,%ebp
80101c2d:	53                   	push   %ebx
80101c2e:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101c31:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101c34:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c38:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3b:	89 04 24             	mov    %eax,(%esp)
80101c3e:	e8 f9 fd ff ff       	call   80101a3c <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101c43:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c46:	89 c2                	mov    %eax,%edx
80101c48:	c1 ea 0c             	shr    $0xc,%edx
80101c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c4e:	c1 e8 03             	shr    $0x3,%eax
80101c51:	01 d0                	add    %edx,%eax
80101c53:	8d 50 03             	lea    0x3(%eax),%edx
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c5d:	89 04 24             	mov    %eax,(%esp)
80101c60:	e8 41 e5 ff ff       	call   801001a6 <bread>
80101c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101c68:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c6b:	25 ff 0f 00 00       	and    $0xfff,%eax
80101c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c76:	89 c2                	mov    %eax,%edx
80101c78:	c1 fa 1f             	sar    $0x1f,%edx
80101c7b:	c1 ea 1d             	shr    $0x1d,%edx
80101c7e:	01 d0                	add    %edx,%eax
80101c80:	83 e0 07             	and    $0x7,%eax
80101c83:	29 d0                	sub    %edx,%eax
80101c85:	ba 01 00 00 00       	mov    $0x1,%edx
80101c8a:	89 d3                	mov    %edx,%ebx
80101c8c:	89 c1                	mov    %eax,%ecx
80101c8e:	d3 e3                	shl    %cl,%ebx
80101c90:	89 d8                	mov    %ebx,%eax
80101c92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c98:	8d 50 07             	lea    0x7(%eax),%edx
80101c9b:	85 c0                	test   %eax,%eax
80101c9d:	0f 48 c2             	cmovs  %edx,%eax
80101ca0:	c1 f8 03             	sar    $0x3,%eax
80101ca3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ca6:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101cab:	0f b6 c0             	movzbl %al,%eax
80101cae:	23 45 ec             	and    -0x14(%ebp),%eax
80101cb1:	85 c0                	test   %eax,%eax
80101cb3:	75 0c                	jne    80101cc1 <bfree+0x97>
    panic("freeing free block");
80101cb5:	c7 04 24 df 8d 10 80 	movl   $0x80108ddf,(%esp)
80101cbc:	e8 7c e8 ff ff       	call   8010053d <panic>
  bp->data[bi/8] &= ~m;
80101cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc4:	8d 50 07             	lea    0x7(%eax),%edx
80101cc7:	85 c0                	test   %eax,%eax
80101cc9:	0f 48 c2             	cmovs  %edx,%eax
80101ccc:	c1 f8 03             	sar    $0x3,%eax
80101ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd2:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101cd7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101cda:	f7 d1                	not    %ecx
80101cdc:	21 ca                	and    %ecx,%edx
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ce3:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cea:	89 04 24             	mov    %eax,(%esp)
80101ced:	e8 1c 1d 00 00       	call   80103a0e <log_write>
  brelse(bp);
80101cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf5:	89 04 24             	mov    %eax,(%esp)
80101cf8:	e8 1a e5 ff ff       	call   80100217 <brelse>
}
80101cfd:	83 c4 34             	add    $0x34,%esp
80101d00:	5b                   	pop    %ebx
80101d01:	5d                   	pop    %ebp
80101d02:	c3                   	ret    

80101d03 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101d03:	55                   	push   %ebp
80101d04:	89 e5                	mov    %esp,%ebp
80101d06:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
80101d09:	c7 44 24 04 f2 8d 10 	movl   $0x80108df2,0x4(%esp)
80101d10:	80 
80101d11:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101d18:	e8 6d 38 00 00       	call   8010558a <initlock>
}
80101d1d:	c9                   	leave  
80101d1e:	c3                   	ret    

80101d1f <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101d1f:	55                   	push   %ebp
80101d20:	89 e5                	mov    %esp,%ebp
80101d22:	83 ec 48             	sub    $0x48,%esp
80101d25:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d28:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101d32:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d36:	89 04 24             	mov    %eax,(%esp)
80101d39:	e8 fe fc ff ff       	call   80101a3c <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101d3e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101d45:	e9 98 00 00 00       	jmp    80101de2 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d4d:	c1 e8 03             	shr    $0x3,%eax
80101d50:	83 c0 02             	add    $0x2,%eax
80101d53:	89 44 24 04          	mov    %eax,0x4(%esp)
80101d57:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5a:	89 04 24             	mov    %eax,(%esp)
80101d5d:	e8 44 e4 ff ff       	call   801001a6 <bread>
80101d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d68:	8d 50 18             	lea    0x18(%eax),%edx
80101d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d6e:	83 e0 07             	and    $0x7,%eax
80101d71:	c1 e0 06             	shl    $0x6,%eax
80101d74:	01 d0                	add    %edx,%eax
80101d76:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d7c:	0f b7 00             	movzwl (%eax),%eax
80101d7f:	66 85 c0             	test   %ax,%ax
80101d82:	75 4f                	jne    80101dd3 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101d84:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101d8b:	00 
80101d8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101d93:	00 
80101d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d97:	89 04 24             	mov    %eax,(%esp)
80101d9a:	e8 5b 3a 00 00       	call   801057fa <memset>
      dip->type = type;
80101d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101da2:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101da6:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dac:	89 04 24             	mov    %eax,(%esp)
80101daf:	e8 5a 1c 00 00       	call   80103a0e <log_write>
      brelse(bp);
80101db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db7:	89 04 24             	mov    %eax,(%esp)
80101dba:	e8 58 e4 ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
80101dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc9:	89 04 24             	mov    %eax,(%esp)
80101dcc:	e8 e3 00 00 00       	call   80101eb4 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101dd1:	c9                   	leave  
80101dd2:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd6:	89 04 24             	mov    %eax,(%esp)
80101dd9:	e8 39 e4 ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101dde:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101de8:	39 c2                	cmp    %eax,%edx
80101dea:	0f 82 5a ff ff ff    	jb     80101d4a <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101df0:	c7 04 24 f9 8d 10 80 	movl   $0x80108df9,(%esp)
80101df7:	e8 41 e7 ff ff       	call   8010053d <panic>

80101dfc <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101dfc:	55                   	push   %ebp
80101dfd:	89 e5                	mov    %esp,%ebp
80101dff:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101e02:	8b 45 08             	mov    0x8(%ebp),%eax
80101e05:	8b 40 04             	mov    0x4(%eax),%eax
80101e08:	c1 e8 03             	shr    $0x3,%eax
80101e0b:	8d 50 02             	lea    0x2(%eax),%edx
80101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e11:	8b 00                	mov    (%eax),%eax
80101e13:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e17:	89 04 24             	mov    %eax,(%esp)
80101e1a:	e8 87 e3 ff ff       	call   801001a6 <bread>
80101e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e25:	8d 50 18             	lea    0x18(%eax),%edx
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	8b 40 04             	mov    0x4(%eax),%eax
80101e2e:	83 e0 07             	and    $0x7,%eax
80101e31:	c1 e0 06             	shl    $0x6,%eax
80101e34:	01 d0                	add    %edx,%eax
80101e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101e39:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e43:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101e46:	8b 45 08             	mov    0x8(%ebp),%eax
80101e49:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e50:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101e54:	8b 45 08             	mov    0x8(%ebp),%eax
80101e57:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e5e:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101e62:	8b 45 08             	mov    0x8(%ebp),%eax
80101e65:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	8b 50 18             	mov    0x18(%eax),%edx
80101e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e79:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7f:	8d 50 1c             	lea    0x1c(%eax),%edx
80101e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e85:	83 c0 0c             	add    $0xc,%eax
80101e88:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101e8f:	00 
80101e90:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e94:	89 04 24             	mov    %eax,(%esp)
80101e97:	e8 31 3a 00 00       	call   801058cd <memmove>
  log_write(bp);
80101e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e9f:	89 04 24             	mov    %eax,(%esp)
80101ea2:	e8 67 1b 00 00       	call   80103a0e <log_write>
  brelse(bp);
80101ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eaa:	89 04 24             	mov    %eax,(%esp)
80101ead:	e8 65 e3 ff ff       	call   80100217 <brelse>
}
80101eb2:	c9                   	leave  
80101eb3:	c3                   	ret    

80101eb4 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101eb4:	55                   	push   %ebp
80101eb5:	89 e5                	mov    %esp,%ebp
80101eb7:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101eba:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101ec1:	e8 e5 36 00 00       	call   801055ab <acquire>

  // Is the inode already cached?
  empty = 0;
80101ec6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101ecd:	c7 45 f4 54 08 11 80 	movl   $0x80110854,-0xc(%ebp)
80101ed4:	eb 59                	jmp    80101f2f <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ed9:	8b 40 08             	mov    0x8(%eax),%eax
80101edc:	85 c0                	test   %eax,%eax
80101ede:	7e 35                	jle    80101f15 <iget+0x61>
80101ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ee3:	8b 00                	mov    (%eax),%eax
80101ee5:	3b 45 08             	cmp    0x8(%ebp),%eax
80101ee8:	75 2b                	jne    80101f15 <iget+0x61>
80101eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eed:	8b 40 04             	mov    0x4(%eax),%eax
80101ef0:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101ef3:	75 20                	jne    80101f15 <iget+0x61>
      ip->ref++;
80101ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef8:	8b 40 08             	mov    0x8(%eax),%eax
80101efb:	8d 50 01             	lea    0x1(%eax),%edx
80101efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f01:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101f04:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101f0b:	e8 fd 36 00 00       	call   8010560d <release>
      return ip;
80101f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f13:	eb 6f                	jmp    80101f84 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101f19:	75 10                	jne    80101f2b <iget+0x77>
80101f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f1e:	8b 40 08             	mov    0x8(%eax),%eax
80101f21:	85 c0                	test   %eax,%eax
80101f23:	75 06                	jne    80101f2b <iget+0x77>
      empty = ip;
80101f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f28:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101f2b:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101f2f:	81 7d f4 f4 17 11 80 	cmpl   $0x801117f4,-0xc(%ebp)
80101f36:	72 9e                	jb     80101ed6 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101f38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101f3c:	75 0c                	jne    80101f4a <iget+0x96>
    panic("iget: no inodes");
80101f3e:	c7 04 24 0b 8e 10 80 	movl   $0x80108e0b,(%esp)
80101f45:	e8 f3 e5 ff ff       	call   8010053d <panic>

  ip = empty;
80101f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f53:	8b 55 08             	mov    0x8(%ebp),%edx
80101f56:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f5e:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f64:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f6e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101f75:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101f7c:	e8 8c 36 00 00       	call   8010560d <release>

  return ip;
80101f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101f84:	c9                   	leave  
80101f85:	c3                   	ret    

80101f86 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101f86:	55                   	push   %ebp
80101f87:	89 e5                	mov    %esp,%ebp
80101f89:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101f8c:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101f93:	e8 13 36 00 00       	call   801055ab <acquire>
  ip->ref++;
80101f98:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9b:	8b 40 08             	mov    0x8(%eax),%eax
80101f9e:	8d 50 01             	lea    0x1(%eax),%edx
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101fa7:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101fae:	e8 5a 36 00 00       	call   8010560d <release>
  return ip;
80101fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fb6:	c9                   	leave  
80101fb7:	c3                   	ret    

80101fb8 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101fb8:	55                   	push   %ebp
80101fb9:	89 e5                	mov    %esp,%ebp
80101fbb:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101fbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101fc2:	74 0a                	je     80101fce <ilock+0x16>
80101fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc7:	8b 40 08             	mov    0x8(%eax),%eax
80101fca:	85 c0                	test   %eax,%eax
80101fcc:	7f 0c                	jg     80101fda <ilock+0x22>
    panic("ilock");
80101fce:	c7 04 24 1b 8e 10 80 	movl   $0x80108e1b,(%esp)
80101fd5:	e8 63 e5 ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
80101fda:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101fe1:	e8 c5 35 00 00       	call   801055ab <acquire>
  while(ip->flags & I_BUSY)
80101fe6:	eb 13                	jmp    80101ffb <ilock+0x43>
    sleep(ip, &icache.lock);
80101fe8:	c7 44 24 04 20 08 11 	movl   $0x80110820,0x4(%esp)
80101fef:	80 
80101ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff3:	89 04 24             	mov    %eax,(%esp)
80101ff6:	e8 38 32 00 00       	call   80105233 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffe:	8b 40 0c             	mov    0xc(%eax),%eax
80102001:	83 e0 01             	and    $0x1,%eax
80102004:	84 c0                	test   %al,%al
80102006:	75 e0                	jne    80101fe8 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80102008:	8b 45 08             	mov    0x8(%ebp),%eax
8010200b:	8b 40 0c             	mov    0xc(%eax),%eax
8010200e:	89 c2                	mov    %eax,%edx
80102010:	83 ca 01             	or     $0x1,%edx
80102013:	8b 45 08             	mov    0x8(%ebp),%eax
80102016:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80102019:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80102020:	e8 e8 35 00 00       	call   8010560d <release>

  if(!(ip->flags & I_VALID)){
80102025:	8b 45 08             	mov    0x8(%ebp),%eax
80102028:	8b 40 0c             	mov    0xc(%eax),%eax
8010202b:	83 e0 02             	and    $0x2,%eax
8010202e:	85 c0                	test   %eax,%eax
80102030:	0f 85 ce 00 00 00    	jne    80102104 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80102036:	8b 45 08             	mov    0x8(%ebp),%eax
80102039:	8b 40 04             	mov    0x4(%eax),%eax
8010203c:	c1 e8 03             	shr    $0x3,%eax
8010203f:	8d 50 02             	lea    0x2(%eax),%edx
80102042:	8b 45 08             	mov    0x8(%ebp),%eax
80102045:	8b 00                	mov    (%eax),%eax
80102047:	89 54 24 04          	mov    %edx,0x4(%esp)
8010204b:	89 04 24             	mov    %eax,(%esp)
8010204e:	e8 53 e1 ff ff       	call   801001a6 <bread>
80102053:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102059:	8d 50 18             	lea    0x18(%eax),%edx
8010205c:	8b 45 08             	mov    0x8(%ebp),%eax
8010205f:	8b 40 04             	mov    0x4(%eax),%eax
80102062:	83 e0 07             	and    $0x7,%eax
80102065:	c1 e0 06             	shl    $0x6,%eax
80102068:	01 d0                	add    %edx,%eax
8010206a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010206d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102070:	0f b7 10             	movzwl (%eax),%edx
80102073:	8b 45 08             	mov    0x8(%ebp),%eax
80102076:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010207d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80102081:	8b 45 08             	mov    0x8(%ebp),%eax
80102084:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80102088:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010208b:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010208f:	8b 45 08             	mov    0x8(%ebp),%eax
80102092:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80102096:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102099:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010209d:	8b 45 08             	mov    0x8(%ebp),%eax
801020a0:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020a7:	8b 50 08             	mov    0x8(%eax),%edx
801020aa:	8b 45 08             	mov    0x8(%ebp),%eax
801020ad:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801020b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020b3:	8d 50 0c             	lea    0xc(%eax),%edx
801020b6:	8b 45 08             	mov    0x8(%ebp),%eax
801020b9:	83 c0 1c             	add    $0x1c,%eax
801020bc:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801020c3:	00 
801020c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801020c8:	89 04 24             	mov    %eax,(%esp)
801020cb:	e8 fd 37 00 00       	call   801058cd <memmove>
    brelse(bp);
801020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020d3:	89 04 24             	mov    %eax,(%esp)
801020d6:	e8 3c e1 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
801020de:	8b 40 0c             	mov    0xc(%eax),%eax
801020e1:	89 c2                	mov    %eax,%edx
801020e3:	83 ca 02             	or     $0x2,%edx
801020e6:	8b 45 08             	mov    0x8(%ebp),%eax
801020e9:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020f3:	66 85 c0             	test   %ax,%ax
801020f6:	75 0c                	jne    80102104 <ilock+0x14c>
      panic("ilock: no type");
801020f8:	c7 04 24 21 8e 10 80 	movl   $0x80108e21,(%esp)
801020ff:	e8 39 e4 ff ff       	call   8010053d <panic>
  }
}
80102104:	c9                   	leave  
80102105:	c3                   	ret    

80102106 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80102106:	55                   	push   %ebp
80102107:	89 e5                	mov    %esp,%ebp
80102109:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010210c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102110:	74 17                	je     80102129 <iunlock+0x23>
80102112:	8b 45 08             	mov    0x8(%ebp),%eax
80102115:	8b 40 0c             	mov    0xc(%eax),%eax
80102118:	83 e0 01             	and    $0x1,%eax
8010211b:	85 c0                	test   %eax,%eax
8010211d:	74 0a                	je     80102129 <iunlock+0x23>
8010211f:	8b 45 08             	mov    0x8(%ebp),%eax
80102122:	8b 40 08             	mov    0x8(%eax),%eax
80102125:	85 c0                	test   %eax,%eax
80102127:	7f 0c                	jg     80102135 <iunlock+0x2f>
    panic("iunlock");
80102129:	c7 04 24 30 8e 10 80 	movl   $0x80108e30,(%esp)
80102130:	e8 08 e4 ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
80102135:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
8010213c:	e8 6a 34 00 00       	call   801055ab <acquire>
  ip->flags &= ~I_BUSY;
80102141:	8b 45 08             	mov    0x8(%ebp),%eax
80102144:	8b 40 0c             	mov    0xc(%eax),%eax
80102147:	89 c2                	mov    %eax,%edx
80102149:	83 e2 fe             	and    $0xfffffffe,%edx
8010214c:	8b 45 08             	mov    0x8(%ebp),%eax
8010214f:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80102152:	8b 45 08             	mov    0x8(%ebp),%eax
80102155:	89 04 24             	mov    %eax,(%esp)
80102158:	e8 44 32 00 00       	call   801053a1 <wakeup>
  release(&icache.lock);
8010215d:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80102164:	e8 a4 34 00 00       	call   8010560d <release>
}
80102169:	c9                   	leave  
8010216a:	c3                   	ret    

8010216b <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
8010216b:	55                   	push   %ebp
8010216c:	89 e5                	mov    %esp,%ebp
8010216e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80102171:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80102178:	e8 2e 34 00 00       	call   801055ab <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
8010217d:	8b 45 08             	mov    0x8(%ebp),%eax
80102180:	8b 40 08             	mov    0x8(%eax),%eax
80102183:	83 f8 01             	cmp    $0x1,%eax
80102186:	0f 85 93 00 00 00    	jne    8010221f <iput+0xb4>
8010218c:	8b 45 08             	mov    0x8(%ebp),%eax
8010218f:	8b 40 0c             	mov    0xc(%eax),%eax
80102192:	83 e0 02             	and    $0x2,%eax
80102195:	85 c0                	test   %eax,%eax
80102197:	0f 84 82 00 00 00    	je     8010221f <iput+0xb4>
8010219d:	8b 45 08             	mov    0x8(%ebp),%eax
801021a0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801021a4:	66 85 c0             	test   %ax,%ax
801021a7:	75 76                	jne    8010221f <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
801021a9:	8b 45 08             	mov    0x8(%ebp),%eax
801021ac:	8b 40 0c             	mov    0xc(%eax),%eax
801021af:	83 e0 01             	and    $0x1,%eax
801021b2:	84 c0                	test   %al,%al
801021b4:	74 0c                	je     801021c2 <iput+0x57>
      panic("iput busy");
801021b6:	c7 04 24 38 8e 10 80 	movl   $0x80108e38,(%esp)
801021bd:	e8 7b e3 ff ff       	call   8010053d <panic>
    ip->flags |= I_BUSY;
801021c2:	8b 45 08             	mov    0x8(%ebp),%eax
801021c5:	8b 40 0c             	mov    0xc(%eax),%eax
801021c8:	89 c2                	mov    %eax,%edx
801021ca:	83 ca 01             	or     $0x1,%edx
801021cd:	8b 45 08             	mov    0x8(%ebp),%eax
801021d0:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
801021d3:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
801021da:	e8 2e 34 00 00       	call   8010560d <release>
    itrunc(ip);
801021df:	8b 45 08             	mov    0x8(%ebp),%eax
801021e2:	89 04 24             	mov    %eax,(%esp)
801021e5:	e8 72 01 00 00       	call   8010235c <itrunc>
    ip->type = 0;
801021ea:	8b 45 08             	mov    0x8(%ebp),%eax
801021ed:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
801021f3:	8b 45 08             	mov    0x8(%ebp),%eax
801021f6:	89 04 24             	mov    %eax,(%esp)
801021f9:	e8 fe fb ff ff       	call   80101dfc <iupdate>
    acquire(&icache.lock);
801021fe:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80102205:	e8 a1 33 00 00       	call   801055ab <acquire>
    ip->flags = 0;
8010220a:	8b 45 08             	mov    0x8(%ebp),%eax
8010220d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80102214:	8b 45 08             	mov    0x8(%ebp),%eax
80102217:	89 04 24             	mov    %eax,(%esp)
8010221a:	e8 82 31 00 00       	call   801053a1 <wakeup>
  }
  ip->ref--;
8010221f:	8b 45 08             	mov    0x8(%ebp),%eax
80102222:	8b 40 08             	mov    0x8(%eax),%eax
80102225:	8d 50 ff             	lea    -0x1(%eax),%edx
80102228:	8b 45 08             	mov    0x8(%ebp),%eax
8010222b:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010222e:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80102235:	e8 d3 33 00 00       	call   8010560d <release>
}
8010223a:	c9                   	leave  
8010223b:	c3                   	ret    

8010223c <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
8010223c:	55                   	push   %ebp
8010223d:	89 e5                	mov    %esp,%ebp
8010223f:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80102242:	8b 45 08             	mov    0x8(%ebp),%eax
80102245:	89 04 24             	mov    %eax,(%esp)
80102248:	e8 b9 fe ff ff       	call   80102106 <iunlock>
  iput(ip);
8010224d:	8b 45 08             	mov    0x8(%ebp),%eax
80102250:	89 04 24             	mov    %eax,(%esp)
80102253:	e8 13 ff ff ff       	call   8010216b <iput>
}
80102258:	c9                   	leave  
80102259:	c3                   	ret    

8010225a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
8010225a:	55                   	push   %ebp
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	53                   	push   %ebx
8010225e:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80102261:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80102265:	77 3e                	ja     801022a5 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80102267:	8b 45 08             	mov    0x8(%ebp),%eax
8010226a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010226d:	83 c2 04             	add    $0x4,%edx
80102270:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80102274:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010227b:	75 20                	jne    8010229d <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010227d:	8b 45 08             	mov    0x8(%ebp),%eax
80102280:	8b 00                	mov    (%eax),%eax
80102282:	89 04 24             	mov    %eax,(%esp)
80102285:	e8 49 f8 ff ff       	call   80101ad3 <balloc>
8010228a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010228d:	8b 45 08             	mov    0x8(%ebp),%eax
80102290:	8b 55 0c             	mov    0xc(%ebp),%edx
80102293:	8d 4a 04             	lea    0x4(%edx),%ecx
80102296:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102299:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
8010229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022a0:	e9 b1 00 00 00       	jmp    80102356 <bmap+0xfc>
  }
  bn -= NDIRECT;
801022a5:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
801022a9:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
801022ad:	0f 87 97 00 00 00    	ja     8010234a <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801022b3:	8b 45 08             	mov    0x8(%ebp),%eax
801022b6:	8b 40 4c             	mov    0x4c(%eax),%eax
801022b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801022c0:	75 19                	jne    801022db <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801022c2:	8b 45 08             	mov    0x8(%ebp),%eax
801022c5:	8b 00                	mov    (%eax),%eax
801022c7:	89 04 24             	mov    %eax,(%esp)
801022ca:	e8 04 f8 ff ff       	call   80101ad3 <balloc>
801022cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022d2:	8b 45 08             	mov    0x8(%ebp),%eax
801022d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022d8:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
801022de:	8b 00                	mov    (%eax),%eax
801022e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022e3:	89 54 24 04          	mov    %edx,0x4(%esp)
801022e7:	89 04 24             	mov    %eax,(%esp)
801022ea:	e8 b7 de ff ff       	call   801001a6 <bread>
801022ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
801022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022f5:	83 c0 18             	add    $0x18,%eax
801022f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
801022fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801022fe:	c1 e0 02             	shl    $0x2,%eax
80102301:	03 45 ec             	add    -0x14(%ebp),%eax
80102304:	8b 00                	mov    (%eax),%eax
80102306:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010230d:	75 2b                	jne    8010233a <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
8010230f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102312:	c1 e0 02             	shl    $0x2,%eax
80102315:	89 c3                	mov    %eax,%ebx
80102317:	03 5d ec             	add    -0x14(%ebp),%ebx
8010231a:	8b 45 08             	mov    0x8(%ebp),%eax
8010231d:	8b 00                	mov    (%eax),%eax
8010231f:	89 04 24             	mov    %eax,(%esp)
80102322:	e8 ac f7 ff ff       	call   80101ad3 <balloc>
80102327:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232d:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
8010232f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102332:	89 04 24             	mov    %eax,(%esp)
80102335:	e8 d4 16 00 00       	call   80103a0e <log_write>
    }
    brelse(bp);
8010233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010233d:	89 04 24             	mov    %eax,(%esp)
80102340:	e8 d2 de ff ff       	call   80100217 <brelse>
    return addr;
80102345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102348:	eb 0c                	jmp    80102356 <bmap+0xfc>
  }

  panic("bmap: out of range");
8010234a:	c7 04 24 42 8e 10 80 	movl   $0x80108e42,(%esp)
80102351:	e8 e7 e1 ff ff       	call   8010053d <panic>
}
80102356:	83 c4 24             	add    $0x24,%esp
80102359:	5b                   	pop    %ebx
8010235a:	5d                   	pop    %ebp
8010235b:	c3                   	ret    

8010235c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
8010235c:	55                   	push   %ebp
8010235d:	89 e5                	mov    %esp,%ebp
8010235f:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102362:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102369:	eb 44                	jmp    801023af <itrunc+0x53>
    if(ip->addrs[i]){
8010236b:	8b 45 08             	mov    0x8(%ebp),%eax
8010236e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102371:	83 c2 04             	add    $0x4,%edx
80102374:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	74 2f                	je     801023ab <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
8010237c:	8b 45 08             	mov    0x8(%ebp),%eax
8010237f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102382:	83 c2 04             	add    $0x4,%edx
80102385:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80102389:	8b 45 08             	mov    0x8(%ebp),%eax
8010238c:	8b 00                	mov    (%eax),%eax
8010238e:	89 54 24 04          	mov    %edx,0x4(%esp)
80102392:	89 04 24             	mov    %eax,(%esp)
80102395:	e8 90 f8 ff ff       	call   80101c2a <bfree>
      ip->addrs[i] = 0;
8010239a:	8b 45 08             	mov    0x8(%ebp),%eax
8010239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801023a0:	83 c2 04             	add    $0x4,%edx
801023a3:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
801023aa:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801023ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801023af:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
801023b3:	7e b6                	jle    8010236b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
801023b8:	8b 40 4c             	mov    0x4c(%eax),%eax
801023bb:	85 c0                	test   %eax,%eax
801023bd:	0f 84 8f 00 00 00    	je     80102452 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801023c3:	8b 45 08             	mov    0x8(%ebp),%eax
801023c6:	8b 50 4c             	mov    0x4c(%eax),%edx
801023c9:	8b 45 08             	mov    0x8(%ebp),%eax
801023cc:	8b 00                	mov    (%eax),%eax
801023ce:	89 54 24 04          	mov    %edx,0x4(%esp)
801023d2:	89 04 24             	mov    %eax,(%esp)
801023d5:	e8 cc dd ff ff       	call   801001a6 <bread>
801023da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
801023dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023e0:	83 c0 18             	add    $0x18,%eax
801023e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801023e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801023ed:	eb 2f                	jmp    8010241e <itrunc+0xc2>
      if(a[j])
801023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023f2:	c1 e0 02             	shl    $0x2,%eax
801023f5:	03 45 e8             	add    -0x18(%ebp),%eax
801023f8:	8b 00                	mov    (%eax),%eax
801023fa:	85 c0                	test   %eax,%eax
801023fc:	74 1c                	je     8010241a <itrunc+0xbe>
        bfree(ip->dev, a[j]);
801023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102401:	c1 e0 02             	shl    $0x2,%eax
80102404:	03 45 e8             	add    -0x18(%ebp),%eax
80102407:	8b 10                	mov    (%eax),%edx
80102409:	8b 45 08             	mov    0x8(%ebp),%eax
8010240c:	8b 00                	mov    (%eax),%eax
8010240e:	89 54 24 04          	mov    %edx,0x4(%esp)
80102412:	89 04 24             	mov    %eax,(%esp)
80102415:	e8 10 f8 ff ff       	call   80101c2a <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010241a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102421:	83 f8 7f             	cmp    $0x7f,%eax
80102424:	76 c9                	jbe    801023ef <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80102426:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102429:	89 04 24             	mov    %eax,(%esp)
8010242c:	e8 e6 dd ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102431:	8b 45 08             	mov    0x8(%ebp),%eax
80102434:	8b 50 4c             	mov    0x4c(%eax),%edx
80102437:	8b 45 08             	mov    0x8(%ebp),%eax
8010243a:	8b 00                	mov    (%eax),%eax
8010243c:	89 54 24 04          	mov    %edx,0x4(%esp)
80102440:	89 04 24             	mov    %eax,(%esp)
80102443:	e8 e2 f7 ff ff       	call   80101c2a <bfree>
    ip->addrs[NDIRECT] = 0;
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
8010244b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80102452:	8b 45 08             	mov    0x8(%ebp),%eax
80102455:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
8010245c:	8b 45 08             	mov    0x8(%ebp),%eax
8010245f:	89 04 24             	mov    %eax,(%esp)
80102462:	e8 95 f9 ff ff       	call   80101dfc <iupdate>
}
80102467:	c9                   	leave  
80102468:	c3                   	ret    

80102469 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80102469:	55                   	push   %ebp
8010246a:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
8010246c:	8b 45 08             	mov    0x8(%ebp),%eax
8010246f:	8b 00                	mov    (%eax),%eax
80102471:	89 c2                	mov    %eax,%edx
80102473:	8b 45 0c             	mov    0xc(%ebp),%eax
80102476:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80102479:	8b 45 08             	mov    0x8(%ebp),%eax
8010247c:	8b 50 04             	mov    0x4(%eax),%edx
8010247f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102482:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
80102488:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010248c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010248f:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102492:	8b 45 08             	mov    0x8(%ebp),%eax
80102495:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80102499:	8b 45 0c             	mov    0xc(%ebp),%eax
8010249c:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
801024a0:	8b 45 08             	mov    0x8(%ebp),%eax
801024a3:	8b 50 18             	mov    0x18(%eax),%edx
801024a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801024a9:	89 50 10             	mov    %edx,0x10(%eax)
}
801024ac:	5d                   	pop    %ebp
801024ad:	c3                   	ret    

801024ae <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801024ae:	55                   	push   %ebp
801024af:	89 e5                	mov    %esp,%ebp
801024b1:	53                   	push   %ebx
801024b2:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801024b5:	8b 45 08             	mov    0x8(%ebp),%eax
801024b8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024bc:	66 83 f8 03          	cmp    $0x3,%ax
801024c0:	75 60                	jne    80102522 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801024c2:	8b 45 08             	mov    0x8(%ebp),%eax
801024c5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801024c9:	66 85 c0             	test   %ax,%ax
801024cc:	78 20                	js     801024ee <readi+0x40>
801024ce:	8b 45 08             	mov    0x8(%ebp),%eax
801024d1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801024d5:	66 83 f8 09          	cmp    $0x9,%ax
801024d9:	7f 13                	jg     801024ee <readi+0x40>
801024db:	8b 45 08             	mov    0x8(%ebp),%eax
801024de:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801024e2:	98                   	cwtl   
801024e3:	8b 04 c5 c0 07 11 80 	mov    -0x7feef840(,%eax,8),%eax
801024ea:	85 c0                	test   %eax,%eax
801024ec:	75 0a                	jne    801024f8 <readi+0x4a>
      return -1;
801024ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024f3:	e9 1b 01 00 00       	jmp    80102613 <readi+0x165>
    return devsw[ip->major].read(ip, dst, n);
801024f8:	8b 45 08             	mov    0x8(%ebp),%eax
801024fb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801024ff:	98                   	cwtl   
80102500:	8b 14 c5 c0 07 11 80 	mov    -0x7feef840(,%eax,8),%edx
80102507:	8b 45 14             	mov    0x14(%ebp),%eax
8010250a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010250e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102511:	89 44 24 04          	mov    %eax,0x4(%esp)
80102515:	8b 45 08             	mov    0x8(%ebp),%eax
80102518:	89 04 24             	mov    %eax,(%esp)
8010251b:	ff d2                	call   *%edx
8010251d:	e9 f1 00 00 00       	jmp    80102613 <readi+0x165>
  }

  if(off > ip->size || off + n < off)
80102522:	8b 45 08             	mov    0x8(%ebp),%eax
80102525:	8b 40 18             	mov    0x18(%eax),%eax
80102528:	3b 45 10             	cmp    0x10(%ebp),%eax
8010252b:	72 0d                	jb     8010253a <readi+0x8c>
8010252d:	8b 45 14             	mov    0x14(%ebp),%eax
80102530:	8b 55 10             	mov    0x10(%ebp),%edx
80102533:	01 d0                	add    %edx,%eax
80102535:	3b 45 10             	cmp    0x10(%ebp),%eax
80102538:	73 0a                	jae    80102544 <readi+0x96>
    return -1;
8010253a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010253f:	e9 cf 00 00 00       	jmp    80102613 <readi+0x165>
  if(off + n > ip->size)
80102544:	8b 45 14             	mov    0x14(%ebp),%eax
80102547:	8b 55 10             	mov    0x10(%ebp),%edx
8010254a:	01 c2                	add    %eax,%edx
8010254c:	8b 45 08             	mov    0x8(%ebp),%eax
8010254f:	8b 40 18             	mov    0x18(%eax),%eax
80102552:	39 c2                	cmp    %eax,%edx
80102554:	76 0c                	jbe    80102562 <readi+0xb4>
    n = ip->size - off;
80102556:	8b 45 08             	mov    0x8(%ebp),%eax
80102559:	8b 40 18             	mov    0x18(%eax),%eax
8010255c:	2b 45 10             	sub    0x10(%ebp),%eax
8010255f:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102562:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102569:	e9 96 00 00 00       	jmp    80102604 <readi+0x156>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010256e:	8b 45 10             	mov    0x10(%ebp),%eax
80102571:	c1 e8 09             	shr    $0x9,%eax
80102574:	89 44 24 04          	mov    %eax,0x4(%esp)
80102578:	8b 45 08             	mov    0x8(%ebp),%eax
8010257b:	89 04 24             	mov    %eax,(%esp)
8010257e:	e8 d7 fc ff ff       	call   8010225a <bmap>
80102583:	8b 55 08             	mov    0x8(%ebp),%edx
80102586:	8b 12                	mov    (%edx),%edx
80102588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010258c:	89 14 24             	mov    %edx,(%esp)
8010258f:	e8 12 dc ff ff       	call   801001a6 <bread>
80102594:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102597:	8b 45 10             	mov    0x10(%ebp),%eax
8010259a:	89 c2                	mov    %eax,%edx
8010259c:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801025a2:	b8 00 02 00 00       	mov    $0x200,%eax
801025a7:	89 c1                	mov    %eax,%ecx
801025a9:	29 d1                	sub    %edx,%ecx
801025ab:	89 ca                	mov    %ecx,%edx
801025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
801025b3:	89 cb                	mov    %ecx,%ebx
801025b5:	29 c3                	sub    %eax,%ebx
801025b7:	89 d8                	mov    %ebx,%eax
801025b9:	39 c2                	cmp    %eax,%edx
801025bb:	0f 46 c2             	cmovbe %edx,%eax
801025be:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025c4:	8d 50 18             	lea    0x18(%eax),%edx
801025c7:	8b 45 10             	mov    0x10(%ebp),%eax
801025ca:	25 ff 01 00 00       	and    $0x1ff,%eax
801025cf:	01 c2                	add    %eax,%edx
801025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801025d4:	89 44 24 08          	mov    %eax,0x8(%esp)
801025d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801025dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801025df:	89 04 24             	mov    %eax,(%esp)
801025e2:	e8 e6 32 00 00       	call   801058cd <memmove>
    brelse(bp);
801025e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025ea:	89 04 24             	mov    %eax,(%esp)
801025ed:	e8 25 dc ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801025f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801025f5:	01 45 f4             	add    %eax,-0xc(%ebp)
801025f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801025fb:	01 45 10             	add    %eax,0x10(%ebp)
801025fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102601:	01 45 0c             	add    %eax,0xc(%ebp)
80102604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102607:	3b 45 14             	cmp    0x14(%ebp),%eax
8010260a:	0f 82 5e ff ff ff    	jb     8010256e <readi+0xc0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102610:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102613:	83 c4 24             	add    $0x24,%esp
80102616:	5b                   	pop    %ebx
80102617:	5d                   	pop    %ebp
80102618:	c3                   	ret    

80102619 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102619:	55                   	push   %ebp
8010261a:	89 e5                	mov    %esp,%ebp
8010261c:	53                   	push   %ebx
8010261d:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102620:	8b 45 08             	mov    0x8(%ebp),%eax
80102623:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102627:	66 83 f8 03          	cmp    $0x3,%ax
8010262b:	75 60                	jne    8010268d <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010262d:	8b 45 08             	mov    0x8(%ebp),%eax
80102630:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102634:	66 85 c0             	test   %ax,%ax
80102637:	78 20                	js     80102659 <writei+0x40>
80102639:	8b 45 08             	mov    0x8(%ebp),%eax
8010263c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102640:	66 83 f8 09          	cmp    $0x9,%ax
80102644:	7f 13                	jg     80102659 <writei+0x40>
80102646:	8b 45 08             	mov    0x8(%ebp),%eax
80102649:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010264d:	98                   	cwtl   
8010264e:	8b 04 c5 c4 07 11 80 	mov    -0x7feef83c(,%eax,8),%eax
80102655:	85 c0                	test   %eax,%eax
80102657:	75 0a                	jne    80102663 <writei+0x4a>
      return -1;
80102659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010265e:	e9 46 01 00 00       	jmp    801027a9 <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
80102663:	8b 45 08             	mov    0x8(%ebp),%eax
80102666:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010266a:	98                   	cwtl   
8010266b:	8b 14 c5 c4 07 11 80 	mov    -0x7feef83c(,%eax,8),%edx
80102672:	8b 45 14             	mov    0x14(%ebp),%eax
80102675:	89 44 24 08          	mov    %eax,0x8(%esp)
80102679:	8b 45 0c             	mov    0xc(%ebp),%eax
8010267c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102680:	8b 45 08             	mov    0x8(%ebp),%eax
80102683:	89 04 24             	mov    %eax,(%esp)
80102686:	ff d2                	call   *%edx
80102688:	e9 1c 01 00 00       	jmp    801027a9 <writei+0x190>
  }

  if(off > ip->size || off + n < off)
8010268d:	8b 45 08             	mov    0x8(%ebp),%eax
80102690:	8b 40 18             	mov    0x18(%eax),%eax
80102693:	3b 45 10             	cmp    0x10(%ebp),%eax
80102696:	72 0d                	jb     801026a5 <writei+0x8c>
80102698:	8b 45 14             	mov    0x14(%ebp),%eax
8010269b:	8b 55 10             	mov    0x10(%ebp),%edx
8010269e:	01 d0                	add    %edx,%eax
801026a0:	3b 45 10             	cmp    0x10(%ebp),%eax
801026a3:	73 0a                	jae    801026af <writei+0x96>
    return -1;
801026a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026aa:	e9 fa 00 00 00       	jmp    801027a9 <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
801026af:	8b 45 14             	mov    0x14(%ebp),%eax
801026b2:	8b 55 10             	mov    0x10(%ebp),%edx
801026b5:	01 d0                	add    %edx,%eax
801026b7:	3d 00 18 01 00       	cmp    $0x11800,%eax
801026bc:	76 0a                	jbe    801026c8 <writei+0xaf>
    return -1;
801026be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026c3:	e9 e1 00 00 00       	jmp    801027a9 <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801026c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026cf:	e9 a1 00 00 00       	jmp    80102775 <writei+0x15c>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801026d4:	8b 45 10             	mov    0x10(%ebp),%eax
801026d7:	c1 e8 09             	shr    $0x9,%eax
801026da:	89 44 24 04          	mov    %eax,0x4(%esp)
801026de:	8b 45 08             	mov    0x8(%ebp),%eax
801026e1:	89 04 24             	mov    %eax,(%esp)
801026e4:	e8 71 fb ff ff       	call   8010225a <bmap>
801026e9:	8b 55 08             	mov    0x8(%ebp),%edx
801026ec:	8b 12                	mov    (%edx),%edx
801026ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801026f2:	89 14 24             	mov    %edx,(%esp)
801026f5:	e8 ac da ff ff       	call   801001a6 <bread>
801026fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801026fd:	8b 45 10             	mov    0x10(%ebp),%eax
80102700:	89 c2                	mov    %eax,%edx
80102702:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102708:	b8 00 02 00 00       	mov    $0x200,%eax
8010270d:	89 c1                	mov    %eax,%ecx
8010270f:	29 d1                	sub    %edx,%ecx
80102711:	89 ca                	mov    %ecx,%edx
80102713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102716:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102719:	89 cb                	mov    %ecx,%ebx
8010271b:	29 c3                	sub    %eax,%ebx
8010271d:	89 d8                	mov    %ebx,%eax
8010271f:	39 c2                	cmp    %eax,%edx
80102721:	0f 46 c2             	cmovbe %edx,%eax
80102724:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102727:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010272a:	8d 50 18             	lea    0x18(%eax),%edx
8010272d:	8b 45 10             	mov    0x10(%ebp),%eax
80102730:	25 ff 01 00 00       	and    $0x1ff,%eax
80102735:	01 c2                	add    %eax,%edx
80102737:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010273a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010273e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102741:	89 44 24 04          	mov    %eax,0x4(%esp)
80102745:	89 14 24             	mov    %edx,(%esp)
80102748:	e8 80 31 00 00       	call   801058cd <memmove>
    log_write(bp);
8010274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102750:	89 04 24             	mov    %eax,(%esp)
80102753:	e8 b6 12 00 00       	call   80103a0e <log_write>
    brelse(bp);
80102758:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010275b:	89 04 24             	mov    %eax,(%esp)
8010275e:	e8 b4 da ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102763:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102766:	01 45 f4             	add    %eax,-0xc(%ebp)
80102769:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010276c:	01 45 10             	add    %eax,0x10(%ebp)
8010276f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102772:	01 45 0c             	add    %eax,0xc(%ebp)
80102775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102778:	3b 45 14             	cmp    0x14(%ebp),%eax
8010277b:	0f 82 53 ff ff ff    	jb     801026d4 <writei+0xbb>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102781:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102785:	74 1f                	je     801027a6 <writei+0x18d>
80102787:	8b 45 08             	mov    0x8(%ebp),%eax
8010278a:	8b 40 18             	mov    0x18(%eax),%eax
8010278d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102790:	73 14                	jae    801027a6 <writei+0x18d>
    ip->size = off;
80102792:	8b 45 08             	mov    0x8(%ebp),%eax
80102795:	8b 55 10             	mov    0x10(%ebp),%edx
80102798:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010279b:	8b 45 08             	mov    0x8(%ebp),%eax
8010279e:	89 04 24             	mov    %eax,(%esp)
801027a1:	e8 56 f6 ff ff       	call   80101dfc <iupdate>
  }
  return n;
801027a6:	8b 45 14             	mov    0x14(%ebp),%eax
}
801027a9:	83 c4 24             	add    $0x24,%esp
801027ac:	5b                   	pop    %ebx
801027ad:	5d                   	pop    %ebp
801027ae:	c3                   	ret    

801027af <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801027af:	55                   	push   %ebp
801027b0:	89 e5                	mov    %esp,%ebp
801027b2:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801027b5:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801027bc:	00 
801027bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801027c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c4:	8b 45 08             	mov    0x8(%ebp),%eax
801027c7:	89 04 24             	mov    %eax,(%esp)
801027ca:	e8 a2 31 00 00       	call   80105971 <strncmp>
}
801027cf:	c9                   	leave  
801027d0:	c3                   	ret    

801027d1 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801027d1:	55                   	push   %ebp
801027d2:	89 e5                	mov    %esp,%ebp
801027d4:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801027d7:	8b 45 08             	mov    0x8(%ebp),%eax
801027da:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801027de:	66 83 f8 01          	cmp    $0x1,%ax
801027e2:	74 0c                	je     801027f0 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801027e4:	c7 04 24 55 8e 10 80 	movl   $0x80108e55,(%esp)
801027eb:	e8 4d dd ff ff       	call   8010053d <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801027f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027f7:	e9 87 00 00 00       	jmp    80102883 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801027fc:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102803:	00 
80102804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102807:	89 44 24 08          	mov    %eax,0x8(%esp)
8010280b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010280e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102812:	8b 45 08             	mov    0x8(%ebp),%eax
80102815:	89 04 24             	mov    %eax,(%esp)
80102818:	e8 91 fc ff ff       	call   801024ae <readi>
8010281d:	83 f8 10             	cmp    $0x10,%eax
80102820:	74 0c                	je     8010282e <dirlookup+0x5d>
      panic("dirlink read");
80102822:	c7 04 24 67 8e 10 80 	movl   $0x80108e67,(%esp)
80102829:	e8 0f dd ff ff       	call   8010053d <panic>
    if(de.inum == 0)
8010282e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102832:	66 85 c0             	test   %ax,%ax
80102835:	74 47                	je     8010287e <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
80102837:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010283a:	83 c0 02             	add    $0x2,%eax
8010283d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102841:	8b 45 0c             	mov    0xc(%ebp),%eax
80102844:	89 04 24             	mov    %eax,(%esp)
80102847:	e8 63 ff ff ff       	call   801027af <namecmp>
8010284c:	85 c0                	test   %eax,%eax
8010284e:	75 2f                	jne    8010287f <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102850:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102854:	74 08                	je     8010285e <dirlookup+0x8d>
        *poff = off;
80102856:	8b 45 10             	mov    0x10(%ebp),%eax
80102859:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010285c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010285e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102862:	0f b7 c0             	movzwl %ax,%eax
80102865:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102868:	8b 45 08             	mov    0x8(%ebp),%eax
8010286b:	8b 00                	mov    (%eax),%eax
8010286d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102870:	89 54 24 04          	mov    %edx,0x4(%esp)
80102874:	89 04 24             	mov    %eax,(%esp)
80102877:	e8 38 f6 ff ff       	call   80101eb4 <iget>
8010287c:	eb 19                	jmp    80102897 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010287e:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010287f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102883:	8b 45 08             	mov    0x8(%ebp),%eax
80102886:	8b 40 18             	mov    0x18(%eax),%eax
80102889:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010288c:	0f 87 6a ff ff ff    	ja     801027fc <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102892:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102897:	c9                   	leave  
80102898:	c3                   	ret    

80102899 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102899:	55                   	push   %ebp
8010289a:	89 e5                	mov    %esp,%ebp
8010289c:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010289f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801028a6:	00 
801028a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801028aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801028ae:	8b 45 08             	mov    0x8(%ebp),%eax
801028b1:	89 04 24             	mov    %eax,(%esp)
801028b4:	e8 18 ff ff ff       	call   801027d1 <dirlookup>
801028b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801028bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801028c0:	74 15                	je     801028d7 <dirlink+0x3e>
    iput(ip);
801028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028c5:	89 04 24             	mov    %eax,(%esp)
801028c8:	e8 9e f8 ff ff       	call   8010216b <iput>
    return -1;
801028cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801028d2:	e9 b8 00 00 00       	jmp    8010298f <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801028d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801028de:	eb 44                	jmp    80102924 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e3:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801028ea:	00 
801028eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801028ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
801028f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801028f6:	8b 45 08             	mov    0x8(%ebp),%eax
801028f9:	89 04 24             	mov    %eax,(%esp)
801028fc:	e8 ad fb ff ff       	call   801024ae <readi>
80102901:	83 f8 10             	cmp    $0x10,%eax
80102904:	74 0c                	je     80102912 <dirlink+0x79>
      panic("dirlink read");
80102906:	c7 04 24 67 8e 10 80 	movl   $0x80108e67,(%esp)
8010290d:	e8 2b dc ff ff       	call   8010053d <panic>
    if(de.inum == 0)
80102912:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102916:	66 85 c0             	test   %ax,%ax
80102919:	74 18                	je     80102933 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291e:	83 c0 10             	add    $0x10,%eax
80102921:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102924:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102927:	8b 45 08             	mov    0x8(%ebp),%eax
8010292a:	8b 40 18             	mov    0x18(%eax),%eax
8010292d:	39 c2                	cmp    %eax,%edx
8010292f:	72 af                	jb     801028e0 <dirlink+0x47>
80102931:	eb 01                	jmp    80102934 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102933:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102934:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010293b:	00 
8010293c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010293f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102943:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102946:	83 c0 02             	add    $0x2,%eax
80102949:	89 04 24             	mov    %eax,(%esp)
8010294c:	e8 78 30 00 00       	call   801059c9 <strncpy>
  de.inum = inum;
80102951:	8b 45 10             	mov    0x10(%ebp),%eax
80102954:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102962:	00 
80102963:	89 44 24 08          	mov    %eax,0x8(%esp)
80102967:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010296a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010296e:	8b 45 08             	mov    0x8(%ebp),%eax
80102971:	89 04 24             	mov    %eax,(%esp)
80102974:	e8 a0 fc ff ff       	call   80102619 <writei>
80102979:	83 f8 10             	cmp    $0x10,%eax
8010297c:	74 0c                	je     8010298a <dirlink+0xf1>
    panic("dirlink");
8010297e:	c7 04 24 74 8e 10 80 	movl   $0x80108e74,(%esp)
80102985:	e8 b3 db ff ff       	call   8010053d <panic>
  
  return 0;
8010298a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010298f:	c9                   	leave  
80102990:	c3                   	ret    

80102991 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102991:	55                   	push   %ebp
80102992:	89 e5                	mov    %esp,%ebp
80102994:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102997:	eb 04                	jmp    8010299d <skipelem+0xc>
    path++;
80102999:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010299d:	8b 45 08             	mov    0x8(%ebp),%eax
801029a0:	0f b6 00             	movzbl (%eax),%eax
801029a3:	3c 2f                	cmp    $0x2f,%al
801029a5:	74 f2                	je     80102999 <skipelem+0x8>
    path++;
  if(*path == 0)
801029a7:	8b 45 08             	mov    0x8(%ebp),%eax
801029aa:	0f b6 00             	movzbl (%eax),%eax
801029ad:	84 c0                	test   %al,%al
801029af:	75 0a                	jne    801029bb <skipelem+0x2a>
    return 0;
801029b1:	b8 00 00 00 00       	mov    $0x0,%eax
801029b6:	e9 86 00 00 00       	jmp    80102a41 <skipelem+0xb0>
  s = path;
801029bb:	8b 45 08             	mov    0x8(%ebp),%eax
801029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801029c1:	eb 04                	jmp    801029c7 <skipelem+0x36>
    path++;
801029c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801029c7:	8b 45 08             	mov    0x8(%ebp),%eax
801029ca:	0f b6 00             	movzbl (%eax),%eax
801029cd:	3c 2f                	cmp    $0x2f,%al
801029cf:	74 0a                	je     801029db <skipelem+0x4a>
801029d1:	8b 45 08             	mov    0x8(%ebp),%eax
801029d4:	0f b6 00             	movzbl (%eax),%eax
801029d7:	84 c0                	test   %al,%al
801029d9:	75 e8                	jne    801029c3 <skipelem+0x32>
    path++;
  len = path - s;
801029db:	8b 55 08             	mov    0x8(%ebp),%edx
801029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e1:	89 d1                	mov    %edx,%ecx
801029e3:	29 c1                	sub    %eax,%ecx
801029e5:	89 c8                	mov    %ecx,%eax
801029e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801029ea:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801029ee:	7e 1c                	jle    80102a0c <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801029f0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801029f7:	00 
801029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a02:	89 04 24             	mov    %eax,(%esp)
80102a05:	e8 c3 2e 00 00       	call   801058cd <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102a0a:	eb 28                	jmp    80102a34 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a0f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a16:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a1d:	89 04 24             	mov    %eax,(%esp)
80102a20:	e8 a8 2e 00 00       	call   801058cd <memmove>
    name[len] = 0;
80102a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a28:	03 45 0c             	add    0xc(%ebp),%eax
80102a2b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102a2e:	eb 04                	jmp    80102a34 <skipelem+0xa3>
    path++;
80102a30:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102a34:	8b 45 08             	mov    0x8(%ebp),%eax
80102a37:	0f b6 00             	movzbl (%eax),%eax
80102a3a:	3c 2f                	cmp    $0x2f,%al
80102a3c:	74 f2                	je     80102a30 <skipelem+0x9f>
    path++;
  return path;
80102a3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102a41:	c9                   	leave  
80102a42:	c3                   	ret    

80102a43 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102a43:	55                   	push   %ebp
80102a44:	89 e5                	mov    %esp,%ebp
80102a46:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102a49:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4c:	0f b6 00             	movzbl (%eax),%eax
80102a4f:	3c 2f                	cmp    $0x2f,%al
80102a51:	75 1c                	jne    80102a6f <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102a53:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a5a:	00 
80102a5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a62:	e8 4d f4 ff ff       	call   80101eb4 <iget>
80102a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102a6a:	e9 af 00 00 00       	jmp    80102b1e <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102a6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102a75:	8b 40 68             	mov    0x68(%eax),%eax
80102a78:	89 04 24             	mov    %eax,(%esp)
80102a7b:	e8 06 f5 ff ff       	call   80101f86 <idup>
80102a80:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102a83:	e9 96 00 00 00       	jmp    80102b1e <namex+0xdb>
    ilock(ip);
80102a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a8b:	89 04 24             	mov    %eax,(%esp)
80102a8e:	e8 25 f5 ff ff       	call   80101fb8 <ilock>
    if(ip->type != T_DIR){
80102a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a96:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102a9a:	66 83 f8 01          	cmp    $0x1,%ax
80102a9e:	74 15                	je     80102ab5 <namex+0x72>
      iunlockput(ip);
80102aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa3:	89 04 24             	mov    %eax,(%esp)
80102aa6:	e8 91 f7 ff ff       	call   8010223c <iunlockput>
      return 0;
80102aab:	b8 00 00 00 00       	mov    $0x0,%eax
80102ab0:	e9 a3 00 00 00       	jmp    80102b58 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102ab5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102ab9:	74 1d                	je     80102ad8 <namex+0x95>
80102abb:	8b 45 08             	mov    0x8(%ebp),%eax
80102abe:	0f b6 00             	movzbl (%eax),%eax
80102ac1:	84 c0                	test   %al,%al
80102ac3:	75 13                	jne    80102ad8 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac8:	89 04 24             	mov    %eax,(%esp)
80102acb:	e8 36 f6 ff ff       	call   80102106 <iunlock>
      return ip;
80102ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad3:	e9 80 00 00 00       	jmp    80102b58 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102ad8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102adf:	00 
80102ae0:	8b 45 10             	mov    0x10(%ebp),%eax
80102ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aea:	89 04 24             	mov    %eax,(%esp)
80102aed:	e8 df fc ff ff       	call   801027d1 <dirlookup>
80102af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102af5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102af9:	75 12                	jne    80102b0d <namex+0xca>
      iunlockput(ip);
80102afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afe:	89 04 24             	mov    %eax,(%esp)
80102b01:	e8 36 f7 ff ff       	call   8010223c <iunlockput>
      return 0;
80102b06:	b8 00 00 00 00       	mov    $0x0,%eax
80102b0b:	eb 4b                	jmp    80102b58 <namex+0x115>
    }
    iunlockput(ip);
80102b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b10:	89 04 24             	mov    %eax,(%esp)
80102b13:	e8 24 f7 ff ff       	call   8010223c <iunlockput>
    ip = next;
80102b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102b1e:	8b 45 10             	mov    0x10(%ebp),%eax
80102b21:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b25:	8b 45 08             	mov    0x8(%ebp),%eax
80102b28:	89 04 24             	mov    %eax,(%esp)
80102b2b:	e8 61 fe ff ff       	call   80102991 <skipelem>
80102b30:	89 45 08             	mov    %eax,0x8(%ebp)
80102b33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102b37:	0f 85 4b ff ff ff    	jne    80102a88 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102b3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102b41:	74 12                	je     80102b55 <namex+0x112>
    iput(ip);
80102b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b46:	89 04 24             	mov    %eax,(%esp)
80102b49:	e8 1d f6 ff ff       	call   8010216b <iput>
    return 0;
80102b4e:	b8 00 00 00 00       	mov    $0x0,%eax
80102b53:	eb 03                	jmp    80102b58 <namex+0x115>
  }
  return ip;
80102b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b58:	c9                   	leave  
80102b59:	c3                   	ret    

80102b5a <namei>:

struct inode*
namei(char *path)
{
80102b5a:	55                   	push   %ebp
80102b5b:	89 e5                	mov    %esp,%ebp
80102b5d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102b60:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102b63:	89 44 24 08          	mov    %eax,0x8(%esp)
80102b67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102b6e:	00 
80102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b72:	89 04 24             	mov    %eax,(%esp)
80102b75:	e8 c9 fe ff ff       	call   80102a43 <namex>
}
80102b7a:	c9                   	leave  
80102b7b:	c3                   	ret    

80102b7c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102b7c:	55                   	push   %ebp
80102b7d:	89 e5                	mov    %esp,%ebp
80102b7f:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102b82:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b85:	89 44 24 08          	mov    %eax,0x8(%esp)
80102b89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b90:	00 
80102b91:	8b 45 08             	mov    0x8(%ebp),%eax
80102b94:	89 04 24             	mov    %eax,(%esp)
80102b97:	e8 a7 fe ff ff       	call   80102a43 <namex>
}
80102b9c:	c9                   	leave  
80102b9d:	c3                   	ret    
	...

80102ba0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	53                   	push   %ebx
80102ba4:	83 ec 14             	sub    $0x14,%esp
80102ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80102baa:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bae:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102bb2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102bb6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80102bba:	ec                   	in     (%dx),%al
80102bbb:	89 c3                	mov    %eax,%ebx
80102bbd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102bc0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102bc4:	83 c4 14             	add    $0x14,%esp
80102bc7:	5b                   	pop    %ebx
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    

80102bca <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102bca:	55                   	push   %ebp
80102bcb:	89 e5                	mov    %esp,%ebp
80102bcd:	57                   	push   %edi
80102bce:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102bcf:	8b 55 08             	mov    0x8(%ebp),%edx
80102bd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bd5:	8b 45 10             	mov    0x10(%ebp),%eax
80102bd8:	89 cb                	mov    %ecx,%ebx
80102bda:	89 df                	mov    %ebx,%edi
80102bdc:	89 c1                	mov    %eax,%ecx
80102bde:	fc                   	cld    
80102bdf:	f3 6d                	rep insl (%dx),%es:(%edi)
80102be1:	89 c8                	mov    %ecx,%eax
80102be3:	89 fb                	mov    %edi,%ebx
80102be5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102be8:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102beb:	5b                   	pop    %ebx
80102bec:	5f                   	pop    %edi
80102bed:	5d                   	pop    %ebp
80102bee:	c3                   	ret    

80102bef <outb>:

static inline void
outb(ushort port, uchar data)
{
80102bef:	55                   	push   %ebp
80102bf0:	89 e5                	mov    %esp,%ebp
80102bf2:	83 ec 08             	sub    $0x8,%esp
80102bf5:	8b 55 08             	mov    0x8(%ebp),%edx
80102bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bfb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102bff:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c02:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102c06:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102c0a:	ee                   	out    %al,(%dx)
}
80102c0b:	c9                   	leave  
80102c0c:	c3                   	ret    

80102c0d <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102c0d:	55                   	push   %ebp
80102c0e:	89 e5                	mov    %esp,%ebp
80102c10:	56                   	push   %esi
80102c11:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102c12:	8b 55 08             	mov    0x8(%ebp),%edx
80102c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c18:	8b 45 10             	mov    0x10(%ebp),%eax
80102c1b:	89 cb                	mov    %ecx,%ebx
80102c1d:	89 de                	mov    %ebx,%esi
80102c1f:	89 c1                	mov    %eax,%ecx
80102c21:	fc                   	cld    
80102c22:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102c24:	89 c8                	mov    %ecx,%eax
80102c26:	89 f3                	mov    %esi,%ebx
80102c28:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102c2b:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102c2e:	5b                   	pop    %ebx
80102c2f:	5e                   	pop    %esi
80102c30:	5d                   	pop    %ebp
80102c31:	c3                   	ret    

80102c32 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102c32:	55                   	push   %ebp
80102c33:	89 e5                	mov    %esp,%ebp
80102c35:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102c38:	90                   	nop
80102c39:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102c40:	e8 5b ff ff ff       	call   80102ba0 <inb>
80102c45:	0f b6 c0             	movzbl %al,%eax
80102c48:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102c4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4e:	25 c0 00 00 00       	and    $0xc0,%eax
80102c53:	83 f8 40             	cmp    $0x40,%eax
80102c56:	75 e1                	jne    80102c39 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102c5c:	74 11                	je     80102c6f <idewait+0x3d>
80102c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c61:	83 e0 21             	and    $0x21,%eax
80102c64:	85 c0                	test   %eax,%eax
80102c66:	74 07                	je     80102c6f <idewait+0x3d>
    return -1;
80102c68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c6d:	eb 05                	jmp    80102c74 <idewait+0x42>
  return 0;
80102c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102c74:	c9                   	leave  
80102c75:	c3                   	ret    

80102c76 <ideinit>:

void
ideinit(void)
{
80102c76:	55                   	push   %ebp
80102c77:	89 e5                	mov    %esp,%ebp
80102c79:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102c7c:	c7 44 24 04 7c 8e 10 	movl   $0x80108e7c,0x4(%esp)
80102c83:	80 
80102c84:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
80102c8b:	e8 fa 28 00 00       	call   8010558a <initlock>
  picenable(IRQ_IDE);
80102c90:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102c97:	e8 75 15 00 00       	call   80104211 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102c9c:	a1 c0 1e 11 80       	mov    0x80111ec0,%eax
80102ca1:	83 e8 01             	sub    $0x1,%eax
80102ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ca8:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102caf:	e8 12 04 00 00       	call   801030c6 <ioapicenable>
  idewait(0);
80102cb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102cbb:	e8 72 ff ff ff       	call   80102c32 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102cc0:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102cc7:	00 
80102cc8:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102ccf:	e8 1b ff ff ff       	call   80102bef <outb>
  for(i=0; i<1000; i++){
80102cd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102cdb:	eb 20                	jmp    80102cfd <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102cdd:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102ce4:	e8 b7 fe ff ff       	call   80102ba0 <inb>
80102ce9:	84 c0                	test   %al,%al
80102ceb:	74 0c                	je     80102cf9 <ideinit+0x83>
      havedisk1 = 1;
80102ced:	c7 05 f8 d5 10 80 01 	movl   $0x1,0x8010d5f8
80102cf4:	00 00 00 
      break;
80102cf7:	eb 0d                	jmp    80102d06 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102cf9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102cfd:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102d04:	7e d7                	jle    80102cdd <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102d06:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102d0d:	00 
80102d0e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102d15:	e8 d5 fe ff ff       	call   80102bef <outb>
}
80102d1a:	c9                   	leave  
80102d1b:	c3                   	ret    

80102d1c <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102d1c:	55                   	push   %ebp
80102d1d:	89 e5                	mov    %esp,%ebp
80102d1f:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102d22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102d26:	75 0c                	jne    80102d34 <idestart+0x18>
    panic("idestart");
80102d28:	c7 04 24 80 8e 10 80 	movl   $0x80108e80,(%esp)
80102d2f:	e8 09 d8 ff ff       	call   8010053d <panic>

  idewait(0);
80102d34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102d3b:	e8 f2 fe ff ff       	call   80102c32 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102d40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102d47:	00 
80102d48:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102d4f:	e8 9b fe ff ff       	call   80102bef <outb>
  outb(0x1f2, 1);  // number of sectors
80102d54:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102d5b:	00 
80102d5c:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102d63:	e8 87 fe ff ff       	call   80102bef <outb>
  outb(0x1f3, b->sector & 0xff);
80102d68:	8b 45 08             	mov    0x8(%ebp),%eax
80102d6b:	8b 40 08             	mov    0x8(%eax),%eax
80102d6e:	0f b6 c0             	movzbl %al,%eax
80102d71:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d75:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102d7c:	e8 6e fe ff ff       	call   80102bef <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102d81:	8b 45 08             	mov    0x8(%ebp),%eax
80102d84:	8b 40 08             	mov    0x8(%eax),%eax
80102d87:	c1 e8 08             	shr    $0x8,%eax
80102d8a:	0f b6 c0             	movzbl %al,%eax
80102d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d91:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102d98:	e8 52 fe ff ff       	call   80102bef <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80102da0:	8b 40 08             	mov    0x8(%eax),%eax
80102da3:	c1 e8 10             	shr    $0x10,%eax
80102da6:	0f b6 c0             	movzbl %al,%eax
80102da9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102dad:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102db4:	e8 36 fe ff ff       	call   80102bef <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102db9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dbc:	8b 40 04             	mov    0x4(%eax),%eax
80102dbf:	83 e0 01             	and    $0x1,%eax
80102dc2:	89 c2                	mov    %eax,%edx
80102dc4:	c1 e2 04             	shl    $0x4,%edx
80102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80102dca:	8b 40 08             	mov    0x8(%eax),%eax
80102dcd:	c1 e8 18             	shr    $0x18,%eax
80102dd0:	83 e0 0f             	and    $0xf,%eax
80102dd3:	09 d0                	or     %edx,%eax
80102dd5:	83 c8 e0             	or     $0xffffffe0,%eax
80102dd8:	0f b6 c0             	movzbl %al,%eax
80102ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ddf:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102de6:	e8 04 fe ff ff       	call   80102bef <outb>
  if(b->flags & B_DIRTY){
80102deb:	8b 45 08             	mov    0x8(%ebp),%eax
80102dee:	8b 00                	mov    (%eax),%eax
80102df0:	83 e0 04             	and    $0x4,%eax
80102df3:	85 c0                	test   %eax,%eax
80102df5:	74 34                	je     80102e2b <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102df7:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80102dfe:	00 
80102dff:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102e06:	e8 e4 fd ff ff       	call   80102bef <outb>
    outsl(0x1f0, b->data, 512/4);
80102e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0e:	83 c0 18             	add    $0x18,%eax
80102e11:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102e18:	00 
80102e19:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e1d:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102e24:	e8 e4 fd ff ff       	call   80102c0d <outsl>
80102e29:	eb 14                	jmp    80102e3f <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102e2b:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102e32:	00 
80102e33:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102e3a:	e8 b0 fd ff ff       	call   80102bef <outb>
  }
}
80102e3f:	c9                   	leave  
80102e40:	c3                   	ret    

80102e41 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102e41:	55                   	push   %ebp
80102e42:	89 e5                	mov    %esp,%ebp
80102e44:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102e47:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
80102e4e:	e8 58 27 00 00       	call   801055ab <acquire>
  if((b = idequeue) == 0){
80102e53:	a1 f4 d5 10 80       	mov    0x8010d5f4,%eax
80102e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e5f:	75 11                	jne    80102e72 <ideintr+0x31>
    release(&idelock);
80102e61:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
80102e68:	e8 a0 27 00 00       	call   8010560d <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102e6d:	e9 90 00 00 00       	jmp    80102f02 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e75:	8b 40 14             	mov    0x14(%eax),%eax
80102e78:	a3 f4 d5 10 80       	mov    %eax,0x8010d5f4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e80:	8b 00                	mov    (%eax),%eax
80102e82:	83 e0 04             	and    $0x4,%eax
80102e85:	85 c0                	test   %eax,%eax
80102e87:	75 2e                	jne    80102eb7 <ideintr+0x76>
80102e89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102e90:	e8 9d fd ff ff       	call   80102c32 <idewait>
80102e95:	85 c0                	test   %eax,%eax
80102e97:	78 1e                	js     80102eb7 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e9c:	83 c0 18             	add    $0x18,%eax
80102e9f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102ea6:	00 
80102ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eab:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102eb2:	e8 13 fd ff ff       	call   80102bca <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eba:	8b 00                	mov    (%eax),%eax
80102ebc:	89 c2                	mov    %eax,%edx
80102ebe:	83 ca 02             	or     $0x2,%edx
80102ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ec4:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ec9:	8b 00                	mov    (%eax),%eax
80102ecb:	89 c2                	mov    %eax,%edx
80102ecd:	83 e2 fb             	and    $0xfffffffb,%edx
80102ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ed3:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ed8:	89 04 24             	mov    %eax,(%esp)
80102edb:	e8 c1 24 00 00       	call   801053a1 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ee0:	a1 f4 d5 10 80       	mov    0x8010d5f4,%eax
80102ee5:	85 c0                	test   %eax,%eax
80102ee7:	74 0d                	je     80102ef6 <ideintr+0xb5>
    idestart(idequeue);
80102ee9:	a1 f4 d5 10 80       	mov    0x8010d5f4,%eax
80102eee:	89 04 24             	mov    %eax,(%esp)
80102ef1:	e8 26 fe ff ff       	call   80102d1c <idestart>

  release(&idelock);
80102ef6:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
80102efd:	e8 0b 27 00 00       	call   8010560d <release>
}
80102f02:	c9                   	leave  
80102f03:	c3                   	ret    

80102f04 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102f04:	55                   	push   %ebp
80102f05:	89 e5                	mov    %esp,%ebp
80102f07:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80102f0d:	8b 00                	mov    (%eax),%eax
80102f0f:	83 e0 01             	and    $0x1,%eax
80102f12:	85 c0                	test   %eax,%eax
80102f14:	75 0c                	jne    80102f22 <iderw+0x1e>
    panic("iderw: buf not busy");
80102f16:	c7 04 24 89 8e 10 80 	movl   $0x80108e89,(%esp)
80102f1d:	e8 1b d6 ff ff       	call   8010053d <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102f22:	8b 45 08             	mov    0x8(%ebp),%eax
80102f25:	8b 00                	mov    (%eax),%eax
80102f27:	83 e0 06             	and    $0x6,%eax
80102f2a:	83 f8 02             	cmp    $0x2,%eax
80102f2d:	75 0c                	jne    80102f3b <iderw+0x37>
    panic("iderw: nothing to do");
80102f2f:	c7 04 24 9d 8e 10 80 	movl   $0x80108e9d,(%esp)
80102f36:	e8 02 d6 ff ff       	call   8010053d <panic>
  if(b->dev != 0 && !havedisk1)
80102f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102f3e:	8b 40 04             	mov    0x4(%eax),%eax
80102f41:	85 c0                	test   %eax,%eax
80102f43:	74 15                	je     80102f5a <iderw+0x56>
80102f45:	a1 f8 d5 10 80       	mov    0x8010d5f8,%eax
80102f4a:	85 c0                	test   %eax,%eax
80102f4c:	75 0c                	jne    80102f5a <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102f4e:	c7 04 24 b2 8e 10 80 	movl   $0x80108eb2,(%esp)
80102f55:	e8 e3 d5 ff ff       	call   8010053d <panic>

  acquire(&idelock);  //DOC: acquire-lock
80102f5a:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
80102f61:	e8 45 26 00 00       	call   801055ab <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102f66:	8b 45 08             	mov    0x8(%ebp),%eax
80102f69:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
80102f70:	c7 45 f4 f4 d5 10 80 	movl   $0x8010d5f4,-0xc(%ebp)
80102f77:	eb 0b                	jmp    80102f84 <iderw+0x80>
80102f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f7c:	8b 00                	mov    (%eax),%eax
80102f7e:	83 c0 14             	add    $0x14,%eax
80102f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f87:	8b 00                	mov    (%eax),%eax
80102f89:	85 c0                	test   %eax,%eax
80102f8b:	75 ec                	jne    80102f79 <iderw+0x75>
    ;
  *pp = b;
80102f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f90:	8b 55 08             	mov    0x8(%ebp),%edx
80102f93:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102f95:	a1 f4 d5 10 80       	mov    0x8010d5f4,%eax
80102f9a:	3b 45 08             	cmp    0x8(%ebp),%eax
80102f9d:	75 22                	jne    80102fc1 <iderw+0xbd>
    idestart(b);
80102f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102fa2:	89 04 24             	mov    %eax,(%esp)
80102fa5:	e8 72 fd ff ff       	call   80102d1c <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102faa:	eb 15                	jmp    80102fc1 <iderw+0xbd>
    sleep(b, &idelock);
80102fac:	c7 44 24 04 c0 d5 10 	movl   $0x8010d5c0,0x4(%esp)
80102fb3:	80 
80102fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80102fb7:	89 04 24             	mov    %eax,(%esp)
80102fba:	e8 74 22 00 00       	call   80105233 <sleep>
80102fbf:	eb 01                	jmp    80102fc2 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102fc1:	90                   	nop
80102fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80102fc5:	8b 00                	mov    (%eax),%eax
80102fc7:	83 e0 06             	and    $0x6,%eax
80102fca:	83 f8 02             	cmp    $0x2,%eax
80102fcd:	75 dd                	jne    80102fac <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
80102fcf:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
80102fd6:	e8 32 26 00 00       	call   8010560d <release>
}
80102fdb:	c9                   	leave  
80102fdc:	c3                   	ret    
80102fdd:	00 00                	add    %al,(%eax)
	...

80102fe0 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102fe3:	a1 f4 17 11 80       	mov    0x801117f4,%eax
80102fe8:	8b 55 08             	mov    0x8(%ebp),%edx
80102feb:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102fed:	a1 f4 17 11 80       	mov    0x801117f4,%eax
80102ff2:	8b 40 10             	mov    0x10(%eax),%eax
}
80102ff5:	5d                   	pop    %ebp
80102ff6:	c3                   	ret    

80102ff7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102ff7:	55                   	push   %ebp
80102ff8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ffa:	a1 f4 17 11 80       	mov    0x801117f4,%eax
80102fff:	8b 55 08             	mov    0x8(%ebp),%edx
80103002:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80103004:	a1 f4 17 11 80       	mov    0x801117f4,%eax
80103009:	8b 55 0c             	mov    0xc(%ebp),%edx
8010300c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010300f:	5d                   	pop    %ebp
80103010:	c3                   	ret    

80103011 <ioapicinit>:

void
ioapicinit(void)
{
80103011:	55                   	push   %ebp
80103012:	89 e5                	mov    %esp,%ebp
80103014:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80103017:	a1 c4 18 11 80       	mov    0x801118c4,%eax
8010301c:	85 c0                	test   %eax,%eax
8010301e:	0f 84 9f 00 00 00    	je     801030c3 <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80103024:	c7 05 f4 17 11 80 00 	movl   $0xfec00000,0x801117f4
8010302b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010302e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103035:	e8 a6 ff ff ff       	call   80102fe0 <ioapicread>
8010303a:	c1 e8 10             	shr    $0x10,%eax
8010303d:	25 ff 00 00 00       	and    $0xff,%eax
80103042:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80103045:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010304c:	e8 8f ff ff ff       	call   80102fe0 <ioapicread>
80103051:	c1 e8 18             	shr    $0x18,%eax
80103054:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80103057:	0f b6 05 c0 18 11 80 	movzbl 0x801118c0,%eax
8010305e:	0f b6 c0             	movzbl %al,%eax
80103061:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103064:	74 0c                	je     80103072 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103066:	c7 04 24 d0 8e 10 80 	movl   $0x80108ed0,(%esp)
8010306d:	e8 2f d3 ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80103072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103079:	eb 3e                	jmp    801030b9 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010307e:	83 c0 20             	add    $0x20,%eax
80103081:	0d 00 00 01 00       	or     $0x10000,%eax
80103086:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103089:	83 c2 08             	add    $0x8,%edx
8010308c:	01 d2                	add    %edx,%edx
8010308e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103092:	89 14 24             	mov    %edx,(%esp)
80103095:	e8 5d ff ff ff       	call   80102ff7 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010309d:	83 c0 08             	add    $0x8,%eax
801030a0:	01 c0                	add    %eax,%eax
801030a2:	83 c0 01             	add    $0x1,%eax
801030a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030ac:	00 
801030ad:	89 04 24             	mov    %eax,(%esp)
801030b0:	e8 42 ff ff ff       	call   80102ff7 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801030b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801030bf:	7e ba                	jle    8010307b <ioapicinit+0x6a>
801030c1:	eb 01                	jmp    801030c4 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801030c3:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801030c4:	c9                   	leave  
801030c5:	c3                   	ret    

801030c6 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801030c6:	55                   	push   %ebp
801030c7:	89 e5                	mov    %esp,%ebp
801030c9:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801030cc:	a1 c4 18 11 80       	mov    0x801118c4,%eax
801030d1:	85 c0                	test   %eax,%eax
801030d3:	74 39                	je     8010310e <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801030d5:	8b 45 08             	mov    0x8(%ebp),%eax
801030d8:	83 c0 20             	add    $0x20,%eax
801030db:	8b 55 08             	mov    0x8(%ebp),%edx
801030de:	83 c2 08             	add    $0x8,%edx
801030e1:	01 d2                	add    %edx,%edx
801030e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801030e7:	89 14 24             	mov    %edx,(%esp)
801030ea:	e8 08 ff ff ff       	call   80102ff7 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801030ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801030f2:	c1 e0 18             	shl    $0x18,%eax
801030f5:	8b 55 08             	mov    0x8(%ebp),%edx
801030f8:	83 c2 08             	add    $0x8,%edx
801030fb:	01 d2                	add    %edx,%edx
801030fd:	83 c2 01             	add    $0x1,%edx
80103100:	89 44 24 04          	mov    %eax,0x4(%esp)
80103104:	89 14 24             	mov    %edx,(%esp)
80103107:	e8 eb fe ff ff       	call   80102ff7 <ioapicwrite>
8010310c:	eb 01                	jmp    8010310f <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
8010310e:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
8010310f:	c9                   	leave  
80103110:	c3                   	ret    
80103111:	00 00                	add    %al,(%eax)
	...

80103114 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80103114:	55                   	push   %ebp
80103115:	89 e5                	mov    %esp,%ebp
80103117:	8b 45 08             	mov    0x8(%ebp),%eax
8010311a:	05 00 00 00 80       	add    $0x80000000,%eax
8010311f:	5d                   	pop    %ebp
80103120:	c3                   	ret    

80103121 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80103121:	55                   	push   %ebp
80103122:	89 e5                	mov    %esp,%ebp
80103124:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80103127:	c7 44 24 04 02 8f 10 	movl   $0x80108f02,0x4(%esp)
8010312e:	80 
8010312f:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
80103136:	e8 4f 24 00 00       	call   8010558a <initlock>
  kmem.use_lock = 0;
8010313b:	c7 05 34 18 11 80 00 	movl   $0x0,0x80111834
80103142:	00 00 00 
  freerange(vstart, vend);
80103145:	8b 45 0c             	mov    0xc(%ebp),%eax
80103148:	89 44 24 04          	mov    %eax,0x4(%esp)
8010314c:	8b 45 08             	mov    0x8(%ebp),%eax
8010314f:	89 04 24             	mov    %eax,(%esp)
80103152:	e8 26 00 00 00       	call   8010317d <freerange>
}
80103157:	c9                   	leave  
80103158:	c3                   	ret    

80103159 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80103159:	55                   	push   %ebp
8010315a:	89 e5                	mov    %esp,%ebp
8010315c:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
8010315f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103162:	89 44 24 04          	mov    %eax,0x4(%esp)
80103166:	8b 45 08             	mov    0x8(%ebp),%eax
80103169:	89 04 24             	mov    %eax,(%esp)
8010316c:	e8 0c 00 00 00       	call   8010317d <freerange>
  kmem.use_lock = 1;
80103171:	c7 05 34 18 11 80 01 	movl   $0x1,0x80111834
80103178:	00 00 00 
}
8010317b:	c9                   	leave  
8010317c:	c3                   	ret    

8010317d <freerange>:

void
freerange(void *vstart, void *vend)
{
8010317d:	55                   	push   %ebp
8010317e:	89 e5                	mov    %esp,%ebp
80103180:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80103183:	8b 45 08             	mov    0x8(%ebp),%eax
80103186:	05 ff 0f 00 00       	add    $0xfff,%eax
8010318b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80103190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103193:	eb 12                	jmp    801031a7 <freerange+0x2a>
    kfree(p);
80103195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103198:	89 04 24             	mov    %eax,(%esp)
8010319b:	e8 16 00 00 00       	call   801031b6 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801031a0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801031a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031aa:	05 00 10 00 00       	add    $0x1000,%eax
801031af:	3b 45 0c             	cmp    0xc(%ebp),%eax
801031b2:	76 e1                	jbe    80103195 <freerange+0x18>
    kfree(p);
}
801031b4:	c9                   	leave  
801031b5:	c3                   	ret    

801031b6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801031b6:	55                   	push   %ebp
801031b7:	89 e5                	mov    %esp,%ebp
801031b9:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
801031bc:	8b 45 08             	mov    0x8(%ebp),%eax
801031bf:	25 ff 0f 00 00       	and    $0xfff,%eax
801031c4:	85 c0                	test   %eax,%eax
801031c6:	75 1b                	jne    801031e3 <kfree+0x2d>
801031c8:	81 7d 08 bc 4f 11 80 	cmpl   $0x80114fbc,0x8(%ebp)
801031cf:	72 12                	jb     801031e3 <kfree+0x2d>
801031d1:	8b 45 08             	mov    0x8(%ebp),%eax
801031d4:	89 04 24             	mov    %eax,(%esp)
801031d7:	e8 38 ff ff ff       	call   80103114 <v2p>
801031dc:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801031e1:	76 0c                	jbe    801031ef <kfree+0x39>
    panic("kfree");
801031e3:	c7 04 24 07 8f 10 80 	movl   $0x80108f07,(%esp)
801031ea:	e8 4e d3 ff ff       	call   8010053d <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801031ef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801031f6:	00 
801031f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801031fe:	00 
801031ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103202:	89 04 24             	mov    %eax,(%esp)
80103205:	e8 f0 25 00 00       	call   801057fa <memset>

  if(kmem.use_lock)
8010320a:	a1 34 18 11 80       	mov    0x80111834,%eax
8010320f:	85 c0                	test   %eax,%eax
80103211:	74 0c                	je     8010321f <kfree+0x69>
    acquire(&kmem.lock);
80103213:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
8010321a:	e8 8c 23 00 00       	call   801055ab <acquire>
  r = (struct run*)v;
8010321f:	8b 45 08             	mov    0x8(%ebp),%eax
80103222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80103225:	8b 15 38 18 11 80    	mov    0x80111838,%edx
8010322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010322e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80103230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103233:	a3 38 18 11 80       	mov    %eax,0x80111838
  if(kmem.use_lock)
80103238:	a1 34 18 11 80       	mov    0x80111834,%eax
8010323d:	85 c0                	test   %eax,%eax
8010323f:	74 0c                	je     8010324d <kfree+0x97>
    release(&kmem.lock);
80103241:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
80103248:	e8 c0 23 00 00       	call   8010560d <release>
}
8010324d:	c9                   	leave  
8010324e:	c3                   	ret    

8010324f <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010324f:	55                   	push   %ebp
80103250:	89 e5                	mov    %esp,%ebp
80103252:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80103255:	a1 34 18 11 80       	mov    0x80111834,%eax
8010325a:	85 c0                	test   %eax,%eax
8010325c:	74 0c                	je     8010326a <kalloc+0x1b>
    acquire(&kmem.lock);
8010325e:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
80103265:	e8 41 23 00 00       	call   801055ab <acquire>
  r = kmem.freelist;
8010326a:	a1 38 18 11 80       	mov    0x80111838,%eax
8010326f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80103272:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103276:	74 0a                	je     80103282 <kalloc+0x33>
    kmem.freelist = r->next;
80103278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010327b:	8b 00                	mov    (%eax),%eax
8010327d:	a3 38 18 11 80       	mov    %eax,0x80111838
  if(kmem.use_lock)
80103282:	a1 34 18 11 80       	mov    0x80111834,%eax
80103287:	85 c0                	test   %eax,%eax
80103289:	74 0c                	je     80103297 <kalloc+0x48>
    release(&kmem.lock);
8010328b:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
80103292:	e8 76 23 00 00       	call   8010560d <release>
  return (char*)r;
80103297:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010329a:	c9                   	leave  
8010329b:	c3                   	ret    

8010329c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010329c:	55                   	push   %ebp
8010329d:	89 e5                	mov    %esp,%ebp
8010329f:	53                   	push   %ebx
801032a0:	83 ec 14             	sub    $0x14,%esp
801032a3:	8b 45 08             	mov    0x8(%ebp),%eax
801032a6:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032aa:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801032ae:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801032b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801032b6:	ec                   	in     (%dx),%al
801032b7:	89 c3                	mov    %eax,%ebx
801032b9:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801032bc:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801032c0:	83 c4 14             	add    $0x14,%esp
801032c3:	5b                   	pop    %ebx
801032c4:	5d                   	pop    %ebp
801032c5:	c3                   	ret    

801032c6 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801032c6:	55                   	push   %ebp
801032c7:	89 e5                	mov    %esp,%ebp
801032c9:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
801032cc:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801032d3:	e8 c4 ff ff ff       	call   8010329c <inb>
801032d8:	0f b6 c0             	movzbl %al,%eax
801032db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
801032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e1:	83 e0 01             	and    $0x1,%eax
801032e4:	85 c0                	test   %eax,%eax
801032e6:	75 0a                	jne    801032f2 <kbdgetc+0x2c>
    return -1;
801032e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032ed:	e9 23 01 00 00       	jmp    80103415 <kbdgetc+0x14f>
  data = inb(KBDATAP);
801032f2:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
801032f9:	e8 9e ff ff ff       	call   8010329c <inb>
801032fe:	0f b6 c0             	movzbl %al,%eax
80103301:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80103304:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
8010330b:	75 17                	jne    80103324 <kbdgetc+0x5e>
    shift |= E0ESC;
8010330d:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
80103312:	83 c8 40             	or     $0x40,%eax
80103315:	a3 fc d5 10 80       	mov    %eax,0x8010d5fc
    return 0;
8010331a:	b8 00 00 00 00       	mov    $0x0,%eax
8010331f:	e9 f1 00 00 00       	jmp    80103415 <kbdgetc+0x14f>
  } else if(data & 0x80){
80103324:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103327:	25 80 00 00 00       	and    $0x80,%eax
8010332c:	85 c0                	test   %eax,%eax
8010332e:	74 45                	je     80103375 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103330:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
80103335:	83 e0 40             	and    $0x40,%eax
80103338:	85 c0                	test   %eax,%eax
8010333a:	75 08                	jne    80103344 <kbdgetc+0x7e>
8010333c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010333f:	83 e0 7f             	and    $0x7f,%eax
80103342:	eb 03                	jmp    80103347 <kbdgetc+0x81>
80103344:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103347:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
8010334a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010334d:	05 20 a0 10 80       	add    $0x8010a020,%eax
80103352:	0f b6 00             	movzbl (%eax),%eax
80103355:	83 c8 40             	or     $0x40,%eax
80103358:	0f b6 c0             	movzbl %al,%eax
8010335b:	f7 d0                	not    %eax
8010335d:	89 c2                	mov    %eax,%edx
8010335f:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
80103364:	21 d0                	and    %edx,%eax
80103366:	a3 fc d5 10 80       	mov    %eax,0x8010d5fc
    return 0;
8010336b:	b8 00 00 00 00       	mov    $0x0,%eax
80103370:	e9 a0 00 00 00       	jmp    80103415 <kbdgetc+0x14f>
  } else if(shift & E0ESC){
80103375:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
8010337a:	83 e0 40             	and    $0x40,%eax
8010337d:	85 c0                	test   %eax,%eax
8010337f:	74 14                	je     80103395 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103381:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80103388:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
8010338d:	83 e0 bf             	and    $0xffffffbf,%eax
80103390:	a3 fc d5 10 80       	mov    %eax,0x8010d5fc
  }

  shift |= shiftcode[data];
80103395:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103398:	05 20 a0 10 80       	add    $0x8010a020,%eax
8010339d:	0f b6 00             	movzbl (%eax),%eax
801033a0:	0f b6 d0             	movzbl %al,%edx
801033a3:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
801033a8:	09 d0                	or     %edx,%eax
801033aa:	a3 fc d5 10 80       	mov    %eax,0x8010d5fc
  shift ^= togglecode[data];
801033af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801033b2:	05 20 a1 10 80       	add    $0x8010a120,%eax
801033b7:	0f b6 00             	movzbl (%eax),%eax
801033ba:	0f b6 d0             	movzbl %al,%edx
801033bd:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
801033c2:	31 d0                	xor    %edx,%eax
801033c4:	a3 fc d5 10 80       	mov    %eax,0x8010d5fc
  c = charcode[shift & (CTL | SHIFT)][data];
801033c9:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
801033ce:	83 e0 03             	and    $0x3,%eax
801033d1:	8b 04 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%eax
801033d8:	03 45 fc             	add    -0x4(%ebp),%eax
801033db:	0f b6 00             	movzbl (%eax),%eax
801033de:	0f b6 c0             	movzbl %al,%eax
801033e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
801033e4:	a1 fc d5 10 80       	mov    0x8010d5fc,%eax
801033e9:	83 e0 08             	and    $0x8,%eax
801033ec:	85 c0                	test   %eax,%eax
801033ee:	74 22                	je     80103412 <kbdgetc+0x14c>
    if('a' <= c && c <= 'z')
801033f0:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
801033f4:	76 0c                	jbe    80103402 <kbdgetc+0x13c>
801033f6:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
801033fa:	77 06                	ja     80103402 <kbdgetc+0x13c>
      c += 'A' - 'a';
801033fc:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80103400:	eb 10                	jmp    80103412 <kbdgetc+0x14c>
    else if('A' <= c && c <= 'Z')
80103402:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80103406:	76 0a                	jbe    80103412 <kbdgetc+0x14c>
80103408:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
8010340c:	77 04                	ja     80103412 <kbdgetc+0x14c>
      c += 'a' - 'A';
8010340e:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80103412:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103415:	c9                   	leave  
80103416:	c3                   	ret    

80103417 <kbdintr>:

void
kbdintr(void)
{
80103417:	55                   	push   %ebp
80103418:	89 e5                	mov    %esp,%ebp
8010341a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
8010341d:	c7 04 24 c6 32 10 80 	movl   $0x801032c6,(%esp)
80103424:	e8 ab d3 ff ff       	call   801007d4 <consoleintr>
}
80103429:	c9                   	leave  
8010342a:	c3                   	ret    
	...

8010342c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010342c:	55                   	push   %ebp
8010342d:	89 e5                	mov    %esp,%ebp
8010342f:	83 ec 08             	sub    $0x8,%esp
80103432:	8b 55 08             	mov    0x8(%ebp),%edx
80103435:	8b 45 0c             	mov    0xc(%ebp),%eax
80103438:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010343c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010343f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103443:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103447:	ee                   	out    %al,(%dx)
}
80103448:	c9                   	leave  
80103449:	c3                   	ret    

8010344a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010344a:	55                   	push   %ebp
8010344b:	89 e5                	mov    %esp,%ebp
8010344d:	53                   	push   %ebx
8010344e:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103451:	9c                   	pushf  
80103452:	5b                   	pop    %ebx
80103453:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80103456:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103459:	83 c4 10             	add    $0x10,%esp
8010345c:	5b                   	pop    %ebx
8010345d:	5d                   	pop    %ebp
8010345e:	c3                   	ret    

8010345f <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
8010345f:	55                   	push   %ebp
80103460:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103462:	a1 3c 18 11 80       	mov    0x8011183c,%eax
80103467:	8b 55 08             	mov    0x8(%ebp),%edx
8010346a:	c1 e2 02             	shl    $0x2,%edx
8010346d:	01 c2                	add    %eax,%edx
8010346f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103472:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80103474:	a1 3c 18 11 80       	mov    0x8011183c,%eax
80103479:	83 c0 20             	add    $0x20,%eax
8010347c:	8b 00                	mov    (%eax),%eax
}
8010347e:	5d                   	pop    %ebp
8010347f:	c3                   	ret    

80103480 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80103486:	a1 3c 18 11 80       	mov    0x8011183c,%eax
8010348b:	85 c0                	test   %eax,%eax
8010348d:	0f 84 47 01 00 00    	je     801035da <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103493:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
8010349a:	00 
8010349b:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
801034a2:	e8 b8 ff ff ff       	call   8010345f <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801034a7:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
801034ae:	00 
801034af:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
801034b6:	e8 a4 ff ff ff       	call   8010345f <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801034bb:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
801034c2:	00 
801034c3:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801034ca:	e8 90 ff ff ff       	call   8010345f <lapicw>
  lapicw(TICR, 10000000); 
801034cf:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
801034d6:	00 
801034d7:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
801034de:	e8 7c ff ff ff       	call   8010345f <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801034e3:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801034ea:	00 
801034eb:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
801034f2:	e8 68 ff ff ff       	call   8010345f <lapicw>
  lapicw(LINT1, MASKED);
801034f7:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801034fe:	00 
801034ff:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80103506:	e8 54 ff ff ff       	call   8010345f <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010350b:	a1 3c 18 11 80       	mov    0x8011183c,%eax
80103510:	83 c0 30             	add    $0x30,%eax
80103513:	8b 00                	mov    (%eax),%eax
80103515:	c1 e8 10             	shr    $0x10,%eax
80103518:	25 ff 00 00 00       	and    $0xff,%eax
8010351d:	83 f8 03             	cmp    $0x3,%eax
80103520:	76 14                	jbe    80103536 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80103522:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103529:	00 
8010352a:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80103531:	e8 29 ff ff ff       	call   8010345f <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103536:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
8010353d:	00 
8010353e:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80103545:	e8 15 ff ff ff       	call   8010345f <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010354a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103551:	00 
80103552:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103559:	e8 01 ff ff ff       	call   8010345f <lapicw>
  lapicw(ESR, 0);
8010355e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103565:	00 
80103566:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010356d:	e8 ed fe ff ff       	call   8010345f <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103572:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103579:	00 
8010357a:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103581:	e8 d9 fe ff ff       	call   8010345f <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103586:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010358d:	00 
8010358e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103595:	e8 c5 fe ff ff       	call   8010345f <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010359a:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
801035a1:	00 
801035a2:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801035a9:	e8 b1 fe ff ff       	call   8010345f <lapicw>
  while(lapic[ICRLO] & DELIVS)
801035ae:	90                   	nop
801035af:	a1 3c 18 11 80       	mov    0x8011183c,%eax
801035b4:	05 00 03 00 00       	add    $0x300,%eax
801035b9:	8b 00                	mov    (%eax),%eax
801035bb:	25 00 10 00 00       	and    $0x1000,%eax
801035c0:	85 c0                	test   %eax,%eax
801035c2:	75 eb                	jne    801035af <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801035c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801035cb:	00 
801035cc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801035d3:	e8 87 fe ff ff       	call   8010345f <lapicw>
801035d8:	eb 01                	jmp    801035db <lapicinit+0x15b>

void
lapicinit(int c)
{
  if(!lapic) 
    return;
801035da:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801035db:	c9                   	leave  
801035dc:	c3                   	ret    

801035dd <cpunum>:

int
cpunum(void)
{
801035dd:	55                   	push   %ebp
801035de:	89 e5                	mov    %esp,%ebp
801035e0:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801035e3:	e8 62 fe ff ff       	call   8010344a <readeflags>
801035e8:	25 00 02 00 00       	and    $0x200,%eax
801035ed:	85 c0                	test   %eax,%eax
801035ef:	74 29                	je     8010361a <cpunum+0x3d>
    static int n;
    if(n++ == 0)
801035f1:	a1 00 d6 10 80       	mov    0x8010d600,%eax
801035f6:	85 c0                	test   %eax,%eax
801035f8:	0f 94 c2             	sete   %dl
801035fb:	83 c0 01             	add    $0x1,%eax
801035fe:	a3 00 d6 10 80       	mov    %eax,0x8010d600
80103603:	84 d2                	test   %dl,%dl
80103605:	74 13                	je     8010361a <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80103607:	8b 45 04             	mov    0x4(%ebp),%eax
8010360a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010360e:	c7 04 24 10 8f 10 80 	movl   $0x80108f10,(%esp)
80103615:	e8 87 cd ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
8010361a:	a1 3c 18 11 80       	mov    0x8011183c,%eax
8010361f:	85 c0                	test   %eax,%eax
80103621:	74 0f                	je     80103632 <cpunum+0x55>
    return lapic[ID]>>24;
80103623:	a1 3c 18 11 80       	mov    0x8011183c,%eax
80103628:	83 c0 20             	add    $0x20,%eax
8010362b:	8b 00                	mov    (%eax),%eax
8010362d:	c1 e8 18             	shr    $0x18,%eax
80103630:	eb 05                	jmp    80103637 <cpunum+0x5a>
  return 0;
80103632:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103637:	c9                   	leave  
80103638:	c3                   	ret    

80103639 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103639:	55                   	push   %ebp
8010363a:	89 e5                	mov    %esp,%ebp
8010363c:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
8010363f:	a1 3c 18 11 80       	mov    0x8011183c,%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	74 14                	je     8010365c <lapiceoi+0x23>
    lapicw(EOI, 0);
80103648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010364f:	00 
80103650:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103657:	e8 03 fe ff ff       	call   8010345f <lapicw>
}
8010365c:	c9                   	leave  
8010365d:	c3                   	ret    

8010365e <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010365e:	55                   	push   %ebp
8010365f:	89 e5                	mov    %esp,%ebp
}
80103661:	5d                   	pop    %ebp
80103662:	c3                   	ret    

80103663 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103663:	55                   	push   %ebp
80103664:	89 e5                	mov    %esp,%ebp
80103666:	83 ec 1c             	sub    $0x1c,%esp
80103669:	8b 45 08             	mov    0x8(%ebp),%eax
8010366c:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
8010366f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80103676:	00 
80103677:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010367e:	e8 a9 fd ff ff       	call   8010342c <outb>
  outb(IO_RTC+1, 0x0A);
80103683:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010368a:	00 
8010368b:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103692:	e8 95 fd ff ff       	call   8010342c <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103697:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010369e:	8b 45 f8             	mov    -0x8(%ebp),%eax
801036a1:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801036a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801036a9:	8d 50 02             	lea    0x2(%eax),%edx
801036ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801036af:	c1 e8 04             	shr    $0x4,%eax
801036b2:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801036b5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801036b9:	c1 e0 18             	shl    $0x18,%eax
801036bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801036c0:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801036c7:	e8 93 fd ff ff       	call   8010345f <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801036cc:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
801036d3:	00 
801036d4:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801036db:	e8 7f fd ff ff       	call   8010345f <lapicw>
  microdelay(200);
801036e0:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801036e7:	e8 72 ff ff ff       	call   8010365e <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
801036ec:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
801036f3:	00 
801036f4:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801036fb:	e8 5f fd ff ff       	call   8010345f <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103700:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103707:	e8 52 ff ff ff       	call   8010365e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010370c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103713:	eb 40                	jmp    80103755 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80103715:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103719:	c1 e0 18             	shl    $0x18,%eax
8010371c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103720:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103727:	e8 33 fd ff ff       	call   8010345f <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010372c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010372f:	c1 e8 0c             	shr    $0xc,%eax
80103732:	80 cc 06             	or     $0x6,%ah
80103735:	89 44 24 04          	mov    %eax,0x4(%esp)
80103739:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103740:	e8 1a fd ff ff       	call   8010345f <lapicw>
    microdelay(200);
80103745:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010374c:	e8 0d ff ff ff       	call   8010365e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103751:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103755:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103759:	7e ba                	jle    80103715 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010375b:	c9                   	leave  
8010375c:	c3                   	ret    
8010375d:	00 00                	add    %al,(%eax)
	...

80103760 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103766:	c7 44 24 04 3c 8f 10 	movl   $0x80108f3c,0x4(%esp)
8010376d:	80 
8010376e:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80103775:	e8 10 1e 00 00       	call   8010558a <initlock>
  readsb(ROOTDEV, &sb);
8010377a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010377d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103781:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103788:	e8 af e2 ff ff       	call   80101a3c <readsb>
  log.start = sb.size - sb.nlog;
8010378d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103793:	89 d1                	mov    %edx,%ecx
80103795:	29 c1                	sub    %eax,%ecx
80103797:	89 c8                	mov    %ecx,%eax
80103799:	a3 74 18 11 80       	mov    %eax,0x80111874
  log.size = sb.nlog;
8010379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037a1:	a3 78 18 11 80       	mov    %eax,0x80111878
  log.dev = ROOTDEV;
801037a6:	c7 05 80 18 11 80 01 	movl   $0x1,0x80111880
801037ad:	00 00 00 
  recover_from_log();
801037b0:	e8 97 01 00 00       	call   8010394c <recover_from_log>
}
801037b5:	c9                   	leave  
801037b6:	c3                   	ret    

801037b7 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801037b7:	55                   	push   %ebp
801037b8:	89 e5                	mov    %esp,%ebp
801037ba:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037c4:	e9 89 00 00 00       	jmp    80103852 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801037c9:	a1 74 18 11 80       	mov    0x80111874,%eax
801037ce:	03 45 f4             	add    -0xc(%ebp),%eax
801037d1:	83 c0 01             	add    $0x1,%eax
801037d4:	89 c2                	mov    %eax,%edx
801037d6:	a1 80 18 11 80       	mov    0x80111880,%eax
801037db:	89 54 24 04          	mov    %edx,0x4(%esp)
801037df:	89 04 24             	mov    %eax,(%esp)
801037e2:	e8 bf c9 ff ff       	call   801001a6 <bread>
801037e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801037ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ed:	83 c0 10             	add    $0x10,%eax
801037f0:	8b 04 85 48 18 11 80 	mov    -0x7feee7b8(,%eax,4),%eax
801037f7:	89 c2                	mov    %eax,%edx
801037f9:	a1 80 18 11 80       	mov    0x80111880,%eax
801037fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80103802:	89 04 24             	mov    %eax,(%esp)
80103805:	e8 9c c9 ff ff       	call   801001a6 <bread>
8010380a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010380d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103810:	8d 50 18             	lea    0x18(%eax),%edx
80103813:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103816:	83 c0 18             	add    $0x18,%eax
80103819:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103820:	00 
80103821:	89 54 24 04          	mov    %edx,0x4(%esp)
80103825:	89 04 24             	mov    %eax,(%esp)
80103828:	e8 a0 20 00 00       	call   801058cd <memmove>
    bwrite(dbuf);  // write dst to disk
8010382d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103830:	89 04 24             	mov    %eax,(%esp)
80103833:	e8 a5 c9 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
80103838:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010383b:	89 04 24             	mov    %eax,(%esp)
8010383e:	e8 d4 c9 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103843:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103846:	89 04 24             	mov    %eax,(%esp)
80103849:	e8 c9 c9 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010384e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103852:	a1 84 18 11 80       	mov    0x80111884,%eax
80103857:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010385a:	0f 8f 69 ff ff ff    	jg     801037c9 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103860:	c9                   	leave  
80103861:	c3                   	ret    

80103862 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103862:	55                   	push   %ebp
80103863:	89 e5                	mov    %esp,%ebp
80103865:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103868:	a1 74 18 11 80       	mov    0x80111874,%eax
8010386d:	89 c2                	mov    %eax,%edx
8010386f:	a1 80 18 11 80       	mov    0x80111880,%eax
80103874:	89 54 24 04          	mov    %edx,0x4(%esp)
80103878:	89 04 24             	mov    %eax,(%esp)
8010387b:	e8 26 c9 ff ff       	call   801001a6 <bread>
80103880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103883:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103886:	83 c0 18             	add    $0x18,%eax
80103889:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010388c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010388f:	8b 00                	mov    (%eax),%eax
80103891:	a3 84 18 11 80       	mov    %eax,0x80111884
  for (i = 0; i < log.lh.n; i++) {
80103896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010389d:	eb 1b                	jmp    801038ba <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010389f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038a5:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801038a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038ac:	83 c2 10             	add    $0x10,%edx
801038af:	89 04 95 48 18 11 80 	mov    %eax,-0x7feee7b8(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801038b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038ba:	a1 84 18 11 80       	mov    0x80111884,%eax
801038bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038c2:	7f db                	jg     8010389f <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801038c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c7:	89 04 24             	mov    %eax,(%esp)
801038ca:	e8 48 c9 ff ff       	call   80100217 <brelse>
}
801038cf:	c9                   	leave  
801038d0:	c3                   	ret    

801038d1 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801038d1:	55                   	push   %ebp
801038d2:	89 e5                	mov    %esp,%ebp
801038d4:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801038d7:	a1 74 18 11 80       	mov    0x80111874,%eax
801038dc:	89 c2                	mov    %eax,%edx
801038de:	a1 80 18 11 80       	mov    0x80111880,%eax
801038e3:	89 54 24 04          	mov    %edx,0x4(%esp)
801038e7:	89 04 24             	mov    %eax,(%esp)
801038ea:	e8 b7 c8 ff ff       	call   801001a6 <bread>
801038ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801038f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f5:	83 c0 18             	add    $0x18,%eax
801038f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801038fb:	8b 15 84 18 11 80    	mov    0x80111884,%edx
80103901:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103904:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103906:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010390d:	eb 1b                	jmp    8010392a <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
8010390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103912:	83 c0 10             	add    $0x10,%eax
80103915:	8b 0c 85 48 18 11 80 	mov    -0x7feee7b8(,%eax,4),%ecx
8010391c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103922:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103926:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010392a:	a1 84 18 11 80       	mov    0x80111884,%eax
8010392f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103932:	7f db                	jg     8010390f <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103934:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103937:	89 04 24             	mov    %eax,(%esp)
8010393a:	e8 9e c8 ff ff       	call   801001dd <bwrite>
  brelse(buf);
8010393f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103942:	89 04 24             	mov    %eax,(%esp)
80103945:	e8 cd c8 ff ff       	call   80100217 <brelse>
}
8010394a:	c9                   	leave  
8010394b:	c3                   	ret    

8010394c <recover_from_log>:

static void
recover_from_log(void)
{
8010394c:	55                   	push   %ebp
8010394d:	89 e5                	mov    %esp,%ebp
8010394f:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103952:	e8 0b ff ff ff       	call   80103862 <read_head>
  install_trans(); // if committed, copy from log to disk
80103957:	e8 5b fe ff ff       	call   801037b7 <install_trans>
  log.lh.n = 0;
8010395c:	c7 05 84 18 11 80 00 	movl   $0x0,0x80111884
80103963:	00 00 00 
  write_head(); // clear the log
80103966:	e8 66 ff ff ff       	call   801038d1 <write_head>
}
8010396b:	c9                   	leave  
8010396c:	c3                   	ret    

8010396d <begin_trans>:

void
begin_trans(void)
{
8010396d:	55                   	push   %ebp
8010396e:	89 e5                	mov    %esp,%ebp
80103970:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103973:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
8010397a:	e8 2c 1c 00 00       	call   801055ab <acquire>
  while (log.busy) {
8010397f:	eb 14                	jmp    80103995 <begin_trans+0x28>
    sleep(&log, &log.lock);
80103981:	c7 44 24 04 40 18 11 	movl   $0x80111840,0x4(%esp)
80103988:	80 
80103989:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80103990:	e8 9e 18 00 00       	call   80105233 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103995:	a1 7c 18 11 80       	mov    0x8011187c,%eax
8010399a:	85 c0                	test   %eax,%eax
8010399c:	75 e3                	jne    80103981 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010399e:	c7 05 7c 18 11 80 01 	movl   $0x1,0x8011187c
801039a5:	00 00 00 
  release(&log.lock);
801039a8:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
801039af:	e8 59 1c 00 00       	call   8010560d <release>
}
801039b4:	c9                   	leave  
801039b5:	c3                   	ret    

801039b6 <commit_trans>:

void
commit_trans(void)
{
801039b6:	55                   	push   %ebp
801039b7:	89 e5                	mov    %esp,%ebp
801039b9:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
801039bc:	a1 84 18 11 80       	mov    0x80111884,%eax
801039c1:	85 c0                	test   %eax,%eax
801039c3:	7e 19                	jle    801039de <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
801039c5:	e8 07 ff ff ff       	call   801038d1 <write_head>
    install_trans(); // Now install writes to home locations
801039ca:	e8 e8 fd ff ff       	call   801037b7 <install_trans>
    log.lh.n = 0; 
801039cf:	c7 05 84 18 11 80 00 	movl   $0x0,0x80111884
801039d6:	00 00 00 
    write_head();    // Erase the transaction from the log
801039d9:	e8 f3 fe ff ff       	call   801038d1 <write_head>
  }
  
  acquire(&log.lock);
801039de:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
801039e5:	e8 c1 1b 00 00       	call   801055ab <acquire>
  log.busy = 0;
801039ea:	c7 05 7c 18 11 80 00 	movl   $0x0,0x8011187c
801039f1:	00 00 00 
  wakeup(&log);
801039f4:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
801039fb:	e8 a1 19 00 00       	call   801053a1 <wakeup>
  release(&log.lock);
80103a00:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80103a07:	e8 01 1c 00 00       	call   8010560d <release>
}
80103a0c:	c9                   	leave  
80103a0d:	c3                   	ret    

80103a0e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103a0e:	55                   	push   %ebp
80103a0f:	89 e5                	mov    %esp,%ebp
80103a11:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103a14:	a1 84 18 11 80       	mov    0x80111884,%eax
80103a19:	83 f8 09             	cmp    $0x9,%eax
80103a1c:	7f 12                	jg     80103a30 <log_write+0x22>
80103a1e:	a1 84 18 11 80       	mov    0x80111884,%eax
80103a23:	8b 15 78 18 11 80    	mov    0x80111878,%edx
80103a29:	83 ea 01             	sub    $0x1,%edx
80103a2c:	39 d0                	cmp    %edx,%eax
80103a2e:	7c 0c                	jl     80103a3c <log_write+0x2e>
    panic("too big a transaction");
80103a30:	c7 04 24 40 8f 10 80 	movl   $0x80108f40,(%esp)
80103a37:	e8 01 cb ff ff       	call   8010053d <panic>
  if (!log.busy)
80103a3c:	a1 7c 18 11 80       	mov    0x8011187c,%eax
80103a41:	85 c0                	test   %eax,%eax
80103a43:	75 0c                	jne    80103a51 <log_write+0x43>
    panic("write outside of trans");
80103a45:	c7 04 24 56 8f 10 80 	movl   $0x80108f56,(%esp)
80103a4c:	e8 ec ca ff ff       	call   8010053d <panic>

  for (i = 0; i < log.lh.n; i++) {
80103a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a58:	eb 1d                	jmp    80103a77 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
80103a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a5d:	83 c0 10             	add    $0x10,%eax
80103a60:	8b 04 85 48 18 11 80 	mov    -0x7feee7b8(,%eax,4),%eax
80103a67:	89 c2                	mov    %eax,%edx
80103a69:	8b 45 08             	mov    0x8(%ebp),%eax
80103a6c:	8b 40 08             	mov    0x8(%eax),%eax
80103a6f:	39 c2                	cmp    %eax,%edx
80103a71:	74 10                	je     80103a83 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103a73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a77:	a1 84 18 11 80       	mov    0x80111884,%eax
80103a7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a7f:	7f d9                	jg     80103a5a <log_write+0x4c>
80103a81:	eb 01                	jmp    80103a84 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103a83:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103a84:	8b 45 08             	mov    0x8(%ebp),%eax
80103a87:	8b 40 08             	mov    0x8(%eax),%eax
80103a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a8d:	83 c2 10             	add    $0x10,%edx
80103a90:	89 04 95 48 18 11 80 	mov    %eax,-0x7feee7b8(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103a97:	a1 74 18 11 80       	mov    0x80111874,%eax
80103a9c:	03 45 f4             	add    -0xc(%ebp),%eax
80103a9f:	83 c0 01             	add    $0x1,%eax
80103aa2:	89 c2                	mov    %eax,%edx
80103aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80103aa7:	8b 40 04             	mov    0x4(%eax),%eax
80103aaa:	89 54 24 04          	mov    %edx,0x4(%esp)
80103aae:	89 04 24             	mov    %eax,(%esp)
80103ab1:	e8 f0 c6 ff ff       	call   801001a6 <bread>
80103ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80103abc:	8d 50 18             	lea    0x18(%eax),%edx
80103abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac2:	83 c0 18             	add    $0x18,%eax
80103ac5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103acc:	00 
80103acd:	89 54 24 04          	mov    %edx,0x4(%esp)
80103ad1:	89 04 24             	mov    %eax,(%esp)
80103ad4:	e8 f4 1d 00 00       	call   801058cd <memmove>
  bwrite(lbuf);
80103ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103adc:	89 04 24             	mov    %eax,(%esp)
80103adf:	e8 f9 c6 ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae7:	89 04 24             	mov    %eax,(%esp)
80103aea:	e8 28 c7 ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103aef:	a1 84 18 11 80       	mov    0x80111884,%eax
80103af4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103af7:	75 0d                	jne    80103b06 <log_write+0xf8>
    log.lh.n++;
80103af9:	a1 84 18 11 80       	mov    0x80111884,%eax
80103afe:	83 c0 01             	add    $0x1,%eax
80103b01:	a3 84 18 11 80       	mov    %eax,0x80111884
  b->flags |= B_DIRTY; // XXX prevent eviction
80103b06:	8b 45 08             	mov    0x8(%ebp),%eax
80103b09:	8b 00                	mov    (%eax),%eax
80103b0b:	89 c2                	mov    %eax,%edx
80103b0d:	83 ca 04             	or     $0x4,%edx
80103b10:	8b 45 08             	mov    0x8(%ebp),%eax
80103b13:	89 10                	mov    %edx,(%eax)
}
80103b15:	c9                   	leave  
80103b16:	c3                   	ret    
	...

80103b18 <v2p>:
80103b18:	55                   	push   %ebp
80103b19:	89 e5                	mov    %esp,%ebp
80103b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b1e:	05 00 00 00 80       	add    $0x80000000,%eax
80103b23:	5d                   	pop    %ebp
80103b24:	c3                   	ret    

80103b25 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103b25:	55                   	push   %ebp
80103b26:	89 e5                	mov    %esp,%ebp
80103b28:	8b 45 08             	mov    0x8(%ebp),%eax
80103b2b:	05 00 00 00 80       	add    $0x80000000,%eax
80103b30:	5d                   	pop    %ebp
80103b31:	c3                   	ret    

80103b32 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103b32:	55                   	push   %ebp
80103b33:	89 e5                	mov    %esp,%ebp
80103b35:	53                   	push   %ebx
80103b36:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80103b39:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80103b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103b42:	89 c3                	mov    %eax,%ebx
80103b44:	89 d8                	mov    %ebx,%eax
80103b46:	f0 87 02             	lock xchg %eax,(%edx)
80103b49:	89 c3                	mov    %eax,%ebx
80103b4b:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103b4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b51:	83 c4 10             	add    $0x10,%esp
80103b54:	5b                   	pop    %ebx
80103b55:	5d                   	pop    %ebp
80103b56:	c3                   	ret    

80103b57 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103b57:	55                   	push   %ebp
80103b58:	89 e5                	mov    %esp,%ebp
80103b5a:	83 e4 f0             	and    $0xfffffff0,%esp
80103b5d:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103b60:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103b67:	80 
80103b68:	c7 04 24 bc 4f 11 80 	movl   $0x80114fbc,(%esp)
80103b6f:	e8 ad f5 ff ff       	call   80103121 <kinit1>
  kvmalloc();      // kernel page table
80103b74:	e8 21 4a 00 00       	call   8010859a <kvmalloc>
  mpinit();        // collect info about this machine
80103b79:	e8 63 04 00 00       	call   80103fe1 <mpinit>
  lapicinit(mpbcpu());
80103b7e:	e8 2e 02 00 00       	call   80103db1 <mpbcpu>
80103b83:	89 04 24             	mov    %eax,(%esp)
80103b86:	e8 f5 f8 ff ff       	call   80103480 <lapicinit>
  seginit();       // set up segments
80103b8b:	e8 ad 43 00 00       	call   80107f3d <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103b90:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103b96:	0f b6 00             	movzbl (%eax),%eax
80103b99:	0f b6 c0             	movzbl %al,%eax
80103b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ba0:	c7 04 24 6d 8f 10 80 	movl   $0x80108f6d,(%esp)
80103ba7:	e8 f5 c7 ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103bac:	e8 95 06 00 00       	call   80104246 <picinit>
  ioapicinit();    // another interrupt controller
80103bb1:	e8 5b f4 ff ff       	call   80103011 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103bb6:	e8 c3 d4 ff ff       	call   8010107e <consoleinit>
  uartinit();      // serial port
80103bbb:	e8 c8 36 00 00       	call   80107288 <uartinit>
  pinit();         // process table
80103bc0:	e8 96 0b 00 00       	call   8010475b <pinit>
  tvinit();        // trap vectors
80103bc5:	e8 99 31 00 00       	call   80106d63 <tvinit>
  binit();         // buffer cache
80103bca:	e8 65 c4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103bcf:	e8 7c da ff ff       	call   80101650 <fileinit>
  iinit();         // inode cache
80103bd4:	e8 2a e1 ff ff       	call   80101d03 <iinit>
  ideinit();       // disk
80103bd9:	e8 98 f0 ff ff       	call   80102c76 <ideinit>
  if(!ismp)
80103bde:	a1 c4 18 11 80       	mov    0x801118c4,%eax
80103be3:	85 c0                	test   %eax,%eax
80103be5:	75 05                	jne    80103bec <main+0x95>
    timerinit();   // uniprocessor timer
80103be7:	e8 ba 30 00 00       	call   80106ca6 <timerinit>
  startothers();   // start other processors
80103bec:	e8 87 00 00 00       	call   80103c78 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103bf1:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103bf8:	8e 
80103bf9:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103c00:	e8 54 f5 ff ff       	call   80103159 <kinit2>
  userinit();      // first user process
80103c05:	e8 ea 0c 00 00       	call   801048f4 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103c0a:	e8 22 00 00 00       	call   80103c31 <mpmain>

80103c0f <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c0f:	55                   	push   %ebp
80103c10:	89 e5                	mov    %esp,%ebp
80103c12:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
80103c15:	e8 97 49 00 00       	call   801085b1 <switchkvm>
  seginit();
80103c1a:	e8 1e 43 00 00       	call   80107f3d <seginit>
  lapicinit(cpunum());
80103c1f:	e8 b9 f9 ff ff       	call   801035dd <cpunum>
80103c24:	89 04 24             	mov    %eax,(%esp)
80103c27:	e8 54 f8 ff ff       	call   80103480 <lapicinit>
  mpmain();
80103c2c:	e8 00 00 00 00       	call   80103c31 <mpmain>

80103c31 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103c31:	55                   	push   %ebp
80103c32:	89 e5                	mov    %esp,%ebp
80103c34:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103c37:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c3d:	0f b6 00             	movzbl (%eax),%eax
80103c40:	0f b6 c0             	movzbl %al,%eax
80103c43:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c47:	c7 04 24 84 8f 10 80 	movl   $0x80108f84,(%esp)
80103c4e:	e8 4e c7 ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
80103c53:	e8 7f 32 00 00       	call   80106ed7 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103c58:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c5e:	05 a8 00 00 00       	add    $0xa8,%eax
80103c63:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103c6a:	00 
80103c6b:	89 04 24             	mov    %eax,(%esp)
80103c6e:	e8 bf fe ff ff       	call   80103b32 <xchg>
  scheduler();     // start running processes
80103c73:	e8 e8 13 00 00       	call   80105060 <scheduler>

80103c78 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103c78:	55                   	push   %ebp
80103c79:	89 e5                	mov    %esp,%ebp
80103c7b:	53                   	push   %ebx
80103c7c:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103c7f:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103c86:	e8 9a fe ff ff       	call   80103b25 <p2v>
80103c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103c8e:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103c93:	89 44 24 08          	mov    %eax,0x8(%esp)
80103c97:	c7 44 24 04 0c c5 10 	movl   $0x8010c50c,0x4(%esp)
80103c9e:	80 
80103c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca2:	89 04 24             	mov    %eax,(%esp)
80103ca5:	e8 23 1c 00 00       	call   801058cd <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103caa:	c7 45 f4 e0 18 11 80 	movl   $0x801118e0,-0xc(%ebp)
80103cb1:	e9 86 00 00 00       	jmp    80103d3c <startothers+0xc4>
    if(c == cpus+cpunum())  // We've started already.
80103cb6:	e8 22 f9 ff ff       	call   801035dd <cpunum>
80103cbb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103cc1:	05 e0 18 11 80       	add    $0x801118e0,%eax
80103cc6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103cc9:	74 69                	je     80103d34 <startothers+0xbc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103ccb:	e8 7f f5 ff ff       	call   8010324f <kalloc>
80103cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd6:	83 e8 04             	sub    $0x4,%eax
80103cd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103cdc:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103ce2:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce7:	83 e8 08             	sub    $0x8,%eax
80103cea:	c7 00 0f 3c 10 80    	movl   $0x80103c0f,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf3:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103cf6:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103cfd:	e8 16 fe ff ff       	call   80103b18 <v2p>
80103d02:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d07:	89 04 24             	mov    %eax,(%esp)
80103d0a:	e8 09 fe ff ff       	call   80103b18 <v2p>
80103d0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d12:	0f b6 12             	movzbl (%edx),%edx
80103d15:	0f b6 d2             	movzbl %dl,%edx
80103d18:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d1c:	89 14 24             	mov    %edx,(%esp)
80103d1f:	e8 3f f9 ff ff       	call   80103663 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103d24:	90                   	nop
80103d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d28:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103d2e:	85 c0                	test   %eax,%eax
80103d30:	74 f3                	je     80103d25 <startothers+0xad>
80103d32:	eb 01                	jmp    80103d35 <startothers+0xbd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103d34:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103d35:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103d3c:	a1 c0 1e 11 80       	mov    0x80111ec0,%eax
80103d41:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d47:	05 e0 18 11 80       	add    $0x801118e0,%eax
80103d4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d4f:	0f 87 61 ff ff ff    	ja     80103cb6 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103d55:	83 c4 24             	add    $0x24,%esp
80103d58:	5b                   	pop    %ebx
80103d59:	5d                   	pop    %ebp
80103d5a:	c3                   	ret    
	...

80103d5c <p2v>:
80103d5c:	55                   	push   %ebp
80103d5d:	89 e5                	mov    %esp,%ebp
80103d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d62:	05 00 00 00 80       	add    $0x80000000,%eax
80103d67:	5d                   	pop    %ebp
80103d68:	c3                   	ret    

80103d69 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103d69:	55                   	push   %ebp
80103d6a:	89 e5                	mov    %esp,%ebp
80103d6c:	53                   	push   %ebx
80103d6d:	83 ec 14             	sub    $0x14,%esp
80103d70:	8b 45 08             	mov    0x8(%ebp),%eax
80103d73:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d77:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80103d7b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80103d7f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80103d83:	ec                   	in     (%dx),%al
80103d84:	89 c3                	mov    %eax,%ebx
80103d86:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103d89:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80103d8d:	83 c4 14             	add    $0x14,%esp
80103d90:	5b                   	pop    %ebx
80103d91:	5d                   	pop    %ebp
80103d92:	c3                   	ret    

80103d93 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d93:	55                   	push   %ebp
80103d94:	89 e5                	mov    %esp,%ebp
80103d96:	83 ec 08             	sub    $0x8,%esp
80103d99:	8b 55 08             	mov    0x8(%ebp),%edx
80103d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d9f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103da3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103da6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103daa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103dae:	ee                   	out    %al,(%dx)
}
80103daf:	c9                   	leave  
80103db0:	c3                   	ret    

80103db1 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103db1:	55                   	push   %ebp
80103db2:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103db4:	a1 04 d6 10 80       	mov    0x8010d604,%eax
80103db9:	89 c2                	mov    %eax,%edx
80103dbb:	b8 e0 18 11 80       	mov    $0x801118e0,%eax
80103dc0:	89 d1                	mov    %edx,%ecx
80103dc2:	29 c1                	sub    %eax,%ecx
80103dc4:	89 c8                	mov    %ecx,%eax
80103dc6:	c1 f8 02             	sar    $0x2,%eax
80103dc9:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103dcf:	5d                   	pop    %ebp
80103dd0:	c3                   	ret    

80103dd1 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103dd1:	55                   	push   %ebp
80103dd2:	89 e5                	mov    %esp,%ebp
80103dd4:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103dd7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103dde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103de5:	eb 13                	jmp    80103dfa <sum+0x29>
    sum += addr[i];
80103de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103dea:	03 45 08             	add    0x8(%ebp),%eax
80103ded:	0f b6 00             	movzbl (%eax),%eax
80103df0:	0f b6 c0             	movzbl %al,%eax
80103df3:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103df6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103dfd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103e00:	7c e5                	jl     80103de7 <sum+0x16>
    sum += addr[i];
  return sum;
80103e02:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103e05:	c9                   	leave  
80103e06:	c3                   	ret    

80103e07 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103e07:	55                   	push   %ebp
80103e08:	89 e5                	mov    %esp,%ebp
80103e0a:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e10:	89 04 24             	mov    %eax,(%esp)
80103e13:	e8 44 ff ff ff       	call   80103d5c <p2v>
80103e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e1e:	03 45 f0             	add    -0x10(%ebp),%eax
80103e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e2a:	eb 3f                	jmp    80103e6b <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e2c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103e33:	00 
80103e34:	c7 44 24 04 98 8f 10 	movl   $0x80108f98,0x4(%esp)
80103e3b:	80 
80103e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3f:	89 04 24             	mov    %eax,(%esp)
80103e42:	e8 2a 1a 00 00       	call   80105871 <memcmp>
80103e47:	85 c0                	test   %eax,%eax
80103e49:	75 1c                	jne    80103e67 <mpsearch1+0x60>
80103e4b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103e52:	00 
80103e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e56:	89 04 24             	mov    %eax,(%esp)
80103e59:	e8 73 ff ff ff       	call   80103dd1 <sum>
80103e5e:	84 c0                	test   %al,%al
80103e60:	75 05                	jne    80103e67 <mpsearch1+0x60>
      return (struct mp*)p;
80103e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e65:	eb 11                	jmp    80103e78 <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103e67:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e6e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e71:	72 b9                	jb     80103e2c <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e78:	c9                   	leave  
80103e79:	c3                   	ret    

80103e7a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103e7a:	55                   	push   %ebp
80103e7b:	89 e5                	mov    %esp,%ebp
80103e7d:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103e80:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e8a:	83 c0 0f             	add    $0xf,%eax
80103e8d:	0f b6 00             	movzbl (%eax),%eax
80103e90:	0f b6 c0             	movzbl %al,%eax
80103e93:	89 c2                	mov    %eax,%edx
80103e95:	c1 e2 08             	shl    $0x8,%edx
80103e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e9b:	83 c0 0e             	add    $0xe,%eax
80103e9e:	0f b6 00             	movzbl (%eax),%eax
80103ea1:	0f b6 c0             	movzbl %al,%eax
80103ea4:	09 d0                	or     %edx,%eax
80103ea6:	c1 e0 04             	shl    $0x4,%eax
80103ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103eac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103eb0:	74 21                	je     80103ed3 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103eb2:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103eb9:	00 
80103eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ebd:	89 04 24             	mov    %eax,(%esp)
80103ec0:	e8 42 ff ff ff       	call   80103e07 <mpsearch1>
80103ec5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ec8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ecc:	74 50                	je     80103f1e <mpsearch+0xa4>
      return mp;
80103ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ed1:	eb 5f                	jmp    80103f32 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed6:	83 c0 14             	add    $0x14,%eax
80103ed9:	0f b6 00             	movzbl (%eax),%eax
80103edc:	0f b6 c0             	movzbl %al,%eax
80103edf:	89 c2                	mov    %eax,%edx
80103ee1:	c1 e2 08             	shl    $0x8,%edx
80103ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee7:	83 c0 13             	add    $0x13,%eax
80103eea:	0f b6 00             	movzbl (%eax),%eax
80103eed:	0f b6 c0             	movzbl %al,%eax
80103ef0:	09 d0                	or     %edx,%eax
80103ef2:	c1 e0 0a             	shl    $0xa,%eax
80103ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103efb:	2d 00 04 00 00       	sub    $0x400,%eax
80103f00:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103f07:	00 
80103f08:	89 04 24             	mov    %eax,(%esp)
80103f0b:	e8 f7 fe ff ff       	call   80103e07 <mpsearch1>
80103f10:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f17:	74 05                	je     80103f1e <mpsearch+0xa4>
      return mp;
80103f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f1c:	eb 14                	jmp    80103f32 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103f1e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103f25:	00 
80103f26:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103f2d:	e8 d5 fe ff ff       	call   80103e07 <mpsearch1>
}
80103f32:	c9                   	leave  
80103f33:	c3                   	ret    

80103f34 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f3a:	e8 3b ff ff ff       	call   80103e7a <mpsearch>
80103f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f46:	74 0a                	je     80103f52 <mpconfig+0x1e>
80103f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f4b:	8b 40 04             	mov    0x4(%eax),%eax
80103f4e:	85 c0                	test   %eax,%eax
80103f50:	75 0a                	jne    80103f5c <mpconfig+0x28>
    return 0;
80103f52:	b8 00 00 00 00       	mov    $0x0,%eax
80103f57:	e9 83 00 00 00       	jmp    80103fdf <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f5f:	8b 40 04             	mov    0x4(%eax),%eax
80103f62:	89 04 24             	mov    %eax,(%esp)
80103f65:	e8 f2 fd ff ff       	call   80103d5c <p2v>
80103f6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103f6d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103f74:	00 
80103f75:	c7 44 24 04 9d 8f 10 	movl   $0x80108f9d,0x4(%esp)
80103f7c:	80 
80103f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f80:	89 04 24             	mov    %eax,(%esp)
80103f83:	e8 e9 18 00 00       	call   80105871 <memcmp>
80103f88:	85 c0                	test   %eax,%eax
80103f8a:	74 07                	je     80103f93 <mpconfig+0x5f>
    return 0;
80103f8c:	b8 00 00 00 00       	mov    $0x0,%eax
80103f91:	eb 4c                	jmp    80103fdf <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f96:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f9a:	3c 01                	cmp    $0x1,%al
80103f9c:	74 12                	je     80103fb0 <mpconfig+0x7c>
80103f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fa1:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103fa5:	3c 04                	cmp    $0x4,%al
80103fa7:	74 07                	je     80103fb0 <mpconfig+0x7c>
    return 0;
80103fa9:	b8 00 00 00 00       	mov    $0x0,%eax
80103fae:	eb 2f                	jmp    80103fdf <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fb3:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103fb7:	0f b7 c0             	movzwl %ax,%eax
80103fba:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fc1:	89 04 24             	mov    %eax,(%esp)
80103fc4:	e8 08 fe ff ff       	call   80103dd1 <sum>
80103fc9:	84 c0                	test   %al,%al
80103fcb:	74 07                	je     80103fd4 <mpconfig+0xa0>
    return 0;
80103fcd:	b8 00 00 00 00       	mov    $0x0,%eax
80103fd2:	eb 0b                	jmp    80103fdf <mpconfig+0xab>
  *pmp = mp;
80103fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fda:	89 10                	mov    %edx,(%eax)
  return conf;
80103fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103fdf:	c9                   	leave  
80103fe0:	c3                   	ret    

80103fe1 <mpinit>:

void
mpinit(void)
{
80103fe1:	55                   	push   %ebp
80103fe2:	89 e5                	mov    %esp,%ebp
80103fe4:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103fe7:	c7 05 04 d6 10 80 e0 	movl   $0x801118e0,0x8010d604
80103fee:	18 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ff1:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ff4:	89 04 24             	mov    %eax,(%esp)
80103ff7:	e8 38 ff ff ff       	call   80103f34 <mpconfig>
80103ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103fff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104003:	0f 84 9c 01 00 00    	je     801041a5 <mpinit+0x1c4>
    return;
  ismp = 1;
80104009:	c7 05 c4 18 11 80 01 	movl   $0x1,0x801118c4
80104010:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80104013:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104016:	8b 40 24             	mov    0x24(%eax),%eax
80104019:	a3 3c 18 11 80       	mov    %eax,0x8011183c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010401e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104021:	83 c0 2c             	add    $0x2c,%eax
80104024:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104027:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010402a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010402e:	0f b7 c0             	movzwl %ax,%eax
80104031:	03 45 f0             	add    -0x10(%ebp),%eax
80104034:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104037:	e9 f4 00 00 00       	jmp    80104130 <mpinit+0x14f>
    switch(*p){
8010403c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403f:	0f b6 00             	movzbl (%eax),%eax
80104042:	0f b6 c0             	movzbl %al,%eax
80104045:	83 f8 04             	cmp    $0x4,%eax
80104048:	0f 87 bf 00 00 00    	ja     8010410d <mpinit+0x12c>
8010404e:	8b 04 85 e0 8f 10 80 	mov    -0x7fef7020(,%eax,4),%eax
80104055:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80104057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010405d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104060:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104064:	0f b6 d0             	movzbl %al,%edx
80104067:	a1 c0 1e 11 80       	mov    0x80111ec0,%eax
8010406c:	39 c2                	cmp    %eax,%edx
8010406e:	74 2d                	je     8010409d <mpinit+0xbc>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80104070:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104073:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104077:	0f b6 d0             	movzbl %al,%edx
8010407a:	a1 c0 1e 11 80       	mov    0x80111ec0,%eax
8010407f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104083:	89 44 24 04          	mov    %eax,0x4(%esp)
80104087:	c7 04 24 a2 8f 10 80 	movl   $0x80108fa2,(%esp)
8010408e:	e8 0e c3 ff ff       	call   801003a1 <cprintf>
        ismp = 0;
80104093:	c7 05 c4 18 11 80 00 	movl   $0x0,0x801118c4
8010409a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010409d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040a0:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801040a4:	0f b6 c0             	movzbl %al,%eax
801040a7:	83 e0 02             	and    $0x2,%eax
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 15                	je     801040c3 <mpinit+0xe2>
        bcpu = &cpus[ncpu];
801040ae:	a1 c0 1e 11 80       	mov    0x80111ec0,%eax
801040b3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801040b9:	05 e0 18 11 80       	add    $0x801118e0,%eax
801040be:	a3 04 d6 10 80       	mov    %eax,0x8010d604
      cpus[ncpu].id = ncpu;
801040c3:	8b 15 c0 1e 11 80    	mov    0x80111ec0,%edx
801040c9:	a1 c0 1e 11 80       	mov    0x80111ec0,%eax
801040ce:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
801040d4:	81 c2 e0 18 11 80    	add    $0x801118e0,%edx
801040da:	88 02                	mov    %al,(%edx)
      ncpu++;
801040dc:	a1 c0 1e 11 80       	mov    0x80111ec0,%eax
801040e1:	83 c0 01             	add    $0x1,%eax
801040e4:	a3 c0 1e 11 80       	mov    %eax,0x80111ec0
      p += sizeof(struct mpproc);
801040e9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
801040ed:	eb 41                	jmp    80104130 <mpinit+0x14f>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
801040ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801040f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801040f8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040fc:	a2 c0 18 11 80       	mov    %al,0x801118c0
      p += sizeof(struct mpioapic);
80104101:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104105:	eb 29                	jmp    80104130 <mpinit+0x14f>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104107:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010410b:	eb 23                	jmp    80104130 <mpinit+0x14f>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010410d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104110:	0f b6 00             	movzbl (%eax),%eax
80104113:	0f b6 c0             	movzbl %al,%eax
80104116:	89 44 24 04          	mov    %eax,0x4(%esp)
8010411a:	c7 04 24 c0 8f 10 80 	movl   $0x80108fc0,(%esp)
80104121:	e8 7b c2 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
80104126:	c7 05 c4 18 11 80 00 	movl   $0x0,0x801118c4
8010412d:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104136:	0f 82 00 ff ff ff    	jb     8010403c <mpinit+0x5b>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
8010413c:	a1 c4 18 11 80       	mov    0x801118c4,%eax
80104141:	85 c0                	test   %eax,%eax
80104143:	75 1d                	jne    80104162 <mpinit+0x181>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104145:	c7 05 c0 1e 11 80 01 	movl   $0x1,0x80111ec0
8010414c:	00 00 00 
    lapic = 0;
8010414f:	c7 05 3c 18 11 80 00 	movl   $0x0,0x8011183c
80104156:	00 00 00 
    ioapicid = 0;
80104159:	c6 05 c0 18 11 80 00 	movb   $0x0,0x801118c0
    return;
80104160:	eb 44                	jmp    801041a6 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80104162:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104165:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104169:	84 c0                	test   %al,%al
8010416b:	74 39                	je     801041a6 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
8010416d:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80104174:	00 
80104175:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
8010417c:	e8 12 fc ff ff       	call   80103d93 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104181:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80104188:	e8 dc fb ff ff       	call   80103d69 <inb>
8010418d:	83 c8 01             	or     $0x1,%eax
80104190:	0f b6 c0             	movzbl %al,%eax
80104193:	89 44 24 04          	mov    %eax,0x4(%esp)
80104197:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
8010419e:	e8 f0 fb ff ff       	call   80103d93 <outb>
801041a3:	eb 01                	jmp    801041a6 <mpinit+0x1c5>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
801041a5:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801041a6:	c9                   	leave  
801041a7:	c3                   	ret    

801041a8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801041a8:	55                   	push   %ebp
801041a9:	89 e5                	mov    %esp,%ebp
801041ab:	83 ec 08             	sub    $0x8,%esp
801041ae:	8b 55 08             	mov    0x8(%ebp),%edx
801041b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801041b8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801041bb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801041bf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801041c3:	ee                   	out    %al,(%dx)
}
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    

801041c6 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
801041c6:	55                   	push   %ebp
801041c7:	89 e5                	mov    %esp,%ebp
801041c9:	83 ec 0c             	sub    $0xc,%esp
801041cc:	8b 45 08             	mov    0x8(%ebp),%eax
801041cf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801041d3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041d7:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
801041dd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041e1:	0f b6 c0             	movzbl %al,%eax
801041e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801041e8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801041ef:	e8 b4 ff ff ff       	call   801041a8 <outb>
  outb(IO_PIC2+1, mask >> 8);
801041f4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041f8:	66 c1 e8 08          	shr    $0x8,%ax
801041fc:	0f b6 c0             	movzbl %al,%eax
801041ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80104203:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010420a:	e8 99 ff ff ff       	call   801041a8 <outb>
}
8010420f:	c9                   	leave  
80104210:	c3                   	ret    

80104211 <picenable>:

void
picenable(int irq)
{
80104211:	55                   	push   %ebp
80104212:	89 e5                	mov    %esp,%ebp
80104214:	53                   	push   %ebx
80104215:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80104218:	8b 45 08             	mov    0x8(%ebp),%eax
8010421b:	ba 01 00 00 00       	mov    $0x1,%edx
80104220:	89 d3                	mov    %edx,%ebx
80104222:	89 c1                	mov    %eax,%ecx
80104224:	d3 e3                	shl    %cl,%ebx
80104226:	89 d8                	mov    %ebx,%eax
80104228:	89 c2                	mov    %eax,%edx
8010422a:	f7 d2                	not    %edx
8010422c:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104233:	21 d0                	and    %edx,%eax
80104235:	0f b7 c0             	movzwl %ax,%eax
80104238:	89 04 24             	mov    %eax,(%esp)
8010423b:	e8 86 ff ff ff       	call   801041c6 <picsetmask>
}
80104240:	83 c4 04             	add    $0x4,%esp
80104243:	5b                   	pop    %ebx
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret    

80104246 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104246:	55                   	push   %ebp
80104247:	89 e5                	mov    %esp,%ebp
80104249:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010424c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80104253:	00 
80104254:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
8010425b:	e8 48 ff ff ff       	call   801041a8 <outb>
  outb(IO_PIC2+1, 0xFF);
80104260:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80104267:	00 
80104268:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010426f:	e8 34 ff ff ff       	call   801041a8 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104274:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
8010427b:	00 
8010427c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104283:	e8 20 ff ff ff       	call   801041a8 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104288:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010428f:	00 
80104290:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104297:	e8 0c ff ff ff       	call   801041a8 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010429c:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
801042a3:	00 
801042a4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801042ab:	e8 f8 fe ff ff       	call   801041a8 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801042b0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801042b7:	00 
801042b8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
801042bf:	e8 e4 fe ff ff       	call   801041a8 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801042c4:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
801042cb:	00 
801042cc:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
801042d3:	e8 d0 fe ff ff       	call   801041a8 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801042d8:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
801042df:	00 
801042e0:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801042e7:	e8 bc fe ff ff       	call   801041a8 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801042ec:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801042f3:	00 
801042f4:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801042fb:	e8 a8 fe ff ff       	call   801041a8 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104300:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80104307:	00 
80104308:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
8010430f:	e8 94 fe ff ff       	call   801041a8 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104314:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
8010431b:	00 
8010431c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104323:	e8 80 fe ff ff       	call   801041a8 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104328:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010432f:	00 
80104330:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104337:	e8 6c fe ff ff       	call   801041a8 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
8010433c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80104343:	00 
80104344:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010434b:	e8 58 fe ff ff       	call   801041a8 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80104350:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80104357:	00 
80104358:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
8010435f:	e8 44 fe ff ff       	call   801041a8 <outb>

  if(irqmask != 0xFFFF)
80104364:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
8010436b:	66 83 f8 ff          	cmp    $0xffff,%ax
8010436f:	74 12                	je     80104383 <picinit+0x13d>
    picsetmask(irqmask);
80104371:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104378:	0f b7 c0             	movzwl %ax,%eax
8010437b:	89 04 24             	mov    %eax,(%esp)
8010437e:	e8 43 fe ff ff       	call   801041c6 <picsetmask>
}
80104383:	c9                   	leave  
80104384:	c3                   	ret    
80104385:	00 00                	add    %al,(%eax)
	...

80104388 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104388:	55                   	push   %ebp
80104389:	89 e5                	mov    %esp,%ebp
8010438b:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
8010438e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104395:	8b 45 0c             	mov    0xc(%ebp),%eax
80104398:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010439e:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a1:	8b 10                	mov    (%eax),%edx
801043a3:	8b 45 08             	mov    0x8(%ebp),%eax
801043a6:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801043a8:	e8 bf d2 ff ff       	call   8010166c <filealloc>
801043ad:	8b 55 08             	mov    0x8(%ebp),%edx
801043b0:	89 02                	mov    %eax,(%edx)
801043b2:	8b 45 08             	mov    0x8(%ebp),%eax
801043b5:	8b 00                	mov    (%eax),%eax
801043b7:	85 c0                	test   %eax,%eax
801043b9:	0f 84 c8 00 00 00    	je     80104487 <pipealloc+0xff>
801043bf:	e8 a8 d2 ff ff       	call   8010166c <filealloc>
801043c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801043c7:	89 02                	mov    %eax,(%edx)
801043c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801043cc:	8b 00                	mov    (%eax),%eax
801043ce:	85 c0                	test   %eax,%eax
801043d0:	0f 84 b1 00 00 00    	je     80104487 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801043d6:	e8 74 ee ff ff       	call   8010324f <kalloc>
801043db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043e2:	0f 84 9e 00 00 00    	je     80104486 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
801043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043eb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801043f2:	00 00 00 
  p->writeopen = 1;
801043f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801043ff:	00 00 00 
  p->nwrite = 0;
80104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104405:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010440c:	00 00 00 
  p->nread = 0;
8010440f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104412:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104419:	00 00 00 
  initlock(&p->lock, "pipe");
8010441c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441f:	c7 44 24 04 f4 8f 10 	movl   $0x80108ff4,0x4(%esp)
80104426:	80 
80104427:	89 04 24             	mov    %eax,(%esp)
8010442a:	e8 5b 11 00 00       	call   8010558a <initlock>
  (*f0)->type = FD_PIPE;
8010442f:	8b 45 08             	mov    0x8(%ebp),%eax
80104432:	8b 00                	mov    (%eax),%eax
80104434:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010443a:	8b 45 08             	mov    0x8(%ebp),%eax
8010443d:	8b 00                	mov    (%eax),%eax
8010443f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104443:	8b 45 08             	mov    0x8(%ebp),%eax
80104446:	8b 00                	mov    (%eax),%eax
80104448:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010444c:	8b 45 08             	mov    0x8(%ebp),%eax
8010444f:	8b 00                	mov    (%eax),%eax
80104451:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104454:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104457:	8b 45 0c             	mov    0xc(%ebp),%eax
8010445a:	8b 00                	mov    (%eax),%eax
8010445c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104462:	8b 45 0c             	mov    0xc(%ebp),%eax
80104465:	8b 00                	mov    (%eax),%eax
80104467:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010446b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010446e:	8b 00                	mov    (%eax),%eax
80104470:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104474:	8b 45 0c             	mov    0xc(%ebp),%eax
80104477:	8b 00                	mov    (%eax),%eax
80104479:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447c:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010447f:	b8 00 00 00 00       	mov    $0x0,%eax
80104484:	eb 43                	jmp    801044c9 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104486:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104487:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010448b:	74 0b                	je     80104498 <pipealloc+0x110>
    kfree((char*)p);
8010448d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104490:	89 04 24             	mov    %eax,(%esp)
80104493:	e8 1e ed ff ff       	call   801031b6 <kfree>
  if(*f0)
80104498:	8b 45 08             	mov    0x8(%ebp),%eax
8010449b:	8b 00                	mov    (%eax),%eax
8010449d:	85 c0                	test   %eax,%eax
8010449f:	74 0d                	je     801044ae <pipealloc+0x126>
    fileclose(*f0);
801044a1:	8b 45 08             	mov    0x8(%ebp),%eax
801044a4:	8b 00                	mov    (%eax),%eax
801044a6:	89 04 24             	mov    %eax,(%esp)
801044a9:	e8 66 d2 ff ff       	call   80101714 <fileclose>
  if(*f1)
801044ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801044b1:	8b 00                	mov    (%eax),%eax
801044b3:	85 c0                	test   %eax,%eax
801044b5:	74 0d                	je     801044c4 <pipealloc+0x13c>
    fileclose(*f1);
801044b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ba:	8b 00                	mov    (%eax),%eax
801044bc:	89 04 24             	mov    %eax,(%esp)
801044bf:	e8 50 d2 ff ff       	call   80101714 <fileclose>
  return -1;
801044c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044c9:	c9                   	leave  
801044ca:	c3                   	ret    

801044cb <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801044cb:	55                   	push   %ebp
801044cc:	89 e5                	mov    %esp,%ebp
801044ce:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
801044d1:	8b 45 08             	mov    0x8(%ebp),%eax
801044d4:	89 04 24             	mov    %eax,(%esp)
801044d7:	e8 cf 10 00 00       	call   801055ab <acquire>
  if(writable){
801044dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801044e0:	74 1f                	je     80104501 <pipeclose+0x36>
    p->writeopen = 0;
801044e2:	8b 45 08             	mov    0x8(%ebp),%eax
801044e5:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801044ec:	00 00 00 
    wakeup(&p->nread);
801044ef:	8b 45 08             	mov    0x8(%ebp),%eax
801044f2:	05 34 02 00 00       	add    $0x234,%eax
801044f7:	89 04 24             	mov    %eax,(%esp)
801044fa:	e8 a2 0e 00 00       	call   801053a1 <wakeup>
801044ff:	eb 1d                	jmp    8010451e <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104501:	8b 45 08             	mov    0x8(%ebp),%eax
80104504:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010450b:	00 00 00 
    wakeup(&p->nwrite);
8010450e:	8b 45 08             	mov    0x8(%ebp),%eax
80104511:	05 38 02 00 00       	add    $0x238,%eax
80104516:	89 04 24             	mov    %eax,(%esp)
80104519:	e8 83 0e 00 00       	call   801053a1 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010451e:	8b 45 08             	mov    0x8(%ebp),%eax
80104521:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104527:	85 c0                	test   %eax,%eax
80104529:	75 25                	jne    80104550 <pipeclose+0x85>
8010452b:	8b 45 08             	mov    0x8(%ebp),%eax
8010452e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104534:	85 c0                	test   %eax,%eax
80104536:	75 18                	jne    80104550 <pipeclose+0x85>
    release(&p->lock);
80104538:	8b 45 08             	mov    0x8(%ebp),%eax
8010453b:	89 04 24             	mov    %eax,(%esp)
8010453e:	e8 ca 10 00 00       	call   8010560d <release>
    kfree((char*)p);
80104543:	8b 45 08             	mov    0x8(%ebp),%eax
80104546:	89 04 24             	mov    %eax,(%esp)
80104549:	e8 68 ec ff ff       	call   801031b6 <kfree>
8010454e:	eb 0b                	jmp    8010455b <pipeclose+0x90>
  } else
    release(&p->lock);
80104550:	8b 45 08             	mov    0x8(%ebp),%eax
80104553:	89 04 24             	mov    %eax,(%esp)
80104556:	e8 b2 10 00 00       	call   8010560d <release>
}
8010455b:	c9                   	leave  
8010455c:	c3                   	ret    

8010455d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010455d:	55                   	push   %ebp
8010455e:	89 e5                	mov    %esp,%ebp
80104560:	53                   	push   %ebx
80104561:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104564:	8b 45 08             	mov    0x8(%ebp),%eax
80104567:	89 04 24             	mov    %eax,(%esp)
8010456a:	e8 3c 10 00 00       	call   801055ab <acquire>
  for(i = 0; i < n; i++){
8010456f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104576:	e9 a6 00 00 00       	jmp    80104621 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
8010457b:	8b 45 08             	mov    0x8(%ebp),%eax
8010457e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104584:	85 c0                	test   %eax,%eax
80104586:	74 0d                	je     80104595 <pipewrite+0x38>
80104588:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458e:	8b 40 24             	mov    0x24(%eax),%eax
80104591:	85 c0                	test   %eax,%eax
80104593:	74 15                	je     801045aa <pipewrite+0x4d>
        release(&p->lock);
80104595:	8b 45 08             	mov    0x8(%ebp),%eax
80104598:	89 04 24             	mov    %eax,(%esp)
8010459b:	e8 6d 10 00 00       	call   8010560d <release>
        return -1;
801045a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045a5:	e9 9d 00 00 00       	jmp    80104647 <pipewrite+0xea>
      }
      wakeup(&p->nread);
801045aa:	8b 45 08             	mov    0x8(%ebp),%eax
801045ad:	05 34 02 00 00       	add    $0x234,%eax
801045b2:	89 04 24             	mov    %eax,(%esp)
801045b5:	e8 e7 0d 00 00       	call   801053a1 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801045ba:	8b 45 08             	mov    0x8(%ebp),%eax
801045bd:	8b 55 08             	mov    0x8(%ebp),%edx
801045c0:	81 c2 38 02 00 00    	add    $0x238,%edx
801045c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801045ca:	89 14 24             	mov    %edx,(%esp)
801045cd:	e8 61 0c 00 00       	call   80105233 <sleep>
801045d2:	eb 01                	jmp    801045d5 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801045d4:	90                   	nop
801045d5:	8b 45 08             	mov    0x8(%ebp),%eax
801045d8:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801045de:	8b 45 08             	mov    0x8(%ebp),%eax
801045e1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045e7:	05 00 02 00 00       	add    $0x200,%eax
801045ec:	39 c2                	cmp    %eax,%edx
801045ee:	74 8b                	je     8010457b <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801045f0:	8b 45 08             	mov    0x8(%ebp),%eax
801045f3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045f9:	89 c3                	mov    %eax,%ebx
801045fb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80104601:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104604:	03 55 0c             	add    0xc(%ebp),%edx
80104607:	0f b6 0a             	movzbl (%edx),%ecx
8010460a:	8b 55 08             	mov    0x8(%ebp),%edx
8010460d:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80104611:	8d 50 01             	lea    0x1(%eax),%edx
80104614:	8b 45 08             	mov    0x8(%ebp),%eax
80104617:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010461d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104624:	3b 45 10             	cmp    0x10(%ebp),%eax
80104627:	7c ab                	jl     801045d4 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104629:	8b 45 08             	mov    0x8(%ebp),%eax
8010462c:	05 34 02 00 00       	add    $0x234,%eax
80104631:	89 04 24             	mov    %eax,(%esp)
80104634:	e8 68 0d 00 00       	call   801053a1 <wakeup>
  release(&p->lock);
80104639:	8b 45 08             	mov    0x8(%ebp),%eax
8010463c:	89 04 24             	mov    %eax,(%esp)
8010463f:	e8 c9 0f 00 00       	call   8010560d <release>
  return n;
80104644:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104647:	83 c4 24             	add    $0x24,%esp
8010464a:	5b                   	pop    %ebx
8010464b:	5d                   	pop    %ebp
8010464c:	c3                   	ret    

8010464d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010464d:	55                   	push   %ebp
8010464e:	89 e5                	mov    %esp,%ebp
80104650:	53                   	push   %ebx
80104651:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104654:	8b 45 08             	mov    0x8(%ebp),%eax
80104657:	89 04 24             	mov    %eax,(%esp)
8010465a:	e8 4c 0f 00 00       	call   801055ab <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010465f:	eb 3a                	jmp    8010469b <piperead+0x4e>
    if(proc->killed){
80104661:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104667:	8b 40 24             	mov    0x24(%eax),%eax
8010466a:	85 c0                	test   %eax,%eax
8010466c:	74 15                	je     80104683 <piperead+0x36>
      release(&p->lock);
8010466e:	8b 45 08             	mov    0x8(%ebp),%eax
80104671:	89 04 24             	mov    %eax,(%esp)
80104674:	e8 94 0f 00 00       	call   8010560d <release>
      return -1;
80104679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010467e:	e9 b6 00 00 00       	jmp    80104739 <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104683:	8b 45 08             	mov    0x8(%ebp),%eax
80104686:	8b 55 08             	mov    0x8(%ebp),%edx
80104689:	81 c2 34 02 00 00    	add    $0x234,%edx
8010468f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104693:	89 14 24             	mov    %edx,(%esp)
80104696:	e8 98 0b 00 00       	call   80105233 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010469b:	8b 45 08             	mov    0x8(%ebp),%eax
8010469e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046a4:	8b 45 08             	mov    0x8(%ebp),%eax
801046a7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046ad:	39 c2                	cmp    %eax,%edx
801046af:	75 0d                	jne    801046be <piperead+0x71>
801046b1:	8b 45 08             	mov    0x8(%ebp),%eax
801046b4:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801046ba:	85 c0                	test   %eax,%eax
801046bc:	75 a3                	jne    80104661 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801046be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801046c5:	eb 49                	jmp    80104710 <piperead+0xc3>
    if(p->nread == p->nwrite)
801046c7:	8b 45 08             	mov    0x8(%ebp),%eax
801046ca:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046d0:	8b 45 08             	mov    0x8(%ebp),%eax
801046d3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046d9:	39 c2                	cmp    %eax,%edx
801046db:	74 3d                	je     8010471a <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e0:	89 c2                	mov    %eax,%edx
801046e2:	03 55 0c             	add    0xc(%ebp),%edx
801046e5:	8b 45 08             	mov    0x8(%ebp),%eax
801046e8:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801046ee:	89 c3                	mov    %eax,%ebx
801046f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801046f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046f9:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
801046fe:	88 0a                	mov    %cl,(%edx)
80104700:	8d 50 01             	lea    0x1(%eax),%edx
80104703:	8b 45 08             	mov    0x8(%ebp),%eax
80104706:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010470c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104713:	3b 45 10             	cmp    0x10(%ebp),%eax
80104716:	7c af                	jl     801046c7 <piperead+0x7a>
80104718:	eb 01                	jmp    8010471b <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
8010471a:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010471b:	8b 45 08             	mov    0x8(%ebp),%eax
8010471e:	05 38 02 00 00       	add    $0x238,%eax
80104723:	89 04 24             	mov    %eax,(%esp)
80104726:	e8 76 0c 00 00       	call   801053a1 <wakeup>
  release(&p->lock);
8010472b:	8b 45 08             	mov    0x8(%ebp),%eax
8010472e:	89 04 24             	mov    %eax,(%esp)
80104731:	e8 d7 0e 00 00       	call   8010560d <release>
  return i;
80104736:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104739:	83 c4 24             	add    $0x24,%esp
8010473c:	5b                   	pop    %ebx
8010473d:	5d                   	pop    %ebp
8010473e:	c3                   	ret    
	...

80104740 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104747:	9c                   	pushf  
80104748:	5b                   	pop    %ebx
80104749:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
8010474c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010474f:	83 c4 10             	add    $0x10,%esp
80104752:	5b                   	pop    %ebx
80104753:	5d                   	pop    %ebp
80104754:	c3                   	ret    

80104755 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104755:	55                   	push   %ebp
80104756:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104758:	fb                   	sti    
}
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    

8010475b <pinit>:
      release(&ptable.lock); 
} */

void
pinit(void)
{
8010475b:	55                   	push   %ebp
8010475c:	89 e5                	mov    %esp,%ebp
8010475e:	83 ec 18             	sub    $0x18,%esp
  ptable.FRR_COUNTER = 0;
80104761:	c7 05 14 47 11 80 00 	movl   $0x0,0x80114714
80104768:	00 00 00 
  initlock(&ptable.lock, "ptable");
8010476b:	c7 44 24 04 f9 8f 10 	movl   $0x80108ff9,0x4(%esp)
80104772:	80 
80104773:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
8010477a:	e8 0b 0e 00 00       	call   8010558a <initlock>
}
8010477f:	c9                   	leave  
80104780:	c3                   	ret    

80104781 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104781:	55                   	push   %ebp
80104782:	89 e5                	mov    %esp,%ebp
80104784:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;  
  acquire(&ptable.lock);
80104787:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
8010478e:	e8 18 0e 00 00       	call   801055ab <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104793:	c7 45 f4 14 1f 11 80 	movl   $0x80111f14,-0xc(%ebp)
8010479a:	eb 11                	jmp    801047ad <allocproc+0x2c>
    if(p->state == UNUSED)
8010479c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479f:	8b 40 0c             	mov    0xc(%eax),%eax
801047a2:	85 c0                	test   %eax,%eax
801047a4:	74 26                	je     801047cc <allocproc+0x4b>
allocproc(void)
{
  struct proc *p;
  char *sp;  
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047a6:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801047ad:	81 7d f4 14 47 11 80 	cmpl   $0x80114714,-0xc(%ebp)
801047b4:	72 e6                	jb     8010479c <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801047b6:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
801047bd:	e8 4b 0e 00 00       	call   8010560d <release>
  return 0;
801047c2:	b8 00 00 00 00       	mov    $0x0,%eax
801047c7:	e9 26 01 00 00       	jmp    801048f2 <allocproc+0x171>
  struct proc *p;
  char *sp;  
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801047cc:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d0:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801047d7:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801047dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047df:	89 42 10             	mov    %eax,0x10(%edx)
801047e2:	83 c0 01             	add    $0x1,%eax
801047e5:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  p->priority = MEDIUM;
801047ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ed:	c7 80 9c 00 00 00 02 	movl   $0x2,0x9c(%eax)
801047f4:	00 00 00 
  p->queuenum = ptable.FRR_COUNTER++;
801047f7:	a1 14 47 11 80       	mov    0x80114714,%eax
801047fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047ff:	89 82 98 00 00 00    	mov    %eax,0x98(%edx)
80104805:	83 c0 01             	add    $0x1,%eax
80104808:	a3 14 47 11 80       	mov    %eax,0x80114714
  p->iotime = 0;
8010480d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104810:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104817:	00 00 00 
  p->wtime = 0;
8010481a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104824:	00 00 00 
  p->rtime = 0;
80104827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482a:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104831:	00 00 00 
  p->etime = 0;
80104834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104837:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010483e:	00 00 00 
  p->sleeptime = 0;
80104841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104844:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010484b:	00 00 00 
  release(&ptable.lock);
8010484e:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104855:	e8 b3 0d 00 00       	call   8010560d <release>
  
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010485a:	e8 f0 e9 ff ff       	call   8010324f <kalloc>
8010485f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104862:	89 42 08             	mov    %eax,0x8(%edx)
80104865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104868:	8b 40 08             	mov    0x8(%eax),%eax
8010486b:	85 c0                	test   %eax,%eax
8010486d:	75 11                	jne    80104880 <allocproc+0xff>
    p->state = UNUSED;
8010486f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104872:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104879:	b8 00 00 00 00       	mov    $0x0,%eax
8010487e:	eb 72                	jmp    801048f2 <allocproc+0x171>
  }
  sp = p->kstack + KSTACKSIZE;
80104880:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104883:	8b 40 08             	mov    0x8(%eax),%eax
80104886:	05 00 10 00 00       	add    $0x1000,%eax
8010488b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010488e:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104895:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104898:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010489b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010489f:	ba 18 6d 10 80       	mov    $0x80106d18,%edx
801048a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048a7:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801048a9:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801048ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048b3:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801048b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801048bc:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801048c3:	00 
801048c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801048cb:	00 
801048cc:	89 04 24             	mov    %eax,(%esp)
801048cf:	e8 26 0f 00 00       	call   801057fa <memset>
  p->context->eip = (uint)forkret;
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	8b 40 1c             	mov    0x1c(%eax),%eax
801048da:	ba 07 52 10 80       	mov    $0x80105207,%edx
801048df:	89 50 10             	mov    %edx,0x10(%eax)
  
  // S
  //acquire(&tickslock);
  p->ctime = ticks; 
801048e2:	a1 60 4f 11 80       	mov    0x80114f60,%eax
801048e7:	89 c2                	mov    %eax,%edx
801048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ec:	89 50 7c             	mov    %edx,0x7c(%eax)
  //release(&tickslock);
  
  return p;
801048ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801048f2:	c9                   	leave  
801048f3:	c3                   	ret    

801048f4 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801048fa:	e8 82 fe ff ff       	call   80104781 <allocproc>
801048ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104905:	a3 08 d6 10 80       	mov    %eax,0x8010d608
  if((p->pgdir = setupkvm(kalloc)) == 0)
8010490a:	c7 04 24 4f 32 10 80 	movl   $0x8010324f,(%esp)
80104911:	e8 c7 3b 00 00       	call   801084dd <setupkvm>
80104916:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104919:	89 42 04             	mov    %eax,0x4(%edx)
8010491c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491f:	8b 40 04             	mov    0x4(%eax),%eax
80104922:	85 c0                	test   %eax,%eax
80104924:	75 0c                	jne    80104932 <userinit+0x3e>
    panic("userinit: out of memory?");
80104926:	c7 04 24 00 90 10 80 	movl   $0x80109000,(%esp)
8010492d:	e8 0b bc ff ff       	call   8010053d <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104932:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104937:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493a:	8b 40 04             	mov    0x4(%eax),%eax
8010493d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104941:	c7 44 24 04 e0 c4 10 	movl   $0x8010c4e0,0x4(%esp)
80104948:	80 
80104949:	89 04 24             	mov    %eax,(%esp)
8010494c:	e8 e4 3d 00 00       	call   80108735 <inituvm>
  p->sz = PGSIZE;
80104951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104954:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010495a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495d:	8b 40 18             	mov    0x18(%eax),%eax
80104960:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104967:	00 
80104968:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010496f:	00 
80104970:	89 04 24             	mov    %eax,(%esp)
80104973:	e8 82 0e 00 00       	call   801057fa <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497b:	8b 40 18             	mov    0x18(%eax),%eax
8010497e:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104987:	8b 40 18             	mov    0x18(%eax),%eax
8010498a:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104993:	8b 40 18             	mov    0x18(%eax),%eax
80104996:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104999:	8b 52 18             	mov    0x18(%edx),%edx
8010499c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801049a0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801049a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a7:	8b 40 18             	mov    0x18(%eax),%eax
801049aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049ad:	8b 52 18             	mov    0x18(%edx),%edx
801049b0:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801049b4:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801049b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049bb:	8b 40 18             	mov    0x18(%eax),%eax
801049be:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c8:	8b 40 18             	mov    0x18(%eax),%eax
801049cb:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801049d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d5:	8b 40 18             	mov    0x18(%eax),%eax
801049d8:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801049df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e2:	83 c0 6c             	add    $0x6c,%eax
801049e5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801049ec:	00 
801049ed:	c7 44 24 04 19 90 10 	movl   $0x80109019,0x4(%esp)
801049f4:	80 
801049f5:	89 04 24             	mov    %eax,(%esp)
801049f8:	e8 2d 10 00 00       	call   80105a2a <safestrcpy>
  p->cwd = namei("/");
801049fd:	c7 04 24 22 90 10 80 	movl   $0x80109022,(%esp)
80104a04:	e8 51 e1 ff ff       	call   80102b5a <namei>
80104a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a0c:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a12:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104a19:	c9                   	leave  
80104a1a:	c3                   	ret    

80104a1b <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104a1b:	55                   	push   %ebp
80104a1c:	89 e5                	mov    %esp,%ebp
80104a1e:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104a21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a27:	8b 00                	mov    (%eax),%eax
80104a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a30:	7e 34                	jle    80104a66 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104a32:	8b 45 08             	mov    0x8(%ebp),%eax
80104a35:	89 c2                	mov    %eax,%edx
80104a37:	03 55 f4             	add    -0xc(%ebp),%edx
80104a3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a40:	8b 40 04             	mov    0x4(%eax),%eax
80104a43:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a4a:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a4e:	89 04 24             	mov    %eax,(%esp)
80104a51:	e8 59 3e 00 00       	call   801088af <allocuvm>
80104a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a5d:	75 41                	jne    80104aa0 <growproc+0x85>
      return -1;
80104a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a64:	eb 58                	jmp    80104abe <growproc+0xa3>
  } else if(n < 0){
80104a66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a6a:	79 34                	jns    80104aa0 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80104a6f:	89 c2                	mov    %eax,%edx
80104a71:	03 55 f4             	add    -0xc(%ebp),%edx
80104a74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7a:	8b 40 04             	mov    0x4(%eax),%eax
80104a7d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a84:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a88:	89 04 24             	mov    %eax,(%esp)
80104a8b:	e8 f9 3e 00 00       	call   80108989 <deallocuvm>
80104a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a97:	75 07                	jne    80104aa0 <growproc+0x85>
      return -1;
80104a99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a9e:	eb 1e                	jmp    80104abe <growproc+0xa3>
  }
  proc->sz = sz;
80104aa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aa9:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104aab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab1:	89 04 24             	mov    %eax,(%esp)
80104ab4:	e8 15 3b 00 00       	call   801085ce <switchuvm>
  return 0;
80104ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104abe:	c9                   	leave  
80104abf:	c3                   	ret    

80104ac0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104ac9:	e8 b3 fc ff ff       	call   80104781 <allocproc>
80104ace:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104ad1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104ad5:	75 0a                	jne    80104ae1 <fork+0x21>
    return -1;
80104ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104adc:	e9 3a 01 00 00       	jmp    80104c1b <fork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104ae1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae7:	8b 10                	mov    (%eax),%edx
80104ae9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aef:	8b 40 04             	mov    0x4(%eax),%eax
80104af2:	89 54 24 04          	mov    %edx,0x4(%esp)
80104af6:	89 04 24             	mov    %eax,(%esp)
80104af9:	e8 1b 40 00 00       	call   80108b19 <copyuvm>
80104afe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104b01:	89 42 04             	mov    %eax,0x4(%edx)
80104b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b07:	8b 40 04             	mov    0x4(%eax),%eax
80104b0a:	85 c0                	test   %eax,%eax
80104b0c:	75 2c                	jne    80104b3a <fork+0x7a>
    kfree(np->kstack);
80104b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b11:	8b 40 08             	mov    0x8(%eax),%eax
80104b14:	89 04 24             	mov    %eax,(%esp)
80104b17:	e8 9a e6 ff ff       	call   801031b6 <kfree>
    np->kstack = 0;
80104b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b29:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b35:	e9 e1 00 00 00       	jmp    80104c1b <fork+0x15b>
  }
  np->sz = proc->sz;
80104b3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b40:	8b 10                	mov    (%eax),%edx
80104b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b45:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104b47:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b51:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104b54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b57:	8b 50 18             	mov    0x18(%eax),%edx
80104b5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b60:	8b 40 18             	mov    0x18(%eax),%eax
80104b63:	89 c3                	mov    %eax,%ebx
80104b65:	b8 13 00 00 00       	mov    $0x13,%eax
80104b6a:	89 d7                	mov    %edx,%edi
80104b6c:	89 de                	mov    %ebx,%esi
80104b6e:	89 c1                	mov    %eax,%ecx
80104b70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b75:	8b 40 18             	mov    0x18(%eax),%eax
80104b78:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b7f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b86:	eb 3d                	jmp    80104bc5 <fork+0x105>
    if(proc->ofile[i])
80104b88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b91:	83 c2 08             	add    $0x8,%edx
80104b94:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b98:	85 c0                	test   %eax,%eax
80104b9a:	74 25                	je     80104bc1 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ba5:	83 c2 08             	add    $0x8,%edx
80104ba8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104bac:	89 04 24             	mov    %eax,(%esp)
80104baf:	e8 18 cb ff ff       	call   801016cc <filedup>
80104bb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104bb7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104bba:	83 c1 08             	add    $0x8,%ecx
80104bbd:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104bc1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104bc5:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104bc9:	7e bd                	jle    80104b88 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104bcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd1:	8b 40 68             	mov    0x68(%eax),%eax
80104bd4:	89 04 24             	mov    %eax,(%esp)
80104bd7:	e8 aa d3 ff ff       	call   80101f86 <idup>
80104bdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104bdf:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104be5:	8b 40 10             	mov    0x10(%eax),%eax
80104be8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104beb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104bf5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bfb:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c01:	83 c0 6c             	add    $0x6c,%eax
80104c04:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c0b:	00 
80104c0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c10:	89 04 24             	mov    %eax,(%esp)
80104c13:	e8 12 0e 00 00       	call   80105a2a <safestrcpy>
  return pid;
80104c18:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104c1b:	83 c4 2c             	add    $0x2c,%esp
80104c1e:	5b                   	pop    %ebx
80104c1f:	5e                   	pop    %esi
80104c20:	5f                   	pop    %edi
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    

80104c23 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104c23:	55                   	push   %ebp
80104c24:	89 e5                	mov    %esp,%ebp
80104c26:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104c29:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c30:	a1 08 d6 10 80       	mov    0x8010d608,%eax
80104c35:	39 c2                	cmp    %eax,%edx
80104c37:	75 0c                	jne    80104c45 <exit+0x22>
    panic("init exiting");
80104c39:	c7 04 24 24 90 10 80 	movl   $0x80109024,(%esp)
80104c40:	e8 f8 b8 ff ff       	call   8010053d <panic>
  
     
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c4c:	eb 44                	jmp    80104c92 <exit+0x6f>
    if(proc->ofile[fd]){
80104c4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c54:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c57:	83 c2 08             	add    $0x8,%edx
80104c5a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c5e:	85 c0                	test   %eax,%eax
80104c60:	74 2c                	je     80104c8e <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104c62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c6b:	83 c2 08             	add    $0x8,%edx
80104c6e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c72:	89 04 24             	mov    %eax,(%esp)
80104c75:	e8 9a ca ff ff       	call   80101714 <fileclose>
      proc->ofile[fd] = 0;
80104c7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c80:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c83:	83 c2 08             	add    $0x8,%edx
80104c86:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c8d:	00 
  if(proc == initproc)
    panic("init exiting");
  
     
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c8e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c92:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c96:	7e b6                	jle    80104c4e <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104c98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9e:	8b 40 68             	mov    0x68(%eax),%eax
80104ca1:	89 04 24             	mov    %eax,(%esp)
80104ca4:	e8 c2 d4 ff ff       	call   8010216b <iput>
  proc->cwd = 0;
80104ca9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104caf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104cb6:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104cbd:	e8 e9 08 00 00       	call   801055ab <acquire>
  
  // Set end time of process
  //acquire(&tickslock);
  proc->etime = ticks;
80104cc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc8:	8b 15 60 4f 11 80    	mov    0x80114f60,%edx
80104cce:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  //release(&tickslock);
  
  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104cd4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cda:	8b 40 14             	mov    0x14(%eax),%eax
80104cdd:	89 04 24             	mov    %eax,(%esp)
80104ce0:	e8 05 06 00 00       	call   801052ea <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ce5:	c7 45 f4 14 1f 11 80 	movl   $0x80111f14,-0xc(%ebp)
80104cec:	eb 3b                	jmp    80104d29 <exit+0x106>
    if(p->parent == proc){
80104cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf1:	8b 50 14             	mov    0x14(%eax),%edx
80104cf4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cfa:	39 c2                	cmp    %eax,%edx
80104cfc:	75 24                	jne    80104d22 <exit+0xff>
      p->parent = initproc;
80104cfe:	8b 15 08 d6 10 80    	mov    0x8010d608,%edx
80104d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d07:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d0d:	8b 40 0c             	mov    0xc(%eax),%eax
80104d10:	83 f8 05             	cmp    $0x5,%eax
80104d13:	75 0d                	jne    80104d22 <exit+0xff>
        wakeup1(initproc);
80104d15:	a1 08 d6 10 80       	mov    0x8010d608,%eax
80104d1a:	89 04 24             	mov    %eax,(%esp)
80104d1d:	e8 c8 05 00 00       	call   801052ea <wakeup1>
  
  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d22:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104d29:	81 7d f4 14 47 11 80 	cmpl   $0x80114714,-0xc(%ebp)
80104d30:	72 bc                	jb     80104cee <exit+0xcb>
    }
  }

    
  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104d32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d38:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104d3f:	e8 c5 03 00 00       	call   80105109 <sched>
  panic("zombie exit");
80104d44:	c7 04 24 31 90 10 80 	movl   $0x80109031,(%esp)
80104d4b:	e8 ed b7 ff ff       	call   8010053d <panic>

80104d50 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104d56:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104d5d:	e8 49 08 00 00       	call   801055ab <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104d62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d69:	c7 45 f4 14 1f 11 80 	movl   $0x80111f14,-0xc(%ebp)
80104d70:	e9 9d 00 00 00       	jmp    80104e12 <wait+0xc2>
      if(p->parent != proc)
80104d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d78:	8b 50 14             	mov    0x14(%eax),%edx
80104d7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d81:	39 c2                	cmp    %eax,%edx
80104d83:	0f 85 81 00 00 00    	jne    80104e0a <wait+0xba>
        continue;
      havekids = 1;
80104d89:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d93:	8b 40 0c             	mov    0xc(%eax),%eax
80104d96:	83 f8 05             	cmp    $0x5,%eax
80104d99:	75 70                	jne    80104e0b <wait+0xbb>
        // Found one.
        pid = p->pid;
80104d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9e:	8b 40 10             	mov    0x10(%eax),%eax
80104da1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da7:	8b 40 08             	mov    0x8(%eax),%eax
80104daa:	89 04 24             	mov    %eax,(%esp)
80104dad:	e8 04 e4 ff ff       	call   801031b6 <kfree>
        p->kstack = 0;
80104db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbf:	8b 40 04             	mov    0x4(%eax),%eax
80104dc2:	89 04 24             	mov    %eax,(%esp)
80104dc5:	e8 7b 3c 00 00       	call   80108a45 <freevm>
        p->state = UNUSED;
80104dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd7:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104deb:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df2:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104df9:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104e00:	e8 08 08 00 00       	call   8010560d <release>
        return pid;
80104e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e08:	eb 56                	jmp    80104e60 <wait+0x110>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104e0a:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e0b:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104e12:	81 7d f4 14 47 11 80 	cmpl   $0x80114714,-0xc(%ebp)
80104e19:	0f 82 56 ff ff ff    	jb     80104d75 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e23:	74 0d                	je     80104e32 <wait+0xe2>
80104e25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e2b:	8b 40 24             	mov    0x24(%eax),%eax
80104e2e:	85 c0                	test   %eax,%eax
80104e30:	74 13                	je     80104e45 <wait+0xf5>
      release(&ptable.lock);
80104e32:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104e39:	e8 cf 07 00 00       	call   8010560d <release>
      return -1;
80104e3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e43:	eb 1b                	jmp    80104e60 <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104e45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e4b:	c7 44 24 04 e0 1e 11 	movl   $0x80111ee0,0x4(%esp)
80104e52:	80 
80104e53:	89 04 24             	mov    %eax,(%esp)
80104e56:	e8 d8 03 00 00       	call   80105233 <sleep>
  }
80104e5b:	e9 02 ff ff ff       	jmp    80104d62 <wait+0x12>
}
80104e60:	c9                   	leave  
80104e61:	c3                   	ret    

80104e62 <wait2>:

int
wait2(int *wtime, int *rtime, int *iotime)
{
80104e62:	55                   	push   %ebp
80104e63:	89 e5                	mov    %esp,%ebp
80104e65:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104e68:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104e6f:	e8 37 07 00 00       	call   801055ab <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104e74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e7b:	c7 45 f4 14 1f 11 80 	movl   $0x80111f14,-0xc(%ebp)
80104e82:	e9 e9 00 00 00       	jmp    80104f70 <wait2+0x10e>
      if(p->parent != proc)
80104e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8a:	8b 50 14             	mov    0x14(%eax),%edx
80104e8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e93:	39 c2                	cmp    %eax,%edx
80104e95:	0f 85 cd 00 00 00    	jne    80104f68 <wait2+0x106>
        continue;
      havekids = 1;
80104e9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea5:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea8:	83 f8 05             	cmp    $0x5,%eax
80104eab:	0f 85 b8 00 00 00    	jne    80104f69 <wait2+0x107>
        // Found one.
        pid = p->pid;
80104eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb4:	8b 40 10             	mov    0x10(%eax),%eax
80104eb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ebd:	8b 40 08             	mov    0x8(%eax),%eax
80104ec0:	89 04 24             	mov    %eax,(%esp)
80104ec3:	e8 ee e2 ff ff       	call   801031b6 <kfree>
        p->kstack = 0;
80104ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed5:	8b 40 04             	mov    0x4(%eax),%eax
80104ed8:	89 04 24             	mov    %eax,(%esp)
80104edb:	e8 65 3b 00 00       	call   80108a45 <freevm>
        p->state = UNUSED;
80104ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eed:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f01:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f08:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        
	// Update RTIME and IOTIME, calc WTIME
	*rtime = p->rtime;
80104f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f12:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80104f18:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f1b:	89 10                	mov    %edx,(%eax)
	*iotime = p->iotime;
80104f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f20:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104f26:	8b 45 10             	mov    0x10(%ebp),%eax
80104f29:	89 10                	mov    %edx,(%eax)
	*wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f37:	8b 40 7c             	mov    0x7c(%eax),%eax
80104f3a:	29 c2                	sub    %eax,%edx
80104f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f3f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80104f45:	29 c2                	sub    %eax,%edx
80104f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4a:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104f50:	29 c2                	sub    %eax,%edx
80104f52:	8b 45 08             	mov    0x8(%ebp),%eax
80104f55:	89 10                	mov    %edx,(%eax)
	
	release(&ptable.lock);
80104f57:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104f5e:	e8 aa 06 00 00       	call   8010560d <release>
        return pid;
80104f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f66:	eb 56                	jmp    80104fbe <wait2+0x15c>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104f68:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f69:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104f70:	81 7d f4 14 47 11 80 	cmpl   $0x80114714,-0xc(%ebp)
80104f77:	0f 82 0a ff ff ff    	jb     80104e87 <wait2+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104f7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f81:	74 0d                	je     80104f90 <wait2+0x12e>
80104f83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f89:	8b 40 24             	mov    0x24(%eax),%eax
80104f8c:	85 c0                	test   %eax,%eax
80104f8e:	74 13                	je     80104fa3 <wait2+0x141>
      release(&ptable.lock);
80104f90:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80104f97:	e8 71 06 00 00       	call   8010560d <release>
      return -1;
80104f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa1:	eb 1b                	jmp    80104fbe <wait2+0x15c>
    }
        
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104fa3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa9:	c7 44 24 04 e0 1e 11 	movl   $0x80111ee0,0x4(%esp)
80104fb0:	80 
80104fb1:	89 04 24             	mov    %eax,(%esp)
80104fb4:	e8 7a 02 00 00       	call   80105233 <sleep>
  }
80104fb9:	e9 b6 fe ff ff       	jmp    80104e74 <wait2+0x12>
}
80104fbe:	c9                   	leave  
80104fbf:	c3                   	ret    

80104fc0 <register_handler>:

void
register_handler(sighandler_t sighandler)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
80104fc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fcc:	8b 40 18             	mov    0x18(%eax),%eax
80104fcf:	8b 40 44             	mov    0x44(%eax),%eax
80104fd2:	89 c2                	mov    %eax,%edx
80104fd4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fda:	8b 40 04             	mov    0x4(%eax),%eax
80104fdd:	89 54 24 04          	mov    %edx,0x4(%esp)
80104fe1:	89 04 24             	mov    %eax,(%esp)
80104fe4:	e8 41 3c 00 00       	call   80108c2a <uva2ka>
80104fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
80104fec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff2:	8b 40 18             	mov    0x18(%eax),%eax
80104ff5:	8b 40 44             	mov    0x44(%eax),%eax
80104ff8:	25 ff 0f 00 00       	and    $0xfff,%eax
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	75 0c                	jne    8010500d <register_handler+0x4d>
    panic("esp_offset == 0");
80105001:	c7 04 24 3d 90 10 80 	movl   $0x8010903d,(%esp)
80105008:	e8 30 b5 ff ff       	call   8010053d <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
8010500d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105013:	8b 40 18             	mov    0x18(%eax),%eax
80105016:	8b 40 44             	mov    0x44(%eax),%eax
80105019:	83 e8 04             	sub    $0x4,%eax
8010501c:	25 ff 0f 00 00       	and    $0xfff,%eax
80105021:	03 45 f4             	add    -0xc(%ebp),%eax
          = proc->tf->eip;
80105024:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010502b:	8b 52 18             	mov    0x18(%edx),%edx
8010502e:	8b 52 38             	mov    0x38(%edx),%edx
80105031:	89 10                	mov    %edx,(%eax)
  proc->tf->esp -= 4;
80105033:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105039:	8b 40 18             	mov    0x18(%eax),%eax
8010503c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105043:	8b 52 18             	mov    0x18(%edx),%edx
80105046:	8b 52 44             	mov    0x44(%edx),%edx
80105049:	83 ea 04             	sub    $0x4,%edx
8010504c:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
8010504f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105055:	8b 40 18             	mov    0x18(%eax),%eax
80105058:	8b 55 08             	mov    0x8(%ebp),%edx
8010505b:	89 50 38             	mov    %edx,0x38(%eax)
}
8010505e:	c9                   	leave  
8010505f:	c3                   	ret    

80105060 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80105066:	e8 ea f6 ff ff       	call   80104755 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010506b:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80105072:	e8 34 05 00 00       	call   801055ab <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105077:	c7 45 f4 14 1f 11 80 	movl   $0x80111f14,-0xc(%ebp)
8010507e:	eb 6f                	jmp    801050ef <scheduler+0x8f>
      if(p->state != RUNNABLE)
80105080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105083:	8b 40 0c             	mov    0xc(%eax),%eax
80105086:	83 f8 03             	cmp    $0x3,%eax
80105089:	75 5c                	jne    801050e7 <scheduler+0x87>
      #endif // 3Q
	
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
8010508b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010508e:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80105094:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105097:	89 04 24             	mov    %eax,(%esp)
8010509a:	e8 2f 35 00 00       	call   801085ce <switchuvm>
      p->state = RUNNING;
8010509f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a2:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->quanta = 1;
801050a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ac:	c7 80 94 00 00 00 01 	movl   $0x1,0x94(%eax)
801050b3:	00 00 00 
      swtch(&cpu->scheduler, proc->context);
801050b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050bc:	8b 40 1c             	mov    0x1c(%eax),%eax
801050bf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050c6:	83 c2 04             	add    $0x4,%edx
801050c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801050cd:	89 14 24             	mov    %edx,(%esp)
801050d0:	e8 cb 09 00 00       	call   80105aa0 <swtch>
      switchkvm();
801050d5:	e8 d7 34 00 00       	call   801085b1 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801050da:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801050e1:	00 00 00 00 
801050e5:	eb 01                	jmp    801050e8 <scheduler+0x88>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
801050e7:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050e8:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801050ef:	81 7d f4 14 47 11 80 	cmpl   $0x80114714,-0xc(%ebp)
801050f6:	72 88                	jb     80105080 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
801050f8:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
801050ff:	e8 09 05 00 00       	call   8010560d <release>

  }
80105104:	e9 5d ff ff ff       	jmp    80105066 <scheduler+0x6>

80105109 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80105109:	55                   	push   %ebp
8010510a:	89 e5                	mov    %esp,%ebp
8010510c:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
8010510f:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80105116:	e8 ae 05 00 00       	call   801056c9 <holding>
8010511b:	85 c0                	test   %eax,%eax
8010511d:	75 0c                	jne    8010512b <sched+0x22>
    panic("sched ptable.lock");
8010511f:	c7 04 24 4d 90 10 80 	movl   $0x8010904d,(%esp)
80105126:	e8 12 b4 ff ff       	call   8010053d <panic>
  if(cpu->ncli != 1)
8010512b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105131:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105137:	83 f8 01             	cmp    $0x1,%eax
8010513a:	74 0c                	je     80105148 <sched+0x3f>
    panic("sched locks");
8010513c:	c7 04 24 5f 90 10 80 	movl   $0x8010905f,(%esp)
80105143:	e8 f5 b3 ff ff       	call   8010053d <panic>
  if(proc->state == RUNNING)
80105148:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514e:	8b 40 0c             	mov    0xc(%eax),%eax
80105151:	83 f8 04             	cmp    $0x4,%eax
80105154:	75 0c                	jne    80105162 <sched+0x59>
    panic("sched running");
80105156:	c7 04 24 6b 90 10 80 	movl   $0x8010906b,(%esp)
8010515d:	e8 db b3 ff ff       	call   8010053d <panic>
  if(readeflags()&FL_IF)
80105162:	e8 d9 f5 ff ff       	call   80104740 <readeflags>
80105167:	25 00 02 00 00       	and    $0x200,%eax
8010516c:	85 c0                	test   %eax,%eax
8010516e:	74 0c                	je     8010517c <sched+0x73>
    panic("sched interruptible");
80105170:	c7 04 24 79 90 10 80 	movl   $0x80109079,(%esp)
80105177:	e8 c1 b3 ff ff       	call   8010053d <panic>
  intena = cpu->intena;
8010517c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105182:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105188:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
8010518b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105191:	8b 40 04             	mov    0x4(%eax),%eax
80105194:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010519b:	83 c2 1c             	add    $0x1c,%edx
8010519e:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a2:	89 14 24             	mov    %edx,(%esp)
801051a5:	e8 f6 08 00 00       	call   80105aa0 <swtch>
  cpu->intena = intena;
801051aa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051b3:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801051b9:	c9                   	leave  
801051ba:	c3                   	ret    

801051bb <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801051bb:	55                   	push   %ebp
801051bc:	89 e5                	mov    %esp,%ebp
801051be:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801051c1:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
801051c8:	e8 de 03 00 00       	call   801055ab <acquire>
  proc->state = RUNNABLE;
801051cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051d3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  proc->queuenum = ptable.FRR_COUNTER++;
801051da:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051e1:	a1 14 47 11 80       	mov    0x80114714,%eax
801051e6:	89 82 98 00 00 00    	mov    %eax,0x98(%edx)
801051ec:	83 c0 01             	add    $0x1,%eax
801051ef:	a3 14 47 11 80       	mov    %eax,0x80114714
  sched();
801051f4:	e8 10 ff ff ff       	call   80105109 <sched>
  release(&ptable.lock);
801051f9:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80105200:	e8 08 04 00 00       	call   8010560d <release>
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    

80105207 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105207:	55                   	push   %ebp
80105208:	89 e5                	mov    %esp,%ebp
8010520a:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010520d:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80105214:	e8 f4 03 00 00       	call   8010560d <release>

  if (first) {
80105219:	a1 20 c0 10 80       	mov    0x8010c020,%eax
8010521e:	85 c0                	test   %eax,%eax
80105220:	74 0f                	je     80105231 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105222:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80105229:	00 00 00 
    initlog();
8010522c:	e8 2f e5 ff ff       	call   80103760 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105231:	c9                   	leave  
80105232:	c3                   	ret    

80105233 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105233:	55                   	push   %ebp
80105234:	89 e5                	mov    %esp,%ebp
80105236:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80105239:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010523f:	85 c0                	test   %eax,%eax
80105241:	75 0c                	jne    8010524f <sleep+0x1c>
    panic("sleep");
80105243:	c7 04 24 8d 90 10 80 	movl   $0x8010908d,(%esp)
8010524a:	e8 ee b2 ff ff       	call   8010053d <panic>

  if(lk == 0)
8010524f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105253:	75 0c                	jne    80105261 <sleep+0x2e>
    panic("sleep without lk");
80105255:	c7 04 24 93 90 10 80 	movl   $0x80109093,(%esp)
8010525c:	e8 dc b2 ff ff       	call   8010053d <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105261:	81 7d 0c e0 1e 11 80 	cmpl   $0x80111ee0,0xc(%ebp)
80105268:	74 17                	je     80105281 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010526a:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80105271:	e8 35 03 00 00       	call   801055ab <acquire>
    release(lk);
80105276:	8b 45 0c             	mov    0xc(%ebp),%eax
80105279:	89 04 24             	mov    %eax,(%esp)
8010527c:	e8 8c 03 00 00       	call   8010560d <release>
  }

  // Go to sleep.
  if (proc)
80105281:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105287:	85 c0                	test   %eax,%eax
80105289:	74 12                	je     8010529d <sleep+0x6a>
    proc->sleeptime = ticks;
8010528b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105291:	8b 15 60 4f 11 80    	mov    0x80114f60,%edx
80105297:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  proc->chan = chan;
8010529d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a3:	8b 55 08             	mov    0x8(%ebp),%edx
801052a6:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801052a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052af:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801052b6:	e8 4e fe ff ff       	call   80105109 <sched>

  // Tidy up.
  proc->chan = 0;
801052bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c1:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801052c8:	81 7d 0c e0 1e 11 80 	cmpl   $0x80111ee0,0xc(%ebp)
801052cf:	74 17                	je     801052e8 <sleep+0xb5>
    release(&ptable.lock);
801052d1:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
801052d8:	e8 30 03 00 00       	call   8010560d <release>
    acquire(lk);
801052dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e0:	89 04 24             	mov    %eax,(%esp)
801052e3:	e8 c3 02 00 00       	call   801055ab <acquire>
  }
}
801052e8:	c9                   	leave  
801052e9:	c3                   	ret    

801052ea <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801052ea:	55                   	push   %ebp
801052eb:	89 e5                	mov    %esp,%ebp
801052ed:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801052f0:	c7 45 fc 14 1f 11 80 	movl   $0x80111f14,-0x4(%ebp)
801052f7:	e9 96 00 00 00       	jmp    80105392 <wakeup1+0xa8>
    if(p->state == SLEEPING && p->chan == chan){
801052fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ff:	8b 40 0c             	mov    0xc(%eax),%eax
80105302:	83 f8 02             	cmp    $0x2,%eax
80105305:	0f 85 80 00 00 00    	jne    8010538b <wakeup1+0xa1>
8010530b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010530e:	8b 40 20             	mov    0x20(%eax),%eax
80105311:	3b 45 08             	cmp    0x8(%ebp),%eax
80105314:	75 75                	jne    8010538b <wakeup1+0xa1>
      p->state = RUNNABLE;
80105316:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105319:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      if (p->priority == LOW)
80105320:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105323:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80105329:	83 f8 03             	cmp    $0x3,%eax
8010532c:	75 0f                	jne    8010533d <wakeup1+0x53>
	p->priority = MEDIUM;
8010532e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105331:	c7 80 9c 00 00 00 02 	movl   $0x2,0x9c(%eax)
80105338:	00 00 00 
8010533b:	eb 0d                	jmp    8010534a <wakeup1+0x60>
      else
	p->priority = HIGH;
8010533d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105340:	c7 80 9c 00 00 00 01 	movl   $0x1,0x9c(%eax)
80105347:	00 00 00 
      p->queuenum = ptable.FRR_COUNTER++;
8010534a:	a1 14 47 11 80       	mov    0x80114714,%eax
8010534f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105352:	89 82 98 00 00 00    	mov    %eax,0x98(%edx)
80105358:	83 c0 01             	add    $0x1,%eax
8010535b:	a3 14 47 11 80       	mov    %eax,0x80114714
      int tmp = ticks;
80105360:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80105365:	89 45 f8             	mov    %eax,-0x8(%ebp)
      tmp = tmp - p->sleeptime;
80105368:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010536b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105371:	29 45 f8             	sub    %eax,-0x8(%ebp)
      p->iotime = p->iotime + tmp;
80105374:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105377:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010537d:	89 c2                	mov    %eax,%edx
8010537f:	03 55 f8             	add    -0x8(%ebp),%edx
80105382:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105385:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010538b:	81 45 fc a0 00 00 00 	addl   $0xa0,-0x4(%ebp)
80105392:	81 7d fc 14 47 11 80 	cmpl   $0x80114714,-0x4(%ebp)
80105399:	0f 82 5d ff ff ff    	jb     801052fc <wakeup1+0x12>
      p->queuenum = ptable.FRR_COUNTER++;
      int tmp = ticks;
      tmp = tmp - p->sleeptime;
      p->iotime = p->iotime + tmp;
    }
}
8010539f:	c9                   	leave  
801053a0:	c3                   	ret    

801053a1 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801053a1:	55                   	push   %ebp
801053a2:	89 e5                	mov    %esp,%ebp
801053a4:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801053a7:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
801053ae:	e8 f8 01 00 00       	call   801055ab <acquire>
  wakeup1(chan);
801053b3:	8b 45 08             	mov    0x8(%ebp),%eax
801053b6:	89 04 24             	mov    %eax,(%esp)
801053b9:	e8 2c ff ff ff       	call   801052ea <wakeup1>
  release(&ptable.lock);
801053be:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
801053c5:	e8 43 02 00 00       	call   8010560d <release>
}
801053ca:	c9                   	leave  
801053cb:	c3                   	ret    

801053cc <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801053cc:	55                   	push   %ebp
801053cd:	89 e5                	mov    %esp,%ebp
801053cf:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
801053d2:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
801053d9:	e8 cd 01 00 00       	call   801055ab <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053de:	c7 45 f4 14 1f 11 80 	movl   $0x80111f14,-0xc(%ebp)
801053e5:	eb 44                	jmp    8010542b <kill+0x5f>
    if(p->pid == pid){
801053e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ea:	8b 40 10             	mov    0x10(%eax),%eax
801053ed:	3b 45 08             	cmp    0x8(%ebp),%eax
801053f0:	75 32                	jne    80105424 <kill+0x58>
      p->killed = 1;
801053f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801053fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ff:	8b 40 0c             	mov    0xc(%eax),%eax
80105402:	83 f8 02             	cmp    $0x2,%eax
80105405:	75 0a                	jne    80105411 <kill+0x45>
        p->state = RUNNABLE;
80105407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010540a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105411:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
80105418:	e8 f0 01 00 00       	call   8010560d <release>
      return 0;
8010541d:	b8 00 00 00 00       	mov    $0x0,%eax
80105422:	eb 21                	jmp    80105445 <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105424:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
8010542b:	81 7d f4 14 47 11 80 	cmpl   $0x80114714,-0xc(%ebp)
80105432:	72 b3                	jb     801053e7 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105434:	c7 04 24 e0 1e 11 80 	movl   $0x80111ee0,(%esp)
8010543b:	e8 cd 01 00 00       	call   8010560d <release>
  return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    

80105447 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105447:	55                   	push   %ebp
80105448:	89 e5                	mov    %esp,%ebp
8010544a:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010544d:	c7 45 f0 14 1f 11 80 	movl   $0x80111f14,-0x10(%ebp)
80105454:	e9 db 00 00 00       	jmp    80105534 <procdump+0xed>
    if(p->state == UNUSED)
80105459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010545c:	8b 40 0c             	mov    0xc(%eax),%eax
8010545f:	85 c0                	test   %eax,%eax
80105461:	0f 84 c5 00 00 00    	je     8010552c <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010546a:	8b 40 0c             	mov    0xc(%eax),%eax
8010546d:	83 f8 05             	cmp    $0x5,%eax
80105470:	77 23                	ja     80105495 <procdump+0x4e>
80105472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105475:	8b 40 0c             	mov    0xc(%eax),%eax
80105478:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
8010547f:	85 c0                	test   %eax,%eax
80105481:	74 12                	je     80105495 <procdump+0x4e>
      state = states[p->state];
80105483:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105486:	8b 40 0c             	mov    0xc(%eax),%eax
80105489:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105490:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105493:	eb 07                	jmp    8010549c <procdump+0x55>
    else
      state = "???";
80105495:	c7 45 ec a4 90 10 80 	movl   $0x801090a4,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010549c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010549f:	8d 50 6c             	lea    0x6c(%eax),%edx
801054a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054a5:	8b 40 10             	mov    0x10(%eax),%eax
801054a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
801054ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
801054af:	89 54 24 08          	mov    %edx,0x8(%esp)
801054b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b7:	c7 04 24 a8 90 10 80 	movl   $0x801090a8,(%esp)
801054be:	e8 de ae ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
801054c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054c6:	8b 40 0c             	mov    0xc(%eax),%eax
801054c9:	83 f8 02             	cmp    $0x2,%eax
801054cc:	75 50                	jne    8010551e <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801054ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054d1:	8b 40 1c             	mov    0x1c(%eax),%eax
801054d4:	8b 40 0c             	mov    0xc(%eax),%eax
801054d7:	83 c0 08             	add    $0x8,%eax
801054da:	8d 55 c4             	lea    -0x3c(%ebp),%edx
801054dd:	89 54 24 04          	mov    %edx,0x4(%esp)
801054e1:	89 04 24             	mov    %eax,(%esp)
801054e4:	e8 73 01 00 00       	call   8010565c <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801054e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801054f0:	eb 1b                	jmp    8010550d <procdump+0xc6>
        cprintf(" %p", pc[i]);
801054f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801054f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801054fd:	c7 04 24 b1 90 10 80 	movl   $0x801090b1,(%esp)
80105504:	e8 98 ae ff ff       	call   801003a1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105509:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010550d:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105511:	7f 0b                	jg     8010551e <procdump+0xd7>
80105513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105516:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010551a:	85 c0                	test   %eax,%eax
8010551c:	75 d4                	jne    801054f2 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010551e:	c7 04 24 b5 90 10 80 	movl   $0x801090b5,(%esp)
80105525:	e8 77 ae ff ff       	call   801003a1 <cprintf>
8010552a:	eb 01                	jmp    8010552d <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
8010552c:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010552d:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
80105534:	81 7d f0 14 47 11 80 	cmpl   $0x80114714,-0x10(%ebp)
8010553b:	0f 82 18 ff ff ff    	jb     80105459 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105541:	c9                   	leave  
80105542:	c3                   	ret    
	...

80105544 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105544:	55                   	push   %ebp
80105545:	89 e5                	mov    %esp,%ebp
80105547:	53                   	push   %ebx
80105548:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010554b:	9c                   	pushf  
8010554c:	5b                   	pop    %ebx
8010554d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80105550:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105553:	83 c4 10             	add    $0x10,%esp
80105556:	5b                   	pop    %ebx
80105557:	5d                   	pop    %ebp
80105558:	c3                   	ret    

80105559 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105559:	55                   	push   %ebp
8010555a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010555c:	fa                   	cli    
}
8010555d:	5d                   	pop    %ebp
8010555e:	c3                   	ret    

8010555f <sti>:

static inline void
sti(void)
{
8010555f:	55                   	push   %ebp
80105560:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105562:	fb                   	sti    
}
80105563:	5d                   	pop    %ebp
80105564:	c3                   	ret    

80105565 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105565:	55                   	push   %ebp
80105566:	89 e5                	mov    %esp,%ebp
80105568:	53                   	push   %ebx
80105569:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
8010556c:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010556f:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80105572:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105575:	89 c3                	mov    %eax,%ebx
80105577:	89 d8                	mov    %ebx,%eax
80105579:	f0 87 02             	lock xchg %eax,(%edx)
8010557c:	89 c3                	mov    %eax,%ebx
8010557e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105581:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	5b                   	pop    %ebx
80105588:	5d                   	pop    %ebp
80105589:	c3                   	ret    

8010558a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010558a:	55                   	push   %ebp
8010558b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010558d:	8b 45 08             	mov    0x8(%ebp),%eax
80105590:	8b 55 0c             	mov    0xc(%ebp),%edx
80105593:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105596:	8b 45 08             	mov    0x8(%ebp),%eax
80105599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010559f:	8b 45 08             	mov    0x8(%ebp),%eax
801055a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801055a9:	5d                   	pop    %ebp
801055aa:	c3                   	ret    

801055ab <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801055ab:	55                   	push   %ebp
801055ac:	89 e5                	mov    %esp,%ebp
801055ae:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801055b1:	e8 3d 01 00 00       	call   801056f3 <pushcli>
  if(holding(lk))
801055b6:	8b 45 08             	mov    0x8(%ebp),%eax
801055b9:	89 04 24             	mov    %eax,(%esp)
801055bc:	e8 08 01 00 00       	call   801056c9 <holding>
801055c1:	85 c0                	test   %eax,%eax
801055c3:	74 0c                	je     801055d1 <acquire+0x26>
    panic("acquire");
801055c5:	c7 04 24 e1 90 10 80 	movl   $0x801090e1,(%esp)
801055cc:	e8 6c af ff ff       	call   8010053d <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801055d1:	90                   	nop
801055d2:	8b 45 08             	mov    0x8(%ebp),%eax
801055d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801055dc:	00 
801055dd:	89 04 24             	mov    %eax,(%esp)
801055e0:	e8 80 ff ff ff       	call   80105565 <xchg>
801055e5:	85 c0                	test   %eax,%eax
801055e7:	75 e9                	jne    801055d2 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801055e9:	8b 45 08             	mov    0x8(%ebp),%eax
801055ec:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055f3:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801055f6:	8b 45 08             	mov    0x8(%ebp),%eax
801055f9:	83 c0 0c             	add    $0xc,%eax
801055fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105600:	8d 45 08             	lea    0x8(%ebp),%eax
80105603:	89 04 24             	mov    %eax,(%esp)
80105606:	e8 51 00 00 00       	call   8010565c <getcallerpcs>
}
8010560b:	c9                   	leave  
8010560c:	c3                   	ret    

8010560d <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010560d:	55                   	push   %ebp
8010560e:	89 e5                	mov    %esp,%ebp
80105610:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105613:	8b 45 08             	mov    0x8(%ebp),%eax
80105616:	89 04 24             	mov    %eax,(%esp)
80105619:	e8 ab 00 00 00       	call   801056c9 <holding>
8010561e:	85 c0                	test   %eax,%eax
80105620:	75 0c                	jne    8010562e <release+0x21>
    panic("release");
80105622:	c7 04 24 e9 90 10 80 	movl   $0x801090e9,(%esp)
80105629:	e8 0f af ff ff       	call   8010053d <panic>

  lk->pcs[0] = 0;
8010562e:	8b 45 08             	mov    0x8(%ebp),%eax
80105631:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105638:	8b 45 08             	mov    0x8(%ebp),%eax
8010563b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105642:	8b 45 08             	mov    0x8(%ebp),%eax
80105645:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010564c:	00 
8010564d:	89 04 24             	mov    %eax,(%esp)
80105650:	e8 10 ff ff ff       	call   80105565 <xchg>

  popcli();
80105655:	e8 e1 00 00 00       	call   8010573b <popcli>
}
8010565a:	c9                   	leave  
8010565b:	c3                   	ret    

8010565c <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010565c:	55                   	push   %ebp
8010565d:	89 e5                	mov    %esp,%ebp
8010565f:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105662:	8b 45 08             	mov    0x8(%ebp),%eax
80105665:	83 e8 08             	sub    $0x8,%eax
80105668:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010566b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105672:	eb 32                	jmp    801056a6 <getcallerpcs+0x4a>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105674:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105678:	74 47                	je     801056c1 <getcallerpcs+0x65>
8010567a:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105681:	76 3e                	jbe    801056c1 <getcallerpcs+0x65>
80105683:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105687:	74 38                	je     801056c1 <getcallerpcs+0x65>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105689:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010568c:	c1 e0 02             	shl    $0x2,%eax
8010568f:	03 45 0c             	add    0xc(%ebp),%eax
80105692:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105695:	8b 52 04             	mov    0x4(%edx),%edx
80105698:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
8010569a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010569d:	8b 00                	mov    (%eax),%eax
8010569f:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801056a2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056a6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056aa:	7e c8                	jle    80105674 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801056ac:	eb 13                	jmp    801056c1 <getcallerpcs+0x65>
    pcs[i] = 0;
801056ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056b1:	c1 e0 02             	shl    $0x2,%eax
801056b4:	03 45 0c             	add    0xc(%ebp),%eax
801056b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801056bd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056c1:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056c5:	7e e7                	jle    801056ae <getcallerpcs+0x52>
    pcs[i] = 0;
}
801056c7:	c9                   	leave  
801056c8:	c3                   	ret    

801056c9 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056c9:	55                   	push   %ebp
801056ca:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801056cc:	8b 45 08             	mov    0x8(%ebp),%eax
801056cf:	8b 00                	mov    (%eax),%eax
801056d1:	85 c0                	test   %eax,%eax
801056d3:	74 17                	je     801056ec <holding+0x23>
801056d5:	8b 45 08             	mov    0x8(%ebp),%eax
801056d8:	8b 50 08             	mov    0x8(%eax),%edx
801056db:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056e1:	39 c2                	cmp    %eax,%edx
801056e3:	75 07                	jne    801056ec <holding+0x23>
801056e5:	b8 01 00 00 00       	mov    $0x1,%eax
801056ea:	eb 05                	jmp    801056f1 <holding+0x28>
801056ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056f1:	5d                   	pop    %ebp
801056f2:	c3                   	ret    

801056f3 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056f3:	55                   	push   %ebp
801056f4:	89 e5                	mov    %esp,%ebp
801056f6:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801056f9:	e8 46 fe ff ff       	call   80105544 <readeflags>
801056fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105701:	e8 53 fe ff ff       	call   80105559 <cli>
  if(cpu->ncli++ == 0)
80105706:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010570c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105712:	85 d2                	test   %edx,%edx
80105714:	0f 94 c1             	sete   %cl
80105717:	83 c2 01             	add    $0x1,%edx
8010571a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105720:	84 c9                	test   %cl,%cl
80105722:	74 15                	je     80105739 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80105724:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010572a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010572d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105733:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105739:	c9                   	leave  
8010573a:	c3                   	ret    

8010573b <popcli>:

void
popcli(void)
{
8010573b:	55                   	push   %ebp
8010573c:	89 e5                	mov    %esp,%ebp
8010573e:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105741:	e8 fe fd ff ff       	call   80105544 <readeflags>
80105746:	25 00 02 00 00       	and    $0x200,%eax
8010574b:	85 c0                	test   %eax,%eax
8010574d:	74 0c                	je     8010575b <popcli+0x20>
    panic("popcli - interruptible");
8010574f:	c7 04 24 f1 90 10 80 	movl   $0x801090f1,(%esp)
80105756:	e8 e2 ad ff ff       	call   8010053d <panic>
  if(--cpu->ncli < 0)
8010575b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105761:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105767:	83 ea 01             	sub    $0x1,%edx
8010576a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105770:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105776:	85 c0                	test   %eax,%eax
80105778:	79 0c                	jns    80105786 <popcli+0x4b>
    panic("popcli");
8010577a:	c7 04 24 08 91 10 80 	movl   $0x80109108,(%esp)
80105781:	e8 b7 ad ff ff       	call   8010053d <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105786:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010578c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105792:	85 c0                	test   %eax,%eax
80105794:	75 15                	jne    801057ab <popcli+0x70>
80105796:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010579c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801057a2:	85 c0                	test   %eax,%eax
801057a4:	74 05                	je     801057ab <popcli+0x70>
    sti();
801057a6:	e8 b4 fd ff ff       	call   8010555f <sti>
}
801057ab:	c9                   	leave  
801057ac:	c3                   	ret    
801057ad:	00 00                	add    %al,(%eax)
	...

801057b0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	57                   	push   %edi
801057b4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801057b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057b8:	8b 55 10             	mov    0x10(%ebp),%edx
801057bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801057be:	89 cb                	mov    %ecx,%ebx
801057c0:	89 df                	mov    %ebx,%edi
801057c2:	89 d1                	mov    %edx,%ecx
801057c4:	fc                   	cld    
801057c5:	f3 aa                	rep stos %al,%es:(%edi)
801057c7:	89 ca                	mov    %ecx,%edx
801057c9:	89 fb                	mov    %edi,%ebx
801057cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057ce:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801057d1:	5b                   	pop    %ebx
801057d2:	5f                   	pop    %edi
801057d3:	5d                   	pop    %ebp
801057d4:	c3                   	ret    

801057d5 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801057d5:	55                   	push   %ebp
801057d6:	89 e5                	mov    %esp,%ebp
801057d8:	57                   	push   %edi
801057d9:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801057da:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057dd:	8b 55 10             	mov    0x10(%ebp),%edx
801057e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e3:	89 cb                	mov    %ecx,%ebx
801057e5:	89 df                	mov    %ebx,%edi
801057e7:	89 d1                	mov    %edx,%ecx
801057e9:	fc                   	cld    
801057ea:	f3 ab                	rep stos %eax,%es:(%edi)
801057ec:	89 ca                	mov    %ecx,%edx
801057ee:	89 fb                	mov    %edi,%ebx
801057f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057f3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801057f6:	5b                   	pop    %ebx
801057f7:	5f                   	pop    %edi
801057f8:	5d                   	pop    %ebp
801057f9:	c3                   	ret    

801057fa <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801057fa:	55                   	push   %ebp
801057fb:	89 e5                	mov    %esp,%ebp
801057fd:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105800:	8b 45 08             	mov    0x8(%ebp),%eax
80105803:	83 e0 03             	and    $0x3,%eax
80105806:	85 c0                	test   %eax,%eax
80105808:	75 49                	jne    80105853 <memset+0x59>
8010580a:	8b 45 10             	mov    0x10(%ebp),%eax
8010580d:	83 e0 03             	and    $0x3,%eax
80105810:	85 c0                	test   %eax,%eax
80105812:	75 3f                	jne    80105853 <memset+0x59>
    c &= 0xFF;
80105814:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010581b:	8b 45 10             	mov    0x10(%ebp),%eax
8010581e:	c1 e8 02             	shr    $0x2,%eax
80105821:	89 c2                	mov    %eax,%edx
80105823:	8b 45 0c             	mov    0xc(%ebp),%eax
80105826:	89 c1                	mov    %eax,%ecx
80105828:	c1 e1 18             	shl    $0x18,%ecx
8010582b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010582e:	c1 e0 10             	shl    $0x10,%eax
80105831:	09 c1                	or     %eax,%ecx
80105833:	8b 45 0c             	mov    0xc(%ebp),%eax
80105836:	c1 e0 08             	shl    $0x8,%eax
80105839:	09 c8                	or     %ecx,%eax
8010583b:	0b 45 0c             	or     0xc(%ebp),%eax
8010583e:	89 54 24 08          	mov    %edx,0x8(%esp)
80105842:	89 44 24 04          	mov    %eax,0x4(%esp)
80105846:	8b 45 08             	mov    0x8(%ebp),%eax
80105849:	89 04 24             	mov    %eax,(%esp)
8010584c:	e8 84 ff ff ff       	call   801057d5 <stosl>
80105851:	eb 19                	jmp    8010586c <memset+0x72>
  } else
    stosb(dst, c, n);
80105853:	8b 45 10             	mov    0x10(%ebp),%eax
80105856:	89 44 24 08          	mov    %eax,0x8(%esp)
8010585a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105861:	8b 45 08             	mov    0x8(%ebp),%eax
80105864:	89 04 24             	mov    %eax,(%esp)
80105867:	e8 44 ff ff ff       	call   801057b0 <stosb>
  return dst;
8010586c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010586f:	c9                   	leave  
80105870:	c3                   	ret    

80105871 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105871:	55                   	push   %ebp
80105872:	89 e5                	mov    %esp,%ebp
80105874:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105877:	8b 45 08             	mov    0x8(%ebp),%eax
8010587a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010587d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105880:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105883:	eb 32                	jmp    801058b7 <memcmp+0x46>
    if(*s1 != *s2)
80105885:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105888:	0f b6 10             	movzbl (%eax),%edx
8010588b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010588e:	0f b6 00             	movzbl (%eax),%eax
80105891:	38 c2                	cmp    %al,%dl
80105893:	74 1a                	je     801058af <memcmp+0x3e>
      return *s1 - *s2;
80105895:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105898:	0f b6 00             	movzbl (%eax),%eax
8010589b:	0f b6 d0             	movzbl %al,%edx
8010589e:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058a1:	0f b6 00             	movzbl (%eax),%eax
801058a4:	0f b6 c0             	movzbl %al,%eax
801058a7:	89 d1                	mov    %edx,%ecx
801058a9:	29 c1                	sub    %eax,%ecx
801058ab:	89 c8                	mov    %ecx,%eax
801058ad:	eb 1c                	jmp    801058cb <memcmp+0x5a>
    s1++, s2++;
801058af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058b3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801058b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058bb:	0f 95 c0             	setne  %al
801058be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058c2:	84 c0                	test   %al,%al
801058c4:	75 bf                	jne    80105885 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801058c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058cb:	c9                   	leave  
801058cc:	c3                   	ret    

801058cd <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058cd:	55                   	push   %ebp
801058ce:	89 e5                	mov    %esp,%ebp
801058d0:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801058d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801058d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801058d9:	8b 45 08             	mov    0x8(%ebp),%eax
801058dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058e5:	73 54                	jae    8010593b <memmove+0x6e>
801058e7:	8b 45 10             	mov    0x10(%ebp),%eax
801058ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058ed:	01 d0                	add    %edx,%eax
801058ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058f2:	76 47                	jbe    8010593b <memmove+0x6e>
    s += n;
801058f4:	8b 45 10             	mov    0x10(%ebp),%eax
801058f7:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801058fa:	8b 45 10             	mov    0x10(%ebp),%eax
801058fd:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105900:	eb 13                	jmp    80105915 <memmove+0x48>
      *--d = *--s;
80105902:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105906:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010590a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010590d:	0f b6 10             	movzbl (%eax),%edx
80105910:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105913:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105915:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105919:	0f 95 c0             	setne  %al
8010591c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105920:	84 c0                	test   %al,%al
80105922:	75 de                	jne    80105902 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105924:	eb 25                	jmp    8010594b <memmove+0x7e>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105926:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105929:	0f b6 10             	movzbl (%eax),%edx
8010592c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010592f:	88 10                	mov    %dl,(%eax)
80105931:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105935:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105939:	eb 01                	jmp    8010593c <memmove+0x6f>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010593b:	90                   	nop
8010593c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105940:	0f 95 c0             	setne  %al
80105943:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105947:	84 c0                	test   %al,%al
80105949:	75 db                	jne    80105926 <memmove+0x59>
      *d++ = *s++;

  return dst;
8010594b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010594e:	c9                   	leave  
8010594f:	c3                   	ret    

80105950 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105956:	8b 45 10             	mov    0x10(%ebp),%eax
80105959:	89 44 24 08          	mov    %eax,0x8(%esp)
8010595d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105960:	89 44 24 04          	mov    %eax,0x4(%esp)
80105964:	8b 45 08             	mov    0x8(%ebp),%eax
80105967:	89 04 24             	mov    %eax,(%esp)
8010596a:	e8 5e ff ff ff       	call   801058cd <memmove>
}
8010596f:	c9                   	leave  
80105970:	c3                   	ret    

80105971 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105971:	55                   	push   %ebp
80105972:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105974:	eb 0c                	jmp    80105982 <strncmp+0x11>
    n--, p++, q++;
80105976:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010597a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010597e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105982:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105986:	74 1a                	je     801059a2 <strncmp+0x31>
80105988:	8b 45 08             	mov    0x8(%ebp),%eax
8010598b:	0f b6 00             	movzbl (%eax),%eax
8010598e:	84 c0                	test   %al,%al
80105990:	74 10                	je     801059a2 <strncmp+0x31>
80105992:	8b 45 08             	mov    0x8(%ebp),%eax
80105995:	0f b6 10             	movzbl (%eax),%edx
80105998:	8b 45 0c             	mov    0xc(%ebp),%eax
8010599b:	0f b6 00             	movzbl (%eax),%eax
8010599e:	38 c2                	cmp    %al,%dl
801059a0:	74 d4                	je     80105976 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801059a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059a6:	75 07                	jne    801059af <strncmp+0x3e>
    return 0;
801059a8:	b8 00 00 00 00       	mov    $0x0,%eax
801059ad:	eb 18                	jmp    801059c7 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
801059af:	8b 45 08             	mov    0x8(%ebp),%eax
801059b2:	0f b6 00             	movzbl (%eax),%eax
801059b5:	0f b6 d0             	movzbl %al,%edx
801059b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801059bb:	0f b6 00             	movzbl (%eax),%eax
801059be:	0f b6 c0             	movzbl %al,%eax
801059c1:	89 d1                	mov    %edx,%ecx
801059c3:	29 c1                	sub    %eax,%ecx
801059c5:	89 c8                	mov    %ecx,%eax
}
801059c7:	5d                   	pop    %ebp
801059c8:	c3                   	ret    

801059c9 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801059c9:	55                   	push   %ebp
801059ca:	89 e5                	mov    %esp,%ebp
801059cc:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059cf:	8b 45 08             	mov    0x8(%ebp),%eax
801059d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059d5:	90                   	nop
801059d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059da:	0f 9f c0             	setg   %al
801059dd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801059e1:	84 c0                	test   %al,%al
801059e3:	74 30                	je     80105a15 <strncpy+0x4c>
801059e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801059e8:	0f b6 10             	movzbl (%eax),%edx
801059eb:	8b 45 08             	mov    0x8(%ebp),%eax
801059ee:	88 10                	mov    %dl,(%eax)
801059f0:	8b 45 08             	mov    0x8(%ebp),%eax
801059f3:	0f b6 00             	movzbl (%eax),%eax
801059f6:	84 c0                	test   %al,%al
801059f8:	0f 95 c0             	setne  %al
801059fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801059ff:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105a03:	84 c0                	test   %al,%al
80105a05:	75 cf                	jne    801059d6 <strncpy+0xd>
    ;
  while(n-- > 0)
80105a07:	eb 0c                	jmp    80105a15 <strncpy+0x4c>
    *s++ = 0;
80105a09:	8b 45 08             	mov    0x8(%ebp),%eax
80105a0c:	c6 00 00             	movb   $0x0,(%eax)
80105a0f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105a13:	eb 01                	jmp    80105a16 <strncpy+0x4d>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105a15:	90                   	nop
80105a16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a1a:	0f 9f c0             	setg   %al
80105a1d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a21:	84 c0                	test   %al,%al
80105a23:	75 e4                	jne    80105a09 <strncpy+0x40>
    *s++ = 0;
  return os;
80105a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a28:	c9                   	leave  
80105a29:	c3                   	ret    

80105a2a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a2a:	55                   	push   %ebp
80105a2b:	89 e5                	mov    %esp,%ebp
80105a2d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105a30:	8b 45 08             	mov    0x8(%ebp),%eax
80105a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a3a:	7f 05                	jg     80105a41 <safestrcpy+0x17>
    return os;
80105a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a3f:	eb 35                	jmp    80105a76 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a41:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a49:	7e 22                	jle    80105a6d <safestrcpy+0x43>
80105a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a4e:	0f b6 10             	movzbl (%eax),%edx
80105a51:	8b 45 08             	mov    0x8(%ebp),%eax
80105a54:	88 10                	mov    %dl,(%eax)
80105a56:	8b 45 08             	mov    0x8(%ebp),%eax
80105a59:	0f b6 00             	movzbl (%eax),%eax
80105a5c:	84 c0                	test   %al,%al
80105a5e:	0f 95 c0             	setne  %al
80105a61:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105a65:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105a69:	84 c0                	test   %al,%al
80105a6b:	75 d4                	jne    80105a41 <safestrcpy+0x17>
    ;
  *s = 0;
80105a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a70:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a76:	c9                   	leave  
80105a77:	c3                   	ret    

80105a78 <strlen>:

int
strlen(const char *s)
{
80105a78:	55                   	push   %ebp
80105a79:	89 e5                	mov    %esp,%ebp
80105a7b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a85:	eb 04                	jmp    80105a8b <strlen+0x13>
80105a87:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a8e:	03 45 08             	add    0x8(%ebp),%eax
80105a91:	0f b6 00             	movzbl (%eax),%eax
80105a94:	84 c0                	test   %al,%al
80105a96:	75 ef                	jne    80105a87 <strlen+0xf>
    ;
  return n;
80105a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a9b:	c9                   	leave  
80105a9c:	c3                   	ret    
80105a9d:	00 00                	add    %al,(%eax)
	...

80105aa0 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105aa0:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105aa4:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105aa8:	55                   	push   %ebp
  pushl %ebx
80105aa9:	53                   	push   %ebx
  pushl %esi
80105aaa:	56                   	push   %esi
  pushl %edi
80105aab:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105aac:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105aae:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105ab0:	5f                   	pop    %edi
  popl %esi
80105ab1:	5e                   	pop    %esi
  popl %ebx
80105ab2:	5b                   	pop    %ebx
  popl %ebp
80105ab3:	5d                   	pop    %ebp
  ret
80105ab4:	c3                   	ret    
80105ab5:	00 00                	add    %al,(%eax)
	...

80105ab8 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
80105ab8:	55                   	push   %ebp
80105ab9:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
80105abb:	8b 45 08             	mov    0x8(%ebp),%eax
80105abe:	8b 00                	mov    (%eax),%eax
80105ac0:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105ac3:	76 0f                	jbe    80105ad4 <fetchint+0x1c>
80105ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ac8:	8d 50 04             	lea    0x4(%eax),%edx
80105acb:	8b 45 08             	mov    0x8(%ebp),%eax
80105ace:	8b 00                	mov    (%eax),%eax
80105ad0:	39 c2                	cmp    %eax,%edx
80105ad2:	76 07                	jbe    80105adb <fetchint+0x23>
    return -1;
80105ad4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad9:	eb 0f                	jmp    80105aea <fetchint+0x32>
  *ip = *(int*)(addr);
80105adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ade:	8b 10                	mov    (%eax),%edx
80105ae0:	8b 45 10             	mov    0x10(%ebp),%eax
80105ae3:	89 10                	mov    %edx,(%eax)
  return 0;
80105ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105aea:	5d                   	pop    %ebp
80105aeb:	c3                   	ret    

80105aec <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
80105aec:	55                   	push   %ebp
80105aed:	89 e5                	mov    %esp,%ebp
80105aef:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
80105af2:	8b 45 08             	mov    0x8(%ebp),%eax
80105af5:	8b 00                	mov    (%eax),%eax
80105af7:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105afa:	77 07                	ja     80105b03 <fetchstr+0x17>
    return -1;
80105afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b01:	eb 45                	jmp    80105b48 <fetchstr+0x5c>
  *pp = (char*)addr;
80105b03:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b06:	8b 45 10             	mov    0x10(%ebp),%eax
80105b09:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
80105b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80105b0e:	8b 00                	mov    (%eax),%eax
80105b10:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105b13:	8b 45 10             	mov    0x10(%ebp),%eax
80105b16:	8b 00                	mov    (%eax),%eax
80105b18:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105b1b:	eb 1e                	jmp    80105b3b <fetchstr+0x4f>
    if(*s == 0)
80105b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b20:	0f b6 00             	movzbl (%eax),%eax
80105b23:	84 c0                	test   %al,%al
80105b25:	75 10                	jne    80105b37 <fetchstr+0x4b>
      return s - *pp;
80105b27:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b2a:	8b 45 10             	mov    0x10(%ebp),%eax
80105b2d:	8b 00                	mov    (%eax),%eax
80105b2f:	89 d1                	mov    %edx,%ecx
80105b31:	29 c1                	sub    %eax,%ecx
80105b33:	89 c8                	mov    %ecx,%eax
80105b35:	eb 11                	jmp    80105b48 <fetchstr+0x5c>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
80105b37:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b3e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b41:	72 da                	jb     80105b1d <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
80105b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b48:	c9                   	leave  
80105b49:	c3                   	ret    

80105b4a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b4a:	55                   	push   %ebp
80105b4b:	89 e5                	mov    %esp,%ebp
80105b4d:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
80105b50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b56:	8b 40 18             	mov    0x18(%eax),%eax
80105b59:	8b 50 44             	mov    0x44(%eax),%edx
80105b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b5f:	c1 e0 02             	shl    $0x2,%eax
80105b62:	01 d0                	add    %edx,%eax
80105b64:	8d 48 04             	lea    0x4(%eax),%ecx
80105b67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b70:	89 54 24 08          	mov    %edx,0x8(%esp)
80105b74:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105b78:	89 04 24             	mov    %eax,(%esp)
80105b7b:	e8 38 ff ff ff       	call   80105ab8 <fetchint>
}
80105b80:	c9                   	leave  
80105b81:	c3                   	ret    

80105b82 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b82:	55                   	push   %ebp
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105b88:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b92:	89 04 24             	mov    %eax,(%esp)
80105b95:	e8 b0 ff ff ff       	call   80105b4a <argint>
80105b9a:	85 c0                	test   %eax,%eax
80105b9c:	79 07                	jns    80105ba5 <argptr+0x23>
    return -1;
80105b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba3:	eb 3d                	jmp    80105be2 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ba8:	89 c2                	mov    %eax,%edx
80105baa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bb0:	8b 00                	mov    (%eax),%eax
80105bb2:	39 c2                	cmp    %eax,%edx
80105bb4:	73 16                	jae    80105bcc <argptr+0x4a>
80105bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bb9:	89 c2                	mov    %eax,%edx
80105bbb:	8b 45 10             	mov    0x10(%ebp),%eax
80105bbe:	01 c2                	add    %eax,%edx
80105bc0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bc6:	8b 00                	mov    (%eax),%eax
80105bc8:	39 c2                	cmp    %eax,%edx
80105bca:	76 07                	jbe    80105bd3 <argptr+0x51>
    return -1;
80105bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd1:	eb 0f                	jmp    80105be2 <argptr+0x60>
  *pp = (char*)i;
80105bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bd6:	89 c2                	mov    %eax,%edx
80105bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bdb:	89 10                	mov    %edx,(%eax)
  return 0;
80105bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105be2:	c9                   	leave  
80105be3:	c3                   	ret    

80105be4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105bea:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105bed:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf4:	89 04 24             	mov    %eax,(%esp)
80105bf7:	e8 4e ff ff ff       	call   80105b4a <argint>
80105bfc:	85 c0                	test   %eax,%eax
80105bfe:	79 07                	jns    80105c07 <argstr+0x23>
    return -1;
80105c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c05:	eb 1e                	jmp    80105c25 <argstr+0x41>
  return fetchstr(proc, addr, pp);
80105c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c0a:	89 c2                	mov    %eax,%edx
80105c0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c15:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c19:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c1d:	89 04 24             	mov    %eax,(%esp)
80105c20:	e8 c7 fe ff ff       	call   80105aec <fetchstr>
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    

80105c27 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105c27:	55                   	push   %ebp
80105c28:	89 e5                	mov    %esp,%ebp
80105c2a:	53                   	push   %ebx
80105c2b:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105c2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c34:	8b 40 18             	mov    0x18(%eax),%eax
80105c37:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
80105c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c41:	78 2e                	js     80105c71 <syscall+0x4a>
80105c43:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105c47:	7f 28                	jg     80105c71 <syscall+0x4a>
80105c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4c:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c53:	85 c0                	test   %eax,%eax
80105c55:	74 1a                	je     80105c71 <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
80105c57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c5d:	8b 58 18             	mov    0x18(%eax),%ebx
80105c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c63:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c6a:	ff d0                	call   *%eax
80105c6c:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105c6f:	eb 73                	jmp    80105ce4 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
80105c71:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105c75:	7e 30                	jle    80105ca7 <syscall+0x80>
80105c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7a:	83 f8 17             	cmp    $0x17,%eax
80105c7d:	77 28                	ja     80105ca7 <syscall+0x80>
80105c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c82:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	74 1a                	je     80105ca7 <syscall+0x80>
    proc->tf->eax = syscalls[num]();
80105c8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c93:	8b 58 18             	mov    0x18(%eax),%ebx
80105c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c99:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105ca0:	ff d0                	call   *%eax
80105ca2:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105ca5:	eb 3d                	jmp    80105ce4 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105ca7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cad:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105cb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105cb6:	8b 40 10             	mov    0x10(%eax),%eax
80105cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cbc:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105cc0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cc8:	c7 04 24 0f 91 10 80 	movl   $0x8010910f,(%esp)
80105ccf:	e8 cd a6 ff ff       	call   801003a1 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105cd4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cda:	8b 40 18             	mov    0x18(%eax),%eax
80105cdd:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105ce4:	83 c4 24             	add    $0x24,%esp
80105ce7:	5b                   	pop    %ebx
80105ce8:	5d                   	pop    %ebp
80105ce9:	c3                   	ret    
	...

80105cec <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105cec:	55                   	push   %ebp
80105ced:	89 e5                	mov    %esp,%ebp
80105cef:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105cf2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80105cfc:	89 04 24             	mov    %eax,(%esp)
80105cff:	e8 46 fe ff ff       	call   80105b4a <argint>
80105d04:	85 c0                	test   %eax,%eax
80105d06:	79 07                	jns    80105d0f <argfd+0x23>
    return -1;
80105d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0d:	eb 50                	jmp    80105d5f <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d12:	85 c0                	test   %eax,%eax
80105d14:	78 21                	js     80105d37 <argfd+0x4b>
80105d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d19:	83 f8 0f             	cmp    $0xf,%eax
80105d1c:	7f 19                	jg     80105d37 <argfd+0x4b>
80105d1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d24:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d27:	83 c2 08             	add    $0x8,%edx
80105d2a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d35:	75 07                	jne    80105d3e <argfd+0x52>
    return -1;
80105d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3c:	eb 21                	jmp    80105d5f <argfd+0x73>
  if(pfd)
80105d3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d42:	74 08                	je     80105d4c <argfd+0x60>
    *pfd = fd;
80105d44:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d47:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d4a:	89 10                	mov    %edx,(%eax)
  if(pf)
80105d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d50:	74 08                	je     80105d5a <argfd+0x6e>
    *pf = f;
80105d52:	8b 45 10             	mov    0x10(%ebp),%eax
80105d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d58:	89 10                	mov    %edx,(%eax)
  return 0;
80105d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d5f:	c9                   	leave  
80105d60:	c3                   	ret    

80105d61 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105d61:	55                   	push   %ebp
80105d62:	89 e5                	mov    %esp,%ebp
80105d64:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105d67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105d6e:	eb 30                	jmp    80105da0 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105d70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d76:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d79:	83 c2 08             	add    $0x8,%edx
80105d7c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d80:	85 c0                	test   %eax,%eax
80105d82:	75 18                	jne    80105d9c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105d84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d8d:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d90:	8b 55 08             	mov    0x8(%ebp),%edx
80105d93:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d9a:	eb 0f                	jmp    80105dab <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105d9c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105da0:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105da4:	7e ca                	jle    80105d70 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dab:	c9                   	leave  
80105dac:	c3                   	ret    

80105dad <sys_dup>:

int
sys_dup(void)
{
80105dad:	55                   	push   %ebp
80105dae:	89 e5                	mov    %esp,%ebp
80105db0:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105db3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105dc1:	00 
80105dc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dc9:	e8 1e ff ff ff       	call   80105cec <argfd>
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	79 07                	jns    80105dd9 <sys_dup+0x2c>
    return -1;
80105dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd7:	eb 29                	jmp    80105e02 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddc:	89 04 24             	mov    %eax,(%esp)
80105ddf:	e8 7d ff ff ff       	call   80105d61 <fdalloc>
80105de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105deb:	79 07                	jns    80105df4 <sys_dup+0x47>
    return -1;
80105ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df2:	eb 0e                	jmp    80105e02 <sys_dup+0x55>
  filedup(f);
80105df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df7:	89 04 24             	mov    %eax,(%esp)
80105dfa:	e8 cd b8 ff ff       	call   801016cc <filedup>
  return fd;
80105dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e02:	c9                   	leave  
80105e03:	c3                   	ret    

80105e04 <sys_read>:

int
sys_read(void)
{
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e0d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e11:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e18:	00 
80105e19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e20:	e8 c7 fe ff ff       	call   80105cec <argfd>
80105e25:	85 c0                	test   %eax,%eax
80105e27:	78 35                	js     80105e5e <sys_read+0x5a>
80105e29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e30:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e37:	e8 0e fd ff ff       	call   80105b4a <argint>
80105e3c:	85 c0                	test   %eax,%eax
80105e3e:	78 1e                	js     80105e5e <sys_read+0x5a>
80105e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e43:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e47:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e55:	e8 28 fd ff ff       	call   80105b82 <argptr>
80105e5a:	85 c0                	test   %eax,%eax
80105e5c:	79 07                	jns    80105e65 <sys_read+0x61>
    return -1;
80105e5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e63:	eb 19                	jmp    80105e7e <sys_read+0x7a>
  return fileread(f, p, n);
80105e65:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e68:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105e72:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e76:	89 04 24             	mov    %eax,(%esp)
80105e79:	e8 bb b9 ff ff       	call   80101839 <fileread>
}
80105e7e:	c9                   	leave  
80105e7f:	c3                   	ret    

80105e80 <sys_write>:

int
sys_write(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e89:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e94:	00 
80105e95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e9c:	e8 4b fe ff ff       	call   80105cec <argfd>
80105ea1:	85 c0                	test   %eax,%eax
80105ea3:	78 35                	js     80105eda <sys_write+0x5a>
80105ea5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105eb3:	e8 92 fc ff ff       	call   80105b4a <argint>
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	78 1e                	js     80105eda <sys_write+0x5a>
80105ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ebf:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ec3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ed1:	e8 ac fc ff ff       	call   80105b82 <argptr>
80105ed6:	85 c0                	test   %eax,%eax
80105ed8:	79 07                	jns    80105ee1 <sys_write+0x61>
    return -1;
80105eda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105edf:	eb 19                	jmp    80105efa <sys_write+0x7a>
  return filewrite(f, p, n);
80105ee1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ee4:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eea:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105eee:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ef2:	89 04 24             	mov    %eax,(%esp)
80105ef5:	e8 fb b9 ff ff       	call   801018f5 <filewrite>
}
80105efa:	c9                   	leave  
80105efb:	c3                   	ret    

80105efc <sys_close>:

int
sys_close(void)
{
80105efc:	55                   	push   %ebp
80105efd:	89 e5                	mov    %esp,%ebp
80105eff:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105f02:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f05:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f17:	e8 d0 fd ff ff       	call   80105cec <argfd>
80105f1c:	85 c0                	test   %eax,%eax
80105f1e:	79 07                	jns    80105f27 <sys_close+0x2b>
    return -1;
80105f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f25:	eb 24                	jmp    80105f4b <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105f27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f30:	83 c2 08             	add    $0x8,%edx
80105f33:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105f3a:	00 
  fileclose(f);
80105f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3e:	89 04 24             	mov    %eax,(%esp)
80105f41:	e8 ce b7 ff ff       	call   80101714 <fileclose>
  return 0;
80105f46:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f4b:	c9                   	leave  
80105f4c:	c3                   	ret    

80105f4d <sys_fstat>:

int
sys_fstat(void)
{
80105f4d:	55                   	push   %ebp
80105f4e:	89 e5                	mov    %esp,%ebp
80105f50:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105f53:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f56:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f5a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f61:	00 
80105f62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f69:	e8 7e fd ff ff       	call   80105cec <argfd>
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	78 1f                	js     80105f91 <sys_fstat+0x44>
80105f72:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105f79:	00 
80105f7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f88:	e8 f5 fb ff ff       	call   80105b82 <argptr>
80105f8d:	85 c0                	test   %eax,%eax
80105f8f:	79 07                	jns    80105f98 <sys_fstat+0x4b>
    return -1;
80105f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f96:	eb 12                	jmp    80105faa <sys_fstat+0x5d>
  return filestat(f, st);
80105f98:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fa2:	89 04 24             	mov    %eax,(%esp)
80105fa5:	e8 40 b8 ff ff       	call   801017ea <filestat>
}
80105faa:	c9                   	leave  
80105fab:	c3                   	ret    

80105fac <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105fac:	55                   	push   %ebp
80105fad:	89 e5                	mov    %esp,%ebp
80105faf:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105fb2:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105fb5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fc0:	e8 1f fc ff ff       	call   80105be4 <argstr>
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	78 17                	js     80105fe0 <sys_link+0x34>
80105fc9:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105fd7:	e8 08 fc ff ff       	call   80105be4 <argstr>
80105fdc:	85 c0                	test   %eax,%eax
80105fde:	79 0a                	jns    80105fea <sys_link+0x3e>
    return -1;
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe5:	e9 3c 01 00 00       	jmp    80106126 <sys_link+0x17a>
  if((ip = namei(old)) == 0)
80105fea:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105fed:	89 04 24             	mov    %eax,(%esp)
80105ff0:	e8 65 cb ff ff       	call   80102b5a <namei>
80105ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ffc:	75 0a                	jne    80106008 <sys_link+0x5c>
    return -1;
80105ffe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106003:	e9 1e 01 00 00       	jmp    80106126 <sys_link+0x17a>

  begin_trans();
80106008:	e8 60 d9 ff ff       	call   8010396d <begin_trans>

  ilock(ip);
8010600d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106010:	89 04 24             	mov    %eax,(%esp)
80106013:	e8 a0 bf ff ff       	call   80101fb8 <ilock>
  if(ip->type == T_DIR){
80106018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010601f:	66 83 f8 01          	cmp    $0x1,%ax
80106023:	75 1a                	jne    8010603f <sys_link+0x93>
    iunlockput(ip);
80106025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106028:	89 04 24             	mov    %eax,(%esp)
8010602b:	e8 0c c2 ff ff       	call   8010223c <iunlockput>
    commit_trans();
80106030:	e8 81 d9 ff ff       	call   801039b6 <commit_trans>
    return -1;
80106035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603a:	e9 e7 00 00 00       	jmp    80106126 <sys_link+0x17a>
  }

  ip->nlink++;
8010603f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106042:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106046:	8d 50 01             	lea    0x1(%eax),%edx
80106049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010604c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106053:	89 04 24             	mov    %eax,(%esp)
80106056:	e8 a1 bd ff ff       	call   80101dfc <iupdate>
  iunlock(ip);
8010605b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010605e:	89 04 24             	mov    %eax,(%esp)
80106061:	e8 a0 c0 ff ff       	call   80102106 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106066:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106069:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010606c:	89 54 24 04          	mov    %edx,0x4(%esp)
80106070:	89 04 24             	mov    %eax,(%esp)
80106073:	e8 04 cb ff ff       	call   80102b7c <nameiparent>
80106078:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010607b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010607f:	74 68                	je     801060e9 <sys_link+0x13d>
    goto bad;
  ilock(dp);
80106081:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106084:	89 04 24             	mov    %eax,(%esp)
80106087:	e8 2c bf ff ff       	call   80101fb8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010608c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010608f:	8b 10                	mov    (%eax),%edx
80106091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106094:	8b 00                	mov    (%eax),%eax
80106096:	39 c2                	cmp    %eax,%edx
80106098:	75 20                	jne    801060ba <sys_link+0x10e>
8010609a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609d:	8b 40 04             	mov    0x4(%eax),%eax
801060a0:	89 44 24 08          	mov    %eax,0x8(%esp)
801060a4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801060a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801060ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ae:	89 04 24             	mov    %eax,(%esp)
801060b1:	e8 e3 c7 ff ff       	call   80102899 <dirlink>
801060b6:	85 c0                	test   %eax,%eax
801060b8:	79 0d                	jns    801060c7 <sys_link+0x11b>
    iunlockput(dp);
801060ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060bd:	89 04 24             	mov    %eax,(%esp)
801060c0:	e8 77 c1 ff ff       	call   8010223c <iunlockput>
    goto bad;
801060c5:	eb 23                	jmp    801060ea <sys_link+0x13e>
  }
  iunlockput(dp);
801060c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ca:	89 04 24             	mov    %eax,(%esp)
801060cd:	e8 6a c1 ff ff       	call   8010223c <iunlockput>
  iput(ip);
801060d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d5:	89 04 24             	mov    %eax,(%esp)
801060d8:	e8 8e c0 ff ff       	call   8010216b <iput>

  commit_trans();
801060dd:	e8 d4 d8 ff ff       	call   801039b6 <commit_trans>

  return 0;
801060e2:	b8 00 00 00 00       	mov    $0x0,%eax
801060e7:	eb 3d                	jmp    80106126 <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801060e9:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
801060ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ed:	89 04 24             	mov    %eax,(%esp)
801060f0:	e8 c3 be ff ff       	call   80101fb8 <ilock>
  ip->nlink--;
801060f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060fc:	8d 50 ff             	lea    -0x1(%eax),%edx
801060ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106102:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106109:	89 04 24             	mov    %eax,(%esp)
8010610c:	e8 eb bc ff ff       	call   80101dfc <iupdate>
  iunlockput(ip);
80106111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106114:	89 04 24             	mov    %eax,(%esp)
80106117:	e8 20 c1 ff ff       	call   8010223c <iunlockput>
  commit_trans();
8010611c:	e8 95 d8 ff ff       	call   801039b6 <commit_trans>
  return -1;
80106121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106126:	c9                   	leave  
80106127:	c3                   	ret    

80106128 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106128:	55                   	push   %ebp
80106129:	89 e5                	mov    %esp,%ebp
8010612b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010612e:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106135:	eb 4b                	jmp    80106182 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106137:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106141:	00 
80106142:	89 44 24 08          	mov    %eax,0x8(%esp)
80106146:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106149:	89 44 24 04          	mov    %eax,0x4(%esp)
8010614d:	8b 45 08             	mov    0x8(%ebp),%eax
80106150:	89 04 24             	mov    %eax,(%esp)
80106153:	e8 56 c3 ff ff       	call   801024ae <readi>
80106158:	83 f8 10             	cmp    $0x10,%eax
8010615b:	74 0c                	je     80106169 <isdirempty+0x41>
      panic("isdirempty: readi");
8010615d:	c7 04 24 2b 91 10 80 	movl   $0x8010912b,(%esp)
80106164:	e8 d4 a3 ff ff       	call   8010053d <panic>
    if(de.inum != 0)
80106169:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010616d:	66 85 c0             	test   %ax,%ax
80106170:	74 07                	je     80106179 <isdirempty+0x51>
      return 0;
80106172:	b8 00 00 00 00       	mov    $0x0,%eax
80106177:	eb 1b                	jmp    80106194 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617c:	83 c0 10             	add    $0x10,%eax
8010617f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106182:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106185:	8b 45 08             	mov    0x8(%ebp),%eax
80106188:	8b 40 18             	mov    0x18(%eax),%eax
8010618b:	39 c2                	cmp    %eax,%edx
8010618d:	72 a8                	jb     80106137 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010618f:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106194:	c9                   	leave  
80106195:	c3                   	ret    

80106196 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106196:	55                   	push   %ebp
80106197:	89 e5                	mov    %esp,%ebp
80106199:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010619c:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010619f:	89 44 24 04          	mov    %eax,0x4(%esp)
801061a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061aa:	e8 35 fa ff ff       	call   80105be4 <argstr>
801061af:	85 c0                	test   %eax,%eax
801061b1:	79 0a                	jns    801061bd <sys_unlink+0x27>
    return -1;
801061b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b8:	e9 aa 01 00 00       	jmp    80106367 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
801061bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801061c0:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801061c3:	89 54 24 04          	mov    %edx,0x4(%esp)
801061c7:	89 04 24             	mov    %eax,(%esp)
801061ca:	e8 ad c9 ff ff       	call   80102b7c <nameiparent>
801061cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061d6:	75 0a                	jne    801061e2 <sys_unlink+0x4c>
    return -1;
801061d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061dd:	e9 85 01 00 00       	jmp    80106367 <sys_unlink+0x1d1>

  begin_trans();
801061e2:	e8 86 d7 ff ff       	call   8010396d <begin_trans>

  ilock(dp);
801061e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ea:	89 04 24             	mov    %eax,(%esp)
801061ed:	e8 c6 bd ff ff       	call   80101fb8 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801061f2:	c7 44 24 04 3d 91 10 	movl   $0x8010913d,0x4(%esp)
801061f9:	80 
801061fa:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061fd:	89 04 24             	mov    %eax,(%esp)
80106200:	e8 aa c5 ff ff       	call   801027af <namecmp>
80106205:	85 c0                	test   %eax,%eax
80106207:	0f 84 45 01 00 00    	je     80106352 <sys_unlink+0x1bc>
8010620d:	c7 44 24 04 3f 91 10 	movl   $0x8010913f,0x4(%esp)
80106214:	80 
80106215:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106218:	89 04 24             	mov    %eax,(%esp)
8010621b:	e8 8f c5 ff ff       	call   801027af <namecmp>
80106220:	85 c0                	test   %eax,%eax
80106222:	0f 84 2a 01 00 00    	je     80106352 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106228:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010622b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010622f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106232:	89 44 24 04          	mov    %eax,0x4(%esp)
80106236:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106239:	89 04 24             	mov    %eax,(%esp)
8010623c:	e8 90 c5 ff ff       	call   801027d1 <dirlookup>
80106241:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106244:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106248:	0f 84 03 01 00 00    	je     80106351 <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
8010624e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106251:	89 04 24             	mov    %eax,(%esp)
80106254:	e8 5f bd ff ff       	call   80101fb8 <ilock>

  if(ip->nlink < 1)
80106259:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106260:	66 85 c0             	test   %ax,%ax
80106263:	7f 0c                	jg     80106271 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80106265:	c7 04 24 42 91 10 80 	movl   $0x80109142,(%esp)
8010626c:	e8 cc a2 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106274:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106278:	66 83 f8 01          	cmp    $0x1,%ax
8010627c:	75 1f                	jne    8010629d <sys_unlink+0x107>
8010627e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106281:	89 04 24             	mov    %eax,(%esp)
80106284:	e8 9f fe ff ff       	call   80106128 <isdirempty>
80106289:	85 c0                	test   %eax,%eax
8010628b:	75 10                	jne    8010629d <sys_unlink+0x107>
    iunlockput(ip);
8010628d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106290:	89 04 24             	mov    %eax,(%esp)
80106293:	e8 a4 bf ff ff       	call   8010223c <iunlockput>
    goto bad;
80106298:	e9 b5 00 00 00       	jmp    80106352 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
8010629d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801062a4:	00 
801062a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801062ac:	00 
801062ad:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062b0:	89 04 24             	mov    %eax,(%esp)
801062b3:	e8 42 f5 ff ff       	call   801057fa <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801062b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
801062bb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801062c2:	00 
801062c3:	89 44 24 08          	mov    %eax,0x8(%esp)
801062c7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d1:	89 04 24             	mov    %eax,(%esp)
801062d4:	e8 40 c3 ff ff       	call   80102619 <writei>
801062d9:	83 f8 10             	cmp    $0x10,%eax
801062dc:	74 0c                	je     801062ea <sys_unlink+0x154>
    panic("unlink: writei");
801062de:	c7 04 24 54 91 10 80 	movl   $0x80109154,(%esp)
801062e5:	e8 53 a2 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR){
801062ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ed:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062f1:	66 83 f8 01          	cmp    $0x1,%ax
801062f5:	75 1c                	jne    80106313 <sys_unlink+0x17d>
    dp->nlink--;
801062f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062fa:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062fe:	8d 50 ff             	lea    -0x1(%eax),%edx
80106301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106304:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010630b:	89 04 24             	mov    %eax,(%esp)
8010630e:	e8 e9 ba ff ff       	call   80101dfc <iupdate>
  }
  iunlockput(dp);
80106313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106316:	89 04 24             	mov    %eax,(%esp)
80106319:	e8 1e bf ff ff       	call   8010223c <iunlockput>

  ip->nlink--;
8010631e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106321:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106325:	8d 50 ff             	lea    -0x1(%eax),%edx
80106328:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010632b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010632f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106332:	89 04 24             	mov    %eax,(%esp)
80106335:	e8 c2 ba ff ff       	call   80101dfc <iupdate>
  iunlockput(ip);
8010633a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010633d:	89 04 24             	mov    %eax,(%esp)
80106340:	e8 f7 be ff ff       	call   8010223c <iunlockput>

  commit_trans();
80106345:	e8 6c d6 ff ff       	call   801039b6 <commit_trans>

  return 0;
8010634a:	b8 00 00 00 00       	mov    $0x0,%eax
8010634f:	eb 16                	jmp    80106367 <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106351:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80106352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106355:	89 04 24             	mov    %eax,(%esp)
80106358:	e8 df be ff ff       	call   8010223c <iunlockput>
  commit_trans();
8010635d:	e8 54 d6 ff ff       	call   801039b6 <commit_trans>
  return -1;
80106362:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106367:	c9                   	leave  
80106368:	c3                   	ret    

80106369 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106369:	55                   	push   %ebp
8010636a:	89 e5                	mov    %esp,%ebp
8010636c:	83 ec 48             	sub    $0x48,%esp
8010636f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106372:	8b 55 10             	mov    0x10(%ebp),%edx
80106375:	8b 45 14             	mov    0x14(%ebp),%eax
80106378:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010637c:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106380:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106384:	8d 45 de             	lea    -0x22(%ebp),%eax
80106387:	89 44 24 04          	mov    %eax,0x4(%esp)
8010638b:	8b 45 08             	mov    0x8(%ebp),%eax
8010638e:	89 04 24             	mov    %eax,(%esp)
80106391:	e8 e6 c7 ff ff       	call   80102b7c <nameiparent>
80106396:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010639d:	75 0a                	jne    801063a9 <create+0x40>
    return 0;
8010639f:	b8 00 00 00 00       	mov    $0x0,%eax
801063a4:	e9 7e 01 00 00       	jmp    80106527 <create+0x1be>
  ilock(dp);
801063a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ac:	89 04 24             	mov    %eax,(%esp)
801063af:	e8 04 bc ff ff       	call   80101fb8 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801063b4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801063bb:	8d 45 de             	lea    -0x22(%ebp),%eax
801063be:	89 44 24 04          	mov    %eax,0x4(%esp)
801063c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c5:	89 04 24             	mov    %eax,(%esp)
801063c8:	e8 04 c4 ff ff       	call   801027d1 <dirlookup>
801063cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063d4:	74 47                	je     8010641d <create+0xb4>
    iunlockput(dp);
801063d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d9:	89 04 24             	mov    %eax,(%esp)
801063dc:	e8 5b be ff ff       	call   8010223c <iunlockput>
    ilock(ip);
801063e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e4:	89 04 24             	mov    %eax,(%esp)
801063e7:	e8 cc bb ff ff       	call   80101fb8 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801063ec:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801063f1:	75 15                	jne    80106408 <create+0x9f>
801063f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063f6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063fa:	66 83 f8 02          	cmp    $0x2,%ax
801063fe:	75 08                	jne    80106408 <create+0x9f>
      return ip;
80106400:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106403:	e9 1f 01 00 00       	jmp    80106527 <create+0x1be>
    iunlockput(ip);
80106408:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010640b:	89 04 24             	mov    %eax,(%esp)
8010640e:	e8 29 be ff ff       	call   8010223c <iunlockput>
    return 0;
80106413:	b8 00 00 00 00       	mov    $0x0,%eax
80106418:	e9 0a 01 00 00       	jmp    80106527 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010641d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106424:	8b 00                	mov    (%eax),%eax
80106426:	89 54 24 04          	mov    %edx,0x4(%esp)
8010642a:	89 04 24             	mov    %eax,(%esp)
8010642d:	e8 ed b8 ff ff       	call   80101d1f <ialloc>
80106432:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106435:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106439:	75 0c                	jne    80106447 <create+0xde>
    panic("create: ialloc");
8010643b:	c7 04 24 63 91 10 80 	movl   $0x80109163,(%esp)
80106442:	e8 f6 a0 ff ff       	call   8010053d <panic>

  ilock(ip);
80106447:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010644a:	89 04 24             	mov    %eax,(%esp)
8010644d:	e8 66 bb ff ff       	call   80101fb8 <ilock>
  ip->major = major;
80106452:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106455:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106459:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010645d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106460:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106464:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646b:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106474:	89 04 24             	mov    %eax,(%esp)
80106477:	e8 80 b9 ff ff       	call   80101dfc <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010647c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106481:	75 6a                	jne    801064ed <create+0x184>
    dp->nlink++;  // for ".."
80106483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106486:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010648a:	8d 50 01             	lea    0x1(%eax),%edx
8010648d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106490:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106497:	89 04 24             	mov    %eax,(%esp)
8010649a:	e8 5d b9 ff ff       	call   80101dfc <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010649f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a2:	8b 40 04             	mov    0x4(%eax),%eax
801064a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801064a9:	c7 44 24 04 3d 91 10 	movl   $0x8010913d,0x4(%esp)
801064b0:	80 
801064b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b4:	89 04 24             	mov    %eax,(%esp)
801064b7:	e8 dd c3 ff ff       	call   80102899 <dirlink>
801064bc:	85 c0                	test   %eax,%eax
801064be:	78 21                	js     801064e1 <create+0x178>
801064c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064c3:	8b 40 04             	mov    0x4(%eax),%eax
801064c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801064ca:	c7 44 24 04 3f 91 10 	movl   $0x8010913f,0x4(%esp)
801064d1:	80 
801064d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d5:	89 04 24             	mov    %eax,(%esp)
801064d8:	e8 bc c3 ff ff       	call   80102899 <dirlink>
801064dd:	85 c0                	test   %eax,%eax
801064df:	79 0c                	jns    801064ed <create+0x184>
      panic("create dots");
801064e1:	c7 04 24 72 91 10 80 	movl   $0x80109172,(%esp)
801064e8:	e8 50 a0 ff ff       	call   8010053d <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801064ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f0:	8b 40 04             	mov    0x4(%eax),%eax
801064f3:	89 44 24 08          	mov    %eax,0x8(%esp)
801064f7:	8d 45 de             	lea    -0x22(%ebp),%eax
801064fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801064fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106501:	89 04 24             	mov    %eax,(%esp)
80106504:	e8 90 c3 ff ff       	call   80102899 <dirlink>
80106509:	85 c0                	test   %eax,%eax
8010650b:	79 0c                	jns    80106519 <create+0x1b0>
    panic("create: dirlink");
8010650d:	c7 04 24 7e 91 10 80 	movl   $0x8010917e,(%esp)
80106514:	e8 24 a0 ff ff       	call   8010053d <panic>

  iunlockput(dp);
80106519:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010651c:	89 04 24             	mov    %eax,(%esp)
8010651f:	e8 18 bd ff ff       	call   8010223c <iunlockput>

  return ip;
80106524:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106527:	c9                   	leave  
80106528:	c3                   	ret    

80106529 <sys_open>:

int
sys_open(void)
{
80106529:	55                   	push   %ebp
8010652a:	89 e5                	mov    %esp,%ebp
8010652c:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010652f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106532:	89 44 24 04          	mov    %eax,0x4(%esp)
80106536:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010653d:	e8 a2 f6 ff ff       	call   80105be4 <argstr>
80106542:	85 c0                	test   %eax,%eax
80106544:	78 17                	js     8010655d <sys_open+0x34>
80106546:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106549:	89 44 24 04          	mov    %eax,0x4(%esp)
8010654d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106554:	e8 f1 f5 ff ff       	call   80105b4a <argint>
80106559:	85 c0                	test   %eax,%eax
8010655b:	79 0a                	jns    80106567 <sys_open+0x3e>
    return -1;
8010655d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106562:	e9 46 01 00 00       	jmp    801066ad <sys_open+0x184>
  if(omode & O_CREATE){
80106567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010656a:	25 00 02 00 00       	and    $0x200,%eax
8010656f:	85 c0                	test   %eax,%eax
80106571:	74 40                	je     801065b3 <sys_open+0x8a>
    begin_trans();
80106573:	e8 f5 d3 ff ff       	call   8010396d <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106578:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010657b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106582:	00 
80106583:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010658a:	00 
8010658b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106592:	00 
80106593:	89 04 24             	mov    %eax,(%esp)
80106596:	e8 ce fd ff ff       	call   80106369 <create>
8010659b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
8010659e:	e8 13 d4 ff ff       	call   801039b6 <commit_trans>
    if(ip == 0)
801065a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065a7:	75 5c                	jne    80106605 <sys_open+0xdc>
      return -1;
801065a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ae:	e9 fa 00 00 00       	jmp    801066ad <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
801065b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065b6:	89 04 24             	mov    %eax,(%esp)
801065b9:	e8 9c c5 ff ff       	call   80102b5a <namei>
801065be:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065c5:	75 0a                	jne    801065d1 <sys_open+0xa8>
      return -1;
801065c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cc:	e9 dc 00 00 00       	jmp    801066ad <sys_open+0x184>
    ilock(ip);
801065d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d4:	89 04 24             	mov    %eax,(%esp)
801065d7:	e8 dc b9 ff ff       	call   80101fb8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801065dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065df:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065e3:	66 83 f8 01          	cmp    $0x1,%ax
801065e7:	75 1c                	jne    80106605 <sys_open+0xdc>
801065e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065ec:	85 c0                	test   %eax,%eax
801065ee:	74 15                	je     80106605 <sys_open+0xdc>
      iunlockput(ip);
801065f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f3:	89 04 24             	mov    %eax,(%esp)
801065f6:	e8 41 bc ff ff       	call   8010223c <iunlockput>
      return -1;
801065fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106600:	e9 a8 00 00 00       	jmp    801066ad <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106605:	e8 62 b0 ff ff       	call   8010166c <filealloc>
8010660a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010660d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106611:	74 14                	je     80106627 <sys_open+0xfe>
80106613:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106616:	89 04 24             	mov    %eax,(%esp)
80106619:	e8 43 f7 ff ff       	call   80105d61 <fdalloc>
8010661e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106621:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106625:	79 23                	jns    8010664a <sys_open+0x121>
    if(f)
80106627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010662b:	74 0b                	je     80106638 <sys_open+0x10f>
      fileclose(f);
8010662d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106630:	89 04 24             	mov    %eax,(%esp)
80106633:	e8 dc b0 ff ff       	call   80101714 <fileclose>
    iunlockput(ip);
80106638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010663b:	89 04 24             	mov    %eax,(%esp)
8010663e:	e8 f9 bb ff ff       	call   8010223c <iunlockput>
    return -1;
80106643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106648:	eb 63                	jmp    801066ad <sys_open+0x184>
  }
  iunlock(ip);
8010664a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664d:	89 04 24             	mov    %eax,(%esp)
80106650:	e8 b1 ba ff ff       	call   80102106 <iunlock>

  f->type = FD_INODE;
80106655:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106658:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010665e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106661:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106664:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010666a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106674:	83 e0 01             	and    $0x1,%eax
80106677:	85 c0                	test   %eax,%eax
80106679:	0f 94 c2             	sete   %dl
8010667c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010667f:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106685:	83 e0 01             	and    $0x1,%eax
80106688:	84 c0                	test   %al,%al
8010668a:	75 0a                	jne    80106696 <sys_open+0x16d>
8010668c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010668f:	83 e0 02             	and    $0x2,%eax
80106692:	85 c0                	test   %eax,%eax
80106694:	74 07                	je     8010669d <sys_open+0x174>
80106696:	b8 01 00 00 00       	mov    $0x1,%eax
8010669b:	eb 05                	jmp    801066a2 <sys_open+0x179>
8010669d:	b8 00 00 00 00       	mov    $0x0,%eax
801066a2:	89 c2                	mov    %eax,%edx
801066a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a7:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801066aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801066ad:	c9                   	leave  
801066ae:	c3                   	ret    

801066af <sys_mkdir>:

int
sys_mkdir(void)
{
801066af:	55                   	push   %ebp
801066b0:	89 e5                	mov    %esp,%ebp
801066b2:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801066b5:	e8 b3 d2 ff ff       	call   8010396d <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801066ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801066c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066c8:	e8 17 f5 ff ff       	call   80105be4 <argstr>
801066cd:	85 c0                	test   %eax,%eax
801066cf:	78 2c                	js     801066fd <sys_mkdir+0x4e>
801066d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066d4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801066db:	00 
801066dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801066e3:	00 
801066e4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801066eb:	00 
801066ec:	89 04 24             	mov    %eax,(%esp)
801066ef:	e8 75 fc ff ff       	call   80106369 <create>
801066f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066fb:	75 0c                	jne    80106709 <sys_mkdir+0x5a>
    commit_trans();
801066fd:	e8 b4 d2 ff ff       	call   801039b6 <commit_trans>
    return -1;
80106702:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106707:	eb 15                	jmp    8010671e <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670c:	89 04 24             	mov    %eax,(%esp)
8010670f:	e8 28 bb ff ff       	call   8010223c <iunlockput>
  commit_trans();
80106714:	e8 9d d2 ff ff       	call   801039b6 <commit_trans>
  return 0;
80106719:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010671e:	c9                   	leave  
8010671f:	c3                   	ret    

80106720 <sys_mknod>:

int
sys_mknod(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106726:	e8 42 d2 ff ff       	call   8010396d <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
8010672b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010672e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106739:	e8 a6 f4 ff ff       	call   80105be4 <argstr>
8010673e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106745:	78 5e                	js     801067a5 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106747:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010674a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010674e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106755:	e8 f0 f3 ff ff       	call   80105b4a <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
8010675a:	85 c0                	test   %eax,%eax
8010675c:	78 47                	js     801067a5 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010675e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106761:	89 44 24 04          	mov    %eax,0x4(%esp)
80106765:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010676c:	e8 d9 f3 ff ff       	call   80105b4a <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106771:	85 c0                	test   %eax,%eax
80106773:	78 30                	js     801067a5 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106778:	0f bf c8             	movswl %ax,%ecx
8010677b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010677e:	0f bf d0             	movswl %ax,%edx
80106781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106784:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106788:	89 54 24 08          	mov    %edx,0x8(%esp)
8010678c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106793:	00 
80106794:	89 04 24             	mov    %eax,(%esp)
80106797:	e8 cd fb ff ff       	call   80106369 <create>
8010679c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010679f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067a3:	75 0c                	jne    801067b1 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
801067a5:	e8 0c d2 ff ff       	call   801039b6 <commit_trans>
    return -1;
801067aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067af:	eb 15                	jmp    801067c6 <sys_mknod+0xa6>
  }
  iunlockput(ip);
801067b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067b4:	89 04 24             	mov    %eax,(%esp)
801067b7:	e8 80 ba ff ff       	call   8010223c <iunlockput>
  commit_trans();
801067bc:	e8 f5 d1 ff ff       	call   801039b6 <commit_trans>
  return 0;
801067c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067c6:	c9                   	leave  
801067c7:	c3                   	ret    

801067c8 <sys_chdir>:

int
sys_chdir(void)
{
801067c8:	55                   	push   %ebp
801067c9:	89 e5                	mov    %esp,%ebp
801067cb:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801067ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801067d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067dc:	e8 03 f4 ff ff       	call   80105be4 <argstr>
801067e1:	85 c0                	test   %eax,%eax
801067e3:	78 14                	js     801067f9 <sys_chdir+0x31>
801067e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067e8:	89 04 24             	mov    %eax,(%esp)
801067eb:	e8 6a c3 ff ff       	call   80102b5a <namei>
801067f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067f7:	75 07                	jne    80106800 <sys_chdir+0x38>
    return -1;
801067f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067fe:	eb 57                	jmp    80106857 <sys_chdir+0x8f>
  ilock(ip);
80106800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106803:	89 04 24             	mov    %eax,(%esp)
80106806:	e8 ad b7 ff ff       	call   80101fb8 <ilock>
  if(ip->type != T_DIR){
8010680b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010680e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106812:	66 83 f8 01          	cmp    $0x1,%ax
80106816:	74 12                	je     8010682a <sys_chdir+0x62>
    iunlockput(ip);
80106818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010681b:	89 04 24             	mov    %eax,(%esp)
8010681e:	e8 19 ba ff ff       	call   8010223c <iunlockput>
    return -1;
80106823:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106828:	eb 2d                	jmp    80106857 <sys_chdir+0x8f>
  }
  iunlock(ip);
8010682a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010682d:	89 04 24             	mov    %eax,(%esp)
80106830:	e8 d1 b8 ff ff       	call   80102106 <iunlock>
  iput(proc->cwd);
80106835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010683b:	8b 40 68             	mov    0x68(%eax),%eax
8010683e:	89 04 24             	mov    %eax,(%esp)
80106841:	e8 25 b9 ff ff       	call   8010216b <iput>
  proc->cwd = ip;
80106846:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010684c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010684f:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106852:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106857:	c9                   	leave  
80106858:	c3                   	ret    

80106859 <sys_exec>:

int
sys_exec(void)
{
80106859:	55                   	push   %ebp
8010685a:	89 e5                	mov    %esp,%ebp
8010685c:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106862:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106865:	89 44 24 04          	mov    %eax,0x4(%esp)
80106869:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106870:	e8 6f f3 ff ff       	call   80105be4 <argstr>
80106875:	85 c0                	test   %eax,%eax
80106877:	78 1a                	js     80106893 <sys_exec+0x3a>
80106879:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010687f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106883:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010688a:	e8 bb f2 ff ff       	call   80105b4a <argint>
8010688f:	85 c0                	test   %eax,%eax
80106891:	79 0a                	jns    8010689d <sys_exec+0x44>
    return -1;
80106893:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106898:	e9 e2 00 00 00       	jmp    8010697f <sys_exec+0x126>
  }
  memset(argv, 0, sizeof(argv));
8010689d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801068a4:	00 
801068a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068ac:	00 
801068ad:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801068b3:	89 04 24             	mov    %eax,(%esp)
801068b6:	e8 3f ef ff ff       	call   801057fa <memset>
  for(i=0;; i++){
801068bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801068c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c5:	83 f8 1f             	cmp    $0x1f,%eax
801068c8:	76 0a                	jbe    801068d4 <sys_exec+0x7b>
      return -1;
801068ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068cf:	e9 ab 00 00 00       	jmp    8010697f <sys_exec+0x126>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
801068d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068d7:	c1 e0 02             	shl    $0x2,%eax
801068da:	89 c2                	mov    %eax,%edx
801068dc:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801068e2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801068e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068eb:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
801068f1:	89 54 24 08          	mov    %edx,0x8(%esp)
801068f5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801068f9:	89 04 24             	mov    %eax,(%esp)
801068fc:	e8 b7 f1 ff ff       	call   80105ab8 <fetchint>
80106901:	85 c0                	test   %eax,%eax
80106903:	79 07                	jns    8010690c <sys_exec+0xb3>
      return -1;
80106905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690a:	eb 73                	jmp    8010697f <sys_exec+0x126>
    if(uarg == 0){
8010690c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106912:	85 c0                	test   %eax,%eax
80106914:	75 26                	jne    8010693c <sys_exec+0xe3>
      argv[i] = 0;
80106916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106919:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106920:	00 00 00 00 
      break;
80106924:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106928:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010692e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106932:	89 04 24             	mov    %eax,(%esp)
80106935:	e8 b2 a7 ff ff       	call   801010ec <exec>
8010693a:	eb 43                	jmp    8010697f <sys_exec+0x126>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
8010693c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010693f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106946:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010694c:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
8010694f:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106955:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010695b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010695f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106963:	89 04 24             	mov    %eax,(%esp)
80106966:	e8 81 f1 ff ff       	call   80105aec <fetchstr>
8010696b:	85 c0                	test   %eax,%eax
8010696d:	79 07                	jns    80106976 <sys_exec+0x11d>
      return -1;
8010696f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106974:	eb 09                	jmp    8010697f <sys_exec+0x126>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106976:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
8010697a:	e9 43 ff ff ff       	jmp    801068c2 <sys_exec+0x69>
  return exec(path, argv);
}
8010697f:	c9                   	leave  
80106980:	c3                   	ret    

80106981 <sys_pipe>:

int
sys_pipe(void)
{
80106981:	55                   	push   %ebp
80106982:	89 e5                	mov    %esp,%ebp
80106984:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106987:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010698e:	00 
8010698f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106992:	89 44 24 04          	mov    %eax,0x4(%esp)
80106996:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010699d:	e8 e0 f1 ff ff       	call   80105b82 <argptr>
801069a2:	85 c0                	test   %eax,%eax
801069a4:	79 0a                	jns    801069b0 <sys_pipe+0x2f>
    return -1;
801069a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ab:	e9 9b 00 00 00       	jmp    80106a4b <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801069b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801069b7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069ba:	89 04 24             	mov    %eax,(%esp)
801069bd:	e8 c6 d9 ff ff       	call   80104388 <pipealloc>
801069c2:	85 c0                	test   %eax,%eax
801069c4:	79 07                	jns    801069cd <sys_pipe+0x4c>
    return -1;
801069c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069cb:	eb 7e                	jmp    80106a4b <sys_pipe+0xca>
  fd0 = -1;
801069cd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801069d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069d7:	89 04 24             	mov    %eax,(%esp)
801069da:	e8 82 f3 ff ff       	call   80105d61 <fdalloc>
801069df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069e6:	78 14                	js     801069fc <sys_pipe+0x7b>
801069e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069eb:	89 04 24             	mov    %eax,(%esp)
801069ee:	e8 6e f3 ff ff       	call   80105d61 <fdalloc>
801069f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801069f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801069fa:	79 37                	jns    80106a33 <sys_pipe+0xb2>
    if(fd0 >= 0)
801069fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a00:	78 14                	js     80106a16 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106a02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a0b:	83 c2 08             	add    $0x8,%edx
80106a0e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106a15:	00 
    fileclose(rf);
80106a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a19:	89 04 24             	mov    %eax,(%esp)
80106a1c:	e8 f3 ac ff ff       	call   80101714 <fileclose>
    fileclose(wf);
80106a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a24:	89 04 24             	mov    %eax,(%esp)
80106a27:	e8 e8 ac ff ff       	call   80101714 <fileclose>
    return -1;
80106a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a31:	eb 18                	jmp    80106a4b <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a39:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a3e:	8d 50 04             	lea    0x4(%eax),%edx
80106a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a44:	89 02                	mov    %eax,(%edx)
  return 0;
80106a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a4b:	c9                   	leave  
80106a4c:	c3                   	ret    
80106a4d:	00 00                	add    %al,(%eax)
	...

80106a50 <sys_fork>:
#include "proc.h"


int
sys_fork(void)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106a56:	e8 65 e0 ff ff       	call   80104ac0 <fork>
}
80106a5b:	c9                   	leave  
80106a5c:	c3                   	ret    

80106a5d <sys_exit>:

int
sys_exit(void)
{
80106a5d:	55                   	push   %ebp
80106a5e:	89 e5                	mov    %esp,%ebp
80106a60:	83 ec 08             	sub    $0x8,%esp
  exit();
80106a63:	e8 bb e1 ff ff       	call   80104c23 <exit>
  return 0;  // not reached
80106a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a6d:	c9                   	leave  
80106a6e:	c3                   	ret    

80106a6f <sys_wait>:

int
sys_wait(void)
{
80106a6f:	55                   	push   %ebp
80106a70:	89 e5                	mov    %esp,%ebp
80106a72:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106a75:	e8 d6 e2 ff ff       	call   80104d50 <wait>
}
80106a7a:	c9                   	leave  
80106a7b:	c3                   	ret    

80106a7c <sys_wait2>:

int
sys_wait2(void)
{
80106a7c:	55                   	push   %ebp
80106a7d:	89 e5                	mov    %esp,%ebp
80106a7f:	83 ec 28             	sub    $0x28,%esp
  int *wtime, *rtime, *iotime; 
  if (argptr(0, (void*)&wtime, sizeof(wtime)) <0) return -1;
80106a82:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106a89:	00 
80106a8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a98:	e8 e5 f0 ff ff       	call   80105b82 <argptr>
80106a9d:	85 c0                	test   %eax,%eax
80106a9f:	79 07                	jns    80106aa8 <sys_wait2+0x2c>
80106aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa6:	eb 65                	jmp    80106b0d <sys_wait2+0x91>
  if (argptr(1, (void*)&rtime, sizeof(rtime)) <0) return -1;
80106aa8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106aaf:	00 
80106ab0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ab7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106abe:	e8 bf f0 ff ff       	call   80105b82 <argptr>
80106ac3:	85 c0                	test   %eax,%eax
80106ac5:	79 07                	jns    80106ace <sys_wait2+0x52>
80106ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106acc:	eb 3f                	jmp    80106b0d <sys_wait2+0x91>
  if (argptr(2, (void*)&iotime, sizeof(iotime)) <0) return -1;
80106ace:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106ad5:	00 
80106ad6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106add:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106ae4:	e8 99 f0 ff ff       	call   80105b82 <argptr>
80106ae9:	85 c0                	test   %eax,%eax
80106aeb:	79 07                	jns    80106af4 <sys_wait2+0x78>
80106aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af2:	eb 19                	jmp    80106b0d <sys_wait2+0x91>
  return wait2(wtime, rtime, iotime);
80106af4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106afd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106b01:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b05:	89 04 24             	mov    %eax,(%esp)
80106b08:	e8 55 e3 ff ff       	call   80104e62 <wait2>
}
80106b0d:	c9                   	leave  
80106b0e:	c3                   	ret    

80106b0f <sys_kill>:

int
sys_kill(void)
{
80106b0f:	55                   	push   %ebp
80106b10:	89 e5                	mov    %esp,%ebp
80106b12:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b18:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b23:	e8 22 f0 ff ff       	call   80105b4a <argint>
80106b28:	85 c0                	test   %eax,%eax
80106b2a:	79 07                	jns    80106b33 <sys_kill+0x24>
    return -1;
80106b2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b31:	eb 0b                	jmp    80106b3e <sys_kill+0x2f>
  return kill(pid);
80106b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b36:	89 04 24             	mov    %eax,(%esp)
80106b39:	e8 8e e8 ff ff       	call   801053cc <kill>
}
80106b3e:	c9                   	leave  
80106b3f:	c3                   	ret    

80106b40 <sys_getpid>:

int
sys_getpid(void)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106b43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b49:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b4c:	5d                   	pop    %ebp
80106b4d:	c3                   	ret    

80106b4e <sys_sbrk>:

int
sys_sbrk(void)
{
80106b4e:	55                   	push   %ebp
80106b4f:	89 e5                	mov    %esp,%ebp
80106b51:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106b54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b62:	e8 e3 ef ff ff       	call   80105b4a <argint>
80106b67:	85 c0                	test   %eax,%eax
80106b69:	79 07                	jns    80106b72 <sys_sbrk+0x24>
    return -1;
80106b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b70:	eb 24                	jmp    80106b96 <sys_sbrk+0x48>
  addr = proc->sz;
80106b72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b78:	8b 00                	mov    (%eax),%eax
80106b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b80:	89 04 24             	mov    %eax,(%esp)
80106b83:	e8 93 de ff ff       	call   80104a1b <growproc>
80106b88:	85 c0                	test   %eax,%eax
80106b8a:	79 07                	jns    80106b93 <sys_sbrk+0x45>
    return -1;
80106b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b91:	eb 03                	jmp    80106b96 <sys_sbrk+0x48>
  return addr;
80106b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b96:	c9                   	leave  
80106b97:	c3                   	ret    

80106b98 <sys_sleep>:

int
sys_sleep(void)
{
80106b98:	55                   	push   %ebp
80106b99:	89 e5                	mov    %esp,%ebp
80106b9b:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106b9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ba5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bac:	e8 99 ef ff ff       	call   80105b4a <argint>
80106bb1:	85 c0                	test   %eax,%eax
80106bb3:	79 07                	jns    80106bbc <sys_sleep+0x24>
    return -1;
80106bb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bba:	eb 6c                	jmp    80106c28 <sys_sleep+0x90>
  acquire(&tickslock);
80106bbc:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106bc3:	e8 e3 e9 ff ff       	call   801055ab <acquire>
  ticks0 = ticks;
80106bc8:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80106bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106bd0:	eb 34                	jmp    80106c06 <sys_sleep+0x6e>
    if(proc->killed){
80106bd2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd8:	8b 40 24             	mov    0x24(%eax),%eax
80106bdb:	85 c0                	test   %eax,%eax
80106bdd:	74 13                	je     80106bf2 <sys_sleep+0x5a>
      release(&tickslock);
80106bdf:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106be6:	e8 22 ea ff ff       	call   8010560d <release>
      return -1;
80106beb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bf0:	eb 36                	jmp    80106c28 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106bf2:	c7 44 24 04 20 47 11 	movl   $0x80114720,0x4(%esp)
80106bf9:	80 
80106bfa:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80106c01:	e8 2d e6 ff ff       	call   80105233 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106c06:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80106c0b:	89 c2                	mov    %eax,%edx
80106c0d:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c13:	39 c2                	cmp    %eax,%edx
80106c15:	72 bb                	jb     80106bd2 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106c17:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106c1e:	e8 ea e9 ff ff       	call   8010560d <release>
  return 0;
80106c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c28:	c9                   	leave  
80106c29:	c3                   	ret    

80106c2a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c2a:	55                   	push   %ebp
80106c2b:	89 e5                	mov    %esp,%ebp
80106c2d:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106c30:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106c37:	e8 6f e9 ff ff       	call   801055ab <acquire>
  xticks = ticks;
80106c3c:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80106c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106c44:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106c4b:	e8 bd e9 ff ff       	call   8010560d <release>
  return xticks;
80106c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c53:	c9                   	leave  
80106c54:	c3                   	ret    

80106c55 <sys_add_path>:

// assignment1 - 1.2 - returning to the "real" implementation in sh.c
int
sys_add_path(void) {
80106c55:	55                   	push   %ebp
80106c56:	89 e5                	mov    %esp,%ebp
80106c58:	83 ec 28             	sub    $0x28,%esp
          char *path;
          if(argstr(0, &path) < 0)
80106c5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c69:	e8 76 ef ff ff       	call   80105be4 <argstr>
80106c6e:	85 c0                	test   %eax,%eax
80106c70:	79 07                	jns    80106c79 <sys_add_path+0x24>
            return -1;
80106c72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c77:	eb 0b                	jmp    80106c84 <sys_add_path+0x2f>
          return add_path(path);
80106c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c7c:	89 04 24             	mov    %eax,(%esp)
80106c7f:	e8 3e a9 ff ff       	call   801015c2 <add_path>

}
80106c84:	c9                   	leave  
80106c85:	c3                   	ret    
	...

80106c88 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106c88:	55                   	push   %ebp
80106c89:	89 e5                	mov    %esp,%ebp
80106c8b:	83 ec 08             	sub    $0x8,%esp
80106c8e:	8b 55 08             	mov    0x8(%ebp),%edx
80106c91:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c94:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106c98:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c9b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106c9f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ca3:	ee                   	out    %al,(%dx)
}
80106ca4:	c9                   	leave  
80106ca5:	c3                   	ret    

80106ca6 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106ca6:	55                   	push   %ebp
80106ca7:	89 e5                	mov    %esp,%ebp
80106ca9:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106cac:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106cb3:	00 
80106cb4:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106cbb:	e8 c8 ff ff ff       	call   80106c88 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106cc0:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106cc7:	00 
80106cc8:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106ccf:	e8 b4 ff ff ff       	call   80106c88 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106cd4:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106cdb:	00 
80106cdc:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106ce3:	e8 a0 ff ff ff       	call   80106c88 <outb>
  picenable(IRQ_TIMER);
80106ce8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cef:	e8 1d d5 ff ff       	call   80104211 <picenable>
}
80106cf4:	c9                   	leave  
80106cf5:	c3                   	ret    
	...

80106cf8 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106cf8:	1e                   	push   %ds
  pushl %es
80106cf9:	06                   	push   %es
  pushl %fs
80106cfa:	0f a0                	push   %fs
  pushl %gs
80106cfc:	0f a8                	push   %gs
  pushal
80106cfe:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106cff:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d03:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d05:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106d07:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106d0b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106d0d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d0f:	54                   	push   %esp
  call trap
80106d10:	e8 de 01 00 00       	call   80106ef3 <trap>
  addl $4, %esp
80106d15:	83 c4 04             	add    $0x4,%esp

80106d18 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d18:	61                   	popa   
  popl %gs
80106d19:	0f a9                	pop    %gs
  popl %fs
80106d1b:	0f a1                	pop    %fs
  popl %es
80106d1d:	07                   	pop    %es
  popl %ds
80106d1e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d1f:	83 c4 08             	add    $0x8,%esp
  iret
80106d22:	cf                   	iret   
	...

80106d24 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106d24:	55                   	push   %ebp
80106d25:	89 e5                	mov    %esp,%ebp
80106d27:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d2d:	83 e8 01             	sub    $0x1,%eax
80106d30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d34:	8b 45 08             	mov    0x8(%ebp),%eax
80106d37:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3e:	c1 e8 10             	shr    $0x10,%eax
80106d41:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106d45:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d48:	0f 01 18             	lidtl  (%eax)
}
80106d4b:	c9                   	leave  
80106d4c:	c3                   	ret    

80106d4d <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106d4d:	55                   	push   %ebp
80106d4e:	89 e5                	mov    %esp,%ebp
80106d50:	53                   	push   %ebx
80106d51:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d54:	0f 20 d3             	mov    %cr2,%ebx
80106d57:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106d5d:	83 c4 10             	add    $0x10,%esp
80106d60:	5b                   	pop    %ebx
80106d61:	5d                   	pop    %ebp
80106d62:	c3                   	ret    

80106d63 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106d63:	55                   	push   %ebp
80106d64:	89 e5                	mov    %esp,%ebp
80106d66:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d70:	e9 c3 00 00 00       	jmp    80106e38 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d78:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106d7f:	89 c2                	mov    %eax,%edx
80106d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d84:	66 89 14 c5 60 47 11 	mov    %dx,-0x7feeb8a0(,%eax,8)
80106d8b:	80 
80106d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d8f:	66 c7 04 c5 62 47 11 	movw   $0x8,-0x7feeb89e(,%eax,8)
80106d96:	80 08 00 
80106d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d9c:	0f b6 14 c5 64 47 11 	movzbl -0x7feeb89c(,%eax,8),%edx
80106da3:	80 
80106da4:	83 e2 e0             	and    $0xffffffe0,%edx
80106da7:	88 14 c5 64 47 11 80 	mov    %dl,-0x7feeb89c(,%eax,8)
80106dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106db1:	0f b6 14 c5 64 47 11 	movzbl -0x7feeb89c(,%eax,8),%edx
80106db8:	80 
80106db9:	83 e2 1f             	and    $0x1f,%edx
80106dbc:	88 14 c5 64 47 11 80 	mov    %dl,-0x7feeb89c(,%eax,8)
80106dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dc6:	0f b6 14 c5 65 47 11 	movzbl -0x7feeb89b(,%eax,8),%edx
80106dcd:	80 
80106dce:	83 e2 f0             	and    $0xfffffff0,%edx
80106dd1:	83 ca 0e             	or     $0xe,%edx
80106dd4:	88 14 c5 65 47 11 80 	mov    %dl,-0x7feeb89b(,%eax,8)
80106ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dde:	0f b6 14 c5 65 47 11 	movzbl -0x7feeb89b(,%eax,8),%edx
80106de5:	80 
80106de6:	83 e2 ef             	and    $0xffffffef,%edx
80106de9:	88 14 c5 65 47 11 80 	mov    %dl,-0x7feeb89b(,%eax,8)
80106df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df3:	0f b6 14 c5 65 47 11 	movzbl -0x7feeb89b(,%eax,8),%edx
80106dfa:	80 
80106dfb:	83 e2 9f             	and    $0xffffff9f,%edx
80106dfe:	88 14 c5 65 47 11 80 	mov    %dl,-0x7feeb89b(,%eax,8)
80106e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e08:	0f b6 14 c5 65 47 11 	movzbl -0x7feeb89b(,%eax,8),%edx
80106e0f:	80 
80106e10:	83 ca 80             	or     $0xffffff80,%edx
80106e13:	88 14 c5 65 47 11 80 	mov    %dl,-0x7feeb89b(,%eax,8)
80106e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e1d:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106e24:	c1 e8 10             	shr    $0x10,%eax
80106e27:	89 c2                	mov    %eax,%edx
80106e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e2c:	66 89 14 c5 66 47 11 	mov    %dx,-0x7feeb89a(,%eax,8)
80106e33:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106e34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e38:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106e3f:	0f 8e 30 ff ff ff    	jle    80106d75 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e45:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
80106e4a:	66 a3 60 49 11 80    	mov    %ax,0x80114960
80106e50:	66 c7 05 62 49 11 80 	movw   $0x8,0x80114962
80106e57:	08 00 
80106e59:	0f b6 05 64 49 11 80 	movzbl 0x80114964,%eax
80106e60:	83 e0 e0             	and    $0xffffffe0,%eax
80106e63:	a2 64 49 11 80       	mov    %al,0x80114964
80106e68:	0f b6 05 64 49 11 80 	movzbl 0x80114964,%eax
80106e6f:	83 e0 1f             	and    $0x1f,%eax
80106e72:	a2 64 49 11 80       	mov    %al,0x80114964
80106e77:	0f b6 05 65 49 11 80 	movzbl 0x80114965,%eax
80106e7e:	83 c8 0f             	or     $0xf,%eax
80106e81:	a2 65 49 11 80       	mov    %al,0x80114965
80106e86:	0f b6 05 65 49 11 80 	movzbl 0x80114965,%eax
80106e8d:	83 e0 ef             	and    $0xffffffef,%eax
80106e90:	a2 65 49 11 80       	mov    %al,0x80114965
80106e95:	0f b6 05 65 49 11 80 	movzbl 0x80114965,%eax
80106e9c:	83 c8 60             	or     $0x60,%eax
80106e9f:	a2 65 49 11 80       	mov    %al,0x80114965
80106ea4:	0f b6 05 65 49 11 80 	movzbl 0x80114965,%eax
80106eab:	83 c8 80             	or     $0xffffff80,%eax
80106eae:	a2 65 49 11 80       	mov    %al,0x80114965
80106eb3:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
80106eb8:	c1 e8 10             	shr    $0x10,%eax
80106ebb:	66 a3 66 49 11 80    	mov    %ax,0x80114966
  
  initlock(&tickslock, "time");
80106ec1:	c7 44 24 04 90 91 10 	movl   $0x80109190,0x4(%esp)
80106ec8:	80 
80106ec9:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106ed0:	e8 b5 e6 ff ff       	call   8010558a <initlock>
}
80106ed5:	c9                   	leave  
80106ed6:	c3                   	ret    

80106ed7 <idtinit>:

void
idtinit(void)
{
80106ed7:	55                   	push   %ebp
80106ed8:	89 e5                	mov    %esp,%ebp
80106eda:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106edd:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106ee4:	00 
80106ee5:	c7 04 24 60 47 11 80 	movl   $0x80114760,(%esp)
80106eec:	e8 33 fe ff ff       	call   80106d24 <lidt>
}
80106ef1:	c9                   	leave  
80106ef2:	c3                   	ret    

80106ef3 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106ef3:	55                   	push   %ebp
80106ef4:	89 e5                	mov    %esp,%ebp
80106ef6:	57                   	push   %edi
80106ef7:	56                   	push   %esi
80106ef8:	53                   	push   %ebx
80106ef9:	83 ec 4c             	sub    $0x4c,%esp
  if(tf->trapno == T_SYSCALL){
80106efc:	8b 45 08             	mov    0x8(%ebp),%eax
80106eff:	8b 40 30             	mov    0x30(%eax),%eax
80106f02:	83 f8 40             	cmp    $0x40,%eax
80106f05:	75 3e                	jne    80106f45 <trap+0x52>
    if(proc->killed)
80106f07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f0d:	8b 40 24             	mov    0x24(%eax),%eax
80106f10:	85 c0                	test   %eax,%eax
80106f12:	74 05                	je     80106f19 <trap+0x26>
      exit();
80106f14:	e8 0a dd ff ff       	call   80104c23 <exit>
    proc->tf = tf;
80106f19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f1f:	8b 55 08             	mov    0x8(%ebp),%edx
80106f22:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f25:	e8 fd ec ff ff       	call   80105c27 <syscall>
    if(proc->killed)
80106f2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f30:	8b 40 24             	mov    0x24(%eax),%eax
80106f33:	85 c0                	test   %eax,%eax
80106f35:	0f 84 f9 02 00 00    	je     80107234 <trap+0x341>
      exit();
80106f3b:	e8 e3 dc ff ff       	call   80104c23 <exit>
    return;
80106f40:	e9 ef 02 00 00       	jmp    80107234 <trap+0x341>
  }

  switch(tf->trapno){
80106f45:	8b 45 08             	mov    0x8(%ebp),%eax
80106f48:	8b 40 30             	mov    0x30(%eax),%eax
80106f4b:	83 e8 20             	sub    $0x20,%eax
80106f4e:	83 f8 1f             	cmp    $0x1f,%eax
80106f51:	0f 87 10 01 00 00    	ja     80107067 <trap+0x174>
80106f57:	8b 04 85 38 92 10 80 	mov    -0x7fef6dc8(,%eax,4),%eax
80106f5e:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106f60:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f66:	0f b6 00             	movzbl (%eax),%eax
80106f69:	84 c0                	test   %al,%al
80106f6b:	0f 85 81 00 00 00    	jne    80106ff2 <trap+0xff>
      acquire(&tickslock);
80106f71:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106f78:	e8 2e e6 ff ff       	call   801055ab <acquire>
      ticks++;
80106f7d:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80106f82:	83 c0 01             	add    $0x1,%eax
80106f85:	a3 60 4f 11 80       	mov    %eax,0x80114f60
      if (proc && proc->state == RUNNING){
80106f8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f90:	85 c0                	test   %eax,%eax
80106f92:	74 46                	je     80106fda <trap+0xe7>
80106f94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f9a:	8b 40 0c             	mov    0xc(%eax),%eax
80106f9d:	83 f8 04             	cmp    $0x4,%eax
80106fa0:	75 38                	jne    80106fda <trap+0xe7>
	proc->rtime = proc->rtime + 1;
80106fa2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fa8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106faf:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80106fb5:	83 c2 01             	add    $0x1,%edx
80106fb8:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
	proc->quanta = proc->quanta + 1;
80106fbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fc4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106fcb:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80106fd1:	83 c2 01             	add    $0x1,%edx
80106fd4:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      }
      wakeup(&ticks);
80106fda:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80106fe1:	e8 bb e3 ff ff       	call   801053a1 <wakeup>
      release(&tickslock);
80106fe6:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80106fed:	e8 1b e6 ff ff       	call   8010560d <release>
    }
    lapiceoi();
80106ff2:	e8 42 c6 ff ff       	call   80103639 <lapiceoi>
    break;
80106ff7:	e9 41 01 00 00       	jmp    8010713d <trap+0x24a>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106ffc:	e8 40 be ff ff       	call   80102e41 <ideintr>
    lapiceoi();
80107001:	e8 33 c6 ff ff       	call   80103639 <lapiceoi>
    break;
80107006:	e9 32 01 00 00       	jmp    8010713d <trap+0x24a>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010700b:	e8 07 c4 ff ff       	call   80103417 <kbdintr>
    lapiceoi();
80107010:	e8 24 c6 ff ff       	call   80103639 <lapiceoi>
    break;
80107015:	e9 23 01 00 00       	jmp    8010713d <trap+0x24a>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010701a:	e8 1d 04 00 00       	call   8010743c <uartintr>
    lapiceoi();
8010701f:	e8 15 c6 ff ff       	call   80103639 <lapiceoi>
    break;
80107024:	e9 14 01 00 00       	jmp    8010713d <trap+0x24a>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80107029:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010702c:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010702f:	8b 45 08             	mov    0x8(%ebp),%eax
80107032:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107036:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107039:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010703f:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107042:	0f b6 c0             	movzbl %al,%eax
80107045:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107049:	89 54 24 08          	mov    %edx,0x8(%esp)
8010704d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107051:	c7 04 24 98 91 10 80 	movl   $0x80109198,(%esp)
80107058:	e8 44 93 ff ff       	call   801003a1 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010705d:	e8 d7 c5 ff ff       	call   80103639 <lapiceoi>
    break;
80107062:	e9 d6 00 00 00       	jmp    8010713d <trap+0x24a>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107067:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010706d:	85 c0                	test   %eax,%eax
8010706f:	74 11                	je     80107082 <trap+0x18f>
80107071:	8b 45 08             	mov    0x8(%ebp),%eax
80107074:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107078:	0f b7 c0             	movzwl %ax,%eax
8010707b:	83 e0 03             	and    $0x3,%eax
8010707e:	85 c0                	test   %eax,%eax
80107080:	75 46                	jne    801070c8 <trap+0x1d5>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107082:	e8 c6 fc ff ff       	call   80106d4d <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
80107087:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010708a:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010708d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107094:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107097:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010709a:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010709d:	8b 52 30             	mov    0x30(%edx),%edx
801070a0:	89 44 24 10          	mov    %eax,0x10(%esp)
801070a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801070a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801070ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801070b0:	c7 04 24 bc 91 10 80 	movl   $0x801091bc,(%esp)
801070b7:	e8 e5 92 ff ff       	call   801003a1 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801070bc:	c7 04 24 ee 91 10 80 	movl   $0x801091ee,(%esp)
801070c3:	e8 75 94 ff ff       	call   8010053d <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070c8:	e8 80 fc ff ff       	call   80106d4d <rcr2>
801070cd:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070cf:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070d2:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070db:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070de:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070e1:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070e4:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070e7:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070ea:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f3:	83 c0 6c             	add    $0x6c,%eax
801070f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801070f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070ff:	8b 40 10             	mov    0x10(%eax),%eax
80107102:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80107106:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010710a:	89 74 24 14          	mov    %esi,0x14(%esp)
8010710e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107112:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107116:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80107119:	89 54 24 08          	mov    %edx,0x8(%esp)
8010711d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107121:	c7 04 24 f4 91 10 80 	movl   $0x801091f4,(%esp)
80107128:	e8 74 92 ff ff       	call   801003a1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010712d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107133:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010713a:	eb 01                	jmp    8010713d <trap+0x24a>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010713c:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010713d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107143:	85 c0                	test   %eax,%eax
80107145:	74 24                	je     8010716b <trap+0x278>
80107147:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010714d:	8b 40 24             	mov    0x24(%eax),%eax
80107150:	85 c0                	test   %eax,%eax
80107152:	74 17                	je     8010716b <trap+0x278>
80107154:	8b 45 08             	mov    0x8(%ebp),%eax
80107157:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010715b:	0f b7 c0             	movzwl %ax,%eax
8010715e:	83 e0 03             	and    $0x3,%eax
80107161:	83 f8 03             	cmp    $0x3,%eax
80107164:	75 05                	jne    8010716b <trap+0x278>
    exit();
80107166:	e8 b8 da ff ff       	call   80104c23 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  #ifndef _FCFS
  if(proc && proc->state == RUNNING && proc->quanta % QUANTA == 0 && tf->trapno == T_IRQ0+IRQ_TIMER){
8010716b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107171:	85 c0                	test   %eax,%eax
80107173:	0f 84 8b 00 00 00    	je     80107204 <trap+0x311>
80107179:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010717f:	8b 40 0c             	mov    0xc(%eax),%eax
80107182:	83 f8 04             	cmp    $0x4,%eax
80107185:	75 7d                	jne    80107204 <trap+0x311>
80107187:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010718d:	8b 88 94 00 00 00    	mov    0x94(%eax),%ecx
80107193:	ba 67 66 66 66       	mov    $0x66666667,%edx
80107198:	89 c8                	mov    %ecx,%eax
8010719a:	f7 ea                	imul   %edx
8010719c:	d1 fa                	sar    %edx
8010719e:	89 c8                	mov    %ecx,%eax
801071a0:	c1 f8 1f             	sar    $0x1f,%eax
801071a3:	29 c2                	sub    %eax,%edx
801071a5:	89 d0                	mov    %edx,%eax
801071a7:	c1 e0 02             	shl    $0x2,%eax
801071aa:	01 d0                	add    %edx,%eax
801071ac:	89 ca                	mov    %ecx,%edx
801071ae:	29 c2                	sub    %eax,%edx
801071b0:	85 d2                	test   %edx,%edx
801071b2:	75 50                	jne    80107204 <trap+0x311>
801071b4:	8b 45 08             	mov    0x8(%ebp),%eax
801071b7:	8b 40 30             	mov    0x30(%eax),%eax
801071ba:	83 f8 20             	cmp    $0x20,%eax
801071bd:	75 45                	jne    80107204 <trap+0x311>
    int check = 1;
801071bf:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    #ifdef _3Q
    if (proc->priority == LOW)
      check = 0;
    #endif
    if (check){
801071c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801071ca:	74 38                	je     80107204 <trap+0x311>
      if (proc->priority == HIGH)
801071cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071d2:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
801071d8:	83 f8 01             	cmp    $0x1,%eax
801071db:	75 12                	jne    801071ef <trap+0x2fc>
	proc->priority = MEDIUM;
801071dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071e3:	c7 80 9c 00 00 00 02 	movl   $0x2,0x9c(%eax)
801071ea:	00 00 00 
801071ed:	eb 10                	jmp    801071ff <trap+0x30c>
      else
	proc->priority = LOW;
801071ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071f5:	c7 80 9c 00 00 00 03 	movl   $0x3,0x9c(%eax)
801071fc:	00 00 00 
      yield();
801071ff:	e8 b7 df ff ff       	call   801051bb <yield>
    }
  }
  #endif

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107204:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010720a:	85 c0                	test   %eax,%eax
8010720c:	74 27                	je     80107235 <trap+0x342>
8010720e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107214:	8b 40 24             	mov    0x24(%eax),%eax
80107217:	85 c0                	test   %eax,%eax
80107219:	74 1a                	je     80107235 <trap+0x342>
8010721b:	8b 45 08             	mov    0x8(%ebp),%eax
8010721e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107222:	0f b7 c0             	movzwl %ax,%eax
80107225:	83 e0 03             	and    $0x3,%eax
80107228:	83 f8 03             	cmp    $0x3,%eax
8010722b:	75 08                	jne    80107235 <trap+0x342>
    exit();
8010722d:	e8 f1 d9 ff ff       	call   80104c23 <exit>
80107232:	eb 01                	jmp    80107235 <trap+0x342>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107234:	90                   	nop
  #endif

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107235:	83 c4 4c             	add    $0x4c,%esp
80107238:	5b                   	pop    %ebx
80107239:	5e                   	pop    %esi
8010723a:	5f                   	pop    %edi
8010723b:	5d                   	pop    %ebp
8010723c:	c3                   	ret    
8010723d:	00 00                	add    %al,(%eax)
	...

80107240 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	53                   	push   %ebx
80107244:	83 ec 14             	sub    $0x14,%esp
80107247:	8b 45 08             	mov    0x8(%ebp),%eax
8010724a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010724e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80107252:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80107256:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
8010725a:	ec                   	in     (%dx),%al
8010725b:	89 c3                	mov    %eax,%ebx
8010725d:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80107260:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80107264:	83 c4 14             	add    $0x14,%esp
80107267:	5b                   	pop    %ebx
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    

8010726a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010726a:	55                   	push   %ebp
8010726b:	89 e5                	mov    %esp,%ebp
8010726d:	83 ec 08             	sub    $0x8,%esp
80107270:	8b 55 08             	mov    0x8(%ebp),%edx
80107273:	8b 45 0c             	mov    0xc(%ebp),%eax
80107276:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010727a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010727d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107281:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107285:	ee                   	out    %al,(%dx)
}
80107286:	c9                   	leave  
80107287:	c3                   	ret    

80107288 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107288:	55                   	push   %ebp
80107289:	89 e5                	mov    %esp,%ebp
8010728b:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010728e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107295:	00 
80107296:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010729d:	e8 c8 ff ff ff       	call   8010726a <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801072a2:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801072a9:	00 
801072aa:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801072b1:	e8 b4 ff ff ff       	call   8010726a <outb>
  outb(COM1+0, 115200/9600);
801072b6:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801072bd:	00 
801072be:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801072c5:	e8 a0 ff ff ff       	call   8010726a <outb>
  outb(COM1+1, 0);
801072ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072d1:	00 
801072d2:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801072d9:	e8 8c ff ff ff       	call   8010726a <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801072de:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801072e5:	00 
801072e6:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801072ed:	e8 78 ff ff ff       	call   8010726a <outb>
  outb(COM1+4, 0);
801072f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072f9:	00 
801072fa:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107301:	e8 64 ff ff ff       	call   8010726a <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107306:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010730d:	00 
8010730e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107315:	e8 50 ff ff ff       	call   8010726a <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010731a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107321:	e8 1a ff ff ff       	call   80107240 <inb>
80107326:	3c ff                	cmp    $0xff,%al
80107328:	74 6c                	je     80107396 <uartinit+0x10e>
    return;
  uart = 1;
8010732a:	c7 05 0c d6 10 80 01 	movl   $0x1,0x8010d60c
80107331:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107334:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010733b:	e8 00 ff ff ff       	call   80107240 <inb>
  inb(COM1+0);
80107340:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107347:	e8 f4 fe ff ff       	call   80107240 <inb>
  picenable(IRQ_COM1);
8010734c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107353:	e8 b9 ce ff ff       	call   80104211 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107358:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010735f:	00 
80107360:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107367:	e8 5a bd ff ff       	call   801030c6 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010736c:	c7 45 f4 b8 92 10 80 	movl   $0x801092b8,-0xc(%ebp)
80107373:	eb 15                	jmp    8010738a <uartinit+0x102>
    uartputc(*p);
80107375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107378:	0f b6 00             	movzbl (%eax),%eax
8010737b:	0f be c0             	movsbl %al,%eax
8010737e:	89 04 24             	mov    %eax,(%esp)
80107381:	e8 13 00 00 00       	call   80107399 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107386:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010738a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738d:	0f b6 00             	movzbl (%eax),%eax
80107390:	84 c0                	test   %al,%al
80107392:	75 e1                	jne    80107375 <uartinit+0xed>
80107394:	eb 01                	jmp    80107397 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107396:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107397:	c9                   	leave  
80107398:	c3                   	ret    

80107399 <uartputc>:

void
uartputc(int c)
{
80107399:	55                   	push   %ebp
8010739a:	89 e5                	mov    %esp,%ebp
8010739c:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010739f:	a1 0c d6 10 80       	mov    0x8010d60c,%eax
801073a4:	85 c0                	test   %eax,%eax
801073a6:	74 4d                	je     801073f5 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801073a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801073af:	eb 10                	jmp    801073c1 <uartputc+0x28>
    microdelay(10);
801073b1:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801073b8:	e8 a1 c2 ff ff       	call   8010365e <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801073bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801073c1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801073c5:	7f 16                	jg     801073dd <uartputc+0x44>
801073c7:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801073ce:	e8 6d fe ff ff       	call   80107240 <inb>
801073d3:	0f b6 c0             	movzbl %al,%eax
801073d6:	83 e0 20             	and    $0x20,%eax
801073d9:	85 c0                	test   %eax,%eax
801073db:	74 d4                	je     801073b1 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801073dd:	8b 45 08             	mov    0x8(%ebp),%eax
801073e0:	0f b6 c0             	movzbl %al,%eax
801073e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801073e7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073ee:	e8 77 fe ff ff       	call   8010726a <outb>
801073f3:	eb 01                	jmp    801073f6 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801073f5:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801073f6:	c9                   	leave  
801073f7:	c3                   	ret    

801073f8 <uartgetc>:

static int
uartgetc(void)
{
801073f8:	55                   	push   %ebp
801073f9:	89 e5                	mov    %esp,%ebp
801073fb:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801073fe:	a1 0c d6 10 80       	mov    0x8010d60c,%eax
80107403:	85 c0                	test   %eax,%eax
80107405:	75 07                	jne    8010740e <uartgetc+0x16>
    return -1;
80107407:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010740c:	eb 2c                	jmp    8010743a <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010740e:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107415:	e8 26 fe ff ff       	call   80107240 <inb>
8010741a:	0f b6 c0             	movzbl %al,%eax
8010741d:	83 e0 01             	and    $0x1,%eax
80107420:	85 c0                	test   %eax,%eax
80107422:	75 07                	jne    8010742b <uartgetc+0x33>
    return -1;
80107424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107429:	eb 0f                	jmp    8010743a <uartgetc+0x42>
  return inb(COM1+0);
8010742b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107432:	e8 09 fe ff ff       	call   80107240 <inb>
80107437:	0f b6 c0             	movzbl %al,%eax
}
8010743a:	c9                   	leave  
8010743b:	c3                   	ret    

8010743c <uartintr>:

void
uartintr(void)
{
8010743c:	55                   	push   %ebp
8010743d:	89 e5                	mov    %esp,%ebp
8010743f:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107442:	c7 04 24 f8 73 10 80 	movl   $0x801073f8,(%esp)
80107449:	e8 86 93 ff ff       	call   801007d4 <consoleintr>
}
8010744e:	c9                   	leave  
8010744f:	c3                   	ret    

80107450 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $0
80107452:	6a 00                	push   $0x0
  jmp alltraps
80107454:	e9 9f f8 ff ff       	jmp    80106cf8 <alltraps>

80107459 <vector1>:
.globl vector1
vector1:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $1
8010745b:	6a 01                	push   $0x1
  jmp alltraps
8010745d:	e9 96 f8 ff ff       	jmp    80106cf8 <alltraps>

80107462 <vector2>:
.globl vector2
vector2:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $2
80107464:	6a 02                	push   $0x2
  jmp alltraps
80107466:	e9 8d f8 ff ff       	jmp    80106cf8 <alltraps>

8010746b <vector3>:
.globl vector3
vector3:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $3
8010746d:	6a 03                	push   $0x3
  jmp alltraps
8010746f:	e9 84 f8 ff ff       	jmp    80106cf8 <alltraps>

80107474 <vector4>:
.globl vector4
vector4:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $4
80107476:	6a 04                	push   $0x4
  jmp alltraps
80107478:	e9 7b f8 ff ff       	jmp    80106cf8 <alltraps>

8010747d <vector5>:
.globl vector5
vector5:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $5
8010747f:	6a 05                	push   $0x5
  jmp alltraps
80107481:	e9 72 f8 ff ff       	jmp    80106cf8 <alltraps>

80107486 <vector6>:
.globl vector6
vector6:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $6
80107488:	6a 06                	push   $0x6
  jmp alltraps
8010748a:	e9 69 f8 ff ff       	jmp    80106cf8 <alltraps>

8010748f <vector7>:
.globl vector7
vector7:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $7
80107491:	6a 07                	push   $0x7
  jmp alltraps
80107493:	e9 60 f8 ff ff       	jmp    80106cf8 <alltraps>

80107498 <vector8>:
.globl vector8
vector8:
  pushl $8
80107498:	6a 08                	push   $0x8
  jmp alltraps
8010749a:	e9 59 f8 ff ff       	jmp    80106cf8 <alltraps>

8010749f <vector9>:
.globl vector9
vector9:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $9
801074a1:	6a 09                	push   $0x9
  jmp alltraps
801074a3:	e9 50 f8 ff ff       	jmp    80106cf8 <alltraps>

801074a8 <vector10>:
.globl vector10
vector10:
  pushl $10
801074a8:	6a 0a                	push   $0xa
  jmp alltraps
801074aa:	e9 49 f8 ff ff       	jmp    80106cf8 <alltraps>

801074af <vector11>:
.globl vector11
vector11:
  pushl $11
801074af:	6a 0b                	push   $0xb
  jmp alltraps
801074b1:	e9 42 f8 ff ff       	jmp    80106cf8 <alltraps>

801074b6 <vector12>:
.globl vector12
vector12:
  pushl $12
801074b6:	6a 0c                	push   $0xc
  jmp alltraps
801074b8:	e9 3b f8 ff ff       	jmp    80106cf8 <alltraps>

801074bd <vector13>:
.globl vector13
vector13:
  pushl $13
801074bd:	6a 0d                	push   $0xd
  jmp alltraps
801074bf:	e9 34 f8 ff ff       	jmp    80106cf8 <alltraps>

801074c4 <vector14>:
.globl vector14
vector14:
  pushl $14
801074c4:	6a 0e                	push   $0xe
  jmp alltraps
801074c6:	e9 2d f8 ff ff       	jmp    80106cf8 <alltraps>

801074cb <vector15>:
.globl vector15
vector15:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $15
801074cd:	6a 0f                	push   $0xf
  jmp alltraps
801074cf:	e9 24 f8 ff ff       	jmp    80106cf8 <alltraps>

801074d4 <vector16>:
.globl vector16
vector16:
  pushl $0
801074d4:	6a 00                	push   $0x0
  pushl $16
801074d6:	6a 10                	push   $0x10
  jmp alltraps
801074d8:	e9 1b f8 ff ff       	jmp    80106cf8 <alltraps>

801074dd <vector17>:
.globl vector17
vector17:
  pushl $17
801074dd:	6a 11                	push   $0x11
  jmp alltraps
801074df:	e9 14 f8 ff ff       	jmp    80106cf8 <alltraps>

801074e4 <vector18>:
.globl vector18
vector18:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $18
801074e6:	6a 12                	push   $0x12
  jmp alltraps
801074e8:	e9 0b f8 ff ff       	jmp    80106cf8 <alltraps>

801074ed <vector19>:
.globl vector19
vector19:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $19
801074ef:	6a 13                	push   $0x13
  jmp alltraps
801074f1:	e9 02 f8 ff ff       	jmp    80106cf8 <alltraps>

801074f6 <vector20>:
.globl vector20
vector20:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $20
801074f8:	6a 14                	push   $0x14
  jmp alltraps
801074fa:	e9 f9 f7 ff ff       	jmp    80106cf8 <alltraps>

801074ff <vector21>:
.globl vector21
vector21:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $21
80107501:	6a 15                	push   $0x15
  jmp alltraps
80107503:	e9 f0 f7 ff ff       	jmp    80106cf8 <alltraps>

80107508 <vector22>:
.globl vector22
vector22:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $22
8010750a:	6a 16                	push   $0x16
  jmp alltraps
8010750c:	e9 e7 f7 ff ff       	jmp    80106cf8 <alltraps>

80107511 <vector23>:
.globl vector23
vector23:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $23
80107513:	6a 17                	push   $0x17
  jmp alltraps
80107515:	e9 de f7 ff ff       	jmp    80106cf8 <alltraps>

8010751a <vector24>:
.globl vector24
vector24:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $24
8010751c:	6a 18                	push   $0x18
  jmp alltraps
8010751e:	e9 d5 f7 ff ff       	jmp    80106cf8 <alltraps>

80107523 <vector25>:
.globl vector25
vector25:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $25
80107525:	6a 19                	push   $0x19
  jmp alltraps
80107527:	e9 cc f7 ff ff       	jmp    80106cf8 <alltraps>

8010752c <vector26>:
.globl vector26
vector26:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $26
8010752e:	6a 1a                	push   $0x1a
  jmp alltraps
80107530:	e9 c3 f7 ff ff       	jmp    80106cf8 <alltraps>

80107535 <vector27>:
.globl vector27
vector27:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $27
80107537:	6a 1b                	push   $0x1b
  jmp alltraps
80107539:	e9 ba f7 ff ff       	jmp    80106cf8 <alltraps>

8010753e <vector28>:
.globl vector28
vector28:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $28
80107540:	6a 1c                	push   $0x1c
  jmp alltraps
80107542:	e9 b1 f7 ff ff       	jmp    80106cf8 <alltraps>

80107547 <vector29>:
.globl vector29
vector29:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $29
80107549:	6a 1d                	push   $0x1d
  jmp alltraps
8010754b:	e9 a8 f7 ff ff       	jmp    80106cf8 <alltraps>

80107550 <vector30>:
.globl vector30
vector30:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $30
80107552:	6a 1e                	push   $0x1e
  jmp alltraps
80107554:	e9 9f f7 ff ff       	jmp    80106cf8 <alltraps>

80107559 <vector31>:
.globl vector31
vector31:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $31
8010755b:	6a 1f                	push   $0x1f
  jmp alltraps
8010755d:	e9 96 f7 ff ff       	jmp    80106cf8 <alltraps>

80107562 <vector32>:
.globl vector32
vector32:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $32
80107564:	6a 20                	push   $0x20
  jmp alltraps
80107566:	e9 8d f7 ff ff       	jmp    80106cf8 <alltraps>

8010756b <vector33>:
.globl vector33
vector33:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $33
8010756d:	6a 21                	push   $0x21
  jmp alltraps
8010756f:	e9 84 f7 ff ff       	jmp    80106cf8 <alltraps>

80107574 <vector34>:
.globl vector34
vector34:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $34
80107576:	6a 22                	push   $0x22
  jmp alltraps
80107578:	e9 7b f7 ff ff       	jmp    80106cf8 <alltraps>

8010757d <vector35>:
.globl vector35
vector35:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $35
8010757f:	6a 23                	push   $0x23
  jmp alltraps
80107581:	e9 72 f7 ff ff       	jmp    80106cf8 <alltraps>

80107586 <vector36>:
.globl vector36
vector36:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $36
80107588:	6a 24                	push   $0x24
  jmp alltraps
8010758a:	e9 69 f7 ff ff       	jmp    80106cf8 <alltraps>

8010758f <vector37>:
.globl vector37
vector37:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $37
80107591:	6a 25                	push   $0x25
  jmp alltraps
80107593:	e9 60 f7 ff ff       	jmp    80106cf8 <alltraps>

80107598 <vector38>:
.globl vector38
vector38:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $38
8010759a:	6a 26                	push   $0x26
  jmp alltraps
8010759c:	e9 57 f7 ff ff       	jmp    80106cf8 <alltraps>

801075a1 <vector39>:
.globl vector39
vector39:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $39
801075a3:	6a 27                	push   $0x27
  jmp alltraps
801075a5:	e9 4e f7 ff ff       	jmp    80106cf8 <alltraps>

801075aa <vector40>:
.globl vector40
vector40:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $40
801075ac:	6a 28                	push   $0x28
  jmp alltraps
801075ae:	e9 45 f7 ff ff       	jmp    80106cf8 <alltraps>

801075b3 <vector41>:
.globl vector41
vector41:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $41
801075b5:	6a 29                	push   $0x29
  jmp alltraps
801075b7:	e9 3c f7 ff ff       	jmp    80106cf8 <alltraps>

801075bc <vector42>:
.globl vector42
vector42:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $42
801075be:	6a 2a                	push   $0x2a
  jmp alltraps
801075c0:	e9 33 f7 ff ff       	jmp    80106cf8 <alltraps>

801075c5 <vector43>:
.globl vector43
vector43:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $43
801075c7:	6a 2b                	push   $0x2b
  jmp alltraps
801075c9:	e9 2a f7 ff ff       	jmp    80106cf8 <alltraps>

801075ce <vector44>:
.globl vector44
vector44:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $44
801075d0:	6a 2c                	push   $0x2c
  jmp alltraps
801075d2:	e9 21 f7 ff ff       	jmp    80106cf8 <alltraps>

801075d7 <vector45>:
.globl vector45
vector45:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $45
801075d9:	6a 2d                	push   $0x2d
  jmp alltraps
801075db:	e9 18 f7 ff ff       	jmp    80106cf8 <alltraps>

801075e0 <vector46>:
.globl vector46
vector46:
  pushl $0
801075e0:	6a 00                	push   $0x0
  pushl $46
801075e2:	6a 2e                	push   $0x2e
  jmp alltraps
801075e4:	e9 0f f7 ff ff       	jmp    80106cf8 <alltraps>

801075e9 <vector47>:
.globl vector47
vector47:
  pushl $0
801075e9:	6a 00                	push   $0x0
  pushl $47
801075eb:	6a 2f                	push   $0x2f
  jmp alltraps
801075ed:	e9 06 f7 ff ff       	jmp    80106cf8 <alltraps>

801075f2 <vector48>:
.globl vector48
vector48:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $48
801075f4:	6a 30                	push   $0x30
  jmp alltraps
801075f6:	e9 fd f6 ff ff       	jmp    80106cf8 <alltraps>

801075fb <vector49>:
.globl vector49
vector49:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $49
801075fd:	6a 31                	push   $0x31
  jmp alltraps
801075ff:	e9 f4 f6 ff ff       	jmp    80106cf8 <alltraps>

80107604 <vector50>:
.globl vector50
vector50:
  pushl $0
80107604:	6a 00                	push   $0x0
  pushl $50
80107606:	6a 32                	push   $0x32
  jmp alltraps
80107608:	e9 eb f6 ff ff       	jmp    80106cf8 <alltraps>

8010760d <vector51>:
.globl vector51
vector51:
  pushl $0
8010760d:	6a 00                	push   $0x0
  pushl $51
8010760f:	6a 33                	push   $0x33
  jmp alltraps
80107611:	e9 e2 f6 ff ff       	jmp    80106cf8 <alltraps>

80107616 <vector52>:
.globl vector52
vector52:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $52
80107618:	6a 34                	push   $0x34
  jmp alltraps
8010761a:	e9 d9 f6 ff ff       	jmp    80106cf8 <alltraps>

8010761f <vector53>:
.globl vector53
vector53:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $53
80107621:	6a 35                	push   $0x35
  jmp alltraps
80107623:	e9 d0 f6 ff ff       	jmp    80106cf8 <alltraps>

80107628 <vector54>:
.globl vector54
vector54:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $54
8010762a:	6a 36                	push   $0x36
  jmp alltraps
8010762c:	e9 c7 f6 ff ff       	jmp    80106cf8 <alltraps>

80107631 <vector55>:
.globl vector55
vector55:
  pushl $0
80107631:	6a 00                	push   $0x0
  pushl $55
80107633:	6a 37                	push   $0x37
  jmp alltraps
80107635:	e9 be f6 ff ff       	jmp    80106cf8 <alltraps>

8010763a <vector56>:
.globl vector56
vector56:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $56
8010763c:	6a 38                	push   $0x38
  jmp alltraps
8010763e:	e9 b5 f6 ff ff       	jmp    80106cf8 <alltraps>

80107643 <vector57>:
.globl vector57
vector57:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $57
80107645:	6a 39                	push   $0x39
  jmp alltraps
80107647:	e9 ac f6 ff ff       	jmp    80106cf8 <alltraps>

8010764c <vector58>:
.globl vector58
vector58:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $58
8010764e:	6a 3a                	push   $0x3a
  jmp alltraps
80107650:	e9 a3 f6 ff ff       	jmp    80106cf8 <alltraps>

80107655 <vector59>:
.globl vector59
vector59:
  pushl $0
80107655:	6a 00                	push   $0x0
  pushl $59
80107657:	6a 3b                	push   $0x3b
  jmp alltraps
80107659:	e9 9a f6 ff ff       	jmp    80106cf8 <alltraps>

8010765e <vector60>:
.globl vector60
vector60:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $60
80107660:	6a 3c                	push   $0x3c
  jmp alltraps
80107662:	e9 91 f6 ff ff       	jmp    80106cf8 <alltraps>

80107667 <vector61>:
.globl vector61
vector61:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $61
80107669:	6a 3d                	push   $0x3d
  jmp alltraps
8010766b:	e9 88 f6 ff ff       	jmp    80106cf8 <alltraps>

80107670 <vector62>:
.globl vector62
vector62:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $62
80107672:	6a 3e                	push   $0x3e
  jmp alltraps
80107674:	e9 7f f6 ff ff       	jmp    80106cf8 <alltraps>

80107679 <vector63>:
.globl vector63
vector63:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $63
8010767b:	6a 3f                	push   $0x3f
  jmp alltraps
8010767d:	e9 76 f6 ff ff       	jmp    80106cf8 <alltraps>

80107682 <vector64>:
.globl vector64
vector64:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $64
80107684:	6a 40                	push   $0x40
  jmp alltraps
80107686:	e9 6d f6 ff ff       	jmp    80106cf8 <alltraps>

8010768b <vector65>:
.globl vector65
vector65:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $65
8010768d:	6a 41                	push   $0x41
  jmp alltraps
8010768f:	e9 64 f6 ff ff       	jmp    80106cf8 <alltraps>

80107694 <vector66>:
.globl vector66
vector66:
  pushl $0
80107694:	6a 00                	push   $0x0
  pushl $66
80107696:	6a 42                	push   $0x42
  jmp alltraps
80107698:	e9 5b f6 ff ff       	jmp    80106cf8 <alltraps>

8010769d <vector67>:
.globl vector67
vector67:
  pushl $0
8010769d:	6a 00                	push   $0x0
  pushl $67
8010769f:	6a 43                	push   $0x43
  jmp alltraps
801076a1:	e9 52 f6 ff ff       	jmp    80106cf8 <alltraps>

801076a6 <vector68>:
.globl vector68
vector68:
  pushl $0
801076a6:	6a 00                	push   $0x0
  pushl $68
801076a8:	6a 44                	push   $0x44
  jmp alltraps
801076aa:	e9 49 f6 ff ff       	jmp    80106cf8 <alltraps>

801076af <vector69>:
.globl vector69
vector69:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $69
801076b1:	6a 45                	push   $0x45
  jmp alltraps
801076b3:	e9 40 f6 ff ff       	jmp    80106cf8 <alltraps>

801076b8 <vector70>:
.globl vector70
vector70:
  pushl $0
801076b8:	6a 00                	push   $0x0
  pushl $70
801076ba:	6a 46                	push   $0x46
  jmp alltraps
801076bc:	e9 37 f6 ff ff       	jmp    80106cf8 <alltraps>

801076c1 <vector71>:
.globl vector71
vector71:
  pushl $0
801076c1:	6a 00                	push   $0x0
  pushl $71
801076c3:	6a 47                	push   $0x47
  jmp alltraps
801076c5:	e9 2e f6 ff ff       	jmp    80106cf8 <alltraps>

801076ca <vector72>:
.globl vector72
vector72:
  pushl $0
801076ca:	6a 00                	push   $0x0
  pushl $72
801076cc:	6a 48                	push   $0x48
  jmp alltraps
801076ce:	e9 25 f6 ff ff       	jmp    80106cf8 <alltraps>

801076d3 <vector73>:
.globl vector73
vector73:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $73
801076d5:	6a 49                	push   $0x49
  jmp alltraps
801076d7:	e9 1c f6 ff ff       	jmp    80106cf8 <alltraps>

801076dc <vector74>:
.globl vector74
vector74:
  pushl $0
801076dc:	6a 00                	push   $0x0
  pushl $74
801076de:	6a 4a                	push   $0x4a
  jmp alltraps
801076e0:	e9 13 f6 ff ff       	jmp    80106cf8 <alltraps>

801076e5 <vector75>:
.globl vector75
vector75:
  pushl $0
801076e5:	6a 00                	push   $0x0
  pushl $75
801076e7:	6a 4b                	push   $0x4b
  jmp alltraps
801076e9:	e9 0a f6 ff ff       	jmp    80106cf8 <alltraps>

801076ee <vector76>:
.globl vector76
vector76:
  pushl $0
801076ee:	6a 00                	push   $0x0
  pushl $76
801076f0:	6a 4c                	push   $0x4c
  jmp alltraps
801076f2:	e9 01 f6 ff ff       	jmp    80106cf8 <alltraps>

801076f7 <vector77>:
.globl vector77
vector77:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $77
801076f9:	6a 4d                	push   $0x4d
  jmp alltraps
801076fb:	e9 f8 f5 ff ff       	jmp    80106cf8 <alltraps>

80107700 <vector78>:
.globl vector78
vector78:
  pushl $0
80107700:	6a 00                	push   $0x0
  pushl $78
80107702:	6a 4e                	push   $0x4e
  jmp alltraps
80107704:	e9 ef f5 ff ff       	jmp    80106cf8 <alltraps>

80107709 <vector79>:
.globl vector79
vector79:
  pushl $0
80107709:	6a 00                	push   $0x0
  pushl $79
8010770b:	6a 4f                	push   $0x4f
  jmp alltraps
8010770d:	e9 e6 f5 ff ff       	jmp    80106cf8 <alltraps>

80107712 <vector80>:
.globl vector80
vector80:
  pushl $0
80107712:	6a 00                	push   $0x0
  pushl $80
80107714:	6a 50                	push   $0x50
  jmp alltraps
80107716:	e9 dd f5 ff ff       	jmp    80106cf8 <alltraps>

8010771b <vector81>:
.globl vector81
vector81:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $81
8010771d:	6a 51                	push   $0x51
  jmp alltraps
8010771f:	e9 d4 f5 ff ff       	jmp    80106cf8 <alltraps>

80107724 <vector82>:
.globl vector82
vector82:
  pushl $0
80107724:	6a 00                	push   $0x0
  pushl $82
80107726:	6a 52                	push   $0x52
  jmp alltraps
80107728:	e9 cb f5 ff ff       	jmp    80106cf8 <alltraps>

8010772d <vector83>:
.globl vector83
vector83:
  pushl $0
8010772d:	6a 00                	push   $0x0
  pushl $83
8010772f:	6a 53                	push   $0x53
  jmp alltraps
80107731:	e9 c2 f5 ff ff       	jmp    80106cf8 <alltraps>

80107736 <vector84>:
.globl vector84
vector84:
  pushl $0
80107736:	6a 00                	push   $0x0
  pushl $84
80107738:	6a 54                	push   $0x54
  jmp alltraps
8010773a:	e9 b9 f5 ff ff       	jmp    80106cf8 <alltraps>

8010773f <vector85>:
.globl vector85
vector85:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $85
80107741:	6a 55                	push   $0x55
  jmp alltraps
80107743:	e9 b0 f5 ff ff       	jmp    80106cf8 <alltraps>

80107748 <vector86>:
.globl vector86
vector86:
  pushl $0
80107748:	6a 00                	push   $0x0
  pushl $86
8010774a:	6a 56                	push   $0x56
  jmp alltraps
8010774c:	e9 a7 f5 ff ff       	jmp    80106cf8 <alltraps>

80107751 <vector87>:
.globl vector87
vector87:
  pushl $0
80107751:	6a 00                	push   $0x0
  pushl $87
80107753:	6a 57                	push   $0x57
  jmp alltraps
80107755:	e9 9e f5 ff ff       	jmp    80106cf8 <alltraps>

8010775a <vector88>:
.globl vector88
vector88:
  pushl $0
8010775a:	6a 00                	push   $0x0
  pushl $88
8010775c:	6a 58                	push   $0x58
  jmp alltraps
8010775e:	e9 95 f5 ff ff       	jmp    80106cf8 <alltraps>

80107763 <vector89>:
.globl vector89
vector89:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $89
80107765:	6a 59                	push   $0x59
  jmp alltraps
80107767:	e9 8c f5 ff ff       	jmp    80106cf8 <alltraps>

8010776c <vector90>:
.globl vector90
vector90:
  pushl $0
8010776c:	6a 00                	push   $0x0
  pushl $90
8010776e:	6a 5a                	push   $0x5a
  jmp alltraps
80107770:	e9 83 f5 ff ff       	jmp    80106cf8 <alltraps>

80107775 <vector91>:
.globl vector91
vector91:
  pushl $0
80107775:	6a 00                	push   $0x0
  pushl $91
80107777:	6a 5b                	push   $0x5b
  jmp alltraps
80107779:	e9 7a f5 ff ff       	jmp    80106cf8 <alltraps>

8010777e <vector92>:
.globl vector92
vector92:
  pushl $0
8010777e:	6a 00                	push   $0x0
  pushl $92
80107780:	6a 5c                	push   $0x5c
  jmp alltraps
80107782:	e9 71 f5 ff ff       	jmp    80106cf8 <alltraps>

80107787 <vector93>:
.globl vector93
vector93:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $93
80107789:	6a 5d                	push   $0x5d
  jmp alltraps
8010778b:	e9 68 f5 ff ff       	jmp    80106cf8 <alltraps>

80107790 <vector94>:
.globl vector94
vector94:
  pushl $0
80107790:	6a 00                	push   $0x0
  pushl $94
80107792:	6a 5e                	push   $0x5e
  jmp alltraps
80107794:	e9 5f f5 ff ff       	jmp    80106cf8 <alltraps>

80107799 <vector95>:
.globl vector95
vector95:
  pushl $0
80107799:	6a 00                	push   $0x0
  pushl $95
8010779b:	6a 5f                	push   $0x5f
  jmp alltraps
8010779d:	e9 56 f5 ff ff       	jmp    80106cf8 <alltraps>

801077a2 <vector96>:
.globl vector96
vector96:
  pushl $0
801077a2:	6a 00                	push   $0x0
  pushl $96
801077a4:	6a 60                	push   $0x60
  jmp alltraps
801077a6:	e9 4d f5 ff ff       	jmp    80106cf8 <alltraps>

801077ab <vector97>:
.globl vector97
vector97:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $97
801077ad:	6a 61                	push   $0x61
  jmp alltraps
801077af:	e9 44 f5 ff ff       	jmp    80106cf8 <alltraps>

801077b4 <vector98>:
.globl vector98
vector98:
  pushl $0
801077b4:	6a 00                	push   $0x0
  pushl $98
801077b6:	6a 62                	push   $0x62
  jmp alltraps
801077b8:	e9 3b f5 ff ff       	jmp    80106cf8 <alltraps>

801077bd <vector99>:
.globl vector99
vector99:
  pushl $0
801077bd:	6a 00                	push   $0x0
  pushl $99
801077bf:	6a 63                	push   $0x63
  jmp alltraps
801077c1:	e9 32 f5 ff ff       	jmp    80106cf8 <alltraps>

801077c6 <vector100>:
.globl vector100
vector100:
  pushl $0
801077c6:	6a 00                	push   $0x0
  pushl $100
801077c8:	6a 64                	push   $0x64
  jmp alltraps
801077ca:	e9 29 f5 ff ff       	jmp    80106cf8 <alltraps>

801077cf <vector101>:
.globl vector101
vector101:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $101
801077d1:	6a 65                	push   $0x65
  jmp alltraps
801077d3:	e9 20 f5 ff ff       	jmp    80106cf8 <alltraps>

801077d8 <vector102>:
.globl vector102
vector102:
  pushl $0
801077d8:	6a 00                	push   $0x0
  pushl $102
801077da:	6a 66                	push   $0x66
  jmp alltraps
801077dc:	e9 17 f5 ff ff       	jmp    80106cf8 <alltraps>

801077e1 <vector103>:
.globl vector103
vector103:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $103
801077e3:	6a 67                	push   $0x67
  jmp alltraps
801077e5:	e9 0e f5 ff ff       	jmp    80106cf8 <alltraps>

801077ea <vector104>:
.globl vector104
vector104:
  pushl $0
801077ea:	6a 00                	push   $0x0
  pushl $104
801077ec:	6a 68                	push   $0x68
  jmp alltraps
801077ee:	e9 05 f5 ff ff       	jmp    80106cf8 <alltraps>

801077f3 <vector105>:
.globl vector105
vector105:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $105
801077f5:	6a 69                	push   $0x69
  jmp alltraps
801077f7:	e9 fc f4 ff ff       	jmp    80106cf8 <alltraps>

801077fc <vector106>:
.globl vector106
vector106:
  pushl $0
801077fc:	6a 00                	push   $0x0
  pushl $106
801077fe:	6a 6a                	push   $0x6a
  jmp alltraps
80107800:	e9 f3 f4 ff ff       	jmp    80106cf8 <alltraps>

80107805 <vector107>:
.globl vector107
vector107:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $107
80107807:	6a 6b                	push   $0x6b
  jmp alltraps
80107809:	e9 ea f4 ff ff       	jmp    80106cf8 <alltraps>

8010780e <vector108>:
.globl vector108
vector108:
  pushl $0
8010780e:	6a 00                	push   $0x0
  pushl $108
80107810:	6a 6c                	push   $0x6c
  jmp alltraps
80107812:	e9 e1 f4 ff ff       	jmp    80106cf8 <alltraps>

80107817 <vector109>:
.globl vector109
vector109:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $109
80107819:	6a 6d                	push   $0x6d
  jmp alltraps
8010781b:	e9 d8 f4 ff ff       	jmp    80106cf8 <alltraps>

80107820 <vector110>:
.globl vector110
vector110:
  pushl $0
80107820:	6a 00                	push   $0x0
  pushl $110
80107822:	6a 6e                	push   $0x6e
  jmp alltraps
80107824:	e9 cf f4 ff ff       	jmp    80106cf8 <alltraps>

80107829 <vector111>:
.globl vector111
vector111:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $111
8010782b:	6a 6f                	push   $0x6f
  jmp alltraps
8010782d:	e9 c6 f4 ff ff       	jmp    80106cf8 <alltraps>

80107832 <vector112>:
.globl vector112
vector112:
  pushl $0
80107832:	6a 00                	push   $0x0
  pushl $112
80107834:	6a 70                	push   $0x70
  jmp alltraps
80107836:	e9 bd f4 ff ff       	jmp    80106cf8 <alltraps>

8010783b <vector113>:
.globl vector113
vector113:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $113
8010783d:	6a 71                	push   $0x71
  jmp alltraps
8010783f:	e9 b4 f4 ff ff       	jmp    80106cf8 <alltraps>

80107844 <vector114>:
.globl vector114
vector114:
  pushl $0
80107844:	6a 00                	push   $0x0
  pushl $114
80107846:	6a 72                	push   $0x72
  jmp alltraps
80107848:	e9 ab f4 ff ff       	jmp    80106cf8 <alltraps>

8010784d <vector115>:
.globl vector115
vector115:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $115
8010784f:	6a 73                	push   $0x73
  jmp alltraps
80107851:	e9 a2 f4 ff ff       	jmp    80106cf8 <alltraps>

80107856 <vector116>:
.globl vector116
vector116:
  pushl $0
80107856:	6a 00                	push   $0x0
  pushl $116
80107858:	6a 74                	push   $0x74
  jmp alltraps
8010785a:	e9 99 f4 ff ff       	jmp    80106cf8 <alltraps>

8010785f <vector117>:
.globl vector117
vector117:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $117
80107861:	6a 75                	push   $0x75
  jmp alltraps
80107863:	e9 90 f4 ff ff       	jmp    80106cf8 <alltraps>

80107868 <vector118>:
.globl vector118
vector118:
  pushl $0
80107868:	6a 00                	push   $0x0
  pushl $118
8010786a:	6a 76                	push   $0x76
  jmp alltraps
8010786c:	e9 87 f4 ff ff       	jmp    80106cf8 <alltraps>

80107871 <vector119>:
.globl vector119
vector119:
  pushl $0
80107871:	6a 00                	push   $0x0
  pushl $119
80107873:	6a 77                	push   $0x77
  jmp alltraps
80107875:	e9 7e f4 ff ff       	jmp    80106cf8 <alltraps>

8010787a <vector120>:
.globl vector120
vector120:
  pushl $0
8010787a:	6a 00                	push   $0x0
  pushl $120
8010787c:	6a 78                	push   $0x78
  jmp alltraps
8010787e:	e9 75 f4 ff ff       	jmp    80106cf8 <alltraps>

80107883 <vector121>:
.globl vector121
vector121:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $121
80107885:	6a 79                	push   $0x79
  jmp alltraps
80107887:	e9 6c f4 ff ff       	jmp    80106cf8 <alltraps>

8010788c <vector122>:
.globl vector122
vector122:
  pushl $0
8010788c:	6a 00                	push   $0x0
  pushl $122
8010788e:	6a 7a                	push   $0x7a
  jmp alltraps
80107890:	e9 63 f4 ff ff       	jmp    80106cf8 <alltraps>

80107895 <vector123>:
.globl vector123
vector123:
  pushl $0
80107895:	6a 00                	push   $0x0
  pushl $123
80107897:	6a 7b                	push   $0x7b
  jmp alltraps
80107899:	e9 5a f4 ff ff       	jmp    80106cf8 <alltraps>

8010789e <vector124>:
.globl vector124
vector124:
  pushl $0
8010789e:	6a 00                	push   $0x0
  pushl $124
801078a0:	6a 7c                	push   $0x7c
  jmp alltraps
801078a2:	e9 51 f4 ff ff       	jmp    80106cf8 <alltraps>

801078a7 <vector125>:
.globl vector125
vector125:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $125
801078a9:	6a 7d                	push   $0x7d
  jmp alltraps
801078ab:	e9 48 f4 ff ff       	jmp    80106cf8 <alltraps>

801078b0 <vector126>:
.globl vector126
vector126:
  pushl $0
801078b0:	6a 00                	push   $0x0
  pushl $126
801078b2:	6a 7e                	push   $0x7e
  jmp alltraps
801078b4:	e9 3f f4 ff ff       	jmp    80106cf8 <alltraps>

801078b9 <vector127>:
.globl vector127
vector127:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $127
801078bb:	6a 7f                	push   $0x7f
  jmp alltraps
801078bd:	e9 36 f4 ff ff       	jmp    80106cf8 <alltraps>

801078c2 <vector128>:
.globl vector128
vector128:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $128
801078c4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801078c9:	e9 2a f4 ff ff       	jmp    80106cf8 <alltraps>

801078ce <vector129>:
.globl vector129
vector129:
  pushl $0
801078ce:	6a 00                	push   $0x0
  pushl $129
801078d0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801078d5:	e9 1e f4 ff ff       	jmp    80106cf8 <alltraps>

801078da <vector130>:
.globl vector130
vector130:
  pushl $0
801078da:	6a 00                	push   $0x0
  pushl $130
801078dc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801078e1:	e9 12 f4 ff ff       	jmp    80106cf8 <alltraps>

801078e6 <vector131>:
.globl vector131
vector131:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $131
801078e8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801078ed:	e9 06 f4 ff ff       	jmp    80106cf8 <alltraps>

801078f2 <vector132>:
.globl vector132
vector132:
  pushl $0
801078f2:	6a 00                	push   $0x0
  pushl $132
801078f4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801078f9:	e9 fa f3 ff ff       	jmp    80106cf8 <alltraps>

801078fe <vector133>:
.globl vector133
vector133:
  pushl $0
801078fe:	6a 00                	push   $0x0
  pushl $133
80107900:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107905:	e9 ee f3 ff ff       	jmp    80106cf8 <alltraps>

8010790a <vector134>:
.globl vector134
vector134:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $134
8010790c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107911:	e9 e2 f3 ff ff       	jmp    80106cf8 <alltraps>

80107916 <vector135>:
.globl vector135
vector135:
  pushl $0
80107916:	6a 00                	push   $0x0
  pushl $135
80107918:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010791d:	e9 d6 f3 ff ff       	jmp    80106cf8 <alltraps>

80107922 <vector136>:
.globl vector136
vector136:
  pushl $0
80107922:	6a 00                	push   $0x0
  pushl $136
80107924:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107929:	e9 ca f3 ff ff       	jmp    80106cf8 <alltraps>

8010792e <vector137>:
.globl vector137
vector137:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $137
80107930:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107935:	e9 be f3 ff ff       	jmp    80106cf8 <alltraps>

8010793a <vector138>:
.globl vector138
vector138:
  pushl $0
8010793a:	6a 00                	push   $0x0
  pushl $138
8010793c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107941:	e9 b2 f3 ff ff       	jmp    80106cf8 <alltraps>

80107946 <vector139>:
.globl vector139
vector139:
  pushl $0
80107946:	6a 00                	push   $0x0
  pushl $139
80107948:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010794d:	e9 a6 f3 ff ff       	jmp    80106cf8 <alltraps>

80107952 <vector140>:
.globl vector140
vector140:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $140
80107954:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107959:	e9 9a f3 ff ff       	jmp    80106cf8 <alltraps>

8010795e <vector141>:
.globl vector141
vector141:
  pushl $0
8010795e:	6a 00                	push   $0x0
  pushl $141
80107960:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107965:	e9 8e f3 ff ff       	jmp    80106cf8 <alltraps>

8010796a <vector142>:
.globl vector142
vector142:
  pushl $0
8010796a:	6a 00                	push   $0x0
  pushl $142
8010796c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107971:	e9 82 f3 ff ff       	jmp    80106cf8 <alltraps>

80107976 <vector143>:
.globl vector143
vector143:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $143
80107978:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010797d:	e9 76 f3 ff ff       	jmp    80106cf8 <alltraps>

80107982 <vector144>:
.globl vector144
vector144:
  pushl $0
80107982:	6a 00                	push   $0x0
  pushl $144
80107984:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107989:	e9 6a f3 ff ff       	jmp    80106cf8 <alltraps>

8010798e <vector145>:
.globl vector145
vector145:
  pushl $0
8010798e:	6a 00                	push   $0x0
  pushl $145
80107990:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107995:	e9 5e f3 ff ff       	jmp    80106cf8 <alltraps>

8010799a <vector146>:
.globl vector146
vector146:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $146
8010799c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801079a1:	e9 52 f3 ff ff       	jmp    80106cf8 <alltraps>

801079a6 <vector147>:
.globl vector147
vector147:
  pushl $0
801079a6:	6a 00                	push   $0x0
  pushl $147
801079a8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801079ad:	e9 46 f3 ff ff       	jmp    80106cf8 <alltraps>

801079b2 <vector148>:
.globl vector148
vector148:
  pushl $0
801079b2:	6a 00                	push   $0x0
  pushl $148
801079b4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801079b9:	e9 3a f3 ff ff       	jmp    80106cf8 <alltraps>

801079be <vector149>:
.globl vector149
vector149:
  pushl $0
801079be:	6a 00                	push   $0x0
  pushl $149
801079c0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801079c5:	e9 2e f3 ff ff       	jmp    80106cf8 <alltraps>

801079ca <vector150>:
.globl vector150
vector150:
  pushl $0
801079ca:	6a 00                	push   $0x0
  pushl $150
801079cc:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801079d1:	e9 22 f3 ff ff       	jmp    80106cf8 <alltraps>

801079d6 <vector151>:
.globl vector151
vector151:
  pushl $0
801079d6:	6a 00                	push   $0x0
  pushl $151
801079d8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801079dd:	e9 16 f3 ff ff       	jmp    80106cf8 <alltraps>

801079e2 <vector152>:
.globl vector152
vector152:
  pushl $0
801079e2:	6a 00                	push   $0x0
  pushl $152
801079e4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801079e9:	e9 0a f3 ff ff       	jmp    80106cf8 <alltraps>

801079ee <vector153>:
.globl vector153
vector153:
  pushl $0
801079ee:	6a 00                	push   $0x0
  pushl $153
801079f0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801079f5:	e9 fe f2 ff ff       	jmp    80106cf8 <alltraps>

801079fa <vector154>:
.globl vector154
vector154:
  pushl $0
801079fa:	6a 00                	push   $0x0
  pushl $154
801079fc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107a01:	e9 f2 f2 ff ff       	jmp    80106cf8 <alltraps>

80107a06 <vector155>:
.globl vector155
vector155:
  pushl $0
80107a06:	6a 00                	push   $0x0
  pushl $155
80107a08:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107a0d:	e9 e6 f2 ff ff       	jmp    80106cf8 <alltraps>

80107a12 <vector156>:
.globl vector156
vector156:
  pushl $0
80107a12:	6a 00                	push   $0x0
  pushl $156
80107a14:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107a19:	e9 da f2 ff ff       	jmp    80106cf8 <alltraps>

80107a1e <vector157>:
.globl vector157
vector157:
  pushl $0
80107a1e:	6a 00                	push   $0x0
  pushl $157
80107a20:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107a25:	e9 ce f2 ff ff       	jmp    80106cf8 <alltraps>

80107a2a <vector158>:
.globl vector158
vector158:
  pushl $0
80107a2a:	6a 00                	push   $0x0
  pushl $158
80107a2c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107a31:	e9 c2 f2 ff ff       	jmp    80106cf8 <alltraps>

80107a36 <vector159>:
.globl vector159
vector159:
  pushl $0
80107a36:	6a 00                	push   $0x0
  pushl $159
80107a38:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107a3d:	e9 b6 f2 ff ff       	jmp    80106cf8 <alltraps>

80107a42 <vector160>:
.globl vector160
vector160:
  pushl $0
80107a42:	6a 00                	push   $0x0
  pushl $160
80107a44:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107a49:	e9 aa f2 ff ff       	jmp    80106cf8 <alltraps>

80107a4e <vector161>:
.globl vector161
vector161:
  pushl $0
80107a4e:	6a 00                	push   $0x0
  pushl $161
80107a50:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107a55:	e9 9e f2 ff ff       	jmp    80106cf8 <alltraps>

80107a5a <vector162>:
.globl vector162
vector162:
  pushl $0
80107a5a:	6a 00                	push   $0x0
  pushl $162
80107a5c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a61:	e9 92 f2 ff ff       	jmp    80106cf8 <alltraps>

80107a66 <vector163>:
.globl vector163
vector163:
  pushl $0
80107a66:	6a 00                	push   $0x0
  pushl $163
80107a68:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a6d:	e9 86 f2 ff ff       	jmp    80106cf8 <alltraps>

80107a72 <vector164>:
.globl vector164
vector164:
  pushl $0
80107a72:	6a 00                	push   $0x0
  pushl $164
80107a74:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a79:	e9 7a f2 ff ff       	jmp    80106cf8 <alltraps>

80107a7e <vector165>:
.globl vector165
vector165:
  pushl $0
80107a7e:	6a 00                	push   $0x0
  pushl $165
80107a80:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a85:	e9 6e f2 ff ff       	jmp    80106cf8 <alltraps>

80107a8a <vector166>:
.globl vector166
vector166:
  pushl $0
80107a8a:	6a 00                	push   $0x0
  pushl $166
80107a8c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a91:	e9 62 f2 ff ff       	jmp    80106cf8 <alltraps>

80107a96 <vector167>:
.globl vector167
vector167:
  pushl $0
80107a96:	6a 00                	push   $0x0
  pushl $167
80107a98:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a9d:	e9 56 f2 ff ff       	jmp    80106cf8 <alltraps>

80107aa2 <vector168>:
.globl vector168
vector168:
  pushl $0
80107aa2:	6a 00                	push   $0x0
  pushl $168
80107aa4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107aa9:	e9 4a f2 ff ff       	jmp    80106cf8 <alltraps>

80107aae <vector169>:
.globl vector169
vector169:
  pushl $0
80107aae:	6a 00                	push   $0x0
  pushl $169
80107ab0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107ab5:	e9 3e f2 ff ff       	jmp    80106cf8 <alltraps>

80107aba <vector170>:
.globl vector170
vector170:
  pushl $0
80107aba:	6a 00                	push   $0x0
  pushl $170
80107abc:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107ac1:	e9 32 f2 ff ff       	jmp    80106cf8 <alltraps>

80107ac6 <vector171>:
.globl vector171
vector171:
  pushl $0
80107ac6:	6a 00                	push   $0x0
  pushl $171
80107ac8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107acd:	e9 26 f2 ff ff       	jmp    80106cf8 <alltraps>

80107ad2 <vector172>:
.globl vector172
vector172:
  pushl $0
80107ad2:	6a 00                	push   $0x0
  pushl $172
80107ad4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107ad9:	e9 1a f2 ff ff       	jmp    80106cf8 <alltraps>

80107ade <vector173>:
.globl vector173
vector173:
  pushl $0
80107ade:	6a 00                	push   $0x0
  pushl $173
80107ae0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107ae5:	e9 0e f2 ff ff       	jmp    80106cf8 <alltraps>

80107aea <vector174>:
.globl vector174
vector174:
  pushl $0
80107aea:	6a 00                	push   $0x0
  pushl $174
80107aec:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107af1:	e9 02 f2 ff ff       	jmp    80106cf8 <alltraps>

80107af6 <vector175>:
.globl vector175
vector175:
  pushl $0
80107af6:	6a 00                	push   $0x0
  pushl $175
80107af8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107afd:	e9 f6 f1 ff ff       	jmp    80106cf8 <alltraps>

80107b02 <vector176>:
.globl vector176
vector176:
  pushl $0
80107b02:	6a 00                	push   $0x0
  pushl $176
80107b04:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107b09:	e9 ea f1 ff ff       	jmp    80106cf8 <alltraps>

80107b0e <vector177>:
.globl vector177
vector177:
  pushl $0
80107b0e:	6a 00                	push   $0x0
  pushl $177
80107b10:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107b15:	e9 de f1 ff ff       	jmp    80106cf8 <alltraps>

80107b1a <vector178>:
.globl vector178
vector178:
  pushl $0
80107b1a:	6a 00                	push   $0x0
  pushl $178
80107b1c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107b21:	e9 d2 f1 ff ff       	jmp    80106cf8 <alltraps>

80107b26 <vector179>:
.globl vector179
vector179:
  pushl $0
80107b26:	6a 00                	push   $0x0
  pushl $179
80107b28:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107b2d:	e9 c6 f1 ff ff       	jmp    80106cf8 <alltraps>

80107b32 <vector180>:
.globl vector180
vector180:
  pushl $0
80107b32:	6a 00                	push   $0x0
  pushl $180
80107b34:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107b39:	e9 ba f1 ff ff       	jmp    80106cf8 <alltraps>

80107b3e <vector181>:
.globl vector181
vector181:
  pushl $0
80107b3e:	6a 00                	push   $0x0
  pushl $181
80107b40:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107b45:	e9 ae f1 ff ff       	jmp    80106cf8 <alltraps>

80107b4a <vector182>:
.globl vector182
vector182:
  pushl $0
80107b4a:	6a 00                	push   $0x0
  pushl $182
80107b4c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b51:	e9 a2 f1 ff ff       	jmp    80106cf8 <alltraps>

80107b56 <vector183>:
.globl vector183
vector183:
  pushl $0
80107b56:	6a 00                	push   $0x0
  pushl $183
80107b58:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b5d:	e9 96 f1 ff ff       	jmp    80106cf8 <alltraps>

80107b62 <vector184>:
.globl vector184
vector184:
  pushl $0
80107b62:	6a 00                	push   $0x0
  pushl $184
80107b64:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b69:	e9 8a f1 ff ff       	jmp    80106cf8 <alltraps>

80107b6e <vector185>:
.globl vector185
vector185:
  pushl $0
80107b6e:	6a 00                	push   $0x0
  pushl $185
80107b70:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b75:	e9 7e f1 ff ff       	jmp    80106cf8 <alltraps>

80107b7a <vector186>:
.globl vector186
vector186:
  pushl $0
80107b7a:	6a 00                	push   $0x0
  pushl $186
80107b7c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b81:	e9 72 f1 ff ff       	jmp    80106cf8 <alltraps>

80107b86 <vector187>:
.globl vector187
vector187:
  pushl $0
80107b86:	6a 00                	push   $0x0
  pushl $187
80107b88:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b8d:	e9 66 f1 ff ff       	jmp    80106cf8 <alltraps>

80107b92 <vector188>:
.globl vector188
vector188:
  pushl $0
80107b92:	6a 00                	push   $0x0
  pushl $188
80107b94:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b99:	e9 5a f1 ff ff       	jmp    80106cf8 <alltraps>

80107b9e <vector189>:
.globl vector189
vector189:
  pushl $0
80107b9e:	6a 00                	push   $0x0
  pushl $189
80107ba0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107ba5:	e9 4e f1 ff ff       	jmp    80106cf8 <alltraps>

80107baa <vector190>:
.globl vector190
vector190:
  pushl $0
80107baa:	6a 00                	push   $0x0
  pushl $190
80107bac:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107bb1:	e9 42 f1 ff ff       	jmp    80106cf8 <alltraps>

80107bb6 <vector191>:
.globl vector191
vector191:
  pushl $0
80107bb6:	6a 00                	push   $0x0
  pushl $191
80107bb8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107bbd:	e9 36 f1 ff ff       	jmp    80106cf8 <alltraps>

80107bc2 <vector192>:
.globl vector192
vector192:
  pushl $0
80107bc2:	6a 00                	push   $0x0
  pushl $192
80107bc4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107bc9:	e9 2a f1 ff ff       	jmp    80106cf8 <alltraps>

80107bce <vector193>:
.globl vector193
vector193:
  pushl $0
80107bce:	6a 00                	push   $0x0
  pushl $193
80107bd0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107bd5:	e9 1e f1 ff ff       	jmp    80106cf8 <alltraps>

80107bda <vector194>:
.globl vector194
vector194:
  pushl $0
80107bda:	6a 00                	push   $0x0
  pushl $194
80107bdc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107be1:	e9 12 f1 ff ff       	jmp    80106cf8 <alltraps>

80107be6 <vector195>:
.globl vector195
vector195:
  pushl $0
80107be6:	6a 00                	push   $0x0
  pushl $195
80107be8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107bed:	e9 06 f1 ff ff       	jmp    80106cf8 <alltraps>

80107bf2 <vector196>:
.globl vector196
vector196:
  pushl $0
80107bf2:	6a 00                	push   $0x0
  pushl $196
80107bf4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107bf9:	e9 fa f0 ff ff       	jmp    80106cf8 <alltraps>

80107bfe <vector197>:
.globl vector197
vector197:
  pushl $0
80107bfe:	6a 00                	push   $0x0
  pushl $197
80107c00:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107c05:	e9 ee f0 ff ff       	jmp    80106cf8 <alltraps>

80107c0a <vector198>:
.globl vector198
vector198:
  pushl $0
80107c0a:	6a 00                	push   $0x0
  pushl $198
80107c0c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107c11:	e9 e2 f0 ff ff       	jmp    80106cf8 <alltraps>

80107c16 <vector199>:
.globl vector199
vector199:
  pushl $0
80107c16:	6a 00                	push   $0x0
  pushl $199
80107c18:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107c1d:	e9 d6 f0 ff ff       	jmp    80106cf8 <alltraps>

80107c22 <vector200>:
.globl vector200
vector200:
  pushl $0
80107c22:	6a 00                	push   $0x0
  pushl $200
80107c24:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107c29:	e9 ca f0 ff ff       	jmp    80106cf8 <alltraps>

80107c2e <vector201>:
.globl vector201
vector201:
  pushl $0
80107c2e:	6a 00                	push   $0x0
  pushl $201
80107c30:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107c35:	e9 be f0 ff ff       	jmp    80106cf8 <alltraps>

80107c3a <vector202>:
.globl vector202
vector202:
  pushl $0
80107c3a:	6a 00                	push   $0x0
  pushl $202
80107c3c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107c41:	e9 b2 f0 ff ff       	jmp    80106cf8 <alltraps>

80107c46 <vector203>:
.globl vector203
vector203:
  pushl $0
80107c46:	6a 00                	push   $0x0
  pushl $203
80107c48:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c4d:	e9 a6 f0 ff ff       	jmp    80106cf8 <alltraps>

80107c52 <vector204>:
.globl vector204
vector204:
  pushl $0
80107c52:	6a 00                	push   $0x0
  pushl $204
80107c54:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107c59:	e9 9a f0 ff ff       	jmp    80106cf8 <alltraps>

80107c5e <vector205>:
.globl vector205
vector205:
  pushl $0
80107c5e:	6a 00                	push   $0x0
  pushl $205
80107c60:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c65:	e9 8e f0 ff ff       	jmp    80106cf8 <alltraps>

80107c6a <vector206>:
.globl vector206
vector206:
  pushl $0
80107c6a:	6a 00                	push   $0x0
  pushl $206
80107c6c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c71:	e9 82 f0 ff ff       	jmp    80106cf8 <alltraps>

80107c76 <vector207>:
.globl vector207
vector207:
  pushl $0
80107c76:	6a 00                	push   $0x0
  pushl $207
80107c78:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c7d:	e9 76 f0 ff ff       	jmp    80106cf8 <alltraps>

80107c82 <vector208>:
.globl vector208
vector208:
  pushl $0
80107c82:	6a 00                	push   $0x0
  pushl $208
80107c84:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c89:	e9 6a f0 ff ff       	jmp    80106cf8 <alltraps>

80107c8e <vector209>:
.globl vector209
vector209:
  pushl $0
80107c8e:	6a 00                	push   $0x0
  pushl $209
80107c90:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c95:	e9 5e f0 ff ff       	jmp    80106cf8 <alltraps>

80107c9a <vector210>:
.globl vector210
vector210:
  pushl $0
80107c9a:	6a 00                	push   $0x0
  pushl $210
80107c9c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107ca1:	e9 52 f0 ff ff       	jmp    80106cf8 <alltraps>

80107ca6 <vector211>:
.globl vector211
vector211:
  pushl $0
80107ca6:	6a 00                	push   $0x0
  pushl $211
80107ca8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107cad:	e9 46 f0 ff ff       	jmp    80106cf8 <alltraps>

80107cb2 <vector212>:
.globl vector212
vector212:
  pushl $0
80107cb2:	6a 00                	push   $0x0
  pushl $212
80107cb4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107cb9:	e9 3a f0 ff ff       	jmp    80106cf8 <alltraps>

80107cbe <vector213>:
.globl vector213
vector213:
  pushl $0
80107cbe:	6a 00                	push   $0x0
  pushl $213
80107cc0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107cc5:	e9 2e f0 ff ff       	jmp    80106cf8 <alltraps>

80107cca <vector214>:
.globl vector214
vector214:
  pushl $0
80107cca:	6a 00                	push   $0x0
  pushl $214
80107ccc:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107cd1:	e9 22 f0 ff ff       	jmp    80106cf8 <alltraps>

80107cd6 <vector215>:
.globl vector215
vector215:
  pushl $0
80107cd6:	6a 00                	push   $0x0
  pushl $215
80107cd8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107cdd:	e9 16 f0 ff ff       	jmp    80106cf8 <alltraps>

80107ce2 <vector216>:
.globl vector216
vector216:
  pushl $0
80107ce2:	6a 00                	push   $0x0
  pushl $216
80107ce4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107ce9:	e9 0a f0 ff ff       	jmp    80106cf8 <alltraps>

80107cee <vector217>:
.globl vector217
vector217:
  pushl $0
80107cee:	6a 00                	push   $0x0
  pushl $217
80107cf0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107cf5:	e9 fe ef ff ff       	jmp    80106cf8 <alltraps>

80107cfa <vector218>:
.globl vector218
vector218:
  pushl $0
80107cfa:	6a 00                	push   $0x0
  pushl $218
80107cfc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107d01:	e9 f2 ef ff ff       	jmp    80106cf8 <alltraps>

80107d06 <vector219>:
.globl vector219
vector219:
  pushl $0
80107d06:	6a 00                	push   $0x0
  pushl $219
80107d08:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107d0d:	e9 e6 ef ff ff       	jmp    80106cf8 <alltraps>

80107d12 <vector220>:
.globl vector220
vector220:
  pushl $0
80107d12:	6a 00                	push   $0x0
  pushl $220
80107d14:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107d19:	e9 da ef ff ff       	jmp    80106cf8 <alltraps>

80107d1e <vector221>:
.globl vector221
vector221:
  pushl $0
80107d1e:	6a 00                	push   $0x0
  pushl $221
80107d20:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107d25:	e9 ce ef ff ff       	jmp    80106cf8 <alltraps>

80107d2a <vector222>:
.globl vector222
vector222:
  pushl $0
80107d2a:	6a 00                	push   $0x0
  pushl $222
80107d2c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107d31:	e9 c2 ef ff ff       	jmp    80106cf8 <alltraps>

80107d36 <vector223>:
.globl vector223
vector223:
  pushl $0
80107d36:	6a 00                	push   $0x0
  pushl $223
80107d38:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107d3d:	e9 b6 ef ff ff       	jmp    80106cf8 <alltraps>

80107d42 <vector224>:
.globl vector224
vector224:
  pushl $0
80107d42:	6a 00                	push   $0x0
  pushl $224
80107d44:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107d49:	e9 aa ef ff ff       	jmp    80106cf8 <alltraps>

80107d4e <vector225>:
.globl vector225
vector225:
  pushl $0
80107d4e:	6a 00                	push   $0x0
  pushl $225
80107d50:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107d55:	e9 9e ef ff ff       	jmp    80106cf8 <alltraps>

80107d5a <vector226>:
.globl vector226
vector226:
  pushl $0
80107d5a:	6a 00                	push   $0x0
  pushl $226
80107d5c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d61:	e9 92 ef ff ff       	jmp    80106cf8 <alltraps>

80107d66 <vector227>:
.globl vector227
vector227:
  pushl $0
80107d66:	6a 00                	push   $0x0
  pushl $227
80107d68:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d6d:	e9 86 ef ff ff       	jmp    80106cf8 <alltraps>

80107d72 <vector228>:
.globl vector228
vector228:
  pushl $0
80107d72:	6a 00                	push   $0x0
  pushl $228
80107d74:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d79:	e9 7a ef ff ff       	jmp    80106cf8 <alltraps>

80107d7e <vector229>:
.globl vector229
vector229:
  pushl $0
80107d7e:	6a 00                	push   $0x0
  pushl $229
80107d80:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d85:	e9 6e ef ff ff       	jmp    80106cf8 <alltraps>

80107d8a <vector230>:
.globl vector230
vector230:
  pushl $0
80107d8a:	6a 00                	push   $0x0
  pushl $230
80107d8c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d91:	e9 62 ef ff ff       	jmp    80106cf8 <alltraps>

80107d96 <vector231>:
.globl vector231
vector231:
  pushl $0
80107d96:	6a 00                	push   $0x0
  pushl $231
80107d98:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d9d:	e9 56 ef ff ff       	jmp    80106cf8 <alltraps>

80107da2 <vector232>:
.globl vector232
vector232:
  pushl $0
80107da2:	6a 00                	push   $0x0
  pushl $232
80107da4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107da9:	e9 4a ef ff ff       	jmp    80106cf8 <alltraps>

80107dae <vector233>:
.globl vector233
vector233:
  pushl $0
80107dae:	6a 00                	push   $0x0
  pushl $233
80107db0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107db5:	e9 3e ef ff ff       	jmp    80106cf8 <alltraps>

80107dba <vector234>:
.globl vector234
vector234:
  pushl $0
80107dba:	6a 00                	push   $0x0
  pushl $234
80107dbc:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107dc1:	e9 32 ef ff ff       	jmp    80106cf8 <alltraps>

80107dc6 <vector235>:
.globl vector235
vector235:
  pushl $0
80107dc6:	6a 00                	push   $0x0
  pushl $235
80107dc8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107dcd:	e9 26 ef ff ff       	jmp    80106cf8 <alltraps>

80107dd2 <vector236>:
.globl vector236
vector236:
  pushl $0
80107dd2:	6a 00                	push   $0x0
  pushl $236
80107dd4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107dd9:	e9 1a ef ff ff       	jmp    80106cf8 <alltraps>

80107dde <vector237>:
.globl vector237
vector237:
  pushl $0
80107dde:	6a 00                	push   $0x0
  pushl $237
80107de0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107de5:	e9 0e ef ff ff       	jmp    80106cf8 <alltraps>

80107dea <vector238>:
.globl vector238
vector238:
  pushl $0
80107dea:	6a 00                	push   $0x0
  pushl $238
80107dec:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107df1:	e9 02 ef ff ff       	jmp    80106cf8 <alltraps>

80107df6 <vector239>:
.globl vector239
vector239:
  pushl $0
80107df6:	6a 00                	push   $0x0
  pushl $239
80107df8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107dfd:	e9 f6 ee ff ff       	jmp    80106cf8 <alltraps>

80107e02 <vector240>:
.globl vector240
vector240:
  pushl $0
80107e02:	6a 00                	push   $0x0
  pushl $240
80107e04:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107e09:	e9 ea ee ff ff       	jmp    80106cf8 <alltraps>

80107e0e <vector241>:
.globl vector241
vector241:
  pushl $0
80107e0e:	6a 00                	push   $0x0
  pushl $241
80107e10:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107e15:	e9 de ee ff ff       	jmp    80106cf8 <alltraps>

80107e1a <vector242>:
.globl vector242
vector242:
  pushl $0
80107e1a:	6a 00                	push   $0x0
  pushl $242
80107e1c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107e21:	e9 d2 ee ff ff       	jmp    80106cf8 <alltraps>

80107e26 <vector243>:
.globl vector243
vector243:
  pushl $0
80107e26:	6a 00                	push   $0x0
  pushl $243
80107e28:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107e2d:	e9 c6 ee ff ff       	jmp    80106cf8 <alltraps>

80107e32 <vector244>:
.globl vector244
vector244:
  pushl $0
80107e32:	6a 00                	push   $0x0
  pushl $244
80107e34:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107e39:	e9 ba ee ff ff       	jmp    80106cf8 <alltraps>

80107e3e <vector245>:
.globl vector245
vector245:
  pushl $0
80107e3e:	6a 00                	push   $0x0
  pushl $245
80107e40:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107e45:	e9 ae ee ff ff       	jmp    80106cf8 <alltraps>

80107e4a <vector246>:
.globl vector246
vector246:
  pushl $0
80107e4a:	6a 00                	push   $0x0
  pushl $246
80107e4c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e51:	e9 a2 ee ff ff       	jmp    80106cf8 <alltraps>

80107e56 <vector247>:
.globl vector247
vector247:
  pushl $0
80107e56:	6a 00                	push   $0x0
  pushl $247
80107e58:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e5d:	e9 96 ee ff ff       	jmp    80106cf8 <alltraps>

80107e62 <vector248>:
.globl vector248
vector248:
  pushl $0
80107e62:	6a 00                	push   $0x0
  pushl $248
80107e64:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e69:	e9 8a ee ff ff       	jmp    80106cf8 <alltraps>

80107e6e <vector249>:
.globl vector249
vector249:
  pushl $0
80107e6e:	6a 00                	push   $0x0
  pushl $249
80107e70:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e75:	e9 7e ee ff ff       	jmp    80106cf8 <alltraps>

80107e7a <vector250>:
.globl vector250
vector250:
  pushl $0
80107e7a:	6a 00                	push   $0x0
  pushl $250
80107e7c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e81:	e9 72 ee ff ff       	jmp    80106cf8 <alltraps>

80107e86 <vector251>:
.globl vector251
vector251:
  pushl $0
80107e86:	6a 00                	push   $0x0
  pushl $251
80107e88:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e8d:	e9 66 ee ff ff       	jmp    80106cf8 <alltraps>

80107e92 <vector252>:
.globl vector252
vector252:
  pushl $0
80107e92:	6a 00                	push   $0x0
  pushl $252
80107e94:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e99:	e9 5a ee ff ff       	jmp    80106cf8 <alltraps>

80107e9e <vector253>:
.globl vector253
vector253:
  pushl $0
80107e9e:	6a 00                	push   $0x0
  pushl $253
80107ea0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107ea5:	e9 4e ee ff ff       	jmp    80106cf8 <alltraps>

80107eaa <vector254>:
.globl vector254
vector254:
  pushl $0
80107eaa:	6a 00                	push   $0x0
  pushl $254
80107eac:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107eb1:	e9 42 ee ff ff       	jmp    80106cf8 <alltraps>

80107eb6 <vector255>:
.globl vector255
vector255:
  pushl $0
80107eb6:	6a 00                	push   $0x0
  pushl $255
80107eb8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107ebd:	e9 36 ee ff ff       	jmp    80106cf8 <alltraps>
	...

80107ec4 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107ec4:	55                   	push   %ebp
80107ec5:	89 e5                	mov    %esp,%ebp
80107ec7:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107eca:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ecd:	83 e8 01             	sub    $0x1,%eax
80107ed0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ed4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107edb:	8b 45 08             	mov    0x8(%ebp),%eax
80107ede:	c1 e8 10             	shr    $0x10,%eax
80107ee1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107ee5:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ee8:	0f 01 10             	lgdtl  (%eax)
}
80107eeb:	c9                   	leave  
80107eec:	c3                   	ret    

80107eed <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107eed:	55                   	push   %ebp
80107eee:	89 e5                	mov    %esp,%ebp
80107ef0:	83 ec 04             	sub    $0x4,%esp
80107ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107efa:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107efe:	0f 00 d8             	ltr    %ax
}
80107f01:	c9                   	leave  
80107f02:	c3                   	ret    

80107f03 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107f03:	55                   	push   %ebp
80107f04:	89 e5                	mov    %esp,%ebp
80107f06:	83 ec 04             	sub    $0x4,%esp
80107f09:	8b 45 08             	mov    0x8(%ebp),%eax
80107f0c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107f10:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f14:	8e e8                	mov    %eax,%gs
}
80107f16:	c9                   	leave  
80107f17:	c3                   	ret    

80107f18 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107f18:	55                   	push   %ebp
80107f19:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f1b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f1e:	0f 22 d8             	mov    %eax,%cr3
}
80107f21:	5d                   	pop    %ebp
80107f22:	c3                   	ret    

80107f23 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107f23:	55                   	push   %ebp
80107f24:	89 e5                	mov    %esp,%ebp
80107f26:	8b 45 08             	mov    0x8(%ebp),%eax
80107f29:	05 00 00 00 80       	add    $0x80000000,%eax
80107f2e:	5d                   	pop    %ebp
80107f2f:	c3                   	ret    

80107f30 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107f30:	55                   	push   %ebp
80107f31:	89 e5                	mov    %esp,%ebp
80107f33:	8b 45 08             	mov    0x8(%ebp),%eax
80107f36:	05 00 00 00 80       	add    $0x80000000,%eax
80107f3b:	5d                   	pop    %ebp
80107f3c:	c3                   	ret    

80107f3d <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107f3d:	55                   	push   %ebp
80107f3e:	89 e5                	mov    %esp,%ebp
80107f40:	53                   	push   %ebx
80107f41:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107f44:	e8 94 b6 ff ff       	call   801035dd <cpunum>
80107f49:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107f4f:	05 e0 18 11 80       	add    $0x801118e0,%eax
80107f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5a:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f63:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6c:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f77:	83 e2 f0             	and    $0xfffffff0,%edx
80107f7a:	83 ca 0a             	or     $0xa,%edx
80107f7d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f83:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f87:	83 ca 10             	or     $0x10,%edx
80107f8a:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f90:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f94:	83 e2 9f             	and    $0xffffff9f,%edx
80107f97:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107fa1:	83 ca 80             	or     $0xffffff80,%edx
80107fa4:	88 50 7d             	mov    %dl,0x7d(%eax)
80107fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107faa:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fae:	83 ca 0f             	or     $0xf,%edx
80107fb1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fbb:	83 e2 ef             	and    $0xffffffef,%edx
80107fbe:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fc8:	83 e2 df             	and    $0xffffffdf,%edx
80107fcb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fd5:	83 ca 40             	or     $0x40,%edx
80107fd8:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fe2:	83 ca 80             	or     $0xffffff80,%edx
80107fe5:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107feb:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff2:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107ff9:	ff ff 
80107ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffe:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108005:	00 00 
80108007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800a:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108014:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010801b:	83 e2 f0             	and    $0xfffffff0,%edx
8010801e:	83 ca 02             	or     $0x2,%edx
80108021:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108031:	83 ca 10             	or     $0x10,%edx
80108034:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010803a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108044:	83 e2 9f             	and    $0xffffff9f,%edx
80108047:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010804d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108050:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108057:	83 ca 80             	or     $0xffffff80,%edx
8010805a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108063:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010806a:	83 ca 0f             	or     $0xf,%edx
8010806d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108073:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108076:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010807d:	83 e2 ef             	and    $0xffffffef,%edx
80108080:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108089:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108090:	83 e2 df             	and    $0xffffffdf,%edx
80108093:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080a3:	83 ca 40             	or     $0x40,%edx
801080a6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080af:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080b6:	83 ca 80             	or     $0xffffff80,%edx
801080b9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c2:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801080c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cc:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801080d3:	ff ff 
801080d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d8:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801080df:	00 00 
801080e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e4:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801080eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ee:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080f5:	83 e2 f0             	and    $0xfffffff0,%edx
801080f8:	83 ca 0a             	or     $0xa,%edx
801080fb:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108104:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010810b:	83 ca 10             	or     $0x10,%edx
8010810e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108117:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010811e:	83 ca 60             	or     $0x60,%edx
80108121:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108131:	83 ca 80             	or     $0xffffff80,%edx
80108134:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010813a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108144:	83 ca 0f             	or     $0xf,%edx
80108147:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010814d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108150:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108157:	83 e2 ef             	and    $0xffffffef,%edx
8010815a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108160:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108163:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010816a:	83 e2 df             	and    $0xffffffdf,%edx
8010816d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108176:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010817d:	83 ca 40             	or     $0x40,%edx
80108180:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108189:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108190:	83 ca 80             	or     $0xffffff80,%edx
80108193:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819c:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801081a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a6:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801081ad:	ff ff 
801081af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b2:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801081b9:	00 00 
801081bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081be:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801081c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081cf:	83 e2 f0             	and    $0xfffffff0,%edx
801081d2:	83 ca 02             	or     $0x2,%edx
801081d5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081de:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081e5:	83 ca 10             	or     $0x10,%edx
801081e8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f1:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081f8:	83 ca 60             	or     $0x60,%edx
801081fb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108204:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010820b:	83 ca 80             	or     $0xffffff80,%edx
8010820e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108217:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010821e:	83 ca 0f             	or     $0xf,%edx
80108221:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108231:	83 e2 ef             	and    $0xffffffef,%edx
80108234:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010823a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108244:	83 e2 df             	and    $0xffffffdf,%edx
80108247:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010824d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108250:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108257:	83 ca 40             	or     $0x40,%edx
8010825a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108260:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108263:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010826a:	83 ca 80             	or     $0xffffff80,%edx
8010826d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108276:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010827d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108280:	05 b4 00 00 00       	add    $0xb4,%eax
80108285:	89 c3                	mov    %eax,%ebx
80108287:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828a:	05 b4 00 00 00       	add    $0xb4,%eax
8010828f:	c1 e8 10             	shr    $0x10,%eax
80108292:	89 c1                	mov    %eax,%ecx
80108294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108297:	05 b4 00 00 00       	add    $0xb4,%eax
8010829c:	c1 e8 18             	shr    $0x18,%eax
8010829f:	89 c2                	mov    %eax,%edx
801082a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a4:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801082ab:	00 00 
801082ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b0:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801082b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ba:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801082c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c3:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082ca:	83 e1 f0             	and    $0xfffffff0,%ecx
801082cd:	83 c9 02             	or     $0x2,%ecx
801082d0:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d9:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082e0:	83 c9 10             	or     $0x10,%ecx
801082e3:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ec:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082f3:	83 e1 9f             	and    $0xffffff9f,%ecx
801082f6:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ff:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108306:	83 c9 80             	or     $0xffffff80,%ecx
80108309:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010830f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108312:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108319:	83 e1 f0             	and    $0xfffffff0,%ecx
8010831c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108325:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010832c:	83 e1 ef             	and    $0xffffffef,%ecx
8010832f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108338:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010833f:	83 e1 df             	and    $0xffffffdf,%ecx
80108342:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834b:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108352:	83 c9 40             	or     $0x40,%ecx
80108355:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010835b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108365:	83 c9 80             	or     $0xffffff80,%ecx
80108368:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010836e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108371:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837a:	83 c0 70             	add    $0x70,%eax
8010837d:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108384:	00 
80108385:	89 04 24             	mov    %eax,(%esp)
80108388:	e8 37 fb ff ff       	call   80107ec4 <lgdt>
  loadgs(SEG_KCPU << 3);
8010838d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108394:	e8 6a fb ff ff       	call   80107f03 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839c:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801083a2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801083a9:	00 00 00 00 
}
801083ad:	83 c4 24             	add    $0x24,%esp
801083b0:	5b                   	pop    %ebx
801083b1:	5d                   	pop    %ebp
801083b2:	c3                   	ret    

801083b3 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801083b3:	55                   	push   %ebp
801083b4:	89 e5                	mov    %esp,%ebp
801083b6:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801083b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801083bc:	c1 e8 16             	shr    $0x16,%eax
801083bf:	c1 e0 02             	shl    $0x2,%eax
801083c2:	03 45 08             	add    0x8(%ebp),%eax
801083c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801083c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083cb:	8b 00                	mov    (%eax),%eax
801083cd:	83 e0 01             	and    $0x1,%eax
801083d0:	84 c0                	test   %al,%al
801083d2:	74 17                	je     801083eb <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801083d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083d7:	8b 00                	mov    (%eax),%eax
801083d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083de:	89 04 24             	mov    %eax,(%esp)
801083e1:	e8 4a fb ff ff       	call   80107f30 <p2v>
801083e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083e9:	eb 4b                	jmp    80108436 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801083eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801083ef:	74 0e                	je     801083ff <walkpgdir+0x4c>
801083f1:	e8 59 ae ff ff       	call   8010324f <kalloc>
801083f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083fd:	75 07                	jne    80108406 <walkpgdir+0x53>
      return 0;
801083ff:	b8 00 00 00 00       	mov    $0x0,%eax
80108404:	eb 41                	jmp    80108447 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108406:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010840d:	00 
8010840e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108415:	00 
80108416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108419:	89 04 24             	mov    %eax,(%esp)
8010841c:	e8 d9 d3 ff ff       	call   801057fa <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108424:	89 04 24             	mov    %eax,(%esp)
80108427:	e8 f7 fa ff ff       	call   80107f23 <v2p>
8010842c:	89 c2                	mov    %eax,%edx
8010842e:	83 ca 07             	or     $0x7,%edx
80108431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108434:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108436:	8b 45 0c             	mov    0xc(%ebp),%eax
80108439:	c1 e8 0c             	shr    $0xc,%eax
8010843c:	25 ff 03 00 00       	and    $0x3ff,%eax
80108441:	c1 e0 02             	shl    $0x2,%eax
80108444:	03 45 f4             	add    -0xc(%ebp),%eax
}
80108447:	c9                   	leave  
80108448:	c3                   	ret    

80108449 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108449:	55                   	push   %ebp
8010844a:	89 e5                	mov    %esp,%ebp
8010844c:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010844f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010845a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010845d:	03 45 10             	add    0x10(%ebp),%eax
80108460:	83 e8 01             	sub    $0x1,%eax
80108463:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108468:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010846b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108472:	00 
80108473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108476:	89 44 24 04          	mov    %eax,0x4(%esp)
8010847a:	8b 45 08             	mov    0x8(%ebp),%eax
8010847d:	89 04 24             	mov    %eax,(%esp)
80108480:	e8 2e ff ff ff       	call   801083b3 <walkpgdir>
80108485:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010848c:	75 07                	jne    80108495 <mappages+0x4c>
      return -1;
8010848e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108493:	eb 46                	jmp    801084db <mappages+0x92>
    if(*pte & PTE_P)
80108495:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108498:	8b 00                	mov    (%eax),%eax
8010849a:	83 e0 01             	and    $0x1,%eax
8010849d:	84 c0                	test   %al,%al
8010849f:	74 0c                	je     801084ad <mappages+0x64>
      panic("remap");
801084a1:	c7 04 24 c0 92 10 80 	movl   $0x801092c0,(%esp)
801084a8:	e8 90 80 ff ff       	call   8010053d <panic>
    *pte = pa | perm | PTE_P;
801084ad:	8b 45 18             	mov    0x18(%ebp),%eax
801084b0:	0b 45 14             	or     0x14(%ebp),%eax
801084b3:	89 c2                	mov    %eax,%edx
801084b5:	83 ca 01             	or     $0x1,%edx
801084b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084bb:	89 10                	mov    %edx,(%eax)
    if(a == last)
801084bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801084c3:	74 10                	je     801084d5 <mappages+0x8c>
      break;
    a += PGSIZE;
801084c5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801084cc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801084d3:	eb 96                	jmp    8010846b <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801084d5:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801084d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084db:	c9                   	leave  
801084dc:	c3                   	ret    

801084dd <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
801084dd:	55                   	push   %ebp
801084de:	89 e5                	mov    %esp,%ebp
801084e0:	53                   	push   %ebx
801084e1:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801084e4:	e8 66 ad ff ff       	call   8010324f <kalloc>
801084e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084f0:	75 0a                	jne    801084fc <setupkvm+0x1f>
    return 0;
801084f2:	b8 00 00 00 00       	mov    $0x0,%eax
801084f7:	e9 98 00 00 00       	jmp    80108594 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801084fc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108503:	00 
80108504:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010850b:	00 
8010850c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010850f:	89 04 24             	mov    %eax,(%esp)
80108512:	e8 e3 d2 ff ff       	call   801057fa <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108517:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
8010851e:	e8 0d fa ff ff       	call   80107f30 <p2v>
80108523:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108528:	76 0c                	jbe    80108536 <setupkvm+0x59>
    panic("PHYSTOP too high");
8010852a:	c7 04 24 c6 92 10 80 	movl   $0x801092c6,(%esp)
80108531:	e8 07 80 ff ff       	call   8010053d <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108536:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
8010853d:	eb 49                	jmp    80108588 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
8010853f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108542:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108545:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108548:	8b 50 04             	mov    0x4(%eax),%edx
8010854b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010854e:	8b 58 08             	mov    0x8(%eax),%ebx
80108551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108554:	8b 40 04             	mov    0x4(%eax),%eax
80108557:	29 c3                	sub    %eax,%ebx
80108559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010855c:	8b 00                	mov    (%eax),%eax
8010855e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108562:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108566:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010856a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010856e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108571:	89 04 24             	mov    %eax,(%esp)
80108574:	e8 d0 fe ff ff       	call   80108449 <mappages>
80108579:	85 c0                	test   %eax,%eax
8010857b:	79 07                	jns    80108584 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010857d:	b8 00 00 00 00       	mov    $0x0,%eax
80108582:	eb 10                	jmp    80108594 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108584:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108588:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
8010858f:	72 ae                	jb     8010853f <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108594:	83 c4 34             	add    $0x34,%esp
80108597:	5b                   	pop    %ebx
80108598:	5d                   	pop    %ebp
80108599:	c3                   	ret    

8010859a <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010859a:	55                   	push   %ebp
8010859b:	89 e5                	mov    %esp,%ebp
8010859d:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801085a0:	e8 38 ff ff ff       	call   801084dd <setupkvm>
801085a5:	a3 b8 4f 11 80       	mov    %eax,0x80114fb8
  switchkvm();
801085aa:	e8 02 00 00 00       	call   801085b1 <switchkvm>
}
801085af:	c9                   	leave  
801085b0:	c3                   	ret    

801085b1 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801085b1:	55                   	push   %ebp
801085b2:	89 e5                	mov    %esp,%ebp
801085b4:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801085b7:	a1 b8 4f 11 80       	mov    0x80114fb8,%eax
801085bc:	89 04 24             	mov    %eax,(%esp)
801085bf:	e8 5f f9 ff ff       	call   80107f23 <v2p>
801085c4:	89 04 24             	mov    %eax,(%esp)
801085c7:	e8 4c f9 ff ff       	call   80107f18 <lcr3>
}
801085cc:	c9                   	leave  
801085cd:	c3                   	ret    

801085ce <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801085ce:	55                   	push   %ebp
801085cf:	89 e5                	mov    %esp,%ebp
801085d1:	53                   	push   %ebx
801085d2:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801085d5:	e8 19 d1 ff ff       	call   801056f3 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801085da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085e0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085e7:	83 c2 08             	add    $0x8,%edx
801085ea:	89 d3                	mov    %edx,%ebx
801085ec:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085f3:	83 c2 08             	add    $0x8,%edx
801085f6:	c1 ea 10             	shr    $0x10,%edx
801085f9:	89 d1                	mov    %edx,%ecx
801085fb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108602:	83 c2 08             	add    $0x8,%edx
80108605:	c1 ea 18             	shr    $0x18,%edx
80108608:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010860f:	67 00 
80108611:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80108618:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
8010861e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108625:	83 e1 f0             	and    $0xfffffff0,%ecx
80108628:	83 c9 09             	or     $0x9,%ecx
8010862b:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108631:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108638:	83 c9 10             	or     $0x10,%ecx
8010863b:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108641:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108648:	83 e1 9f             	and    $0xffffff9f,%ecx
8010864b:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108651:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108658:	83 c9 80             	or     $0xffffff80,%ecx
8010865b:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108661:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108668:	83 e1 f0             	and    $0xfffffff0,%ecx
8010866b:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108671:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108678:	83 e1 ef             	and    $0xffffffef,%ecx
8010867b:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108681:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108688:	83 e1 df             	and    $0xffffffdf,%ecx
8010868b:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108691:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108698:	83 c9 40             	or     $0x40,%ecx
8010869b:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801086a1:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801086a8:	83 e1 7f             	and    $0x7f,%ecx
801086ab:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801086b1:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801086b7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086bd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086c4:	83 e2 ef             	and    $0xffffffef,%edx
801086c7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801086cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086d3:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801086d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086df:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801086e6:	8b 52 08             	mov    0x8(%edx),%edx
801086e9:	81 c2 00 10 00 00    	add    $0x1000,%edx
801086ef:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801086f2:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801086f9:	e8 ef f7 ff ff       	call   80107eed <ltr>
  if(p->pgdir == 0)
801086fe:	8b 45 08             	mov    0x8(%ebp),%eax
80108701:	8b 40 04             	mov    0x4(%eax),%eax
80108704:	85 c0                	test   %eax,%eax
80108706:	75 0c                	jne    80108714 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80108708:	c7 04 24 d7 92 10 80 	movl   $0x801092d7,(%esp)
8010870f:	e8 29 7e ff ff       	call   8010053d <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108714:	8b 45 08             	mov    0x8(%ebp),%eax
80108717:	8b 40 04             	mov    0x4(%eax),%eax
8010871a:	89 04 24             	mov    %eax,(%esp)
8010871d:	e8 01 f8 ff ff       	call   80107f23 <v2p>
80108722:	89 04 24             	mov    %eax,(%esp)
80108725:	e8 ee f7 ff ff       	call   80107f18 <lcr3>
  popcli();
8010872a:	e8 0c d0 ff ff       	call   8010573b <popcli>
}
8010872f:	83 c4 14             	add    $0x14,%esp
80108732:	5b                   	pop    %ebx
80108733:	5d                   	pop    %ebp
80108734:	c3                   	ret    

80108735 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108735:	55                   	push   %ebp
80108736:	89 e5                	mov    %esp,%ebp
80108738:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010873b:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108742:	76 0c                	jbe    80108750 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108744:	c7 04 24 eb 92 10 80 	movl   $0x801092eb,(%esp)
8010874b:	e8 ed 7d ff ff       	call   8010053d <panic>
  mem = kalloc();
80108750:	e8 fa aa ff ff       	call   8010324f <kalloc>
80108755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108758:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010875f:	00 
80108760:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108767:	00 
80108768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876b:	89 04 24             	mov    %eax,(%esp)
8010876e:	e8 87 d0 ff ff       	call   801057fa <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108776:	89 04 24             	mov    %eax,(%esp)
80108779:	e8 a5 f7 ff ff       	call   80107f23 <v2p>
8010877e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108785:	00 
80108786:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010878a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108791:	00 
80108792:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108799:	00 
8010879a:	8b 45 08             	mov    0x8(%ebp),%eax
8010879d:	89 04 24             	mov    %eax,(%esp)
801087a0:	e8 a4 fc ff ff       	call   80108449 <mappages>
  memmove(mem, init, sz);
801087a5:	8b 45 10             	mov    0x10(%ebp),%eax
801087a8:	89 44 24 08          	mov    %eax,0x8(%esp)
801087ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801087af:	89 44 24 04          	mov    %eax,0x4(%esp)
801087b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b6:	89 04 24             	mov    %eax,(%esp)
801087b9:	e8 0f d1 ff ff       	call   801058cd <memmove>
}
801087be:	c9                   	leave  
801087bf:	c3                   	ret    

801087c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801087c0:	55                   	push   %ebp
801087c1:	89 e5                	mov    %esp,%ebp
801087c3:	53                   	push   %ebx
801087c4:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801087c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801087ca:	25 ff 0f 00 00       	and    $0xfff,%eax
801087cf:	85 c0                	test   %eax,%eax
801087d1:	74 0c                	je     801087df <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801087d3:	c7 04 24 08 93 10 80 	movl   $0x80109308,(%esp)
801087da:	e8 5e 7d ff ff       	call   8010053d <panic>
  for(i = 0; i < sz; i += PGSIZE){
801087df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087e6:	e9 ad 00 00 00       	jmp    80108898 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801087eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801087f1:	01 d0                	add    %edx,%eax
801087f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087fa:	00 
801087fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801087ff:	8b 45 08             	mov    0x8(%ebp),%eax
80108802:	89 04 24             	mov    %eax,(%esp)
80108805:	e8 a9 fb ff ff       	call   801083b3 <walkpgdir>
8010880a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010880d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108811:	75 0c                	jne    8010881f <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108813:	c7 04 24 2b 93 10 80 	movl   $0x8010932b,(%esp)
8010881a:	e8 1e 7d ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
8010881f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108822:	8b 00                	mov    (%eax),%eax
80108824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108829:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010882c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882f:	8b 55 18             	mov    0x18(%ebp),%edx
80108832:	89 d1                	mov    %edx,%ecx
80108834:	29 c1                	sub    %eax,%ecx
80108836:	89 c8                	mov    %ecx,%eax
80108838:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010883d:	77 11                	ja     80108850 <loaduvm+0x90>
      n = sz - i;
8010883f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108842:	8b 55 18             	mov    0x18(%ebp),%edx
80108845:	89 d1                	mov    %edx,%ecx
80108847:	29 c1                	sub    %eax,%ecx
80108849:	89 c8                	mov    %ecx,%eax
8010884b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010884e:	eb 07                	jmp    80108857 <loaduvm+0x97>
    else
      n = PGSIZE;
80108850:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885a:	8b 55 14             	mov    0x14(%ebp),%edx
8010885d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108860:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108863:	89 04 24             	mov    %eax,(%esp)
80108866:	e8 c5 f6 ff ff       	call   80107f30 <p2v>
8010886b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010886e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108872:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108876:	89 44 24 04          	mov    %eax,0x4(%esp)
8010887a:	8b 45 10             	mov    0x10(%ebp),%eax
8010887d:	89 04 24             	mov    %eax,(%esp)
80108880:	e8 29 9c ff ff       	call   801024ae <readi>
80108885:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108888:	74 07                	je     80108891 <loaduvm+0xd1>
      return -1;
8010888a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010888f:	eb 18                	jmp    801088a9 <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108891:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010889b:	3b 45 18             	cmp    0x18(%ebp),%eax
8010889e:	0f 82 47 ff ff ff    	jb     801087eb <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801088a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088a9:	83 c4 24             	add    $0x24,%esp
801088ac:	5b                   	pop    %ebx
801088ad:	5d                   	pop    %ebp
801088ae:	c3                   	ret    

801088af <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801088af:	55                   	push   %ebp
801088b0:	89 e5                	mov    %esp,%ebp
801088b2:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801088b5:	8b 45 10             	mov    0x10(%ebp),%eax
801088b8:	85 c0                	test   %eax,%eax
801088ba:	79 0a                	jns    801088c6 <allocuvm+0x17>
    return 0;
801088bc:	b8 00 00 00 00       	mov    $0x0,%eax
801088c1:	e9 c1 00 00 00       	jmp    80108987 <allocuvm+0xd8>
  if(newsz < oldsz)
801088c6:	8b 45 10             	mov    0x10(%ebp),%eax
801088c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088cc:	73 08                	jae    801088d6 <allocuvm+0x27>
    return oldsz;
801088ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801088d1:	e9 b1 00 00 00       	jmp    80108987 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801088d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801088d9:	05 ff 0f 00 00       	add    $0xfff,%eax
801088de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801088e6:	e9 8d 00 00 00       	jmp    80108978 <allocuvm+0xc9>
    mem = kalloc();
801088eb:	e8 5f a9 ff ff       	call   8010324f <kalloc>
801088f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801088f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088f7:	75 2c                	jne    80108925 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801088f9:	c7 04 24 49 93 10 80 	movl   $0x80109349,(%esp)
80108900:	e8 9c 7a ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108905:	8b 45 0c             	mov    0xc(%ebp),%eax
80108908:	89 44 24 08          	mov    %eax,0x8(%esp)
8010890c:	8b 45 10             	mov    0x10(%ebp),%eax
8010890f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108913:	8b 45 08             	mov    0x8(%ebp),%eax
80108916:	89 04 24             	mov    %eax,(%esp)
80108919:	e8 6b 00 00 00       	call   80108989 <deallocuvm>
      return 0;
8010891e:	b8 00 00 00 00       	mov    $0x0,%eax
80108923:	eb 62                	jmp    80108987 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108925:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010892c:	00 
8010892d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108934:	00 
80108935:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108938:	89 04 24             	mov    %eax,(%esp)
8010893b:	e8 ba ce ff ff       	call   801057fa <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108940:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108943:	89 04 24             	mov    %eax,(%esp)
80108946:	e8 d8 f5 ff ff       	call   80107f23 <v2p>
8010894b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010894e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108955:	00 
80108956:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010895a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108961:	00 
80108962:	89 54 24 04          	mov    %edx,0x4(%esp)
80108966:	8b 45 08             	mov    0x8(%ebp),%eax
80108969:	89 04 24             	mov    %eax,(%esp)
8010896c:	e8 d8 fa ff ff       	call   80108449 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108971:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010897b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010897e:	0f 82 67 ff ff ff    	jb     801088eb <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108984:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108987:	c9                   	leave  
80108988:	c3                   	ret    

80108989 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108989:	55                   	push   %ebp
8010898a:	89 e5                	mov    %esp,%ebp
8010898c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010898f:	8b 45 10             	mov    0x10(%ebp),%eax
80108992:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108995:	72 08                	jb     8010899f <deallocuvm+0x16>
    return oldsz;
80108997:	8b 45 0c             	mov    0xc(%ebp),%eax
8010899a:	e9 a4 00 00 00       	jmp    80108a43 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010899f:	8b 45 10             	mov    0x10(%ebp),%eax
801089a2:	05 ff 0f 00 00       	add    $0xfff,%eax
801089a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801089af:	e9 80 00 00 00       	jmp    80108a34 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801089b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089be:	00 
801089bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801089c3:	8b 45 08             	mov    0x8(%ebp),%eax
801089c6:	89 04 24             	mov    %eax,(%esp)
801089c9:	e8 e5 f9 ff ff       	call   801083b3 <walkpgdir>
801089ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801089d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089d5:	75 09                	jne    801089e0 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801089d7:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801089de:	eb 4d                	jmp    80108a2d <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801089e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089e3:	8b 00                	mov    (%eax),%eax
801089e5:	83 e0 01             	and    $0x1,%eax
801089e8:	84 c0                	test   %al,%al
801089ea:	74 41                	je     80108a2d <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801089ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ef:	8b 00                	mov    (%eax),%eax
801089f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801089f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089fd:	75 0c                	jne    80108a0b <deallocuvm+0x82>
        panic("kfree");
801089ff:	c7 04 24 61 93 10 80 	movl   $0x80109361,(%esp)
80108a06:	e8 32 7b ff ff       	call   8010053d <panic>
      char *v = p2v(pa);
80108a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a0e:	89 04 24             	mov    %eax,(%esp)
80108a11:	e8 1a f5 ff ff       	call   80107f30 <p2v>
80108a16:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a1c:	89 04 24             	mov    %eax,(%esp)
80108a1f:	e8 92 a7 ff ff       	call   801031b6 <kfree>
      *pte = 0;
80108a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108a2d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a37:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a3a:	0f 82 74 ff ff ff    	jb     801089b4 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108a40:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a43:	c9                   	leave  
80108a44:	c3                   	ret    

80108a45 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108a45:	55                   	push   %ebp
80108a46:	89 e5                	mov    %esp,%ebp
80108a48:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108a4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a4f:	75 0c                	jne    80108a5d <freevm+0x18>
    panic("freevm: no pgdir");
80108a51:	c7 04 24 67 93 10 80 	movl   $0x80109367,(%esp)
80108a58:	e8 e0 7a ff ff       	call   8010053d <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a5d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a64:	00 
80108a65:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108a6c:	80 
80108a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80108a70:	89 04 24             	mov    %eax,(%esp)
80108a73:	e8 11 ff ff ff       	call   80108989 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a7f:	eb 3c                	jmp    80108abd <freevm+0x78>
    if(pgdir[i] & PTE_P){
80108a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a84:	c1 e0 02             	shl    $0x2,%eax
80108a87:	03 45 08             	add    0x8(%ebp),%eax
80108a8a:	8b 00                	mov    (%eax),%eax
80108a8c:	83 e0 01             	and    $0x1,%eax
80108a8f:	84 c0                	test   %al,%al
80108a91:	74 26                	je     80108ab9 <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a96:	c1 e0 02             	shl    $0x2,%eax
80108a99:	03 45 08             	add    0x8(%ebp),%eax
80108a9c:	8b 00                	mov    (%eax),%eax
80108a9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aa3:	89 04 24             	mov    %eax,(%esp)
80108aa6:	e8 85 f4 ff ff       	call   80107f30 <p2v>
80108aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ab1:	89 04 24             	mov    %eax,(%esp)
80108ab4:	e8 fd a6 ff ff       	call   801031b6 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108ab9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108abd:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108ac4:	76 bb                	jbe    80108a81 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80108ac9:	89 04 24             	mov    %eax,(%esp)
80108acc:	e8 e5 a6 ff ff       	call   801031b6 <kfree>
}
80108ad1:	c9                   	leave  
80108ad2:	c3                   	ret    

80108ad3 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108ad3:	55                   	push   %ebp
80108ad4:	89 e5                	mov    %esp,%ebp
80108ad6:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108ad9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108ae0:	00 
80108ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80108aeb:	89 04 24             	mov    %eax,(%esp)
80108aee:	e8 c0 f8 ff ff       	call   801083b3 <walkpgdir>
80108af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108afa:	75 0c                	jne    80108b08 <clearpteu+0x35>
    panic("clearpteu");
80108afc:	c7 04 24 78 93 10 80 	movl   $0x80109378,(%esp)
80108b03:	e8 35 7a ff ff       	call   8010053d <panic>
  *pte &= ~PTE_U;
80108b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0b:	8b 00                	mov    (%eax),%eax
80108b0d:	89 c2                	mov    %eax,%edx
80108b0f:	83 e2 fb             	and    $0xfffffffb,%edx
80108b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b15:	89 10                	mov    %edx,(%eax)
}
80108b17:	c9                   	leave  
80108b18:	c3                   	ret    

80108b19 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b19:	55                   	push   %ebp
80108b1a:	89 e5                	mov    %esp,%ebp
80108b1c:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80108b1f:	e8 b9 f9 ff ff       	call   801084dd <setupkvm>
80108b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b2b:	75 0a                	jne    80108b37 <copyuvm+0x1e>
    return 0;
80108b2d:	b8 00 00 00 00       	mov    $0x0,%eax
80108b32:	e9 f1 00 00 00       	jmp    80108c28 <copyuvm+0x10f>
  for(i = 0; i < sz; i += PGSIZE){
80108b37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b3e:	e9 c0 00 00 00       	jmp    80108c03 <copyuvm+0xea>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b4d:	00 
80108b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b52:	8b 45 08             	mov    0x8(%ebp),%eax
80108b55:	89 04 24             	mov    %eax,(%esp)
80108b58:	e8 56 f8 ff ff       	call   801083b3 <walkpgdir>
80108b5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b64:	75 0c                	jne    80108b72 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108b66:	c7 04 24 82 93 10 80 	movl   $0x80109382,(%esp)
80108b6d:	e8 cb 79 ff ff       	call   8010053d <panic>
    if(!(*pte & PTE_P))
80108b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b75:	8b 00                	mov    (%eax),%eax
80108b77:	83 e0 01             	and    $0x1,%eax
80108b7a:	85 c0                	test   %eax,%eax
80108b7c:	75 0c                	jne    80108b8a <copyuvm+0x71>
      panic("copyuvm: page not present");
80108b7e:	c7 04 24 9c 93 10 80 	movl   $0x8010939c,(%esp)
80108b85:	e8 b3 79 ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
80108b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b8d:	8b 00                	mov    (%eax),%eax
80108b8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b94:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80108b97:	e8 b3 a6 ff ff       	call   8010324f <kalloc>
80108b9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108b9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108ba3:	74 6f                	je     80108c14 <copyuvm+0xfb>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ba8:	89 04 24             	mov    %eax,(%esp)
80108bab:	e8 80 f3 ff ff       	call   80107f30 <p2v>
80108bb0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108bb7:	00 
80108bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bbf:	89 04 24             	mov    %eax,(%esp)
80108bc2:	e8 06 cd ff ff       	call   801058cd <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80108bc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bca:	89 04 24             	mov    %eax,(%esp)
80108bcd:	e8 51 f3 ff ff       	call   80107f23 <v2p>
80108bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108bd5:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108bdc:	00 
80108bdd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108be1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108be8:	00 
80108be9:	89 54 24 04          	mov    %edx,0x4(%esp)
80108bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf0:	89 04 24             	mov    %eax,(%esp)
80108bf3:	e8 51 f8 ff ff       	call   80108449 <mappages>
80108bf8:	85 c0                	test   %eax,%eax
80108bfa:	78 1b                	js     80108c17 <copyuvm+0xfe>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108bfc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c06:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c09:	0f 82 34 ff ff ff    	jb     80108b43 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
80108c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c12:	eb 14                	jmp    80108c28 <copyuvm+0x10f>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108c14:	90                   	nop
80108c15:	eb 01                	jmp    80108c18 <copyuvm+0xff>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
80108c17:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c1b:	89 04 24             	mov    %eax,(%esp)
80108c1e:	e8 22 fe ff ff       	call   80108a45 <freevm>
  return 0;
80108c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c28:	c9                   	leave  
80108c29:	c3                   	ret    

80108c2a <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108c2a:	55                   	push   %ebp
80108c2b:	89 e5                	mov    %esp,%ebp
80108c2d:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108c30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108c37:	00 
80108c38:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80108c42:	89 04 24             	mov    %eax,(%esp)
80108c45:	e8 69 f7 ff ff       	call   801083b3 <walkpgdir>
80108c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c50:	8b 00                	mov    (%eax),%eax
80108c52:	83 e0 01             	and    $0x1,%eax
80108c55:	85 c0                	test   %eax,%eax
80108c57:	75 07                	jne    80108c60 <uva2ka+0x36>
    return 0;
80108c59:	b8 00 00 00 00       	mov    $0x0,%eax
80108c5e:	eb 25                	jmp    80108c85 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c63:	8b 00                	mov    (%eax),%eax
80108c65:	83 e0 04             	and    $0x4,%eax
80108c68:	85 c0                	test   %eax,%eax
80108c6a:	75 07                	jne    80108c73 <uva2ka+0x49>
    return 0;
80108c6c:	b8 00 00 00 00       	mov    $0x0,%eax
80108c71:	eb 12                	jmp    80108c85 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c76:	8b 00                	mov    (%eax),%eax
80108c78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c7d:	89 04 24             	mov    %eax,(%esp)
80108c80:	e8 ab f2 ff ff       	call   80107f30 <p2v>
}
80108c85:	c9                   	leave  
80108c86:	c3                   	ret    

80108c87 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c87:	55                   	push   %ebp
80108c88:	89 e5                	mov    %esp,%ebp
80108c8a:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108c8d:	8b 45 10             	mov    0x10(%ebp),%eax
80108c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108c93:	e9 8b 00 00 00       	jmp    80108d23 <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
80108c98:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
80108caa:	8b 45 08             	mov    0x8(%ebp),%eax
80108cad:	89 04 24             	mov    %eax,(%esp)
80108cb0:	e8 75 ff ff ff       	call   80108c2a <uva2ka>
80108cb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108cb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108cbc:	75 07                	jne    80108cc5 <copyout+0x3e>
      return -1;
80108cbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108cc3:	eb 6d                	jmp    80108d32 <copyout+0xab>
    n = PGSIZE - (va - va0);
80108cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108ccb:	89 d1                	mov    %edx,%ecx
80108ccd:	29 c1                	sub    %eax,%ecx
80108ccf:	89 c8                	mov    %ecx,%eax
80108cd1:	05 00 10 00 00       	add    $0x1000,%eax
80108cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cdc:	3b 45 14             	cmp    0x14(%ebp),%eax
80108cdf:	76 06                	jbe    80108ce7 <copyout+0x60>
      n = len;
80108ce1:	8b 45 14             	mov    0x14(%ebp),%eax
80108ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cea:	8b 55 0c             	mov    0xc(%ebp),%edx
80108ced:	89 d1                	mov    %edx,%ecx
80108cef:	29 c1                	sub    %eax,%ecx
80108cf1:	89 c8                	mov    %ecx,%eax
80108cf3:	03 45 e8             	add    -0x18(%ebp),%eax
80108cf6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108cf9:	89 54 24 08          	mov    %edx,0x8(%esp)
80108cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108d00:	89 54 24 04          	mov    %edx,0x4(%esp)
80108d04:	89 04 24             	mov    %eax,(%esp)
80108d07:	e8 c1 cb ff ff       	call   801058cd <memmove>
    len -= n;
80108d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d0f:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d15:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d1b:	05 00 10 00 00       	add    $0x1000,%eax
80108d20:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108d23:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108d27:	0f 85 6b ff ff ff    	jne    80108c98 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d32:	c9                   	leave  
80108d33:	c3                   	ret    
