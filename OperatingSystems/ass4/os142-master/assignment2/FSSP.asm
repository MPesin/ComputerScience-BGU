
_FSSP:     file format elf32-i386


Disassembly of section .text:

00000000 <initializeBarrier>:
/* R */	{ {S_R, S_R, S_Q, S_L, S_E},  {S_Q, S_R, S_L, S_E, S_L},  {S_S, S_E, S_Q, S_F, S_E}, {S_Q, S_R, S_L, S_E, S_L}, {S_S, S_E, S_Q, S_F, S_E} },
/* L */	{ {S_L, S_S, S_Q, S_Q, S_E},  {S_Q, S_Q, S_R, S_R, S_Q},  {S_L, S_E, S_L, S_L, S_E}, {S_R, S_F, S_E, S_E, S_F}, {S_E, S_E, S_R, S_R, S_E} },
/* S */	{ {S_Q, S_S, S_L, S_Q, S_E},  {S_R, S_E, S_E, S_F, S_E},  {S_S, S_E, S_E, S_S, S_E}, {S_Q, S_S, S_F, S_E, S_E}, {S_Q, S_S, S_F, S_E, S_E} },
};

void initializeBarrier(int size) {
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
	barrier.counter = 0;
       6:	c7 05 80 1b 00 00 00 	movl   $0x0,0x1b80
       d:	00 00 00 
	barrier.size = size;
      10:	8b 45 08             	mov    0x8(%ebp),%eax
      13:	a3 84 1b 00 00       	mov    %eax,0x1b84
	binary_semaphore_init(&barrier.arr_sem,1);
      18:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
      1f:	00 
      20:	c7 04 24 88 1b 00 00 	movl   $0x1b88,(%esp)
      27:	e8 51 10 00 00       	call   107d <binary_semaphore_init>
	binary_semaphore_init(&barrier.dep_sem,0);
      2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      33:	00 
      34:	c7 04 24 90 1c 00 00 	movl   $0x1c90,(%esp)
      3b:	e8 3d 10 00 00       	call   107d <binary_semaphore_init>
}
      40:	c9                   	leave  
      41:	c3                   	ret    

00000042 <next_state>:

int next_state(int index) {
      42:	55                   	push   %ebp
      43:	89 e5                	mov    %esp,%ebp
      45:	83 ec 20             	sub    $0x20,%esp
	int center, left, right, nextState;
	int (*currStates)[sol_num];
      48:	a1 60 19 00 00       	mov    0x1960,%eax
      4d:	83 e8 01             	sub    $0x1,%eax
      50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int (*nextStates)[sol_num];
      53:	a1 60 19 00 00       	mov    0x1960,%eax
      58:	83 e8 01             	sub    $0x1,%eax
      5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (CURRENT_STATE == 1) {
      5e:	a1 80 17 00 00       	mov    0x1780,%eax
      63:	83 f8 01             	cmp    $0x1,%eax
      66:	75 10                	jne    78 <next_state+0x36>
		currStates = &A_STATES;
      68:	c7 45 fc 80 1a 00 00 	movl   $0x1a80,-0x4(%ebp)
		nextStates = &B_STATES;
      6f:	c7 45 f8 80 19 00 00 	movl   $0x1980,-0x8(%ebp)
      76:	eb 0e                	jmp    86 <next_state+0x44>
	}
	else {
		currStates = &B_STATES;
      78:	c7 45 fc 80 19 00 00 	movl   $0x1980,-0x4(%ebp)
		nextStates = &A_STATES;
      7f:	c7 45 f8 80 1a 00 00 	movl   $0x1a80,-0x8(%ebp)
	}

	center = (*currStates)[index];
      86:	8b 45 fc             	mov    -0x4(%ebp),%eax
      89:	8b 55 08             	mov    0x8(%ebp),%edx
      8c:	8b 04 90             	mov    (%eax,%edx,4),%eax
      8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	left = (index==0) ? S_ASTRIX : (*currStates)[index-1];
      92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      96:	74 0e                	je     a6 <next_state+0x64>
      98:	8b 45 08             	mov    0x8(%ebp),%eax
      9b:	8d 50 ff             	lea    -0x1(%eax),%edx
      9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
      a1:	8b 04 90             	mov    (%eax,%edx,4),%eax
      a4:	eb 05                	jmp    ab <next_state+0x69>
      a6:	b8 04 00 00 00       	mov    $0x4,%eax
      ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	right = (index == sol_num-1) ? S_ASTRIX : (*currStates)[index+1];
      ae:	a1 60 19 00 00       	mov    0x1960,%eax
      b3:	83 e8 01             	sub    $0x1,%eax
      b6:	3b 45 08             	cmp    0x8(%ebp),%eax
      b9:	74 0e                	je     c9 <next_state+0x87>
      bb:	8b 45 08             	mov    0x8(%ebp),%eax
      be:	8d 50 01             	lea    0x1(%eax),%edx
      c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
      c4:	8b 04 90             	mov    (%eax,%edx,4),%eax
      c7:	eb 05                	jmp    ce <next_state+0x8c>
      c9:	b8 04 00 00 00       	mov    $0x4,%eax
      ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	nextState = states[center][left][right];
      d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
      d4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
      d7:	89 c2                	mov    %eax,%edx
      d9:	c1 e2 02             	shl    $0x2,%edx
      dc:	01 c2                	add    %eax,%edx
      de:	89 c8                	mov    %ecx,%eax
      e0:	c1 e0 02             	shl    $0x2,%eax
      e3:	01 c8                	add    %ecx,%eax
      e5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
      ec:	01 c8                	add    %ecx,%eax
      ee:	01 c2                	add    %eax,%edx
      f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      f3:	01 d0                	add    %edx,%eax
      f5:	8b 04 85 a0 17 00 00 	mov    0x17a0(,%eax,4),%eax
      fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	(*nextStates)[index] = nextState;
      ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
     102:	8b 55 08             	mov    0x8(%ebp),%edx
     105:	8b 4d e0             	mov    -0x20(%ebp),%ecx
     108:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

	return nextState;
     10b:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
     10e:	c9                   	leave  
     10f:	c3                   	ret    

00000110 <statesPrinter>:

void statesPrinter() {
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	83 ec 28             	sub    $0x28,%esp
	int (*currStates)[sol_num];
     116:	a1 60 19 00 00       	mov    0x1960,%eax
     11b:	83 e8 01             	sub    $0x1,%eax
     11e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int i;
	if (CURRENT_STATE == 1){
     121:	a1 80 17 00 00       	mov    0x1780,%eax
     126:	83 f8 01             	cmp    $0x1,%eax
     129:	75 09                	jne    134 <statesPrinter+0x24>
		currStates = &A_STATES;
     12b:	c7 45 f4 80 1a 00 00 	movl   $0x1a80,-0xc(%ebp)
     132:	eb 07                	jmp    13b <statesPrinter+0x2b>
	}
	else{
		currStates = &B_STATES;
     134:	c7 45 f4 80 19 00 00 	movl   $0x1980,-0xc(%ebp)
	}
	for (i = 0; i < sol_num ; i++) {
     13b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     142:	eb 25                	jmp    169 <statesPrinter+0x59>
		printf(1," %d ", (*currStates)[i]);
     144:	8b 45 f4             	mov    -0xc(%ebp),%eax
     147:	8b 55 f0             	mov    -0x10(%ebp),%edx
     14a:	8b 04 90             	mov    (%eax,%edx,4),%eax
     14d:	89 44 24 08          	mov    %eax,0x8(%esp)
     151:	c7 44 24 04 d4 11 00 	movl   $0x11d4,0x4(%esp)
     158:	00 
     159:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     160:	e8 7a 06 00 00       	call   7df <printf>
		currStates = &A_STATES;
	}
	else{
		currStates = &B_STATES;
	}
	for (i = 0; i < sol_num ; i++) {
     165:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     169:	a1 60 19 00 00       	mov    0x1960,%eax
     16e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     171:	7c d1                	jl     144 <statesPrinter+0x34>
		printf(1," %d ", (*currStates)[i]);
	}
	printf(1,"\n");
     173:	c7 44 24 04 d9 11 00 	movl   $0x11d9,0x4(%esp)
     17a:	00 
     17b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     182:	e8 58 06 00 00       	call   7df <printf>
}
     187:	c9                   	leave  
     188:	c3                   	ret    

00000189 <barrier_func>:

void barrier_func(){
     189:	55                   	push   %ebp
     18a:	89 e5                	mov    %esp,%ebp
     18c:	83 ec 18             	sub    $0x18,%esp
	binary_semaphore_down(&barrier.arr_sem);
     18f:	c7 04 24 88 1b 00 00 	movl   $0x1b88,(%esp)
     196:	e8 20 0f 00 00       	call   10bb <binary_semaphore_down>
	barrier.counter++;
     19b:	a1 80 1b 00 00       	mov    0x1b80,%eax
     1a0:	83 c0 01             	add    $0x1,%eax
     1a3:	a3 80 1b 00 00       	mov    %eax,0x1b80
	if (barrier.size > barrier.counter){
     1a8:	8b 15 84 1b 00 00    	mov    0x1b84,%edx
     1ae:	a1 80 1b 00 00       	mov    0x1b80,%eax
     1b3:	39 c2                	cmp    %eax,%edx
     1b5:	7e 0e                	jle    1c5 <barrier_func+0x3c>
		binary_semaphore_up(&barrier.arr_sem);
     1b7:	c7 04 24 88 1b 00 00 	movl   $0x1b88,(%esp)
     1be:	e8 75 0f 00 00       	call   1138 <binary_semaphore_up>
     1c3:	eb 3c                	jmp    201 <barrier_func+0x78>
	}
	else {
		alarm(0);
     1c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1cc:	e8 96 04 00 00       	call   667 <alarm>
		statesPrinter();
     1d1:	e8 3a ff ff ff       	call   110 <statesPrinter>
		CURRENT_STATE = 1 - CURRENT_STATE;
     1d6:	a1 80 17 00 00       	mov    0x1780,%eax
     1db:	ba 01 00 00 00       	mov    $0x1,%edx
     1e0:	29 c2                	sub    %eax,%edx
     1e2:	89 d0                	mov    %edx,%eax
     1e4:	a3 80 17 00 00       	mov    %eax,0x1780
		alarm(UTHREAD_QUANTA);
     1e9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     1f0:	e8 72 04 00 00       	call   667 <alarm>
		binary_semaphore_up(&barrier.dep_sem);
     1f5:	c7 04 24 90 1c 00 00 	movl   $0x1c90,(%esp)
     1fc:	e8 37 0f 00 00       	call   1138 <binary_semaphore_up>
	}
	binary_semaphore_down(&barrier.dep_sem);
     201:	c7 04 24 90 1c 00 00 	movl   $0x1c90,(%esp)
     208:	e8 ae 0e 00 00       	call   10bb <binary_semaphore_down>
	barrier.counter--;
     20d:	a1 80 1b 00 00       	mov    0x1b80,%eax
     212:	83 e8 01             	sub    $0x1,%eax
     215:	a3 80 1b 00 00       	mov    %eax,0x1b80
	if (barrier.counter > 0)
     21a:	a1 80 1b 00 00       	mov    0x1b80,%eax
     21f:	85 c0                	test   %eax,%eax
     221:	7e 0e                	jle    231 <barrier_func+0xa8>
		binary_semaphore_up(&barrier.dep_sem);
     223:	c7 04 24 90 1c 00 00 	movl   $0x1c90,(%esp)
     22a:	e8 09 0f 00 00       	call   1138 <binary_semaphore_up>
     22f:	eb 0c                	jmp    23d <barrier_func+0xb4>
	else
		binary_semaphore_up(&barrier.arr_sem);
     231:	c7 04 24 88 1b 00 00 	movl   $0x1b88,(%esp)
     238:	e8 fb 0e 00 00       	call   1138 <binary_semaphore_up>
}
     23d:	c9                   	leave  
     23e:	c3                   	ret    

0000023f <initStates>:

void initStates() {
     23f:	55                   	push   %ebp
     240:	89 e5                	mov    %esp,%ebp
     242:	83 ec 10             	sub    $0x10,%esp
	int i;
	A_STATES[0]  = S_R;
     245:	c7 05 80 1a 00 00 01 	movl   $0x1,0x1a80
     24c:	00 00 00 
	for (i = 1; i < sol_num; i++){
     24f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
     256:	eb 12                	jmp    26a <initStates+0x2b>
		A_STATES[i]  = S_Q;
     258:	8b 45 fc             	mov    -0x4(%ebp),%eax
     25b:	c7 04 85 80 1a 00 00 	movl   $0x0,0x1a80(,%eax,4)
     262:	00 00 00 00 
}

void initStates() {
	int i;
	A_STATES[0]  = S_R;
	for (i = 1; i < sol_num; i++){
     266:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     26a:	a1 60 19 00 00       	mov    0x1960,%eax
     26f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
     272:	7c e4                	jl     258 <initStates+0x19>
		A_STATES[i]  = S_Q;
	}
}
     274:	c9                   	leave  
     275:	c3                   	ret    

00000276 <soldier>:

void soldier(void* ind){
     276:	55                   	push   %ebp
     277:	89 e5                	mov    %esp,%ebp
     279:	83 ec 28             	sub    $0x28,%esp
	int index,state;
	index =(int)((int *) ind);
     27c:	8b 45 08             	mov    0x8(%ebp),%eax
     27f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	state = S_Q ;
     282:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while (state != S_F) {
     289:	eb 13                	jmp    29e <soldier+0x28>
		state =	next_state(index);
     28b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     28e:	89 04 24             	mov    %eax,(%esp)
     291:	e8 ac fd ff ff       	call   42 <next_state>
     296:	89 45 f4             	mov    %eax,-0xc(%ebp)
		barrier_func();
     299:	e8 eb fe ff ff       	call   189 <barrier_func>

void soldier(void* ind){
	int index,state;
	index =(int)((int *) ind);
	state = S_Q ;
	while (state != S_F) {
     29e:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
     2a2:	75 e7                	jne    28b <soldier+0x15>
		state =	next_state(index);
		barrier_func();
	}
}
     2a4:	c9                   	leave  
     2a5:	c3                   	ret    

000002a6 <main>:

int main(int argc, char **argv) {
     2a6:	55                   	push   %ebp
     2a7:	89 e5                	mov    %esp,%ebp
     2a9:	83 e4 f0             	and    $0xfffffff0,%esp
     2ac:	81 ec 20 01 00 00    	sub    $0x120,%esp
	int threads[MAX_UTHREADS],i;
	if (argc < 2) {
     2b2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     2b6:	7f 19                	jg     2d1 <main+0x2b>
		printf(1,"ERROR: Not enough arguments, usage: FSSP <number> \n");
     2b8:	c7 44 24 04 dc 11 00 	movl   $0x11dc,0x4(%esp)
     2bf:	00 
     2c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c7:	e8 13 05 00 00       	call   7df <printf>
		exit();
     2cc:	e8 76 03 00 00       	call   647 <exit>
	}
	sol_num = atoi(argv[1]);
     2d1:	8b 45 0c             	mov    0xc(%ebp),%eax
     2d4:	83 c0 04             	add    $0x4,%eax
     2d7:	8b 00                	mov    (%eax),%eax
     2d9:	89 04 24             	mov    %eax,(%esp)
     2dc:	e8 d4 02 00 00       	call   5b5 <atoi>
     2e1:	a3 60 19 00 00       	mov    %eax,0x1960
	if (sol_num > MAX_UTHREADS) {
     2e6:	a1 60 19 00 00       	mov    0x1960,%eax
     2eb:	83 f8 40             	cmp    $0x40,%eax
     2ee:	7e 19                	jle    309 <main+0x63>
		printf(1,"ERROR: More soldiers than threads\n");
     2f0:	c7 44 24 04 10 12 00 	movl   $0x1210,0x4(%esp)
     2f7:	00 
     2f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2ff:	e8 db 04 00 00       	call   7df <printf>
		exit();
     304:	e8 3e 03 00 00       	call   647 <exit>
	}

	uthread_init(); 
     309:	e8 30 09 00 00       	call   c3e <uthread_init>
	initializeBarrier(sol_num); 
     30e:	a1 60 19 00 00       	mov    0x1960,%eax
     313:	89 04 24             	mov    %eax,(%esp)
     316:	e8 e5 fc ff ff       	call   0 <initializeBarrier>
	
	/* Initialize states */
	A_STATES[0]  = S_R;
     31b:	c7 05 80 1a 00 00 01 	movl   $0x1,0x1a80
     322:	00 00 00 
	for (i = 1; i < sol_num; i++){
     325:	c7 84 24 1c 01 00 00 	movl   $0x1,0x11c(%esp)
     32c:	01 00 00 00 
     330:	eb 1a                	jmp    34c <main+0xa6>
		A_STATES[i]  = S_Q;
     332:	8b 84 24 1c 01 00 00 	mov    0x11c(%esp),%eax
     339:	c7 04 85 80 1a 00 00 	movl   $0x0,0x1a80(,%eax,4)
     340:	00 00 00 00 
	uthread_init(); 
	initializeBarrier(sol_num); 
	
	/* Initialize states */
	A_STATES[0]  = S_R;
	for (i = 1; i < sol_num; i++){
     344:	83 84 24 1c 01 00 00 	addl   $0x1,0x11c(%esp)
     34b:	01 
     34c:	a1 60 19 00 00       	mov    0x1960,%eax
     351:	39 84 24 1c 01 00 00 	cmp    %eax,0x11c(%esp)
     358:	7c d8                	jl     332 <main+0x8c>
		A_STATES[i]  = S_Q;
	}

	for (i=0; i < sol_num; i++){
     35a:	c7 84 24 1c 01 00 00 	movl   $0x0,0x11c(%esp)
     361:	00 00 00 00 
     365:	eb 2a                	jmp    391 <main+0xeb>
		threads[i] = uthread_create(soldier,(void*)i);
     367:	8b 84 24 1c 01 00 00 	mov    0x11c(%esp),%eax
     36e:	89 44 24 04          	mov    %eax,0x4(%esp)
     372:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
     379:	e8 4e 09 00 00       	call   ccc <uthread_create>
     37e:	8b 94 24 1c 01 00 00 	mov    0x11c(%esp),%edx
     385:	89 44 94 1c          	mov    %eax,0x1c(%esp,%edx,4)
	A_STATES[0]  = S_R;
	for (i = 1; i < sol_num; i++){
		A_STATES[i]  = S_Q;
	}

	for (i=0; i < sol_num; i++){
     389:	83 84 24 1c 01 00 00 	addl   $0x1,0x11c(%esp)
     390:	01 
     391:	a1 60 19 00 00       	mov    0x1960,%eax
     396:	39 84 24 1c 01 00 00 	cmp    %eax,0x11c(%esp)
     39d:	7c c8                	jl     367 <main+0xc1>
		threads[i] = uthread_create(soldier,(void*)i);
	}

	for (i=0; i < sol_num; i++){
     39f:	c7 84 24 1c 01 00 00 	movl   $0x0,0x11c(%esp)
     3a6:	00 00 00 00 
     3aa:	eb 1b                	jmp    3c7 <main+0x121>
		uthread_join(threads[i]);
     3ac:	8b 84 24 1c 01 00 00 	mov    0x11c(%esp),%eax
     3b3:	8b 44 84 1c          	mov    0x1c(%esp,%eax,4),%eax
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 7f 0b 00 00       	call   f3e <uthread_join>

	for (i=0; i < sol_num; i++){
		threads[i] = uthread_create(soldier,(void*)i);
	}

	for (i=0; i < sol_num; i++){
     3bf:	83 84 24 1c 01 00 00 	addl   $0x1,0x11c(%esp)
     3c6:	01 
     3c7:	a1 60 19 00 00       	mov    0x1960,%eax
     3cc:	39 84 24 1c 01 00 00 	cmp    %eax,0x11c(%esp)
     3d3:	7c d7                	jl     3ac <main+0x106>
		uthread_join(threads[i]);
	}
	statesPrinter();
     3d5:	e8 36 fd ff ff       	call   110 <statesPrinter>

	exit();
     3da:	e8 68 02 00 00       	call   647 <exit>

000003df <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     3df:	55                   	push   %ebp
     3e0:	89 e5                	mov    %esp,%ebp
     3e2:	57                   	push   %edi
     3e3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     3e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
     3e7:	8b 55 10             	mov    0x10(%ebp),%edx
     3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ed:	89 cb                	mov    %ecx,%ebx
     3ef:	89 df                	mov    %ebx,%edi
     3f1:	89 d1                	mov    %edx,%ecx
     3f3:	fc                   	cld    
     3f4:	f3 aa                	rep stos %al,%es:(%edi)
     3f6:	89 ca                	mov    %ecx,%edx
     3f8:	89 fb                	mov    %edi,%ebx
     3fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
     3fd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     400:	5b                   	pop    %ebx
     401:	5f                   	pop    %edi
     402:	5d                   	pop    %ebp
     403:	c3                   	ret    

00000404 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     404:	55                   	push   %ebp
     405:	89 e5                	mov    %esp,%ebp
     407:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     40a:	8b 45 08             	mov    0x8(%ebp),%eax
     40d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     410:	90                   	nop
     411:	8b 45 08             	mov    0x8(%ebp),%eax
     414:	8d 50 01             	lea    0x1(%eax),%edx
     417:	89 55 08             	mov    %edx,0x8(%ebp)
     41a:	8b 55 0c             	mov    0xc(%ebp),%edx
     41d:	8d 4a 01             	lea    0x1(%edx),%ecx
     420:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     423:	0f b6 12             	movzbl (%edx),%edx
     426:	88 10                	mov    %dl,(%eax)
     428:	0f b6 00             	movzbl (%eax),%eax
     42b:	84 c0                	test   %al,%al
     42d:	75 e2                	jne    411 <strcpy+0xd>
    ;
  return os;
     42f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     432:	c9                   	leave  
     433:	c3                   	ret    

00000434 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     434:	55                   	push   %ebp
     435:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     437:	eb 08                	jmp    441 <strcmp+0xd>
    p++, q++;
     439:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     43d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     441:	8b 45 08             	mov    0x8(%ebp),%eax
     444:	0f b6 00             	movzbl (%eax),%eax
     447:	84 c0                	test   %al,%al
     449:	74 10                	je     45b <strcmp+0x27>
     44b:	8b 45 08             	mov    0x8(%ebp),%eax
     44e:	0f b6 10             	movzbl (%eax),%edx
     451:	8b 45 0c             	mov    0xc(%ebp),%eax
     454:	0f b6 00             	movzbl (%eax),%eax
     457:	38 c2                	cmp    %al,%dl
     459:	74 de                	je     439 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     45b:	8b 45 08             	mov    0x8(%ebp),%eax
     45e:	0f b6 00             	movzbl (%eax),%eax
     461:	0f b6 d0             	movzbl %al,%edx
     464:	8b 45 0c             	mov    0xc(%ebp),%eax
     467:	0f b6 00             	movzbl (%eax),%eax
     46a:	0f b6 c0             	movzbl %al,%eax
     46d:	29 c2                	sub    %eax,%edx
     46f:	89 d0                	mov    %edx,%eax
}
     471:	5d                   	pop    %ebp
     472:	c3                   	ret    

00000473 <strlen>:

uint
strlen(char *s)
{
     473:	55                   	push   %ebp
     474:	89 e5                	mov    %esp,%ebp
     476:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     480:	eb 04                	jmp    486 <strlen+0x13>
     482:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     486:	8b 55 fc             	mov    -0x4(%ebp),%edx
     489:	8b 45 08             	mov    0x8(%ebp),%eax
     48c:	01 d0                	add    %edx,%eax
     48e:	0f b6 00             	movzbl (%eax),%eax
     491:	84 c0                	test   %al,%al
     493:	75 ed                	jne    482 <strlen+0xf>
    ;
  return n;
     495:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     498:	c9                   	leave  
     499:	c3                   	ret    

0000049a <memset>:

void*
memset(void *dst, int c, uint n)
{
     49a:	55                   	push   %ebp
     49b:	89 e5                	mov    %esp,%ebp
     49d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     4a0:	8b 45 10             	mov    0x10(%ebp),%eax
     4a3:	89 44 24 08          	mov    %eax,0x8(%esp)
     4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
     4aa:	89 44 24 04          	mov    %eax,0x4(%esp)
     4ae:	8b 45 08             	mov    0x8(%ebp),%eax
     4b1:	89 04 24             	mov    %eax,(%esp)
     4b4:	e8 26 ff ff ff       	call   3df <stosb>
  return dst;
     4b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     4bc:	c9                   	leave  
     4bd:	c3                   	ret    

000004be <strchr>:

char*
strchr(const char *s, char c)
{
     4be:	55                   	push   %ebp
     4bf:	89 e5                	mov    %esp,%ebp
     4c1:	83 ec 04             	sub    $0x4,%esp
     4c4:	8b 45 0c             	mov    0xc(%ebp),%eax
     4c7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     4ca:	eb 14                	jmp    4e0 <strchr+0x22>
    if(*s == c)
     4cc:	8b 45 08             	mov    0x8(%ebp),%eax
     4cf:	0f b6 00             	movzbl (%eax),%eax
     4d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
     4d5:	75 05                	jne    4dc <strchr+0x1e>
      return (char*)s;
     4d7:	8b 45 08             	mov    0x8(%ebp),%eax
     4da:	eb 13                	jmp    4ef <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     4dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     4e0:	8b 45 08             	mov    0x8(%ebp),%eax
     4e3:	0f b6 00             	movzbl (%eax),%eax
     4e6:	84 c0                	test   %al,%al
     4e8:	75 e2                	jne    4cc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     4ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
     4ef:	c9                   	leave  
     4f0:	c3                   	ret    

000004f1 <gets>:

char*
gets(char *buf, int max)
{
     4f1:	55                   	push   %ebp
     4f2:	89 e5                	mov    %esp,%ebp
     4f4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     4f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4fe:	eb 4c                	jmp    54c <gets+0x5b>
    cc = read(0, &c, 1);
     500:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     507:	00 
     508:	8d 45 ef             	lea    -0x11(%ebp),%eax
     50b:	89 44 24 04          	mov    %eax,0x4(%esp)
     50f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     516:	e8 5c 01 00 00       	call   677 <read>
     51b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     51e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     522:	7f 02                	jg     526 <gets+0x35>
      break;
     524:	eb 31                	jmp    557 <gets+0x66>
    buf[i++] = c;
     526:	8b 45 f4             	mov    -0xc(%ebp),%eax
     529:	8d 50 01             	lea    0x1(%eax),%edx
     52c:	89 55 f4             	mov    %edx,-0xc(%ebp)
     52f:	89 c2                	mov    %eax,%edx
     531:	8b 45 08             	mov    0x8(%ebp),%eax
     534:	01 c2                	add    %eax,%edx
     536:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     53a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     53c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     540:	3c 0a                	cmp    $0xa,%al
     542:	74 13                	je     557 <gets+0x66>
     544:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     548:	3c 0d                	cmp    $0xd,%al
     54a:	74 0b                	je     557 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     54c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54f:	83 c0 01             	add    $0x1,%eax
     552:	3b 45 0c             	cmp    0xc(%ebp),%eax
     555:	7c a9                	jl     500 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     557:	8b 55 f4             	mov    -0xc(%ebp),%edx
     55a:	8b 45 08             	mov    0x8(%ebp),%eax
     55d:	01 d0                	add    %edx,%eax
     55f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     562:	8b 45 08             	mov    0x8(%ebp),%eax
}
     565:	c9                   	leave  
     566:	c3                   	ret    

00000567 <stat>:

int
stat(char *n, struct stat *st)
{
     567:	55                   	push   %ebp
     568:	89 e5                	mov    %esp,%ebp
     56a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     56d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     574:	00 
     575:	8b 45 08             	mov    0x8(%ebp),%eax
     578:	89 04 24             	mov    %eax,(%esp)
     57b:	e8 1f 01 00 00       	call   69f <open>
     580:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     587:	79 07                	jns    590 <stat+0x29>
    return -1;
     589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     58e:	eb 23                	jmp    5b3 <stat+0x4c>
  r = fstat(fd, st);
     590:	8b 45 0c             	mov    0xc(%ebp),%eax
     593:	89 44 24 04          	mov    %eax,0x4(%esp)
     597:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59a:	89 04 24             	mov    %eax,(%esp)
     59d:	e8 15 01 00 00       	call   6b7 <fstat>
     5a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a8:	89 04 24             	mov    %eax,(%esp)
     5ab:	e8 d7 00 00 00       	call   687 <close>
  return r;
     5b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     5b3:	c9                   	leave  
     5b4:	c3                   	ret    

000005b5 <atoi>:

int
atoi(const char *s)
{
     5b5:	55                   	push   %ebp
     5b6:	89 e5                	mov    %esp,%ebp
     5b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     5bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     5c2:	eb 25                	jmp    5e9 <atoi+0x34>
    n = n*10 + *s++ - '0';
     5c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5c7:	89 d0                	mov    %edx,%eax
     5c9:	c1 e0 02             	shl    $0x2,%eax
     5cc:	01 d0                	add    %edx,%eax
     5ce:	01 c0                	add    %eax,%eax
     5d0:	89 c1                	mov    %eax,%ecx
     5d2:	8b 45 08             	mov    0x8(%ebp),%eax
     5d5:	8d 50 01             	lea    0x1(%eax),%edx
     5d8:	89 55 08             	mov    %edx,0x8(%ebp)
     5db:	0f b6 00             	movzbl (%eax),%eax
     5de:	0f be c0             	movsbl %al,%eax
     5e1:	01 c8                	add    %ecx,%eax
     5e3:	83 e8 30             	sub    $0x30,%eax
     5e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     5e9:	8b 45 08             	mov    0x8(%ebp),%eax
     5ec:	0f b6 00             	movzbl (%eax),%eax
     5ef:	3c 2f                	cmp    $0x2f,%al
     5f1:	7e 0a                	jle    5fd <atoi+0x48>
     5f3:	8b 45 08             	mov    0x8(%ebp),%eax
     5f6:	0f b6 00             	movzbl (%eax),%eax
     5f9:	3c 39                	cmp    $0x39,%al
     5fb:	7e c7                	jle    5c4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     600:	c9                   	leave  
     601:	c3                   	ret    

00000602 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     602:	55                   	push   %ebp
     603:	89 e5                	mov    %esp,%ebp
     605:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     608:	8b 45 08             	mov    0x8(%ebp),%eax
     60b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     60e:	8b 45 0c             	mov    0xc(%ebp),%eax
     611:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     614:	eb 17                	jmp    62d <memmove+0x2b>
    *dst++ = *src++;
     616:	8b 45 fc             	mov    -0x4(%ebp),%eax
     619:	8d 50 01             	lea    0x1(%eax),%edx
     61c:	89 55 fc             	mov    %edx,-0x4(%ebp)
     61f:	8b 55 f8             	mov    -0x8(%ebp),%edx
     622:	8d 4a 01             	lea    0x1(%edx),%ecx
     625:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     628:	0f b6 12             	movzbl (%edx),%edx
     62b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     62d:	8b 45 10             	mov    0x10(%ebp),%eax
     630:	8d 50 ff             	lea    -0x1(%eax),%edx
     633:	89 55 10             	mov    %edx,0x10(%ebp)
     636:	85 c0                	test   %eax,%eax
     638:	7f dc                	jg     616 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     63a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     63d:	c9                   	leave  
     63e:	c3                   	ret    

0000063f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     63f:	b8 01 00 00 00       	mov    $0x1,%eax
     644:	cd 40                	int    $0x40
     646:	c3                   	ret    

00000647 <exit>:
SYSCALL(exit)
     647:	b8 02 00 00 00       	mov    $0x2,%eax
     64c:	cd 40                	int    $0x40
     64e:	c3                   	ret    

0000064f <wait>:
SYSCALL(wait)
     64f:	b8 03 00 00 00       	mov    $0x3,%eax
     654:	cd 40                	int    $0x40
     656:	c3                   	ret    

00000657 <signal>:
SYSCALL(signal)
     657:	b8 18 00 00 00       	mov    $0x18,%eax
     65c:	cd 40                	int    $0x40
     65e:	c3                   	ret    

0000065f <sigsend>:
SYSCALL(sigsend)
     65f:	b8 19 00 00 00       	mov    $0x19,%eax
     664:	cd 40                	int    $0x40
     666:	c3                   	ret    

00000667 <alarm>:
SYSCALL(alarm)
     667:	b8 1a 00 00 00       	mov    $0x1a,%eax
     66c:	cd 40                	int    $0x40
     66e:	c3                   	ret    

0000066f <pipe>:
SYSCALL(pipe)
     66f:	b8 04 00 00 00       	mov    $0x4,%eax
     674:	cd 40                	int    $0x40
     676:	c3                   	ret    

00000677 <read>:
SYSCALL(read)
     677:	b8 05 00 00 00       	mov    $0x5,%eax
     67c:	cd 40                	int    $0x40
     67e:	c3                   	ret    

0000067f <write>:
SYSCALL(write)
     67f:	b8 10 00 00 00       	mov    $0x10,%eax
     684:	cd 40                	int    $0x40
     686:	c3                   	ret    

00000687 <close>:
SYSCALL(close)
     687:	b8 15 00 00 00       	mov    $0x15,%eax
     68c:	cd 40                	int    $0x40
     68e:	c3                   	ret    

0000068f <kill>:
SYSCALL(kill)
     68f:	b8 06 00 00 00       	mov    $0x6,%eax
     694:	cd 40                	int    $0x40
     696:	c3                   	ret    

00000697 <exec>:
SYSCALL(exec)
     697:	b8 07 00 00 00       	mov    $0x7,%eax
     69c:	cd 40                	int    $0x40
     69e:	c3                   	ret    

0000069f <open>:
SYSCALL(open)
     69f:	b8 0f 00 00 00       	mov    $0xf,%eax
     6a4:	cd 40                	int    $0x40
     6a6:	c3                   	ret    

000006a7 <mknod>:
SYSCALL(mknod)
     6a7:	b8 11 00 00 00       	mov    $0x11,%eax
     6ac:	cd 40                	int    $0x40
     6ae:	c3                   	ret    

000006af <unlink>:
SYSCALL(unlink)
     6af:	b8 12 00 00 00       	mov    $0x12,%eax
     6b4:	cd 40                	int    $0x40
     6b6:	c3                   	ret    

000006b7 <fstat>:
SYSCALL(fstat)
     6b7:	b8 08 00 00 00       	mov    $0x8,%eax
     6bc:	cd 40                	int    $0x40
     6be:	c3                   	ret    

000006bf <link>:
SYSCALL(link)
     6bf:	b8 13 00 00 00       	mov    $0x13,%eax
     6c4:	cd 40                	int    $0x40
     6c6:	c3                   	ret    

000006c7 <mkdir>:
SYSCALL(mkdir)
     6c7:	b8 14 00 00 00       	mov    $0x14,%eax
     6cc:	cd 40                	int    $0x40
     6ce:	c3                   	ret    

000006cf <chdir>:
SYSCALL(chdir)
     6cf:	b8 09 00 00 00       	mov    $0x9,%eax
     6d4:	cd 40                	int    $0x40
     6d6:	c3                   	ret    

000006d7 <dup>:
SYSCALL(dup)
     6d7:	b8 0a 00 00 00       	mov    $0xa,%eax
     6dc:	cd 40                	int    $0x40
     6de:	c3                   	ret    

000006df <getpid>:
SYSCALL(getpid)
     6df:	b8 0b 00 00 00       	mov    $0xb,%eax
     6e4:	cd 40                	int    $0x40
     6e6:	c3                   	ret    

000006e7 <sbrk>:
SYSCALL(sbrk)
     6e7:	b8 0c 00 00 00       	mov    $0xc,%eax
     6ec:	cd 40                	int    $0x40
     6ee:	c3                   	ret    

000006ef <sleep>:
SYSCALL(sleep)
     6ef:	b8 0d 00 00 00       	mov    $0xd,%eax
     6f4:	cd 40                	int    $0x40
     6f6:	c3                   	ret    

000006f7 <uptime>:
SYSCALL(uptime)
     6f7:	b8 0e 00 00 00       	mov    $0xe,%eax
     6fc:	cd 40                	int    $0x40
     6fe:	c3                   	ret    

000006ff <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     6ff:	55                   	push   %ebp
     700:	89 e5                	mov    %esp,%ebp
     702:	83 ec 18             	sub    $0x18,%esp
     705:	8b 45 0c             	mov    0xc(%ebp),%eax
     708:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     70b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     712:	00 
     713:	8d 45 f4             	lea    -0xc(%ebp),%eax
     716:	89 44 24 04          	mov    %eax,0x4(%esp)
     71a:	8b 45 08             	mov    0x8(%ebp),%eax
     71d:	89 04 24             	mov    %eax,(%esp)
     720:	e8 5a ff ff ff       	call   67f <write>
}
     725:	c9                   	leave  
     726:	c3                   	ret    

00000727 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     727:	55                   	push   %ebp
     728:	89 e5                	mov    %esp,%ebp
     72a:	56                   	push   %esi
     72b:	53                   	push   %ebx
     72c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     72f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     736:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     73a:	74 17                	je     753 <printint+0x2c>
     73c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     740:	79 11                	jns    753 <printint+0x2c>
    neg = 1;
     742:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     749:	8b 45 0c             	mov    0xc(%ebp),%eax
     74c:	f7 d8                	neg    %eax
     74e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     751:	eb 06                	jmp    759 <printint+0x32>
  } else {
    x = xx;
     753:	8b 45 0c             	mov    0xc(%ebp),%eax
     756:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     760:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     763:	8d 41 01             	lea    0x1(%ecx),%eax
     766:	89 45 f4             	mov    %eax,-0xc(%ebp)
     769:	8b 5d 10             	mov    0x10(%ebp),%ebx
     76c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     76f:	ba 00 00 00 00       	mov    $0x0,%edx
     774:	f7 f3                	div    %ebx
     776:	89 d0                	mov    %edx,%eax
     778:	0f b6 80 30 19 00 00 	movzbl 0x1930(%eax),%eax
     77f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     783:	8b 75 10             	mov    0x10(%ebp),%esi
     786:	8b 45 ec             	mov    -0x14(%ebp),%eax
     789:	ba 00 00 00 00       	mov    $0x0,%edx
     78e:	f7 f6                	div    %esi
     790:	89 45 ec             	mov    %eax,-0x14(%ebp)
     793:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     797:	75 c7                	jne    760 <printint+0x39>
  if(neg)
     799:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     79d:	74 10                	je     7af <printint+0x88>
    buf[i++] = '-';
     79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a2:	8d 50 01             	lea    0x1(%eax),%edx
     7a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
     7a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     7ad:	eb 1f                	jmp    7ce <printint+0xa7>
     7af:	eb 1d                	jmp    7ce <printint+0xa7>
    putc(fd, buf[i]);
     7b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
     7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7b7:	01 d0                	add    %edx,%eax
     7b9:	0f b6 00             	movzbl (%eax),%eax
     7bc:	0f be c0             	movsbl %al,%eax
     7bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     7c3:	8b 45 08             	mov    0x8(%ebp),%eax
     7c6:	89 04 24             	mov    %eax,(%esp)
     7c9:	e8 31 ff ff ff       	call   6ff <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     7ce:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     7d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     7d6:	79 d9                	jns    7b1 <printint+0x8a>
    putc(fd, buf[i]);
}
     7d8:	83 c4 30             	add    $0x30,%esp
     7db:	5b                   	pop    %ebx
     7dc:	5e                   	pop    %esi
     7dd:	5d                   	pop    %ebp
     7de:	c3                   	ret    

000007df <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     7df:	55                   	push   %ebp
     7e0:	89 e5                	mov    %esp,%ebp
     7e2:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     7e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     7ec:	8d 45 0c             	lea    0xc(%ebp),%eax
     7ef:	83 c0 04             	add    $0x4,%eax
     7f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     7f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7fc:	e9 7c 01 00 00       	jmp    97d <printf+0x19e>
    c = fmt[i] & 0xff;
     801:	8b 55 0c             	mov    0xc(%ebp),%edx
     804:	8b 45 f0             	mov    -0x10(%ebp),%eax
     807:	01 d0                	add    %edx,%eax
     809:	0f b6 00             	movzbl (%eax),%eax
     80c:	0f be c0             	movsbl %al,%eax
     80f:	25 ff 00 00 00       	and    $0xff,%eax
     814:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     817:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     81b:	75 2c                	jne    849 <printf+0x6a>
      if(c == '%'){
     81d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     821:	75 0c                	jne    82f <printf+0x50>
        state = '%';
     823:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     82a:	e9 4a 01 00 00       	jmp    979 <printf+0x19a>
      } else {
        putc(fd, c);
     82f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     832:	0f be c0             	movsbl %al,%eax
     835:	89 44 24 04          	mov    %eax,0x4(%esp)
     839:	8b 45 08             	mov    0x8(%ebp),%eax
     83c:	89 04 24             	mov    %eax,(%esp)
     83f:	e8 bb fe ff ff       	call   6ff <putc>
     844:	e9 30 01 00 00       	jmp    979 <printf+0x19a>
      }
    } else if(state == '%'){
     849:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     84d:	0f 85 26 01 00 00    	jne    979 <printf+0x19a>
      if(c == 'd'){
     853:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     857:	75 2d                	jne    886 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     859:	8b 45 e8             	mov    -0x18(%ebp),%eax
     85c:	8b 00                	mov    (%eax),%eax
     85e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     865:	00 
     866:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     86d:	00 
     86e:	89 44 24 04          	mov    %eax,0x4(%esp)
     872:	8b 45 08             	mov    0x8(%ebp),%eax
     875:	89 04 24             	mov    %eax,(%esp)
     878:	e8 aa fe ff ff       	call   727 <printint>
        ap++;
     87d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     881:	e9 ec 00 00 00       	jmp    972 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     886:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     88a:	74 06                	je     892 <printf+0xb3>
     88c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     890:	75 2d                	jne    8bf <printf+0xe0>
        printint(fd, *ap, 16, 0);
     892:	8b 45 e8             	mov    -0x18(%ebp),%eax
     895:	8b 00                	mov    (%eax),%eax
     897:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     89e:	00 
     89f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     8a6:	00 
     8a7:	89 44 24 04          	mov    %eax,0x4(%esp)
     8ab:	8b 45 08             	mov    0x8(%ebp),%eax
     8ae:	89 04 24             	mov    %eax,(%esp)
     8b1:	e8 71 fe ff ff       	call   727 <printint>
        ap++;
     8b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     8ba:	e9 b3 00 00 00       	jmp    972 <printf+0x193>
      } else if(c == 's'){
     8bf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     8c3:	75 45                	jne    90a <printf+0x12b>
        s = (char*)*ap;
     8c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8c8:	8b 00                	mov    (%eax),%eax
     8ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     8cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     8d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8d5:	75 09                	jne    8e0 <printf+0x101>
          s = "(null)";
     8d7:	c7 45 f4 33 12 00 00 	movl   $0x1233,-0xc(%ebp)
        while(*s != 0){
     8de:	eb 1e                	jmp    8fe <printf+0x11f>
     8e0:	eb 1c                	jmp    8fe <printf+0x11f>
          putc(fd, *s);
     8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8e5:	0f b6 00             	movzbl (%eax),%eax
     8e8:	0f be c0             	movsbl %al,%eax
     8eb:	89 44 24 04          	mov    %eax,0x4(%esp)
     8ef:	8b 45 08             	mov    0x8(%ebp),%eax
     8f2:	89 04 24             	mov    %eax,(%esp)
     8f5:	e8 05 fe ff ff       	call   6ff <putc>
          s++;
     8fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     901:	0f b6 00             	movzbl (%eax),%eax
     904:	84 c0                	test   %al,%al
     906:	75 da                	jne    8e2 <printf+0x103>
     908:	eb 68                	jmp    972 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     90a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     90e:	75 1d                	jne    92d <printf+0x14e>
        putc(fd, *ap);
     910:	8b 45 e8             	mov    -0x18(%ebp),%eax
     913:	8b 00                	mov    (%eax),%eax
     915:	0f be c0             	movsbl %al,%eax
     918:	89 44 24 04          	mov    %eax,0x4(%esp)
     91c:	8b 45 08             	mov    0x8(%ebp),%eax
     91f:	89 04 24             	mov    %eax,(%esp)
     922:	e8 d8 fd ff ff       	call   6ff <putc>
        ap++;
     927:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     92b:	eb 45                	jmp    972 <printf+0x193>
      } else if(c == '%'){
     92d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     931:	75 17                	jne    94a <printf+0x16b>
        putc(fd, c);
     933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     936:	0f be c0             	movsbl %al,%eax
     939:	89 44 24 04          	mov    %eax,0x4(%esp)
     93d:	8b 45 08             	mov    0x8(%ebp),%eax
     940:	89 04 24             	mov    %eax,(%esp)
     943:	e8 b7 fd ff ff       	call   6ff <putc>
     948:	eb 28                	jmp    972 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     94a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     951:	00 
     952:	8b 45 08             	mov    0x8(%ebp),%eax
     955:	89 04 24             	mov    %eax,(%esp)
     958:	e8 a2 fd ff ff       	call   6ff <putc>
        putc(fd, c);
     95d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     960:	0f be c0             	movsbl %al,%eax
     963:	89 44 24 04          	mov    %eax,0x4(%esp)
     967:	8b 45 08             	mov    0x8(%ebp),%eax
     96a:	89 04 24             	mov    %eax,(%esp)
     96d:	e8 8d fd ff ff       	call   6ff <putc>
      }
      state = 0;
     972:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     979:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     97d:	8b 55 0c             	mov    0xc(%ebp),%edx
     980:	8b 45 f0             	mov    -0x10(%ebp),%eax
     983:	01 d0                	add    %edx,%eax
     985:	0f b6 00             	movzbl (%eax),%eax
     988:	84 c0                	test   %al,%al
     98a:	0f 85 71 fe ff ff    	jne    801 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     990:	c9                   	leave  
     991:	c3                   	ret    

00000992 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     992:	55                   	push   %ebp
     993:	89 e5                	mov    %esp,%ebp
     995:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     998:	8b 45 08             	mov    0x8(%ebp),%eax
     99b:	83 e8 08             	sub    $0x8,%eax
     99e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     9a1:	a1 6c 19 00 00       	mov    0x196c,%eax
     9a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
     9a9:	eb 24                	jmp    9cf <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ae:	8b 00                	mov    (%eax),%eax
     9b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     9b3:	77 12                	ja     9c7 <free+0x35>
     9b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     9bb:	77 24                	ja     9e1 <free+0x4f>
     9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9c0:	8b 00                	mov    (%eax),%eax
     9c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     9c5:	77 1a                	ja     9e1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     9c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ca:	8b 00                	mov    (%eax),%eax
     9cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
     9cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     9d5:	76 d4                	jbe    9ab <free+0x19>
     9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9da:	8b 00                	mov    (%eax),%eax
     9dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     9df:	76 ca                	jbe    9ab <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     9e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9e4:	8b 40 04             	mov    0x4(%eax),%eax
     9e7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     9ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9f1:	01 c2                	add    %eax,%edx
     9f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9f6:	8b 00                	mov    (%eax),%eax
     9f8:	39 c2                	cmp    %eax,%edx
     9fa:	75 24                	jne    a20 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     9fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
     9ff:	8b 50 04             	mov    0x4(%eax),%edx
     a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a05:	8b 00                	mov    (%eax),%eax
     a07:	8b 40 04             	mov    0x4(%eax),%eax
     a0a:	01 c2                	add    %eax,%edx
     a0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a0f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a15:	8b 00                	mov    (%eax),%eax
     a17:	8b 10                	mov    (%eax),%edx
     a19:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a1c:	89 10                	mov    %edx,(%eax)
     a1e:	eb 0a                	jmp    a2a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a23:	8b 10                	mov    (%eax),%edx
     a25:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a28:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     a2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a2d:	8b 40 04             	mov    0x4(%eax),%eax
     a30:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a3a:	01 d0                	add    %edx,%eax
     a3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     a3f:	75 20                	jne    a61 <free+0xcf>
    p->s.size += bp->s.size;
     a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a44:	8b 50 04             	mov    0x4(%eax),%edx
     a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a4a:	8b 40 04             	mov    0x4(%eax),%eax
     a4d:	01 c2                	add    %eax,%edx
     a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a52:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a58:	8b 10                	mov    (%eax),%edx
     a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a5d:	89 10                	mov    %edx,(%eax)
     a5f:	eb 08                	jmp    a69 <free+0xd7>
  } else
    p->s.ptr = bp;
     a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a64:	8b 55 f8             	mov    -0x8(%ebp),%edx
     a67:	89 10                	mov    %edx,(%eax)
  freep = p;
     a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a6c:	a3 6c 19 00 00       	mov    %eax,0x196c
}
     a71:	c9                   	leave  
     a72:	c3                   	ret    

00000a73 <morecore>:

static Header*
morecore(uint nu)
{
     a73:	55                   	push   %ebp
     a74:	89 e5                	mov    %esp,%ebp
     a76:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     a79:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     a80:	77 07                	ja     a89 <morecore+0x16>
    nu = 4096;
     a82:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     a89:	8b 45 08             	mov    0x8(%ebp),%eax
     a8c:	c1 e0 03             	shl    $0x3,%eax
     a8f:	89 04 24             	mov    %eax,(%esp)
     a92:	e8 50 fc ff ff       	call   6e7 <sbrk>
     a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     a9a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     a9e:	75 07                	jne    aa7 <morecore+0x34>
    return 0;
     aa0:	b8 00 00 00 00       	mov    $0x0,%eax
     aa5:	eb 22                	jmp    ac9 <morecore+0x56>
  hp = (Header*)p;
     aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab0:	8b 55 08             	mov    0x8(%ebp),%edx
     ab3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab9:	83 c0 08             	add    $0x8,%eax
     abc:	89 04 24             	mov    %eax,(%esp)
     abf:	e8 ce fe ff ff       	call   992 <free>
  return freep;
     ac4:	a1 6c 19 00 00       	mov    0x196c,%eax
}
     ac9:	c9                   	leave  
     aca:	c3                   	ret    

00000acb <malloc>:

void*
malloc(uint nbytes)
{
     acb:	55                   	push   %ebp
     acc:	89 e5                	mov    %esp,%ebp
     ace:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     ad1:	8b 45 08             	mov    0x8(%ebp),%eax
     ad4:	83 c0 07             	add    $0x7,%eax
     ad7:	c1 e8 03             	shr    $0x3,%eax
     ada:	83 c0 01             	add    $0x1,%eax
     add:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     ae0:	a1 6c 19 00 00       	mov    0x196c,%eax
     ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ae8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     aec:	75 23                	jne    b11 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     aee:	c7 45 f0 64 19 00 00 	movl   $0x1964,-0x10(%ebp)
     af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     af8:	a3 6c 19 00 00       	mov    %eax,0x196c
     afd:	a1 6c 19 00 00       	mov    0x196c,%eax
     b02:	a3 64 19 00 00       	mov    %eax,0x1964
    base.s.size = 0;
     b07:	c7 05 68 19 00 00 00 	movl   $0x0,0x1968
     b0e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b14:	8b 00                	mov    (%eax),%eax
     b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b1c:	8b 40 04             	mov    0x4(%eax),%eax
     b1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b22:	72 4d                	jb     b71 <malloc+0xa6>
      if(p->s.size == nunits)
     b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b27:	8b 40 04             	mov    0x4(%eax),%eax
     b2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b2d:	75 0c                	jne    b3b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b32:	8b 10                	mov    (%eax),%edx
     b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b37:	89 10                	mov    %edx,(%eax)
     b39:	eb 26                	jmp    b61 <malloc+0x96>
      else {
        p->s.size -= nunits;
     b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b3e:	8b 40 04             	mov    0x4(%eax),%eax
     b41:	2b 45 ec             	sub    -0x14(%ebp),%eax
     b44:	89 c2                	mov    %eax,%edx
     b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b49:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b4f:	8b 40 04             	mov    0x4(%eax),%eax
     b52:	c1 e0 03             	shl    $0x3,%eax
     b55:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b5e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b64:	a3 6c 19 00 00       	mov    %eax,0x196c
      return (void*)(p + 1);
     b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b6c:	83 c0 08             	add    $0x8,%eax
     b6f:	eb 38                	jmp    ba9 <malloc+0xde>
    }
    if(p == freep)
     b71:	a1 6c 19 00 00       	mov    0x196c,%eax
     b76:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     b79:	75 1b                	jne    b96 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b7e:	89 04 24             	mov    %eax,(%esp)
     b81:	e8 ed fe ff ff       	call   a73 <morecore>
     b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b8d:	75 07                	jne    b96 <malloc+0xcb>
        return 0;
     b8f:	b8 00 00 00 00       	mov    $0x0,%eax
     b94:	eb 13                	jmp    ba9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b9f:	8b 00                	mov    (%eax),%eax
     ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
     ba4:	e9 70 ff ff ff       	jmp    b19 <malloc+0x4e>
}
     ba9:	c9                   	leave  
     baa:	c3                   	ret    

00000bab <findNextFreeThreadId>:
#include "x86.h"

extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
     bab:	55                   	push   %ebp
     bac:	89 e5                	mov    %esp,%ebp
     bae:	83 ec 10             	sub    $0x10,%esp
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
     bb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     bb8:	eb 17                	jmp    bd1 <findNextFreeThreadId+0x26>
		//if (threadTable.threads[i]->state == T_FREE)
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
     bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bbd:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     bc4:	85 c0                	test   %eax,%eax
     bc6:	75 05                	jne    bcd <findNextFreeThreadId+0x22>
			return i;
     bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bcb:	eb 0f                	jmp    bdc <findNextFreeThreadId+0x31>
extern void alarm(int ticks);

int findNextFreeThreadId(void)
{
	int i;
	for (i=0; i < MAX_UTHREADS; i++){
     bcd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     bd1:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
     bd5:	7e e3                	jle    bba <findNextFreeThreadId+0xf>
			//return threadTable.threads[i]->tid;
		if (threadTable.threads[i] == 0)
			return i;
			
	}
	return -1;
     bd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     bdc:	c9                   	leave  
     bdd:	c3                   	ret    

00000bde <findNextRunnableThread>:

uthread_p findNextRunnableThread()
{
     bde:	55                   	push   %ebp
     bdf:	89 e5                	mov    %esp,%ebp
     be1:	83 ec 10             	sub    $0x10,%esp
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
     be4:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     be9:	8b 00                	mov    (%eax),%eax
     beb:	8d 50 01             	lea    0x1(%eax),%edx
     bee:	89 d0                	mov    %edx,%eax
     bf0:	c1 f8 1f             	sar    $0x1f,%eax
     bf3:	c1 e8 1a             	shr    $0x1a,%eax
     bf6:	01 c2                	add    %eax,%edx
     bf8:	83 e2 3f             	and    $0x3f,%edx
     bfb:	29 c2                	sub    %eax,%edx
     bfd:	89 d0                	mov    %edx,%eax
     bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (;; i = (i + 1) % MAX_UTHREADS)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
     c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c05:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     c0c:	8b 40 28             	mov    0x28(%eax),%eax
     c0f:	83 f8 02             	cmp    $0x2,%eax
     c12:	75 0c                	jne    c20 <findNextRunnableThread+0x42>
			return threadTable.threads[i];
     c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c17:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     c1e:	eb 1c                	jmp    c3c <findNextRunnableThread+0x5e>
}

uthread_p findNextRunnableThread()
{
	int i = (threadTable.runningThread->tid + 1) % MAX_UTHREADS;
	for (;; i = (i + 1) % MAX_UTHREADS)
     c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c23:	8d 50 01             	lea    0x1(%eax),%edx
     c26:	89 d0                	mov    %edx,%eax
     c28:	c1 f8 1f             	sar    $0x1f,%eax
     c2b:	c1 e8 1a             	shr    $0x1a,%eax
     c2e:	01 c2                	add    %eax,%edx
     c30:	83 e2 3f             	and    $0x3f,%edx
     c33:	29 c2                	sub    %eax,%edx
     c35:	89 d0                	mov    %edx,%eax
     c37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	{
		if (threadTable.threads[i]->state == T_RUNNABLE)
			return threadTable.threads[i];
	}
     c3a:	eb c6                	jmp    c02 <findNextRunnableThread+0x24>
}
     c3c:	c9                   	leave  
     c3d:	c3                   	ret    

00000c3e <uthread_init>:

void uthread_init(void)
{
     c3e:	55                   	push   %ebp
     c3f:	89 e5                	mov    %esp,%ebp
     c41:	83 ec 28             	sub    $0x28,%esp
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
     c44:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     c4b:	eb 12                	jmp    c5f <uthread_init+0x21>
		/*threadTable.threads[i] = (uthread_p)malloc(sizeof(struct uthread));
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
     c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c50:	c7 04 85 a0 1d 00 00 	movl   $0x0,0x1da0(,%eax,4)
     c57:	00 00 00 00 

void uthread_init(void)
{
	// Initialize thread table
	int i;
	for (i=1; i < MAX_UTHREADS; i++){
     c5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c5f:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
     c63:	7e e8                	jle    c4d <uthread_init+0xf>
		threadTable.threads[i]->state = T_FREE;
		threadTable.threads[i]->tid = i;*/
		threadTable.threads[i] = 0;
	}
	
	threadTable.threads[0] = (uthread_p)malloc(sizeof(uthread_t));
     c65:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
     c6c:	e8 5a fe ff ff       	call   acb <malloc>
     c71:	a3 a0 1d 00 00       	mov    %eax,0x1da0
	// Initialize main thread
	STORE_ESP(threadTable.threads[0]->esp);
     c76:	a1 a0 1d 00 00       	mov    0x1da0,%eax
     c7b:	89 e2                	mov    %esp,%edx
     c7d:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.threads[0]->ebp);
     c80:	a1 a0 1d 00 00       	mov    0x1da0,%eax
     c85:	89 ea                	mov    %ebp,%edx
     c87:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.threads[0]->state = T_RUNNING;
     c8a:	a1 a0 1d 00 00       	mov    0x1da0,%eax
     c8f:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	threadTable.runningThread = threadTable.threads[0];
     c96:	a1 a0 1d 00 00       	mov    0x1da0,%eax
     c9b:	a3 a0 1e 00 00       	mov    %eax,0x1ea0
	threadTable.threadCount = 1;
     ca0:	c7 05 a4 1e 00 00 01 	movl   $0x1,0x1ea4
     ca7:	00 00 00 
	
	signal(SIGALRM, uthread_yield);
     caa:	c7 44 24 04 83 0e 00 	movl   $0xe83,0x4(%esp)
     cb1:	00 
     cb2:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
     cb9:	e8 99 f9 ff ff       	call   657 <signal>
	alarm(UTHREAD_QUANTA);
     cbe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     cc5:	e8 9d f9 ff ff       	call   667 <alarm>
}
     cca:	c9                   	leave  
     ccb:	c3                   	ret    

00000ccc <uthread_create>:

int  uthread_create(void (*func)(void *), void* value)
{
     ccc:	55                   	push   %ebp
     ccd:	89 e5                	mov    %esp,%ebp
     ccf:	53                   	push   %ebx
     cd0:	83 ec 24             	sub    $0x24,%esp
	alarm(0);
     cd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     cda:	e8 88 f9 ff ff       	call   667 <alarm>
	//int espBackup,ebpBackup;
	// Find next available thread slot
	int current = findNextFreeThreadId();
     cdf:	e8 c7 fe ff ff       	call   bab <findNextFreeThreadId>
     ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (current == -1)
     ce7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     ceb:	75 0a                	jne    cf7 <uthread_create+0x2b>
		return -1;
     ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cf2:	e9 d6 00 00 00       	jmp    dcd <uthread_create+0x101>
	
	threadTable.threads[current] = (uthread_p)malloc(sizeof(uthread_t));
     cf7:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
     cfe:	e8 c8 fd ff ff       	call   acb <malloc>
     d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d06:	89 04 95 a0 1d 00 00 	mov    %eax,0x1da0(,%edx,4)
	threadTable.threads[current]->tid = current;
     d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d10:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d1a:	89 10                	mov    %edx,(%eax)
	threadTable.threads[current]->firstrun = 1;
     d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d1f:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     d26:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
	threadTable.threadCount++;
     d2d:	a1 a4 1e 00 00       	mov    0x1ea4,%eax
     d32:	83 c0 01             	add    $0x1,%eax
     d35:	a3 a4 1e 00 00       	mov    %eax,0x1ea4
	threadTable.threads[current]->entry = func;
     d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d3d:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     d44:	8b 55 08             	mov    0x8(%ebp),%edx
     d47:	89 50 30             	mov    %edx,0x30(%eax)
	threadTable.threads[current]->value = value;
     d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d4d:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     d54:	8b 55 0c             	mov    0xc(%ebp),%edx
     d57:	89 50 34             	mov    %edx,0x34(%eax)
	threadTable.threads[current]->stack = (void*)malloc(STACK_SIZE);
     d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d5d:	8b 1c 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%ebx
     d64:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     d6b:	e8 5b fd ff ff       	call   acb <malloc>
     d70:	89 43 24             	mov    %eax,0x24(%ebx)
	threadTable.threads[current]->esp = (int)threadTable.threads[current]->stack + (STACK_SIZE-4);
     d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d76:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d80:	8b 14 95 a0 1d 00 00 	mov    0x1da0(,%edx,4),%edx
     d87:	8b 52 24             	mov    0x24(%edx),%edx
     d8a:	81 c2 fc 0f 00 00    	add    $0xffc,%edx
     d90:	89 50 04             	mov    %edx,0x4(%eax)
	threadTable.threads[current]->ebp = threadTable.threads[current]->esp;
     d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d96:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     d9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     da0:	8b 14 95 a0 1d 00 00 	mov    0x1da0(,%edx,4),%edx
     da7:	8b 52 04             	mov    0x4(%edx),%edx
     daa:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"*** new thread tid = %d entry = %x esp = %x ebp = %x\n",threadTable.threads[current]->tid,threadTable.threads[current]->entry,threadTable.threads[current]->esp,threadTable.threads[current]->ebp);
	
	// Set state for new thread and return it's ID
	threadTable.threads[current]->state = T_RUNNABLE;
     dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     db0:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     db7:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	alarm(UTHREAD_QUANTA);
     dbe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     dc5:	e8 9d f8 ff ff       	call   667 <alarm>
	return current;
     dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     dcd:	83 c4 24             	add    $0x24,%esp
     dd0:	5b                   	pop    %ebx
     dd1:	5d                   	pop    %ebp
     dd2:	c3                   	ret    

00000dd3 <uthread_exit>:

void uthread_exit(void)
{
     dd3:	55                   	push   %ebp
     dd4:	89 e5                	mov    %esp,%ebp
     dd6:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"*** thread %d exiting ***\n",threadTable.runningThread->tid);
	
	
	// Free current thread's stack space
	if (threadTable.runningThread->tid)
     dd9:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     dde:	8b 00                	mov    (%eax),%eax
     de0:	85 c0                	test   %eax,%eax
     de2:	74 10                	je     df4 <uthread_exit+0x21>
		free(threadTable.runningThread->stack);
     de4:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     de9:	8b 40 24             	mov    0x24(%eax),%eax
     dec:	89 04 24             	mov    %eax,(%esp)
     def:	e8 9e fb ff ff       	call   992 <free>
		
	threadTable.threads[threadTable.runningThread->tid] = 0;
     df4:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     df9:	8b 00                	mov    (%eax),%eax
     dfb:	c7 04 85 a0 1d 00 00 	movl   $0x0,0x1da0(,%eax,4)
     e02:	00 00 00 00 
	
	free(threadTable.runningThread);
     e06:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e0b:	89 04 24             	mov    %eax,(%esp)
     e0e:	e8 7f fb ff ff       	call   992 <free>
	
	// Set state of thread as FREE
	//threadTable.runningThread->state = T_FREE;
	
	// Update number of running threads
	threadTable.threadCount--;
     e13:	a1 a4 1e 00 00       	mov    0x1ea4,%eax
     e18:	83 e8 01             	sub    $0x1,%eax
     e1b:	a3 a4 1e 00 00       	mov    %eax,0x1ea4
	
	// DEBUG PRINT
	//printf(1,"threadTable.threadCount = %d\n",threadTable.threadCount);
	
	if (threadTable.threadCount == 0){
     e20:	a1 a4 1e 00 00       	mov    0x1ea4,%eax
     e25:	85 c0                	test   %eax,%eax
     e27:	75 05                	jne    e2e <uthread_exit+0x5b>
		// DEBUG PRINT
		// printf(1,"threadTable.threadCount = 0 , FREEING ALL RESOURCES!\n");
		//int i=0;
		//for (i=0;i<MAX_UTHREADS;i++)
			//free(threadTable.threads[i]);
		exit();
     e29:	e8 19 f8 ff ff       	call   647 <exit>
	}
		
	// If we still got threads left, yield
	threadTable.runningThread = findNextRunnableThread();
     e2e:	e8 ab fd ff ff       	call   bde <findNextRunnableThread>
     e33:	a3 a0 1e 00 00       	mov    %eax,0x1ea0
	
	threadTable.runningThread->state = T_RUNNING;
     e38:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e3d:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	alarm(UTHREAD_QUANTA);
     e44:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     e4b:	e8 17 f8 ff ff       	call   667 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
     e50:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e55:	8b 40 04             	mov    0x4(%eax),%eax
     e58:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
     e5a:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e5f:	8b 40 08             	mov    0x8(%eax),%eax
     e62:	89 c5                	mov    %eax,%ebp
	
	if (threadTable.runningThread->firstrun){
     e64:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e69:	8b 40 2c             	mov    0x2c(%eax),%eax
     e6c:	85 c0                	test   %eax,%eax
     e6e:	74 11                	je     e81 <uthread_exit+0xae>
		threadTable.runningThread->firstrun = 0;
     e70:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e75:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		wrapper();
     e7c:	e8 8e 00 00 00       	call   f0f <wrapper>
	}
	

}
     e81:	c9                   	leave  
     e82:	c3                   	ret    

00000e83 <uthread_yield>:

void uthread_yield(void)
{
     e83:	55                   	push   %ebp
     e84:	89 e5                	mov    %esp,%ebp
     e86:	83 ec 18             	sub    $0x18,%esp
	// DEBUG PRINT
	//printf(1,"entered uthread_yield()\n");

	STORE_ESP(threadTable.runningThread->esp);
     e89:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e8e:	89 e2                	mov    %esp,%edx
     e90:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
     e93:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     e98:	89 ea                	mov    %ebp,%edx
     e9a:	89 50 08             	mov    %edx,0x8(%eax)
	
	// DEBUG PRINT
	//printf(1,"current thread id is %d\n",threadTable.runningThread->tid);

	if (threadTable.runningThread->state == T_RUNNING)
     e9d:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     ea2:	8b 40 28             	mov    0x28(%eax),%eax
     ea5:	83 f8 01             	cmp    $0x1,%eax
     ea8:	75 0c                	jne    eb6 <uthread_yield+0x33>
		threadTable.runningThread->state = T_RUNNABLE;
     eaa:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     eaf:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	

	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
     eb6:	e8 23 fd ff ff       	call   bde <findNextRunnableThread>
     ebb:	a3 a0 1e 00 00       	mov    %eax,0x1ea0
	threadTable.runningThread->state = T_RUNNING;
     ec0:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     ec5:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	//printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	//printf(1,"next->entry = %x , next->esp = %x , next->ebp = %x\n",threadTable.runningThread->entry,threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
     ecc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     ed3:	e8 8f f7 ff ff       	call   667 <alarm>
	LOAD_ESP(threadTable.runningThread->esp);
     ed8:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     edd:	8b 40 04             	mov    0x4(%eax),%eax
     ee0:	89 c4                	mov    %eax,%esp
	LOAD_EBP(threadTable.runningThread->ebp);
     ee2:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     ee7:	8b 40 08             	mov    0x8(%eax),%eax
     eea:	89 c5                	mov    %eax,%ebp
	if (threadTable.runningThread->firstrun){
     eec:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     ef1:	8b 40 2c             	mov    0x2c(%eax),%eax
     ef4:	85 c0                	test   %eax,%eax
     ef6:	74 14                	je     f0c <uthread_yield+0x89>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
     ef8:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     efd:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
     f04:	b8 0f 0f 00 00       	mov    $0xf0f,%eax
     f09:	ff d0                	call   *%eax
		asm("ret");
     f0b:	c3                   	ret    
	}
	return;
     f0c:	90                   	nop
}
     f0d:	c9                   	leave  
     f0e:	c3                   	ret    

00000f0f <wrapper>:

void wrapper(void) {
     f0f:	55                   	push   %ebp
     f10:	89 e5                	mov    %esp,%ebp
     f12:	83 ec 18             	sub    $0x18,%esp
	threadTable.runningThread->entry(threadTable.runningThread->value);
     f15:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     f1a:	8b 40 30             	mov    0x30(%eax),%eax
     f1d:	8b 15 a0 1e 00 00    	mov    0x1ea0,%edx
     f23:	8b 52 34             	mov    0x34(%edx),%edx
     f26:	89 14 24             	mov    %edx,(%esp)
     f29:	ff d0                	call   *%eax
	uthread_exit();
     f2b:	e8 a3 fe ff ff       	call   dd3 <uthread_exit>
}
     f30:	c9                   	leave  
     f31:	c3                   	ret    

00000f32 <uthread_self>:

int uthread_self(void)
{
     f32:	55                   	push   %ebp
     f33:	89 e5                	mov    %esp,%ebp
	return threadTable.runningThread->tid;
     f35:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     f3a:	8b 00                	mov    (%eax),%eax
}
     f3c:	5d                   	pop    %ebp
     f3d:	c3                   	ret    

00000f3e <uthread_join>:

int uthread_join(int tid)
{
     f3e:	55                   	push   %ebp
     f3f:	89 e5                	mov    %esp,%ebp
	if (tid > MAX_UTHREADS)
     f41:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
     f45:	7e 07                	jle    f4e <uthread_join+0x10>
		return -1;
     f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f4c:	eb 14                	jmp    f62 <uthread_join+0x24>
	//while (threadTable.threads[tid]->state != T_FREE){}
	while (threadTable.threads[tid]) {}
     f4e:	90                   	nop
     f4f:	8b 45 08             	mov    0x8(%ebp),%eax
     f52:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
     f59:	85 c0                	test   %eax,%eax
     f5b:	75 f2                	jne    f4f <uthread_join+0x11>
	return 0;
     f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     f62:	5d                   	pop    %ebp
     f63:	c3                   	ret    

00000f64 <uthread_sleep>:

void uthread_sleep(void)
{
     f64:	55                   	push   %ebp
     f65:	89 e5                	mov    %esp,%ebp
     f67:	83 ec 18             	sub    $0x18,%esp
	
	// Store stack pointers
	STORE_ESP(threadTable.runningThread->esp);
     f6a:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     f6f:	89 e2                	mov    %esp,%edx
     f71:	89 50 04             	mov    %edx,0x4(%eax)
	STORE_EBP(threadTable.runningThread->ebp);
     f74:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     f79:	89 ea                	mov    %ebp,%edx
     f7b:	89 50 08             	mov    %edx,0x8(%eax)
	
	threadTable.runningThread->state = T_SLEEPING;
     f7e:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     f83:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	printf(1,"thread %d is now sleeping\n",threadTable.runningThread->tid);
     f8a:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     f8f:	8b 00                	mov    (%eax),%eax
     f91:	89 44 24 08          	mov    %eax,0x8(%esp)
     f95:	c7 44 24 04 3a 12 00 	movl   $0x123a,0x4(%esp)
     f9c:	00 
     f9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fa4:	e8 36 f8 ff ff       	call   7df <printf>
	
	// Pop context of next thread 	
	threadTable.runningThread = findNextRunnableThread();
     fa9:	e8 30 fc ff ff       	call   bde <findNextRunnableThread>
     fae:	a3 a0 1e 00 00       	mov    %eax,0x1ea0
	threadTable.runningThread->state = T_RUNNING;
     fb3:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     fb8:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"next thread id is %d\n",threadTable.runningThread->tid);
	// printf(1,"loaded esp and ebp. next->esp = %x , next->ebp = %x\n",threadTable.runningThread->esp,threadTable.runningThread->ebp);
	
	alarm(UTHREAD_QUANTA);
     fbf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     fc6:	e8 9c f6 ff ff       	call   667 <alarm>
	LOAD_EBP(threadTable.runningThread->ebp);
     fcb:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     fd0:	8b 40 08             	mov    0x8(%eax),%eax
     fd3:	89 c5                	mov    %eax,%ebp
	LOAD_ESP(threadTable.runningThread->esp);
     fd5:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     fda:	8b 40 04             	mov    0x4(%eax),%eax
     fdd:	89 c4                	mov    %eax,%esp
	if (threadTable.runningThread->firstrun){
     fdf:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     fe4:	8b 40 2c             	mov    0x2c(%eax),%eax
     fe7:	85 c0                	test   %eax,%eax
     fe9:	74 14                	je     fff <uthread_sleep+0x9b>
		// DEBUG PRINT
		// printf(1,"FIRST RUN OF THREAD %d\n",threadTable.runningThread->tid);
		threadTable.runningThread->firstrun = 0;
     feb:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
     ff0:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
		CALL(wrapper);
     ff7:	b8 0f 0f 00 00       	mov    $0xf0f,%eax
     ffc:	ff d0                	call   *%eax
		asm("ret");
     ffe:	c3                   	ret    
	}
	return;	
     fff:	90                   	nop
}
    1000:	c9                   	leave  
    1001:	c3                   	ret    

00001002 <uthread_wakeup>:
void uthread_wakeup(int tid)
{
    1002:	55                   	push   %ebp
    1003:	89 e5                	mov    %esp,%ebp
	threadTable.threads[tid]->state = T_RUNNABLE;
    1005:	8b 45 08             	mov    0x8(%ebp),%eax
    1008:	8b 04 85 a0 1d 00 00 	mov    0x1da0(,%eax,4),%eax
    100f:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
	// DEBUG PRINT
	// printf(1,"woke up thread %d and it is now runnable\n",threadTable.threads[tid]->tid);
}
    1016:	5d                   	pop    %ebp
    1017:	c3                   	ret    

00001018 <printQueue>:
}

*/

void printQueue(struct binary_semaphore* semaphore)
{
    1018:	55                   	push   %ebp
    1019:	89 e5                	mov    %esp,%ebp
    101b:	83 ec 28             	sub    $0x28,%esp
	printf(1,"*** WAITING QUEUE ***\n");
    101e:	c7 44 24 04 55 12 00 	movl   $0x1255,0x4(%esp)
    1025:	00 
    1026:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    102d:	e8 ad f7 ff ff       	call   7df <printf>
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    1032:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1039:	eb 26                	jmp    1061 <printQueue+0x49>
			printf(1,"%d ",semaphore->waiting[i]);
    103b:	8b 45 08             	mov    0x8(%ebp),%eax
    103e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1041:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1045:	89 44 24 08          	mov    %eax,0x8(%esp)
    1049:	c7 44 24 04 6c 12 00 	movl   $0x126c,0x4(%esp)
    1050:	00 
    1051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1058:	e8 82 f7 ff ff       	call   7df <printf>

void printQueue(struct binary_semaphore* semaphore)
{
	printf(1,"*** WAITING QUEUE ***\n");
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    105d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1061:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    1065:	7e d4                	jle    103b <printQueue+0x23>
			printf(1,"%d ",semaphore->waiting[i]);
	}
	printf(1,"\n*** WAITING QUEUE ***\n");	
    1067:	c7 44 24 04 70 12 00 	movl   $0x1270,0x4(%esp)
    106e:	00 
    106f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1076:	e8 64 f7 ff ff       	call   7df <printf>
}
    107b:	c9                   	leave  
    107c:	c3                   	ret    

0000107d <binary_semaphore_init>:

void binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
    107d:	55                   	push   %ebp
    107e:	89 e5                	mov    %esp,%ebp
    1080:	83 ec 10             	sub    $0x10,%esp
	
	
	semaphore->value = value;
    1083:	8b 45 08             	mov    0x8(%ebp),%eax
    1086:	8b 55 0c             	mov    0xc(%ebp),%edx
    1089:	89 10                	mov    %edx,(%eax)
	
	
	semaphore->counter = 0;
    108b:	8b 45 08             	mov    0x8(%ebp),%eax
    108e:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
    1095:	00 00 00 
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    1098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    109f:	eb 12                	jmp    10b3 <binary_semaphore_init+0x36>
		semaphore->waiting[i] = -1;
    10a1:	8b 45 08             	mov    0x8(%ebp),%eax
    10a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10a7:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
    10ae:	ff 
	semaphore->value = value;
	
	
	semaphore->counter = 0;
	int i;
	for (i=0;i<MAX_UTHREADS;i++){
    10af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10b3:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%ebp)
    10b7:	7e e8                	jle    10a1 <binary_semaphore_init+0x24>
		semaphore->waiting[i] = -1;
	}
}
    10b9:	c9                   	leave  
    10ba:	c3                   	ret    

000010bb <binary_semaphore_down>:

void binary_semaphore_down(struct binary_semaphore* semaphore)
{
    10bb:	55                   	push   %ebp
    10bc:	89 e5                	mov    %esp,%ebp
    10be:	53                   	push   %ebx
    10bf:	83 ec 14             	sub    $0x14,%esp
	alarm(0);
    10c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10c9:	e8 99 f5 ff ff       	call   667 <alarm>
	if (semaphore->value ==0){
    10ce:	8b 45 08             	mov    0x8(%ebp),%eax
    10d1:	8b 00                	mov    (%eax),%eax
    10d3:	85 c0                	test   %eax,%eax
    10d5:	75 34                	jne    110b <binary_semaphore_down+0x50>
		semaphore->waiting[threadTable.runningThread->tid] = semaphore->counter++;
    10d7:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
    10dc:	8b 08                	mov    (%eax),%ecx
    10de:	8b 45 08             	mov    0x8(%ebp),%eax
    10e1:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
    10e7:	8d 58 01             	lea    0x1(%eax),%ebx
    10ea:	8b 55 08             	mov    0x8(%ebp),%edx
    10ed:	89 9a 04 01 00 00    	mov    %ebx,0x104(%edx)
    10f3:	8b 55 08             	mov    0x8(%ebp),%edx
    10f6:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
		//printf(1,"*** thread %d going to sleep ***\n",threadTable.runningThread->tid);
		threadTable.runningThread->state = T_SLEEPING; // TESTING
    10fa:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
    10ff:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
		uthread_yield(); // TESTING
    1106:	e8 78 fd ff ff       	call   e83 <uthread_yield>
	}
	semaphore->waiting[threadTable.runningThread->tid] = -1;
    110b:	a1 a0 1e 00 00       	mov    0x1ea0,%eax
    1110:	8b 10                	mov    (%eax),%edx
    1112:	8b 45 08             	mov    0x8(%ebp),%eax
    1115:	c7 44 90 04 ff ff ff 	movl   $0xffffffff,0x4(%eax,%edx,4)
    111c:	ff 
	semaphore->value = 0;
    111d:	8b 45 08             	mov    0x8(%ebp),%eax
    1120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	alarm(UTHREAD_QUANTA);
    1126:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    112d:	e8 35 f5 ff ff       	call   667 <alarm>
}
    1132:	83 c4 14             	add    $0x14,%esp
    1135:	5b                   	pop    %ebx
    1136:	5d                   	pop    %ebp
    1137:	c3                   	ret    

00001138 <binary_semaphore_up>:

void binary_semaphore_up(struct binary_semaphore* semaphore)
{
    1138:	55                   	push   %ebp
    1139:	89 e5                	mov    %esp,%ebp
    113b:	83 ec 28             	sub    $0x28,%esp
	alarm(0);
    113e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1145:	e8 1d f5 ff ff       	call   667 <alarm>
	
	if (semaphore->value == 0){
    114a:	8b 45 08             	mov    0x8(%ebp),%eax
    114d:	8b 00                	mov    (%eax),%eax
    114f:	85 c0                	test   %eax,%eax
    1151:	75 71                	jne    11c4 <binary_semaphore_up+0x8c>
		
		int i;
		int minNum = semaphore->counter;
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
    1156:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
    115c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int minIndex = -1;
    115f:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
		for (i=0;i<MAX_UTHREADS;i++){
    1166:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    116d:	eb 35                	jmp    11a4 <binary_semaphore_up+0x6c>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
    116f:	8b 45 08             	mov    0x8(%ebp),%eax
    1172:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1175:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1179:	83 f8 ff             	cmp    $0xffffffff,%eax
    117c:	74 22                	je     11a0 <binary_semaphore_up+0x68>
    117e:	8b 45 08             	mov    0x8(%ebp),%eax
    1181:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1184:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1188:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    118b:	7d 13                	jge    11a0 <binary_semaphore_up+0x68>
				minIndex = i;
    118d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1190:	89 45 ec             	mov    %eax,-0x14(%ebp)
				minNum = semaphore->waiting[i];
    1193:	8b 45 08             	mov    0x8(%ebp),%eax
    1196:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1199:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    119d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (semaphore->value == 0){
		
		int i;
		int minNum = semaphore->counter;
		int minIndex = -1;
		for (i=0;i<MAX_UTHREADS;i++){
    11a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11a4:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
    11a8:	7e c5                	jle    116f <binary_semaphore_up+0x37>
			if (semaphore->waiting[i] != -1 && semaphore->waiting[i] < minNum){
				minIndex = i;
				minNum = semaphore->waiting[i];
			}
		}
		semaphore->value = 1;
    11aa:	8b 45 08             	mov    0x8(%ebp),%eax
    11ad:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		//printQueue(semaphore);
		if (minIndex != -1){
    11b3:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
    11b7:	74 0b                	je     11c4 <binary_semaphore_up+0x8c>
			uthread_wakeup(minIndex);
    11b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    11bc:	89 04 24             	mov    %eax,(%esp)
    11bf:	e8 3e fe ff ff       	call   1002 <uthread_wakeup>
		}
		
	}
	
	alarm(UTHREAD_QUANTA);
    11c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    11cb:	e8 97 f4 ff ff       	call   667 <alarm>
	
    11d0:	c9                   	leave  
    11d1:	c3                   	ret    
