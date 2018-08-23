
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 2b 08 00 	movl   $0x82b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 44 04 00 00       	call   467 <printf>
    exit();
  23:	e8 b8 02 00 00       	call   2e0 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 0c 03 00 00       	call   350 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 3e 08 00 	movl   $0x83e,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 f3 03 00 00       	call   467 <printf>
  exit();
  74:	e8 67 02 00 00       	call   2e0 <exit>
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	90                   	nop
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 10             	movzbl (%eax),%edx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	88 10                	mov    %dl,(%eax)
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	0f 95 c0             	setne  %al
  c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  cc:	84 c0                	test   %al,%al
  ce:	75 de                	jne    ae <strcpy+0xd>
    ;
  return os;
  d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d3:	c9                   	leave  
  d4:	c3                   	ret    

000000d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d8:	eb 08                	jmp    e2 <strcmp+0xd>
    p++, q++;
  da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  de:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	84 c0                	test   %al,%al
  ea:	74 10                	je     fc <strcmp+0x27>
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 10             	movzbl (%eax),%edx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	38 c2                	cmp    %al,%dl
  fa:	74 de                	je     da <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 00             	movzbl (%eax),%eax
 102:	0f b6 d0             	movzbl %al,%edx
 105:	8b 45 0c             	mov    0xc(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	0f b6 c0             	movzbl %al,%eax
 10e:	89 d1                	mov    %edx,%ecx
 110:	29 c1                	sub    %eax,%ecx
 112:	89 c8                	mov    %ecx,%eax
}
 114:	5d                   	pop    %ebp
 115:	c3                   	ret    

00000116 <strlen>:

uint
strlen(char *s)
{
 116:	55                   	push   %ebp
 117:	89 e5                	mov    %esp,%ebp
 119:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 123:	eb 04                	jmp    129 <strlen+0x13>
 125:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12c:	03 45 08             	add    0x8(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	84 c0                	test   %al,%al
 134:	75 ef                	jne    125 <strlen+0xf>
    ;
  return n;
 136:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <memset>:

void*
memset(void *dst, int c, uint n)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 141:	8b 45 10             	mov    0x10(%ebp),%eax
 144:	89 44 24 08          	mov    %eax,0x8(%esp)
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	89 44 24 04          	mov    %eax,0x4(%esp)
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 22 ff ff ff       	call   7c <stosb>
  return dst;
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <strchr>:

char*
strchr(const char *s, char c)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	83 ec 04             	sub    $0x4,%esp
 165:	8b 45 0c             	mov    0xc(%ebp),%eax
 168:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16b:	eb 14                	jmp    181 <strchr+0x22>
    if(*s == c)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	3a 45 fc             	cmp    -0x4(%ebp),%al
 176:	75 05                	jne    17d <strchr+0x1e>
      return (char*)s;
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	eb 13                	jmp    190 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	75 e2                	jne    16d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <gets>:

char*
gets(char *buf, int max)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 198:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19f:	eb 44                	jmp    1e5 <gets+0x53>
    cc = read(0, &c, 1);
 1a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a8:	00 
 1a9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b7:	e8 4c 01 00 00       	call   308 <read>
 1bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c3:	7e 2d                	jle    1f2 <gets+0x60>
      break;
    buf[i++] = c;
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	03 45 08             	add    0x8(%ebp),%eax
 1cb:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1cf:	88 10                	mov    %dl,(%eax)
 1d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	3c 0a                	cmp    $0xa,%al
 1db:	74 16                	je     1f3 <gets+0x61>
 1dd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e1:	3c 0d                	cmp    $0xd,%al
 1e3:	74 0e                	je     1f3 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e8:	83 c0 01             	add    $0x1,%eax
 1eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ee:	7c b1                	jl     1a1 <gets+0xf>
 1f0:	eb 01                	jmp    1f3 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f6:	03 45 08             	add    0x8(%ebp),%eax
 1f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <stat>:

int
stat(char *n, struct stat *st)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20e:	00 
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 04 24             	mov    %eax,(%esp)
 215:	e8 16 01 00 00       	call   330 <open>
 21a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 221:	79 07                	jns    22a <stat+0x29>
    return -1;
 223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 228:	eb 23                	jmp    24d <stat+0x4c>
  r = fstat(fd, st);
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 44 24 04          	mov    %eax,0x4(%esp)
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
 234:	89 04 24             	mov    %eax,(%esp)
 237:	e8 0c 01 00 00       	call   348 <fstat>
 23c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 ce 00 00 00       	call   318 <close>
  return r;
 24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24d:	c9                   	leave  
 24e:	c3                   	ret    

0000024f <atoi>:

int
atoi(const char *s)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25c:	eb 23                	jmp    281 <atoi+0x32>
    n = n*10 + *s++ - '0';
 25e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 261:	89 d0                	mov    %edx,%eax
 263:	c1 e0 02             	shl    $0x2,%eax
 266:	01 d0                	add    %edx,%eax
 268:	01 c0                	add    %eax,%eax
 26a:	89 c2                	mov    %eax,%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	0f be c0             	movsbl %al,%eax
 275:	01 d0                	add    %edx,%eax
 277:	83 e8 30             	sub    $0x30,%eax
 27a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 27d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2f                	cmp    $0x2f,%al
 289:	7e 0a                	jle    295 <atoi+0x46>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 39                	cmp    $0x39,%al
 293:	7e c9                	jle    25e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ac:	eb 13                	jmp    2c1 <memmove+0x27>
    *dst++ = *src++;
 2ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b1:	0f b6 10             	movzbl (%eax),%edx
 2b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b7:	88 10                	mov    %dl,(%eax)
 2b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2bd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c5:	0f 9f c0             	setg   %al
 2c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2cc:	84 c0                	test   %al,%al
 2ce:	75 de                	jne    2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    
 2d5:	90                   	nop
 2d6:	90                   	nop
 2d7:	90                   	nop

000002d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d8:	b8 01 00 00 00       	mov    $0x1,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exit>:
SYSCALL(exit)
 2e0:	b8 02 00 00 00       	mov    $0x2,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <wait>:
SYSCALL(wait)
 2e8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <wait2>:
SYSCALL(wait2)
 2f0:	b8 16 00 00 00       	mov    $0x16,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <add_path>:
SYSCALL(add_path)
 2f8:	b8 17 00 00 00       	mov    $0x17,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <pipe>:
SYSCALL(pipe)
 300:	b8 04 00 00 00       	mov    $0x4,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <read>:
SYSCALL(read)
 308:	b8 05 00 00 00       	mov    $0x5,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <write>:
SYSCALL(write)
 310:	b8 10 00 00 00       	mov    $0x10,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <close>:
SYSCALL(close)
 318:	b8 15 00 00 00       	mov    $0x15,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <kill>:
SYSCALL(kill)
 320:	b8 06 00 00 00       	mov    $0x6,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <exec>:
SYSCALL(exec)
 328:	b8 07 00 00 00       	mov    $0x7,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <open>:
SYSCALL(open)
 330:	b8 0f 00 00 00       	mov    $0xf,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <mknod>:
SYSCALL(mknod)
 338:	b8 11 00 00 00       	mov    $0x11,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <unlink>:
SYSCALL(unlink)
 340:	b8 12 00 00 00       	mov    $0x12,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <fstat>:
SYSCALL(fstat)
 348:	b8 08 00 00 00       	mov    $0x8,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <link>:
SYSCALL(link)
 350:	b8 13 00 00 00       	mov    $0x13,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <mkdir>:
SYSCALL(mkdir)
 358:	b8 14 00 00 00       	mov    $0x14,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <chdir>:
SYSCALL(chdir)
 360:	b8 09 00 00 00       	mov    $0x9,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <dup>:
SYSCALL(dup)
 368:	b8 0a 00 00 00       	mov    $0xa,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <getpid>:
SYSCALL(getpid)
 370:	b8 0b 00 00 00       	mov    $0xb,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <sbrk>:
SYSCALL(sbrk)
 378:	b8 0c 00 00 00       	mov    $0xc,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <sleep>:
SYSCALL(sleep)
 380:	b8 0d 00 00 00       	mov    $0xd,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <uptime>:
SYSCALL(uptime)
 388:	b8 0e 00 00 00       	mov    $0xe,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 28             	sub    $0x28,%esp
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 39c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a3:	00 
 3a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	89 04 24             	mov    %eax,(%esp)
 3b1:	e8 5a ff ff ff       	call   310 <write>
}
 3b6:	c9                   	leave  
 3b7:	c3                   	ret    

000003b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b8:	55                   	push   %ebp
 3b9:	89 e5                	mov    %esp,%ebp
 3bb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c9:	74 17                	je     3e2 <printint+0x2a>
 3cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3cf:	79 11                	jns    3e2 <printint+0x2a>
    neg = 1;
 3d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	f7 d8                	neg    %eax
 3dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e0:	eb 06                	jmp    3e8 <printint+0x30>
  } else {
    x = xx;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f5:	ba 00 00 00 00       	mov    $0x0,%edx
 3fa:	f7 f1                	div    %ecx
 3fc:	89 d0                	mov    %edx,%eax
 3fe:	0f b6 90 98 0a 00 00 	movzbl 0xa98(%eax),%edx
 405:	8d 45 dc             	lea    -0x24(%ebp),%eax
 408:	03 45 f4             	add    -0xc(%ebp),%eax
 40b:	88 10                	mov    %dl,(%eax)
 40d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 411:	8b 55 10             	mov    0x10(%ebp),%edx
 414:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 417:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41a:	ba 00 00 00 00       	mov    $0x0,%edx
 41f:	f7 75 d4             	divl   -0x2c(%ebp)
 422:	89 45 ec             	mov    %eax,-0x14(%ebp)
 425:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 429:	75 c4                	jne    3ef <printint+0x37>
  if(neg)
 42b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42f:	74 2a                	je     45b <printint+0xa3>
    buf[i++] = '-';
 431:	8d 45 dc             	lea    -0x24(%ebp),%eax
 434:	03 45 f4             	add    -0xc(%ebp),%eax
 437:	c6 00 2d             	movb   $0x2d,(%eax)
 43a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 43e:	eb 1b                	jmp    45b <printint+0xa3>
    putc(fd, buf[i]);
 440:	8d 45 dc             	lea    -0x24(%ebp),%eax
 443:	03 45 f4             	add    -0xc(%ebp),%eax
 446:	0f b6 00             	movzbl (%eax),%eax
 449:	0f be c0             	movsbl %al,%eax
 44c:	89 44 24 04          	mov    %eax,0x4(%esp)
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	89 04 24             	mov    %eax,(%esp)
 456:	e8 35 ff ff ff       	call   390 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 45f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 463:	79 db                	jns    440 <printint+0x88>
    putc(fd, buf[i]);
}
 465:	c9                   	leave  
 466:	c3                   	ret    

00000467 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 467:	55                   	push   %ebp
 468:	89 e5                	mov    %esp,%ebp
 46a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 46d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 474:	8d 45 0c             	lea    0xc(%ebp),%eax
 477:	83 c0 04             	add    $0x4,%eax
 47a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 47d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 484:	e9 7d 01 00 00       	jmp    606 <printf+0x19f>
    c = fmt[i] & 0xff;
 489:	8b 55 0c             	mov    0xc(%ebp),%edx
 48c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48f:	01 d0                	add    %edx,%eax
 491:	0f b6 00             	movzbl (%eax),%eax
 494:	0f be c0             	movsbl %al,%eax
 497:	25 ff 00 00 00       	and    $0xff,%eax
 49c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 49f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a3:	75 2c                	jne    4d1 <printf+0x6a>
      if(c == '%'){
 4a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a9:	75 0c                	jne    4b7 <printf+0x50>
        state = '%';
 4ab:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b2:	e9 4b 01 00 00       	jmp    602 <printf+0x19b>
      } else {
        putc(fd, c);
 4b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	89 04 24             	mov    %eax,(%esp)
 4c7:	e8 c4 fe ff ff       	call   390 <putc>
 4cc:	e9 31 01 00 00       	jmp    602 <printf+0x19b>
      }
    } else if(state == '%'){
 4d1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d5:	0f 85 27 01 00 00    	jne    602 <printf+0x19b>
      if(c == 'd'){
 4db:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4df:	75 2d                	jne    50e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e4:	8b 00                	mov    (%eax),%eax
 4e6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ed:	00 
 4ee:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f5:	00 
 4f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	89 04 24             	mov    %eax,(%esp)
 500:	e8 b3 fe ff ff       	call   3b8 <printint>
        ap++;
 505:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 509:	e9 ed 00 00 00       	jmp    5fb <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 50e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 512:	74 06                	je     51a <printf+0xb3>
 514:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 518:	75 2d                	jne    547 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 51a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51d:	8b 00                	mov    (%eax),%eax
 51f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 526:	00 
 527:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 52e:	00 
 52f:	89 44 24 04          	mov    %eax,0x4(%esp)
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	89 04 24             	mov    %eax,(%esp)
 539:	e8 7a fe ff ff       	call   3b8 <printint>
        ap++;
 53e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 542:	e9 b4 00 00 00       	jmp    5fb <printf+0x194>
      } else if(c == 's'){
 547:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54b:	75 46                	jne    593 <printf+0x12c>
        s = (char*)*ap;
 54d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 550:	8b 00                	mov    (%eax),%eax
 552:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55d:	75 27                	jne    586 <printf+0x11f>
          s = "(null)";
 55f:	c7 45 f4 52 08 00 00 	movl   $0x852,-0xc(%ebp)
        while(*s != 0){
 566:	eb 1e                	jmp    586 <printf+0x11f>
          putc(fd, *s);
 568:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56b:	0f b6 00             	movzbl (%eax),%eax
 56e:	0f be c0             	movsbl %al,%eax
 571:	89 44 24 04          	mov    %eax,0x4(%esp)
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	89 04 24             	mov    %eax,(%esp)
 57b:	e8 10 fe ff ff       	call   390 <putc>
          s++;
 580:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 584:	eb 01                	jmp    587 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 586:	90                   	nop
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	84 c0                	test   %al,%al
 58f:	75 d7                	jne    568 <printf+0x101>
 591:	eb 68                	jmp    5fb <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 593:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 597:	75 1d                	jne    5b6 <printf+0x14f>
        putc(fd, *ap);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	89 04 24             	mov    %eax,(%esp)
 5ab:	e8 e0 fd ff ff       	call   390 <putc>
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b4:	eb 45                	jmp    5fb <printf+0x194>
      } else if(c == '%'){
 5b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ba:	75 17                	jne    5d3 <printf+0x16c>
        putc(fd, c);
 5bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bf:	0f be c0             	movsbl %al,%eax
 5c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	89 04 24             	mov    %eax,(%esp)
 5cc:	e8 bf fd ff ff       	call   390 <putc>
 5d1:	eb 28                	jmp    5fb <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5da:	00 
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	89 04 24             	mov    %eax,(%esp)
 5e1:	e8 aa fd ff ff       	call   390 <putc>
        putc(fd, c);
 5e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e9:	0f be c0             	movsbl %al,%eax
 5ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	89 04 24             	mov    %eax,(%esp)
 5f6:	e8 95 fd ff ff       	call   390 <putc>
      }
      state = 0;
 5fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 602:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 606:	8b 55 0c             	mov    0xc(%ebp),%edx
 609:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60c:	01 d0                	add    %edx,%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	84 c0                	test   %al,%al
 613:	0f 85 70 fe ff ff    	jne    489 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 619:	c9                   	leave  
 61a:	c3                   	ret    
 61b:	90                   	nop

0000061c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 622:	8b 45 08             	mov    0x8(%ebp),%eax
 625:	83 e8 08             	sub    $0x8,%eax
 628:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62b:	a1 b4 0a 00 00       	mov    0xab4,%eax
 630:	89 45 fc             	mov    %eax,-0x4(%ebp)
 633:	eb 24                	jmp    659 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63d:	77 12                	ja     651 <free+0x35>
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	77 24                	ja     66b <free+0x4f>
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64f:	77 1a                	ja     66b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	89 45 fc             	mov    %eax,-0x4(%ebp)
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65f:	76 d4                	jbe    635 <free+0x19>
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 669:	76 ca                	jbe    635 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	c1 e0 03             	shl    $0x3,%eax
 674:	89 c2                	mov    %eax,%edx
 676:	03 55 f8             	add    -0x8(%ebp),%edx
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	39 c2                	cmp    %eax,%edx
 680:	75 24                	jne    6a6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	8b 40 04             	mov    0x4(%eax),%eax
 690:	01 c2                	add    %eax,%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	eb 0a                	jmp    6b0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 40 04             	mov    0x4(%eax),%eax
 6b6:	c1 e0 03             	shl    $0x3,%eax
 6b9:	03 45 fc             	add    -0x4(%ebp),%eax
 6bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bf:	75 20                	jne    6e1 <free+0xc5>
    p->s.size += bp->s.size;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 50 04             	mov    0x4(%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	01 c2                	add    %eax,%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	8b 10                	mov    (%eax),%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 10                	mov    %edx,(%eax)
 6df:	eb 08                	jmp    6e9 <free+0xcd>
  } else
    p->s.ptr = bp;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	a3 b4 0a 00 00       	mov    %eax,0xab4
}
 6f1:	c9                   	leave  
 6f2:	c3                   	ret    

000006f3 <morecore>:

static Header*
morecore(uint nu)
{
 6f3:	55                   	push   %ebp
 6f4:	89 e5                	mov    %esp,%ebp
 6f6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 700:	77 07                	ja     709 <morecore+0x16>
    nu = 4096;
 702:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 709:	8b 45 08             	mov    0x8(%ebp),%eax
 70c:	c1 e0 03             	shl    $0x3,%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 61 fc ff ff       	call   378 <sbrk>
 717:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 71a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 71e:	75 07                	jne    727 <morecore+0x34>
    return 0;
 720:	b8 00 00 00 00       	mov    $0x0,%eax
 725:	eb 22                	jmp    749 <morecore+0x56>
  hp = (Header*)p;
 727:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 72d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 730:	8b 55 08             	mov    0x8(%ebp),%edx
 733:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 736:	8b 45 f0             	mov    -0x10(%ebp),%eax
 739:	83 c0 08             	add    $0x8,%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 d8 fe ff ff       	call   61c <free>
  return freep;
 744:	a1 b4 0a 00 00       	mov    0xab4,%eax
}
 749:	c9                   	leave  
 74a:	c3                   	ret    

0000074b <malloc>:

void*
malloc(uint nbytes)
{
 74b:	55                   	push   %ebp
 74c:	89 e5                	mov    %esp,%ebp
 74e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	83 c0 07             	add    $0x7,%eax
 757:	c1 e8 03             	shr    $0x3,%eax
 75a:	83 c0 01             	add    $0x1,%eax
 75d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 760:	a1 b4 0a 00 00       	mov    0xab4,%eax
 765:	89 45 f0             	mov    %eax,-0x10(%ebp)
 768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76c:	75 23                	jne    791 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 76e:	c7 45 f0 ac 0a 00 00 	movl   $0xaac,-0x10(%ebp)
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	a3 b4 0a 00 00       	mov    %eax,0xab4
 77d:	a1 b4 0a 00 00       	mov    0xab4,%eax
 782:	a3 ac 0a 00 00       	mov    %eax,0xaac
    base.s.size = 0;
 787:	c7 05 b0 0a 00 00 00 	movl   $0x0,0xab0
 78e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a2:	72 4d                	jb     7f1 <malloc+0xa6>
      if(p->s.size == nunits)
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ad:	75 0c                	jne    7bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 10                	mov    (%eax),%edx
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	89 10                	mov    %edx,(%eax)
 7b9:	eb 26                	jmp    7e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	89 c2                	mov    %eax,%edx
 7c3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	c1 e0 03             	shl    $0x3,%eax
 7d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	a3 b4 0a 00 00       	mov    %eax,0xab4
      return (void*)(p + 1);
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	83 c0 08             	add    $0x8,%eax
 7ef:	eb 38                	jmp    829 <malloc+0xde>
    }
    if(p == freep)
 7f1:	a1 b4 0a 00 00       	mov    0xab4,%eax
 7f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f9:	75 1b                	jne    816 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7fe:	89 04 24             	mov    %eax,(%esp)
 801:	e8 ed fe ff ff       	call   6f3 <morecore>
 806:	89 45 f4             	mov    %eax,-0xc(%ebp)
 809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80d:	75 07                	jne    816 <malloc+0xcb>
        return 0;
 80f:	b8 00 00 00 00       	mov    $0x0,%eax
 814:	eb 13                	jmp    829 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 824:	e9 70 ff ff ff       	jmp    799 <malloc+0x4e>
}
 829:	c9                   	leave  
 82a:	c3                   	ret    
