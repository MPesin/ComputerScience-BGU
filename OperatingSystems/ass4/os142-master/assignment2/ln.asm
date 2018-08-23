
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
   f:	c7 44 24 04 6c 0e 00 	movl   $0xe6c,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 56 04 00 00       	call   479 <printf>
    exit();
  23:	e8 b9 02 00 00       	call   2e1 <exit>
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
  3f:	e8 15 03 00 00       	call   359 <link>
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
  60:	c7 44 24 04 7f 0e 00 	movl   $0xe7f,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 05 04 00 00       	call   479 <printf>
  exit();
  74:	e8 68 02 00 00       	call   2e1 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  aa:	90                   	nop
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	8d 50 01             	lea    0x1(%eax),%edx
  b1:	89 55 08             	mov    %edx,0x8(%ebp)
  b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  bd:	0f b6 12             	movzbl (%edx),%edx
  c0:	88 10                	mov    %dl,(%eax)
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	84 c0                	test   %al,%al
  c7:	75 e2                	jne    ab <strcpy+0xd>
    ;
  return os;
  c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d1:	eb 08                	jmp    db <strcmp+0xd>
    p++, q++;
  d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	0f b6 00             	movzbl (%eax),%eax
  e1:	84 c0                	test   %al,%al
  e3:	74 10                	je     f5 <strcmp+0x27>
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	38 c2                	cmp    %al,%dl
  f3:	74 de                	je     d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 d0             	movzbl %al,%edx
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	0f b6 c0             	movzbl %al,%eax
 107:	29 c2                	sub    %eax,%edx
 109:	89 d0                	mov    %edx,%eax
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <strlen>:

uint
strlen(char *s)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11a:	eb 04                	jmp    120 <strlen+0x13>
 11c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 120:	8b 55 fc             	mov    -0x4(%ebp),%edx
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	01 d0                	add    %edx,%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	75 ed                	jne    11c <strlen+0xf>
    ;
  return n;
 12f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 13a:	8b 45 10             	mov    0x10(%ebp),%eax
 13d:	89 44 24 08          	mov    %eax,0x8(%esp)
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	89 44 24 04          	mov    %eax,0x4(%esp)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 04 24             	mov    %eax,(%esp)
 14e:	e8 26 ff ff ff       	call   79 <stosb>
  return dst;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
}
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <strchr>:

char*
strchr(const char *s, char c)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 04             	sub    $0x4,%esp
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 164:	eb 14                	jmp    17a <strchr+0x22>
    if(*s == c)
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	0f b6 00             	movzbl (%eax),%eax
 16c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16f:	75 05                	jne    176 <strchr+0x1e>
      return (char*)s;
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	eb 13                	jmp    189 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	84 c0                	test   %al,%al
 182:	75 e2                	jne    166 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 184:	b8 00 00 00 00       	mov    $0x0,%eax
}
 189:	c9                   	leave  
 18a:	c3                   	ret    

0000018b <gets>:

char*
gets(char *buf, int max)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
 18e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 198:	eb 4c                	jmp    1e6 <gets+0x5b>
    cc = read(0, &c, 1);
 19a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a1:	00 
 1a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b0:	e8 5c 01 00 00       	call   311 <read>
 1b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1bc:	7f 02                	jg     1c0 <gets+0x35>
      break;
 1be:	eb 31                	jmp    1f1 <gets+0x66>
    buf[i++] = c;
 1c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c3:	8d 50 01             	lea    0x1(%eax),%edx
 1c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c9:	89 c2                	mov    %eax,%edx
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	01 c2                	add    %eax,%edx
 1d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1da:	3c 0a                	cmp    $0xa,%al
 1dc:	74 13                	je     1f1 <gets+0x66>
 1de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e2:	3c 0d                	cmp    $0xd,%al
 1e4:	74 0b                	je     1f1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e9:	83 c0 01             	add    $0x1,%eax
 1ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ef:	7c a9                	jl     19a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	01 d0                	add    %edx,%eax
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
 215:	e8 1f 01 00 00       	call   339 <open>
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
 237:	e8 15 01 00 00       	call   351 <fstat>
 23c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 d7 00 00 00       	call   321 <close>
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
 25c:	eb 25                	jmp    283 <atoi+0x34>
    n = n*10 + *s++ - '0';
 25e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 261:	89 d0                	mov    %edx,%eax
 263:	c1 e0 02             	shl    $0x2,%eax
 266:	01 d0                	add    %edx,%eax
 268:	01 c0                	add    %eax,%eax
 26a:	89 c1                	mov    %eax,%ecx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8d 50 01             	lea    0x1(%eax),%edx
 272:	89 55 08             	mov    %edx,0x8(%ebp)
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	0f be c0             	movsbl %al,%eax
 27b:	01 c8                	add    %ecx,%eax
 27d:	83 e8 30             	sub    $0x30,%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 00             	movzbl (%eax),%eax
 289:	3c 2f                	cmp    $0x2f,%al
 28b:	7e 0a                	jle    297 <atoi+0x48>
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	3c 39                	cmp    $0x39,%al
 295:	7e c7                	jle    25e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ae:	eb 17                	jmp    2c7 <memmove+0x2b>
    *dst++ = *src++;
 2b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b3:	8d 50 01             	lea    0x1(%eax),%edx
 2b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2bc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c2:	0f b6 12             	movzbl (%edx),%edx
 2c5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ca:	8d 50 ff             	lea    -0x1(%eax),%edx
 2cd:	89 55 10             	mov    %edx,0x10(%ebp)
 2d0:	85 c0                	test   %eax,%eax
 2d2:	7f dc                	jg     2b0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d9:	b8 01 00 00 00       	mov    $0x1,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <exit>:
SYSCALL(exit)
 2e1:	b8 02 00 00 00       	mov    $0x2,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <wait>:
SYSCALL(wait)
 2e9:	b8 03 00 00 00       	mov    $0x3,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <signal>:
SYSCALL(signal)
 2f1:	b8 18 00 00 00       	mov    $0x18,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <sigsend>:
SYSCALL(sigsend)
 2f9:	b8 19 00 00 00       	mov    $0x19,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <alarm>:
SYSCALL(alarm)
 301:	b8 1a 00 00 00       	mov    $0x1a,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <pipe>:
SYSCALL(pipe)
 309:	b8 04 00 00 00       	mov    $0x4,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <read>:
SYSCALL(read)
 311:	b8 05 00 00 00       	mov    $0x5,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <write>:
SYSCALL(write)
 319:	b8 10 00 00 00       	mov    $0x10,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <close>:
SYSCALL(close)
 321:	b8 15 00 00 00       	mov    $0x15,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <kill>:
SYSCALL(kill)
 329:	b8 06 00 00 00       	mov    $0x6,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <exec>:
SYSCALL(exec)
 331:	b8 07 00 00 00       	mov    $0x7,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <open>:
SYSCALL(open)
 339:	b8 0f 00 00 00       	mov    $0xf,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <mknod>:
SYSCALL(mknod)
 341:	b8 11 00 00 00       	mov    $0x11,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <unlink>:
SYSCALL(unlink)
 349:	b8 12 00 00 00       	mov    $0x12,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <fstat>:
SYSCALL(fstat)
 351:	b8 08 00 00 00       	mov    $0x8,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <link>:
SYSCALL(link)
 359:	b8 13 00 00 00       	mov    $0x13,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <mkdir>:
SYSCALL(mkdir)
 361:	b8 14 00 00 00       	mov    $0x14,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <chdir>:
SYSCALL(chdir)
 369:	b8 09 00 00 00       	mov    $0x9,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <dup>:
SYSCALL(dup)
 371:	b8 0a 00 00 00       	mov    $0xa,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <getpid>:
SYSCALL(getpid)
 379:	b8 0b 00 00 00       	mov    $0xb,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sbrk>:
SYSCALL(sbrk)
 381:	b8 0c 00 00 00       	mov    $0xc,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sleep>:
SYSCALL(sleep)
 389:	b8 0d 00 00 00       	mov    $0xd,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <uptime>:
SYSCALL(uptime)
 391:	b8 0e 00 00 00       	mov    $0xe,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	83 ec 18             	sub    $0x18,%esp
 39f:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ac:	00 
 3ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	89 04 24             	mov    %eax,(%esp)
 3ba:	e8 5a ff ff ff       	call   319 <write>
}
 3bf:	c9                   	leave  
 3c0:	c3                   	ret    

000003c1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c1:	55                   	push   %ebp
 3c2:	89 e5                	mov    %esp,%ebp
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d4:	74 17                	je     3ed <printint+0x2c>
 3d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3da:	79 11                	jns    3ed <printint+0x2c>
    neg = 1;
 3dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	f7 d8                	neg    %eax
 3e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3eb:	eb 06                	jmp    3f3 <printint+0x32>
  } else {
    x = xx;
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3fd:	8d 41 01             	lea    0x1(%ecx),%eax
 400:	89 45 f4             	mov    %eax,-0xc(%ebp)
 403:	8b 5d 10             	mov    0x10(%ebp),%ebx
 406:	8b 45 ec             	mov    -0x14(%ebp),%eax
 409:	ba 00 00 00 00       	mov    $0x0,%edx
 40e:	f7 f3                	div    %ebx
 410:	89 d0                	mov    %edx,%eax
 412:	0f b6 80 14 13 00 00 	movzbl 0x1314(%eax),%eax
 419:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 41d:	8b 75 10             	mov    0x10(%ebp),%esi
 420:	8b 45 ec             	mov    -0x14(%ebp),%eax
 423:	ba 00 00 00 00       	mov    $0x0,%edx
 428:	f7 f6                	div    %esi
 42a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 431:	75 c7                	jne    3fa <printint+0x39>
  if(neg)
 433:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 437:	74 10                	je     449 <printint+0x88>
    buf[i++] = '-';
 439:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43c:	8d 50 01             	lea    0x1(%eax),%edx
 43f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 442:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 447:	eb 1f                	jmp    468 <printint+0xa7>
 449:	eb 1d                	jmp    468 <printint+0xa7>
    putc(fd, buf[i]);
 44b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	0f b6 00             	movzbl (%eax),%eax
 456:	0f be c0             	movsbl %al,%eax
 459:	89 44 24 04          	mov    %eax,0x4(%esp)
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	89 04 24             	mov    %eax,(%esp)
 463:	e8 31 ff ff ff       	call   399 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 468:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 470:	79 d9                	jns    44b <printint+0x8a>
    putc(fd, buf[i]);
}
 472:	83 c4 30             	add    $0x30,%esp
 475:	5b                   	pop    %ebx
 476:	5e                   	pop    %esi
 477:	5d                   	pop    %ebp
 478:	c3                   	ret    

00000479 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 486:	8d 45 0c             	lea    0xc(%ebp),%eax
 489:	83 c0 04             	add    $0x4,%eax
 48c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 496:	e9 7c 01 00 00       	jmp    617 <printf+0x19e>
    c = fmt[i] & 0xff;
 49b:	8b 55 0c             	mov    0xc(%ebp),%edx
 49e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a1:	01 d0                	add    %edx,%eax
 4a3:	0f b6 00             	movzbl (%eax),%eax
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	25 ff 00 00 00       	and    $0xff,%eax
 4ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b5:	75 2c                	jne    4e3 <printf+0x6a>
      if(c == '%'){
 4b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bb:	75 0c                	jne    4c9 <printf+0x50>
        state = '%';
 4bd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c4:	e9 4a 01 00 00       	jmp    613 <printf+0x19a>
      } else {
        putc(fd, c);
 4c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cc:	0f be c0             	movsbl %al,%eax
 4cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	89 04 24             	mov    %eax,(%esp)
 4d9:	e8 bb fe ff ff       	call   399 <putc>
 4de:	e9 30 01 00 00       	jmp    613 <printf+0x19a>
      }
    } else if(state == '%'){
 4e3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e7:	0f 85 26 01 00 00    	jne    613 <printf+0x19a>
      if(c == 'd'){
 4ed:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f1:	75 2d                	jne    520 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ff:	00 
 500:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 507:	00 
 508:	89 44 24 04          	mov    %eax,0x4(%esp)
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	89 04 24             	mov    %eax,(%esp)
 512:	e8 aa fe ff ff       	call   3c1 <printint>
        ap++;
 517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51b:	e9 ec 00 00 00       	jmp    60c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 520:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 524:	74 06                	je     52c <printf+0xb3>
 526:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52a:	75 2d                	jne    559 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 52c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 538:	00 
 539:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 540:	00 
 541:	89 44 24 04          	mov    %eax,0x4(%esp)
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	89 04 24             	mov    %eax,(%esp)
 54b:	e8 71 fe ff ff       	call   3c1 <printint>
        ap++;
 550:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 554:	e9 b3 00 00 00       	jmp    60c <printf+0x193>
      } else if(c == 's'){
 559:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55d:	75 45                	jne    5a4 <printf+0x12b>
        s = (char*)*ap;
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	8b 00                	mov    (%eax),%eax
 564:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 567:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56f:	75 09                	jne    57a <printf+0x101>
          s = "(null)";
 571:	c7 45 f4 93 0e 00 00 	movl   $0xe93,-0xc(%ebp)
        while(*s != 0){
 578:	eb 1e                	jmp    598 <printf+0x11f>
 57a:	eb 1c                	jmp    598 <printf+0x11f>
          putc(fd, *s);
 57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 05 fe ff ff       	call   399 <putc>
          s++;
 594:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 598:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59b:	0f b6 00             	movzbl (%eax),%eax
 59e:	84 c0                	test   %al,%al
 5a0:	75 da                	jne    57c <printf+0x103>
 5a2:	eb 68                	jmp    60c <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a8:	75 1d                	jne    5c7 <printf+0x14e>
        putc(fd, *ap);
 5aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	89 04 24             	mov    %eax,(%esp)
 5bc:	e8 d8 fd ff ff       	call   399 <putc>
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c5:	eb 45                	jmp    60c <printf+0x193>
      } else if(c == '%'){
 5c7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5cb:	75 17                	jne    5e4 <printf+0x16b>
        putc(fd, c);
 5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	89 04 24             	mov    %eax,(%esp)
 5dd:	e8 b7 fd ff ff       	call   399 <putc>
 5e2:	eb 28                	jmp    60c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5eb:	00 
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	89 04 24             	mov    %eax,(%esp)
 5f2:	e8 a2 fd ff ff       	call   399 <putc>
        putc(fd, c);
 5f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fa:	0f be c0             	movsbl %al,%eax
 5fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 601:	8b 45 08             	mov    0x8(%ebp),%eax
 604:	89 04 24             	mov    %eax,(%esp)
 607:	e8 8d fd ff ff       	call   399 <putc>
      }
      state = 0;
 60c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 613:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 617:	8b 55 0c             	mov    0xc(%ebp),%edx
 61a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61d:	01 d0                	add    %edx,%eax
 61f:	0f b6 00             	movzbl (%eax),%eax
 622:	84 c0                	test   %al,%al
 624:	0f 85 71 fe ff ff    	jne    49b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 62a:	c9                   	leave  
 62b:	c3                   	ret    

0000062c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62c:	55                   	push   %ebp
 62d:	89 e5                	mov    %esp,%ebp
 62f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	83 e8 08             	sub    $0x8,%eax
 638:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63b:	a1 48 13 00 00       	mov    0x1348,%eax
 640:	89 45 fc             	mov    %eax,-0x4(%ebp)
 643:	eb 24                	jmp    669 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	77 12                	ja     661 <free+0x35>
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 655:	77 24                	ja     67b <free+0x4f>
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	77 1a                	ja     67b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	89 45 fc             	mov    %eax,-0x4(%ebp)
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66f:	76 d4                	jbe    645 <free+0x19>
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 679:	76 ca                	jbe    645 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	8b 40 04             	mov    0x4(%eax),%eax
 681:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	01 c2                	add    %eax,%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	39 c2                	cmp    %eax,%edx
 694:	75 24                	jne    6ba <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	8b 50 04             	mov    0x4(%eax),%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
 6b8:	eb 0a                	jmp    6c4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 40 04             	mov    0x4(%eax),%eax
 6ca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	01 d0                	add    %edx,%eax
 6d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d9:	75 20                	jne    6fb <free+0xcf>
    p->s.size += bp->s.size;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 50 04             	mov    0x4(%eax),%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	8b 40 04             	mov    0x4(%eax),%eax
 6e7:	01 c2                	add    %eax,%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	89 10                	mov    %edx,(%eax)
 6f9:	eb 08                	jmp    703 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 701:	89 10                	mov    %edx,(%eax)
  freep = p;
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	a3 48 13 00 00       	mov    %eax,0x1348
}
 70b:	c9                   	leave  
 70c:	c3                   	ret    

0000070d <morecore>:

static Header*
morecore(uint nu)
{
 70d:	55                   	push   %ebp
 70e:	89 e5                	mov    %esp,%ebp
 710:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 713:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71a:	77 07                	ja     723 <morecore+0x16>
    nu = 4096;
 71c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	c1 e0 03             	shl    $0x3,%eax
 729:	89 04 24             	mov    %eax,(%esp)
 72c:	e8 50 fc ff ff       	call   381 <sbrk>
 731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 734:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 738:	75 07                	jne    741 <morecore+0x34>
    return 0;
 73a:	b8 00 00 00 00       	mov    $0x0,%eax
 73f:	eb 22                	jmp    763 <morecore+0x56>
  hp = (Header*)p;
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74a:	8b 55 08             	mov    0x8(%ebp),%edx
 74d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 750:	8b 45 f0             	mov    -0x10(%ebp),%eax
 753:	83 c0 08             	add    $0x8,%eax
 756:	89 04 24             	mov    %eax,(%esp)
 759:	e8 ce fe ff ff       	call   62c <free>
  return freep;
 75e:	a1 48 13 00 00       	mov    0x1348,%eax
}
 763:	c9                   	leave  
 764:	c3                   	ret    

00000765 <malloc>:

void*
malloc(uint nbytes)
{
 765:	55                   	push   %ebp
 766:	89 e5                	mov    %esp,%ebp
 768:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	83 c0 07             	add    $0x7,%eax
 771:	c1 e8 03             	shr    $0x3,%eax
 774:	83 c0 01             	add    $0x1,%eax
 777:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 77a:	a1 48 13 00 00       	mov    0x1348,%eax
 77f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 782:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 786:	75 23                	jne    7ab <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 788:	c7 45 f0 40 13 00 00 	movl   $0x1340,-0x10(%ebp)
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	a3 48 13 00 00       	mov    %eax,0x1348
 797:	a1 48 13 00 00       	mov    0x1348,%eax
 79c:	a3 40 13 00 00       	mov    %eax,0x1340
    base.s.size = 0;
 7a1:	c7 05 44 13 00 00 00 	movl   $0x0,0x1344
 7a8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	8b 00                	mov    (%eax),%eax
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 40 04             	mov    0x4(%eax),%eax
 7b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bc:	72 4d                	jb     80b <malloc+0xa6>
      if(p->s.size == nunits)
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c7:	75 0c                	jne    7d5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 10                	mov    (%eax),%edx
 7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d1:	89 10                	mov    %edx,(%eax)
 7d3:	eb 26                	jmp    7fb <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7de:	89 c2                	mov    %eax,%edx
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	c1 e0 03             	shl    $0x3,%eax
 7ef:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fe:	a3 48 13 00 00       	mov    %eax,0x1348
      return (void*)(p + 1);
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	83 c0 08             	add    $0x8,%eax
 809:	eb 38                	jmp    843 <malloc+0xde>
    }
    if(p == freep)
 80b:	a1 48 13 00 00       	mov    0x1348,%eax
 810:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 813:	75 1b                	jne    830 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 815:	8b 45 ec             	mov    -0x14(%ebp),%eax
 818:	89 04 24             	mov    %eax,(%esp)
 81b:	e8 ed fe ff ff       	call   70d <morecore>
 820:	89 45 f4             	mov    %eax,-0xc(%ebp)
 823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 827:	75 07                	jne    830 <malloc+0xcb>
        return 0;
 829:	b8 00 00 00 00       	mov    $0x0,%eax
 82e:	eb 13                	jmp    843 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	89 45 f0             	mov    %eax,-0x10(%ebp)
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 00                	mov    (%eax),%eax
 83b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83e:	e9 70 ff ff ff       	jmp    7b3 <malloc+0x4e>
}
 843:	c9                   	leave  
 844:	c3                   	ret    

00000845 <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 845:	55                   	push   %ebp
 846:	89 e5                	mov    %esp,%ebp
 848:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 84b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 852:	eb 17                	jmp    86b <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 85e:	85 c0                	test   %eax,%eax
 860:	75 05                	jne    867 <findNextFreeThreadId+0x22>
			return i;
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	eb 0f                	jmp    876 <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 867:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 86b:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 86f:	7e e3                	jle    854 <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 876:	c9                   	leave  
 877:	c3                   	ret    

00000878 <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 878:	55                   	push   %ebp
 879:	89 e5                	mov    %esp,%ebp
 87b:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 87e:	a1 60 14 00 00       	mov    0x1460,%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	8d 50 01             	lea    0x1(%eax),%edx
 888:	89 d0                	mov    %edx,%eax
 88a:	c1 f8 1f             	sar    $0x1f,%eax
 88d:	c1 e8 1a             	shr    $0x1a,%eax
 890:	01 c2                	add    %eax,%edx
 892:	83 e2 3f             	and    $0x3f,%edx
 895:	29 c2                	sub    %eax,%edx
 897:	89 d0                	mov    %edx,%eax
 899:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 89c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89f:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 8a6:	8b 40 28             	mov    0x28(%eax),%eax
 8a9:	83 f8 02             	cmp    $0x2,%eax
 8ac:	75 0c                	jne    8ba <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 8ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b1:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 8b8:	eb 1c                	jmp    8d6 <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 8ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bd:	8d 50 01             	lea    0x1(%eax),%edx
 8c0:	89 d0                	mov    %edx,%eax
 8c2:	c1 f8 1f             	sar    $0x1f,%eax
 8c5:	c1 e8 1a             	shr    $0x1a,%eax
 8c8:	01 c2                	add    %eax,%edx
 8ca:	83 e2 3f             	and    $0x3f,%edx
 8cd:	29 c2                	sub    %eax,%edx
 8cf:	89 d0                	mov    %edx,%eax
 8d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 8d4:	eb c6                	jmp    89c <findNextRunnableThread+0x24>
}
 8d6:	c9                   	leave  
 8d7:	c3                   	ret    

000008d8 <uthread_init>:

void uthread_init(void)
{
 8d8:	55                   	push   %ebp
 8d9:	89 e5                	mov    %esp,%ebp
 8db:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 8de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 8e5:	eb 12                	jmp    8f9 <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	c7 04 85 60 13 00 00 	movl   $0x0,0x1360(,%eax,4)
 8f1:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 8f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8f9:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 8fd:	7e e8                	jle    8e7 <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 8ff:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 906:	e8 5a fe ff ff       	call   765 <malloc>
 90b:	a3 60 13 00 00       	mov    %eax,0x1360
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 910:	a1 60 13 00 00       	mov    0x1360,%eax
 915:	89 e2                	mov    %esp,%edx
 917:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 91a:	a1 60 13 00 00       	mov    0x1360,%eax
 91f:	89 ea                	mov    %ebp,%edx
 921:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 924:	a1 60 13 00 00       	mov    0x1360,%eax
 929:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 930:	a1 60 13 00 00       	mov    0x1360,%eax
 935:	a3 60 14 00 00       	mov    %eax,0x1460
	threadTable.threadCount = 1;
 93a:	c7 05 64 14 00 00 01 	movl   $0x1,0x1464
 941:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 944:	c7 44 24 04 1d 0b 00 	movl   $0xb1d,0x4(%esp)
 94b:	00 
 94c:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 953:	e8 99 f9 ff ff       	call   2f1 <signal>
	alarm(UTHREAD_QUANTA);
 958:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 95f:	e8 9d f9 ff ff       	call   301 <alarm>
}
 964:	c9                   	leave  
 965:	c3                   	ret    

00000966 <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 966:	55                   	push   %ebp
 967:	89 e5                	mov    %esp,%ebp
 969:	53                   	push   %ebx
 96a:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 96d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 974:	e8 88 f9 ff ff       	call   301 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 979:	e8 c7 fe ff ff       	call   845 <findNextFreeThreadId>
 97e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 981:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 985:	75 0a                	jne    991 <uthread_create+0x2b>
		return -1;
 987:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 98c:	e9 d6 00 00 00       	jmp    a67 <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 991:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 998:	e8 c8 fd ff ff       	call   765 <malloc>
 99d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9a0:	89 04 95 60 13 00 00 	mov    %eax,0x1360(,%edx,4)
	threadTable.threads[current]->tid = current;
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 9b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9b4:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 9c0:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 9c7:	a1 64 14 00 00       	mov    0x1464,%eax
 9cc:	83 c0 01             	add    $0x1,%eax
 9cf:	a3 64 14 00 00       	mov    %eax,0x1464
	threadTable.threads[current]->entry = func;
 9d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d7:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 9de:	8b 55 08             	mov    0x8(%ebp),%edx
 9e1:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 9ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 9f1:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	8b 1c 85 60 13 00 00 	mov    0x1360(,%eax,4),%ebx
 9fe:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 a05:	e8 5b fd ff ff       	call   765 <malloc>
 a0a:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a10:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a1a:	8b 14 95 60 13 00 00 	mov    0x1360(,%edx,4),%edx
 a21:	8b 52 24             	mov    0x24(%edx),%edx
 a24:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 a2a:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a30:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a3a:	8b 14 95 60 13 00 00 	mov    0x1360(,%edx,4),%edx
 a41:	8b 52 04             	mov    0x4(%edx),%edx
 a44:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4a:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 a51:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 a58:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a5f:	e8 9d f8 ff ff       	call   301 <alarm>
	return current;
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 a67:	83 c4 24             	add    $0x24,%esp
 a6a:	5b                   	pop    %ebx
 a6b:	5d                   	pop    %ebp
 a6c:	c3                   	ret    

00000a6d <uthread_exit>:

void uthread_exit(void)
{
 a6d:	55                   	push   %ebp
 a6e:	89 e5                	mov    %esp,%ebp
 a70:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 a73:	a1 60 14 00 00       	mov    0x1460,%eax
 a78:	8b 00                	mov    (%eax),%eax
 a7a:	85 c0                	test   %eax,%eax
 a7c:	74 10                	je     a8e <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 a7e:	a1 60 14 00 00       	mov    0x1460,%eax
 a83:	8b 40 24             	mov    0x24(%eax),%eax
 a86:	89 04 24             	mov    %eax,(%esp)
 a89:	e8 9e fb ff ff       	call   62c <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 a8e:	a1 60 14 00 00       	mov    0x1460,%eax
 a93:	8b 00                	mov    (%eax),%eax
 a95:	c7 04 85 60 13 00 00 	movl   $0x0,0x1360(,%eax,4)
 a9c:	00 00 00 00 
	
	free(threadTable.runningThread);
 aa0:	a1 60 14 00 00       	mov    0x1460,%eax
 aa5:	89 04 24             	mov    %eax,(%esp)
 aa8:	e8 7f fb ff ff       	call   62c <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 aad:	a1 64 14 00 00       	mov    0x1464,%eax
 ab2:	83 e8 01             	sub    $0x1,%eax
 ab5:	a3 64 14 00 00       	mov    %eax,0x1464
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 aba:	a1 64 14 00 00       	mov    0x1464,%eax
 abf:	85 c0                	test   %eax,%eax
 ac1:	75 05                	jne    ac8 <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 ac3:	e8 19 f8 ff ff       	call   2e1 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 ac8:	e8 ab fd ff ff       	call   878 <findNextRunnableThread>
 acd:	a3 60 14 00 00       	mov    %eax,0x1460
	
	threadTable.runningThread->state = T_RUNNING;
 ad2:	a1 60 14 00 00       	mov    0x1460,%eax
 ad7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 ade:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ae5:	e8 17 f8 ff ff       	call   301 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 aea:	a1 60 14 00 00       	mov    0x1460,%eax
 aef:	8b 40 04             	mov    0x4(%eax),%eax
 af2:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 af4:	a1 60 14 00 00       	mov    0x1460,%eax
 af9:	8b 40 08             	mov    0x8(%eax),%eax
 afc:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 afe:	a1 60 14 00 00       	mov    0x1460,%eax
 b03:	8b 40 2c             	mov    0x2c(%eax),%eax
 b06:	85 c0                	test   %eax,%eax
 b08:	74 11                	je     b1b <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 b0a:	a1 60 14 00 00       	mov    0x1460,%eax
 b0f:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 b16:	e8 8e 00 00 00       	call   ba9 <wrapper>
	}
	

}
 b1b:	c9                   	leave  
 b1c:	c3                   	ret    

00000b1d <uthread_yield>:

void uthread_yield(void)
{
 b1d:	55                   	push   %ebp
 b1e:	89 e5                	mov    %esp,%ebp
 b20:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 b23:	a1 60 14 00 00       	mov    0x1460,%eax
 b28:	89 e2                	mov    %esp,%edx
 b2a:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 b2d:	a1 60 14 00 00       	mov    0x1460,%eax
 b32:	89 ea                	mov    %ebp,%edx
 b34:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 b37:	a1 60 14 00 00       	mov    0x1460,%eax
 b3c:	8b 40 28             	mov    0x28(%eax),%eax
 b3f:	83 f8 01             	cmp    $0x1,%eax
 b42:	75 0c                	jne    b50 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 b44:	a1 60 14 00 00       	mov    0x1460,%eax
 b49:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 b50:	e8 23 fd ff ff       	call   878 <findNextRunnableThread>
 b55:	a3 60 14 00 00       	mov    %eax,0x1460
	threadTable.runningThread->state = T_RUNNING;
 b5a:	a1 60 14 00 00       	mov    0x1460,%eax
 b5f:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 b66:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b6d:	e8 8f f7 ff ff       	call   301 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b72:	a1 60 14 00 00       	mov    0x1460,%eax
 b77:	8b 40 04             	mov    0x4(%eax),%eax
 b7a:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b7c:	a1 60 14 00 00       	mov    0x1460,%eax
 b81:	8b 40 08             	mov    0x8(%eax),%eax
 b84:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 b86:	a1 60 14 00 00       	mov    0x1460,%eax
 b8b:	8b 40 2c             	mov    0x2c(%eax),%eax
 b8e:	85 c0                	test   %eax,%eax
 b90:	74 14                	je     ba6 <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 b92:	a1 60 14 00 00       	mov    0x1460,%eax
 b97:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 b9e:	b8 a9 0b 00 00       	mov    $0xba9,%eax
 ba3:	ff d0                	call   *%eax
		asm("ret");
 ba5:	c3                   	ret    
	}
	return;
 ba6:	90                   	nop
}
 ba7:	c9                   	leave  
 ba8:	c3                   	ret    

00000ba9 <wrapper>:

void wrapper(void) {
 ba9:	55                   	push   %ebp
 baa:	89 e5                	mov    %esp,%ebp
 bac:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 baf:	a1 60 14 00 00       	mov    0x1460,%eax
 bb4:	8b 40 30             	mov    0x30(%eax),%eax
 bb7:	8b 15 60 14 00 00    	mov    0x1460,%edx
 bbd:	8b 52 34             	mov    0x34(%edx),%edx
 bc0:	89 14 24             	mov    %edx,(%esp)
 bc3:	ff d0                	call   *%eax
	uthread_exit();
 bc5:	e8 a3 fe ff ff       	call   a6d <uthread_exit>
}
 bca:	c9                   	leave  
 bcb:	c3                   	ret    

00000bcc <uthread_self>:

int uthread_self(void)
{
 bcc:	55                   	push   %ebp
 bcd:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 bcf:	a1 60 14 00 00       	mov    0x1460,%eax
 bd4:	8b 00                	mov    (%eax),%eax
}
 bd6:	5d                   	pop    %ebp
 bd7:	c3                   	ret    

00000bd8 <uthread_join>:

int uthread_join(int tid)
{
 bd8:	55                   	push   %ebp
 bd9:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 bdb:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 bdf:	7e 07                	jle    be8 <uthread_join+0x10>
		return -1;
 be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 be6:	eb 14                	jmp    bfc <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 be8:	90                   	nop
 be9:	8b 45 08             	mov    0x8(%ebp),%eax
 bec:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 bf3:	85 c0                	test   %eax,%eax
 bf5:	75 f2                	jne    be9 <uthread_join+0x11>
	return 0;
 bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 bfc:	5d                   	pop    %ebp
 bfd:	c3                   	ret    

00000bfe <uthread_sleep>:

void uthread_sleep(void)
{
 bfe:	55                   	push   %ebp
 bff:	89 e5                	mov    %esp,%ebp
 c01:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 c04:	a1 60 14 00 00       	mov    0x1460,%eax
 c09:	89 e2                	mov    %esp,%edx
 c0b:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 c0e:	a1 60 14 00 00       	mov    0x1460,%eax
 c13:	89 ea                	mov    %ebp,%edx
 c15:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 c18:	a1 60 14 00 00       	mov    0x1460,%eax
 c1d:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 c24:	a1 60 14 00 00       	mov    0x1460,%eax
 c29:	8b 00                	mov    (%eax),%eax
 c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
 c2f:	c7 44 24 04 9a 0e 00 	movl   $0xe9a,0x4(%esp)
 c36:	00 
 c37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c3e:	e8 36 f8 ff ff       	call   479 <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 c43:	e8 30 fc ff ff       	call   878 <findNextRunnableThread>
 c48:	a3 60 14 00 00       	mov    %eax,0x1460
	threadTable.runningThread->state = T_RUNNING;
 c4d:	a1 60 14 00 00       	mov    0x1460,%eax
 c52:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 c59:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c60:	e8 9c f6 ff ff       	call   301 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 c65:	a1 60 14 00 00       	mov    0x1460,%eax
 c6a:	8b 40 08             	mov    0x8(%eax),%eax
 c6d:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 c6f:	a1 60 14 00 00       	mov    0x1460,%eax
 c74:	8b 40 04             	mov    0x4(%eax),%eax
 c77:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 c79:	a1 60 14 00 00       	mov    0x1460,%eax
 c7e:	8b 40 2c             	mov    0x2c(%eax),%eax
 c81:	85 c0                	test   %eax,%eax
 c83:	74 14                	je     c99 <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 c85:	a1 60 14 00 00       	mov    0x1460,%eax
 c8a:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 c91:	b8 a9 0b 00 00       	mov    $0xba9,%eax
 c96:	ff d0                	call   *%eax
		asm("ret");
 c98:	c3                   	ret    
	}
	return;	
 c99:	90                   	nop
}
 c9a:	c9                   	leave  
 c9b:	c3                   	ret    

00000c9c <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 c9c:	55                   	push   %ebp
 c9d:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 c9f:	8b 45 08             	mov    0x8(%ebp),%eax
 ca2:	8b 04 85 60 13 00 00 	mov    0x1360(,%eax,4),%eax
 ca9:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 cb0:	5d                   	pop    %ebp
 cb1:	c3                   	ret    

00000cb2 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 cb2:	55                   	push   %ebp
 cb3:	89 e5                	mov    %esp,%ebp
 cb5:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 cb8:	c7 44 24 04 b5 0e 00 	movl   $0xeb5,0x4(%esp)
 cbf:	00 
 cc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cc7:	e8 ad f7 ff ff       	call   479 <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 ccc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 cd3:	eb 26                	jmp    cfb <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 cd5:	8b 45 08             	mov    0x8(%ebp),%eax
 cd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cdb:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 cdf:	89 44 24 08          	mov    %eax,0x8(%esp)
 ce3:	c7 44 24 04 cc 0e 00 	movl   $0xecc,0x4(%esp)
 cea:	00 
 ceb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cf2:	e8 82 f7 ff ff       	call   479 <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 cf7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 cfb:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 cff:	7e d4                	jle    cd5 <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 d01:	c7 44 24 04 d0 0e 00 	movl   $0xed0,0x4(%esp)
 d08:	00 
 d09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d10:	e8 64 f7 ff ff       	call   479 <printf>
}
 d15:	c9                   	leave  
 d16:	c3                   	ret    

00000d17 <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 d17:	55                   	push   %ebp
 d18:	89 e5                	mov    %esp,%ebp
 d1a:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 d1d:	8b 45 08             	mov    0x8(%ebp),%eax
 d20:	8b 55 0c             	mov    0xc(%ebp),%edx
 d23:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 d25:	8b 45 08             	mov    0x8(%ebp),%eax
 d28:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 d2f:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 d39:	eb 12                	jmp    d4d <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 d3b:	8b 45 08             	mov    0x8(%ebp),%eax
 d3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 d41:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 d48:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d49:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 d4d:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 d51:	7e e8                	jle    d3b <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 d53:	c9                   	leave  
 d54:	c3                   	ret    

00000d55 <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 d55:	55                   	push   %ebp
 d56:	89 e5                	mov    %esp,%ebp
 d58:	53                   	push   %ebx
 d59:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 d5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 d63:	e8 99 f5 ff ff       	call   301 <alarm>
	if (semaphore->value ==0){
 d68:	8b 45 08             	mov    0x8(%ebp),%eax
 d6b:	8b 00                	mov    (%eax),%eax
 d6d:	85 c0                	test   %eax,%eax
 d6f:	75 34                	jne    da5 <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 d71:	a1 60 14 00 00       	mov    0x1460,%eax
 d76:	8b 08                	mov    (%eax),%ecx
 d78:	8b 45 08             	mov    0x8(%ebp),%eax
 d7b:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 d81:	8d 58 01             	lea    0x1(%eax),%ebx
 d84:	8b 55 08             	mov    0x8(%ebp),%edx
 d87:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 d8d:	8b 55 08             	mov    0x8(%ebp),%edx
 d90:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 d94:	a1 60 14 00 00       	mov    0x1460,%eax
 d99:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 da0:	e8 78 fd ff ff       	call   b1d <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 da5:	a1 60 14 00 00       	mov    0x1460,%eax
 daa:	8b 10                	mov    (%eax),%edx
 dac:	8b 45 08             	mov    0x8(%ebp),%eax
 daf:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 db6:	ff 
	semaphore->value = 0;
 db7:	8b 45 08             	mov    0x8(%ebp),%eax
 dba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 dc0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 dc7:	e8 35 f5 ff ff       	call   301 <alarm>
}
 dcc:	83 c4 14             	add    $0x14,%esp
 dcf:	5b                   	pop    %ebx
 dd0:	5d                   	pop    %ebp
 dd1:	c3                   	ret    

00000dd2 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 dd2:	55                   	push   %ebp
 dd3:	89 e5                	mov    %esp,%ebp
 dd5:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 dd8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 ddf:	e8 1d f5 ff ff       	call   301 <alarm>
	
	if (semaphore->value == 0){
 de4:	8b 45 08             	mov    0x8(%ebp),%eax
 de7:	8b 00                	mov    (%eax),%eax
 de9:	85 c0                	test   %eax,%eax
 deb:	75 71                	jne    e5e <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 ded:	8b 45 08             	mov    0x8(%ebp),%eax
 df0:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 df9:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 e00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 e07:	eb 35                	jmp    e3e <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 e09:	8b 45 08             	mov    0x8(%ebp),%eax
 e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e0f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e13:	83 f8 ff             	cmp    $0xffffffff,%eax
 e16:	74 22                	je     e3a <binary_semaphore_up+0x68>
 e18:	8b 45 08             	mov    0x8(%ebp),%eax
 e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e1e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e22:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 e25:	7d 13                	jge    e3a <binary_semaphore_up+0x68>
				minIndex = i;
 e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 e2d:	8b 45 08             	mov    0x8(%ebp),%eax
 e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e33:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 e3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 e3e:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 e42:	7e c5                	jle    e09 <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 e44:	8b 45 08             	mov    0x8(%ebp),%eax
 e47:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 e4d:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 e51:	74 0b                	je     e5e <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e56:	89 04 24             	mov    %eax,(%esp)
 e59:	e8 3e fe ff ff       	call   c9c <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 e5e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e65:	e8 97 f4 ff ff       	call   301 <alarm>
	
 e6a:	c9                   	leave  
 e6b:	c3                   	ret    
