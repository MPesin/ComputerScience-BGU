
_s2:     file format elf32-i386


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
   char *buf = 0;
    1009:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    1010:	00 
   printf(1,"trying to access ADDRESS 0\n");
    1011:	c7 44 24 04 f5 17 00 	movl   $0x17f5,0x4(%esp)
    1018:	00 
    1019:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1020:	e8 04 04 00 00       	call   1429 <printf>
   buf[0] = 'a';
    1025:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1029:	c6 00 61             	movb   $0x61,(%eax)
   exit();
    102c:	e8 78 02 00 00       	call   12a9 <exit>

00001031 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1031:	55                   	push   %ebp
    1032:	89 e5                	mov    %esp,%ebp
    1034:	57                   	push   %edi
    1035:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1036:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1039:	8b 55 10             	mov    0x10(%ebp),%edx
    103c:	8b 45 0c             	mov    0xc(%ebp),%eax
    103f:	89 cb                	mov    %ecx,%ebx
    1041:	89 df                	mov    %ebx,%edi
    1043:	89 d1                	mov    %edx,%ecx
    1045:	fc                   	cld    
    1046:	f3 aa                	rep stos %al,%es:(%edi)
    1048:	89 ca                	mov    %ecx,%edx
    104a:	89 fb                	mov    %edi,%ebx
    104c:	89 5d 08             	mov    %ebx,0x8(%ebp)
    104f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1052:	5b                   	pop    %ebx
    1053:	5f                   	pop    %edi
    1054:	5d                   	pop    %ebp
    1055:	c3                   	ret    

00001056 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1056:	55                   	push   %ebp
    1057:	89 e5                	mov    %esp,%ebp
    1059:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    105c:	8b 45 08             	mov    0x8(%ebp),%eax
    105f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1062:	90                   	nop
    1063:	8b 45 08             	mov    0x8(%ebp),%eax
    1066:	8d 50 01             	lea    0x1(%eax),%edx
    1069:	89 55 08             	mov    %edx,0x8(%ebp)
    106c:	8b 55 0c             	mov    0xc(%ebp),%edx
    106f:	8d 4a 01             	lea    0x1(%edx),%ecx
    1072:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1075:	0f b6 12             	movzbl (%edx),%edx
    1078:	88 10                	mov    %dl,(%eax)
    107a:	0f b6 00             	movzbl (%eax),%eax
    107d:	84 c0                	test   %al,%al
    107f:	75 e2                	jne    1063 <strcpy+0xd>
    ;
  return os;
    1081:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1084:	c9                   	leave  
    1085:	c3                   	ret    

00001086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1086:	55                   	push   %ebp
    1087:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1089:	eb 08                	jmp    1093 <strcmp+0xd>
    p++, q++;
    108b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    108f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	0f b6 00             	movzbl (%eax),%eax
    1099:	84 c0                	test   %al,%al
    109b:	74 10                	je     10ad <strcmp+0x27>
    109d:	8b 45 08             	mov    0x8(%ebp),%eax
    10a0:	0f b6 10             	movzbl (%eax),%edx
    10a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a6:	0f b6 00             	movzbl (%eax),%eax
    10a9:	38 c2                	cmp    %al,%dl
    10ab:	74 de                	je     108b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10ad:	8b 45 08             	mov    0x8(%ebp),%eax
    10b0:	0f b6 00             	movzbl (%eax),%eax
    10b3:	0f b6 d0             	movzbl %al,%edx
    10b6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b9:	0f b6 00             	movzbl (%eax),%eax
    10bc:	0f b6 c0             	movzbl %al,%eax
    10bf:	29 c2                	sub    %eax,%edx
    10c1:	89 d0                	mov    %edx,%eax
}
    10c3:	5d                   	pop    %ebp
    10c4:	c3                   	ret    

000010c5 <strlen>:

uint
strlen(char *s)
{
    10c5:	55                   	push   %ebp
    10c6:	89 e5                	mov    %esp,%ebp
    10c8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10d2:	eb 04                	jmp    10d8 <strlen+0x13>
    10d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10db:	8b 45 08             	mov    0x8(%ebp),%eax
    10de:	01 d0                	add    %edx,%eax
    10e0:	0f b6 00             	movzbl (%eax),%eax
    10e3:	84 c0                	test   %al,%al
    10e5:	75 ed                	jne    10d4 <strlen+0xf>
    ;
  return n;
    10e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10ea:	c9                   	leave  
    10eb:	c3                   	ret    

000010ec <memset>:

void*
memset(void *dst, int c, uint n)
{
    10ec:	55                   	push   %ebp
    10ed:	89 e5                	mov    %esp,%ebp
    10ef:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10f2:	8b 45 10             	mov    0x10(%ebp),%eax
    10f5:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10fc:	89 44 24 04          	mov    %eax,0x4(%esp)
    1100:	8b 45 08             	mov    0x8(%ebp),%eax
    1103:	89 04 24             	mov    %eax,(%esp)
    1106:	e8 26 ff ff ff       	call   1031 <stosb>
  return dst;
    110b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    110e:	c9                   	leave  
    110f:	c3                   	ret    

00001110 <strchr>:

char*
strchr(const char *s, char c)
{
    1110:	55                   	push   %ebp
    1111:	89 e5                	mov    %esp,%ebp
    1113:	83 ec 04             	sub    $0x4,%esp
    1116:	8b 45 0c             	mov    0xc(%ebp),%eax
    1119:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    111c:	eb 14                	jmp    1132 <strchr+0x22>
    if(*s == c)
    111e:	8b 45 08             	mov    0x8(%ebp),%eax
    1121:	0f b6 00             	movzbl (%eax),%eax
    1124:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1127:	75 05                	jne    112e <strchr+0x1e>
      return (char*)s;
    1129:	8b 45 08             	mov    0x8(%ebp),%eax
    112c:	eb 13                	jmp    1141 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    112e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1132:	8b 45 08             	mov    0x8(%ebp),%eax
    1135:	0f b6 00             	movzbl (%eax),%eax
    1138:	84 c0                	test   %al,%al
    113a:	75 e2                	jne    111e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    113c:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1141:	c9                   	leave  
    1142:	c3                   	ret    

00001143 <gets>:

char*
gets(char *buf, int max)
{
    1143:	55                   	push   %ebp
    1144:	89 e5                	mov    %esp,%ebp
    1146:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1149:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1150:	eb 4c                	jmp    119e <gets+0x5b>
    cc = read(0, &c, 1);
    1152:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1159:	00 
    115a:	8d 45 ef             	lea    -0x11(%ebp),%eax
    115d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1161:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1168:	e8 54 01 00 00       	call   12c1 <read>
    116d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1170:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1174:	7f 02                	jg     1178 <gets+0x35>
      break;
    1176:	eb 31                	jmp    11a9 <gets+0x66>
    buf[i++] = c;
    1178:	8b 45 f4             	mov    -0xc(%ebp),%eax
    117b:	8d 50 01             	lea    0x1(%eax),%edx
    117e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1181:	89 c2                	mov    %eax,%edx
    1183:	8b 45 08             	mov    0x8(%ebp),%eax
    1186:	01 c2                	add    %eax,%edx
    1188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    118c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    118e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1192:	3c 0a                	cmp    $0xa,%al
    1194:	74 13                	je     11a9 <gets+0x66>
    1196:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    119a:	3c 0d                	cmp    $0xd,%al
    119c:	74 0b                	je     11a9 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    119e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a1:	83 c0 01             	add    $0x1,%eax
    11a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11a7:	7c a9                	jl     1152 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11ac:	8b 45 08             	mov    0x8(%ebp),%eax
    11af:	01 d0                	add    %edx,%eax
    11b1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11b7:	c9                   	leave  
    11b8:	c3                   	ret    

000011b9 <stat>:

int
stat(char *n, struct stat *st)
{
    11b9:	55                   	push   %ebp
    11ba:	89 e5                	mov    %esp,%ebp
    11bc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11c6:	00 
    11c7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ca:	89 04 24             	mov    %eax,(%esp)
    11cd:	e8 17 01 00 00       	call   12e9 <open>
    11d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11d9:	79 07                	jns    11e2 <stat+0x29>
    return -1;
    11db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11e0:	eb 23                	jmp    1205 <stat+0x4c>
  r = fstat(fd, st);
    11e2:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    11e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ec:	89 04 24             	mov    %eax,(%esp)
    11ef:	e8 0d 01 00 00       	call   1301 <fstat>
    11f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11fa:	89 04 24             	mov    %eax,(%esp)
    11fd:	e8 cf 00 00 00       	call   12d1 <close>
  return r;
    1202:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1205:	c9                   	leave  
    1206:	c3                   	ret    

00001207 <atoi>:

int
atoi(const char *s)
{
    1207:	55                   	push   %ebp
    1208:	89 e5                	mov    %esp,%ebp
    120a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    120d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1214:	eb 25                	jmp    123b <atoi+0x34>
    n = n*10 + *s++ - '0';
    1216:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1219:	89 d0                	mov    %edx,%eax
    121b:	c1 e0 02             	shl    $0x2,%eax
    121e:	01 d0                	add    %edx,%eax
    1220:	01 c0                	add    %eax,%eax
    1222:	89 c1                	mov    %eax,%ecx
    1224:	8b 45 08             	mov    0x8(%ebp),%eax
    1227:	8d 50 01             	lea    0x1(%eax),%edx
    122a:	89 55 08             	mov    %edx,0x8(%ebp)
    122d:	0f b6 00             	movzbl (%eax),%eax
    1230:	0f be c0             	movsbl %al,%eax
    1233:	01 c8                	add    %ecx,%eax
    1235:	83 e8 30             	sub    $0x30,%eax
    1238:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    123b:	8b 45 08             	mov    0x8(%ebp),%eax
    123e:	0f b6 00             	movzbl (%eax),%eax
    1241:	3c 2f                	cmp    $0x2f,%al
    1243:	7e 0a                	jle    124f <atoi+0x48>
    1245:	8b 45 08             	mov    0x8(%ebp),%eax
    1248:	0f b6 00             	movzbl (%eax),%eax
    124b:	3c 39                	cmp    $0x39,%al
    124d:	7e c7                	jle    1216 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    124f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1252:	c9                   	leave  
    1253:	c3                   	ret    

00001254 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1254:	55                   	push   %ebp
    1255:	89 e5                	mov    %esp,%ebp
    1257:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    125a:	8b 45 08             	mov    0x8(%ebp),%eax
    125d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1260:	8b 45 0c             	mov    0xc(%ebp),%eax
    1263:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1266:	eb 17                	jmp    127f <memmove+0x2b>
    *dst++ = *src++;
    1268:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126b:	8d 50 01             	lea    0x1(%eax),%edx
    126e:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1271:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1274:	8d 4a 01             	lea    0x1(%edx),%ecx
    1277:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    127a:	0f b6 12             	movzbl (%edx),%edx
    127d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    127f:	8b 45 10             	mov    0x10(%ebp),%eax
    1282:	8d 50 ff             	lea    -0x1(%eax),%edx
    1285:	89 55 10             	mov    %edx,0x10(%ebp)
    1288:	85 c0                	test   %eax,%eax
    128a:	7f dc                	jg     1268 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    128f:	c9                   	leave  
    1290:	c3                   	ret    

00001291 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1291:	b8 01 00 00 00       	mov    $0x1,%eax
    1296:	cd 40                	int    $0x40
    1298:	c3                   	ret    

00001299 <cowfork>:
SYSCALL(cowfork)
    1299:	b8 0f 00 00 00       	mov    $0xf,%eax
    129e:	cd 40                	int    $0x40
    12a0:	c3                   	ret    

000012a1 <procdump>:
SYSCALL(procdump)
    12a1:	b8 10 00 00 00       	mov    $0x10,%eax
    12a6:	cd 40                	int    $0x40
    12a8:	c3                   	ret    

000012a9 <exit>:
SYSCALL(exit)
    12a9:	b8 02 00 00 00       	mov    $0x2,%eax
    12ae:	cd 40                	int    $0x40
    12b0:	c3                   	ret    

000012b1 <wait>:
SYSCALL(wait)
    12b1:	b8 03 00 00 00       	mov    $0x3,%eax
    12b6:	cd 40                	int    $0x40
    12b8:	c3                   	ret    

000012b9 <pipe>:
SYSCALL(pipe)
    12b9:	b8 04 00 00 00       	mov    $0x4,%eax
    12be:	cd 40                	int    $0x40
    12c0:	c3                   	ret    

000012c1 <read>:
SYSCALL(read)
    12c1:	b8 05 00 00 00       	mov    $0x5,%eax
    12c6:	cd 40                	int    $0x40
    12c8:	c3                   	ret    

000012c9 <write>:
SYSCALL(write)
    12c9:	b8 12 00 00 00       	mov    $0x12,%eax
    12ce:	cd 40                	int    $0x40
    12d0:	c3                   	ret    

000012d1 <close>:
SYSCALL(close)
    12d1:	b8 17 00 00 00       	mov    $0x17,%eax
    12d6:	cd 40                	int    $0x40
    12d8:	c3                   	ret    

000012d9 <kill>:
SYSCALL(kill)
    12d9:	b8 06 00 00 00       	mov    $0x6,%eax
    12de:	cd 40                	int    $0x40
    12e0:	c3                   	ret    

000012e1 <exec>:
SYSCALL(exec)
    12e1:	b8 07 00 00 00       	mov    $0x7,%eax
    12e6:	cd 40                	int    $0x40
    12e8:	c3                   	ret    

000012e9 <open>:
SYSCALL(open)
    12e9:	b8 11 00 00 00       	mov    $0x11,%eax
    12ee:	cd 40                	int    $0x40
    12f0:	c3                   	ret    

000012f1 <mknod>:
SYSCALL(mknod)
    12f1:	b8 13 00 00 00       	mov    $0x13,%eax
    12f6:	cd 40                	int    $0x40
    12f8:	c3                   	ret    

000012f9 <unlink>:
SYSCALL(unlink)
    12f9:	b8 14 00 00 00       	mov    $0x14,%eax
    12fe:	cd 40                	int    $0x40
    1300:	c3                   	ret    

00001301 <fstat>:
SYSCALL(fstat)
    1301:	b8 08 00 00 00       	mov    $0x8,%eax
    1306:	cd 40                	int    $0x40
    1308:	c3                   	ret    

00001309 <link>:
SYSCALL(link)
    1309:	b8 15 00 00 00       	mov    $0x15,%eax
    130e:	cd 40                	int    $0x40
    1310:	c3                   	ret    

00001311 <mkdir>:
SYSCALL(mkdir)
    1311:	b8 16 00 00 00       	mov    $0x16,%eax
    1316:	cd 40                	int    $0x40
    1318:	c3                   	ret    

00001319 <chdir>:
SYSCALL(chdir)
    1319:	b8 09 00 00 00       	mov    $0x9,%eax
    131e:	cd 40                	int    $0x40
    1320:	c3                   	ret    

00001321 <dup>:
SYSCALL(dup)
    1321:	b8 0a 00 00 00       	mov    $0xa,%eax
    1326:	cd 40                	int    $0x40
    1328:	c3                   	ret    

00001329 <getpid>:
SYSCALL(getpid)
    1329:	b8 0b 00 00 00       	mov    $0xb,%eax
    132e:	cd 40                	int    $0x40
    1330:	c3                   	ret    

00001331 <sbrk>:
SYSCALL(sbrk)
    1331:	b8 0c 00 00 00       	mov    $0xc,%eax
    1336:	cd 40                	int    $0x40
    1338:	c3                   	ret    

00001339 <sleep>:
SYSCALL(sleep)
    1339:	b8 0d 00 00 00       	mov    $0xd,%eax
    133e:	cd 40                	int    $0x40
    1340:	c3                   	ret    

00001341 <uptime>:
SYSCALL(uptime)
    1341:	b8 0e 00 00 00       	mov    $0xe,%eax
    1346:	cd 40                	int    $0x40
    1348:	c3                   	ret    

00001349 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1349:	55                   	push   %ebp
    134a:	89 e5                	mov    %esp,%ebp
    134c:	83 ec 18             	sub    $0x18,%esp
    134f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1352:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1355:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    135c:	00 
    135d:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1360:	89 44 24 04          	mov    %eax,0x4(%esp)
    1364:	8b 45 08             	mov    0x8(%ebp),%eax
    1367:	89 04 24             	mov    %eax,(%esp)
    136a:	e8 5a ff ff ff       	call   12c9 <write>
}
    136f:	c9                   	leave  
    1370:	c3                   	ret    

00001371 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1371:	55                   	push   %ebp
    1372:	89 e5                	mov    %esp,%ebp
    1374:	56                   	push   %esi
    1375:	53                   	push   %ebx
    1376:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1379:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1380:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1384:	74 17                	je     139d <printint+0x2c>
    1386:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    138a:	79 11                	jns    139d <printint+0x2c>
    neg = 1;
    138c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1393:	8b 45 0c             	mov    0xc(%ebp),%eax
    1396:	f7 d8                	neg    %eax
    1398:	89 45 ec             	mov    %eax,-0x14(%ebp)
    139b:	eb 06                	jmp    13a3 <printint+0x32>
  } else {
    x = xx;
    139d:	8b 45 0c             	mov    0xc(%ebp),%eax
    13a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13ad:	8d 41 01             	lea    0x1(%ecx),%eax
    13b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13b9:	ba 00 00 00 00       	mov    $0x0,%edx
    13be:	f7 f3                	div    %ebx
    13c0:	89 d0                	mov    %edx,%eax
    13c2:	0f b6 80 5c 2a 00 00 	movzbl 0x2a5c(%eax),%eax
    13c9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13cd:	8b 75 10             	mov    0x10(%ebp),%esi
    13d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13d3:	ba 00 00 00 00       	mov    $0x0,%edx
    13d8:	f7 f6                	div    %esi
    13da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13e1:	75 c7                	jne    13aa <printint+0x39>
  if(neg)
    13e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13e7:	74 10                	je     13f9 <printint+0x88>
    buf[i++] = '-';
    13e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ec:	8d 50 01             	lea    0x1(%eax),%edx
    13ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13f2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    13f7:	eb 1f                	jmp    1418 <printint+0xa7>
    13f9:	eb 1d                	jmp    1418 <printint+0xa7>
    putc(fd, buf[i]);
    13fb:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1401:	01 d0                	add    %edx,%eax
    1403:	0f b6 00             	movzbl (%eax),%eax
    1406:	0f be c0             	movsbl %al,%eax
    1409:	89 44 24 04          	mov    %eax,0x4(%esp)
    140d:	8b 45 08             	mov    0x8(%ebp),%eax
    1410:	89 04 24             	mov    %eax,(%esp)
    1413:	e8 31 ff ff ff       	call   1349 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1418:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    141c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1420:	79 d9                	jns    13fb <printint+0x8a>
    putc(fd, buf[i]);
}
    1422:	83 c4 30             	add    $0x30,%esp
    1425:	5b                   	pop    %ebx
    1426:	5e                   	pop    %esi
    1427:	5d                   	pop    %ebp
    1428:	c3                   	ret    

00001429 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1429:	55                   	push   %ebp
    142a:	89 e5                	mov    %esp,%ebp
    142c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    142f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1436:	8d 45 0c             	lea    0xc(%ebp),%eax
    1439:	83 c0 04             	add    $0x4,%eax
    143c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    143f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1446:	e9 7c 01 00 00       	jmp    15c7 <printf+0x19e>
    c = fmt[i] & 0xff;
    144b:	8b 55 0c             	mov    0xc(%ebp),%edx
    144e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1451:	01 d0                	add    %edx,%eax
    1453:	0f b6 00             	movzbl (%eax),%eax
    1456:	0f be c0             	movsbl %al,%eax
    1459:	25 ff 00 00 00       	and    $0xff,%eax
    145e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1461:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1465:	75 2c                	jne    1493 <printf+0x6a>
      if(c == '%'){
    1467:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    146b:	75 0c                	jne    1479 <printf+0x50>
        state = '%';
    146d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1474:	e9 4a 01 00 00       	jmp    15c3 <printf+0x19a>
      } else {
        putc(fd, c);
    1479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    147c:	0f be c0             	movsbl %al,%eax
    147f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1483:	8b 45 08             	mov    0x8(%ebp),%eax
    1486:	89 04 24             	mov    %eax,(%esp)
    1489:	e8 bb fe ff ff       	call   1349 <putc>
    148e:	e9 30 01 00 00       	jmp    15c3 <printf+0x19a>
      }
    } else if(state == '%'){
    1493:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1497:	0f 85 26 01 00 00    	jne    15c3 <printf+0x19a>
      if(c == 'd'){
    149d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14a1:	75 2d                	jne    14d0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14a6:	8b 00                	mov    (%eax),%eax
    14a8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14af:	00 
    14b0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14b7:	00 
    14b8:	89 44 24 04          	mov    %eax,0x4(%esp)
    14bc:	8b 45 08             	mov    0x8(%ebp),%eax
    14bf:	89 04 24             	mov    %eax,(%esp)
    14c2:	e8 aa fe ff ff       	call   1371 <printint>
        ap++;
    14c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14cb:	e9 ec 00 00 00       	jmp    15bc <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14d0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14d4:	74 06                	je     14dc <printf+0xb3>
    14d6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14da:	75 2d                	jne    1509 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    14dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14df:	8b 00                	mov    (%eax),%eax
    14e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14e8:	00 
    14e9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    14f0:	00 
    14f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f5:	8b 45 08             	mov    0x8(%ebp),%eax
    14f8:	89 04 24             	mov    %eax,(%esp)
    14fb:	e8 71 fe ff ff       	call   1371 <printint>
        ap++;
    1500:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1504:	e9 b3 00 00 00       	jmp    15bc <printf+0x193>
      } else if(c == 's'){
    1509:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    150d:	75 45                	jne    1554 <printf+0x12b>
        s = (char*)*ap;
    150f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1512:	8b 00                	mov    (%eax),%eax
    1514:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    151b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    151f:	75 09                	jne    152a <printf+0x101>
          s = "(null)";
    1521:	c7 45 f4 11 18 00 00 	movl   $0x1811,-0xc(%ebp)
        while(*s != 0){
    1528:	eb 1e                	jmp    1548 <printf+0x11f>
    152a:	eb 1c                	jmp    1548 <printf+0x11f>
          putc(fd, *s);
    152c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    152f:	0f b6 00             	movzbl (%eax),%eax
    1532:	0f be c0             	movsbl %al,%eax
    1535:	89 44 24 04          	mov    %eax,0x4(%esp)
    1539:	8b 45 08             	mov    0x8(%ebp),%eax
    153c:	89 04 24             	mov    %eax,(%esp)
    153f:	e8 05 fe ff ff       	call   1349 <putc>
          s++;
    1544:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1548:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154b:	0f b6 00             	movzbl (%eax),%eax
    154e:	84 c0                	test   %al,%al
    1550:	75 da                	jne    152c <printf+0x103>
    1552:	eb 68                	jmp    15bc <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1554:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1558:	75 1d                	jne    1577 <printf+0x14e>
        putc(fd, *ap);
    155a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    155d:	8b 00                	mov    (%eax),%eax
    155f:	0f be c0             	movsbl %al,%eax
    1562:	89 44 24 04          	mov    %eax,0x4(%esp)
    1566:	8b 45 08             	mov    0x8(%ebp),%eax
    1569:	89 04 24             	mov    %eax,(%esp)
    156c:	e8 d8 fd ff ff       	call   1349 <putc>
        ap++;
    1571:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1575:	eb 45                	jmp    15bc <printf+0x193>
      } else if(c == '%'){
    1577:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    157b:	75 17                	jne    1594 <printf+0x16b>
        putc(fd, c);
    157d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1580:	0f be c0             	movsbl %al,%eax
    1583:	89 44 24 04          	mov    %eax,0x4(%esp)
    1587:	8b 45 08             	mov    0x8(%ebp),%eax
    158a:	89 04 24             	mov    %eax,(%esp)
    158d:	e8 b7 fd ff ff       	call   1349 <putc>
    1592:	eb 28                	jmp    15bc <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1594:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    159b:	00 
    159c:	8b 45 08             	mov    0x8(%ebp),%eax
    159f:	89 04 24             	mov    %eax,(%esp)
    15a2:	e8 a2 fd ff ff       	call   1349 <putc>
        putc(fd, c);
    15a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15aa:	0f be c0             	movsbl %al,%eax
    15ad:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b1:	8b 45 08             	mov    0x8(%ebp),%eax
    15b4:	89 04 24             	mov    %eax,(%esp)
    15b7:	e8 8d fd ff ff       	call   1349 <putc>
      }
      state = 0;
    15bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15c7:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15cd:	01 d0                	add    %edx,%eax
    15cf:	0f b6 00             	movzbl (%eax),%eax
    15d2:	84 c0                	test   %al,%al
    15d4:	0f 85 71 fe ff ff    	jne    144b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15da:	c9                   	leave  
    15db:	c3                   	ret    

000015dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15dc:	55                   	push   %ebp
    15dd:	89 e5                	mov    %esp,%ebp
    15df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15e2:	8b 45 08             	mov    0x8(%ebp),%eax
    15e5:	83 e8 08             	sub    $0x8,%eax
    15e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15eb:	a1 78 2a 00 00       	mov    0x2a78,%eax
    15f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15f3:	eb 24                	jmp    1619 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15f8:	8b 00                	mov    (%eax),%eax
    15fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15fd:	77 12                	ja     1611 <free+0x35>
    15ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1605:	77 24                	ja     162b <free+0x4f>
    1607:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160a:	8b 00                	mov    (%eax),%eax
    160c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    160f:	77 1a                	ja     162b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1611:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1614:	8b 00                	mov    (%eax),%eax
    1616:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1619:	8b 45 f8             	mov    -0x8(%ebp),%eax
    161c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    161f:	76 d4                	jbe    15f5 <free+0x19>
    1621:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1624:	8b 00                	mov    (%eax),%eax
    1626:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1629:	76 ca                	jbe    15f5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    162b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162e:	8b 40 04             	mov    0x4(%eax),%eax
    1631:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1638:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163b:	01 c2                	add    %eax,%edx
    163d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1640:	8b 00                	mov    (%eax),%eax
    1642:	39 c2                	cmp    %eax,%edx
    1644:	75 24                	jne    166a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1646:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1649:	8b 50 04             	mov    0x4(%eax),%edx
    164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164f:	8b 00                	mov    (%eax),%eax
    1651:	8b 40 04             	mov    0x4(%eax),%eax
    1654:	01 c2                	add    %eax,%edx
    1656:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1659:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    165c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165f:	8b 00                	mov    (%eax),%eax
    1661:	8b 10                	mov    (%eax),%edx
    1663:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1666:	89 10                	mov    %edx,(%eax)
    1668:	eb 0a                	jmp    1674 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166d:	8b 10                	mov    (%eax),%edx
    166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1672:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1674:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1677:	8b 40 04             	mov    0x4(%eax),%eax
    167a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1681:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1684:	01 d0                	add    %edx,%eax
    1686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1689:	75 20                	jne    16ab <free+0xcf>
    p->s.size += bp->s.size;
    168b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168e:	8b 50 04             	mov    0x4(%eax),%edx
    1691:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1694:	8b 40 04             	mov    0x4(%eax),%eax
    1697:	01 c2                	add    %eax,%edx
    1699:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    169f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a2:	8b 10                	mov    (%eax),%edx
    16a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a7:	89 10                	mov    %edx,(%eax)
    16a9:	eb 08                	jmp    16b3 <free+0xd7>
  } else
    p->s.ptr = bp;
    16ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16b1:	89 10                	mov    %edx,(%eax)
  freep = p;
    16b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b6:	a3 78 2a 00 00       	mov    %eax,0x2a78
}
    16bb:	c9                   	leave  
    16bc:	c3                   	ret    

000016bd <morecore>:

static Header*
morecore(uint nu)
{
    16bd:	55                   	push   %ebp
    16be:	89 e5                	mov    %esp,%ebp
    16c0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16c3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16ca:	77 07                	ja     16d3 <morecore+0x16>
    nu = 4096;
    16cc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16d3:	8b 45 08             	mov    0x8(%ebp),%eax
    16d6:	c1 e0 03             	shl    $0x3,%eax
    16d9:	89 04 24             	mov    %eax,(%esp)
    16dc:	e8 50 fc ff ff       	call   1331 <sbrk>
    16e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16e4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16e8:	75 07                	jne    16f1 <morecore+0x34>
    return 0;
    16ea:	b8 00 00 00 00       	mov    $0x0,%eax
    16ef:	eb 22                	jmp    1713 <morecore+0x56>
  hp = (Header*)p;
    16f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16fa:	8b 55 08             	mov    0x8(%ebp),%edx
    16fd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1700:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1703:	83 c0 08             	add    $0x8,%eax
    1706:	89 04 24             	mov    %eax,(%esp)
    1709:	e8 ce fe ff ff       	call   15dc <free>
  return freep;
    170e:	a1 78 2a 00 00       	mov    0x2a78,%eax
}
    1713:	c9                   	leave  
    1714:	c3                   	ret    

00001715 <malloc>:

void*
malloc(uint nbytes)
{
    1715:	55                   	push   %ebp
    1716:	89 e5                	mov    %esp,%ebp
    1718:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    171b:	8b 45 08             	mov    0x8(%ebp),%eax
    171e:	83 c0 07             	add    $0x7,%eax
    1721:	c1 e8 03             	shr    $0x3,%eax
    1724:	83 c0 01             	add    $0x1,%eax
    1727:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    172a:	a1 78 2a 00 00       	mov    0x2a78,%eax
    172f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1732:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1736:	75 23                	jne    175b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1738:	c7 45 f0 70 2a 00 00 	movl   $0x2a70,-0x10(%ebp)
    173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1742:	a3 78 2a 00 00       	mov    %eax,0x2a78
    1747:	a1 78 2a 00 00       	mov    0x2a78,%eax
    174c:	a3 70 2a 00 00       	mov    %eax,0x2a70
    base.s.size = 0;
    1751:	c7 05 74 2a 00 00 00 	movl   $0x0,0x2a74
    1758:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    175e:	8b 00                	mov    (%eax),%eax
    1760:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1763:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1766:	8b 40 04             	mov    0x4(%eax),%eax
    1769:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    176c:	72 4d                	jb     17bb <malloc+0xa6>
      if(p->s.size == nunits)
    176e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1771:	8b 40 04             	mov    0x4(%eax),%eax
    1774:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1777:	75 0c                	jne    1785 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1779:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177c:	8b 10                	mov    (%eax),%edx
    177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1781:	89 10                	mov    %edx,(%eax)
    1783:	eb 26                	jmp    17ab <malloc+0x96>
      else {
        p->s.size -= nunits;
    1785:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1788:	8b 40 04             	mov    0x4(%eax),%eax
    178b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    178e:	89 c2                	mov    %eax,%edx
    1790:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1793:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1796:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1799:	8b 40 04             	mov    0x4(%eax),%eax
    179c:	c1 e0 03             	shl    $0x3,%eax
    179f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17a8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ae:	a3 78 2a 00 00       	mov    %eax,0x2a78
      return (void*)(p + 1);
    17b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b6:	83 c0 08             	add    $0x8,%eax
    17b9:	eb 38                	jmp    17f3 <malloc+0xde>
    }
    if(p == freep)
    17bb:	a1 78 2a 00 00       	mov    0x2a78,%eax
    17c0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17c3:	75 1b                	jne    17e0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17c8:	89 04 24             	mov    %eax,(%esp)
    17cb:	e8 ed fe ff ff       	call   16bd <morecore>
    17d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17d7:	75 07                	jne    17e0 <malloc+0xcb>
        return 0;
    17d9:	b8 00 00 00 00       	mov    $0x0,%eax
    17de:	eb 13                	jmp    17f3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e9:	8b 00                	mov    (%eax),%eax
    17eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17ee:	e9 70 ff ff ff       	jmp    1763 <malloc+0x4e>
}
    17f3:	c9                   	leave  
    17f4:	c3                   	ret    
