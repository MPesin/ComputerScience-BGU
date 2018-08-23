section	.rodata
LC0:
	DB	"%s", 10, 0	; Format string

section .bss
LC1:
	RESB	32

section .text
	align 16
	global my_func
	extern printf

my_func:
	push	ebp
	mov	ebp, esp	; Entry code - set up ebp and esp
	mov ecx, dword [ebp+8]	; Get argument (pointer to string)

	pushad			; Save registers




;       Your code should be here...
		
		mov esi, 0
		mov edx, 0  ; counter for number of chars in the given string
		mov ebx, ecx
COUNT:
		cmp byte [ebx],0
		je END_COUNT
		inc edx
		inc ebx
		jmp COUNT

END_COUNT:

		AND edx, 1
		cmp edx, 0
		je ODD
		jmp cont

ODD:
		cmp byte [ecx], "0"
		je ZERO0


		cmp byte [ecx], "1"
		je ONE1


		cmp byte [ecx], "2"
		je TWO2


		cmp byte [ecx], "3"
		je THREE3

ZERO0:
		mov byte [LC1+esi], '0'
		inc esi
		inc ecx
		jmp cont

ONE1:
		mov byte [LC1+esi], '1'
		inc esi
		inc ecx
		jmp cont

TWO2:
		mov byte [LC1+esi], '2'
		inc esi
		inc ecx
		jmp cont

THREE3:
		mov byte [LC1+esi], '3'
		inc esi
		inc ecx
		jmp cont

cont:	
		cmp byte [ecx],0
		je end_numeric

		cmp word [ecx], "00"
		je ZERO


		cmp word [ecx], "01"
		je ONE


		cmp word [ecx], "02"
		je TWO


		cmp word [ecx], "03"
		je THREE


		cmp word [ecx], "10"
		je FOUR


		cmp word [ecx], "11"
		je FIVE

		cmp word [ecx], "12"
		je SIX

		cmp word [ecx], "13"
		je SEVEN

		cmp word [ecx], "20"
		je EIGHT

		cmp word [ecx], "21"
		je NINE

		cmp word [ecx], "22"
		je A

		cmp word [ecx], "23"
		je B

		cmp word [ecx], "30"
		je C

		cmp word [ecx], "31"
		je D

		cmp word [ecx], "32"
		je E

		cmp word [ecx], "33"
		je F


		jmp NEXT
		


ZERO:
		mov byte [LC1+esi], '0'
		inc esi
		jmp NEXT

ONE:
		mov byte [LC1+esi], '1'
		inc esi
		jmp NEXT

TWO:
		mov byte [LC1+esi], '2'
		inc esi
		jmp NEXT

THREE:
		mov byte [LC1+esi], '3'
		inc esi
		jmp NEXT

FOUR:
		mov byte [LC1+esi], '4'
		inc esi
		jmp NEXT

FIVE:
		mov byte [LC1 + esi], '5'
		inc esi
		jmp NEXT

SIX:
		mov byte [LC1 + esi], '6'
		inc esi
		jmp NEXT

SEVEN:
		mov byte [LC1 + esi], '7'
		inc esi
		jmp NEXT

EIGHT:
		mov byte [LC1 + esi], '8'
		inc esi
		jmp NEXT


NINE:
		mov byte [LC1 + esi], '9'
		inc esi
		jmp NEXT


A:
		mov byte [LC1 + esi], 65
		inc esi
		jmp NEXT


B:
		mov byte [LC1 + esi], 66
		inc esi
		jmp NEXT


C:
		mov byte [LC1 + esi], 67
		inc esi
		jmp NEXT


D:
		mov byte [LC1 + esi], 68
		inc esi
		jmp NEXT


E:
		mov byte [LC1 + esi], 69
		inc esi
		jmp NEXT


F:
		mov byte [LC1 + esi], 70
		inc esi
		jmp NEXT






NEXT:
		inc ecx
		inc ecx
		jmp cont






end_numeric: 






	


;      end of code  ...	

	push	LC1		; Call printf with 2 arguments: pointer to str
	push	LC0		; and pointer to format string.
	call	printf
	add 	esp, 8		; Clean up stack after call

	popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret

