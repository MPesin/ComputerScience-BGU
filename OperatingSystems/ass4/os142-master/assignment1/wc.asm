
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 60 0c 00 00       	add    $0xc60,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 60 0c 00 00       	add    $0xc60,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 73 09 00 00 	movl   $0x973,(%esp)
  5b:	e8 47 02 00 00       	call   2a7 <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 ab 03 00 00       	call   450 <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 79 09 00 	movl   $0x979,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 e3 04 00 00       	call   5af <printf>
    exit();
  cc:	e8 57 03 00 00       	call   428 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 89 09 00 	movl   $0x989,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 ae 04 00 00       	call   5af <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 96 09 00 	movl   $0x996,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 fd 02 00 00       	call   428 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	eb 7d                	jmp    1b2 <main+0xaf>
    if((fd = open(argv[i], 0)) < 0){
 135:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 139:	c1 e0 02             	shl    $0x2,%eax
 13c:	03 45 0c             	add    0xc(%ebp),%eax
 13f:	8b 00                	mov    (%eax),%eax
 141:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 148:	00 
 149:	89 04 24             	mov    %eax,(%esp)
 14c:	e8 27 03 00 00       	call   478 <open>
 151:	89 44 24 18          	mov    %eax,0x18(%esp)
 155:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 15a:	79 29                	jns    185 <main+0x82>
      printf(1, "cat: cannot open %s\n", argv[i]);
 15c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 160:	c1 e0 02             	shl    $0x2,%eax
 163:	03 45 0c             	add    0xc(%ebp),%eax
 166:	8b 00                	mov    (%eax),%eax
 168:	89 44 24 08          	mov    %eax,0x8(%esp)
 16c:	c7 44 24 04 97 09 00 	movl   $0x997,0x4(%esp)
 173:	00 
 174:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17b:	e8 2f 04 00 00       	call   5af <printf>
      exit();
 180:	e8 a3 02 00 00       	call   428 <exit>
    }
    wc(fd, argv[i]);
 185:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 189:	c1 e0 02             	shl    $0x2,%eax
 18c:	03 45 0c             	add    0xc(%ebp),%eax
 18f:	8b 00                	mov    (%eax),%eax
 191:	89 44 24 04          	mov    %eax,0x4(%esp)
 195:	8b 44 24 18          	mov    0x18(%esp),%eax
 199:	89 04 24             	mov    %eax,(%esp)
 19c:	e8 5f fe ff ff       	call   0 <wc>
    close(fd);
 1a1:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a5:	89 04 24             	mov    %eax,(%esp)
 1a8:	e8 b3 02 00 00       	call   460 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1ad:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1b2:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1b6:	3b 45 08             	cmp    0x8(%ebp),%eax
 1b9:	0f 8c 76 ff ff ff    	jl     135 <main+0x32>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1bf:	e8 64 02 00 00       	call   428 <exit>

000001c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cc:	8b 55 10             	mov    0x10(%ebp),%edx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	89 cb                	mov    %ecx,%ebx
 1d4:	89 df                	mov    %ebx,%edi
 1d6:	89 d1                	mov    %edx,%ecx
 1d8:	fc                   	cld    
 1d9:	f3 aa                	rep stos %al,%es:(%edi)
 1db:	89 ca                	mov    %ecx,%edx
 1dd:	89 fb                	mov    %edi,%ebx
 1df:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e5:	5b                   	pop    %ebx
 1e6:	5f                   	pop    %edi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    

000001e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f5:	90                   	nop
 1f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f9:	0f b6 10             	movzbl (%eax),%edx
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	88 10                	mov    %dl,(%eax)
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	84 c0                	test   %al,%al
 209:	0f 95 c0             	setne  %al
 20c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 210:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 214:	84 c0                	test   %al,%al
 216:	75 de                	jne    1f6 <strcpy+0xd>
    ;
  return os;
 218:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21b:	c9                   	leave  
 21c:	c3                   	ret    

0000021d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 220:	eb 08                	jmp    22a <strcmp+0xd>
    p++, q++;
 222:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 226:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 00             	movzbl (%eax),%eax
 230:	84 c0                	test   %al,%al
 232:	74 10                	je     244 <strcmp+0x27>
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 10             	movzbl (%eax),%edx
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	38 c2                	cmp    %al,%dl
 242:	74 de                	je     222 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	0f b6 00             	movzbl (%eax),%eax
 24a:	0f b6 d0             	movzbl %al,%edx
 24d:	8b 45 0c             	mov    0xc(%ebp),%eax
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f b6 c0             	movzbl %al,%eax
 256:	89 d1                	mov    %edx,%ecx
 258:	29 c1                	sub    %eax,%ecx
 25a:	89 c8                	mov    %ecx,%eax
}
 25c:	5d                   	pop    %ebp
 25d:	c3                   	ret    

0000025e <strlen>:

uint
strlen(char *s)
{
 25e:	55                   	push   %ebp
 25f:	89 e5                	mov    %esp,%ebp
 261:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26b:	eb 04                	jmp    271 <strlen+0x13>
 26d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
 274:	03 45 08             	add    0x8(%ebp),%eax
 277:	0f b6 00             	movzbl (%eax),%eax
 27a:	84 c0                	test   %al,%al
 27c:	75 ef                	jne    26d <strlen+0xf>
    ;
  return n;
 27e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <memset>:

void*
memset(void *dst, int c, uint n)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 289:	8b 45 10             	mov    0x10(%ebp),%eax
 28c:	89 44 24 08          	mov    %eax,0x8(%esp)
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 44 24 04          	mov    %eax,0x4(%esp)
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 22 ff ff ff       	call   1c4 <stosb>
  return dst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a5:	c9                   	leave  
 2a6:	c3                   	ret    

000002a7 <strchr>:

char*
strchr(const char *s, char c)
{
 2a7:	55                   	push   %ebp
 2a8:	89 e5                	mov    %esp,%ebp
 2aa:	83 ec 04             	sub    $0x4,%esp
 2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b3:	eb 14                	jmp    2c9 <strchr+0x22>
    if(*s == c)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2be:	75 05                	jne    2c5 <strchr+0x1e>
      return (char*)s;
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	eb 13                	jmp    2d8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	84 c0                	test   %al,%al
 2d1:	75 e2                	jne    2b5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <gets>:

char*
gets(char *buf, int max)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e7:	eb 44                	jmp    32d <gets+0x53>
    cc = read(0, &c, 1);
 2e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f0:	00 
 2f1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ff:	e8 4c 01 00 00       	call   450 <read>
 304:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30b:	7e 2d                	jle    33a <gets+0x60>
      break;
    buf[i++] = c;
 30d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 310:	03 45 08             	add    0x8(%ebp),%eax
 313:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 317:	88 10                	mov    %dl,(%eax)
 319:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 31d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 321:	3c 0a                	cmp    $0xa,%al
 323:	74 16                	je     33b <gets+0x61>
 325:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 329:	3c 0d                	cmp    $0xd,%al
 32b:	74 0e                	je     33b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 330:	83 c0 01             	add    $0x1,%eax
 333:	3b 45 0c             	cmp    0xc(%ebp),%eax
 336:	7c b1                	jl     2e9 <gets+0xf>
 338:	eb 01                	jmp    33b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 33a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 33b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33e:	03 45 08             	add    0x8(%ebp),%eax
 341:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <stat>:

int
stat(char *n, struct stat *st)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 356:	00 
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 16 01 00 00       	call   478 <open>
 362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 369:	79 07                	jns    372 <stat+0x29>
    return -1;
 36b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 370:	eb 23                	jmp    395 <stat+0x4c>
  r = fstat(fd, st);
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	89 44 24 04          	mov    %eax,0x4(%esp)
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 0c 01 00 00       	call   490 <fstat>
 384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 ce 00 00 00       	call   460 <close>
  return r;
 392:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <atoi>:

int
atoi(const char *s)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a4:	eb 23                	jmp    3c9 <atoi+0x32>
    n = n*10 + *s++ - '0';
 3a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	c1 e0 02             	shl    $0x2,%eax
 3ae:	01 d0                	add    %edx,%eax
 3b0:	01 c0                	add    %eax,%eax
 3b2:	89 c2                	mov    %eax,%edx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	0f b6 00             	movzbl (%eax),%eax
 3ba:	0f be c0             	movsbl %al,%eax
 3bd:	01 d0                	add    %edx,%eax
 3bf:	83 e8 30             	sub    $0x30,%eax
 3c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 2f                	cmp    $0x2f,%al
 3d1:	7e 0a                	jle    3dd <atoi+0x46>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	3c 39                	cmp    $0x39,%al
 3db:	7e c9                	jle    3a6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e0:	c9                   	leave  
 3e1:	c3                   	ret    

000003e2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e2:	55                   	push   %ebp
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f4:	eb 13                	jmp    409 <memmove+0x27>
    *dst++ = *src++;
 3f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f9:	0f b6 10             	movzbl (%eax),%edx
 3fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ff:	88 10                	mov    %dl,(%eax)
 401:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 405:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 409:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 40d:	0f 9f c0             	setg   %al
 410:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 414:	84 c0                	test   %al,%al
 416:	75 de                	jne    3f6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 418:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41b:	c9                   	leave  
 41c:	c3                   	ret    
 41d:	90                   	nop
 41e:	90                   	nop
 41f:	90                   	nop

00000420 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 420:	b8 01 00 00 00       	mov    $0x1,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <exit>:
SYSCALL(exit)
 428:	b8 02 00 00 00       	mov    $0x2,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <wait>:
SYSCALL(wait)
 430:	b8 03 00 00 00       	mov    $0x3,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <wait2>:
SYSCALL(wait2)
 438:	b8 16 00 00 00       	mov    $0x16,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <add_path>:
SYSCALL(add_path)
 440:	b8 17 00 00 00       	mov    $0x17,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <pipe>:
SYSCALL(pipe)
 448:	b8 04 00 00 00       	mov    $0x4,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <read>:
SYSCALL(read)
 450:	b8 05 00 00 00       	mov    $0x5,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <write>:
SYSCALL(write)
 458:	b8 10 00 00 00       	mov    $0x10,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <close>:
SYSCALL(close)
 460:	b8 15 00 00 00       	mov    $0x15,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <kill>:
SYSCALL(kill)
 468:	b8 06 00 00 00       	mov    $0x6,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <exec>:
SYSCALL(exec)
 470:	b8 07 00 00 00       	mov    $0x7,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <open>:
SYSCALL(open)
 478:	b8 0f 00 00 00       	mov    $0xf,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <mknod>:
SYSCALL(mknod)
 480:	b8 11 00 00 00       	mov    $0x11,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <unlink>:
SYSCALL(unlink)
 488:	b8 12 00 00 00       	mov    $0x12,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <fstat>:
SYSCALL(fstat)
 490:	b8 08 00 00 00       	mov    $0x8,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <link>:
SYSCALL(link)
 498:	b8 13 00 00 00       	mov    $0x13,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <mkdir>:
SYSCALL(mkdir)
 4a0:	b8 14 00 00 00       	mov    $0x14,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <chdir>:
SYSCALL(chdir)
 4a8:	b8 09 00 00 00       	mov    $0x9,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <dup>:
SYSCALL(dup)
 4b0:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <getpid>:
SYSCALL(getpid)
 4b8:	b8 0b 00 00 00       	mov    $0xb,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <sbrk>:
SYSCALL(sbrk)
 4c0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <sleep>:
SYSCALL(sleep)
 4c8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <uptime>:
SYSCALL(uptime)
 4d0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 28             	sub    $0x28,%esp
 4de:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4eb:	00 
 4ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	89 04 24             	mov    %eax,(%esp)
 4f9:	e8 5a ff ff ff       	call   458 <write>
}
 4fe:	c9                   	leave  
 4ff:	c3                   	ret    

00000500 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 506:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 50d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 511:	74 17                	je     52a <printint+0x2a>
 513:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 517:	79 11                	jns    52a <printint+0x2a>
    neg = 1;
 519:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 520:	8b 45 0c             	mov    0xc(%ebp),%eax
 523:	f7 d8                	neg    %eax
 525:	89 45 ec             	mov    %eax,-0x14(%ebp)
 528:	eb 06                	jmp    530 <printint+0x30>
  } else {
    x = xx;
 52a:	8b 45 0c             	mov    0xc(%ebp),%eax
 52d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 537:	8b 4d 10             	mov    0x10(%ebp),%ecx
 53a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53d:	ba 00 00 00 00       	mov    $0x0,%edx
 542:	f7 f1                	div    %ecx
 544:	89 d0                	mov    %edx,%eax
 546:	0f b6 90 10 0c 00 00 	movzbl 0xc10(%eax),%edx
 54d:	8d 45 dc             	lea    -0x24(%ebp),%eax
 550:	03 45 f4             	add    -0xc(%ebp),%eax
 553:	88 10                	mov    %dl,(%eax)
 555:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 559:	8b 55 10             	mov    0x10(%ebp),%edx
 55c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 55f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 562:	ba 00 00 00 00       	mov    $0x0,%edx
 567:	f7 75 d4             	divl   -0x2c(%ebp)
 56a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 56d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 571:	75 c4                	jne    537 <printint+0x37>
  if(neg)
 573:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 577:	74 2a                	je     5a3 <printint+0xa3>
    buf[i++] = '-';
 579:	8d 45 dc             	lea    -0x24(%ebp),%eax
 57c:	03 45 f4             	add    -0xc(%ebp),%eax
 57f:	c6 00 2d             	movb   $0x2d,(%eax)
 582:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 586:	eb 1b                	jmp    5a3 <printint+0xa3>
    putc(fd, buf[i]);
 588:	8d 45 dc             	lea    -0x24(%ebp),%eax
 58b:	03 45 f4             	add    -0xc(%ebp),%eax
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	89 44 24 04          	mov    %eax,0x4(%esp)
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	89 04 24             	mov    %eax,(%esp)
 59e:	e8 35 ff ff ff       	call   4d8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5a3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ab:	79 db                	jns    588 <printint+0x88>
    putc(fd, buf[i]);
}
 5ad:	c9                   	leave  
 5ae:	c3                   	ret    

000005af <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5af:	55                   	push   %ebp
 5b0:	89 e5                	mov    %esp,%ebp
 5b2:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5bc:	8d 45 0c             	lea    0xc(%ebp),%eax
 5bf:	83 c0 04             	add    $0x4,%eax
 5c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5cc:	e9 7d 01 00 00       	jmp    74e <printf+0x19f>
    c = fmt[i] & 0xff;
 5d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d7:	01 d0                	add    %edx,%eax
 5d9:	0f b6 00             	movzbl (%eax),%eax
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	25 ff 00 00 00       	and    $0xff,%eax
 5e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5eb:	75 2c                	jne    619 <printf+0x6a>
      if(c == '%'){
 5ed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f1:	75 0c                	jne    5ff <printf+0x50>
        state = '%';
 5f3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5fa:	e9 4b 01 00 00       	jmp    74a <printf+0x19b>
      } else {
        putc(fd, c);
 5ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 602:	0f be c0             	movsbl %al,%eax
 605:	89 44 24 04          	mov    %eax,0x4(%esp)
 609:	8b 45 08             	mov    0x8(%ebp),%eax
 60c:	89 04 24             	mov    %eax,(%esp)
 60f:	e8 c4 fe ff ff       	call   4d8 <putc>
 614:	e9 31 01 00 00       	jmp    74a <printf+0x19b>
      }
    } else if(state == '%'){
 619:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 61d:	0f 85 27 01 00 00    	jne    74a <printf+0x19b>
      if(c == 'd'){
 623:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 627:	75 2d                	jne    656 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 629:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 635:	00 
 636:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 63d:	00 
 63e:	89 44 24 04          	mov    %eax,0x4(%esp)
 642:	8b 45 08             	mov    0x8(%ebp),%eax
 645:	89 04 24             	mov    %eax,(%esp)
 648:	e8 b3 fe ff ff       	call   500 <printint>
        ap++;
 64d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 651:	e9 ed 00 00 00       	jmp    743 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 656:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 65a:	74 06                	je     662 <printf+0xb3>
 65c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 660:	75 2d                	jne    68f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 662:	8b 45 e8             	mov    -0x18(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 66e:	00 
 66f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 676:	00 
 677:	89 44 24 04          	mov    %eax,0x4(%esp)
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 7a fe ff ff       	call   500 <printint>
        ap++;
 686:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68a:	e9 b4 00 00 00       	jmp    743 <printf+0x194>
      } else if(c == 's'){
 68f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 693:	75 46                	jne    6db <printf+0x12c>
        s = (char*)*ap;
 695:	8b 45 e8             	mov    -0x18(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 69d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a5:	75 27                	jne    6ce <printf+0x11f>
          s = "(null)";
 6a7:	c7 45 f4 ac 09 00 00 	movl   $0x9ac,-0xc(%ebp)
        while(*s != 0){
 6ae:	eb 1e                	jmp    6ce <printf+0x11f>
          putc(fd, *s);
 6b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b3:	0f b6 00             	movzbl (%eax),%eax
 6b6:	0f be c0             	movsbl %al,%eax
 6b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	89 04 24             	mov    %eax,(%esp)
 6c3:	e8 10 fe ff ff       	call   4d8 <putc>
          s++;
 6c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6cc:	eb 01                	jmp    6cf <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ce:	90                   	nop
 6cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d2:	0f b6 00             	movzbl (%eax),%eax
 6d5:	84 c0                	test   %al,%al
 6d7:	75 d7                	jne    6b0 <printf+0x101>
 6d9:	eb 68                	jmp    743 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6db:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6df:	75 1d                	jne    6fe <printf+0x14f>
        putc(fd, *ap);
 6e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	0f be c0             	movsbl %al,%eax
 6e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ed:	8b 45 08             	mov    0x8(%ebp),%eax
 6f0:	89 04 24             	mov    %eax,(%esp)
 6f3:	e8 e0 fd ff ff       	call   4d8 <putc>
        ap++;
 6f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fc:	eb 45                	jmp    743 <printf+0x194>
      } else if(c == '%'){
 6fe:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 702:	75 17                	jne    71b <printf+0x16c>
        putc(fd, c);
 704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 707:	0f be c0             	movsbl %al,%eax
 70a:	89 44 24 04          	mov    %eax,0x4(%esp)
 70e:	8b 45 08             	mov    0x8(%ebp),%eax
 711:	89 04 24             	mov    %eax,(%esp)
 714:	e8 bf fd ff ff       	call   4d8 <putc>
 719:	eb 28                	jmp    743 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 71b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 722:	00 
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	89 04 24             	mov    %eax,(%esp)
 729:	e8 aa fd ff ff       	call   4d8 <putc>
        putc(fd, c);
 72e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 731:	0f be c0             	movsbl %al,%eax
 734:	89 44 24 04          	mov    %eax,0x4(%esp)
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	89 04 24             	mov    %eax,(%esp)
 73e:	e8 95 fd ff ff       	call   4d8 <putc>
      }
      state = 0;
 743:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 74a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 74e:	8b 55 0c             	mov    0xc(%ebp),%edx
 751:	8b 45 f0             	mov    -0x10(%ebp),%eax
 754:	01 d0                	add    %edx,%eax
 756:	0f b6 00             	movzbl (%eax),%eax
 759:	84 c0                	test   %al,%al
 75b:	0f 85 70 fe ff ff    	jne    5d1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 761:	c9                   	leave  
 762:	c3                   	ret    
 763:	90                   	nop

00000764 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76a:	8b 45 08             	mov    0x8(%ebp),%eax
 76d:	83 e8 08             	sub    $0x8,%eax
 770:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 773:	a1 48 0c 00 00       	mov    0xc48,%eax
 778:	89 45 fc             	mov    %eax,-0x4(%ebp)
 77b:	eb 24                	jmp    7a1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 00                	mov    (%eax),%eax
 782:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 785:	77 12                	ja     799 <free+0x35>
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78d:	77 24                	ja     7b3 <free+0x4f>
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 00                	mov    (%eax),%eax
 794:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 797:	77 1a                	ja     7b3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a7:	76 d4                	jbe    77d <free+0x19>
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b1:	76 ca                	jbe    77d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b6:	8b 40 04             	mov    0x4(%eax),%eax
 7b9:	c1 e0 03             	shl    $0x3,%eax
 7bc:	89 c2                	mov    %eax,%edx
 7be:	03 55 f8             	add    -0x8(%ebp),%edx
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	39 c2                	cmp    %eax,%edx
 7c8:	75 24                	jne    7ee <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	8b 50 04             	mov    0x4(%eax),%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	01 c2                	add    %eax,%edx
 7da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
 7ec:	eb 0a                	jmp    7f8 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	c1 e0 03             	shl    $0x3,%eax
 801:	03 45 fc             	add    -0x4(%ebp),%eax
 804:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 807:	75 20                	jne    829 <free+0xc5>
    p->s.size += bp->s.size;
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 50 04             	mov    0x4(%eax),%edx
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	01 c2                	add    %eax,%edx
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 820:	8b 10                	mov    (%eax),%edx
 822:	8b 45 fc             	mov    -0x4(%ebp),%eax
 825:	89 10                	mov    %edx,(%eax)
 827:	eb 08                	jmp    831 <free+0xcd>
  } else
    p->s.ptr = bp;
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82f:	89 10                	mov    %edx,(%eax)
  freep = p;
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	a3 48 0c 00 00       	mov    %eax,0xc48
}
 839:	c9                   	leave  
 83a:	c3                   	ret    

0000083b <morecore>:

static Header*
morecore(uint nu)
{
 83b:	55                   	push   %ebp
 83c:	89 e5                	mov    %esp,%ebp
 83e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 841:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 848:	77 07                	ja     851 <morecore+0x16>
    nu = 4096;
 84a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 851:	8b 45 08             	mov    0x8(%ebp),%eax
 854:	c1 e0 03             	shl    $0x3,%eax
 857:	89 04 24             	mov    %eax,(%esp)
 85a:	e8 61 fc ff ff       	call   4c0 <sbrk>
 85f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 862:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 866:	75 07                	jne    86f <morecore+0x34>
    return 0;
 868:	b8 00 00 00 00       	mov    $0x0,%eax
 86d:	eb 22                	jmp    891 <morecore+0x56>
  hp = (Header*)p;
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	8b 55 08             	mov    0x8(%ebp),%edx
 87b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 87e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 881:	83 c0 08             	add    $0x8,%eax
 884:	89 04 24             	mov    %eax,(%esp)
 887:	e8 d8 fe ff ff       	call   764 <free>
  return freep;
 88c:	a1 48 0c 00 00       	mov    0xc48,%eax
}
 891:	c9                   	leave  
 892:	c3                   	ret    

00000893 <malloc>:

void*
malloc(uint nbytes)
{
 893:	55                   	push   %ebp
 894:	89 e5                	mov    %esp,%ebp
 896:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 899:	8b 45 08             	mov    0x8(%ebp),%eax
 89c:	83 c0 07             	add    $0x7,%eax
 89f:	c1 e8 03             	shr    $0x3,%eax
 8a2:	83 c0 01             	add    $0x1,%eax
 8a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a8:	a1 48 0c 00 00       	mov    0xc48,%eax
 8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b4:	75 23                	jne    8d9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b6:	c7 45 f0 40 0c 00 00 	movl   $0xc40,-0x10(%ebp)
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	a3 48 0c 00 00       	mov    %eax,0xc48
 8c5:	a1 48 0c 00 00       	mov    0xc48,%eax
 8ca:	a3 40 0c 00 00       	mov    %eax,0xc40
    base.s.size = 0;
 8cf:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 8d6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ea:	72 4d                	jb     939 <malloc+0xa6>
      if(p->s.size == nunits)
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f5:	75 0c                	jne    903 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	89 10                	mov    %edx,(%eax)
 901:	eb 26                	jmp    929 <malloc+0x96>
      else {
        p->s.size -= nunits;
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 40 04             	mov    0x4(%eax),%eax
 909:	89 c2                	mov    %eax,%edx
 90b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 40 04             	mov    0x4(%eax),%eax
 91a:	c1 e0 03             	shl    $0x3,%eax
 91d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 55 ec             	mov    -0x14(%ebp),%edx
 926:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	a3 48 0c 00 00       	mov    %eax,0xc48
      return (void*)(p + 1);
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	83 c0 08             	add    $0x8,%eax
 937:	eb 38                	jmp    971 <malloc+0xde>
    }
    if(p == freep)
 939:	a1 48 0c 00 00       	mov    0xc48,%eax
 93e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 941:	75 1b                	jne    95e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 943:	8b 45 ec             	mov    -0x14(%ebp),%eax
 946:	89 04 24             	mov    %eax,(%esp)
 949:	e8 ed fe ff ff       	call   83b <morecore>
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 955:	75 07                	jne    95e <malloc+0xcb>
        return 0;
 957:	b8 00 00 00 00       	mov    $0x0,%eax
 95c:	eb 13                	jmp    971 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	89 45 f0             	mov    %eax,-0x10(%ebp)
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96c:	e9 70 ff ff ff       	jmp    8e1 <malloc+0x4e>
}
 971:	c9                   	leave  
 972:	c3                   	ret    
