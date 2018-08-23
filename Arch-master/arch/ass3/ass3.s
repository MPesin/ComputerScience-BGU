%macro printArg 2 
	    pusha
		push %1
		push %2
		call printf
		add esp,8
		popa
   %endmacro

%macro printMsg 1
	    pusha
		push %1
		call printf
		add esp,4
		popa
   %endmacro

section	.rodata 
	LC1: DB	"%s", 10,0
	LC2: DB	"%c", 0
	MSG: DB	"----- Program got here -----",10, 0
	endParse: DB "----- End parse args ------",10, 0
	newLine: DB	" ", 10,0
	printLen: DB	"length is: %d", 10,0
	printWidth: DB	"width is: %d", 10,0
	printT: DB	"T is: %d", 10,0
	printK: DB	"K is: %d", 10,0



section .bss
	WorldLength RESB 4
	WorldWidth RESB 4	
	HELPER1 RESB 1
	

section .data 
	mode db "r",0
	FD DD 0
	state DD 0  ; points to an array of width*length bytes
	T DD 0
	K DD 0



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
     extern fopen
     extern fgetc
     extern scheduler
     extern co_init
     extern function
     extern start_co
     global T
     global K
     extern atoi
     global WorldLength
     global WorldWidth
     extern printer
     global state



main:

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;; Parsing Arguments ;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	push ebp
	mov ebp,esp


	mov ebx,[esp+8] ; argc
	mov ecx, [esp+12] ; argv



	;;;;;;;;;;;;;;;;;;;;
    ;;; numeric args ;;;
    ;;;;;;;;;;;;;;;;;;;;

	mov edx, dword[ecx+8]
	push ecx
	push edx
	call atoi
	add esp,4
	pop ecx
	mov dword[WorldLength],eax

		;printArg dword[WorldLength], printLen





	mov edx, dword[ecx+12]
	push ecx
	push edx
	call atoi
	add esp,4
	pop ecx
	mov dword[WorldWidth],eax

		;printArg dword[WorldWidth], printWidth



	mov edx, dword[ecx+16]
	push ecx
	push edx
	call atoi
	add esp,4
	pop ecx
	mov dword[T],eax

		;printArg dword[T], printT




	mov edx, dword[ecx+20]
	push ecx
	push edx
	call atoi
	add esp,4
	pop ecx
	mov dword[K],eax

		;printArg dword[K], printK
	
		   
	
	;;;;;;;;;;;;;
    ;;; state ;;;
    ;;;;;;;;;;;;;
   
    ;;dword[state] = array of 1s and 0s representing the state of the game


	push ecx	             			;open file
	push mode
	push dword[ecx+4]
	call fopen
	add esp,8
	mov [FD],eax
	pop ecx

	mov eax,1
	mul dword[WorldLength]
	mul dword[WorldWidth]

	pusha
	push eax
	call malloc 
	add esp,4 
	mov dword[state], eax ; pointer to the start of the array (state)
	popa


	mov esi, [state]

	mov edx,0
	parse_state_start:

		pusha
		push dword[FD]
		call fgetc  ; eax hold the output of fgetc
		add esp,4
		mov [HELPER1], eax
		popa
		
		cmp byte[HELPER1],-1
		je parse_state_end

		cmp byte[HELPER1], 0x20 ; space
		je parse_state_start
		cmp byte[HELPER1], 0x0A ; new-line
		je parse_state_start
		cmp byte[HELPER1], 0xD
		je parse_state_start
				
		mov eax,0
		mov al,[HELPER1]
		mov byte[esi+edx], al
		inc edx	
		jmp parse_state_start

	parse_state_end:

		

;------------------PRINT state---------------------
;	mov eax,1
;	mul dword;[WorldLength]
;	mul dword[WorldWidth]

;	mov ebx,[state]
;	start_print:
;		cmp eax,0
;		je end_print
;			mov ecx,0
;			mov cl,[ebx]
;			printArg ecx, LC2
;			inc ebx
;			dec eax
;			jmp start_print
;	end_print:

;printMsg newLine
;printMsg endParse


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;; Initializing co-routines ;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;ebx- pointer to current co-routine

  

    mov ebx,0           ; scheduler is co-routine 0
    mov edx, scheduler  
    call co_init            ; initialize scheduler state

    mov ebx,1          ; printer is co-routine 1
    mov edx, printer  
    call co_init            ; initialize printer state


    mov eax,1
	mul dword[WorldLength]
	mul dword[WorldWidth]
	add eax,2
	mov ecx,0
	mov ebx,2
	
	start_co_init:
		cmp ecx,eax
		je end_co_init
			pusha
			mov edx, function
			call co_init
			popa
			inc ebx
			inc ecx
			jmp start_co_init
	end_co_init:


	mov ebx,0
	pusha
	call start_co
	popa
	

exit:

	mov esp, ebp
    pop ebp
    ret





;atoi:

; input: pointer to string
; output: numeric value of string
; example: atoi("254") = 254
; notes: input must be lower then 256
	
;	push ebp
;	mov ebp,esp
;	mov ebx, dword[ebp+8] ; pointer to argument (string)

;	mov edx,0 ;counter for number of digits 
;	start_atoi:
;		cmp byte [ebx],0
;		je end_atoi
;			sub byte[ebx], 0x30
;			inc ebx
;			inc edx
;			jmp start_atoi
;	end_atoi:

;	sub ebx,edx
;	mov ecx,0 ;at the end will hold the numeric value of the string
;	start_convert:
;		cmp edx, 0
;		je end_convert		
;			
;			mov esi,edx
;			mov eax, 1
;			mov byte[HELPER1],10
;			
;			start_offset:
;			cmp esi,1
;			je end_offset
;				mul byte[HELPER1] ; eax = eax*[pow]
;				dec esi
;				jmp start_offset
;			end_offset:
;
;
;			mul byte[ebx]
;			add cl, al
;			
;			inc ebx
;			dec edx
;			jmp start_convert
;	end_convert:
;
;	mov eax,ecx
;
;	mov esp,ebp
;	pop ebp
;	ret
;



