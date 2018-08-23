
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1006:	eb 1b                	jmp    1023 <cat+0x23>
    write(1, buf, n);
    1008:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100b:	89 44 24 08          	mov    %eax,0x8(%esp)
    100f:	c7 44 24 04 c0 2b 00 	movl   $0x2bc0,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    101e:	e8 92 03 00 00       	call   13b5 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1023:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    102a:	00 
    102b:	c7 44 24 04 c0 2b 00 	movl   $0x2bc0,0x4(%esp)
    1032:	00 
    1033:	8b 45 08             	mov    0x8(%ebp),%eax
    1036:	89 04 24             	mov    %eax,(%esp)
    1039:	e8 6f 03 00 00       	call   13ad <read>
    103e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1045:	7f c1                	jg     1008 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
    1047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    104b:	79 19                	jns    1066 <cat+0x66>
    printf(1, "cat: read error\n");
    104d:	c7 44 24 04 e1 18 00 	movl   $0x18e1,0x4(%esp)
    1054:	00 
    1055:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    105c:	e8 b4 04 00 00       	call   1515 <printf>
    exit();
    1061:	e8 2f 03 00 00       	call   1395 <exit>
  }
}
    1066:	c9                   	leave  
    1067:	c3                   	ret    

00001068 <main>:

int
main(int argc, char *argv[])
{
    1068:	55                   	push   %ebp
    1069:	89 e5                	mov    %esp,%ebp
    106b:	83 e4 f0             	and    $0xfffffff0,%esp
    106e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    1071:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1075:	7f 11                	jg     1088 <main+0x20>
    cat(0);
    1077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    107e:	e8 7d ff ff ff       	call   1000 <cat>
    exit();
    1083:	e8 0d 03 00 00       	call   1395 <exit>
  }

  for(i = 1; i < argc; i++){
    1088:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    108f:	00 
    1090:	eb 79                	jmp    110b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
    1092:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1096:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    109d:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a0:	01 d0                	add    %edx,%eax
    10a2:	8b 00                	mov    (%eax),%eax
    10a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10ab:	00 
    10ac:	89 04 24             	mov    %eax,(%esp)
    10af:	e8 21 03 00 00       	call   13d5 <open>
    10b4:	89 44 24 18          	mov    %eax,0x18(%esp)
    10b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10bd:	79 2f                	jns    10ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
    10bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cd:	01 d0                	add    %edx,%eax
    10cf:	8b 00                	mov    (%eax),%eax
    10d1:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d5:	c7 44 24 04 f2 18 00 	movl   $0x18f2,0x4(%esp)
    10dc:	00 
    10dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e4:	e8 2c 04 00 00       	call   1515 <printf>
      exit();
    10e9:	e8 a7 02 00 00       	call   1395 <exit>
    }
    cat(fd);
    10ee:	8b 44 24 18          	mov    0x18(%esp),%eax
    10f2:	89 04 24             	mov    %eax,(%esp)
    10f5:	e8 06 ff ff ff       	call   1000 <cat>
    close(fd);
    10fa:	8b 44 24 18          	mov    0x18(%esp),%eax
    10fe:	89 04 24             	mov    %eax,(%esp)
    1101:	e8 b7 02 00 00       	call   13bd <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    1106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    110b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    110f:	3b 45 08             	cmp    0x8(%ebp),%eax
    1112:	0f 8c 7a ff ff ff    	jl     1092 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
    1118:	e8 78 02 00 00       	call   1395 <exit>

0000111d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    111d:	55                   	push   %ebp
    111e:	89 e5                	mov    %esp,%ebp
    1120:	57                   	push   %edi
    1121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1122:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1125:	8b 55 10             	mov    0x10(%ebp),%edx
    1128:	8b 45 0c             	mov    0xc(%ebp),%eax
    112b:	89 cb                	mov    %ecx,%ebx
    112d:	89 df                	mov    %ebx,%edi
    112f:	89 d1                	mov    %edx,%ecx
    1131:	fc                   	cld    
    1132:	f3 aa                	rep stos %al,%es:(%edi)
    1134:	89 ca                	mov    %ecx,%edx
    1136:	89 fb                	mov    %edi,%ebx
    1138:	89 5d 08             	mov    %ebx,0x8(%ebp)
    113b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    113e:	5b                   	pop    %ebx
    113f:	5f                   	pop    %edi
    1140:	5d                   	pop    %ebp
    1141:	c3                   	ret    

00001142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1142:	55                   	push   %ebp
    1143:	89 e5                	mov    %esp,%ebp
    1145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    114e:	90                   	nop
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
    1152:	8d 50 01             	lea    0x1(%eax),%edx
    1155:	89 55 08             	mov    %edx,0x8(%ebp)
    1158:	8b 55 0c             	mov    0xc(%ebp),%edx
    115b:	8d 4a 01             	lea    0x1(%edx),%ecx
    115e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1161:	0f b6 12             	movzbl (%edx),%edx
    1164:	88 10                	mov    %dl,(%eax)
    1166:	0f b6 00             	movzbl (%eax),%eax
    1169:	84 c0                	test   %al,%al
    116b:	75 e2                	jne    114f <strcpy+0xd>
    ;
  return os;
    116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1170:	c9                   	leave  
    1171:	c3                   	ret    

00001172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1172:	55                   	push   %ebp
    1173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1175:	eb 08                	jmp    117f <strcmp+0xd>
    p++, q++;
    1177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    117b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    117f:	8b 45 08             	mov    0x8(%ebp),%eax
    1182:	0f b6 00             	movzbl (%eax),%eax
    1185:	84 c0                	test   %al,%al
    1187:	74 10                	je     1199 <strcmp+0x27>
    1189:	8b 45 08             	mov    0x8(%ebp),%eax
    118c:	0f b6 10             	movzbl (%eax),%edx
    118f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1192:	0f b6 00             	movzbl (%eax),%eax
    1195:	38 c2                	cmp    %al,%dl
    1197:	74 de                	je     1177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1199:	8b 45 08             	mov    0x8(%ebp),%eax
    119c:	0f b6 00             	movzbl (%eax),%eax
    119f:	0f b6 d0             	movzbl %al,%edx
    11a2:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a5:	0f b6 00             	movzbl (%eax),%eax
    11a8:	0f b6 c0             	movzbl %al,%eax
    11ab:	29 c2                	sub    %eax,%edx
    11ad:	89 d0                	mov    %edx,%eax
}
    11af:	5d                   	pop    %ebp
    11b0:	c3                   	ret    

000011b1 <strlen>:

uint
strlen(char *s)
{
    11b1:	55                   	push   %ebp
    11b2:	89 e5                	mov    %esp,%ebp
    11b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11be:	eb 04                	jmp    11c4 <strlen+0x13>
    11c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11c7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ca:	01 d0                	add    %edx,%eax
    11cc:	0f b6 00             	movzbl (%eax),%eax
    11cf:	84 c0                	test   %al,%al
    11d1:	75 ed                	jne    11c0 <strlen+0xf>
    ;
  return n;
    11d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11d6:	c9                   	leave  
    11d7:	c3                   	ret    

000011d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11d8:	55                   	push   %ebp
    11d9:	89 e5                	mov    %esp,%ebp
    11db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11de:	8b 45 10             	mov    0x10(%ebp),%eax
    11e1:	89 44 24 08          	mov    %eax,0x8(%esp)
    11e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ec:	8b 45 08             	mov    0x8(%ebp),%eax
    11ef:	89 04 24             	mov    %eax,(%esp)
    11f2:	e8 26 ff ff ff       	call   111d <stosb>
  return dst;
    11f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11fa:	c9                   	leave  
    11fb:	c3                   	ret    

000011fc <strchr>:

char*
strchr(const char *s, char c)
{
    11fc:	55                   	push   %ebp
    11fd:	89 e5                	mov    %esp,%ebp
    11ff:	83 ec 04             	sub    $0x4,%esp
    1202:	8b 45 0c             	mov    0xc(%ebp),%eax
    1205:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1208:	eb 14                	jmp    121e <strchr+0x22>
    if(*s == c)
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	0f b6 00             	movzbl (%eax),%eax
    1210:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1213:	75 05                	jne    121a <strchr+0x1e>
      return (char*)s;
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
    1218:	eb 13                	jmp    122d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    121a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    121e:	8b 45 08             	mov    0x8(%ebp),%eax
    1221:	0f b6 00             	movzbl (%eax),%eax
    1224:	84 c0                	test   %al,%al
    1226:	75 e2                	jne    120a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1228:	b8 00 00 00 00       	mov    $0x0,%eax
}
    122d:	c9                   	leave  
    122e:	c3                   	ret    

0000122f <gets>:

char*
gets(char *buf, int max)
{
    122f:	55                   	push   %ebp
    1230:	89 e5                	mov    %esp,%ebp
    1232:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    123c:	eb 4c                	jmp    128a <gets+0x5b>
    cc = read(0, &c, 1);
    123e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1245:	00 
    1246:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1249:	89 44 24 04          	mov    %eax,0x4(%esp)
    124d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1254:	e8 54 01 00 00       	call   13ad <read>
    1259:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    125c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1260:	7f 02                	jg     1264 <gets+0x35>
      break;
    1262:	eb 31                	jmp    1295 <gets+0x66>
    buf[i++] = c;
    1264:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1267:	8d 50 01             	lea    0x1(%eax),%edx
    126a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    126d:	89 c2                	mov    %eax,%edx
    126f:	8b 45 08             	mov    0x8(%ebp),%eax
    1272:	01 c2                	add    %eax,%edx
    1274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1278:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    127a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    127e:	3c 0a                	cmp    $0xa,%al
    1280:	74 13                	je     1295 <gets+0x66>
    1282:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1286:	3c 0d                	cmp    $0xd,%al
    1288:	74 0b                	je     1295 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    128a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128d:	83 c0 01             	add    $0x1,%eax
    1290:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1293:	7c a9                	jl     123e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1295:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1298:	8b 45 08             	mov    0x8(%ebp),%eax
    129b:	01 d0                	add    %edx,%eax
    129d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12a3:	c9                   	leave  
    12a4:	c3                   	ret    

000012a5 <stat>:

int
stat(char *n, struct stat *st)
{
    12a5:	55                   	push   %ebp
    12a6:	89 e5                	mov    %esp,%ebp
    12a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12b2:	00 
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
    12b6:	89 04 24             	mov    %eax,(%esp)
    12b9:	e8 17 01 00 00       	call   13d5 <open>
    12be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12c5:	79 07                	jns    12ce <stat+0x29>
    return -1;
    12c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12cc:	eb 23                	jmp    12f1 <stat+0x4c>
  r = fstat(fd, st);
    12ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    12d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	e8 0d 01 00 00       	call   13ed <fstat>
    12e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12e6:	89 04 24             	mov    %eax,(%esp)
    12e9:	e8 cf 00 00 00       	call   13bd <close>
  return r;
    12ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12f1:	c9                   	leave  
    12f2:	c3                   	ret    

000012f3 <atoi>:

int
atoi(const char *s)
{
    12f3:	55                   	push   %ebp
    12f4:	89 e5                	mov    %esp,%ebp
    12f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1300:	eb 25                	jmp    1327 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1302:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1305:	89 d0                	mov    %edx,%eax
    1307:	c1 e0 02             	shl    $0x2,%eax
    130a:	01 d0                	add    %edx,%eax
    130c:	01 c0                	add    %eax,%eax
    130e:	89 c1                	mov    %eax,%ecx
    1310:	8b 45 08             	mov    0x8(%ebp),%eax
    1313:	8d 50 01             	lea    0x1(%eax),%edx
    1316:	89 55 08             	mov    %edx,0x8(%ebp)
    1319:	0f b6 00             	movzbl (%eax),%eax
    131c:	0f be c0             	movsbl %al,%eax
    131f:	01 c8                	add    %ecx,%eax
    1321:	83 e8 30             	sub    $0x30,%eax
    1324:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1327:	8b 45 08             	mov    0x8(%ebp),%eax
    132a:	0f b6 00             	movzbl (%eax),%eax
    132d:	3c 2f                	cmp    $0x2f,%al
    132f:	7e 0a                	jle    133b <atoi+0x48>
    1331:	8b 45 08             	mov    0x8(%ebp),%eax
    1334:	0f b6 00             	movzbl (%eax),%eax
    1337:	3c 39                	cmp    $0x39,%al
    1339:	7e c7                	jle    1302 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    133e:	c9                   	leave  
    133f:	c3                   	ret    

00001340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1346:	8b 45 08             	mov    0x8(%ebp),%eax
    1349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    134c:	8b 45 0c             	mov    0xc(%ebp),%eax
    134f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1352:	eb 17                	jmp    136b <memmove+0x2b>
    *dst++ = *src++;
    1354:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1357:	8d 50 01             	lea    0x1(%eax),%edx
    135a:	89 55 fc             	mov    %edx,-0x4(%ebp)
    135d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1360:	8d 4a 01             	lea    0x1(%edx),%ecx
    1363:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1366:	0f b6 12             	movzbl (%edx),%edx
    1369:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    136b:	8b 45 10             	mov    0x10(%ebp),%eax
    136e:	8d 50 ff             	lea    -0x1(%eax),%edx
    1371:	89 55 10             	mov    %edx,0x10(%ebp)
    1374:	85 c0                	test   %eax,%eax
    1376:	7f dc                	jg     1354 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1378:	8b 45 08             	mov    0x8(%ebp),%eax
}
    137b:	c9                   	leave  
    137c:	c3                   	ret    

0000137d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    137d:	b8 01 00 00 00       	mov    $0x1,%eax
    1382:	cd 40                	int    $0x40
    1384:	c3                   	ret    

00001385 <cowfork>:
SYSCALL(cowfork)
    1385:	b8 0f 00 00 00       	mov    $0xf,%eax
    138a:	cd 40                	int    $0x40
    138c:	c3                   	ret    

0000138d <procdump>:
SYSCALL(procdump)
    138d:	b8 10 00 00 00       	mov    $0x10,%eax
    1392:	cd 40                	int    $0x40
    1394:	c3                   	ret    

00001395 <exit>:
SYSCALL(exit)
    1395:	b8 02 00 00 00       	mov    $0x2,%eax
    139a:	cd 40                	int    $0x40
    139c:	c3                   	ret    

0000139d <wait>:
SYSCALL(wait)
    139d:	b8 03 00 00 00       	mov    $0x3,%eax
    13a2:	cd 40                	int    $0x40
    13a4:	c3                   	ret    

000013a5 <pipe>:
SYSCALL(pipe)
    13a5:	b8 04 00 00 00       	mov    $0x4,%eax
    13aa:	cd 40                	int    $0x40
    13ac:	c3                   	ret    

000013ad <read>:
SYSCALL(read)
    13ad:	b8 05 00 00 00       	mov    $0x5,%eax
    13b2:	cd 40                	int    $0x40
    13b4:	c3                   	ret    

000013b5 <write>:
SYSCALL(write)
    13b5:	b8 12 00 00 00       	mov    $0x12,%eax
    13ba:	cd 40                	int    $0x40
    13bc:	c3                   	ret    

000013bd <close>:
SYSCALL(close)
    13bd:	b8 17 00 00 00       	mov    $0x17,%eax
    13c2:	cd 40                	int    $0x40
    13c4:	c3                   	ret    

000013c5 <kill>:
SYSCALL(kill)
    13c5:	b8 06 00 00 00       	mov    $0x6,%eax
    13ca:	cd 40                	int    $0x40
    13cc:	c3                   	ret    

000013cd <exec>:
SYSCALL(exec)
    13cd:	b8 07 00 00 00       	mov    $0x7,%eax
    13d2:	cd 40                	int    $0x40
    13d4:	c3                   	ret    

000013d5 <open>:
SYSCALL(open)
    13d5:	b8 11 00 00 00       	mov    $0x11,%eax
    13da:	cd 40                	int    $0x40
    13dc:	c3                   	ret    

000013dd <mknod>:
SYSCALL(mknod)
    13dd:	b8 13 00 00 00       	mov    $0x13,%eax
    13e2:	cd 40                	int    $0x40
    13e4:	c3                   	ret    

000013e5 <unlink>:
SYSCALL(unlink)
    13e5:	b8 14 00 00 00       	mov    $0x14,%eax
    13ea:	cd 40                	int    $0x40
    13ec:	c3                   	ret    

000013ed <fstat>:
SYSCALL(fstat)
    13ed:	b8 08 00 00 00       	mov    $0x8,%eax
    13f2:	cd 40                	int    $0x40
    13f4:	c3                   	ret    

000013f5 <link>:
SYSCALL(link)
    13f5:	b8 15 00 00 00       	mov    $0x15,%eax
    13fa:	cd 40                	int    $0x40
    13fc:	c3                   	ret    

000013fd <mkdir>:
SYSCALL(mkdir)
    13fd:	b8 16 00 00 00       	mov    $0x16,%eax
    1402:	cd 40                	int    $0x40
    1404:	c3                   	ret    

00001405 <chdir>:
SYSCALL(chdir)
    1405:	b8 09 00 00 00       	mov    $0x9,%eax
    140a:	cd 40                	int    $0x40
    140c:	c3                   	ret    

0000140d <dup>:
SYSCALL(dup)
    140d:	b8 0a 00 00 00       	mov    $0xa,%eax
    1412:	cd 40                	int    $0x40
    1414:	c3                   	ret    

00001415 <getpid>:
SYSCALL(getpid)
    1415:	b8 0b 00 00 00       	mov    $0xb,%eax
    141a:	cd 40                	int    $0x40
    141c:	c3                   	ret    

0000141d <sbrk>:
SYSCALL(sbrk)
    141d:	b8 0c 00 00 00       	mov    $0xc,%eax
    1422:	cd 40                	int    $0x40
    1424:	c3                   	ret    

00001425 <sleep>:
SYSCALL(sleep)
    1425:	b8 0d 00 00 00       	mov    $0xd,%eax
    142a:	cd 40                	int    $0x40
    142c:	c3                   	ret    

0000142d <uptime>:
SYSCALL(uptime)
    142d:	b8 0e 00 00 00       	mov    $0xe,%eax
    1432:	cd 40                	int    $0x40
    1434:	c3                   	ret    

00001435 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1435:	55                   	push   %ebp
    1436:	89 e5                	mov    %esp,%ebp
    1438:	83 ec 18             	sub    $0x18,%esp
    143b:	8b 45 0c             	mov    0xc(%ebp),%eax
    143e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1441:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1448:	00 
    1449:	8d 45 f4             	lea    -0xc(%ebp),%eax
    144c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1450:	8b 45 08             	mov    0x8(%ebp),%eax
    1453:	89 04 24             	mov    %eax,(%esp)
    1456:	e8 5a ff ff ff       	call   13b5 <write>
}
    145b:	c9                   	leave  
    145c:	c3                   	ret    

0000145d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    145d:	55                   	push   %ebp
    145e:	89 e5                	mov    %esp,%ebp
    1460:	56                   	push   %esi
    1461:	53                   	push   %ebx
    1462:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1465:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    146c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1470:	74 17                	je     1489 <printint+0x2c>
    1472:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1476:	79 11                	jns    1489 <printint+0x2c>
    neg = 1;
    1478:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    147f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1482:	f7 d8                	neg    %eax
    1484:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1487:	eb 06                	jmp    148f <printint+0x32>
  } else {
    x = xx;
    1489:	8b 45 0c             	mov    0xc(%ebp),%eax
    148c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    148f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1496:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1499:	8d 41 01             	lea    0x1(%ecx),%eax
    149c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    149f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14a5:	ba 00 00 00 00       	mov    $0x0,%edx
    14aa:	f7 f3                	div    %ebx
    14ac:	89 d0                	mov    %edx,%eax
    14ae:	0f b6 80 74 2b 00 00 	movzbl 0x2b74(%eax),%eax
    14b5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14b9:	8b 75 10             	mov    0x10(%ebp),%esi
    14bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14bf:	ba 00 00 00 00       	mov    $0x0,%edx
    14c4:	f7 f6                	div    %esi
    14c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14cd:	75 c7                	jne    1496 <printint+0x39>
  if(neg)
    14cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14d3:	74 10                	je     14e5 <printint+0x88>
    buf[i++] = '-';
    14d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d8:	8d 50 01             	lea    0x1(%eax),%edx
    14db:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14de:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14e3:	eb 1f                	jmp    1504 <printint+0xa7>
    14e5:	eb 1d                	jmp    1504 <printint+0xa7>
    putc(fd, buf[i]);
    14e7:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ed:	01 d0                	add    %edx,%eax
    14ef:	0f b6 00             	movzbl (%eax),%eax
    14f2:	0f be c0             	movsbl %al,%eax
    14f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f9:	8b 45 08             	mov    0x8(%ebp),%eax
    14fc:	89 04 24             	mov    %eax,(%esp)
    14ff:	e8 31 ff ff ff       	call   1435 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1504:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    150c:	79 d9                	jns    14e7 <printint+0x8a>
    putc(fd, buf[i]);
}
    150e:	83 c4 30             	add    $0x30,%esp
    1511:	5b                   	pop    %ebx
    1512:	5e                   	pop    %esi
    1513:	5d                   	pop    %ebp
    1514:	c3                   	ret    

00001515 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1515:	55                   	push   %ebp
    1516:	89 e5                	mov    %esp,%ebp
    1518:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    151b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1522:	8d 45 0c             	lea    0xc(%ebp),%eax
    1525:	83 c0 04             	add    $0x4,%eax
    1528:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    152b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1532:	e9 7c 01 00 00       	jmp    16b3 <printf+0x19e>
    c = fmt[i] & 0xff;
    1537:	8b 55 0c             	mov    0xc(%ebp),%edx
    153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    153d:	01 d0                	add    %edx,%eax
    153f:	0f b6 00             	movzbl (%eax),%eax
    1542:	0f be c0             	movsbl %al,%eax
    1545:	25 ff 00 00 00       	and    $0xff,%eax
    154a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    154d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1551:	75 2c                	jne    157f <printf+0x6a>
      if(c == '%'){
    1553:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1557:	75 0c                	jne    1565 <printf+0x50>
        state = '%';
    1559:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1560:	e9 4a 01 00 00       	jmp    16af <printf+0x19a>
      } else {
        putc(fd, c);
    1565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1568:	0f be c0             	movsbl %al,%eax
    156b:	89 44 24 04          	mov    %eax,0x4(%esp)
    156f:	8b 45 08             	mov    0x8(%ebp),%eax
    1572:	89 04 24             	mov    %eax,(%esp)
    1575:	e8 bb fe ff ff       	call   1435 <putc>
    157a:	e9 30 01 00 00       	jmp    16af <printf+0x19a>
      }
    } else if(state == '%'){
    157f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1583:	0f 85 26 01 00 00    	jne    16af <printf+0x19a>
      if(c == 'd'){
    1589:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    158d:	75 2d                	jne    15bc <printf+0xa7>
        printint(fd, *ap, 10, 1);
    158f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1592:	8b 00                	mov    (%eax),%eax
    1594:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    159b:	00 
    159c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15a3:	00 
    15a4:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a8:	8b 45 08             	mov    0x8(%ebp),%eax
    15ab:	89 04 24             	mov    %eax,(%esp)
    15ae:	e8 aa fe ff ff       	call   145d <printint>
        ap++;
    15b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15b7:	e9 ec 00 00 00       	jmp    16a8 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15bc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15c0:	74 06                	je     15c8 <printf+0xb3>
    15c2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15c6:	75 2d                	jne    15f5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15cb:	8b 00                	mov    (%eax),%eax
    15cd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15d4:	00 
    15d5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15dc:	00 
    15dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e1:	8b 45 08             	mov    0x8(%ebp),%eax
    15e4:	89 04 24             	mov    %eax,(%esp)
    15e7:	e8 71 fe ff ff       	call   145d <printint>
        ap++;
    15ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15f0:	e9 b3 00 00 00       	jmp    16a8 <printf+0x193>
      } else if(c == 's'){
    15f5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15f9:	75 45                	jne    1640 <printf+0x12b>
        s = (char*)*ap;
    15fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15fe:	8b 00                	mov    (%eax),%eax
    1600:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1603:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    160b:	75 09                	jne    1616 <printf+0x101>
          s = "(null)";
    160d:	c7 45 f4 07 19 00 00 	movl   $0x1907,-0xc(%ebp)
        while(*s != 0){
    1614:	eb 1e                	jmp    1634 <printf+0x11f>
    1616:	eb 1c                	jmp    1634 <printf+0x11f>
          putc(fd, *s);
    1618:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161b:	0f b6 00             	movzbl (%eax),%eax
    161e:	0f be c0             	movsbl %al,%eax
    1621:	89 44 24 04          	mov    %eax,0x4(%esp)
    1625:	8b 45 08             	mov    0x8(%ebp),%eax
    1628:	89 04 24             	mov    %eax,(%esp)
    162b:	e8 05 fe ff ff       	call   1435 <putc>
          s++;
    1630:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1634:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1637:	0f b6 00             	movzbl (%eax),%eax
    163a:	84 c0                	test   %al,%al
    163c:	75 da                	jne    1618 <printf+0x103>
    163e:	eb 68                	jmp    16a8 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1640:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1644:	75 1d                	jne    1663 <printf+0x14e>
        putc(fd, *ap);
    1646:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1649:	8b 00                	mov    (%eax),%eax
    164b:	0f be c0             	movsbl %al,%eax
    164e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1652:	8b 45 08             	mov    0x8(%ebp),%eax
    1655:	89 04 24             	mov    %eax,(%esp)
    1658:	e8 d8 fd ff ff       	call   1435 <putc>
        ap++;
    165d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1661:	eb 45                	jmp    16a8 <printf+0x193>
      } else if(c == '%'){
    1663:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1667:	75 17                	jne    1680 <printf+0x16b>
        putc(fd, c);
    1669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    166c:	0f be c0             	movsbl %al,%eax
    166f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1673:	8b 45 08             	mov    0x8(%ebp),%eax
    1676:	89 04 24             	mov    %eax,(%esp)
    1679:	e8 b7 fd ff ff       	call   1435 <putc>
    167e:	eb 28                	jmp    16a8 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1680:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1687:	00 
    1688:	8b 45 08             	mov    0x8(%ebp),%eax
    168b:	89 04 24             	mov    %eax,(%esp)
    168e:	e8 a2 fd ff ff       	call   1435 <putc>
        putc(fd, c);
    1693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1696:	0f be c0             	movsbl %al,%eax
    1699:	89 44 24 04          	mov    %eax,0x4(%esp)
    169d:	8b 45 08             	mov    0x8(%ebp),%eax
    16a0:	89 04 24             	mov    %eax,(%esp)
    16a3:	e8 8d fd ff ff       	call   1435 <putc>
      }
      state = 0;
    16a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16af:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16b3:	8b 55 0c             	mov    0xc(%ebp),%edx
    16b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16b9:	01 d0                	add    %edx,%eax
    16bb:	0f b6 00             	movzbl (%eax),%eax
    16be:	84 c0                	test   %al,%al
    16c0:	0f 85 71 fe ff ff    	jne    1537 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16c6:	c9                   	leave  
    16c7:	c3                   	ret    

000016c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16c8:	55                   	push   %ebp
    16c9:	89 e5                	mov    %esp,%ebp
    16cb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16ce:	8b 45 08             	mov    0x8(%ebp),%eax
    16d1:	83 e8 08             	sub    $0x8,%eax
    16d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d7:	a1 a8 2b 00 00       	mov    0x2ba8,%eax
    16dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16df:	eb 24                	jmp    1705 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e4:	8b 00                	mov    (%eax),%eax
    16e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16e9:	77 12                	ja     16fd <free+0x35>
    16eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16f1:	77 24                	ja     1717 <free+0x4f>
    16f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f6:	8b 00                	mov    (%eax),%eax
    16f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16fb:	77 1a                	ja     1717 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1700:	8b 00                	mov    (%eax),%eax
    1702:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1705:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1708:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    170b:	76 d4                	jbe    16e1 <free+0x19>
    170d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1710:	8b 00                	mov    (%eax),%eax
    1712:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1715:	76 ca                	jbe    16e1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1717:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171a:	8b 40 04             	mov    0x4(%eax),%eax
    171d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1724:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1727:	01 c2                	add    %eax,%edx
    1729:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172c:	8b 00                	mov    (%eax),%eax
    172e:	39 c2                	cmp    %eax,%edx
    1730:	75 24                	jne    1756 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1732:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1735:	8b 50 04             	mov    0x4(%eax),%edx
    1738:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173b:	8b 00                	mov    (%eax),%eax
    173d:	8b 40 04             	mov    0x4(%eax),%eax
    1740:	01 c2                	add    %eax,%edx
    1742:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1745:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1748:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174b:	8b 00                	mov    (%eax),%eax
    174d:	8b 10                	mov    (%eax),%edx
    174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1752:	89 10                	mov    %edx,(%eax)
    1754:	eb 0a                	jmp    1760 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1756:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1759:	8b 10                	mov    (%eax),%edx
    175b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    175e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1760:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1763:	8b 40 04             	mov    0x4(%eax),%eax
    1766:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    176d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1770:	01 d0                	add    %edx,%eax
    1772:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1775:	75 20                	jne    1797 <free+0xcf>
    p->s.size += bp->s.size;
    1777:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177a:	8b 50 04             	mov    0x4(%eax),%edx
    177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1780:	8b 40 04             	mov    0x4(%eax),%eax
    1783:	01 c2                	add    %eax,%edx
    1785:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1788:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    178b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    178e:	8b 10                	mov    (%eax),%edx
    1790:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1793:	89 10                	mov    %edx,(%eax)
    1795:	eb 08                	jmp    179f <free+0xd7>
  } else
    p->s.ptr = bp;
    1797:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    179d:	89 10                	mov    %edx,(%eax)
  freep = p;
    179f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a2:	a3 a8 2b 00 00       	mov    %eax,0x2ba8
}
    17a7:	c9                   	leave  
    17a8:	c3                   	ret    

000017a9 <morecore>:

static Header*
morecore(uint nu)
{
    17a9:	55                   	push   %ebp
    17aa:	89 e5                	mov    %esp,%ebp
    17ac:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17af:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17b6:	77 07                	ja     17bf <morecore+0x16>
    nu = 4096;
    17b8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17bf:	8b 45 08             	mov    0x8(%ebp),%eax
    17c2:	c1 e0 03             	shl    $0x3,%eax
    17c5:	89 04 24             	mov    %eax,(%esp)
    17c8:	e8 50 fc ff ff       	call   141d <sbrk>
    17cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17d0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17d4:	75 07                	jne    17dd <morecore+0x34>
    return 0;
    17d6:	b8 00 00 00 00       	mov    $0x0,%eax
    17db:	eb 22                	jmp    17ff <morecore+0x56>
  hp = (Header*)p;
    17dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e6:	8b 55 08             	mov    0x8(%ebp),%edx
    17e9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ef:	83 c0 08             	add    $0x8,%eax
    17f2:	89 04 24             	mov    %eax,(%esp)
    17f5:	e8 ce fe ff ff       	call   16c8 <free>
  return freep;
    17fa:	a1 a8 2b 00 00       	mov    0x2ba8,%eax
}
    17ff:	c9                   	leave  
    1800:	c3                   	ret    

00001801 <malloc>:

void*
malloc(uint nbytes)
{
    1801:	55                   	push   %ebp
    1802:	89 e5                	mov    %esp,%ebp
    1804:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1807:	8b 45 08             	mov    0x8(%ebp),%eax
    180a:	83 c0 07             	add    $0x7,%eax
    180d:	c1 e8 03             	shr    $0x3,%eax
    1810:	83 c0 01             	add    $0x1,%eax
    1813:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1816:	a1 a8 2b 00 00       	mov    0x2ba8,%eax
    181b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    181e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1822:	75 23                	jne    1847 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1824:	c7 45 f0 a0 2b 00 00 	movl   $0x2ba0,-0x10(%ebp)
    182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    182e:	a3 a8 2b 00 00       	mov    %eax,0x2ba8
    1833:	a1 a8 2b 00 00       	mov    0x2ba8,%eax
    1838:	a3 a0 2b 00 00       	mov    %eax,0x2ba0
    base.s.size = 0;
    183d:	c7 05 a4 2b 00 00 00 	movl   $0x0,0x2ba4
    1844:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1847:	8b 45 f0             	mov    -0x10(%ebp),%eax
    184a:	8b 00                	mov    (%eax),%eax
    184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1852:	8b 40 04             	mov    0x4(%eax),%eax
    1855:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1858:	72 4d                	jb     18a7 <malloc+0xa6>
      if(p->s.size == nunits)
    185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185d:	8b 40 04             	mov    0x4(%eax),%eax
    1860:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1863:	75 0c                	jne    1871 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1865:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1868:	8b 10                	mov    (%eax),%edx
    186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    186d:	89 10                	mov    %edx,(%eax)
    186f:	eb 26                	jmp    1897 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1871:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1874:	8b 40 04             	mov    0x4(%eax),%eax
    1877:	2b 45 ec             	sub    -0x14(%ebp),%eax
    187a:	89 c2                	mov    %eax,%edx
    187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1882:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1885:	8b 40 04             	mov    0x4(%eax),%eax
    1888:	c1 e0 03             	shl    $0x3,%eax
    188b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1891:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1894:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1897:	8b 45 f0             	mov    -0x10(%ebp),%eax
    189a:	a3 a8 2b 00 00       	mov    %eax,0x2ba8
      return (void*)(p + 1);
    189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a2:	83 c0 08             	add    $0x8,%eax
    18a5:	eb 38                	jmp    18df <malloc+0xde>
    }
    if(p == freep)
    18a7:	a1 a8 2b 00 00       	mov    0x2ba8,%eax
    18ac:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18af:	75 1b                	jne    18cc <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18b4:	89 04 24             	mov    %eax,(%esp)
    18b7:	e8 ed fe ff ff       	call   17a9 <morecore>
    18bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18c3:	75 07                	jne    18cc <malloc+0xcb>
        return 0;
    18c5:	b8 00 00 00 00       	mov    $0x0,%eax
    18ca:	eb 13                	jmp    18df <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d5:	8b 00                	mov    (%eax),%eax
    18d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18da:	e9 70 ff ff ff       	jmp    184f <malloc+0x4e>
}
    18df:	c9                   	leave  
    18e0:	c3                   	ret    
