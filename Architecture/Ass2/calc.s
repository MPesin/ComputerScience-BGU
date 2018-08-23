section	.rodata 
    LC0: DB	">>calc: ", 0	; Format string
    ERROR1: DB	"Error: Insufficient Number of Arguments on Stack", 10 , 0
    ERROR2: DB	"Error: Operand Stack Overflow", 10 , 0
    ERROR3: DB	"Error: Illegal Input", 10 , 0
    STACK_LEN EQU 5
    LC1: DB	"%02X", 0	; Format string
    LC2: DB	"", 10,0
    LC3: DB	">>%x", 0	; Format string
    LC4: DB	">>%d", 10,0
    LC5: DB	"debug info- user input: %s",0
    LC6: DB	"debug info- operand being inserted: ",0


section .bss
    INPUT RESB 80
    PREV_LINK RESB 4
    HEAD_LINK RESB 4
    HELPER RESB 4
    HELPER1 RESB 1
    CARRY RESB 4


section .data 
    MY_EBP TIMES STACK_LEN DD 0
    STACK_OFFSET DB 0 ;points to the next slot to add a new operand, in order to get top operand in stack use STACK_OFFSET-4
    ACTION_COUNTER DD 0
    DEBUG DB 0

section .text
    global main 
    extern printf 
    extern fprintf 
    extern malloc 
    extern free
    extern fgets 
    extern stderr 
    extern stdin 
    extern stdout 




main:

    mov ecx,[esp+4]; argc
    mov ebx,[esp+8]; argv 

    cmp ecx,1
    je start
    mov edx,0
    mov edx,dword[ebx+4]
    mov eax,0
    mov al,byte[edx]
    mov ebx,0
    mov bl, byte[edx+1]
    cmp al,'-'
    jne start
    cmp bl,'d'
    jne start
    inc byte[DEBUG]
    
start:
    call read   

plus:		
    cmp byte [INPUT], '+'
    jne qq
    call addition
    jmp start
qq:
    cmp byte [INPUT], 'q'
    jne pnp
    jmp quit
pnp:
    cmp byte [INPUT], 'p'
    jne dup
    call pop_and_print
    jmp start
dup:
    cmp byte [INPUT], 'd'
    jne else
    call duplicate
    jmp start

else:
    mov eax,0
    mov al, [INPUT]
    cmp al,'0'
    jb invalid_input
    cmp al,'9'
    ja invalid_input
    jmp valid_input
    
    invalid_input:
        push ERROR3
        call printf
        add esp,4
        jmp start
    
    valid_input:
        cmp byte [DEBUG],0
        je next
        push ebp
        push INPUT
        push LC5
        push dword[stderr]		
        call fprintf	
        add esp,12
        pop ebp
    
    next:   
    mov cl,STACK_LEN
    shl ecx,2    
    cmp byte [STACK_OFFSET],cl
    jne cont_make_operand
    push ERROR2
    call printf
    add esp,4
    jmp start
    
    
    
    cont_make_operand:
        mov esi,0    ;holds the length of the input string
        
    start_count:	
        cmp byte [INPUT+esi], 0
        je end_count
        inc esi
        jmp start_count
        
    end_count:
        dec esi
        mov eax,esi
        and eax,1
        cmp eax,1
        jne even
    
    odd:     
        push esi
        push 5
        call malloc ; now eax holds the address of the first byte of the current operand node
        add esp,4 
        pop esi       
        mov ecx,0
        sub byte [INPUT],48
        add cl, byte [INPUT] ;first char in input
        mov byte [eax],cl ; mov data to first link
        mov dword[HEAD_LINK],eax
        mov dword[PREV_LINK],eax
        mov edx,1
        jmp start_create_list   
    
    even:
        mov edx,0
    
    start_create_list:
        cmp edx, esi
        jae end_create_list        
        push esi
        push edx
        push 5
        call malloc ; now eax holds the address of the first byte of the current operand node
        add esp,4 
        pop edx
        pop esi        
        cmp edx,0
        ja cont1
        mov dword [HEAD_LINK], eax    
    
    cont1:
        cmp edx,0
        je cont2
        mov ecx, dword [PREV_LINK]
        mov dword [ecx+1], eax
    
    cont2:
        mov ecx,0
        sub byte [INPUT+edx],48
        add cl , [INPUT+edx]
        shl cl,4
        sub byte [INPUT+edx+1],48
        add cl , [INPUT+edx+1]
        add edx,2
        mov byte [eax], cl    ; mov 2 digits to node data
        mov dword [PREV_LINK], eax
        jmp start_create_list
    
    
    end_create_list:  
        mov dword [eax+1],0 ;set last link to point to null
        mov ecx, 0
        mov cl, byte [STACK_OFFSET]
        mov edx, dword [HEAD_LINK]
        mov dword [MY_EBP+ecx], edx
        add byte [STACK_OFFSET],4
        jmp start
    
    read:    
        push ebp
        mov ebp,esp
        push LC0
        call printf
        add esp, 4
        push dword [stdin]
        push 80
        push INPUT
        call fgets
        mov esp,ebp
        pop ebp
        ret
    
    pop_and_print:    
        cmp byte [STACK_OFFSET],0
        jne cont_pop
        push ERROR1
        call printf
        add esp,4
        ret
    
    cont_pop:    
        mov eax, 0
        mov al, byte [STACK_OFFSET]
        sub al,4 
        mov ebx, dword [MY_EBP+eax]; ebx hold the address of the top operand in my stack for printing
        sub byte [STACK_OFFSET],4 ; now top of my stack is the prev operand
        
        push ebx
        call get_operand_len
        pop ebx
        
        cmp eax,1
        ja cont_pop4
        mov ecx,0
        mov cl,[ebx]
        push ecx
        push LC3
        call printf
        add esp,8
        
        push LC2
        call printf
        add esp,4
        inc dword[ACTION_COUNTER]
        
        ret
        
    cont_pop4:
        mov edx,0 ;counter 
    
    test1:
        cmp dword[ebx+1],0
        je end_pop    
        cmp edx,0
        je cont_pop1
        mov ecx,0
        mov cl, byte [ebx] ; cl get data of the current node of the operand
        push ecx
        push LC1
        call printf
        add esp,8
        jmp cont_pop2
    
    cont_pop1:
        mov ecx,0
        mov cl, byte [ebx] ; cl get data of the current node of the operand
        push ecx
        push LC3
        call printf
        add esp,8
        jmp cont_pop2
    
    cont_pop2:
        mov esi,[ebx+1]
        mov ebx,esi
        jmp test1
        inc edx
    
    end_pop:    
        mov ecx,0
        mov cl, byte [ebx] ; cl get data of the current node of the operand
        push ecx
        push LC1
        call printf
        add esp,8    
        push LC2
        call printf
        add esp,4    
        inc dword[ACTION_COUNTER]
        ret
    
    
    duplicate:
        cmp byte [STACK_OFFSET],0 ; checks if my stack is empty
        jne cont_dup
        push ERROR1
        call printf
        add esp,4
        ret
    
    cont_dup: ; checks if my stack is full
        mov ecx,0
        mov cl, byte [STACK_OFFSET]
        shr ecx,2
        cmp ecx, STACK_LEN
        jne cont_dup2
        push ERROR2
        call printf
        add esp,4
        ret
    
    cont_dup2:    
        mov eax, 0
        mov al, byte [STACK_OFFSET]
        sub al,4 
        mov ebx, dword [MY_EBP+eax]; ebx hold the address of the top operand in my stack for printing
        mov edx,0 ; number of the current elemnet of the operand (0 is msb and lengh-1 is lsb)
        mov esi, dword [ebx+1] ;esi hold the address to the next link of the top operand
    
    start_op_len:
        cmp esi,0
        je end_op_len
        inc edx
        mov ecx, esi ;mov address of next link to esi
        mov esi, dword [ecx+1]
        jmp start_op_len
        
    end_op_len:    
        inc edx    
        mov eax, 0
        mov al, byte [STACK_OFFSET]
        sub al,4 
        mov ebx, dword [MY_EBP+eax]; ebx hold the address of the top operand in my stack for printing
        mov edx,0 ; number of the current elemnet of the operand (0 is msb and lengh-1 is lsb)
        mov esi, dword [ebx+1] ;esi hold the address to the next link of the top operand
    
    start_operand:
        cmp edx,0
        je end_of_operand
        push edx
        push ebx
        push esi
        push 5
        call malloc ; now eax holds the address of the first byte of the current operand node
        add esp,4 
        pop esi
        pop ebx
        pop edx
        cmp edx,0
        ja cont_dup3
        mov dword[HEAD_LINK], eax 
    
    cont_dup3:
        cmp edx,0
        je cont_dup4
        mov ecx, dword [PREV_LINK] 
        mov dword [ecx+1], eax 
        
    cont_dup4:
        mov dword [PREV_LINK], eax
        mov ecx,0
        mov cl, byte [ebx]   ;copy data to new operand
        mov byte [eax], cl
        dec edx
        mov ecx, esi ;mov address of next link to esi
        mov esi, dword [ecx+1]
        jmp start_operand    
    
    end_of_operand:
        mov eax, 0
        mov al, byte [STACK_OFFSET]
        mov ecx, dword[HEAD_LINK]
        mov dword [MY_EBP+eax], ecx
        add byte [STACK_OFFSET],4    
        inc dword[ACTION_COUNTER]
    
    test2:
        cmp byte [DEBUG],0
        je dup_no_debug        
        push ebp
        push LC6
        push dword[stderr]		
        call fprintf	
        add esp,8
        pop ebp        
        mov edx, 0
        mov dl, byte [STACK_OFFSET]
        sub dl,4 
        mov ebx, dword [MY_EBP+edx]; 
    
    start_insert_debug:
        cmp ebx,0
        je end_insert_debug    
        mov eax,0
        mov al,[ebx]
        push ebp
        push eax
        push LC1
        push dword[stderr]
        call fprintf
        add esp,12
        pop ebp    
        mov esi,[ebx+1]
        mov ebx,esi
        jmp start_insert_debug
    
    end_insert_debug:
        push LC2
        push dword[stderr]
        call fprintf
        add esp,8
        
    dup_no_debug:
        ret
    
    
    
    addition:    
        cmp byte [STACK_OFFSET],8
        jae cont_add8
        push ERROR1
        call printf
        add esp,4
        ret
        
    cont_add8:
        mov dword[HEAD_LINK],0
        mov dword[PREV_LINK],0
        mov edx, 0
        mov dl, byte [STACK_OFFSET]
        sub dl,4 
        mov ebx, dword [MY_EBP+edx]; ebx hold the address of 1st arg to add
        sub dl,4
        mov ecx, dword [MY_EBP+edx]; ebx hold the address of 2nd arg to add
        
        ;-----------------------start- reverse operands if requrired------------------------------
        push ecx
        push ebx
        call get_operand_len
        pop ebx
        pop ecx        
        cmp eax,1
        je skip_ebx_reverse        
        push ecx
        push ebx
        call reverse ; eax holds reverse(ebx)
        add esp,4
        pop ecx
        mov ebx,eax
    
    skip_ebx_reverse:    
        push ebx
        push ecx
        call get_operand_len
        pop ecx
        pop ebx        
        cmp eax,1
        je skip_ecx_reverse
        push ebx
        push ecx
        call reverse ; eax holds reverse(ecx)
        add esp,4
        pop ebx
        mov ecx,eax
        ; ebx and ecx hold pointers to the add args after reverse
    
    
    
    
    ;-----------------------end- reverse operands if requrired------------------------------
    
    
    ;-----------------------start-main addition---------------------------------
    skip_ecx_reverse:
        mov dword[CARRY],0
        mov esi,0 ;hold 1 for carry
        mov byte[HELPER1],0
        mov byte[PREV_LINK],0
        
    start_add:
        cmp dword[ebx+1],0
        je end_add
        cmp dword[ecx+1],0
        je end_add
        mov edx,0
        mov eax,0
        mov dl, byte[ebx]
        mov al,	byte[ecx]
        
        mov esi,[CARRY]
        cmp esi,0
        je no_carry1
        add al,1
        daa
        
    no_carry1:    
        add al,dl
        daa   
        mov esi,0
        adc esi,0
        mov [CARRY],esi
        mov dl,al
        pusha
        push 5
        call malloc ; now eax holds the address of the first byte of the current operand node
        add esp,4 
        mov dword[HELPER], eax
        popa  
        mov eax, dword[HELPER] ;current link to add to new list
        mov byte[eax], dl ;mov new data        
        cmp byte[HELPER1],0
        je cont_add1
        mov esi, dword [PREV_LINK],
        mov dword[esi+1], eax
        
    cont_add1:    
        cmp byte[HELPER1],0
        ja cont_add2
        mov dword[HEAD_LINK], eax
        
    cont_add2:    
        mov dword[PREV_LINK], eax
        inc byte[HELPER1]        
        mov esi,dword[ebx+1]
        mov ebx,esi
        mov esi,dword[ecx+1]
        mov ecx,esi 
        jmp start_add
    
    ;-----------------------end-main addition---------------------------------
    
    
    
    ;--------------------start- add last 2 links and create new node----------------
    
    end_add:
        mov edx,0
        mov eax,0
        mov dl, byte[ebx]
        mov al,	byte[ecx]    
        mov esi,[CARRY]
        cmp esi,0
        je no_carry2
        add al,1
        daa
        
        
    no_carry2:
        add al,dl
        daa
        mov esi,0
        adc esi,0
        mov [CARRY],esi
        mov dl,al        
        pusha
        push 5
        call malloc ; now eax holds the address of the first byte of the current operand node
        add esp,4
        mov dword[HELPER], eax
        popa  
        mov eax, dword[HELPER] ;current link to add to new list
        mov byte[eax], dl ;mov new data
        cmp dword[PREV_LINK],0
        je cont_add4
        mov esi, dword [PREV_LINK]
        mov dword[esi+1], eax
        
    cont_add4:
        cmp dword[HEAD_LINK],0
        jne cont_add5
        mov dword[HEAD_LINK],eax
        
    cont_add5:
        mov dword[eax+1],0 ;set msb link to null (may require adding more links of longer operand)
        mov edx,eax
        ; ebx- pointer to current link of first operand
        ; ecx- pointer to current link of second operand
        ; edx- pointer to last link of the new operand
        cmp dword[ebx+1],0
        je ecx_is_longer	;jmp if ecx is longer, else ebx is longer and stay
        mov esi,dword[ebx+1]
        
        mov dword[edx+1],esi
        mov ebx,esi
        
    start_ebx:
        cmp dword[ebx+1],0
        je add_last_link
        mov esi,dword[CARRY]
        cmp esi,0
        je no_carry3
        mov eax,0
        mov al,byte[ebx]
        add al,1
        daa
        mov esi,0
        adc esi,0
        mov dword[CARRY],esi		
        mov byte[ebx],al
        
    no_carry3:
        mov esi,dword[ebx+1]
        mov ebx,esi	
        jmp start_ebx
        
    ecx_is_longer:    
        cmp dword[ecx+1],0
        je add_last_link	;jmp if ecx is longer, else ebx is longer and stay
        mov esi,dword[ecx+1]
        
        mov dword[edx+1],esi
        mov ecx,esi
        
    start_ecx:
        cmp dword[ecx+1],0
        je change_reg    
        mov esi,dword[CARRY]
        cmp esi,0
        je no_carry9
        mov eax,0
        mov al,byte[ecx]
        add al,1
        daa
        mov esi,0
        adc esi,0
        mov dword[CARRY],esi		
        mov byte[ecx],al
    no_carry9:
        mov esi,dword[ecx+1]
        mov ecx,esi	
        jmp start_ecx
    
    
    
    
    ;-------------------end- operands of non equal length----------------
    ;-------------------start-add 1 more link in case of carry-----------
    change_reg:
        mov ebx,ecx
        
    add_last_link:        
        mov esi,[CARRY]
        cmp esi,0
        je cont_add7
        mov eax,0
        mov al, [ebx]
        add al,1
        daa
        mov esi,0
        adc esi,0
        mov [CARRY],esi
        mov [ebx],al
    
    cont_add7:  
        mov esi,[CARRY]        
        cmp esi,0
        je no_carry4			
        push ebx
        push 5
        call malloc ; now eax holds the address of the first byte of the current operand node
        add esp,4 
        pop ebx        
        mov byte[eax],1
        mov dword [eax+1],0
        mov dword[ebx+1],eax
        
        
        
        ;-------------------end-add 1 more link in case of carry-------------
        
        ;-------------------start- add new operand to my stack--------------
    no_carry4:
        mov ebx,[HEAD_LINK]        
        push dword[HEAD_LINK]
        call get_operand_len
        add esp,4        
        cmp eax,1
        je cont_add6
        push dword[HEAD_LINK]
        call reverse 
        add esp,4
        mov dword[HEAD_LINK],eax
        
    cont_add6:	        
        mov eax, dword[HEAD_LINK]
        sub byte [STACK_OFFSET], 8
        mov edx,0
        mov dl, byte [STACK_OFFSET]
        mov dword[MY_EBP+edx],eax
        add byte [STACK_OFFSET],4
        
        ;mov edx,0
        ;mov dl, byte [STACK_OFFSET]
        ;sub dl,4
        ;mov ebx,dword[MY_EBP+edx]
        
        inc dword[ACTION_COUNTER]
        
    test3:        
        cmp byte [DEBUG],0
        je add_no_debug        
        push ebp
        push LC6
        push dword[stderr]		
        call fprintf	
        add esp,8
        pop ebp        
        mov edx, 0
        mov dl, byte [STACK_OFFSET]
        sub dl,4 
        mov ebx, dword [MY_EBP+edx]; 
        
    start_add_debug:
        cmp ebx,0
        je end_add_debug        
        mov eax,0
        mov al,[ebx]
        push ebp
        push eax
        push LC1
        push dword[stderr]
        call fprintf
        add esp,12;
        pop ebp        
        mov esi,[ebx+1]
        mov ebx,esi
        jmp start_add_debug
        
        
        
    end_add_debug:    
        push LC2
        push dword[stderr]
        call fprintf
        add esp,8
        
        
    add_no_debug:    
        
        ret
        
        
        ;-----------------------start- reverse operands if requrired------------------------------
        push ecx
        push ebx
        call get_operand_len
        pop ebx
        pop ecx        
        cmp eax,1
        je skip_ebx_reverse2        
        push ecx
        push ebx
        call reverse ; eax holds reverse(ebx)
        add esp,4
        pop ecx
        mov ebx,eax
        
    skip_ebx_reverse2:        
        push ebx
        push ecx
        call get_operand_len
        pop ecx
        pop ebx        
        cmp eax,1
        je skip_ecx_reverse2   
        push ebx
        push ecx
        call reverse ; eax holds reverse(ecx)
        add esp,4
        pop ebx
        mov ecx,eax
        ; ebx and ecx hold pointers to the add args after reverse     
        ;-----------------------end- reverse operands if requrired------------------------------
        ;ebx - pointer to first link of first operand
        ;ecx - pointer to first link of second operand
    skip_ecx_reverse2:
        mov [HEAD_LINK],ecx
        
    and_start:
        cmp dword[ebx+1],0
        je end_and
        cmp dword[ecx+1],0
        je end_and
        
        mov al, [ecx]
        mov dl, [ebx]
        and al,dl
        mov [ecx],al
        
        mov esi, [ebx+1]
        mov ebx,esi
        mov esi, [ecx+1]
        mov ecx,esi
        jmp and_start
        
    end_and:        
        mov al, [ecx]
        mov dl, [ebx]
        and al,dl
        mov [ecx],al
        cmp dword[ecx+1],0
        je update_stack
        mov dword [ecx+1],0
        
    update_stack:
        push dword[HEAD_LINK]
        call get_operand_len
        add esp,4        
        cmp eax,1
        je cont_and1
        push dword[HEAD_LINK]
        call reverse 
        add esp,4
        mov dword[HEAD_LINK],eax
        
    cont_and1:        
        mov eax,[HEAD_LINK]
        sub byte[STACK_OFFSET], 8
        mov edx,0
        mov dl, [STACK_OFFSET]
        mov dword[MY_EBP+edx], eax
        add byte[STACK_OFFSET], 4
        cmp byte [DEBUG],0
        je and_no_debug        
        push ebp
        push LC6
        push dword[stderr]		
        call fprintf	
        add esp,8
        pop ebp        
        mov edx, 0
        mov dl, byte [STACK_OFFSET]
        sub dl,4 
        mov ebx, dword [MY_EBP+edx]; 
        
    start_and_debug:
        cmp ebx,0
        je end_and_debug        
        mov eax,0
        mov al,[ebx]
        push ebp
        push eax
        push LC1
        push dword[stderr]
        call fprintf
        add esp,12
        pop ebp        
        mov esi,[ebx+1]
        mov ebx,esi
        jmp start_and_debug
                
    end_and_debug:
        push LC2
        push dword[stderr]
        call fprintf
        add esp,8
        
        
    and_no_debug:
        inc dword[ACTION_COUNTER]
        
    test4:        
        ret
        
        
        
        
        
        ;------------------------------------------helper functions---------------------------------------------
        
    get_operand_len:  ;gets 1 pointer to an operand (msb of the operand), return the length of the list containing the operand
        push ebp
        mov ebp,esp
        mov ebx, dword[ebp+8] ; holds the pointer to the operand        
        mov eax,0 ;at the end will hold the length of the elment pointed by ebx
        
    start_operand_count:
        cmp dword[ebx+1],0
        je end_operand_count
        inc eax
        mov esi, dword[ebx+1]
        mov ebx,esi
        jmp start_operand_count
        
    end_operand_count:
        inc eax
        
        mov esp,ebp
        pop ebp
        ret
        
        
    reverse:
        push ebp
        mov ebp,esp
        mov ebx, dword[ebp+8] ; pointer to the operand to reverse        
        mov dword [PREV_LINK], ebx
        mov edx,0   ;counter
        
    start_reverse:
        cmp dword[ebx+1],0
        je end_reverse
        cmp edx,0
        ja cont_reverse
        mov ecx, dword[ebx+1]
        mov dword [ebx+1], 0
        mov ebx,ecx ;go to next element
        inc edx
        jmp start_reverse
        
    cont_reverse:
        mov ecx, dword[ebx+1]
        mov esi, dword[PREV_LINK]
        mov dword [ebx+1], esi
        mov dword [PREV_LINK], ebx
        mov ebx,ecx ;go to next element
        inc edx
        jmp start_reverse
        
    end_reverse:
        mov esi, dword[PREV_LINK]
        mov dword [ebx+1], esi
        mov eax,ebx
        mov esp,ebp
        pop ebp
        
        ret
        
        
        
    quit:
        push dword [ACTION_COUNTER]
        push LC4
        call printf
        add esp,8
    
