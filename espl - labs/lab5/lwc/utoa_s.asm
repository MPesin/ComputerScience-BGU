section .data
    NUMS db "0123456789"
    
secrion .text
    global utoa_s
    
utoa_s:
    push ebp
    mov ebp, esp
    
	    
        
    mov esp, ebp
    pop ebp
    ret
    