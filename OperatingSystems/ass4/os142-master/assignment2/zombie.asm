
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 75 02 00 00       	call   283 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 15 03 00 00       	call   333 <sleep>
  exit();
  1e:	e8 68 02 00 00       	call   28b <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	8d 50 01             	lea    0x1(%eax),%edx
  5b:	89 55 08             	mov    %edx,0x8(%ebp)
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  61:	8d 4a 01             	lea    0x1(%edx),%ecx
  64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  67:	0f b6 12             	movzbl (%edx),%edx
  6a:	88 10                	mov    %dl,(%eax)
  6c:	0f b6 00             	movzbl (%eax),%eax
  6f:	84 c0                	test   %al,%al
  71:	75 e2                	jne    55 <strcpy+0xd>
    ;
  return os;
  73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  76:	c9                   	leave  
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7b:	eb 08                	jmp    85 <strcmp+0xd>
    p++, q++;
  7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 10                	je     9f <strcmp+0x27>
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 10             	movzbl (%eax),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	38 c2                	cmp    %al,%dl
  9d:	74 de                	je     7d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	0f b6 d0             	movzbl %al,%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 c0             	movzbl %al,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
}
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strlen>:

uint
strlen(char *s)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c4:	eb 04                	jmp    ca <strlen+0x13>
  c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	01 d0                	add    %edx,%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 ed                	jne    c6 <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e4:	8b 45 10             	mov    0x10(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	89 04 24             	mov    %eax,(%esp)
  f8:	e8 26 ff ff ff       	call   23 <stosb>
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 4c                	jmp    190 <gets+0x5b>
    cc = read(0, &c, 1);
 144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14b:	00 
 14c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14f:	89 44 24 04          	mov    %eax,0x4(%esp)
 153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15a:	e8 5c 01 00 00       	call   2bb <read>
 15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 166:	7f 02                	jg     16a <gets+0x35>
      break;
 168:	eb 31                	jmp    19b <gets+0x66>
    buf[i++] = c;
 16a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 f4             	mov    %edx,-0xc(%ebp)
 173:	89 c2                	mov    %eax,%edx
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	01 c2                	add    %eax,%edx
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 13                	je     19b <gets+0x66>
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0d                	cmp    $0xd,%al
 18e:	74 0b                	je     19b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	83 c0 01             	add    $0x1,%eax
 196:	3b 45 0c             	cmp    0xc(%ebp),%eax
 199:	7c a9                	jl     144 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b8:	00 
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	89 04 24             	mov    %eax,(%esp)
 1bf:	e8 1f 01 00 00       	call   2e3 <open>
 1c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cb:	79 07                	jns    1d4 <stat+0x29>
    return -1;
 1cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d2:	eb 23                	jmp    1f7 <stat+0x4c>
  r = fstat(fd, st);
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 15 01 00 00       	call   2fb <fstat>
 1e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 d7 00 00 00       	call   2cb <close>
  return r;
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <atoi>:

int
atoi(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 206:	eb 25                	jmp    22d <atoi+0x34>
    n = n*10 + *s++ - '0';
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	89 d0                	mov    %edx,%eax
 20d:	c1 e0 02             	shl    $0x2,%eax
 210:	01 d0                	add    %edx,%eax
 212:	01 c0                	add    %eax,%eax
 214:	89 c1                	mov    %eax,%ecx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	0f be c0             	movsbl %al,%eax
 225:	01 c8                	add    %ecx,%eax
 227:	83 e8 30             	sub    $0x30,%eax
 22a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2f                	cmp    $0x2f,%al
 235:	7e 0a                	jle    241 <atoi+0x48>
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 39                	cmp    $0x39,%al
 23f:	7e c7                	jle    208 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 258:	eb 17                	jmp    271 <memmove+0x2b>
    *dst++ = *src++;
 25a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 fc             	mov    %edx,-0x4(%ebp)
 263:	8b 55 f8             	mov    -0x8(%ebp),%edx
 266:	8d 4a 01             	lea    0x1(%edx),%ecx
 269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26c:	0f b6 12             	movzbl (%edx),%edx
 26f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 271:	8b 45 10             	mov    0x10(%ebp),%eax
 274:	8d 50 ff             	lea    -0x1(%eax),%edx
 277:	89 55 10             	mov    %edx,0x10(%ebp)
 27a:	85 c0                	test   %eax,%eax
 27c:	7f dc                	jg     25a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 283:	b8 01 00 00 00       	mov    $0x1,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <exit>:
SYSCALL(exit)
 28b:	b8 02 00 00 00       	mov    $0x2,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <wait>:
SYSCALL(wait)
 293:	b8 03 00 00 00       	mov    $0x3,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <signal>:
SYSCALL(signal)
 29b:	b8 18 00 00 00       	mov    $0x18,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <sigsend>:
SYSCALL(sigsend)
 2a3:	b8 19 00 00 00       	mov    $0x19,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <alarm>:
SYSCALL(alarm)
 2ab:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <pipe>:
SYSCALL(pipe)
 2b3:	b8 04 00 00 00       	mov    $0x4,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <read>:
SYSCALL(read)
 2bb:	b8 05 00 00 00       	mov    $0x5,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <write>:
SYSCALL(write)
 2c3:	b8 10 00 00 00       	mov    $0x10,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <close>:
SYSCALL(close)
 2cb:	b8 15 00 00 00       	mov    $0x15,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <kill>:
SYSCALL(kill)
 2d3:	b8 06 00 00 00       	mov    $0x6,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <exec>:
SYSCALL(exec)
 2db:	b8 07 00 00 00       	mov    $0x7,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <open>:
SYSCALL(open)
 2e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mknod>:
SYSCALL(mknod)
 2eb:	b8 11 00 00 00       	mov    $0x11,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <unlink>:
SYSCALL(unlink)
 2f3:	b8 12 00 00 00       	mov    $0x12,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <fstat>:
SYSCALL(fstat)
 2fb:	b8 08 00 00 00       	mov    $0x8,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <link>:
SYSCALL(link)
 303:	b8 13 00 00 00       	mov    $0x13,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <mkdir>:
SYSCALL(mkdir)
 30b:	b8 14 00 00 00       	mov    $0x14,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <chdir>:
SYSCALL(chdir)
 313:	b8 09 00 00 00       	mov    $0x9,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <dup>:
SYSCALL(dup)
 31b:	b8 0a 00 00 00       	mov    $0xa,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <getpid>:
SYSCALL(getpid)
 323:	b8 0b 00 00 00       	mov    $0xb,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <sbrk>:
SYSCALL(sbrk)
 32b:	b8 0c 00 00 00       	mov    $0xc,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <sleep>:
SYSCALL(sleep)
 333:	b8 0d 00 00 00       	mov    $0xd,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <uptime>:
SYSCALL(uptime)
 33b:	b8 0e 00 00 00       	mov    $0xe,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	83 ec 18             	sub    $0x18,%esp
 349:	8b 45 0c             	mov    0xc(%ebp),%eax
 34c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 34f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 356:	00 
 357:	8d 45 f4             	lea    -0xc(%ebp),%eax
 35a:	89 44 24 04          	mov    %eax,0x4(%esp)
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	89 04 24             	mov    %eax,(%esp)
 364:	e8 5a ff ff ff       	call   2c3 <write>
}
 369:	c9                   	leave  
 36a:	c3                   	ret    

0000036b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	56                   	push   %esi
 36f:	53                   	push   %ebx
 370:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 37a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 37e:	74 17                	je     397 <printint+0x2c>
 380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 384:	79 11                	jns    397 <printint+0x2c>
    neg = 1;
 386:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	f7 d8                	neg    %eax
 392:	89 45 ec             	mov    %eax,-0x14(%ebp)
 395:	eb 06                	jmp    39d <printint+0x32>
  } else {
    x = xx;
 397:	8b 45 0c             	mov    0xc(%ebp),%eax
 39a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 39d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3a4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3a7:	8d 41 01             	lea    0x1(%ecx),%eax
 3aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b3:	ba 00 00 00 00       	mov    $0x0,%edx
 3b8:	f7 f3                	div    %ebx
 3ba:	89 d0                	mov    %edx,%eax
 3bc:	0f b6 80 98 12 00 00 	movzbl 0x1298(%eax),%eax
 3c3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3c7:	8b 75 10             	mov    0x10(%ebp),%esi
 3ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cd:	ba 00 00 00 00       	mov    $0x0,%edx
 3d2:	f7 f6                	div    %esi
 3d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3db:	75 c7                	jne    3a4 <printint+0x39>
  if(neg)
 3dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e1:	74 10                	je     3f3 <printint+0x88>
    buf[i++] = '-';
 3e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e6:	8d 50 01             	lea    0x1(%eax),%edx
 3e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3ec:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3f1:	eb 1f                	jmp    412 <printint+0xa7>
 3f3:	eb 1d                	jmp    412 <printint+0xa7>
    putc(fd, buf[i]);
 3f5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	0f b6 00             	movzbl (%eax),%eax
 400:	0f be c0             	movsbl %al,%eax
 403:	89 44 24 04          	mov    %eax,0x4(%esp)
 407:	8b 45 08             	mov    0x8(%ebp),%eax
 40a:	89 04 24             	mov    %eax,(%esp)
 40d:	e8 31 ff ff ff       	call   343 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 412:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 41a:	79 d9                	jns    3f5 <printint+0x8a>
    putc(fd, buf[i]);
}
 41c:	83 c4 30             	add    $0x30,%esp
 41f:	5b                   	pop    %ebx
 420:	5e                   	pop    %esi
 421:	5d                   	pop    %ebp
 422:	c3                   	ret    

00000423 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 423:	55                   	push   %ebp
 424:	89 e5                	mov    %esp,%ebp
 426:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 429:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 430:	8d 45 0c             	lea    0xc(%ebp),%eax
 433:	83 c0 04             	add    $0x4,%eax
 436:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 439:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 440:	e9 7c 01 00 00       	jmp    5c1 <printf+0x19e>
    c = fmt[i] & 0xff;
 445:	8b 55 0c             	mov    0xc(%ebp),%edx
 448:	8b 45 f0             	mov    -0x10(%ebp),%eax
 44b:	01 d0                	add    %edx,%eax
 44d:	0f b6 00             	movzbl (%eax),%eax
 450:	0f be c0             	movsbl %al,%eax
 453:	25 ff 00 00 00       	and    $0xff,%eax
 458:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 45b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45f:	75 2c                	jne    48d <printf+0x6a>
      if(c == '%'){
 461:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 465:	75 0c                	jne    473 <printf+0x50>
        state = '%';
 467:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 46e:	e9 4a 01 00 00       	jmp    5bd <printf+0x19a>
      } else {
        putc(fd, c);
 473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 476:	0f be c0             	movsbl %al,%eax
 479:	89 44 24 04          	mov    %eax,0x4(%esp)
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	89 04 24             	mov    %eax,(%esp)
 483:	e8 bb fe ff ff       	call   343 <putc>
 488:	e9 30 01 00 00       	jmp    5bd <printf+0x19a>
      }
    } else if(state == '%'){
 48d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 491:	0f 85 26 01 00 00    	jne    5bd <printf+0x19a>
      if(c == 'd'){
 497:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 49b:	75 2d                	jne    4ca <printf+0xa7>
        printint(fd, *ap, 10, 1);
 49d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a0:	8b 00                	mov    (%eax),%eax
 4a2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4a9:	00 
 4aa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4b1:	00 
 4b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	89 04 24             	mov    %eax,(%esp)
 4bc:	e8 aa fe ff ff       	call   36b <printint>
        ap++;
 4c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c5:	e9 ec 00 00 00       	jmp    5b6 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4ca:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ce:	74 06                	je     4d6 <printf+0xb3>
 4d0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d4:	75 2d                	jne    503 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d9:	8b 00                	mov    (%eax),%eax
 4db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4e2:	00 
 4e3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4ea:	00 
 4eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	89 04 24             	mov    %eax,(%esp)
 4f5:	e8 71 fe ff ff       	call   36b <printint>
        ap++;
 4fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fe:	e9 b3 00 00 00       	jmp    5b6 <printf+0x193>
      } else if(c == 's'){
 503:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 507:	75 45                	jne    54e <printf+0x12b>
        s = (char*)*ap;
 509:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50c:	8b 00                	mov    (%eax),%eax
 50e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 519:	75 09                	jne    524 <printf+0x101>
          s = "(null)";
 51b:	c7 45 f4 16 0e 00 00 	movl   $0xe16,-0xc(%ebp)
        while(*s != 0){
 522:	eb 1e                	jmp    542 <printf+0x11f>
 524:	eb 1c                	jmp    542 <printf+0x11f>
          putc(fd, *s);
 526:	8b 45 f4             	mov    -0xc(%ebp),%eax
 529:	0f b6 00             	movzbl (%eax),%eax
 52c:	0f be c0             	movsbl %al,%eax
 52f:	89 44 24 04          	mov    %eax,0x4(%esp)
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	89 04 24             	mov    %eax,(%esp)
 539:	e8 05 fe ff ff       	call   343 <putc>
          s++;
 53e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 542:	8b 45 f4             	mov    -0xc(%ebp),%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	84 c0                	test   %al,%al
 54a:	75 da                	jne    526 <printf+0x103>
 54c:	eb 68                	jmp    5b6 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 552:	75 1d                	jne    571 <printf+0x14e>
        putc(fd, *ap);
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	0f be c0             	movsbl %al,%eax
 55c:	89 44 24 04          	mov    %eax,0x4(%esp)
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	89 04 24             	mov    %eax,(%esp)
 566:	e8 d8 fd ff ff       	call   343 <putc>
        ap++;
 56b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56f:	eb 45                	jmp    5b6 <printf+0x193>
      } else if(c == '%'){
 571:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 575:	75 17                	jne    58e <printf+0x16b>
        putc(fd, c);
 577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57a:	0f be c0             	movsbl %al,%eax
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 b7 fd ff ff       	call   343 <putc>
 58c:	eb 28                	jmp    5b6 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 595:	00 
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 a2 fd ff ff       	call   343 <putc>
        putc(fd, c);
 5a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 8d fd ff ff       	call   343 <putc>
      }
      state = 0;
 5b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5c1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c7:	01 d0                	add    %edx,%eax
 5c9:	0f b6 00             	movzbl (%eax),%eax
 5cc:	84 c0                	test   %al,%al
 5ce:	0f 85 71 fe ff ff    	jne    445 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d4:	c9                   	leave  
 5d5:	c3                   	ret    

000005d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d6:	55                   	push   %ebp
 5d7:	89 e5                	mov    %esp,%ebp
 5d9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5dc:	8b 45 08             	mov    0x8(%ebp),%eax
 5df:	83 e8 08             	sub    $0x8,%eax
 5e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e5:	a1 c8 12 00 00       	mov    0x12c8,%eax
 5ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ed:	eb 24                	jmp    613 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f7:	77 12                	ja     60b <free+0x35>
 5f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ff:	77 24                	ja     625 <free+0x4f>
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 609:	77 1a                	ja     625 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	89 45 fc             	mov    %eax,-0x4(%ebp)
 613:	8b 45 f8             	mov    -0x8(%ebp),%eax
 616:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 619:	76 d4                	jbe    5ef <free+0x19>
 61b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 623:	76 ca                	jbe    5ef <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	8b 40 04             	mov    0x4(%eax),%eax
 62b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	01 c2                	add    %eax,%edx
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	39 c2                	cmp    %eax,%edx
 63e:	75 24                	jne    664 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	8b 50 04             	mov    0x4(%eax),%edx
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	8b 40 04             	mov    0x4(%eax),%eax
 64e:	01 c2                	add    %eax,%edx
 650:	8b 45 f8             	mov    -0x8(%ebp),%eax
 653:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	8b 10                	mov    (%eax),%edx
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	89 10                	mov    %edx,(%eax)
 662:	eb 0a                	jmp    66e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 10                	mov    (%eax),%edx
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 40 04             	mov    0x4(%eax),%eax
 674:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	01 d0                	add    %edx,%eax
 680:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 683:	75 20                	jne    6a5 <free+0xcf>
    p->s.size += bp->s.size;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 50 04             	mov    0x4(%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	01 c2                	add    %eax,%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 10                	mov    (%eax),%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	89 10                	mov    %edx,(%eax)
 6a3:	eb 08                	jmp    6ad <free+0xd7>
  } else
    p->s.ptr = bp;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ab:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	a3 c8 12 00 00       	mov    %eax,0x12c8
}
 6b5:	c9                   	leave  
 6b6:	c3                   	ret    

000006b7 <morecore>:

static Header*
morecore(uint nu)
{
 6b7:	55                   	push   %ebp
 6b8:	89 e5                	mov    %esp,%ebp
 6ba:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6bd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c4:	77 07                	ja     6cd <morecore+0x16>
    nu = 4096;
 6c6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	c1 e0 03             	shl    $0x3,%eax
 6d3:	89 04 24             	mov    %eax,(%esp)
 6d6:	e8 50 fc ff ff       	call   32b <sbrk>
 6db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6de:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e2:	75 07                	jne    6eb <morecore+0x34>
    return 0;
 6e4:	b8 00 00 00 00       	mov    $0x0,%eax
 6e9:	eb 22                	jmp    70d <morecore+0x56>
  hp = (Header*)p;
 6eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f4:	8b 55 08             	mov    0x8(%ebp),%edx
 6f7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fd:	83 c0 08             	add    $0x8,%eax
 700:	89 04 24             	mov    %eax,(%esp)
 703:	e8 ce fe ff ff       	call   5d6 <free>
  return freep;
 708:	a1 c8 12 00 00       	mov    0x12c8,%eax
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <malloc>:

void*
malloc(uint nbytes)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	83 c0 07             	add    $0x7,%eax
 71b:	c1 e8 03             	shr    $0x3,%eax
 71e:	83 c0 01             	add    $0x1,%eax
 721:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 724:	a1 c8 12 00 00       	mov    0x12c8,%eax
 729:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 730:	75 23                	jne    755 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 732:	c7 45 f0 c0 12 00 00 	movl   $0x12c0,-0x10(%ebp)
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	a3 c8 12 00 00       	mov    %eax,0x12c8
 741:	a1 c8 12 00 00       	mov    0x12c8,%eax
 746:	a3 c0 12 00 00       	mov    %eax,0x12c0
    base.s.size = 0;
 74b:	c7 05 c4 12 00 00 00 	movl   $0x0,0x12c4
 752:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 766:	72 4d                	jb     7b5 <malloc+0xa6>
      if(p->s.size == nunits)
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 771:	75 0c                	jne    77f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	89 10                	mov    %edx,(%eax)
 77d:	eb 26                	jmp    7a5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	2b 45 ec             	sub    -0x14(%ebp),%eax
 788:	89 c2                	mov    %eax,%edx
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	c1 e0 03             	shl    $0x3,%eax
 799:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	a3 c8 12 00 00       	mov    %eax,0x12c8
      return (void*)(p + 1);
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	83 c0 08             	add    $0x8,%eax
 7b3:	eb 38                	jmp    7ed <malloc+0xde>
    }
    if(p == freep)
 7b5:	a1 c8 12 00 00       	mov    0x12c8,%eax
 7ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bd:	75 1b                	jne    7da <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c2:	89 04 24             	mov    %eax,(%esp)
 7c5:	e8 ed fe ff ff       	call   6b7 <morecore>
 7ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d1:	75 07                	jne    7da <malloc+0xcb>
        return 0;
 7d3:	b8 00 00 00 00       	mov    $0x0,%eax
 7d8:	eb 13                	jmp    7ed <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e8:	e9 70 ff ff ff       	jmp    75d <malloc+0x4e>
}
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 7ef:	55                   	push   %ebp
 7f0:	89 e5                	mov    %esp,%ebp
 7f2:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 7f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 7fc:	eb 17                	jmp    815 <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 808:	85 c0                	test   %eax,%eax
 80a:	75 05                	jne    811 <findNextFreeThreadId+0x22>
			return i;
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	eb 0f                	jmp    820 <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 811:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 815:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 819:	7e e3                	jle    7fe <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 81b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 820:	c9                   	leave  
 821:	c3                   	ret    

00000822 <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 822:	55                   	push   %ebp
 823:	89 e5                	mov    %esp,%ebp
 825:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 828:	a1 e0 13 00 00       	mov    0x13e0,%eax
 82d:	8b 00                	mov    (%eax),%eax
 82f:	8d 50 01             	lea    0x1(%eax),%edx
 832:	89 d0                	mov    %edx,%eax
 834:	c1 f8 1f             	sar    $0x1f,%eax
 837:	c1 e8 1a             	shr    $0x1a,%eax
 83a:	01 c2                	add    %eax,%edx
 83c:	83 e2 3f             	and    $0x3f,%edx
 83f:	29 c2                	sub    %eax,%edx
 841:	89 d0                	mov    %edx,%eax
 843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 850:	8b 40 28             	mov    0x28(%eax),%eax
 853:	83 f8 02             	cmp    $0x2,%eax
 856:	75 0c                	jne    864 <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 862:	eb 1c                	jmp    880 <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	8d 50 01             	lea    0x1(%eax),%edx
 86a:	89 d0                	mov    %edx,%eax
 86c:	c1 f8 1f             	sar    $0x1f,%eax
 86f:	c1 e8 1a             	shr    $0x1a,%eax
 872:	01 c2                	add    %eax,%edx
 874:	83 e2 3f             	and    $0x3f,%edx
 877:	29 c2                	sub    %eax,%edx
 879:	89 d0                	mov    %edx,%eax
 87b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 87e:	eb c6                	jmp    846 <findNextRunnableThread+0x24>
}
 880:	c9                   	leave  
 881:	c3                   	ret    

00000882 <uthread_init>:

void uthread_init(void)
{
 882:	55                   	push   %ebp
 883:	89 e5                	mov    %esp,%ebp
 885:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 888:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 88f:	eb 12                	jmp    8a3 <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	c7 04 85 e0 12 00 00 	movl   $0x0,0x12e0(,%eax,4)
 89b:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 89f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8a3:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 8a7:	7e e8                	jle    891 <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 8a9:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 8b0:	e8 5a fe ff ff       	call   70f <malloc>
 8b5:	a3 e0 12 00 00       	mov    %eax,0x12e0
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 8ba:	a1 e0 12 00 00       	mov    0x12e0,%eax
 8bf:	89 e2                	mov    %esp,%edx
 8c1:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 8c4:	a1 e0 12 00 00       	mov    0x12e0,%eax
 8c9:	89 ea                	mov    %ebp,%edx
 8cb:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 8ce:	a1 e0 12 00 00       	mov    0x12e0,%eax
 8d3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 8da:	a1 e0 12 00 00       	mov    0x12e0,%eax
 8df:	a3 e0 13 00 00       	mov    %eax,0x13e0
	threadTable.threadCount = 1;
 8e4:	c7 05 e4 13 00 00 01 	movl   $0x1,0x13e4
 8eb:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 8ee:	c7 44 24 04 c7 0a 00 	movl   $0xac7,0x4(%esp)
 8f5:	00 
 8f6:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 8fd:	e8 99 f9 ff ff       	call   29b <signal>
	alarm(UTHREAD_QUANTA);
 902:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 909:	e8 9d f9 ff ff       	call   2ab <alarm>
}
 90e:	c9                   	leave  
 90f:	c3                   	ret    

00000910 <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	53                   	push   %ebx
 914:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 917:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 91e:	e8 88 f9 ff ff       	call   2ab <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 923:	e8 c7 fe ff ff       	call   7ef <findNextFreeThreadId>
 928:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 92b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 92f:	75 0a                	jne    93b <uthread_create+0x2b>
		return -1;
 931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 936:	e9 d6 00 00 00       	jmp    a11 <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 93b:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 942:	e8 c8 fd ff ff       	call   70f <malloc>
 947:	8b 55 f4             	mov    -0xc(%ebp),%edx
 94a:	89 04 95 e0 12 00 00 	mov    %eax,0x12e0(,%edx,4)
	threadTable.threads[current]->tid = current;
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 95b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 95e:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 960:	8b 45 f4             	mov    -0xc(%ebp),%eax
 963:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 96a:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 971:	a1 e4 13 00 00       	mov    0x13e4,%eax
 976:	83 c0 01             	add    $0x1,%eax
 979:	a3 e4 13 00 00       	mov    %eax,0x13e4
	threadTable.threads[current]->entry = func;
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 988:	8b 55 08             	mov    0x8(%ebp),%edx
 98b:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 98e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 991:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 998:	8b 55 0c             	mov    0xc(%ebp),%edx
 99b:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 99e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a1:	8b 1c 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%ebx
 9a8:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 9af:	e8 5b fd ff ff       	call   70f <malloc>
 9b4:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 9c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9c4:	8b 14 95 e0 12 00 00 	mov    0x12e0(,%edx,4),%edx
 9cb:	8b 52 24             	mov    0x24(%edx),%edx
 9ce:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 9d4:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9da:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 9e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9e4:	8b 14 95 e0 12 00 00 	mov    0x12e0(,%edx,4),%edx
 9eb:	8b 52 04             	mov    0x4(%edx),%edx
 9ee:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f4:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 9fb:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 a02:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a09:	e8 9d f8 ff ff       	call   2ab <alarm>
	return current;
 a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 a11:	83 c4 24             	add    $0x24,%esp
 a14:	5b                   	pop    %ebx
 a15:	5d                   	pop    %ebp
 a16:	c3                   	ret    

00000a17 <uthread_exit>:

void uthread_exit(void)
{
 a17:	55                   	push   %ebp
 a18:	89 e5                	mov    %esp,%ebp
 a1a:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 a1d:	a1 e0 13 00 00       	mov    0x13e0,%eax
 a22:	8b 00                	mov    (%eax),%eax
 a24:	85 c0                	test   %eax,%eax
 a26:	74 10                	je     a38 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 a28:	a1 e0 13 00 00       	mov    0x13e0,%eax
 a2d:	8b 40 24             	mov    0x24(%eax),%eax
 a30:	89 04 24             	mov    %eax,(%esp)
 a33:	e8 9e fb ff ff       	call   5d6 <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 a38:	a1 e0 13 00 00       	mov    0x13e0,%eax
 a3d:	8b 00                	mov    (%eax),%eax
 a3f:	c7 04 85 e0 12 00 00 	movl   $0x0,0x12e0(,%eax,4)
 a46:	00 00 00 00 
	
	free(threadTable.runningThread);
 a4a:	a1 e0 13 00 00       	mov    0x13e0,%eax
 a4f:	89 04 24             	mov    %eax,(%esp)
 a52:	e8 7f fb ff ff       	call   5d6 <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 a57:	a1 e4 13 00 00       	mov    0x13e4,%eax
 a5c:	83 e8 01             	sub    $0x1,%eax
 a5f:	a3 e4 13 00 00       	mov    %eax,0x13e4
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 a64:	a1 e4 13 00 00       	mov    0x13e4,%eax
 a69:	85 c0                	test   %eax,%eax
 a6b:	75 05                	jne    a72 <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 a6d:	e8 19 f8 ff ff       	call   28b <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 a72:	e8 ab fd ff ff       	call   822 <findNextRunnableThread>
 a77:	a3 e0 13 00 00       	mov    %eax,0x13e0
	
	threadTable.runningThread->state = T_RUNNING;
 a7c:	a1 e0 13 00 00       	mov    0x13e0,%eax
 a81:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 a88:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a8f:	e8 17 f8 ff ff       	call   2ab <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 a94:	a1 e0 13 00 00       	mov    0x13e0,%eax
 a99:	8b 40 04             	mov    0x4(%eax),%eax
 a9c:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 a9e:	a1 e0 13 00 00       	mov    0x13e0,%eax
 aa3:	8b 40 08             	mov    0x8(%eax),%eax
 aa6:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 aa8:	a1 e0 13 00 00       	mov    0x13e0,%eax
 aad:	8b 40 2c             	mov    0x2c(%eax),%eax
 ab0:	85 c0                	test   %eax,%eax
 ab2:	74 11                	je     ac5 <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 ab4:	a1 e0 13 00 00       	mov    0x13e0,%eax
 ab9:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 ac0:	e8 8e 00 00 00       	call   b53 <wrapper>
	}
	

}
 ac5:	c9                   	leave  
 ac6:	c3                   	ret    

00000ac7 <uthread_yield>:

void uthread_yield(void)
{
 ac7:	55                   	push   %ebp
 ac8:	89 e5                	mov    %esp,%ebp
 aca:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 acd:	a1 e0 13 00 00       	mov    0x13e0,%eax
 ad2:	89 e2                	mov    %esp,%edx
 ad4:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 ad7:	a1 e0 13 00 00       	mov    0x13e0,%eax
 adc:	89 ea                	mov    %ebp,%edx
 ade:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 ae1:	a1 e0 13 00 00       	mov    0x13e0,%eax
 ae6:	8b 40 28             	mov    0x28(%eax),%eax
 ae9:	83 f8 01             	cmp    $0x1,%eax
 aec:	75 0c                	jne    afa <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 aee:	a1 e0 13 00 00       	mov    0x13e0,%eax
 af3:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 afa:	e8 23 fd ff ff       	call   822 <findNextRunnableThread>
 aff:	a3 e0 13 00 00       	mov    %eax,0x13e0
	threadTable.runningThread->state = T_RUNNING;
 b04:	a1 e0 13 00 00       	mov    0x13e0,%eax
 b09:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 b10:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b17:	e8 8f f7 ff ff       	call   2ab <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b1c:	a1 e0 13 00 00       	mov    0x13e0,%eax
 b21:	8b 40 04             	mov    0x4(%eax),%eax
 b24:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b26:	a1 e0 13 00 00       	mov    0x13e0,%eax
 b2b:	8b 40 08             	mov    0x8(%eax),%eax
 b2e:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 b30:	a1 e0 13 00 00       	mov    0x13e0,%eax
 b35:	8b 40 2c             	mov    0x2c(%eax),%eax
 b38:	85 c0                	test   %eax,%eax
 b3a:	74 14                	je     b50 <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 b3c:	a1 e0 13 00 00       	mov    0x13e0,%eax
 b41:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 b48:	b8 53 0b 00 00       	mov    $0xb53,%eax
 b4d:	ff d0                	call   *%eax
		asm("ret");
 b4f:	c3                   	ret    
	}
	return;
 b50:	90                   	nop
}
 b51:	c9                   	leave  
 b52:	c3                   	ret    

00000b53 <wrapper>:

void wrapper(void) {
 b53:	55                   	push   %ebp
 b54:	89 e5                	mov    %esp,%ebp
 b56:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 b59:	a1 e0 13 00 00       	mov    0x13e0,%eax
 b5e:	8b 40 30             	mov    0x30(%eax),%eax
 b61:	8b 15 e0 13 00 00    	mov    0x13e0,%edx
 b67:	8b 52 34             	mov    0x34(%edx),%edx
 b6a:	89 14 24             	mov    %edx,(%esp)
 b6d:	ff d0                	call   *%eax
	uthread_exit();
 b6f:	e8 a3 fe ff ff       	call   a17 <uthread_exit>
}
 b74:	c9                   	leave  
 b75:	c3                   	ret    

00000b76 <uthread_self>:

int uthread_self(void)
{
 b76:	55                   	push   %ebp
 b77:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 b79:	a1 e0 13 00 00       	mov    0x13e0,%eax
 b7e:	8b 00                	mov    (%eax),%eax
}
 b80:	5d                   	pop    %ebp
 b81:	c3                   	ret    

00000b82 <uthread_join>:

int uthread_join(int tid)
{
 b82:	55                   	push   %ebp
 b83:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 b85:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 b89:	7e 07                	jle    b92 <uthread_join+0x10>
		return -1;
 b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 b90:	eb 14                	jmp    ba6 <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 b92:	90                   	nop
 b93:	8b 45 08             	mov    0x8(%ebp),%eax
 b96:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 b9d:	85 c0                	test   %eax,%eax
 b9f:	75 f2                	jne    b93 <uthread_join+0x11>
	return 0;
 ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 ba6:	5d                   	pop    %ebp
 ba7:	c3                   	ret    

00000ba8 <uthread_sleep>:

void uthread_sleep(void)
{
 ba8:	55                   	push   %ebp
 ba9:	89 e5                	mov    %esp,%ebp
 bab:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 bae:	a1 e0 13 00 00       	mov    0x13e0,%eax
 bb3:	89 e2                	mov    %esp,%edx
 bb5:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 bb8:	a1 e0 13 00 00       	mov    0x13e0,%eax
 bbd:	89 ea                	mov    %ebp,%edx
 bbf:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 bc2:	a1 e0 13 00 00       	mov    0x13e0,%eax
 bc7:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 bce:	a1 e0 13 00 00       	mov    0x13e0,%eax
 bd3:	8b 00                	mov    (%eax),%eax
 bd5:	89 44 24 08          	mov    %eax,0x8(%esp)
 bd9:	c7 44 24 04 1d 0e 00 	movl   $0xe1d,0x4(%esp)
 be0:	00 
 be1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 be8:	e8 36 f8 ff ff       	call   423 <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 bed:	e8 30 fc ff ff       	call   822 <findNextRunnableThread>
 bf2:	a3 e0 13 00 00       	mov    %eax,0x13e0
	threadTable.runningThread->state = T_RUNNING;
 bf7:	a1 e0 13 00 00       	mov    0x13e0,%eax
 bfc:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 c03:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c0a:	e8 9c f6 ff ff       	call   2ab <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 c0f:	a1 e0 13 00 00       	mov    0x13e0,%eax
 c14:	8b 40 08             	mov    0x8(%eax),%eax
 c17:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 c19:	a1 e0 13 00 00       	mov    0x13e0,%eax
 c1e:	8b 40 04             	mov    0x4(%eax),%eax
 c21:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 c23:	a1 e0 13 00 00       	mov    0x13e0,%eax
 c28:	8b 40 2c             	mov    0x2c(%eax),%eax
 c2b:	85 c0                	test   %eax,%eax
 c2d:	74 14                	je     c43 <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 c2f:	a1 e0 13 00 00       	mov    0x13e0,%eax
 c34:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 c3b:	b8 53 0b 00 00       	mov    $0xb53,%eax
 c40:	ff d0                	call   *%eax
		asm("ret");
 c42:	c3                   	ret    
	}
	return;	
 c43:	90                   	nop
}
 c44:	c9                   	leave  
 c45:	c3                   	ret    

00000c46 <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 c46:	55                   	push   %ebp
 c47:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 c49:	8b 45 08             	mov    0x8(%ebp),%eax
 c4c:	8b 04 85 e0 12 00 00 	mov    0x12e0(,%eax,4),%eax
 c53:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 c5a:	5d                   	pop    %ebp
 c5b:	c3                   	ret    

00000c5c <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 c5c:	55                   	push   %ebp
 c5d:	89 e5                	mov    %esp,%ebp
 c5f:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 c62:	c7 44 24 04 38 0e 00 	movl   $0xe38,0x4(%esp)
 c69:	00 
 c6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c71:	e8 ad f7 ff ff       	call   423 <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 c76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 c7d:	eb 26                	jmp    ca5 <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 c7f:	8b 45 08             	mov    0x8(%ebp),%eax
 c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
 c85:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 c89:	89 44 24 08          	mov    %eax,0x8(%esp)
 c8d:	c7 44 24 04 4f 0e 00 	movl   $0xe4f,0x4(%esp)
 c94:	00 
 c95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c9c:	e8 82 f7 ff ff       	call   423 <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 ca1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 ca5:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 ca9:	7e d4                	jle    c7f <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 cab:	c7 44 24 04 53 0e 00 	movl   $0xe53,0x4(%esp)
 cb2:	00 
 cb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cba:	e8 64 f7 ff ff       	call   423 <printf>
}
 cbf:	c9                   	leave  
 cc0:	c3                   	ret    

00000cc1 <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 cc1:	55                   	push   %ebp
 cc2:	89 e5                	mov    %esp,%ebp
 cc4:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 cc7:	8b 45 08             	mov    0x8(%ebp),%eax
 cca:	8b 55 0c             	mov    0xc(%ebp),%edx
 ccd:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 ccf:	8b 45 08             	mov    0x8(%ebp),%eax
 cd2:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 cd9:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 cdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 ce3:	eb 12                	jmp    cf7 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 ce5:	8b 45 08             	mov    0x8(%ebp),%eax
 ce8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 ceb:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 cf2:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 cf3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 cf7:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 cfb:	7e e8                	jle    ce5 <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 cfd:	c9                   	leave  
 cfe:	c3                   	ret    

00000cff <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 cff:	55                   	push   %ebp
 d00:	89 e5                	mov    %esp,%ebp
 d02:	53                   	push   %ebx
 d03:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 d06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 d0d:	e8 99 f5 ff ff       	call   2ab <alarm>
	if (semaphore->value ==0){
 d12:	8b 45 08             	mov    0x8(%ebp),%eax
 d15:	8b 00                	mov    (%eax),%eax
 d17:	85 c0                	test   %eax,%eax
 d19:	75 34                	jne    d4f <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 d1b:	a1 e0 13 00 00       	mov    0x13e0,%eax
 d20:	8b 08                	mov    (%eax),%ecx
 d22:	8b 45 08             	mov    0x8(%ebp),%eax
 d25:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 d2b:	8d 58 01             	lea    0x1(%eax),%ebx
 d2e:	8b 55 08             	mov    0x8(%ebp),%edx
 d31:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 d37:	8b 55 08             	mov    0x8(%ebp),%edx
 d3a:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 d3e:	a1 e0 13 00 00       	mov    0x13e0,%eax
 d43:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 d4a:	e8 78 fd ff ff       	call   ac7 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 d4f:	a1 e0 13 00 00       	mov    0x13e0,%eax
 d54:	8b 10                	mov    (%eax),%edx
 d56:	8b 45 08             	mov    0x8(%ebp),%eax
 d59:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 d60:	ff 
	semaphore->value = 0;
 d61:	8b 45 08             	mov    0x8(%ebp),%eax
 d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 d6a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 d71:	e8 35 f5 ff ff       	call   2ab <alarm>
}
 d76:	83 c4 14             	add    $0x14,%esp
 d79:	5b                   	pop    %ebx
 d7a:	5d                   	pop    %ebp
 d7b:	c3                   	ret    

00000d7c <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 d7c:	55                   	push   %ebp
 d7d:	89 e5                	mov    %esp,%ebp
 d7f:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 d82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 d89:	e8 1d f5 ff ff       	call   2ab <alarm>
	
	if (semaphore->value == 0){
 d8e:	8b 45 08             	mov    0x8(%ebp),%eax
 d91:	8b 00                	mov    (%eax),%eax
 d93:	85 c0                	test   %eax,%eax
 d95:	75 71                	jne    e08 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 d97:	8b 45 08             	mov    0x8(%ebp),%eax
 d9a:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 da0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 da3:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 daa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 db1:	eb 35                	jmp    de8 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 db3:	8b 45 08             	mov    0x8(%ebp),%eax
 db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 db9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 dbd:	83 f8 ff             	cmp    $0xffffffff,%eax
 dc0:	74 22                	je     de4 <binary_semaphore_up+0x68>
 dc2:	8b 45 08             	mov    0x8(%ebp),%eax
 dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 dc8:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 dcc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 dcf:	7d 13                	jge    de4 <binary_semaphore_up+0x68>
				minIndex = i;
 dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 dd7:	8b 45 08             	mov    0x8(%ebp),%eax
 dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ddd:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 de1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 de4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 de8:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 dec:	7e c5                	jle    db3 <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 dee:	8b 45 08             	mov    0x8(%ebp),%eax
 df1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 df7:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 dfb:	74 0b                	je     e08 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e00:	89 04 24             	mov    %eax,(%esp)
 e03:	e8 3e fe ff ff       	call   c46 <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 e08:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e0f:	e8 97 f4 ff ff       	call   2ab <alarm>
	
 e14:	c9                   	leave  
 e15:	c3                   	ret    
