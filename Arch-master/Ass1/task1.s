section	.rodata
LC0:
	DB	"%s", 10, 0	; Format string

section .bss
LC1:
	RESB	256

section .text
	align 16
	global my_func
	extern printf

my_func:
	push	ebp
	mov	ebp, esp	; Entry code - set up ebp and esp
	pushad			; Save registers

	mov ecx, dword [ebp+8]	; Get argument (pointer to string)

.loop:
        cmp byte[ecx],0x0              
        je exit                        
        rol ebx,04                      ;appends zero to lsb
        mov dl,byte[ecx]                ;dl=ascii value
        cmp dl,39h                      ;if lesser than 39 goto esc
        jbe esc                         ;else subtract 7
        sub dl,07h   
        esc:  
        sub dl,30h                      ;sub 30h
        add LC1,dl                       ;bl=bl+dl
        inc ecx, dword [ebp+8]                         
        jmp .loop
exit:
	push	LC1		; Call printf with 2 arguments: pointer to str
	push	LC0		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call

	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret

  