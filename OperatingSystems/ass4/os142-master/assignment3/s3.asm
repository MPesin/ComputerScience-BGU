
_s3:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"


int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
   char* pointer = (char*)main;
    1009:	c7 44 24 1c 00 10 00 	movl   $0x1000,0x1c(%esp)
    1010:	00 

   if(fork() == 0) {
    1011:	e8 ad 02 00 00       	call   12c3 <fork>
    1016:	85 c0                	test   %eax,%eax
    1018:	75 3f                	jne    1059 <main+0x59>
    printf(1, "read from pointer %c \n", *pointer);
    101a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    101e:	0f b6 00             	movzbl (%eax),%eax
    1021:	0f be c0             	movsbl %al,%eax
    1024:	89 44 24 08          	mov    %eax,0x8(%esp)
    1028:	c7 44 24 04 28 18 00 	movl   $0x1828,0x4(%esp)
    102f:	00 
    1030:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1037:	e8 1f 04 00 00       	call   145b <printf>
     printf(1, "son is trying to write to main (which is read only)\n");
    103c:	c7 44 24 04 40 18 00 	movl   $0x1840,0x4(%esp)
    1043:	00 
    1044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104b:	e8 0b 04 00 00       	call   145b <printf>
     *pointer = 'n';
    1050:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1054:	c6 00 6e             	movb   $0x6e,(%eax)
    1057:	eb 05                	jmp    105e <main+0x5e>
   } else
     wait();// father waiting
    1059:	e8 85 02 00 00       	call   12e3 <wait>


   exit();
    105e:	e8 78 02 00 00       	call   12db <exit>

00001063 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1063:	55                   	push   %ebp
    1064:	89 e5                	mov    %esp,%ebp
    1066:	57                   	push   %edi
    1067:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1068:	8b 4d 08             	mov    0x8(%ebp),%ecx
    106b:	8b 55 10             	mov    0x10(%ebp),%edx
    106e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1071:	89 cb                	mov    %ecx,%ebx
    1073:	89 df                	mov    %ebx,%edi
    1075:	89 d1                	mov    %edx,%ecx
    1077:	fc                   	cld    
    1078:	f3 aa                	rep stos %al,%es:(%edi)
    107a:	89 ca                	mov    %ecx,%edx
    107c:	89 fb                	mov    %edi,%ebx
    107e:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1081:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1084:	5b                   	pop    %ebx
    1085:	5f                   	pop    %edi
    1086:	5d                   	pop    %ebp
    1087:	c3                   	ret    

00001088 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1088:	55                   	push   %ebp
    1089:	89 e5                	mov    %esp,%ebp
    108b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    108e:	8b 45 08             	mov    0x8(%ebp),%eax
    1091:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1094:	90                   	nop
    1095:	8b 45 08             	mov    0x8(%ebp),%eax
    1098:	8d 50 01             	lea    0x1(%eax),%edx
    109b:	89 55 08             	mov    %edx,0x8(%ebp)
    109e:	8b 55 0c             	mov    0xc(%ebp),%edx
    10a1:	8d 4a 01             	lea    0x1(%edx),%ecx
    10a4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10a7:	0f b6 12             	movzbl (%edx),%edx
    10aa:	88 10                	mov    %dl,(%eax)
    10ac:	0f b6 00             	movzbl (%eax),%eax
    10af:	84 c0                	test   %al,%al
    10b1:	75 e2                	jne    1095 <strcpy+0xd>
    ;
  return os;
    10b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10b6:	c9                   	leave  
    10b7:	c3                   	ret    

000010b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10b8:	55                   	push   %ebp
    10b9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10bb:	eb 08                	jmp    10c5 <strcmp+0xd>
    p++, q++;
    10bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10c1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10c5:	8b 45 08             	mov    0x8(%ebp),%eax
    10c8:	0f b6 00             	movzbl (%eax),%eax
    10cb:	84 c0                	test   %al,%al
    10cd:	74 10                	je     10df <strcmp+0x27>
    10cf:	8b 45 08             	mov    0x8(%ebp),%eax
    10d2:	0f b6 10             	movzbl (%eax),%edx
    10d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d8:	0f b6 00             	movzbl (%eax),%eax
    10db:	38 c2                	cmp    %al,%dl
    10dd:	74 de                	je     10bd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10df:	8b 45 08             	mov    0x8(%ebp),%eax
    10e2:	0f b6 00             	movzbl (%eax),%eax
    10e5:	0f b6 d0             	movzbl %al,%edx
    10e8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10eb:	0f b6 00             	movzbl (%eax),%eax
    10ee:	0f b6 c0             	movzbl %al,%eax
    10f1:	29 c2                	sub    %eax,%edx
    10f3:	89 d0                	mov    %edx,%eax
}
    10f5:	5d                   	pop    %ebp
    10f6:	c3                   	ret    

000010f7 <strlen>:

uint
strlen(char *s)
{
    10f7:	55                   	push   %ebp
    10f8:	89 e5                	mov    %esp,%ebp
    10fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1104:	eb 04                	jmp    110a <strlen+0x13>
    1106:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    110a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    110d:	8b 45 08             	mov    0x8(%ebp),%eax
    1110:	01 d0                	add    %edx,%eax
    1112:	0f b6 00             	movzbl (%eax),%eax
    1115:	84 c0                	test   %al,%al
    1117:	75 ed                	jne    1106 <strlen+0xf>
    ;
  return n;
    1119:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    111c:	c9                   	leave  
    111d:	c3                   	ret    

0000111e <memset>:

void*
memset(void *dst, int c, uint n)
{
    111e:	55                   	push   %ebp
    111f:	89 e5                	mov    %esp,%ebp
    1121:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1124:	8b 45 10             	mov    0x10(%ebp),%eax
    1127:	89 44 24 08          	mov    %eax,0x8(%esp)
    112b:	8b 45 0c             	mov    0xc(%ebp),%eax
    112e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1132:	8b 45 08             	mov    0x8(%ebp),%eax
    1135:	89 04 24             	mov    %eax,(%esp)
    1138:	e8 26 ff ff ff       	call   1063 <stosb>
  return dst;
    113d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1140:	c9                   	leave  
    1141:	c3                   	ret    

00001142 <strchr>:

char*
strchr(const char *s, char c)
{
    1142:	55                   	push   %ebp
    1143:	89 e5                	mov    %esp,%ebp
    1145:	83 ec 04             	sub    $0x4,%esp
    1148:	8b 45 0c             	mov    0xc(%ebp),%eax
    114b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    114e:	eb 14                	jmp    1164 <strchr+0x22>
    if(*s == c)
    1150:	8b 45 08             	mov    0x8(%ebp),%eax
    1153:	0f b6 00             	movzbl (%eax),%eax
    1156:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1159:	75 05                	jne    1160 <strchr+0x1e>
      return (char*)s;
    115b:	8b 45 08             	mov    0x8(%ebp),%eax
    115e:	eb 13                	jmp    1173 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1160:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	0f b6 00             	movzbl (%eax),%eax
    116a:	84 c0                	test   %al,%al
    116c:	75 e2                	jne    1150 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    116e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1173:	c9                   	leave  
    1174:	c3                   	ret    

00001175 <gets>:

char*
gets(char *buf, int max)
{
    1175:	55                   	push   %ebp
    1176:	89 e5                	mov    %esp,%ebp
    1178:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    117b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1182:	eb 4c                	jmp    11d0 <gets+0x5b>
    cc = read(0, &c, 1);
    1184:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    118b:	00 
    118c:	8d 45 ef             	lea    -0x11(%ebp),%eax
    118f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1193:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    119a:	e8 54 01 00 00       	call   12f3 <read>
    119f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11a6:	7f 02                	jg     11aa <gets+0x35>
      break;
    11a8:	eb 31                	jmp    11db <gets+0x66>
    buf[i++] = c;
    11aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ad:	8d 50 01             	lea    0x1(%eax),%edx
    11b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11b3:	89 c2                	mov    %eax,%edx
    11b5:	8b 45 08             	mov    0x8(%ebp),%eax
    11b8:	01 c2                	add    %eax,%edx
    11ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11be:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c4:	3c 0a                	cmp    $0xa,%al
    11c6:	74 13                	je     11db <gets+0x66>
    11c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11cc:	3c 0d                	cmp    $0xd,%al
    11ce:	74 0b                	je     11db <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d3:	83 c0 01             	add    $0x1,%eax
    11d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11d9:	7c a9                	jl     1184 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11db:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
    11e1:	01 d0                	add    %edx,%eax
    11e3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11e9:	c9                   	leave  
    11ea:	c3                   	ret    

000011eb <stat>:

int
stat(char *n, struct stat *st)
{
    11eb:	55                   	push   %ebp
    11ec:	89 e5                	mov    %esp,%ebp
    11ee:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11f8:	00 
    11f9:	8b 45 08             	mov    0x8(%ebp),%eax
    11fc:	89 04 24             	mov    %eax,(%esp)
    11ff:	e8 17 01 00 00       	call   131b <open>
    1204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    120b:	79 07                	jns    1214 <stat+0x29>
    return -1;
    120d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1212:	eb 23                	jmp    1237 <stat+0x4c>
  r = fstat(fd, st);
    1214:	8b 45 0c             	mov    0xc(%ebp),%eax
    1217:	89 44 24 04          	mov    %eax,0x4(%esp)
    121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    121e:	89 04 24             	mov    %eax,(%esp)
    1221:	e8 0d 01 00 00       	call   1333 <fstat>
    1226:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1229:	8b 45 f4             	mov    -0xc(%ebp),%eax
    122c:	89 04 24             	mov    %eax,(%esp)
    122f:	e8 cf 00 00 00       	call   1303 <close>
  return r;
    1234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1237:	c9                   	leave  
    1238:	c3                   	ret    

00001239 <atoi>:

int
atoi(const char *s)
{
    1239:	55                   	push   %ebp
    123a:	89 e5                	mov    %esp,%ebp
    123c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    123f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1246:	eb 25                	jmp    126d <atoi+0x34>
    n = n*10 + *s++ - '0';
    1248:	8b 55 fc             	mov    -0x4(%ebp),%edx
    124b:	89 d0                	mov    %edx,%eax
    124d:	c1 e0 02             	shl    $0x2,%eax
    1250:	01 d0                	add    %edx,%eax
    1252:	01 c0                	add    %eax,%eax
    1254:	89 c1                	mov    %eax,%ecx
    1256:	8b 45 08             	mov    0x8(%ebp),%eax
    1259:	8d 50 01             	lea    0x1(%eax),%edx
    125c:	89 55 08             	mov    %edx,0x8(%ebp)
    125f:	0f b6 00             	movzbl (%eax),%eax
    1262:	0f be c0             	movsbl %al,%eax
    1265:	01 c8                	add    %ecx,%eax
    1267:	83 e8 30             	sub    $0x30,%eax
    126a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    126d:	8b 45 08             	mov    0x8(%ebp),%eax
    1270:	0f b6 00             	movzbl (%eax),%eax
    1273:	3c 2f                	cmp    $0x2f,%al
    1275:	7e 0a                	jle    1281 <atoi+0x48>
    1277:	8b 45 08             	mov    0x8(%ebp),%eax
    127a:	0f b6 00             	movzbl (%eax),%eax
    127d:	3c 39                	cmp    $0x39,%al
    127f:	7e c7                	jle    1248 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1284:	c9                   	leave  
    1285:	c3                   	ret    

00001286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1286:	55                   	push   %ebp
    1287:	89 e5                	mov    %esp,%ebp
    1289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
    128f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1292:	8b 45 0c             	mov    0xc(%ebp),%eax
    1295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1298:	eb 17                	jmp    12b1 <memmove+0x2b>
    *dst++ = *src++;
    129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    129d:	8d 50 01             	lea    0x1(%eax),%edx
    12a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12a6:	8d 4a 01             	lea    0x1(%edx),%ecx
    12a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12ac:	0f b6 12             	movzbl (%edx),%edx
    12af:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12b1:	8b 45 10             	mov    0x10(%ebp),%eax
    12b4:	8d 50 ff             	lea    -0x1(%eax),%edx
    12b7:	89 55 10             	mov    %edx,0x10(%ebp)
    12ba:	85 c0                	test   %eax,%eax
    12bc:	7f dc                	jg     129a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12be:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c1:	c9                   	leave  
    12c2:	c3                   	ret    

000012c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c3:	b8 01 00 00 00       	mov    $0x1,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <cowfork>:
SYSCALL(cowfork)
    12cb:	b8 0f 00 00 00       	mov    $0xf,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <procdump>:
SYSCALL(procdump)
    12d3:	b8 10 00 00 00       	mov    $0x10,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <exit>:
SYSCALL(exit)
    12db:	b8 02 00 00 00       	mov    $0x2,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <wait>:
SYSCALL(wait)
    12e3:	b8 03 00 00 00       	mov    $0x3,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <pipe>:
SYSCALL(pipe)
    12eb:	b8 04 00 00 00       	mov    $0x4,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <read>:
SYSCALL(read)
    12f3:	b8 05 00 00 00       	mov    $0x5,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <write>:
SYSCALL(write)
    12fb:	b8 12 00 00 00       	mov    $0x12,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <close>:
SYSCALL(close)
    1303:	b8 17 00 00 00       	mov    $0x17,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <kill>:
SYSCALL(kill)
    130b:	b8 06 00 00 00       	mov    $0x6,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <exec>:
SYSCALL(exec)
    1313:	b8 07 00 00 00       	mov    $0x7,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <open>:
SYSCALL(open)
    131b:	b8 11 00 00 00       	mov    $0x11,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <mknod>:
SYSCALL(mknod)
    1323:	b8 13 00 00 00       	mov    $0x13,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <unlink>:
SYSCALL(unlink)
    132b:	b8 14 00 00 00       	mov    $0x14,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <fstat>:
SYSCALL(fstat)
    1333:	b8 08 00 00 00       	mov    $0x8,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <link>:
SYSCALL(link)
    133b:	b8 15 00 00 00       	mov    $0x15,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret    

00001343 <mkdir>:
SYSCALL(mkdir)
    1343:	b8 16 00 00 00       	mov    $0x16,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret    

0000134b <chdir>:
SYSCALL(chdir)
    134b:	b8 09 00 00 00       	mov    $0x9,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <dup>:
SYSCALL(dup)
    1353:	b8 0a 00 00 00       	mov    $0xa,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <getpid>:
SYSCALL(getpid)
    135b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret    

00001363 <sbrk>:
SYSCALL(sbrk)
    1363:	b8 0c 00 00 00       	mov    $0xc,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret    

0000136b <sleep>:
SYSCALL(sleep)
    136b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <uptime>:
SYSCALL(uptime)
    1373:	b8 0e 00 00 00       	mov    $0xe,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    137b:	55                   	push   %ebp
    137c:	89 e5                	mov    %esp,%ebp
    137e:	83 ec 18             	sub    $0x18,%esp
    1381:	8b 45 0c             	mov    0xc(%ebp),%eax
    1384:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1387:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    138e:	00 
    138f:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1392:	89 44 24 04          	mov    %eax,0x4(%esp)
    1396:	8b 45 08             	mov    0x8(%ebp),%eax
    1399:	89 04 24             	mov    %eax,(%esp)
    139c:	e8 5a ff ff ff       	call   12fb <write>
}
    13a1:	c9                   	leave  
    13a2:	c3                   	ret    

000013a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13a3:	55                   	push   %ebp
    13a4:	89 e5                	mov    %esp,%ebp
    13a6:	56                   	push   %esi
    13a7:	53                   	push   %ebx
    13a8:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13b6:	74 17                	je     13cf <printint+0x2c>
    13b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13bc:	79 11                	jns    13cf <printint+0x2c>
    neg = 1;
    13be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13c5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c8:	f7 d8                	neg    %eax
    13ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13cd:	eb 06                	jmp    13d5 <printint+0x32>
  } else {
    x = xx;
    13cf:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13df:	8d 41 01             	lea    0x1(%ecx),%eax
    13e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13eb:	ba 00 00 00 00       	mov    $0x0,%edx
    13f0:	f7 f3                	div    %ebx
    13f2:	89 d0                	mov    %edx,%eax
    13f4:	0f b6 80 c0 2a 00 00 	movzbl 0x2ac0(%eax),%eax
    13fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13ff:	8b 75 10             	mov    0x10(%ebp),%esi
    1402:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1405:	ba 00 00 00 00       	mov    $0x0,%edx
    140a:	f7 f6                	div    %esi
    140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    140f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1413:	75 c7                	jne    13dc <printint+0x39>
  if(neg)
    1415:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1419:	74 10                	je     142b <printint+0x88>
    buf[i++] = '-';
    141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141e:	8d 50 01             	lea    0x1(%eax),%edx
    1421:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1424:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1429:	eb 1f                	jmp    144a <printint+0xa7>
    142b:	eb 1d                	jmp    144a <printint+0xa7>
    putc(fd, buf[i]);
    142d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1430:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1433:	01 d0                	add    %edx,%eax
    1435:	0f b6 00             	movzbl (%eax),%eax
    1438:	0f be c0             	movsbl %al,%eax
    143b:	89 44 24 04          	mov    %eax,0x4(%esp)
    143f:	8b 45 08             	mov    0x8(%ebp),%eax
    1442:	89 04 24             	mov    %eax,(%esp)
    1445:	e8 31 ff ff ff       	call   137b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    144a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    144e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1452:	79 d9                	jns    142d <printint+0x8a>
    putc(fd, buf[i]);
}
    1454:	83 c4 30             	add    $0x30,%esp
    1457:	5b                   	pop    %ebx
    1458:	5e                   	pop    %esi
    1459:	5d                   	pop    %ebp
    145a:	c3                   	ret    

0000145b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    145b:	55                   	push   %ebp
    145c:	89 e5                	mov    %esp,%ebp
    145e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1461:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1468:	8d 45 0c             	lea    0xc(%ebp),%eax
    146b:	83 c0 04             	add    $0x4,%eax
    146e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1471:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1478:	e9 7c 01 00 00       	jmp    15f9 <printf+0x19e>
    c = fmt[i] & 0xff;
    147d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1480:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1483:	01 d0                	add    %edx,%eax
    1485:	0f b6 00             	movzbl (%eax),%eax
    1488:	0f be c0             	movsbl %al,%eax
    148b:	25 ff 00 00 00       	and    $0xff,%eax
    1490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1497:	75 2c                	jne    14c5 <printf+0x6a>
      if(c == '%'){
    1499:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    149d:	75 0c                	jne    14ab <printf+0x50>
        state = '%';
    149f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14a6:	e9 4a 01 00 00       	jmp    15f5 <printf+0x19a>
      } else {
        putc(fd, c);
    14ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14ae:	0f be c0             	movsbl %al,%eax
    14b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    14b5:	8b 45 08             	mov    0x8(%ebp),%eax
    14b8:	89 04 24             	mov    %eax,(%esp)
    14bb:	e8 bb fe ff ff       	call   137b <putc>
    14c0:	e9 30 01 00 00       	jmp    15f5 <printf+0x19a>
      }
    } else if(state == '%'){
    14c5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14c9:	0f 85 26 01 00 00    	jne    15f5 <printf+0x19a>
      if(c == 'd'){
    14cf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14d3:	75 2d                	jne    1502 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d8:	8b 00                	mov    (%eax),%eax
    14da:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14e1:	00 
    14e2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14e9:	00 
    14ea:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ee:	8b 45 08             	mov    0x8(%ebp),%eax
    14f1:	89 04 24             	mov    %eax,(%esp)
    14f4:	e8 aa fe ff ff       	call   13a3 <printint>
        ap++;
    14f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14fd:	e9 ec 00 00 00       	jmp    15ee <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1502:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1506:	74 06                	je     150e <printf+0xb3>
    1508:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    150c:	75 2d                	jne    153b <printf+0xe0>
        printint(fd, *ap, 16, 0);
    150e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1511:	8b 00                	mov    (%eax),%eax
    1513:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    151a:	00 
    151b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1522:	00 
    1523:	89 44 24 04          	mov    %eax,0x4(%esp)
    1527:	8b 45 08             	mov    0x8(%ebp),%eax
    152a:	89 04 24             	mov    %eax,(%esp)
    152d:	e8 71 fe ff ff       	call   13a3 <printint>
        ap++;
    1532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1536:	e9 b3 00 00 00       	jmp    15ee <printf+0x193>
      } else if(c == 's'){
    153b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    153f:	75 45                	jne    1586 <printf+0x12b>
        s = (char*)*ap;
    1541:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1544:	8b 00                	mov    (%eax),%eax
    1546:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    154d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1551:	75 09                	jne    155c <printf+0x101>
          s = "(null)";
    1553:	c7 45 f4 75 18 00 00 	movl   $0x1875,-0xc(%ebp)
        while(*s != 0){
    155a:	eb 1e                	jmp    157a <printf+0x11f>
    155c:	eb 1c                	jmp    157a <printf+0x11f>
          putc(fd, *s);
    155e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1561:	0f b6 00             	movzbl (%eax),%eax
    1564:	0f be c0             	movsbl %al,%eax
    1567:	89 44 24 04          	mov    %eax,0x4(%esp)
    156b:	8b 45 08             	mov    0x8(%ebp),%eax
    156e:	89 04 24             	mov    %eax,(%esp)
    1571:	e8 05 fe ff ff       	call   137b <putc>
          s++;
    1576:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    157a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157d:	0f b6 00             	movzbl (%eax),%eax
    1580:	84 c0                	test   %al,%al
    1582:	75 da                	jne    155e <printf+0x103>
    1584:	eb 68                	jmp    15ee <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1586:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    158a:	75 1d                	jne    15a9 <printf+0x14e>
        putc(fd, *ap);
    158c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158f:	8b 00                	mov    (%eax),%eax
    1591:	0f be c0             	movsbl %al,%eax
    1594:	89 44 24 04          	mov    %eax,0x4(%esp)
    1598:	8b 45 08             	mov    0x8(%ebp),%eax
    159b:	89 04 24             	mov    %eax,(%esp)
    159e:	e8 d8 fd ff ff       	call   137b <putc>
        ap++;
    15a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a7:	eb 45                	jmp    15ee <printf+0x193>
      } else if(c == '%'){
    15a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15ad:	75 17                	jne    15c6 <printf+0x16b>
        putc(fd, c);
    15af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b2:	0f be c0             	movsbl %al,%eax
    15b5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b9:	8b 45 08             	mov    0x8(%ebp),%eax
    15bc:	89 04 24             	mov    %eax,(%esp)
    15bf:	e8 b7 fd ff ff       	call   137b <putc>
    15c4:	eb 28                	jmp    15ee <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15c6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15cd:	00 
    15ce:	8b 45 08             	mov    0x8(%ebp),%eax
    15d1:	89 04 24             	mov    %eax,(%esp)
    15d4:	e8 a2 fd ff ff       	call   137b <putc>
        putc(fd, c);
    15d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15dc:	0f be c0             	movsbl %al,%eax
    15df:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e3:	8b 45 08             	mov    0x8(%ebp),%eax
    15e6:	89 04 24             	mov    %eax,(%esp)
    15e9:	e8 8d fd ff ff       	call   137b <putc>
      }
      state = 0;
    15ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15f9:	8b 55 0c             	mov    0xc(%ebp),%edx
    15fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15ff:	01 d0                	add    %edx,%eax
    1601:	0f b6 00             	movzbl (%eax),%eax
    1604:	84 c0                	test   %al,%al
    1606:	0f 85 71 fe ff ff    	jne    147d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    160c:	c9                   	leave  
    160d:	c3                   	ret    

0000160e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    160e:	55                   	push   %ebp
    160f:	89 e5                	mov    %esp,%ebp
    1611:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1614:	8b 45 08             	mov    0x8(%ebp),%eax
    1617:	83 e8 08             	sub    $0x8,%eax
    161a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    161d:	a1 dc 2a 00 00       	mov    0x2adc,%eax
    1622:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1625:	eb 24                	jmp    164b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1627:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162a:	8b 00                	mov    (%eax),%eax
    162c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162f:	77 12                	ja     1643 <free+0x35>
    1631:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1634:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1637:	77 24                	ja     165d <free+0x4f>
    1639:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163c:	8b 00                	mov    (%eax),%eax
    163e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1641:	77 1a                	ja     165d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1643:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1646:	8b 00                	mov    (%eax),%eax
    1648:	89 45 fc             	mov    %eax,-0x4(%ebp)
    164b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1651:	76 d4                	jbe    1627 <free+0x19>
    1653:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1656:	8b 00                	mov    (%eax),%eax
    1658:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    165b:	76 ca                	jbe    1627 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1660:	8b 40 04             	mov    0x4(%eax),%eax
    1663:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    166a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166d:	01 c2                	add    %eax,%edx
    166f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1672:	8b 00                	mov    (%eax),%eax
    1674:	39 c2                	cmp    %eax,%edx
    1676:	75 24                	jne    169c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1678:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167b:	8b 50 04             	mov    0x4(%eax),%edx
    167e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1681:	8b 00                	mov    (%eax),%eax
    1683:	8b 40 04             	mov    0x4(%eax),%eax
    1686:	01 c2                	add    %eax,%edx
    1688:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1691:	8b 00                	mov    (%eax),%eax
    1693:	8b 10                	mov    (%eax),%edx
    1695:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1698:	89 10                	mov    %edx,(%eax)
    169a:	eb 0a                	jmp    16a6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    169c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169f:	8b 10                	mov    (%eax),%edx
    16a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a9:	8b 40 04             	mov    0x4(%eax),%eax
    16ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b6:	01 d0                	add    %edx,%eax
    16b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16bb:	75 20                	jne    16dd <free+0xcf>
    p->s.size += bp->s.size;
    16bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c0:	8b 50 04             	mov    0x4(%eax),%edx
    16c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c6:	8b 40 04             	mov    0x4(%eax),%eax
    16c9:	01 c2                	add    %eax,%edx
    16cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d4:	8b 10                	mov    (%eax),%edx
    16d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d9:	89 10                	mov    %edx,(%eax)
    16db:	eb 08                	jmp    16e5 <free+0xd7>
  } else
    p->s.ptr = bp;
    16dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16e3:	89 10                	mov    %edx,(%eax)
  freep = p;
    16e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e8:	a3 dc 2a 00 00       	mov    %eax,0x2adc
}
    16ed:	c9                   	leave  
    16ee:	c3                   	ret    

000016ef <morecore>:

static Header*
morecore(uint nu)
{
    16ef:	55                   	push   %ebp
    16f0:	89 e5                	mov    %esp,%ebp
    16f2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16f5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16fc:	77 07                	ja     1705 <morecore+0x16>
    nu = 4096;
    16fe:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1705:	8b 45 08             	mov    0x8(%ebp),%eax
    1708:	c1 e0 03             	shl    $0x3,%eax
    170b:	89 04 24             	mov    %eax,(%esp)
    170e:	e8 50 fc ff ff       	call   1363 <sbrk>
    1713:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1716:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    171a:	75 07                	jne    1723 <morecore+0x34>
    return 0;
    171c:	b8 00 00 00 00       	mov    $0x0,%eax
    1721:	eb 22                	jmp    1745 <morecore+0x56>
  hp = (Header*)p;
    1723:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1729:	8b 45 f0             	mov    -0x10(%ebp),%eax
    172c:	8b 55 08             	mov    0x8(%ebp),%edx
    172f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1732:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1735:	83 c0 08             	add    $0x8,%eax
    1738:	89 04 24             	mov    %eax,(%esp)
    173b:	e8 ce fe ff ff       	call   160e <free>
  return freep;
    1740:	a1 dc 2a 00 00       	mov    0x2adc,%eax
}
    1745:	c9                   	leave  
    1746:	c3                   	ret    

00001747 <malloc>:

void*
malloc(uint nbytes)
{
    1747:	55                   	push   %ebp
    1748:	89 e5                	mov    %esp,%ebp
    174a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    174d:	8b 45 08             	mov    0x8(%ebp),%eax
    1750:	83 c0 07             	add    $0x7,%eax
    1753:	c1 e8 03             	shr    $0x3,%eax
    1756:	83 c0 01             	add    $0x1,%eax
    1759:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    175c:	a1 dc 2a 00 00       	mov    0x2adc,%eax
    1761:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1764:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1768:	75 23                	jne    178d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    176a:	c7 45 f0 d4 2a 00 00 	movl   $0x2ad4,-0x10(%ebp)
    1771:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1774:	a3 dc 2a 00 00       	mov    %eax,0x2adc
    1779:	a1 dc 2a 00 00       	mov    0x2adc,%eax
    177e:	a3 d4 2a 00 00       	mov    %eax,0x2ad4
    base.s.size = 0;
    1783:	c7 05 d8 2a 00 00 00 	movl   $0x0,0x2ad8
    178a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1790:	8b 00                	mov    (%eax),%eax
    1792:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1795:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1798:	8b 40 04             	mov    0x4(%eax),%eax
    179b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    179e:	72 4d                	jb     17ed <malloc+0xa6>
      if(p->s.size == nunits)
    17a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a3:	8b 40 04             	mov    0x4(%eax),%eax
    17a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17a9:	75 0c                	jne    17b7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ae:	8b 10                	mov    (%eax),%edx
    17b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b3:	89 10                	mov    %edx,(%eax)
    17b5:	eb 26                	jmp    17dd <malloc+0x96>
      else {
        p->s.size -= nunits;
    17b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ba:	8b 40 04             	mov    0x4(%eax),%eax
    17bd:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17c0:	89 c2                	mov    %eax,%edx
    17c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cb:	8b 40 04             	mov    0x4(%eax),%eax
    17ce:	c1 e0 03             	shl    $0x3,%eax
    17d1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17da:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e0:	a3 dc 2a 00 00       	mov    %eax,0x2adc
      return (void*)(p + 1);
    17e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e8:	83 c0 08             	add    $0x8,%eax
    17eb:	eb 38                	jmp    1825 <malloc+0xde>
    }
    if(p == freep)
    17ed:	a1 dc 2a 00 00       	mov    0x2adc,%eax
    17f2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17f5:	75 1b                	jne    1812 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17fa:	89 04 24             	mov    %eax,(%esp)
    17fd:	e8 ed fe ff ff       	call   16ef <morecore>
    1802:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1809:	75 07                	jne    1812 <malloc+0xcb>
        return 0;
    180b:	b8 00 00 00 00       	mov    $0x0,%eax
    1810:	eb 13                	jmp    1825 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1812:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1815:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1818:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181b:	8b 00                	mov    (%eax),%eax
    181d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1820:	e9 70 ff ff ff       	jmp    1795 <malloc+0x4e>
}
    1825:	c9                   	leave  
    1826:	c3                   	ret    
