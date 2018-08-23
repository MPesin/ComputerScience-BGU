
_echo:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 5f 0e 00 00       	mov    $0xe5f,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 61 0e 00 00       	mov    $0xe61,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 63 0e 00 	movl   $0xe63,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 13 04 00 00       	call   46c <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 68 02 00 00       	call   2d4 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	8d 50 01             	lea    0x1(%eax),%edx
  a4:	89 55 08             	mov    %edx,0x8(%ebp)
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b0:	0f b6 12             	movzbl (%edx),%edx
  b3:	88 10                	mov    %dl,(%eax)
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 08                	jmp    ce <strcmp+0xd>
    p++, q++;
  c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 10                	je     e8 <strcmp+0x27>
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	38 c2                	cmp    %al,%dl
  e6:	74 de                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	0f b6 d0             	movzbl %al,%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 c0             	movzbl %al,%eax
  fa:	29 c2                	sub    %eax,%edx
  fc:	89 d0                	mov    %edx,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10d:	eb 04                	jmp    113 <strlen+0x13>
 10f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 113:	8b 55 fc             	mov    -0x4(%ebp),%edx
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	01 d0                	add    %edx,%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	84 c0                	test   %al,%al
 120:	75 ed                	jne    10f <strlen+0xf>
    ;
  return n;
 122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <memset>:

void*
memset(void *dst, int c, uint n)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12d:	8b 45 10             	mov    0x10(%ebp),%eax
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 44 24 04          	mov    %eax,0x4(%esp)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 04 24             	mov    %eax,(%esp)
 141:	e8 26 ff ff ff       	call   6c <stosb>
  return dst;
 146:	8b 45 08             	mov    0x8(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <strchr>:

char*
strchr(const char *s, char c)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 157:	eb 14                	jmp    16d <strchr+0x22>
    if(*s == c)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 162:	75 05                	jne    169 <strchr+0x1e>
      return (char*)s;
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	eb 13                	jmp    17c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 e2                	jne    159 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 177:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <gets>:

char*
gets(char *buf, int max)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18b:	eb 4c                	jmp    1d9 <gets+0x5b>
    cc = read(0, &c, 1);
 18d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 194:	00 
 195:	8d 45 ef             	lea    -0x11(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a3:	e8 5c 01 00 00       	call   304 <read>
 1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1af:	7f 02                	jg     1b3 <gets+0x35>
      break;
 1b1:	eb 31                	jmp    1e4 <gets+0x66>
    buf[i++] = c;
 1b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b6:	8d 50 01             	lea    0x1(%eax),%edx
 1b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1bc:	89 c2                	mov    %eax,%edx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	01 c2                	add    %eax,%edx
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 13                	je     1e4 <gets+0x66>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0b                	je     1e4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c a9                	jl     18d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	01 d0                	add    %edx,%eax
 1ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <stat>:

int
stat(char *n, struct stat *st)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 201:	00 
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	89 04 24             	mov    %eax,(%esp)
 208:	e8 1f 01 00 00       	call   32c <open>
 20d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 214:	79 07                	jns    21d <stat+0x29>
    return -1;
 216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21b:	eb 23                	jmp    240 <stat+0x4c>
  r = fstat(fd, st);
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	89 44 24 04          	mov    %eax,0x4(%esp)
 224:	8b 45 f4             	mov    -0xc(%ebp),%eax
 227:	89 04 24             	mov    %eax,(%esp)
 22a:	e8 15 01 00 00       	call   344 <fstat>
 22f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 d7 00 00 00       	call   314 <close>
  return r;
 23d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <atoi>:

int
atoi(const char *s)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24f:	eb 25                	jmp    276 <atoi+0x34>
    n = n*10 + *s++ - '0';
 251:	8b 55 fc             	mov    -0x4(%ebp),%edx
 254:	89 d0                	mov    %edx,%eax
 256:	c1 e0 02             	shl    $0x2,%eax
 259:	01 d0                	add    %edx,%eax
 25b:	01 c0                	add    %eax,%eax
 25d:	89 c1                	mov    %eax,%ecx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 08             	mov    %edx,0x8(%ebp)
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	0f be c0             	movsbl %al,%eax
 26e:	01 c8                	add    %ecx,%eax
 270:	83 e8 30             	sub    $0x30,%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2f                	cmp    $0x2f,%al
 27e:	7e 0a                	jle    28a <atoi+0x48>
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	3c 39                	cmp    $0x39,%al
 288:	7e c7                	jle    251 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a1:	eb 17                	jmp    2ba <memmove+0x2b>
    *dst++ = *src++;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2af:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b5:	0f b6 12             	movzbl (%edx),%edx
 2b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ba:	8b 45 10             	mov    0x10(%ebp),%eax
 2bd:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c0:	89 55 10             	mov    %edx,0x10(%ebp)
 2c3:	85 c0                	test   %eax,%eax
 2c5:	7f dc                	jg     2a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cc:	b8 01 00 00 00       	mov    $0x1,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exit>:
SYSCALL(exit)
 2d4:	b8 02 00 00 00       	mov    $0x2,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <wait>:
SYSCALL(wait)
 2dc:	b8 03 00 00 00       	mov    $0x3,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <signal>:
SYSCALL(signal)
 2e4:	b8 18 00 00 00       	mov    $0x18,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <sigsend>:
SYSCALL(sigsend)
 2ec:	b8 19 00 00 00       	mov    $0x19,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <alarm>:
SYSCALL(alarm)
 2f4:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <pipe>:
SYSCALL(pipe)
 2fc:	b8 04 00 00 00       	mov    $0x4,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <read>:
SYSCALL(read)
 304:	b8 05 00 00 00       	mov    $0x5,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <write>:
SYSCALL(write)
 30c:	b8 10 00 00 00       	mov    $0x10,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <close>:
SYSCALL(close)
 314:	b8 15 00 00 00       	mov    $0x15,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <kill>:
SYSCALL(kill)
 31c:	b8 06 00 00 00       	mov    $0x6,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <exec>:
SYSCALL(exec)
 324:	b8 07 00 00 00       	mov    $0x7,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <open>:
SYSCALL(open)
 32c:	b8 0f 00 00 00       	mov    $0xf,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <mknod>:
SYSCALL(mknod)
 334:	b8 11 00 00 00       	mov    $0x11,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <unlink>:
SYSCALL(unlink)
 33c:	b8 12 00 00 00       	mov    $0x12,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <fstat>:
SYSCALL(fstat)
 344:	b8 08 00 00 00       	mov    $0x8,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <link>:
SYSCALL(link)
 34c:	b8 13 00 00 00       	mov    $0x13,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <mkdir>:
SYSCALL(mkdir)
 354:	b8 14 00 00 00       	mov    $0x14,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <chdir>:
SYSCALL(chdir)
 35c:	b8 09 00 00 00       	mov    $0x9,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <dup>:
SYSCALL(dup)
 364:	b8 0a 00 00 00       	mov    $0xa,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <getpid>:
SYSCALL(getpid)
 36c:	b8 0b 00 00 00       	mov    $0xb,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sbrk>:
SYSCALL(sbrk)
 374:	b8 0c 00 00 00       	mov    $0xc,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <sleep>:
SYSCALL(sleep)
 37c:	b8 0d 00 00 00       	mov    $0xd,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <uptime>:
SYSCALL(uptime)
 384:	b8 0e 00 00 00       	mov    $0xe,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	83 ec 18             	sub    $0x18,%esp
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 398:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39f:	00 
 3a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	89 04 24             	mov    %eax,(%esp)
 3ad:	e8 5a ff ff ff       	call   30c <write>
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	56                   	push   %esi
 3b8:	53                   	push   %ebx
 3b9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c7:	74 17                	je     3e0 <printint+0x2c>
 3c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3cd:	79 11                	jns    3e0 <printint+0x2c>
    neg = 1;
 3cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	f7 d8                	neg    %eax
 3db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3de:	eb 06                	jmp    3e6 <printint+0x32>
  } else {
    x = xx;
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f0:	8d 41 01             	lea    0x1(%ecx),%eax
 3f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fc:	ba 00 00 00 00       	mov    $0x0,%edx
 401:	f7 f3                	div    %ebx
 403:	89 d0                	mov    %edx,%eax
 405:	0f b6 80 ec 12 00 00 	movzbl 0x12ec(%eax),%eax
 40c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 410:	8b 75 10             	mov    0x10(%ebp),%esi
 413:	8b 45 ec             	mov    -0x14(%ebp),%eax
 416:	ba 00 00 00 00       	mov    $0x0,%edx
 41b:	f7 f6                	div    %esi
 41d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 420:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 424:	75 c7                	jne    3ed <printint+0x39>
  if(neg)
 426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42a:	74 10                	je     43c <printint+0x88>
    buf[i++] = '-';
 42c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42f:	8d 50 01             	lea    0x1(%eax),%edx
 432:	89 55 f4             	mov    %edx,-0xc(%ebp)
 435:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 43a:	eb 1f                	jmp    45b <printint+0xa7>
 43c:	eb 1d                	jmp    45b <printint+0xa7>
    putc(fd, buf[i]);
 43e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 441:	8b 45 f4             	mov    -0xc(%ebp),%eax
 444:	01 d0                	add    %edx,%eax
 446:	0f b6 00             	movzbl (%eax),%eax
 449:	0f be c0             	movsbl %al,%eax
 44c:	89 44 24 04          	mov    %eax,0x4(%esp)
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	89 04 24             	mov    %eax,(%esp)
 456:	e8 31 ff ff ff       	call   38c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 45f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 463:	79 d9                	jns    43e <printint+0x8a>
    putc(fd, buf[i]);
}
 465:	83 c4 30             	add    $0x30,%esp
 468:	5b                   	pop    %ebx
 469:	5e                   	pop    %esi
 46a:	5d                   	pop    %ebp
 46b:	c3                   	ret    

0000046c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 472:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 479:	8d 45 0c             	lea    0xc(%ebp),%eax
 47c:	83 c0 04             	add    $0x4,%eax
 47f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 482:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 489:	e9 7c 01 00 00       	jmp    60a <printf+0x19e>
    c = fmt[i] & 0xff;
 48e:	8b 55 0c             	mov    0xc(%ebp),%edx
 491:	8b 45 f0             	mov    -0x10(%ebp),%eax
 494:	01 d0                	add    %edx,%eax
 496:	0f b6 00             	movzbl (%eax),%eax
 499:	0f be c0             	movsbl %al,%eax
 49c:	25 ff 00 00 00       	and    $0xff,%eax
 4a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a8:	75 2c                	jne    4d6 <printf+0x6a>
      if(c == '%'){
 4aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ae:	75 0c                	jne    4bc <printf+0x50>
        state = '%';
 4b0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b7:	e9 4a 01 00 00       	jmp    606 <printf+0x19a>
      } else {
        putc(fd, c);
 4bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bf:	0f be c0             	movsbl %al,%eax
 4c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	89 04 24             	mov    %eax,(%esp)
 4cc:	e8 bb fe ff ff       	call   38c <putc>
 4d1:	e9 30 01 00 00       	jmp    606 <printf+0x19a>
      }
    } else if(state == '%'){
 4d6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4da:	0f 85 26 01 00 00    	jne    606 <printf+0x19a>
      if(c == 'd'){
 4e0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e4:	75 2d                	jne    513 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e9:	8b 00                	mov    (%eax),%eax
 4eb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f2:	00 
 4f3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4fa:	00 
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 aa fe ff ff       	call   3b4 <printint>
        ap++;
 50a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50e:	e9 ec 00 00 00       	jmp    5ff <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 513:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 517:	74 06                	je     51f <printf+0xb3>
 519:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51d:	75 2d                	jne    54c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 52b:	00 
 52c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 533:	00 
 534:	89 44 24 04          	mov    %eax,0x4(%esp)
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	89 04 24             	mov    %eax,(%esp)
 53e:	e8 71 fe ff ff       	call   3b4 <printint>
        ap++;
 543:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 547:	e9 b3 00 00 00       	jmp    5ff <printf+0x193>
      } else if(c == 's'){
 54c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 550:	75 45                	jne    597 <printf+0x12b>
        s = (char*)*ap;
 552:	8b 45 e8             	mov    -0x18(%ebp),%eax
 555:	8b 00                	mov    (%eax),%eax
 557:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 562:	75 09                	jne    56d <printf+0x101>
          s = "(null)";
 564:	c7 45 f4 68 0e 00 00 	movl   $0xe68,-0xc(%ebp)
        while(*s != 0){
 56b:	eb 1e                	jmp    58b <printf+0x11f>
 56d:	eb 1c                	jmp    58b <printf+0x11f>
          putc(fd, *s);
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	89 44 24 04          	mov    %eax,0x4(%esp)
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	89 04 24             	mov    %eax,(%esp)
 582:	e8 05 fe ff ff       	call   38c <putc>
          s++;
 587:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	84 c0                	test   %al,%al
 593:	75 da                	jne    56f <printf+0x103>
 595:	eb 68                	jmp    5ff <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 597:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59b:	75 1d                	jne    5ba <printf+0x14e>
        putc(fd, *ap);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	0f be c0             	movsbl %al,%eax
 5a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	89 04 24             	mov    %eax,(%esp)
 5af:	e8 d8 fd ff ff       	call   38c <putc>
        ap++;
 5b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b8:	eb 45                	jmp    5ff <printf+0x193>
      } else if(c == '%'){
 5ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5be:	75 17                	jne    5d7 <printf+0x16b>
        putc(fd, c);
 5c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ca:	8b 45 08             	mov    0x8(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 b7 fd ff ff       	call   38c <putc>
 5d5:	eb 28                	jmp    5ff <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5de:	00 
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	89 04 24             	mov    %eax,(%esp)
 5e5:	e8 a2 fd ff ff       	call   38c <putc>
        putc(fd, c);
 5ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	89 04 24             	mov    %eax,(%esp)
 5fa:	e8 8d fd ff ff       	call   38c <putc>
      }
      state = 0;
 5ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 606:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 60a:	8b 55 0c             	mov    0xc(%ebp),%edx
 60d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 610:	01 d0                	add    %edx,%eax
 612:	0f b6 00             	movzbl (%eax),%eax
 615:	84 c0                	test   %al,%al
 617:	0f 85 71 fe ff ff    	jne    48e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61d:	c9                   	leave  
 61e:	c3                   	ret    

0000061f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61f:	55                   	push   %ebp
 620:	89 e5                	mov    %esp,%ebp
 622:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 625:	8b 45 08             	mov    0x8(%ebp),%eax
 628:	83 e8 08             	sub    $0x8,%eax
 62b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62e:	a1 08 13 00 00       	mov    0x1308,%eax
 633:	89 45 fc             	mov    %eax,-0x4(%ebp)
 636:	eb 24                	jmp    65c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 640:	77 12                	ja     654 <free+0x35>
 642:	8b 45 f8             	mov    -0x8(%ebp),%eax
 645:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 648:	77 24                	ja     66e <free+0x4f>
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 652:	77 1a                	ja     66e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 662:	76 d4                	jbe    638 <free+0x19>
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66c:	76 ca                	jbe    638 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	8b 40 04             	mov    0x4(%eax),%eax
 674:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	01 c2                	add    %eax,%edx
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	39 c2                	cmp    %eax,%edx
 687:	75 24                	jne    6ad <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	8b 50 04             	mov    0x4(%eax),%edx
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	8b 40 04             	mov    0x4(%eax),%eax
 697:	01 c2                	add    %eax,%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	8b 10                	mov    (%eax),%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	89 10                	mov    %edx,(%eax)
 6ab:	eb 0a                	jmp    6b7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 10                	mov    (%eax),%edx
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 40 04             	mov    0x4(%eax),%eax
 6bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	01 d0                	add    %edx,%eax
 6c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cc:	75 20                	jne    6ee <free+0xcf>
    p->s.size += bp->s.size;
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 50 04             	mov    0x4(%eax),%edx
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	8b 40 04             	mov    0x4(%eax),%eax
 6da:	01 c2                	add    %eax,%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	8b 10                	mov    (%eax),%edx
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	89 10                	mov    %edx,(%eax)
 6ec:	eb 08                	jmp    6f6 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	a3 08 13 00 00       	mov    %eax,0x1308
}
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <morecore>:

static Header*
morecore(uint nu)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 706:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70d:	77 07                	ja     716 <morecore+0x16>
    nu = 4096;
 70f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	c1 e0 03             	shl    $0x3,%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 50 fc ff ff       	call   374 <sbrk>
 724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 727:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72b:	75 07                	jne    734 <morecore+0x34>
    return 0;
 72d:	b8 00 00 00 00       	mov    $0x0,%eax
 732:	eb 22                	jmp    756 <morecore+0x56>
  hp = (Header*)p;
 734:	8b 45 f4             	mov    -0xc(%ebp),%eax
 737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73d:	8b 55 08             	mov    0x8(%ebp),%edx
 740:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	83 c0 08             	add    $0x8,%eax
 749:	89 04 24             	mov    %eax,(%esp)
 74c:	e8 ce fe ff ff       	call   61f <free>
  return freep;
 751:	a1 08 13 00 00       	mov    0x1308,%eax
}
 756:	c9                   	leave  
 757:	c3                   	ret    

00000758 <malloc>:

void*
malloc(uint nbytes)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	83 c0 07             	add    $0x7,%eax
 764:	c1 e8 03             	shr    $0x3,%eax
 767:	83 c0 01             	add    $0x1,%eax
 76a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76d:	a1 08 13 00 00       	mov    0x1308,%eax
 772:	89 45 f0             	mov    %eax,-0x10(%ebp)
 775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 779:	75 23                	jne    79e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77b:	c7 45 f0 00 13 00 00 	movl   $0x1300,-0x10(%ebp)
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	a3 08 13 00 00       	mov    %eax,0x1308
 78a:	a1 08 13 00 00       	mov    0x1308,%eax
 78f:	a3 00 13 00 00       	mov    %eax,0x1300
    base.s.size = 0;
 794:	c7 05 04 13 00 00 00 	movl   $0x0,0x1304
 79b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7af:	72 4d                	jb     7fe <malloc+0xa6>
      if(p->s.size == nunits)
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ba:	75 0c                	jne    7c8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 10                	mov    (%eax),%edx
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	89 10                	mov    %edx,(%eax)
 7c6:	eb 26                	jmp    7ee <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d1:	89 c2                	mov    %eax,%edx
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 40 04             	mov    0x4(%eax),%eax
 7df:	c1 e0 03             	shl    $0x3,%eax
 7e2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	a3 08 13 00 00       	mov    %eax,0x1308
      return (void*)(p + 1);
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	83 c0 08             	add    $0x8,%eax
 7fc:	eb 38                	jmp    836 <malloc+0xde>
    }
    if(p == freep)
 7fe:	a1 08 13 00 00       	mov    0x1308,%eax
 803:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 806:	75 1b                	jne    823 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 808:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80b:	89 04 24             	mov    %eax,(%esp)
 80e:	e8 ed fe ff ff       	call   700 <morecore>
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
 816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81a:	75 07                	jne    823 <malloc+0xcb>
        return 0;
 81c:	b8 00 00 00 00       	mov    $0x0,%eax
 821:	eb 13                	jmp    836 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 831:	e9 70 ff ff ff       	jmp    7a6 <malloc+0x4e>
}
 836:	c9                   	leave  
 837:	c3                   	ret    

00000838 <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 838:	55                   	push   %ebp
 839:	89 e5                	mov    %esp,%ebp
 83b:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 83e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 845:	eb 17                	jmp    85e <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 851:	85 c0                	test   %eax,%eax
 853:	75 05                	jne    85a <findNextFreeThreadId+0x22>
			return i;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	eb 0f                	jmp    869 <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 85a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 85e:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 862:	7e e3                	jle    847 <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 869:	c9                   	leave  
 86a:	c3                   	ret    

0000086b <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 86b:	55                   	push   %ebp
 86c:	89 e5                	mov    %esp,%ebp
 86e:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 871:	a1 20 14 00 00       	mov    0x1420,%eax
 876:	8b 00                	mov    (%eax),%eax
 878:	8d 50 01             	lea    0x1(%eax),%edx
 87b:	89 d0                	mov    %edx,%eax
 87d:	c1 f8 1f             	sar    $0x1f,%eax
 880:	c1 e8 1a             	shr    $0x1a,%eax
 883:	01 c2                	add    %eax,%edx
 885:	83 e2 3f             	and    $0x3f,%edx
 888:	29 c2                	sub    %eax,%edx
 88a:	89 d0                	mov    %edx,%eax
 88c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 899:	8b 40 28             	mov    0x28(%eax),%eax
 89c:	83 f8 02             	cmp    $0x2,%eax
 89f:	75 0c                	jne    8ad <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 8ab:	eb 1c                	jmp    8c9 <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8d 50 01             	lea    0x1(%eax),%edx
 8b3:	89 d0                	mov    %edx,%eax
 8b5:	c1 f8 1f             	sar    $0x1f,%eax
 8b8:	c1 e8 1a             	shr    $0x1a,%eax
 8bb:	01 c2                	add    %eax,%edx
 8bd:	83 e2 3f             	and    $0x3f,%edx
 8c0:	29 c2                	sub    %eax,%edx
 8c2:	89 d0                	mov    %edx,%eax
 8c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 8c7:	eb c6                	jmp    88f <findNextRunnableThread+0x24>
}
 8c9:	c9                   	leave  
 8ca:	c3                   	ret    

000008cb <uthread_init>:

void uthread_init(void)
{
 8cb:	55                   	push   %ebp
 8cc:	89 e5                	mov    %esp,%ebp
 8ce:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 8d1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 8d8:	eb 12                	jmp    8ec <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	c7 04 85 20 13 00 00 	movl   $0x0,0x1320(,%eax,4)
 8e4:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 8e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8ec:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 8f0:	7e e8                	jle    8da <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 8f2:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 8f9:	e8 5a fe ff ff       	call   758 <malloc>
 8fe:	a3 20 13 00 00       	mov    %eax,0x1320
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 903:	a1 20 13 00 00       	mov    0x1320,%eax
 908:	89 e2                	mov    %esp,%edx
 90a:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 90d:	a1 20 13 00 00       	mov    0x1320,%eax
 912:	89 ea                	mov    %ebp,%edx
 914:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 917:	a1 20 13 00 00       	mov    0x1320,%eax
 91c:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 923:	a1 20 13 00 00       	mov    0x1320,%eax
 928:	a3 20 14 00 00       	mov    %eax,0x1420
	threadTable.threadCount = 1;
 92d:	c7 05 24 14 00 00 01 	movl   $0x1,0x1424
 934:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 937:	c7 44 24 04 10 0b 00 	movl   $0xb10,0x4(%esp)
 93e:	00 
 93f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 946:	e8 99 f9 ff ff       	call   2e4 <signal>
	alarm(UTHREAD_QUANTA);
 94b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 952:	e8 9d f9 ff ff       	call   2f4 <alarm>
}
 957:	c9                   	leave  
 958:	c3                   	ret    

00000959 <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 959:	55                   	push   %ebp
 95a:	89 e5                	mov    %esp,%ebp
 95c:	53                   	push   %ebx
 95d:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 960:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 967:	e8 88 f9 ff ff       	call   2f4 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 96c:	e8 c7 fe ff ff       	call   838 <findNextFreeThreadId>
 971:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 974:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 978:	75 0a                	jne    984 <uthread_create+0x2b>
		return -1;
 97a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 97f:	e9 d6 00 00 00       	jmp    a5a <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 984:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 98b:	e8 c8 fd ff ff       	call   758 <malloc>
 990:	8b 55 f4             	mov    -0xc(%ebp),%edx
 993:	89 04 95 20 13 00 00 	mov    %eax,0x1320(,%edx,4)
	threadTable.threads[current]->tid = current;
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 9a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9a7:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ac:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 9b3:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 9ba:	a1 24 14 00 00       	mov    0x1424,%eax
 9bf:	83 c0 01             	add    $0x1,%eax
 9c2:	a3 24 14 00 00       	mov    %eax,0x1424
	threadTable.threads[current]->entry = func;
 9c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ca:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 9d1:	8b 55 08             	mov    0x8(%ebp),%edx
 9d4:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9da:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 9e1:	8b 55 0c             	mov    0xc(%ebp),%edx
 9e4:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 9e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ea:	8b 1c 85 20 13 00 00 	mov    0x1320(,%eax,4),%ebx
 9f1:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 9f8:	e8 5b fd ff ff       	call   758 <malloc>
 9fd:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a03:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a0d:	8b 14 95 20 13 00 00 	mov    0x1320(,%edx,4),%edx
 a14:	8b 52 24             	mov    0x24(%edx),%edx
 a17:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 a1d:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a23:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a2d:	8b 14 95 20 13 00 00 	mov    0x1320(,%edx,4),%edx
 a34:	8b 52 04             	mov    0x4(%edx),%edx
 a37:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3d:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 a44:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 a4b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a52:	e8 9d f8 ff ff       	call   2f4 <alarm>
	return current;
 a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 a5a:	83 c4 24             	add    $0x24,%esp
 a5d:	5b                   	pop    %ebx
 a5e:	5d                   	pop    %ebp
 a5f:	c3                   	ret    

00000a60 <uthread_exit>:

void uthread_exit(void)
{
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 a66:	a1 20 14 00 00       	mov    0x1420,%eax
 a6b:	8b 00                	mov    (%eax),%eax
 a6d:	85 c0                	test   %eax,%eax
 a6f:	74 10                	je     a81 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 a71:	a1 20 14 00 00       	mov    0x1420,%eax
 a76:	8b 40 24             	mov    0x24(%eax),%eax
 a79:	89 04 24             	mov    %eax,(%esp)
 a7c:	e8 9e fb ff ff       	call   61f <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 a81:	a1 20 14 00 00       	mov    0x1420,%eax
 a86:	8b 00                	mov    (%eax),%eax
 a88:	c7 04 85 20 13 00 00 	movl   $0x0,0x1320(,%eax,4)
 a8f:	00 00 00 00 
	
	free(threadTable.runningThread);
 a93:	a1 20 14 00 00       	mov    0x1420,%eax
 a98:	89 04 24             	mov    %eax,(%esp)
 a9b:	e8 7f fb ff ff       	call   61f <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 aa0:	a1 24 14 00 00       	mov    0x1424,%eax
 aa5:	83 e8 01             	sub    $0x1,%eax
 aa8:	a3 24 14 00 00       	mov    %eax,0x1424
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 aad:	a1 24 14 00 00       	mov    0x1424,%eax
 ab2:	85 c0                	test   %eax,%eax
 ab4:	75 05                	jne    abb <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 ab6:	e8 19 f8 ff ff       	call   2d4 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 abb:	e8 ab fd ff ff       	call   86b <findNextRunnableThread>
 ac0:	a3 20 14 00 00       	mov    %eax,0x1420
	
	threadTable.runningThread->state = T_RUNNING;
 ac5:	a1 20 14 00 00       	mov    0x1420,%eax
 aca:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 ad1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ad8:	e8 17 f8 ff ff       	call   2f4 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 add:	a1 20 14 00 00       	mov    0x1420,%eax
 ae2:	8b 40 04             	mov    0x4(%eax),%eax
 ae5:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 ae7:	a1 20 14 00 00       	mov    0x1420,%eax
 aec:	8b 40 08             	mov    0x8(%eax),%eax
 aef:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 af1:	a1 20 14 00 00       	mov    0x1420,%eax
 af6:	8b 40 2c             	mov    0x2c(%eax),%eax
 af9:	85 c0                	test   %eax,%eax
 afb:	74 11                	je     b0e <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 afd:	a1 20 14 00 00       	mov    0x1420,%eax
 b02:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 b09:	e8 8e 00 00 00       	call   b9c <wrapper>
	}
	

}
 b0e:	c9                   	leave  
 b0f:	c3                   	ret    

00000b10 <uthread_yield>:

void uthread_yield(void)
{
 b10:	55                   	push   %ebp
 b11:	89 e5                	mov    %esp,%ebp
 b13:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 b16:	a1 20 14 00 00       	mov    0x1420,%eax
 b1b:	89 e2                	mov    %esp,%edx
 b1d:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 b20:	a1 20 14 00 00       	mov    0x1420,%eax
 b25:	89 ea                	mov    %ebp,%edx
 b27:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 b2a:	a1 20 14 00 00       	mov    0x1420,%eax
 b2f:	8b 40 28             	mov    0x28(%eax),%eax
 b32:	83 f8 01             	cmp    $0x1,%eax
 b35:	75 0c                	jne    b43 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 b37:	a1 20 14 00 00       	mov    0x1420,%eax
 b3c:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 b43:	e8 23 fd ff ff       	call   86b <findNextRunnableThread>
 b48:	a3 20 14 00 00       	mov    %eax,0x1420
	threadTable.runningThread->state = T_RUNNING;
 b4d:	a1 20 14 00 00       	mov    0x1420,%eax
 b52:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 b59:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b60:	e8 8f f7 ff ff       	call   2f4 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b65:	a1 20 14 00 00       	mov    0x1420,%eax
 b6a:	8b 40 04             	mov    0x4(%eax),%eax
 b6d:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b6f:	a1 20 14 00 00       	mov    0x1420,%eax
 b74:	8b 40 08             	mov    0x8(%eax),%eax
 b77:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 b79:	a1 20 14 00 00       	mov    0x1420,%eax
 b7e:	8b 40 2c             	mov    0x2c(%eax),%eax
 b81:	85 c0                	test   %eax,%eax
 b83:	74 14                	je     b99 <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 b85:	a1 20 14 00 00       	mov    0x1420,%eax
 b8a:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 b91:	b8 9c 0b 00 00       	mov    $0xb9c,%eax
 b96:	ff d0                	call   *%eax
		asm("ret");
 b98:	c3                   	ret    
	}
	return;
 b99:	90                   	nop
}
 b9a:	c9                   	leave  
 b9b:	c3                   	ret    

00000b9c <wrapper>:

void wrapper(void) {
 b9c:	55                   	push   %ebp
 b9d:	89 e5                	mov    %esp,%ebp
 b9f:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 ba2:	a1 20 14 00 00       	mov    0x1420,%eax
 ba7:	8b 40 30             	mov    0x30(%eax),%eax
 baa:	8b 15 20 14 00 00    	mov    0x1420,%edx
 bb0:	8b 52 34             	mov    0x34(%edx),%edx
 bb3:	89 14 24             	mov    %edx,(%esp)
 bb6:	ff d0                	call   *%eax
	uthread_exit();
 bb8:	e8 a3 fe ff ff       	call   a60 <uthread_exit>
}
 bbd:	c9                   	leave  
 bbe:	c3                   	ret    

00000bbf <uthread_self>:

int uthread_self(void)
{
 bbf:	55                   	push   %ebp
 bc0:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 bc2:	a1 20 14 00 00       	mov    0x1420,%eax
 bc7:	8b 00                	mov    (%eax),%eax
}
 bc9:	5d                   	pop    %ebp
 bca:	c3                   	ret    

00000bcb <uthread_join>:

int uthread_join(int tid)
{
 bcb:	55                   	push   %ebp
 bcc:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 bce:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 bd2:	7e 07                	jle    bdb <uthread_join+0x10>
		return -1;
 bd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 bd9:	eb 14                	jmp    bef <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 bdb:	90                   	nop
 bdc:	8b 45 08             	mov    0x8(%ebp),%eax
 bdf:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 be6:	85 c0                	test   %eax,%eax
 be8:	75 f2                	jne    bdc <uthread_join+0x11>
	return 0;
 bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
 bef:	5d                   	pop    %ebp
 bf0:	c3                   	ret    

00000bf1 <uthread_sleep>:

void uthread_sleep(void)
{
 bf1:	55                   	push   %ebp
 bf2:	89 e5                	mov    %esp,%ebp
 bf4:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 bf7:	a1 20 14 00 00       	mov    0x1420,%eax
 bfc:	89 e2                	mov    %esp,%edx
 bfe:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 c01:	a1 20 14 00 00       	mov    0x1420,%eax
 c06:	89 ea                	mov    %ebp,%edx
 c08:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 c0b:	a1 20 14 00 00       	mov    0x1420,%eax
 c10:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 c17:	a1 20 14 00 00       	mov    0x1420,%eax
 c1c:	8b 00                	mov    (%eax),%eax
 c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
 c22:	c7 44 24 04 6f 0e 00 	movl   $0xe6f,0x4(%esp)
 c29:	00 
 c2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c31:	e8 36 f8 ff ff       	call   46c <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 c36:	e8 30 fc ff ff       	call   86b <findNextRunnableThread>
 c3b:	a3 20 14 00 00       	mov    %eax,0x1420
	threadTable.runningThread->state = T_RUNNING;
 c40:	a1 20 14 00 00       	mov    0x1420,%eax
 c45:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 c4c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c53:	e8 9c f6 ff ff       	call   2f4 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 c58:	a1 20 14 00 00       	mov    0x1420,%eax
 c5d:	8b 40 08             	mov    0x8(%eax),%eax
 c60:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 c62:	a1 20 14 00 00       	mov    0x1420,%eax
 c67:	8b 40 04             	mov    0x4(%eax),%eax
 c6a:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 c6c:	a1 20 14 00 00       	mov    0x1420,%eax
 c71:	8b 40 2c             	mov    0x2c(%eax),%eax
 c74:	85 c0                	test   %eax,%eax
 c76:	74 14                	je     c8c <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 c78:	a1 20 14 00 00       	mov    0x1420,%eax
 c7d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 c84:	b8 9c 0b 00 00       	mov    $0xb9c,%eax
 c89:	ff d0                	call   *%eax
		asm("ret");
 c8b:	c3                   	ret    
	}
	return;	
 c8c:	90                   	nop
}
 c8d:	c9                   	leave  
 c8e:	c3                   	ret    

00000c8f <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 c8f:	55                   	push   %ebp
 c90:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 c92:	8b 45 08             	mov    0x8(%ebp),%eax
 c95:	8b 04 85 20 13 00 00 	mov    0x1320(,%eax,4),%eax
 c9c:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 ca3:	5d                   	pop    %ebp
 ca4:	c3                   	ret    

00000ca5 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 ca5:	55                   	push   %ebp
 ca6:	89 e5                	mov    %esp,%ebp
 ca8:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 cab:	c7 44 24 04 8a 0e 00 	movl   $0xe8a,0x4(%esp)
 cb2:	00 
 cb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cba:	e8 ad f7 ff ff       	call   46c <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 cc6:	eb 26                	jmp    cee <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 cc8:	8b 45 08             	mov    0x8(%ebp),%eax
 ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cce:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 cd2:	89 44 24 08          	mov    %eax,0x8(%esp)
 cd6:	c7 44 24 04 a1 0e 00 	movl   $0xea1,0x4(%esp)
 cdd:	00 
 cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ce5:	e8 82 f7 ff ff       	call   46c <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 cea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 cee:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 cf2:	7e d4                	jle    cc8 <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 cf4:	c7 44 24 04 a5 0e 00 	movl   $0xea5,0x4(%esp)
 cfb:	00 
 cfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d03:	e8 64 f7 ff ff       	call   46c <printf>
}
 d08:	c9                   	leave  
 d09:	c3                   	ret    

00000d0a <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 d0a:	55                   	push   %ebp
 d0b:	89 e5                	mov    %esp,%ebp
 d0d:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 d10:	8b 45 08             	mov    0x8(%ebp),%eax
 d13:	8b 55 0c             	mov    0xc(%ebp),%edx
 d16:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 d18:	8b 45 08             	mov    0x8(%ebp),%eax
 d1b:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 d22:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 d2c:	eb 12                	jmp    d40 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 d2e:	8b 45 08             	mov    0x8(%ebp),%eax
 d31:	8b 55 fc             	mov    -0x4(%ebp),%edx
 d34:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 d3b:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d3c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 d40:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 d44:	7e e8                	jle    d2e <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 d46:	c9                   	leave  
 d47:	c3                   	ret    

00000d48 <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 d48:	55                   	push   %ebp
 d49:	89 e5                	mov    %esp,%ebp
 d4b:	53                   	push   %ebx
 d4c:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 d4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 d56:	e8 99 f5 ff ff       	call   2f4 <alarm>
	if (semaphore->value ==0){
 d5b:	8b 45 08             	mov    0x8(%ebp),%eax
 d5e:	8b 00                	mov    (%eax),%eax
 d60:	85 c0                	test   %eax,%eax
 d62:	75 34                	jne    d98 <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 d64:	a1 20 14 00 00       	mov    0x1420,%eax
 d69:	8b 08                	mov    (%eax),%ecx
 d6b:	8b 45 08             	mov    0x8(%ebp),%eax
 d6e:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 d74:	8d 58 01             	lea    0x1(%eax),%ebx
 d77:	8b 55 08             	mov    0x8(%ebp),%edx
 d7a:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 d80:	8b 55 08             	mov    0x8(%ebp),%edx
 d83:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 d87:	a1 20 14 00 00       	mov    0x1420,%eax
 d8c:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 d93:	e8 78 fd ff ff       	call   b10 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 d98:	a1 20 14 00 00       	mov    0x1420,%eax
 d9d:	8b 10                	mov    (%eax),%edx
 d9f:	8b 45 08             	mov    0x8(%ebp),%eax
 da2:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 da9:	ff 
	semaphore->value = 0;
 daa:	8b 45 08             	mov    0x8(%ebp),%eax
 dad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 db3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 dba:	e8 35 f5 ff ff       	call   2f4 <alarm>
}
 dbf:	83 c4 14             	add    $0x14,%esp
 dc2:	5b                   	pop    %ebx
 dc3:	5d                   	pop    %ebp
 dc4:	c3                   	ret    

00000dc5 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 dc5:	55                   	push   %ebp
 dc6:	89 e5                	mov    %esp,%ebp
 dc8:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 dd2:	e8 1d f5 ff ff       	call   2f4 <alarm>
	
	if (semaphore->value == 0){
 dd7:	8b 45 08             	mov    0x8(%ebp),%eax
 dda:	8b 00                	mov    (%eax),%eax
 ddc:	85 c0                	test   %eax,%eax
 dde:	75 71                	jne    e51 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 de0:	8b 45 08             	mov    0x8(%ebp),%eax
 de3:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 dec:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 df3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 dfa:	eb 35                	jmp    e31 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 dfc:	8b 45 08             	mov    0x8(%ebp),%eax
 dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e02:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e06:	83 f8 ff             	cmp    $0xffffffff,%eax
 e09:	74 22                	je     e2d <binary_semaphore_up+0x68>
 e0b:	8b 45 08             	mov    0x8(%ebp),%eax
 e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e11:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 e18:	7d 13                	jge    e2d <binary_semaphore_up+0x68>
				minIndex = i;
 e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 e20:	8b 45 08             	mov    0x8(%ebp),%eax
 e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e26:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 e2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 e31:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 e35:	7e c5                	jle    dfc <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 e37:	8b 45 08             	mov    0x8(%ebp),%eax
 e3a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 e40:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 e44:	74 0b                	je     e51 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e49:	89 04 24             	mov    %eax,(%esp)
 e4c:	e8 3e fe ff ff       	call   c8f <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 e51:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e58:	e8 97 f4 ff ff       	call   2f4 <alarm>
	
 e5d:	c9                   	leave  
 e5e:	c3                   	ret    
