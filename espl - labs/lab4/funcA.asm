section .text
	global funcA
	
funcA:
	push	ebp
	mov	ebp, esp
	mov	eax,-1

.L2:
	add eax, 1
	mov ebx, eax
	add ebx, [ebp+8]
	mov bl, BYTE [ebx]
	test bl,bl
	jne .L2
	mov esp, ebp
	pop ebp
	ret