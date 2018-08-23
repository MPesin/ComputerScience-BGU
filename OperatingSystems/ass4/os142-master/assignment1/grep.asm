
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bf 00 00 00       	jmp    d1 <grep+0xd1>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 53                	jmp    74 <grep+0x74>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 af 01 00 00       	call   1e8 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2e                	je     6b <grep+0x6b>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	89 d1                	mov    %edx,%ecx
  50:	29 c1                	sub    %eax,%ecx
  52:	89 c8                	mov    %ecx,%eax
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 79 05 00 00       	call   5e4 <write>
      }
      p = q+1;
  6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6e:	83 c0 01             	add    $0x1,%eax
  71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  74:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  7b:	00 
  7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	e8 ac 03 00 00       	call   433 <strchr>
  87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8e:	75 91                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  90:	81 7d f0 40 0e 00 00 	cmpl   $0xe40,-0x10(%ebp)
  97:	75 07                	jne    a0 <grep+0xa0>
      m = 0;
  99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a4:	7e 2b                	jle    d1 <grep+0xd1>
      m -= p - buf;
  a6:	ba 40 0e 00 00       	mov    $0xe40,%edx
  ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ae:	89 d1                	mov    %edx,%ecx
  b0:	29 c1                	sub    %eax,%ecx
  b2:	89 c8                	mov    %ecx,%eax
  b4:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  c5:	c7 04 24 40 0e 00 00 	movl   $0xe40,(%esp)
  cc:	e8 9d 04 00 00       	call   56e <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d4:	ba 00 04 00 00       	mov    $0x400,%edx
  d9:	89 d1                	mov    %edx,%ecx
  db:	29 c1                	sub    %eax,%ecx
  dd:	89 c8                	mov    %ecx,%eax
  df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e2:	81 c2 40 0e 00 00    	add    $0xe40,%edx
  e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	89 04 24             	mov    %eax,(%esp)
  f6:	e8 e1 04 00 00       	call   5dc <read>
  fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 102:	0f 8f 0a ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 108:	c9                   	leave  
 109:	c3                   	ret    

0000010a <main>:

int
main(int argc, char *argv[])
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	83 e4 f0             	and    $0xfffffff0,%esp
 110:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 113:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 117:	7f 19                	jg     132 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 119:	c7 44 24 04 00 0b 00 	movl   $0xb00,0x4(%esp)
 120:	00 
 121:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 128:	e8 0e 06 00 00       	call   73b <printf>
    exit();
 12d:	e8 82 04 00 00       	call   5b4 <exit>
  }
  pattern = argv[1];
 132:	8b 45 0c             	mov    0xc(%ebp),%eax
 135:	8b 40 04             	mov    0x4(%eax),%eax
 138:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 13c:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 140:	7f 19                	jg     15b <main+0x51>
    grep(pattern, 0);
 142:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 149:	00 
 14a:	8b 44 24 18          	mov    0x18(%esp),%eax
 14e:	89 04 24             	mov    %eax,(%esp)
 151:	e8 aa fe ff ff       	call   0 <grep>
    exit();
 156:	e8 59 04 00 00       	call   5b4 <exit>
  }

  for(i = 2; i < argc; i++){
 15b:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 162:	00 
 163:	eb 75                	jmp    1da <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	c1 e0 02             	shl    $0x2,%eax
 16c:	03 45 0c             	add    0xc(%ebp),%eax
 16f:	8b 00                	mov    (%eax),%eax
 171:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 178:	00 
 179:	89 04 24             	mov    %eax,(%esp)
 17c:	e8 83 04 00 00       	call   604 <open>
 181:	89 44 24 14          	mov    %eax,0x14(%esp)
 185:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 18a:	79 29                	jns    1b5 <main+0xab>
      printf(1, "grep: cannot open %s\n", argv[i]);
 18c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 190:	c1 e0 02             	shl    $0x2,%eax
 193:	03 45 0c             	add    0xc(%ebp),%eax
 196:	8b 00                	mov    (%eax),%eax
 198:	89 44 24 08          	mov    %eax,0x8(%esp)
 19c:	c7 44 24 04 20 0b 00 	movl   $0xb20,0x4(%esp)
 1a3:	00 
 1a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ab:	e8 8b 05 00 00       	call   73b <printf>
      exit();
 1b0:	e8 ff 03 00 00       	call   5b4 <exit>
    }
    grep(pattern, fd);
 1b5:	8b 44 24 14          	mov    0x14(%esp),%eax
 1b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bd:	8b 44 24 18          	mov    0x18(%esp),%eax
 1c1:	89 04 24             	mov    %eax,(%esp)
 1c4:	e8 37 fe ff ff       	call   0 <grep>
    close(fd);
 1c9:	8b 44 24 14          	mov    0x14(%esp),%eax
 1cd:	89 04 24             	mov    %eax,(%esp)
 1d0:	e8 17 04 00 00       	call   5ec <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1d5:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1da:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1de:	3b 45 08             	cmp    0x8(%ebp),%eax
 1e1:	7c 82                	jl     165 <main+0x5b>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1e3:	e8 cc 03 00 00       	call   5b4 <exit>

000001e8 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	0f b6 00             	movzbl (%eax),%eax
 1f4:	3c 5e                	cmp    $0x5e,%al
 1f6:	75 17                	jne    20f <match+0x27>
    return matchhere(re+1, text);
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 201:	89 44 24 04          	mov    %eax,0x4(%esp)
 205:	89 14 24             	mov    %edx,(%esp)
 208:	e8 39 00 00 00       	call   246 <matchhere>
 20d:	eb 35                	jmp    244 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 20f:	8b 45 0c             	mov    0xc(%ebp),%eax
 212:	89 44 24 04          	mov    %eax,0x4(%esp)
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	89 04 24             	mov    %eax,(%esp)
 21c:	e8 25 00 00 00       	call   246 <matchhere>
 221:	85 c0                	test   %eax,%eax
 223:	74 07                	je     22c <match+0x44>
      return 1;
 225:	b8 01 00 00 00       	mov    $0x1,%eax
 22a:	eb 18                	jmp    244 <match+0x5c>
  }while(*text++ != '\0');
 22c:	8b 45 0c             	mov    0xc(%ebp),%eax
 22f:	0f b6 00             	movzbl (%eax),%eax
 232:	84 c0                	test   %al,%al
 234:	0f 95 c0             	setne  %al
 237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 23b:	84 c0                	test   %al,%al
 23d:	75 d0                	jne    20f <match+0x27>
  return 0;
 23f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	84 c0                	test   %al,%al
 254:	75 0a                	jne    260 <matchhere+0x1a>
    return 1;
 256:	b8 01 00 00 00       	mov    $0x1,%eax
 25b:	e9 9b 00 00 00       	jmp    2fb <matchhere+0xb5>
  if(re[1] == '*')
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	83 c0 01             	add    $0x1,%eax
 266:	0f b6 00             	movzbl (%eax),%eax
 269:	3c 2a                	cmp    $0x2a,%al
 26b:	75 24                	jne    291 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	8d 48 02             	lea    0x2(%eax),%ecx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	0f be c0             	movsbl %al,%eax
 27c:	8b 55 0c             	mov    0xc(%ebp),%edx
 27f:	89 54 24 08          	mov    %edx,0x8(%esp)
 283:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 287:	89 04 24             	mov    %eax,(%esp)
 28a:	e8 6e 00 00 00       	call   2fd <matchstar>
 28f:	eb 6a                	jmp    2fb <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 24                	cmp    $0x24,%al
 299:	75 1d                	jne    2b8 <matchhere+0x72>
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	83 c0 01             	add    $0x1,%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	84 c0                	test   %al,%al
 2a6:	75 10                	jne    2b8 <matchhere+0x72>
    return *text == '\0';
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	84 c0                	test   %al,%al
 2b0:	0f 94 c0             	sete   %al
 2b3:	0f b6 c0             	movzbl %al,%eax
 2b6:	eb 43                	jmp    2fb <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	84 c0                	test   %al,%al
 2c0:	74 34                	je     2f6 <matchhere+0xb0>
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	3c 2e                	cmp    $0x2e,%al
 2ca:	74 10                	je     2dc <matchhere+0x96>
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 10             	movzbl (%eax),%edx
 2d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d5:	0f b6 00             	movzbl (%eax),%eax
 2d8:	38 c2                	cmp    %al,%dl
 2da:	75 1a                	jne    2f6 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	8d 50 01             	lea    0x1(%eax),%edx
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	83 c0 01             	add    $0x1,%eax
 2e8:	89 54 24 04          	mov    %edx,0x4(%esp)
 2ec:	89 04 24             	mov    %eax,(%esp)
 2ef:	e8 52 ff ff ff       	call   246 <matchhere>
 2f4:	eb 05                	jmp    2fb <matchhere+0xb5>
  return 0;
 2f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2fb:	c9                   	leave  
 2fc:	c3                   	ret    

000002fd <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2fd:	55                   	push   %ebp
 2fe:	89 e5                	mov    %esp,%ebp
 300:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 303:	8b 45 10             	mov    0x10(%ebp),%eax
 306:	89 44 24 04          	mov    %eax,0x4(%esp)
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 04 24             	mov    %eax,(%esp)
 310:	e8 31 ff ff ff       	call   246 <matchhere>
 315:	85 c0                	test   %eax,%eax
 317:	74 07                	je     320 <matchstar+0x23>
      return 1;
 319:	b8 01 00 00 00       	mov    $0x1,%eax
 31e:	eb 2c                	jmp    34c <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 320:	8b 45 10             	mov    0x10(%ebp),%eax
 323:	0f b6 00             	movzbl (%eax),%eax
 326:	84 c0                	test   %al,%al
 328:	74 1d                	je     347 <matchstar+0x4a>
 32a:	8b 45 10             	mov    0x10(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	0f be c0             	movsbl %al,%eax
 333:	3b 45 08             	cmp    0x8(%ebp),%eax
 336:	0f 94 c0             	sete   %al
 339:	83 45 10 01          	addl   $0x1,0x10(%ebp)
 33d:	84 c0                	test   %al,%al
 33f:	75 c2                	jne    303 <matchstar+0x6>
 341:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 345:	74 bc                	je     303 <matchstar+0x6>
  return 0;
 347:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    
 34e:	90                   	nop
 34f:	90                   	nop

00000350 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 355:	8b 4d 08             	mov    0x8(%ebp),%ecx
 358:	8b 55 10             	mov    0x10(%ebp),%edx
 35b:	8b 45 0c             	mov    0xc(%ebp),%eax
 35e:	89 cb                	mov    %ecx,%ebx
 360:	89 df                	mov    %ebx,%edi
 362:	89 d1                	mov    %edx,%ecx
 364:	fc                   	cld    
 365:	f3 aa                	rep stos %al,%es:(%edi)
 367:	89 ca                	mov    %ecx,%edx
 369:	89 fb                	mov    %edi,%ebx
 36b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 36e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 371:	5b                   	pop    %ebx
 372:	5f                   	pop    %edi
 373:	5d                   	pop    %ebp
 374:	c3                   	ret    

00000375 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 381:	90                   	nop
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	0f b6 10             	movzbl (%eax),%edx
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	88 10                	mov    %dl,(%eax)
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	84 c0                	test   %al,%al
 395:	0f 95 c0             	setne  %al
 398:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 39c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3a0:	84 c0                	test   %al,%al
 3a2:	75 de                	jne    382 <strcpy+0xd>
    ;
  return os;
 3a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3ac:	eb 08                	jmp    3b6 <strcmp+0xd>
    p++, q++;
 3ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	84 c0                	test   %al,%al
 3be:	74 10                	je     3d0 <strcmp+0x27>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 10             	movzbl (%eax),%edx
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	0f b6 00             	movzbl (%eax),%eax
 3cc:	38 c2                	cmp    %al,%dl
 3ce:	74 de                	je     3ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	0f b6 d0             	movzbl %al,%edx
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	0f b6 c0             	movzbl %al,%eax
 3e2:	89 d1                	mov    %edx,%ecx
 3e4:	29 c1                	sub    %eax,%ecx
 3e6:	89 c8                	mov    %ecx,%eax
}
 3e8:	5d                   	pop    %ebp
 3e9:	c3                   	ret    

000003ea <strlen>:

uint
strlen(char *s)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f7:	eb 04                	jmp    3fd <strlen+0x13>
 3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 400:	03 45 08             	add    0x8(%ebp),%eax
 403:	0f b6 00             	movzbl (%eax),%eax
 406:	84 c0                	test   %al,%al
 408:	75 ef                	jne    3f9 <strlen+0xf>
    ;
  return n;
 40a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40d:	c9                   	leave  
 40e:	c3                   	ret    

0000040f <memset>:

void*
memset(void *dst, int c, uint n)
{
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
 412:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 415:	8b 45 10             	mov    0x10(%ebp),%eax
 418:	89 44 24 08          	mov    %eax,0x8(%esp)
 41c:	8b 45 0c             	mov    0xc(%ebp),%eax
 41f:	89 44 24 04          	mov    %eax,0x4(%esp)
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	89 04 24             	mov    %eax,(%esp)
 429:	e8 22 ff ff ff       	call   350 <stosb>
  return dst;
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <strchr>:

char*
strchr(const char *s, char c)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	83 ec 04             	sub    $0x4,%esp
 439:	8b 45 0c             	mov    0xc(%ebp),%eax
 43c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 43f:	eb 14                	jmp    455 <strchr+0x22>
    if(*s == c)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	0f b6 00             	movzbl (%eax),%eax
 447:	3a 45 fc             	cmp    -0x4(%ebp),%al
 44a:	75 05                	jne    451 <strchr+0x1e>
      return (char*)s;
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	eb 13                	jmp    464 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 451:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	0f b6 00             	movzbl (%eax),%eax
 45b:	84 c0                	test   %al,%al
 45d:	75 e2                	jne    441 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 45f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 464:	c9                   	leave  
 465:	c3                   	ret    

00000466 <gets>:

char*
gets(char *buf, int max)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 473:	eb 44                	jmp    4b9 <gets+0x53>
    cc = read(0, &c, 1);
 475:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47c:	00 
 47d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 480:	89 44 24 04          	mov    %eax,0x4(%esp)
 484:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 48b:	e8 4c 01 00 00       	call   5dc <read>
 490:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 493:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 497:	7e 2d                	jle    4c6 <gets+0x60>
      break;
    buf[i++] = c;
 499:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49c:	03 45 08             	add    0x8(%ebp),%eax
 49f:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 4a3:	88 10                	mov    %dl,(%eax)
 4a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 4a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ad:	3c 0a                	cmp    $0xa,%al
 4af:	74 16                	je     4c7 <gets+0x61>
 4b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b5:	3c 0d                	cmp    $0xd,%al
 4b7:	74 0e                	je     4c7 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	83 c0 01             	add    $0x1,%eax
 4bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4c2:	7c b1                	jl     475 <gets+0xf>
 4c4:	eb 01                	jmp    4c7 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4c6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ca:	03 45 08             	add    0x8(%ebp),%eax
 4cd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d3:	c9                   	leave  
 4d4:	c3                   	ret    

000004d5 <stat>:

int
stat(char *n, struct stat *st)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4e2:	00 
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	89 04 24             	mov    %eax,(%esp)
 4e9:	e8 16 01 00 00       	call   604 <open>
 4ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f5:	79 07                	jns    4fe <stat+0x29>
    return -1;
 4f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4fc:	eb 23                	jmp    521 <stat+0x4c>
  r = fstat(fd, st);
 4fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 501:	89 44 24 04          	mov    %eax,0x4(%esp)
 505:	8b 45 f4             	mov    -0xc(%ebp),%eax
 508:	89 04 24             	mov    %eax,(%esp)
 50b:	e8 0c 01 00 00       	call   61c <fstat>
 510:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 513:	8b 45 f4             	mov    -0xc(%ebp),%eax
 516:	89 04 24             	mov    %eax,(%esp)
 519:	e8 ce 00 00 00       	call   5ec <close>
  return r;
 51e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 521:	c9                   	leave  
 522:	c3                   	ret    

00000523 <atoi>:

int
atoi(const char *s)
{
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 529:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 530:	eb 23                	jmp    555 <atoi+0x32>
    n = n*10 + *s++ - '0';
 532:	8b 55 fc             	mov    -0x4(%ebp),%edx
 535:	89 d0                	mov    %edx,%eax
 537:	c1 e0 02             	shl    $0x2,%eax
 53a:	01 d0                	add    %edx,%eax
 53c:	01 c0                	add    %eax,%eax
 53e:	89 c2                	mov    %eax,%edx
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	0f b6 00             	movzbl (%eax),%eax
 546:	0f be c0             	movsbl %al,%eax
 549:	01 d0                	add    %edx,%eax
 54b:	83 e8 30             	sub    $0x30,%eax
 54e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 551:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	0f b6 00             	movzbl (%eax),%eax
 55b:	3c 2f                	cmp    $0x2f,%al
 55d:	7e 0a                	jle    569 <atoi+0x46>
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	3c 39                	cmp    $0x39,%al
 567:	7e c9                	jle    532 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 569:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 56c:	c9                   	leave  
 56d:	c3                   	ret    

0000056e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 56e:	55                   	push   %ebp
 56f:	89 e5                	mov    %esp,%ebp
 571:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 57a:	8b 45 0c             	mov    0xc(%ebp),%eax
 57d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 580:	eb 13                	jmp    595 <memmove+0x27>
    *dst++ = *src++;
 582:	8b 45 f8             	mov    -0x8(%ebp),%eax
 585:	0f b6 10             	movzbl (%eax),%edx
 588:	8b 45 fc             	mov    -0x4(%ebp),%eax
 58b:	88 10                	mov    %dl,(%eax)
 58d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 591:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 595:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 599:	0f 9f c0             	setg   %al
 59c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5a0:	84 c0                	test   %al,%al
 5a2:	75 de                	jne    582 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5a7:	c9                   	leave  
 5a8:	c3                   	ret    
 5a9:	90                   	nop
 5aa:	90                   	nop
 5ab:	90                   	nop

000005ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ac:	b8 01 00 00 00       	mov    $0x1,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <exit>:
SYSCALL(exit)
 5b4:	b8 02 00 00 00       	mov    $0x2,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <wait>:
SYSCALL(wait)
 5bc:	b8 03 00 00 00       	mov    $0x3,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <wait2>:
SYSCALL(wait2)
 5c4:	b8 16 00 00 00       	mov    $0x16,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <add_path>:
SYSCALL(add_path)
 5cc:	b8 17 00 00 00       	mov    $0x17,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <pipe>:
SYSCALL(pipe)
 5d4:	b8 04 00 00 00       	mov    $0x4,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <read>:
SYSCALL(read)
 5dc:	b8 05 00 00 00       	mov    $0x5,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <write>:
SYSCALL(write)
 5e4:	b8 10 00 00 00       	mov    $0x10,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <close>:
SYSCALL(close)
 5ec:	b8 15 00 00 00       	mov    $0x15,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <kill>:
SYSCALL(kill)
 5f4:	b8 06 00 00 00       	mov    $0x6,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <exec>:
SYSCALL(exec)
 5fc:	b8 07 00 00 00       	mov    $0x7,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <open>:
SYSCALL(open)
 604:	b8 0f 00 00 00       	mov    $0xf,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <mknod>:
SYSCALL(mknod)
 60c:	b8 11 00 00 00       	mov    $0x11,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <unlink>:
SYSCALL(unlink)
 614:	b8 12 00 00 00       	mov    $0x12,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <fstat>:
SYSCALL(fstat)
 61c:	b8 08 00 00 00       	mov    $0x8,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <link>:
SYSCALL(link)
 624:	b8 13 00 00 00       	mov    $0x13,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <mkdir>:
SYSCALL(mkdir)
 62c:	b8 14 00 00 00       	mov    $0x14,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <chdir>:
SYSCALL(chdir)
 634:	b8 09 00 00 00       	mov    $0x9,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <dup>:
SYSCALL(dup)
 63c:	b8 0a 00 00 00       	mov    $0xa,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <getpid>:
SYSCALL(getpid)
 644:	b8 0b 00 00 00       	mov    $0xb,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <sbrk>:
SYSCALL(sbrk)
 64c:	b8 0c 00 00 00       	mov    $0xc,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <sleep>:
SYSCALL(sleep)
 654:	b8 0d 00 00 00       	mov    $0xd,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <uptime>:
SYSCALL(uptime)
 65c:	b8 0e 00 00 00       	mov    $0xe,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	83 ec 28             	sub    $0x28,%esp
 66a:	8b 45 0c             	mov    0xc(%ebp),%eax
 66d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 670:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 677:	00 
 678:	8d 45 f4             	lea    -0xc(%ebp),%eax
 67b:	89 44 24 04          	mov    %eax,0x4(%esp)
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	89 04 24             	mov    %eax,(%esp)
 685:	e8 5a ff ff ff       	call   5e4 <write>
}
 68a:	c9                   	leave  
 68b:	c3                   	ret    

0000068c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 68c:	55                   	push   %ebp
 68d:	89 e5                	mov    %esp,%ebp
 68f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 692:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 699:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 69d:	74 17                	je     6b6 <printint+0x2a>
 69f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6a3:	79 11                	jns    6b6 <printint+0x2a>
    neg = 1;
 6a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 6af:	f7 d8                	neg    %eax
 6b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b4:	eb 06                	jmp    6bc <printint+0x30>
  } else {
    x = xx;
 6b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c9:	ba 00 00 00 00       	mov    $0x0,%edx
 6ce:	f7 f1                	div    %ecx
 6d0:	89 d0                	mov    %edx,%eax
 6d2:	0f b6 90 fc 0d 00 00 	movzbl 0xdfc(%eax),%edx
 6d9:	8d 45 dc             	lea    -0x24(%ebp),%eax
 6dc:	03 45 f4             	add    -0xc(%ebp),%eax
 6df:	88 10                	mov    %dl,(%eax)
 6e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 6e5:	8b 55 10             	mov    0x10(%ebp),%edx
 6e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ee:	ba 00 00 00 00       	mov    $0x0,%edx
 6f3:	f7 75 d4             	divl   -0x2c(%ebp)
 6f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6fd:	75 c4                	jne    6c3 <printint+0x37>
  if(neg)
 6ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 703:	74 2a                	je     72f <printint+0xa3>
    buf[i++] = '-';
 705:	8d 45 dc             	lea    -0x24(%ebp),%eax
 708:	03 45 f4             	add    -0xc(%ebp),%eax
 70b:	c6 00 2d             	movb   $0x2d,(%eax)
 70e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 712:	eb 1b                	jmp    72f <printint+0xa3>
    putc(fd, buf[i]);
 714:	8d 45 dc             	lea    -0x24(%ebp),%eax
 717:	03 45 f4             	add    -0xc(%ebp),%eax
 71a:	0f b6 00             	movzbl (%eax),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 35 ff ff ff       	call   664 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 72f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 737:	79 db                	jns    714 <printint+0x88>
    putc(fd, buf[i]);
}
 739:	c9                   	leave  
 73a:	c3                   	ret    

0000073b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 73b:	55                   	push   %ebp
 73c:	89 e5                	mov    %esp,%ebp
 73e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 748:	8d 45 0c             	lea    0xc(%ebp),%eax
 74b:	83 c0 04             	add    $0x4,%eax
 74e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 751:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 758:	e9 7d 01 00 00       	jmp    8da <printf+0x19f>
    c = fmt[i] & 0xff;
 75d:	8b 55 0c             	mov    0xc(%ebp),%edx
 760:	8b 45 f0             	mov    -0x10(%ebp),%eax
 763:	01 d0                	add    %edx,%eax
 765:	0f b6 00             	movzbl (%eax),%eax
 768:	0f be c0             	movsbl %al,%eax
 76b:	25 ff 00 00 00       	and    $0xff,%eax
 770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 773:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 777:	75 2c                	jne    7a5 <printf+0x6a>
      if(c == '%'){
 779:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 77d:	75 0c                	jne    78b <printf+0x50>
        state = '%';
 77f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 786:	e9 4b 01 00 00       	jmp    8d6 <printf+0x19b>
      } else {
        putc(fd, c);
 78b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78e:	0f be c0             	movsbl %al,%eax
 791:	89 44 24 04          	mov    %eax,0x4(%esp)
 795:	8b 45 08             	mov    0x8(%ebp),%eax
 798:	89 04 24             	mov    %eax,(%esp)
 79b:	e8 c4 fe ff ff       	call   664 <putc>
 7a0:	e9 31 01 00 00       	jmp    8d6 <printf+0x19b>
      }
    } else if(state == '%'){
 7a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7a9:	0f 85 27 01 00 00    	jne    8d6 <printf+0x19b>
      if(c == 'd'){
 7af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7b3:	75 2d                	jne    7e2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7c1:	00 
 7c2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7c9:	00 
 7ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	89 04 24             	mov    %eax,(%esp)
 7d4:	e8 b3 fe ff ff       	call   68c <printint>
        ap++;
 7d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7dd:	e9 ed 00 00 00       	jmp    8cf <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 7e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7e6:	74 06                	je     7ee <printf+0xb3>
 7e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ec:	75 2d                	jne    81b <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7fa:	00 
 7fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 802:	00 
 803:	89 44 24 04          	mov    %eax,0x4(%esp)
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	89 04 24             	mov    %eax,(%esp)
 80d:	e8 7a fe ff ff       	call   68c <printint>
        ap++;
 812:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 816:	e9 b4 00 00 00       	jmp    8cf <printf+0x194>
      } else if(c == 's'){
 81b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 81f:	75 46                	jne    867 <printf+0x12c>
        s = (char*)*ap;
 821:	8b 45 e8             	mov    -0x18(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 829:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 82d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 831:	75 27                	jne    85a <printf+0x11f>
          s = "(null)";
 833:	c7 45 f4 36 0b 00 00 	movl   $0xb36,-0xc(%ebp)
        while(*s != 0){
 83a:	eb 1e                	jmp    85a <printf+0x11f>
          putc(fd, *s);
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	0f b6 00             	movzbl (%eax),%eax
 842:	0f be c0             	movsbl %al,%eax
 845:	89 44 24 04          	mov    %eax,0x4(%esp)
 849:	8b 45 08             	mov    0x8(%ebp),%eax
 84c:	89 04 24             	mov    %eax,(%esp)
 84f:	e8 10 fe ff ff       	call   664 <putc>
          s++;
 854:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 858:	eb 01                	jmp    85b <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 85a:	90                   	nop
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	0f b6 00             	movzbl (%eax),%eax
 861:	84 c0                	test   %al,%al
 863:	75 d7                	jne    83c <printf+0x101>
 865:	eb 68                	jmp    8cf <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 867:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 86b:	75 1d                	jne    88a <printf+0x14f>
        putc(fd, *ap);
 86d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	0f be c0             	movsbl %al,%eax
 875:	89 44 24 04          	mov    %eax,0x4(%esp)
 879:	8b 45 08             	mov    0x8(%ebp),%eax
 87c:	89 04 24             	mov    %eax,(%esp)
 87f:	e8 e0 fd ff ff       	call   664 <putc>
        ap++;
 884:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 888:	eb 45                	jmp    8cf <printf+0x194>
      } else if(c == '%'){
 88a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 88e:	75 17                	jne    8a7 <printf+0x16c>
        putc(fd, c);
 890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 893:	0f be c0             	movsbl %al,%eax
 896:	89 44 24 04          	mov    %eax,0x4(%esp)
 89a:	8b 45 08             	mov    0x8(%ebp),%eax
 89d:	89 04 24             	mov    %eax,(%esp)
 8a0:	e8 bf fd ff ff       	call   664 <putc>
 8a5:	eb 28                	jmp    8cf <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8a7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8ae:	00 
 8af:	8b 45 08             	mov    0x8(%ebp),%eax
 8b2:	89 04 24             	mov    %eax,(%esp)
 8b5:	e8 aa fd ff ff       	call   664 <putc>
        putc(fd, c);
 8ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8bd:	0f be c0             	movsbl %al,%eax
 8c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c4:	8b 45 08             	mov    0x8(%ebp),%eax
 8c7:	89 04 24             	mov    %eax,(%esp)
 8ca:	e8 95 fd ff ff       	call   664 <putc>
      }
      state = 0;
 8cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8d6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8da:	8b 55 0c             	mov    0xc(%ebp),%edx
 8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e0:	01 d0                	add    %edx,%eax
 8e2:	0f b6 00             	movzbl (%eax),%eax
 8e5:	84 c0                	test   %al,%al
 8e7:	0f 85 70 fe ff ff    	jne    75d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8ed:	c9                   	leave  
 8ee:	c3                   	ret    
 8ef:	90                   	nop

000008f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f6:	8b 45 08             	mov    0x8(%ebp),%eax
 8f9:	83 e8 08             	sub    $0x8,%eax
 8fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ff:	a1 28 0e 00 00       	mov    0xe28,%eax
 904:	89 45 fc             	mov    %eax,-0x4(%ebp)
 907:	eb 24                	jmp    92d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8b 00                	mov    (%eax),%eax
 90e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 911:	77 12                	ja     925 <free+0x35>
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 919:	77 24                	ja     93f <free+0x4f>
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 923:	77 1a                	ja     93f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 92d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 930:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 933:	76 d4                	jbe    909 <free+0x19>
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93d:	76 ca                	jbe    909 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	c1 e0 03             	shl    $0x3,%eax
 948:	89 c2                	mov    %eax,%edx
 94a:	03 55 f8             	add    -0x8(%ebp),%edx
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 00                	mov    (%eax),%eax
 952:	39 c2                	cmp    %eax,%edx
 954:	75 24                	jne    97a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 956:	8b 45 f8             	mov    -0x8(%ebp),%eax
 959:	8b 50 04             	mov    0x4(%eax),%edx
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 00                	mov    (%eax),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	01 c2                	add    %eax,%edx
 966:	8b 45 f8             	mov    -0x8(%ebp),%eax
 969:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 96c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96f:	8b 00                	mov    (%eax),%eax
 971:	8b 10                	mov    (%eax),%edx
 973:	8b 45 f8             	mov    -0x8(%ebp),%eax
 976:	89 10                	mov    %edx,(%eax)
 978:	eb 0a                	jmp    984 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	8b 10                	mov    (%eax),%edx
 97f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 982:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	c1 e0 03             	shl    $0x3,%eax
 98d:	03 45 fc             	add    -0x4(%ebp),%eax
 990:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 993:	75 20                	jne    9b5 <free+0xc5>
    p->s.size += bp->s.size;
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	8b 50 04             	mov    0x4(%eax),%edx
 99b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99e:	8b 40 04             	mov    0x4(%eax),%eax
 9a1:	01 c2                	add    %eax,%edx
 9a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ac:	8b 10                	mov    (%eax),%edx
 9ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b1:	89 10                	mov    %edx,(%eax)
 9b3:	eb 08                	jmp    9bd <free+0xcd>
  } else
    p->s.ptr = bp;
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9bb:	89 10                	mov    %edx,(%eax)
  freep = p;
 9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c0:	a3 28 0e 00 00       	mov    %eax,0xe28
}
 9c5:	c9                   	leave  
 9c6:	c3                   	ret    

000009c7 <morecore>:

static Header*
morecore(uint nu)
{
 9c7:	55                   	push   %ebp
 9c8:	89 e5                	mov    %esp,%ebp
 9ca:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9cd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9d4:	77 07                	ja     9dd <morecore+0x16>
    nu = 4096;
 9d6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9dd:	8b 45 08             	mov    0x8(%ebp),%eax
 9e0:	c1 e0 03             	shl    $0x3,%eax
 9e3:	89 04 24             	mov    %eax,(%esp)
 9e6:	e8 61 fc ff ff       	call   64c <sbrk>
 9eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9ee:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9f2:	75 07                	jne    9fb <morecore+0x34>
    return 0;
 9f4:	b8 00 00 00 00       	mov    $0x0,%eax
 9f9:	eb 22                	jmp    a1d <morecore+0x56>
  hp = (Header*)p;
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a04:	8b 55 08             	mov    0x8(%ebp),%edx
 a07:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0d:	83 c0 08             	add    $0x8,%eax
 a10:	89 04 24             	mov    %eax,(%esp)
 a13:	e8 d8 fe ff ff       	call   8f0 <free>
  return freep;
 a18:	a1 28 0e 00 00       	mov    0xe28,%eax
}
 a1d:	c9                   	leave  
 a1e:	c3                   	ret    

00000a1f <malloc>:

void*
malloc(uint nbytes)
{
 a1f:	55                   	push   %ebp
 a20:	89 e5                	mov    %esp,%ebp
 a22:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a25:	8b 45 08             	mov    0x8(%ebp),%eax
 a28:	83 c0 07             	add    $0x7,%eax
 a2b:	c1 e8 03             	shr    $0x3,%eax
 a2e:	83 c0 01             	add    $0x1,%eax
 a31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a34:	a1 28 0e 00 00       	mov    0xe28,%eax
 a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a40:	75 23                	jne    a65 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a42:	c7 45 f0 20 0e 00 00 	movl   $0xe20,-0x10(%ebp)
 a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4c:	a3 28 0e 00 00       	mov    %eax,0xe28
 a51:	a1 28 0e 00 00       	mov    0xe28,%eax
 a56:	a3 20 0e 00 00       	mov    %eax,0xe20
    base.s.size = 0;
 a5b:	c7 05 24 0e 00 00 00 	movl   $0x0,0xe24
 a62:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a68:	8b 00                	mov    (%eax),%eax
 a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a70:	8b 40 04             	mov    0x4(%eax),%eax
 a73:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a76:	72 4d                	jb     ac5 <malloc+0xa6>
      if(p->s.size == nunits)
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	8b 40 04             	mov    0x4(%eax),%eax
 a7e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a81:	75 0c                	jne    a8f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a86:	8b 10                	mov    (%eax),%edx
 a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8b:	89 10                	mov    %edx,(%eax)
 a8d:	eb 26                	jmp    ab5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 40 04             	mov    0x4(%eax),%eax
 a95:	89 c2                	mov    %eax,%edx
 a97:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	8b 40 04             	mov    0x4(%eax),%eax
 aa6:	c1 e0 03             	shl    $0x3,%eax
 aa9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ab2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab8:	a3 28 0e 00 00       	mov    %eax,0xe28
      return (void*)(p + 1);
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	83 c0 08             	add    $0x8,%eax
 ac3:	eb 38                	jmp    afd <malloc+0xde>
    }
    if(p == freep)
 ac5:	a1 28 0e 00 00       	mov    0xe28,%eax
 aca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 acd:	75 1b                	jne    aea <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ad2:	89 04 24             	mov    %eax,(%esp)
 ad5:	e8 ed fe ff ff       	call   9c7 <morecore>
 ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
 add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ae1:	75 07                	jne    aea <malloc+0xcb>
        return 0;
 ae3:	b8 00 00 00 00       	mov    $0x0,%eax
 ae8:	eb 13                	jmp    afd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af3:	8b 00                	mov    (%eax),%eax
 af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 af8:	e9 70 ff ff ff       	jmp    a6d <malloc+0x4e>
}
 afd:	c9                   	leave  
 afe:	c3                   	ret    
