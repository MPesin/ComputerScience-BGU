
_wait2test:     file format elf32-i386


Disassembly of section .text:

00000000 <foo>:
}
*/

void
foo()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i;
  for (i=0;i<100;i++)
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	eb 1f                	jmp    2e <foo+0x2e>
     printf(2, "wait test %d\n",i);
   f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  12:	89 44 24 08          	mov    %eax,0x8(%esp)
  16:	c7 44 24 04 bc 08 00 	movl   $0x8bc,0x4(%esp)
  1d:	00 
  1e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  25:	e8 cd 04 00 00       	call   4f7 <printf>

void
foo()
{
  int i;
  for (i=0;i<100;i++)
  2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  2e:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  32:	7e db                	jle    f <foo+0xf>
     printf(2, "wait test %d\n",i);
  sleep(20);
  34:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
  3b:	e8 d0 03 00 00       	call   410 <sleep>
  for (i=0;i<100;i++)
  40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  47:	eb 1f                	jmp    68 <foo+0x68>
     printf(2, "wait test %d\n",i);
  49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  50:	c7 44 24 04 bc 08 00 	movl   $0x8bc,0x4(%esp)
  57:	00 
  58:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  5f:	e8 93 04 00 00       	call   4f7 <printf>
{
  int i;
  for (i=0;i<100;i++)
     printf(2, "wait test %d\n",i);
  sleep(20);
  for (i=0;i<100;i++)
  64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  68:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  6c:	7e db                	jle    49 <foo+0x49>
     printf(2, "wait test %d\n",i);

}
  6e:	c9                   	leave  
  6f:	c3                   	ret    

00000070 <waittest>:

void
waittest(void)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	83 ec 38             	sub    $0x38,%esp
  int wTime;
  int rTime;
  int ioTime;
  int pid;
  printf(1, "wait test\n");
  76:	c7 44 24 04 ca 08 00 	movl   $0x8ca,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 6d 04 00 00       	call   4f7 <printf>


    pid = fork();
  8a:	e8 d9 02 00 00       	call   368 <fork>
  8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid == 0)
  92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  96:	75 0a                	jne    a2 <waittest+0x32>
    {
      foo();
  98:	e8 63 ff ff ff       	call   0 <foo>
      exit();      
  9d:	e8 ce 02 00 00       	call   370 <exit>
    }
    wait2(&wTime,&rTime,&ioTime);
  a2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  b3:	89 04 24             	mov    %eax,(%esp)
  b6:	e8 c5 02 00 00       	call   380 <wait2>
     printf(1, "wasting time for wait2 \n");
  bb:	c7 44 24 04 d5 08 00 	movl   $0x8d5,0x4(%esp)
  c2:	00 
  c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ca:	e8 28 04 00 00       	call   4f7 <printf>
    printf(1, "wTime: %d rTime: %d ioTime: %d \n",wTime,rTime, ioTime);
  cf:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  e4:	c7 44 24 04 f0 08 00 	movl   $0x8f0,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 ff 03 00 00       	call   4f7 <printf>

}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <main>:
int
main(void)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 e4 f0             	and    $0xfffffff0,%esp
  waittest();
 100:	e8 6b ff ff ff       	call   70 <waittest>
  exit();
 105:	e8 66 02 00 00       	call   370 <exit>
 10a:	90                   	nop
 10b:	90                   	nop

0000010c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	57                   	push   %edi
 110:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 111:	8b 4d 08             	mov    0x8(%ebp),%ecx
 114:	8b 55 10             	mov    0x10(%ebp),%edx
 117:	8b 45 0c             	mov    0xc(%ebp),%eax
 11a:	89 cb                	mov    %ecx,%ebx
 11c:	89 df                	mov    %ebx,%edi
 11e:	89 d1                	mov    %edx,%ecx
 120:	fc                   	cld    
 121:	f3 aa                	rep stos %al,%es:(%edi)
 123:	89 ca                	mov    %ecx,%edx
 125:	89 fb                	mov    %edi,%ebx
 127:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 12d:	5b                   	pop    %ebx
 12e:	5f                   	pop    %edi
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13d:	90                   	nop
 13e:	8b 45 0c             	mov    0xc(%ebp),%eax
 141:	0f b6 10             	movzbl (%eax),%edx
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	88 10                	mov    %dl,(%eax)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	84 c0                	test   %al,%al
 151:	0f 95 c0             	setne  %al
 154:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 158:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 15c:	84 c0                	test   %al,%al
 15e:	75 de                	jne    13e <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	89 d1                	mov    %edx,%ecx
 1a0:	29 c1                	sub    %eax,%ecx
 1a2:	89 c8                	mov    %ecx,%eax
}
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    

000001a6 <strlen>:

uint
strlen(char *s)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b3:	eb 04                	jmp    1b9 <strlen+0x13>
 1b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1bc:	03 45 08             	add    0x8(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ef                	jne    1b5 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d1:	8b 45 10             	mov    0x10(%ebp),%eax
 1d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	89 44 24 04          	mov    %eax,0x4(%esp)
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 04 24             	mov    %eax,(%esp)
 1e5:	e8 22 ff ff ff       	call   10c <stosb>
  return dst;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <strchr>:

char*
strchr(const char *s, char c)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 04             	sub    $0x4,%esp
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fb:	eb 14                	jmp    211 <strchr+0x22>
    if(*s == c)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	3a 45 fc             	cmp    -0x4(%ebp),%al
 206:	75 05                	jne    20d <strchr+0x1e>
      return (char*)s;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	eb 13                	jmp    220 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 e2                	jne    1fd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22f:	eb 44                	jmp    275 <gets+0x53>
    cc = read(0, &c, 1);
 231:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 238:	00 
 239:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23c:	89 44 24 04          	mov    %eax,0x4(%esp)
 240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 247:	e8 4c 01 00 00       	call   398 <read>
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 253:	7e 2d                	jle    282 <gets+0x60>
      break;
    buf[i++] = c;
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	03 45 08             	add    0x8(%ebp),%eax
 25b:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 25f:	88 10                	mov    %dl,(%eax)
 261:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 265:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 269:	3c 0a                	cmp    $0xa,%al
 26b:	74 16                	je     283 <gets+0x61>
 26d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 271:	3c 0d                	cmp    $0xd,%al
 273:	74 0e                	je     283 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 275:	8b 45 f4             	mov    -0xc(%ebp),%eax
 278:	83 c0 01             	add    $0x1,%eax
 27b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 27e:	7c b1                	jl     231 <gets+0xf>
 280:	eb 01                	jmp    283 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 282:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 283:	8b 45 f4             	mov    -0xc(%ebp),%eax
 286:	03 45 08             	add    0x8(%ebp),%eax
 289:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <stat>:

int
stat(char *n, struct stat *st)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 297:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29e:	00 
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	89 04 24             	mov    %eax,(%esp)
 2a5:	e8 16 01 00 00       	call   3c0 <open>
 2aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b1:	79 07                	jns    2ba <stat+0x29>
    return -1;
 2b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b8:	eb 23                	jmp    2dd <stat+0x4c>
  r = fstat(fd, st);
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c4:	89 04 24             	mov    %eax,(%esp)
 2c7:	e8 0c 01 00 00       	call   3d8 <fstat>
 2cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 ce 00 00 00       	call   3a8 <close>
  return r;
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <atoi>:

int
atoi(const char *s)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ec:	eb 23                	jmp    311 <atoi+0x32>
    n = n*10 + *s++ - '0';
 2ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f1:	89 d0                	mov    %edx,%eax
 2f3:	c1 e0 02             	shl    $0x2,%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	01 c0                	add    %eax,%eax
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	0f be c0             	movsbl %al,%eax
 305:	01 d0                	add    %edx,%eax
 307:	83 e8 30             	sub    $0x30,%eax
 30a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 30d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	0f b6 00             	movzbl (%eax),%eax
 317:	3c 2f                	cmp    $0x2f,%al
 319:	7e 0a                	jle    325 <atoi+0x46>
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	3c 39                	cmp    $0x39,%al
 323:	7e c9                	jle    2ee <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 325:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 33c:	eb 13                	jmp    351 <memmove+0x27>
    *dst++ = *src++;
 33e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 341:	0f b6 10             	movzbl (%eax),%edx
 344:	8b 45 fc             	mov    -0x4(%ebp),%eax
 347:	88 10                	mov    %dl,(%eax)
 349:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 34d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 351:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 355:	0f 9f c0             	setg   %al
 358:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 35c:	84 c0                	test   %al,%al
 35e:	75 de                	jne    33e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 360:	8b 45 08             	mov    0x8(%ebp),%eax
}
 363:	c9                   	leave  
 364:	c3                   	ret    
 365:	90                   	nop
 366:	90                   	nop
 367:	90                   	nop

00000368 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 368:	b8 01 00 00 00       	mov    $0x1,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <exit>:
SYSCALL(exit)
 370:	b8 02 00 00 00       	mov    $0x2,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <wait>:
SYSCALL(wait)
 378:	b8 03 00 00 00       	mov    $0x3,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <wait2>:
SYSCALL(wait2)
 380:	b8 16 00 00 00       	mov    $0x16,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <add_path>:
SYSCALL(add_path)
 388:	b8 17 00 00 00       	mov    $0x17,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <pipe>:
SYSCALL(pipe)
 390:	b8 04 00 00 00       	mov    $0x4,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <read>:
SYSCALL(read)
 398:	b8 05 00 00 00       	mov    $0x5,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <write>:
SYSCALL(write)
 3a0:	b8 10 00 00 00       	mov    $0x10,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <close>:
SYSCALL(close)
 3a8:	b8 15 00 00 00       	mov    $0x15,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <kill>:
SYSCALL(kill)
 3b0:	b8 06 00 00 00       	mov    $0x6,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <exec>:
SYSCALL(exec)
 3b8:	b8 07 00 00 00       	mov    $0x7,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <open>:
SYSCALL(open)
 3c0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <mknod>:
SYSCALL(mknod)
 3c8:	b8 11 00 00 00       	mov    $0x11,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <unlink>:
SYSCALL(unlink)
 3d0:	b8 12 00 00 00       	mov    $0x12,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <fstat>:
SYSCALL(fstat)
 3d8:	b8 08 00 00 00       	mov    $0x8,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <link>:
SYSCALL(link)
 3e0:	b8 13 00 00 00       	mov    $0x13,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <mkdir>:
SYSCALL(mkdir)
 3e8:	b8 14 00 00 00       	mov    $0x14,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <chdir>:
SYSCALL(chdir)
 3f0:	b8 09 00 00 00       	mov    $0x9,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <dup>:
SYSCALL(dup)
 3f8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <getpid>:
SYSCALL(getpid)
 400:	b8 0b 00 00 00       	mov    $0xb,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sbrk>:
SYSCALL(sbrk)
 408:	b8 0c 00 00 00       	mov    $0xc,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sleep>:
SYSCALL(sleep)
 410:	b8 0d 00 00 00       	mov    $0xd,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <uptime>:
SYSCALL(uptime)
 418:	b8 0e 00 00 00       	mov    $0xe,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 28             	sub    $0x28,%esp
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 42c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 433:	00 
 434:	8d 45 f4             	lea    -0xc(%ebp),%eax
 437:	89 44 24 04          	mov    %eax,0x4(%esp)
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	89 04 24             	mov    %eax,(%esp)
 441:	e8 5a ff ff ff       	call   3a0 <write>
}
 446:	c9                   	leave  
 447:	c3                   	ret    

00000448 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 455:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 459:	74 17                	je     472 <printint+0x2a>
 45b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45f:	79 11                	jns    472 <printint+0x2a>
    neg = 1;
 461:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 468:	8b 45 0c             	mov    0xc(%ebp),%eax
 46b:	f7 d8                	neg    %eax
 46d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 470:	eb 06                	jmp    478 <printint+0x30>
  } else {
    x = xx;
 472:	8b 45 0c             	mov    0xc(%ebp),%eax
 475:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 482:	8b 45 ec             	mov    -0x14(%ebp),%eax
 485:	ba 00 00 00 00       	mov    $0x0,%edx
 48a:	f7 f1                	div    %ecx
 48c:	89 d0                	mov    %edx,%eax
 48e:	0f b6 90 94 0b 00 00 	movzbl 0xb94(%eax),%edx
 495:	8d 45 dc             	lea    -0x24(%ebp),%eax
 498:	03 45 f4             	add    -0xc(%ebp),%eax
 49b:	88 10                	mov    %dl,(%eax)
 49d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4a1:	8b 55 10             	mov    0x10(%ebp),%edx
 4a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4aa:	ba 00 00 00 00       	mov    $0x0,%edx
 4af:	f7 75 d4             	divl   -0x2c(%ebp)
 4b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b9:	75 c4                	jne    47f <printint+0x37>
  if(neg)
 4bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bf:	74 2a                	je     4eb <printint+0xa3>
    buf[i++] = '-';
 4c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4c4:	03 45 f4             	add    -0xc(%ebp),%eax
 4c7:	c6 00 2d             	movb   $0x2d,(%eax)
 4ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 4ce:	eb 1b                	jmp    4eb <printint+0xa3>
    putc(fd, buf[i]);
 4d0:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4d3:	03 45 f4             	add    -0xc(%ebp),%eax
 4d6:	0f b6 00             	movzbl (%eax),%eax
 4d9:	0f be c0             	movsbl %al,%eax
 4dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	89 04 24             	mov    %eax,(%esp)
 4e6:	e8 35 ff ff ff       	call   420 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4eb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f3:	79 db                	jns    4d0 <printint+0x88>
    putc(fd, buf[i]);
}
 4f5:	c9                   	leave  
 4f6:	c3                   	ret    

000004f7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f7:	55                   	push   %ebp
 4f8:	89 e5                	mov    %esp,%ebp
 4fa:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 504:	8d 45 0c             	lea    0xc(%ebp),%eax
 507:	83 c0 04             	add    $0x4,%eax
 50a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 514:	e9 7d 01 00 00       	jmp    696 <printf+0x19f>
    c = fmt[i] & 0xff;
 519:	8b 55 0c             	mov    0xc(%ebp),%edx
 51c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51f:	01 d0                	add    %edx,%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	25 ff 00 00 00       	and    $0xff,%eax
 52c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 533:	75 2c                	jne    561 <printf+0x6a>
      if(c == '%'){
 535:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 539:	75 0c                	jne    547 <printf+0x50>
        state = '%';
 53b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 542:	e9 4b 01 00 00       	jmp    692 <printf+0x19b>
      } else {
        putc(fd, c);
 547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	89 44 24 04          	mov    %eax,0x4(%esp)
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	89 04 24             	mov    %eax,(%esp)
 557:	e8 c4 fe ff ff       	call   420 <putc>
 55c:	e9 31 01 00 00       	jmp    692 <printf+0x19b>
      }
    } else if(state == '%'){
 561:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 565:	0f 85 27 01 00 00    	jne    692 <printf+0x19b>
      if(c == 'd'){
 56b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56f:	75 2d                	jne    59e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 571:	8b 45 e8             	mov    -0x18(%ebp),%eax
 574:	8b 00                	mov    (%eax),%eax
 576:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57d:	00 
 57e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 585:	00 
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 b3 fe ff ff       	call   448 <printint>
        ap++;
 595:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 599:	e9 ed 00 00 00       	jmp    68b <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 59e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a2:	74 06                	je     5aa <printf+0xb3>
 5a4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a8:	75 2d                	jne    5d7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b6:	00 
 5b7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5be:	00 
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 7a fe ff ff       	call   448 <printint>
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	e9 b4 00 00 00       	jmp    68b <printf+0x194>
      } else if(c == 's'){
 5d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5db:	75 46                	jne    623 <printf+0x12c>
        s = (char*)*ap;
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ed:	75 27                	jne    616 <printf+0x11f>
          s = "(null)";
 5ef:	c7 45 f4 11 09 00 00 	movl   $0x911,-0xc(%ebp)
        while(*s != 0){
 5f6:	eb 1e                	jmp    616 <printf+0x11f>
          putc(fd, *s);
 5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fb:	0f b6 00             	movzbl (%eax),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	89 44 24 04          	mov    %eax,0x4(%esp)
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	89 04 24             	mov    %eax,(%esp)
 60b:	e8 10 fe ff ff       	call   420 <putc>
          s++;
 610:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 614:	eb 01                	jmp    617 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 616:	90                   	nop
 617:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61a:	0f b6 00             	movzbl (%eax),%eax
 61d:	84 c0                	test   %al,%al
 61f:	75 d7                	jne    5f8 <printf+0x101>
 621:	eb 68                	jmp    68b <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 623:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 627:	75 1d                	jne    646 <printf+0x14f>
        putc(fd, *ap);
 629:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	89 44 24 04          	mov    %eax,0x4(%esp)
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 04 24             	mov    %eax,(%esp)
 63b:	e8 e0 fd ff ff       	call   420 <putc>
        ap++;
 640:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 644:	eb 45                	jmp    68b <printf+0x194>
      } else if(c == '%'){
 646:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64a:	75 17                	jne    663 <printf+0x16c>
        putc(fd, c);
 64c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	89 44 24 04          	mov    %eax,0x4(%esp)
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	89 04 24             	mov    %eax,(%esp)
 65c:	e8 bf fd ff ff       	call   420 <putc>
 661:	eb 28                	jmp    68b <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 663:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 66a:	00 
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 aa fd ff ff       	call   420 <putc>
        putc(fd, c);
 676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 95 fd ff ff       	call   420 <putc>
      }
      state = 0;
 68b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 692:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 696:	8b 55 0c             	mov    0xc(%ebp),%edx
 699:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69c:	01 d0                	add    %edx,%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	84 c0                	test   %al,%al
 6a3:	0f 85 70 fe ff ff    	jne    519 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    
 6ab:	90                   	nop

000006ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	83 e8 08             	sub    $0x8,%eax
 6b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bb:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 6c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c3:	eb 24                	jmp    6e9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cd:	77 12                	ja     6e1 <free+0x35>
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d5:	77 24                	ja     6fb <free+0x4f>
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6df:	77 1a                	ja     6fb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ef:	76 d4                	jbe    6c5 <free+0x19>
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f9:	76 ca                	jbe    6c5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 40 04             	mov    0x4(%eax),%eax
 701:	c1 e0 03             	shl    $0x3,%eax
 704:	89 c2                	mov    %eax,%edx
 706:	03 55 f8             	add    -0x8(%ebp),%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	39 c2                	cmp    %eax,%edx
 710:	75 24                	jne    736 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 50 04             	mov    0x4(%eax),%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	01 c2                	add    %eax,%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	8b 10                	mov    (%eax),%edx
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	89 10                	mov    %edx,(%eax)
 734:	eb 0a                	jmp    740 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	c1 e0 03             	shl    $0x3,%eax
 749:	03 45 fc             	add    -0x4(%ebp),%eax
 74c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74f:	75 20                	jne    771 <free+0xc5>
    p->s.size += bp->s.size;
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 50 04             	mov    0x4(%eax),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	01 c2                	add    %eax,%edx
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 10                	mov    (%eax),%edx
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	89 10                	mov    %edx,(%eax)
 76f:	eb 08                	jmp    779 <free+0xcd>
  } else
    p->s.ptr = bp;
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 55 f8             	mov    -0x8(%ebp),%edx
 777:	89 10                	mov    %edx,(%eax)
  freep = p;
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	a3 b0 0b 00 00       	mov    %eax,0xbb0
}
 781:	c9                   	leave  
 782:	c3                   	ret    

00000783 <morecore>:

static Header*
morecore(uint nu)
{
 783:	55                   	push   %ebp
 784:	89 e5                	mov    %esp,%ebp
 786:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 789:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 790:	77 07                	ja     799 <morecore+0x16>
    nu = 4096;
 792:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	c1 e0 03             	shl    $0x3,%eax
 79f:	89 04 24             	mov    %eax,(%esp)
 7a2:	e8 61 fc ff ff       	call   408 <sbrk>
 7a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7aa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ae:	75 07                	jne    7b7 <morecore+0x34>
    return 0;
 7b0:	b8 00 00 00 00       	mov    $0x0,%eax
 7b5:	eb 22                	jmp    7d9 <morecore+0x56>
  hp = (Header*)p;
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	8b 55 08             	mov    0x8(%ebp),%edx
 7c3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c9:	83 c0 08             	add    $0x8,%eax
 7cc:	89 04 24             	mov    %eax,(%esp)
 7cf:	e8 d8 fe ff ff       	call   6ac <free>
  return freep;
 7d4:	a1 b0 0b 00 00       	mov    0xbb0,%eax
}
 7d9:	c9                   	leave  
 7da:	c3                   	ret    

000007db <malloc>:

void*
malloc(uint nbytes)
{
 7db:	55                   	push   %ebp
 7dc:	89 e5                	mov    %esp,%ebp
 7de:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
 7e4:	83 c0 07             	add    $0x7,%eax
 7e7:	c1 e8 03             	shr    $0x3,%eax
 7ea:	83 c0 01             	add    $0x1,%eax
 7ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f0:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 7f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7fc:	75 23                	jne    821 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7fe:	c7 45 f0 a8 0b 00 00 	movl   $0xba8,-0x10(%ebp)
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	a3 b0 0b 00 00       	mov    %eax,0xbb0
 80d:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 812:	a3 a8 0b 00 00       	mov    %eax,0xba8
    base.s.size = 0;
 817:	c7 05 ac 0b 00 00 00 	movl   $0x0,0xbac
 81e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 832:	72 4d                	jb     881 <malloc+0xa6>
      if(p->s.size == nunits)
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83d:	75 0c                	jne    84b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 10                	mov    (%eax),%edx
 844:	8b 45 f0             	mov    -0x10(%ebp),%eax
 847:	89 10                	mov    %edx,(%eax)
 849:	eb 26                	jmp    871 <malloc+0x96>
      else {
        p->s.size -= nunits;
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	89 c2                	mov    %eax,%edx
 853:	2b 55 ec             	sub    -0x14(%ebp),%edx
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	c1 e0 03             	shl    $0x3,%eax
 865:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	a3 b0 0b 00 00       	mov    %eax,0xbb0
      return (void*)(p + 1);
 879:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87c:	83 c0 08             	add    $0x8,%eax
 87f:	eb 38                	jmp    8b9 <malloc+0xde>
    }
    if(p == freep)
 881:	a1 b0 0b 00 00       	mov    0xbb0,%eax
 886:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 889:	75 1b                	jne    8a6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 88b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88e:	89 04 24             	mov    %eax,(%esp)
 891:	e8 ed fe ff ff       	call   783 <morecore>
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)
 899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89d:	75 07                	jne    8a6 <malloc+0xcb>
        return 0;
 89f:	b8 00 00 00 00       	mov    $0x0,%eax
 8a4:	eb 13                	jmp    8b9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 00                	mov    (%eax),%eax
 8b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b4:	e9 70 ff ff ff       	jmp    829 <malloc+0x4e>
}
 8b9:	c9                   	leave  
 8ba:	c3                   	ret    
