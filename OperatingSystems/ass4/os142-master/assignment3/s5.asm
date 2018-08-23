
_s5:     file format elf32-i386


Disassembly of section .text:

00001000 <regular_demo>:
#include "stat.h"
#include "user.h"

void
regular_demo()
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	56                   	push   %esi
    1005:	53                   	push   %ebx
    1006:	83 ec 3c             	sub    $0x3c,%esp
   int pid = getpid();
    1009:	e8 37 06 00 00       	call   1645 <getpid>
    100e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   int *x = (int *)malloc(sizeof(int));
    1011:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    1018:	e8 14 0a 00 00       	call   1a31 <malloc>
    101d:	89 45 e0             	mov    %eax,-0x20(%ebp)
   int *grade = (int*)malloc(sizeof(int));
    1020:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    1027:	e8 05 0a 00 00       	call   1a31 <malloc>
    102c:	89 45 dc             	mov    %eax,-0x24(%ebp)
   *grade = 100;
    102f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1032:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
   *x = 0;
    1038:	8b 45 e0             	mov    -0x20(%ebp),%eax
    103b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   int *y = (int *)malloc(sizeof(int));
    1041:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    1048:	e8 e4 09 00 00       	call   1a31 <malloc>
    104d:	89 45 d8             	mov    %eax,-0x28(%ebp)
   *y = 100; // GRADE?!#!##$
    1050:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1053:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

   printf(1, "pid : %d x: %d y: %d grade: %d \n\n", pid, *x, *y, *grade);
    1059:	8b 45 dc             	mov    -0x24(%ebp),%eax
    105c:	8b 08                	mov    (%eax),%ecx
    105e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1061:	8b 10                	mov    (%eax),%edx
    1063:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1066:	8b 00                	mov    (%eax),%eax
    1068:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    106c:	89 54 24 10          	mov    %edx,0x10(%esp)
    1070:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1074:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1077:	89 44 24 08          	mov    %eax,0x8(%esp)
    107b:	c7 44 24 04 14 1b 00 	movl   $0x1b14,0x4(%esp)
    1082:	00 
    1083:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108a:	e8 b6 06 00 00       	call   1745 <printf>
   printf(1, "Fater Process <procdump> Before Forking \n\n");
    108f:	c7 44 24 04 38 1b 00 	movl   $0x1b38,0x4(%esp)
    1096:	00 
    1097:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    109e:	e8 a2 06 00 00       	call   1745 <printf>
   //output will be from page 1 and we can see that there is a readonly page.
   procdump();
    10a3:	e8 15 05 00 00       	call   15bd <procdump>
   //child
   if (fork() == 0)
    10a8:	e8 00 05 00 00       	call   15ad <fork>
    10ad:	85 c0                	test   %eax,%eax
    10af:	0f 85 ad 00 00 00    	jne    1162 <regular_demo+0x162>
   {

     printf(1, "CHILD before changing X same address -copied\n");
    10b5:	c7 44 24 04 64 1b 00 	movl   $0x1b64,0x4(%esp)
    10bc:	00 
    10bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c4:	e8 7c 06 00 00       	call   1745 <printf>
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
    10c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    10cc:	8b 38                	mov    (%eax),%edi
    10ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
    10d1:	8b 30                	mov    (%eax),%esi
    10d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
    10d6:	8b 18                	mov    (%eax),%ebx
    10d8:	e8 68 05 00 00       	call   1645 <getpid>
    10dd:	89 7c 24 14          	mov    %edi,0x14(%esp)
    10e1:	89 74 24 10          	mov    %esi,0x10(%esp)
    10e5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    10e9:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ed:	c7 44 24 04 94 1b 00 	movl   $0x1b94,0x4(%esp)
    10f4:	00 
    10f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fc:	e8 44 06 00 00       	call   1745 <printf>
     procdump();
    1101:	e8 b7 04 00 00       	call   15bd <procdump>
     *x=2;
    1106:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1109:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
     printf(1, "CHILD after changing X address\n");
    110f:	c7 44 24 04 bc 1b 00 	movl   $0x1bbc,0x4(%esp)
    1116:	00 
    1117:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    111e:	e8 22 06 00 00       	call   1745 <printf>
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
    1123:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1126:	8b 38                	mov    (%eax),%edi
    1128:	8b 45 d8             	mov    -0x28(%ebp),%eax
    112b:	8b 30                	mov    (%eax),%esi
    112d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1130:	8b 18                	mov    (%eax),%ebx
    1132:	e8 0e 05 00 00       	call   1645 <getpid>
    1137:	89 7c 24 14          	mov    %edi,0x14(%esp)
    113b:	89 74 24 10          	mov    %esi,0x10(%esp)
    113f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1143:	89 44 24 08          	mov    %eax,0x8(%esp)
    1147:	c7 44 24 04 94 1b 00 	movl   $0x1b94,0x4(%esp)
    114e:	00 
    114f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1156:	e8 ea 05 00 00       	call   1745 <printf>
     procdump();
    115b:	e8 5d 04 00 00       	call   15bd <procdump>
    1160:	eb 1e                	jmp    1180 <regular_demo+0x180>
//     // now we can see that before changing x it was a shared memory
//     printf(1,"pid is : %d x: %d , y: %d, grade: %d \n\n\n\n", getpid(), *x, *y, *grade);
   } else {
	   wait();
    1162:	e8 66 04 00 00       	call   15cd <wait>
	   printf(1, "Fater Process <procdump> After Cow_Forking \n\n");
    1167:	c7 44 24 04 dc 1b 00 	movl   $0x1bdc,0x4(%esp)
    116e:	00 
    116f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1176:	e8 ca 05 00 00       	call   1745 <printf>
	   procdump();
    117b:	e8 3d 04 00 00       	call   15bd <procdump>
   }
}
    1180:	83 c4 3c             	add    $0x3c,%esp
    1183:	5b                   	pop    %ebx
    1184:	5e                   	pop    %esi
    1185:	5f                   	pop    %edi
    1186:	5d                   	pop    %ebp
    1187:	c3                   	ret    

00001188 <cow_demo>:

void
cow_demo()
{
    1188:	55                   	push   %ebp
    1189:	89 e5                	mov    %esp,%ebp
    118b:	57                   	push   %edi
    118c:	56                   	push   %esi
    118d:	53                   	push   %ebx
    118e:	83 ec 3c             	sub    $0x3c,%esp
   int pid = getpid();
    1191:	e8 af 04 00 00       	call   1645 <getpid>
    1196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   int *x = (int *)malloc(sizeof(int));
    1199:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    11a0:	e8 8c 08 00 00       	call   1a31 <malloc>
    11a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
   int *grade = (int*)malloc(sizeof(int));
    11a8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    11af:	e8 7d 08 00 00       	call   1a31 <malloc>
    11b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
   *grade = 100;
    11b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11ba:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
   *x = 0;
    11c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   int *y = (int *)malloc(sizeof(int));
    11c9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    11d0:	e8 5c 08 00 00       	call   1a31 <malloc>
    11d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
   *y = 100; // GRADE?!#!##$
    11d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    11db:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

   printf(1, "pid : %d x: %d y: %d grade: %d \n\n", pid, *x, *y, *grade);
    11e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11e4:	8b 08                	mov    (%eax),%ecx
    11e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    11e9:	8b 10                	mov    (%eax),%edx
    11eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11ee:	8b 00                	mov    (%eax),%eax
    11f0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    11f4:	89 54 24 10          	mov    %edx,0x10(%esp)
    11f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
    11fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11ff:	89 44 24 08          	mov    %eax,0x8(%esp)
    1203:	c7 44 24 04 14 1b 00 	movl   $0x1b14,0x4(%esp)
    120a:	00 
    120b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1212:	e8 2e 05 00 00       	call   1745 <printf>
   printf(1, "Fater Process <procdump> Before Forking \n\n");
    1217:	c7 44 24 04 38 1b 00 	movl   $0x1b38,0x4(%esp)
    121e:	00 
    121f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1226:	e8 1a 05 00 00       	call   1745 <printf>
   //output will be from page 1 and we can see that there is a readonly page.
   procdump();
    122b:	e8 8d 03 00 00       	call   15bd <procdump>

   //child
   if (cowfork() == 0)
    1230:	e8 80 03 00 00       	call   15b5 <cowfork>
    1235:	85 c0                	test   %eax,%eax
    1237:	0f 85 ad 00 00 00    	jne    12ea <cow_demo+0x162>
   {

     printf(1, "CHILD before changing X same address -copied\n");
    123d:	c7 44 24 04 64 1b 00 	movl   $0x1b64,0x4(%esp)
    1244:	00 
    1245:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    124c:	e8 f4 04 00 00       	call   1745 <printf>
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
    1251:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1254:	8b 38                	mov    (%eax),%edi
    1256:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1259:	8b 30                	mov    (%eax),%esi
    125b:	8b 45 e0             	mov    -0x20(%ebp),%eax
    125e:	8b 18                	mov    (%eax),%ebx
    1260:	e8 e0 03 00 00       	call   1645 <getpid>
    1265:	89 7c 24 14          	mov    %edi,0x14(%esp)
    1269:	89 74 24 10          	mov    %esi,0x10(%esp)
    126d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1271:	89 44 24 08          	mov    %eax,0x8(%esp)
    1275:	c7 44 24 04 94 1b 00 	movl   $0x1b94,0x4(%esp)
    127c:	00 
    127d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1284:	e8 bc 04 00 00       	call   1745 <printf>
     procdump();
    1289:	e8 2f 03 00 00       	call   15bd <procdump>
     *x=2;
    128e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1291:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
     printf(1, "CHILD after changing X same address\n");
    1297:	c7 44 24 04 0c 1c 00 	movl   $0x1c0c,0x4(%esp)
    129e:	00 
    129f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12a6:	e8 9a 04 00 00       	call   1745 <printf>
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n\n", getpid(), *x, *y, *grade);
    12ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
    12ae:	8b 38                	mov    (%eax),%edi
    12b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
    12b3:	8b 30                	mov    (%eax),%esi
    12b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
    12b8:	8b 18                	mov    (%eax),%ebx
    12ba:	e8 86 03 00 00       	call   1645 <getpid>
    12bf:	89 7c 24 14          	mov    %edi,0x14(%esp)
    12c3:	89 74 24 10          	mov    %esi,0x10(%esp)
    12c7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    12cb:	89 44 24 08          	mov    %eax,0x8(%esp)
    12cf:	c7 44 24 04 94 1b 00 	movl   $0x1b94,0x4(%esp)
    12d6:	00 
    12d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12de:	e8 62 04 00 00       	call   1745 <printf>
     procdump();
    12e3:	e8 d5 02 00 00       	call   15bd <procdump>
    12e8:	eb 1e                	jmp    1308 <cow_demo+0x180>
//     // now we can see that before changing x it was a shared memory
//     printf(1,"pid is : %d x: %d , y: %d, grade: %d \n\n\n\n", getpid(), *x, *y, *grade);
   } else {
	   wait();
    12ea:	e8 de 02 00 00       	call   15cd <wait>
	   printf(1, "Fater Process <procdump> After Cow_Forking \n\n");
    12ef:	c7 44 24 04 dc 1b 00 	movl   $0x1bdc,0x4(%esp)
    12f6:	00 
    12f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12fe:	e8 42 04 00 00       	call   1745 <printf>
	   procdump();
    1303:	e8 b5 02 00 00       	call   15bd <procdump>
   }
   exit();
    1308:	e8 b8 02 00 00       	call   15c5 <exit>

0000130d <main>:
}
int
main(int argc, char *argv[])
{
    130d:	55                   	push   %ebp
    130e:	89 e5                	mov    %esp,%ebp
    1310:	83 e4 f0             	and    $0xfffffff0,%esp
    1313:	83 ec 10             	sub    $0x10,%esp
	printf(1,"Regular fork demonstration:\n\n");
    1316:	c7 44 24 04 31 1c 00 	movl   $0x1c31,0x4(%esp)
    131d:	00 
    131e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1325:	e8 1b 04 00 00       	call   1745 <printf>
	regular_demo();
    132a:	e8 d1 fc ff ff       	call   1000 <regular_demo>
	printf(1,"COW demonstration:\n\n");
    132f:	c7 44 24 04 4f 1c 00 	movl   $0x1c4f,0x4(%esp)
    1336:	00 
    1337:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    133e:	e8 02 04 00 00       	call   1745 <printf>
	cow_demo();
    1343:	e8 40 fe ff ff       	call   1188 <cow_demo>
	exit();
    1348:	e8 78 02 00 00       	call   15c5 <exit>

0000134d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    134d:	55                   	push   %ebp
    134e:	89 e5                	mov    %esp,%ebp
    1350:	57                   	push   %edi
    1351:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1352:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1355:	8b 55 10             	mov    0x10(%ebp),%edx
    1358:	8b 45 0c             	mov    0xc(%ebp),%eax
    135b:	89 cb                	mov    %ecx,%ebx
    135d:	89 df                	mov    %ebx,%edi
    135f:	89 d1                	mov    %edx,%ecx
    1361:	fc                   	cld    
    1362:	f3 aa                	rep stos %al,%es:(%edi)
    1364:	89 ca                	mov    %ecx,%edx
    1366:	89 fb                	mov    %edi,%ebx
    1368:	89 5d 08             	mov    %ebx,0x8(%ebp)
    136b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    136e:	5b                   	pop    %ebx
    136f:	5f                   	pop    %edi
    1370:	5d                   	pop    %ebp
    1371:	c3                   	ret    

00001372 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1372:	55                   	push   %ebp
    1373:	89 e5                	mov    %esp,%ebp
    1375:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1378:	8b 45 08             	mov    0x8(%ebp),%eax
    137b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    137e:	90                   	nop
    137f:	8b 45 08             	mov    0x8(%ebp),%eax
    1382:	8d 50 01             	lea    0x1(%eax),%edx
    1385:	89 55 08             	mov    %edx,0x8(%ebp)
    1388:	8b 55 0c             	mov    0xc(%ebp),%edx
    138b:	8d 4a 01             	lea    0x1(%edx),%ecx
    138e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1391:	0f b6 12             	movzbl (%edx),%edx
    1394:	88 10                	mov    %dl,(%eax)
    1396:	0f b6 00             	movzbl (%eax),%eax
    1399:	84 c0                	test   %al,%al
    139b:	75 e2                	jne    137f <strcpy+0xd>
    ;
  return os;
    139d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13a0:	c9                   	leave  
    13a1:	c3                   	ret    

000013a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13a2:	55                   	push   %ebp
    13a3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13a5:	eb 08                	jmp    13af <strcmp+0xd>
    p++, q++;
    13a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13ab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13af:	8b 45 08             	mov    0x8(%ebp),%eax
    13b2:	0f b6 00             	movzbl (%eax),%eax
    13b5:	84 c0                	test   %al,%al
    13b7:	74 10                	je     13c9 <strcmp+0x27>
    13b9:	8b 45 08             	mov    0x8(%ebp),%eax
    13bc:	0f b6 10             	movzbl (%eax),%edx
    13bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c2:	0f b6 00             	movzbl (%eax),%eax
    13c5:	38 c2                	cmp    %al,%dl
    13c7:	74 de                	je     13a7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13c9:	8b 45 08             	mov    0x8(%ebp),%eax
    13cc:	0f b6 00             	movzbl (%eax),%eax
    13cf:	0f b6 d0             	movzbl %al,%edx
    13d2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d5:	0f b6 00             	movzbl (%eax),%eax
    13d8:	0f b6 c0             	movzbl %al,%eax
    13db:	29 c2                	sub    %eax,%edx
    13dd:	89 d0                	mov    %edx,%eax
}
    13df:	5d                   	pop    %ebp
    13e0:	c3                   	ret    

000013e1 <strlen>:

uint
strlen(char *s)
{
    13e1:	55                   	push   %ebp
    13e2:	89 e5                	mov    %esp,%ebp
    13e4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13ee:	eb 04                	jmp    13f4 <strlen+0x13>
    13f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    13f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13f7:	8b 45 08             	mov    0x8(%ebp),%eax
    13fa:	01 d0                	add    %edx,%eax
    13fc:	0f b6 00             	movzbl (%eax),%eax
    13ff:	84 c0                	test   %al,%al
    1401:	75 ed                	jne    13f0 <strlen+0xf>
    ;
  return n;
    1403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1406:	c9                   	leave  
    1407:	c3                   	ret    

00001408 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1408:	55                   	push   %ebp
    1409:	89 e5                	mov    %esp,%ebp
    140b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    140e:	8b 45 10             	mov    0x10(%ebp),%eax
    1411:	89 44 24 08          	mov    %eax,0x8(%esp)
    1415:	8b 45 0c             	mov    0xc(%ebp),%eax
    1418:	89 44 24 04          	mov    %eax,0x4(%esp)
    141c:	8b 45 08             	mov    0x8(%ebp),%eax
    141f:	89 04 24             	mov    %eax,(%esp)
    1422:	e8 26 ff ff ff       	call   134d <stosb>
  return dst;
    1427:	8b 45 08             	mov    0x8(%ebp),%eax
}
    142a:	c9                   	leave  
    142b:	c3                   	ret    

0000142c <strchr>:

char*
strchr(const char *s, char c)
{
    142c:	55                   	push   %ebp
    142d:	89 e5                	mov    %esp,%ebp
    142f:	83 ec 04             	sub    $0x4,%esp
    1432:	8b 45 0c             	mov    0xc(%ebp),%eax
    1435:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1438:	eb 14                	jmp    144e <strchr+0x22>
    if(*s == c)
    143a:	8b 45 08             	mov    0x8(%ebp),%eax
    143d:	0f b6 00             	movzbl (%eax),%eax
    1440:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1443:	75 05                	jne    144a <strchr+0x1e>
      return (char*)s;
    1445:	8b 45 08             	mov    0x8(%ebp),%eax
    1448:	eb 13                	jmp    145d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    144a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    144e:	8b 45 08             	mov    0x8(%ebp),%eax
    1451:	0f b6 00             	movzbl (%eax),%eax
    1454:	84 c0                	test   %al,%al
    1456:	75 e2                	jne    143a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1458:	b8 00 00 00 00       	mov    $0x0,%eax
}
    145d:	c9                   	leave  
    145e:	c3                   	ret    

0000145f <gets>:

char*
gets(char *buf, int max)
{
    145f:	55                   	push   %ebp
    1460:	89 e5                	mov    %esp,%ebp
    1462:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1465:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    146c:	eb 4c                	jmp    14ba <gets+0x5b>
    cc = read(0, &c, 1);
    146e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1475:	00 
    1476:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1479:	89 44 24 04          	mov    %eax,0x4(%esp)
    147d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1484:	e8 54 01 00 00       	call   15dd <read>
    1489:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    148c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1490:	7f 02                	jg     1494 <gets+0x35>
      break;
    1492:	eb 31                	jmp    14c5 <gets+0x66>
    buf[i++] = c;
    1494:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1497:	8d 50 01             	lea    0x1(%eax),%edx
    149a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    149d:	89 c2                	mov    %eax,%edx
    149f:	8b 45 08             	mov    0x8(%ebp),%eax
    14a2:	01 c2                	add    %eax,%edx
    14a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14a8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14ae:	3c 0a                	cmp    $0xa,%al
    14b0:	74 13                	je     14c5 <gets+0x66>
    14b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b6:	3c 0d                	cmp    $0xd,%al
    14b8:	74 0b                	je     14c5 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bd:	83 c0 01             	add    $0x1,%eax
    14c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14c3:	7c a9                	jl     146e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14c8:	8b 45 08             	mov    0x8(%ebp),%eax
    14cb:	01 d0                	add    %edx,%eax
    14cd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14d3:	c9                   	leave  
    14d4:	c3                   	ret    

000014d5 <stat>:

int
stat(char *n, struct stat *st)
{
    14d5:	55                   	push   %ebp
    14d6:	89 e5                	mov    %esp,%ebp
    14d8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14e2:	00 
    14e3:	8b 45 08             	mov    0x8(%ebp),%eax
    14e6:	89 04 24             	mov    %eax,(%esp)
    14e9:	e8 17 01 00 00       	call   1605 <open>
    14ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14f5:	79 07                	jns    14fe <stat+0x29>
    return -1;
    14f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14fc:	eb 23                	jmp    1521 <stat+0x4c>
  r = fstat(fd, st);
    14fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1501:	89 44 24 04          	mov    %eax,0x4(%esp)
    1505:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1508:	89 04 24             	mov    %eax,(%esp)
    150b:	e8 0d 01 00 00       	call   161d <fstat>
    1510:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1513:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1516:	89 04 24             	mov    %eax,(%esp)
    1519:	e8 cf 00 00 00       	call   15ed <close>
  return r;
    151e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1521:	c9                   	leave  
    1522:	c3                   	ret    

00001523 <atoi>:

int
atoi(const char *s)
{
    1523:	55                   	push   %ebp
    1524:	89 e5                	mov    %esp,%ebp
    1526:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1529:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1530:	eb 25                	jmp    1557 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1532:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1535:	89 d0                	mov    %edx,%eax
    1537:	c1 e0 02             	shl    $0x2,%eax
    153a:	01 d0                	add    %edx,%eax
    153c:	01 c0                	add    %eax,%eax
    153e:	89 c1                	mov    %eax,%ecx
    1540:	8b 45 08             	mov    0x8(%ebp),%eax
    1543:	8d 50 01             	lea    0x1(%eax),%edx
    1546:	89 55 08             	mov    %edx,0x8(%ebp)
    1549:	0f b6 00             	movzbl (%eax),%eax
    154c:	0f be c0             	movsbl %al,%eax
    154f:	01 c8                	add    %ecx,%eax
    1551:	83 e8 30             	sub    $0x30,%eax
    1554:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1557:	8b 45 08             	mov    0x8(%ebp),%eax
    155a:	0f b6 00             	movzbl (%eax),%eax
    155d:	3c 2f                	cmp    $0x2f,%al
    155f:	7e 0a                	jle    156b <atoi+0x48>
    1561:	8b 45 08             	mov    0x8(%ebp),%eax
    1564:	0f b6 00             	movzbl (%eax),%eax
    1567:	3c 39                	cmp    $0x39,%al
    1569:	7e c7                	jle    1532 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    156b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    156e:	c9                   	leave  
    156f:	c3                   	ret    

00001570 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1570:	55                   	push   %ebp
    1571:	89 e5                	mov    %esp,%ebp
    1573:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1576:	8b 45 08             	mov    0x8(%ebp),%eax
    1579:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    157c:	8b 45 0c             	mov    0xc(%ebp),%eax
    157f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1582:	eb 17                	jmp    159b <memmove+0x2b>
    *dst++ = *src++;
    1584:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1587:	8d 50 01             	lea    0x1(%eax),%edx
    158a:	89 55 fc             	mov    %edx,-0x4(%ebp)
    158d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1590:	8d 4a 01             	lea    0x1(%edx),%ecx
    1593:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1596:	0f b6 12             	movzbl (%edx),%edx
    1599:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    159b:	8b 45 10             	mov    0x10(%ebp),%eax
    159e:	8d 50 ff             	lea    -0x1(%eax),%edx
    15a1:	89 55 10             	mov    %edx,0x10(%ebp)
    15a4:	85 c0                	test   %eax,%eax
    15a6:	7f dc                	jg     1584 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    15a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15ab:	c9                   	leave  
    15ac:	c3                   	ret    

000015ad <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15ad:	b8 01 00 00 00       	mov    $0x1,%eax
    15b2:	cd 40                	int    $0x40
    15b4:	c3                   	ret    

000015b5 <cowfork>:
SYSCALL(cowfork)
    15b5:	b8 0f 00 00 00       	mov    $0xf,%eax
    15ba:	cd 40                	int    $0x40
    15bc:	c3                   	ret    

000015bd <procdump>:
SYSCALL(procdump)
    15bd:	b8 10 00 00 00       	mov    $0x10,%eax
    15c2:	cd 40                	int    $0x40
    15c4:	c3                   	ret    

000015c5 <exit>:
SYSCALL(exit)
    15c5:	b8 02 00 00 00       	mov    $0x2,%eax
    15ca:	cd 40                	int    $0x40
    15cc:	c3                   	ret    

000015cd <wait>:
SYSCALL(wait)
    15cd:	b8 03 00 00 00       	mov    $0x3,%eax
    15d2:	cd 40                	int    $0x40
    15d4:	c3                   	ret    

000015d5 <pipe>:
SYSCALL(pipe)
    15d5:	b8 04 00 00 00       	mov    $0x4,%eax
    15da:	cd 40                	int    $0x40
    15dc:	c3                   	ret    

000015dd <read>:
SYSCALL(read)
    15dd:	b8 05 00 00 00       	mov    $0x5,%eax
    15e2:	cd 40                	int    $0x40
    15e4:	c3                   	ret    

000015e5 <write>:
SYSCALL(write)
    15e5:	b8 12 00 00 00       	mov    $0x12,%eax
    15ea:	cd 40                	int    $0x40
    15ec:	c3                   	ret    

000015ed <close>:
SYSCALL(close)
    15ed:	b8 17 00 00 00       	mov    $0x17,%eax
    15f2:	cd 40                	int    $0x40
    15f4:	c3                   	ret    

000015f5 <kill>:
SYSCALL(kill)
    15f5:	b8 06 00 00 00       	mov    $0x6,%eax
    15fa:	cd 40                	int    $0x40
    15fc:	c3                   	ret    

000015fd <exec>:
SYSCALL(exec)
    15fd:	b8 07 00 00 00       	mov    $0x7,%eax
    1602:	cd 40                	int    $0x40
    1604:	c3                   	ret    

00001605 <open>:
SYSCALL(open)
    1605:	b8 11 00 00 00       	mov    $0x11,%eax
    160a:	cd 40                	int    $0x40
    160c:	c3                   	ret    

0000160d <mknod>:
SYSCALL(mknod)
    160d:	b8 13 00 00 00       	mov    $0x13,%eax
    1612:	cd 40                	int    $0x40
    1614:	c3                   	ret    

00001615 <unlink>:
SYSCALL(unlink)
    1615:	b8 14 00 00 00       	mov    $0x14,%eax
    161a:	cd 40                	int    $0x40
    161c:	c3                   	ret    

0000161d <fstat>:
SYSCALL(fstat)
    161d:	b8 08 00 00 00       	mov    $0x8,%eax
    1622:	cd 40                	int    $0x40
    1624:	c3                   	ret    

00001625 <link>:
SYSCALL(link)
    1625:	b8 15 00 00 00       	mov    $0x15,%eax
    162a:	cd 40                	int    $0x40
    162c:	c3                   	ret    

0000162d <mkdir>:
SYSCALL(mkdir)
    162d:	b8 16 00 00 00       	mov    $0x16,%eax
    1632:	cd 40                	int    $0x40
    1634:	c3                   	ret    

00001635 <chdir>:
SYSCALL(chdir)
    1635:	b8 09 00 00 00       	mov    $0x9,%eax
    163a:	cd 40                	int    $0x40
    163c:	c3                   	ret    

0000163d <dup>:
SYSCALL(dup)
    163d:	b8 0a 00 00 00       	mov    $0xa,%eax
    1642:	cd 40                	int    $0x40
    1644:	c3                   	ret    

00001645 <getpid>:
SYSCALL(getpid)
    1645:	b8 0b 00 00 00       	mov    $0xb,%eax
    164a:	cd 40                	int    $0x40
    164c:	c3                   	ret    

0000164d <sbrk>:
SYSCALL(sbrk)
    164d:	b8 0c 00 00 00       	mov    $0xc,%eax
    1652:	cd 40                	int    $0x40
    1654:	c3                   	ret    

00001655 <sleep>:
SYSCALL(sleep)
    1655:	b8 0d 00 00 00       	mov    $0xd,%eax
    165a:	cd 40                	int    $0x40
    165c:	c3                   	ret    

0000165d <uptime>:
SYSCALL(uptime)
    165d:	b8 0e 00 00 00       	mov    $0xe,%eax
    1662:	cd 40                	int    $0x40
    1664:	c3                   	ret    

00001665 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1665:	55                   	push   %ebp
    1666:	89 e5                	mov    %esp,%ebp
    1668:	83 ec 18             	sub    $0x18,%esp
    166b:	8b 45 0c             	mov    0xc(%ebp),%eax
    166e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1671:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1678:	00 
    1679:	8d 45 f4             	lea    -0xc(%ebp),%eax
    167c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1680:	8b 45 08             	mov    0x8(%ebp),%eax
    1683:	89 04 24             	mov    %eax,(%esp)
    1686:	e8 5a ff ff ff       	call   15e5 <write>
}
    168b:	c9                   	leave  
    168c:	c3                   	ret    

0000168d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    168d:	55                   	push   %ebp
    168e:	89 e5                	mov    %esp,%ebp
    1690:	56                   	push   %esi
    1691:	53                   	push   %ebx
    1692:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1695:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    169c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16a0:	74 17                	je     16b9 <printint+0x2c>
    16a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16a6:	79 11                	jns    16b9 <printint+0x2c>
    neg = 1;
    16a8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16af:	8b 45 0c             	mov    0xc(%ebp),%eax
    16b2:	f7 d8                	neg    %eax
    16b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16b7:	eb 06                	jmp    16bf <printint+0x32>
  } else {
    x = xx;
    16b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    16bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16c9:	8d 41 01             	lea    0x1(%ecx),%eax
    16cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16d5:	ba 00 00 00 00       	mov    $0x0,%edx
    16da:	f7 f3                	div    %ebx
    16dc:	89 d0                	mov    %edx,%eax
    16de:	0f b6 80 00 2f 00 00 	movzbl 0x2f00(%eax),%eax
    16e5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16e9:	8b 75 10             	mov    0x10(%ebp),%esi
    16ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16ef:	ba 00 00 00 00       	mov    $0x0,%edx
    16f4:	f7 f6                	div    %esi
    16f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16fd:	75 c7                	jne    16c6 <printint+0x39>
  if(neg)
    16ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1703:	74 10                	je     1715 <printint+0x88>
    buf[i++] = '-';
    1705:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1708:	8d 50 01             	lea    0x1(%eax),%edx
    170b:	89 55 f4             	mov    %edx,-0xc(%ebp)
    170e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1713:	eb 1f                	jmp    1734 <printint+0xa7>
    1715:	eb 1d                	jmp    1734 <printint+0xa7>
    putc(fd, buf[i]);
    1717:	8d 55 dc             	lea    -0x24(%ebp),%edx
    171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    171d:	01 d0                	add    %edx,%eax
    171f:	0f b6 00             	movzbl (%eax),%eax
    1722:	0f be c0             	movsbl %al,%eax
    1725:	89 44 24 04          	mov    %eax,0x4(%esp)
    1729:	8b 45 08             	mov    0x8(%ebp),%eax
    172c:	89 04 24             	mov    %eax,(%esp)
    172f:	e8 31 ff ff ff       	call   1665 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1734:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1738:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    173c:	79 d9                	jns    1717 <printint+0x8a>
    putc(fd, buf[i]);
}
    173e:	83 c4 30             	add    $0x30,%esp
    1741:	5b                   	pop    %ebx
    1742:	5e                   	pop    %esi
    1743:	5d                   	pop    %ebp
    1744:	c3                   	ret    

00001745 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1745:	55                   	push   %ebp
    1746:	89 e5                	mov    %esp,%ebp
    1748:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    174b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1752:	8d 45 0c             	lea    0xc(%ebp),%eax
    1755:	83 c0 04             	add    $0x4,%eax
    1758:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    175b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1762:	e9 7c 01 00 00       	jmp    18e3 <printf+0x19e>
    c = fmt[i] & 0xff;
    1767:	8b 55 0c             	mov    0xc(%ebp),%edx
    176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    176d:	01 d0                	add    %edx,%eax
    176f:	0f b6 00             	movzbl (%eax),%eax
    1772:	0f be c0             	movsbl %al,%eax
    1775:	25 ff 00 00 00       	and    $0xff,%eax
    177a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    177d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1781:	75 2c                	jne    17af <printf+0x6a>
      if(c == '%'){
    1783:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1787:	75 0c                	jne    1795 <printf+0x50>
        state = '%';
    1789:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1790:	e9 4a 01 00 00       	jmp    18df <printf+0x19a>
      } else {
        putc(fd, c);
    1795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1798:	0f be c0             	movsbl %al,%eax
    179b:	89 44 24 04          	mov    %eax,0x4(%esp)
    179f:	8b 45 08             	mov    0x8(%ebp),%eax
    17a2:	89 04 24             	mov    %eax,(%esp)
    17a5:	e8 bb fe ff ff       	call   1665 <putc>
    17aa:	e9 30 01 00 00       	jmp    18df <printf+0x19a>
      }
    } else if(state == '%'){
    17af:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17b3:	0f 85 26 01 00 00    	jne    18df <printf+0x19a>
      if(c == 'd'){
    17b9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17bd:	75 2d                	jne    17ec <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17c2:	8b 00                	mov    (%eax),%eax
    17c4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17cb:	00 
    17cc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17d3:	00 
    17d4:	89 44 24 04          	mov    %eax,0x4(%esp)
    17d8:	8b 45 08             	mov    0x8(%ebp),%eax
    17db:	89 04 24             	mov    %eax,(%esp)
    17de:	e8 aa fe ff ff       	call   168d <printint>
        ap++;
    17e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17e7:	e9 ec 00 00 00       	jmp    18d8 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    17ec:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17f0:	74 06                	je     17f8 <printf+0xb3>
    17f2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17f6:	75 2d                	jne    1825 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    17f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17fb:	8b 00                	mov    (%eax),%eax
    17fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1804:	00 
    1805:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    180c:	00 
    180d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1811:	8b 45 08             	mov    0x8(%ebp),%eax
    1814:	89 04 24             	mov    %eax,(%esp)
    1817:	e8 71 fe ff ff       	call   168d <printint>
        ap++;
    181c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1820:	e9 b3 00 00 00       	jmp    18d8 <printf+0x193>
      } else if(c == 's'){
    1825:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1829:	75 45                	jne    1870 <printf+0x12b>
        s = (char*)*ap;
    182b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    182e:	8b 00                	mov    (%eax),%eax
    1830:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1833:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    183b:	75 09                	jne    1846 <printf+0x101>
          s = "(null)";
    183d:	c7 45 f4 64 1c 00 00 	movl   $0x1c64,-0xc(%ebp)
        while(*s != 0){
    1844:	eb 1e                	jmp    1864 <printf+0x11f>
    1846:	eb 1c                	jmp    1864 <printf+0x11f>
          putc(fd, *s);
    1848:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184b:	0f b6 00             	movzbl (%eax),%eax
    184e:	0f be c0             	movsbl %al,%eax
    1851:	89 44 24 04          	mov    %eax,0x4(%esp)
    1855:	8b 45 08             	mov    0x8(%ebp),%eax
    1858:	89 04 24             	mov    %eax,(%esp)
    185b:	e8 05 fe ff ff       	call   1665 <putc>
          s++;
    1860:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1864:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1867:	0f b6 00             	movzbl (%eax),%eax
    186a:	84 c0                	test   %al,%al
    186c:	75 da                	jne    1848 <printf+0x103>
    186e:	eb 68                	jmp    18d8 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1870:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1874:	75 1d                	jne    1893 <printf+0x14e>
        putc(fd, *ap);
    1876:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1879:	8b 00                	mov    (%eax),%eax
    187b:	0f be c0             	movsbl %al,%eax
    187e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1882:	8b 45 08             	mov    0x8(%ebp),%eax
    1885:	89 04 24             	mov    %eax,(%esp)
    1888:	e8 d8 fd ff ff       	call   1665 <putc>
        ap++;
    188d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1891:	eb 45                	jmp    18d8 <printf+0x193>
      } else if(c == '%'){
    1893:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1897:	75 17                	jne    18b0 <printf+0x16b>
        putc(fd, c);
    1899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    189c:	0f be c0             	movsbl %al,%eax
    189f:	89 44 24 04          	mov    %eax,0x4(%esp)
    18a3:	8b 45 08             	mov    0x8(%ebp),%eax
    18a6:	89 04 24             	mov    %eax,(%esp)
    18a9:	e8 b7 fd ff ff       	call   1665 <putc>
    18ae:	eb 28                	jmp    18d8 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18b0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18b7:	00 
    18b8:	8b 45 08             	mov    0x8(%ebp),%eax
    18bb:	89 04 24             	mov    %eax,(%esp)
    18be:	e8 a2 fd ff ff       	call   1665 <putc>
        putc(fd, c);
    18c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18c6:	0f be c0             	movsbl %al,%eax
    18c9:	89 44 24 04          	mov    %eax,0x4(%esp)
    18cd:	8b 45 08             	mov    0x8(%ebp),%eax
    18d0:	89 04 24             	mov    %eax,(%esp)
    18d3:	e8 8d fd ff ff       	call   1665 <putc>
      }
      state = 0;
    18d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18df:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    18e3:	8b 55 0c             	mov    0xc(%ebp),%edx
    18e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e9:	01 d0                	add    %edx,%eax
    18eb:	0f b6 00             	movzbl (%eax),%eax
    18ee:	84 c0                	test   %al,%al
    18f0:	0f 85 71 fe ff ff    	jne    1767 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18f6:	c9                   	leave  
    18f7:	c3                   	ret    

000018f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18f8:	55                   	push   %ebp
    18f9:	89 e5                	mov    %esp,%ebp
    18fb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    18fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1901:	83 e8 08             	sub    $0x8,%eax
    1904:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1907:	a1 1c 2f 00 00       	mov    0x2f1c,%eax
    190c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    190f:	eb 24                	jmp    1935 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1911:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1914:	8b 00                	mov    (%eax),%eax
    1916:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1919:	77 12                	ja     192d <free+0x35>
    191b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    191e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1921:	77 24                	ja     1947 <free+0x4f>
    1923:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1926:	8b 00                	mov    (%eax),%eax
    1928:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    192b:	77 1a                	ja     1947 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1930:	8b 00                	mov    (%eax),%eax
    1932:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1935:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1938:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    193b:	76 d4                	jbe    1911 <free+0x19>
    193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1940:	8b 00                	mov    (%eax),%eax
    1942:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1945:	76 ca                	jbe    1911 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1947:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194a:	8b 40 04             	mov    0x4(%eax),%eax
    194d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1954:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1957:	01 c2                	add    %eax,%edx
    1959:	8b 45 fc             	mov    -0x4(%ebp),%eax
    195c:	8b 00                	mov    (%eax),%eax
    195e:	39 c2                	cmp    %eax,%edx
    1960:	75 24                	jne    1986 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1962:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1965:	8b 50 04             	mov    0x4(%eax),%edx
    1968:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196b:	8b 00                	mov    (%eax),%eax
    196d:	8b 40 04             	mov    0x4(%eax),%eax
    1970:	01 c2                	add    %eax,%edx
    1972:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1975:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1978:	8b 45 fc             	mov    -0x4(%ebp),%eax
    197b:	8b 00                	mov    (%eax),%eax
    197d:	8b 10                	mov    (%eax),%edx
    197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1982:	89 10                	mov    %edx,(%eax)
    1984:	eb 0a                	jmp    1990 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1986:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1989:	8b 10                	mov    (%eax),%edx
    198b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    198e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1990:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1993:	8b 40 04             	mov    0x4(%eax),%eax
    1996:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a0:	01 d0                	add    %edx,%eax
    19a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19a5:	75 20                	jne    19c7 <free+0xcf>
    p->s.size += bp->s.size;
    19a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19aa:	8b 50 04             	mov    0x4(%eax),%edx
    19ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19b0:	8b 40 04             	mov    0x4(%eax),%eax
    19b3:	01 c2                	add    %eax,%edx
    19b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19be:	8b 10                	mov    (%eax),%edx
    19c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c3:	89 10                	mov    %edx,(%eax)
    19c5:	eb 08                	jmp    19cf <free+0xd7>
  } else
    p->s.ptr = bp;
    19c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19cd:	89 10                	mov    %edx,(%eax)
  freep = p;
    19cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d2:	a3 1c 2f 00 00       	mov    %eax,0x2f1c
}
    19d7:	c9                   	leave  
    19d8:	c3                   	ret    

000019d9 <morecore>:

static Header*
morecore(uint nu)
{
    19d9:	55                   	push   %ebp
    19da:	89 e5                	mov    %esp,%ebp
    19dc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19df:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19e6:	77 07                	ja     19ef <morecore+0x16>
    nu = 4096;
    19e8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19ef:	8b 45 08             	mov    0x8(%ebp),%eax
    19f2:	c1 e0 03             	shl    $0x3,%eax
    19f5:	89 04 24             	mov    %eax,(%esp)
    19f8:	e8 50 fc ff ff       	call   164d <sbrk>
    19fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a00:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a04:	75 07                	jne    1a0d <morecore+0x34>
    return 0;
    1a06:	b8 00 00 00 00       	mov    $0x0,%eax
    1a0b:	eb 22                	jmp    1a2f <morecore+0x56>
  hp = (Header*)p;
    1a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a16:	8b 55 08             	mov    0x8(%ebp),%edx
    1a19:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a1f:	83 c0 08             	add    $0x8,%eax
    1a22:	89 04 24             	mov    %eax,(%esp)
    1a25:	e8 ce fe ff ff       	call   18f8 <free>
  return freep;
    1a2a:	a1 1c 2f 00 00       	mov    0x2f1c,%eax
}
    1a2f:	c9                   	leave  
    1a30:	c3                   	ret    

00001a31 <malloc>:

void*
malloc(uint nbytes)
{
    1a31:	55                   	push   %ebp
    1a32:	89 e5                	mov    %esp,%ebp
    1a34:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a37:	8b 45 08             	mov    0x8(%ebp),%eax
    1a3a:	83 c0 07             	add    $0x7,%eax
    1a3d:	c1 e8 03             	shr    $0x3,%eax
    1a40:	83 c0 01             	add    $0x1,%eax
    1a43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a46:	a1 1c 2f 00 00       	mov    0x2f1c,%eax
    1a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a52:	75 23                	jne    1a77 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a54:	c7 45 f0 14 2f 00 00 	movl   $0x2f14,-0x10(%ebp)
    1a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a5e:	a3 1c 2f 00 00       	mov    %eax,0x2f1c
    1a63:	a1 1c 2f 00 00       	mov    0x2f1c,%eax
    1a68:	a3 14 2f 00 00       	mov    %eax,0x2f14
    base.s.size = 0;
    1a6d:	c7 05 18 2f 00 00 00 	movl   $0x0,0x2f18
    1a74:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a7a:	8b 00                	mov    (%eax),%eax
    1a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a82:	8b 40 04             	mov    0x4(%eax),%eax
    1a85:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a88:	72 4d                	jb     1ad7 <malloc+0xa6>
      if(p->s.size == nunits)
    1a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a8d:	8b 40 04             	mov    0x4(%eax),%eax
    1a90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a93:	75 0c                	jne    1aa1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a98:	8b 10                	mov    (%eax),%edx
    1a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a9d:	89 10                	mov    %edx,(%eax)
    1a9f:	eb 26                	jmp    1ac7 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa4:	8b 40 04             	mov    0x4(%eax),%eax
    1aa7:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1aaa:	89 c2                	mov    %eax,%edx
    1aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aaf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab5:	8b 40 04             	mov    0x4(%eax),%eax
    1ab8:	c1 e0 03             	shl    $0x3,%eax
    1abb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1ac4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aca:	a3 1c 2f 00 00       	mov    %eax,0x2f1c
      return (void*)(p + 1);
    1acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad2:	83 c0 08             	add    $0x8,%eax
    1ad5:	eb 38                	jmp    1b0f <malloc+0xde>
    }
    if(p == freep)
    1ad7:	a1 1c 2f 00 00       	mov    0x2f1c,%eax
    1adc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1adf:	75 1b                	jne    1afc <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ae4:	89 04 24             	mov    %eax,(%esp)
    1ae7:	e8 ed fe ff ff       	call   19d9 <morecore>
    1aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1af3:	75 07                	jne    1afc <malloc+0xcb>
        return 0;
    1af5:	b8 00 00 00 00       	mov    $0x0,%eax
    1afa:	eb 13                	jmp    1b0f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b05:	8b 00                	mov    (%eax),%eax
    1b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b0a:	e9 70 ff ff ff       	jmp    1a7f <malloc+0x4e>
}
    1b0f:	c9                   	leave  
    1b10:	c3                   	ret    
