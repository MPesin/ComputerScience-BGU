
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
       d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
      12:	8b 45 ec             	mov    -0x14(%ebp),%eax
      15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
      18:	c7 45 f0 c0 16 00 00 	movl   $0x16c0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
      1f:	eb 51                	jmp    72 <grep+0x72>
      *q = 0;
      21:	8b 45 e8             	mov    -0x18(%ebp),%eax
      24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
      27:	8b 45 f0             	mov    -0x10(%ebp),%eax
      2a:	89 44 24 04          	mov    %eax,0x4(%esp)
      2e:	8b 45 08             	mov    0x8(%ebp),%eax
      31:	89 04 24             	mov    %eax,(%esp)
      34:	e8 bc 01 00 00       	call   1f5 <match>
      39:	85 c0                	test   %eax,%eax
      3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
      3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
      43:	8b 45 e8             	mov    -0x18(%ebp),%eax
      46:	83 c0 01             	add    $0x1,%eax
      49:	89 c2                	mov    %eax,%edx
      4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      4e:	29 c2                	sub    %eax,%edx
      50:	89 d0                	mov    %edx,%eax
      52:	89 44 24 08          	mov    %eax,0x8(%esp)
      56:	8b 45 f0             	mov    -0x10(%ebp),%eax
      59:	89 44 24 04          	mov    %eax,0x4(%esp)
      5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      64:	e8 8c 05 00 00       	call   5f5 <write>
      }
      p = q+1;
      69:	8b 45 e8             	mov    -0x18(%ebp),%eax
      6c:	83 c0 01             	add    $0x1,%eax
      6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
      79:	00 
      7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      7d:	89 04 24             	mov    %eax,(%esp)
      80:	e8 af 03 00 00       	call   434 <strchr>
      85:	89 45 e8             	mov    %eax,-0x18(%ebp)
      88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      8c:	75 93                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
      8e:	81 7d f0 c0 16 00 00 	cmpl   $0x16c0,-0x10(%ebp)
      95:	75 07                	jne    9e <grep+0x9e>
      m = 0;
      97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
      9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      a2:	7e 29                	jle    cd <grep+0xcd>
      m -= p - buf;
      a4:	ba c0 16 00 00       	mov    $0x16c0,%edx
      a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
      ac:	29 c2                	sub    %eax,%edx
      ae:	89 d0                	mov    %edx,%eax
      b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
      b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
      bd:	89 44 24 04          	mov    %eax,0x4(%esp)
      c1:	c7 04 24 c0 16 00 00 	movl   $0x16c0,(%esp)
      c8:	e8 ab 04 00 00       	call   578 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
      cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d0:	ba 00 04 00 00       	mov    $0x400,%edx
      d5:	29 c2                	sub    %eax,%edx
      d7:	89 d0                	mov    %edx,%eax
      d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
      dc:	81 c2 c0 16 00 00    	add    $0x16c0,%edx
      e2:	89 44 24 08          	mov    %eax,0x8(%esp)
      e6:	89 54 24 04          	mov    %edx,0x4(%esp)
      ea:	8b 45 0c             	mov    0xc(%ebp),%eax
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 f8 04 00 00       	call   5ed <read>
      f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      fc:	0f 8f 10 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
     102:	c9                   	leave  
     103:	c3                   	ret    

00000104 <main>:

int
main(int argc, char *argv[])
{
     104:	55                   	push   %ebp
     105:	89 e5                	mov    %esp,%ebp
     107:	83 e4 f0             	and    $0xfffffff0,%esp
     10a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
     10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     111:	7f 19                	jg     12c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
     113:	c7 44 24 04 48 11 00 	movl   $0x1148,0x4(%esp)
     11a:	00 
     11b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     122:	e8 2e 06 00 00       	call   755 <printf>
    exit();
     127:	e8 91 04 00 00       	call   5bd <exit>
  }
  pattern = argv[1];
     12c:	8b 45 0c             	mov    0xc(%ebp),%eax
     12f:	8b 40 04             	mov    0x4(%eax),%eax
     132:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
     136:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
     13a:	7f 19                	jg     155 <main+0x51>
    grep(pattern, 0);
     13c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     143:	00 
     144:	8b 44 24 18          	mov    0x18(%esp),%eax
     148:	89 04 24             	mov    %eax,(%esp)
     14b:	e8 b0 fe ff ff       	call   0 <grep>
    exit();
     150:	e8 68 04 00 00       	call   5bd <exit>
  }

  for(i = 2; i < argc; i++){
     155:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
     15c:	00 
     15d:	e9 81 00 00 00       	jmp    1e3 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
     162:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     16d:	8b 45 0c             	mov    0xc(%ebp),%eax
     170:	01 d0                	add    %edx,%eax
     172:	8b 00                	mov    (%eax),%eax
     174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     17b:	00 
     17c:	89 04 24             	mov    %eax,(%esp)
     17f:	e8 91 04 00 00       	call   615 <open>
     184:	89 44 24 14          	mov    %eax,0x14(%esp)
     188:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
     18d:	79 2f                	jns    1be <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
     18f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     19a:	8b 45 0c             	mov    0xc(%ebp),%eax
     19d:	01 d0                	add    %edx,%eax
     19f:	8b 00                	mov    (%eax),%eax
     1a1:	89 44 24 08          	mov    %eax,0x8(%esp)
     1a5:	c7 44 24 04 68 11 00 	movl   $0x1168,0x4(%esp)
     1ac:	00 
     1ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1b4:	e8 9c 05 00 00       	call   755 <printf>
      exit();
     1b9:	e8 ff 03 00 00       	call   5bd <exit>
    }
    grep(pattern, fd);
     1be:	8b 44 24 14          	mov    0x14(%esp),%eax
     1c2:	89 44 24 04          	mov    %eax,0x4(%esp)
     1c6:	8b 44 24 18          	mov    0x18(%esp),%eax
     1ca:	89 04 24             	mov    %eax,(%esp)
     1cd:	e8 2e fe ff ff       	call   0 <grep>
    close(fd);
     1d2:	8b 44 24 14          	mov    0x14(%esp),%eax
     1d6:	89 04 24             	mov    %eax,(%esp)
     1d9:	e8 1f 04 00 00       	call   5fd <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
     1de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     1e3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     1e7:	3b 45 08             	cmp    0x8(%ebp),%eax
     1ea:	0f 8c 72 ff ff ff    	jl     162 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
     1f0:	e8 c8 03 00 00       	call   5bd <exit>

000001f5 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
     1f5:	55                   	push   %ebp
     1f6:	89 e5                	mov    %esp,%ebp
     1f8:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
     1fb:	8b 45 08             	mov    0x8(%ebp),%eax
     1fe:	0f b6 00             	movzbl (%eax),%eax
     201:	3c 5e                	cmp    $0x5e,%al
     203:	75 17                	jne    21c <match+0x27>
    return matchhere(re+1, text);
     205:	8b 45 08             	mov    0x8(%ebp),%eax
     208:	8d 50 01             	lea    0x1(%eax),%edx
     20b:	8b 45 0c             	mov    0xc(%ebp),%eax
     20e:	89 44 24 04          	mov    %eax,0x4(%esp)
     212:	89 14 24             	mov    %edx,(%esp)
     215:	e8 36 00 00 00       	call   250 <matchhere>
     21a:	eb 32                	jmp    24e <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
     21c:	8b 45 0c             	mov    0xc(%ebp),%eax
     21f:	89 44 24 04          	mov    %eax,0x4(%esp)
     223:	8b 45 08             	mov    0x8(%ebp),%eax
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 22 00 00 00       	call   250 <matchhere>
     22e:	85 c0                	test   %eax,%eax
     230:	74 07                	je     239 <match+0x44>
      return 1;
     232:	b8 01 00 00 00       	mov    $0x1,%eax
     237:	eb 15                	jmp    24e <match+0x59>
  }while(*text++ != '\0');
     239:	8b 45 0c             	mov    0xc(%ebp),%eax
     23c:	8d 50 01             	lea    0x1(%eax),%edx
     23f:	89 55 0c             	mov    %edx,0xc(%ebp)
     242:	0f b6 00             	movzbl (%eax),%eax
     245:	84 c0                	test   %al,%al
     247:	75 d3                	jne    21c <match+0x27>
  return 0;
     249:	b8 00 00 00 00       	mov    $0x0,%eax
}
     24e:	c9                   	leave  
     24f:	c3                   	ret    

00000250 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
     250:	55                   	push   %ebp
     251:	89 e5                	mov    %esp,%ebp
     253:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
     256:	8b 45 08             	mov    0x8(%ebp),%eax
     259:	0f b6 00             	movzbl (%eax),%eax
     25c:	84 c0                	test   %al,%al
     25e:	75 0a                	jne    26a <matchhere+0x1a>
    return 1;
     260:	b8 01 00 00 00       	mov    $0x1,%eax
     265:	e9 9b 00 00 00       	jmp    305 <matchhere+0xb5>
  if(re[1] == '*')
     26a:	8b 45 08             	mov    0x8(%ebp),%eax
     26d:	83 c0 01             	add    $0x1,%eax
     270:	0f b6 00             	movzbl (%eax),%eax
     273:	3c 2a                	cmp    $0x2a,%al
     275:	75 24                	jne    29b <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
     277:	8b 45 08             	mov    0x8(%ebp),%eax
     27a:	8d 48 02             	lea    0x2(%eax),%ecx
     27d:	8b 45 08             	mov    0x8(%ebp),%eax
     280:	0f b6 00             	movzbl (%eax),%eax
     283:	0f be c0             	movsbl %al,%eax
     286:	8b 55 0c             	mov    0xc(%ebp),%edx
     289:	89 54 24 08          	mov    %edx,0x8(%esp)
     28d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
     291:	89 04 24             	mov    %eax,(%esp)
     294:	e8 6e 00 00 00       	call   307 <matchstar>
     299:	eb 6a                	jmp    305 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
     29b:	8b 45 08             	mov    0x8(%ebp),%eax
     29e:	0f b6 00             	movzbl (%eax),%eax
     2a1:	3c 24                	cmp    $0x24,%al
     2a3:	75 1d                	jne    2c2 <matchhere+0x72>
     2a5:	8b 45 08             	mov    0x8(%ebp),%eax
     2a8:	83 c0 01             	add    $0x1,%eax
     2ab:	0f b6 00             	movzbl (%eax),%eax
     2ae:	84 c0                	test   %al,%al
     2b0:	75 10                	jne    2c2 <matchhere+0x72>
    return *text == '\0';
     2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
     2b5:	0f b6 00             	movzbl (%eax),%eax
     2b8:	84 c0                	test   %al,%al
     2ba:	0f 94 c0             	sete   %al
     2bd:	0f b6 c0             	movzbl %al,%eax
     2c0:	eb 43                	jmp    305 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
     2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c5:	0f b6 00             	movzbl (%eax),%eax
     2c8:	84 c0                	test   %al,%al
     2ca:	74 34                	je     300 <matchhere+0xb0>
     2cc:	8b 45 08             	mov    0x8(%ebp),%eax
     2cf:	0f b6 00             	movzbl (%eax),%eax
     2d2:	3c 2e                	cmp    $0x2e,%al
     2d4:	74 10                	je     2e6 <matchhere+0x96>
     2d6:	8b 45 08             	mov    0x8(%ebp),%eax
     2d9:	0f b6 10             	movzbl (%eax),%edx
     2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
     2df:	0f b6 00             	movzbl (%eax),%eax
     2e2:	38 c2                	cmp    %al,%dl
     2e4:	75 1a                	jne    300 <matchhere+0xb0>
    return matchhere(re+1, text+1);
     2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     2e9:	8d 50 01             	lea    0x1(%eax),%edx
     2ec:	8b 45 08             	mov    0x8(%ebp),%eax
     2ef:	83 c0 01             	add    $0x1,%eax
     2f2:	89 54 24 04          	mov    %edx,0x4(%esp)
     2f6:	89 04 24             	mov    %eax,(%esp)
     2f9:	e8 52 ff ff ff       	call   250 <matchhere>
     2fe:	eb 05                	jmp    305 <matchhere+0xb5>
  return 0;
     300:	b8 00 00 00 00       	mov    $0x0,%eax
}
     305:	c9                   	leave  
     306:	c3                   	ret    

00000307 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
     307:	55                   	push   %ebp
     308:	89 e5                	mov    %esp,%ebp
     30a:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
     30d:	8b 45 10             	mov    0x10(%ebp),%eax
     310:	89 44 24 04          	mov    %eax,0x4(%esp)
     314:	8b 45 0c             	mov    0xc(%ebp),%eax
     317:	89 04 24             	mov    %eax,(%esp)
     31a:	e8 31 ff ff ff       	call   250 <matchhere>
     31f:	85 c0                	test   %eax,%eax
     321:	74 07                	je     32a <matchstar+0x23>
      return 1;
     323:	b8 01 00 00 00       	mov    $0x1,%eax
     328:	eb 29                	jmp    353 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
     32a:	8b 45 10             	mov    0x10(%ebp),%eax
     32d:	0f b6 00             	movzbl (%eax),%eax
     330:	84 c0                	test   %al,%al
     332:	74 1a                	je     34e <matchstar+0x47>
     334:	8b 45 10             	mov    0x10(%ebp),%eax
     337:	8d 50 01             	lea    0x1(%eax),%edx
     33a:	89 55 10             	mov    %edx,0x10(%ebp)
     33d:	0f b6 00             	movzbl (%eax),%eax
     340:	0f be c0             	movsbl %al,%eax
     343:	3b 45 08             	cmp    0x8(%ebp),%eax
     346:	74 c5                	je     30d <matchstar+0x6>
     348:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
     34c:	74 bf                	je     30d <matchstar+0x6>
  return 0;
     34e:	b8 00 00 00 00       	mov    $0x0,%eax
}
     353:	c9                   	leave  
     354:	c3                   	ret    

00000355 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     355:	55                   	push   %ebp
     356:	89 e5                	mov    %esp,%ebp
     358:	57                   	push   %edi
     359:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     35a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     35d:	8b 55 10             	mov    0x10(%ebp),%edx
     360:	8b 45 0c             	mov    0xc(%ebp),%eax
     363:	89 cb                	mov    %ecx,%ebx
     365:	89 df                	mov    %ebx,%edi
     367:	89 d1                	mov    %edx,%ecx
     369:	fc                   	cld    
     36a:	f3 aa                	rep stos %al,%es:(%edi)
     36c:	89 ca                	mov    %ecx,%edx
     36e:	89 fb                	mov    %edi,%ebx
     370:	89 5d 08             	mov    %ebx,0x8(%ebp)
     373:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     376:	5b                   	pop    %ebx
     377:	5f                   	pop    %edi
     378:	5d                   	pop    %ebp
     379:	c3                   	ret    

0000037a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     37a:	55                   	push   %ebp
     37b:	89 e5                	mov    %esp,%ebp
     37d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     380:	8b 45 08             	mov    0x8(%ebp),%eax
     383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     386:	90                   	nop
     387:	8b 45 08             	mov    0x8(%ebp),%eax
     38a:	8d 50 01             	lea    0x1(%eax),%edx
     38d:	89 55 08             	mov    %edx,0x8(%ebp)
     390:	8b 55 0c             	mov    0xc(%ebp),%edx
     393:	8d 4a 01             	lea    0x1(%edx),%ecx
     396:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     399:	0f b6 12             	movzbl (%edx),%edx
     39c:	88 10                	mov    %dl,(%eax)
     39e:	0f b6 00             	movzbl (%eax),%eax
     3a1:	84 c0                	test   %al,%al
     3a3:	75 e2                	jne    387 <strcpy+0xd>
    ;
  return os;
     3a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3a8:	c9                   	leave  
     3a9:	c3                   	ret    

000003aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
     3aa:	55                   	push   %ebp
     3ab:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     3ad:	eb 08                	jmp    3b7 <strcmp+0xd>
    p++, q++;
     3af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     3b7:	8b 45 08             	mov    0x8(%ebp),%eax
     3ba:	0f b6 00             	movzbl (%eax),%eax
     3bd:	84 c0                	test   %al,%al
     3bf:	74 10                	je     3d1 <strcmp+0x27>
     3c1:	8b 45 08             	mov    0x8(%ebp),%eax
     3c4:	0f b6 10             	movzbl (%eax),%edx
     3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ca:	0f b6 00             	movzbl (%eax),%eax
     3cd:	38 c2                	cmp    %al,%dl
     3cf:	74 de                	je     3af <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     3d1:	8b 45 08             	mov    0x8(%ebp),%eax
     3d4:	0f b6 00             	movzbl (%eax),%eax
     3d7:	0f b6 d0             	movzbl %al,%edx
     3da:	8b 45 0c             	mov    0xc(%ebp),%eax
     3dd:	0f b6 00             	movzbl (%eax),%eax
     3e0:	0f b6 c0             	movzbl %al,%eax
     3e3:	29 c2                	sub    %eax,%edx
     3e5:	89 d0                	mov    %edx,%eax
}
     3e7:	5d                   	pop    %ebp
     3e8:	c3                   	ret    

000003e9 <strlen>:

uint
strlen(char *s)
{
     3e9:	55                   	push   %ebp
     3ea:	89 e5                	mov    %esp,%ebp
     3ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     3ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     3f6:	eb 04                	jmp    3fc <strlen+0x13>
     3f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     3fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
     3ff:	8b 45 08             	mov    0x8(%ebp),%eax
     402:	01 d0                	add    %edx,%eax
     404:	0f b6 00             	movzbl (%eax),%eax
     407:	84 c0                	test   %al,%al
     409:	75 ed                	jne    3f8 <strlen+0xf>
    ;
  return n;
     40b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     40e:	c9                   	leave  
     40f:	c3                   	ret    

00000410 <memset>:

void*
memset(void *dst, int c, uint n)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     416:	8b 45 10             	mov    0x10(%ebp),%eax
     419:	89 44 24 08          	mov    %eax,0x8(%esp)
     41d:	8b 45 0c             	mov    0xc(%ebp),%eax
     420:	89 44 24 04          	mov    %eax,0x4(%esp)
     424:	8b 45 08             	mov    0x8(%ebp),%eax
     427:	89 04 24             	mov    %eax,(%esp)
     42a:	e8 26 ff ff ff       	call   355 <stosb>
  return dst;
     42f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     432:	c9                   	leave  
     433:	c3                   	ret    

00000434 <strchr>:

char*
strchr(const char *s, char c)
{
     434:	55                   	push   %ebp
     435:	89 e5                	mov    %esp,%ebp
     437:	83 ec 04             	sub    $0x4,%esp
     43a:	8b 45 0c             	mov    0xc(%ebp),%eax
     43d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     440:	eb 14                	jmp    456 <strchr+0x22>
    if(*s == c)
     442:	8b 45 08             	mov    0x8(%ebp),%eax
     445:	0f b6 00             	movzbl (%eax),%eax
     448:	3a 45 fc             	cmp    -0x4(%ebp),%al
     44b:	75 05                	jne    452 <strchr+0x1e>
      return (char*)s;
     44d:	8b 45 08             	mov    0x8(%ebp),%eax
     450:	eb 13                	jmp    465 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     452:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     456:	8b 45 08             	mov    0x8(%ebp),%eax
     459:	0f b6 00             	movzbl (%eax),%eax
     45c:	84 c0                	test   %al,%al
     45e:	75 e2                	jne    442 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     460:	b8 00 00 00 00       	mov    $0x0,%eax
}
     465:	c9                   	leave  
     466:	c3                   	ret    

00000467 <gets>:

char*
gets(char *buf, int max)
{
     467:	55                   	push   %ebp
     468:	89 e5                	mov    %esp,%ebp
     46a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     46d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     474:	eb 4c                	jmp    4c2 <gets+0x5b>
    cc = read(0, &c, 1);
     476:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     47d:	00 
     47e:	8d 45 ef             	lea    -0x11(%ebp),%eax
     481:	89 44 24 04          	mov    %eax,0x4(%esp)
     485:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     48c:	e8 5c 01 00 00       	call   5ed <read>
     491:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     498:	7f 02                	jg     49c <gets+0x35>
      break;
     49a:	eb 31                	jmp    4cd <gets+0x66>
    buf[i++] = c;
     49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     49f:	8d 50 01             	lea    0x1(%eax),%edx
     4a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
     4a5:	89 c2                	mov    %eax,%edx
     4a7:	8b 45 08             	mov    0x8(%ebp),%eax
     4aa:	01 c2                	add    %eax,%edx
     4ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     4b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4b6:	3c 0a                	cmp    $0xa,%al
     4b8:	74 13                	je     4cd <gets+0x66>
     4ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     4be:	3c 0d                	cmp    $0xd,%al
     4c0:	74 0b                	je     4cd <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	83 c0 01             	add    $0x1,%eax
     4c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
     4cb:	7c a9                	jl     476 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     4cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4d0:	8b 45 08             	mov    0x8(%ebp),%eax
     4d3:	01 d0                	add    %edx,%eax
     4d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     4d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     4db:	c9                   	leave  
     4dc:	c3                   	ret    

000004dd <stat>:

int
stat(char *n, struct stat *st)
{
     4dd:	55                   	push   %ebp
     4de:	89 e5                	mov    %esp,%ebp
     4e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     4e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4ea:	00 
     4eb:	8b 45 08             	mov    0x8(%ebp),%eax
     4ee:	89 04 24             	mov    %eax,(%esp)
     4f1:	e8 1f 01 00 00       	call   615 <open>
     4f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     4f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     4fd:	79 07                	jns    506 <stat+0x29>
    return -1;
     4ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     504:	eb 23                	jmp    529 <stat+0x4c>
  r = fstat(fd, st);
     506:	8b 45 0c             	mov    0xc(%ebp),%eax
     509:	89 44 24 04          	mov    %eax,0x4(%esp)
     50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     510:	89 04 24             	mov    %eax,(%esp)
     513:	e8 15 01 00 00       	call   62d <fstat>
     518:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	89 04 24             	mov    %eax,(%esp)
     521:	e8 d7 00 00 00       	call   5fd <close>
  return r;
     526:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     529:	c9                   	leave  
     52a:	c3                   	ret    

0000052b <atoi>:

int
atoi(const char *s)
{
     52b:	55                   	push   %ebp
     52c:	89 e5                	mov    %esp,%ebp
     52e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     538:	eb 25                	jmp    55f <atoi+0x34>
    n = n*10 + *s++ - '0';
     53a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     53d:	89 d0                	mov    %edx,%eax
     53f:	c1 e0 02             	shl    $0x2,%eax
     542:	01 d0                	add    %edx,%eax
     544:	01 c0                	add    %eax,%eax
     546:	89 c1                	mov    %eax,%ecx
     548:	8b 45 08             	mov    0x8(%ebp),%eax
     54b:	8d 50 01             	lea    0x1(%eax),%edx
     54e:	89 55 08             	mov    %edx,0x8(%ebp)
     551:	0f b6 00             	movzbl (%eax),%eax
     554:	0f be c0             	movsbl %al,%eax
     557:	01 c8                	add    %ecx,%eax
     559:	83 e8 30             	sub    $0x30,%eax
     55c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     55f:	8b 45 08             	mov    0x8(%ebp),%eax
     562:	0f b6 00             	movzbl (%eax),%eax
     565:	3c 2f                	cmp    $0x2f,%al
     567:	7e 0a                	jle    573 <atoi+0x48>
     569:	8b 45 08             	mov    0x8(%ebp),%eax
     56c:	0f b6 00             	movzbl (%eax),%eax
     56f:	3c 39                	cmp    $0x39,%al
     571:	7e c7                	jle    53a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     573:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     576:	c9                   	leave  
     577:	c3                   	ret    

00000578 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     578:	55                   	push   %ebp
     579:	89 e5                	mov    %esp,%ebp
     57b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     57e:	8b 45 08             	mov    0x8(%ebp),%eax
     581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     584:	8b 45 0c             	mov    0xc(%ebp),%eax
     587:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     58a:	eb 17                	jmp    5a3 <memmove+0x2b>
    *dst++ = *src++;
     58c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     58f:	8d 50 01             	lea    0x1(%eax),%edx
     592:	89 55 fc             	mov    %edx,-0x4(%ebp)
     595:	8b 55 f8             	mov    -0x8(%ebp),%edx
     598:	8d 4a 01             	lea    0x1(%edx),%ecx
     59b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     59e:	0f b6 12             	movzbl (%edx),%edx
     5a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     5a3:	8b 45 10             	mov    0x10(%ebp),%eax
     5a6:	8d 50 ff             	lea    -0x1(%eax),%edx
     5a9:	89 55 10             	mov    %edx,0x10(%ebp)
     5ac:	85 c0                	test   %eax,%eax
     5ae:	7f dc                	jg     58c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     5b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     5b3:	c9                   	leave  
     5b4:	c3                   	ret    

000005b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     5b5:	b8 01 00 00 00       	mov    $0x1,%eax
     5ba:	cd 40                	int    $0x40
     5bc:	c3                   	ret    

000005bd <exit>:
SYSCALL(exit)
     5bd:	b8 02 00 00 00       	mov    $0x2,%eax
     5c2:	cd 40                	int    $0x40
     5c4:	c3                   	ret    

000005c5 <wait>:
SYSCALL(wait)
     5c5:	b8 03 00 00 00       	mov    $0x3,%eax
     5ca:	cd 40                	int    $0x40
     5cc:	c3                   	ret    

000005cd <signal>:
SYSCALL(signal)
     5cd:	b8 18 00 00 00       	mov    $0x18,%eax
     5d2:	cd 40                	int    $0x40
     5d4:	c3                   	ret    

000005d5 <sigsend>:
SYSCALL(sigsend)
     5d5:	b8 19 00 00 00       	mov    $0x19,%eax
     5da:	cd 40                	int    $0x40
     5dc:	c3                   	ret    

000005dd <alarm>:
SYSCALL(alarm)
     5dd:	b8 1a 00 00 00       	mov    $0x1a,%eax
     5e2:	cd 40                	int    $0x40
     5e4:	c3                   	ret    

000005e5 <pipe>:
SYSCALL(pipe)
     5e5:	b8 04 00 00 00       	mov    $0x4,%eax
     5ea:	cd 40                	int    $0x40
     5ec:	c3                   	ret    

000005ed <read>:
SYSCALL(read)
     5ed:	b8 05 00 00 00       	mov    $0x5,%eax
     5f2:	cd 40                	int    $0x40
     5f4:	c3                   	ret    

000005f5 <write>:
SYSCALL(write)
     5f5:	b8 10 00 00 00       	mov    $0x10,%eax
     5fa:	cd 40                	int    $0x40
     5fc:	c3                   	ret    

000005fd <close>:
SYSCALL(close)
     5fd:	b8 15 00 00 00       	mov    $0x15,%eax
     602:	cd 40                	int    $0x40
     604:	c3                   	ret    

00000605 <kill>:
SYSCALL(kill)
     605:	b8 06 00 00 00       	mov    $0x6,%eax
     60a:	cd 40                	int    $0x40
     60c:	c3                   	ret    

0000060d <exec>:
SYSCALL(exec)
     60d:	b8 07 00 00 00       	mov    $0x7,%eax
     612:	cd 40                	int    $0x40
     614:	c3                   	ret    

00000615 <open>:
SYSCALL(open)
     615:	b8 0f 00 00 00       	mov    $0xf,%eax
     61a:	cd 40                	int    $0x40
     61c:	c3                   	ret    

0000061d <mknod>:
SYSCALL(mknod)
     61d:	b8 11 00 00 00       	mov    $0x11,%eax
     622:	cd 40                	int    $0x40
     624:	c3                   	ret    

00000625 <unlink>:
SYSCALL(unlink)
     625:	b8 12 00 00 00       	mov    $0x12,%eax
     62a:	cd 40                	int    $0x40
     62c:	c3                   	ret    

0000062d <fstat>:
SYSCALL(fstat)
     62d:	b8 08 00 00 00       	mov    $0x8,%eax
     632:	cd 40                	int    $0x40
     634:	c3                   	ret    

00000635 <link>:
SYSCALL(link)
     635:	b8 13 00 00 00       	mov    $0x13,%eax
     63a:	cd 40                	int    $0x40
     63c:	c3                   	ret    

0000063d <mkdir>:
SYSCALL(mkdir)
     63d:	b8 14 00 00 00       	mov    $0x14,%eax
     642:	cd 40                	int    $0x40
     644:	c3                   	ret    

00000645 <chdir>:
SYSCALL(chdir)
     645:	b8 09 00 00 00       	mov    $0x9,%eax
     64a:	cd 40                	int    $0x40
     64c:	c3                   	ret    

0000064d <dup>:
SYSCALL(dup)
     64d:	b8 0a 00 00 00       	mov    $0xa,%eax
     652:	cd 40                	int    $0x40
     654:	c3                   	ret    

00000655 <getpid>:
SYSCALL(getpid)
     655:	b8 0b 00 00 00       	mov    $0xb,%eax
     65a:	cd 40                	int    $0x40
     65c:	c3                   	ret    

0000065d <sbrk>:
SYSCALL(sbrk)
     65d:	b8 0c 00 00 00       	mov    $0xc,%eax
     662:	cd 40                	int    $0x40
     664:	c3                   	ret    

00000665 <sleep>:
SYSCALL(sleep)
     665:	b8 0d 00 00 00       	mov    $0xd,%eax
     66a:	cd 40                	int    $0x40
     66c:	c3                   	ret    

0000066d <uptime>:
SYSCALL(uptime)
     66d:	b8 0e 00 00 00       	mov    $0xe,%eax
     672:	cd 40                	int    $0x40
     674:	c3                   	ret    

00000675 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     675:	55                   	push   %ebp
     676:	89 e5                	mov    %esp,%ebp
     678:	83 ec 18             	sub    $0x18,%esp
     67b:	8b 45 0c             	mov    0xc(%ebp),%eax
     67e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     681:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     688:	00 
     689:	8d 45 f4             	lea    -0xc(%ebp),%eax
     68c:	89 44 24 04          	mov    %eax,0x4(%esp)
     690:	8b 45 08             	mov    0x8(%ebp),%eax
     693:	89 04 24             	mov    %eax,(%esp)
     696:	e8 5a ff ff ff       	call   5f5 <write>
}
     69b:	c9                   	leave  
     69c:	c3                   	ret    

0000069d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     69d:	55                   	push   %ebp
     69e:	89 e5                	mov    %esp,%ebp
     6a0:	56                   	push   %esi
     6a1:	53                   	push   %ebx
     6a2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     6a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     6ac:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     6b0:	74 17                	je     6c9 <printint+0x2c>
     6b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     6b6:	79 11                	jns    6c9 <printint+0x2c>
    neg = 1;
     6b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     6bf:	8b 45 0c             	mov    0xc(%ebp),%eax
     6c2:	f7 d8                	neg    %eax
     6c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6c7:	eb 06                	jmp    6cf <printint+0x32>
  } else {
    x = xx;
     6c9:	8b 45 0c             	mov    0xc(%ebp),%eax
     6cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     6cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     6d6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     6d9:	8d 41 01             	lea    0x1(%ecx),%eax
     6dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
     6df:	8b 5d 10             	mov    0x10(%ebp),%ebx
     6e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6e5:	ba 00 00 00 00       	mov    $0x0,%edx
     6ea:	f7 f3                	div    %ebx
     6ec:	89 d0                	mov    %edx,%eax
     6ee:	0f b6 80 80 16 00 00 	movzbl 0x1680(%eax),%eax
     6f5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     6f9:	8b 75 10             	mov    0x10(%ebp),%esi
     6fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6ff:	ba 00 00 00 00       	mov    $0x0,%edx
     704:	f7 f6                	div    %esi
     706:	89 45 ec             	mov    %eax,-0x14(%ebp)
     709:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     70d:	75 c7                	jne    6d6 <printint+0x39>
  if(neg)
     70f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     713:	74 10                	je     725 <printint+0x88>
    buf[i++] = '-';
     715:	8b 45 f4             	mov    -0xc(%ebp),%eax
     718:	8d 50 01             	lea    0x1(%eax),%edx
     71b:	89 55 f4             	mov    %edx,-0xc(%ebp)
     71e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     723:	eb 1f                	jmp    744 <printint+0xa7>
     725:	eb 1d                	jmp    744 <printint+0xa7>
    putc(fd, buf[i]);
     727:	8d 55 dc             	lea    -0x24(%ebp),%edx
     72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72d:	01 d0                	add    %edx,%eax
     72f:	0f b6 00             	movzbl (%eax),%eax
     732:	0f be c0             	movsbl %al,%eax
     735:	89 44 24 04          	mov    %eax,0x4(%esp)
     739:	8b 45 08             	mov    0x8(%ebp),%eax
     73c:	89 04 24             	mov    %eax,(%esp)
     73f:	e8 31 ff ff ff       	call   675 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     744:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     74c:	79 d9                	jns    727 <printint+0x8a>
    putc(fd, buf[i]);
}
     74e:	83 c4 30             	add    $0x30,%esp
     751:	5b                   	pop    %ebx
     752:	5e                   	pop    %esi
     753:	5d                   	pop    %ebp
     754:	c3                   	ret    

00000755 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     755:	55                   	push   %ebp
     756:	89 e5                	mov    %esp,%ebp
     758:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     75b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     762:	8d 45 0c             	lea    0xc(%ebp),%eax
     765:	83 c0 04             	add    $0x4,%eax
     768:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     76b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     772:	e9 7c 01 00 00       	jmp    8f3 <printf+0x19e>
    c = fmt[i] & 0xff;
     777:	8b 55 0c             	mov    0xc(%ebp),%edx
     77a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     77d:	01 d0                	add    %edx,%eax
     77f:	0f b6 00             	movzbl (%eax),%eax
     782:	0f be c0             	movsbl %al,%eax
     785:	25 ff 00 00 00       	and    $0xff,%eax
     78a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     78d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     791:	75 2c                	jne    7bf <printf+0x6a>
      if(c == '%'){
     793:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     797:	75 0c                	jne    7a5 <printf+0x50>
        state = '%';
     799:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     7a0:	e9 4a 01 00 00       	jmp    8ef <printf+0x19a>
      } else {
        putc(fd, c);
     7a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7a8:	0f be c0             	movsbl %al,%eax
     7ab:	89 44 24 04          	mov    %eax,0x4(%esp)
     7af:	8b 45 08             	mov    0x8(%ebp),%eax
     7b2:	89 04 24             	mov    %eax,(%esp)
     7b5:	e8 bb fe ff ff       	call   675 <putc>
     7ba:	e9 30 01 00 00       	jmp    8ef <printf+0x19a>
      }
    } else if(state == '%'){
     7bf:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     7c3:	0f 85 26 01 00 00    	jne    8ef <printf+0x19a>
      if(c == 'd'){
     7c9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     7cd:	75 2d                	jne    7fc <printf+0xa7>
        printint(fd, *ap, 10, 1);
     7cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7d2:	8b 00                	mov    (%eax),%eax
     7d4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     7db:	00 
     7dc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     7e3:	00 
     7e4:	89 44 24 04          	mov    %eax,0x4(%esp)
     7e8:	8b 45 08             	mov    0x8(%ebp),%eax
     7eb:	89 04 24             	mov    %eax,(%esp)
     7ee:	e8 aa fe ff ff       	call   69d <printint>
        ap++;
     7f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     7f7:	e9 ec 00 00 00       	jmp    8e8 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     7fc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     800:	74 06                	je     808 <printf+0xb3>
     802:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     806:	75 2d                	jne    835 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     808:	8b 45 e8             	mov    -0x18(%ebp),%eax
     80b:	8b 00                	mov    (%eax),%eax
     80d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     814:	00 
     815:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     81c:	00 
     81d:	89 44 24 04          	mov    %eax,0x4(%esp)
     821:	8b 45 08             	mov    0x8(%ebp),%eax
     824:	89 04 24             	mov    %eax,(%esp)
     827:	e8 71 fe ff ff       	call   69d <printint>
        ap++;
     82c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     830:	e9 b3 00 00 00       	jmp    8e8 <printf+0x193>
      } else if(c == 's'){
     835:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     839:	75 45                	jne    880 <printf+0x12b>
        s = (char*)*ap;
     83b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     83e:	8b 00                	mov    (%eax),%eax
     840:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     843:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     847:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     84b:	75 09                	jne    856 <printf+0x101>
          s = "(null)";
     84d:	c7 45 f4 7e 11 00 00 	movl   $0x117e,-0xc(%ebp)
        while(*s != 0){
     854:	eb 1e                	jmp    874 <printf+0x11f>
     856:	eb 1c                	jmp    874 <printf+0x11f>
          putc(fd, *s);
     858:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85b:	0f b6 00             	movzbl (%eax),%eax
     85e:	0f be c0             	movsbl %al,%eax
     861:	89 44 24 04          	mov    %eax,0x4(%esp)
     865:	8b 45 08             	mov    0x8(%ebp),%eax
     868:	89 04 24             	mov    %eax,(%esp)
     86b:	e8 05 fe ff ff       	call   675 <putc>
          s++;
     870:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     874:	8b 45 f4             	mov    -0xc(%ebp),%eax
     877:	0f b6 00             	movzbl (%eax),%eax
     87a:	84 c0                	test   %al,%al
     87c:	75 da                	jne    858 <printf+0x103>
     87e:	eb 68                	jmp    8e8 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     880:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     884:	75 1d                	jne    8a3 <printf+0x14e>
        putc(fd, *ap);
     886:	8b 45 e8             	mov    -0x18(%ebp),%eax
     889:	8b 00                	mov    (%eax),%eax
     88b:	0f be c0             	movsbl %al,%eax
     88e:	89 44 24 04          	mov    %eax,0x4(%esp)
     892:	8b 45 08             	mov    0x8(%ebp),%eax
     895:	89 04 24             	mov    %eax,(%esp)
     898:	e8 d8 fd ff ff       	call   675 <putc>
        ap++;
     89d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     8a1:	eb 45                	jmp    8e8 <printf+0x193>
      } else if(c == '%'){
     8a3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     8a7:	75 17                	jne    8c0 <printf+0x16b>
        putc(fd, c);
     8a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8ac:	0f be c0             	movsbl %al,%eax
     8af:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b3:	8b 45 08             	mov    0x8(%ebp),%eax
     8b6:	89 04 24             	mov    %eax,(%esp)
     8b9:	e8 b7 fd ff ff       	call   675 <putc>
     8be:	eb 28                	jmp    8e8 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     8c0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     8c7:	00 
     8c8:	8b 45 08             	mov    0x8(%ebp),%eax
     8cb:	89 04 24             	mov    %eax,(%esp)
     8ce:	e8 a2 fd ff ff       	call   675 <putc>
        putc(fd, c);
     8d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8d6:	0f be c0             	movsbl %al,%eax
     8d9:	89 44 24 04          	mov    %eax,0x4(%esp)
     8dd:	8b 45 08             	mov    0x8(%ebp),%eax
     8e0:	89 04 24             	mov    %eax,(%esp)
     8e3:	e8 8d fd ff ff       	call   675 <putc>
      }
      state = 0;
     8e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     8ef:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     8f3:	8b 55 0c             	mov    0xc(%ebp),%edx
     8f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8f9:	01 d0                	add    %edx,%eax
     8fb:	0f b6 00             	movzbl (%eax),%eax
     8fe:	84 c0                	test   %al,%al
     900:	0f 85 71 fe ff ff    	jne    777 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     906:	c9                   	leave  
     907:	c3                   	ret    

00000908 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     908:	55                   	push   %ebp
     909:	89 e5                	mov    %esp,%ebp
     90b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     90e:	8b 45 08             	mov    0x8(%ebp),%eax
     911:	83 e8 08             	sub    $0x8,%eax
     914:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     917:	a1 a8 16 00 00       	mov    0x16a8,%eax
     91c:	89 45 fc             	mov    %eax,-0x4(%ebp)
     91f:	eb 24                	jmp    945 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     921:	8b 45 fc             	mov    -0x4(%ebp),%eax
     924:	8b 00                	mov    (%eax),%eax
     926:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     929:	77 12                	ja     93d <free+0x35>
     92b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     92e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     931:	77 24                	ja     957 <free+0x4f>
     933:	8b 45 fc             	mov    -0x4(%ebp),%eax
     936:	8b 00                	mov    (%eax),%eax
     938:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     93b:	77 1a                	ja     957 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     93d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     940:	8b 00                	mov    (%eax),%eax
     942:	89 45 fc             	mov    %eax,-0x4(%ebp)
     945:	8b 45 f8             	mov    -0x8(%ebp),%eax
     948:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     94b:	76 d4                	jbe    921 <free+0x19>
     94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     950:	8b 00                	mov    (%eax),%eax
     952:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     955:	76 ca                	jbe    921 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     957:	8b 45 f8             	mov    -0x8(%ebp),%eax
     95a:	8b 40 04             	mov    0x4(%eax),%eax
     95d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     964:	8b 45 f8             	mov    -0x8(%ebp),%eax
     967:	01 c2                	add    %eax,%edx
     969:	8b 45 fc             	mov    -0x4(%ebp),%eax
     96c:	8b 00                	mov    (%eax),%eax
     96e:	39 c2                	cmp    %eax,%edx
     970:	75 24                	jne    996 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     972:	8b 45 f8             	mov    -0x8(%ebp),%eax
     975:	8b 50 04             	mov    0x4(%eax),%edx
     978:	8b 45 fc             	mov    -0x4(%ebp),%eax
     97b:	8b 00                	mov    (%eax),%eax
     97d:	8b 40 04             	mov    0x4(%eax),%eax
     980:	01 c2                	add    %eax,%edx
     982:	8b 45 f8             	mov    -0x8(%ebp),%eax
     985:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     988:	8b 45 fc             	mov    -0x4(%ebp),%eax
     98b:	8b 00                	mov    (%eax),%eax
     98d:	8b 10                	mov    (%eax),%edx
     98f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     992:	89 10                	mov    %edx,(%eax)
     994:	eb 0a                	jmp    9a0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     996:	8b 45 fc             	mov    -0x4(%ebp),%eax
     999:	8b 10                	mov    (%eax),%edx
     99b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     99e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     9a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9a3:	8b 40 04             	mov    0x4(%eax),%eax
     9a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     9ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9b0:	01 d0                	add    %edx,%eax
     9b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     9b5:	75 20                	jne    9d7 <free+0xcf>
    p->s.size += bp->s.size;
     9b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ba:	8b 50 04             	mov    0x4(%eax),%edx
     9bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9c0:	8b 40 04             	mov    0x4(%eax),%eax
     9c3:	01 c2                	add    %eax,%edx
     9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9c8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     9cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9ce:	8b 10                	mov    (%eax),%edx
     9d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9d3:	89 10                	mov    %edx,(%eax)
     9d5:	eb 08                	jmp    9df <free+0xd7>
  } else
    p->s.ptr = bp;
     9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9da:	8b 55 f8             	mov    -0x8(%ebp),%edx
     9dd:	89 10                	mov    %edx,(%eax)
  freep = p;
     9df:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9e2:	a3 a8 16 00 00       	mov    %eax,0x16a8
}
     9e7:	c9                   	leave  
     9e8:	c3                   	ret    

000009e9 <morecore>:

static Header*
morecore(uint nu)
{
     9e9:	55                   	push   %ebp
     9ea:	89 e5                	mov    %esp,%ebp
     9ec:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     9ef:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     9f6:	77 07                	ja     9ff <morecore+0x16>
    nu = 4096;
     9f8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     9ff:	8b 45 08             	mov    0x8(%ebp),%eax
     a02:	c1 e0 03             	shl    $0x3,%eax
     a05:	89 04 24             	mov    %eax,(%esp)
     a08:	e8 50 fc ff ff       	call   65d <sbrk>
     a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     a10:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     a14:	75 07                	jne    a1d <morecore+0x34>
    return 0;
     a16:	b8 00 00 00 00       	mov    $0x0,%eax
     a1b:	eb 22                	jmp    a3f <morecore+0x56>
  hp = (Header*)p;
     a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a26:	8b 55 08             	mov    0x8(%ebp),%edx
     a29:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a2f:	83 c0 08             	add    $0x8,%eax
     a32:	89 04 24             	mov    %eax,(%esp)
     a35:	e8 ce fe ff ff       	call   908 <free>
  return freep;
     a3a:	a1 a8 16 00 00       	mov    0x16a8,%eax
}
     a3f:	c9                   	leave  
     a40:	c3                   	ret    

00000a41 <malloc>:

void*
malloc(uint nbytes)
{
     a41:	55                   	push   %ebp
     a42:	89 e5                	mov    %esp,%ebp
     a44:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     a47:	8b 45 08             	mov    0x8(%ebp),%eax
     a4a:	83 c0 07             	add    $0x7,%eax
     a4d:	c1 e8 03             	shr    $0x3,%eax
     a50:	83 c0 01             	add    $0x1,%eax
     a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     a56:	a1 a8 16 00 00       	mov    0x16a8,%eax
     a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a62:	75 23                	jne    a87 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     a64:	c7 45 f0 a0 16 00 00 	movl   $0x16a0,-0x10(%ebp)
     a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a6e:	a3 a8 16 00 00       	mov    %eax,0x16a8
     a73:	a1 a8 16 00 00       	mov    0x16a8,%eax
     a78:	a3 a0 16 00 00       	mov    %eax,0x16a0
    base.s.size = 0;
     a7d:	c7 05 a4 16 00 00 00 	movl   $0x0,0x16a4
     a84:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a8a:	8b 00                	mov    (%eax),%eax
     a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a92:	8b 40 04             	mov    0x4(%eax),%eax
     a95:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a98:	72 4d                	jb     ae7 <malloc+0xa6>
      if(p->s.size == nunits)
     a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a9d:	8b 40 04             	mov    0x4(%eax),%eax
     aa0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     aa3:	75 0c                	jne    ab1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa8:	8b 10                	mov    (%eax),%edx
     aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aad:	89 10                	mov    %edx,(%eax)
     aaf:	eb 26                	jmp    ad7 <malloc+0x96>
      else {
        p->s.size -= nunits;
     ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab4:	8b 40 04             	mov    0x4(%eax),%eax
     ab7:	2b 45 ec             	sub    -0x14(%ebp),%eax
     aba:	89 c2                	mov    %eax,%edx
     abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     abf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac5:	8b 40 04             	mov    0x4(%eax),%eax
     ac8:	c1 e0 03             	shl    $0x3,%eax
     acb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
     ad4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ada:	a3 a8 16 00 00       	mov    %eax,0x16a8
      return (void*)(p + 1);
     adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ae2:	83 c0 08             	add    $0x8,%eax
     ae5:	eb 38                	jmp    b1f <malloc+0xde>
    }
    if(p == freep)
     ae7:	a1 a8 16 00 00       	mov    0x16a8,%eax
     aec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     aef:	75 1b                	jne    b0c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     af4:	89 04 24             	mov    %eax,(%esp)
     af7:	e8 ed fe ff ff       	call   9e9 <morecore>
     afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
     aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b03:	75 07                	jne    b0c <malloc+0xcb>
        return 0;
     b05:	b8 00 00 00 00       	mov    $0x0,%eax
     b0a:	eb 13                	jmp    b1f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b15:	8b 00                	mov    (%eax),%eax
     b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     b1a:	e9 70 ff ff ff       	jmp    a8f <malloc+0x4e>
}
     b1f:	c9                   	leave  
     b20:	c3                   	ret    

00000b21 <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
     b21:	55                   	push   %ebp
     b22:	89 e5                	mov    %esp,%ebp
     b24:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
     b27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     b2e:	eb 17                	jmp    b47 <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
     b30:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b33:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     b3a:	85 c0                	test   %eax,%eax
     b3c:	75 05                	jne    b43 <findNextFreeThreadId+0x22>
			return i;
     b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b41:	eb 0f                	jmp    b52 <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
     b43:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     b47:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
     b4b:	7e e3                	jle    b30 <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
     b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b52:	c9                   	leave  
     b53:	c3                   	ret    

00000b54 <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
     b54:	55                   	push   %ebp
     b55:	89 e5                	mov    %esp,%ebp
     b57:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
     b5a:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     b5f:	8b 00                	mov    (%eax),%eax
     b61:	8d 50 01             	lea    0x1(%eax),%edx
     b64:	89 d0                	mov    %edx,%eax
     b66:	c1 f8 1f             	sar    $0x1f,%eax
     b69:	c1 e8 1a             	shr    $0x1a,%eax
     b6c:	01 c2                	add    %eax,%edx
     b6e:	83 e2 3f             	and    $0x3f,%edx
     b71:	29 c2                	sub    %eax,%edx
     b73:	89 d0                	mov    %edx,%eax
     b75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
     b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b7b:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     b82:	8b 40 28             	mov    0x28(%eax),%eax
     b85:	83 f8 02             	cmp    $0x2,%eax
     b88:	75 0c                	jne    b96 <findNextRunnableThread+0x42>
			return threadTable.threads[i];
     b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b8d:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     b94:	eb 1c                	jmp    bb2 <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
     b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b99:	8d 50 01             	lea    0x1(%eax),%edx
     b9c:	89 d0                	mov    %edx,%eax
     b9e:	c1 f8 1f             	sar    $0x1f,%eax
     ba1:	c1 e8 1a             	shr    $0x1a,%eax
     ba4:	01 c2                	add    %eax,%edx
     ba6:	83 e2 3f             	and    $0x3f,%edx
     ba9:	29 c2                	sub    %eax,%edx
     bab:	89 d0                	mov    %edx,%eax
     bad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
     bb0:	eb c6                	jmp    b78 <findNextRunnableThread+0x24>
}
     bb2:	c9                   	leave  
     bb3:	c3                   	ret    

00000bb4 <uthread_init>:

void uthread_init(void)
{
     bb4:	55                   	push   %ebp
     bb5:	89 e5                	mov    %esp,%ebp
     bb7:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
     bba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     bc1:	eb 12                	jmp    bd5 <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
     bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc6:	c7 04 85 c0 1a 00 00 	movl   $0x0,0x1ac0(,%eax,4)
     bcd:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
     bd1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bd5:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
     bd9:	7e e8                	jle    bc3 <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
     bdb:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
     be2:	e8 5a fe ff ff       	call   a41 <malloc>
     be7:	a3 c0 1a 00 00       	mov    %eax,0x1ac0
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
     bec:	a1 c0 1a 00 00       	mov    0x1ac0,%eax
     bf1:	89 e2                	mov    %esp,%edx
     bf3:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
     bf6:	a1 c0 1a 00 00       	mov    0x1ac0,%eax
     bfb:	89 ea                	mov    %ebp,%edx
     bfd:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
     c00:	a1 c0 1a 00 00       	mov    0x1ac0,%eax
     c05:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
     c0c:	a1 c0 1a 00 00       	mov    0x1ac0,%eax
     c11:	a3 c0 1b 00 00       	mov    %eax,0x1bc0
	threadTable.threadCount = 1;
     c16:	c7 05 c4 1b 00 00 01 	movl   $0x1,0x1bc4
     c1d:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
     c20:	c7 44 24 04 f9 0d 00 	movl   $0xdf9,0x4(%esp)
     c27:	00 
     c28:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
     c2f:	e8 99 f9 ff ff       	call   5cd <signal>
	alarm(UTHREAD_QUANTA);
     c34:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     c3b:	e8 9d f9 ff ff       	call   5dd <alarm>
}
     c40:	c9                   	leave  
     c41:	c3                   	ret    

00000c42 <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
     c42:	55                   	push   %ebp
     c43:	89 e5                	mov    %esp,%ebp
     c45:	53                   	push   %ebx
     c46:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
     c49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c50:	e8 88 f9 ff ff       	call   5dd <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
     c55:	e8 c7 fe ff ff       	call   b21 <findNextFreeThreadId>
     c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
     c5d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     c61:	75 0a                	jne    c6d <uthread_create+0x2b>
		return -1;
     c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c68:	e9 d6 00 00 00       	jmp    d43 <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
     c6d:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
     c74:	e8 c8 fd ff ff       	call   a41 <malloc>
     c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c7c:	89 04 95 c0 1a 00 00 	mov    %eax,0x1ac0(,%edx,4)
	threadTable.threads[current]->tid = current;
     c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c86:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c90:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
     c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c95:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     c9c:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
     ca3:	a1 c4 1b 00 00       	mov    0x1bc4,%eax
     ca8:	83 c0 01             	add    $0x1,%eax
     cab:	a3 c4 1b 00 00       	mov    %eax,0x1bc4
	threadTable.threads[current]->entry = func;
     cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb3:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     cba:	8b 55 08             	mov    0x8(%ebp),%edx
     cbd:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
     cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc3:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     cca:	8b 55 0c             	mov    0xc(%ebp),%edx
     ccd:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
     cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cd3:	8b 1c 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%ebx
     cda:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     ce1:	e8 5b fd ff ff       	call   a41 <malloc>
     ce6:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
     ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cec:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cf6:	8b 14 95 c0 1a 00 00 	mov    0x1ac0(,%edx,4),%edx
     cfd:	8b 52 24             	mov    0x24(%edx),%edx
     d00:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
     d06:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
     d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d0c:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d16:	8b 14 95 c0 1a 00 00 	mov    0x1ac0(,%edx,4),%edx
     d1d:	8b 52 04             	mov    0x4(%edx),%edx
     d20:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
     d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d26:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     d2d:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
     d34:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     d3b:	e8 9d f8 ff ff       	call   5dd <alarm>
	return current;
     d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d43:	83 c4 24             	add    $0x24,%esp
     d46:	5b                   	pop    %ebx
     d47:	5d                   	pop    %ebp
     d48:	c3                   	ret    

00000d49 <uthread_exit>:

void uthread_exit(void)
{
     d49:	55                   	push   %ebp
     d4a:	89 e5                	mov    %esp,%ebp
     d4c:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
     d4f:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     d54:	8b 00                	mov    (%eax),%eax
     d56:	85 c0                	test   %eax,%eax
     d58:	74 10                	je     d6a <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
     d5a:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     d5f:	8b 40 24             	mov    0x24(%eax),%eax
     d62:	89 04 24             	mov    %eax,(%esp)
     d65:	e8 9e fb ff ff       	call   908 <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
     d6a:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     d6f:	8b 00                	mov    (%eax),%eax
     d71:	c7 04 85 c0 1a 00 00 	movl   $0x0,0x1ac0(,%eax,4)
     d78:	00 00 00 00 
	
	free(threadTable.runningThread);
     d7c:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     d81:	89 04 24             	mov    %eax,(%esp)
     d84:	e8 7f fb ff ff       	call   908 <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
     d89:	a1 c4 1b 00 00       	mov    0x1bc4,%eax
     d8e:	83 e8 01             	sub    $0x1,%eax
     d91:	a3 c4 1b 00 00       	mov    %eax,0x1bc4
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
     d96:	a1 c4 1b 00 00       	mov    0x1bc4,%eax
     d9b:	85 c0                	test   %eax,%eax
     d9d:	75 05                	jne    da4 <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
     d9f:	e8 19 f8 ff ff       	call   5bd <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
     da4:	e8 ab fd ff ff       	call   b54 <findNextRunnableThread>
     da9:	a3 c0 1b 00 00       	mov    %eax,0x1bc0
	
	threadTable.runningThread->state = T_RUNNING;
     dae:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     db3:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
     dba:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     dc1:	e8 17 f8 ff ff       	call   5dd <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
     dc6:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     dcb:	8b 40 04             	mov    0x4(%eax),%eax
     dce:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
     dd0:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     dd5:	8b 40 08             	mov    0x8(%eax),%eax
     dd8:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
     dda:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     ddf:	8b 40 2c             	mov    0x2c(%eax),%eax
     de2:	85 c0                	test   %eax,%eax
     de4:	74 11                	je     df7 <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
     de6:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     deb:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
     df2:	e8 8e 00 00 00       	call   e85 <wrapper>
	}
	

}
     df7:	c9                   	leave  
     df8:	c3                   	ret    

00000df9 <uthread_yield>:

void uthread_yield(void)
{
     df9:	55                   	push   %ebp
     dfa:	89 e5                	mov    %esp,%ebp
     dfc:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
     dff:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e04:	89 e2                	mov    %esp,%edx
     e06:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
     e09:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e0e:	89 ea                	mov    %ebp,%edx
     e10:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
     e13:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e18:	8b 40 28             	mov    0x28(%eax),%eax
     e1b:	83 f8 01             	cmp    $0x1,%eax
     e1e:	75 0c                	jne    e2c <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
     e20:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e25:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
     e2c:	e8 23 fd ff ff       	call   b54 <findNextRunnableThread>
     e31:	a3 c0 1b 00 00       	mov    %eax,0x1bc0
	threadTable.runningThread->state = T_RUNNING;
     e36:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e3b:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
     e42:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     e49:	e8 8f f7 ff ff       	call   5dd <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
     e4e:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e53:	8b 40 04             	mov    0x4(%eax),%eax
     e56:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
     e58:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e5d:	8b 40 08             	mov    0x8(%eax),%eax
     e60:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
     e62:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e67:	8b 40 2c             	mov    0x2c(%eax),%eax
     e6a:	85 c0                	test   %eax,%eax
     e6c:	74 14                	je     e82 <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
     e6e:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e73:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
     e7a:	b8 85 0e 00 00       	mov    $0xe85,%eax
     e7f:	ff d0                	call   *%eax
		asm("ret");
     e81:	c3                   	ret    
	}
	return;
     e82:	90                   	nop
}
     e83:	c9                   	leave  
     e84:	c3                   	ret    

00000e85 <wrapper>:

void wrapper(void) {
     e85:	55                   	push   %ebp
     e86:	89 e5                	mov    %esp,%ebp
     e88:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
     e8b:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     e90:	8b 40 30             	mov    0x30(%eax),%eax
     e93:	8b 15 c0 1b 00 00    	mov    0x1bc0,%edx
     e99:	8b 52 34             	mov    0x34(%edx),%edx
     e9c:	89 14 24             	mov    %edx,(%esp)
     e9f:	ff d0                	call   *%eax
	uthread_exit();
     ea1:	e8 a3 fe ff ff       	call   d49 <uthread_exit>
}
     ea6:	c9                   	leave  
     ea7:	c3                   	ret    

00000ea8 <uthread_self>:

int uthread_self(void)
{
     ea8:	55                   	push   %ebp
     ea9:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
     eab:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     eb0:	8b 00                	mov    (%eax),%eax
}
     eb2:	5d                   	pop    %ebp
     eb3:	c3                   	ret    

00000eb4 <uthread_join>:

int uthread_join(int tid)
{
     eb4:	55                   	push   %ebp
     eb5:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
     eb7:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
     ebb:	7e 07                	jle    ec4 <uthread_join+0x10>
		return -1;
     ebd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ec2:	eb 14                	jmp    ed8 <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
     ec4:	90                   	nop
     ec5:	8b 45 08             	mov    0x8(%ebp),%eax
     ec8:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     ecf:	85 c0                	test   %eax,%eax
     ed1:	75 f2                	jne    ec5 <uthread_join+0x11>
	return 0;
     ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ed8:	5d                   	pop    %ebp
     ed9:	c3                   	ret    

00000eda <uthread_sleep>:

void uthread_sleep(void)
{
     eda:	55                   	push   %ebp
     edb:	89 e5                	mov    %esp,%ebp
     edd:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
     ee0:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     ee5:	89 e2                	mov    %esp,%edx
     ee7:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
     eea:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     eef:	89 ea                	mov    %ebp,%edx
     ef1:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
     ef4:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     ef9:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
     f00:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     f05:	8b 00                	mov    (%eax),%eax
     f07:	89 44 24 08          	mov    %eax,0x8(%esp)
     f0b:	c7 44 24 04 85 11 00 	movl   $0x1185,0x4(%esp)
     f12:	00 
     f13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f1a:	e8 36 f8 ff ff       	call   755 <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
     f1f:	e8 30 fc ff ff       	call   b54 <findNextRunnableThread>
     f24:	a3 c0 1b 00 00       	mov    %eax,0x1bc0
	threadTable.runningThread->state = T_RUNNING;
     f29:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     f2e:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
     f35:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     f3c:	e8 9c f6 ff ff       	call   5dd <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
     f41:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     f46:	8b 40 08             	mov    0x8(%eax),%eax
     f49:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
     f4b:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     f50:	8b 40 04             	mov    0x4(%eax),%eax
     f53:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
     f55:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     f5a:	8b 40 2c             	mov    0x2c(%eax),%eax
     f5d:	85 c0                	test   %eax,%eax
     f5f:	74 14                	je     f75 <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
     f61:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
     f66:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
     f6d:	b8 85 0e 00 00       	mov    $0xe85,%eax
     f72:	ff d0                	call   *%eax
		asm("ret");
     f74:	c3                   	ret    
	}
	return;	
     f75:	90                   	nop
}
     f76:	c9                   	leave  
     f77:	c3                   	ret    

00000f78 <uthread_wakeup>:
void uthread_wakeup(int tid)
{
     f78:	55                   	push   %ebp
     f79:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
     f7b:	8b 45 08             	mov    0x8(%ebp),%eax
     f7e:	8b 04 85 c0 1a 00 00 	mov    0x1ac0(,%eax,4),%eax
     f85:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
     f8c:	5d                   	pop    %ebp
     f8d:	c3                   	ret    

00000f8e <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
     f8e:	55                   	push   %ebp
     f8f:	89 e5                	mov    %esp,%ebp
     f91:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
     f94:	c7 44 24 04 a0 11 00 	movl   $0x11a0,0x4(%esp)
     f9b:	00 
     f9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fa3:	e8 ad f7 ff ff       	call   755 <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
     fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     faf:	eb 26                	jmp    fd7 <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
     fb1:	8b 45 08             	mov    0x8(%ebp),%eax
     fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fb7:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     fbb:	89 44 24 08          	mov    %eax,0x8(%esp)
     fbf:	c7 44 24 04 b7 11 00 	movl   $0x11b7,0x4(%esp)
     fc6:	00 
     fc7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fce:	e8 82 f7 ff ff       	call   755 <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
     fd3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fd7:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
     fdb:	7e d4                	jle    fb1 <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
     fdd:	c7 44 24 04 bb 11 00 	movl   $0x11bb,0x4(%esp)
     fe4:	00 
     fe5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fec:	e8 64 f7 ff ff       	call   755 <printf>
}
     ff1:	c9                   	leave  
     ff2:	c3                   	ret    

00000ff3 <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
     ff3:	55                   	push   %ebp
     ff4:	89 e5                	mov    %esp,%ebp
     ff6:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
     ff9:	8b 45 08             	mov    0x8(%ebp),%eax
     ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
     fff:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
    1001:	8b 45 08             	mov    0x8(%ebp),%eax
    1004:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
    100b:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    100e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1015:	eb 12                	jmp    1029 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
    1017:	8b 45 08             	mov    0x8(%ebp),%eax
    101a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    101d:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
    1024:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    1025:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1029:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
    102d:	7e e8                	jle    1017 <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
    102f:	c9                   	leave  
    1030:	c3                   	ret    

00001031 <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
    1031:	55                   	push   %ebp
    1032:	89 e5                	mov    %esp,%ebp
    1034:	53                   	push   %ebx
    1035:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
    1038:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    103f:	e8 99 f5 ff ff       	call   5dd <alarm>
	if (semaphore->value ==0){
    1044:	8b 45 08             	mov    0x8(%ebp),%eax
    1047:	8b 00                	mov    (%eax),%eax
    1049:	85 c0                	test   %eax,%eax
    104b:	75 34                	jne    1081 <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
    104d:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
    1052:	8b 08                	mov    (%eax),%ecx
    1054:	8b 45 08             	mov    0x8(%ebp),%eax
    1057:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
    105d:	8d 58 01             	lea    0x1(%eax),%ebx
    1060:	8b 55 08             	mov    0x8(%ebp),%edx
    1063:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
    1069:	8b 55 08             	mov    0x8(%ebp),%edx
    106c:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
    1070:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
    1075:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
    107c:	e8 78 fd ff ff       	call   df9 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
    1081:	a1 c0 1b 00 00       	mov    0x1bc0,%eax
    1086:	8b 10                	mov    (%eax),%edx
    1088:	8b 45 08             	mov    0x8(%ebp),%eax
    108b:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
    1092:	ff 
	semaphore->value = 0;
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
    109c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    10a3:	e8 35 f5 ff ff       	call   5dd <alarm>
}
    10a8:	83 c4 14             	add    $0x14,%esp
    10ab:	5b                   	pop    %ebx
    10ac:	5d                   	pop    %ebp
    10ad:	c3                   	ret    

000010ae <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
    10ae:	55                   	push   %ebp
    10af:	89 e5                	mov    %esp,%ebp
    10b1:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
    10b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10bb:	e8 1d f5 ff ff       	call   5dd <alarm>
	
	if (semaphore->value == 0){
    10c0:	8b 45 08             	mov    0x8(%ebp),%eax
    10c3:	8b 00                	mov    (%eax),%eax
    10c5:	85 c0                	test   %eax,%eax
    10c7:	75 71                	jne    113a <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
    10c9:	8b 45 08             	mov    0x8(%ebp),%eax
    10cc:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
    10d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
    10d5:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
    10dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10e3:	eb 35                	jmp    111a <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10eb:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    10ef:	83 f8 ff             	cmp    $0xffffffff,%eax
    10f2:	74 22                	je     1116 <binary_semaphore_up+0x68>
    10f4:	8b 45 08             	mov    0x8(%ebp),%eax
    10f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10fa:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    10fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    1101:	7d 13                	jge    1116 <binary_semaphore_up+0x68>
				minIndex = i;
    1103:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1106:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
    1109:	8b 45 08             	mov    0x8(%ebp),%eax
    110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    110f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1113:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
    1116:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    111a:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    111e:	7e c5                	jle    10e5 <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
    1120:	8b 45 08             	mov    0x8(%ebp),%eax
    1123:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
    1129:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
    112d:	74 0b                	je     113a <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
    112f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1132:	89 04 24             	mov    %eax,(%esp)
    1135:	e8 3e fe ff ff       	call   f78 <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
    113a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    1141:	e8 97 f4 ff ff       	call   5dd <alarm>
	
    1146:	c9                   	leave  
    1147:	c3                   	ret    
