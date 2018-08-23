
_s4:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"


int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 30             	sub    $0x30,%esp
   int x = 0;
    1009:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
    1010:	00 
   int i , j;
   int sum = 0;
    1011:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%esp)
    1018:	00 
   int *num = (int*)malloc(sizeof(int));
    1019:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    1020:	e8 f9 07 00 00       	call   181e <malloc>
    1025:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   *num = 5;
    1029:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    102d:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
   procdump();
    1033:	e8 72 03 00 00       	call   13aa <procdump>
   //child
   printf(1,"enter child %d \n\n\n", x);
    1038:	8b 44 24 20          	mov    0x20(%esp),%eax
    103c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1040:	c7 44 24 04 fe 18 00 	movl   $0x18fe,0x4(%esp)
    1047:	00 
    1048:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104f:	e8 de 04 00 00       	call   1532 <printf>
   if (cowfork() == 0)
    1054:	e8 49 03 00 00       	call   13a2 <cowfork>
    1059:	85 c0                	test   %eax,%eax
    105b:	0f 85 9d 00 00 00    	jne    10fe <main+0xfe>
   {
     procdump();
    1061:	e8 44 03 00 00       	call   13aa <procdump>
     x=2;
    1066:	c7 44 24 20 02 00 00 	movl   $0x2,0x20(%esp)
    106d:	00 
     
     printf(1,"son is : %d \n\n\n", x);
    106e:	8b 44 24 20          	mov    0x20(%esp),%eax
    1072:	89 44 24 08          	mov    %eax,0x8(%esp)
    1076:	c7 44 24 04 11 19 00 	movl   $0x1911,0x4(%esp)
    107d:	00 
    107e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1085:	e8 a8 04 00 00       	call   1532 <printf>
     
     for (i=0; i< 10; i++)
    108a:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
    1091:	00 
    1092:	eb 20                	jmp    10b4 <main+0xb4>
       for(j=0; j<5; j++)
    1094:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
    109b:	00 
    109c:	eb 0a                	jmp    10a8 <main+0xa8>
	sum++;
    109e:	83 44 24 24 01       	addl   $0x1,0x24(%esp)
     x=2;
     
     printf(1,"son is : %d \n\n\n", x);
     
     for (i=0; i< 10; i++)
       for(j=0; j<5; j++)
    10a3:	83 44 24 28 01       	addl   $0x1,0x28(%esp)
    10a8:	83 7c 24 28 04       	cmpl   $0x4,0x28(%esp)
    10ad:	7e ef                	jle    109e <main+0x9e>
     procdump();
     x=2;
     
     printf(1,"son is : %d \n\n\n", x);
     
     for (i=0; i< 10; i++)
    10af:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)
    10b4:	83 7c 24 2c 09       	cmpl   $0x9,0x2c(%esp)
    10b9:	7e d9                	jle    1094 <main+0x94>
       for(j=0; j<5; j++)
	sum++;
     *num = 6;
    10bb:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10bf:	c7 00 06 00 00 00    	movl   $0x6,(%eax)
     procdump();
    10c5:	e8 e0 02 00 00       	call   13aa <procdump>
     printf(1,"son value of num:\n");
    10ca:	c7 44 24 04 21 19 00 	movl   $0x1921,0x4(%esp)
    10d1:	00 
    10d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10d9:	e8 54 04 00 00       	call   1532 <printf>
     printf(1, "%d\n", *num);
    10de:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10e2:	8b 00                	mov    (%eax),%eax
    10e4:	89 44 24 08          	mov    %eax,0x8(%esp)
    10e8:	c7 44 24 04 34 19 00 	movl   $0x1934,0x4(%esp)
    10ef:	00 
    10f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10f7:	e8 36 04 00 00       	call   1532 <printf>
    10fc:	eb 37                	jmp    1135 <main+0x135>
     
    }
    else{
       wait();
    10fe:	e8 b7 02 00 00       	call   13ba <wait>
       printf(1,"father value of num:\n");
    1103:	c7 44 24 04 38 19 00 	movl   $0x1938,0x4(%esp)
    110a:	00 
    110b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1112:	e8 1b 04 00 00       	call   1532 <printf>
       printf(1, "%d\n", *num);
    1117:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    111b:	8b 00                	mov    (%eax),%eax
    111d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1121:	c7 44 24 04 34 19 00 	movl   $0x1934,0x4(%esp)
    1128:	00 
    1129:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1130:	e8 fd 03 00 00       	call   1532 <printf>
    }
   exit();
    1135:	e8 78 02 00 00       	call   13b2 <exit>

0000113a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    113a:	55                   	push   %ebp
    113b:	89 e5                	mov    %esp,%ebp
    113d:	57                   	push   %edi
    113e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    113f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1142:	8b 55 10             	mov    0x10(%ebp),%edx
    1145:	8b 45 0c             	mov    0xc(%ebp),%eax
    1148:	89 cb                	mov    %ecx,%ebx
    114a:	89 df                	mov    %ebx,%edi
    114c:	89 d1                	mov    %edx,%ecx
    114e:	fc                   	cld    
    114f:	f3 aa                	rep stos %al,%es:(%edi)
    1151:	89 ca                	mov    %ecx,%edx
    1153:	89 fb                	mov    %edi,%ebx
    1155:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1158:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    115b:	5b                   	pop    %ebx
    115c:	5f                   	pop    %edi
    115d:	5d                   	pop    %ebp
    115e:	c3                   	ret    

0000115f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    115f:	55                   	push   %ebp
    1160:	89 e5                	mov    %esp,%ebp
    1162:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1165:	8b 45 08             	mov    0x8(%ebp),%eax
    1168:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    116b:	90                   	nop
    116c:	8b 45 08             	mov    0x8(%ebp),%eax
    116f:	8d 50 01             	lea    0x1(%eax),%edx
    1172:	89 55 08             	mov    %edx,0x8(%ebp)
    1175:	8b 55 0c             	mov    0xc(%ebp),%edx
    1178:	8d 4a 01             	lea    0x1(%edx),%ecx
    117b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    117e:	0f b6 12             	movzbl (%edx),%edx
    1181:	88 10                	mov    %dl,(%eax)
    1183:	0f b6 00             	movzbl (%eax),%eax
    1186:	84 c0                	test   %al,%al
    1188:	75 e2                	jne    116c <strcpy+0xd>
    ;
  return os;
    118a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    118d:	c9                   	leave  
    118e:	c3                   	ret    

0000118f <strcmp>:

int
strcmp(const char *p, const char *q)
{
    118f:	55                   	push   %ebp
    1190:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1192:	eb 08                	jmp    119c <strcmp+0xd>
    p++, q++;
    1194:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1198:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    119c:	8b 45 08             	mov    0x8(%ebp),%eax
    119f:	0f b6 00             	movzbl (%eax),%eax
    11a2:	84 c0                	test   %al,%al
    11a4:	74 10                	je     11b6 <strcmp+0x27>
    11a6:	8b 45 08             	mov    0x8(%ebp),%eax
    11a9:	0f b6 10             	movzbl (%eax),%edx
    11ac:	8b 45 0c             	mov    0xc(%ebp),%eax
    11af:	0f b6 00             	movzbl (%eax),%eax
    11b2:	38 c2                	cmp    %al,%dl
    11b4:	74 de                	je     1194 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    11b6:	8b 45 08             	mov    0x8(%ebp),%eax
    11b9:	0f b6 00             	movzbl (%eax),%eax
    11bc:	0f b6 d0             	movzbl %al,%edx
    11bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c2:	0f b6 00             	movzbl (%eax),%eax
    11c5:	0f b6 c0             	movzbl %al,%eax
    11c8:	29 c2                	sub    %eax,%edx
    11ca:	89 d0                	mov    %edx,%eax
}
    11cc:	5d                   	pop    %ebp
    11cd:	c3                   	ret    

000011ce <strlen>:

uint
strlen(char *s)
{
    11ce:	55                   	push   %ebp
    11cf:	89 e5                	mov    %esp,%ebp
    11d1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11db:	eb 04                	jmp    11e1 <strlen+0x13>
    11dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11e4:	8b 45 08             	mov    0x8(%ebp),%eax
    11e7:	01 d0                	add    %edx,%eax
    11e9:	0f b6 00             	movzbl (%eax),%eax
    11ec:	84 c0                	test   %al,%al
    11ee:	75 ed                	jne    11dd <strlen+0xf>
    ;
  return n;
    11f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11f3:	c9                   	leave  
    11f4:	c3                   	ret    

000011f5 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11f5:	55                   	push   %ebp
    11f6:	89 e5                	mov    %esp,%ebp
    11f8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11fb:	8b 45 10             	mov    0x10(%ebp),%eax
    11fe:	89 44 24 08          	mov    %eax,0x8(%esp)
    1202:	8b 45 0c             	mov    0xc(%ebp),%eax
    1205:	89 44 24 04          	mov    %eax,0x4(%esp)
    1209:	8b 45 08             	mov    0x8(%ebp),%eax
    120c:	89 04 24             	mov    %eax,(%esp)
    120f:	e8 26 ff ff ff       	call   113a <stosb>
  return dst;
    1214:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1217:	c9                   	leave  
    1218:	c3                   	ret    

00001219 <strchr>:

char*
strchr(const char *s, char c)
{
    1219:	55                   	push   %ebp
    121a:	89 e5                	mov    %esp,%ebp
    121c:	83 ec 04             	sub    $0x4,%esp
    121f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1222:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1225:	eb 14                	jmp    123b <strchr+0x22>
    if(*s == c)
    1227:	8b 45 08             	mov    0x8(%ebp),%eax
    122a:	0f b6 00             	movzbl (%eax),%eax
    122d:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1230:	75 05                	jne    1237 <strchr+0x1e>
      return (char*)s;
    1232:	8b 45 08             	mov    0x8(%ebp),%eax
    1235:	eb 13                	jmp    124a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1237:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    123b:	8b 45 08             	mov    0x8(%ebp),%eax
    123e:	0f b6 00             	movzbl (%eax),%eax
    1241:	84 c0                	test   %al,%al
    1243:	75 e2                	jne    1227 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1245:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124a:	c9                   	leave  
    124b:	c3                   	ret    

0000124c <gets>:

char*
gets(char *buf, int max)
{
    124c:	55                   	push   %ebp
    124d:	89 e5                	mov    %esp,%ebp
    124f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1259:	eb 4c                	jmp    12a7 <gets+0x5b>
    cc = read(0, &c, 1);
    125b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1262:	00 
    1263:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1266:	89 44 24 04          	mov    %eax,0x4(%esp)
    126a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1271:	e8 54 01 00 00       	call   13ca <read>
    1276:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    127d:	7f 02                	jg     1281 <gets+0x35>
      break;
    127f:	eb 31                	jmp    12b2 <gets+0x66>
    buf[i++] = c;
    1281:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1284:	8d 50 01             	lea    0x1(%eax),%edx
    1287:	89 55 f4             	mov    %edx,-0xc(%ebp)
    128a:	89 c2                	mov    %eax,%edx
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
    128f:	01 c2                	add    %eax,%edx
    1291:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1295:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1297:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    129b:	3c 0a                	cmp    $0xa,%al
    129d:	74 13                	je     12b2 <gets+0x66>
    129f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a3:	3c 0d                	cmp    $0xd,%al
    12a5:	74 0b                	je     12b2 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12aa:	83 c0 01             	add    $0x1,%eax
    12ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
    12b0:	7c a9                	jl     125b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    12b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12b5:	8b 45 08             	mov    0x8(%ebp),%eax
    12b8:	01 d0                	add    %edx,%eax
    12ba:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c0:	c9                   	leave  
    12c1:	c3                   	ret    

000012c2 <stat>:

int
stat(char *n, struct stat *st)
{
    12c2:	55                   	push   %ebp
    12c3:	89 e5                	mov    %esp,%ebp
    12c5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12cf:	00 
    12d0:	8b 45 08             	mov    0x8(%ebp),%eax
    12d3:	89 04 24             	mov    %eax,(%esp)
    12d6:	e8 17 01 00 00       	call   13f2 <open>
    12db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e2:	79 07                	jns    12eb <stat+0x29>
    return -1;
    12e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12e9:	eb 23                	jmp    130e <stat+0x4c>
  r = fstat(fd, st);
    12eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    12f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f5:	89 04 24             	mov    %eax,(%esp)
    12f8:	e8 0d 01 00 00       	call   140a <fstat>
    12fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1300:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1303:	89 04 24             	mov    %eax,(%esp)
    1306:	e8 cf 00 00 00       	call   13da <close>
  return r;
    130b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    130e:	c9                   	leave  
    130f:	c3                   	ret    

00001310 <atoi>:

int
atoi(const char *s)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    131d:	eb 25                	jmp    1344 <atoi+0x34>
    n = n*10 + *s++ - '0';
    131f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1322:	89 d0                	mov    %edx,%eax
    1324:	c1 e0 02             	shl    $0x2,%eax
    1327:	01 d0                	add    %edx,%eax
    1329:	01 c0                	add    %eax,%eax
    132b:	89 c1                	mov    %eax,%ecx
    132d:	8b 45 08             	mov    0x8(%ebp),%eax
    1330:	8d 50 01             	lea    0x1(%eax),%edx
    1333:	89 55 08             	mov    %edx,0x8(%ebp)
    1336:	0f b6 00             	movzbl (%eax),%eax
    1339:	0f be c0             	movsbl %al,%eax
    133c:	01 c8                	add    %ecx,%eax
    133e:	83 e8 30             	sub    $0x30,%eax
    1341:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1344:	8b 45 08             	mov    0x8(%ebp),%eax
    1347:	0f b6 00             	movzbl (%eax),%eax
    134a:	3c 2f                	cmp    $0x2f,%al
    134c:	7e 0a                	jle    1358 <atoi+0x48>
    134e:	8b 45 08             	mov    0x8(%ebp),%eax
    1351:	0f b6 00             	movzbl (%eax),%eax
    1354:	3c 39                	cmp    $0x39,%al
    1356:	7e c7                	jle    131f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    135b:	c9                   	leave  
    135c:	c3                   	ret    

0000135d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    135d:	55                   	push   %ebp
    135e:	89 e5                	mov    %esp,%ebp
    1360:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1363:	8b 45 08             	mov    0x8(%ebp),%eax
    1366:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1369:	8b 45 0c             	mov    0xc(%ebp),%eax
    136c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    136f:	eb 17                	jmp    1388 <memmove+0x2b>
    *dst++ = *src++;
    1371:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1374:	8d 50 01             	lea    0x1(%eax),%edx
    1377:	89 55 fc             	mov    %edx,-0x4(%ebp)
    137a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    137d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1380:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1383:	0f b6 12             	movzbl (%edx),%edx
    1386:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1388:	8b 45 10             	mov    0x10(%ebp),%eax
    138b:	8d 50 ff             	lea    -0x1(%eax),%edx
    138e:	89 55 10             	mov    %edx,0x10(%ebp)
    1391:	85 c0                	test   %eax,%eax
    1393:	7f dc                	jg     1371 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1395:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1398:	c9                   	leave  
    1399:	c3                   	ret    

0000139a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    139a:	b8 01 00 00 00       	mov    $0x1,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <cowfork>:
SYSCALL(cowfork)
    13a2:	b8 0f 00 00 00       	mov    $0xf,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <procdump>:
SYSCALL(procdump)
    13aa:	b8 10 00 00 00       	mov    $0x10,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <exit>:
SYSCALL(exit)
    13b2:	b8 02 00 00 00       	mov    $0x2,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <wait>:
SYSCALL(wait)
    13ba:	b8 03 00 00 00       	mov    $0x3,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <pipe>:
SYSCALL(pipe)
    13c2:	b8 04 00 00 00       	mov    $0x4,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <read>:
SYSCALL(read)
    13ca:	b8 05 00 00 00       	mov    $0x5,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <write>:
SYSCALL(write)
    13d2:	b8 12 00 00 00       	mov    $0x12,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <close>:
SYSCALL(close)
    13da:	b8 17 00 00 00       	mov    $0x17,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <kill>:
SYSCALL(kill)
    13e2:	b8 06 00 00 00       	mov    $0x6,%eax
    13e7:	cd 40                	int    $0x40
    13e9:	c3                   	ret    

000013ea <exec>:
SYSCALL(exec)
    13ea:	b8 07 00 00 00       	mov    $0x7,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <open>:
SYSCALL(open)
    13f2:	b8 11 00 00 00       	mov    $0x11,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <mknod>:
SYSCALL(mknod)
    13fa:	b8 13 00 00 00       	mov    $0x13,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <unlink>:
SYSCALL(unlink)
    1402:	b8 14 00 00 00       	mov    $0x14,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <fstat>:
SYSCALL(fstat)
    140a:	b8 08 00 00 00       	mov    $0x8,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <link>:
SYSCALL(link)
    1412:	b8 15 00 00 00       	mov    $0x15,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <mkdir>:
SYSCALL(mkdir)
    141a:	b8 16 00 00 00       	mov    $0x16,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    

00001422 <chdir>:
SYSCALL(chdir)
    1422:	b8 09 00 00 00       	mov    $0x9,%eax
    1427:	cd 40                	int    $0x40
    1429:	c3                   	ret    

0000142a <dup>:
SYSCALL(dup)
    142a:	b8 0a 00 00 00       	mov    $0xa,%eax
    142f:	cd 40                	int    $0x40
    1431:	c3                   	ret    

00001432 <getpid>:
SYSCALL(getpid)
    1432:	b8 0b 00 00 00       	mov    $0xb,%eax
    1437:	cd 40                	int    $0x40
    1439:	c3                   	ret    

0000143a <sbrk>:
SYSCALL(sbrk)
    143a:	b8 0c 00 00 00       	mov    $0xc,%eax
    143f:	cd 40                	int    $0x40
    1441:	c3                   	ret    

00001442 <sleep>:
SYSCALL(sleep)
    1442:	b8 0d 00 00 00       	mov    $0xd,%eax
    1447:	cd 40                	int    $0x40
    1449:	c3                   	ret    

0000144a <uptime>:
SYSCALL(uptime)
    144a:	b8 0e 00 00 00       	mov    $0xe,%eax
    144f:	cd 40                	int    $0x40
    1451:	c3                   	ret    

00001452 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1452:	55                   	push   %ebp
    1453:	89 e5                	mov    %esp,%ebp
    1455:	83 ec 18             	sub    $0x18,%esp
    1458:	8b 45 0c             	mov    0xc(%ebp),%eax
    145b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    145e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1465:	00 
    1466:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1469:	89 44 24 04          	mov    %eax,0x4(%esp)
    146d:	8b 45 08             	mov    0x8(%ebp),%eax
    1470:	89 04 24             	mov    %eax,(%esp)
    1473:	e8 5a ff ff ff       	call   13d2 <write>
}
    1478:	c9                   	leave  
    1479:	c3                   	ret    

0000147a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    147a:	55                   	push   %ebp
    147b:	89 e5                	mov    %esp,%ebp
    147d:	56                   	push   %esi
    147e:	53                   	push   %ebx
    147f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1482:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1489:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    148d:	74 17                	je     14a6 <printint+0x2c>
    148f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1493:	79 11                	jns    14a6 <printint+0x2c>
    neg = 1;
    1495:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    149c:	8b 45 0c             	mov    0xc(%ebp),%eax
    149f:	f7 d8                	neg    %eax
    14a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14a4:	eb 06                	jmp    14ac <printint+0x32>
  } else {
    x = xx;
    14a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14b6:	8d 41 01             	lea    0x1(%ecx),%eax
    14b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14c2:	ba 00 00 00 00       	mov    $0x0,%edx
    14c7:	f7 f3                	div    %ebx
    14c9:	89 d0                	mov    %edx,%eax
    14cb:	0f b6 80 9c 2b 00 00 	movzbl 0x2b9c(%eax),%eax
    14d2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14d6:	8b 75 10             	mov    0x10(%ebp),%esi
    14d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14dc:	ba 00 00 00 00       	mov    $0x0,%edx
    14e1:	f7 f6                	div    %esi
    14e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14ea:	75 c7                	jne    14b3 <printint+0x39>
  if(neg)
    14ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14f0:	74 10                	je     1502 <printint+0x88>
    buf[i++] = '-';
    14f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f5:	8d 50 01             	lea    0x1(%eax),%edx
    14f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14fb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1500:	eb 1f                	jmp    1521 <printint+0xa7>
    1502:	eb 1d                	jmp    1521 <printint+0xa7>
    putc(fd, buf[i]);
    1504:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1507:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150a:	01 d0                	add    %edx,%eax
    150c:	0f b6 00             	movzbl (%eax),%eax
    150f:	0f be c0             	movsbl %al,%eax
    1512:	89 44 24 04          	mov    %eax,0x4(%esp)
    1516:	8b 45 08             	mov    0x8(%ebp),%eax
    1519:	89 04 24             	mov    %eax,(%esp)
    151c:	e8 31 ff ff ff       	call   1452 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1521:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1529:	79 d9                	jns    1504 <printint+0x8a>
    putc(fd, buf[i]);
}
    152b:	83 c4 30             	add    $0x30,%esp
    152e:	5b                   	pop    %ebx
    152f:	5e                   	pop    %esi
    1530:	5d                   	pop    %ebp
    1531:	c3                   	ret    

00001532 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1532:	55                   	push   %ebp
    1533:	89 e5                	mov    %esp,%ebp
    1535:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1538:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    153f:	8d 45 0c             	lea    0xc(%ebp),%eax
    1542:	83 c0 04             	add    $0x4,%eax
    1545:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1548:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    154f:	e9 7c 01 00 00       	jmp    16d0 <printf+0x19e>
    c = fmt[i] & 0xff;
    1554:	8b 55 0c             	mov    0xc(%ebp),%edx
    1557:	8b 45 f0             	mov    -0x10(%ebp),%eax
    155a:	01 d0                	add    %edx,%eax
    155c:	0f b6 00             	movzbl (%eax),%eax
    155f:	0f be c0             	movsbl %al,%eax
    1562:	25 ff 00 00 00       	and    $0xff,%eax
    1567:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    156a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    156e:	75 2c                	jne    159c <printf+0x6a>
      if(c == '%'){
    1570:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1574:	75 0c                	jne    1582 <printf+0x50>
        state = '%';
    1576:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    157d:	e9 4a 01 00 00       	jmp    16cc <printf+0x19a>
      } else {
        putc(fd, c);
    1582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1585:	0f be c0             	movsbl %al,%eax
    1588:	89 44 24 04          	mov    %eax,0x4(%esp)
    158c:	8b 45 08             	mov    0x8(%ebp),%eax
    158f:	89 04 24             	mov    %eax,(%esp)
    1592:	e8 bb fe ff ff       	call   1452 <putc>
    1597:	e9 30 01 00 00       	jmp    16cc <printf+0x19a>
      }
    } else if(state == '%'){
    159c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15a0:	0f 85 26 01 00 00    	jne    16cc <printf+0x19a>
      if(c == 'd'){
    15a6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15aa:	75 2d                	jne    15d9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15af:	8b 00                	mov    (%eax),%eax
    15b1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15b8:	00 
    15b9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15c0:	00 
    15c1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c5:	8b 45 08             	mov    0x8(%ebp),%eax
    15c8:	89 04 24             	mov    %eax,(%esp)
    15cb:	e8 aa fe ff ff       	call   147a <printint>
        ap++;
    15d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d4:	e9 ec 00 00 00       	jmp    16c5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15d9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15dd:	74 06                	je     15e5 <printf+0xb3>
    15df:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15e3:	75 2d                	jne    1612 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15e8:	8b 00                	mov    (%eax),%eax
    15ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15f1:	00 
    15f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15f9:	00 
    15fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    15fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1601:	89 04 24             	mov    %eax,(%esp)
    1604:	e8 71 fe ff ff       	call   147a <printint>
        ap++;
    1609:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    160d:	e9 b3 00 00 00       	jmp    16c5 <printf+0x193>
      } else if(c == 's'){
    1612:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1616:	75 45                	jne    165d <printf+0x12b>
        s = (char*)*ap;
    1618:	8b 45 e8             	mov    -0x18(%ebp),%eax
    161b:	8b 00                	mov    (%eax),%eax
    161d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1620:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1628:	75 09                	jne    1633 <printf+0x101>
          s = "(null)";
    162a:	c7 45 f4 4e 19 00 00 	movl   $0x194e,-0xc(%ebp)
        while(*s != 0){
    1631:	eb 1e                	jmp    1651 <printf+0x11f>
    1633:	eb 1c                	jmp    1651 <printf+0x11f>
          putc(fd, *s);
    1635:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1638:	0f b6 00             	movzbl (%eax),%eax
    163b:	0f be c0             	movsbl %al,%eax
    163e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1642:	8b 45 08             	mov    0x8(%ebp),%eax
    1645:	89 04 24             	mov    %eax,(%esp)
    1648:	e8 05 fe ff ff       	call   1452 <putc>
          s++;
    164d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1651:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1654:	0f b6 00             	movzbl (%eax),%eax
    1657:	84 c0                	test   %al,%al
    1659:	75 da                	jne    1635 <printf+0x103>
    165b:	eb 68                	jmp    16c5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    165d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1661:	75 1d                	jne    1680 <printf+0x14e>
        putc(fd, *ap);
    1663:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1666:	8b 00                	mov    (%eax),%eax
    1668:	0f be c0             	movsbl %al,%eax
    166b:	89 44 24 04          	mov    %eax,0x4(%esp)
    166f:	8b 45 08             	mov    0x8(%ebp),%eax
    1672:	89 04 24             	mov    %eax,(%esp)
    1675:	e8 d8 fd ff ff       	call   1452 <putc>
        ap++;
    167a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    167e:	eb 45                	jmp    16c5 <printf+0x193>
      } else if(c == '%'){
    1680:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1684:	75 17                	jne    169d <printf+0x16b>
        putc(fd, c);
    1686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1689:	0f be c0             	movsbl %al,%eax
    168c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1690:	8b 45 08             	mov    0x8(%ebp),%eax
    1693:	89 04 24             	mov    %eax,(%esp)
    1696:	e8 b7 fd ff ff       	call   1452 <putc>
    169b:	eb 28                	jmp    16c5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    169d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    16a4:	00 
    16a5:	8b 45 08             	mov    0x8(%ebp),%eax
    16a8:	89 04 24             	mov    %eax,(%esp)
    16ab:	e8 a2 fd ff ff       	call   1452 <putc>
        putc(fd, c);
    16b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b3:	0f be c0             	movsbl %al,%eax
    16b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    16ba:	8b 45 08             	mov    0x8(%ebp),%eax
    16bd:	89 04 24             	mov    %eax,(%esp)
    16c0:	e8 8d fd ff ff       	call   1452 <putc>
      }
      state = 0;
    16c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16d0:	8b 55 0c             	mov    0xc(%ebp),%edx
    16d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16d6:	01 d0                	add    %edx,%eax
    16d8:	0f b6 00             	movzbl (%eax),%eax
    16db:	84 c0                	test   %al,%al
    16dd:	0f 85 71 fe ff ff    	jne    1554 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16e3:	c9                   	leave  
    16e4:	c3                   	ret    

000016e5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16e5:	55                   	push   %ebp
    16e6:	89 e5                	mov    %esp,%ebp
    16e8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16eb:	8b 45 08             	mov    0x8(%ebp),%eax
    16ee:	83 e8 08             	sub    $0x8,%eax
    16f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f4:	a1 b8 2b 00 00       	mov    0x2bb8,%eax
    16f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16fc:	eb 24                	jmp    1722 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1701:	8b 00                	mov    (%eax),%eax
    1703:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1706:	77 12                	ja     171a <free+0x35>
    1708:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    170e:	77 24                	ja     1734 <free+0x4f>
    1710:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1713:	8b 00                	mov    (%eax),%eax
    1715:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1718:	77 1a                	ja     1734 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    171a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171d:	8b 00                	mov    (%eax),%eax
    171f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1722:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1725:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1728:	76 d4                	jbe    16fe <free+0x19>
    172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172d:	8b 00                	mov    (%eax),%eax
    172f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1732:	76 ca                	jbe    16fe <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1734:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1737:	8b 40 04             	mov    0x4(%eax),%eax
    173a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1741:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1744:	01 c2                	add    %eax,%edx
    1746:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1749:	8b 00                	mov    (%eax),%eax
    174b:	39 c2                	cmp    %eax,%edx
    174d:	75 24                	jne    1773 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1752:	8b 50 04             	mov    0x4(%eax),%edx
    1755:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1758:	8b 00                	mov    (%eax),%eax
    175a:	8b 40 04             	mov    0x4(%eax),%eax
    175d:	01 c2                	add    %eax,%edx
    175f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1762:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1765:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1768:	8b 00                	mov    (%eax),%eax
    176a:	8b 10                	mov    (%eax),%edx
    176c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    176f:	89 10                	mov    %edx,(%eax)
    1771:	eb 0a                	jmp    177d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1773:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1776:	8b 10                	mov    (%eax),%edx
    1778:	8b 45 f8             	mov    -0x8(%ebp),%eax
    177b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    177d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1780:	8b 40 04             	mov    0x4(%eax),%eax
    1783:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    178a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    178d:	01 d0                	add    %edx,%eax
    178f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1792:	75 20                	jne    17b4 <free+0xcf>
    p->s.size += bp->s.size;
    1794:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1797:	8b 50 04             	mov    0x4(%eax),%edx
    179a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179d:	8b 40 04             	mov    0x4(%eax),%eax
    17a0:	01 c2                	add    %eax,%edx
    17a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ab:	8b 10                	mov    (%eax),%edx
    17ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b0:	89 10                	mov    %edx,(%eax)
    17b2:	eb 08                	jmp    17bc <free+0xd7>
  } else
    p->s.ptr = bp;
    17b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17ba:	89 10                	mov    %edx,(%eax)
  freep = p;
    17bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bf:	a3 b8 2b 00 00       	mov    %eax,0x2bb8
}
    17c4:	c9                   	leave  
    17c5:	c3                   	ret    

000017c6 <morecore>:

static Header*
morecore(uint nu)
{
    17c6:	55                   	push   %ebp
    17c7:	89 e5                	mov    %esp,%ebp
    17c9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17cc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17d3:	77 07                	ja     17dc <morecore+0x16>
    nu = 4096;
    17d5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17dc:	8b 45 08             	mov    0x8(%ebp),%eax
    17df:	c1 e0 03             	shl    $0x3,%eax
    17e2:	89 04 24             	mov    %eax,(%esp)
    17e5:	e8 50 fc ff ff       	call   143a <sbrk>
    17ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17ed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17f1:	75 07                	jne    17fa <morecore+0x34>
    return 0;
    17f3:	b8 00 00 00 00       	mov    $0x0,%eax
    17f8:	eb 22                	jmp    181c <morecore+0x56>
  hp = (Header*)p;
    17fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1800:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1803:	8b 55 08             	mov    0x8(%ebp),%edx
    1806:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1809:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180c:	83 c0 08             	add    $0x8,%eax
    180f:	89 04 24             	mov    %eax,(%esp)
    1812:	e8 ce fe ff ff       	call   16e5 <free>
  return freep;
    1817:	a1 b8 2b 00 00       	mov    0x2bb8,%eax
}
    181c:	c9                   	leave  
    181d:	c3                   	ret    

0000181e <malloc>:

void*
malloc(uint nbytes)
{
    181e:	55                   	push   %ebp
    181f:	89 e5                	mov    %esp,%ebp
    1821:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1824:	8b 45 08             	mov    0x8(%ebp),%eax
    1827:	83 c0 07             	add    $0x7,%eax
    182a:	c1 e8 03             	shr    $0x3,%eax
    182d:	83 c0 01             	add    $0x1,%eax
    1830:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1833:	a1 b8 2b 00 00       	mov    0x2bb8,%eax
    1838:	89 45 f0             	mov    %eax,-0x10(%ebp)
    183b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    183f:	75 23                	jne    1864 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1841:	c7 45 f0 b0 2b 00 00 	movl   $0x2bb0,-0x10(%ebp)
    1848:	8b 45 f0             	mov    -0x10(%ebp),%eax
    184b:	a3 b8 2b 00 00       	mov    %eax,0x2bb8
    1850:	a1 b8 2b 00 00       	mov    0x2bb8,%eax
    1855:	a3 b0 2b 00 00       	mov    %eax,0x2bb0
    base.s.size = 0;
    185a:	c7 05 b4 2b 00 00 00 	movl   $0x0,0x2bb4
    1861:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1864:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1867:	8b 00                	mov    (%eax),%eax
    1869:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186f:	8b 40 04             	mov    0x4(%eax),%eax
    1872:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1875:	72 4d                	jb     18c4 <malloc+0xa6>
      if(p->s.size == nunits)
    1877:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187a:	8b 40 04             	mov    0x4(%eax),%eax
    187d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1880:	75 0c                	jne    188e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1882:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1885:	8b 10                	mov    (%eax),%edx
    1887:	8b 45 f0             	mov    -0x10(%ebp),%eax
    188a:	89 10                	mov    %edx,(%eax)
    188c:	eb 26                	jmp    18b4 <malloc+0x96>
      else {
        p->s.size -= nunits;
    188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1891:	8b 40 04             	mov    0x4(%eax),%eax
    1894:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1897:	89 c2                	mov    %eax,%edx
    1899:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a2:	8b 40 04             	mov    0x4(%eax),%eax
    18a5:	c1 e0 03             	shl    $0x3,%eax
    18a8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18b1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18b7:	a3 b8 2b 00 00       	mov    %eax,0x2bb8
      return (void*)(p + 1);
    18bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bf:	83 c0 08             	add    $0x8,%eax
    18c2:	eb 38                	jmp    18fc <malloc+0xde>
    }
    if(p == freep)
    18c4:	a1 b8 2b 00 00       	mov    0x2bb8,%eax
    18c9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18cc:	75 1b                	jne    18e9 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18d1:	89 04 24             	mov    %eax,(%esp)
    18d4:	e8 ed fe ff ff       	call   17c6 <morecore>
    18d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e0:	75 07                	jne    18e9 <malloc+0xcb>
        return 0;
    18e2:	b8 00 00 00 00       	mov    $0x0,%eax
    18e7:	eb 13                	jmp    18fc <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f2:	8b 00                	mov    (%eax),%eax
    18f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18f7:	e9 70 ff ff ff       	jmp    186c <malloc+0x4e>
}
    18fc:	c9                   	leave  
    18fd:	c3                   	ret    
