section .data
    str1 db "assd",0;
    str2 db "alslf",0;
    format db "%d",0xa,0;

section .text 
    global _start

    extern funcA;
    extern printf;

_start:
    push str1
    call funcA
    mov edx, eax
    push str2
    call funcA
    add edx, eax
    
    push edx
    push format
    call printf
    
    mov eax, 1
    int 80h
    