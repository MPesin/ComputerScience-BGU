;;; ascii-to-text.asm
;;; Read two-letter hex values in source string and output
;;; the corresponding ASCII string
;;;
;;; Programmer: Mayer Goldberg, 2017

%define newline 10
%define dquote 34
	
section .data
input_string:
	db "333435364c656d6f6e", 0, 0
result_format:
	db "The string is ", dquote, "%s", dquote, newline, 0 

section .bss
nibble_conversion_table:
	resb 256
result:
	resb 256

extern exit, printf
global main
section .text
main:
	call setup_conversion_table

	mov esi, dword input_string
	mov edi, result
	
.loop:
	mov eax, 0
	mov al, byte [esi]	; high nibble
	cmp al, 0		; bss is initialized to zeros
	je .done		; bad input
	mov ebx, 0
	mov bl, byte [esi + 1]			     ; low nibble
	mov al, byte [nibble_conversion_table + eax] ; value of high nibble
	mov bl, byte [nibble_conversion_table + ebx] ; value low nibble
	shl al, 4				     ; al *= 16
	add al, bl				     ; al += bl
	mov byte [edi], al	; add char to output string
	add esi, 2		; advance by two bytes in input
	inc edi			; advance by one  byte in output
	jmp .loop
	
.done:
	push result
	push result_format
	call printf
	add esp, 2*4

	mov eax, 0
	call exit

setup_conversion_table:
	mov byte [nibble_conversion_table + '1'], 1
	mov byte [nibble_conversion_table + '2'], 2
	mov byte [nibble_conversion_table + '3'], 3
	mov byte [nibble_conversion_table + '4'], 4
	mov byte [nibble_conversion_table + '5'], 5
	mov byte [nibble_conversion_table + '6'], 6
	mov byte [nibble_conversion_table + '7'], 7
	mov byte [nibble_conversion_table + '8'], 8
	mov byte [nibble_conversion_table + '9'], 9
	mov byte [nibble_conversion_table + 'a'], 10
	mov byte [nibble_conversion_table + 'b'], 11
	mov byte [nibble_conversion_table + 'c'], 12
	mov byte [nibble_conversion_table + 'd'], 13
	mov byte [nibble_conversion_table + 'e'], 14
	mov byte [nibble_conversion_table + 'f'], 15
	mov byte [nibble_conversion_table + 'A'], 10
	mov byte [nibble_conversion_table + 'B'], 11
	mov byte [nibble_conversion_table + 'C'], 12
	mov byte [nibble_conversion_table + 'D'], 13
	mov byte [nibble_conversion_table + 'E'], 14
	mov byte [nibble_conversion_table + 'F'], 15
	ret
	
