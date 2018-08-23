
section .bss        
   num resb 5

section .text
	
global _start
global read
global write
global open
global close
global strlen

   
extern main
_start:
    mov ebp, esp
        lea eax, [ebp+4]
    push eax
    push dword [ebp]

    call	main
    mov     ebx,eax
	mov	eax,1
	int 0x80

read:
    push ebp
    mov ebp, esp
    
    mov eax, 3
    mov ebx, [esp]
    mov ecx, [esp+4]
    mov edx, [esp+8]
    int 0x80
    
    mov esp, ebp
    pop ebp
    ret
    
write:
    push ebp
    mov ebp, esp
    
    mov eax, 4
    mov ebx, [esp]
    mov ecx, [esp+4]
    mov edx, [esp+8]
    int 80h  
    
    mov esp, ebp
    pop ebp
    ret
    
open:
    push ebp
    mov ebp, esp
    
    mov eax, 5
    mov ebx, [esp]
    mov ecx, [esp+4]
    mov edx, [esp+8]
    int 0x80
    
    mov esp, ebp
    pop ebp
    ret
    
close:
    push ebp
    mov ebp, esp
    
    mov eax, 6
    mov ebx, [esp]
    int 0x80
    
    mov esp, ebp
    pop ebp
    ret
    
strlen:
	ret
