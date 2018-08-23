section .text
	global my_cmp ;make my_cmp transparent to other modules
my_cmp:
	push ebp ;stack maintenance
	mov ebp, esp ;stack maintenance
	
get_arguments:
	movzx eax, BYTE [ebp+8] ;retrieves the first function argument, READ about MOVZX
	movzx ebx, BYTE [ebp+12] ;retrieves the second function argument, READ about MOVZX

cmpare:
	%TODO: complete the comparison part
	
F_BIG:
	mov eax, 1 ;return value need to be stored in eax register
	jmp FINISH
	
S_BIG:
	mov eax, 2 ;return value need to be stored in eax register
	jmp FINISH
	
FINISH:
	mov esp, ebp ;stack maintenance
	pop ebp ;stack maintenance
	ret ;stack maintenance