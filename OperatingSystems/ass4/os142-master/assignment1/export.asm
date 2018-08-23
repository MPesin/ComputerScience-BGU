
_export:     file format elf32-i386


Disassembly of section .text:

00000000 <export>:
#include "user.h"
#include "our_header.h"


void export(char* buf)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	53                   	push   %ebx
   5:	81 ec a0 00 00 00    	sub    $0xa0,%esp
  int next_c,i = 0;
   b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  char tempPath[MAX_ENTRY_LEN] = "";
  12:	c7 85 70 ff ff ff 00 	movl   $0x0,-0x90(%ebp)
  19:	00 00 00 
  1c:	8d 9d 74 ff ff ff    	lea    -0x8c(%ebp),%ebx
  22:	b8 00 00 00 00       	mov    $0x0,%eax
  27:	ba 1f 00 00 00       	mov    $0x1f,%edx
  2c:	89 df                	mov    %ebx,%edi
  2e:	89 d1                	mov    %edx,%ecx
  30:	f3 ab                	rep stos %eax,%es:(%edi)

  while(*buf != 0 && *buf != '\n' && *buf != '\t' && *buf != '\r' && *buf != ' ') {
  32:	eb 78                	jmp    ac <export+0xac>
    if(*buf != ':') {
  34:	8b 45 08             	mov    0x8(%ebp),%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 3a                	cmp    $0x3a,%al
  3c:	74 17                	je     55 <export+0x55>
    	tempPath[next_c] = *buf;
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	0f b6 10             	movzbl (%eax),%edx
  44:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  4a:	03 45 f4             	add    -0xc(%ebp),%eax
  4d:	88 10                	mov    %dl,(%eax)
    	next_c++;
  4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  53:	eb 53                	jmp    a8 <export+0xa8>
    }
    else	// : delimiter , new path
    {

      tempPath[next_c] = 0; // NULL terminated
  55:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  5b:	03 45 f4             	add    -0xc(%ebp),%eax
  5e:	c6 00 00             	movb   $0x0,(%eax)
      add_path(tempPath);
  61:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  67:	89 04 24             	mov    %eax,(%esp)
  6a:	e8 25 03 00 00       	call   394 <add_path>
      for (i = 0 ; i < strlen(tempPath) ; i++) {
  6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  76:	eb 14                	jmp    8c <export+0x8c>
    	  tempPath[i] = *"";
  78:	ba 00 00 00 00       	mov    $0x0,%edx
  7d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  83:	03 45 f0             	add    -0x10(%ebp),%eax
  86:	88 10                	mov    %dl,(%eax)
    else	// : delimiter , new path
    {

      tempPath[next_c] = 0; // NULL terminated
      add_path(tempPath);
      for (i = 0 ; i < strlen(tempPath) ; i++) {
  88:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  8f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  95:	89 04 24             	mov    %eax,(%esp)
  98:	e8 15 01 00 00       	call   1b2 <strlen>
  9d:	39 c3                	cmp    %eax,%ebx
  9f:	72 d7                	jb     78 <export+0x78>
    	  tempPath[i] = *"";
      }
      next_c = 0;
  a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    }
    buf++;
  a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
void export(char* buf)
{
  int next_c,i = 0;
  char tempPath[MAX_ENTRY_LEN] = "";

  while(*buf != 0 && *buf != '\n' && *buf != '\t' && *buf != '\r' && *buf != ' ') {
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	74 2c                	je     e2 <export+0xe2>
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	3c 0a                	cmp    $0xa,%al
  be:	74 22                	je     e2 <export+0xe2>
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	3c 09                	cmp    $0x9,%al
  c8:	74 18                	je     e2 <export+0xe2>
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	0f b6 00             	movzbl (%eax),%eax
  d0:	3c 0d                	cmp    $0xd,%al
  d2:	74 0e                	je     e2 <export+0xe2>
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 00             	movzbl (%eax),%eax
  da:	3c 20                	cmp    $0x20,%al
  dc:	0f 85 52 ff ff ff    	jne    34 <export+0x34>
      }
      next_c = 0;
    }
    buf++;
  }
}
  e2:	81 c4 a0 00 00 00    	add    $0xa0,%esp
  e8:	5b                   	pop    %ebx
  e9:	5f                   	pop    %edi
  ea:	5d                   	pop    %ebp
  eb:	c3                   	ret    

000000ec <main>:

int
main(int argc, char *argv[])
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	83 e4 f0             	and    $0xfffffff0,%esp
  f2:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2){
  f5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  f9:	7f 05                	jg     100 <main+0x14>
    exit();
  fb:	e8 7c 02 00 00       	call   37c <exit>
  }
  export(argv[1]);
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	83 c0 04             	add    $0x4,%eax
 106:	8b 00                	mov    (%eax),%eax
 108:	89 04 24             	mov    %eax,(%esp)
 10b:	e8 f0 fe ff ff       	call   0 <export>
  exit();
 110:	e8 67 02 00 00       	call   37c <exit>
 115:	90                   	nop
 116:	90                   	nop
 117:	90                   	nop

00000118 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 120:	8b 55 10             	mov    0x10(%ebp),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 cb                	mov    %ecx,%ebx
 128:	89 df                	mov    %ebx,%edi
 12a:	89 d1                	mov    %edx,%ecx
 12c:	fc                   	cld    
 12d:	f3 aa                	rep stos %al,%es:(%edi)
 12f:	89 ca                	mov    %ecx,%edx
 131:	89 fb                	mov    %edi,%ebx
 133:	89 5d 08             	mov    %ebx,0x8(%ebp)
 136:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 149:	90                   	nop
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	0f b6 10             	movzbl (%eax),%edx
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	88 10                	mov    %dl,(%eax)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	0f 95 c0             	setne  %al
 160:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 164:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 168:	84 c0                	test   %al,%al
 16a:	75 de                	jne    14a <strcpy+0xd>
    ;
  return os;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 174:	eb 08                	jmp    17e <strcmp+0xd>
    p++, q++;
 176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	84 c0                	test   %al,%al
 186:	74 10                	je     198 <strcmp+0x27>
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 10             	movzbl (%eax),%edx
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	38 c2                	cmp    %al,%dl
 196:	74 de                	je     176 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 00             	movzbl (%eax),%eax
 19e:	0f b6 d0             	movzbl %al,%edx
 1a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a4:	0f b6 00             	movzbl (%eax),%eax
 1a7:	0f b6 c0             	movzbl %al,%eax
 1aa:	89 d1                	mov    %edx,%ecx
 1ac:	29 c1                	sub    %eax,%ecx
 1ae:	89 c8                	mov    %ecx,%eax
}
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <strlen>:

uint
strlen(char *s)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1bf:	eb 04                	jmp    1c5 <strlen+0x13>
 1c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c8:	03 45 08             	add    0x8(%ebp),%eax
 1cb:	0f b6 00             	movzbl (%eax),%eax
 1ce:	84 c0                	test   %al,%al
 1d0:	75 ef                	jne    1c1 <strlen+0xf>
    ;
  return n;
 1d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1dd:	8b 45 10             	mov    0x10(%ebp),%eax
 1e0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	89 04 24             	mov    %eax,(%esp)
 1f1:	e8 22 ff ff ff       	call   118 <stosb>
  return dst;
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <strchr>:

char*
strchr(const char *s, char c)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 04             	sub    $0x4,%esp
 201:	8b 45 0c             	mov    0xc(%ebp),%eax
 204:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 207:	eb 14                	jmp    21d <strchr+0x22>
    if(*s == c)
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 212:	75 05                	jne    219 <strchr+0x1e>
      return (char*)s;
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	eb 13                	jmp    22c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 219:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	84 c0                	test   %al,%al
 225:	75 e2                	jne    209 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 227:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <gets>:

char*
gets(char *buf, int max)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23b:	eb 44                	jmp    281 <gets+0x53>
    cc = read(0, &c, 1);
 23d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 244:	00 
 245:	8d 45 ef             	lea    -0x11(%ebp),%eax
 248:	89 44 24 04          	mov    %eax,0x4(%esp)
 24c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 253:	e8 4c 01 00 00       	call   3a4 <read>
 258:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25f:	7e 2d                	jle    28e <gets+0x60>
      break;
    buf[i++] = c;
 261:	8b 45 f4             	mov    -0xc(%ebp),%eax
 264:	03 45 08             	add    0x8(%ebp),%eax
 267:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 26b:	88 10                	mov    %dl,(%eax)
 26d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 271:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 275:	3c 0a                	cmp    $0xa,%al
 277:	74 16                	je     28f <gets+0x61>
 279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 0e                	je     28f <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	83 c0 01             	add    $0x1,%eax
 287:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28a:	7c b1                	jl     23d <gets+0xf>
 28c:	eb 01                	jmp    28f <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 292:	03 45 08             	add    0x8(%ebp),%eax
 295:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <stat>:

int
stat(char *n, struct stat *st)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2aa:	00 
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	89 04 24             	mov    %eax,(%esp)
 2b1:	e8 16 01 00 00       	call   3cc <open>
 2b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bd:	79 07                	jns    2c6 <stat+0x29>
    return -1;
 2bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c4:	eb 23                	jmp    2e9 <stat+0x4c>
  r = fstat(fd, st);
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d0:	89 04 24             	mov    %eax,(%esp)
 2d3:	e8 0c 01 00 00       	call   3e4 <fstat>
 2d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	89 04 24             	mov    %eax,(%esp)
 2e1:	e8 ce 00 00 00       	call   3b4 <close>
  return r;
 2e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <atoi>:

int
atoi(const char *s)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f8:	eb 23                	jmp    31d <atoi+0x32>
    n = n*10 + *s++ - '0';
 2fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fd:	89 d0                	mov    %edx,%eax
 2ff:	c1 e0 02             	shl    $0x2,%eax
 302:	01 d0                	add    %edx,%eax
 304:	01 c0                	add    %eax,%eax
 306:	89 c2                	mov    %eax,%edx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	0f be c0             	movsbl %al,%eax
 311:	01 d0                	add    %edx,%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
 319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2f                	cmp    $0x2f,%al
 325:	7e 0a                	jle    331 <atoi+0x46>
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 39                	cmp    $0x39,%al
 32f:	7e c9                	jle    2fa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 331:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 348:	eb 13                	jmp    35d <memmove+0x27>
    *dst++ = *src++;
 34a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34d:	0f b6 10             	movzbl (%eax),%edx
 350:	8b 45 fc             	mov    -0x4(%ebp),%eax
 353:	88 10                	mov    %dl,(%eax)
 355:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 359:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 361:	0f 9f c0             	setg   %al
 364:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 368:	84 c0                	test   %al,%al
 36a:	75 de                	jne    34a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    
 371:	90                   	nop
 372:	90                   	nop
 373:	90                   	nop

00000374 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
SYSCALL(exit)
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
SYSCALL(wait)
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <wait2>:
SYSCALL(wait2)
 38c:	b8 16 00 00 00       	mov    $0x16,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <add_path>:
SYSCALL(add_path)
 394:	b8 17 00 00 00       	mov    $0x17,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <pipe>:
SYSCALL(pipe)
 39c:	b8 04 00 00 00       	mov    $0x4,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <read>:
SYSCALL(read)
 3a4:	b8 05 00 00 00       	mov    $0x5,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <write>:
SYSCALL(write)
 3ac:	b8 10 00 00 00       	mov    $0x10,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <close>:
SYSCALL(close)
 3b4:	b8 15 00 00 00       	mov    $0x15,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <kill>:
SYSCALL(kill)
 3bc:	b8 06 00 00 00       	mov    $0x6,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <exec>:
SYSCALL(exec)
 3c4:	b8 07 00 00 00       	mov    $0x7,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <open>:
SYSCALL(open)
 3cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <mknod>:
SYSCALL(mknod)
 3d4:	b8 11 00 00 00       	mov    $0x11,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <unlink>:
SYSCALL(unlink)
 3dc:	b8 12 00 00 00       	mov    $0x12,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <fstat>:
SYSCALL(fstat)
 3e4:	b8 08 00 00 00       	mov    $0x8,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <link>:
SYSCALL(link)
 3ec:	b8 13 00 00 00       	mov    $0x13,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <mkdir>:
SYSCALL(mkdir)
 3f4:	b8 14 00 00 00       	mov    $0x14,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <chdir>:
SYSCALL(chdir)
 3fc:	b8 09 00 00 00       	mov    $0x9,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <dup>:
SYSCALL(dup)
 404:	b8 0a 00 00 00       	mov    $0xa,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <getpid>:
SYSCALL(getpid)
 40c:	b8 0b 00 00 00       	mov    $0xb,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <sbrk>:
SYSCALL(sbrk)
 414:	b8 0c 00 00 00       	mov    $0xc,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <sleep>:
SYSCALL(sleep)
 41c:	b8 0d 00 00 00       	mov    $0xd,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <uptime>:
SYSCALL(uptime)
 424:	b8 0e 00 00 00       	mov    $0xe,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 28             	sub    $0x28,%esp
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 438:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43f:	00 
 440:	8d 45 f4             	lea    -0xc(%ebp),%eax
 443:	89 44 24 04          	mov    %eax,0x4(%esp)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	89 04 24             	mov    %eax,(%esp)
 44d:	e8 5a ff ff ff       	call   3ac <write>
}
 452:	c9                   	leave  
 453:	c3                   	ret    

00000454 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 45a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 461:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 465:	74 17                	je     47e <printint+0x2a>
 467:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 46b:	79 11                	jns    47e <printint+0x2a>
    neg = 1;
 46d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	f7 d8                	neg    %eax
 479:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47c:	eb 06                	jmp    484 <printint+0x30>
  } else {
    x = xx;
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 48b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 491:	ba 00 00 00 00       	mov    $0x0,%edx
 496:	f7 f1                	div    %ecx
 498:	89 d0                	mov    %edx,%eax
 49a:	0f b6 90 34 0b 00 00 	movzbl 0xb34(%eax),%edx
 4a1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4a4:	03 45 f4             	add    -0xc(%ebp),%eax
 4a7:	88 10                	mov    %dl,(%eax)
 4a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4ad:	8b 55 10             	mov    0x10(%ebp),%edx
 4b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b6:	ba 00 00 00 00       	mov    $0x0,%edx
 4bb:	f7 75 d4             	divl   -0x2c(%ebp)
 4be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c5:	75 c4                	jne    48b <printint+0x37>
  if(neg)
 4c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4cb:	74 2a                	je     4f7 <printint+0xa3>
    buf[i++] = '-';
 4cd:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4d0:	03 45 f4             	add    -0xc(%ebp),%eax
 4d3:	c6 00 2d             	movb   $0x2d,(%eax)
 4d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 4da:	eb 1b                	jmp    4f7 <printint+0xa3>
    putc(fd, buf[i]);
 4dc:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4df:	03 45 f4             	add    -0xc(%ebp),%eax
 4e2:	0f b6 00             	movzbl (%eax),%eax
 4e5:	0f be c0             	movsbl %al,%eax
 4e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
 4ef:	89 04 24             	mov    %eax,(%esp)
 4f2:	e8 35 ff ff ff       	call   42c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ff:	79 db                	jns    4dc <printint+0x88>
    putc(fd, buf[i]);
}
 501:	c9                   	leave  
 502:	c3                   	ret    

00000503 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 503:	55                   	push   %ebp
 504:	89 e5                	mov    %esp,%ebp
 506:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 510:	8d 45 0c             	lea    0xc(%ebp),%eax
 513:	83 c0 04             	add    $0x4,%eax
 516:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 519:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 520:	e9 7d 01 00 00       	jmp    6a2 <printf+0x19f>
    c = fmt[i] & 0xff;
 525:	8b 55 0c             	mov    0xc(%ebp),%edx
 528:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52b:	01 d0                	add    %edx,%eax
 52d:	0f b6 00             	movzbl (%eax),%eax
 530:	0f be c0             	movsbl %al,%eax
 533:	25 ff 00 00 00       	and    $0xff,%eax
 538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 53b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53f:	75 2c                	jne    56d <printf+0x6a>
      if(c == '%'){
 541:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 545:	75 0c                	jne    553 <printf+0x50>
        state = '%';
 547:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 54e:	e9 4b 01 00 00       	jmp    69e <printf+0x19b>
      } else {
        putc(fd, c);
 553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 556:	0f be c0             	movsbl %al,%eax
 559:	89 44 24 04          	mov    %eax,0x4(%esp)
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	89 04 24             	mov    %eax,(%esp)
 563:	e8 c4 fe ff ff       	call   42c <putc>
 568:	e9 31 01 00 00       	jmp    69e <printf+0x19b>
      }
    } else if(state == '%'){
 56d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 571:	0f 85 27 01 00 00    	jne    69e <printf+0x19b>
      if(c == 'd'){
 577:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 57b:	75 2d                	jne    5aa <printf+0xa7>
        printint(fd, *ap, 10, 1);
 57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 580:	8b 00                	mov    (%eax),%eax
 582:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 589:	00 
 58a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 591:	00 
 592:	89 44 24 04          	mov    %eax,0x4(%esp)
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 b3 fe ff ff       	call   454 <printint>
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a5:	e9 ed 00 00 00       	jmp    697 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5aa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ae:	74 06                	je     5b6 <printf+0xb3>
 5b0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b4:	75 2d                	jne    5e3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c2:	00 
 5c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5ca:	00 
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 7a fe ff ff       	call   454 <printint>
        ap++;
 5da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5de:	e9 b4 00 00 00       	jmp    697 <printf+0x194>
      } else if(c == 's'){
 5e3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e7:	75 46                	jne    62f <printf+0x12c>
        s = (char*)*ap;
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f9:	75 27                	jne    622 <printf+0x11f>
          s = "(null)";
 5fb:	c7 45 f4 c7 08 00 00 	movl   $0x8c7,-0xc(%ebp)
        while(*s != 0){
 602:	eb 1e                	jmp    622 <printf+0x11f>
          putc(fd, *s);
 604:	8b 45 f4             	mov    -0xc(%ebp),%eax
 607:	0f b6 00             	movzbl (%eax),%eax
 60a:	0f be c0             	movsbl %al,%eax
 60d:	89 44 24 04          	mov    %eax,0x4(%esp)
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	89 04 24             	mov    %eax,(%esp)
 617:	e8 10 fe ff ff       	call   42c <putc>
          s++;
 61c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 620:	eb 01                	jmp    623 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 622:	90                   	nop
 623:	8b 45 f4             	mov    -0xc(%ebp),%eax
 626:	0f b6 00             	movzbl (%eax),%eax
 629:	84 c0                	test   %al,%al
 62b:	75 d7                	jne    604 <printf+0x101>
 62d:	eb 68                	jmp    697 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 633:	75 1d                	jne    652 <printf+0x14f>
        putc(fd, *ap);
 635:	8b 45 e8             	mov    -0x18(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	0f be c0             	movsbl %al,%eax
 63d:	89 44 24 04          	mov    %eax,0x4(%esp)
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 04 24             	mov    %eax,(%esp)
 647:	e8 e0 fd ff ff       	call   42c <putc>
        ap++;
 64c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 650:	eb 45                	jmp    697 <printf+0x194>
      } else if(c == '%'){
 652:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 656:	75 17                	jne    66f <printf+0x16c>
        putc(fd, c);
 658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	89 44 24 04          	mov    %eax,0x4(%esp)
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 bf fd ff ff       	call   42c <putc>
 66d:	eb 28                	jmp    697 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 676:	00 
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 aa fd ff ff       	call   42c <putc>
        putc(fd, c);
 682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 685:	0f be c0             	movsbl %al,%eax
 688:	89 44 24 04          	mov    %eax,0x4(%esp)
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	89 04 24             	mov    %eax,(%esp)
 692:	e8 95 fd ff ff       	call   42c <putc>
      }
      state = 0;
 697:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a8:	01 d0                	add    %edx,%eax
 6aa:	0f b6 00             	movzbl (%eax),%eax
 6ad:	84 c0                	test   %al,%al
 6af:	0f 85 70 fe ff ff    	jne    525 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b5:	c9                   	leave  
 6b6:	c3                   	ret    
 6b7:	90                   	nop

000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	83 e8 08             	sub    $0x8,%eax
 6c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c7:	a1 50 0b 00 00       	mov    0xb50,%eax
 6cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cf:	eb 24                	jmp    6f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 12                	ja     6ed <free+0x35>
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	77 24                	ja     707 <free+0x4f>
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6eb:	77 1a                	ja     707 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fb:	76 d4                	jbe    6d1 <free+0x19>
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 705:	76 ca                	jbe    6d1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	8b 40 04             	mov    0x4(%eax),%eax
 70d:	c1 e0 03             	shl    $0x3,%eax
 710:	89 c2                	mov    %eax,%edx
 712:	03 55 f8             	add    -0x8(%ebp),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	39 c2                	cmp    %eax,%edx
 71c:	75 24                	jne    742 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	8b 50 04             	mov    0x4(%eax),%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
 740:	eb 0a                	jmp    74c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 10                	mov    (%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	c1 e0 03             	shl    $0x3,%eax
 755:	03 45 fc             	add    -0x4(%ebp),%eax
 758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75b:	75 20                	jne    77d <free+0xc5>
    p->s.size += bp->s.size;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 50 04             	mov    0x4(%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	01 c2                	add    %eax,%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
 77b:	eb 08                	jmp    785 <free+0xcd>
  } else
    p->s.ptr = bp;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 55 f8             	mov    -0x8(%ebp),%edx
 783:	89 10                	mov    %edx,(%eax)
  freep = p;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	a3 50 0b 00 00       	mov    %eax,0xb50
}
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <morecore>:

static Header*
morecore(uint nu)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 795:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79c:	77 07                	ja     7a5 <morecore+0x16>
    nu = 4096;
 79e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	c1 e0 03             	shl    $0x3,%eax
 7ab:	89 04 24             	mov    %eax,(%esp)
 7ae:	e8 61 fc ff ff       	call   414 <sbrk>
 7b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ba:	75 07                	jne    7c3 <morecore+0x34>
    return 0;
 7bc:	b8 00 00 00 00       	mov    $0x0,%eax
 7c1:	eb 22                	jmp    7e5 <morecore+0x56>
  hp = (Header*)p;
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	8b 55 08             	mov    0x8(%ebp),%edx
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	83 c0 08             	add    $0x8,%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 d8 fe ff ff       	call   6b8 <free>
  return freep;
 7e0:	a1 50 0b 00 00       	mov    0xb50,%eax
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    

000007e7 <malloc>:

void*
malloc(uint nbytes)
{
 7e7:	55                   	push   %ebp
 7e8:	89 e5                	mov    %esp,%ebp
 7ea:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
 7f0:	83 c0 07             	add    $0x7,%eax
 7f3:	c1 e8 03             	shr    $0x3,%eax
 7f6:	83 c0 01             	add    $0x1,%eax
 7f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7fc:	a1 50 0b 00 00       	mov    0xb50,%eax
 801:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 808:	75 23                	jne    82d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 80a:	c7 45 f0 48 0b 00 00 	movl   $0xb48,-0x10(%ebp)
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	a3 50 0b 00 00       	mov    %eax,0xb50
 819:	a1 50 0b 00 00       	mov    0xb50,%eax
 81e:	a3 48 0b 00 00       	mov    %eax,0xb48
    base.s.size = 0;
 823:	c7 05 4c 0b 00 00 00 	movl   $0x0,0xb4c
 82a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 40 04             	mov    0x4(%eax),%eax
 83b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83e:	72 4d                	jb     88d <malloc+0xa6>
      if(p->s.size == nunits)
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 849:	75 0c                	jne    857 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 10                	mov    (%eax),%edx
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	89 10                	mov    %edx,(%eax)
 855:	eb 26                	jmp    87d <malloc+0x96>
      else {
        p->s.size -= nunits;
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 40 04             	mov    0x4(%eax),%eax
 85d:	89 c2                	mov    %eax,%edx
 85f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	c1 e0 03             	shl    $0x3,%eax
 871:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 55 ec             	mov    -0x14(%ebp),%edx
 87a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	a3 50 0b 00 00       	mov    %eax,0xb50
      return (void*)(p + 1);
 885:	8b 45 f4             	mov    -0xc(%ebp),%eax
 888:	83 c0 08             	add    $0x8,%eax
 88b:	eb 38                	jmp    8c5 <malloc+0xde>
    }
    if(p == freep)
 88d:	a1 50 0b 00 00       	mov    0xb50,%eax
 892:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 895:	75 1b                	jne    8b2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 897:	8b 45 ec             	mov    -0x14(%ebp),%eax
 89a:	89 04 24             	mov    %eax,(%esp)
 89d:	e8 ed fe ff ff       	call   78f <morecore>
 8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a9:	75 07                	jne    8b2 <malloc+0xcb>
        return 0;
 8ab:	b8 00 00 00 00       	mov    $0x0,%eax
 8b0:	eb 13                	jmp    8c5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8c0:	e9 70 ff ff ff       	jmp    835 <malloc+0x4e>
}
 8c5:	c9                   	leave  
 8c6:	c3                   	ret    
