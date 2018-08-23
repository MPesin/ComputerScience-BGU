
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 5a 0e 00 	movl   $0xe5a,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 44 04 00 00       	call   467 <printf>
    exit();
  23:	e8 a7 02 00 00       	call   2cf <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f1 01 00 00       	call   23d <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 c3 02 00 00       	call   317 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 68 02 00 00       	call   2cf <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  92:	8b 45 08             	mov    0x8(%ebp),%eax
  95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  98:	90                   	nop
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	8d 50 01             	lea    0x1(%eax),%edx
  9f:	89 55 08             	mov    %edx,0x8(%ebp)
  a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ab:	0f b6 12             	movzbl (%edx),%edx
  ae:	88 10                	mov    %dl,(%eax)
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	84 c0                	test   %al,%al
  b5:	75 e2                	jne    99 <strcpy+0xd>
    ;
  return os;
  b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bf:	eb 08                	jmp    c9 <strcmp+0xd>
    p++, q++;
  c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 00             	movzbl (%eax),%eax
  cf:	84 c0                	test   %al,%al
  d1:	74 10                	je     e3 <strcmp+0x27>
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	38 c2                	cmp    %al,%dl
  e1:	74 de                	je     c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	0f b6 d0             	movzbl %al,%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 c0             	movzbl %al,%eax
  f5:	29 c2                	sub    %eax,%edx
  f7:	89 d0                	mov    %edx,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 108:	eb 04                	jmp    10e <strlen+0x13>
 10a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	01 d0                	add    %edx,%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 ed                	jne    10a <strlen+0xf>
    ;
  return n;
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 128:	8b 45 10             	mov    0x10(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	89 04 24             	mov    %eax,(%esp)
 13c:	e8 26 ff ff ff       	call   67 <stosb>
  return dst;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 152:	eb 14                	jmp    168 <strchr+0x22>
    if(*s == c)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15d:	75 05                	jne    164 <strchr+0x1e>
      return (char*)s;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	eb 13                	jmp    177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 172:	b8 00 00 00 00       	mov    $0x0,%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <gets>:

char*
gets(char *buf, int max)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 186:	eb 4c                	jmp    1d4 <gets+0x5b>
    cc = read(0, &c, 1);
 188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18f:	00 
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	89 44 24 04          	mov    %eax,0x4(%esp)
 197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19e:	e8 5c 01 00 00       	call   2ff <read>
 1a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1aa:	7f 02                	jg     1ae <gets+0x35>
      break;
 1ac:	eb 31                	jmp    1df <gets+0x66>
    buf[i++] = c;
 1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b1:	8d 50 01             	lea    0x1(%eax),%edx
 1b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b7:	89 c2                	mov    %eax,%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 c2                	add    %eax,%edx
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0a                	cmp    $0xa,%al
 1ca:	74 13                	je     1df <gets+0x66>
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	3c 0d                	cmp    $0xd,%al
 1d2:	74 0b                	je     1df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d7:	83 c0 01             	add    $0x1,%eax
 1da:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dd:	7c a9                	jl     188 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1df:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	01 d0                	add    %edx,%eax
 1e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <stat>:

int
stat(char *n, struct stat *st)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fc:	00 
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	89 04 24             	mov    %eax,(%esp)
 203:	e8 1f 01 00 00       	call   327 <open>
 208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20f:	79 07                	jns    218 <stat+0x29>
    return -1;
 211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 216:	eb 23                	jmp    23b <stat+0x4c>
  r = fstat(fd, st);
 218:	8b 45 0c             	mov    0xc(%ebp),%eax
 21b:	89 44 24 04          	mov    %eax,0x4(%esp)
 21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 15 01 00 00       	call   33f <fstat>
 22a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	89 04 24             	mov    %eax,(%esp)
 233:	e8 d7 00 00 00       	call   30f <close>
  return r;
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <atoi>:

int
atoi(const char *s)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24a:	eb 25                	jmp    271 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24f:	89 d0                	mov    %edx,%eax
 251:	c1 e0 02             	shl    $0x2,%eax
 254:	01 d0                	add    %edx,%eax
 256:	01 c0                	add    %eax,%eax
 258:	89 c1                	mov    %eax,%ecx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 08             	mov    %edx,0x8(%ebp)
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f be c0             	movsbl %al,%eax
 269:	01 c8                	add    %ecx,%eax
 26b:	83 e8 30             	sub    $0x30,%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 2f                	cmp    $0x2f,%al
 279:	7e 0a                	jle    285 <atoi+0x48>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	0f b6 00             	movzbl (%eax),%eax
 281:	3c 39                	cmp    $0x39,%al
 283:	7e c7                	jle    24c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 296:	8b 45 0c             	mov    0xc(%ebp),%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29c:	eb 17                	jmp    2b5 <memmove+0x2b>
    *dst++ = *src++;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a1:	8d 50 01             	lea    0x1(%eax),%edx
 2a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b0:	0f b6 12             	movzbl (%edx),%edx
 2b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bb:	89 55 10             	mov    %edx,0x10(%ebp)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7f dc                	jg     29e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c7:	b8 01 00 00 00       	mov    $0x1,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <exit>:
SYSCALL(exit)
 2cf:	b8 02 00 00 00       	mov    $0x2,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <wait>:
SYSCALL(wait)
 2d7:	b8 03 00 00 00       	mov    $0x3,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <signal>:
SYSCALL(signal)
 2df:	b8 18 00 00 00       	mov    $0x18,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <sigsend>:
SYSCALL(sigsend)
 2e7:	b8 19 00 00 00       	mov    $0x19,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <alarm>:
SYSCALL(alarm)
 2ef:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <pipe>:
SYSCALL(pipe)
 2f7:	b8 04 00 00 00       	mov    $0x4,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <read>:
SYSCALL(read)
 2ff:	b8 05 00 00 00       	mov    $0x5,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <write>:
SYSCALL(write)
 307:	b8 10 00 00 00       	mov    $0x10,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <close>:
SYSCALL(close)
 30f:	b8 15 00 00 00       	mov    $0x15,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <kill>:
SYSCALL(kill)
 317:	b8 06 00 00 00       	mov    $0x6,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <exec>:
SYSCALL(exec)
 31f:	b8 07 00 00 00       	mov    $0x7,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <open>:
SYSCALL(open)
 327:	b8 0f 00 00 00       	mov    $0xf,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mknod>:
SYSCALL(mknod)
 32f:	b8 11 00 00 00       	mov    $0x11,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <unlink>:
SYSCALL(unlink)
 337:	b8 12 00 00 00       	mov    $0x12,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <fstat>:
SYSCALL(fstat)
 33f:	b8 08 00 00 00       	mov    $0x8,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <link>:
SYSCALL(link)
 347:	b8 13 00 00 00       	mov    $0x13,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <mkdir>:
SYSCALL(mkdir)
 34f:	b8 14 00 00 00       	mov    $0x14,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <chdir>:
SYSCALL(chdir)
 357:	b8 09 00 00 00       	mov    $0x9,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <dup>:
SYSCALL(dup)
 35f:	b8 0a 00 00 00       	mov    $0xa,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <getpid>:
SYSCALL(getpid)
 367:	b8 0b 00 00 00       	mov    $0xb,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <sbrk>:
SYSCALL(sbrk)
 36f:	b8 0c 00 00 00       	mov    $0xc,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <sleep>:
SYSCALL(sleep)
 377:	b8 0d 00 00 00       	mov    $0xd,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <uptime>:
SYSCALL(uptime)
 37f:	b8 0e 00 00 00       	mov    $0xe,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp
 38a:	83 ec 18             	sub    $0x18,%esp
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 393:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39a:	00 
 39b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39e:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	89 04 24             	mov    %eax,(%esp)
 3a8:	e8 5a ff ff ff       	call   307 <write>
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	56                   	push   %esi
 3b3:	53                   	push   %ebx
 3b4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c2:	74 17                	je     3db <printint+0x2c>
 3c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c8:	79 11                	jns    3db <printint+0x2c>
    neg = 1;
 3ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	f7 d8                	neg    %eax
 3d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d9:	eb 06                	jmp    3e1 <printint+0x32>
  } else {
    x = xx;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3eb:	8d 41 01             	lea    0x1(%ecx),%eax
 3ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f7:	ba 00 00 00 00       	mov    $0x0,%edx
 3fc:	f7 f3                	div    %ebx
 3fe:	89 d0                	mov    %edx,%eax
 400:	0f b6 80 f0 12 00 00 	movzbl 0x12f0(%eax),%eax
 407:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 40b:	8b 75 10             	mov    0x10(%ebp),%esi
 40e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 411:	ba 00 00 00 00       	mov    $0x0,%edx
 416:	f7 f6                	div    %esi
 418:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41f:	75 c7                	jne    3e8 <printint+0x39>
  if(neg)
 421:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 425:	74 10                	je     437 <printint+0x88>
    buf[i++] = '-';
 427:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42a:	8d 50 01             	lea    0x1(%eax),%edx
 42d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 430:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 435:	eb 1f                	jmp    456 <printint+0xa7>
 437:	eb 1d                	jmp    456 <printint+0xa7>
    putc(fd, buf[i]);
 439:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43f:	01 d0                	add    %edx,%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	0f be c0             	movsbl %al,%eax
 447:	89 44 24 04          	mov    %eax,0x4(%esp)
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	89 04 24             	mov    %eax,(%esp)
 451:	e8 31 ff ff ff       	call   387 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 456:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 45a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45e:	79 d9                	jns    439 <printint+0x8a>
    putc(fd, buf[i]);
}
 460:	83 c4 30             	add    $0x30,%esp
 463:	5b                   	pop    %ebx
 464:	5e                   	pop    %esi
 465:	5d                   	pop    %ebp
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
 484:	e9 7c 01 00 00       	jmp    605 <printf+0x19e>
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
 4b2:	e9 4a 01 00 00       	jmp    601 <printf+0x19a>
      } else {
        putc(fd, c);
 4b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	89 04 24             	mov    %eax,(%esp)
 4c7:	e8 bb fe ff ff       	call   387 <putc>
 4cc:	e9 30 01 00 00       	jmp    601 <printf+0x19a>
      }
    } else if(state == '%'){
 4d1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d5:	0f 85 26 01 00 00    	jne    601 <printf+0x19a>
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
 500:	e8 aa fe ff ff       	call   3af <printint>
        ap++;
 505:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 509:	e9 ec 00 00 00       	jmp    5fa <printf+0x193>
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
 539:	e8 71 fe ff ff       	call   3af <printint>
        ap++;
 53e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 542:	e9 b3 00 00 00       	jmp    5fa <printf+0x193>
      } else if(c == 's'){
 547:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54b:	75 45                	jne    592 <printf+0x12b>
        s = (char*)*ap;
 54d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 550:	8b 00                	mov    (%eax),%eax
 552:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55d:	75 09                	jne    568 <printf+0x101>
          s = "(null)";
 55f:	c7 45 f4 6e 0e 00 00 	movl   $0xe6e,-0xc(%ebp)
        while(*s != 0){
 566:	eb 1e                	jmp    586 <printf+0x11f>
 568:	eb 1c                	jmp    586 <printf+0x11f>
          putc(fd, *s);
 56a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56d:	0f b6 00             	movzbl (%eax),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	89 44 24 04          	mov    %eax,0x4(%esp)
 577:	8b 45 08             	mov    0x8(%ebp),%eax
 57a:	89 04 24             	mov    %eax,(%esp)
 57d:	e8 05 fe ff ff       	call   387 <putc>
          s++;
 582:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 586:	8b 45 f4             	mov    -0xc(%ebp),%eax
 589:	0f b6 00             	movzbl (%eax),%eax
 58c:	84 c0                	test   %al,%al
 58e:	75 da                	jne    56a <printf+0x103>
 590:	eb 68                	jmp    5fa <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 592:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 596:	75 1d                	jne    5b5 <printf+0x14e>
        putc(fd, *ap);
 598:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59b:	8b 00                	mov    (%eax),%eax
 59d:	0f be c0             	movsbl %al,%eax
 5a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	89 04 24             	mov    %eax,(%esp)
 5aa:	e8 d8 fd ff ff       	call   387 <putc>
        ap++;
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b3:	eb 45                	jmp    5fa <printf+0x193>
      } else if(c == '%'){
 5b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b9:	75 17                	jne    5d2 <printf+0x16b>
        putc(fd, c);
 5bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 b7 fd ff ff       	call   387 <putc>
 5d0:	eb 28                	jmp    5fa <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d9:	00 
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 a2 fd ff ff       	call   387 <putc>
        putc(fd, c);
 5e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e8:	0f be c0             	movsbl %al,%eax
 5eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	89 04 24             	mov    %eax,(%esp)
 5f5:	e8 8d fd ff ff       	call   387 <putc>
      }
      state = 0;
 5fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 601:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 605:	8b 55 0c             	mov    0xc(%ebp),%edx
 608:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60b:	01 d0                	add    %edx,%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	84 c0                	test   %al,%al
 612:	0f 85 71 fe ff ff    	jne    489 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 618:	c9                   	leave  
 619:	c3                   	ret    

0000061a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61a:	55                   	push   %ebp
 61b:	89 e5                	mov    %esp,%ebp
 61d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	83 e8 08             	sub    $0x8,%eax
 626:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 629:	a1 28 13 00 00       	mov    0x1328,%eax
 62e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 631:	eb 24                	jmp    657 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63b:	77 12                	ja     64f <free+0x35>
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 643:	77 24                	ja     669 <free+0x4f>
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64d:	77 1a                	ja     669 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	89 45 fc             	mov    %eax,-0x4(%ebp)
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65d:	76 d4                	jbe    633 <free+0x19>
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 667:	76 ca                	jbe    633 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	8b 40 04             	mov    0x4(%eax),%eax
 66f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	01 c2                	add    %eax,%edx
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	39 c2                	cmp    %eax,%edx
 682:	75 24                	jne    6a8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	8b 50 04             	mov    0x4(%eax),%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	01 c2                	add    %eax,%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	8b 10                	mov    (%eax),%edx
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	89 10                	mov    %edx,(%eax)
 6a6:	eb 0a                	jmp    6b2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 10                	mov    (%eax),%edx
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 40 04             	mov    0x4(%eax),%eax
 6b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	01 d0                	add    %edx,%eax
 6c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c7:	75 20                	jne    6e9 <free+0xcf>
    p->s.size += bp->s.size;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 50 04             	mov    0x4(%eax),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	8b 10                	mov    (%eax),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	89 10                	mov    %edx,(%eax)
 6e7:	eb 08                	jmp    6f1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	a3 28 13 00 00       	mov    %eax,0x1328
}
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <morecore>:

static Header*
morecore(uint nu)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 701:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 708:	77 07                	ja     711 <morecore+0x16>
    nu = 4096;
 70a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 711:	8b 45 08             	mov    0x8(%ebp),%eax
 714:	c1 e0 03             	shl    $0x3,%eax
 717:	89 04 24             	mov    %eax,(%esp)
 71a:	e8 50 fc ff ff       	call   36f <sbrk>
 71f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 722:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 726:	75 07                	jne    72f <morecore+0x34>
    return 0;
 728:	b8 00 00 00 00       	mov    $0x0,%eax
 72d:	eb 22                	jmp    751 <morecore+0x56>
  hp = (Header*)p;
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 735:	8b 45 f0             	mov    -0x10(%ebp),%eax
 738:	8b 55 08             	mov    0x8(%ebp),%edx
 73b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 741:	83 c0 08             	add    $0x8,%eax
 744:	89 04 24             	mov    %eax,(%esp)
 747:	e8 ce fe ff ff       	call   61a <free>
  return freep;
 74c:	a1 28 13 00 00       	mov    0x1328,%eax
}
 751:	c9                   	leave  
 752:	c3                   	ret    

00000753 <malloc>:

void*
malloc(uint nbytes)
{
 753:	55                   	push   %ebp
 754:	89 e5                	mov    %esp,%ebp
 756:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 759:	8b 45 08             	mov    0x8(%ebp),%eax
 75c:	83 c0 07             	add    $0x7,%eax
 75f:	c1 e8 03             	shr    $0x3,%eax
 762:	83 c0 01             	add    $0x1,%eax
 765:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 768:	a1 28 13 00 00       	mov    0x1328,%eax
 76d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 770:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 774:	75 23                	jne    799 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 776:	c7 45 f0 20 13 00 00 	movl   $0x1320,-0x10(%ebp)
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	a3 28 13 00 00       	mov    %eax,0x1328
 785:	a1 28 13 00 00       	mov    0x1328,%eax
 78a:	a3 20 13 00 00       	mov    %eax,0x1320
    base.s.size = 0;
 78f:	c7 05 24 13 00 00 00 	movl   $0x0,0x1324
 796:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7aa:	72 4d                	jb     7f9 <malloc+0xa6>
      if(p->s.size == nunits)
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b5:	75 0c                	jne    7c3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	89 10                	mov    %edx,(%eax)
 7c1:	eb 26                	jmp    7e9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7cc:	89 c2                	mov    %eax,%edx
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	c1 e0 03             	shl    $0x3,%eax
 7dd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	a3 28 13 00 00       	mov    %eax,0x1328
      return (void*)(p + 1);
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	83 c0 08             	add    $0x8,%eax
 7f7:	eb 38                	jmp    831 <malloc+0xde>
    }
    if(p == freep)
 7f9:	a1 28 13 00 00       	mov    0x1328,%eax
 7fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 801:	75 1b                	jne    81e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 803:	8b 45 ec             	mov    -0x14(%ebp),%eax
 806:	89 04 24             	mov    %eax,(%esp)
 809:	e8 ed fe ff ff       	call   6fb <morecore>
 80e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 815:	75 07                	jne    81e <malloc+0xcb>
        return 0;
 817:	b8 00 00 00 00       	mov    $0x0,%eax
 81c:	eb 13                	jmp    831 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	8b 00                	mov    (%eax),%eax
 829:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82c:	e9 70 ff ff ff       	jmp    7a1 <malloc+0x4e>
}
 831:	c9                   	leave  
 832:	c3                   	ret    

00000833 <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 833:	55                   	push   %ebp
 834:	89 e5                	mov    %esp,%ebp
 836:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 839:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 840:	eb 17                	jmp    859 <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 842:	8b 45 fc             	mov    -0x4(%ebp),%eax
 845:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 84c:	85 c0                	test   %eax,%eax
 84e:	75 05                	jne    855 <findNextFreeThreadId+0x22>
			return i;
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	eb 0f                	jmp    864 <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 855:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 859:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 85d:	7e e3                	jle    842 <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 85f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 864:	c9                   	leave  
 865:	c3                   	ret    

00000866 <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 866:	55                   	push   %ebp
 867:	89 e5                	mov    %esp,%ebp
 869:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 86c:	a1 40 14 00 00       	mov    0x1440,%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	8d 50 01             	lea    0x1(%eax),%edx
 876:	89 d0                	mov    %edx,%eax
 878:	c1 f8 1f             	sar    $0x1f,%eax
 87b:	c1 e8 1a             	shr    $0x1a,%eax
 87e:	01 c2                	add    %eax,%edx
 880:	83 e2 3f             	and    $0x3f,%edx
 883:	29 c2                	sub    %eax,%edx
 885:	89 d0                	mov    %edx,%eax
 887:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 894:	8b 40 28             	mov    0x28(%eax),%eax
 897:	83 f8 02             	cmp    $0x2,%eax
 89a:	75 0c                	jne    8a8 <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 89c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89f:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 8a6:	eb 1c                	jmp    8c4 <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 8a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ab:	8d 50 01             	lea    0x1(%eax),%edx
 8ae:	89 d0                	mov    %edx,%eax
 8b0:	c1 f8 1f             	sar    $0x1f,%eax
 8b3:	c1 e8 1a             	shr    $0x1a,%eax
 8b6:	01 c2                	add    %eax,%edx
 8b8:	83 e2 3f             	and    $0x3f,%edx
 8bb:	29 c2                	sub    %eax,%edx
 8bd:	89 d0                	mov    %edx,%eax
 8bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 8c2:	eb c6                	jmp    88a <findNextRunnableThread+0x24>
}
 8c4:	c9                   	leave  
 8c5:	c3                   	ret    

000008c6 <uthread_init>:

void uthread_init(void)
{
 8c6:	55                   	push   %ebp
 8c7:	89 e5                	mov    %esp,%ebp
 8c9:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 8cc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 8d3:	eb 12                	jmp    8e7 <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	c7 04 85 40 13 00 00 	movl   $0x0,0x1340(,%eax,4)
 8df:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 8e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8e7:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 8eb:	7e e8                	jle    8d5 <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 8ed:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 8f4:	e8 5a fe ff ff       	call   753 <malloc>
 8f9:	a3 40 13 00 00       	mov    %eax,0x1340
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 8fe:	a1 40 13 00 00       	mov    0x1340,%eax
 903:	89 e2                	mov    %esp,%edx
 905:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 908:	a1 40 13 00 00       	mov    0x1340,%eax
 90d:	89 ea                	mov    %ebp,%edx
 90f:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 912:	a1 40 13 00 00       	mov    0x1340,%eax
 917:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 91e:	a1 40 13 00 00       	mov    0x1340,%eax
 923:	a3 40 14 00 00       	mov    %eax,0x1440
	threadTable.threadCount = 1;
 928:	c7 05 44 14 00 00 01 	movl   $0x1,0x1444
 92f:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 932:	c7 44 24 04 0b 0b 00 	movl   $0xb0b,0x4(%esp)
 939:	00 
 93a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 941:	e8 99 f9 ff ff       	call   2df <signal>
	alarm(UTHREAD_QUANTA);
 946:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 94d:	e8 9d f9 ff ff       	call   2ef <alarm>
}
 952:	c9                   	leave  
 953:	c3                   	ret    

00000954 <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 954:	55                   	push   %ebp
 955:	89 e5                	mov    %esp,%ebp
 957:	53                   	push   %ebx
 958:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 95b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 962:	e8 88 f9 ff ff       	call   2ef <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 967:	e8 c7 fe ff ff       	call   833 <findNextFreeThreadId>
 96c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 96f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 973:	75 0a                	jne    97f <uthread_create+0x2b>
		return -1;
 975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 97a:	e9 d6 00 00 00       	jmp    a55 <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 97f:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 986:	e8 c8 fd ff ff       	call   753 <malloc>
 98b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 98e:	89 04 95 40 13 00 00 	mov    %eax,0x1340(,%edx,4)
	threadTable.threads[current]->tid = current;
 995:	8b 45 f4             	mov    -0xc(%ebp),%eax
 998:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 99f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9a2:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a7:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 9ae:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 9b5:	a1 44 14 00 00       	mov    0x1444,%eax
 9ba:	83 c0 01             	add    $0x1,%eax
 9bd:	a3 44 14 00 00       	mov    %eax,0x1444
	threadTable.threads[current]->entry = func;
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 9cc:	8b 55 08             	mov    0x8(%ebp),%edx
 9cf:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d5:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 9dc:	8b 55 0c             	mov    0xc(%ebp),%edx
 9df:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	8b 1c 85 40 13 00 00 	mov    0x1340(,%eax,4),%ebx
 9ec:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 9f3:	e8 5b fd ff ff       	call   753 <malloc>
 9f8:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a08:	8b 14 95 40 13 00 00 	mov    0x1340(,%edx,4),%edx
 a0f:	8b 52 24             	mov    0x24(%edx),%edx
 a12:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 a18:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1e:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a28:	8b 14 95 40 13 00 00 	mov    0x1340(,%edx,4),%edx
 a2f:	8b 52 04             	mov    0x4(%edx),%edx
 a32:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 a3f:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 a46:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a4d:	e8 9d f8 ff ff       	call   2ef <alarm>
	return current;
 a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 a55:	83 c4 24             	add    $0x24,%esp
 a58:	5b                   	pop    %ebx
 a59:	5d                   	pop    %ebp
 a5a:	c3                   	ret    

00000a5b <uthread_exit>:

void uthread_exit(void)
{
 a5b:	55                   	push   %ebp
 a5c:	89 e5                	mov    %esp,%ebp
 a5e:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 a61:	a1 40 14 00 00       	mov    0x1440,%eax
 a66:	8b 00                	mov    (%eax),%eax
 a68:	85 c0                	test   %eax,%eax
 a6a:	74 10                	je     a7c <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 a6c:	a1 40 14 00 00       	mov    0x1440,%eax
 a71:	8b 40 24             	mov    0x24(%eax),%eax
 a74:	89 04 24             	mov    %eax,(%esp)
 a77:	e8 9e fb ff ff       	call   61a <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 a7c:	a1 40 14 00 00       	mov    0x1440,%eax
 a81:	8b 00                	mov    (%eax),%eax
 a83:	c7 04 85 40 13 00 00 	movl   $0x0,0x1340(,%eax,4)
 a8a:	00 00 00 00 
	
	free(threadTable.runningThread);
 a8e:	a1 40 14 00 00       	mov    0x1440,%eax
 a93:	89 04 24             	mov    %eax,(%esp)
 a96:	e8 7f fb ff ff       	call   61a <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 a9b:	a1 44 14 00 00       	mov    0x1444,%eax
 aa0:	83 e8 01             	sub    $0x1,%eax
 aa3:	a3 44 14 00 00       	mov    %eax,0x1444
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 aa8:	a1 44 14 00 00       	mov    0x1444,%eax
 aad:	85 c0                	test   %eax,%eax
 aaf:	75 05                	jne    ab6 <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 ab1:	e8 19 f8 ff ff       	call   2cf <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 ab6:	e8 ab fd ff ff       	call   866 <findNextRunnableThread>
 abb:	a3 40 14 00 00       	mov    %eax,0x1440
	
	threadTable.runningThread->state = T_RUNNING;
 ac0:	a1 40 14 00 00       	mov    0x1440,%eax
 ac5:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 acc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ad3:	e8 17 f8 ff ff       	call   2ef <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 ad8:	a1 40 14 00 00       	mov    0x1440,%eax
 add:	8b 40 04             	mov    0x4(%eax),%eax
 ae0:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 ae2:	a1 40 14 00 00       	mov    0x1440,%eax
 ae7:	8b 40 08             	mov    0x8(%eax),%eax
 aea:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 aec:	a1 40 14 00 00       	mov    0x1440,%eax
 af1:	8b 40 2c             	mov    0x2c(%eax),%eax
 af4:	85 c0                	test   %eax,%eax
 af6:	74 11                	je     b09 <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 af8:	a1 40 14 00 00       	mov    0x1440,%eax
 afd:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 b04:	e8 8e 00 00 00       	call   b97 <wrapper>
	}
	

}
 b09:	c9                   	leave  
 b0a:	c3                   	ret    

00000b0b <uthread_yield>:

void uthread_yield(void)
{
 b0b:	55                   	push   %ebp
 b0c:	89 e5                	mov    %esp,%ebp
 b0e:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 b11:	a1 40 14 00 00       	mov    0x1440,%eax
 b16:	89 e2                	mov    %esp,%edx
 b18:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 b1b:	a1 40 14 00 00       	mov    0x1440,%eax
 b20:	89 ea                	mov    %ebp,%edx
 b22:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 b25:	a1 40 14 00 00       	mov    0x1440,%eax
 b2a:	8b 40 28             	mov    0x28(%eax),%eax
 b2d:	83 f8 01             	cmp    $0x1,%eax
 b30:	75 0c                	jne    b3e <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 b32:	a1 40 14 00 00       	mov    0x1440,%eax
 b37:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 b3e:	e8 23 fd ff ff       	call   866 <findNextRunnableThread>
 b43:	a3 40 14 00 00       	mov    %eax,0x1440
	threadTable.runningThread->state = T_RUNNING;
 b48:	a1 40 14 00 00       	mov    0x1440,%eax
 b4d:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 b54:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b5b:	e8 8f f7 ff ff       	call   2ef <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b60:	a1 40 14 00 00       	mov    0x1440,%eax
 b65:	8b 40 04             	mov    0x4(%eax),%eax
 b68:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b6a:	a1 40 14 00 00       	mov    0x1440,%eax
 b6f:	8b 40 08             	mov    0x8(%eax),%eax
 b72:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 b74:	a1 40 14 00 00       	mov    0x1440,%eax
 b79:	8b 40 2c             	mov    0x2c(%eax),%eax
 b7c:	85 c0                	test   %eax,%eax
 b7e:	74 14                	je     b94 <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 b80:	a1 40 14 00 00       	mov    0x1440,%eax
 b85:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 b8c:	b8 97 0b 00 00       	mov    $0xb97,%eax
 b91:	ff d0                	call   *%eax
		asm("ret");
 b93:	c3                   	ret    
	}
	return;
 b94:	90                   	nop
}
 b95:	c9                   	leave  
 b96:	c3                   	ret    

00000b97 <wrapper>:

void wrapper(void) {
 b97:	55                   	push   %ebp
 b98:	89 e5                	mov    %esp,%ebp
 b9a:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 b9d:	a1 40 14 00 00       	mov    0x1440,%eax
 ba2:	8b 40 30             	mov    0x30(%eax),%eax
 ba5:	8b 15 40 14 00 00    	mov    0x1440,%edx
 bab:	8b 52 34             	mov    0x34(%edx),%edx
 bae:	89 14 24             	mov    %edx,(%esp)
 bb1:	ff d0                	call   *%eax
	uthread_exit();
 bb3:	e8 a3 fe ff ff       	call   a5b <uthread_exit>
}
 bb8:	c9                   	leave  
 bb9:	c3                   	ret    

00000bba <uthread_self>:

int uthread_self(void)
{
 bba:	55                   	push   %ebp
 bbb:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 bbd:	a1 40 14 00 00       	mov    0x1440,%eax
 bc2:	8b 00                	mov    (%eax),%eax
}
 bc4:	5d                   	pop    %ebp
 bc5:	c3                   	ret    

00000bc6 <uthread_join>:

int uthread_join(int tid)
{
 bc6:	55                   	push   %ebp
 bc7:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 bc9:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 bcd:	7e 07                	jle    bd6 <uthread_join+0x10>
		return -1;
 bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 bd4:	eb 14                	jmp    bea <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 bd6:	90                   	nop
 bd7:	8b 45 08             	mov    0x8(%ebp),%eax
 bda:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 be1:	85 c0                	test   %eax,%eax
 be3:	75 f2                	jne    bd7 <uthread_join+0x11>
	return 0;
 be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 bea:	5d                   	pop    %ebp
 beb:	c3                   	ret    

00000bec <uthread_sleep>:

void uthread_sleep(void)
{
 bec:	55                   	push   %ebp
 bed:	89 e5                	mov    %esp,%ebp
 bef:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 bf2:	a1 40 14 00 00       	mov    0x1440,%eax
 bf7:	89 e2                	mov    %esp,%edx
 bf9:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 bfc:	a1 40 14 00 00       	mov    0x1440,%eax
 c01:	89 ea                	mov    %ebp,%edx
 c03:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 c06:	a1 40 14 00 00       	mov    0x1440,%eax
 c0b:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 c12:	a1 40 14 00 00       	mov    0x1440,%eax
 c17:	8b 00                	mov    (%eax),%eax
 c19:	89 44 24 08          	mov    %eax,0x8(%esp)
 c1d:	c7 44 24 04 75 0e 00 	movl   $0xe75,0x4(%esp)
 c24:	00 
 c25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c2c:	e8 36 f8 ff ff       	call   467 <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 c31:	e8 30 fc ff ff       	call   866 <findNextRunnableThread>
 c36:	a3 40 14 00 00       	mov    %eax,0x1440
	threadTable.runningThread->state = T_RUNNING;
 c3b:	a1 40 14 00 00       	mov    0x1440,%eax
 c40:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 c47:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c4e:	e8 9c f6 ff ff       	call   2ef <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 c53:	a1 40 14 00 00       	mov    0x1440,%eax
 c58:	8b 40 08             	mov    0x8(%eax),%eax
 c5b:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 c5d:	a1 40 14 00 00       	mov    0x1440,%eax
 c62:	8b 40 04             	mov    0x4(%eax),%eax
 c65:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 c67:	a1 40 14 00 00       	mov    0x1440,%eax
 c6c:	8b 40 2c             	mov    0x2c(%eax),%eax
 c6f:	85 c0                	test   %eax,%eax
 c71:	74 14                	je     c87 <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 c73:	a1 40 14 00 00       	mov    0x1440,%eax
 c78:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 c7f:	b8 97 0b 00 00       	mov    $0xb97,%eax
 c84:	ff d0                	call   *%eax
		asm("ret");
 c86:	c3                   	ret    
	}
	return;	
 c87:	90                   	nop
}
 c88:	c9                   	leave  
 c89:	c3                   	ret    

00000c8a <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 c8a:	55                   	push   %ebp
 c8b:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 c8d:	8b 45 08             	mov    0x8(%ebp),%eax
 c90:	8b 04 85 40 13 00 00 	mov    0x1340(,%eax,4),%eax
 c97:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 c9e:	5d                   	pop    %ebp
 c9f:	c3                   	ret    

00000ca0 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 ca0:	55                   	push   %ebp
 ca1:	89 e5                	mov    %esp,%ebp
 ca3:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 ca6:	c7 44 24 04 90 0e 00 	movl   $0xe90,0x4(%esp)
 cad:	00 
 cae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cb5:	e8 ad f7 ff ff       	call   467 <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 cba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 cc1:	eb 26                	jmp    ce9 <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 cc3:	8b 45 08             	mov    0x8(%ebp),%eax
 cc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cc9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 ccd:	89 44 24 08          	mov    %eax,0x8(%esp)
 cd1:	c7 44 24 04 a7 0e 00 	movl   $0xea7,0x4(%esp)
 cd8:	00 
 cd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ce0:	e8 82 f7 ff ff       	call   467 <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 ce5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 ce9:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 ced:	7e d4                	jle    cc3 <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 cef:	c7 44 24 04 ab 0e 00 	movl   $0xeab,0x4(%esp)
 cf6:	00 
 cf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cfe:	e8 64 f7 ff ff       	call   467 <printf>
}
 d03:	c9                   	leave  
 d04:	c3                   	ret    

00000d05 <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 d05:	55                   	push   %ebp
 d06:	89 e5                	mov    %esp,%ebp
 d08:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 d0b:	8b 45 08             	mov    0x8(%ebp),%eax
 d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
 d11:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 d13:	8b 45 08             	mov    0x8(%ebp),%eax
 d16:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 d1d:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 d27:	eb 12                	jmp    d3b <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 d29:	8b 45 08             	mov    0x8(%ebp),%eax
 d2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 d2f:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 d36:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d37:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 d3b:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 d3f:	7e e8                	jle    d29 <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 d41:	c9                   	leave  
 d42:	c3                   	ret    

00000d43 <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 d43:	55                   	push   %ebp
 d44:	89 e5                	mov    %esp,%ebp
 d46:	53                   	push   %ebx
 d47:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 d4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 d51:	e8 99 f5 ff ff       	call   2ef <alarm>
	if (semaphore->value ==0){
 d56:	8b 45 08             	mov    0x8(%ebp),%eax
 d59:	8b 00                	mov    (%eax),%eax
 d5b:	85 c0                	test   %eax,%eax
 d5d:	75 34                	jne    d93 <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 d5f:	a1 40 14 00 00       	mov    0x1440,%eax
 d64:	8b 08                	mov    (%eax),%ecx
 d66:	8b 45 08             	mov    0x8(%ebp),%eax
 d69:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 d6f:	8d 58 01             	lea    0x1(%eax),%ebx
 d72:	8b 55 08             	mov    0x8(%ebp),%edx
 d75:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 d7b:	8b 55 08             	mov    0x8(%ebp),%edx
 d7e:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 d82:	a1 40 14 00 00       	mov    0x1440,%eax
 d87:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 d8e:	e8 78 fd ff ff       	call   b0b <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 d93:	a1 40 14 00 00       	mov    0x1440,%eax
 d98:	8b 10                	mov    (%eax),%edx
 d9a:	8b 45 08             	mov    0x8(%ebp),%eax
 d9d:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 da4:	ff 
	semaphore->value = 0;
 da5:	8b 45 08             	mov    0x8(%ebp),%eax
 da8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 dae:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 db5:	e8 35 f5 ff ff       	call   2ef <alarm>
}
 dba:	83 c4 14             	add    $0x14,%esp
 dbd:	5b                   	pop    %ebx
 dbe:	5d                   	pop    %ebp
 dbf:	c3                   	ret    

00000dc0 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 dc0:	55                   	push   %ebp
 dc1:	89 e5                	mov    %esp,%ebp
 dc3:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 dc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 dcd:	e8 1d f5 ff ff       	call   2ef <alarm>
	
	if (semaphore->value == 0){
 dd2:	8b 45 08             	mov    0x8(%ebp),%eax
 dd5:	8b 00                	mov    (%eax),%eax
 dd7:	85 c0                	test   %eax,%eax
 dd9:	75 71                	jne    e4c <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 ddb:	8b 45 08             	mov    0x8(%ebp),%eax
 dde:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 de7:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 dee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 df5:	eb 35                	jmp    e2c <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 df7:	8b 45 08             	mov    0x8(%ebp),%eax
 dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
 dfd:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e01:	83 f8 ff             	cmp    $0xffffffff,%eax
 e04:	74 22                	je     e28 <binary_semaphore_up+0x68>
 e06:	8b 45 08             	mov    0x8(%ebp),%eax
 e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e0c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 e13:	7d 13                	jge    e28 <binary_semaphore_up+0x68>
				minIndex = i;
 e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e18:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 e1b:	8b 45 08             	mov    0x8(%ebp),%eax
 e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e21:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 e28:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 e2c:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 e30:	7e c5                	jle    df7 <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 e32:	8b 45 08             	mov    0x8(%ebp),%eax
 e35:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 e3b:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 e3f:	74 0b                	je     e4c <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e44:	89 04 24             	mov    %eax,(%esp)
 e47:	e8 3e fe ff ff       	call   c8a <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 e4c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e53:	e8 97 f4 ff ff       	call   2ef <alarm>
	
 e58:	c9                   	leave  
 e59:	c3                   	ret    
