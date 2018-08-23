
_mkdir:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 82 0e 00 	movl   $0xe82,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 6c 04 00 00       	call   48f <printf>
    exit();
  23:	e8 cf 02 00 00       	call   2f7 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 2b 03 00 00       	call   377 <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 99 0e 00 	movl   $0xe99,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 15 04 00 00       	call   48f <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 68 02 00 00       	call   2f7 <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c0:	90                   	nop
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	8d 50 01             	lea    0x1(%eax),%edx
  c7:	89 55 08             	mov    %edx,0x8(%ebp)
  ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d3:	0f b6 12             	movzbl (%edx),%edx
  d6:	88 10                	mov    %dl,(%eax)
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 e2                	jne    c1 <strcpy+0xd>
    ;
  return os;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e7:	eb 08                	jmp    f1 <strcmp+0xd>
    p++, q++;
  e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	84 c0                	test   %al,%al
  f9:	74 10                	je     10b <strcmp+0x27>
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 10             	movzbl (%eax),%edx
 101:	8b 45 0c             	mov    0xc(%ebp),%eax
 104:	0f b6 00             	movzbl (%eax),%eax
 107:	38 c2                	cmp    %al,%dl
 109:	74 de                	je     e9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	0f b6 d0             	movzbl %al,%edx
 114:	8b 45 0c             	mov    0xc(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	0f b6 c0             	movzbl %al,%eax
 11d:	29 c2                	sub    %eax,%edx
 11f:	89 d0                	mov    %edx,%eax
}
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    

00000123 <strlen>:

uint
strlen(char *s)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 130:	eb 04                	jmp    136 <strlen+0x13>
 132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 136:	8b 55 fc             	mov    -0x4(%ebp),%edx
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	01 d0                	add    %edx,%eax
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	84 c0                	test   %al,%al
 143:	75 ed                	jne    132 <strlen+0xf>
    ;
  return n;
 145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 150:	8b 45 10             	mov    0x10(%ebp),%eax
 153:	89 44 24 08          	mov    %eax,0x8(%esp)
 157:	8b 45 0c             	mov    0xc(%ebp),%eax
 15a:	89 44 24 04          	mov    %eax,0x4(%esp)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	89 04 24             	mov    %eax,(%esp)
 164:	e8 26 ff ff ff       	call   8f <stosb>
  return dst;
 169:	8b 45 08             	mov    0x8(%ebp),%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 04             	sub    $0x4,%esp
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17a:	eb 14                	jmp    190 <strchr+0x22>
    if(*s == c)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	3a 45 fc             	cmp    -0x4(%ebp),%al
 185:	75 05                	jne    18c <strchr+0x1e>
      return (char*)s;
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	eb 13                	jmp    19f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 18c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	84 c0                	test   %al,%al
 198:	75 e2                	jne    17c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 19a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <gets>:

char*
gets(char *buf, int max)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ae:	eb 4c                	jmp    1fc <gets+0x5b>
    cc = read(0, &c, 1);
 1b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b7:	00 
 1b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c6:	e8 5c 01 00 00       	call   327 <read>
 1cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d2:	7f 02                	jg     1d6 <gets+0x35>
      break;
 1d4:	eb 31                	jmp    207 <gets+0x66>
    buf[i++] = c;
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	8d 50 01             	lea    0x1(%eax),%edx
 1dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1df:	89 c2                	mov    %eax,%edx
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	01 c2                	add    %eax,%edx
 1e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f0:	3c 0a                	cmp    $0xa,%al
 1f2:	74 13                	je     207 <gets+0x66>
 1f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f8:	3c 0d                	cmp    $0xd,%al
 1fa:	74 0b                	je     207 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ff:	83 c0 01             	add    $0x1,%eax
 202:	3b 45 0c             	cmp    0xc(%ebp),%eax
 205:	7c a9                	jl     1b0 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 207:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
}
 215:	c9                   	leave  
 216:	c3                   	ret    

00000217 <stat>:

int
stat(char *n, struct stat *st)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 224:	00 
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	89 04 24             	mov    %eax,(%esp)
 22b:	e8 1f 01 00 00       	call   34f <open>
 230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 237:	79 07                	jns    240 <stat+0x29>
    return -1;
 239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 23e:	eb 23                	jmp    263 <stat+0x4c>
  r = fstat(fd, st);
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	89 04 24             	mov    %eax,(%esp)
 24d:	e8 15 01 00 00       	call   367 <fstat>
 252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	89 04 24             	mov    %eax,(%esp)
 25b:	e8 d7 00 00 00       	call   337 <close>
  return r;
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <atoi>:

int
atoi(const char *s)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 26b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 272:	eb 25                	jmp    299 <atoi+0x34>
    n = n*10 + *s++ - '0';
 274:	8b 55 fc             	mov    -0x4(%ebp),%edx
 277:	89 d0                	mov    %edx,%eax
 279:	c1 e0 02             	shl    $0x2,%eax
 27c:	01 d0                	add    %edx,%eax
 27e:	01 c0                	add    %eax,%eax
 280:	89 c1                	mov    %eax,%ecx
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	8d 50 01             	lea    0x1(%eax),%edx
 288:	89 55 08             	mov    %edx,0x8(%ebp)
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	0f be c0             	movsbl %al,%eax
 291:	01 c8                	add    %ecx,%eax
 293:	83 e8 30             	sub    $0x30,%eax
 296:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	3c 2f                	cmp    $0x2f,%al
 2a1:	7e 0a                	jle    2ad <atoi+0x48>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	3c 39                	cmp    $0x39,%al
 2ab:	7e c7                	jle    274 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2be:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c4:	eb 17                	jmp    2dd <memmove+0x2b>
    *dst++ = *src++;
 2c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c9:	8d 50 01             	lea    0x1(%eax),%edx
 2cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d8:	0f b6 12             	movzbl (%edx),%edx
 2db:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2dd:	8b 45 10             	mov    0x10(%ebp),%eax
 2e0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e3:	89 55 10             	mov    %edx,0x10(%ebp)
 2e6:	85 c0                	test   %eax,%eax
 2e8:	7f dc                	jg     2c6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ed:	c9                   	leave  
 2ee:	c3                   	ret    

000002ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ef:	b8 01 00 00 00       	mov    $0x1,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <exit>:
SYSCALL(exit)
 2f7:	b8 02 00 00 00       	mov    $0x2,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <wait>:
SYSCALL(wait)
 2ff:	b8 03 00 00 00       	mov    $0x3,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <signal>:
SYSCALL(signal)
 307:	b8 18 00 00 00       	mov    $0x18,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <sigsend>:
SYSCALL(sigsend)
 30f:	b8 19 00 00 00       	mov    $0x19,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <alarm>:
SYSCALL(alarm)
 317:	b8 1a 00 00 00       	mov    $0x1a,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <pipe>:
SYSCALL(pipe)
 31f:	b8 04 00 00 00       	mov    $0x4,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <read>:
SYSCALL(read)
 327:	b8 05 00 00 00       	mov    $0x5,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <write>:
SYSCALL(write)
 32f:	b8 10 00 00 00       	mov    $0x10,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <close>:
SYSCALL(close)
 337:	b8 15 00 00 00       	mov    $0x15,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <kill>:
SYSCALL(kill)
 33f:	b8 06 00 00 00       	mov    $0x6,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <exec>:
SYSCALL(exec)
 347:	b8 07 00 00 00       	mov    $0x7,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <open>:
SYSCALL(open)
 34f:	b8 0f 00 00 00       	mov    $0xf,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <mknod>:
SYSCALL(mknod)
 357:	b8 11 00 00 00       	mov    $0x11,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <unlink>:
SYSCALL(unlink)
 35f:	b8 12 00 00 00       	mov    $0x12,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <fstat>:
SYSCALL(fstat)
 367:	b8 08 00 00 00       	mov    $0x8,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <link>:
SYSCALL(link)
 36f:	b8 13 00 00 00       	mov    $0x13,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <mkdir>:
SYSCALL(mkdir)
 377:	b8 14 00 00 00       	mov    $0x14,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <chdir>:
SYSCALL(chdir)
 37f:	b8 09 00 00 00       	mov    $0x9,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <dup>:
SYSCALL(dup)
 387:	b8 0a 00 00 00       	mov    $0xa,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <getpid>:
SYSCALL(getpid)
 38f:	b8 0b 00 00 00       	mov    $0xb,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <sbrk>:
SYSCALL(sbrk)
 397:	b8 0c 00 00 00       	mov    $0xc,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <sleep>:
SYSCALL(sleep)
 39f:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <uptime>:
SYSCALL(uptime)
 3a7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 18             	sub    $0x18,%esp
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c2:	00 
 3c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
 3cd:	89 04 24             	mov    %eax,(%esp)
 3d0:	e8 5a ff ff ff       	call   32f <write>
}
 3d5:	c9                   	leave  
 3d6:	c3                   	ret    

000003d7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	56                   	push   %esi
 3db:	53                   	push   %ebx
 3dc:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ea:	74 17                	je     403 <printint+0x2c>
 3ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f0:	79 11                	jns    403 <printint+0x2c>
    neg = 1;
 3f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fc:	f7 d8                	neg    %eax
 3fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
 401:	eb 06                	jmp    409 <printint+0x32>
  } else {
    x = xx;
 403:	8b 45 0c             	mov    0xc(%ebp),%eax
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 409:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 410:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 413:	8d 41 01             	lea    0x1(%ecx),%eax
 416:	89 45 f4             	mov    %eax,-0xc(%ebp)
 419:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41f:	ba 00 00 00 00       	mov    $0x0,%edx
 424:	f7 f3                	div    %ebx
 426:	89 d0                	mov    %edx,%eax
 428:	0f b6 80 38 13 00 00 	movzbl 0x1338(%eax),%eax
 42f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 433:	8b 75 10             	mov    0x10(%ebp),%esi
 436:	8b 45 ec             	mov    -0x14(%ebp),%eax
 439:	ba 00 00 00 00       	mov    $0x0,%edx
 43e:	f7 f6                	div    %esi
 440:	89 45 ec             	mov    %eax,-0x14(%ebp)
 443:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 447:	75 c7                	jne    410 <printint+0x39>
  if(neg)
 449:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44d:	74 10                	je     45f <printint+0x88>
    buf[i++] = '-';
 44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 452:	8d 50 01             	lea    0x1(%eax),%edx
 455:	89 55 f4             	mov    %edx,-0xc(%ebp)
 458:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45d:	eb 1f                	jmp    47e <printint+0xa7>
 45f:	eb 1d                	jmp    47e <printint+0xa7>
    putc(fd, buf[i]);
 461:	8d 55 dc             	lea    -0x24(%ebp),%edx
 464:	8b 45 f4             	mov    -0xc(%ebp),%eax
 467:	01 d0                	add    %edx,%eax
 469:	0f b6 00             	movzbl (%eax),%eax
 46c:	0f be c0             	movsbl %al,%eax
 46f:	89 44 24 04          	mov    %eax,0x4(%esp)
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	89 04 24             	mov    %eax,(%esp)
 479:	e8 31 ff ff ff       	call   3af <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 486:	79 d9                	jns    461 <printint+0x8a>
    putc(fd, buf[i]);
}
 488:	83 c4 30             	add    $0x30,%esp
 48b:	5b                   	pop    %ebx
 48c:	5e                   	pop    %esi
 48d:	5d                   	pop    %ebp
 48e:	c3                   	ret    

0000048f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48f:	55                   	push   %ebp
 490:	89 e5                	mov    %esp,%ebp
 492:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 495:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49c:	8d 45 0c             	lea    0xc(%ebp),%eax
 49f:	83 c0 04             	add    $0x4,%eax
 4a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ac:	e9 7c 01 00 00       	jmp    62d <printf+0x19e>
    c = fmt[i] & 0xff;
 4b1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b7:	01 d0                	add    %edx,%eax
 4b9:	0f b6 00             	movzbl (%eax),%eax
 4bc:	0f be c0             	movsbl %al,%eax
 4bf:	25 ff 00 00 00       	and    $0xff,%eax
 4c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cb:	75 2c                	jne    4f9 <printf+0x6a>
      if(c == '%'){
 4cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d1:	75 0c                	jne    4df <printf+0x50>
        state = '%';
 4d3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4da:	e9 4a 01 00 00       	jmp    629 <printf+0x19a>
      } else {
        putc(fd, c);
 4df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e2:	0f be c0             	movsbl %al,%eax
 4e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	89 04 24             	mov    %eax,(%esp)
 4ef:	e8 bb fe ff ff       	call   3af <putc>
 4f4:	e9 30 01 00 00       	jmp    629 <printf+0x19a>
      }
    } else if(state == '%'){
 4f9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fd:	0f 85 26 01 00 00    	jne    629 <printf+0x19a>
      if(c == 'd'){
 503:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 507:	75 2d                	jne    536 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 509:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50c:	8b 00                	mov    (%eax),%eax
 50e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 515:	00 
 516:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 51d:	00 
 51e:	89 44 24 04          	mov    %eax,0x4(%esp)
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	89 04 24             	mov    %eax,(%esp)
 528:	e8 aa fe ff ff       	call   3d7 <printint>
        ap++;
 52d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 531:	e9 ec 00 00 00       	jmp    622 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 536:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 53a:	74 06                	je     542 <printf+0xb3>
 53c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 540:	75 2d                	jne    56f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 00                	mov    (%eax),%eax
 547:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 54e:	00 
 54f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 556:	00 
 557:	89 44 24 04          	mov    %eax,0x4(%esp)
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	89 04 24             	mov    %eax,(%esp)
 561:	e8 71 fe ff ff       	call   3d7 <printint>
        ap++;
 566:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56a:	e9 b3 00 00 00       	jmp    622 <printf+0x193>
      } else if(c == 's'){
 56f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 573:	75 45                	jne    5ba <printf+0x12b>
        s = (char*)*ap;
 575:	8b 45 e8             	mov    -0x18(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 57d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 585:	75 09                	jne    590 <printf+0x101>
          s = "(null)";
 587:	c7 45 f4 b5 0e 00 00 	movl   $0xeb5,-0xc(%ebp)
        while(*s != 0){
 58e:	eb 1e                	jmp    5ae <printf+0x11f>
 590:	eb 1c                	jmp    5ae <printf+0x11f>
          putc(fd, *s);
 592:	8b 45 f4             	mov    -0xc(%ebp),%eax
 595:	0f b6 00             	movzbl (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	89 44 24 04          	mov    %eax,0x4(%esp)
 59f:	8b 45 08             	mov    0x8(%ebp),%eax
 5a2:	89 04 24             	mov    %eax,(%esp)
 5a5:	e8 05 fe ff ff       	call   3af <putc>
          s++;
 5aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b1:	0f b6 00             	movzbl (%eax),%eax
 5b4:	84 c0                	test   %al,%al
 5b6:	75 da                	jne    592 <printf+0x103>
 5b8:	eb 68                	jmp    622 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ba:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5be:	75 1d                	jne    5dd <printf+0x14e>
        putc(fd, *ap);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 d8 fd ff ff       	call   3af <putc>
        ap++;
 5d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5db:	eb 45                	jmp    622 <printf+0x193>
      } else if(c == '%'){
 5dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e1:	75 17                	jne    5fa <printf+0x16b>
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ed:	8b 45 08             	mov    0x8(%ebp),%eax
 5f0:	89 04 24             	mov    %eax,(%esp)
 5f3:	e8 b7 fd ff ff       	call   3af <putc>
 5f8:	eb 28                	jmp    622 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fa:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 601:	00 
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	89 04 24             	mov    %eax,(%esp)
 608:	e8 a2 fd ff ff       	call   3af <putc>
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 8d fd ff ff       	call   3af <putc>
      }
      state = 0;
 622:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 629:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 62d:	8b 55 0c             	mov    0xc(%ebp),%edx
 630:	8b 45 f0             	mov    -0x10(%ebp),%eax
 633:	01 d0                	add    %edx,%eax
 635:	0f b6 00             	movzbl (%eax),%eax
 638:	84 c0                	test   %al,%al
 63a:	0f 85 71 fe ff ff    	jne    4b1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 640:	c9                   	leave  
 641:	c3                   	ret    

00000642 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 642:	55                   	push   %ebp
 643:	89 e5                	mov    %esp,%ebp
 645:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	83 e8 08             	sub    $0x8,%eax
 64e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	a1 68 13 00 00       	mov    0x1368,%eax
 656:	89 45 fc             	mov    %eax,-0x4(%ebp)
 659:	eb 24                	jmp    67f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 00                	mov    (%eax),%eax
 660:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 663:	77 12                	ja     677 <free+0x35>
 665:	8b 45 f8             	mov    -0x8(%ebp),%eax
 668:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66b:	77 24                	ja     691 <free+0x4f>
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 675:	77 1a                	ja     691 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 685:	76 d4                	jbe    65b <free+0x19>
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68f:	76 ca                	jbe    65b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 40 04             	mov    0x4(%eax),%eax
 697:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	01 c2                	add    %eax,%edx
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	39 c2                	cmp    %eax,%edx
 6aa:	75 24                	jne    6d0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 50 04             	mov    0x4(%eax),%edx
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	8b 40 04             	mov    0x4(%eax),%eax
 6ba:	01 c2                	add    %eax,%edx
 6bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bf:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	8b 10                	mov    (%eax),%edx
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	89 10                	mov    %edx,(%eax)
 6ce:	eb 0a                	jmp    6da <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 10                	mov    (%eax),%edx
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 40 04             	mov    0x4(%eax),%eax
 6e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	01 d0                	add    %edx,%eax
 6ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ef:	75 20                	jne    711 <free+0xcf>
    p->s.size += bp->s.size;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 50 04             	mov    0x4(%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	01 c2                	add    %eax,%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	8b 10                	mov    (%eax),%edx
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	89 10                	mov    %edx,(%eax)
 70f:	eb 08                	jmp    719 <free+0xd7>
  } else
    p->s.ptr = bp;
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 55 f8             	mov    -0x8(%ebp),%edx
 717:	89 10                	mov    %edx,(%eax)
  freep = p;
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	a3 68 13 00 00       	mov    %eax,0x1368
}
 721:	c9                   	leave  
 722:	c3                   	ret    

00000723 <morecore>:

static Header*
morecore(uint nu)
{
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 729:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 730:	77 07                	ja     739 <morecore+0x16>
    nu = 4096;
 732:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	c1 e0 03             	shl    $0x3,%eax
 73f:	89 04 24             	mov    %eax,(%esp)
 742:	e8 50 fc ff ff       	call   397 <sbrk>
 747:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74e:	75 07                	jne    757 <morecore+0x34>
    return 0;
 750:	b8 00 00 00 00       	mov    $0x0,%eax
 755:	eb 22                	jmp    779 <morecore+0x56>
  hp = (Header*)p;
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	8b 55 08             	mov    0x8(%ebp),%edx
 763:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	83 c0 08             	add    $0x8,%eax
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 ce fe ff ff       	call   642 <free>
  return freep;
 774:	a1 68 13 00 00       	mov    0x1368,%eax
}
 779:	c9                   	leave  
 77a:	c3                   	ret    

0000077b <malloc>:

void*
malloc(uint nbytes)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 781:	8b 45 08             	mov    0x8(%ebp),%eax
 784:	83 c0 07             	add    $0x7,%eax
 787:	c1 e8 03             	shr    $0x3,%eax
 78a:	83 c0 01             	add    $0x1,%eax
 78d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 790:	a1 68 13 00 00       	mov    0x1368,%eax
 795:	89 45 f0             	mov    %eax,-0x10(%ebp)
 798:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 79c:	75 23                	jne    7c1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 79e:	c7 45 f0 60 13 00 00 	movl   $0x1360,-0x10(%ebp)
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	a3 68 13 00 00       	mov    %eax,0x1368
 7ad:	a1 68 13 00 00       	mov    0x1368,%eax
 7b2:	a3 60 13 00 00       	mov    %eax,0x1360
    base.s.size = 0;
 7b7:	c7 05 64 13 00 00 00 	movl   $0x0,0x1364
 7be:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d2:	72 4d                	jb     821 <malloc+0xa6>
      if(p->s.size == nunits)
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7dd:	75 0c                	jne    7eb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 10                	mov    (%eax),%edx
 7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e7:	89 10                	mov    %edx,(%eax)
 7e9:	eb 26                	jmp    811 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f4:	89 c2                	mov    %eax,%edx
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	c1 e0 03             	shl    $0x3,%eax
 805:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	a3 68 13 00 00       	mov    %eax,0x1368
      return (void*)(p + 1);
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	83 c0 08             	add    $0x8,%eax
 81f:	eb 38                	jmp    859 <malloc+0xde>
    }
    if(p == freep)
 821:	a1 68 13 00 00       	mov    0x1368,%eax
 826:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 829:	75 1b                	jne    846 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 82b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82e:	89 04 24             	mov    %eax,(%esp)
 831:	e8 ed fe ff ff       	call   723 <morecore>
 836:	89 45 f4             	mov    %eax,-0xc(%ebp)
 839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83d:	75 07                	jne    846 <malloc+0xcb>
        return 0;
 83f:	b8 00 00 00 00       	mov    $0x0,%eax
 844:	eb 13                	jmp    859 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 00                	mov    (%eax),%eax
 851:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 854:	e9 70 ff ff ff       	jmp    7c9 <malloc+0x4e>
}
 859:	c9                   	leave  
 85a:	c3                   	ret    

0000085b <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 85b:	55                   	push   %ebp
 85c:	89 e5                	mov    %esp,%ebp
 85e:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 861:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 868:	eb 17                	jmp    881 <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 874:	85 c0                	test   %eax,%eax
 876:	75 05                	jne    87d <findNextFreeThreadId+0x22>
			return i;
 878:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87b:	eb 0f                	jmp    88c <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 87d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 881:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 885:	7e e3                	jle    86a <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 88c:	c9                   	leave  
 88d:	c3                   	ret    

0000088e <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 88e:	55                   	push   %ebp
 88f:	89 e5                	mov    %esp,%ebp
 891:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 894:	a1 80 14 00 00       	mov    0x1480,%eax
 899:	8b 00                	mov    (%eax),%eax
 89b:	8d 50 01             	lea    0x1(%eax),%edx
 89e:	89 d0                	mov    %edx,%eax
 8a0:	c1 f8 1f             	sar    $0x1f,%eax
 8a3:	c1 e8 1a             	shr    $0x1a,%eax
 8a6:	01 c2                	add    %eax,%edx
 8a8:	83 e2 3f             	and    $0x3f,%edx
 8ab:	29 c2                	sub    %eax,%edx
 8ad:	89 d0                	mov    %edx,%eax
 8af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 8b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b5:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 8bc:	8b 40 28             	mov    0x28(%eax),%eax
 8bf:	83 f8 02             	cmp    $0x2,%eax
 8c2:	75 0c                	jne    8d0 <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 8ce:	eb 1c                	jmp    8ec <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8d 50 01             	lea    0x1(%eax),%edx
 8d6:	89 d0                	mov    %edx,%eax
 8d8:	c1 f8 1f             	sar    $0x1f,%eax
 8db:	c1 e8 1a             	shr    $0x1a,%eax
 8de:	01 c2                	add    %eax,%edx
 8e0:	83 e2 3f             	and    $0x3f,%edx
 8e3:	29 c2                	sub    %eax,%edx
 8e5:	89 d0                	mov    %edx,%eax
 8e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 8ea:	eb c6                	jmp    8b2 <findNextRunnableThread+0x24>
}
 8ec:	c9                   	leave  
 8ed:	c3                   	ret    

000008ee <uthread_init>:

void uthread_init(void)
{
 8ee:	55                   	push   %ebp
 8ef:	89 e5                	mov    %esp,%ebp
 8f1:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 8f4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 8fb:	eb 12                	jmp    90f <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	c7 04 85 80 13 00 00 	movl   $0x0,0x1380(,%eax,4)
 907:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 90b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 90f:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 913:	7e e8                	jle    8fd <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 915:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 91c:	e8 5a fe ff ff       	call   77b <malloc>
 921:	a3 80 13 00 00       	mov    %eax,0x1380
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 926:	a1 80 13 00 00       	mov    0x1380,%eax
 92b:	89 e2                	mov    %esp,%edx
 92d:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 930:	a1 80 13 00 00       	mov    0x1380,%eax
 935:	89 ea                	mov    %ebp,%edx
 937:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 93a:	a1 80 13 00 00       	mov    0x1380,%eax
 93f:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 946:	a1 80 13 00 00       	mov    0x1380,%eax
 94b:	a3 80 14 00 00       	mov    %eax,0x1480
	threadTable.threadCount = 1;
 950:	c7 05 84 14 00 00 01 	movl   $0x1,0x1484
 957:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 95a:	c7 44 24 04 33 0b 00 	movl   $0xb33,0x4(%esp)
 961:	00 
 962:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 969:	e8 99 f9 ff ff       	call   307 <signal>
	alarm(UTHREAD_QUANTA);
 96e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 975:	e8 9d f9 ff ff       	call   317 <alarm>
}
 97a:	c9                   	leave  
 97b:	c3                   	ret    

0000097c <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 97c:	55                   	push   %ebp
 97d:	89 e5                	mov    %esp,%ebp
 97f:	53                   	push   %ebx
 980:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 983:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 98a:	e8 88 f9 ff ff       	call   317 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 98f:	e8 c7 fe ff ff       	call   85b <findNextFreeThreadId>
 994:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 997:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99b:	75 0a                	jne    9a7 <uthread_create+0x2b>
		return -1;
 99d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9a2:	e9 d6 00 00 00       	jmp    a7d <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 9a7:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 9ae:	e8 c8 fd ff ff       	call   77b <malloc>
 9b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9b6:	89 04 95 80 13 00 00 	mov    %eax,0x1380(,%edx,4)
	threadTable.threads[current]->tid = current;
 9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c0:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 9c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9ca:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 9cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cf:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 9d6:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 9dd:	a1 84 14 00 00       	mov    0x1484,%eax
 9e2:	83 c0 01             	add    $0x1,%eax
 9e5:	a3 84 14 00 00       	mov    %eax,0x1484
	threadTable.threads[current]->entry = func;
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 9f4:	8b 55 08             	mov    0x8(%ebp),%edx
 9f7:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 9fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fd:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 a04:	8b 55 0c             	mov    0xc(%ebp),%edx
 a07:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	8b 1c 85 80 13 00 00 	mov    0x1380(,%eax,4),%ebx
 a14:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 a1b:	e8 5b fd ff ff       	call   77b <malloc>
 a20:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a26:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a30:	8b 14 95 80 13 00 00 	mov    0x1380(,%edx,4),%edx
 a37:	8b 52 24             	mov    0x24(%edx),%edx
 a3a:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 a40:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a46:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a50:	8b 14 95 80 13 00 00 	mov    0x1380(,%edx,4),%edx
 a57:	8b 52 04             	mov    0x4(%edx),%edx
 a5a:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a60:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 a67:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 a6e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a75:	e8 9d f8 ff ff       	call   317 <alarm>
	return current;
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 a7d:	83 c4 24             	add    $0x24,%esp
 a80:	5b                   	pop    %ebx
 a81:	5d                   	pop    %ebp
 a82:	c3                   	ret    

00000a83 <uthread_exit>:

void uthread_exit(void)
{
 a83:	55                   	push   %ebp
 a84:	89 e5                	mov    %esp,%ebp
 a86:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 a89:	a1 80 14 00 00       	mov    0x1480,%eax
 a8e:	8b 00                	mov    (%eax),%eax
 a90:	85 c0                	test   %eax,%eax
 a92:	74 10                	je     aa4 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 a94:	a1 80 14 00 00       	mov    0x1480,%eax
 a99:	8b 40 24             	mov    0x24(%eax),%eax
 a9c:	89 04 24             	mov    %eax,(%esp)
 a9f:	e8 9e fb ff ff       	call   642 <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 aa4:	a1 80 14 00 00       	mov    0x1480,%eax
 aa9:	8b 00                	mov    (%eax),%eax
 aab:	c7 04 85 80 13 00 00 	movl   $0x0,0x1380(,%eax,4)
 ab2:	00 00 00 00 
	
	free(threadTable.runningThread);
 ab6:	a1 80 14 00 00       	mov    0x1480,%eax
 abb:	89 04 24             	mov    %eax,(%esp)
 abe:	e8 7f fb ff ff       	call   642 <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 ac3:	a1 84 14 00 00       	mov    0x1484,%eax
 ac8:	83 e8 01             	sub    $0x1,%eax
 acb:	a3 84 14 00 00       	mov    %eax,0x1484
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 ad0:	a1 84 14 00 00       	mov    0x1484,%eax
 ad5:	85 c0                	test   %eax,%eax
 ad7:	75 05                	jne    ade <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 ad9:	e8 19 f8 ff ff       	call   2f7 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 ade:	e8 ab fd ff ff       	call   88e <findNextRunnableThread>
 ae3:	a3 80 14 00 00       	mov    %eax,0x1480
	
	threadTable.runningThread->state = T_RUNNING;
 ae8:	a1 80 14 00 00       	mov    0x1480,%eax
 aed:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 af4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 afb:	e8 17 f8 ff ff       	call   317 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b00:	a1 80 14 00 00       	mov    0x1480,%eax
 b05:	8b 40 04             	mov    0x4(%eax),%eax
 b08:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b0a:	a1 80 14 00 00       	mov    0x1480,%eax
 b0f:	8b 40 08             	mov    0x8(%eax),%eax
 b12:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 b14:	a1 80 14 00 00       	mov    0x1480,%eax
 b19:	8b 40 2c             	mov    0x2c(%eax),%eax
 b1c:	85 c0                	test   %eax,%eax
 b1e:	74 11                	je     b31 <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 b20:	a1 80 14 00 00       	mov    0x1480,%eax
 b25:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 b2c:	e8 8e 00 00 00       	call   bbf <wrapper>
	}
	

}
 b31:	c9                   	leave  
 b32:	c3                   	ret    

00000b33 <uthread_yield>:

void uthread_yield(void)
{
 b33:	55                   	push   %ebp
 b34:	89 e5                	mov    %esp,%ebp
 b36:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 b39:	a1 80 14 00 00       	mov    0x1480,%eax
 b3e:	89 e2                	mov    %esp,%edx
 b40:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 b43:	a1 80 14 00 00       	mov    0x1480,%eax
 b48:	89 ea                	mov    %ebp,%edx
 b4a:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 b4d:	a1 80 14 00 00       	mov    0x1480,%eax
 b52:	8b 40 28             	mov    0x28(%eax),%eax
 b55:	83 f8 01             	cmp    $0x1,%eax
 b58:	75 0c                	jne    b66 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 b5a:	a1 80 14 00 00       	mov    0x1480,%eax
 b5f:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 b66:	e8 23 fd ff ff       	call   88e <findNextRunnableThread>
 b6b:	a3 80 14 00 00       	mov    %eax,0x1480
	threadTable.runningThread->state = T_RUNNING;
 b70:	a1 80 14 00 00       	mov    0x1480,%eax
 b75:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 b7c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b83:	e8 8f f7 ff ff       	call   317 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b88:	a1 80 14 00 00       	mov    0x1480,%eax
 b8d:	8b 40 04             	mov    0x4(%eax),%eax
 b90:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b92:	a1 80 14 00 00       	mov    0x1480,%eax
 b97:	8b 40 08             	mov    0x8(%eax),%eax
 b9a:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 b9c:	a1 80 14 00 00       	mov    0x1480,%eax
 ba1:	8b 40 2c             	mov    0x2c(%eax),%eax
 ba4:	85 c0                	test   %eax,%eax
 ba6:	74 14                	je     bbc <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 ba8:	a1 80 14 00 00       	mov    0x1480,%eax
 bad:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 bb4:	b8 bf 0b 00 00       	mov    $0xbbf,%eax
 bb9:	ff d0                	call   *%eax
		asm("ret");
 bbb:	c3                   	ret    
	}
	return;
 bbc:	90                   	nop
}
 bbd:	c9                   	leave  
 bbe:	c3                   	ret    

00000bbf <wrapper>:

void wrapper(void) {
 bbf:	55                   	push   %ebp
 bc0:	89 e5                	mov    %esp,%ebp
 bc2:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 bc5:	a1 80 14 00 00       	mov    0x1480,%eax
 bca:	8b 40 30             	mov    0x30(%eax),%eax
 bcd:	8b 15 80 14 00 00    	mov    0x1480,%edx
 bd3:	8b 52 34             	mov    0x34(%edx),%edx
 bd6:	89 14 24             	mov    %edx,(%esp)
 bd9:	ff d0                	call   *%eax
	uthread_exit();
 bdb:	e8 a3 fe ff ff       	call   a83 <uthread_exit>
}
 be0:	c9                   	leave  
 be1:	c3                   	ret    

00000be2 <uthread_self>:

int uthread_self(void)
{
 be2:	55                   	push   %ebp
 be3:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 be5:	a1 80 14 00 00       	mov    0x1480,%eax
 bea:	8b 00                	mov    (%eax),%eax
}
 bec:	5d                   	pop    %ebp
 bed:	c3                   	ret    

00000bee <uthread_join>:

int uthread_join(int tid)
{
 bee:	55                   	push   %ebp
 bef:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 bf1:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 bf5:	7e 07                	jle    bfe <uthread_join+0x10>
		return -1;
 bf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 bfc:	eb 14                	jmp    c12 <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 bfe:	90                   	nop
 bff:	8b 45 08             	mov    0x8(%ebp),%eax
 c02:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 c09:	85 c0                	test   %eax,%eax
 c0b:	75 f2                	jne    bff <uthread_join+0x11>
	return 0;
 c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 c12:	5d                   	pop    %ebp
 c13:	c3                   	ret    

00000c14 <uthread_sleep>:

void uthread_sleep(void)
{
 c14:	55                   	push   %ebp
 c15:	89 e5                	mov    %esp,%ebp
 c17:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 c1a:	a1 80 14 00 00       	mov    0x1480,%eax
 c1f:	89 e2                	mov    %esp,%edx
 c21:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 c24:	a1 80 14 00 00       	mov    0x1480,%eax
 c29:	89 ea                	mov    %ebp,%edx
 c2b:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 c2e:	a1 80 14 00 00       	mov    0x1480,%eax
 c33:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 c3a:	a1 80 14 00 00       	mov    0x1480,%eax
 c3f:	8b 00                	mov    (%eax),%eax
 c41:	89 44 24 08          	mov    %eax,0x8(%esp)
 c45:	c7 44 24 04 bc 0e 00 	movl   $0xebc,0x4(%esp)
 c4c:	00 
 c4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c54:	e8 36 f8 ff ff       	call   48f <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 c59:	e8 30 fc ff ff       	call   88e <findNextRunnableThread>
 c5e:	a3 80 14 00 00       	mov    %eax,0x1480
	threadTable.runningThread->state = T_RUNNING;
 c63:	a1 80 14 00 00       	mov    0x1480,%eax
 c68:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 c6f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c76:	e8 9c f6 ff ff       	call   317 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 c7b:	a1 80 14 00 00       	mov    0x1480,%eax
 c80:	8b 40 08             	mov    0x8(%eax),%eax
 c83:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 c85:	a1 80 14 00 00       	mov    0x1480,%eax
 c8a:	8b 40 04             	mov    0x4(%eax),%eax
 c8d:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 c8f:	a1 80 14 00 00       	mov    0x1480,%eax
 c94:	8b 40 2c             	mov    0x2c(%eax),%eax
 c97:	85 c0                	test   %eax,%eax
 c99:	74 14                	je     caf <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 c9b:	a1 80 14 00 00       	mov    0x1480,%eax
 ca0:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 ca7:	b8 bf 0b 00 00       	mov    $0xbbf,%eax
 cac:	ff d0                	call   *%eax
		asm("ret");
 cae:	c3                   	ret    
	}
	return;	
 caf:	90                   	nop
}
 cb0:	c9                   	leave  
 cb1:	c3                   	ret    

00000cb2 <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 cb2:	55                   	push   %ebp
 cb3:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 cb5:	8b 45 08             	mov    0x8(%ebp),%eax
 cb8:	8b 04 85 80 13 00 00 	mov    0x1380(,%eax,4),%eax
 cbf:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 cc6:	5d                   	pop    %ebp
 cc7:	c3                   	ret    

00000cc8 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 cc8:	55                   	push   %ebp
 cc9:	89 e5                	mov    %esp,%ebp
 ccb:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 cce:	c7 44 24 04 d7 0e 00 	movl   $0xed7,0x4(%esp)
 cd5:	00 
 cd6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cdd:	e8 ad f7 ff ff       	call   48f <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 ce2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 ce9:	eb 26                	jmp    d11 <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 ceb:	8b 45 08             	mov    0x8(%ebp),%eax
 cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cf1:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
 cf9:	c7 44 24 04 ee 0e 00 	movl   $0xeee,0x4(%esp)
 d00:	00 
 d01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d08:	e8 82 f7 ff ff       	call   48f <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 d11:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 d15:	7e d4                	jle    ceb <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 d17:	c7 44 24 04 f2 0e 00 	movl   $0xef2,0x4(%esp)
 d1e:	00 
 d1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d26:	e8 64 f7 ff ff       	call   48f <printf>
}
 d2b:	c9                   	leave  
 d2c:	c3                   	ret    

00000d2d <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 d2d:	55                   	push   %ebp
 d2e:	89 e5                	mov    %esp,%ebp
 d30:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 d33:	8b 45 08             	mov    0x8(%ebp),%eax
 d36:	8b 55 0c             	mov    0xc(%ebp),%edx
 d39:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 d3b:	8b 45 08             	mov    0x8(%ebp),%eax
 d3e:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 d45:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 d4f:	eb 12                	jmp    d63 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 d51:	8b 45 08             	mov    0x8(%ebp),%eax
 d54:	8b 55 fc             	mov    -0x4(%ebp),%edx
 d57:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 d5e:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d5f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 d63:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 d67:	7e e8                	jle    d51 <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 d69:	c9                   	leave  
 d6a:	c3                   	ret    

00000d6b <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 d6b:	55                   	push   %ebp
 d6c:	89 e5                	mov    %esp,%ebp
 d6e:	53                   	push   %ebx
 d6f:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 d72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 d79:	e8 99 f5 ff ff       	call   317 <alarm>
	if (semaphore->value ==0){
 d7e:	8b 45 08             	mov    0x8(%ebp),%eax
 d81:	8b 00                	mov    (%eax),%eax
 d83:	85 c0                	test   %eax,%eax
 d85:	75 34                	jne    dbb <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 d87:	a1 80 14 00 00       	mov    0x1480,%eax
 d8c:	8b 08                	mov    (%eax),%ecx
 d8e:	8b 45 08             	mov    0x8(%ebp),%eax
 d91:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 d97:	8d 58 01             	lea    0x1(%eax),%ebx
 d9a:	8b 55 08             	mov    0x8(%ebp),%edx
 d9d:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 da3:	8b 55 08             	mov    0x8(%ebp),%edx
 da6:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 daa:	a1 80 14 00 00       	mov    0x1480,%eax
 daf:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 db6:	e8 78 fd ff ff       	call   b33 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 dbb:	a1 80 14 00 00       	mov    0x1480,%eax
 dc0:	8b 10                	mov    (%eax),%edx
 dc2:	8b 45 08             	mov    0x8(%ebp),%eax
 dc5:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 dcc:	ff 
	semaphore->value = 0;
 dcd:	8b 45 08             	mov    0x8(%ebp),%eax
 dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 dd6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ddd:	e8 35 f5 ff ff       	call   317 <alarm>
}
 de2:	83 c4 14             	add    $0x14,%esp
 de5:	5b                   	pop    %ebx
 de6:	5d                   	pop    %ebp
 de7:	c3                   	ret    

00000de8 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 de8:	55                   	push   %ebp
 de9:	89 e5                	mov    %esp,%ebp
 deb:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 dee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 df5:	e8 1d f5 ff ff       	call   317 <alarm>
	
	if (semaphore->value == 0){
 dfa:	8b 45 08             	mov    0x8(%ebp),%eax
 dfd:	8b 00                	mov    (%eax),%eax
 dff:	85 c0                	test   %eax,%eax
 e01:	75 71                	jne    e74 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 e03:	8b 45 08             	mov    0x8(%ebp),%eax
 e06:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 e0f:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 e16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 e1d:	eb 35                	jmp    e54 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 e1f:	8b 45 08             	mov    0x8(%ebp),%eax
 e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e25:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e29:	83 f8 ff             	cmp    $0xffffffff,%eax
 e2c:	74 22                	je     e50 <binary_semaphore_up+0x68>
 e2e:	8b 45 08             	mov    0x8(%ebp),%eax
 e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e34:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 e3b:	7d 13                	jge    e50 <binary_semaphore_up+0x68>
				minIndex = i;
 e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e40:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 e43:	8b 45 08             	mov    0x8(%ebp),%eax
 e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e49:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 e50:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 e54:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 e58:	7e c5                	jle    e1f <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 e5a:	8b 45 08             	mov    0x8(%ebp),%eax
 e5d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 e63:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 e67:	74 0b                	je     e74 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e6c:	89 04 24             	mov    %eax,(%esp)
 e6f:	e8 3e fe ff ff       	call   cb2 <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 e74:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e7b:	e8 97 f4 ff ff       	call   317 <alarm>
	
 e80:	c9                   	leave  
 e81:	c3                   	ret    
