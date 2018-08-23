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


section	.rodata 
	LC1: DB	" @@@@@    printer   @@@@@", 10,0
	space: DB	" " ,0
	cell: DB	"%c " ,0
	newLine: DB     " ", 10,0
	MSG: DB "----- Program got here  -----",10, 0

section .bss
    align 16
    tmpWidth: resd 4
    tmpLenth: resd 4
    indent: resb 4
	

section .text
	global printer
	extern resume
	extern end_co
	extern CORS
	extern printf
	extern T
	extern WorldLength
    extern WorldWidth
    extern state


printer:
 
 	mov byte[indent],1
	;printMsg LC1
	;printMsg newLine

	mov eax,1
	mul dword[WorldLength]
	mul dword[WorldWidth]
	mov ecx, 0
	mov esi,[state]
	mov edx, [WorldWidth]



	start_print:
	cmp ecx,eax
	je end_print
		
		

		cont_print:
		cmp ecx, edx
		jb no_break_line
			printMsg newLine
			add edx, [WorldWidth]

					cmp byte[indent],0
				je no_indent
					printMsg space
					mov byte[indent],0
					jmp cont_print

				no_indent:
					mov byte[indent],1

		no_break_line:

		mov ebx,0

		mov bl, [esi+ecx]	
		printArg ebx,cell
		inc ecx
		jmp start_print

	end_print:
	;printMsg newLine
	printMsg newLine
     
    mov ebx,0
    call resume
    jmp printer
		



