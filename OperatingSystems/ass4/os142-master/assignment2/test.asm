
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <test>:
#include "types.h"
#include "stat.h"
#include "user.h"
 
 
void test(void *t){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        while (i < 50){
   d:	eb 2b                	jmp    3a <test+0x3a>
                printf(1,"thread child %d\n", (int)t);
   f:	8b 45 08             	mov    0x8(%ebp),%eax
  12:	89 44 24 08          	mov    %eax,0x8(%esp)
  16:	c7 44 24 04 b4 0e 00 	movl   $0xeb4,0x4(%esp)
  1d:	00 
  1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  25:	e8 97 04 00 00       	call   4c1 <printf>
                i++;
  2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
                sleep(60);
  2e:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
  35:	e8 97 03 00 00       	call   3d1 <sleep>
#include "user.h"
 
 
void test(void *t){
  int i = 0;
        while (i < 50){
  3a:	83 7d f4 31          	cmpl   $0x31,-0xc(%ebp)
  3e:	7e cf                	jle    f <test+0xf>
                printf(1,"thread child %d\n", (int)t);
                i++;
                sleep(60);
        }
 
}
  40:	c9                   	leave  
  41:	c3                   	ret    

00000042 <main>:
int main(int argc,char** argv){
  42:	55                   	push   %ebp
  43:	89 e5                	mov    %esp,%ebp
  45:	83 e4 f0             	and    $0xfffffff0,%esp
  48:	83 ec 20             	sub    $0x20,%esp
        uthread_init();
  4b:	e8 d0 08 00 00       	call   920 <uthread_init>
        int i;
		for (i=1;i<25;i++){
  50:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  57:	00 
  58:	eb 3e                	jmp    98 <main+0x56>
			int tid = uthread_create(test, (void *) i);
  5a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  69:	e8 40 09 00 00       	call   9ae <uthread_create>
  6e:	89 44 24 18          	mov    %eax,0x18(%esp)
			if (!tid)
  72:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  77:	75 1a                	jne    93 <main+0x51>
                goto out_err;
  79:	90                   	nop
          printf(1,"thread father\n");
          sleep(60);
    }
        exit();
        out_err:
        printf(1,"Faild to create thread, we go bye bye\n");
  7a:	c7 44 24 04 d4 0e 00 	movl   $0xed4,0x4(%esp)
  81:	00 
  82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  89:	e8 33 04 00 00       	call   4c1 <printf>
        exit();
  8e:	e8 96 02 00 00       	call   329 <exit>
 
}
int main(int argc,char** argv){
        uthread_init();
        int i;
		for (i=1;i<25;i++){
  93:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  98:	83 7c 24 1c 18       	cmpl   $0x18,0x1c(%esp)
  9d:	7e bb                	jle    5a <main+0x18>
			if (!tid)
                goto out_err;
		}
		   
    while (1){
          printf(1,"thread father\n");
  9f:	c7 44 24 04 c5 0e 00 	movl   $0xec5,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ae:	e8 0e 04 00 00       	call   4c1 <printf>
          sleep(60);
  b3:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
  ba:	e8 12 03 00 00       	call   3d1 <sleep>
    }
  bf:	eb de                	jmp    9f <main+0x5d>

000000c1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	57                   	push   %edi
  c5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c9:	8b 55 10             	mov    0x10(%ebp),%edx
  cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  cf:	89 cb                	mov    %ecx,%ebx
  d1:	89 df                	mov    %ebx,%edi
  d3:	89 d1                	mov    %edx,%ecx
  d5:	fc                   	cld    
  d6:	f3 aa                	rep stos %al,%es:(%edi)
  d8:	89 ca                	mov    %ecx,%edx
  da:	89 fb                	mov    %edi,%ebx
  dc:	89 5d 08             	mov    %ebx,0x8(%ebp)
  df:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e2:	5b                   	pop    %ebx
  e3:	5f                   	pop    %edi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    

000000e6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f2:	90                   	nop
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	8d 50 01             	lea    0x1(%eax),%edx
  f9:	89 55 08             	mov    %edx,0x8(%ebp)
  fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  ff:	8d 4a 01             	lea    0x1(%edx),%ecx
 102:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 105:	0f b6 12             	movzbl (%edx),%edx
 108:	88 10                	mov    %dl,(%eax)
 10a:	0f b6 00             	movzbl (%eax),%eax
 10d:	84 c0                	test   %al,%al
 10f:	75 e2                	jne    f3 <strcpy+0xd>
    ;
  return os;
 111:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 114:	c9                   	leave  
 115:	c3                   	ret    

00000116 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 116:	55                   	push   %ebp
 117:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 119:	eb 08                	jmp    123 <strcmp+0xd>
    p++, q++;
 11b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	84 c0                	test   %al,%al
 12b:	74 10                	je     13d <strcmp+0x27>
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	0f b6 10             	movzbl (%eax),%edx
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	38 c2                	cmp    %al,%dl
 13b:	74 de                	je     11b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	0f b6 d0             	movzbl %al,%edx
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	0f b6 00             	movzbl (%eax),%eax
 14c:	0f b6 c0             	movzbl %al,%eax
 14f:	29 c2                	sub    %eax,%edx
 151:	89 d0                	mov    %edx,%eax
}
 153:	5d                   	pop    %ebp
 154:	c3                   	ret    

00000155 <strlen>:

uint
strlen(char *s)
{
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
 158:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 162:	eb 04                	jmp    168 <strlen+0x13>
 164:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 168:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 d0                	add    %edx,%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 ed                	jne    164 <strlen+0xf>
    ;
  return n;
 177:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <memset>:

void*
memset(void *dst, int c, uint n)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 182:	8b 45 10             	mov    0x10(%ebp),%eax
 185:	89 44 24 08          	mov    %eax,0x8(%esp)
 189:	8b 45 0c             	mov    0xc(%ebp),%eax
 18c:	89 44 24 04          	mov    %eax,0x4(%esp)
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	89 04 24             	mov    %eax,(%esp)
 196:	e8 26 ff ff ff       	call   c1 <stosb>
  return dst;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 04             	sub    $0x4,%esp
 1a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ac:	eb 14                	jmp    1c2 <strchr+0x22>
    if(*s == c)
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1b7:	75 05                	jne    1be <strchr+0x1e>
      return (char*)s;
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	eb 13                	jmp    1d1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	0f b6 00             	movzbl (%eax),%eax
 1c8:	84 c0                	test   %al,%al
 1ca:	75 e2                	jne    1ae <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d1:	c9                   	leave  
 1d2:	c3                   	ret    

000001d3 <gets>:

char*
gets(char *buf, int max)
{
 1d3:	55                   	push   %ebp
 1d4:	89 e5                	mov    %esp,%ebp
 1d6:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e0:	eb 4c                	jmp    22e <gets+0x5b>
    cc = read(0, &c, 1);
 1e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1e9:	00 
 1ea:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1f8:	e8 5c 01 00 00       	call   359 <read>
 1fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 204:	7f 02                	jg     208 <gets+0x35>
      break;
 206:	eb 31                	jmp    239 <gets+0x66>
    buf[i++] = c;
 208:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20b:	8d 50 01             	lea    0x1(%eax),%edx
 20e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 211:	89 c2                	mov    %eax,%edx
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	01 c2                	add    %eax,%edx
 218:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 21e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 222:	3c 0a                	cmp    $0xa,%al
 224:	74 13                	je     239 <gets+0x66>
 226:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22a:	3c 0d                	cmp    $0xd,%al
 22c:	74 0b                	je     239 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 231:	83 c0 01             	add    $0x1,%eax
 234:	3b 45 0c             	cmp    0xc(%ebp),%eax
 237:	7c a9                	jl     1e2 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 239:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	01 d0                	add    %edx,%eax
 241:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
}
 247:	c9                   	leave  
 248:	c3                   	ret    

00000249 <stat>:

int
stat(char *n, struct stat *st)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 256:	00 
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	89 04 24             	mov    %eax,(%esp)
 25d:	e8 1f 01 00 00       	call   381 <open>
 262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 269:	79 07                	jns    272 <stat+0x29>
    return -1;
 26b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 270:	eb 23                	jmp    295 <stat+0x4c>
  r = fstat(fd, st);
 272:	8b 45 0c             	mov    0xc(%ebp),%eax
 275:	89 44 24 04          	mov    %eax,0x4(%esp)
 279:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27c:	89 04 24             	mov    %eax,(%esp)
 27f:	e8 15 01 00 00       	call   399 <fstat>
 284:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 287:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28a:	89 04 24             	mov    %eax,(%esp)
 28d:	e8 d7 00 00 00       	call   369 <close>
  return r;
 292:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    

00000297 <atoi>:

int
atoi(const char *s)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 29d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a4:	eb 25                	jmp    2cb <atoi+0x34>
    n = n*10 + *s++ - '0';
 2a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a9:	89 d0                	mov    %edx,%eax
 2ab:	c1 e0 02             	shl    $0x2,%eax
 2ae:	01 d0                	add    %edx,%eax
 2b0:	01 c0                	add    %eax,%eax
 2b2:	89 c1                	mov    %eax,%ecx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	8d 50 01             	lea    0x1(%eax),%edx
 2ba:	89 55 08             	mov    %edx,0x8(%ebp)
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	0f be c0             	movsbl %al,%eax
 2c3:	01 c8                	add    %ecx,%eax
 2c5:	83 e8 30             	sub    $0x30,%eax
 2c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	3c 2f                	cmp    $0x2f,%al
 2d3:	7e 0a                	jle    2df <atoi+0x48>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3c 39                	cmp    $0x39,%al
 2dd:	7e c7                	jle    2a6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e2:	c9                   	leave  
 2e3:	c3                   	ret    

000002e4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f6:	eb 17                	jmp    30f <memmove+0x2b>
    *dst++ = *src++;
 2f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2fb:	8d 50 01             	lea    0x1(%eax),%edx
 2fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
 301:	8b 55 f8             	mov    -0x8(%ebp),%edx
 304:	8d 4a 01             	lea    0x1(%edx),%ecx
 307:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30a:	0f b6 12             	movzbl (%edx),%edx
 30d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30f:	8b 45 10             	mov    0x10(%ebp),%eax
 312:	8d 50 ff             	lea    -0x1(%eax),%edx
 315:	89 55 10             	mov    %edx,0x10(%ebp)
 318:	85 c0                	test   %eax,%eax
 31a:	7f dc                	jg     2f8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 321:	b8 01 00 00 00       	mov    $0x1,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <exit>:
SYSCALL(exit)
 329:	b8 02 00 00 00       	mov    $0x2,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <wait>:
SYSCALL(wait)
 331:	b8 03 00 00 00       	mov    $0x3,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <signal>:
SYSCALL(signal)
 339:	b8 18 00 00 00       	mov    $0x18,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <sigsend>:
SYSCALL(sigsend)
 341:	b8 19 00 00 00       	mov    $0x19,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <alarm>:
SYSCALL(alarm)
 349:	b8 1a 00 00 00       	mov    $0x1a,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <pipe>:
SYSCALL(pipe)
 351:	b8 04 00 00 00       	mov    $0x4,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <read>:
SYSCALL(read)
 359:	b8 05 00 00 00       	mov    $0x5,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <write>:
SYSCALL(write)
 361:	b8 10 00 00 00       	mov    $0x10,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <close>:
SYSCALL(close)
 369:	b8 15 00 00 00       	mov    $0x15,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <kill>:
SYSCALL(kill)
 371:	b8 06 00 00 00       	mov    $0x6,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <exec>:
SYSCALL(exec)
 379:	b8 07 00 00 00       	mov    $0x7,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <open>:
SYSCALL(open)
 381:	b8 0f 00 00 00       	mov    $0xf,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <mknod>:
SYSCALL(mknod)
 389:	b8 11 00 00 00       	mov    $0x11,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <unlink>:
SYSCALL(unlink)
 391:	b8 12 00 00 00       	mov    $0x12,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <fstat>:
SYSCALL(fstat)
 399:	b8 08 00 00 00       	mov    $0x8,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <link>:
SYSCALL(link)
 3a1:	b8 13 00 00 00       	mov    $0x13,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <mkdir>:
SYSCALL(mkdir)
 3a9:	b8 14 00 00 00       	mov    $0x14,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <chdir>:
SYSCALL(chdir)
 3b1:	b8 09 00 00 00       	mov    $0x9,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <dup>:
SYSCALL(dup)
 3b9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <getpid>:
SYSCALL(getpid)
 3c1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <sbrk>:
SYSCALL(sbrk)
 3c9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <sleep>:
SYSCALL(sleep)
 3d1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <uptime>:
SYSCALL(uptime)
 3d9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	83 ec 18             	sub    $0x18,%esp
 3e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ea:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f4:	00 
 3f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	89 04 24             	mov    %eax,(%esp)
 402:	e8 5a ff ff ff       	call   361 <write>
}
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	56                   	push   %esi
 40d:	53                   	push   %ebx
 40e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 411:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 418:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41c:	74 17                	je     435 <printint+0x2c>
 41e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 422:	79 11                	jns    435 <printint+0x2c>
    neg = 1;
 424:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	f7 d8                	neg    %eax
 430:	89 45 ec             	mov    %eax,-0x14(%ebp)
 433:	eb 06                	jmp    43b <printint+0x32>
  } else {
    x = xx;
 435:	8b 45 0c             	mov    0xc(%ebp),%eax
 438:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 442:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 445:	8d 41 01             	lea    0x1(%ecx),%eax
 448:	89 45 f4             	mov    %eax,-0xc(%ebp)
 44b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f3                	div    %ebx
 458:	89 d0                	mov    %edx,%eax
 45a:	0f b6 80 9c 13 00 00 	movzbl 0x139c(%eax),%eax
 461:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 465:	8b 75 10             	mov    0x10(%ebp),%esi
 468:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46b:	ba 00 00 00 00       	mov    $0x0,%edx
 470:	f7 f6                	div    %esi
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	75 c7                	jne    442 <printint+0x39>
  if(neg)
 47b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47f:	74 10                	je     491 <printint+0x88>
    buf[i++] = '-';
 481:	8b 45 f4             	mov    -0xc(%ebp),%eax
 484:	8d 50 01             	lea    0x1(%eax),%edx
 487:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 48f:	eb 1f                	jmp    4b0 <printint+0xa7>
 491:	eb 1d                	jmp    4b0 <printint+0xa7>
    putc(fd, buf[i]);
 493:	8d 55 dc             	lea    -0x24(%ebp),%edx
 496:	8b 45 f4             	mov    -0xc(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	0f be c0             	movsbl %al,%eax
 4a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	89 04 24             	mov    %eax,(%esp)
 4ab:	e8 31 ff ff ff       	call   3e1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b8:	79 d9                	jns    493 <printint+0x8a>
    putc(fd, buf[i]);
}
 4ba:	83 c4 30             	add    $0x30,%esp
 4bd:	5b                   	pop    %ebx
 4be:	5e                   	pop    %esi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    

000004c1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ce:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4de:	e9 7c 01 00 00       	jmp    65f <printf+0x19e>
    c = fmt[i] & 0xff;
 4e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e9:	01 d0                	add    %edx,%eax
 4eb:	0f b6 00             	movzbl (%eax),%eax
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	25 ff 00 00 00       	and    $0xff,%eax
 4f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fd:	75 2c                	jne    52b <printf+0x6a>
      if(c == '%'){
 4ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 503:	75 0c                	jne    511 <printf+0x50>
        state = '%';
 505:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 50c:	e9 4a 01 00 00       	jmp    65b <printf+0x19a>
      } else {
        putc(fd, c);
 511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 514:	0f be c0             	movsbl %al,%eax
 517:	89 44 24 04          	mov    %eax,0x4(%esp)
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	89 04 24             	mov    %eax,(%esp)
 521:	e8 bb fe ff ff       	call   3e1 <putc>
 526:	e9 30 01 00 00       	jmp    65b <printf+0x19a>
      }
    } else if(state == '%'){
 52b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52f:	0f 85 26 01 00 00    	jne    65b <printf+0x19a>
      if(c == 'd'){
 535:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 539:	75 2d                	jne    568 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 547:	00 
 548:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 54f:	00 
 550:	89 44 24 04          	mov    %eax,0x4(%esp)
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	89 04 24             	mov    %eax,(%esp)
 55a:	e8 aa fe ff ff       	call   409 <printint>
        ap++;
 55f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 563:	e9 ec 00 00 00       	jmp    654 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 568:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 56c:	74 06                	je     574 <printf+0xb3>
 56e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 572:	75 2d                	jne    5a1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 580:	00 
 581:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 588:	00 
 589:	89 44 24 04          	mov    %eax,0x4(%esp)
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	89 04 24             	mov    %eax,(%esp)
 593:	e8 71 fe ff ff       	call   409 <printint>
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59c:	e9 b3 00 00 00       	jmp    654 <printf+0x193>
      } else if(c == 's'){
 5a1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a5:	75 45                	jne    5ec <printf+0x12b>
        s = (char*)*ap;
 5a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b7:	75 09                	jne    5c2 <printf+0x101>
          s = "(null)";
 5b9:	c7 45 f4 fb 0e 00 00 	movl   $0xefb,-0xc(%ebp)
        while(*s != 0){
 5c0:	eb 1e                	jmp    5e0 <printf+0x11f>
 5c2:	eb 1c                	jmp    5e0 <printf+0x11f>
          putc(fd, *s);
 5c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c7:	0f b6 00             	movzbl (%eax),%eax
 5ca:	0f be c0             	movsbl %al,%eax
 5cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	89 04 24             	mov    %eax,(%esp)
 5d7:	e8 05 fe ff ff       	call   3e1 <putc>
          s++;
 5dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e3:	0f b6 00             	movzbl (%eax),%eax
 5e6:	84 c0                	test   %al,%al
 5e8:	75 da                	jne    5c4 <printf+0x103>
 5ea:	eb 68                	jmp    654 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ec:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f0:	75 1d                	jne    60f <printf+0x14e>
        putc(fd, *ap);
 5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	0f be c0             	movsbl %al,%eax
 5fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	89 04 24             	mov    %eax,(%esp)
 604:	e8 d8 fd ff ff       	call   3e1 <putc>
        ap++;
 609:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60d:	eb 45                	jmp    654 <printf+0x193>
      } else if(c == '%'){
 60f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 613:	75 17                	jne    62c <printf+0x16b>
        putc(fd, c);
 615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 b7 fd ff ff       	call   3e1 <putc>
 62a:	eb 28                	jmp    654 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 633:	00 
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 a2 fd ff ff       	call   3e1 <putc>
        putc(fd, c);
 63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	89 44 24 04          	mov    %eax,0x4(%esp)
 649:	8b 45 08             	mov    0x8(%ebp),%eax
 64c:	89 04 24             	mov    %eax,(%esp)
 64f:	e8 8d fd ff ff       	call   3e1 <putc>
      }
      state = 0;
 654:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65f:	8b 55 0c             	mov    0xc(%ebp),%edx
 662:	8b 45 f0             	mov    -0x10(%ebp),%eax
 665:	01 d0                	add    %edx,%eax
 667:	0f b6 00             	movzbl (%eax),%eax
 66a:	84 c0                	test   %al,%al
 66c:	0f 85 71 fe ff ff    	jne    4e3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 672:	c9                   	leave  
 673:	c3                   	ret    

00000674 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67a:	8b 45 08             	mov    0x8(%ebp),%eax
 67d:	83 e8 08             	sub    $0x8,%eax
 680:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 683:	a1 c8 13 00 00       	mov    0x13c8,%eax
 688:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68b:	eb 24                	jmp    6b1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 695:	77 12                	ja     6a9 <free+0x35>
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69d:	77 24                	ja     6c3 <free+0x4f>
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a7:	77 1a                	ja     6c3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b7:	76 d4                	jbe    68d <free+0x19>
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c1:	76 ca                	jbe    68d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	39 c2                	cmp    %eax,%edx
 6dc:	75 24                	jne    702 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	8b 50 04             	mov    0x4(%eax),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	8b 40 04             	mov    0x4(%eax),%eax
 6ec:	01 c2                	add    %eax,%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	8b 10                	mov    (%eax),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	89 10                	mov    %edx,(%eax)
 700:	eb 0a                	jmp    70c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 10                	mov    (%eax),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 40 04             	mov    0x4(%eax),%eax
 712:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	01 d0                	add    %edx,%eax
 71e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 721:	75 20                	jne    743 <free+0xcf>
    p->s.size += bp->s.size;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 50 04             	mov    0x4(%eax),%edx
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 10                	mov    (%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	89 10                	mov    %edx,(%eax)
 741:	eb 08                	jmp    74b <free+0xd7>
  } else
    p->s.ptr = bp;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 55 f8             	mov    -0x8(%ebp),%edx
 749:	89 10                	mov    %edx,(%eax)
  freep = p;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	a3 c8 13 00 00       	mov    %eax,0x13c8
}
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <morecore>:

static Header*
morecore(uint nu)
{
 755:	55                   	push   %ebp
 756:	89 e5                	mov    %esp,%ebp
 758:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 762:	77 07                	ja     76b <morecore+0x16>
    nu = 4096;
 764:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	c1 e0 03             	shl    $0x3,%eax
 771:	89 04 24             	mov    %eax,(%esp)
 774:	e8 50 fc ff ff       	call   3c9 <sbrk>
 779:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 77c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 780:	75 07                	jne    789 <morecore+0x34>
    return 0;
 782:	b8 00 00 00 00       	mov    $0x0,%eax
 787:	eb 22                	jmp    7ab <morecore+0x56>
  hp = (Header*)p;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	8b 55 08             	mov    0x8(%ebp),%edx
 795:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	83 c0 08             	add    $0x8,%eax
 79e:	89 04 24             	mov    %eax,(%esp)
 7a1:	e8 ce fe ff ff       	call   674 <free>
  return freep;
 7a6:	a1 c8 13 00 00       	mov    0x13c8,%eax
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <malloc>:

void*
malloc(uint nbytes)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	83 c0 07             	add    $0x7,%eax
 7b9:	c1 e8 03             	shr    $0x3,%eax
 7bc:	83 c0 01             	add    $0x1,%eax
 7bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c2:	a1 c8 13 00 00       	mov    0x13c8,%eax
 7c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ce:	75 23                	jne    7f3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 45 f0 c0 13 00 00 	movl   $0x13c0,-0x10(%ebp)
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	a3 c8 13 00 00       	mov    %eax,0x13c8
 7df:	a1 c8 13 00 00       	mov    0x13c8,%eax
 7e4:	a3 c0 13 00 00       	mov    %eax,0x13c0
    base.s.size = 0;
 7e9:	c7 05 c4 13 00 00 00 	movl   $0x0,0x13c4
 7f0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 804:	72 4d                	jb     853 <malloc+0xa6>
      if(p->s.size == nunits)
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80f:	75 0c                	jne    81d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 f0             	mov    -0x10(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 26                	jmp    843 <malloc+0x96>
      else {
        p->s.size -= nunits;
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	2b 45 ec             	sub    -0x14(%ebp),%eax
 826:	89 c2                	mov    %eax,%edx
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	c1 e0 03             	shl    $0x3,%eax
 837:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 840:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	a3 c8 13 00 00       	mov    %eax,0x13c8
      return (void*)(p + 1);
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	83 c0 08             	add    $0x8,%eax
 851:	eb 38                	jmp    88b <malloc+0xde>
    }
    if(p == freep)
 853:	a1 c8 13 00 00       	mov    0x13c8,%eax
 858:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 85b:	75 1b                	jne    878 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 85d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 860:	89 04 24             	mov    %eax,(%esp)
 863:	e8 ed fe ff ff       	call   755 <morecore>
 868:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86f:	75 07                	jne    878 <malloc+0xcb>
        return 0;
 871:	b8 00 00 00 00       	mov    $0x0,%eax
 876:	eb 13                	jmp    88b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 00                	mov    (%eax),%eax
 883:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 886:	e9 70 ff ff ff       	jmp    7fb <malloc+0x4e>
}
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 88d:	55                   	push   %ebp
 88e:	89 e5                	mov    %esp,%ebp
 890:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 893:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 89a:	eb 17                	jmp    8b3 <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 89c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89f:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 8a6:	85 c0                	test   %eax,%eax
 8a8:	75 05                	jne    8af <findNextFreeThreadId+0x22>
			return i;
 8aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ad:	eb 0f                	jmp    8be <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 8af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8b3:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 8b7:	7e e3                	jle    89c <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 8b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 8be:	c9                   	leave  
 8bf:	c3                   	ret    

000008c0 <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 8c6:	a1 e0 14 00 00       	mov    0x14e0,%eax
 8cb:	8b 00                	mov    (%eax),%eax
 8cd:	8d 50 01             	lea    0x1(%eax),%edx
 8d0:	89 d0                	mov    %edx,%eax
 8d2:	c1 f8 1f             	sar    $0x1f,%eax
 8d5:	c1 e8 1a             	shr    $0x1a,%eax
 8d8:	01 c2                	add    %eax,%edx
 8da:	83 e2 3f             	and    $0x3f,%edx
 8dd:	29 c2                	sub    %eax,%edx
 8df:	89 d0                	mov    %edx,%eax
 8e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 8ee:	8b 40 28             	mov    0x28(%eax),%eax
 8f1:	83 f8 02             	cmp    $0x2,%eax
 8f4:	75 0c                	jne    902 <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 8f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f9:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 900:	eb 1c                	jmp    91e <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	8d 50 01             	lea    0x1(%eax),%edx
 908:	89 d0                	mov    %edx,%eax
 90a:	c1 f8 1f             	sar    $0x1f,%eax
 90d:	c1 e8 1a             	shr    $0x1a,%eax
 910:	01 c2                	add    %eax,%edx
 912:	83 e2 3f             	and    $0x3f,%edx
 915:	29 c2                	sub    %eax,%edx
 917:	89 d0                	mov    %edx,%eax
 919:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 91c:	eb c6                	jmp    8e4 <findNextRunnableThread+0x24>
}
 91e:	c9                   	leave  
 91f:	c3                   	ret    

00000920 <uthread_init>:

void uthread_init(void)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 926:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 92d:	eb 12                	jmp    941 <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	c7 04 85 e0 13 00 00 	movl   $0x0,0x13e0(,%eax,4)
 939:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 93d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 941:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 945:	7e e8                	jle    92f <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 947:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 94e:	e8 5a fe ff ff       	call   7ad <malloc>
 953:	a3 e0 13 00 00       	mov    %eax,0x13e0
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 958:	a1 e0 13 00 00       	mov    0x13e0,%eax
 95d:	89 e2                	mov    %esp,%edx
 95f:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 962:	a1 e0 13 00 00       	mov    0x13e0,%eax
 967:	89 ea                	mov    %ebp,%edx
 969:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 96c:	a1 e0 13 00 00       	mov    0x13e0,%eax
 971:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 978:	a1 e0 13 00 00       	mov    0x13e0,%eax
 97d:	a3 e0 14 00 00       	mov    %eax,0x14e0
	threadTable.threadCount = 1;
 982:	c7 05 e4 14 00 00 01 	movl   $0x1,0x14e4
 989:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 98c:	c7 44 24 04 65 0b 00 	movl   $0xb65,0x4(%esp)
 993:	00 
 994:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 99b:	e8 99 f9 ff ff       	call   339 <signal>
	alarm(UTHREAD_QUANTA);
 9a0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 9a7:	e8 9d f9 ff ff       	call   349 <alarm>
}
 9ac:	c9                   	leave  
 9ad:	c3                   	ret    

000009ae <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 9ae:	55                   	push   %ebp
 9af:	89 e5                	mov    %esp,%ebp
 9b1:	53                   	push   %ebx
 9b2:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 9b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 9bc:	e8 88 f9 ff ff       	call   349 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 9c1:	e8 c7 fe ff ff       	call   88d <findNextFreeThreadId>
 9c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 9c9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9cd:	75 0a                	jne    9d9 <uthread_create+0x2b>
		return -1;
 9cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9d4:	e9 d6 00 00 00       	jmp    aaf <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 9d9:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 9e0:	e8 c8 fd ff ff       	call   7ad <malloc>
 9e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9e8:	89 04 95 e0 13 00 00 	mov    %eax,0x13e0(,%edx,4)
	threadTable.threads[current]->tid = current;
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 9f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9fc:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 9fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a01:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 a08:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 a0f:	a1 e4 14 00 00       	mov    0x14e4,%eax
 a14:	83 c0 01             	add    $0x1,%eax
 a17:	a3 e4 14 00 00       	mov    %eax,0x14e4
	threadTable.threads[current]->entry = func;
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 a26:	8b 55 08             	mov    0x8(%ebp),%edx
 a29:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 a36:	8b 55 0c             	mov    0xc(%ebp),%edx
 a39:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3f:	8b 1c 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%ebx
 a46:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 a4d:	e8 5b fd ff ff       	call   7ad <malloc>
 a52:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a62:	8b 14 95 e0 13 00 00 	mov    0x13e0(,%edx,4),%edx
 a69:	8b 52 24             	mov    0x24(%edx),%edx
 a6c:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 a72:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a78:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 a7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a82:	8b 14 95 e0 13 00 00 	mov    0x13e0(,%edx,4),%edx
 a89:	8b 52 04             	mov    0x4(%edx),%edx
 a8c:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 a99:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 aa0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 aa7:	e8 9d f8 ff ff       	call   349 <alarm>
	return current;
 aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 aaf:	83 c4 24             	add    $0x24,%esp
 ab2:	5b                   	pop    %ebx
 ab3:	5d                   	pop    %ebp
 ab4:	c3                   	ret    

00000ab5 <uthread_exit>:

void uthread_exit(void)
{
 ab5:	55                   	push   %ebp
 ab6:	89 e5                	mov    %esp,%ebp
 ab8:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 abb:	a1 e0 14 00 00       	mov    0x14e0,%eax
 ac0:	8b 00                	mov    (%eax),%eax
 ac2:	85 c0                	test   %eax,%eax
 ac4:	74 10                	je     ad6 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 ac6:	a1 e0 14 00 00       	mov    0x14e0,%eax
 acb:	8b 40 24             	mov    0x24(%eax),%eax
 ace:	89 04 24             	mov    %eax,(%esp)
 ad1:	e8 9e fb ff ff       	call   674 <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 ad6:	a1 e0 14 00 00       	mov    0x14e0,%eax
 adb:	8b 00                	mov    (%eax),%eax
 add:	c7 04 85 e0 13 00 00 	movl   $0x0,0x13e0(,%eax,4)
 ae4:	00 00 00 00 
	
	free(threadTable.runningThread);
 ae8:	a1 e0 14 00 00       	mov    0x14e0,%eax
 aed:	89 04 24             	mov    %eax,(%esp)
 af0:	e8 7f fb ff ff       	call   674 <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 af5:	a1 e4 14 00 00       	mov    0x14e4,%eax
 afa:	83 e8 01             	sub    $0x1,%eax
 afd:	a3 e4 14 00 00       	mov    %eax,0x14e4
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 b02:	a1 e4 14 00 00       	mov    0x14e4,%eax
 b07:	85 c0                	test   %eax,%eax
 b09:	75 05                	jne    b10 <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 b0b:	e8 19 f8 ff ff       	call   329 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 b10:	e8 ab fd ff ff       	call   8c0 <findNextRunnableThread>
 b15:	a3 e0 14 00 00       	mov    %eax,0x14e0
	
	threadTable.runningThread->state = T_RUNNING;
 b1a:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b1f:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 b26:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b2d:	e8 17 f8 ff ff       	call   349 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b32:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b37:	8b 40 04             	mov    0x4(%eax),%eax
 b3a:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b3c:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b41:	8b 40 08             	mov    0x8(%eax),%eax
 b44:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 b46:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b4b:	8b 40 2c             	mov    0x2c(%eax),%eax
 b4e:	85 c0                	test   %eax,%eax
 b50:	74 11                	je     b63 <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 b52:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b57:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 b5e:	e8 8e 00 00 00       	call   bf1 <wrapper>
	}
	

}
 b63:	c9                   	leave  
 b64:	c3                   	ret    

00000b65 <uthread_yield>:

void uthread_yield(void)
{
 b65:	55                   	push   %ebp
 b66:	89 e5                	mov    %esp,%ebp
 b68:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 b6b:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b70:	89 e2                	mov    %esp,%edx
 b72:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 b75:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b7a:	89 ea                	mov    %ebp,%edx
 b7c:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 b7f:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b84:	8b 40 28             	mov    0x28(%eax),%eax
 b87:	83 f8 01             	cmp    $0x1,%eax
 b8a:	75 0c                	jne    b98 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 b8c:	a1 e0 14 00 00       	mov    0x14e0,%eax
 b91:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 b98:	e8 23 fd ff ff       	call   8c0 <findNextRunnableThread>
 b9d:	a3 e0 14 00 00       	mov    %eax,0x14e0
	threadTable.runningThread->state = T_RUNNING;
 ba2:	a1 e0 14 00 00       	mov    0x14e0,%eax
 ba7:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 bae:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 bb5:	e8 8f f7 ff ff       	call   349 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 bba:	a1 e0 14 00 00       	mov    0x14e0,%eax
 bbf:	8b 40 04             	mov    0x4(%eax),%eax
 bc2:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 bc4:	a1 e0 14 00 00       	mov    0x14e0,%eax
 bc9:	8b 40 08             	mov    0x8(%eax),%eax
 bcc:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 bce:	a1 e0 14 00 00       	mov    0x14e0,%eax
 bd3:	8b 40 2c             	mov    0x2c(%eax),%eax
 bd6:	85 c0                	test   %eax,%eax
 bd8:	74 14                	je     bee <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 bda:	a1 e0 14 00 00       	mov    0x14e0,%eax
 bdf:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 be6:	b8 f1 0b 00 00       	mov    $0xbf1,%eax
 beb:	ff d0                	call   *%eax
		asm("ret");
 bed:	c3                   	ret    
	}
	return;
 bee:	90                   	nop
}
 bef:	c9                   	leave  
 bf0:	c3                   	ret    

00000bf1 <wrapper>:

void wrapper(void) {
 bf1:	55                   	push   %ebp
 bf2:	89 e5                	mov    %esp,%ebp
 bf4:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 bf7:	a1 e0 14 00 00       	mov    0x14e0,%eax
 bfc:	8b 40 30             	mov    0x30(%eax),%eax
 bff:	8b 15 e0 14 00 00    	mov    0x14e0,%edx
 c05:	8b 52 34             	mov    0x34(%edx),%edx
 c08:	89 14 24             	mov    %edx,(%esp)
 c0b:	ff d0                	call   *%eax
	uthread_exit();
 c0d:	e8 a3 fe ff ff       	call   ab5 <uthread_exit>
}
 c12:	c9                   	leave  
 c13:	c3                   	ret    

00000c14 <uthread_self>:

int uthread_self(void)
{
 c14:	55                   	push   %ebp
 c15:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 c17:	a1 e0 14 00 00       	mov    0x14e0,%eax
 c1c:	8b 00                	mov    (%eax),%eax
}
 c1e:	5d                   	pop    %ebp
 c1f:	c3                   	ret    

00000c20 <uthread_join>:

int uthread_join(int tid)
{
 c20:	55                   	push   %ebp
 c21:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 c23:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 c27:	7e 07                	jle    c30 <uthread_join+0x10>
		return -1;
 c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 c2e:	eb 14                	jmp    c44 <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 c30:	90                   	nop
 c31:	8b 45 08             	mov    0x8(%ebp),%eax
 c34:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 c3b:	85 c0                	test   %eax,%eax
 c3d:	75 f2                	jne    c31 <uthread_join+0x11>
	return 0;
 c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 c44:	5d                   	pop    %ebp
 c45:	c3                   	ret    

00000c46 <uthread_sleep>:

void uthread_sleep(void)
{
 c46:	55                   	push   %ebp
 c47:	89 e5                	mov    %esp,%ebp
 c49:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 c4c:	a1 e0 14 00 00       	mov    0x14e0,%eax
 c51:	89 e2                	mov    %esp,%edx
 c53:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 c56:	a1 e0 14 00 00       	mov    0x14e0,%eax
 c5b:	89 ea                	mov    %ebp,%edx
 c5d:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 c60:	a1 e0 14 00 00       	mov    0x14e0,%eax
 c65:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 c6c:	a1 e0 14 00 00       	mov    0x14e0,%eax
 c71:	8b 00                	mov    (%eax),%eax
 c73:	89 44 24 08          	mov    %eax,0x8(%esp)
 c77:	c7 44 24 04 02 0f 00 	movl   $0xf02,0x4(%esp)
 c7e:	00 
 c7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c86:	e8 36 f8 ff ff       	call   4c1 <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 c8b:	e8 30 fc ff ff       	call   8c0 <findNextRunnableThread>
 c90:	a3 e0 14 00 00       	mov    %eax,0x14e0
	threadTable.runningThread->state = T_RUNNING;
 c95:	a1 e0 14 00 00       	mov    0x14e0,%eax
 c9a:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 ca1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ca8:	e8 9c f6 ff ff       	call   349 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 cad:	a1 e0 14 00 00       	mov    0x14e0,%eax
 cb2:	8b 40 08             	mov    0x8(%eax),%eax
 cb5:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 cb7:	a1 e0 14 00 00       	mov    0x14e0,%eax
 cbc:	8b 40 04             	mov    0x4(%eax),%eax
 cbf:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 cc1:	a1 e0 14 00 00       	mov    0x14e0,%eax
 cc6:	8b 40 2c             	mov    0x2c(%eax),%eax
 cc9:	85 c0                	test   %eax,%eax
 ccb:	74 14                	je     ce1 <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 ccd:	a1 e0 14 00 00       	mov    0x14e0,%eax
 cd2:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 cd9:	b8 f1 0b 00 00       	mov    $0xbf1,%eax
 cde:	ff d0                	call   *%eax
		asm("ret");
 ce0:	c3                   	ret    
	}
	return;	
 ce1:	90                   	nop
}
 ce2:	c9                   	leave  
 ce3:	c3                   	ret    

00000ce4 <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 ce4:	55                   	push   %ebp
 ce5:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 ce7:	8b 45 08             	mov    0x8(%ebp),%eax
 cea:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
 cf1:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 cf8:	5d                   	pop    %ebp
 cf9:	c3                   	ret    

00000cfa <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 cfa:	55                   	push   %ebp
 cfb:	89 e5                	mov    %esp,%ebp
 cfd:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 d00:	c7 44 24 04 1d 0f 00 	movl   $0xf1d,0x4(%esp)
 d07:	00 
 d08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d0f:	e8 ad f7 ff ff       	call   4c1 <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 d1b:	eb 26                	jmp    d43 <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 d1d:	8b 45 08             	mov    0x8(%ebp),%eax
 d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
 d23:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 d27:	89 44 24 08          	mov    %eax,0x8(%esp)
 d2b:	c7 44 24 04 34 0f 00 	movl   $0xf34,0x4(%esp)
 d32:	00 
 d33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d3a:	e8 82 f7 ff ff       	call   4c1 <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 d43:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 d47:	7e d4                	jle    d1d <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 d49:	c7 44 24 04 38 0f 00 	movl   $0xf38,0x4(%esp)
 d50:	00 
 d51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d58:	e8 64 f7 ff ff       	call   4c1 <printf>
}
 d5d:	c9                   	leave  
 d5e:	c3                   	ret    

00000d5f <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 d5f:	55                   	push   %ebp
 d60:	89 e5                	mov    %esp,%ebp
 d62:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 d65:	8b 45 08             	mov    0x8(%ebp),%eax
 d68:	8b 55 0c             	mov    0xc(%ebp),%edx
 d6b:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 d6d:	8b 45 08             	mov    0x8(%ebp),%eax
 d70:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 d77:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 d81:	eb 12                	jmp    d95 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 d83:	8b 45 08             	mov    0x8(%ebp),%eax
 d86:	8b 55 fc             	mov    -0x4(%ebp),%edx
 d89:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 d90:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d91:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 d95:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 d99:	7e e8                	jle    d83 <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 d9b:	c9                   	leave  
 d9c:	c3                   	ret    

00000d9d <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 d9d:	55                   	push   %ebp
 d9e:	89 e5                	mov    %esp,%ebp
 da0:	53                   	push   %ebx
 da1:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 da4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 dab:	e8 99 f5 ff ff       	call   349 <alarm>
	if (semaphore->value ==0){
 db0:	8b 45 08             	mov    0x8(%ebp),%eax
 db3:	8b 00                	mov    (%eax),%eax
 db5:	85 c0                	test   %eax,%eax
 db7:	75 34                	jne    ded <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 db9:	a1 e0 14 00 00       	mov    0x14e0,%eax
 dbe:	8b 08                	mov    (%eax),%ecx
 dc0:	8b 45 08             	mov    0x8(%ebp),%eax
 dc3:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 dc9:	8d 58 01             	lea    0x1(%eax),%ebx
 dcc:	8b 55 08             	mov    0x8(%ebp),%edx
 dcf:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 dd5:	8b 55 08             	mov    0x8(%ebp),%edx
 dd8:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 ddc:	a1 e0 14 00 00       	mov    0x14e0,%eax
 de1:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 de8:	e8 78 fd ff ff       	call   b65 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 ded:	a1 e0 14 00 00       	mov    0x14e0,%eax
 df2:	8b 10                	mov    (%eax),%edx
 df4:	8b 45 08             	mov    0x8(%ebp),%eax
 df7:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 dfe:	ff 
	semaphore->value = 0;
 dff:	8b 45 08             	mov    0x8(%ebp),%eax
 e02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 e08:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e0f:	e8 35 f5 ff ff       	call   349 <alarm>
}
 e14:	83 c4 14             	add    $0x14,%esp
 e17:	5b                   	pop    %ebx
 e18:	5d                   	pop    %ebp
 e19:	c3                   	ret    

00000e1a <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 e1a:	55                   	push   %ebp
 e1b:	89 e5                	mov    %esp,%ebp
 e1d:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 e20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 e27:	e8 1d f5 ff ff       	call   349 <alarm>
	
	if (semaphore->value == 0){
 e2c:	8b 45 08             	mov    0x8(%ebp),%eax
 e2f:	8b 00                	mov    (%eax),%eax
 e31:	85 c0                	test   %eax,%eax
 e33:	75 71                	jne    ea6 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 e35:	8b 45 08             	mov    0x8(%ebp),%eax
 e38:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 e41:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 e48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 e4f:	eb 35                	jmp    e86 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 e51:	8b 45 08             	mov    0x8(%ebp),%eax
 e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e57:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e5b:	83 f8 ff             	cmp    $0xffffffff,%eax
 e5e:	74 22                	je     e82 <binary_semaphore_up+0x68>
 e60:	8b 45 08             	mov    0x8(%ebp),%eax
 e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e66:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e6a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 e6d:	7d 13                	jge    e82 <binary_semaphore_up+0x68>
				minIndex = i;
 e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e72:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 e75:	8b 45 08             	mov    0x8(%ebp),%eax
 e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e7b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 e82:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 e86:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 e8a:	7e c5                	jle    e51 <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 e8c:	8b 45 08             	mov    0x8(%ebp),%eax
 e8f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 e95:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 e99:	74 0b                	je     ea6 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e9e:	89 04 24             	mov    %eax,(%esp)
 ea1:	e8 3e fe ff ff       	call   ce4 <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 ea6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ead:	e8 97 f4 ff ff       	call   349 <alarm>
	
 eb2:	c9                   	leave  
 eb3:	c3                   	ret    
