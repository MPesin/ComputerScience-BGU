
_grep:     file format elf32-i386


Disassembly of section .text:

00001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
    1006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    100d:	e9 bb 00 00 00       	jmp    10cd <grep+0xcd>
    m += n;
    1012:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1015:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
    1018:	c7 45 f0 40 20 00 00 	movl   $0x2040,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
    101f:	eb 51                	jmp    1072 <grep+0x72>
      *q = 0;
    1021:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1024:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
    1027:	8b 45 f0             	mov    -0x10(%ebp),%eax
    102a:	89 44 24 04          	mov    %eax,0x4(%esp)
    102e:	8b 45 08             	mov    0x8(%ebp),%eax
    1031:	89 04 24             	mov    %eax,(%esp)
    1034:	e8 bc 01 00 00       	call   11f5 <match>
    1039:	85 c0                	test   %eax,%eax
    103b:	74 2c                	je     1069 <grep+0x69>
        *q = '\n';
    103d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1040:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
    1043:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1046:	83 c0 01             	add    $0x1,%eax
    1049:	89 c2                	mov    %eax,%edx
    104b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    104e:	29 c2                	sub    %eax,%edx
    1050:	89 d0                	mov    %edx,%eax
    1052:	89 44 24 08          	mov    %eax,0x8(%esp)
    1056:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1059:	89 44 24 04          	mov    %eax,0x4(%esp)
    105d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1064:	e8 84 05 00 00       	call   15ed <write>
      }
      p = q+1;
    1069:	8b 45 e8             	mov    -0x18(%ebp),%eax
    106c:	83 c0 01             	add    $0x1,%eax
    106f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
    1072:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
    1079:	00 
    107a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    107d:	89 04 24             	mov    %eax,(%esp)
    1080:	e8 af 03 00 00       	call   1434 <strchr>
    1085:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1088:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    108c:	75 93                	jne    1021 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
    108e:	81 7d f0 40 20 00 00 	cmpl   $0x2040,-0x10(%ebp)
    1095:	75 07                	jne    109e <grep+0x9e>
      m = 0;
    1097:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
    109e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10a2:	7e 29                	jle    10cd <grep+0xcd>
      m -= p - buf;
    10a4:	ba 40 20 00 00       	mov    $0x2040,%edx
    10a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10ac:	29 c2                	sub    %eax,%edx
    10ae:	89 d0                	mov    %edx,%eax
    10b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
    10b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b6:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c1:	c7 04 24 40 20 00 00 	movl   $0x2040,(%esp)
    10c8:	e8 ab 04 00 00       	call   1578 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    10cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d0:	ba 00 04 00 00       	mov    $0x400,%edx
    10d5:	29 c2                	sub    %eax,%edx
    10d7:	89 d0                	mov    %edx,%eax
    10d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10dc:	81 c2 40 20 00 00    	add    $0x2040,%edx
    10e2:	89 44 24 08          	mov    %eax,0x8(%esp)
    10e6:	89 54 24 04          	mov    %edx,0x4(%esp)
    10ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ed:	89 04 24             	mov    %eax,(%esp)
    10f0:	e8 f0 04 00 00       	call   15e5 <read>
    10f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10fc:	0f 8f 10 ff ff ff    	jg     1012 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
    1102:	c9                   	leave  
    1103:	c3                   	ret    

00001104 <main>:

int
main(int argc, char *argv[])
{
    1104:	55                   	push   %ebp
    1105:	89 e5                	mov    %esp,%ebp
    1107:	83 e4 f0             	and    $0xfffffff0,%esp
    110a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
    110d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1111:	7f 19                	jg     112c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
    1113:	c7 44 24 04 1c 1b 00 	movl   $0x1b1c,0x4(%esp)
    111a:	00 
    111b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1122:	e8 26 06 00 00       	call   174d <printf>
    exit();
    1127:	e8 a1 04 00 00       	call   15cd <exit>
  }
  pattern = argv[1];
    112c:	8b 45 0c             	mov    0xc(%ebp),%eax
    112f:	8b 40 04             	mov    0x4(%eax),%eax
    1132:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
    1136:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    113a:	7f 19                	jg     1155 <main+0x51>
    grep(pattern, 0);
    113c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1143:	00 
    1144:	8b 44 24 18          	mov    0x18(%esp),%eax
    1148:	89 04 24             	mov    %eax,(%esp)
    114b:	e8 b0 fe ff ff       	call   1000 <grep>
    exit();
    1150:	e8 78 04 00 00       	call   15cd <exit>
  }

  for(i = 2; i < argc; i++){
    1155:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
    115c:	00 
    115d:	e9 81 00 00 00       	jmp    11e3 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
    1162:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    116d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1170:	01 d0                	add    %edx,%eax
    1172:	8b 00                	mov    (%eax),%eax
    1174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    117b:	00 
    117c:	89 04 24             	mov    %eax,(%esp)
    117f:	e8 89 04 00 00       	call   160d <open>
    1184:	89 44 24 14          	mov    %eax,0x14(%esp)
    1188:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    118d:	79 2f                	jns    11be <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
    118f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    119a:	8b 45 0c             	mov    0xc(%ebp),%eax
    119d:	01 d0                	add    %edx,%eax
    119f:	8b 00                	mov    (%eax),%eax
    11a1:	89 44 24 08          	mov    %eax,0x8(%esp)
    11a5:	c7 44 24 04 3c 1b 00 	movl   $0x1b3c,0x4(%esp)
    11ac:	00 
    11ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11b4:	e8 94 05 00 00       	call   174d <printf>
      exit();
    11b9:	e8 0f 04 00 00       	call   15cd <exit>
    }
    grep(pattern, fd);
    11be:	8b 44 24 14          	mov    0x14(%esp),%eax
    11c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    11c6:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ca:	89 04 24             	mov    %eax,(%esp)
    11cd:	e8 2e fe ff ff       	call   1000 <grep>
    close(fd);
    11d2:	8b 44 24 14          	mov    0x14(%esp),%eax
    11d6:	89 04 24             	mov    %eax,(%esp)
    11d9:	e8 17 04 00 00       	call   15f5 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    11de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    11e3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11e7:	3b 45 08             	cmp    0x8(%ebp),%eax
    11ea:	0f 8c 72 ff ff ff    	jl     1162 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
    11f0:	e8 d8 03 00 00       	call   15cd <exit>

000011f5 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    11f5:	55                   	push   %ebp
    11f6:	89 e5                	mov    %esp,%ebp
    11f8:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
    11fb:	8b 45 08             	mov    0x8(%ebp),%eax
    11fe:	0f b6 00             	movzbl (%eax),%eax
    1201:	3c 5e                	cmp    $0x5e,%al
    1203:	75 17                	jne    121c <match+0x27>
    return matchhere(re+1, text);
    1205:	8b 45 08             	mov    0x8(%ebp),%eax
    1208:	8d 50 01             	lea    0x1(%eax),%edx
    120b:	8b 45 0c             	mov    0xc(%ebp),%eax
    120e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1212:	89 14 24             	mov    %edx,(%esp)
    1215:	e8 36 00 00 00       	call   1250 <matchhere>
    121a:	eb 32                	jmp    124e <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
    121c:	8b 45 0c             	mov    0xc(%ebp),%eax
    121f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
    1226:	89 04 24             	mov    %eax,(%esp)
    1229:	e8 22 00 00 00       	call   1250 <matchhere>
    122e:	85 c0                	test   %eax,%eax
    1230:	74 07                	je     1239 <match+0x44>
      return 1;
    1232:	b8 01 00 00 00       	mov    $0x1,%eax
    1237:	eb 15                	jmp    124e <match+0x59>
  }while(*text++ != '\0');
    1239:	8b 45 0c             	mov    0xc(%ebp),%eax
    123c:	8d 50 01             	lea    0x1(%eax),%edx
    123f:	89 55 0c             	mov    %edx,0xc(%ebp)
    1242:	0f b6 00             	movzbl (%eax),%eax
    1245:	84 c0                	test   %al,%al
    1247:	75 d3                	jne    121c <match+0x27>
  return 0;
    1249:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124e:	c9                   	leave  
    124f:	c3                   	ret    

00001250 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
    1256:	8b 45 08             	mov    0x8(%ebp),%eax
    1259:	0f b6 00             	movzbl (%eax),%eax
    125c:	84 c0                	test   %al,%al
    125e:	75 0a                	jne    126a <matchhere+0x1a>
    return 1;
    1260:	b8 01 00 00 00       	mov    $0x1,%eax
    1265:	e9 9b 00 00 00       	jmp    1305 <matchhere+0xb5>
  if(re[1] == '*')
    126a:	8b 45 08             	mov    0x8(%ebp),%eax
    126d:	83 c0 01             	add    $0x1,%eax
    1270:	0f b6 00             	movzbl (%eax),%eax
    1273:	3c 2a                	cmp    $0x2a,%al
    1275:	75 24                	jne    129b <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
    1277:	8b 45 08             	mov    0x8(%ebp),%eax
    127a:	8d 48 02             	lea    0x2(%eax),%ecx
    127d:	8b 45 08             	mov    0x8(%ebp),%eax
    1280:	0f b6 00             	movzbl (%eax),%eax
    1283:	0f be c0             	movsbl %al,%eax
    1286:	8b 55 0c             	mov    0xc(%ebp),%edx
    1289:	89 54 24 08          	mov    %edx,0x8(%esp)
    128d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    1291:	89 04 24             	mov    %eax,(%esp)
    1294:	e8 6e 00 00 00       	call   1307 <matchstar>
    1299:	eb 6a                	jmp    1305 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
    129b:	8b 45 08             	mov    0x8(%ebp),%eax
    129e:	0f b6 00             	movzbl (%eax),%eax
    12a1:	3c 24                	cmp    $0x24,%al
    12a3:	75 1d                	jne    12c2 <matchhere+0x72>
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
    12a8:	83 c0 01             	add    $0x1,%eax
    12ab:	0f b6 00             	movzbl (%eax),%eax
    12ae:	84 c0                	test   %al,%al
    12b0:	75 10                	jne    12c2 <matchhere+0x72>
    return *text == '\0';
    12b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12b5:	0f b6 00             	movzbl (%eax),%eax
    12b8:	84 c0                	test   %al,%al
    12ba:	0f 94 c0             	sete   %al
    12bd:	0f b6 c0             	movzbl %al,%eax
    12c0:	eb 43                	jmp    1305 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    12c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c5:	0f b6 00             	movzbl (%eax),%eax
    12c8:	84 c0                	test   %al,%al
    12ca:	74 34                	je     1300 <matchhere+0xb0>
    12cc:	8b 45 08             	mov    0x8(%ebp),%eax
    12cf:	0f b6 00             	movzbl (%eax),%eax
    12d2:	3c 2e                	cmp    $0x2e,%al
    12d4:	74 10                	je     12e6 <matchhere+0x96>
    12d6:	8b 45 08             	mov    0x8(%ebp),%eax
    12d9:	0f b6 10             	movzbl (%eax),%edx
    12dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    12df:	0f b6 00             	movzbl (%eax),%eax
    12e2:	38 c2                	cmp    %al,%dl
    12e4:	75 1a                	jne    1300 <matchhere+0xb0>
    return matchhere(re+1, text+1);
    12e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    12e9:	8d 50 01             	lea    0x1(%eax),%edx
    12ec:	8b 45 08             	mov    0x8(%ebp),%eax
    12ef:	83 c0 01             	add    $0x1,%eax
    12f2:	89 54 24 04          	mov    %edx,0x4(%esp)
    12f6:	89 04 24             	mov    %eax,(%esp)
    12f9:	e8 52 ff ff ff       	call   1250 <matchhere>
    12fe:	eb 05                	jmp    1305 <matchhere+0xb5>
  return 0;
    1300:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1305:	c9                   	leave  
    1306:	c3                   	ret    

00001307 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    1307:	55                   	push   %ebp
    1308:	89 e5                	mov    %esp,%ebp
    130a:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    130d:	8b 45 10             	mov    0x10(%ebp),%eax
    1310:	89 44 24 04          	mov    %eax,0x4(%esp)
    1314:	8b 45 0c             	mov    0xc(%ebp),%eax
    1317:	89 04 24             	mov    %eax,(%esp)
    131a:	e8 31 ff ff ff       	call   1250 <matchhere>
    131f:	85 c0                	test   %eax,%eax
    1321:	74 07                	je     132a <matchstar+0x23>
      return 1;
    1323:	b8 01 00 00 00       	mov    $0x1,%eax
    1328:	eb 29                	jmp    1353 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
    132a:	8b 45 10             	mov    0x10(%ebp),%eax
    132d:	0f b6 00             	movzbl (%eax),%eax
    1330:	84 c0                	test   %al,%al
    1332:	74 1a                	je     134e <matchstar+0x47>
    1334:	8b 45 10             	mov    0x10(%ebp),%eax
    1337:	8d 50 01             	lea    0x1(%eax),%edx
    133a:	89 55 10             	mov    %edx,0x10(%ebp)
    133d:	0f b6 00             	movzbl (%eax),%eax
    1340:	0f be c0             	movsbl %al,%eax
    1343:	3b 45 08             	cmp    0x8(%ebp),%eax
    1346:	74 c5                	je     130d <matchstar+0x6>
    1348:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
    134c:	74 bf                	je     130d <matchstar+0x6>
  return 0;
    134e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1353:	c9                   	leave  
    1354:	c3                   	ret    

00001355 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1355:	55                   	push   %ebp
    1356:	89 e5                	mov    %esp,%ebp
    1358:	57                   	push   %edi
    1359:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    135a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    135d:	8b 55 10             	mov    0x10(%ebp),%edx
    1360:	8b 45 0c             	mov    0xc(%ebp),%eax
    1363:	89 cb                	mov    %ecx,%ebx
    1365:	89 df                	mov    %ebx,%edi
    1367:	89 d1                	mov    %edx,%ecx
    1369:	fc                   	cld    
    136a:	f3 aa                	rep stos %al,%es:(%edi)
    136c:	89 ca                	mov    %ecx,%edx
    136e:	89 fb                	mov    %edi,%ebx
    1370:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1373:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1376:	5b                   	pop    %ebx
    1377:	5f                   	pop    %edi
    1378:	5d                   	pop    %ebp
    1379:	c3                   	ret    

0000137a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    137a:	55                   	push   %ebp
    137b:	89 e5                	mov    %esp,%ebp
    137d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1380:	8b 45 08             	mov    0x8(%ebp),%eax
    1383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1386:	90                   	nop
    1387:	8b 45 08             	mov    0x8(%ebp),%eax
    138a:	8d 50 01             	lea    0x1(%eax),%edx
    138d:	89 55 08             	mov    %edx,0x8(%ebp)
    1390:	8b 55 0c             	mov    0xc(%ebp),%edx
    1393:	8d 4a 01             	lea    0x1(%edx),%ecx
    1396:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1399:	0f b6 12             	movzbl (%edx),%edx
    139c:	88 10                	mov    %dl,(%eax)
    139e:	0f b6 00             	movzbl (%eax),%eax
    13a1:	84 c0                	test   %al,%al
    13a3:	75 e2                	jne    1387 <strcpy+0xd>
    ;
  return os;
    13a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13a8:	c9                   	leave  
    13a9:	c3                   	ret    

000013aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13aa:	55                   	push   %ebp
    13ab:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13ad:	eb 08                	jmp    13b7 <strcmp+0xd>
    p++, q++;
    13af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13b7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ba:	0f b6 00             	movzbl (%eax),%eax
    13bd:	84 c0                	test   %al,%al
    13bf:	74 10                	je     13d1 <strcmp+0x27>
    13c1:	8b 45 08             	mov    0x8(%ebp),%eax
    13c4:	0f b6 10             	movzbl (%eax),%edx
    13c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ca:	0f b6 00             	movzbl (%eax),%eax
    13cd:	38 c2                	cmp    %al,%dl
    13cf:	74 de                	je     13af <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13d1:	8b 45 08             	mov    0x8(%ebp),%eax
    13d4:	0f b6 00             	movzbl (%eax),%eax
    13d7:	0f b6 d0             	movzbl %al,%edx
    13da:	8b 45 0c             	mov    0xc(%ebp),%eax
    13dd:	0f b6 00             	movzbl (%eax),%eax
    13e0:	0f b6 c0             	movzbl %al,%eax
    13e3:	29 c2                	sub    %eax,%edx
    13e5:	89 d0                	mov    %edx,%eax
}
    13e7:	5d                   	pop    %ebp
    13e8:	c3                   	ret    

000013e9 <strlen>:

uint
strlen(char *s)
{
    13e9:	55                   	push   %ebp
    13ea:	89 e5                	mov    %esp,%ebp
    13ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13f6:	eb 04                	jmp    13fc <strlen+0x13>
    13f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    13fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1402:	01 d0                	add    %edx,%eax
    1404:	0f b6 00             	movzbl (%eax),%eax
    1407:	84 c0                	test   %al,%al
    1409:	75 ed                	jne    13f8 <strlen+0xf>
    ;
  return n;
    140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    140e:	c9                   	leave  
    140f:	c3                   	ret    

00001410 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1416:	8b 45 10             	mov    0x10(%ebp),%eax
    1419:	89 44 24 08          	mov    %eax,0x8(%esp)
    141d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1420:	89 44 24 04          	mov    %eax,0x4(%esp)
    1424:	8b 45 08             	mov    0x8(%ebp),%eax
    1427:	89 04 24             	mov    %eax,(%esp)
    142a:	e8 26 ff ff ff       	call   1355 <stosb>
  return dst;
    142f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1432:	c9                   	leave  
    1433:	c3                   	ret    

00001434 <strchr>:

char*
strchr(const char *s, char c)
{
    1434:	55                   	push   %ebp
    1435:	89 e5                	mov    %esp,%ebp
    1437:	83 ec 04             	sub    $0x4,%esp
    143a:	8b 45 0c             	mov    0xc(%ebp),%eax
    143d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1440:	eb 14                	jmp    1456 <strchr+0x22>
    if(*s == c)
    1442:	8b 45 08             	mov    0x8(%ebp),%eax
    1445:	0f b6 00             	movzbl (%eax),%eax
    1448:	3a 45 fc             	cmp    -0x4(%ebp),%al
    144b:	75 05                	jne    1452 <strchr+0x1e>
      return (char*)s;
    144d:	8b 45 08             	mov    0x8(%ebp),%eax
    1450:	eb 13                	jmp    1465 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1452:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1456:	8b 45 08             	mov    0x8(%ebp),%eax
    1459:	0f b6 00             	movzbl (%eax),%eax
    145c:	84 c0                	test   %al,%al
    145e:	75 e2                	jne    1442 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1460:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1465:	c9                   	leave  
    1466:	c3                   	ret    

00001467 <gets>:

char*
gets(char *buf, int max)
{
    1467:	55                   	push   %ebp
    1468:	89 e5                	mov    %esp,%ebp
    146a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    146d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1474:	eb 4c                	jmp    14c2 <gets+0x5b>
    cc = read(0, &c, 1);
    1476:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    147d:	00 
    147e:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1481:	89 44 24 04          	mov    %eax,0x4(%esp)
    1485:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    148c:	e8 54 01 00 00       	call   15e5 <read>
    1491:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1498:	7f 02                	jg     149c <gets+0x35>
      break;
    149a:	eb 31                	jmp    14cd <gets+0x66>
    buf[i++] = c;
    149c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    149f:	8d 50 01             	lea    0x1(%eax),%edx
    14a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14a5:	89 c2                	mov    %eax,%edx
    14a7:	8b 45 08             	mov    0x8(%ebp),%eax
    14aa:	01 c2                	add    %eax,%edx
    14ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b6:	3c 0a                	cmp    $0xa,%al
    14b8:	74 13                	je     14cd <gets+0x66>
    14ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14be:	3c 0d                	cmp    $0xd,%al
    14c0:	74 0b                	je     14cd <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c5:	83 c0 01             	add    $0x1,%eax
    14c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14cb:	7c a9                	jl     1476 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14d0:	8b 45 08             	mov    0x8(%ebp),%eax
    14d3:	01 d0                	add    %edx,%eax
    14d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14db:	c9                   	leave  
    14dc:	c3                   	ret    

000014dd <stat>:

int
stat(char *n, struct stat *st)
{
    14dd:	55                   	push   %ebp
    14de:	89 e5                	mov    %esp,%ebp
    14e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14ea:	00 
    14eb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ee:	89 04 24             	mov    %eax,(%esp)
    14f1:	e8 17 01 00 00       	call   160d <open>
    14f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14fd:	79 07                	jns    1506 <stat+0x29>
    return -1;
    14ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1504:	eb 23                	jmp    1529 <stat+0x4c>
  r = fstat(fd, st);
    1506:	8b 45 0c             	mov    0xc(%ebp),%eax
    1509:	89 44 24 04          	mov    %eax,0x4(%esp)
    150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1510:	89 04 24             	mov    %eax,(%esp)
    1513:	e8 0d 01 00 00       	call   1625 <fstat>
    1518:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151e:	89 04 24             	mov    %eax,(%esp)
    1521:	e8 cf 00 00 00       	call   15f5 <close>
  return r;
    1526:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1529:	c9                   	leave  
    152a:	c3                   	ret    

0000152b <atoi>:

int
atoi(const char *s)
{
    152b:	55                   	push   %ebp
    152c:	89 e5                	mov    %esp,%ebp
    152e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1538:	eb 25                	jmp    155f <atoi+0x34>
    n = n*10 + *s++ - '0';
    153a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    153d:	89 d0                	mov    %edx,%eax
    153f:	c1 e0 02             	shl    $0x2,%eax
    1542:	01 d0                	add    %edx,%eax
    1544:	01 c0                	add    %eax,%eax
    1546:	89 c1                	mov    %eax,%ecx
    1548:	8b 45 08             	mov    0x8(%ebp),%eax
    154b:	8d 50 01             	lea    0x1(%eax),%edx
    154e:	89 55 08             	mov    %edx,0x8(%ebp)
    1551:	0f b6 00             	movzbl (%eax),%eax
    1554:	0f be c0             	movsbl %al,%eax
    1557:	01 c8                	add    %ecx,%eax
    1559:	83 e8 30             	sub    $0x30,%eax
    155c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    155f:	8b 45 08             	mov    0x8(%ebp),%eax
    1562:	0f b6 00             	movzbl (%eax),%eax
    1565:	3c 2f                	cmp    $0x2f,%al
    1567:	7e 0a                	jle    1573 <atoi+0x48>
    1569:	8b 45 08             	mov    0x8(%ebp),%eax
    156c:	0f b6 00             	movzbl (%eax),%eax
    156f:	3c 39                	cmp    $0x39,%al
    1571:	7e c7                	jle    153a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1573:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1576:	c9                   	leave  
    1577:	c3                   	ret    

00001578 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1578:	55                   	push   %ebp
    1579:	89 e5                	mov    %esp,%ebp
    157b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    157e:	8b 45 08             	mov    0x8(%ebp),%eax
    1581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1584:	8b 45 0c             	mov    0xc(%ebp),%eax
    1587:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    158a:	eb 17                	jmp    15a3 <memmove+0x2b>
    *dst++ = *src++;
    158c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    158f:	8d 50 01             	lea    0x1(%eax),%edx
    1592:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1595:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1598:	8d 4a 01             	lea    0x1(%edx),%ecx
    159b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    159e:	0f b6 12             	movzbl (%edx),%edx
    15a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    15a3:	8b 45 10             	mov    0x10(%ebp),%eax
    15a6:	8d 50 ff             	lea    -0x1(%eax),%edx
    15a9:	89 55 10             	mov    %edx,0x10(%ebp)
    15ac:	85 c0                	test   %eax,%eax
    15ae:	7f dc                	jg     158c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    15b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15b3:	c9                   	leave  
    15b4:	c3                   	ret    

000015b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15b5:	b8 01 00 00 00       	mov    $0x1,%eax
    15ba:	cd 40                	int    $0x40
    15bc:	c3                   	ret    

000015bd <cowfork>:
SYSCALL(cowfork)
    15bd:	b8 0f 00 00 00       	mov    $0xf,%eax
    15c2:	cd 40                	int    $0x40
    15c4:	c3                   	ret    

000015c5 <procdump>:
SYSCALL(procdump)
    15c5:	b8 10 00 00 00       	mov    $0x10,%eax
    15ca:	cd 40                	int    $0x40
    15cc:	c3                   	ret    

000015cd <exit>:
SYSCALL(exit)
    15cd:	b8 02 00 00 00       	mov    $0x2,%eax
    15d2:	cd 40                	int    $0x40
    15d4:	c3                   	ret    

000015d5 <wait>:
SYSCALL(wait)
    15d5:	b8 03 00 00 00       	mov    $0x3,%eax
    15da:	cd 40                	int    $0x40
    15dc:	c3                   	ret    

000015dd <pipe>:
SYSCALL(pipe)
    15dd:	b8 04 00 00 00       	mov    $0x4,%eax
    15e2:	cd 40                	int    $0x40
    15e4:	c3                   	ret    

000015e5 <read>:
SYSCALL(read)
    15e5:	b8 05 00 00 00       	mov    $0x5,%eax
    15ea:	cd 40                	int    $0x40
    15ec:	c3                   	ret    

000015ed <write>:
SYSCALL(write)
    15ed:	b8 12 00 00 00       	mov    $0x12,%eax
    15f2:	cd 40                	int    $0x40
    15f4:	c3                   	ret    

000015f5 <close>:
SYSCALL(close)
    15f5:	b8 17 00 00 00       	mov    $0x17,%eax
    15fa:	cd 40                	int    $0x40
    15fc:	c3                   	ret    

000015fd <kill>:
SYSCALL(kill)
    15fd:	b8 06 00 00 00       	mov    $0x6,%eax
    1602:	cd 40                	int    $0x40
    1604:	c3                   	ret    

00001605 <exec>:
SYSCALL(exec)
    1605:	b8 07 00 00 00       	mov    $0x7,%eax
    160a:	cd 40                	int    $0x40
    160c:	c3                   	ret    

0000160d <open>:
SYSCALL(open)
    160d:	b8 11 00 00 00       	mov    $0x11,%eax
    1612:	cd 40                	int    $0x40
    1614:	c3                   	ret    

00001615 <mknod>:
SYSCALL(mknod)
    1615:	b8 13 00 00 00       	mov    $0x13,%eax
    161a:	cd 40                	int    $0x40
    161c:	c3                   	ret    

0000161d <unlink>:
SYSCALL(unlink)
    161d:	b8 14 00 00 00       	mov    $0x14,%eax
    1622:	cd 40                	int    $0x40
    1624:	c3                   	ret    

00001625 <fstat>:
SYSCALL(fstat)
    1625:	b8 08 00 00 00       	mov    $0x8,%eax
    162a:	cd 40                	int    $0x40
    162c:	c3                   	ret    

0000162d <link>:
SYSCALL(link)
    162d:	b8 15 00 00 00       	mov    $0x15,%eax
    1632:	cd 40                	int    $0x40
    1634:	c3                   	ret    

00001635 <mkdir>:
SYSCALL(mkdir)
    1635:	b8 16 00 00 00       	mov    $0x16,%eax
    163a:	cd 40                	int    $0x40
    163c:	c3                   	ret    

0000163d <chdir>:
SYSCALL(chdir)
    163d:	b8 09 00 00 00       	mov    $0x9,%eax
    1642:	cd 40                	int    $0x40
    1644:	c3                   	ret    

00001645 <dup>:
SYSCALL(dup)
    1645:	b8 0a 00 00 00       	mov    $0xa,%eax
    164a:	cd 40                	int    $0x40
    164c:	c3                   	ret    

0000164d <getpid>:
SYSCALL(getpid)
    164d:	b8 0b 00 00 00       	mov    $0xb,%eax
    1652:	cd 40                	int    $0x40
    1654:	c3                   	ret    

00001655 <sbrk>:
SYSCALL(sbrk)
    1655:	b8 0c 00 00 00       	mov    $0xc,%eax
    165a:	cd 40                	int    $0x40
    165c:	c3                   	ret    

0000165d <sleep>:
SYSCALL(sleep)
    165d:	b8 0d 00 00 00       	mov    $0xd,%eax
    1662:	cd 40                	int    $0x40
    1664:	c3                   	ret    

00001665 <uptime>:
SYSCALL(uptime)
    1665:	b8 0e 00 00 00       	mov    $0xe,%eax
    166a:	cd 40                	int    $0x40
    166c:	c3                   	ret    

0000166d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    166d:	55                   	push   %ebp
    166e:	89 e5                	mov    %esp,%ebp
    1670:	83 ec 18             	sub    $0x18,%esp
    1673:	8b 45 0c             	mov    0xc(%ebp),%eax
    1676:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1679:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1680:	00 
    1681:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1684:	89 44 24 04          	mov    %eax,0x4(%esp)
    1688:	8b 45 08             	mov    0x8(%ebp),%eax
    168b:	89 04 24             	mov    %eax,(%esp)
    168e:	e8 5a ff ff ff       	call   15ed <write>
}
    1693:	c9                   	leave  
    1694:	c3                   	ret    

00001695 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1695:	55                   	push   %ebp
    1696:	89 e5                	mov    %esp,%ebp
    1698:	56                   	push   %esi
    1699:	53                   	push   %ebx
    169a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    169d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16a4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16a8:	74 17                	je     16c1 <printint+0x2c>
    16aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16ae:	79 11                	jns    16c1 <printint+0x2c>
    neg = 1;
    16b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16b7:	8b 45 0c             	mov    0xc(%ebp),%eax
    16ba:	f7 d8                	neg    %eax
    16bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16bf:	eb 06                	jmp    16c7 <printint+0x32>
  } else {
    x = xx;
    16c1:	8b 45 0c             	mov    0xc(%ebp),%eax
    16c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16d1:	8d 41 01             	lea    0x1(%ecx),%eax
    16d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16da:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16dd:	ba 00 00 00 00       	mov    $0x0,%edx
    16e2:	f7 f3                	div    %ebx
    16e4:	89 d0                	mov    %edx,%eax
    16e6:	0f b6 80 00 20 00 00 	movzbl 0x2000(%eax),%eax
    16ed:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16f1:	8b 75 10             	mov    0x10(%ebp),%esi
    16f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16f7:	ba 00 00 00 00       	mov    $0x0,%edx
    16fc:	f7 f6                	div    %esi
    16fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1701:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1705:	75 c7                	jne    16ce <printint+0x39>
  if(neg)
    1707:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    170b:	74 10                	je     171d <printint+0x88>
    buf[i++] = '-';
    170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1710:	8d 50 01             	lea    0x1(%eax),%edx
    1713:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1716:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    171b:	eb 1f                	jmp    173c <printint+0xa7>
    171d:	eb 1d                	jmp    173c <printint+0xa7>
    putc(fd, buf[i]);
    171f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1722:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1725:	01 d0                	add    %edx,%eax
    1727:	0f b6 00             	movzbl (%eax),%eax
    172a:	0f be c0             	movsbl %al,%eax
    172d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1731:	8b 45 08             	mov    0x8(%ebp),%eax
    1734:	89 04 24             	mov    %eax,(%esp)
    1737:	e8 31 ff ff ff       	call   166d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    173c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1744:	79 d9                	jns    171f <printint+0x8a>
    putc(fd, buf[i]);
}
    1746:	83 c4 30             	add    $0x30,%esp
    1749:	5b                   	pop    %ebx
    174a:	5e                   	pop    %esi
    174b:	5d                   	pop    %ebp
    174c:	c3                   	ret    

0000174d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    174d:	55                   	push   %ebp
    174e:	89 e5                	mov    %esp,%ebp
    1750:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1753:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    175a:	8d 45 0c             	lea    0xc(%ebp),%eax
    175d:	83 c0 04             	add    $0x4,%eax
    1760:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    176a:	e9 7c 01 00 00       	jmp    18eb <printf+0x19e>
    c = fmt[i] & 0xff;
    176f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1772:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1775:	01 d0                	add    %edx,%eax
    1777:	0f b6 00             	movzbl (%eax),%eax
    177a:	0f be c0             	movsbl %al,%eax
    177d:	25 ff 00 00 00       	and    $0xff,%eax
    1782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1785:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1789:	75 2c                	jne    17b7 <printf+0x6a>
      if(c == '%'){
    178b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    178f:	75 0c                	jne    179d <printf+0x50>
        state = '%';
    1791:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1798:	e9 4a 01 00 00       	jmp    18e7 <printf+0x19a>
      } else {
        putc(fd, c);
    179d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17a0:	0f be c0             	movsbl %al,%eax
    17a3:	89 44 24 04          	mov    %eax,0x4(%esp)
    17a7:	8b 45 08             	mov    0x8(%ebp),%eax
    17aa:	89 04 24             	mov    %eax,(%esp)
    17ad:	e8 bb fe ff ff       	call   166d <putc>
    17b2:	e9 30 01 00 00       	jmp    18e7 <printf+0x19a>
      }
    } else if(state == '%'){
    17b7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17bb:	0f 85 26 01 00 00    	jne    18e7 <printf+0x19a>
      if(c == 'd'){
    17c1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17c5:	75 2d                	jne    17f4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17ca:	8b 00                	mov    (%eax),%eax
    17cc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17d3:	00 
    17d4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17db:	00 
    17dc:	89 44 24 04          	mov    %eax,0x4(%esp)
    17e0:	8b 45 08             	mov    0x8(%ebp),%eax
    17e3:	89 04 24             	mov    %eax,(%esp)
    17e6:	e8 aa fe ff ff       	call   1695 <printint>
        ap++;
    17eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17ef:	e9 ec 00 00 00       	jmp    18e0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    17f4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17f8:	74 06                	je     1800 <printf+0xb3>
    17fa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17fe:	75 2d                	jne    182d <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1800:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1803:	8b 00                	mov    (%eax),%eax
    1805:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    180c:	00 
    180d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1814:	00 
    1815:	89 44 24 04          	mov    %eax,0x4(%esp)
    1819:	8b 45 08             	mov    0x8(%ebp),%eax
    181c:	89 04 24             	mov    %eax,(%esp)
    181f:	e8 71 fe ff ff       	call   1695 <printint>
        ap++;
    1824:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1828:	e9 b3 00 00 00       	jmp    18e0 <printf+0x193>
      } else if(c == 's'){
    182d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1831:	75 45                	jne    1878 <printf+0x12b>
        s = (char*)*ap;
    1833:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1836:	8b 00                	mov    (%eax),%eax
    1838:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    183b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    183f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1843:	75 09                	jne    184e <printf+0x101>
          s = "(null)";
    1845:	c7 45 f4 52 1b 00 00 	movl   $0x1b52,-0xc(%ebp)
        while(*s != 0){
    184c:	eb 1e                	jmp    186c <printf+0x11f>
    184e:	eb 1c                	jmp    186c <printf+0x11f>
          putc(fd, *s);
    1850:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1853:	0f b6 00             	movzbl (%eax),%eax
    1856:	0f be c0             	movsbl %al,%eax
    1859:	89 44 24 04          	mov    %eax,0x4(%esp)
    185d:	8b 45 08             	mov    0x8(%ebp),%eax
    1860:	89 04 24             	mov    %eax,(%esp)
    1863:	e8 05 fe ff ff       	call   166d <putc>
          s++;
    1868:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186f:	0f b6 00             	movzbl (%eax),%eax
    1872:	84 c0                	test   %al,%al
    1874:	75 da                	jne    1850 <printf+0x103>
    1876:	eb 68                	jmp    18e0 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1878:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    187c:	75 1d                	jne    189b <printf+0x14e>
        putc(fd, *ap);
    187e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1881:	8b 00                	mov    (%eax),%eax
    1883:	0f be c0             	movsbl %al,%eax
    1886:	89 44 24 04          	mov    %eax,0x4(%esp)
    188a:	8b 45 08             	mov    0x8(%ebp),%eax
    188d:	89 04 24             	mov    %eax,(%esp)
    1890:	e8 d8 fd ff ff       	call   166d <putc>
        ap++;
    1895:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1899:	eb 45                	jmp    18e0 <printf+0x193>
      } else if(c == '%'){
    189b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    189f:	75 17                	jne    18b8 <printf+0x16b>
        putc(fd, c);
    18a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18a4:	0f be c0             	movsbl %al,%eax
    18a7:	89 44 24 04          	mov    %eax,0x4(%esp)
    18ab:	8b 45 08             	mov    0x8(%ebp),%eax
    18ae:	89 04 24             	mov    %eax,(%esp)
    18b1:	e8 b7 fd ff ff       	call   166d <putc>
    18b6:	eb 28                	jmp    18e0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18b8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18bf:	00 
    18c0:	8b 45 08             	mov    0x8(%ebp),%eax
    18c3:	89 04 24             	mov    %eax,(%esp)
    18c6:	e8 a2 fd ff ff       	call   166d <putc>
        putc(fd, c);
    18cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18ce:	0f be c0             	movsbl %al,%eax
    18d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    18d5:	8b 45 08             	mov    0x8(%ebp),%eax
    18d8:	89 04 24             	mov    %eax,(%esp)
    18db:	e8 8d fd ff ff       	call   166d <putc>
      }
      state = 0;
    18e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    18eb:	8b 55 0c             	mov    0xc(%ebp),%edx
    18ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18f1:	01 d0                	add    %edx,%eax
    18f3:	0f b6 00             	movzbl (%eax),%eax
    18f6:	84 c0                	test   %al,%al
    18f8:	0f 85 71 fe ff ff    	jne    176f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18fe:	c9                   	leave  
    18ff:	c3                   	ret    

00001900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1900:	55                   	push   %ebp
    1901:	89 e5                	mov    %esp,%ebp
    1903:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1906:	8b 45 08             	mov    0x8(%ebp),%eax
    1909:	83 e8 08             	sub    $0x8,%eax
    190c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    190f:	a1 28 20 00 00       	mov    0x2028,%eax
    1914:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1917:	eb 24                	jmp    193d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1919:	8b 45 fc             	mov    -0x4(%ebp),%eax
    191c:	8b 00                	mov    (%eax),%eax
    191e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1921:	77 12                	ja     1935 <free+0x35>
    1923:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1926:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1929:	77 24                	ja     194f <free+0x4f>
    192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    192e:	8b 00                	mov    (%eax),%eax
    1930:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1933:	77 1a                	ja     194f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1935:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1938:	8b 00                	mov    (%eax),%eax
    193a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    193d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1940:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1943:	76 d4                	jbe    1919 <free+0x19>
    1945:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1948:	8b 00                	mov    (%eax),%eax
    194a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    194d:	76 ca                	jbe    1919 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    194f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1952:	8b 40 04             	mov    0x4(%eax),%eax
    1955:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    195c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    195f:	01 c2                	add    %eax,%edx
    1961:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1964:	8b 00                	mov    (%eax),%eax
    1966:	39 c2                	cmp    %eax,%edx
    1968:	75 24                	jne    198e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    196a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    196d:	8b 50 04             	mov    0x4(%eax),%edx
    1970:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1973:	8b 00                	mov    (%eax),%eax
    1975:	8b 40 04             	mov    0x4(%eax),%eax
    1978:	01 c2                	add    %eax,%edx
    197a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    197d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1980:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1983:	8b 00                	mov    (%eax),%eax
    1985:	8b 10                	mov    (%eax),%edx
    1987:	8b 45 f8             	mov    -0x8(%ebp),%eax
    198a:	89 10                	mov    %edx,(%eax)
    198c:	eb 0a                	jmp    1998 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1991:	8b 10                	mov    (%eax),%edx
    1993:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1996:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1998:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199b:	8b 40 04             	mov    0x4(%eax),%eax
    199e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a8:	01 d0                	add    %edx,%eax
    19aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19ad:	75 20                	jne    19cf <free+0xcf>
    p->s.size += bp->s.size;
    19af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b2:	8b 50 04             	mov    0x4(%eax),%edx
    19b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19b8:	8b 40 04             	mov    0x4(%eax),%eax
    19bb:	01 c2                	add    %eax,%edx
    19bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19c6:	8b 10                	mov    (%eax),%edx
    19c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19cb:	89 10                	mov    %edx,(%eax)
    19cd:	eb 08                	jmp    19d7 <free+0xd7>
  } else
    p->s.ptr = bp;
    19cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19d5:	89 10                	mov    %edx,(%eax)
  freep = p;
    19d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19da:	a3 28 20 00 00       	mov    %eax,0x2028
}
    19df:	c9                   	leave  
    19e0:	c3                   	ret    

000019e1 <morecore>:

static Header*
morecore(uint nu)
{
    19e1:	55                   	push   %ebp
    19e2:	89 e5                	mov    %esp,%ebp
    19e4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19e7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19ee:	77 07                	ja     19f7 <morecore+0x16>
    nu = 4096;
    19f0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19f7:	8b 45 08             	mov    0x8(%ebp),%eax
    19fa:	c1 e0 03             	shl    $0x3,%eax
    19fd:	89 04 24             	mov    %eax,(%esp)
    1a00:	e8 50 fc ff ff       	call   1655 <sbrk>
    1a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a08:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a0c:	75 07                	jne    1a15 <morecore+0x34>
    return 0;
    1a0e:	b8 00 00 00 00       	mov    $0x0,%eax
    1a13:	eb 22                	jmp    1a37 <morecore+0x56>
  hp = (Header*)p;
    1a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a1e:	8b 55 08             	mov    0x8(%ebp),%edx
    1a21:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a27:	83 c0 08             	add    $0x8,%eax
    1a2a:	89 04 24             	mov    %eax,(%esp)
    1a2d:	e8 ce fe ff ff       	call   1900 <free>
  return freep;
    1a32:	a1 28 20 00 00       	mov    0x2028,%eax
}
    1a37:	c9                   	leave  
    1a38:	c3                   	ret    

00001a39 <malloc>:

void*
malloc(uint nbytes)
{
    1a39:	55                   	push   %ebp
    1a3a:	89 e5                	mov    %esp,%ebp
    1a3c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a3f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a42:	83 c0 07             	add    $0x7,%eax
    1a45:	c1 e8 03             	shr    $0x3,%eax
    1a48:	83 c0 01             	add    $0x1,%eax
    1a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a4e:	a1 28 20 00 00       	mov    0x2028,%eax
    1a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a5a:	75 23                	jne    1a7f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a5c:	c7 45 f0 20 20 00 00 	movl   $0x2020,-0x10(%ebp)
    1a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a66:	a3 28 20 00 00       	mov    %eax,0x2028
    1a6b:	a1 28 20 00 00       	mov    0x2028,%eax
    1a70:	a3 20 20 00 00       	mov    %eax,0x2020
    base.s.size = 0;
    1a75:	c7 05 24 20 00 00 00 	movl   $0x0,0x2024
    1a7c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a82:	8b 00                	mov    (%eax),%eax
    1a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a8a:	8b 40 04             	mov    0x4(%eax),%eax
    1a8d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a90:	72 4d                	jb     1adf <malloc+0xa6>
      if(p->s.size == nunits)
    1a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a95:	8b 40 04             	mov    0x4(%eax),%eax
    1a98:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a9b:	75 0c                	jne    1aa9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa0:	8b 10                	mov    (%eax),%edx
    1aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aa5:	89 10                	mov    %edx,(%eax)
    1aa7:	eb 26                	jmp    1acf <malloc+0x96>
      else {
        p->s.size -= nunits;
    1aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aac:	8b 40 04             	mov    0x4(%eax),%eax
    1aaf:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ab2:	89 c2                	mov    %eax,%edx
    1ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abd:	8b 40 04             	mov    0x4(%eax),%eax
    1ac0:	c1 e0 03             	shl    $0x3,%eax
    1ac3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1acc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ad2:	a3 28 20 00 00       	mov    %eax,0x2028
      return (void*)(p + 1);
    1ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ada:	83 c0 08             	add    $0x8,%eax
    1add:	eb 38                	jmp    1b17 <malloc+0xde>
    }
    if(p == freep)
    1adf:	a1 28 20 00 00       	mov    0x2028,%eax
    1ae4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1ae7:	75 1b                	jne    1b04 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1aec:	89 04 24             	mov    %eax,(%esp)
    1aef:	e8 ed fe ff ff       	call   19e1 <morecore>
    1af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1afb:	75 07                	jne    1b04 <malloc+0xcb>
        return 0;
    1afd:	b8 00 00 00 00       	mov    $0x0,%eax
    1b02:	eb 13                	jmp    1b17 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b0d:	8b 00                	mov    (%eax),%eax
    1b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b12:	e9 70 ff ff ff       	jmp    1a87 <malloc+0x4e>
}
    1b17:	c9                   	leave  
    1b18:	c3                   	ret    
