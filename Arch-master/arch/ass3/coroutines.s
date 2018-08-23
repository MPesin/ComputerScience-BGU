STKSZ equ 16*1024 ; co-routine stack size
NUMCO equ 60*60+2

%macro printArg 2 
            pusha
                push %1
                push %2
                call printf
                add esp,8
                popa
   %endmacro


%macro printArg3 3 
            pusha
                push %1
                push %2
                push %3
                call printf
                add esp,12
                popa
   %endmacro

%macro printMsg 1
                pusha
                push %1
                call printf
                add esp,4
                popa
   %endmacro



section .rodata
        align 16
        global numco
        numco: dd 60*60+2
        calculate: DB "co-routine offset %d CALCULATES.. ", 10,0
        update: DB "co-routine offset %d UPDATE-MATRIX..", 10,0
        lineNum: DB "co-routine line number is: %d", 10,0
        rowNum: DB "co-routine row number is: %d", 10,0
        bla: DB "test: %d", 10,0
        LC2: DB "%c ", 0
        LC3: DB "scheduler esp is: %x", 10,0
        LC4: DB "ebx is: %d", 10,0
        LC6: DB "eax is: %d", 10,0
        LC5: DB "content of esp is: %d", 10,0
        LC8: DB "tmp row is: %d", 10,0
        LC9: DB "num of lit is: %d", 10,0
        LC10: DB "ecx is is: %d", 10,0
        LC11: DB "hudlak", 10,0
        LC12: DB "kuba", 10,0
        MSG: DB "----- Program got here  -----",10, 0
        initeMsg: DB "----- INIT  -----",10, 0
        resumeMsg: DB "----- got to resume -----",10, 0
        endParse: DB "----- End parse args ------",10, 0
        newLine: DB     " ", 10,0
        shachen: DB "(%d,%d)", 0

section .data
        align 16
        CORS TIMES NUMCO DD 0
        neighbors TIMES 6 DB  '2' ;holds the value of a chells neighbors, 2 means no neighbor
     

section .bss
        align 16
        CURR: resd 1
        TMP_CURR: resb 1
        SPT: resd 1 ; temporary stack pointer variable
        SPMAIN: resd 1 ; stack pointer of main
        tmp: resb 4 ;temp esp
        HELPER1: resb 4
        stacks: resb NUMCO * STKSZ  ; co-routine stacks
        currentLine: resb 4
        currentRow: resb 4
        currNeighbor: resb 4
        currentCellInLine: resb 4
        even: resb 4 ;;hold 0 if even else 1
        tmpRow: resb 4
        tmpLine: resb 4
        litNeigbor: resb 1
        extern T
        extern K



section .text
        global co_init
        extern malloc
        extern printf
        global function
        global start_co
        extern scheduler
        global resume
        global end_co
        extern state
        extern WorldLength
        extern WorldWidth



co_init:


        push eax                ; save eax (on callers stack)
        push edx
        mov edx,0
        mov eax,STKSZ
        imul ebx                            ; eax = co-routines stack offset in stacks
        pop edx
        add eax, stacks + STKSZ ; eax = top of (empty) co-routines stack
        mov [CORS + ebx*4], eax ; store co-routines stack top
        pop eax                 ; restore eax (from callers stack)

        mov [tmp], esp          ; save callers stack top
        mov esp, [CORS + ebx*4] ; esp = co-routines stack top

       
        cmp ebx,0
        ja no_scheduler
            push dword[K]
            push dword[T]       
        no_scheduler:

        push edx  
                      ; save return address to co-routine stack
        
        pushf                   ; save flags
        pusha                   ; save all registers

     


        mov [CORS + ebx*4], esp ; update co-routines stack top

        mov esp, [tmp]          ; restore callers stack top
        ret                     ; return to caller





; EBX is pointer to co-init structure of co-routine to be resumed
; CURR holds a pointer to co-init structure of the curent co-routine
resume:
  
        pushf                   ; Save state of caller
        pusha
        mov     EDX, [CURR]
  
        mov     [CORS+4*EDX],ESP   ; Save current SP

do_resume:

        mov esp, dword[CORS+4*EBX] 
        mov     [CURR], EBX  
        popa                    ; Restore resumed co-routine state
        popf

        ret                     ; "return" to resumed co-routine!


start_co:
        push    EBP
        mov     EBP, ESP
        pusha
        mov     [SPMAIN], ESP             ; Save SP of main code
        mov [CURR], ebx
        jmp     do_resume


end_co:
        mov     ESP, [SPMAIN]            ; Restore state of main code      
        popa
        pop     EBP
        ret



function:
;-------------calc -------------------
;;esi will hold the calulated state of cell with offset ebx in CORS
;;note- at first sub ebx,2. at the end add ebx,2 (for the proper offset in state)

        mov ebx,[CURR]
        ;printArg dword[CURR],calculate
        sub ebx,2
        ;printArg ebx,LC4
        call getLIneNumber
        call getRowNumber 
        add ebx,2
        ;printArg dword[currentLine], lineNum
        ;printArg dword[currentRow], rowNum
        ;printMsg newLine
        call checkIfEvenLine
        call calcNeighbors
       
      
        mov [CURR],ebx
        mov edx,ebx
        mov ebx,0
        call resume
        mov ebx,edx


        ;-------------update matrix -------------------
        ;;ecx will hold the number of lit neighbors for each co-routine
       ; mov [CURR],ebx
       sub ebx,2
        mov edx,[state]
        ;printArg dword[CURR],update

 ;printArg ebx,LC4
 ;printArg ecx,LC10
        mov eax,0
        mov al, [edx+ebx]
        cmp al,'0'
        jne alive
                dead:
                        cmp ecx,2
                        jne dont_change_to_1
                                mov al,'1'
                                mov edx,[state]
                                mov [edx+ebx],al
                                ;printMsg LC11
                        dont_change_to_1:
                        jmp dont_changeto_0

        alive:
                cmp ecx,4
                je dont_changeto_0
                cmp ecx,3
                je dont_changeto_0
                        mov al,'0'
                        mov edx,[state]
                        mov [edx+ebx],al
                        ;printMsg LC12

                dont_changeto_0:
       




       


        mov ebx,0
        call resume


        jmp function
      









getLIneNumber:
;; output- dword[currentLine] will hold the line number of co-routine with offset ebx in cors
;; first line is 0 and not 1


        mov eax,[WorldWidth]
        mov dword[currentLine],0
        start_get_line:

                cmp ebx, eax
                jb end_get_line
                mov edx, [WorldWidth]
                add eax,[WorldWidth]
                inc dword[currentLine]
                jmp start_get_line
                
        end_get_line:
 ret

 getRowNumber:
;; output- dword[currentRow] will hold the row number of co-routine with offset ebx in cors
;; first row is 0 and not 1
        
        mov edx,ebx
        shr edx,16
        mov eax,0
        mov ax,bx
        mov ecx, [WorldWidth]
        div ecx
        mov ecx,0
        mov cx,dx
        mov [currentRow],edx
       
ret




checkIfEvenLine:
        mov dword[even],0
        mov edx, [currentLine]
        and edx,1
        cmp edx,0
        je end_check
                mov dword[even],1

        end_check:
ret 


calcNeighbors:
        
        mov byte[litNeigbor],0
        mov edx,[state] ;pointer to first byte in state
        mov ecx,0
        cmp dword[even],1
        je odd_case

        even_case:
                ;;-------------(i-1,j-1)------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                dec dword[tmpLine]
                dec dword[tmpRow]

        
                cmp dword[tmpLine], -1
                jne if_line_not_neg_1

                        mov esi,[WorldLength]
                        mov [tmpLine],esi
                        dec dword [tmpLine]

                if_line_not_neg_1:

                cmp dword[tmpRow], -1
                jne if_row_not_neg_1

                        mov esi,[WorldWidth]
                        mov [tmpRow],esi
                        dec dword [tmpRow]

                if_row_not_neg_1:
 
                ;printArg3  dword[tmpRow], dword[tmpLine], shachen
                ;printMsg newLine

               call checkLIt

              




                ;;(i-1,j)---------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                dec dword[tmpLine]
              

                cmp dword[tmpLine], -1
                jne if_line_not_neg_2

                        mov esi,[WorldLength]
                        mov [tmpLine],esi
                        dec dword [tmpLine]

                if_line_not_neg_2:

                ;printArg3  dword[tmpRow], dword[tmpLine], shachen
                ;printMsg newLine

                call checkLIt

                ;;(i,j-1)---------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                dec dword[tmpRow]


                cmp dword[tmpRow], -1
                jne if_row_not_neg_3

                        mov esi,[WorldWidth]
                        mov [tmpRow],esi
                        dec dword [tmpRow]

                if_row_not_neg_3:

                ;printArg3  dword[tmpRow], dword[tmpLine], shachen
                ;printMsg newLine

                call checkLIt

                ;;(i,j+1)---------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                inc dword[tmpRow]

                mov esi, [WorldWidth]
                cmp dword[tmpRow], esi
                jne if_row_not_edge

                        mov dword[tmpRow],0

                if_row_not_edge:

                ;printArg3  dword[tmpRow], dword[tmpLine], shachen
                ;printMsg newLine
 
                call checkLIt

                ;;(i+1,j-1)-------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                inc dword[tmpLine]
                dec dword[tmpRow]
              
                mov esi, [WorldLength]
                cmp dword[tmpLine], esi
                jne if_line_edge
                  
                        mov dword[tmpLine],0
                       
                if_line_edge:

                cmp dword[tmpRow], -1
                jne if_row_not_neg_4

                        mov esi,[WorldWidth]
                        mov [tmpRow],esi
                        dec dword [tmpRow]

                if_row_not_neg_4:

               ; printArg3  dword[tmpRow], dword[tmpLine], shachen
               ; printMsg newLine

                call checkLIt


                ;;(i+1,j)---------------------------


                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                inc dword[tmpLine]
              
                mov esi, [WorldLength]
                cmp dword[tmpLine], esi
                jne if_line_edge2
                  
                        mov dword[tmpLine],0
                       
                if_line_edge2:
              ;  printArg3  dword[tmpRow], dword[tmpLine], shachen
               ; printMsg newLine
               ; printMsg newLine

                call checkLIt


                jmp end_calc
             

        odd_case:

         ;;-------------(i-1,j)------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                dec dword[tmpLine]

              
                cmp dword[tmpLine], -1
                jne if_line_not_neg_11

                        mov esi,[WorldLength]
                        mov [tmpLine],esi
                        dec dword [tmpLine]

                if_line_not_neg_11:

 
               ; printArg3  dword[tmpRow], dword[tmpLine], shachen
               ; printMsg newLine

                call checkLIt

                ;;(i-1,j+1)---------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                dec dword[tmpLine]
                inc dword[tmpRow]
              

                cmp dword[tmpLine], -1
                jne if_line_not_neg_22

                        mov esi,[WorldLength]
                        mov [tmpLine],esi
                        dec dword [tmpLine]

                if_line_not_neg_22:

                mov esi, [WorldWidth]
                cmp dword[tmpRow], esi 

                jne if_row_not_edge66

                       mov dword[tmpRow],0

                if_row_not_edge66:

              ;  printArg3  dword[tmpRow], dword[tmpLine], shachen
              ;  printMsg newLine

                call checkLIt

                ;;(i,j-1)---------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                dec dword[tmpRow]


                cmp dword[tmpRow], -1
                jne if_row_not_neg_33

                        mov esi,[WorldWidth]
                        mov [tmpRow],esi
                        dec dword [tmpRow]

                if_row_not_neg_33:

              ;  printArg3  dword[tmpRow], dword[tmpLine], shachen
              ; printMsg newLine

                call checkLIt
                ;;(i,j+1)---------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                inc dword[tmpRow]

                mov esi, [WorldWidth]
                cmp dword[tmpRow], esi
                jne if_row_not_edge0

                        mov dword[tmpRow],0

                if_row_not_edge0:

              ;  printArg3  dword[tmpRow], dword[tmpLine], shachen
              ;  printMsg newLine

                call checkLIt


                ;;(i+1,j)-------------------------

                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                inc dword[tmpLine]
              
                mov esi, [WorldLength]
                cmp dword[tmpLine], esi
                jne if_line_edge0
                  
                        mov dword[tmpLine],0
                       
                if_line_edge0:

              ;  printArg3  dword[tmpRow], dword[tmpLine], shachen
              ;  printMsg newLine

                call checkLIt

                ;;(i+1,j+1)---------------------------


                mov esi,[currentLine]
                mov [tmpLine],esi
                mov esi,[currentRow]
                mov [tmpRow],esi
                inc dword[tmpLine]
                inc dword[tmpRow]
              
                mov esi, [WorldLength]
                cmp dword[tmpLine], esi
                jne if_line_edge22
                  
                        mov dword[tmpLine],0
                       
                if_line_edge22:

                mov esi, [WorldWidth]
                cmp dword[tmpRow], esi
                jne if_row_not_edge55

                        mov dword[tmpRow],0

                if_row_not_edge55:


            ;    printArg3  dword[tmpRow], dword[tmpLine], shachen
            ;    printMsg newLine
            ;    printMsg newLine

                call checkLIt


end_calc:
        mov ecx,0
        mov cl, [litNeigbor]
      ;  printArg ecx, LC9
       ; printMsg newLine
       ; printMsg newLine

        ;;ecx will hold the number of lit neighbors for each co-routine
   
ret

;------------------------test-----------------------------
;                printMsg newLine
;                mov ecx, neighbors
;                mov esi,0;
;
;                start_print:
;;                cmp esi,6
;                je end_print
;                        mov edx,0
;                        mov dl ,byte[neighbors+esi]
;                        printArg edx,LC2
;                        inc esi
 ;                       jmp start_print
 ;               end_print:
;;
;                printMsg newLine
;                printMsg newLine
;
;;--------------------test------------------------------


    

     checkLIt:   

                mov eax,1
                mul dword[tmpLine]
                mul dword[WorldWidth]
                add eax,dword[tmpRow]

                mov edx,[state]
                mov ecx,0
                mov cl, [edx+eax]
                cmp cl,'0'
                je cont_check
                        inc byte[litNeigbor]
                cont_check:

        ret
 
