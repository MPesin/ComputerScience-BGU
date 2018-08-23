section	.rodata
LC0:
	DB	"%llx", 10, 0	; Format string


section .bss
descriptive_y: RESB	8
	


upper: RESB 1
lower: RESB 1 





section	.data

counters: times 16 DB 0



section .text
	align 16
	global calc_func
	extern printf
	extern compare

calc_func:
	push	ebp
	mov	ebp, esp	; Entry code - set up ebp and esp
	mov ecx, dword [ebp+8]	; get long long number
	mov ebx, dword [ebp+12] ; get num of rounds
	pushad			; Save registers





;----------- start- compute counters-------------
new_itteration:
	cmp ebx, 0
	je print_y
	mov eax, 8 ; count to 0 (num of pairs of hex digits)
count:
	cmp eax, 0
	je end_count

		mov edx, 0
		ADD dl, byte [ecx]
		AND dl, 0x0F
		inc byte [counters + edx]

		mov edx, 0
		ADD dl, byte [ecx]
		AND dl, 0xF0
		shr dl, 4
		inc byte [counters + edx]
	dec eax
	inc ecx
	jmp count

end_count:
	

;------------end -compute counters---------------


;------------start- make descriptive y-----------

	mov esi, 14
	mov eax,0
start_y:
	cmp eax, 8
	je end_y

		mov edx ,0
		add dl, byte [counters + esi]
		shl edx, 4
		inc esi
		add dl, byte [counters + esi]
		mov byte [descriptive_y + eax], dl
		sub esi, 3
		inc eax
		jmp start_y


end_y:

;-----------end- make descriptive y--------------

;-----------start compare-----------------------
		
		sub ecx, 8
		pushad
		push descriptive_y
		
		push ecx
		call compare
		add esp,8
		cmp eax, 1
		je print_x	
		popad

		mov eax, 0
		start_copy:
			cmp eax, 8
			je end_copy
			mov dl, byte [descriptive_y + eax]
			mov byte [ecx + eax], dl
			inc eax
			jmp start_copy
		end_copy:

		mov eax, 0
		start_reset:
			cmp eax, 16
			je end_reset
			mov byte [counters + eax], 0
			inc eax
			jmp start_reset
		end_reset:

		
		dec ebx
		jmp new_itteration 

;-----------end compare-------------------------
	

print_x:
	
		mov ecx, dword [ebp+8]
		push    dword [ecx + 4]     	
		push    dword [ecx]		 
		push	LC0	
		call	printf
		add 	esp, 8	
		jmp end_prog
	
		



print_y:
	
		push    dword [descriptive_y + 4]     	
		push    dword [descriptive_y]		 
		push	LC0	
		call	printf
		add 	esp, 8	


end_prog:
	


	;popad			; Restore registers
	mov	esp, ebp	; Function exit code
	pop	ebp
	ret

