section	.data

        ans DB	"%d", 10, 0	; Format string

section .text
	global calc_div
	extern printf, check

calc_div:
	push	ebp
	mov	ebp, esp	; Entry code - set up ebp and esp
	pushad			; Save registers

	mov ecx, 



	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret

  