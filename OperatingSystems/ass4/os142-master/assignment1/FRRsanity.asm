
_FRRsanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define NUM_OF_CHILDRENS 10
#define NUM_OF_CHILD_LOOPS 1000

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 e4 f0             	and    $0xfffffff0,%esp
   8:	81 ec e0 00 00 00    	sub    $0xe0,%esp
	int i,j,index,wTime,rTime,ioTime = 0;
   e:	c7 84 24 c4 00 00 00 	movl   $0x0,0xc4(%esp)
  15:	00 00 00 00 
	int fork_id = 1;
  19:	c7 84 24 d0 00 00 00 	movl   $0x1,0xd0(%esp)
  20:	01 00 00 00 
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
  24:	c7 84 24 dc 00 00 00 	movl   $0x0,0xdc(%esp)
  2b:	00 00 00 00 
  2f:	eb 40                	jmp    71 <main+0x71>
		for (j=0 ; j < 4 ; j++)
  31:	c7 84 24 d8 00 00 00 	movl   $0x0,0xd8(%esp)
  38:	00 00 00 00 
  3c:	eb 21                	jmp    5f <main+0x5f>
			c_array[i][j] = 0;
  3e:	8b 84 24 dc 00 00 00 	mov    0xdc(%esp),%eax
  45:	c1 e0 02             	shl    $0x2,%eax
  48:	03 84 24 d8 00 00 00 	add    0xd8(%esp),%eax
  4f:	c7 44 84 24 00 00 00 	movl   $0x0,0x24(%esp,%eax,4)
  56:	00 
{
	int i,j,index,wTime,rTime,ioTime = 0;
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
		for (j=0 ; j < 4 ; j++)
  57:	83 84 24 d8 00 00 00 	addl   $0x1,0xd8(%esp)
  5e:	01 
  5f:	83 bc 24 d8 00 00 00 	cmpl   $0x3,0xd8(%esp)
  66:	03 
  67:	7e d5                	jle    3e <main+0x3e>
int main(int argc, char *argv[])
{
	int i,j,index,wTime,rTime,ioTime = 0;
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
  69:	83 84 24 dc 00 00 00 	addl   $0x1,0xdc(%esp)
  70:	01 
  71:	83 bc 24 dc 00 00 00 	cmpl   $0x9,0xdc(%esp)
  78:	09 
  79:	7e b6                	jle    31 <main+0x31>
		for (j=0 ; j < 4 ; j++)
			c_array[i][j] = 0;
	for (i=0 ; i < NUM_OF_CHILDRENS && fork_id !=0; i++) {
  7b:	c7 84 24 dc 00 00 00 	movl   $0x0,0xdc(%esp)
  82:	00 00 00 00 
  86:	eb 6d                	jmp    f5 <main+0xf5>
		fork_id = fork();
  88:	e8 7b 04 00 00       	call   508 <fork>
  8d:	89 84 24 d0 00 00 00 	mov    %eax,0xd0(%esp)
		if (fork_id == 0) {
  94:	83 bc 24 d0 00 00 00 	cmpl   $0x0,0xd0(%esp)
  9b:	00 
  9c:	75 4f                	jne    ed <main+0xed>
			for (j=0 ; j < NUM_OF_CHILD_LOOPS ; j++)
  9e:	c7 84 24 d8 00 00 00 	movl   $0x0,0xd8(%esp)
  a5:	00 00 00 00 
  a9:	eb 30                	jmp    db <main+0xdb>
				printf(2,"child <%d> prints for the <%d>\n",getpid(),j);
  ab:	e8 f0 04 00 00       	call   5a0 <getpid>
  b0:	8b 94 24 d8 00 00 00 	mov    0xd8(%esp),%edx
  b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  bf:	c7 44 24 04 5c 0a 00 	movl   $0xa5c,0x4(%esp)
  c6:	00 
  c7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ce:	e8 c4 05 00 00       	call   697 <printf>
		for (j=0 ; j < 4 ; j++)
			c_array[i][j] = 0;
	for (i=0 ; i < NUM_OF_CHILDRENS && fork_id !=0; i++) {
		fork_id = fork();
		if (fork_id == 0) {
			for (j=0 ; j < NUM_OF_CHILD_LOOPS ; j++)
  d3:	83 84 24 d8 00 00 00 	addl   $0x1,0xd8(%esp)
  da:	01 
  db:	81 bc 24 d8 00 00 00 	cmpl   $0x3e7,0xd8(%esp)
  e2:	e7 03 00 00 
  e6:	7e c3                	jle    ab <main+0xab>
				printf(2,"child <%d> prints for the <%d>\n",getpid(),j);
			exit();
  e8:	e8 23 04 00 00       	call   510 <exit>
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
		for (j=0 ; j < 4 ; j++)
			c_array[i][j] = 0;
	for (i=0 ; i < NUM_OF_CHILDRENS && fork_id !=0; i++) {
  ed:	83 84 24 dc 00 00 00 	addl   $0x1,0xdc(%esp)
  f4:	01 
  f5:	83 bc 24 dc 00 00 00 	cmpl   $0x9,0xdc(%esp)
  fc:	09 
  fd:	0f 8f b6 00 00 00    	jg     1b9 <main+0x1b9>
 103:	83 bc 24 d0 00 00 00 	cmpl   $0x0,0xd0(%esp)
 10a:	00 
 10b:	0f 85 77 ff ff ff    	jne    88 <main+0x88>
				printf(2,"child <%d> prints for the <%d>\n",getpid(),j);
			exit();
		}
	}

	while ((fork_id = wait2(&wTime,&rTime,&ioTime)) > 0) {
 111:	e9 a3 00 00 00       	jmp    1b9 <main+0x1b9>
		c_array[index][0] = fork_id;
 116:	8b 84 24 d4 00 00 00 	mov    0xd4(%esp),%eax
 11d:	c1 e0 04             	shl    $0x4,%eax
 120:	8d 94 24 e0 00 00 00 	lea    0xe0(%esp),%edx
 127:	01 d0                	add    %edx,%eax
 129:	8d 90 44 ff ff ff    	lea    -0xbc(%eax),%edx
 12f:	8b 84 24 d0 00 00 00 	mov    0xd0(%esp),%eax
 136:	89 02                	mov    %eax,(%edx)
		c_array[index][1] = wTime;	// waiting time
 138:	8b 84 24 cc 00 00 00 	mov    0xcc(%esp),%eax
 13f:	8b 94 24 d4 00 00 00 	mov    0xd4(%esp),%edx
 146:	c1 e2 04             	shl    $0x4,%edx
 149:	8d 8c 24 e0 00 00 00 	lea    0xe0(%esp),%ecx
 150:	01 ca                	add    %ecx,%edx
 152:	81 ea b8 00 00 00    	sub    $0xb8,%edx
 158:	89 02                	mov    %eax,(%edx)
		c_array[index][2] = rTime;	// run time
 15a:	8b 84 24 c8 00 00 00 	mov    0xc8(%esp),%eax
 161:	8b 94 24 d4 00 00 00 	mov    0xd4(%esp),%edx
 168:	c1 e2 04             	shl    $0x4,%edx
 16b:	8d b4 24 e0 00 00 00 	lea    0xe0(%esp),%esi
 172:	01 f2                	add    %esi,%edx
 174:	81 ea b4 00 00 00    	sub    $0xb4,%edx
 17a:	89 02                	mov    %eax,(%edx)
		c_array[index][3] = wTime+ioTime+rTime; // turnaround time -> end time - creation time
 17c:	8b 94 24 cc 00 00 00 	mov    0xcc(%esp),%edx
 183:	8b 84 24 c4 00 00 00 	mov    0xc4(%esp),%eax
 18a:	01 c2                	add    %eax,%edx
 18c:	8b 84 24 c8 00 00 00 	mov    0xc8(%esp),%eax
 193:	01 c2                	add    %eax,%edx
 195:	8b 84 24 d4 00 00 00 	mov    0xd4(%esp),%eax
 19c:	c1 e0 04             	shl    $0x4,%eax
 19f:	8d 8c 24 e0 00 00 00 	lea    0xe0(%esp),%ecx
 1a6:	01 c8                	add    %ecx,%eax
 1a8:	2d b0 00 00 00       	sub    $0xb0,%eax
 1ad:	89 10                	mov    %edx,(%eax)
		index++;
 1af:	83 84 24 d4 00 00 00 	addl   $0x1,0xd4(%esp)
 1b6:	01 
 1b7:	eb 01                	jmp    1ba <main+0x1ba>
				printf(2,"child <%d> prints for the <%d>\n",getpid(),j);
			exit();
		}
	}

	while ((fork_id = wait2(&wTime,&rTime,&ioTime)) > 0) {
 1b9:	90                   	nop
 1ba:	8d 84 24 c4 00 00 00 	lea    0xc4(%esp),%eax
 1c1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c5:	8d 84 24 c8 00 00 00 	lea    0xc8(%esp),%eax
 1cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d0:	8d 84 24 cc 00 00 00 	lea    0xcc(%esp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 41 03 00 00       	call   520 <wait2>
 1df:	89 84 24 d0 00 00 00 	mov    %eax,0xd0(%esp)
 1e6:	83 bc 24 d0 00 00 00 	cmpl   $0x0,0xd0(%esp)
 1ed:	00 
 1ee:	0f 8f 22 ff ff ff    	jg     116 <main+0x116>
		c_array[index][2] = rTime;	// run time
		c_array[index][3] = wTime+ioTime+rTime; // turnaround time -> end time - creation time
		index++;
	}

	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++) {
 1f4:	c7 84 24 d4 00 00 00 	movl   $0x0,0xd4(%esp)
 1fb:	00 00 00 00 
 1ff:	e9 94 00 00 00       	jmp    298 <main+0x298>
		printf(2,"Child <%d>: Waiting time %d , Running time %d , Turnaround time %d\n",c_array[index][0],c_array[index][1],c_array[index][2],c_array[index][3]);
 204:	8b 84 24 d4 00 00 00 	mov    0xd4(%esp),%eax
 20b:	c1 e0 04             	shl    $0x4,%eax
 20e:	8d b4 24 e0 00 00 00 	lea    0xe0(%esp),%esi
 215:	01 f0                	add    %esi,%eax
 217:	2d b0 00 00 00       	sub    $0xb0,%eax
 21c:	8b 18                	mov    (%eax),%ebx
 21e:	8b 84 24 d4 00 00 00 	mov    0xd4(%esp),%eax
 225:	c1 e0 04             	shl    $0x4,%eax
 228:	8d 94 24 e0 00 00 00 	lea    0xe0(%esp),%edx
 22f:	01 d0                	add    %edx,%eax
 231:	2d b4 00 00 00       	sub    $0xb4,%eax
 236:	8b 08                	mov    (%eax),%ecx
 238:	8b 84 24 d4 00 00 00 	mov    0xd4(%esp),%eax
 23f:	c1 e0 04             	shl    $0x4,%eax
 242:	8d b4 24 e0 00 00 00 	lea    0xe0(%esp),%esi
 249:	01 f0                	add    %esi,%eax
 24b:	2d b8 00 00 00       	sub    $0xb8,%eax
 250:	8b 10                	mov    (%eax),%edx
 252:	8b 84 24 d4 00 00 00 	mov    0xd4(%esp),%eax
 259:	c1 e0 04             	shl    $0x4,%eax
 25c:	8d b4 24 e0 00 00 00 	lea    0xe0(%esp),%esi
 263:	01 f0                	add    %esi,%eax
 265:	2d bc 00 00 00       	sub    $0xbc,%eax
 26a:	8b 00                	mov    (%eax),%eax
 26c:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 270:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 274:	89 54 24 0c          	mov    %edx,0xc(%esp)
 278:	89 44 24 08          	mov    %eax,0x8(%esp)
 27c:	c7 44 24 04 7c 0a 00 	movl   $0xa7c,0x4(%esp)
 283:	00 
 284:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 28b:	e8 07 04 00 00       	call   697 <printf>
		c_array[index][2] = rTime;	// run time
		c_array[index][3] = wTime+ioTime+rTime; // turnaround time -> end time - creation time
		index++;
	}

	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++) {
 290:	83 84 24 d4 00 00 00 	addl   $0x1,0xd4(%esp)
 297:	01 
 298:	83 bc 24 d4 00 00 00 	cmpl   $0x9,0xd4(%esp)
 29f:	09 
 2a0:	0f 8e 5e ff ff ff    	jle    204 <main+0x204>
		printf(2,"Child <%d>: Waiting time %d , Running time %d , Turnaround time %d\n",c_array[index][0],c_array[index][1],c_array[index][2],c_array[index][3]);
	}
	exit();
 2a6:	e8 65 02 00 00       	call   510 <exit>
 2ab:	90                   	nop

000002ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	57                   	push   %edi
 2b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b4:	8b 55 10             	mov    0x10(%ebp),%edx
 2b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ba:	89 cb                	mov    %ecx,%ebx
 2bc:	89 df                	mov    %ebx,%edi
 2be:	89 d1                	mov    %edx,%ecx
 2c0:	fc                   	cld    
 2c1:	f3 aa                	rep stos %al,%es:(%edi)
 2c3:	89 ca                	mov    %ecx,%edx
 2c5:	89 fb                	mov    %edi,%ebx
 2c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2cd:	5b                   	pop    %ebx
 2ce:	5f                   	pop    %edi
 2cf:	5d                   	pop    %ebp
 2d0:	c3                   	ret    

000002d1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2dd:	90                   	nop
 2de:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e1:	0f b6 10             	movzbl (%eax),%edx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	88 10                	mov    %dl,(%eax)
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	84 c0                	test   %al,%al
 2f1:	0f 95 c0             	setne  %al
 2f4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 2fc:	84 c0                	test   %al,%al
 2fe:	75 de                	jne    2de <strcpy+0xd>
    ;
  return os;
 300:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 303:	c9                   	leave  
 304:	c3                   	ret    

00000305 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 305:	55                   	push   %ebp
 306:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 308:	eb 08                	jmp    312 <strcmp+0xd>
    p++, q++;
 30a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 30e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	84 c0                	test   %al,%al
 31a:	74 10                	je     32c <strcmp+0x27>
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 10             	movzbl (%eax),%edx
 322:	8b 45 0c             	mov    0xc(%ebp),%eax
 325:	0f b6 00             	movzbl (%eax),%eax
 328:	38 c2                	cmp    %al,%dl
 32a:	74 de                	je     30a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	0f b6 d0             	movzbl %al,%edx
 335:	8b 45 0c             	mov    0xc(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	0f b6 c0             	movzbl %al,%eax
 33e:	89 d1                	mov    %edx,%ecx
 340:	29 c1                	sub    %eax,%ecx
 342:	89 c8                	mov    %ecx,%eax
}
 344:	5d                   	pop    %ebp
 345:	c3                   	ret    

00000346 <strlen>:

uint
strlen(char *s)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 34c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 353:	eb 04                	jmp    359 <strlen+0x13>
 355:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 359:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35c:	03 45 08             	add    0x8(%ebp),%eax
 35f:	0f b6 00             	movzbl (%eax),%eax
 362:	84 c0                	test   %al,%al
 364:	75 ef                	jne    355 <strlen+0xf>
    ;
  return n;
 366:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 369:	c9                   	leave  
 36a:	c3                   	ret    

0000036b <memset>:

void*
memset(void *dst, int c, uint n)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 371:	8b 45 10             	mov    0x10(%ebp),%eax
 374:	89 44 24 08          	mov    %eax,0x8(%esp)
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	89 44 24 04          	mov    %eax,0x4(%esp)
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 04 24             	mov    %eax,(%esp)
 385:	e8 22 ff ff ff       	call   2ac <stosb>
  return dst;
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 38d:	c9                   	leave  
 38e:	c3                   	ret    

0000038f <strchr>:

char*
strchr(const char *s, char c)
{
 38f:	55                   	push   %ebp
 390:	89 e5                	mov    %esp,%ebp
 392:	83 ec 04             	sub    $0x4,%esp
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 39b:	eb 14                	jmp    3b1 <strchr+0x22>
    if(*s == c)
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	0f b6 00             	movzbl (%eax),%eax
 3a3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3a6:	75 05                	jne    3ad <strchr+0x1e>
      return (char*)s;
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	eb 13                	jmp    3c0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	84 c0                	test   %al,%al
 3b9:	75 e2                	jne    39d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3c0:	c9                   	leave  
 3c1:	c3                   	ret    

000003c2 <gets>:

char*
gets(char *buf, int max)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
 3c5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3cf:	eb 44                	jmp    415 <gets+0x53>
    cc = read(0, &c, 1);
 3d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d8:	00 
 3d9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3e7:	e8 4c 01 00 00       	call   538 <read>
 3ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f3:	7e 2d                	jle    422 <gets+0x60>
      break;
    buf[i++] = c;
 3f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f8:	03 45 08             	add    0x8(%ebp),%eax
 3fb:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 3ff:	88 10                	mov    %dl,(%eax)
 401:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 405:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 409:	3c 0a                	cmp    $0xa,%al
 40b:	74 16                	je     423 <gets+0x61>
 40d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 411:	3c 0d                	cmp    $0xd,%al
 413:	74 0e                	je     423 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	83 c0 01             	add    $0x1,%eax
 41b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 41e:	7c b1                	jl     3d1 <gets+0xf>
 420:	eb 01                	jmp    423 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 422:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 423:	8b 45 f4             	mov    -0xc(%ebp),%eax
 426:	03 45 08             	add    0x8(%ebp),%eax
 429:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42f:	c9                   	leave  
 430:	c3                   	ret    

00000431 <stat>:

int
stat(char *n, struct stat *st)
{
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 437:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 43e:	00 
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	89 04 24             	mov    %eax,(%esp)
 445:	e8 16 01 00 00       	call   560 <open>
 44a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 44d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 451:	79 07                	jns    45a <stat+0x29>
    return -1;
 453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 458:	eb 23                	jmp    47d <stat+0x4c>
  r = fstat(fd, st);
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 44 24 04          	mov    %eax,0x4(%esp)
 461:	8b 45 f4             	mov    -0xc(%ebp),%eax
 464:	89 04 24             	mov    %eax,(%esp)
 467:	e8 0c 01 00 00       	call   578 <fstat>
 46c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 472:	89 04 24             	mov    %eax,(%esp)
 475:	e8 ce 00 00 00       	call   548 <close>
  return r;
 47a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 47d:	c9                   	leave  
 47e:	c3                   	ret    

0000047f <atoi>:

int
atoi(const char *s)
{
 47f:	55                   	push   %ebp
 480:	89 e5                	mov    %esp,%ebp
 482:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 48c:	eb 23                	jmp    4b1 <atoi+0x32>
    n = n*10 + *s++ - '0';
 48e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 491:	89 d0                	mov    %edx,%eax
 493:	c1 e0 02             	shl    $0x2,%eax
 496:	01 d0                	add    %edx,%eax
 498:	01 c0                	add    %eax,%eax
 49a:	89 c2                	mov    %eax,%edx
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	0f b6 00             	movzbl (%eax),%eax
 4a2:	0f be c0             	movsbl %al,%eax
 4a5:	01 d0                	add    %edx,%eax
 4a7:	83 e8 30             	sub    $0x30,%eax
 4aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 4ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	0f b6 00             	movzbl (%eax),%eax
 4b7:	3c 2f                	cmp    $0x2f,%al
 4b9:	7e 0a                	jle    4c5 <atoi+0x46>
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	0f b6 00             	movzbl (%eax),%eax
 4c1:	3c 39                	cmp    $0x39,%al
 4c3:	7e c9                	jle    48e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4c8:	c9                   	leave  
 4c9:	c3                   	ret    

000004ca <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4ca:	55                   	push   %ebp
 4cb:	89 e5                	mov    %esp,%ebp
 4cd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4dc:	eb 13                	jmp    4f1 <memmove+0x27>
    *dst++ = *src++;
 4de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4e1:	0f b6 10             	movzbl (%eax),%edx
 4e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4e7:	88 10                	mov    %dl,(%eax)
 4e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4ed:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4f5:	0f 9f c0             	setg   %al
 4f8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 4fc:	84 c0                	test   %al,%al
 4fe:	75 de                	jne    4de <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 500:	8b 45 08             	mov    0x8(%ebp),%eax
}
 503:	c9                   	leave  
 504:	c3                   	ret    
 505:	90                   	nop
 506:	90                   	nop
 507:	90                   	nop

00000508 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 508:	b8 01 00 00 00       	mov    $0x1,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <exit>:
SYSCALL(exit)
 510:	b8 02 00 00 00       	mov    $0x2,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <wait>:
SYSCALL(wait)
 518:	b8 03 00 00 00       	mov    $0x3,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <wait2>:
SYSCALL(wait2)
 520:	b8 16 00 00 00       	mov    $0x16,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <add_path>:
SYSCALL(add_path)
 528:	b8 17 00 00 00       	mov    $0x17,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <pipe>:
SYSCALL(pipe)
 530:	b8 04 00 00 00       	mov    $0x4,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <read>:
SYSCALL(read)
 538:	b8 05 00 00 00       	mov    $0x5,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <write>:
SYSCALL(write)
 540:	b8 10 00 00 00       	mov    $0x10,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <close>:
SYSCALL(close)
 548:	b8 15 00 00 00       	mov    $0x15,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <kill>:
SYSCALL(kill)
 550:	b8 06 00 00 00       	mov    $0x6,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <exec>:
SYSCALL(exec)
 558:	b8 07 00 00 00       	mov    $0x7,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <open>:
SYSCALL(open)
 560:	b8 0f 00 00 00       	mov    $0xf,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <mknod>:
SYSCALL(mknod)
 568:	b8 11 00 00 00       	mov    $0x11,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <unlink>:
SYSCALL(unlink)
 570:	b8 12 00 00 00       	mov    $0x12,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <fstat>:
SYSCALL(fstat)
 578:	b8 08 00 00 00       	mov    $0x8,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <link>:
SYSCALL(link)
 580:	b8 13 00 00 00       	mov    $0x13,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <mkdir>:
SYSCALL(mkdir)
 588:	b8 14 00 00 00       	mov    $0x14,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <chdir>:
SYSCALL(chdir)
 590:	b8 09 00 00 00       	mov    $0x9,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <dup>:
SYSCALL(dup)
 598:	b8 0a 00 00 00       	mov    $0xa,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <getpid>:
SYSCALL(getpid)
 5a0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <sbrk>:
SYSCALL(sbrk)
 5a8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <sleep>:
SYSCALL(sleep)
 5b0:	b8 0d 00 00 00       	mov    $0xd,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <uptime>:
SYSCALL(uptime)
 5b8:	b8 0e 00 00 00       	mov    $0xe,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	83 ec 28             	sub    $0x28,%esp
 5c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d3:	00 
 5d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	89 04 24             	mov    %eax,(%esp)
 5e1:	e8 5a ff ff ff       	call   540 <write>
}
 5e6:	c9                   	leave  
 5e7:	c3                   	ret    

000005e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5f9:	74 17                	je     612 <printint+0x2a>
 5fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ff:	79 11                	jns    612 <printint+0x2a>
    neg = 1;
 601:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 608:	8b 45 0c             	mov    0xc(%ebp),%eax
 60b:	f7 d8                	neg    %eax
 60d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 610:	eb 06                	jmp    618 <printint+0x30>
  } else {
    x = xx;
 612:	8b 45 0c             	mov    0xc(%ebp),%eax
 615:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 618:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 61f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 622:	8b 45 ec             	mov    -0x14(%ebp),%eax
 625:	ba 00 00 00 00       	mov    $0x0,%edx
 62a:	f7 f1                	div    %ecx
 62c:	89 d0                	mov    %edx,%eax
 62e:	0f b6 90 08 0d 00 00 	movzbl 0xd08(%eax),%edx
 635:	8d 45 dc             	lea    -0x24(%ebp),%eax
 638:	03 45 f4             	add    -0xc(%ebp),%eax
 63b:	88 10                	mov    %dl,(%eax)
 63d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 641:	8b 55 10             	mov    0x10(%ebp),%edx
 644:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 647:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64a:	ba 00 00 00 00       	mov    $0x0,%edx
 64f:	f7 75 d4             	divl   -0x2c(%ebp)
 652:	89 45 ec             	mov    %eax,-0x14(%ebp)
 655:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 659:	75 c4                	jne    61f <printint+0x37>
  if(neg)
 65b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 65f:	74 2a                	je     68b <printint+0xa3>
    buf[i++] = '-';
 661:	8d 45 dc             	lea    -0x24(%ebp),%eax
 664:	03 45 f4             	add    -0xc(%ebp),%eax
 667:	c6 00 2d             	movb   $0x2d,(%eax)
 66a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 66e:	eb 1b                	jmp    68b <printint+0xa3>
    putc(fd, buf[i]);
 670:	8d 45 dc             	lea    -0x24(%ebp),%eax
 673:	03 45 f4             	add    -0xc(%ebp),%eax
 676:	0f b6 00             	movzbl (%eax),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 35 ff ff ff       	call   5c0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 68b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 68f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 693:	79 db                	jns    670 <printint+0x88>
    putc(fd, buf[i]);
}
 695:	c9                   	leave  
 696:	c3                   	ret    

00000697 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 697:	55                   	push   %ebp
 698:	89 e5                	mov    %esp,%ebp
 69a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 69d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6a4:	8d 45 0c             	lea    0xc(%ebp),%eax
 6a7:	83 c0 04             	add    $0x4,%eax
 6aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6b4:	e9 7d 01 00 00       	jmp    836 <printf+0x19f>
    c = fmt[i] & 0xff;
 6b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bf:	01 d0                	add    %edx,%eax
 6c1:	0f b6 00             	movzbl (%eax),%eax
 6c4:	0f be c0             	movsbl %al,%eax
 6c7:	25 ff 00 00 00       	and    $0xff,%eax
 6cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d3:	75 2c                	jne    701 <printf+0x6a>
      if(c == '%'){
 6d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d9:	75 0c                	jne    6e7 <printf+0x50>
        state = '%';
 6db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6e2:	e9 4b 01 00 00       	jmp    832 <printf+0x19b>
      } else {
        putc(fd, c);
 6e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ea:	0f be c0             	movsbl %al,%eax
 6ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	89 04 24             	mov    %eax,(%esp)
 6f7:	e8 c4 fe ff ff       	call   5c0 <putc>
 6fc:	e9 31 01 00 00       	jmp    832 <printf+0x19b>
      }
    } else if(state == '%'){
 701:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 705:	0f 85 27 01 00 00    	jne    832 <printf+0x19b>
      if(c == 'd'){
 70b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 70f:	75 2d                	jne    73e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 711:	8b 45 e8             	mov    -0x18(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 71d:	00 
 71e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 725:	00 
 726:	89 44 24 04          	mov    %eax,0x4(%esp)
 72a:	8b 45 08             	mov    0x8(%ebp),%eax
 72d:	89 04 24             	mov    %eax,(%esp)
 730:	e8 b3 fe ff ff       	call   5e8 <printint>
        ap++;
 735:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 739:	e9 ed 00 00 00       	jmp    82b <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 73e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 742:	74 06                	je     74a <printf+0xb3>
 744:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 748:	75 2d                	jne    777 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 74a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 756:	00 
 757:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 75e:	00 
 75f:	89 44 24 04          	mov    %eax,0x4(%esp)
 763:	8b 45 08             	mov    0x8(%ebp),%eax
 766:	89 04 24             	mov    %eax,(%esp)
 769:	e8 7a fe ff ff       	call   5e8 <printint>
        ap++;
 76e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 772:	e9 b4 00 00 00       	jmp    82b <printf+0x194>
      } else if(c == 's'){
 777:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 77b:	75 46                	jne    7c3 <printf+0x12c>
        s = (char*)*ap;
 77d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 780:	8b 00                	mov    (%eax),%eax
 782:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 785:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 789:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 78d:	75 27                	jne    7b6 <printf+0x11f>
          s = "(null)";
 78f:	c7 45 f4 c0 0a 00 00 	movl   $0xac0,-0xc(%ebp)
        while(*s != 0){
 796:	eb 1e                	jmp    7b6 <printf+0x11f>
          putc(fd, *s);
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	0f b6 00             	movzbl (%eax),%eax
 79e:	0f be c0             	movsbl %al,%eax
 7a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 10 fe ff ff       	call   5c0 <putc>
          s++;
 7b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 7b4:	eb 01                	jmp    7b7 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7b6:	90                   	nop
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	0f b6 00             	movzbl (%eax),%eax
 7bd:	84 c0                	test   %al,%al
 7bf:	75 d7                	jne    798 <printf+0x101>
 7c1:	eb 68                	jmp    82b <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7c7:	75 1d                	jne    7e6 <printf+0x14f>
        putc(fd, *ap);
 7c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d5:	8b 45 08             	mov    0x8(%ebp),%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 e0 fd ff ff       	call   5c0 <putc>
        ap++;
 7e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e4:	eb 45                	jmp    82b <printf+0x194>
      } else if(c == '%'){
 7e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ea:	75 17                	jne    803 <printf+0x16c>
        putc(fd, c);
 7ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ef:	0f be c0             	movsbl %al,%eax
 7f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 7f6:	8b 45 08             	mov    0x8(%ebp),%eax
 7f9:	89 04 24             	mov    %eax,(%esp)
 7fc:	e8 bf fd ff ff       	call   5c0 <putc>
 801:	eb 28                	jmp    82b <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 803:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 80a:	00 
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	89 04 24             	mov    %eax,(%esp)
 811:	e8 aa fd ff ff       	call   5c0 <putc>
        putc(fd, c);
 816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 819:	0f be c0             	movsbl %al,%eax
 81c:	89 44 24 04          	mov    %eax,0x4(%esp)
 820:	8b 45 08             	mov    0x8(%ebp),%eax
 823:	89 04 24             	mov    %eax,(%esp)
 826:	e8 95 fd ff ff       	call   5c0 <putc>
      }
      state = 0;
 82b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 832:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 836:	8b 55 0c             	mov    0xc(%ebp),%edx
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	01 d0                	add    %edx,%eax
 83e:	0f b6 00             	movzbl (%eax),%eax
 841:	84 c0                	test   %al,%al
 843:	0f 85 70 fe ff ff    	jne    6b9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 849:	c9                   	leave  
 84a:	c3                   	ret    
 84b:	90                   	nop

0000084c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84c:	55                   	push   %ebp
 84d:	89 e5                	mov    %esp,%ebp
 84f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	83 e8 08             	sub    $0x8,%eax
 858:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85b:	a1 24 0d 00 00       	mov    0xd24,%eax
 860:	89 45 fc             	mov    %eax,-0x4(%ebp)
 863:	eb 24                	jmp    889 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86d:	77 12                	ja     881 <free+0x35>
 86f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 872:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 875:	77 24                	ja     89b <free+0x4f>
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87f:	77 1a                	ja     89b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	89 45 fc             	mov    %eax,-0x4(%ebp)
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88f:	76 d4                	jbe    865 <free+0x19>
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 899:	76 ca                	jbe    865 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 89b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	c1 e0 03             	shl    $0x3,%eax
 8a4:	89 c2                	mov    %eax,%edx
 8a6:	03 55 f8             	add    -0x8(%ebp),%edx
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	39 c2                	cmp    %eax,%edx
 8b0:	75 24                	jne    8d6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 8b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b5:	8b 50 04             	mov    0x4(%eax),%edx
 8b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	8b 40 04             	mov    0x4(%eax),%eax
 8c0:	01 c2                	add    %eax,%edx
 8c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cb:	8b 00                	mov    (%eax),%eax
 8cd:	8b 10                	mov    (%eax),%edx
 8cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d2:	89 10                	mov    %edx,(%eax)
 8d4:	eb 0a                	jmp    8e0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 10                	mov    (%eax),%edx
 8db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8de:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	c1 e0 03             	shl    $0x3,%eax
 8e9:	03 45 fc             	add    -0x4(%ebp),%eax
 8ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ef:	75 20                	jne    911 <free+0xc5>
    p->s.size += bp->s.size;
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f4:	8b 50 04             	mov    0x4(%eax),%edx
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	01 c2                	add    %eax,%edx
 8ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 902:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	8b 10                	mov    (%eax),%edx
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	89 10                	mov    %edx,(%eax)
 90f:	eb 08                	jmp    919 <free+0xcd>
  } else
    p->s.ptr = bp;
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	8b 55 f8             	mov    -0x8(%ebp),%edx
 917:	89 10                	mov    %edx,(%eax)
  freep = p;
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	a3 24 0d 00 00       	mov    %eax,0xd24
}
 921:	c9                   	leave  
 922:	c3                   	ret    

00000923 <morecore>:

static Header*
morecore(uint nu)
{
 923:	55                   	push   %ebp
 924:	89 e5                	mov    %esp,%ebp
 926:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 929:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 930:	77 07                	ja     939 <morecore+0x16>
    nu = 4096;
 932:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 939:	8b 45 08             	mov    0x8(%ebp),%eax
 93c:	c1 e0 03             	shl    $0x3,%eax
 93f:	89 04 24             	mov    %eax,(%esp)
 942:	e8 61 fc ff ff       	call   5a8 <sbrk>
 947:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 94a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 94e:	75 07                	jne    957 <morecore+0x34>
    return 0;
 950:	b8 00 00 00 00       	mov    $0x0,%eax
 955:	eb 22                	jmp    979 <morecore+0x56>
  hp = (Header*)p;
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 95d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 960:	8b 55 08             	mov    0x8(%ebp),%edx
 963:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 966:	8b 45 f0             	mov    -0x10(%ebp),%eax
 969:	83 c0 08             	add    $0x8,%eax
 96c:	89 04 24             	mov    %eax,(%esp)
 96f:	e8 d8 fe ff ff       	call   84c <free>
  return freep;
 974:	a1 24 0d 00 00       	mov    0xd24,%eax
}
 979:	c9                   	leave  
 97a:	c3                   	ret    

0000097b <malloc>:

void*
malloc(uint nbytes)
{
 97b:	55                   	push   %ebp
 97c:	89 e5                	mov    %esp,%ebp
 97e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 981:	8b 45 08             	mov    0x8(%ebp),%eax
 984:	83 c0 07             	add    $0x7,%eax
 987:	c1 e8 03             	shr    $0x3,%eax
 98a:	83 c0 01             	add    $0x1,%eax
 98d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 990:	a1 24 0d 00 00       	mov    0xd24,%eax
 995:	89 45 f0             	mov    %eax,-0x10(%ebp)
 998:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 99c:	75 23                	jne    9c1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 99e:	c7 45 f0 1c 0d 00 00 	movl   $0xd1c,-0x10(%ebp)
 9a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a8:	a3 24 0d 00 00       	mov    %eax,0xd24
 9ad:	a1 24 0d 00 00       	mov    0xd24,%eax
 9b2:	a3 1c 0d 00 00       	mov    %eax,0xd1c
    base.s.size = 0;
 9b7:	c7 05 20 0d 00 00 00 	movl   $0x0,0xd20
 9be:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c4:	8b 00                	mov    (%eax),%eax
 9c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cc:	8b 40 04             	mov    0x4(%eax),%eax
 9cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d2:	72 4d                	jb     a21 <malloc+0xa6>
      if(p->s.size == nunits)
 9d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d7:	8b 40 04             	mov    0x4(%eax),%eax
 9da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9dd:	75 0c                	jne    9eb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e2:	8b 10                	mov    (%eax),%edx
 9e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e7:	89 10                	mov    %edx,(%eax)
 9e9:	eb 26                	jmp    a11 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ee:	8b 40 04             	mov    0x4(%eax),%eax
 9f1:	89 c2                	mov    %eax,%edx
 9f3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 9f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	8b 40 04             	mov    0x4(%eax),%eax
 a02:	c1 e0 03             	shl    $0x3,%eax
 a05:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a0e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a14:	a3 24 0d 00 00       	mov    %eax,0xd24
      return (void*)(p + 1);
 a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1c:	83 c0 08             	add    $0x8,%eax
 a1f:	eb 38                	jmp    a59 <malloc+0xde>
    }
    if(p == freep)
 a21:	a1 24 0d 00 00       	mov    0xd24,%eax
 a26:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a29:	75 1b                	jne    a46 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a2e:	89 04 24             	mov    %eax,(%esp)
 a31:	e8 ed fe ff ff       	call   923 <morecore>
 a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3d:	75 07                	jne    a46 <malloc+0xcb>
        return 0;
 a3f:	b8 00 00 00 00       	mov    $0x0,%eax
 a44:	eb 13                	jmp    a59 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	8b 00                	mov    (%eax),%eax
 a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a54:	e9 70 ff ff ff       	jmp    9c9 <malloc+0x4e>
}
 a59:	c9                   	leave  
 a5a:	c3                   	ret    
