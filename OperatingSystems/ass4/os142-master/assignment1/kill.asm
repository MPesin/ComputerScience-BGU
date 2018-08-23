
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
   f:	c7 44 24 04 13 08 00 	movl   $0x813,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 2c 04 00 00       	call   44f <printf>
    exit();
  23:	e8 a0 02 00 00       	call   2c8 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 21                	jmp    53 <main+0x53>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	03 45 0c             	add    0xc(%ebp),%eax
  3c:	8b 00                	mov    (%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 f1 01 00 00       	call   237 <atoi>
  46:	89 04 24             	mov    %eax,(%esp)
  49:	e8 ba 02 00 00       	call   308 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  4e:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  53:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  57:	3b 45 08             	cmp    0x8(%ebp),%eax
  5a:	7c d6                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  5c:	e8 67 02 00 00       	call   2c8 <exit>
  61:	90                   	nop
  62:	90                   	nop
  63:	90                   	nop

00000064 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	57                   	push   %edi
  68:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	8b 55 10             	mov    0x10(%ebp),%edx
  6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  72:	89 cb                	mov    %ecx,%ebx
  74:	89 df                	mov    %ebx,%edi
  76:	89 d1                	mov    %edx,%ecx
  78:	fc                   	cld    
  79:	f3 aa                	rep stos %al,%es:(%edi)
  7b:	89 ca                	mov    %ecx,%edx
  7d:	89 fb                	mov    %edi,%ebx
  7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  82:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  85:	5b                   	pop    %ebx
  86:	5f                   	pop    %edi
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    

00000089 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  8c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  95:	90                   	nop
  96:	8b 45 0c             	mov    0xc(%ebp),%eax
  99:	0f b6 10             	movzbl (%eax),%edx
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	88 10                	mov    %dl,(%eax)
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	84 c0                	test   %al,%al
  a9:	0f 95 c0             	setne  %al
  ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b4:	84 c0                	test   %al,%al
  b6:	75 de                	jne    96 <strcpy+0xd>
    ;
  return os;
  b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bb:	c9                   	leave  
  bc:	c3                   	ret    

000000bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c0:	eb 08                	jmp    ca <strcmp+0xd>
    p++, q++;
  c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	0f b6 00             	movzbl (%eax),%eax
  d0:	84 c0                	test   %al,%al
  d2:	74 10                	je     e4 <strcmp+0x27>
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 10             	movzbl (%eax),%edx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	0f b6 00             	movzbl (%eax),%eax
  e0:	38 c2                	cmp    %al,%dl
  e2:	74 de                	je     c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	0f b6 d0             	movzbl %al,%edx
  ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  f0:	0f b6 00             	movzbl (%eax),%eax
  f3:	0f b6 c0             	movzbl %al,%eax
  f6:	89 d1                	mov    %edx,%ecx
  f8:	29 c1                	sub    %eax,%ecx
  fa:	89 c8                	mov    %ecx,%eax
}
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    

000000fe <strlen>:

uint
strlen(char *s)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 104:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10b:	eb 04                	jmp    111 <strlen+0x13>
 10d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 111:	8b 45 fc             	mov    -0x4(%ebp),%eax
 114:	03 45 08             	add    0x8(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	84 c0                	test   %al,%al
 11c:	75 ef                	jne    10d <strlen+0xf>
    ;
  return n;
 11e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 121:	c9                   	leave  
 122:	c3                   	ret    

00000123 <memset>:

void*
memset(void *dst, int c, uint n)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 129:	8b 45 10             	mov    0x10(%ebp),%eax
 12c:	89 44 24 08          	mov    %eax,0x8(%esp)
 130:	8b 45 0c             	mov    0xc(%ebp),%eax
 133:	89 44 24 04          	mov    %eax,0x4(%esp)
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	89 04 24             	mov    %eax,(%esp)
 13d:	e8 22 ff ff ff       	call   64 <stosb>
  return dst;
 142:	8b 45 08             	mov    0x8(%ebp),%eax
}
 145:	c9                   	leave  
 146:	c3                   	ret    

00000147 <strchr>:

char*
strchr(const char *s, char c)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 04             	sub    $0x4,%esp
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 153:	eb 14                	jmp    169 <strchr+0x22>
    if(*s == c)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15e:	75 05                	jne    165 <strchr+0x1e>
      return (char*)s;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	eb 13                	jmp    178 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 165:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	84 c0                	test   %al,%al
 171:	75 e2                	jne    155 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 173:	b8 00 00 00 00       	mov    $0x0,%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <gets>:

char*
gets(char *buf, int max)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 187:	eb 44                	jmp    1cd <gets+0x53>
    cc = read(0, &c, 1);
 189:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 190:	00 
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	89 44 24 04          	mov    %eax,0x4(%esp)
 198:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19f:	e8 4c 01 00 00       	call   2f0 <read>
 1a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ab:	7e 2d                	jle    1da <gets+0x60>
      break;
    buf[i++] = c;
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	03 45 08             	add    0x8(%ebp),%eax
 1b3:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1b7:	88 10                	mov    %dl,(%eax)
 1b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c1:	3c 0a                	cmp    $0xa,%al
 1c3:	74 16                	je     1db <gets+0x61>
 1c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c9:	3c 0d                	cmp    $0xd,%al
 1cb:	74 0e                	je     1db <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d0:	83 c0 01             	add    $0x1,%eax
 1d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d6:	7c b1                	jl     189 <gets+0xf>
 1d8:	eb 01                	jmp    1db <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1da:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	03 45 08             	add    0x8(%ebp),%eax
 1e1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <stat>:

int
stat(char *n, struct stat *st)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f6:	00 
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	89 04 24             	mov    %eax,(%esp)
 1fd:	e8 16 01 00 00       	call   318 <open>
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x29>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 23                	jmp    235 <stat+0x4c>
  r = fstat(fd, st);
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	89 44 24 04          	mov    %eax,0x4(%esp)
 219:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 0c 01 00 00       	call   330 <fstat>
 224:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 227:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22a:	89 04 24             	mov    %eax,(%esp)
 22d:	e8 ce 00 00 00       	call   300 <close>
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 23                	jmp    269 <atoi+0x32>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c2                	mov    %eax,%edx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	0f be c0             	movsbl %al,%eax
 25d:	01 d0                	add    %edx,%eax
 25f:	83 e8 30             	sub    $0x30,%eax
 262:	89 45 fc             	mov    %eax,-0x4(%ebp)
 265:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	3c 2f                	cmp    $0x2f,%al
 271:	7e 0a                	jle    27d <atoi+0x46>
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	3c 39                	cmp    $0x39,%al
 27b:	7e c9                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 294:	eb 13                	jmp    2a9 <memmove+0x27>
    *dst++ = *src++;
 296:	8b 45 f8             	mov    -0x8(%ebp),%eax
 299:	0f b6 10             	movzbl (%eax),%edx
 29c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29f:	88 10                	mov    %dl,(%eax)
 2a1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2a5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ad:	0f 9f c0             	setg   %al
 2b0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2b4:	84 c0                	test   %al,%al
 2b6:	75 de                	jne    296 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    
 2bd:	90                   	nop
 2be:	90                   	nop
 2bf:	90                   	nop

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <wait2>:
SYSCALL(wait2)
 2d8:	b8 16 00 00 00       	mov    $0x16,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <add_path>:
SYSCALL(add_path)
 2e0:	b8 17 00 00 00       	mov    $0x17,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <pipe>:
SYSCALL(pipe)
 2e8:	b8 04 00 00 00       	mov    $0x4,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <read>:
SYSCALL(read)
 2f0:	b8 05 00 00 00       	mov    $0x5,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <write>:
SYSCALL(write)
 2f8:	b8 10 00 00 00       	mov    $0x10,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <close>:
SYSCALL(close)
 300:	b8 15 00 00 00       	mov    $0x15,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <kill>:
SYSCALL(kill)
 308:	b8 06 00 00 00       	mov    $0x6,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <exec>:
SYSCALL(exec)
 310:	b8 07 00 00 00       	mov    $0x7,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <open>:
SYSCALL(open)
 318:	b8 0f 00 00 00       	mov    $0xf,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <mknod>:
SYSCALL(mknod)
 320:	b8 11 00 00 00       	mov    $0x11,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <unlink>:
SYSCALL(unlink)
 328:	b8 12 00 00 00       	mov    $0x12,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <fstat>:
SYSCALL(fstat)
 330:	b8 08 00 00 00       	mov    $0x8,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <link>:
SYSCALL(link)
 338:	b8 13 00 00 00       	mov    $0x13,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <mkdir>:
SYSCALL(mkdir)
 340:	b8 14 00 00 00       	mov    $0x14,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <chdir>:
SYSCALL(chdir)
 348:	b8 09 00 00 00       	mov    $0x9,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <dup>:
SYSCALL(dup)
 350:	b8 0a 00 00 00       	mov    $0xa,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <getpid>:
SYSCALL(getpid)
 358:	b8 0b 00 00 00       	mov    $0xb,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <sbrk>:
SYSCALL(sbrk)
 360:	b8 0c 00 00 00       	mov    $0xc,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <sleep>:
SYSCALL(sleep)
 368:	b8 0d 00 00 00       	mov    $0xd,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <uptime>:
SYSCALL(uptime)
 370:	b8 0e 00 00 00       	mov    $0xe,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	83 ec 28             	sub    $0x28,%esp
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 384:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 38b:	00 
 38c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38f:	89 44 24 04          	mov    %eax,0x4(%esp)
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	89 04 24             	mov    %eax,(%esp)
 399:	e8 5a ff ff ff       	call   2f8 <write>
}
 39e:	c9                   	leave  
 39f:	c3                   	ret    

000003a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ad:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b1:	74 17                	je     3ca <printint+0x2a>
 3b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b7:	79 11                	jns    3ca <printint+0x2a>
    neg = 1;
 3b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c3:	f7 d8                	neg    %eax
 3c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c8:	eb 06                	jmp    3d0 <printint+0x30>
  } else {
    x = xx;
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3dd:	ba 00 00 00 00       	mov    $0x0,%edx
 3e2:	f7 f1                	div    %ecx
 3e4:	89 d0                	mov    %edx,%eax
 3e6:	0f b6 90 6c 0a 00 00 	movzbl 0xa6c(%eax),%edx
 3ed:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3f0:	03 45 f4             	add    -0xc(%ebp),%eax
 3f3:	88 10                	mov    %dl,(%eax)
 3f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3f9:	8b 55 10             	mov    0x10(%ebp),%edx
 3fc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 402:	ba 00 00 00 00       	mov    $0x0,%edx
 407:	f7 75 d4             	divl   -0x2c(%ebp)
 40a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 411:	75 c4                	jne    3d7 <printint+0x37>
  if(neg)
 413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 417:	74 2a                	je     443 <printint+0xa3>
    buf[i++] = '-';
 419:	8d 45 dc             	lea    -0x24(%ebp),%eax
 41c:	03 45 f4             	add    -0xc(%ebp),%eax
 41f:	c6 00 2d             	movb   $0x2d,(%eax)
 422:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 426:	eb 1b                	jmp    443 <printint+0xa3>
    putc(fd, buf[i]);
 428:	8d 45 dc             	lea    -0x24(%ebp),%eax
 42b:	03 45 f4             	add    -0xc(%ebp),%eax
 42e:	0f b6 00             	movzbl (%eax),%eax
 431:	0f be c0             	movsbl %al,%eax
 434:	89 44 24 04          	mov    %eax,0x4(%esp)
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	89 04 24             	mov    %eax,(%esp)
 43e:	e8 35 ff ff ff       	call   378 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 443:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44b:	79 db                	jns    428 <printint+0x88>
    putc(fd, buf[i]);
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 455:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45c:	8d 45 0c             	lea    0xc(%ebp),%eax
 45f:	83 c0 04             	add    $0x4,%eax
 462:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 465:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 46c:	e9 7d 01 00 00       	jmp    5ee <printf+0x19f>
    c = fmt[i] & 0xff;
 471:	8b 55 0c             	mov    0xc(%ebp),%edx
 474:	8b 45 f0             	mov    -0x10(%ebp),%eax
 477:	01 d0                	add    %edx,%eax
 479:	0f b6 00             	movzbl (%eax),%eax
 47c:	0f be c0             	movsbl %al,%eax
 47f:	25 ff 00 00 00       	and    $0xff,%eax
 484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48b:	75 2c                	jne    4b9 <printf+0x6a>
      if(c == '%'){
 48d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 491:	75 0c                	jne    49f <printf+0x50>
        state = '%';
 493:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49a:	e9 4b 01 00 00       	jmp    5ea <printf+0x19b>
      } else {
        putc(fd, c);
 49f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a2:	0f be c0             	movsbl %al,%eax
 4a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	89 04 24             	mov    %eax,(%esp)
 4af:	e8 c4 fe ff ff       	call   378 <putc>
 4b4:	e9 31 01 00 00       	jmp    5ea <printf+0x19b>
      }
    } else if(state == '%'){
 4b9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4bd:	0f 85 27 01 00 00    	jne    5ea <printf+0x19b>
      if(c == 'd'){
 4c3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c7:	75 2d                	jne    4f6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cc:	8b 00                	mov    (%eax),%eax
 4ce:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d5:	00 
 4d6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4dd:	00 
 4de:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	89 04 24             	mov    %eax,(%esp)
 4e8:	e8 b3 fe ff ff       	call   3a0 <printint>
        ap++;
 4ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f1:	e9 ed 00 00 00       	jmp    5e3 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4f6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fa:	74 06                	je     502 <printf+0xb3>
 4fc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 500:	75 2d                	jne    52f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 50e:	00 
 50f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 516:	00 
 517:	89 44 24 04          	mov    %eax,0x4(%esp)
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	89 04 24             	mov    %eax,(%esp)
 521:	e8 7a fe ff ff       	call   3a0 <printint>
        ap++;
 526:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52a:	e9 b4 00 00 00       	jmp    5e3 <printf+0x194>
      } else if(c == 's'){
 52f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 533:	75 46                	jne    57b <printf+0x12c>
        s = (char*)*ap;
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 545:	75 27                	jne    56e <printf+0x11f>
          s = "(null)";
 547:	c7 45 f4 27 08 00 00 	movl   $0x827,-0xc(%ebp)
        while(*s != 0){
 54e:	eb 1e                	jmp    56e <printf+0x11f>
          putc(fd, *s);
 550:	8b 45 f4             	mov    -0xc(%ebp),%eax
 553:	0f b6 00             	movzbl (%eax),%eax
 556:	0f be c0             	movsbl %al,%eax
 559:	89 44 24 04          	mov    %eax,0x4(%esp)
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	89 04 24             	mov    %eax,(%esp)
 563:	e8 10 fe ff ff       	call   378 <putc>
          s++;
 568:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 56c:	eb 01                	jmp    56f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56e:	90                   	nop
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	84 c0                	test   %al,%al
 577:	75 d7                	jne    550 <printf+0x101>
 579:	eb 68                	jmp    5e3 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57f:	75 1d                	jne    59e <printf+0x14f>
        putc(fd, *ap);
 581:	8b 45 e8             	mov    -0x18(%ebp),%eax
 584:	8b 00                	mov    (%eax),%eax
 586:	0f be c0             	movsbl %al,%eax
 589:	89 44 24 04          	mov    %eax,0x4(%esp)
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	89 04 24             	mov    %eax,(%esp)
 593:	e8 e0 fd ff ff       	call   378 <putc>
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59c:	eb 45                	jmp    5e3 <printf+0x194>
      } else if(c == '%'){
 59e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a2:	75 17                	jne    5bb <printf+0x16c>
        putc(fd, c);
 5a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a7:	0f be c0             	movsbl %al,%eax
 5aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 bf fd ff ff       	call   378 <putc>
 5b9:	eb 28                	jmp    5e3 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c2:	00 
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 aa fd ff ff       	call   378 <putc>
        putc(fd, c);
 5ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	89 04 24             	mov    %eax,(%esp)
 5de:	e8 95 fd ff ff       	call   378 <putc>
      }
      state = 0;
 5e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f4:	01 d0                	add    %edx,%eax
 5f6:	0f b6 00             	movzbl (%eax),%eax
 5f9:	84 c0                	test   %al,%al
 5fb:	0f 85 70 fe ff ff    	jne    471 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 601:	c9                   	leave  
 602:	c3                   	ret    
 603:	90                   	nop

00000604 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	83 e8 08             	sub    $0x8,%eax
 610:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	a1 88 0a 00 00       	mov    0xa88,%eax
 618:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61b:	eb 24                	jmp    641 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 12                	ja     639 <free+0x35>
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 24                	ja     653 <free+0x4f>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	77 1a                	ja     653 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	76 d4                	jbe    61d <free+0x19>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	76 ca                	jbe    61d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	c1 e0 03             	shl    $0x3,%eax
 65c:	89 c2                	mov    %eax,%edx
 65e:	03 55 f8             	add    -0x8(%ebp),%edx
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	39 c2                	cmp    %eax,%edx
 668:	75 24                	jne    68e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	8b 40 04             	mov    0x4(%eax),%eax
 678:	01 c2                	add    %eax,%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	8b 10                	mov    (%eax),%edx
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	89 10                	mov    %edx,(%eax)
 68c:	eb 0a                	jmp    698 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 40 04             	mov    0x4(%eax),%eax
 69e:	c1 e0 03             	shl    $0x3,%eax
 6a1:	03 45 fc             	add    -0x4(%ebp),%eax
 6a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a7:	75 20                	jne    6c9 <free+0xc5>
    p->s.size += bp->s.size;
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 50 04             	mov    0x4(%eax),%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	01 c2                	add    %eax,%edx
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	8b 10                	mov    (%eax),%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	89 10                	mov    %edx,(%eax)
 6c7:	eb 08                	jmp    6d1 <free+0xcd>
  } else
    p->s.ptr = bp;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6cf:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	a3 88 0a 00 00       	mov    %eax,0xa88
}
 6d9:	c9                   	leave  
 6da:	c3                   	ret    

000006db <morecore>:

static Header*
morecore(uint nu)
{
 6db:	55                   	push   %ebp
 6dc:	89 e5                	mov    %esp,%ebp
 6de:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e8:	77 07                	ja     6f1 <morecore+0x16>
    nu = 4096;
 6ea:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	c1 e0 03             	shl    $0x3,%eax
 6f7:	89 04 24             	mov    %eax,(%esp)
 6fa:	e8 61 fc ff ff       	call   360 <sbrk>
 6ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 702:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 706:	75 07                	jne    70f <morecore+0x34>
    return 0;
 708:	b8 00 00 00 00       	mov    $0x0,%eax
 70d:	eb 22                	jmp    731 <morecore+0x56>
  hp = (Header*)p;
 70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 712:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 715:	8b 45 f0             	mov    -0x10(%ebp),%eax
 718:	8b 55 08             	mov    0x8(%ebp),%edx
 71b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 721:	83 c0 08             	add    $0x8,%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 d8 fe ff ff       	call   604 <free>
  return freep;
 72c:	a1 88 0a 00 00       	mov    0xa88,%eax
}
 731:	c9                   	leave  
 732:	c3                   	ret    

00000733 <malloc>:

void*
malloc(uint nbytes)
{
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	83 c0 07             	add    $0x7,%eax
 73f:	c1 e8 03             	shr    $0x3,%eax
 742:	83 c0 01             	add    $0x1,%eax
 745:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 748:	a1 88 0a 00 00       	mov    0xa88,%eax
 74d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 750:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 754:	75 23                	jne    779 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 756:	c7 45 f0 80 0a 00 00 	movl   $0xa80,-0x10(%ebp)
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	a3 88 0a 00 00       	mov    %eax,0xa88
 765:	a1 88 0a 00 00       	mov    0xa88,%eax
 76a:	a3 80 0a 00 00       	mov    %eax,0xa80
    base.s.size = 0;
 76f:	c7 05 84 0a 00 00 00 	movl   $0x0,0xa84
 776:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 779:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78a:	72 4d                	jb     7d9 <malloc+0xa6>
      if(p->s.size == nunits)
 78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 795:	75 0c                	jne    7a3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	8b 10                	mov    (%eax),%edx
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	89 10                	mov    %edx,(%eax)
 7a1:	eb 26                	jmp    7c9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	89 c2                	mov    %eax,%edx
 7ab:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	c1 e0 03             	shl    $0x3,%eax
 7bd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	a3 88 0a 00 00       	mov    %eax,0xa88
      return (void*)(p + 1);
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	83 c0 08             	add    $0x8,%eax
 7d7:	eb 38                	jmp    811 <malloc+0xde>
    }
    if(p == freep)
 7d9:	a1 88 0a 00 00       	mov    0xa88,%eax
 7de:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7e1:	75 1b                	jne    7fe <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e6:	89 04 24             	mov    %eax,(%esp)
 7e9:	e8 ed fe ff ff       	call   6db <morecore>
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f5:	75 07                	jne    7fe <malloc+0xcb>
        return 0;
 7f7:	b8 00 00 00 00       	mov    $0x0,%eax
 7fc:	eb 13                	jmp    811 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 80c:	e9 70 ff ff ff       	jmp    781 <malloc+0x4e>
}
 811:	c9                   	leave  
 812:	c3                   	ret    
