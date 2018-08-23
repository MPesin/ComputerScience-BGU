NUMCO equ 60*60+2

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

section .bss
    K: resd 1
    T: resd 1
	


section	.rodata 
	LC1: DB	" scheduler ", 10,0
	LC18: DB	" k is: %d ", 10,0
	LC19: DB	" t is: %d ", 10,0
	LC2: DB	"%c", 0
	RoundStartMsg: DB	"------------------start orround #%d--------------------: ", 10,0
	RoundEndMsg: DB	    "-------------------end orround #%d--------------------: ", 10,0


section .data
        align 16
        IterPerRound DD 0
        CurrCoInRound DD 0
        toPrint DD 0
        tmpEbx DD 0
      ;;  T DD 0
       ; K DD 0
        firstIter DB 0

section .text
	global scheduler
	extern resume
	extern end_co
	extern CORS
	extern printf
	;extern T
	;extern K
	extern WorldLength
    extern WorldWidth


scheduler:

	cmp byte[firstIter],0
	ja not_first
		pop ecx
		mov [T],ecx
		pop ecx
		mov [K],ecx
		mov byte[firstIter],1

		;printArg dword[T], LC19
		;printArg dword[K], LC18
		
	not_first



	mov eax,1
	mul dword[WorldLength]
	mul dword[WorldWidth]
	mov dword[IterPerRound],eax
	mov dword[toPrint],0
	
	;mov edx,0
	mov edx, [T]
	;printArg edx, RoundStartMsg
	mov ebx,2


	cmp dword[T],0
	je end_scheduler
		
		start_round1:
			cmp dword[IterPerRound], 0
			je end_round1

				;mov ecx,0
				mov ecx,[K]
				cmp [toPrint], ecx
				jb no_print
					mov [tmpEbx],ebx
					mov ebx,1
					pusha
					call resume 
					popa
					mov ebx,[tmpEbx]
					mov dword[toPrint],0

				no_print:
				;printMsg LC1
				pusha
				call resume
				popa
				inc ebx
				inc dword[toPrint]
				dec dword[IterPerRound]
				jmp start_round1

		end_round1:

		mov eax,1
		mul dword[WorldLength]
		mul dword[WorldWidth]
		mov dword[IterPerRound],eax
		mov ebx,2

		start_round2:
			cmp dword[IterPerRound], 0
			je end_round2

				;mov ecx,0
				mov ecx,[K]
				cmp [toPrint], ecx
				jb no_print2
					mov [tmpEbx],ebx
					mov ebx,1
					pusha
					call resume 
					popa
					mov ebx,[tmpEbx]
					mov dword[toPrint],0

				no_print2:
				;printMsg LC1
				pusha
				call resume
				popa
				inc ebx
				inc dword[toPrint]
				dec dword[IterPerRound]
				jmp start_round2

		end_round2:




	;printArg edx, RoundEndMsg
	dec dword[T]
	jmp scheduler

end_scheduler:

	mov ebx,1
	pusha
	call resume
	popa

	call end_co
	
		



