section .data                    	; data section, read-write
        an:    DD 0              	; this is a temporary var
	
section .text                    	; our code is always in the .text section
        global add_Str_N          	; makes the function appear in global scope
        extern printf            	; tell linker that printf is defined elsewhere 				; (not used in the program)

add_Str_N:                        	; functions are defined as labels
        push    ebp              	; save Base Pointer (bp) original value
        mov     ebp, esp         	; use base pointer to access stack contents
        pushad                   	; push all variables onto stack
        mov ecx, dword [ebp+8]	; get function argument

;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE STARTS HERE ;;;;;;;;;;;;;;;; 
cont:	cmp byte [ecx],0
	je end_of_loop
	inc dword [an]

if_a_z_pre:	    cmp byte [ecx], 'a'
		    jl else_if_A_Z_pre
		    cmp byte [ecx], 'z'
		    jg else_if_A_Z_pre
		    jmp letter

else_if_A_Z_pre:    cmp byte [ecx], 'A'
		    jl else_pre
		    cmp byte [ecx], 'Z'
		    jg else_pre
		    jmp letter

else_pre:  add byte [ecx],9
	   dec dword [an]
	   inc ecx
	   jmp cont

letter:	   add byte [ecx],9

if_a_z_post: cmp byte [ecx], 'a'
	     jl else_if_A_Z_post
	     cmp byte [ecx], 'z'
	     jg else_if_A_Z_post
	     dec dword [an]
	     inc ecx
	     jmp cont
	     
else_if_A_Z_post: cmp byte [ecx], 'A'
		  jl else_post
		  cmp byte [ecx], 'Z'
		  jg else_post
		  dec dword [an]
		  inc ecx
		  jmp cont

else_post: inc ecx
	   jmp cont
	   
end_of_loop:
  




;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE ENDS HERE ;;;;;;;;;;;;;;;; 
         popad                    ; restore all previously used registers
         mov     eax,[an]         ; return an (returned values are in eax)
         mov     esp, ebp
         pop     ebp
         ret 