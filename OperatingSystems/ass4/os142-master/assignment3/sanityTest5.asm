
_sanityTest5:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"


int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	56                   	push   %esi
    1005:	53                   	push   %ebx
    1006:	83 e4 f0             	and    $0xfffffff0,%esp
    1009:	83 ec 50             	sub    $0x50,%esp
   int pid = getpid();
    100c:	e8 72 06 00 00       	call   1683 <getpid>
    1011:	89 44 24 48          	mov    %eax,0x48(%esp)
   int *x = (int *)malloc(sizeof(int));
    1015:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    101c:	e8 4e 0a 00 00       	call   1a6f <malloc>
    1021:	89 44 24 44          	mov    %eax,0x44(%esp)
   int *grade = (int*)malloc(sizeof(int));
    1025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    102c:	e8 3e 0a 00 00       	call   1a6f <malloc>
    1031:	89 44 24 40          	mov    %eax,0x40(%esp)
   *grade = 100;
    1035:	8b 44 24 40          	mov    0x40(%esp),%eax
    1039:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
   *x = 0;
    103f:	8b 44 24 44          	mov    0x44(%esp),%eax
    1043:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   int i;
   int *malloced_array[5];
   
   for(i = 0; i < 5 ; i++){
    1049:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%esp)
    1050:	00 
    1051:	eb 51                	jmp    10a4 <main+0xa4>
		malloced_array[i] = (int *)malloc(1000*sizeof(int));
    1053:	c7 04 24 a0 0f 00 00 	movl   $0xfa0,(%esp)
    105a:	e8 10 0a 00 00       	call   1a6f <malloc>
    105f:	8b 54 24 4c          	mov    0x4c(%esp),%edx
    1063:	89 44 94 20          	mov    %eax,0x20(%esp,%edx,4)
		malloced_array[i][0] = i;
    1067:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    106b:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
    106f:	8b 54 24 4c          	mov    0x4c(%esp),%edx
    1073:	89 10                	mov    %edx,(%eax)
		printf(1,"malloced_array[%d][0] = %d\n", i, malloced_array[i][0]);
    1075:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    1079:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
    107d:	8b 00                	mov    (%eax),%eax
    107f:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1083:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    1087:	89 44 24 08          	mov    %eax,0x8(%esp)
    108b:	c7 44 24 04 50 1b 00 	movl   $0x1b50,0x4(%esp)
    1092:	00 
    1093:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    109a:	e8 e4 06 00 00       	call   1783 <printf>
   *grade = 100;
   *x = 0;
   int i;
   int *malloced_array[5];
   
   for(i = 0; i < 5 ; i++){
    109f:	83 44 24 4c 01       	addl   $0x1,0x4c(%esp)
    10a4:	83 7c 24 4c 04       	cmpl   $0x4,0x4c(%esp)
    10a9:	7e a8                	jle    1053 <main+0x53>
		malloced_array[i] = (int *)malloc(1000*sizeof(int));
		malloced_array[i][0] = i;
		printf(1,"malloced_array[%d][0] = %d\n", i, malloced_array[i][0]);
	}
   
   int *y = (int *)malloc(sizeof(int));
    10ab:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    10b2:	e8 b8 09 00 00       	call   1a6f <malloc>
    10b7:	89 44 24 3c          	mov    %eax,0x3c(%esp)
   *y = 100; // GRADE?!#!##$
    10bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    10bf:	c7 00 64 00 00 00    	movl   $0x64,(%eax)
   
   printf(1, "pid : %d x: %d y: %d grade: %d \n\n\n\n", pid, *x, *y, *grade);
    10c5:	8b 44 24 40          	mov    0x40(%esp),%eax
    10c9:	8b 08                	mov    (%eax),%ecx
    10cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    10cf:	8b 10                	mov    (%eax),%edx
    10d1:	8b 44 24 44          	mov    0x44(%esp),%eax
    10d5:	8b 00                	mov    (%eax),%eax
    10d7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    10db:	89 54 24 10          	mov    %edx,0x10(%esp)
    10df:	89 44 24 0c          	mov    %eax,0xc(%esp)
    10e3:	8b 44 24 48          	mov    0x48(%esp),%eax
    10e7:	89 44 24 08          	mov    %eax,0x8(%esp)
    10eb:	c7 44 24 04 6c 1b 00 	movl   $0x1b6c,0x4(%esp)
    10f2:	00 
    10f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fa:	e8 84 06 00 00       	call   1783 <printf>
   //output will be from page 1 and we can see that there is a readonly page.
   procdump();
    10ff:	e8 f7 04 00 00       	call   15fb <procdump>
   
   //child
   if (cowfork() == 0)
    1104:	e8 ea 04 00 00       	call   15f3 <cowfork>
    1109:	85 c0                	test   %eax,%eax
    110b:	0f 85 46 01 00 00    	jne    1257 <main+0x257>
   {
     printf(1,"pid is : %d x:  %d y: %d, grade: %d \n", getpid(), *x, *y, *grade);
    1111:	8b 44 24 40          	mov    0x40(%esp),%eax
    1115:	8b 38                	mov    (%eax),%edi
    1117:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    111b:	8b 30                	mov    (%eax),%esi
    111d:	8b 44 24 44          	mov    0x44(%esp),%eax
    1121:	8b 18                	mov    (%eax),%ebx
    1123:	e8 5b 05 00 00       	call   1683 <getpid>
    1128:	89 7c 24 14          	mov    %edi,0x14(%esp)
    112c:	89 74 24 10          	mov    %esi,0x10(%esp)
    1130:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1134:	89 44 24 08          	mov    %eax,0x8(%esp)
    1138:	c7 44 24 04 90 1b 00 	movl   $0x1b90,0x4(%esp)
    113f:	00 
    1140:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1147:	e8 37 06 00 00       	call   1783 <printf>
     printf(1, "before changing X same address\n\n\n\n\n");
    114c:	c7 44 24 04 b8 1b 00 	movl   $0x1bb8,0x4(%esp)
    1153:	00 
    1154:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    115b:	e8 23 06 00 00       	call   1783 <printf>
     procdump();
    1160:	e8 96 04 00 00       	call   15fb <procdump>
     *x=2;
    1165:	8b 44 24 44          	mov    0x44(%esp),%eax
    1169:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
     printf(1, "after changing X different address\n\n\n\n");
    116f:	c7 44 24 04 dc 1b 00 	movl   $0x1bdc,0x4(%esp)
    1176:	00 
    1177:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    117e:	e8 00 06 00 00       	call   1783 <printf>
     procdump();
    1183:	e8 73 04 00 00       	call   15fb <procdump>
     // now we can see that before changing x it was a shared memory
     printf(1,"pid is : %d x: %d , y: %d, grade: %d \n\n\n\n", getpid(), *x, *y, *grade);
    1188:	8b 44 24 40          	mov    0x40(%esp),%eax
    118c:	8b 38                	mov    (%eax),%edi
    118e:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    1192:	8b 30                	mov    (%eax),%esi
    1194:	8b 44 24 44          	mov    0x44(%esp),%eax
    1198:	8b 18                	mov    (%eax),%ebx
    119a:	e8 e4 04 00 00       	call   1683 <getpid>
    119f:	89 7c 24 14          	mov    %edi,0x14(%esp)
    11a3:	89 74 24 10          	mov    %esi,0x10(%esp)
    11a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    11ab:	89 44 24 08          	mov    %eax,0x8(%esp)
    11af:	c7 44 24 04 04 1c 00 	movl   $0x1c04,0x4(%esp)
    11b6:	00 
    11b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11be:	e8 c0 05 00 00       	call   1783 <printf>
     
     //child of child
     if (cowfork() == 0){
    11c3:	e8 2b 04 00 00       	call   15f3 <cowfork>
    11c8:	85 c0                	test   %eax,%eax
    11ca:	75 7c                	jne    1248 <main+0x248>
       
       printf(1, "before changing Y same address\n\n\n\n");
    11cc:	c7 44 24 04 30 1c 00 	movl   $0x1c30,0x4(%esp)
    11d3:	00 
    11d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11db:	e8 a3 05 00 00       	call   1783 <printf>
       procdump();
    11e0:	e8 16 04 00 00       	call   15fb <procdump>
       *y = 200;
    11e5:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    11e9:	c7 00 c8 00 00 00    	movl   $0xc8,(%eax)
       printf(1, "after changing Y different address\n");
    11ef:	c7 44 24 04 54 1c 00 	movl   $0x1c54,0x4(%esp)
    11f6:	00 
    11f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11fe:	e8 80 05 00 00       	call   1783 <printf>
       printf(1,"pid is : %d, x: %d, y: %d , grade: %d \n\n\n\n\n", getpid(), *x, *y, *grade);
    1203:	8b 44 24 40          	mov    0x40(%esp),%eax
    1207:	8b 38                	mov    (%eax),%edi
    1209:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    120d:	8b 30                	mov    (%eax),%esi
    120f:	8b 44 24 44          	mov    0x44(%esp),%eax
    1213:	8b 18                	mov    (%eax),%ebx
    1215:	e8 69 04 00 00       	call   1683 <getpid>
    121a:	89 7c 24 14          	mov    %edi,0x14(%esp)
    121e:	89 74 24 10          	mov    %esi,0x10(%esp)
    1222:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1226:	89 44 24 08          	mov    %eax,0x8(%esp)
    122a:	c7 44 24 04 78 1c 00 	movl   $0x1c78,0x4(%esp)
    1231:	00 
    1232:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1239:	e8 45 05 00 00       	call   1783 <printf>
       procdump();
    123e:	e8 b8 03 00 00       	call   15fb <procdump>
       exit();
    1243:	e8 bb 03 00 00       	call   1603 <exit>
    }
    else{
       wait();
    1248:	e8 be 03 00 00       	call   160b <wait>
       procdump();
    124d:	e8 a9 03 00 00       	call   15fb <procdump>
       exit();
    1252:	e8 ac 03 00 00       	call   1603 <exit>
   }
   
   //parent
   else
   {
     wait();
    1257:	e8 af 03 00 00       	call   160b <wait>
     printf(1,"pid is : %d , x is %d, y is %d , grade: %d \n", pid, *x, *y, *grade);
    125c:	8b 44 24 40          	mov    0x40(%esp),%eax
    1260:	8b 08                	mov    (%eax),%ecx
    1262:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    1266:	8b 10                	mov    (%eax),%edx
    1268:	8b 44 24 44          	mov    0x44(%esp),%eax
    126c:	8b 00                	mov    (%eax),%eax
    126e:	89 4c 24 14          	mov    %ecx,0x14(%esp)
    1272:	89 54 24 10          	mov    %edx,0x10(%esp)
    1276:	89 44 24 0c          	mov    %eax,0xc(%esp)
    127a:	8b 44 24 48          	mov    0x48(%esp),%eax
    127e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1282:	c7 44 24 04 a4 1c 00 	movl   $0x1ca4,0x4(%esp)
    1289:	00 
    128a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1291:	e8 ed 04 00 00       	call   1783 <printf>
     printf(1, "ALL CHILDREN DIED \n\n\n\n\n");
    1296:	c7 44 24 04 d1 1c 00 	movl   $0x1cd1,0x4(%esp)
    129d:	00 
    129e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12a5:	e8 d9 04 00 00       	call   1783 <printf>
     procdump();
    12aa:	e8 4c 03 00 00       	call   15fb <procdump>
     
     //test 2
     if (cowfork() == 0)
    12af:	e8 3f 03 00 00       	call   15f3 <cowfork>
    12b4:	85 c0                	test   %eax,%eax
    12b6:	75 3c                	jne    12f4 <main+0x2f4>
     {
       char *buf = 0;
    12b8:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%esp)
    12bf:	00 
       printf(1, "son is trying to write to 0\n");
    12c0:	c7 44 24 04 e9 1c 00 	movl   $0x1ce9,0x4(%esp)
    12c7:	00 
    12c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12cf:	e8 af 04 00 00       	call   1783 <printf>
       buf[0] = 'a';
    12d4:	8b 44 24 38          	mov    0x38(%esp),%eax
    12d8:	c6 00 61             	movb   $0x61,(%eax)
       printf(1, "This line will never printed");
    12db:	c7 44 24 04 06 1d 00 	movl   $0x1d06,0x4(%esp)
    12e2:	00 
    12e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12ea:	e8 94 04 00 00       	call   1783 <printf>
       exit();
    12ef:	e8 0f 03 00 00       	call   1603 <exit>
     }
     else
     {
       wait();
    12f4:	e8 12 03 00 00       	call   160b <wait>
       if (cowfork() == 0)
    12f9:	e8 f5 02 00 00       	call   15f3 <cowfork>
    12fe:	85 c0                	test   %eax,%eax
    1300:	75 5b                	jne    135d <main+0x35d>
       {
	 char* pointer = (char*)main;
    1302:	c7 44 24 34 00 10 00 	movl   $0x1000,0x34(%esp)
    1309:	00 
	 printf(1, "read from pointer main %c \n", *pointer);
    130a:	8b 44 24 34          	mov    0x34(%esp),%eax
    130e:	0f b6 00             	movzbl (%eax),%eax
    1311:	0f be c0             	movsbl %al,%eax
    1314:	89 44 24 08          	mov    %eax,0x8(%esp)
    1318:	c7 44 24 04 23 1d 00 	movl   $0x1d23,0x4(%esp)
    131f:	00 
    1320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1327:	e8 57 04 00 00       	call   1783 <printf>
	 printf(1, "son is trying to write to pointer main\n");
    132c:	c7 44 24 04 40 1d 00 	movl   $0x1d40,0x4(%esp)
    1333:	00 
    1334:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    133b:	e8 43 04 00 00       	call   1783 <printf>
         *pointer = 'n';
    1340:	8b 44 24 34          	mov    0x34(%esp),%eax
    1344:	c6 00 6e             	movb   $0x6e,(%eax)
         printf(1, "This line will never printed");
    1347:	c7 44 24 04 06 1d 00 	movl   $0x1d06,0x4(%esp)
    134e:	00 
    134f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1356:	e8 28 04 00 00       	call   1783 <printf>
    135b:	eb 05                	jmp    1362 <main+0x362>
       }
       else
       {
	 wait();
    135d:	e8 a9 02 00 00       	call   160b <wait>
       }
     }
       
   }
     free(y);
    1362:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    1366:	89 04 24             	mov    %eax,(%esp)
    1369:	e8 c8 05 00 00       	call   1936 <free>
     free(x);
    136e:	8b 44 24 44          	mov    0x44(%esp),%eax
    1372:	89 04 24             	mov    %eax,(%esp)
    1375:	e8 bc 05 00 00       	call   1936 <free>
     free(grade);
    137a:	8b 44 24 40          	mov    0x40(%esp),%eax
    137e:	89 04 24             	mov    %eax,(%esp)
    1381:	e8 b0 05 00 00       	call   1936 <free>
     exit();
    1386:	e8 78 02 00 00       	call   1603 <exit>

0000138b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    138b:	55                   	push   %ebp
    138c:	89 e5                	mov    %esp,%ebp
    138e:	57                   	push   %edi
    138f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1390:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1393:	8b 55 10             	mov    0x10(%ebp),%edx
    1396:	8b 45 0c             	mov    0xc(%ebp),%eax
    1399:	89 cb                	mov    %ecx,%ebx
    139b:	89 df                	mov    %ebx,%edi
    139d:	89 d1                	mov    %edx,%ecx
    139f:	fc                   	cld    
    13a0:	f3 aa                	rep stos %al,%es:(%edi)
    13a2:	89 ca                	mov    %ecx,%edx
    13a4:	89 fb                	mov    %edi,%ebx
    13a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
    13a9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    13ac:	5b                   	pop    %ebx
    13ad:	5f                   	pop    %edi
    13ae:	5d                   	pop    %ebp
    13af:	c3                   	ret    

000013b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
    13b3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    13b6:	8b 45 08             	mov    0x8(%ebp),%eax
    13b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    13bc:	90                   	nop
    13bd:	8b 45 08             	mov    0x8(%ebp),%eax
    13c0:	8d 50 01             	lea    0x1(%eax),%edx
    13c3:	89 55 08             	mov    %edx,0x8(%ebp)
    13c6:	8b 55 0c             	mov    0xc(%ebp),%edx
    13c9:	8d 4a 01             	lea    0x1(%edx),%ecx
    13cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    13cf:	0f b6 12             	movzbl (%edx),%edx
    13d2:	88 10                	mov    %dl,(%eax)
    13d4:	0f b6 00             	movzbl (%eax),%eax
    13d7:	84 c0                	test   %al,%al
    13d9:	75 e2                	jne    13bd <strcpy+0xd>
    ;
  return os;
    13db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13de:	c9                   	leave  
    13df:	c3                   	ret    

000013e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13e0:	55                   	push   %ebp
    13e1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13e3:	eb 08                	jmp    13ed <strcmp+0xd>
    p++, q++;
    13e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13e9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13ed:	8b 45 08             	mov    0x8(%ebp),%eax
    13f0:	0f b6 00             	movzbl (%eax),%eax
    13f3:	84 c0                	test   %al,%al
    13f5:	74 10                	je     1407 <strcmp+0x27>
    13f7:	8b 45 08             	mov    0x8(%ebp),%eax
    13fa:	0f b6 10             	movzbl (%eax),%edx
    13fd:	8b 45 0c             	mov    0xc(%ebp),%eax
    1400:	0f b6 00             	movzbl (%eax),%eax
    1403:	38 c2                	cmp    %al,%dl
    1405:	74 de                	je     13e5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1407:	8b 45 08             	mov    0x8(%ebp),%eax
    140a:	0f b6 00             	movzbl (%eax),%eax
    140d:	0f b6 d0             	movzbl %al,%edx
    1410:	8b 45 0c             	mov    0xc(%ebp),%eax
    1413:	0f b6 00             	movzbl (%eax),%eax
    1416:	0f b6 c0             	movzbl %al,%eax
    1419:	29 c2                	sub    %eax,%edx
    141b:	89 d0                	mov    %edx,%eax
}
    141d:	5d                   	pop    %ebp
    141e:	c3                   	ret    

0000141f <strlen>:

uint
strlen(char *s)
{
    141f:	55                   	push   %ebp
    1420:	89 e5                	mov    %esp,%ebp
    1422:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1425:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    142c:	eb 04                	jmp    1432 <strlen+0x13>
    142e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1432:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1435:	8b 45 08             	mov    0x8(%ebp),%eax
    1438:	01 d0                	add    %edx,%eax
    143a:	0f b6 00             	movzbl (%eax),%eax
    143d:	84 c0                	test   %al,%al
    143f:	75 ed                	jne    142e <strlen+0xf>
    ;
  return n;
    1441:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1444:	c9                   	leave  
    1445:	c3                   	ret    

00001446 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1446:	55                   	push   %ebp
    1447:	89 e5                	mov    %esp,%ebp
    1449:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    144c:	8b 45 10             	mov    0x10(%ebp),%eax
    144f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1453:	8b 45 0c             	mov    0xc(%ebp),%eax
    1456:	89 44 24 04          	mov    %eax,0x4(%esp)
    145a:	8b 45 08             	mov    0x8(%ebp),%eax
    145d:	89 04 24             	mov    %eax,(%esp)
    1460:	e8 26 ff ff ff       	call   138b <stosb>
  return dst;
    1465:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1468:	c9                   	leave  
    1469:	c3                   	ret    

0000146a <strchr>:

char*
strchr(const char *s, char c)
{
    146a:	55                   	push   %ebp
    146b:	89 e5                	mov    %esp,%ebp
    146d:	83 ec 04             	sub    $0x4,%esp
    1470:	8b 45 0c             	mov    0xc(%ebp),%eax
    1473:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1476:	eb 14                	jmp    148c <strchr+0x22>
    if(*s == c)
    1478:	8b 45 08             	mov    0x8(%ebp),%eax
    147b:	0f b6 00             	movzbl (%eax),%eax
    147e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1481:	75 05                	jne    1488 <strchr+0x1e>
      return (char*)s;
    1483:	8b 45 08             	mov    0x8(%ebp),%eax
    1486:	eb 13                	jmp    149b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1488:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    148c:	8b 45 08             	mov    0x8(%ebp),%eax
    148f:	0f b6 00             	movzbl (%eax),%eax
    1492:	84 c0                	test   %al,%al
    1494:	75 e2                	jne    1478 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1496:	b8 00 00 00 00       	mov    $0x0,%eax
}
    149b:	c9                   	leave  
    149c:	c3                   	ret    

0000149d <gets>:

char*
gets(char *buf, int max)
{
    149d:	55                   	push   %ebp
    149e:	89 e5                	mov    %esp,%ebp
    14a0:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14aa:	eb 4c                	jmp    14f8 <gets+0x5b>
    cc = read(0, &c, 1);
    14ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14b3:	00 
    14b4:	8d 45 ef             	lea    -0x11(%ebp),%eax
    14b7:	89 44 24 04          	mov    %eax,0x4(%esp)
    14bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14c2:	e8 54 01 00 00       	call   161b <read>
    14c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    14ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14ce:	7f 02                	jg     14d2 <gets+0x35>
      break;
    14d0:	eb 31                	jmp    1503 <gets+0x66>
    buf[i++] = c;
    14d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d5:	8d 50 01             	lea    0x1(%eax),%edx
    14d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14db:	89 c2                	mov    %eax,%edx
    14dd:	8b 45 08             	mov    0x8(%ebp),%eax
    14e0:	01 c2                	add    %eax,%edx
    14e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14e6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14e8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14ec:	3c 0a                	cmp    $0xa,%al
    14ee:	74 13                	je     1503 <gets+0x66>
    14f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14f4:	3c 0d                	cmp    $0xd,%al
    14f6:	74 0b                	je     1503 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fb:	83 c0 01             	add    $0x1,%eax
    14fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1501:	7c a9                	jl     14ac <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1503:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1506:	8b 45 08             	mov    0x8(%ebp),%eax
    1509:	01 d0                	add    %edx,%eax
    150b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    150e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1511:	c9                   	leave  
    1512:	c3                   	ret    

00001513 <stat>:

int
stat(char *n, struct stat *st)
{
    1513:	55                   	push   %ebp
    1514:	89 e5                	mov    %esp,%ebp
    1516:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1519:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1520:	00 
    1521:	8b 45 08             	mov    0x8(%ebp),%eax
    1524:	89 04 24             	mov    %eax,(%esp)
    1527:	e8 17 01 00 00       	call   1643 <open>
    152c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    152f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1533:	79 07                	jns    153c <stat+0x29>
    return -1;
    1535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    153a:	eb 23                	jmp    155f <stat+0x4c>
  r = fstat(fd, st);
    153c:	8b 45 0c             	mov    0xc(%ebp),%eax
    153f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1543:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1546:	89 04 24             	mov    %eax,(%esp)
    1549:	e8 0d 01 00 00       	call   165b <fstat>
    154e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1551:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1554:	89 04 24             	mov    %eax,(%esp)
    1557:	e8 cf 00 00 00       	call   162b <close>
  return r;
    155c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    155f:	c9                   	leave  
    1560:	c3                   	ret    

00001561 <atoi>:

int
atoi(const char *s)
{
    1561:	55                   	push   %ebp
    1562:	89 e5                	mov    %esp,%ebp
    1564:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    156e:	eb 25                	jmp    1595 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1570:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1573:	89 d0                	mov    %edx,%eax
    1575:	c1 e0 02             	shl    $0x2,%eax
    1578:	01 d0                	add    %edx,%eax
    157a:	01 c0                	add    %eax,%eax
    157c:	89 c1                	mov    %eax,%ecx
    157e:	8b 45 08             	mov    0x8(%ebp),%eax
    1581:	8d 50 01             	lea    0x1(%eax),%edx
    1584:	89 55 08             	mov    %edx,0x8(%ebp)
    1587:	0f b6 00             	movzbl (%eax),%eax
    158a:	0f be c0             	movsbl %al,%eax
    158d:	01 c8                	add    %ecx,%eax
    158f:	83 e8 30             	sub    $0x30,%eax
    1592:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1595:	8b 45 08             	mov    0x8(%ebp),%eax
    1598:	0f b6 00             	movzbl (%eax),%eax
    159b:	3c 2f                	cmp    $0x2f,%al
    159d:	7e 0a                	jle    15a9 <atoi+0x48>
    159f:	8b 45 08             	mov    0x8(%ebp),%eax
    15a2:	0f b6 00             	movzbl (%eax),%eax
    15a5:	3c 39                	cmp    $0x39,%al
    15a7:	7e c7                	jle    1570 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    15a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    15ac:	c9                   	leave  
    15ad:	c3                   	ret    

000015ae <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    15ae:	55                   	push   %ebp
    15af:	89 e5                	mov    %esp,%ebp
    15b1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    15b4:	8b 45 08             	mov    0x8(%ebp),%eax
    15b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    15ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    15bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    15c0:	eb 17                	jmp    15d9 <memmove+0x2b>
    *dst++ = *src++;
    15c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15c5:	8d 50 01             	lea    0x1(%eax),%edx
    15c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
    15cb:	8b 55 f8             	mov    -0x8(%ebp),%edx
    15ce:	8d 4a 01             	lea    0x1(%edx),%ecx
    15d1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    15d4:	0f b6 12             	movzbl (%edx),%edx
    15d7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    15d9:	8b 45 10             	mov    0x10(%ebp),%eax
    15dc:	8d 50 ff             	lea    -0x1(%eax),%edx
    15df:	89 55 10             	mov    %edx,0x10(%ebp)
    15e2:	85 c0                	test   %eax,%eax
    15e4:	7f dc                	jg     15c2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    15e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15e9:	c9                   	leave  
    15ea:	c3                   	ret    

000015eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15eb:	b8 01 00 00 00       	mov    $0x1,%eax
    15f0:	cd 40                	int    $0x40
    15f2:	c3                   	ret    

000015f3 <cowfork>:
SYSCALL(cowfork)
    15f3:	b8 0f 00 00 00       	mov    $0xf,%eax
    15f8:	cd 40                	int    $0x40
    15fa:	c3                   	ret    

000015fb <procdump>:
SYSCALL(procdump)
    15fb:	b8 10 00 00 00       	mov    $0x10,%eax
    1600:	cd 40                	int    $0x40
    1602:	c3                   	ret    

00001603 <exit>:
SYSCALL(exit)
    1603:	b8 02 00 00 00       	mov    $0x2,%eax
    1608:	cd 40                	int    $0x40
    160a:	c3                   	ret    

0000160b <wait>:
SYSCALL(wait)
    160b:	b8 03 00 00 00       	mov    $0x3,%eax
    1610:	cd 40                	int    $0x40
    1612:	c3                   	ret    

00001613 <pipe>:
SYSCALL(pipe)
    1613:	b8 04 00 00 00       	mov    $0x4,%eax
    1618:	cd 40                	int    $0x40
    161a:	c3                   	ret    

0000161b <read>:
SYSCALL(read)
    161b:	b8 05 00 00 00       	mov    $0x5,%eax
    1620:	cd 40                	int    $0x40
    1622:	c3                   	ret    

00001623 <write>:
SYSCALL(write)
    1623:	b8 12 00 00 00       	mov    $0x12,%eax
    1628:	cd 40                	int    $0x40
    162a:	c3                   	ret    

0000162b <close>:
SYSCALL(close)
    162b:	b8 17 00 00 00       	mov    $0x17,%eax
    1630:	cd 40                	int    $0x40
    1632:	c3                   	ret    

00001633 <kill>:
SYSCALL(kill)
    1633:	b8 06 00 00 00       	mov    $0x6,%eax
    1638:	cd 40                	int    $0x40
    163a:	c3                   	ret    

0000163b <exec>:
SYSCALL(exec)
    163b:	b8 07 00 00 00       	mov    $0x7,%eax
    1640:	cd 40                	int    $0x40
    1642:	c3                   	ret    

00001643 <open>:
SYSCALL(open)
    1643:	b8 11 00 00 00       	mov    $0x11,%eax
    1648:	cd 40                	int    $0x40
    164a:	c3                   	ret    

0000164b <mknod>:
SYSCALL(mknod)
    164b:	b8 13 00 00 00       	mov    $0x13,%eax
    1650:	cd 40                	int    $0x40
    1652:	c3                   	ret    

00001653 <unlink>:
SYSCALL(unlink)
    1653:	b8 14 00 00 00       	mov    $0x14,%eax
    1658:	cd 40                	int    $0x40
    165a:	c3                   	ret    

0000165b <fstat>:
SYSCALL(fstat)
    165b:	b8 08 00 00 00       	mov    $0x8,%eax
    1660:	cd 40                	int    $0x40
    1662:	c3                   	ret    

00001663 <link>:
SYSCALL(link)
    1663:	b8 15 00 00 00       	mov    $0x15,%eax
    1668:	cd 40                	int    $0x40
    166a:	c3                   	ret    

0000166b <mkdir>:
SYSCALL(mkdir)
    166b:	b8 16 00 00 00       	mov    $0x16,%eax
    1670:	cd 40                	int    $0x40
    1672:	c3                   	ret    

00001673 <chdir>:
SYSCALL(chdir)
    1673:	b8 09 00 00 00       	mov    $0x9,%eax
    1678:	cd 40                	int    $0x40
    167a:	c3                   	ret    

0000167b <dup>:
SYSCALL(dup)
    167b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1680:	cd 40                	int    $0x40
    1682:	c3                   	ret    

00001683 <getpid>:
SYSCALL(getpid)
    1683:	b8 0b 00 00 00       	mov    $0xb,%eax
    1688:	cd 40                	int    $0x40
    168a:	c3                   	ret    

0000168b <sbrk>:
SYSCALL(sbrk)
    168b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1690:	cd 40                	int    $0x40
    1692:	c3                   	ret    

00001693 <sleep>:
SYSCALL(sleep)
    1693:	b8 0d 00 00 00       	mov    $0xd,%eax
    1698:	cd 40                	int    $0x40
    169a:	c3                   	ret    

0000169b <uptime>:
SYSCALL(uptime)
    169b:	b8 0e 00 00 00       	mov    $0xe,%eax
    16a0:	cd 40                	int    $0x40
    16a2:	c3                   	ret    

000016a3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    16a3:	55                   	push   %ebp
    16a4:	89 e5                	mov    %esp,%ebp
    16a6:	83 ec 18             	sub    $0x18,%esp
    16a9:	8b 45 0c             	mov    0xc(%ebp),%eax
    16ac:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    16af:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    16b6:	00 
    16b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
    16ba:	89 44 24 04          	mov    %eax,0x4(%esp)
    16be:	8b 45 08             	mov    0x8(%ebp),%eax
    16c1:	89 04 24             	mov    %eax,(%esp)
    16c4:	e8 5a ff ff ff       	call   1623 <write>
}
    16c9:	c9                   	leave  
    16ca:	c3                   	ret    

000016cb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    16cb:	55                   	push   %ebp
    16cc:	89 e5                	mov    %esp,%ebp
    16ce:	56                   	push   %esi
    16cf:	53                   	push   %ebx
    16d0:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    16d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16da:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16de:	74 17                	je     16f7 <printint+0x2c>
    16e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16e4:	79 11                	jns    16f7 <printint+0x2c>
    neg = 1;
    16e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16ed:	8b 45 0c             	mov    0xc(%ebp),%eax
    16f0:	f7 d8                	neg    %eax
    16f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16f5:	eb 06                	jmp    16fd <printint+0x32>
  } else {
    x = xx;
    16f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    16fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1704:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1707:	8d 41 01             	lea    0x1(%ecx),%eax
    170a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    170d:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1710:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1713:	ba 00 00 00 00       	mov    $0x0,%edx
    1718:	f7 f3                	div    %ebx
    171a:	89 d0                	mov    %edx,%eax
    171c:	0f b6 80 b8 2f 00 00 	movzbl 0x2fb8(%eax),%eax
    1723:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1727:	8b 75 10             	mov    0x10(%ebp),%esi
    172a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    172d:	ba 00 00 00 00       	mov    $0x0,%edx
    1732:	f7 f6                	div    %esi
    1734:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1737:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    173b:	75 c7                	jne    1704 <printint+0x39>
  if(neg)
    173d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1741:	74 10                	je     1753 <printint+0x88>
    buf[i++] = '-';
    1743:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1746:	8d 50 01             	lea    0x1(%eax),%edx
    1749:	89 55 f4             	mov    %edx,-0xc(%ebp)
    174c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1751:	eb 1f                	jmp    1772 <printint+0xa7>
    1753:	eb 1d                	jmp    1772 <printint+0xa7>
    putc(fd, buf[i]);
    1755:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1758:	8b 45 f4             	mov    -0xc(%ebp),%eax
    175b:	01 d0                	add    %edx,%eax
    175d:	0f b6 00             	movzbl (%eax),%eax
    1760:	0f be c0             	movsbl %al,%eax
    1763:	89 44 24 04          	mov    %eax,0x4(%esp)
    1767:	8b 45 08             	mov    0x8(%ebp),%eax
    176a:	89 04 24             	mov    %eax,(%esp)
    176d:	e8 31 ff ff ff       	call   16a3 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1772:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    177a:	79 d9                	jns    1755 <printint+0x8a>
    putc(fd, buf[i]);
}
    177c:	83 c4 30             	add    $0x30,%esp
    177f:	5b                   	pop    %ebx
    1780:	5e                   	pop    %esi
    1781:	5d                   	pop    %ebp
    1782:	c3                   	ret    

00001783 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1783:	55                   	push   %ebp
    1784:	89 e5                	mov    %esp,%ebp
    1786:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1789:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1790:	8d 45 0c             	lea    0xc(%ebp),%eax
    1793:	83 c0 04             	add    $0x4,%eax
    1796:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1799:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    17a0:	e9 7c 01 00 00       	jmp    1921 <printf+0x19e>
    c = fmt[i] & 0xff;
    17a5:	8b 55 0c             	mov    0xc(%ebp),%edx
    17a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ab:	01 d0                	add    %edx,%eax
    17ad:	0f b6 00             	movzbl (%eax),%eax
    17b0:	0f be c0             	movsbl %al,%eax
    17b3:	25 ff 00 00 00       	and    $0xff,%eax
    17b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    17bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17bf:	75 2c                	jne    17ed <printf+0x6a>
      if(c == '%'){
    17c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17c5:	75 0c                	jne    17d3 <printf+0x50>
        state = '%';
    17c7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    17ce:	e9 4a 01 00 00       	jmp    191d <printf+0x19a>
      } else {
        putc(fd, c);
    17d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17d6:	0f be c0             	movsbl %al,%eax
    17d9:	89 44 24 04          	mov    %eax,0x4(%esp)
    17dd:	8b 45 08             	mov    0x8(%ebp),%eax
    17e0:	89 04 24             	mov    %eax,(%esp)
    17e3:	e8 bb fe ff ff       	call   16a3 <putc>
    17e8:	e9 30 01 00 00       	jmp    191d <printf+0x19a>
      }
    } else if(state == '%'){
    17ed:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17f1:	0f 85 26 01 00 00    	jne    191d <printf+0x19a>
      if(c == 'd'){
    17f7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17fb:	75 2d                	jne    182a <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1800:	8b 00                	mov    (%eax),%eax
    1802:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1809:	00 
    180a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1811:	00 
    1812:	89 44 24 04          	mov    %eax,0x4(%esp)
    1816:	8b 45 08             	mov    0x8(%ebp),%eax
    1819:	89 04 24             	mov    %eax,(%esp)
    181c:	e8 aa fe ff ff       	call   16cb <printint>
        ap++;
    1821:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1825:	e9 ec 00 00 00       	jmp    1916 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    182a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    182e:	74 06                	je     1836 <printf+0xb3>
    1830:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1834:	75 2d                	jne    1863 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1836:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1839:	8b 00                	mov    (%eax),%eax
    183b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1842:	00 
    1843:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    184a:	00 
    184b:	89 44 24 04          	mov    %eax,0x4(%esp)
    184f:	8b 45 08             	mov    0x8(%ebp),%eax
    1852:	89 04 24             	mov    %eax,(%esp)
    1855:	e8 71 fe ff ff       	call   16cb <printint>
        ap++;
    185a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    185e:	e9 b3 00 00 00       	jmp    1916 <printf+0x193>
      } else if(c == 's'){
    1863:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1867:	75 45                	jne    18ae <printf+0x12b>
        s = (char*)*ap;
    1869:	8b 45 e8             	mov    -0x18(%ebp),%eax
    186c:	8b 00                	mov    (%eax),%eax
    186e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1871:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1879:	75 09                	jne    1884 <printf+0x101>
          s = "(null)";
    187b:	c7 45 f4 68 1d 00 00 	movl   $0x1d68,-0xc(%ebp)
        while(*s != 0){
    1882:	eb 1e                	jmp    18a2 <printf+0x11f>
    1884:	eb 1c                	jmp    18a2 <printf+0x11f>
          putc(fd, *s);
    1886:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1889:	0f b6 00             	movzbl (%eax),%eax
    188c:	0f be c0             	movsbl %al,%eax
    188f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1893:	8b 45 08             	mov    0x8(%ebp),%eax
    1896:	89 04 24             	mov    %eax,(%esp)
    1899:	e8 05 fe ff ff       	call   16a3 <putc>
          s++;
    189e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    18a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a5:	0f b6 00             	movzbl (%eax),%eax
    18a8:	84 c0                	test   %al,%al
    18aa:	75 da                	jne    1886 <printf+0x103>
    18ac:	eb 68                	jmp    1916 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    18ae:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    18b2:	75 1d                	jne    18d1 <printf+0x14e>
        putc(fd, *ap);
    18b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18b7:	8b 00                	mov    (%eax),%eax
    18b9:	0f be c0             	movsbl %al,%eax
    18bc:	89 44 24 04          	mov    %eax,0x4(%esp)
    18c0:	8b 45 08             	mov    0x8(%ebp),%eax
    18c3:	89 04 24             	mov    %eax,(%esp)
    18c6:	e8 d8 fd ff ff       	call   16a3 <putc>
        ap++;
    18cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18cf:	eb 45                	jmp    1916 <printf+0x193>
      } else if(c == '%'){
    18d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18d5:	75 17                	jne    18ee <printf+0x16b>
        putc(fd, c);
    18d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18da:	0f be c0             	movsbl %al,%eax
    18dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    18e1:	8b 45 08             	mov    0x8(%ebp),%eax
    18e4:	89 04 24             	mov    %eax,(%esp)
    18e7:	e8 b7 fd ff ff       	call   16a3 <putc>
    18ec:	eb 28                	jmp    1916 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18ee:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18f5:	00 
    18f6:	8b 45 08             	mov    0x8(%ebp),%eax
    18f9:	89 04 24             	mov    %eax,(%esp)
    18fc:	e8 a2 fd ff ff       	call   16a3 <putc>
        putc(fd, c);
    1901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1904:	0f be c0             	movsbl %al,%eax
    1907:	89 44 24 04          	mov    %eax,0x4(%esp)
    190b:	8b 45 08             	mov    0x8(%ebp),%eax
    190e:	89 04 24             	mov    %eax,(%esp)
    1911:	e8 8d fd ff ff       	call   16a3 <putc>
      }
      state = 0;
    1916:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    191d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1921:	8b 55 0c             	mov    0xc(%ebp),%edx
    1924:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1927:	01 d0                	add    %edx,%eax
    1929:	0f b6 00             	movzbl (%eax),%eax
    192c:	84 c0                	test   %al,%al
    192e:	0f 85 71 fe ff ff    	jne    17a5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1934:	c9                   	leave  
    1935:	c3                   	ret    

00001936 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1936:	55                   	push   %ebp
    1937:	89 e5                	mov    %esp,%ebp
    1939:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    193c:	8b 45 08             	mov    0x8(%ebp),%eax
    193f:	83 e8 08             	sub    $0x8,%eax
    1942:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1945:	a1 d4 2f 00 00       	mov    0x2fd4,%eax
    194a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    194d:	eb 24                	jmp    1973 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1952:	8b 00                	mov    (%eax),%eax
    1954:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1957:	77 12                	ja     196b <free+0x35>
    1959:	8b 45 f8             	mov    -0x8(%ebp),%eax
    195c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    195f:	77 24                	ja     1985 <free+0x4f>
    1961:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1964:	8b 00                	mov    (%eax),%eax
    1966:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1969:	77 1a                	ja     1985 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196e:	8b 00                	mov    (%eax),%eax
    1970:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1973:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1976:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1979:	76 d4                	jbe    194f <free+0x19>
    197b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    197e:	8b 00                	mov    (%eax),%eax
    1980:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1983:	76 ca                	jbe    194f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1985:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1988:	8b 40 04             	mov    0x4(%eax),%eax
    198b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1992:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1995:	01 c2                	add    %eax,%edx
    1997:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199a:	8b 00                	mov    (%eax),%eax
    199c:	39 c2                	cmp    %eax,%edx
    199e:	75 24                	jne    19c4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    19a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19a3:	8b 50 04             	mov    0x4(%eax),%edx
    19a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a9:	8b 00                	mov    (%eax),%eax
    19ab:	8b 40 04             	mov    0x4(%eax),%eax
    19ae:	01 c2                	add    %eax,%edx
    19b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19b3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    19b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b9:	8b 00                	mov    (%eax),%eax
    19bb:	8b 10                	mov    (%eax),%edx
    19bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19c0:	89 10                	mov    %edx,(%eax)
    19c2:	eb 0a                	jmp    19ce <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    19c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c7:	8b 10                	mov    (%eax),%edx
    19c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19cc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    19ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d1:	8b 40 04             	mov    0x4(%eax),%eax
    19d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19de:	01 d0                	add    %edx,%eax
    19e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19e3:	75 20                	jne    1a05 <free+0xcf>
    p->s.size += bp->s.size;
    19e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e8:	8b 50 04             	mov    0x4(%eax),%edx
    19eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19ee:	8b 40 04             	mov    0x4(%eax),%eax
    19f1:	01 c2                	add    %eax,%edx
    19f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19fc:	8b 10                	mov    (%eax),%edx
    19fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a01:	89 10                	mov    %edx,(%eax)
    1a03:	eb 08                	jmp    1a0d <free+0xd7>
  } else
    p->s.ptr = bp;
    1a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a08:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1a0b:	89 10                	mov    %edx,(%eax)
  freep = p;
    1a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a10:	a3 d4 2f 00 00       	mov    %eax,0x2fd4
}
    1a15:	c9                   	leave  
    1a16:	c3                   	ret    

00001a17 <morecore>:

static Header*
morecore(uint nu)
{
    1a17:	55                   	push   %ebp
    1a18:	89 e5                	mov    %esp,%ebp
    1a1a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1a1d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1a24:	77 07                	ja     1a2d <morecore+0x16>
    nu = 4096;
    1a26:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1a2d:	8b 45 08             	mov    0x8(%ebp),%eax
    1a30:	c1 e0 03             	shl    $0x3,%eax
    1a33:	89 04 24             	mov    %eax,(%esp)
    1a36:	e8 50 fc ff ff       	call   168b <sbrk>
    1a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a3e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a42:	75 07                	jne    1a4b <morecore+0x34>
    return 0;
    1a44:	b8 00 00 00 00       	mov    $0x0,%eax
    1a49:	eb 22                	jmp    1a6d <morecore+0x56>
  hp = (Header*)p;
    1a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a54:	8b 55 08             	mov    0x8(%ebp),%edx
    1a57:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a5d:	83 c0 08             	add    $0x8,%eax
    1a60:	89 04 24             	mov    %eax,(%esp)
    1a63:	e8 ce fe ff ff       	call   1936 <free>
  return freep;
    1a68:	a1 d4 2f 00 00       	mov    0x2fd4,%eax
}
    1a6d:	c9                   	leave  
    1a6e:	c3                   	ret    

00001a6f <malloc>:

void*
malloc(uint nbytes)
{
    1a6f:	55                   	push   %ebp
    1a70:	89 e5                	mov    %esp,%ebp
    1a72:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a75:	8b 45 08             	mov    0x8(%ebp),%eax
    1a78:	83 c0 07             	add    $0x7,%eax
    1a7b:	c1 e8 03             	shr    $0x3,%eax
    1a7e:	83 c0 01             	add    $0x1,%eax
    1a81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a84:	a1 d4 2f 00 00       	mov    0x2fd4,%eax
    1a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a90:	75 23                	jne    1ab5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a92:	c7 45 f0 cc 2f 00 00 	movl   $0x2fcc,-0x10(%ebp)
    1a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a9c:	a3 d4 2f 00 00       	mov    %eax,0x2fd4
    1aa1:	a1 d4 2f 00 00       	mov    0x2fd4,%eax
    1aa6:	a3 cc 2f 00 00       	mov    %eax,0x2fcc
    base.s.size = 0;
    1aab:	c7 05 d0 2f 00 00 00 	movl   $0x0,0x2fd0
    1ab2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab8:	8b 00                	mov    (%eax),%eax
    1aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac0:	8b 40 04             	mov    0x4(%eax),%eax
    1ac3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ac6:	72 4d                	jb     1b15 <malloc+0xa6>
      if(p->s.size == nunits)
    1ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1acb:	8b 40 04             	mov    0x4(%eax),%eax
    1ace:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ad1:	75 0c                	jne    1adf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad6:	8b 10                	mov    (%eax),%edx
    1ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1adb:	89 10                	mov    %edx,(%eax)
    1add:	eb 26                	jmp    1b05 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae2:	8b 40 04             	mov    0x4(%eax),%eax
    1ae5:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ae8:	89 c2                	mov    %eax,%edx
    1aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aed:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1af3:	8b 40 04             	mov    0x4(%eax),%eax
    1af6:	c1 e0 03             	shl    $0x3,%eax
    1af9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aff:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b02:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b08:	a3 d4 2f 00 00       	mov    %eax,0x2fd4
      return (void*)(p + 1);
    1b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b10:	83 c0 08             	add    $0x8,%eax
    1b13:	eb 38                	jmp    1b4d <malloc+0xde>
    }
    if(p == freep)
    1b15:	a1 d4 2f 00 00       	mov    0x2fd4,%eax
    1b1a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1b1d:	75 1b                	jne    1b3a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b22:	89 04 24             	mov    %eax,(%esp)
    1b25:	e8 ed fe ff ff       	call   1a17 <morecore>
    1b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b31:	75 07                	jne    1b3a <malloc+0xcb>
        return 0;
    1b33:	b8 00 00 00 00       	mov    $0x0,%eax
    1b38:	eb 13                	jmp    1b4d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b43:	8b 00                	mov    (%eax),%eax
    1b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b48:	e9 70 ff ff ff       	jmp    1abd <malloc+0x4e>
}
    1b4d:	c9                   	leave  
    1b4e:	c3                   	ret    
