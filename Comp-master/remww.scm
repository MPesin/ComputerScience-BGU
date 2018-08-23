(define remww
    (letrec ((remove-redundant-instruction
    (lambda (insts)
        (cond ((null? insts) insts)
              ((redundant-instruction? (car insts) (cdr insts)) (remove-redundant-instruction (cdr insts)))
              (else `(,(car insts) ,@(remove-redundant-instruction (cdr insts)))))))
    (redundant-instruction? 
     (lambda(inst next-insts)
         (letrec ((write-regs (car (cdr (cdr inst)))))
            (andmap (lambda (reg) (overwrriten-following? reg next-insts)) write-regs))))
   (overwrriten-following?
    (lambda (reg insts)
        (if (null? insts) #f
            (let* ((inst (car insts))
                   (read-regs (car (cdr inst)))
                   (write-regs (car (cdr (cdr inst)))))
                (cond ((member reg read-regs) #f)
                      ((member reg write-regs) #t)
                      (else (overwrriten-following? reg (cdr insts)))))))))
    (lambda(insts)
        (let ((removed (remove-redundant-instruction insts)))
            (if (equal? insts removed) insts
                (remww removed))))))
