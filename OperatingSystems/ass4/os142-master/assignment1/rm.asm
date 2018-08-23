
_rm:     file format elf32-i386


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
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 33 08 00 	movl   $0x833,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 4c 04 00 00       	call   46f <printf>
    exit();
  23:	e8 c0 02 00 00       	call   2e8 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 43                	jmp    75 <main+0x75>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	03 45 0c             	add    0xc(%ebp),%eax
  3c:	8b 00                	mov    (%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 02 03 00 00       	call   348 <unlink>
  46:	85 c0                	test   %eax,%eax
  48:	79 26                	jns    70 <main+0x70>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  4a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4e:	c1 e0 02             	shl    $0x2,%eax
  51:	03 45 0c             	add    0xc(%ebp),%eax
  54:	8b 00                	mov    (%eax),%eax
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	c7 44 24 04 47 08 00 	movl   $0x847,0x4(%esp)
  61:	00 
  62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  69:	e8 01 04 00 00       	call   46f <printf>
      break;
  6e:	eb 0e                	jmp    7e <main+0x7e>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  70:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  75:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  79:	3b 45 08             	cmp    0x8(%ebp),%eax
  7c:	7c b4                	jl     32 <main+0x32>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  7e:	e8 65 02 00 00       	call   2e8 <exit>
  83:	90                   	nop

00000084 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 10             	mov    0x10(%ebp),%edx
  8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  92:	89 cb                	mov    %ecx,%ebx
  94:	89 df                	mov    %ebx,%edi
  96:	89 d1                	mov    %edx,%ecx
  98:	fc                   	cld    
  99:	f3 aa                	rep stos %al,%es:(%edi)
  9b:	89 ca                	mov    %ecx,%edx
  9d:	89 fb                	mov    %edi,%ebx
  9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	90                   	nop
  b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  b9:	0f b6 10             	movzbl (%eax),%edx
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	88 10                	mov    %dl,(%eax)
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	0f b6 00             	movzbl (%eax),%eax
  c7:	84 c0                	test   %al,%al
  c9:	0f 95 c0             	setne  %al
  cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  d4:	84 c0                	test   %al,%al
  d6:	75 de                	jne    b6 <strcpy+0xd>
    ;
  return os;
  d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  db:	c9                   	leave  
  dc:	c3                   	ret    

000000dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e0:	eb 08                	jmp    ea <strcmp+0xd>
    p++, q++;
  e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	84 c0                	test   %al,%al
  f2:	74 10                	je     104 <strcmp+0x27>
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	0f b6 10             	movzbl (%eax),%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	38 c2                	cmp    %al,%dl
 102:	74 de                	je     e2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 d0             	movzbl %al,%edx
 10d:	8b 45 0c             	mov    0xc(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 c0             	movzbl %al,%eax
 116:	89 d1                	mov    %edx,%ecx
 118:	29 c1                	sub    %eax,%ecx
 11a:	89 c8                	mov    %ecx,%eax
}
 11c:	5d                   	pop    %ebp
 11d:	c3                   	ret    

0000011e <strlen>:

uint
strlen(char *s)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12b:	eb 04                	jmp    131 <strlen+0x13>
 12d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 131:	8b 45 fc             	mov    -0x4(%ebp),%eax
 134:	03 45 08             	add    0x8(%ebp),%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	84 c0                	test   %al,%al
 13c:	75 ef                	jne    12d <strlen+0xf>
    ;
  return n;
 13e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 141:	c9                   	leave  
 142:	c3                   	ret    

00000143 <memset>:

void*
memset(void *dst, int c, uint n)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 149:	8b 45 10             	mov    0x10(%ebp),%eax
 14c:	89 44 24 08          	mov    %eax,0x8(%esp)
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	89 44 24 04          	mov    %eax,0x4(%esp)
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	89 04 24             	mov    %eax,(%esp)
 15d:	e8 22 ff ff ff       	call   84 <stosb>
  return dst;
 162:	8b 45 08             	mov    0x8(%ebp),%eax
}
 165:	c9                   	leave  
 166:	c3                   	ret    

00000167 <strchr>:

char*
strchr(const char *s, char c)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	83 ec 04             	sub    $0x4,%esp
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 173:	eb 14                	jmp    189 <strchr+0x22>
    if(*s == c)
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	0f b6 00             	movzbl (%eax),%eax
 17b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17e:	75 05                	jne    185 <strchr+0x1e>
      return (char*)s;
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	eb 13                	jmp    198 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 185:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 00             	movzbl (%eax),%eax
 18f:	84 c0                	test   %al,%al
 191:	75 e2                	jne    175 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 193:	b8 00 00 00 00       	mov    $0x0,%eax
}
 198:	c9                   	leave  
 199:	c3                   	ret    

0000019a <gets>:

char*
gets(char *buf, int max)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
 19d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a7:	eb 44                	jmp    1ed <gets+0x53>
    cc = read(0, &c, 1);
 1a9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b0:	00 
 1b1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bf:	e8 4c 01 00 00       	call   310 <read>
 1c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1cb:	7e 2d                	jle    1fa <gets+0x60>
      break;
    buf[i++] = c;
 1cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d0:	03 45 08             	add    0x8(%ebp),%eax
 1d3:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1d7:	88 10                	mov    %dl,(%eax)
 1d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1dd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e1:	3c 0a                	cmp    $0xa,%al
 1e3:	74 16                	je     1fb <gets+0x61>
 1e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e9:	3c 0d                	cmp    $0xd,%al
 1eb:	74 0e                	je     1fb <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f0:	83 c0 01             	add    $0x1,%eax
 1f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f6:	7c b1                	jl     1a9 <gets+0xf>
 1f8:	eb 01                	jmp    1fb <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1fa:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fe:	03 45 08             	add    0x8(%ebp),%eax
 201:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
}
 207:	c9                   	leave  
 208:	c3                   	ret    

00000209 <stat>:

int
stat(char *n, struct stat *st)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 216:	00 
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	89 04 24             	mov    %eax,(%esp)
 21d:	e8 16 01 00 00       	call   338 <open>
 222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 229:	79 07                	jns    232 <stat+0x29>
    return -1;
 22b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 230:	eb 23                	jmp    255 <stat+0x4c>
  r = fstat(fd, st);
 232:	8b 45 0c             	mov    0xc(%ebp),%eax
 235:	89 44 24 04          	mov    %eax,0x4(%esp)
 239:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23c:	89 04 24             	mov    %eax,(%esp)
 23f:	e8 0c 01 00 00       	call   350 <fstat>
 244:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	89 04 24             	mov    %eax,(%esp)
 24d:	e8 ce 00 00 00       	call   320 <close>
  return r;
 252:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <atoi>:

int
atoi(const char *s)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 264:	eb 23                	jmp    289 <atoi+0x32>
    n = n*10 + *s++ - '0';
 266:	8b 55 fc             	mov    -0x4(%ebp),%edx
 269:	89 d0                	mov    %edx,%eax
 26b:	c1 e0 02             	shl    $0x2,%eax
 26e:	01 d0                	add    %edx,%eax
 270:	01 c0                	add    %eax,%eax
 272:	89 c2                	mov    %eax,%edx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	0f b6 00             	movzbl (%eax),%eax
 27a:	0f be c0             	movsbl %al,%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	83 e8 30             	sub    $0x30,%eax
 282:	89 45 fc             	mov    %eax,-0x4(%ebp)
 285:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x46>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c9                	jle    266 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b4:	eb 13                	jmp    2c9 <memmove+0x27>
    *dst++ = *src++;
 2b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b9:	0f b6 10             	movzbl (%eax),%edx
 2bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2bf:	88 10                	mov    %dl,(%eax)
 2c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2c5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2cd:	0f 9f c0             	setg   %al
 2d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2d4:	84 c0                	test   %al,%al
 2d6:	75 de                	jne    2b6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    
 2dd:	90                   	nop
 2de:	90                   	nop
 2df:	90                   	nop

000002e0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e0:	b8 01 00 00 00       	mov    $0x1,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <exit>:
SYSCALL(exit)
 2e8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <wait>:
SYSCALL(wait)
 2f0:	b8 03 00 00 00       	mov    $0x3,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <wait2>:
SYSCALL(wait2)
 2f8:	b8 16 00 00 00       	mov    $0x16,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <add_path>:
SYSCALL(add_path)
 300:	b8 17 00 00 00       	mov    $0x17,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <pipe>:
SYSCALL(pipe)
 308:	b8 04 00 00 00       	mov    $0x4,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <read>:
SYSCALL(read)
 310:	b8 05 00 00 00       	mov    $0x5,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <write>:
SYSCALL(write)
 318:	b8 10 00 00 00       	mov    $0x10,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <close>:
SYSCALL(close)
 320:	b8 15 00 00 00       	mov    $0x15,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <kill>:
SYSCALL(kill)
 328:	b8 06 00 00 00       	mov    $0x6,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <exec>:
SYSCALL(exec)
 330:	b8 07 00 00 00       	mov    $0x7,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <open>:
SYSCALL(open)
 338:	b8 0f 00 00 00       	mov    $0xf,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <mknod>:
SYSCALL(mknod)
 340:	b8 11 00 00 00       	mov    $0x11,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <unlink>:
SYSCALL(unlink)
 348:	b8 12 00 00 00       	mov    $0x12,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <fstat>:
SYSCALL(fstat)
 350:	b8 08 00 00 00       	mov    $0x8,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <link>:
SYSCALL(link)
 358:	b8 13 00 00 00       	mov    $0x13,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <mkdir>:
SYSCALL(mkdir)
 360:	b8 14 00 00 00       	mov    $0x14,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <chdir>:
SYSCALL(chdir)
 368:	b8 09 00 00 00       	mov    $0x9,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <dup>:
SYSCALL(dup)
 370:	b8 0a 00 00 00       	mov    $0xa,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getpid>:
SYSCALL(getpid)
 378:	b8 0b 00 00 00       	mov    $0xb,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <sbrk>:
SYSCALL(sbrk)
 380:	b8 0c 00 00 00       	mov    $0xc,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <sleep>:
SYSCALL(sleep)
 388:	b8 0d 00 00 00       	mov    $0xd,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <uptime>:
SYSCALL(uptime)
 390:	b8 0e 00 00 00       	mov    $0xe,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	83 ec 28             	sub    $0x28,%esp
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ab:	00 
 3ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3af:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	89 04 24             	mov    %eax,(%esp)
 3b9:	e8 5a ff ff ff       	call   318 <write>
}
 3be:	c9                   	leave  
 3bf:	c3                   	ret    

000003c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d1:	74 17                	je     3ea <printint+0x2a>
 3d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d7:	79 11                	jns    3ea <printint+0x2a>
    neg = 1;
 3d9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	f7 d8                	neg    %eax
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e8:	eb 06                	jmp    3f0 <printint+0x30>
  } else {
    x = xx;
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fd:	ba 00 00 00 00       	mov    $0x0,%edx
 402:	f7 f1                	div    %ecx
 404:	89 d0                	mov    %edx,%eax
 406:	0f b6 90 a4 0a 00 00 	movzbl 0xaa4(%eax),%edx
 40d:	8d 45 dc             	lea    -0x24(%ebp),%eax
 410:	03 45 f4             	add    -0xc(%ebp),%eax
 413:	88 10                	mov    %dl,(%eax)
 415:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 419:	8b 55 10             	mov    0x10(%ebp),%edx
 41c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 41f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 422:	ba 00 00 00 00       	mov    $0x0,%edx
 427:	f7 75 d4             	divl   -0x2c(%ebp)
 42a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 431:	75 c4                	jne    3f7 <printint+0x37>
  if(neg)
 433:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 437:	74 2a                	je     463 <printint+0xa3>
    buf[i++] = '-';
 439:	8d 45 dc             	lea    -0x24(%ebp),%eax
 43c:	03 45 f4             	add    -0xc(%ebp),%eax
 43f:	c6 00 2d             	movb   $0x2d,(%eax)
 442:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 446:	eb 1b                	jmp    463 <printint+0xa3>
    putc(fd, buf[i]);
 448:	8d 45 dc             	lea    -0x24(%ebp),%eax
 44b:	03 45 f4             	add    -0xc(%ebp),%eax
 44e:	0f b6 00             	movzbl (%eax),%eax
 451:	0f be c0             	movsbl %al,%eax
 454:	89 44 24 04          	mov    %eax,0x4(%esp)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	89 04 24             	mov    %eax,(%esp)
 45e:	e8 35 ff ff ff       	call   398 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 463:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46b:	79 db                	jns    448 <printint+0x88>
    putc(fd, buf[i]);
}
 46d:	c9                   	leave  
 46e:	c3                   	ret    

0000046f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 475:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47c:	8d 45 0c             	lea    0xc(%ebp),%eax
 47f:	83 c0 04             	add    $0x4,%eax
 482:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48c:	e9 7d 01 00 00       	jmp    60e <printf+0x19f>
    c = fmt[i] & 0xff;
 491:	8b 55 0c             	mov    0xc(%ebp),%edx
 494:	8b 45 f0             	mov    -0x10(%ebp),%eax
 497:	01 d0                	add    %edx,%eax
 499:	0f b6 00             	movzbl (%eax),%eax
 49c:	0f be c0             	movsbl %al,%eax
 49f:	25 ff 00 00 00       	and    $0xff,%eax
 4a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ab:	75 2c                	jne    4d9 <printf+0x6a>
      if(c == '%'){
 4ad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b1:	75 0c                	jne    4bf <printf+0x50>
        state = '%';
 4b3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ba:	e9 4b 01 00 00       	jmp    60a <printf+0x19b>
      } else {
        putc(fd, c);
 4bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c2:	0f be c0             	movsbl %al,%eax
 4c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	89 04 24             	mov    %eax,(%esp)
 4cf:	e8 c4 fe ff ff       	call   398 <putc>
 4d4:	e9 31 01 00 00       	jmp    60a <printf+0x19b>
      }
    } else if(state == '%'){
 4d9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4dd:	0f 85 27 01 00 00    	jne    60a <printf+0x19b>
      if(c == 'd'){
 4e3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e7:	75 2d                	jne    516 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ec:	8b 00                	mov    (%eax),%eax
 4ee:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f5:	00 
 4f6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4fd:	00 
 4fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 502:	8b 45 08             	mov    0x8(%ebp),%eax
 505:	89 04 24             	mov    %eax,(%esp)
 508:	e8 b3 fe ff ff       	call   3c0 <printint>
        ap++;
 50d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 511:	e9 ed 00 00 00       	jmp    603 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 516:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51a:	74 06                	je     522 <printf+0xb3>
 51c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 520:	75 2d                	jne    54f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 522:	8b 45 e8             	mov    -0x18(%ebp),%eax
 525:	8b 00                	mov    (%eax),%eax
 527:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 52e:	00 
 52f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 536:	00 
 537:	89 44 24 04          	mov    %eax,0x4(%esp)
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	89 04 24             	mov    %eax,(%esp)
 541:	e8 7a fe ff ff       	call   3c0 <printint>
        ap++;
 546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54a:	e9 b4 00 00 00       	jmp    603 <printf+0x194>
      } else if(c == 's'){
 54f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 553:	75 46                	jne    59b <printf+0x12c>
        s = (char*)*ap;
 555:	8b 45 e8             	mov    -0x18(%ebp),%eax
 558:	8b 00                	mov    (%eax),%eax
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 565:	75 27                	jne    58e <printf+0x11f>
          s = "(null)";
 567:	c7 45 f4 60 08 00 00 	movl   $0x860,-0xc(%ebp)
        while(*s != 0){
 56e:	eb 1e                	jmp    58e <printf+0x11f>
          putc(fd, *s);
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	89 44 24 04          	mov    %eax,0x4(%esp)
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	89 04 24             	mov    %eax,(%esp)
 583:	e8 10 fe ff ff       	call   398 <putc>
          s++;
 588:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 58c:	eb 01                	jmp    58f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58e:	90                   	nop
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	84 c0                	test   %al,%al
 597:	75 d7                	jne    570 <printf+0x101>
 599:	eb 68                	jmp    603 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59f:	75 1d                	jne    5be <printf+0x14f>
        putc(fd, *ap);
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	89 04 24             	mov    %eax,(%esp)
 5b3:	e8 e0 fd ff ff       	call   398 <putc>
        ap++;
 5b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bc:	eb 45                	jmp    603 <printf+0x194>
      } else if(c == '%'){
 5be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c2:	75 17                	jne    5db <printf+0x16c>
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 bf fd ff ff       	call   398 <putc>
 5d9:	eb 28                	jmp    603 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5db:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e2:	00 
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 aa fd ff ff       	call   398 <putc>
        putc(fd, c);
 5ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f1:	0f be c0             	movsbl %al,%eax
 5f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 95 fd ff ff       	call   398 <putc>
      }
      state = 0;
 603:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 60e:	8b 55 0c             	mov    0xc(%ebp),%edx
 611:	8b 45 f0             	mov    -0x10(%ebp),%eax
 614:	01 d0                	add    %edx,%eax
 616:	0f b6 00             	movzbl (%eax),%eax
 619:	84 c0                	test   %al,%al
 61b:	0f 85 70 fe ff ff    	jne    491 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 621:	c9                   	leave  
 622:	c3                   	ret    
 623:	90                   	nop

00000624 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	83 e8 08             	sub    $0x8,%eax
 630:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	a1 c0 0a 00 00       	mov    0xac0,%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63b:	eb 24                	jmp    661 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	77 12                	ja     659 <free+0x35>
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	77 24                	ja     673 <free+0x4f>
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 657:	77 1a                	ja     673 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 667:	76 d4                	jbe    63d <free+0x19>
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 671:	76 ca                	jbe    63d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	8b 40 04             	mov    0x4(%eax),%eax
 679:	c1 e0 03             	shl    $0x3,%eax
 67c:	89 c2                	mov    %eax,%edx
 67e:	03 55 f8             	add    -0x8(%ebp),%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	39 c2                	cmp    %eax,%edx
 688:	75 24                	jne    6ae <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	8b 40 04             	mov    0x4(%eax),%eax
 698:	01 c2                	add    %eax,%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
 6ac:	eb 0a                	jmp    6b8 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 40 04             	mov    0x4(%eax),%eax
 6be:	c1 e0 03             	shl    $0x3,%eax
 6c1:	03 45 fc             	add    -0x4(%ebp),%eax
 6c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c7:	75 20                	jne    6e9 <free+0xc5>
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
 6e7:	eb 08                	jmp    6f1 <free+0xcd>
  } else
    p->s.ptr = bp;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	a3 c0 0a 00 00       	mov    %eax,0xac0
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
 71a:	e8 61 fc ff ff       	call   380 <sbrk>
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
 747:	e8 d8 fe ff ff       	call   624 <free>
  return freep;
 74c:	a1 c0 0a 00 00       	mov    0xac0,%eax
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
 768:	a1 c0 0a 00 00       	mov    0xac0,%eax
 76d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 770:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 774:	75 23                	jne    799 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 776:	c7 45 f0 b8 0a 00 00 	movl   $0xab8,-0x10(%ebp)
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	a3 c0 0a 00 00       	mov    %eax,0xac0
 785:	a1 c0 0a 00 00       	mov    0xac0,%eax
 78a:	a3 b8 0a 00 00       	mov    %eax,0xab8
    base.s.size = 0;
 78f:	c7 05 bc 0a 00 00 00 	movl   $0x0,0xabc
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
 7c9:	89 c2                	mov    %eax,%edx
 7cb:	2b 55 ec             	sub    -0x14(%ebp),%edx
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
 7ec:	a3 c0 0a 00 00       	mov    %eax,0xac0
      return (void*)(p + 1);
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	83 c0 08             	add    $0x8,%eax
 7f7:	eb 38                	jmp    831 <malloc+0xde>
    }
    if(p == freep)
 7f9:	a1 c0 0a 00 00       	mov    0xac0,%eax
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
