
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
  32:	05 e0 14 00 00       	add    $0x14e0,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 e0 14 00 00       	add    $0x14e0,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 cc 0f 00 00 	movl   $0xfcc,(%esp)
  5b:	e8 58 02 00 00       	call   2b8 <strchr>
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
  92:	c7 44 24 04 e0 14 00 	movl   $0x14e0,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 cc 03 00 00       	call   471 <read>
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
  b8:	c7 44 24 04 d2 0f 00 	movl   $0xfd2,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 0d 05 00 00       	call   5d9 <printf>
    exit();
  cc:	e8 70 03 00 00       	call   441 <exit>
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
  ed:	c7 44 24 04 e2 0f 00 	movl   $0xfe2,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 d8 04 00 00       	call   5d9 <printf>
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
 112:	c7 44 24 04 ef 0f 00 	movl   $0xfef,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 16 03 00 00       	call   441 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 3f 03 00 00       	call   499 <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "cat: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 f0 0f 00 	movl   $0xff0,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 4a 04 00 00       	call   5d9 <printf>
      exit();
 18f:	e8 ad 02 00 00       	call   441 <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 bf 02 00 00       	call   481 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1d4:	e8 68 02 00 00       	call   441 <exit>

000001d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	57                   	push   %edi
 1dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e1:	8b 55 10             	mov    0x10(%ebp),%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 cb                	mov    %ecx,%ebx
 1e9:	89 df                	mov    %ebx,%edi
 1eb:	89 d1                	mov    %edx,%ecx
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
 1f0:	89 ca                	mov    %ecx,%edx
 1f2:	89 fb                	mov    %edi,%ebx
 1f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fa:	5b                   	pop    %ebx
 1fb:	5f                   	pop    %edi
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    

000001fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 20a:	90                   	nop
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	8d 50 01             	lea    0x1(%eax),%edx
 211:	89 55 08             	mov    %edx,0x8(%ebp)
 214:	8b 55 0c             	mov    0xc(%ebp),%edx
 217:	8d 4a 01             	lea    0x1(%edx),%ecx
 21a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 21d:	0f b6 12             	movzbl (%edx),%edx
 220:	88 10                	mov    %dl,(%eax)
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	84 c0                	test   %al,%al
 227:	75 e2                	jne    20b <strcpy+0xd>
    ;
  return os;
 229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 231:	eb 08                	jmp    23b <strcmp+0xd>
    p++, q++;
 233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	84 c0                	test   %al,%al
 243:	74 10                	je     255 <strcmp+0x27>
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	0f b6 10             	movzbl (%eax),%edx
 24b:	8b 45 0c             	mov    0xc(%ebp),%eax
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	38 c2                	cmp    %al,%dl
 253:	74 de                	je     233 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	0f b6 d0             	movzbl %al,%edx
 25e:	8b 45 0c             	mov    0xc(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	0f b6 c0             	movzbl %al,%eax
 267:	29 c2                	sub    %eax,%edx
 269:	89 d0                	mov    %edx,%eax
}
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    

0000026d <strlen>:

uint
strlen(char *s)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 27a:	eb 04                	jmp    280 <strlen+0x13>
 27c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 280:	8b 55 fc             	mov    -0x4(%ebp),%edx
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	01 d0                	add    %edx,%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	84 c0                	test   %al,%al
 28d:	75 ed                	jne    27c <strlen+0xf>
    ;
  return n;
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <memset>:

void*
memset(void *dst, int c, uint n)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 29a:	8b 45 10             	mov    0x10(%ebp),%eax
 29d:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 04 24             	mov    %eax,(%esp)
 2ae:	e8 26 ff ff ff       	call   1d9 <stosb>
  return dst;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <strchr>:

char*
strchr(const char *s, char c)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	83 ec 04             	sub    $0x4,%esp
 2be:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2c4:	eb 14                	jmp    2da <strchr+0x22>
    if(*s == c)
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2cf:	75 05                	jne    2d6 <strchr+0x1e>
      return (char*)s;
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	eb 13                	jmp    2e9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	0f b6 00             	movzbl (%eax),%eax
 2e0:	84 c0                	test   %al,%al
 2e2:	75 e2                	jne    2c6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <gets>:

char*
gets(char *buf, int max)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f8:	eb 4c                	jmp    346 <gets+0x5b>
    cc = read(0, &c, 1);
 2fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 301:	00 
 302:	8d 45 ef             	lea    -0x11(%ebp),%eax
 305:	89 44 24 04          	mov    %eax,0x4(%esp)
 309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 310:	e8 5c 01 00 00       	call   471 <read>
 315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 31c:	7f 02                	jg     320 <gets+0x35>
      break;
 31e:	eb 31                	jmp    351 <gets+0x66>
    buf[i++] = c;
 320:	8b 45 f4             	mov    -0xc(%ebp),%eax
 323:	8d 50 01             	lea    0x1(%eax),%edx
 326:	89 55 f4             	mov    %edx,-0xc(%ebp)
 329:	89 c2                	mov    %eax,%edx
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	01 c2                	add    %eax,%edx
 330:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 334:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 336:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33a:	3c 0a                	cmp    $0xa,%al
 33c:	74 13                	je     351 <gets+0x66>
 33e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 342:	3c 0d                	cmp    $0xd,%al
 344:	74 0b                	je     351 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	8b 45 f4             	mov    -0xc(%ebp),%eax
 349:	83 c0 01             	add    $0x1,%eax
 34c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 34f:	7c a9                	jl     2fa <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 351:	8b 55 f4             	mov    -0xc(%ebp),%edx
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	01 d0                	add    %edx,%eax
 359:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <stat>:

int
stat(char *n, struct stat *st)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 36e:	00 
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	89 04 24             	mov    %eax,(%esp)
 375:	e8 1f 01 00 00       	call   499 <open>
 37a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 37d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 381:	79 07                	jns    38a <stat+0x29>
    return -1;
 383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 388:	eb 23                	jmp    3ad <stat+0x4c>
  r = fstat(fd, st);
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	89 44 24 04          	mov    %eax,0x4(%esp)
 391:	8b 45 f4             	mov    -0xc(%ebp),%eax
 394:	89 04 24             	mov    %eax,(%esp)
 397:	e8 15 01 00 00       	call   4b1 <fstat>
 39c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 39f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a2:	89 04 24             	mov    %eax,(%esp)
 3a5:	e8 d7 00 00 00       	call   481 <close>
  return r;
 3aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <atoi>:

int
atoi(const char *s)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3bc:	eb 25                	jmp    3e3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c1:	89 d0                	mov    %edx,%eax
 3c3:	c1 e0 02             	shl    $0x2,%eax
 3c6:	01 d0                	add    %edx,%eax
 3c8:	01 c0                	add    %eax,%eax
 3ca:	89 c1                	mov    %eax,%ecx
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	8d 50 01             	lea    0x1(%eax),%edx
 3d2:	89 55 08             	mov    %edx,0x8(%ebp)
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	0f be c0             	movsbl %al,%eax
 3db:	01 c8                	add    %ecx,%eax
 3dd:	83 e8 30             	sub    $0x30,%eax
 3e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	3c 2f                	cmp    $0x2f,%al
 3eb:	7e 0a                	jle    3f7 <atoi+0x48>
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	3c 39                	cmp    $0x39,%al
 3f5:	7e c7                	jle    3be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    

000003fc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 40e:	eb 17                	jmp    427 <memmove+0x2b>
    *dst++ = *src++;
 410:	8b 45 fc             	mov    -0x4(%ebp),%eax
 413:	8d 50 01             	lea    0x1(%eax),%edx
 416:	89 55 fc             	mov    %edx,-0x4(%ebp)
 419:	8b 55 f8             	mov    -0x8(%ebp),%edx
 41c:	8d 4a 01             	lea    0x1(%edx),%ecx
 41f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 422:	0f b6 12             	movzbl (%edx),%edx
 425:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 427:	8b 45 10             	mov    0x10(%ebp),%eax
 42a:	8d 50 ff             	lea    -0x1(%eax),%edx
 42d:	89 55 10             	mov    %edx,0x10(%ebp)
 430:	85 c0                	test   %eax,%eax
 432:	7f dc                	jg     410 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 434:	8b 45 08             	mov    0x8(%ebp),%eax
}
 437:	c9                   	leave  
 438:	c3                   	ret    

00000439 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 439:	b8 01 00 00 00       	mov    $0x1,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <exit>:
SYSCALL(exit)
 441:	b8 02 00 00 00       	mov    $0x2,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <wait>:
SYSCALL(wait)
 449:	b8 03 00 00 00       	mov    $0x3,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <signal>:
SYSCALL(signal)
 451:	b8 18 00 00 00       	mov    $0x18,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <sigsend>:
SYSCALL(sigsend)
 459:	b8 19 00 00 00       	mov    $0x19,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <alarm>:
SYSCALL(alarm)
 461:	b8 1a 00 00 00       	mov    $0x1a,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <pipe>:
SYSCALL(pipe)
 469:	b8 04 00 00 00       	mov    $0x4,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <read>:
SYSCALL(read)
 471:	b8 05 00 00 00       	mov    $0x5,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <write>:
SYSCALL(write)
 479:	b8 10 00 00 00       	mov    $0x10,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <close>:
SYSCALL(close)
 481:	b8 15 00 00 00       	mov    $0x15,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <kill>:
SYSCALL(kill)
 489:	b8 06 00 00 00       	mov    $0x6,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <exec>:
SYSCALL(exec)
 491:	b8 07 00 00 00       	mov    $0x7,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <open>:
SYSCALL(open)
 499:	b8 0f 00 00 00       	mov    $0xf,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <mknod>:
SYSCALL(mknod)
 4a1:	b8 11 00 00 00       	mov    $0x11,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <unlink>:
SYSCALL(unlink)
 4a9:	b8 12 00 00 00       	mov    $0x12,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <fstat>:
SYSCALL(fstat)
 4b1:	b8 08 00 00 00       	mov    $0x8,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <link>:
SYSCALL(link)
 4b9:	b8 13 00 00 00       	mov    $0x13,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <mkdir>:
SYSCALL(mkdir)
 4c1:	b8 14 00 00 00       	mov    $0x14,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <chdir>:
SYSCALL(chdir)
 4c9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <dup>:
SYSCALL(dup)
 4d1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <getpid>:
SYSCALL(getpid)
 4d9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <sbrk>:
SYSCALL(sbrk)
 4e1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <sleep>:
SYSCALL(sleep)
 4e9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <uptime>:
SYSCALL(uptime)
 4f1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f9:	55                   	push   %ebp
 4fa:	89 e5                	mov    %esp,%ebp
 4fc:	83 ec 18             	sub    $0x18,%esp
 4ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 502:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 505:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 50c:	00 
 50d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 510:	89 44 24 04          	mov    %eax,0x4(%esp)
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	89 04 24             	mov    %eax,(%esp)
 51a:	e8 5a ff ff ff       	call   479 <write>
}
 51f:	c9                   	leave  
 520:	c3                   	ret    

00000521 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 521:	55                   	push   %ebp
 522:	89 e5                	mov    %esp,%ebp
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 530:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 534:	74 17                	je     54d <printint+0x2c>
 536:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 53a:	79 11                	jns    54d <printint+0x2c>
    neg = 1;
 53c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 543:	8b 45 0c             	mov    0xc(%ebp),%eax
 546:	f7 d8                	neg    %eax
 548:	89 45 ec             	mov    %eax,-0x14(%ebp)
 54b:	eb 06                	jmp    553 <printint+0x32>
  } else {
    x = xx;
 54d:	8b 45 0c             	mov    0xc(%ebp),%eax
 550:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 553:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 55a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 55d:	8d 41 01             	lea    0x1(%ecx),%eax
 560:	89 45 f4             	mov    %eax,-0xc(%ebp)
 563:	8b 5d 10             	mov    0x10(%ebp),%ebx
 566:	8b 45 ec             	mov    -0x14(%ebp),%eax
 569:	ba 00 00 00 00       	mov    $0x0,%edx
 56e:	f7 f3                	div    %ebx
 570:	89 d0                	mov    %edx,%eax
 572:	0f b6 80 a8 14 00 00 	movzbl 0x14a8(%eax),%eax
 579:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 57d:	8b 75 10             	mov    0x10(%ebp),%esi
 580:	8b 45 ec             	mov    -0x14(%ebp),%eax
 583:	ba 00 00 00 00       	mov    $0x0,%edx
 588:	f7 f6                	div    %esi
 58a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 591:	75 c7                	jne    55a <printint+0x39>
  if(neg)
 593:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 597:	74 10                	je     5a9 <printint+0x88>
    buf[i++] = '-';
 599:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59c:	8d 50 01             	lea    0x1(%eax),%edx
 59f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5a2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5a7:	eb 1f                	jmp    5c8 <printint+0xa7>
 5a9:	eb 1d                	jmp    5c8 <printint+0xa7>
    putc(fd, buf[i]);
 5ab:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b1:	01 d0                	add    %edx,%eax
 5b3:	0f b6 00             	movzbl (%eax),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	89 04 24             	mov    %eax,(%esp)
 5c3:	e8 31 ff ff ff       	call   4f9 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5c8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d0:	79 d9                	jns    5ab <printint+0x8a>
    putc(fd, buf[i]);
}
 5d2:	83 c4 30             	add    $0x30,%esp
 5d5:	5b                   	pop    %ebx
 5d6:	5e                   	pop    %esi
 5d7:	5d                   	pop    %ebp
 5d8:	c3                   	ret    

000005d9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d9:	55                   	push   %ebp
 5da:	89 e5                	mov    %esp,%ebp
 5dc:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5e6:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e9:	83 c0 04             	add    $0x4,%eax
 5ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5f6:	e9 7c 01 00 00       	jmp    777 <printf+0x19e>
    c = fmt[i] & 0xff;
 5fb:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 601:	01 d0                	add    %edx,%eax
 603:	0f b6 00             	movzbl (%eax),%eax
 606:	0f be c0             	movsbl %al,%eax
 609:	25 ff 00 00 00       	and    $0xff,%eax
 60e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 611:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 615:	75 2c                	jne    643 <printf+0x6a>
      if(c == '%'){
 617:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 61b:	75 0c                	jne    629 <printf+0x50>
        state = '%';
 61d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 624:	e9 4a 01 00 00       	jmp    773 <printf+0x19a>
      } else {
        putc(fd, c);
 629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62c:	0f be c0             	movsbl %al,%eax
 62f:	89 44 24 04          	mov    %eax,0x4(%esp)
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	89 04 24             	mov    %eax,(%esp)
 639:	e8 bb fe ff ff       	call   4f9 <putc>
 63e:	e9 30 01 00 00       	jmp    773 <printf+0x19a>
      }
    } else if(state == '%'){
 643:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 647:	0f 85 26 01 00 00    	jne    773 <printf+0x19a>
      if(c == 'd'){
 64d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 651:	75 2d                	jne    680 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 653:	8b 45 e8             	mov    -0x18(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 65f:	00 
 660:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 667:	00 
 668:	89 44 24 04          	mov    %eax,0x4(%esp)
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	89 04 24             	mov    %eax,(%esp)
 672:	e8 aa fe ff ff       	call   521 <printint>
        ap++;
 677:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67b:	e9 ec 00 00 00       	jmp    76c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 680:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 684:	74 06                	je     68c <printf+0xb3>
 686:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 68a:	75 2d                	jne    6b9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 68c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 698:	00 
 699:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6a0:	00 
 6a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	89 04 24             	mov    %eax,(%esp)
 6ab:	e8 71 fe ff ff       	call   521 <printint>
        ap++;
 6b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b4:	e9 b3 00 00 00       	jmp    76c <printf+0x193>
      } else if(c == 's'){
 6b9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6bd:	75 45                	jne    704 <printf+0x12b>
        s = (char*)*ap;
 6bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6cf:	75 09                	jne    6da <printf+0x101>
          s = "(null)";
 6d1:	c7 45 f4 05 10 00 00 	movl   $0x1005,-0xc(%ebp)
        while(*s != 0){
 6d8:	eb 1e                	jmp    6f8 <printf+0x11f>
 6da:	eb 1c                	jmp    6f8 <printf+0x11f>
          putc(fd, *s);
 6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6df:	0f b6 00             	movzbl (%eax),%eax
 6e2:	0f be c0             	movsbl %al,%eax
 6e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	89 04 24             	mov    %eax,(%esp)
 6ef:	e8 05 fe ff ff       	call   4f9 <putc>
          s++;
 6f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fb:	0f b6 00             	movzbl (%eax),%eax
 6fe:	84 c0                	test   %al,%al
 700:	75 da                	jne    6dc <printf+0x103>
 702:	eb 68                	jmp    76c <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 704:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 708:	75 1d                	jne    727 <printf+0x14e>
        putc(fd, *ap);
 70a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	0f be c0             	movsbl %al,%eax
 712:	89 44 24 04          	mov    %eax,0x4(%esp)
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	89 04 24             	mov    %eax,(%esp)
 71c:	e8 d8 fd ff ff       	call   4f9 <putc>
        ap++;
 721:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 725:	eb 45                	jmp    76c <printf+0x193>
      } else if(c == '%'){
 727:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 72b:	75 17                	jne    744 <printf+0x16b>
        putc(fd, c);
 72d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 730:	0f be c0             	movsbl %al,%eax
 733:	89 44 24 04          	mov    %eax,0x4(%esp)
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 b7 fd ff ff       	call   4f9 <putc>
 742:	eb 28                	jmp    76c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 744:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 74b:	00 
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	89 04 24             	mov    %eax,(%esp)
 752:	e8 a2 fd ff ff       	call   4f9 <putc>
        putc(fd, c);
 757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75a:	0f be c0             	movsbl %al,%eax
 75d:	89 44 24 04          	mov    %eax,0x4(%esp)
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	89 04 24             	mov    %eax,(%esp)
 767:	e8 8d fd ff ff       	call   4f9 <putc>
      }
      state = 0;
 76c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 773:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 777:	8b 55 0c             	mov    0xc(%ebp),%edx
 77a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77d:	01 d0                	add    %edx,%eax
 77f:	0f b6 00             	movzbl (%eax),%eax
 782:	84 c0                	test   %al,%al
 784:	0f 85 71 fe ff ff    	jne    5fb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 78a:	c9                   	leave  
 78b:	c3                   	ret    

0000078c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78c:	55                   	push   %ebp
 78d:	89 e5                	mov    %esp,%ebp
 78f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 792:	8b 45 08             	mov    0x8(%ebp),%eax
 795:	83 e8 08             	sub    $0x8,%eax
 798:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79b:	a1 c8 14 00 00       	mov    0x14c8,%eax
 7a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a3:	eb 24                	jmp    7c9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ad:	77 12                	ja     7c1 <free+0x35>
 7af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b5:	77 24                	ja     7db <free+0x4f>
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bf:	77 1a                	ja     7db <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cf:	76 d4                	jbe    7a5 <free+0x19>
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d9:	76 ca                	jbe    7a5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	8b 40 04             	mov    0x4(%eax),%eax
 7e1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	01 c2                	add    %eax,%edx
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	39 c2                	cmp    %eax,%edx
 7f4:	75 24                	jne    81a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f9:	8b 50 04             	mov    0x4(%eax),%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	8b 00                	mov    (%eax),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	01 c2                	add    %eax,%edx
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	8b 10                	mov    (%eax),%edx
 813:	8b 45 f8             	mov    -0x8(%ebp),%eax
 816:	89 10                	mov    %edx,(%eax)
 818:	eb 0a                	jmp    824 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 10                	mov    (%eax),%edx
 81f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 822:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 824:	8b 45 fc             	mov    -0x4(%ebp),%eax
 827:	8b 40 04             	mov    0x4(%eax),%eax
 82a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	01 d0                	add    %edx,%eax
 836:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 839:	75 20                	jne    85b <free+0xcf>
    p->s.size += bp->s.size;
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	8b 50 04             	mov    0x4(%eax),%edx
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	8b 40 04             	mov    0x4(%eax),%eax
 847:	01 c2                	add    %eax,%edx
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	8b 10                	mov    (%eax),%edx
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	89 10                	mov    %edx,(%eax)
 859:	eb 08                	jmp    863 <free+0xd7>
  } else
    p->s.ptr = bp;
 85b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 861:	89 10                	mov    %edx,(%eax)
  freep = p;
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	a3 c8 14 00 00       	mov    %eax,0x14c8
}
 86b:	c9                   	leave  
 86c:	c3                   	ret    

0000086d <morecore>:

static Header*
morecore(uint nu)
{
 86d:	55                   	push   %ebp
 86e:	89 e5                	mov    %esp,%ebp
 870:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 873:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 87a:	77 07                	ja     883 <morecore+0x16>
    nu = 4096;
 87c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 883:	8b 45 08             	mov    0x8(%ebp),%eax
 886:	c1 e0 03             	shl    $0x3,%eax
 889:	89 04 24             	mov    %eax,(%esp)
 88c:	e8 50 fc ff ff       	call   4e1 <sbrk>
 891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 894:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 898:	75 07                	jne    8a1 <morecore+0x34>
    return 0;
 89a:	b8 00 00 00 00       	mov    $0x0,%eax
 89f:	eb 22                	jmp    8c3 <morecore+0x56>
  hp = (Header*)p;
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	8b 55 08             	mov    0x8(%ebp),%edx
 8ad:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b3:	83 c0 08             	add    $0x8,%eax
 8b6:	89 04 24             	mov    %eax,(%esp)
 8b9:	e8 ce fe ff ff       	call   78c <free>
  return freep;
 8be:	a1 c8 14 00 00       	mov    0x14c8,%eax
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    

000008c5 <malloc>:

void*
malloc(uint nbytes)
{
 8c5:	55                   	push   %ebp
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8cb:	8b 45 08             	mov    0x8(%ebp),%eax
 8ce:	83 c0 07             	add    $0x7,%eax
 8d1:	c1 e8 03             	shr    $0x3,%eax
 8d4:	83 c0 01             	add    $0x1,%eax
 8d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8da:	a1 c8 14 00 00       	mov    0x14c8,%eax
 8df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e6:	75 23                	jne    90b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8e8:	c7 45 f0 c0 14 00 00 	movl   $0x14c0,-0x10(%ebp)
 8ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f2:	a3 c8 14 00 00       	mov    %eax,0x14c8
 8f7:	a1 c8 14 00 00       	mov    0x14c8,%eax
 8fc:	a3 c0 14 00 00       	mov    %eax,0x14c0
    base.s.size = 0;
 901:	c7 05 c4 14 00 00 00 	movl   $0x0,0x14c4
 908:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90e:	8b 00                	mov    (%eax),%eax
 910:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 91c:	72 4d                	jb     96b <malloc+0xa6>
      if(p->s.size == nunits)
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	8b 40 04             	mov    0x4(%eax),%eax
 924:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 927:	75 0c                	jne    935 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	8b 10                	mov    (%eax),%edx
 92e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 931:	89 10                	mov    %edx,(%eax)
 933:	eb 26                	jmp    95b <malloc+0x96>
      else {
        p->s.size -= nunits;
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	8b 40 04             	mov    0x4(%eax),%eax
 93b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 93e:	89 c2                	mov    %eax,%edx
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 946:	8b 45 f4             	mov    -0xc(%ebp),%eax
 949:	8b 40 04             	mov    0x4(%eax),%eax
 94c:	c1 e0 03             	shl    $0x3,%eax
 94f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	8b 55 ec             	mov    -0x14(%ebp),%edx
 958:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 95b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95e:	a3 c8 14 00 00       	mov    %eax,0x14c8
      return (void*)(p + 1);
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	83 c0 08             	add    $0x8,%eax
 969:	eb 38                	jmp    9a3 <malloc+0xde>
    }
    if(p == freep)
 96b:	a1 c8 14 00 00       	mov    0x14c8,%eax
 970:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 973:	75 1b                	jne    990 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 975:	8b 45 ec             	mov    -0x14(%ebp),%eax
 978:	89 04 24             	mov    %eax,(%esp)
 97b:	e8 ed fe ff ff       	call   86d <morecore>
 980:	89 45 f4             	mov    %eax,-0xc(%ebp)
 983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 987:	75 07                	jne    990 <malloc+0xcb>
        return 0;
 989:	b8 00 00 00 00       	mov    $0x0,%eax
 98e:	eb 13                	jmp    9a3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	89 45 f0             	mov    %eax,-0x10(%ebp)
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	8b 00                	mov    (%eax),%eax
 99b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 99e:	e9 70 ff ff ff       	jmp    913 <malloc+0x4e>
}
 9a3:	c9                   	leave  
 9a4:	c3                   	ret    

000009a5 <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 9a5:	55                   	push   %ebp
 9a6:	89 e5                	mov    %esp,%ebp
 9a8:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 9ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 9b2:	eb 17                	jmp    9cb <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 9be:	85 c0                	test   %eax,%eax
 9c0:	75 05                	jne    9c7 <findNextFreeThreadId+0x22>
			return i;
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	eb 0f                	jmp    9d6 <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 9c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 9cb:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 9cf:	7e e3                	jle    9b4 <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 9d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 9d6:	c9                   	leave  
 9d7:	c3                   	ret    

000009d8 <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 9d8:	55                   	push   %ebp
 9d9:	89 e5                	mov    %esp,%ebp
 9db:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 9de:	a1 e0 17 00 00       	mov    0x17e0,%eax
 9e3:	8b 00                	mov    (%eax),%eax
 9e5:	8d 50 01             	lea    0x1(%eax),%edx
 9e8:	89 d0                	mov    %edx,%eax
 9ea:	c1 f8 1f             	sar    $0x1f,%eax
 9ed:	c1 e8 1a             	shr    $0x1a,%eax
 9f0:	01 c2                	add    %eax,%edx
 9f2:	83 e2 3f             	and    $0x3f,%edx
 9f5:	29 c2                	sub    %eax,%edx
 9f7:	89 d0                	mov    %edx,%eax
 9f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 9fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ff:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 a06:	8b 40 28             	mov    0x28(%eax),%eax
 a09:	83 f8 02             	cmp    $0x2,%eax
 a0c:	75 0c                	jne    a1a <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a11:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 a18:	eb 1c                	jmp    a36 <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1d:	8d 50 01             	lea    0x1(%eax),%edx
 a20:	89 d0                	mov    %edx,%eax
 a22:	c1 f8 1f             	sar    $0x1f,%eax
 a25:	c1 e8 1a             	shr    $0x1a,%eax
 a28:	01 c2                	add    %eax,%edx
 a2a:	83 e2 3f             	and    $0x3f,%edx
 a2d:	29 c2                	sub    %eax,%edx
 a2f:	89 d0                	mov    %edx,%eax
 a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 a34:	eb c6                	jmp    9fc <findNextRunnableThread+0x24>
}
 a36:	c9                   	leave  
 a37:	c3                   	ret    

00000a38 <uthread_init>:

void uthread_init(void)
{
 a38:	55                   	push   %ebp
 a39:	89 e5                	mov    %esp,%ebp
 a3b:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 a3e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 a45:	eb 12                	jmp    a59 <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4a:	c7 04 85 e0 16 00 00 	movl   $0x0,0x16e0(,%eax,4)
 a51:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 a55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 a59:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 a5d:	7e e8                	jle    a47 <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 a5f:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 a66:	e8 5a fe ff ff       	call   8c5 <malloc>
 a6b:	a3 e0 16 00 00       	mov    %eax,0x16e0
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 a70:	a1 e0 16 00 00       	mov    0x16e0,%eax
 a75:	89 e2                	mov    %esp,%edx
 a77:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 a7a:	a1 e0 16 00 00       	mov    0x16e0,%eax
 a7f:	89 ea                	mov    %ebp,%edx
 a81:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 a84:	a1 e0 16 00 00       	mov    0x16e0,%eax
 a89:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 a90:	a1 e0 16 00 00       	mov    0x16e0,%eax
 a95:	a3 e0 17 00 00       	mov    %eax,0x17e0
	threadTable.threadCount = 1;
 a9a:	c7 05 e4 17 00 00 01 	movl   $0x1,0x17e4
 aa1:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 aa4:	c7 44 24 04 7d 0c 00 	movl   $0xc7d,0x4(%esp)
 aab:	00 
 aac:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 ab3:	e8 99 f9 ff ff       	call   451 <signal>
	alarm(UTHREAD_QUANTA);
 ab8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 abf:	e8 9d f9 ff ff       	call   461 <alarm>
}
 ac4:	c9                   	leave  
 ac5:	c3                   	ret    

00000ac6 <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 ac6:	55                   	push   %ebp
 ac7:	89 e5                	mov    %esp,%ebp
 ac9:	53                   	push   %ebx
 aca:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 acd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 ad4:	e8 88 f9 ff ff       	call   461 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 ad9:	e8 c7 fe ff ff       	call   9a5 <findNextFreeThreadId>
 ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 ae1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ae5:	75 0a                	jne    af1 <uthread_create+0x2b>
		return -1;
 ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 aec:	e9 d6 00 00 00       	jmp    bc7 <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 af1:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 af8:	e8 c8 fd ff ff       	call   8c5 <malloc>
 afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b00:	89 04 95 e0 16 00 00 	mov    %eax,0x16e0(,%edx,4)
	threadTable.threads[current]->tid = current;
 b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0a:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b14:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b19:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 b20:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 b27:	a1 e4 17 00 00       	mov    0x17e4,%eax
 b2c:	83 c0 01             	add    $0x1,%eax
 b2f:	a3 e4 17 00 00       	mov    %eax,0x17e4
	threadTable.threads[current]->entry = func;
 b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b37:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 b3e:	8b 55 08             	mov    0x8(%ebp),%edx
 b41:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b47:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
 b51:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b57:	8b 1c 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%ebx
 b5e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 b65:	e8 5b fd ff ff       	call   8c5 <malloc>
 b6a:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b70:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b7a:	8b 14 95 e0 16 00 00 	mov    0x16e0(,%edx,4),%edx
 b81:	8b 52 24             	mov    0x24(%edx),%edx
 b84:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 b8a:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b90:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b9a:	8b 14 95 e0 16 00 00 	mov    0x16e0(,%edx,4),%edx
 ba1:	8b 52 04             	mov    0x4(%edx),%edx
 ba4:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 baa:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 bb1:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 bb8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 bbf:	e8 9d f8 ff ff       	call   461 <alarm>
	return current;
 bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 bc7:	83 c4 24             	add    $0x24,%esp
 bca:	5b                   	pop    %ebx
 bcb:	5d                   	pop    %ebp
 bcc:	c3                   	ret    

00000bcd <uthread_exit>:

void uthread_exit(void)
{
 bcd:	55                   	push   %ebp
 bce:	89 e5                	mov    %esp,%ebp
 bd0:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 bd3:	a1 e0 17 00 00       	mov    0x17e0,%eax
 bd8:	8b 00                	mov    (%eax),%eax
 bda:	85 c0                	test   %eax,%eax
 bdc:	74 10                	je     bee <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 bde:	a1 e0 17 00 00       	mov    0x17e0,%eax
 be3:	8b 40 24             	mov    0x24(%eax),%eax
 be6:	89 04 24             	mov    %eax,(%esp)
 be9:	e8 9e fb ff ff       	call   78c <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 bee:	a1 e0 17 00 00       	mov    0x17e0,%eax
 bf3:	8b 00                	mov    (%eax),%eax
 bf5:	c7 04 85 e0 16 00 00 	movl   $0x0,0x16e0(,%eax,4)
 bfc:	00 00 00 00 
	
	free(threadTable.runningThread);
 c00:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c05:	89 04 24             	mov    %eax,(%esp)
 c08:	e8 7f fb ff ff       	call   78c <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 c0d:	a1 e4 17 00 00       	mov    0x17e4,%eax
 c12:	83 e8 01             	sub    $0x1,%eax
 c15:	a3 e4 17 00 00       	mov    %eax,0x17e4
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 c1a:	a1 e4 17 00 00       	mov    0x17e4,%eax
 c1f:	85 c0                	test   %eax,%eax
 c21:	75 05                	jne    c28 <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 c23:	e8 19 f8 ff ff       	call   441 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 c28:	e8 ab fd ff ff       	call   9d8 <findNextRunnableThread>
 c2d:	a3 e0 17 00 00       	mov    %eax,0x17e0
	
	threadTable.runningThread->state = T_RUNNING;
 c32:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c37:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 c3e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c45:	e8 17 f8 ff ff       	call   461 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 c4a:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c4f:	8b 40 04             	mov    0x4(%eax),%eax
 c52:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 c54:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c59:	8b 40 08             	mov    0x8(%eax),%eax
 c5c:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 c5e:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c63:	8b 40 2c             	mov    0x2c(%eax),%eax
 c66:	85 c0                	test   %eax,%eax
 c68:	74 11                	je     c7b <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 c6a:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c6f:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 c76:	e8 8e 00 00 00       	call   d09 <wrapper>
	}
	

}
 c7b:	c9                   	leave  
 c7c:	c3                   	ret    

00000c7d <uthread_yield>:

void uthread_yield(void)
{
 c7d:	55                   	push   %ebp
 c7e:	89 e5                	mov    %esp,%ebp
 c80:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 c83:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c88:	89 e2                	mov    %esp,%edx
 c8a:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 c8d:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c92:	89 ea                	mov    %ebp,%edx
 c94:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 c97:	a1 e0 17 00 00       	mov    0x17e0,%eax
 c9c:	8b 40 28             	mov    0x28(%eax),%eax
 c9f:	83 f8 01             	cmp    $0x1,%eax
 ca2:	75 0c                	jne    cb0 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 ca4:	a1 e0 17 00 00       	mov    0x17e0,%eax
 ca9:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 cb0:	e8 23 fd ff ff       	call   9d8 <findNextRunnableThread>
 cb5:	a3 e0 17 00 00       	mov    %eax,0x17e0
	threadTable.runningThread->state = T_RUNNING;
 cba:	a1 e0 17 00 00       	mov    0x17e0,%eax
 cbf:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 cc6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ccd:	e8 8f f7 ff ff       	call   461 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 cd2:	a1 e0 17 00 00       	mov    0x17e0,%eax
 cd7:	8b 40 04             	mov    0x4(%eax),%eax
 cda:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 cdc:	a1 e0 17 00 00       	mov    0x17e0,%eax
 ce1:	8b 40 08             	mov    0x8(%eax),%eax
 ce4:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 ce6:	a1 e0 17 00 00       	mov    0x17e0,%eax
 ceb:	8b 40 2c             	mov    0x2c(%eax),%eax
 cee:	85 c0                	test   %eax,%eax
 cf0:	74 14                	je     d06 <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 cf2:	a1 e0 17 00 00       	mov    0x17e0,%eax
 cf7:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 cfe:	b8 09 0d 00 00       	mov    $0xd09,%eax
 d03:	ff d0                	call   *%eax
		asm("ret");
 d05:	c3                   	ret    
	}
	return;
 d06:	90                   	nop
}
 d07:	c9                   	leave  
 d08:	c3                   	ret    

00000d09 <wrapper>:

void wrapper(void) {
 d09:	55                   	push   %ebp
 d0a:	89 e5                	mov    %esp,%ebp
 d0c:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 d0f:	a1 e0 17 00 00       	mov    0x17e0,%eax
 d14:	8b 40 30             	mov    0x30(%eax),%eax
 d17:	8b 15 e0 17 00 00    	mov    0x17e0,%edx
 d1d:	8b 52 34             	mov    0x34(%edx),%edx
 d20:	89 14 24             	mov    %edx,(%esp)
 d23:	ff d0                	call   *%eax
	uthread_exit();
 d25:	e8 a3 fe ff ff       	call   bcd <uthread_exit>
}
 d2a:	c9                   	leave  
 d2b:	c3                   	ret    

00000d2c <uthread_self>:

int uthread_self(void)
{
 d2c:	55                   	push   %ebp
 d2d:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 d2f:	a1 e0 17 00 00       	mov    0x17e0,%eax
 d34:	8b 00                	mov    (%eax),%eax
}
 d36:	5d                   	pop    %ebp
 d37:	c3                   	ret    

00000d38 <uthread_join>:

int uthread_join(int tid)
{
 d38:	55                   	push   %ebp
 d39:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 d3b:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 d3f:	7e 07                	jle    d48 <uthread_join+0x10>
		return -1;
 d41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d46:	eb 14                	jmp    d5c <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 d48:	90                   	nop
 d49:	8b 45 08             	mov    0x8(%ebp),%eax
 d4c:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 d53:	85 c0                	test   %eax,%eax
 d55:	75 f2                	jne    d49 <uthread_join+0x11>
	return 0;
 d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d5c:	5d                   	pop    %ebp
 d5d:	c3                   	ret    

00000d5e <uthread_sleep>:

void uthread_sleep(void)
{
 d5e:	55                   	push   %ebp
 d5f:	89 e5                	mov    %esp,%ebp
 d61:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 d64:	a1 e0 17 00 00       	mov    0x17e0,%eax
 d69:	89 e2                	mov    %esp,%edx
 d6b:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 d6e:	a1 e0 17 00 00       	mov    0x17e0,%eax
 d73:	89 ea                	mov    %ebp,%edx
 d75:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 d78:	a1 e0 17 00 00       	mov    0x17e0,%eax
 d7d:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 d84:	a1 e0 17 00 00       	mov    0x17e0,%eax
 d89:	8b 00                	mov    (%eax),%eax
 d8b:	89 44 24 08          	mov    %eax,0x8(%esp)
 d8f:	c7 44 24 04 0c 10 00 	movl   $0x100c,0x4(%esp)
 d96:	00 
 d97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d9e:	e8 36 f8 ff ff       	call   5d9 <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 da3:	e8 30 fc ff ff       	call   9d8 <findNextRunnableThread>
 da8:	a3 e0 17 00 00       	mov    %eax,0x17e0
	threadTable.runningThread->state = T_RUNNING;
 dad:	a1 e0 17 00 00       	mov    0x17e0,%eax
 db2:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 db9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 dc0:	e8 9c f6 ff ff       	call   461 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 dc5:	a1 e0 17 00 00       	mov    0x17e0,%eax
 dca:	8b 40 08             	mov    0x8(%eax),%eax
 dcd:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 dcf:	a1 e0 17 00 00       	mov    0x17e0,%eax
 dd4:	8b 40 04             	mov    0x4(%eax),%eax
 dd7:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 dd9:	a1 e0 17 00 00       	mov    0x17e0,%eax
 dde:	8b 40 2c             	mov    0x2c(%eax),%eax
 de1:	85 c0                	test   %eax,%eax
 de3:	74 14                	je     df9 <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 de5:	a1 e0 17 00 00       	mov    0x17e0,%eax
 dea:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 df1:	b8 09 0d 00 00       	mov    $0xd09,%eax
 df6:	ff d0                	call   *%eax
		asm("ret");
 df8:	c3                   	ret    
	}
	return;	
 df9:	90                   	nop
}
 dfa:	c9                   	leave  
 dfb:	c3                   	ret    

00000dfc <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 dfc:	55                   	push   %ebp
 dfd:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 dff:	8b 45 08             	mov    0x8(%ebp),%eax
 e02:	8b 04 85 e0 16 00 00 	mov    0x16e0(,%eax,4),%eax
 e09:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 e10:	5d                   	pop    %ebp
 e11:	c3                   	ret    

00000e12 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 e12:	55                   	push   %ebp
 e13:	89 e5                	mov    %esp,%ebp
 e15:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 e18:	c7 44 24 04 27 10 00 	movl   $0x1027,0x4(%esp)
 e1f:	00 
 e20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 e27:	e8 ad f7 ff ff       	call   5d9 <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 e2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 e33:	eb 26                	jmp    e5b <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 e35:	8b 45 08             	mov    0x8(%ebp),%eax
 e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
 e3b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 e3f:	89 44 24 08          	mov    %eax,0x8(%esp)
 e43:	c7 44 24 04 3e 10 00 	movl   $0x103e,0x4(%esp)
 e4a:	00 
 e4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 e52:	e8 82 f7 ff ff       	call   5d9 <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 e57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 e5b:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 e5f:	7e d4                	jle    e35 <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 e61:	c7 44 24 04 42 10 00 	movl   $0x1042,0x4(%esp)
 e68:	00 
 e69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 e70:	e8 64 f7 ff ff       	call   5d9 <printf>
}
 e75:	c9                   	leave  
 e76:	c3                   	ret    

00000e77 <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 e77:	55                   	push   %ebp
 e78:	89 e5                	mov    %esp,%ebp
 e7a:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 e7d:	8b 45 08             	mov    0x8(%ebp),%eax
 e80:	8b 55 0c             	mov    0xc(%ebp),%edx
 e83:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 e85:	8b 45 08             	mov    0x8(%ebp),%eax
 e88:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 e8f:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 e99:	eb 12                	jmp    ead <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 e9b:	8b 45 08             	mov    0x8(%ebp),%eax
 e9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 ea1:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 ea8:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 ea9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 ead:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 eb1:	7e e8                	jle    e9b <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 eb3:	c9                   	leave  
 eb4:	c3                   	ret    

00000eb5 <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 eb5:	55                   	push   %ebp
 eb6:	89 e5                	mov    %esp,%ebp
 eb8:	53                   	push   %ebx
 eb9:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 ebc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 ec3:	e8 99 f5 ff ff       	call   461 <alarm>
	if (semaphore->value ==0){
 ec8:	8b 45 08             	mov    0x8(%ebp),%eax
 ecb:	8b 00                	mov    (%eax),%eax
 ecd:	85 c0                	test   %eax,%eax
 ecf:	75 34                	jne    f05 <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 ed1:	a1 e0 17 00 00       	mov    0x17e0,%eax
 ed6:	8b 08                	mov    (%eax),%ecx
 ed8:	8b 45 08             	mov    0x8(%ebp),%eax
 edb:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 ee1:	8d 58 01             	lea    0x1(%eax),%ebx
 ee4:	8b 55 08             	mov    0x8(%ebp),%edx
 ee7:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 eed:	8b 55 08             	mov    0x8(%ebp),%edx
 ef0:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 ef4:	a1 e0 17 00 00       	mov    0x17e0,%eax
 ef9:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 f00:	e8 78 fd ff ff       	call   c7d <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 f05:	a1 e0 17 00 00       	mov    0x17e0,%eax
 f0a:	8b 10                	mov    (%eax),%edx
 f0c:	8b 45 08             	mov    0x8(%ebp),%eax
 f0f:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 f16:	ff 
	semaphore->value = 0;
 f17:	8b 45 08             	mov    0x8(%ebp),%eax
 f1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 f20:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 f27:	e8 35 f5 ff ff       	call   461 <alarm>
}
 f2c:	83 c4 14             	add    $0x14,%esp
 f2f:	5b                   	pop    %ebx
 f30:	5d                   	pop    %ebp
 f31:	c3                   	ret    

00000f32 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 f32:	55                   	push   %ebp
 f33:	89 e5                	mov    %esp,%ebp
 f35:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 f38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 f3f:	e8 1d f5 ff ff       	call   461 <alarm>
	
	if (semaphore->value == 0){
 f44:	8b 45 08             	mov    0x8(%ebp),%eax
 f47:	8b 00                	mov    (%eax),%eax
 f49:	85 c0                	test   %eax,%eax
 f4b:	75 71                	jne    fbe <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 f4d:	8b 45 08             	mov    0x8(%ebp),%eax
 f50:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 f59:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 f60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 f67:	eb 35                	jmp    f9e <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 f69:	8b 45 08             	mov    0x8(%ebp),%eax
 f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f6f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 f73:	83 f8 ff             	cmp    $0xffffffff,%eax
 f76:	74 22                	je     f9a <binary_semaphore_up+0x68>
 f78:	8b 45 08             	mov    0x8(%ebp),%eax
 f7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f7e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 f82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 f85:	7d 13                	jge    f9a <binary_semaphore_up+0x68>
				minIndex = i;
 f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 f8d:	8b 45 08             	mov    0x8(%ebp),%eax
 f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
 f93:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 f9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 f9e:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 fa2:	7e c5                	jle    f69 <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 fa4:	8b 45 08             	mov    0x8(%ebp),%eax
 fa7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 fad:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 fb1:	74 0b                	je     fbe <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 fb6:	89 04 24             	mov    %eax,(%esp)
 fb9:	e8 3e fe ff ff       	call   dfc <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 fbe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 fc5:	e8 97 f4 ff ff       	call   461 <alarm>
	
 fca:	c9                   	leave  
 fcb:	c3                   	ret    
