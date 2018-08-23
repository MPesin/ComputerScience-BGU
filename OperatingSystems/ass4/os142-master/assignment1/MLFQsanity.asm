
_MLFQsanity:     file format elf32-i386


Disassembly of section .text:

00000000 <waste_time_function>:
#include "user.h"

#define NUM_OF_CHILDRENS 20
#define NUM_OF_CHILD_LOOPS 500

int waste_time_function() {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
	int sum = 0;
   6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int i,j,k = 0;
   d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i =0 ; i < 1750 ; i++) {
  14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  1b:	eb 32                	jmp    4f <waste_time_function+0x4f>
		for (j = 0 ; j < i ; j++) {
  1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  24:	eb 1d                	jmp    43 <waste_time_function+0x43>
			for (k = 0 ; k < j ; k++) {
  26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  2d:	eb 08                	jmp    37 <waste_time_function+0x37>
				sum += 1;
  2f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
int waste_time_function() {
	int sum = 0;
	int i,j,k = 0;
	for (i =0 ; i < 1750 ; i++) {
		for (j = 0 ; j < i ; j++) {
			for (k = 0 ; k < j ; k++) {
  33:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  3a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  3d:	7c f0                	jl     2f <waste_time_function+0x2f>

int waste_time_function() {
	int sum = 0;
	int i,j,k = 0;
	for (i =0 ; i < 1750 ; i++) {
		for (j = 0 ; j < i ; j++) {
  3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  49:	7c db                	jl     26 <waste_time_function+0x26>
#define NUM_OF_CHILD_LOOPS 500

int waste_time_function() {
	int sum = 0;
	int i,j,k = 0;
	for (i =0 ; i < 1750 ; i++) {
  4b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  4f:	81 7d f8 d5 06 00 00 	cmpl   $0x6d5,-0x8(%ebp)
  56:	7e c5                	jle    1d <waste_time_function+0x1d>
			for (k = 0 ; k < j ; k++) {
				sum += 1;
			}
		}
	}
	return sum;
  58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  5b:	c9                   	leave  
  5c:	c3                   	ret    

0000005d <main>:

int main(int argc, char *argv[])
{
  5d:	55                   	push   %ebp
  5e:	89 e5                	mov    %esp,%ebp
  60:	56                   	push   %esi
  61:	53                   	push   %ebx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	81 ec b0 01 00 00    	sub    $0x1b0,%esp
	int i,j,index,wTime,rTime,ioTime,cid,avg_wTime,avg_rTime,avg_turnAround,flag = 0;
  6b:	c7 84 24 90 01 00 00 	movl   $0x0,0x190(%esp)
  72:	00 00 00 00 
	int low_avg_wTime,low_avg_rTime,low_avg_turnAround,high_avg_wTime,high_avg_rTime,high_avg_turnAround;
	int fork_id = 1;
  76:	c7 84 24 74 01 00 00 	movl   $0x1,0x174(%esp)
  7d:	01 00 00 00 
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
  81:	c7 84 24 ac 01 00 00 	movl   $0x0,0x1ac(%esp)
  88:	00 00 00 00 
  8c:	eb 40                	jmp    ce <main+0x71>
		for (j=0 ; j < 4 ; j++)
  8e:	c7 84 24 a8 01 00 00 	movl   $0x0,0x1a8(%esp)
  95:	00 00 00 00 
  99:	eb 21                	jmp    bc <main+0x5f>
			c_array[i][j] = 0;
  9b:	8b 84 24 ac 01 00 00 	mov    0x1ac(%esp),%eax
  a2:	c1 e0 02             	shl    $0x2,%eax
  a5:	03 84 24 a8 01 00 00 	add    0x1a8(%esp),%eax
  ac:	c7 44 84 28 00 00 00 	movl   $0x0,0x28(%esp,%eax,4)
  b3:	00 
	int i,j,index,wTime,rTime,ioTime,cid,avg_wTime,avg_rTime,avg_turnAround,flag = 0;
	int low_avg_wTime,low_avg_rTime,low_avg_turnAround,high_avg_wTime,high_avg_rTime,high_avg_turnAround;
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
		for (j=0 ; j < 4 ; j++)
  b4:	83 84 24 a8 01 00 00 	addl   $0x1,0x1a8(%esp)
  bb:	01 
  bc:	83 bc 24 a8 01 00 00 	cmpl   $0x3,0x1a8(%esp)
  c3:	03 
  c4:	7e d5                	jle    9b <main+0x3e>
{
	int i,j,index,wTime,rTime,ioTime,cid,avg_wTime,avg_rTime,avg_turnAround,flag = 0;
	int low_avg_wTime,low_avg_rTime,low_avg_turnAround,high_avg_wTime,high_avg_rTime,high_avg_turnAround;
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
  c6:	83 84 24 ac 01 00 00 	addl   $0x1,0x1ac(%esp)
  cd:	01 
  ce:	83 bc 24 ac 01 00 00 	cmpl   $0x13,0x1ac(%esp)
  d5:	13 
  d6:	7e b6                	jle    8e <main+0x31>
		for (j=0 ; j < 4 ; j++)
			c_array[i][j] = 0;
	for (cid=0 ; cid < NUM_OF_CHILDRENS; cid++) {
  d8:	c7 84 24 a0 01 00 00 	movl   $0x0,0x1a0(%esp)
  df:	00 00 00 00 
  e3:	e9 ba 00 00 00       	jmp    1a2 <main+0x145>
		fork_id = fork();
  e8:	e8 bb 07 00 00       	call   8a8 <fork>
  ed:	89 84 24 74 01 00 00 	mov    %eax,0x174(%esp)
		if (fork_id == 0) {   // child section
  f4:	83 bc 24 74 01 00 00 	cmpl   $0x0,0x174(%esp)
  fb:	00 
  fc:	75 7a                	jne    178 <main+0x11b>
			if ( cid % 2 == 0) {
  fe:	8b 84 24 a0 01 00 00 	mov    0x1a0(%esp),%eax
 105:	83 e0 01             	and    $0x1,%eax
 108:	85 c0                	test   %eax,%eax
 10a:	75 07                	jne    113 <main+0xb6>
				waste_time_function();
 10c:	e8 ef fe ff ff       	call   0 <waste_time_function>
 111:	eb 1f                	jmp    132 <main+0xd5>
			} else
				printf(2,"cid <%d> is Activating I/O System Call\n",cid);
 113:	8b 84 24 a0 01 00 00 	mov    0x1a0(%esp),%eax
 11a:	89 44 24 08          	mov    %eax,0x8(%esp)
 11e:	c7 44 24 04 fc 0d 00 	movl   $0xdfc,0x4(%esp)
 125:	00 
 126:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 12d:	e8 05 09 00 00       	call   a37 <printf>
			for (i = 0 ; i < NUM_OF_CHILD_LOOPS ; i++) {
 132:	c7 84 24 ac 01 00 00 	movl   $0x0,0x1ac(%esp)
 139:	00 00 00 00 
 13d:	eb 27                	jmp    166 <main+0x109>
				printf(2,"cid <%d>\n",cid);
 13f:	8b 84 24 a0 01 00 00 	mov    0x1a0(%esp),%eax
 146:	89 44 24 08          	mov    %eax,0x8(%esp)
 14a:	c7 44 24 04 24 0e 00 	movl   $0xe24,0x4(%esp)
 151:	00 
 152:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 159:	e8 d9 08 00 00       	call   a37 <printf>
		if (fork_id == 0) {   // child section
			if ( cid % 2 == 0) {
				waste_time_function();
			} else
				printf(2,"cid <%d> is Activating I/O System Call\n",cid);
			for (i = 0 ; i < NUM_OF_CHILD_LOOPS ; i++) {
 15e:	83 84 24 ac 01 00 00 	addl   $0x1,0x1ac(%esp)
 165:	01 
 166:	81 bc 24 ac 01 00 00 	cmpl   $0x1f3,0x1ac(%esp)
 16d:	f3 01 00 00 
 171:	7e cc                	jle    13f <main+0xe2>
				printf(2,"cid <%d>\n",cid);
			}
			exit();			// end of child section
 173:	e8 38 07 00 00       	call   8b0 <exit>
		} else 				// father section starts here
			c_array[cid][0] = fork_id;		// position in array is by CID
 178:	8b 84 24 a0 01 00 00 	mov    0x1a0(%esp),%eax
 17f:	c1 e0 04             	shl    $0x4,%eax
 182:	8d 94 24 b0 01 00 00 	lea    0x1b0(%esp),%edx
 189:	01 d0                	add    %edx,%eax
 18b:	8d 90 78 fe ff ff    	lea    -0x188(%eax),%edx
 191:	8b 84 24 74 01 00 00 	mov    0x174(%esp),%eax
 198:	89 02                	mov    %eax,(%edx)
	int fork_id = 1;
	int c_array[NUM_OF_CHILDRENS][4];
	for (i=0 ; i < NUM_OF_CHILDRENS ; i++)	// init array
		for (j=0 ; j < 4 ; j++)
			c_array[i][j] = 0;
	for (cid=0 ; cid < NUM_OF_CHILDRENS; cid++) {
 19a:	83 84 24 a0 01 00 00 	addl   $0x1,0x1a0(%esp)
 1a1:	01 
 1a2:	83 bc 24 a0 01 00 00 	cmpl   $0x13,0x1a0(%esp)
 1a9:	13 
 1aa:	0f 8e 38 ff ff ff    	jle    e8 <main+0x8b>
			exit();			// end of child section
		} else 				// father section starts here
			c_array[cid][0] = fork_id;		// position in array is by CID
	}

	while ((fork_id = wait2(&wTime,&rTime,&ioTime)) > 0) {	// update data for all the childrens
 1b0:	e9 e4 00 00 00       	jmp    299 <main+0x23c>
		flag = 0;
 1b5:	c7 84 24 90 01 00 00 	movl   $0x0,0x190(%esp)
 1bc:	00 00 00 00 
		for (index = 0 ; index < NUM_OF_CHILDRENS && !flag ; index++) {
 1c0:	c7 84 24 a4 01 00 00 	movl   $0x0,0x1a4(%esp)
 1c7:	00 00 00 00 
 1cb:	e9 b1 00 00 00       	jmp    281 <main+0x224>
			if (c_array[index][0] == fork_id) {
 1d0:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 1d7:	c1 e0 04             	shl    $0x4,%eax
 1da:	8d 8c 24 b0 01 00 00 	lea    0x1b0(%esp),%ecx
 1e1:	01 c8                	add    %ecx,%eax
 1e3:	2d 88 01 00 00       	sub    $0x188,%eax
 1e8:	8b 00                	mov    (%eax),%eax
 1ea:	3b 84 24 74 01 00 00 	cmp    0x174(%esp),%eax
 1f1:	0f 85 82 00 00 00    	jne    279 <main+0x21c>
				c_array[index][1] = wTime;	// waiting time
 1f7:	8b 84 24 70 01 00 00 	mov    0x170(%esp),%eax
 1fe:	8b 94 24 a4 01 00 00 	mov    0x1a4(%esp),%edx
 205:	c1 e2 04             	shl    $0x4,%edx
 208:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 20f:	01 f2                	add    %esi,%edx
 211:	81 ea 84 01 00 00    	sub    $0x184,%edx
 217:	89 02                	mov    %eax,(%edx)
				c_array[index][2] = rTime;	// run time
 219:	8b 84 24 6c 01 00 00 	mov    0x16c(%esp),%eax
 220:	8b 94 24 a4 01 00 00 	mov    0x1a4(%esp),%edx
 227:	c1 e2 04             	shl    $0x4,%edx
 22a:	8d 8c 24 b0 01 00 00 	lea    0x1b0(%esp),%ecx
 231:	01 ca                	add    %ecx,%edx
 233:	81 ea 80 01 00 00    	sub    $0x180,%edx
 239:	89 02                	mov    %eax,(%edx)
				c_array[index][3] = wTime+wTime+rTime; // turnaround time -> end time - creation time
 23b:	8b 94 24 70 01 00 00 	mov    0x170(%esp),%edx
 242:	8b 84 24 70 01 00 00 	mov    0x170(%esp),%eax
 249:	01 c2                	add    %eax,%edx
 24b:	8b 84 24 6c 01 00 00 	mov    0x16c(%esp),%eax
 252:	01 c2                	add    %eax,%edx
 254:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 25b:	c1 e0 04             	shl    $0x4,%eax
 25e:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 265:	01 f0                	add    %esi,%eax
 267:	2d 7c 01 00 00       	sub    $0x17c,%eax
 26c:	89 10                	mov    %edx,(%eax)
				flag = 1;
 26e:	c7 84 24 90 01 00 00 	movl   $0x1,0x190(%esp)
 275:	01 00 00 00 
			c_array[cid][0] = fork_id;		// position in array is by CID
	}

	while ((fork_id = wait2(&wTime,&rTime,&ioTime)) > 0) {	// update data for all the childrens
		flag = 0;
		for (index = 0 ; index < NUM_OF_CHILDRENS && !flag ; index++) {
 279:	83 84 24 a4 01 00 00 	addl   $0x1,0x1a4(%esp)
 280:	01 
 281:	83 bc 24 a4 01 00 00 	cmpl   $0x13,0x1a4(%esp)
 288:	13 
 289:	7f 0e                	jg     299 <main+0x23c>
 28b:	83 bc 24 90 01 00 00 	cmpl   $0x0,0x190(%esp)
 292:	00 
 293:	0f 84 37 ff ff ff    	je     1d0 <main+0x173>
			exit();			// end of child section
		} else 				// father section starts here
			c_array[cid][0] = fork_id;		// position in array is by CID
	}

	while ((fork_id = wait2(&wTime,&rTime,&ioTime)) > 0) {	// update data for all the childrens
 299:	8d 84 24 68 01 00 00 	lea    0x168(%esp),%eax
 2a0:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a4:	8d 84 24 6c 01 00 00 	lea    0x16c(%esp),%eax
 2ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 2af:	8d 84 24 70 01 00 00 	lea    0x170(%esp),%eax
 2b6:	89 04 24             	mov    %eax,(%esp)
 2b9:	e8 02 06 00 00       	call   8c0 <wait2>
 2be:	89 84 24 74 01 00 00 	mov    %eax,0x174(%esp)
 2c5:	83 bc 24 74 01 00 00 	cmpl   $0x0,0x174(%esp)
 2cc:	00 
 2cd:	0f 8f e2 fe ff ff    	jg     1b5 <main+0x158>
				flag = 1;
			}
		}
	}

	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++) {
 2d3:	c7 84 24 a4 01 00 00 	movl   $0x0,0x1a4(%esp)
 2da:	00 00 00 00 
 2de:	e9 41 01 00 00       	jmp    424 <main+0x3c7>
		avg_wTime += c_array[index][1];
 2e3:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 2ea:	c1 e0 04             	shl    $0x4,%eax
 2ed:	8d 94 24 b0 01 00 00 	lea    0x1b0(%esp),%edx
 2f4:	01 d0                	add    %edx,%eax
 2f6:	2d 84 01 00 00       	sub    $0x184,%eax
 2fb:	8b 00                	mov    (%eax),%eax
 2fd:	01 84 24 9c 01 00 00 	add    %eax,0x19c(%esp)
		avg_rTime += c_array[index][2];
 304:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 30b:	c1 e0 04             	shl    $0x4,%eax
 30e:	8d 8c 24 b0 01 00 00 	lea    0x1b0(%esp),%ecx
 315:	01 c8                	add    %ecx,%eax
 317:	2d 80 01 00 00       	sub    $0x180,%eax
 31c:	8b 00                	mov    (%eax),%eax
 31e:	01 84 24 98 01 00 00 	add    %eax,0x198(%esp)
		avg_turnAround += c_array[index][3];
 325:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 32c:	c1 e0 04             	shl    $0x4,%eax
 32f:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 336:	01 f0                	add    %esi,%eax
 338:	2d 7c 01 00 00       	sub    $0x17c,%eax
 33d:	8b 00                	mov    (%eax),%eax
 33f:	01 84 24 94 01 00 00 	add    %eax,0x194(%esp)
		if (index % 2 == 0) {
 346:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 34d:	83 e0 01             	and    $0x1,%eax
 350:	85 c0                	test   %eax,%eax
 352:	75 65                	jne    3b9 <main+0x35c>
			low_avg_wTime += c_array[index][1];
 354:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 35b:	c1 e0 04             	shl    $0x4,%eax
 35e:	8d 94 24 b0 01 00 00 	lea    0x1b0(%esp),%edx
 365:	01 d0                	add    %edx,%eax
 367:	2d 84 01 00 00       	sub    $0x184,%eax
 36c:	8b 00                	mov    (%eax),%eax
 36e:	01 84 24 8c 01 00 00 	add    %eax,0x18c(%esp)
			low_avg_rTime += c_array[index][2];
 375:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 37c:	c1 e0 04             	shl    $0x4,%eax
 37f:	8d 8c 24 b0 01 00 00 	lea    0x1b0(%esp),%ecx
 386:	01 c8                	add    %ecx,%eax
 388:	2d 80 01 00 00       	sub    $0x180,%eax
 38d:	8b 00                	mov    (%eax),%eax
 38f:	01 84 24 88 01 00 00 	add    %eax,0x188(%esp)
			low_avg_turnAround += c_array[index][3];
 396:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 39d:	c1 e0 04             	shl    $0x4,%eax
 3a0:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 3a7:	01 f0                	add    %esi,%eax
 3a9:	2d 7c 01 00 00       	sub    $0x17c,%eax
 3ae:	8b 00                	mov    (%eax),%eax
 3b0:	01 84 24 84 01 00 00 	add    %eax,0x184(%esp)
 3b7:	eb 63                	jmp    41c <main+0x3bf>
		} else {
			high_avg_wTime += c_array[index][1];
 3b9:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 3c0:	c1 e0 04             	shl    $0x4,%eax
 3c3:	8d 94 24 b0 01 00 00 	lea    0x1b0(%esp),%edx
 3ca:	01 d0                	add    %edx,%eax
 3cc:	2d 84 01 00 00       	sub    $0x184,%eax
 3d1:	8b 00                	mov    (%eax),%eax
 3d3:	01 84 24 80 01 00 00 	add    %eax,0x180(%esp)
			high_avg_rTime += c_array[index][2];
 3da:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 3e1:	c1 e0 04             	shl    $0x4,%eax
 3e4:	8d 8c 24 b0 01 00 00 	lea    0x1b0(%esp),%ecx
 3eb:	01 c8                	add    %ecx,%eax
 3ed:	2d 80 01 00 00       	sub    $0x180,%eax
 3f2:	8b 00                	mov    (%eax),%eax
 3f4:	01 84 24 7c 01 00 00 	add    %eax,0x17c(%esp)
			high_avg_turnAround += c_array[index][3];
 3fb:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 402:	c1 e0 04             	shl    $0x4,%eax
 405:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 40c:	01 f0                	add    %esi,%eax
 40e:	2d 7c 01 00 00       	sub    $0x17c,%eax
 413:	8b 00                	mov    (%eax),%eax
 415:	01 84 24 78 01 00 00 	add    %eax,0x178(%esp)
				flag = 1;
			}
		}
	}

	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++) {
 41c:	83 84 24 a4 01 00 00 	addl   $0x1,0x1a4(%esp)
 423:	01 
 424:	83 bc 24 a4 01 00 00 	cmpl   $0x13,0x1a4(%esp)
 42b:	13 
 42c:	0f 8e b1 fe ff ff    	jle    2e3 <main+0x286>
			high_avg_rTime += c_array[index][2];
			high_avg_turnAround += c_array[index][3];
		}
	}

	printf(2,"Average waiting time <%d> , Average run time <%d> , Average turnaround time <%d>\n",avg_wTime/NUM_OF_CHILDRENS,avg_rTime/NUM_OF_CHILDRENS,avg_turnAround/NUM_OF_CHILDRENS);
 432:	8b 8c 24 94 01 00 00 	mov    0x194(%esp),%ecx
 439:	ba 67 66 66 66       	mov    $0x66666667,%edx
 43e:	89 c8                	mov    %ecx,%eax
 440:	f7 ea                	imul   %edx
 442:	c1 fa 03             	sar    $0x3,%edx
 445:	89 c8                	mov    %ecx,%eax
 447:	c1 f8 1f             	sar    $0x1f,%eax
 44a:	89 d6                	mov    %edx,%esi
 44c:	29 c6                	sub    %eax,%esi
 44e:	8b 8c 24 98 01 00 00 	mov    0x198(%esp),%ecx
 455:	ba 67 66 66 66       	mov    $0x66666667,%edx
 45a:	89 c8                	mov    %ecx,%eax
 45c:	f7 ea                	imul   %edx
 45e:	c1 fa 03             	sar    $0x3,%edx
 461:	89 c8                	mov    %ecx,%eax
 463:	c1 f8 1f             	sar    $0x1f,%eax
 466:	89 d3                	mov    %edx,%ebx
 468:	29 c3                	sub    %eax,%ebx
 46a:	8b 8c 24 9c 01 00 00 	mov    0x19c(%esp),%ecx
 471:	ba 67 66 66 66       	mov    $0x66666667,%edx
 476:	89 c8                	mov    %ecx,%eax
 478:	f7 ea                	imul   %edx
 47a:	c1 fa 03             	sar    $0x3,%edx
 47d:	89 c8                	mov    %ecx,%eax
 47f:	c1 f8 1f             	sar    $0x1f,%eax
 482:	89 d1                	mov    %edx,%ecx
 484:	29 c1                	sub    %eax,%ecx
 486:	89 c8                	mov    %ecx,%eax
 488:	89 74 24 10          	mov    %esi,0x10(%esp)
 48c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 490:	89 44 24 08          	mov    %eax,0x8(%esp)
 494:	c7 44 24 04 30 0e 00 	movl   $0xe30,0x4(%esp)
 49b:	00 
 49c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 4a3:	e8 8f 05 00 00       	call   a37 <printf>
	printf(2,"Average Low Priority Queue: waiting time <%d> , run time <%d> , turnaround time <%d>\n",low_avg_wTime/(NUM_OF_CHILDRENS/2),low_avg_rTime/(NUM_OF_CHILDRENS/2),low_avg_turnAround/(NUM_OF_CHILDRENS/2));
 4a8:	8b 8c 24 84 01 00 00 	mov    0x184(%esp),%ecx
 4af:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4b4:	89 c8                	mov    %ecx,%eax
 4b6:	f7 ea                	imul   %edx
 4b8:	c1 fa 02             	sar    $0x2,%edx
 4bb:	89 c8                	mov    %ecx,%eax
 4bd:	c1 f8 1f             	sar    $0x1f,%eax
 4c0:	89 d6                	mov    %edx,%esi
 4c2:	29 c6                	sub    %eax,%esi
 4c4:	8b 8c 24 88 01 00 00 	mov    0x188(%esp),%ecx
 4cb:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4d0:	89 c8                	mov    %ecx,%eax
 4d2:	f7 ea                	imul   %edx
 4d4:	c1 fa 02             	sar    $0x2,%edx
 4d7:	89 c8                	mov    %ecx,%eax
 4d9:	c1 f8 1f             	sar    $0x1f,%eax
 4dc:	89 d3                	mov    %edx,%ebx
 4de:	29 c3                	sub    %eax,%ebx
 4e0:	8b 8c 24 8c 01 00 00 	mov    0x18c(%esp),%ecx
 4e7:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4ec:	89 c8                	mov    %ecx,%eax
 4ee:	f7 ea                	imul   %edx
 4f0:	c1 fa 02             	sar    $0x2,%edx
 4f3:	89 c8                	mov    %ecx,%eax
 4f5:	c1 f8 1f             	sar    $0x1f,%eax
 4f8:	89 d1                	mov    %edx,%ecx
 4fa:	29 c1                	sub    %eax,%ecx
 4fc:	89 c8                	mov    %ecx,%eax
 4fe:	89 74 24 10          	mov    %esi,0x10(%esp)
 502:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 506:	89 44 24 08          	mov    %eax,0x8(%esp)
 50a:	c7 44 24 04 84 0e 00 	movl   $0xe84,0x4(%esp)
 511:	00 
 512:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 519:	e8 19 05 00 00       	call   a37 <printf>
	printf(2,"Average High Priority Queue: waiting time <%d> , run time <%d> , turnaround time <%d>\n",high_avg_wTime/(NUM_OF_CHILDRENS/2),high_avg_rTime/(NUM_OF_CHILDRENS/2),high_avg_turnAround/(NUM_OF_CHILDRENS/2));
 51e:	8b 8c 24 78 01 00 00 	mov    0x178(%esp),%ecx
 525:	ba 67 66 66 66       	mov    $0x66666667,%edx
 52a:	89 c8                	mov    %ecx,%eax
 52c:	f7 ea                	imul   %edx
 52e:	c1 fa 02             	sar    $0x2,%edx
 531:	89 c8                	mov    %ecx,%eax
 533:	c1 f8 1f             	sar    $0x1f,%eax
 536:	89 d6                	mov    %edx,%esi
 538:	29 c6                	sub    %eax,%esi
 53a:	8b 8c 24 7c 01 00 00 	mov    0x17c(%esp),%ecx
 541:	ba 67 66 66 66       	mov    $0x66666667,%edx
 546:	89 c8                	mov    %ecx,%eax
 548:	f7 ea                	imul   %edx
 54a:	c1 fa 02             	sar    $0x2,%edx
 54d:	89 c8                	mov    %ecx,%eax
 54f:	c1 f8 1f             	sar    $0x1f,%eax
 552:	89 d3                	mov    %edx,%ebx
 554:	29 c3                	sub    %eax,%ebx
 556:	8b 8c 24 80 01 00 00 	mov    0x180(%esp),%ecx
 55d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 562:	89 c8                	mov    %ecx,%eax
 564:	f7 ea                	imul   %edx
 566:	c1 fa 02             	sar    $0x2,%edx
 569:	89 c8                	mov    %ecx,%eax
 56b:	c1 f8 1f             	sar    $0x1f,%eax
 56e:	89 d1                	mov    %edx,%ecx
 570:	29 c1                	sub    %eax,%ecx
 572:	89 c8                	mov    %ecx,%eax
 574:	89 74 24 10          	mov    %esi,0x10(%esp)
 578:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 57c:	89 44 24 08          	mov    %eax,0x8(%esp)
 580:	c7 44 24 04 dc 0e 00 	movl   $0xedc,0x4(%esp)
 587:	00 
 588:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 58f:	e8 a3 04 00 00       	call   a37 <printf>
	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++)
 594:	c7 84 24 a4 01 00 00 	movl   $0x0,0x1a4(%esp)
 59b:	00 00 00 00 
 59f:	e9 94 00 00 00       	jmp    638 <main+0x5db>
		printf(2,"Child <%d>: Waiting time %d , Running time %d , Turnaround time %d\n",c_array[index][0],c_array[index][1],c_array[index][2],c_array[index][3]);
 5a4:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 5ab:	c1 e0 04             	shl    $0x4,%eax
 5ae:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 5b5:	01 f0                	add    %esi,%eax
 5b7:	2d 7c 01 00 00       	sub    $0x17c,%eax
 5bc:	8b 18                	mov    (%eax),%ebx
 5be:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 5c5:	c1 e0 04             	shl    $0x4,%eax
 5c8:	8d 94 24 b0 01 00 00 	lea    0x1b0(%esp),%edx
 5cf:	01 d0                	add    %edx,%eax
 5d1:	2d 80 01 00 00       	sub    $0x180,%eax
 5d6:	8b 08                	mov    (%eax),%ecx
 5d8:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 5df:	c1 e0 04             	shl    $0x4,%eax
 5e2:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 5e9:	01 f0                	add    %esi,%eax
 5eb:	2d 84 01 00 00       	sub    $0x184,%eax
 5f0:	8b 10                	mov    (%eax),%edx
 5f2:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
 5f9:	c1 e0 04             	shl    $0x4,%eax
 5fc:	8d b4 24 b0 01 00 00 	lea    0x1b0(%esp),%esi
 603:	01 f0                	add    %esi,%eax
 605:	2d 88 01 00 00       	sub    $0x188,%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 610:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 614:	89 54 24 0c          	mov    %edx,0xc(%esp)
 618:	89 44 24 08          	mov    %eax,0x8(%esp)
 61c:	c7 44 24 04 34 0f 00 	movl   $0xf34,0x4(%esp)
 623:	00 
 624:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 62b:	e8 07 04 00 00       	call   a37 <printf>
	}

	printf(2,"Average waiting time <%d> , Average run time <%d> , Average turnaround time <%d>\n",avg_wTime/NUM_OF_CHILDRENS,avg_rTime/NUM_OF_CHILDRENS,avg_turnAround/NUM_OF_CHILDRENS);
	printf(2,"Average Low Priority Queue: waiting time <%d> , run time <%d> , turnaround time <%d>\n",low_avg_wTime/(NUM_OF_CHILDRENS/2),low_avg_rTime/(NUM_OF_CHILDRENS/2),low_avg_turnAround/(NUM_OF_CHILDRENS/2));
	printf(2,"Average High Priority Queue: waiting time <%d> , run time <%d> , turnaround time <%d>\n",high_avg_wTime/(NUM_OF_CHILDRENS/2),high_avg_rTime/(NUM_OF_CHILDRENS/2),high_avg_turnAround/(NUM_OF_CHILDRENS/2));
	for (index = 0 ; index < NUM_OF_CHILDRENS ; index++)
 630:	83 84 24 a4 01 00 00 	addl   $0x1,0x1a4(%esp)
 637:	01 
 638:	83 bc 24 a4 01 00 00 	cmpl   $0x13,0x1a4(%esp)
 63f:	13 
 640:	0f 8e 5e ff ff ff    	jle    5a4 <main+0x547>
		printf(2,"Child <%d>: Waiting time %d , Running time %d , Turnaround time %d\n",c_array[index][0],c_array[index][1],c_array[index][2],c_array[index][3]);
	exit();
 646:	e8 65 02 00 00       	call   8b0 <exit>
 64b:	90                   	nop

0000064c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 64c:	55                   	push   %ebp
 64d:	89 e5                	mov    %esp,%ebp
 64f:	57                   	push   %edi
 650:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 651:	8b 4d 08             	mov    0x8(%ebp),%ecx
 654:	8b 55 10             	mov    0x10(%ebp),%edx
 657:	8b 45 0c             	mov    0xc(%ebp),%eax
 65a:	89 cb                	mov    %ecx,%ebx
 65c:	89 df                	mov    %ebx,%edi
 65e:	89 d1                	mov    %edx,%ecx
 660:	fc                   	cld    
 661:	f3 aa                	rep stos %al,%es:(%edi)
 663:	89 ca                	mov    %ecx,%edx
 665:	89 fb                	mov    %edi,%ebx
 667:	89 5d 08             	mov    %ebx,0x8(%ebp)
 66a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 66d:	5b                   	pop    %ebx
 66e:	5f                   	pop    %edi
 66f:	5d                   	pop    %ebp
 670:	c3                   	ret    

00000671 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 671:	55                   	push   %ebp
 672:	89 e5                	mov    %esp,%ebp
 674:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 67d:	90                   	nop
 67e:	8b 45 0c             	mov    0xc(%ebp),%eax
 681:	0f b6 10             	movzbl (%eax),%edx
 684:	8b 45 08             	mov    0x8(%ebp),%eax
 687:	88 10                	mov    %dl,(%eax)
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	0f b6 00             	movzbl (%eax),%eax
 68f:	84 c0                	test   %al,%al
 691:	0f 95 c0             	setne  %al
 694:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 698:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 69c:	84 c0                	test   %al,%al
 69e:	75 de                	jne    67e <strcpy+0xd>
    ;
  return os;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6a3:	c9                   	leave  
 6a4:	c3                   	ret    

000006a5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6a5:	55                   	push   %ebp
 6a6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 6a8:	eb 08                	jmp    6b2 <strcmp+0xd>
    p++, q++;
 6aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 6ae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	0f b6 00             	movzbl (%eax),%eax
 6b8:	84 c0                	test   %al,%al
 6ba:	74 10                	je     6cc <strcmp+0x27>
 6bc:	8b 45 08             	mov    0x8(%ebp),%eax
 6bf:	0f b6 10             	movzbl (%eax),%edx
 6c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c5:	0f b6 00             	movzbl (%eax),%eax
 6c8:	38 c2                	cmp    %al,%dl
 6ca:	74 de                	je     6aa <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6cc:	8b 45 08             	mov    0x8(%ebp),%eax
 6cf:	0f b6 00             	movzbl (%eax),%eax
 6d2:	0f b6 d0             	movzbl %al,%edx
 6d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d8:	0f b6 00             	movzbl (%eax),%eax
 6db:	0f b6 c0             	movzbl %al,%eax
 6de:	89 d1                	mov    %edx,%ecx
 6e0:	29 c1                	sub    %eax,%ecx
 6e2:	89 c8                	mov    %ecx,%eax
}
 6e4:	5d                   	pop    %ebp
 6e5:	c3                   	ret    

000006e6 <strlen>:

uint
strlen(char *s)
{
 6e6:	55                   	push   %ebp
 6e7:	89 e5                	mov    %esp,%ebp
 6e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6f3:	eb 04                	jmp    6f9 <strlen+0x13>
 6f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	03 45 08             	add    0x8(%ebp),%eax
 6ff:	0f b6 00             	movzbl (%eax),%eax
 702:	84 c0                	test   %al,%al
 704:	75 ef                	jne    6f5 <strlen+0xf>
    ;
  return n;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 709:	c9                   	leave  
 70a:	c3                   	ret    

0000070b <memset>:

void*
memset(void *dst, int c, uint n)
{
 70b:	55                   	push   %ebp
 70c:	89 e5                	mov    %esp,%ebp
 70e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 711:	8b 45 10             	mov    0x10(%ebp),%eax
 714:	89 44 24 08          	mov    %eax,0x8(%esp)
 718:	8b 45 0c             	mov    0xc(%ebp),%eax
 71b:	89 44 24 04          	mov    %eax,0x4(%esp)
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	89 04 24             	mov    %eax,(%esp)
 725:	e8 22 ff ff ff       	call   64c <stosb>
  return dst;
 72a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <strchr>:

char*
strchr(const char *s, char c)
{
 72f:	55                   	push   %ebp
 730:	89 e5                	mov    %esp,%ebp
 732:	83 ec 04             	sub    $0x4,%esp
 735:	8b 45 0c             	mov    0xc(%ebp),%eax
 738:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 73b:	eb 14                	jmp    751 <strchr+0x22>
    if(*s == c)
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	0f b6 00             	movzbl (%eax),%eax
 743:	3a 45 fc             	cmp    -0x4(%ebp),%al
 746:	75 05                	jne    74d <strchr+0x1e>
      return (char*)s;
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	eb 13                	jmp    760 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 74d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	0f b6 00             	movzbl (%eax),%eax
 757:	84 c0                	test   %al,%al
 759:	75 e2                	jne    73d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 75b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 760:	c9                   	leave  
 761:	c3                   	ret    

00000762 <gets>:

char*
gets(char *buf, int max)
{
 762:	55                   	push   %ebp
 763:	89 e5                	mov    %esp,%ebp
 765:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 768:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 76f:	eb 44                	jmp    7b5 <gets+0x53>
    cc = read(0, &c, 1);
 771:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 778:	00 
 779:	8d 45 ef             	lea    -0x11(%ebp),%eax
 77c:	89 44 24 04          	mov    %eax,0x4(%esp)
 780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 787:	e8 4c 01 00 00       	call   8d8 <read>
 78c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 78f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 793:	7e 2d                	jle    7c2 <gets+0x60>
      break;
    buf[i++] = c;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	03 45 08             	add    0x8(%ebp),%eax
 79b:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 79f:	88 10                	mov    %dl,(%eax)
 7a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 7a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 7a9:	3c 0a                	cmp    $0xa,%al
 7ab:	74 16                	je     7c3 <gets+0x61>
 7ad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 7b1:	3c 0d                	cmp    $0xd,%al
 7b3:	74 0e                	je     7c3 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	83 c0 01             	add    $0x1,%eax
 7bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7be:	7c b1                	jl     771 <gets+0xf>
 7c0:	eb 01                	jmp    7c3 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 7c2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	03 45 08             	add    0x8(%ebp),%eax
 7c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7cf:	c9                   	leave  
 7d0:	c3                   	ret    

000007d1 <stat>:

int
stat(char *n, struct stat *st)
{
 7d1:	55                   	push   %ebp
 7d2:	89 e5                	mov    %esp,%ebp
 7d4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 7de:	00 
 7df:	8b 45 08             	mov    0x8(%ebp),%eax
 7e2:	89 04 24             	mov    %eax,(%esp)
 7e5:	e8 16 01 00 00       	call   900 <open>
 7ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f1:	79 07                	jns    7fa <stat+0x29>
    return -1;
 7f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7f8:	eb 23                	jmp    81d <stat+0x4c>
  r = fstat(fd, st);
 7fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 7fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	89 04 24             	mov    %eax,(%esp)
 807:	e8 0c 01 00 00       	call   918 <fstat>
 80c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	89 04 24             	mov    %eax,(%esp)
 815:	e8 ce 00 00 00       	call   8e8 <close>
  return r;
 81a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <atoi>:

int
atoi(const char *s)
{
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 825:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 82c:	eb 23                	jmp    851 <atoi+0x32>
    n = n*10 + *s++ - '0';
 82e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 831:	89 d0                	mov    %edx,%eax
 833:	c1 e0 02             	shl    $0x2,%eax
 836:	01 d0                	add    %edx,%eax
 838:	01 c0                	add    %eax,%eax
 83a:	89 c2                	mov    %eax,%edx
 83c:	8b 45 08             	mov    0x8(%ebp),%eax
 83f:	0f b6 00             	movzbl (%eax),%eax
 842:	0f be c0             	movsbl %al,%eax
 845:	01 d0                	add    %edx,%eax
 847:	83 e8 30             	sub    $0x30,%eax
 84a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 851:	8b 45 08             	mov    0x8(%ebp),%eax
 854:	0f b6 00             	movzbl (%eax),%eax
 857:	3c 2f                	cmp    $0x2f,%al
 859:	7e 0a                	jle    865 <atoi+0x46>
 85b:	8b 45 08             	mov    0x8(%ebp),%eax
 85e:	0f b6 00             	movzbl (%eax),%eax
 861:	3c 39                	cmp    $0x39,%al
 863:	7e c9                	jle    82e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 868:	c9                   	leave  
 869:	c3                   	ret    

0000086a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 86a:	55                   	push   %ebp
 86b:	89 e5                	mov    %esp,%ebp
 86d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 876:	8b 45 0c             	mov    0xc(%ebp),%eax
 879:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 87c:	eb 13                	jmp    891 <memmove+0x27>
    *dst++ = *src++;
 87e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 881:	0f b6 10             	movzbl (%eax),%edx
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	88 10                	mov    %dl,(%eax)
 889:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 88d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 891:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 895:	0f 9f c0             	setg   %al
 898:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 89c:	84 c0                	test   %al,%al
 89e:	75 de                	jne    87e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    
 8a5:	90                   	nop
 8a6:	90                   	nop
 8a7:	90                   	nop

000008a8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8a8:	b8 01 00 00 00       	mov    $0x1,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <exit>:
SYSCALL(exit)
 8b0:	b8 02 00 00 00       	mov    $0x2,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <wait>:
SYSCALL(wait)
 8b8:	b8 03 00 00 00       	mov    $0x3,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <wait2>:
SYSCALL(wait2)
 8c0:	b8 16 00 00 00       	mov    $0x16,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <add_path>:
SYSCALL(add_path)
 8c8:	b8 17 00 00 00       	mov    $0x17,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <pipe>:
SYSCALL(pipe)
 8d0:	b8 04 00 00 00       	mov    $0x4,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <read>:
SYSCALL(read)
 8d8:	b8 05 00 00 00       	mov    $0x5,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <write>:
SYSCALL(write)
 8e0:	b8 10 00 00 00       	mov    $0x10,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <close>:
SYSCALL(close)
 8e8:	b8 15 00 00 00       	mov    $0x15,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <kill>:
SYSCALL(kill)
 8f0:	b8 06 00 00 00       	mov    $0x6,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <exec>:
SYSCALL(exec)
 8f8:	b8 07 00 00 00       	mov    $0x7,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <open>:
SYSCALL(open)
 900:	b8 0f 00 00 00       	mov    $0xf,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <mknod>:
SYSCALL(mknod)
 908:	b8 11 00 00 00       	mov    $0x11,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <unlink>:
SYSCALL(unlink)
 910:	b8 12 00 00 00       	mov    $0x12,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <fstat>:
SYSCALL(fstat)
 918:	b8 08 00 00 00       	mov    $0x8,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <link>:
SYSCALL(link)
 920:	b8 13 00 00 00       	mov    $0x13,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <mkdir>:
SYSCALL(mkdir)
 928:	b8 14 00 00 00       	mov    $0x14,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <chdir>:
SYSCALL(chdir)
 930:	b8 09 00 00 00       	mov    $0x9,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <dup>:
SYSCALL(dup)
 938:	b8 0a 00 00 00       	mov    $0xa,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <getpid>:
SYSCALL(getpid)
 940:	b8 0b 00 00 00       	mov    $0xb,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <sbrk>:
SYSCALL(sbrk)
 948:	b8 0c 00 00 00       	mov    $0xc,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <sleep>:
SYSCALL(sleep)
 950:	b8 0d 00 00 00       	mov    $0xd,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <uptime>:
SYSCALL(uptime)
 958:	b8 0e 00 00 00       	mov    $0xe,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	83 ec 28             	sub    $0x28,%esp
 966:	8b 45 0c             	mov    0xc(%ebp),%eax
 969:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 96c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 973:	00 
 974:	8d 45 f4             	lea    -0xc(%ebp),%eax
 977:	89 44 24 04          	mov    %eax,0x4(%esp)
 97b:	8b 45 08             	mov    0x8(%ebp),%eax
 97e:	89 04 24             	mov    %eax,(%esp)
 981:	e8 5a ff ff ff       	call   8e0 <write>
}
 986:	c9                   	leave  
 987:	c3                   	ret    

00000988 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 988:	55                   	push   %ebp
 989:	89 e5                	mov    %esp,%ebp
 98b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 98e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 995:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 999:	74 17                	je     9b2 <printint+0x2a>
 99b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 99f:	79 11                	jns    9b2 <printint+0x2a>
    neg = 1;
 9a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 9ab:	f7 d8                	neg    %eax
 9ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9b0:	eb 06                	jmp    9b8 <printint+0x30>
  } else {
    x = xx;
 9b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 9b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 9c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9c5:	ba 00 00 00 00       	mov    $0x0,%edx
 9ca:	f7 f1                	div    %ecx
 9cc:	89 d0                	mov    %edx,%eax
 9ce:	0f b6 90 e0 11 00 00 	movzbl 0x11e0(%eax),%edx
 9d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
 9d8:	03 45 f4             	add    -0xc(%ebp),%eax
 9db:	88 10                	mov    %dl,(%eax)
 9dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 9e1:	8b 55 10             	mov    0x10(%ebp),%edx
 9e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 9e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ea:	ba 00 00 00 00       	mov    $0x0,%edx
 9ef:	f7 75 d4             	divl   -0x2c(%ebp)
 9f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9f9:	75 c4                	jne    9bf <printint+0x37>
  if(neg)
 9fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ff:	74 2a                	je     a2b <printint+0xa3>
    buf[i++] = '-';
 a01:	8d 45 dc             	lea    -0x24(%ebp),%eax
 a04:	03 45 f4             	add    -0xc(%ebp),%eax
 a07:	c6 00 2d             	movb   $0x2d,(%eax)
 a0a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 a0e:	eb 1b                	jmp    a2b <printint+0xa3>
    putc(fd, buf[i]);
 a10:	8d 45 dc             	lea    -0x24(%ebp),%eax
 a13:	03 45 f4             	add    -0xc(%ebp),%eax
 a16:	0f b6 00             	movzbl (%eax),%eax
 a19:	0f be c0             	movsbl %al,%eax
 a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
 a20:	8b 45 08             	mov    0x8(%ebp),%eax
 a23:	89 04 24             	mov    %eax,(%esp)
 a26:	e8 35 ff ff ff       	call   960 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a2b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a33:	79 db                	jns    a10 <printint+0x88>
    putc(fd, buf[i]);
}
 a35:	c9                   	leave  
 a36:	c3                   	ret    

00000a37 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a37:	55                   	push   %ebp
 a38:	89 e5                	mov    %esp,%ebp
 a3a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a44:	8d 45 0c             	lea    0xc(%ebp),%eax
 a47:	83 c0 04             	add    $0x4,%eax
 a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a54:	e9 7d 01 00 00       	jmp    bd6 <printf+0x19f>
    c = fmt[i] & 0xff;
 a59:	8b 55 0c             	mov    0xc(%ebp),%edx
 a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5f:	01 d0                	add    %edx,%eax
 a61:	0f b6 00             	movzbl (%eax),%eax
 a64:	0f be c0             	movsbl %al,%eax
 a67:	25 ff 00 00 00       	and    $0xff,%eax
 a6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a73:	75 2c                	jne    aa1 <printf+0x6a>
      if(c == '%'){
 a75:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a79:	75 0c                	jne    a87 <printf+0x50>
        state = '%';
 a7b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a82:	e9 4b 01 00 00       	jmp    bd2 <printf+0x19b>
      } else {
        putc(fd, c);
 a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a8a:	0f be c0             	movsbl %al,%eax
 a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
 a91:	8b 45 08             	mov    0x8(%ebp),%eax
 a94:	89 04 24             	mov    %eax,(%esp)
 a97:	e8 c4 fe ff ff       	call   960 <putc>
 a9c:	e9 31 01 00 00       	jmp    bd2 <printf+0x19b>
      }
    } else if(state == '%'){
 aa1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 aa5:	0f 85 27 01 00 00    	jne    bd2 <printf+0x19b>
      if(c == 'd'){
 aab:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 aaf:	75 2d                	jne    ade <printf+0xa7>
        printint(fd, *ap, 10, 1);
 ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ab4:	8b 00                	mov    (%eax),%eax
 ab6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 abd:	00 
 abe:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 ac5:	00 
 ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
 aca:	8b 45 08             	mov    0x8(%ebp),%eax
 acd:	89 04 24             	mov    %eax,(%esp)
 ad0:	e8 b3 fe ff ff       	call   988 <printint>
        ap++;
 ad5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ad9:	e9 ed 00 00 00       	jmp    bcb <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 ade:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 ae2:	74 06                	je     aea <printf+0xb3>
 ae4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 ae8:	75 2d                	jne    b17 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aed:	8b 00                	mov    (%eax),%eax
 aef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 af6:	00 
 af7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 afe:	00 
 aff:	89 44 24 04          	mov    %eax,0x4(%esp)
 b03:	8b 45 08             	mov    0x8(%ebp),%eax
 b06:	89 04 24             	mov    %eax,(%esp)
 b09:	e8 7a fe ff ff       	call   988 <printint>
        ap++;
 b0e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b12:	e9 b4 00 00 00       	jmp    bcb <printf+0x194>
      } else if(c == 's'){
 b17:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b1b:	75 46                	jne    b63 <printf+0x12c>
        s = (char*)*ap;
 b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b20:	8b 00                	mov    (%eax),%eax
 b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b25:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b2d:	75 27                	jne    b56 <printf+0x11f>
          s = "(null)";
 b2f:	c7 45 f4 78 0f 00 00 	movl   $0xf78,-0xc(%ebp)
        while(*s != 0){
 b36:	eb 1e                	jmp    b56 <printf+0x11f>
          putc(fd, *s);
 b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3b:	0f b6 00             	movzbl (%eax),%eax
 b3e:	0f be c0             	movsbl %al,%eax
 b41:	89 44 24 04          	mov    %eax,0x4(%esp)
 b45:	8b 45 08             	mov    0x8(%ebp),%eax
 b48:	89 04 24             	mov    %eax,(%esp)
 b4b:	e8 10 fe ff ff       	call   960 <putc>
          s++;
 b50:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 b54:	eb 01                	jmp    b57 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b56:	90                   	nop
 b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5a:	0f b6 00             	movzbl (%eax),%eax
 b5d:	84 c0                	test   %al,%al
 b5f:	75 d7                	jne    b38 <printf+0x101>
 b61:	eb 68                	jmp    bcb <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b63:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b67:	75 1d                	jne    b86 <printf+0x14f>
        putc(fd, *ap);
 b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b6c:	8b 00                	mov    (%eax),%eax
 b6e:	0f be c0             	movsbl %al,%eax
 b71:	89 44 24 04          	mov    %eax,0x4(%esp)
 b75:	8b 45 08             	mov    0x8(%ebp),%eax
 b78:	89 04 24             	mov    %eax,(%esp)
 b7b:	e8 e0 fd ff ff       	call   960 <putc>
        ap++;
 b80:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b84:	eb 45                	jmp    bcb <printf+0x194>
      } else if(c == '%'){
 b86:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b8a:	75 17                	jne    ba3 <printf+0x16c>
        putc(fd, c);
 b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b8f:	0f be c0             	movsbl %al,%eax
 b92:	89 44 24 04          	mov    %eax,0x4(%esp)
 b96:	8b 45 08             	mov    0x8(%ebp),%eax
 b99:	89 04 24             	mov    %eax,(%esp)
 b9c:	e8 bf fd ff ff       	call   960 <putc>
 ba1:	eb 28                	jmp    bcb <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ba3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 baa:	00 
 bab:	8b 45 08             	mov    0x8(%ebp),%eax
 bae:	89 04 24             	mov    %eax,(%esp)
 bb1:	e8 aa fd ff ff       	call   960 <putc>
        putc(fd, c);
 bb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bb9:	0f be c0             	movsbl %al,%eax
 bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
 bc0:	8b 45 08             	mov    0x8(%ebp),%eax
 bc3:	89 04 24             	mov    %eax,(%esp)
 bc6:	e8 95 fd ff ff       	call   960 <putc>
      }
      state = 0;
 bcb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bd2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
 bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bdc:	01 d0                	add    %edx,%eax
 bde:	0f b6 00             	movzbl (%eax),%eax
 be1:	84 c0                	test   %al,%al
 be3:	0f 85 70 fe ff ff    	jne    a59 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 be9:	c9                   	leave  
 bea:	c3                   	ret    
 beb:	90                   	nop

00000bec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bec:	55                   	push   %ebp
 bed:	89 e5                	mov    %esp,%ebp
 bef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bf2:	8b 45 08             	mov    0x8(%ebp),%eax
 bf5:	83 e8 08             	sub    $0x8,%eax
 bf8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfb:	a1 fc 11 00 00       	mov    0x11fc,%eax
 c00:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c03:	eb 24                	jmp    c29 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c08:	8b 00                	mov    (%eax),%eax
 c0a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c0d:	77 12                	ja     c21 <free+0x35>
 c0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c12:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c15:	77 24                	ja     c3b <free+0x4f>
 c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1a:	8b 00                	mov    (%eax),%eax
 c1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c1f:	77 1a                	ja     c3b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c24:	8b 00                	mov    (%eax),%eax
 c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c29:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c2f:	76 d4                	jbe    c05 <free+0x19>
 c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c34:	8b 00                	mov    (%eax),%eax
 c36:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c39:	76 ca                	jbe    c05 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3e:	8b 40 04             	mov    0x4(%eax),%eax
 c41:	c1 e0 03             	shl    $0x3,%eax
 c44:	89 c2                	mov    %eax,%edx
 c46:	03 55 f8             	add    -0x8(%ebp),%edx
 c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c4c:	8b 00                	mov    (%eax),%eax
 c4e:	39 c2                	cmp    %eax,%edx
 c50:	75 24                	jne    c76 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 c52:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c55:	8b 50 04             	mov    0x4(%eax),%edx
 c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5b:	8b 00                	mov    (%eax),%eax
 c5d:	8b 40 04             	mov    0x4(%eax),%eax
 c60:	01 c2                	add    %eax,%edx
 c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c65:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6b:	8b 00                	mov    (%eax),%eax
 c6d:	8b 10                	mov    (%eax),%edx
 c6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c72:	89 10                	mov    %edx,(%eax)
 c74:	eb 0a                	jmp    c80 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c79:	8b 10                	mov    (%eax),%edx
 c7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c83:	8b 40 04             	mov    0x4(%eax),%eax
 c86:	c1 e0 03             	shl    $0x3,%eax
 c89:	03 45 fc             	add    -0x4(%ebp),%eax
 c8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c8f:	75 20                	jne    cb1 <free+0xc5>
    p->s.size += bp->s.size;
 c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c94:	8b 50 04             	mov    0x4(%eax),%edx
 c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c9a:	8b 40 04             	mov    0x4(%eax),%eax
 c9d:	01 c2                	add    %eax,%edx
 c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca8:	8b 10                	mov    (%eax),%edx
 caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cad:	89 10                	mov    %edx,(%eax)
 caf:	eb 08                	jmp    cb9 <free+0xcd>
  } else
    p->s.ptr = bp;
 cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 cb7:	89 10                	mov    %edx,(%eax)
  freep = p;
 cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbc:	a3 fc 11 00 00       	mov    %eax,0x11fc
}
 cc1:	c9                   	leave  
 cc2:	c3                   	ret    

00000cc3 <morecore>:

static Header*
morecore(uint nu)
{
 cc3:	55                   	push   %ebp
 cc4:	89 e5                	mov    %esp,%ebp
 cc6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 cc9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cd0:	77 07                	ja     cd9 <morecore+0x16>
    nu = 4096;
 cd2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 cd9:	8b 45 08             	mov    0x8(%ebp),%eax
 cdc:	c1 e0 03             	shl    $0x3,%eax
 cdf:	89 04 24             	mov    %eax,(%esp)
 ce2:	e8 61 fc ff ff       	call   948 <sbrk>
 ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cea:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cee:	75 07                	jne    cf7 <morecore+0x34>
    return 0;
 cf0:	b8 00 00 00 00       	mov    $0x0,%eax
 cf5:	eb 22                	jmp    d19 <morecore+0x56>
  hp = (Header*)p;
 cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d00:	8b 55 08             	mov    0x8(%ebp),%edx
 d03:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d09:	83 c0 08             	add    $0x8,%eax
 d0c:	89 04 24             	mov    %eax,(%esp)
 d0f:	e8 d8 fe ff ff       	call   bec <free>
  return freep;
 d14:	a1 fc 11 00 00       	mov    0x11fc,%eax
}
 d19:	c9                   	leave  
 d1a:	c3                   	ret    

00000d1b <malloc>:

void*
malloc(uint nbytes)
{
 d1b:	55                   	push   %ebp
 d1c:	89 e5                	mov    %esp,%ebp
 d1e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d21:	8b 45 08             	mov    0x8(%ebp),%eax
 d24:	83 c0 07             	add    $0x7,%eax
 d27:	c1 e8 03             	shr    $0x3,%eax
 d2a:	83 c0 01             	add    $0x1,%eax
 d2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d30:	a1 fc 11 00 00       	mov    0x11fc,%eax
 d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d3c:	75 23                	jne    d61 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 d3e:	c7 45 f0 f4 11 00 00 	movl   $0x11f4,-0x10(%ebp)
 d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d48:	a3 fc 11 00 00       	mov    %eax,0x11fc
 d4d:	a1 fc 11 00 00       	mov    0x11fc,%eax
 d52:	a3 f4 11 00 00       	mov    %eax,0x11f4
    base.s.size = 0;
 d57:	c7 05 f8 11 00 00 00 	movl   $0x0,0x11f8
 d5e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d64:	8b 00                	mov    (%eax),%eax
 d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6c:	8b 40 04             	mov    0x4(%eax),%eax
 d6f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d72:	72 4d                	jb     dc1 <malloc+0xa6>
      if(p->s.size == nunits)
 d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d77:	8b 40 04             	mov    0x4(%eax),%eax
 d7a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d7d:	75 0c                	jne    d8b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d82:	8b 10                	mov    (%eax),%edx
 d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d87:	89 10                	mov    %edx,(%eax)
 d89:	eb 26                	jmp    db1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8e:	8b 40 04             	mov    0x4(%eax),%eax
 d91:	89 c2                	mov    %eax,%edx
 d93:	2b 55 ec             	sub    -0x14(%ebp),%edx
 d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d99:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9f:	8b 40 04             	mov    0x4(%eax),%eax
 da2:	c1 e0 03             	shl    $0x3,%eax
 da5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dab:	8b 55 ec             	mov    -0x14(%ebp),%edx
 dae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 db4:	a3 fc 11 00 00       	mov    %eax,0x11fc
      return (void*)(p + 1);
 db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbc:	83 c0 08             	add    $0x8,%eax
 dbf:	eb 38                	jmp    df9 <malloc+0xde>
    }
    if(p == freep)
 dc1:	a1 fc 11 00 00       	mov    0x11fc,%eax
 dc6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 dc9:	75 1b                	jne    de6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 dce:	89 04 24             	mov    %eax,(%esp)
 dd1:	e8 ed fe ff ff       	call   cc3 <morecore>
 dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ddd:	75 07                	jne    de6 <malloc+0xcb>
        return 0;
 ddf:	b8 00 00 00 00       	mov    $0x0,%eax
 de4:	eb 13                	jmp    df9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 def:	8b 00                	mov    (%eax),%eax
 df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 df4:	e9 70 ff ff ff       	jmp    d69 <malloc+0x4e>
}
 df9:	c9                   	leave  
 dfa:	c3                   	ret    
