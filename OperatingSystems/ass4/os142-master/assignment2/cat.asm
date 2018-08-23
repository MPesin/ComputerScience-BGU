
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 20 14 00 	movl   $0x1420,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 9a 03 00 00       	call   3bd <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 20 14 00 	movl   $0x1420,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 77 03 00 00       	call   3b5 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 10 0f 00 	movl   $0xf10,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 bc 04 00 00       	call   51d <printf>
    exit();
  61:	e8 1f 03 00 00       	call   385 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 fd 02 00 00       	call   385 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 29 03 00 00       	call   3dd <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 21 0f 00 	movl   $0xf21,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 34 04 00 00       	call   51d <printf>
      exit();
  e9:	e8 97 02 00 00       	call   385 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 bf 02 00 00       	call   3c5 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 68 02 00 00       	call   385 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14e:	90                   	nop
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8d 50 01             	lea    0x1(%eax),%edx
 155:	89 55 08             	mov    %edx,0x8(%ebp)
 158:	8b 55 0c             	mov    0xc(%ebp),%edx
 15b:	8d 4a 01             	lea    0x1(%edx),%ecx
 15e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 161:	0f b6 12             	movzbl (%edx),%edx
 164:	88 10                	mov    %dl,(%eax)
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	84 c0                	test   %al,%al
 16b:	75 e2                	jne    14f <strcpy+0xd>
    ;
  return os;
 16d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 170:	c9                   	leave  
 171:	c3                   	ret    

00000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 175:	eb 08                	jmp    17f <strcmp+0xd>
    p++, q++;
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	74 10                	je     199 <strcmp+0x27>
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	38 c2                	cmp    %al,%dl
 197:	74 de                	je     177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 d0             	movzbl %al,%edx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	0f b6 c0             	movzbl %al,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 d0                	add    %edx,%eax
 1cc:	0f b6 00             	movzbl (%eax),%eax
 1cf:	84 c0                	test   %al,%al
 1d1:	75 ed                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1de:	8b 45 10             	mov    0x10(%ebp),%eax
 1e1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 26 ff ff ff       	call   11d <stosb>
  return dst;
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 04             	sub    $0x4,%esp
 202:	8b 45 0c             	mov    0xc(%ebp),%eax
 205:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 208:	eb 14                	jmp    21e <strchr+0x22>
    if(*s == c)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	3a 45 fc             	cmp    -0x4(%ebp),%al
 213:	75 05                	jne    21a <strchr+0x1e>
      return (char*)s;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	eb 13                	jmp    22d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	75 e2                	jne    20a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 228:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <gets>:

char*
gets(char *buf, int max)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23c:	eb 4c                	jmp    28a <gets+0x5b>
    cc = read(0, &c, 1);
 23e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 245:	00 
 246:	8d 45 ef             	lea    -0x11(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 254:	e8 5c 01 00 00       	call   3b5 <read>
 259:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 260:	7f 02                	jg     264 <gets+0x35>
      break;
 262:	eb 31                	jmp    295 <gets+0x66>
    buf[i++] = c;
 264:	8b 45 f4             	mov    -0xc(%ebp),%eax
 267:	8d 50 01             	lea    0x1(%eax),%edx
 26a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 26d:	89 c2                	mov    %eax,%edx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	01 c2                	add    %eax,%edx
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 27a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27e:	3c 0a                	cmp    $0xa,%al
 280:	74 13                	je     295 <gets+0x66>
 282:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 286:	3c 0d                	cmp    $0xd,%al
 288:	74 0b                	je     295 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28d:	83 c0 01             	add    $0x1,%eax
 290:	3b 45 0c             	cmp    0xc(%ebp),%eax
 293:	7c a9                	jl     23e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 295:	8b 55 f4             	mov    -0xc(%ebp),%edx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	01 d0                	add    %edx,%eax
 29d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a3:	c9                   	leave  
 2a4:	c3                   	ret    

000002a5 <stat>:

int
stat(char *n, struct stat *st)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b2:	00 
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	89 04 24             	mov    %eax,(%esp)
 2b9:	e8 1f 01 00 00       	call   3dd <open>
 2be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c5:	79 07                	jns    2ce <stat+0x29>
    return -1;
 2c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cc:	eb 23                	jmp    2f1 <stat+0x4c>
  r = fstat(fd, st);
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 15 01 00 00       	call   3f5 <fstat>
 2e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e6:	89 04 24             	mov    %eax,(%esp)
 2e9:	e8 d7 00 00 00       	call   3c5 <close>
  return r;
 2ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f1:	c9                   	leave  
 2f2:	c3                   	ret    

000002f3 <atoi>:

int
atoi(const char *s)
{
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 300:	eb 25                	jmp    327 <atoi+0x34>
    n = n*10 + *s++ - '0';
 302:	8b 55 fc             	mov    -0x4(%ebp),%edx
 305:	89 d0                	mov    %edx,%eax
 307:	c1 e0 02             	shl    $0x2,%eax
 30a:	01 d0                	add    %edx,%eax
 30c:	01 c0                	add    %eax,%eax
 30e:	89 c1                	mov    %eax,%ecx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	8d 50 01             	lea    0x1(%eax),%edx
 316:	89 55 08             	mov    %edx,0x8(%ebp)
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	0f be c0             	movsbl %al,%eax
 31f:	01 c8                	add    %ecx,%eax
 321:	83 e8 30             	sub    $0x30,%eax
 324:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 2f                	cmp    $0x2f,%al
 32f:	7e 0a                	jle    33b <atoi+0x48>
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	3c 39                	cmp    $0x39,%al
 339:	7e c7                	jle    302 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 33b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34c:	8b 45 0c             	mov    0xc(%ebp),%eax
 34f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 352:	eb 17                	jmp    36b <memmove+0x2b>
    *dst++ = *src++;
 354:	8b 45 fc             	mov    -0x4(%ebp),%eax
 357:	8d 50 01             	lea    0x1(%eax),%edx
 35a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 35d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 360:	8d 4a 01             	lea    0x1(%edx),%ecx
 363:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 366:	0f b6 12             	movzbl (%edx),%edx
 369:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36b:	8b 45 10             	mov    0x10(%ebp),%eax
 36e:	8d 50 ff             	lea    -0x1(%eax),%edx
 371:	89 55 10             	mov    %edx,0x10(%ebp)
 374:	85 c0                	test   %eax,%eax
 376:	7f dc                	jg     354 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37d:	b8 01 00 00 00       	mov    $0x1,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <exit>:
SYSCALL(exit)
 385:	b8 02 00 00 00       	mov    $0x2,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <wait>:
SYSCALL(wait)
 38d:	b8 03 00 00 00       	mov    $0x3,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <signal>:
SYSCALL(signal)
 395:	b8 18 00 00 00       	mov    $0x18,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <sigsend>:
SYSCALL(sigsend)
 39d:	b8 19 00 00 00       	mov    $0x19,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <alarm>:
SYSCALL(alarm)
 3a5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <pipe>:
SYSCALL(pipe)
 3ad:	b8 04 00 00 00       	mov    $0x4,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <read>:
SYSCALL(read)
 3b5:	b8 05 00 00 00       	mov    $0x5,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <write>:
SYSCALL(write)
 3bd:	b8 10 00 00 00       	mov    $0x10,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <close>:
SYSCALL(close)
 3c5:	b8 15 00 00 00       	mov    $0x15,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <kill>:
SYSCALL(kill)
 3cd:	b8 06 00 00 00       	mov    $0x6,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <exec>:
SYSCALL(exec)
 3d5:	b8 07 00 00 00       	mov    $0x7,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <open>:
SYSCALL(open)
 3dd:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <mknod>:
SYSCALL(mknod)
 3e5:	b8 11 00 00 00       	mov    $0x11,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <unlink>:
SYSCALL(unlink)
 3ed:	b8 12 00 00 00       	mov    $0x12,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <fstat>:
SYSCALL(fstat)
 3f5:	b8 08 00 00 00       	mov    $0x8,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <link>:
SYSCALL(link)
 3fd:	b8 13 00 00 00       	mov    $0x13,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <mkdir>:
SYSCALL(mkdir)
 405:	b8 14 00 00 00       	mov    $0x14,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <chdir>:
SYSCALL(chdir)
 40d:	b8 09 00 00 00       	mov    $0x9,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <dup>:
SYSCALL(dup)
 415:	b8 0a 00 00 00       	mov    $0xa,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <getpid>:
SYSCALL(getpid)
 41d:	b8 0b 00 00 00       	mov    $0xb,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <sbrk>:
SYSCALL(sbrk)
 425:	b8 0c 00 00 00       	mov    $0xc,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <sleep>:
SYSCALL(sleep)
 42d:	b8 0d 00 00 00       	mov    $0xd,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <uptime>:
SYSCALL(uptime)
 435:	b8 0e 00 00 00       	mov    $0xe,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 43d:	55                   	push   %ebp
 43e:	89 e5                	mov    %esp,%ebp
 440:	83 ec 18             	sub    $0x18,%esp
 443:	8b 45 0c             	mov    0xc(%ebp),%eax
 446:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 449:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 450:	00 
 451:	8d 45 f4             	lea    -0xc(%ebp),%eax
 454:	89 44 24 04          	mov    %eax,0x4(%esp)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	89 04 24             	mov    %eax,(%esp)
 45e:	e8 5a ff ff ff       	call   3bd <write>
}
 463:	c9                   	leave  
 464:	c3                   	ret    

00000465 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 465:	55                   	push   %ebp
 466:	89 e5                	mov    %esp,%ebp
 468:	56                   	push   %esi
 469:	53                   	push   %ebx
 46a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 46d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 474:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 478:	74 17                	je     491 <printint+0x2c>
 47a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 47e:	79 11                	jns    491 <printint+0x2c>
    neg = 1;
 480:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 487:	8b 45 0c             	mov    0xc(%ebp),%eax
 48a:	f7 d8                	neg    %eax
 48c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48f:	eb 06                	jmp    497 <printint+0x32>
  } else {
    x = xx;
 491:	8b 45 0c             	mov    0xc(%ebp),%eax
 494:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 49e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a1:	8d 41 01             	lea    0x1(%ecx),%eax
 4a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ad:	ba 00 00 00 00       	mov    $0x0,%edx
 4b2:	f7 f3                	div    %ebx
 4b4:	89 d0                	mov    %edx,%eax
 4b6:	0f b6 80 d8 13 00 00 	movzbl 0x13d8(%eax),%eax
 4bd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c1:	8b 75 10             	mov    0x10(%ebp),%esi
 4c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c7:	ba 00 00 00 00       	mov    $0x0,%edx
 4cc:	f7 f6                	div    %esi
 4ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d5:	75 c7                	jne    49e <printint+0x39>
  if(neg)
 4d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4db:	74 10                	je     4ed <printint+0x88>
    buf[i++] = '-';
 4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e0:	8d 50 01             	lea    0x1(%eax),%edx
 4e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4eb:	eb 1f                	jmp    50c <printint+0xa7>
 4ed:	eb 1d                	jmp    50c <printint+0xa7>
    putc(fd, buf[i]);
 4ef:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f5:	01 d0                	add    %edx,%eax
 4f7:	0f b6 00             	movzbl (%eax),%eax
 4fa:	0f be c0             	movsbl %al,%eax
 4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	89 04 24             	mov    %eax,(%esp)
 507:	e8 31 ff ff ff       	call   43d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 514:	79 d9                	jns    4ef <printint+0x8a>
    putc(fd, buf[i]);
}
 516:	83 c4 30             	add    $0x30,%esp
 519:	5b                   	pop    %ebx
 51a:	5e                   	pop    %esi
 51b:	5d                   	pop    %ebp
 51c:	c3                   	ret    

0000051d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51d:	55                   	push   %ebp
 51e:	89 e5                	mov    %esp,%ebp
 520:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 523:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52a:	8d 45 0c             	lea    0xc(%ebp),%eax
 52d:	83 c0 04             	add    $0x4,%eax
 530:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 533:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53a:	e9 7c 01 00 00       	jmp    6bb <printf+0x19e>
    c = fmt[i] & 0xff;
 53f:	8b 55 0c             	mov    0xc(%ebp),%edx
 542:	8b 45 f0             	mov    -0x10(%ebp),%eax
 545:	01 d0                	add    %edx,%eax
 547:	0f b6 00             	movzbl (%eax),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	25 ff 00 00 00       	and    $0xff,%eax
 552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 555:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 559:	75 2c                	jne    587 <printf+0x6a>
      if(c == '%'){
 55b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55f:	75 0c                	jne    56d <printf+0x50>
        state = '%';
 561:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 568:	e9 4a 01 00 00       	jmp    6b7 <printf+0x19a>
      } else {
        putc(fd, c);
 56d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	89 44 24 04          	mov    %eax,0x4(%esp)
 577:	8b 45 08             	mov    0x8(%ebp),%eax
 57a:	89 04 24             	mov    %eax,(%esp)
 57d:	e8 bb fe ff ff       	call   43d <putc>
 582:	e9 30 01 00 00       	jmp    6b7 <printf+0x19a>
      }
    } else if(state == '%'){
 587:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58b:	0f 85 26 01 00 00    	jne    6b7 <printf+0x19a>
      if(c == 'd'){
 591:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 595:	75 2d                	jne    5c4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5a3:	00 
 5a4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ab:	00 
 5ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	89 04 24             	mov    %eax,(%esp)
 5b6:	e8 aa fe ff ff       	call   465 <printint>
        ap++;
 5bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bf:	e9 ec 00 00 00       	jmp    6b0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5c4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c8:	74 06                	je     5d0 <printf+0xb3>
 5ca:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ce:	75 2d                	jne    5fd <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d3:	8b 00                	mov    (%eax),%eax
 5d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5dc:	00 
 5dd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5e4:	00 
 5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	89 04 24             	mov    %eax,(%esp)
 5ef:	e8 71 fe ff ff       	call   465 <printint>
        ap++;
 5f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f8:	e9 b3 00 00 00       	jmp    6b0 <printf+0x193>
      } else if(c == 's'){
 5fd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 601:	75 45                	jne    648 <printf+0x12b>
        s = (char*)*ap;
 603:	8b 45 e8             	mov    -0x18(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 613:	75 09                	jne    61e <printf+0x101>
          s = "(null)";
 615:	c7 45 f4 36 0f 00 00 	movl   $0xf36,-0xc(%ebp)
        while(*s != 0){
 61c:	eb 1e                	jmp    63c <printf+0x11f>
 61e:	eb 1c                	jmp    63c <printf+0x11f>
          putc(fd, *s);
 620:	8b 45 f4             	mov    -0xc(%ebp),%eax
 623:	0f b6 00             	movzbl (%eax),%eax
 626:	0f be c0             	movsbl %al,%eax
 629:	89 44 24 04          	mov    %eax,0x4(%esp)
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	89 04 24             	mov    %eax,(%esp)
 633:	e8 05 fe ff ff       	call   43d <putc>
          s++;
 638:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63f:	0f b6 00             	movzbl (%eax),%eax
 642:	84 c0                	test   %al,%al
 644:	75 da                	jne    620 <printf+0x103>
 646:	eb 68                	jmp    6b0 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 648:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64c:	75 1d                	jne    66b <printf+0x14e>
        putc(fd, *ap);
 64e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	89 44 24 04          	mov    %eax,0x4(%esp)
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	89 04 24             	mov    %eax,(%esp)
 660:	e8 d8 fd ff ff       	call   43d <putc>
        ap++;
 665:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 669:	eb 45                	jmp    6b0 <printf+0x193>
      } else if(c == '%'){
 66b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66f:	75 17                	jne    688 <printf+0x16b>
        putc(fd, c);
 671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 674:	0f be c0             	movsbl %al,%eax
 677:	89 44 24 04          	mov    %eax,0x4(%esp)
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 b7 fd ff ff       	call   43d <putc>
 686:	eb 28                	jmp    6b0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 688:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 68f:	00 
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 04 24             	mov    %eax,(%esp)
 696:	e8 a2 fd ff ff       	call   43d <putc>
        putc(fd, c);
 69b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69e:	0f be c0             	movsbl %al,%eax
 6a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	89 04 24             	mov    %eax,(%esp)
 6ab:	e8 8d fd ff ff       	call   43d <putc>
      }
      state = 0;
 6b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6bb:	8b 55 0c             	mov    0xc(%ebp),%edx
 6be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c1:	01 d0                	add    %edx,%eax
 6c3:	0f b6 00             	movzbl (%eax),%eax
 6c6:	84 c0                	test   %al,%al
 6c8:	0f 85 71 fe ff ff    	jne    53f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ce:	c9                   	leave  
 6cf:	c3                   	ret    

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	83 e8 08             	sub    $0x8,%eax
 6dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6df:	a1 08 14 00 00       	mov    0x1408,%eax
 6e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e7:	eb 24                	jmp    70d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f1:	77 12                	ja     705 <free+0x35>
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	77 24                	ja     71f <free+0x4f>
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 703:	77 1a                	ja     71f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 713:	76 d4                	jbe    6e9 <free+0x19>
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71d:	76 ca                	jbe    6e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	39 c2                	cmp    %eax,%edx
 738:	75 24                	jne    75e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 50 04             	mov    0x4(%eax),%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	01 c2                	add    %eax,%edx
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
 75c:	eb 0a                	jmp    768 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	01 d0                	add    %edx,%eax
 77a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77d:	75 20                	jne    79f <free+0xcf>
    p->s.size += bp->s.size;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 50 04             	mov    0x4(%eax),%edx
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 08                	jmp    7a7 <free+0xd7>
  } else
    p->s.ptr = bp;
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a5:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	a3 08 14 00 00       	mov    %eax,0x1408
}
 7af:	c9                   	leave  
 7b0:	c3                   	ret    

000007b1 <morecore>:

static Header*
morecore(uint nu)
{
 7b1:	55                   	push   %ebp
 7b2:	89 e5                	mov    %esp,%ebp
 7b4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7be:	77 07                	ja     7c7 <morecore+0x16>
    nu = 4096;
 7c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	c1 e0 03             	shl    $0x3,%eax
 7cd:	89 04 24             	mov    %eax,(%esp)
 7d0:	e8 50 fc ff ff       	call   425 <sbrk>
 7d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7dc:	75 07                	jne    7e5 <morecore+0x34>
    return 0;
 7de:	b8 00 00 00 00       	mov    $0x0,%eax
 7e3:	eb 22                	jmp    807 <morecore+0x56>
  hp = (Header*)p;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	8b 55 08             	mov    0x8(%ebp),%edx
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	83 c0 08             	add    $0x8,%eax
 7fa:	89 04 24             	mov    %eax,(%esp)
 7fd:	e8 ce fe ff ff       	call   6d0 <free>
  return freep;
 802:	a1 08 14 00 00       	mov    0x1408,%eax
}
 807:	c9                   	leave  
 808:	c3                   	ret    

00000809 <malloc>:

void*
malloc(uint nbytes)
{
 809:	55                   	push   %ebp
 80a:	89 e5                	mov    %esp,%ebp
 80c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80f:	8b 45 08             	mov    0x8(%ebp),%eax
 812:	83 c0 07             	add    $0x7,%eax
 815:	c1 e8 03             	shr    $0x3,%eax
 818:	83 c0 01             	add    $0x1,%eax
 81b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81e:	a1 08 14 00 00       	mov    0x1408,%eax
 823:	89 45 f0             	mov    %eax,-0x10(%ebp)
 826:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82a:	75 23                	jne    84f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 82c:	c7 45 f0 00 14 00 00 	movl   $0x1400,-0x10(%ebp)
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	a3 08 14 00 00       	mov    %eax,0x1408
 83b:	a1 08 14 00 00       	mov    0x1408,%eax
 840:	a3 00 14 00 00       	mov    %eax,0x1400
    base.s.size = 0;
 845:	c7 05 04 14 00 00 00 	movl   $0x0,0x1404
 84c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 852:	8b 00                	mov    (%eax),%eax
 854:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 40 04             	mov    0x4(%eax),%eax
 85d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 860:	72 4d                	jb     8af <malloc+0xa6>
      if(p->s.size == nunits)
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	8b 40 04             	mov    0x4(%eax),%eax
 868:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86b:	75 0c                	jne    879 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 10                	mov    (%eax),%edx
 872:	8b 45 f0             	mov    -0x10(%ebp),%eax
 875:	89 10                	mov    %edx,(%eax)
 877:	eb 26                	jmp    89f <malloc+0x96>
      else {
        p->s.size -= nunits;
 879:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87c:	8b 40 04             	mov    0x4(%eax),%eax
 87f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 882:	89 c2                	mov    %eax,%edx
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 40 04             	mov    0x4(%eax),%eax
 890:	c1 e0 03             	shl    $0x3,%eax
 893:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	a3 08 14 00 00       	mov    %eax,0x1408
      return (void*)(p + 1);
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	83 c0 08             	add    $0x8,%eax
 8ad:	eb 38                	jmp    8e7 <malloc+0xde>
    }
    if(p == freep)
 8af:	a1 08 14 00 00       	mov    0x1408,%eax
 8b4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b7:	75 1b                	jne    8d4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8bc:	89 04 24             	mov    %eax,(%esp)
 8bf:	e8 ed fe ff ff       	call   7b1 <morecore>
 8c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cb:	75 07                	jne    8d4 <malloc+0xcb>
        return 0;
 8cd:	b8 00 00 00 00       	mov    $0x0,%eax
 8d2:	eb 13                	jmp    8e7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	8b 00                	mov    (%eax),%eax
 8df:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e2:	e9 70 ff ff ff       	jmp    857 <malloc+0x4e>
}
 8e7:	c9                   	leave  
 8e8:	c3                   	ret    

000008e9 <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
 8e9:	55                   	push   %ebp
 8ea:	89 e5                	mov    %esp,%ebp
 8ec:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 8ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8f6:	eb 17                	jmp    90f <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 902:	85 c0                	test   %eax,%eax
 904:	75 05                	jne    90b <findNextFreeThreadId+0x22>
			return i;
 906:	8b 45 fc             	mov    -0x4(%ebp),%eax
 909:	eb 0f                	jmp    91a <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
 90b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 90f:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 913:	7e e3                	jle    8f8 <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
 915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 91a:	c9                   	leave  
 91b:	c3                   	ret    

0000091c <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
 91c:	55                   	push   %ebp
 91d:	89 e5                	mov    %esp,%ebp
 91f:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
 922:	a1 20 17 00 00       	mov    0x1720,%eax
 927:	8b 00                	mov    (%eax),%eax
 929:	8d 50 01             	lea    0x1(%eax),%edx
 92c:	89 d0                	mov    %edx,%eax
 92e:	c1 f8 1f             	sar    $0x1f,%eax
 931:	c1 e8 1a             	shr    $0x1a,%eax
 934:	01 c2                	add    %eax,%edx
 936:	83 e2 3f             	and    $0x3f,%edx
 939:	29 c2                	sub    %eax,%edx
 93b:	89 d0                	mov    %edx,%eax
 93d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 94a:	8b 40 28             	mov    0x28(%eax),%eax
 94d:	83 f8 02             	cmp    $0x2,%eax
 950:	75 0c                	jne    95e <findNextRunnableThread+0x42>
			return threadTable.threads[i];
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 95c:	eb 1c                	jmp    97a <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	8d 50 01             	lea    0x1(%eax),%edx
 964:	89 d0                	mov    %edx,%eax
 966:	c1 f8 1f             	sar    $0x1f,%eax
 969:	c1 e8 1a             	shr    $0x1a,%eax
 96c:	01 c2                	add    %eax,%edx
 96e:	83 e2 3f             	and    $0x3f,%edx
 971:	29 c2                	sub    %eax,%edx
 973:	89 d0                	mov    %edx,%eax
 975:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
 978:	eb c6                	jmp    940 <findNextRunnableThread+0x24>
}
 97a:	c9                   	leave  
 97b:	c3                   	ret    

0000097c <uthread_init>:

void uthread_init(void)
{
 97c:	55                   	push   %ebp
 97d:	89 e5                	mov    %esp,%ebp
 97f:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 982:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 989:	eb 12                	jmp    99d <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	c7 04 85 20 16 00 00 	movl   $0x0,0x1620(,%eax,4)
 995:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
 999:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 99d:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 9a1:	7e e8                	jle    98b <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
 9a3:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 9aa:	e8 5a fe ff ff       	call   809 <malloc>
 9af:	a3 20 16 00 00       	mov    %eax,0x1620
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
 9b4:	a1 20 16 00 00       	mov    0x1620,%eax
 9b9:	89 e2                	mov    %esp,%edx
 9bb:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
 9be:	a1 20 16 00 00       	mov    0x1620,%eax
 9c3:	89 ea                	mov    %ebp,%edx
 9c5:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
 9c8:	a1 20 16 00 00       	mov    0x1620,%eax
 9cd:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
 9d4:	a1 20 16 00 00       	mov    0x1620,%eax
 9d9:	a3 20 17 00 00       	mov    %eax,0x1720
	threadTable.threadCount = 1;
 9de:	c7 05 24 17 00 00 01 	movl   $0x1,0x1724
 9e5:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
 9e8:	c7 44 24 04 c1 0b 00 	movl   $0xbc1,0x4(%esp)
 9ef:	00 
 9f0:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 9f7:	e8 99 f9 ff ff       	call   395 <signal>
	alarm(UTHREAD_QUANTA);
 9fc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a03:	e8 9d f9 ff ff       	call   3a5 <alarm>
}
 a08:	c9                   	leave  
 a09:	c3                   	ret    

00000a0a <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
 a0a:	55                   	push   %ebp
 a0b:	89 e5                	mov    %esp,%ebp
 a0d:	53                   	push   %ebx
 a0e:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
 a11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 a18:	e8 88 f9 ff ff       	call   3a5 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
 a1d:	e8 c7 fe ff ff       	call   8e9 <findNextFreeThreadId>
 a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
 a25:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a29:	75 0a                	jne    a35 <uthread_create+0x2b>
		return -1;
 a2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a30:	e9 d6 00 00 00       	jmp    b0b <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
 a35:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
 a3c:	e8 c8 fd ff ff       	call   809 <malloc>
 a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a44:	89 04 95 20 16 00 00 	mov    %eax,0x1620(,%edx,4)
	threadTable.threads[current]->tid = current;
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a58:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
 a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5d:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 a64:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
 a6b:	a1 24 17 00 00       	mov    0x1724,%eax
 a70:	83 c0 01             	add    $0x1,%eax
 a73:	a3 24 17 00 00       	mov    %eax,0x1724
	threadTable.threads[current]->entry = func;
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 a82:	8b 55 08             	mov    0x8(%ebp),%edx
 a85:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
 a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8b:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 a92:	8b 55 0c             	mov    0xc(%ebp),%edx
 a95:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
 a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9b:	8b 1c 85 20 16 00 00 	mov    0x1620(,%eax,4),%ebx
 aa2:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 aa9:	e8 5b fd ff ff       	call   809 <malloc>
 aae:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
 ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab4:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 abe:	8b 14 95 20 16 00 00 	mov    0x1620(,%edx,4),%edx
 ac5:	8b 52 24             	mov    0x24(%edx),%edx
 ac8:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
 ace:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
 ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad4:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ade:	8b 14 95 20 16 00 00 	mov    0x1620(,%edx,4),%edx
 ae5:	8b 52 04             	mov    0x4(%edx),%edx
 ae8:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
 aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aee:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 af5:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 afc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b03:	e8 9d f8 ff ff       	call   3a5 <alarm>
	return current;
 b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 b0b:	83 c4 24             	add    $0x24,%esp
 b0e:	5b                   	pop    %ebx
 b0f:	5d                   	pop    %ebp
 b10:	c3                   	ret    

00000b11 <uthread_exit>:

void uthread_exit(void)
{
 b11:	55                   	push   %ebp
 b12:	89 e5                	mov    %esp,%ebp
 b14:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
 b17:	a1 20 17 00 00       	mov    0x1720,%eax
 b1c:	8b 00                	mov    (%eax),%eax
 b1e:	85 c0                	test   %eax,%eax
 b20:	74 10                	je     b32 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
 b22:	a1 20 17 00 00       	mov    0x1720,%eax
 b27:	8b 40 24             	mov    0x24(%eax),%eax
 b2a:	89 04 24             	mov    %eax,(%esp)
 b2d:	e8 9e fb ff ff       	call   6d0 <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
 b32:	a1 20 17 00 00       	mov    0x1720,%eax
 b37:	8b 00                	mov    (%eax),%eax
 b39:	c7 04 85 20 16 00 00 	movl   $0x0,0x1620(,%eax,4)
 b40:	00 00 00 00 
	
	free(threadTable.runningThread);
 b44:	a1 20 17 00 00       	mov    0x1720,%eax
 b49:	89 04 24             	mov    %eax,(%esp)
 b4c:	e8 7f fb ff ff       	call   6d0 <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
 b51:	a1 24 17 00 00       	mov    0x1724,%eax
 b56:	83 e8 01             	sub    $0x1,%eax
 b59:	a3 24 17 00 00       	mov    %eax,0x1724
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
 b5e:	a1 24 17 00 00       	mov    0x1724,%eax
 b63:	85 c0                	test   %eax,%eax
 b65:	75 05                	jne    b6c <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
 b67:	e8 19 f8 ff ff       	call   385 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
 b6c:	e8 ab fd ff ff       	call   91c <findNextRunnableThread>
 b71:	a3 20 17 00 00       	mov    %eax,0x1720
	
	threadTable.runningThread->state = T_RUNNING;
 b76:	a1 20 17 00 00       	mov    0x1720,%eax
 b7b:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
 b82:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b89:	e8 17 f8 ff ff       	call   3a5 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 b8e:	a1 20 17 00 00       	mov    0x1720,%eax
 b93:	8b 40 04             	mov    0x4(%eax),%eax
 b96:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 b98:	a1 20 17 00 00       	mov    0x1720,%eax
 b9d:	8b 40 08             	mov    0x8(%eax),%eax
 ba0:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
 ba2:	a1 20 17 00 00       	mov    0x1720,%eax
 ba7:	8b 40 2c             	mov    0x2c(%eax),%eax
 baa:	85 c0                	test   %eax,%eax
 bac:	74 11                	je     bbf <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
 bae:	a1 20 17 00 00       	mov    0x1720,%eax
 bb3:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
 bba:	e8 8e 00 00 00       	call   c4d <wrapper>
	}
	

}
 bbf:	c9                   	leave  
 bc0:	c3                   	ret    

00000bc1 <uthread_yield>:

void uthread_yield(void)
{
 bc1:	55                   	push   %ebp
 bc2:	89 e5                	mov    %esp,%ebp
 bc4:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
 bc7:	a1 20 17 00 00       	mov    0x1720,%eax
 bcc:	89 e2                	mov    %esp,%edx
 bce:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 bd1:	a1 20 17 00 00       	mov    0x1720,%eax
 bd6:	89 ea                	mov    %ebp,%edx
 bd8:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
 bdb:	a1 20 17 00 00       	mov    0x1720,%eax
 be0:	8b 40 28             	mov    0x28(%eax),%eax
 be3:	83 f8 01             	cmp    $0x1,%eax
 be6:	75 0c                	jne    bf4 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
 be8:	a1 20 17 00 00       	mov    0x1720,%eax
 bed:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 bf4:	e8 23 fd ff ff       	call   91c <findNextRunnableThread>
 bf9:	a3 20 17 00 00       	mov    %eax,0x1720
	threadTable.runningThread->state = T_RUNNING;
 bfe:	a1 20 17 00 00       	mov    0x1720,%eax
 c03:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 c0a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c11:	e8 8f f7 ff ff       	call   3a5 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
 c16:	a1 20 17 00 00       	mov    0x1720,%eax
 c1b:	8b 40 04             	mov    0x4(%eax),%eax
 c1e:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
 c20:	a1 20 17 00 00       	mov    0x1720,%eax
 c25:	8b 40 08             	mov    0x8(%eax),%eax
 c28:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
 c2a:	a1 20 17 00 00       	mov    0x1720,%eax
 c2f:	8b 40 2c             	mov    0x2c(%eax),%eax
 c32:	85 c0                	test   %eax,%eax
 c34:	74 14                	je     c4a <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 c36:	a1 20 17 00 00       	mov    0x1720,%eax
 c3b:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 c42:	b8 4d 0c 00 00       	mov    $0xc4d,%eax
 c47:	ff d0                	call   *%eax
		asm("ret");
 c49:	c3                   	ret    
	}
	return;
 c4a:	90                   	nop
}
 c4b:	c9                   	leave  
 c4c:	c3                   	ret    

00000c4d <wrapper>:

void wrapper(void) {
 c4d:	55                   	push   %ebp
 c4e:	89 e5                	mov    %esp,%ebp
 c50:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
 c53:	a1 20 17 00 00       	mov    0x1720,%eax
 c58:	8b 40 30             	mov    0x30(%eax),%eax
 c5b:	8b 15 20 17 00 00    	mov    0x1720,%edx
 c61:	8b 52 34             	mov    0x34(%edx),%edx
 c64:	89 14 24             	mov    %edx,(%esp)
 c67:	ff d0                	call   *%eax
	uthread_exit();
 c69:	e8 a3 fe ff ff       	call   b11 <uthread_exit>
}
 c6e:	c9                   	leave  
 c6f:	c3                   	ret    

00000c70 <uthread_self>:

int uthread_self(void)
{
 c70:	55                   	push   %ebp
 c71:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
 c73:	a1 20 17 00 00       	mov    0x1720,%eax
 c78:	8b 00                	mov    (%eax),%eax
}
 c7a:	5d                   	pop    %ebp
 c7b:	c3                   	ret    

00000c7c <uthread_join>:

int uthread_join(int tid)
{
 c7c:	55                   	push   %ebp
 c7d:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
 c7f:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
 c83:	7e 07                	jle    c8c <uthread_join+0x10>
		return -1;
 c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 c8a:	eb 14                	jmp    ca0 <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
 c8c:	90                   	nop
 c8d:	8b 45 08             	mov    0x8(%ebp),%eax
 c90:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 c97:	85 c0                	test   %eax,%eax
 c99:	75 f2                	jne    c8d <uthread_join+0x11>
	return 0;
 c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 ca0:	5d                   	pop    %ebp
 ca1:	c3                   	ret    

00000ca2 <uthread_sleep>:

void uthread_sleep(void)
{
 ca2:	55                   	push   %ebp
 ca3:	89 e5                	mov    %esp,%ebp
 ca5:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
 ca8:	a1 20 17 00 00       	mov    0x1720,%eax
 cad:	89 e2                	mov    %esp,%edx
 caf:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
 cb2:	a1 20 17 00 00       	mov    0x1720,%eax
 cb7:	89 ea                	mov    %ebp,%edx
 cb9:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
 cbc:	a1 20 17 00 00       	mov    0x1720,%eax
 cc1:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
 cc8:	a1 20 17 00 00       	mov    0x1720,%eax
 ccd:	8b 00                	mov    (%eax),%eax
 ccf:	89 44 24 08          	mov    %eax,0x8(%esp)
 cd3:	c7 44 24 04 3d 0f 00 	movl   $0xf3d,0x4(%esp)
 cda:	00 
 cdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ce2:	e8 36 f8 ff ff       	call   51d <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
 ce7:	e8 30 fc ff ff       	call   91c <findNextRunnableThread>
 cec:	a3 20 17 00 00       	mov    %eax,0x1720
	threadTable.runningThread->state = T_RUNNING;
 cf1:	a1 20 17 00 00       	mov    0x1720,%eax
 cf6:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
 cfd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 d04:	e8 9c f6 ff ff       	call   3a5 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
 d09:	a1 20 17 00 00       	mov    0x1720,%eax
 d0e:	8b 40 08             	mov    0x8(%eax),%eax
 d11:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
 d13:	a1 20 17 00 00       	mov    0x1720,%eax
 d18:	8b 40 04             	mov    0x4(%eax),%eax
 d1b:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
 d1d:	a1 20 17 00 00       	mov    0x1720,%eax
 d22:	8b 40 2c             	mov    0x2c(%eax),%eax
 d25:	85 c0                	test   %eax,%eax
 d27:	74 14                	je     d3d <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
 d29:	a1 20 17 00 00       	mov    0x1720,%eax
 d2e:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
 d35:	b8 4d 0c 00 00       	mov    $0xc4d,%eax
 d3a:	ff d0                	call   *%eax
		asm("ret");
 d3c:	c3                   	ret    
	}
	return;	
 d3d:	90                   	nop
}
 d3e:	c9                   	leave  
 d3f:	c3                   	ret    

00000d40 <uthread_wakeup>:
void uthread_wakeup(int tid)
{
 d40:	55                   	push   %ebp
 d41:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
 d43:	8b 45 08             	mov    0x8(%ebp),%eax
 d46:	8b 04 85 20 16 00 00 	mov    0x1620(,%eax,4),%eax
 d4d:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
 d54:	5d                   	pop    %ebp
 d55:	c3                   	ret    

00000d56 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
 d56:	55                   	push   %ebp
 d57:	89 e5                	mov    %esp,%ebp
 d59:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
 d5c:	c7 44 24 04 58 0f 00 	movl   $0xf58,0x4(%esp)
 d63:	00 
 d64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d6b:	e8 ad f7 ff ff       	call   51d <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 d77:	eb 26                	jmp    d9f <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
 d79:	8b 45 08             	mov    0x8(%ebp),%eax
 d7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 d7f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 d83:	89 44 24 08          	mov    %eax,0x8(%esp)
 d87:	c7 44 24 04 6f 0f 00 	movl   $0xf6f,0x4(%esp)
 d8e:	00 
 d8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d96:	e8 82 f7 ff ff       	call   51d <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 d9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 d9f:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 da3:	7e d4                	jle    d79 <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
 da5:	c7 44 24 04 73 0f 00 	movl   $0xf73,0x4(%esp)
 dac:	00 
 dad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 db4:	e8 64 f7 ff ff       	call   51d <printf>
}
 db9:	c9                   	leave  
 dba:	c3                   	ret    

00000dbb <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
 dbb:	55                   	push   %ebp
 dbc:	89 e5                	mov    %esp,%ebp
 dbe:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
 dc1:	8b 45 08             	mov    0x8(%ebp),%eax
 dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
 dc7:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
 dc9:	8b 45 08             	mov    0x8(%ebp),%eax
 dcc:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
 dd3:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 dd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 ddd:	eb 12                	jmp    df1 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
 ddf:	8b 45 08             	mov    0x8(%ebp),%eax
 de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 de5:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 dec:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
 ded:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 df1:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
 df5:	7e e8                	jle    ddf <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
 df7:	c9                   	leave  
 df8:	c3                   	ret    

00000df9 <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
 df9:	55                   	push   %ebp
 dfa:	89 e5                	mov    %esp,%ebp
 dfc:	53                   	push   %ebx
 dfd:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
 e00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 e07:	e8 99 f5 ff ff       	call   3a5 <alarm>
	if (semaphore->value ==0){
 e0c:	8b 45 08             	mov    0x8(%ebp),%eax
 e0f:	8b 00                	mov    (%eax),%eax
 e11:	85 c0                	test   %eax,%eax
 e13:	75 34                	jne    e49 <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
 e15:	a1 20 17 00 00       	mov    0x1720,%eax
 e1a:	8b 08                	mov    (%eax),%ecx
 e1c:	8b 45 08             	mov    0x8(%ebp),%eax
 e1f:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 e25:	8d 58 01             	lea    0x1(%eax),%ebx
 e28:	8b 55 08             	mov    0x8(%ebp),%edx
 e2b:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
 e31:	8b 55 08             	mov    0x8(%ebp),%edx
 e34:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
 e38:	a1 20 17 00 00       	mov    0x1720,%eax
 e3d:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
 e44:	e8 78 fd ff ff       	call   bc1 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
 e49:	a1 20 17 00 00       	mov    0x1720,%eax
 e4e:	8b 10                	mov    (%eax),%edx
 e50:	8b 45 08             	mov    0x8(%ebp),%eax
 e53:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
 e5a:	ff 
	semaphore->value = 0;
 e5b:	8b 45 08             	mov    0x8(%ebp),%eax
 e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
 e64:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 e6b:	e8 35 f5 ff ff       	call   3a5 <alarm>
}
 e70:	83 c4 14             	add    $0x14,%esp
 e73:	5b                   	pop    %ebx
 e74:	5d                   	pop    %ebp
 e75:	c3                   	ret    

00000e76 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
 e76:	55                   	push   %ebp
 e77:	89 e5                	mov    %esp,%ebp
 e79:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
 e7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 e83:	e8 1d f5 ff ff       	call   3a5 <alarm>
	
	if (semaphore->value == 0){
 e88:	8b 45 08             	mov    0x8(%ebp),%eax
 e8b:	8b 00                	mov    (%eax),%eax
 e8d:	85 c0                	test   %eax,%eax
 e8f:	75 71                	jne    f02 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
 e91:	8b 45 08             	mov    0x8(%ebp),%eax
 e94:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
 e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
 e9d:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
 ea4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 eab:	eb 35                	jmp    ee2 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
 ead:	8b 45 08             	mov    0x8(%ebp),%eax
 eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 eb3:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 eb7:	83 f8 ff             	cmp    $0xffffffff,%eax
 eba:	74 22                	je     ede <binary_semaphore_up+0x68>
 ebc:	8b 45 08             	mov    0x8(%ebp),%eax
 ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ec2:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 ec6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 ec9:	7d 13                	jge    ede <binary_semaphore_up+0x68>
				minIndex = i;
 ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ece:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
 ed1:	8b 45 08             	mov    0x8(%ebp),%eax
 ed4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ed7:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
 edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
 ede:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 ee2:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
 ee6:	7e c5                	jle    ead <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
 ee8:	8b 45 08             	mov    0x8(%ebp),%eax
 eeb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
 ef1:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
 ef5:	74 0b                	je     f02 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
 ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 efa:	89 04 24             	mov    %eax,(%esp)
 efd:	e8 3e fe ff ff       	call   d40 <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
 f02:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 f09:	e8 97 f4 ff ff       	call   3a5 <alarm>
	
 f0e:	c9                   	leave  
 f0f:	c3                   	ret    
