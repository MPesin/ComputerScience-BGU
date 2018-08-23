section .data                    	; data section, read-write
        an:    DD 0              	; this is a temporary var
;        format: db "char: %s" , 10, 0

section .text                    	; our code is always in the .text section
        global do_Str          	; makes the function appear in global scope
        extern printf            	; tell linker that printf is defined elsewhere 							; (not used in the program)

do_Str:                        	; functions are defined as labels
        push    ebp              	; save Base Pointer (bp) original value
        mov     ebp, esp         	; use base pointer to access stack contents
        pushad                   	; push all variables onto stack
        mov ecx, dword [ebp+8]	; get function argument

;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE STARTS HERE ;;;;;;;;;;;;;;;; 

	mov	dword [an], 0		; initialize answer
	convert:
            mov al,[ecx] 
            cmp al, '('
            jne else
            mov al, '<'
            mov [ecx],al
            je count

        else:
            cmp al, ')'
            jne cases 
            mov al, '>'
            mov [ecx],al 
            je count
       
       cases:
            cmp al,'a'
            jb check_count
            cmp al,'z'
            ja check_count
            sub al,0x20 
            mov [ecx],al 
            jmp loop
                              
        check_count:
            cmp al,'A'
            jb count
            cmp al,'Z'
            ja count
            jmp loop
        
        count:
            inc dword [an]         
            
        loop:
            inc ecx      	    ; increment pointer
            cmp byte [ecx], 0   ; check if byte pointed to is zero
            jnz convert      ; keep looping until it is null terminated


;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE ENDS HERE ;;;;;;;;;;;;;;;; 

         popad                    ; restore all previously used registers
         mov     eax,[an]         ; return an (returned values are in eax)
         mov     esp, ebp
         pop     ebp
         ret 
		 