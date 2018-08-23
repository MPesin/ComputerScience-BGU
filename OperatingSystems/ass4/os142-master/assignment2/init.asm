
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 05 0f 00 00 	movl   $0xf05,(%esp)
  18:	e8 b2 03 00 00       	call   3cf <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 05 0f 00 00 	movl   $0xf05,(%esp)
  38:	e8 9a 03 00 00       	call   3d7 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 05 0f 00 00 	movl   $0xf05,(%esp)
  4c:	e8 7e 03 00 00       	call   3cf <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 aa 03 00 00       	call   407 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 9e 03 00 00       	call   407 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 0d 0f 00 	movl   $0xf0d,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 92 04 00 00       	call   50f <printf>
    pid = fork();
  7d:	e8 ed 02 00 00       	call   36f <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 20 0f 00 	movl   $0xf20,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 6e 04 00 00       	call   50f <printf>
      exit();
  a1:	e8 d1 02 00 00       	call   377 <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
  ad:	c7 44 24 04 d4 13 00 	movl   $0x13d4,0x4(%esp)
  b4:	00 
  b5:	c7 04 24 02 0f 00 00 	movl   $0xf02,(%esp)
  bc:	e8 06 03 00 00       	call   3c7 <exec>
      printf(1, "init: exec sh failed\n");
  c1:	c7 44 24 04 33 0f 00 	movl   $0xf33,0x4(%esp)
  c8:	00 
  c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d0:	e8 3a 04 00 00       	call   50f <printf>
      exit();
  d5:	e8 9d 02 00 00       	call   377 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
  dc:	c7 44 24 04 49 0f 00 	movl   $0xf49,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 1f 04 00 00       	call   50f <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f0:	e8 8a 02 00 00       	call   37f <wait>
  f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  fe:	78 0a                	js     10a <main+0x10a>
 100:	8b 44 24 18          	mov    0x18(%esp),%eax
 104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 108:	75 d2                	jne    dc <main+0xdc>
      printf(1, "zombie!\n");
  }
 10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	5b                   	pop    %ebx
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    

00000134 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 140:	90                   	nop
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	8d 50 01             	lea    0x1(%eax),%edx
 147:	89 55 08             	mov    %edx,0x8(%ebp)
 14a:	8b 55 0c             	mov    0xc(%ebp),%edx
 14d:	8d 4a 01             	lea    0x1(%edx),%ecx
 150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 153:	0f b6 12             	movzbl (%edx),%edx
 156:	88 10                	mov    %dl,(%eax)
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	75 e2                	jne    141 <strcpy+0xd>
    ;
  return os;
 15f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 162:	c9                   	leave  
 163:	c3                   	ret    

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 167:	eb 08                	jmp    171 <strcmp+0xd>
    p++, q++;
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	74 10                	je     18b <strcmp+0x27>
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 10             	movzbl (%eax),%edx
 181:	8b 45 0c             	mov    0xc(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	38 c2                	cmp    %al,%dl
 189:	74 de                	je     169 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	0f b6 d0             	movzbl %al,%edx
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	0f b6 c0             	movzbl %al,%eax
 19d:	29 c2                	sub    %eax,%edx
 19f:	89 d0                	mov    %edx,%eax
}
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 04                	jmp    1b6 <strlen+0x13>
 1b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 d0                	add    %edx,%eax
 1be:	0f b6 00             	movzbl (%eax),%eax
 1c1:	84 c0                	test   %al,%al
 1c3:	75 ed                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d0:	8b 45 10             	mov    0x10(%ebp),%eax
 1d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	89 44 24 04          	mov    %eax,0x4(%esp)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 26 ff ff ff       	call   10f <stosb>
  return dst;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ec:	c9                   	leave  
 1ed:	c3                   	ret    

000001ee <strchr>:

char*
strchr(const char *s, char c)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 04             	sub    $0x4,%esp
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fa:	eb 14                	jmp    210 <strchr+0x22>
    if(*s == c)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	3a 45 fc             	cmp    -0x4(%ebp),%al
 205:	75 05                	jne    20c <strchr+0x1e>
      return (char*)s;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	eb 13                	jmp    21f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	84 c0                	test   %al,%al
 218:	75 e2                	jne    1fc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <gets>:

char*
gets(char *buf, int max)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22e:	eb 4c                	jmp    27c <gets+0x5b>
    cc = read(0, &c, 1);
 230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 237:	00 
 238:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 23f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 246:	e8 5c 01 00 00       	call   3a7 <read>
 24b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 252:	7f 02                	jg     256 <gets+0x35>
      break;
 254:	eb 31                	jmp    287 <gets+0x66>
    buf[i++] = c;
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25f:	89 c2                	mov    %eax,%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	01 c2                	add    %eax,%edx
 266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 270:	3c 0a                	cmp    $0xa,%al
 272:	74 13                	je     287 <gets+0x66>
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	3c 0d                	cmp    $0xd,%al
 27a:	74 0b                	je     287 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27f:	83 c0 01             	add    $0x1,%eax
 282:	3b 45 0c             	cmp    0xc(%ebp),%eax
 285:	7c a9                	jl     230 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 287:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 d0                	add    %edx,%eax
 28f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 292:	8b 45 08             	mov    0x8(%ebp),%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    

00000297 <stat>:

int
stat(char *n, struct stat *st)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a4:	00 
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	89 04 24             	mov    %eax,(%esp)
 2ab:	e8 1f 01 00 00       	call   3cf <open>
 2b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b7:	79 07                	jns    2c0 <stat+0x29>
    return -1;
 2b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2be:	eb 23                	jmp    2e3 <stat+0x4c>
  r = fstat(fd, st);
 2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 15 01 00 00       	call   3e7 <fstat>
 2d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 d7 00 00 00       	call   3b7 <close>
  return r;
 2e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <atoi>:

int
atoi(const char *s)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f2:	eb 25                	jmp    319 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f7:	89 d0                	mov    %edx,%eax
 2f9:	c1 e0 02             	shl    $0x2,%eax
 2fc:	01 d0                	add    %edx,%eax
 2fe:	01 c0                	add    %eax,%eax
 300:	89 c1                	mov    %eax,%ecx
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	8d 50 01             	lea    0x1(%eax),%edx
 308:	89 55 08             	mov    %edx,0x8(%ebp)
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	0f be c0             	movsbl %al,%eax
 311:	01 c8                	add    %ecx,%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 2f                	cmp    $0x2f,%al
 321:	7e 0a                	jle    32d <atoi+0x48>
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	3c 39                	cmp    $0x39,%al
 32b:	7e c7                	jle    2f4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 344:	eb 17                	jmp    35d <memmove+0x2b>
    *dst++ = *src++;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
 349:	8d 50 01             	lea    0x1(%eax),%edx
 34c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 352:	8d 4a 01             	lea    0x1(%edx),%ecx
 355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 358:	0f b6 12             	movzbl (%edx),%edx
 35b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	8b 45 10             	mov    0x10(%ebp),%eax
 360:	8d 50 ff             	lea    -0x1(%eax),%edx
 363:	89 55 10             	mov    %edx,0x10(%ebp)
 366:	85 c0                	test   %eax,%eax
 368:	7f dc                	jg     346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36f:	b8 01 00 00 00       	mov    $0x1,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <exit>:
SYSCALL(exit)
 377:	b8 02 00 00 00       	mov    $0x2,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <wait>:
SYSCALL(wait)
 37f:	b8 03 00 00 00       	mov    $0x3,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <signal>:
SYSCALL(signal)
 387:	b8 18 00 00 00       	mov    $0x18,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <sigsend>:
SYSCALL(sigsend)
 38f:	b8 19 00 00 00       	mov    $0x19,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <alarm>:
SYSCALL(alarm)
 397:	b8 1a 00 00 00       	mov    $0x1a,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <pipe>:
SYSCALL(pipe)
 39f:	b8 04 00 00 00       	mov    $0x4,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <read>:
SYSCALL(read)
 3a7:	b8 05 00 00 00       	mov    $0x5,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <write>:
SYSCALL(write)
 3af:	b8 10 00 00 00       	mov    $0x10,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <close>:
SYSCALL(close)
 3b7:	b8 15 00 00 00       	mov    $0x15,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <kill>:
SYSCALL(kill)
 3bf:	b8 06 00 00 00       	mov    $0x6,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <exec>:
SYSCALL(exec)
 3c7:	b8 07 00 00 00       	mov    $0x7,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <open>:
SYSCALL(open)
 3cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <mknod>:
SYSCALL(mknod)
 3d7:	b8 11 00 00 00       	mov    $0x11,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <unlink>:
SYSCALL(unlink)
 3df:	b8 12 00 00 00       	mov    $0x12,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <fstat>:
SYSCALL(fstat)
 3e7:	b8 08 00 00 00       	mov    $0x8,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <link>:
SYSCALL(link)
 3ef:	b8 13 00 00 00       	mov    $0x13,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <mkdir>:
SYSCALL(mkdir)
 3f7:	b8 14 00 00 00       	mov    $0x14,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <chdir>:
SYSCALL(chdir)
 3ff:	b8 09 00 00 00       	mov    $0x9,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <dup>:
SYSCALL(dup)
 407:	b8 0a 00 00 00       	mov    $0xa,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <getpid>:
SYSCALL(getpid)
 40f:	b8 0b 00 00 00       	mov    $0xb,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <sbrk>:
SYSCALL(sbrk)
 417:	b8 0c 00 00 00       	mov    $0xc,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <sleep>:
SYSCALL(sleep)
 41f:	b8 0d 00 00 00       	mov    $0xd,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <uptime>:
SYSCALL(uptime)
 427:	b8 0e 00 00 00       	mov    $0xe,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42f:	55                   	push   %ebp
 430:	89 e5                	mov    %esp,%ebp
 432:	83 ec 18             	sub    $0x18,%esp
 435:	8b 45 0c             	mov    0xc(%ebp),%eax
 438:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 43b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 442:	00 
 443:	8d 45 f4             	lea    -0xc(%ebp),%eax
 446:	89 44 24 04          	mov    %eax,0x4(%esp)
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	89 04 24             	mov    %eax,(%esp)
 450:	e8 5a ff ff ff       	call   3af <write>
}
 455:	c9                   	leave  
 456:	c3                   	ret    

00000457 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	56                   	push   %esi
 45b:	53                   	push   %ebx
 45c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 45f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 466:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46a:	74 17                	je     483 <printint+0x2c>
 46c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 470:	79 11                	jns    483 <printint+0x2c>
    neg = 1;
 472:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 479:	8b 45 0c             	mov    0xc(%ebp),%eax
 47c:	f7 d8                	neg    %eax
 47e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 481:	eb 06                	jmp    489 <printint+0x32>
  } else {
    x = xx;
 483:	8b 45 0c             	mov    0xc(%ebp),%eax
 486:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 490:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 493:	8d 41 01             	lea    0x1(%ecx),%eax
 496:	89 45 f4             	mov    %eax,-0xc(%ebp)
 499:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49f:	ba 00 00 00 00       	mov    $0x0,%edx
 4a4:	f7 f3                	div    %ebx
 4a6:	89 d0                	mov    %edx,%eax
 4a8:	0f b6 80 dc 13 00 00 	movzbl 0x13dc(%eax),%eax
 4af:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4b3:	8b 75 10             	mov    0x10(%ebp),%esi
 4b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b9:	ba 00 00 00 00       	mov    $0x0,%edx
 4be:	f7 f6                	div    %esi
 4c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c7:	75 c7                	jne    490 <printint+0x39>
  if(neg)
 4c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4cd:	74 10                	je     4df <printint+0x88>
    buf[i++] = '-';
 4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d2:	8d 50 01             	lea    0x1(%eax),%edx
 4d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4dd:	eb 1f                	jmp    4fe <printint+0xa7>
 4df:	eb 1d                	jmp    4fe <printint+0xa7>
    putc(fd, buf[i]);
 4e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e7:	01 d0                	add    %edx,%eax
 4e9:	0f b6 00             	movzbl (%eax),%eax
 4ec:	0f be c0             	movsbl %al,%eax
 4ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	89 04 24             	mov    %eax,(%esp)
 4f9:	e8 31 ff ff ff       	call   42f <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 506:	79 d9                	jns    4e1 <printint+0x8a>
    putc(fd, buf[i]);
}
 508:	83 c4 30             	add    $0x30,%esp
 50b:	5b                   	pop    %ebx
 50c:	5e                   	pop    %esi
 50d:	5d                   	pop    %ebp
 50e:	c3                   	ret    

0000050f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50f:	55                   	push   %ebp
 510:	89 e5                	mov    %esp,%ebp
 512:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 515:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 51c:	8d 45 0c             	lea    0xc(%ebp),%eax
 51f:	83 c0 04             	add    $0x4,%eax
 522:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 525:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 52c:	e9 7c 01 00 00       	jmp    6ad <printf+0x19e>
    c = fmt[i] & 0xff;
 531:	8b 55 0c             	mov    0xc(%ebp),%edx
 534:	8b 45 f0             	mov    -0x10(%ebp),%eax
 537:	01 d0                	add    %edx,%eax
 539:	0f b6 00             	movzbl (%eax),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	25 ff 00 00 00       	and    $0xff,%eax
 544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54b:	75 2c                	jne    579 <printf+0x6a>
      if(c == '%'){
 54d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 551:	75 0c                	jne    55f <printf+0x50>
        state = '%';
 553:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 55a:	e9 4a 01 00 00       	jmp    6a9 <printf+0x19a>
      } else {
        putc(fd, c);
 55f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	89 44 24 04          	mov    %eax,0x4(%esp)
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	89 04 24             	mov    %eax,(%esp)
 56f:	e8 bb fe ff ff       	call   42f <putc>
 574:	e9 30 01 00 00       	jmp    6a9 <printf+0x19a>
      }
    } else if(state == '%'){
 579:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 57d:	0f 85 26 01 00 00    	jne    6a9 <printf+0x19a>
      if(c == 'd'){
 583:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 587:	75 2d                	jne    5b6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	8b 00                	mov    (%eax),%eax
 58e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 595:	00 
 596:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 59d:	00 
 59e:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	89 04 24             	mov    %eax,(%esp)
 5a8:	e8 aa fe ff ff       	call   457 <printint>
        ap++;
 5ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b1:	e9 ec 00 00 00       	jmp    6a2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5b6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ba:	74 06                	je     5c2 <printf+0xb3>
 5bc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c0:	75 2d                	jne    5ef <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c5:	8b 00                	mov    (%eax),%eax
 5c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ce:	00 
 5cf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5d6:	00 
 5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	89 04 24             	mov    %eax,(%esp)
 5e1:	e8 71 fe ff ff       	call   457 <printint>
        ap++;
 5e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ea:	e9 b3 00 00 00       	jmp    6a2 <printf+0x193>
      } else if(c == 's'){
 5ef:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5f3:	75 45                	jne    63a <printf+0x12b>
        s = (char*)*ap;
 5f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 605:	75 09                	jne    610 <printf+0x101>
          s = "(null)";
 607:	c7 45 f4 52 0f 00 00 	movl   $0xf52,-0xc(%ebp)
        while(*s != 0){
 60e:	eb 1e                	jmp    62e <printf+0x11f>
 610:	eb 1c                	jmp    62e <printf+0x11f>
          putc(fd, *s);
 612:	8b 45 f4             	mov    -0xc(%ebp),%eax
 615:	0f b6 00             	movzbl (%eax),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 05 fe ff ff       	call   42f <putc>
          s++;
 62a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 631:	0f b6 00             	movzbl (%eax),%eax
 634:	84 c0                	test   %al,%al
 636:	75 da                	jne    612 <printf+0x103>
 638:	eb 68                	jmp    6a2 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 63e:	75 1d                	jne    65d <printf+0x14e>
        putc(fd, *ap);
 640:	8b 45 e8             	mov    -0x18(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	0f be c0             	movsbl %al,%eax
 648:	89 44 24 04          	mov    %eax,0x4(%esp)
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	89 04 24             	mov    %eax,(%esp)
 652:	e8 d8 fd ff ff       	call   42f <putc>
        ap++;
 657:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65b:	eb 45                	jmp    6a2 <printf+0x193>
      } else if(c == '%'){
 65d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 661:	75 17                	jne    67a <printf+0x16b>
        putc(fd, c);
 663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 b7 fd ff ff       	call   42f <putc>
 678:	eb 28                	jmp    6a2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 681:	00 
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	89 04 24             	mov    %eax,(%esp)
 688:	e8 a2 fd ff ff       	call   42f <putc>
        putc(fd, c);
 68d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 690:	0f be c0             	movsbl %al,%eax
 693:	89 44 24 04          	mov    %eax,0x4(%esp)
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 8d fd ff ff       	call   42f <putc>
      }
      state = 0;
 6a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b3:	01 d0                	add    %edx,%eax
 6b5:	0f b6 00             	movzbl (%eax),%eax
 6b8:	84 c0                	test   %al,%al
 6ba:	0f 85 71 fe ff ff    	jne    531 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c0:	c9                   	leave  
 6c1:	c3                   	ret    

000006c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c2:	55                   	push   %ebp
 6c3:	89 e5                	mov    %esp,%ebp
 6c5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c8:	8b 45 08             	mov    0x8(%ebp),%eax
 6cb:	83 e8 08             	sub    $0x8,%eax
 6ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	a1 08 14 00 00       	mov    0x1408,%eax
 6d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d9:	eb 24                	jmp    6ff <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e3:	77 12                	ja     6f7 <free+0x35>
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6eb:	77 24                	ja     711 <free+0x4f>
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f5:	77 1a                	ja     711 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	76 d4                	jbe    6db <free+0x19>
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70f:	76 ca                	jbe    6db <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 711:	8b 45 f8             	mov    -0x8(%ebp),%eax
 714:	8b 40 04             	mov    0x4(%eax),%eax
 717:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	01 c2                	add    %eax,%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	39 c2                	cmp    %eax,%edx
 72a:	75 24                	jne    750 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	8b 50 04             	mov    0x4(%eax),%edx
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	8b 40 04             	mov    0x4(%eax),%eax
 73a:	01 c2                	add    %eax,%edx
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	8b 10                	mov    (%eax),%edx
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	89 10                	mov    %edx,(%eax)
 74e:	eb 0a                	jmp    75a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 10                	mov    (%eax),%edx
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 40 04             	mov    0x4(%eax),%eax
 760:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	01 d0                	add    %edx,%eax
 76c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76f:	75 20                	jne    791 <free+0xcf>
    p->s.size += bp->s.size;
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 50 04             	mov    0x4(%eax),%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	01 c2                	add    %eax,%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 10                	mov    (%eax),%edx
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	89 10                	mov    %edx,(%eax)
 78f:	eb 08                	jmp    799 <free+0xd7>
  } else
    p->s.ptr = bp;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 55 f8             	mov    -0x8(%ebp),%edx
 797:	89 10                	mov    %edx,(%eax)
  freep = p;
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	a3 08 14 00 00       	mov    %eax,0x1408
}
 7a1:	c9                   	leave  
 7a2:	c3                   	ret    

000007a3 <morecore>:

static Header*
morecore(uint nu)
{
 7a3:	55                   	push   %ebp
 7a4:	89 e5                	mov    %esp,%ebp
 7a6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b0:	77 07                	ja     7b9 <morecore+0x16>
    nu = 4096;
 7b2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
 7bc:	c1 e0 03             	shl    $0x3,%eax
 7bf:	89 04 24             	mov    %eax,(%esp)
 7c2:	e8 50 fc ff ff       	call   417 <sbrk>
 7c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ce:	75 07                	jne    7d7 <morecore+0x34>
    return 0;
 7d0:	b8 00 00 00 00       	mov    $0x0,%eax
 7d5:	eb 22                	jmp    7f9 <morecore+0x56>
  hp = (Header*)p;
 7d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	8b 55 08             	mov    0x8(%ebp),%edx
 7e3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e9:	83 c0 08             	add    $0x8,%eax
 7ec:	89 04 24             	mov    %eax,(%esp)
 7ef:	e8 ce fe ff ff       	call   6c2 <free>
  return freep;
 7f4:	a1 08 14 00 00       	mov    0x1408,%eax
}
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    

000007fb <malloc>:

void*
malloc(uint nbytes)
{
 7fb:	55                   	push   %ebp
 7fc:	89 e5                	mov    %esp,%ebp
 7fe:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 801:	8b 45 08             	mov    0x8(%ebp),%eax
 804:	83 c0 07             	add    $0x7,%eax
 807:	c1 e8 03             	shr    $0x3,%eax
 80a:	83 c0 01             	add    $0x1,%eax
 80d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 810:	a1 08 14 00 00       	mov    0x1408,%eax
 815:	89 45 f0             	mov    %eax,-0x10(%ebp)
 818:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81c:	75 23                	jne    841 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 81e:	c7 45 f0 00 14 00 00 	movl   $0x1400,-0x10(%ebp)
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	a3 08 14 00 00       	mov    %eax,0x1408
 82d:	a1 08 14 00 00       	mov    0x1408,%eax
 832:	a3 00 14 00 00       	mov    %eax,0x1400
    base.s.size = 0;
 837:	c7 05 04 14 00 00 00 	movl   $0x0,0x1404
 83e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 841:	8b 45 f0             	mov    -0x10(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 852:	72 4d                	jb     8a1 <malloc+0xa6>
      if(p->s.size == nunits)
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85d:	75 0c                	jne    86b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 10                	mov    (%eax),%edx
 864:	8b 45 f0             	mov    -0x10(%ebp),%eax
 867:	89 10                	mov    %edx,(%eax)
 869:	eb 26                	jmp    891 <malloc+0x96>
      else {
        p->s.size -= nunits;
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	2b 45 ec             	sub    -0x14(%ebp),%eax
 874:	89 c2                	mov    %eax,%edx
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 40 04             	mov    0x4(%eax),%eax
 882:	c1 e0 03             	shl    $0x3,%eax
 885:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 88e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	a3 08 14 00 00       	mov    %eax,0x1408
      return (void*)(p + 1);
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	83 c0 08             	add    $0x8,%eax
 89f:	eb 38                	jmp    8d9 <malloc+0xde>
    }
    if(p == freep)
 8a1:	a1 08 14 00 00       	mov    0x1408,%eax
 8a6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a9:	75 1b                	jne    8c6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ae:	89 04 24             	mov    %eax,(%esp)
 8b1:	e8 ed fe ff ff       	call   7a3 <morecore>
 8b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8bd:	75 07                	jne    8c6 <malloc+0xcb>
        return 0;
 8bf:	b8 00 00 00 00       	mov    $0x0,%eax
 8c4:	eb 13                	jmp    8d9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d4:	e9 70 ff ff ff       	jmp    849 <malloc+0x4e>
}
 8d9:	c9                   	leave  
 8da:	c3                   	ret    

000008db <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 8db:	55                   	push   %ebp
 8dc:	89 e5                	mov    %esp,%ebp
 8de:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 8e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8e8:	eb 17                	jmp    901 <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 8f4:	85 c0                	test   %eax,%eax
 8f6:	75 05                	jne    8fd <findNextFreeThreadId+0x22>
			return i;
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	eb 0f                	jmp    90c <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 8fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 901:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 905:	7e e3                	jle    8ea <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 90c:	c9                   	leave  
 90d:	c3                   	ret    

0000090e <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 90e:	55                   	push   %ebp
 90f:	89 e5                	mov    %esp,%ebp
 911:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 914:	a1 20 15 00 00       	mov    0x1520,%eax
 919:	8b 00                	mov    (%eax),%eax
 91b:	8d 50 01             	lea    0x1(%eax),%edx
 91e:	89 d0                	mov    %edx,%eax
 920:	c1 f8 1f             	sar    $0x1f,%eax
 923:	c1 e8 1a             	shr    $0x1a,%eax
 926:	01 c2                	add    %eax,%edx
 928:	83 e2 3f             	and    $0x3f,%edx
 92b:	29 c2                	sub    %eax,%edx
 92d:	89 d0                	mov    %edx,%eax
 92f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 93c:	8b 40 28             	mov    0x28(%eax),%eax
 93f:	83 f8 02             	cmp    $0x2,%eax
 942:	75 0c                	jne    950 <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 944:	8b 45 fc             	mov    -0x4(%ebp),%eax
 947:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 94e:	eb 1c                	jmp    96c <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	8d 50 01             	lea    0x1(%eax),%edx
 956:	89 d0                	mov    %edx,%eax
 958:	c1 f8 1f             	sar    $0x1f,%eax
 95b:	c1 e8 1a             	shr    $0x1a,%eax
 95e:	01 c2                	add    %eax,%edx
 960:	83 e2 3f             	and    $0x3f,%edx
 963:	29 c2                	sub    %eax,%edx
 965:	89 d0                	mov    %edx,%eax
 967:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 96a:	eb c6                	jmp    932 <findNextRunnableThread+0x24>
}
 96c:	c9                   	leave  
 96d:	c3                   	ret    

0000096e <uthread_init>:

void uthread_init(void)
{
 96e:	55                   	push   %ebp
 96f:	89 e5                	mov    %esp,%ebp
 971:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 974:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 97b:	eb 12                	jmp    98f <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 97d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 980:	c7 04 85 20 14 00 00 	movl   $0x0,0x1420(,%eax,4)
 987:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 98b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 98f:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 993:	7e e8                	jle    97d <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 995:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 99c:	e8 5a fe ff ff       	call   7fb <malloc>
 9a1:	a3 20 14 00 00       	mov    %eax,0x1420
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 9a6:	a1 20 14 00 00       	mov    0x1420,%eax
 9ab:	89 e2                	mov    %esp,%edx
 9ad:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 9b0:	a1 20 14 00 00       	mov    0x1420,%eax
 9b5:	89 ea                	mov    %ebp,%edx
 9b7:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 9ba:	a1 20 14 00 00       	mov    0x1420,%eax
 9bf:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 9c6:	a1 20 14 00 00       	mov    0x1420,%eax
 9cb:	a3 20 15 00 00       	mov    %eax,0x1520
	threadTable.threadCount = 1;
 9d0:	c7 05 24 15 00 00 01 	movl   $0x1,0x1524
 9d7:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 9da:	c7 44 24 04 b3 0b 00 	movl   $0xbb3,0x4(%esp)
 9e1:	00 
 9e2:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 9e9:	e8 99 f9 ff ff       	call   387 <signal>
	alarm(UTHREAD_QUANTA);
 9ee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 9f5:	e8 9d f9 ff ff       	call   397 <alarm>
}
 9fa:	c9                   	leave  
 9fb:	c3                   	ret    

000009fc <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 9fc:	55                   	push   %ebp
 9fd:	89 e5                	mov    %esp,%ebp
 9ff:	53                   	push   %ebx
 a00:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 a03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 a0a:	e8 88 f9 ff ff       	call   397 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 a0f:	e8 c7 fe ff ff       	call   8db <findNextFreeThreadId>
 a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 a17:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a1b:	75 0a                	jne    a27 <uthread_create+0x2b>
		return -1;
 a1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a22:	e9 d6 00 00 00       	jmp    afd <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 a27:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 a2e:	e8 c8 fd ff ff       	call   7fb <malloc>
 a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a36:	89 04 95 20 14 00 00 	mov    %eax,0x1420(,%edx,4)
	threadTable.threads[current]->tid = current;
 a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a40:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a4a:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 a56:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 a5d:	a1 24 15 00 00       	mov    0x1524,%eax
 a62:	83 c0 01             	add    $0x1,%eax
 a65:	a3 24 15 00 00       	mov    %eax,0x1524
	threadTable.threads[current]->entry = func;
 a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6d:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 a74:	8b 55 08             	mov    0x8(%ebp),%edx
 a77:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 a84:	8b 55 0c             	mov    0xc(%ebp),%edx
 a87:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8d:	8b 1c 85 20 14 00 00 	mov    0x1420(,%eax,4),%ebx
 a94:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 a9b:	e8 5b fd ff ff       	call   7fb <malloc>
 aa0:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa6:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ab0:	8b 14 95 20 14 00 00 	mov    0x1420(,%edx,4),%edx
 ab7:	8b 52 24             	mov    0x24(%edx),%edx
 aba:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 ac0:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac6:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ad0:	8b 14 95 20 14 00 00 	mov    0x1420(,%edx,4),%edx
 ad7:	8b 52 04             	mov    0x4(%edx),%edx
 ada:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 ae7:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 aee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 af5:	e8 9d f8 ff ff       	call   397 <alarm>
	return current;
 afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 afd:	83 c4 24             	add    $0x24,%esp
 b00:	5b                   	pop    %ebx
 b01:	5d                   	pop    %ebp
 b02:	c3                   	ret    

00000b03 <uthread_exit>:

void uthread_exit(void)
{
 b03:	55                   	push   %ebp
 b04:	89 e5                	mov    %esp,%ebp
 b06:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 b09:	a1 20 15 00 00       	mov    0x1520,%eax
 b0e:	8b 00                	mov    (%eax),%eax
 b10:	85 c0                	test   %eax,%eax
 b12:	74 10                	je     b24 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 b14:	a1 20 15 00 00       	mov    0x1520,%eax
 b19:	8b 40 24             	mov    0x24(%eax),%eax
 b1c:	89 04 24             	mov    %eax,(%esp)
 b1f:	e8 9e fb ff ff       	call   6c2 <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 b24:	a1 20 15 00 00       	mov    0x1520,%eax
 b29:	8b 00                	mov    (%eax),%eax
 b2b:	c7 04 85 20 14 00 00 	movl   $0x0,0x1420(,%eax,4)
 b32:	00 00 00 00 
	
	free(threadTable.runningThread);
 b36:	a1 20 15 00 00       	mov    0x1520,%eax
 b3b:	89 04 24             	mov    %eax,(%esp)
 b3e:	e8 7f fb ff ff       	call   6c2 <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 b43:	a1 24 15 00 00       	mov    0x1524,%eax
 b48:	83 e8 01             	sub    $0x1,%eax
 b4b:	a3 24 15 00 00       	mov    %eax,0x1524
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 b50:	a1 24 15 00 00       	mov    0x1524,%eax
 b55:	85 c0                	test   %eax,%eax
 b57:	75 05                	jne    b5e <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 b59:	e8 19 f8 ff ff       	call   377 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 b5e:	e8 ab fd ff ff       	call   90e <findNextRunnableThread>
 b63:	a3 20 15 00 00       	mov    %eax,0x1520
	
	threadTable.runningThread->state = T_RUNNING;
 b68:	a1 20 15 00 00       	mov    0x1520,%eax
 b6d:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 b74:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b7b:	e8 17 f8 ff ff       	call   397 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b80:	a1 20 15 00 00       	mov    0x1520,%eax
 b85:	8b 40 04             	mov    0x4(%eax),%eax
 b88:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b8a:	a1 20 15 00 00       	mov    0x1520,%eax
 b8f:	8b 40 08             	mov    0x8(%eax),%eax
 b92:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 b94:	a1 20 15 00 00       	mov    0x1520,%eax
 b99:	8b 40 2c             	mov    0x2c(%eax),%eax
 b9c:	85 c0                	test   %eax,%eax
 b9e:	74 11                	je     bb1 <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 ba0:	a1 20 15 00 00       	mov    0x1520,%eax
 ba5:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 bac:	e8 8e 00 00 00       	call   c3f <wrapper>
	}
	

}
 bb1:	c9                   	leave  
 bb2:	c3                   	ret    

00000bb3 <uthread_yield>:

void uthread_yield(void)
{
 bb3:	55                   	push   %ebp
 bb4:	89 e5                	mov    %esp,%ebp
 bb6:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 bb9:	a1 20 15 00 00       	mov    0x1520,%eax
 bbe:	89 e2                	mov    %esp,%edx
 bc0:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 bc3:	a1 20 15 00 00       	mov    0x1520,%eax
 bc8:	89 ea                	mov    %ebp,%edx
 bca:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 bcd:	a1 20 15 00 00       	mov    0x1520,%eax
 bd2:	8b 40 28             	mov    0x28(%eax),%eax
 bd5:	83 f8 01             	cmp    $0x1,%eax
 bd8:	75 0c                	jne    be6 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 bda:	a1 20 15 00 00       	mov    0x1520,%eax
 bdf:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 be6:	e8 23 fd ff ff       	call   90e <findNextRunnableThread>
 beb:	a3 20 15 00 00       	mov    %eax,0x1520
	threadTable.runningThread->state = T_RUNNING;
 bf0:	a1 20 15 00 00       	mov    0x1520,%eax
 bf5:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 bfc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c03:	e8 8f f7 ff ff       	call   397 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 c08:	a1 20 15 00 00       	mov    0x1520,%eax
 c0d:	8b 40 04             	mov    0x4(%eax),%eax
 c10:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 c12:	a1 20 15 00 00       	mov    0x1520,%eax
 c17:	8b 40 08             	mov    0x8(%eax),%eax
 c1a:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 c1c:	a1 20 15 00 00       	mov    0x1520,%eax
 c21:	8b 40 2c             	mov    0x2c(%eax),%eax
 c24:	85 c0                	test   %eax,%eax
 c26:	74 14                	je     c3c <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 c28:	a1 20 15 00 00       	mov    0x1520,%eax
 c2d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 c34:	b8 3f 0c 00 00       	mov    $0xc3f,%eax
 c39:	ff d0                	call   *%eax
		asm("ret");
 c3b:	c3                   	ret    
	}
	return;
 c3c:	90                   	nop
}
 c3d:	c9                   	leave  
 c3e:	c3                   	ret    

00000c3f <wrapper>:

void wrapper(void) {
 c3f:	55                   	push   %ebp
 c40:	89 e5                	mov    %esp,%ebp
 c42:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 c45:	a1 20 15 00 00       	mov    0x1520,%eax
 c4a:	8b 40 30             	mov    0x30(%eax),%eax
 c4d:	8b 15 20 15 00 00    	mov    0x1520,%edx
 c53:	8b 52 34             	mov    0x34(%edx),%edx
 c56:	89 14 24             	mov    %edx,(%esp)
 c59:	ff d0                	call   *%eax
	uthread_exit();
 c5b:	e8 a3 fe ff ff       	call   b03 <uthread_exit>
}
 c60:	c9                   	leave  
 c61:	c3                   	ret    

00000c62 <uthread_self>:

int uthread_self(void)
{
 c62:	55                   	push   %ebp
 c63:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 c65:	a1 20 15 00 00       	mov    0x1520,%eax
 c6a:	8b 00                	mov    (%eax),%eax
}
 c6c:	5d                   	pop    %ebp
 c6d:	c3                   	ret    

00000c6e <uthread_join>:

int uthread_join(int tid)
{
 c6e:	55                   	push   %ebp
 c6f:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 c71:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 c75:	7e 07                	jle    c7e <uthread_join+0x10>
		return -1;
 c77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 c7c:	eb 14                	jmp    c92 <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 c7e:	90                   	nop
 c7f:	8b 45 08             	mov    0x8(%ebp),%eax
 c82:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 c89:	85 c0                	test   %eax,%eax
 c8b:	75 f2                	jne    c7f <uthread_join+0x11>
	return 0;
 c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 c92:	5d                   	pop    %ebp
 c93:	c3                   	ret    

00000c94 <uthread_sleep>:

void uthread_sleep(void)
{
 c94:	55                   	push   %ebp
 c95:	89 e5                	mov    %esp,%ebp
 c97:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 c9a:	a1 20 15 00 00       	mov    0x1520,%eax
 c9f:	89 e2                	mov    %esp,%edx
 ca1:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 ca4:	a1 20 15 00 00       	mov    0x1520,%eax
 ca9:	89 ea                	mov    %ebp,%edx
 cab:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 cae:	a1 20 15 00 00       	mov    0x1520,%eax
 cb3:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 cba:	a1 20 15 00 00       	mov    0x1520,%eax
 cbf:	8b 00                	mov    (%eax),%eax
 cc1:	89 44 24 08          	mov    %eax,0x8(%esp)
 cc5:	c7 44 24 04 59 0f 00 	movl   $0xf59,0x4(%esp)
 ccc:	00 
 ccd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cd4:	e8 36 f8 ff ff       	call   50f <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 cd9:	e8 30 fc ff ff       	call   90e <findNextRunnableThread>
 cde:	a3 20 15 00 00       	mov    %eax,0x1520
	threadTable.runningThread->state = T_RUNNING;
 ce3:	a1 20 15 00 00       	mov    0x1520,%eax
 ce8:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 cef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 cf6:	e8 9c f6 ff ff       	call   397 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 cfb:	a1 20 15 00 00       	mov    0x1520,%eax
 d00:	8b 40 08             	mov    0x8(%eax),%eax
 d03:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 d05:	a1 20 15 00 00       	mov    0x1520,%eax
 d0a:	8b 40 04             	mov    0x4(%eax),%eax
 d0d:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 d0f:	a1 20 15 00 00       	mov    0x1520,%eax
 d14:	8b 40 2c             	mov    0x2c(%eax),%eax
 d17:	85 c0                	test   %eax,%eax
 d19:	74 14                	je     d2f <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 d1b:	a1 20 15 00 00       	mov    0x1520,%eax
 d20:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 d27:	b8 3f 0c 00 00       	mov    $0xc3f,%eax
 d2c:	ff d0                	call   *%eax
		asm("ret");
 d2e:	c3                   	ret    
	}
	return;	
 d2f:	90                   	nop
}
 d30:	c9                   	leave  
 d31:	c3                   	ret    

00000d32 <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 d32:	55                   	push   %ebp
 d33:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 d35:	8b 45 08             	mov    0x8(%ebp),%eax
 d38:	8b 04 85 20 14 00 00 	mov    0x1420(,%eax,4),%eax
 d3f:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 d46:	5d                   	pop    %ebp
 d47:	c3                   	ret    

00000d48 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 d48:	55                   	push   %ebp
 d49:	89 e5                	mov    %esp,%ebp
 d4b:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 d4e:	c7 44 24 04 74 0f 00 	movl   $0xf74,0x4(%esp)
 d55:	00 
 d56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d5d:	e8 ad f7 ff ff       	call   50f <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 d69:	eb 26                	jmp    d91 <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 d6b:	8b 45 08             	mov    0x8(%ebp),%eax
 d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 d71:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 d75:	89 44 24 08          	mov    %eax,0x8(%esp)
 d79:	c7 44 24 04 8b 0f 00 	movl   $0xf8b,0x4(%esp)
 d80:	00 
 d81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d88:	e8 82 f7 ff ff       	call   50f <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 d91:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 d95:	7e d4                	jle    d6b <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 d97:	c7 44 24 04 8f 0f 00 	movl   $0xf8f,0x4(%esp)
 d9e:	00 
 d9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 da6:	e8 64 f7 ff ff       	call   50f <printf>
}
 dab:	c9                   	leave  
 dac:	c3                   	ret    

00000dad <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 dad:	55                   	push   %ebp
 dae:	89 e5                	mov    %esp,%ebp
 db0:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 db3:	8b 45 08             	mov    0x8(%ebp),%eax
 db6:	8b 55 0c             	mov    0xc(%ebp),%edx
 db9:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 dbb:	8b 45 08             	mov    0x8(%ebp),%eax
 dbe:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 dc5:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 dc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 dcf:	eb 12                	jmp    de3 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 dd1:	8b 45 08             	mov    0x8(%ebp),%eax
 dd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 dd7:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 dde:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 ddf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 de3:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 de7:	7e e8                	jle    dd1 <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 de9:	c9                   	leave  
 dea:	c3                   	ret    

00000deb <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 deb:	55                   	push   %ebp
 dec:	89 e5                	mov    %esp,%ebp
 dee:	53                   	push   %ebx
 def:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 df2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 df9:	e8 99 f5 ff ff       	call   397 <alarm>
	if (semaphore->value ==0){
 dfe:	8b 45 08             	mov    0x8(%ebp),%eax
 e01:	8b 00                	mov    (%eax),%eax
 e03:	85 c0                	test   %eax,%eax
 e05:	75 34                	jne    e3b <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 e07:	a1 20 15 00 00       	mov    0x1520,%eax
 e0c:	8b 08                	mov    (%eax),%ecx
 e0e:	8b 45 08             	mov    0x8(%ebp),%eax
 e11:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 e17:	8d 58 01             	lea    0x1(%eax),%ebx
 e1a:	8b 55 08             	mov    0x8(%ebp),%edx
 e1d:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 e23:	8b 55 08             	mov    0x8(%ebp),%edx
 e26:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 e2a:	a1 20 15 00 00       	mov    0x1520,%eax
 e2f:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 e36:	e8 78 fd ff ff       	call   bb3 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 e3b:	a1 20 15 00 00       	mov    0x1520,%eax
 e40:	8b 10                	mov    (%eax),%edx
 e42:	8b 45 08             	mov    0x8(%ebp),%eax
 e45:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 e4c:	ff 
	semaphore->value = 0;
 e4d:	8b 45 08             	mov    0x8(%ebp),%eax
 e50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 e56:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e5d:	e8 35 f5 ff ff       	call   397 <alarm>
}
 e62:	83 c4 14             	add    $0x14,%esp
 e65:	5b                   	pop    %ebx
 e66:	5d                   	pop    %ebp
 e67:	c3                   	ret    

00000e68 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 e68:	55                   	push   %ebp
 e69:	89 e5                	mov    %esp,%ebp
 e6b:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 e6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 e75:	e8 1d f5 ff ff       	call   397 <alarm>
	
	if (semaphore->value == 0){
 e7a:	8b 45 08             	mov    0x8(%ebp),%eax
 e7d:	8b 00                	mov    (%eax),%eax
 e7f:	85 c0                	test   %eax,%eax
 e81:	75 71                	jne    ef4 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 e83:	8b 45 08             	mov    0x8(%ebp),%eax
 e86:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 e8f:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 e96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 e9d:	eb 35                	jmp    ed4 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 e9f:	8b 45 08             	mov    0x8(%ebp),%eax
 ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ea5:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 ea9:	83 f8 ff             	cmp    $0xffffffff,%eax
 eac:	74 22                	je     ed0 <binary_semaphore_up+0x68>
 eae:	8b 45 08             	mov    0x8(%ebp),%eax
 eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 eb4:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 eb8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 ebb:	7d 13                	jge    ed0 <binary_semaphore_up+0x68>
				minIndex = i;
 ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 ec3:	8b 45 08             	mov    0x8(%ebp),%eax
 ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ec9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 ed0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 ed4:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 ed8:	7e c5                	jle    e9f <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 eda:	8b 45 08             	mov    0x8(%ebp),%eax
 edd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 ee3:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 ee7:	74 0b                	je     ef4 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 eec:	89 04 24             	mov    %eax,(%esp)
 eef:	e8 3e fe ff ff       	call   d32 <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 ef4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 efb:	e8 97 f4 ff ff       	call   397 <alarm>
	
 f00:	c9                   	leave  
 f01:	c3                   	ret    
