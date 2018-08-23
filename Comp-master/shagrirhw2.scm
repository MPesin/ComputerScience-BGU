;;;;;;;
;;;;;;;;    1. change filename to compiler.scm
;;;;;;;;    2. in arch/cisc.h change RAM_SIZE and STACK_SIZE to Mega(64)
;;;;;;;;    3. in arch/scheme.lib change content to that in the file in git
;;;;;;;;    4. in arch/lib/scheme/write_sob.asm change content to that in the file in git
;;;;;;;;    5. enable scheme library functions
(load "pc.scm")
(load "qq.scm")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(define <Whitespace>
  (const
   (lambda (ch)
     (char<=? ch #\space))))

(define <line-comment>
  (let ((<end-of-line-comment>
	 (new (*parser (char #\newline))
	      (*parser <end-of-input>)
	      (*disj 2)
	      done)))
    (new (*parser (char #\;))
	 
	 (*parser <any-char>)
	 (*parser <end-of-line-comment>)
	 *diff *star

	 (*parser <end-of-line-comment>)
	 (*caten 3)
	 done)))
	 

       

(define <sexpr-comment>
  (new (*parser (word "#;"))

       (*delayed (lambda ()  <Sexpr>))
      
       (*caten 2)
      
       done))
       
(define <infix-comment>
  (new (*parser (word "#;"))

       (*delayed (lambda ()  <AddSub>))
      
       (*caten 2)
      
       done))

(define <comment>
  (disj <line-comment>
	<sexpr-comment>))
	
(define <infcomment>
  (disj <line-comment>
	<infix-comment>))

(define <skip>
  (disj <comment>
	<Whitespace>))
	
(define <skipfix>
  (disj <infcomment>
	<Whitespace>))

(define ^^<wrapped>
  (lambda (<wrapper>)
    (lambda (<p>)
      (new (*parser <wrapper>)
	   (*parser <p>)
	   (*parser <wrapper>)
	   (*caten 3)
	   (*pack-with
	     (lambda (_left e _right) e))
	   done))))

(define ^<skipped*> (^^<wrapped> (star <skip>)))
(define ^<skippedfix*> (^^<wrapped> (star <skipfix>)))

(define skipped-char (lambda (ch)
                        (^<skippedfix*> (char ch))))

(define <Boolean> 
    (new (*parser (char #\#))
         (*parser (char #\f))
         (*caten 2)
         (*pack-with
            (lambda (x y) #f))
         (*parser (char #\#))
         (*parser (char #\t))
         (*caten 2)
         (*pack-with
            (lambda (x y) #t))
         (*disj 2)
        done))

(define <CharPrefix>
  (new (*parser (char #\#))
	(*parser (char #\\))
	(*caten 2)
	done))
	
(define <VisibleSimpleChar> 
       (new (*parser <any-char>)
            (*parser (range (integer->char 0) (integer->char 32)))
            *diff
             (*pack (lambda (x) x))
            done))

	
(define <NamedChar> ;missing page & return 
 (new 
  (*parser (word-ci "lambda"))   (*pack (lambda (cp)
                     (integer->char 955)))
  (*parser (word-ci "newline"))  (*pack (lambda (cp)
                     (integer->char 10)))
  (*parser (word-ci "nul"))      (*pack (lambda (cp)
                     (integer->char 0)))
  (*parser (word-ci "page"))     (*pack (lambda (cp)
                     (integer->char 12)))
  (*parser (word-ci "return"))   (*pack (lambda (cp)
                     (integer->char 13)))
  (*parser (word-ci "space"))    (*pack (lambda (cp)
                     (integer->char 32)))
  (*parser (word-ci "tab"))      (*pack (lambda (cp)
                     (integer->char 9)))
  (*disj 7)
  done))
  
  
  (define <HexDigit>
  (let ((zero (char->integer #\0))
	(lc-a (char->integer #\a))
	(uc-a (char->integer #\A)))
    (new (*parser (range #\0 #\9))
	 (*pack
	  (lambda (ch)
	    (- (char->integer ch) zero)))
	 (*parser (range #\a #\f))
	 (*pack
	  (lambda (ch)
	    (+ 10 (- (char->integer ch) lc-a))))
	 (*parser (range #\A #\F))
	 (*pack
	  (lambda (ch)
	    (+ 10 (- (char->integer ch) uc-a))))
	 (*disj 3)
	 done)))
  
(define <HexChar>

    (new (*parser (range #\0 #\9))
	 (*parser (range #\a #\f))
	 (*parser (range #\A #\F))
	 (*disj 3)
	 done))

(define <HexUnicodeChar>
    (new (*parser (char #\x))
         (*parser <HexDigit>) *plus
	 (*caten 2)
         (*pack-with
            (lambda (x y)
                 (fold-left (lambda (a b)
                        (+ b (* a 16))) 0 y)))
    done))
    
(define <Char>
    (new (*parser <CharPrefix>)
	   (*parser <NamedChar>) (*pack (lambda (x) (list->string (list x))))
	 (*parser <HexUnicodeChar>)
	 
         (*parser <VisibleSimpleChar>)
        
         (*disj 3)
         (*guard (lambda (n) (or (not (integer? n)) (< n 1114111))))
         (*pack (lambda (n) (if (integer? n) 
                                (integer->char n)
                                n)))
         (*caten 2)
         (*pack-with (lambda (x y) y))
          (*delayed (lambda () <Symbol>))
         *not-followed-by

         done))
    
(define <Natural>
    (new (*parser (range #\0 #\9))
	 (*parser (range #\0 #\9)) *star
	 (*caten 2)
	 (*pack-with (lambda (x y) (string->number (list->string  `(,x ,@y)))))
	 done))

(define <Integer>
    (new (*parser (char #\+))
       (*parser <Natural>)
       (*caten 2)
       (*pack-with (lambda (++ n)  n))
       (*parser (char #\-))
       (*parser <Natural>)
       (*caten 2)
       (*pack-with (lambda (-- n) (- n)))
       (*parser <Natural>)
       (*disj 3)
       done))
        

        
        
        
        
        
(define <Fraction>
    (new (*parser <Integer>)
       (*parser (char #\/))
       (*parser <Natural>)
       (*guard (lambda (n) (not (zero? n))))
       (*caten 3)
       (*pack-with
	(lambda (x y z)
	  (/ x z)))
       done))
	
(define <Number>
    (new 
	  (*parser <Fraction>)
	  (*parser <Integer>)
	  (*disj 2)
	  done))
	  
(define <StringLiteralChar> 
    (new (*parser <any-char>)
	 (*parser (char #\\))
	 (*parser (char #\"))
	 (*disj 2)
	 *diff
	 done))
    
(define ^<meta-char>
    (lambda (str ch)
        (new (*parser (word str))
             (*pack (lambda(_) ch))
             done)))
             
(define <StringMetaChar>
  (new (*parser (^<meta-char> "\\\"" #\"))
       (*parser (^<meta-char> "\\n" #\newline))
       (*parser (^<meta-char> "\\r" #\return))
       (*parser (^<meta-char> "\\t" #\tab))
       (*parser (^<meta-char> "\\f" #\page))
       (*parser (^<meta-char> "\\\\" #\\))
       (*disj 6)
       done))
       
         
(define <StringHexChar> 
    (new (*parser (word "\\x"))
         (*parser <HexDigit>)
         *star
         (*parser (char #\;))
         (*caten 3)
         (*pack-with
            (lambda (x y z)
                  (fold-left (lambda (a b)
                        (+ b (* a 16))) 0 y)))
                        (*guard (lambda(n) (< n 1114111)))
                        (*pack (lambda(n) (integer->char n)))
                        done))

         
(define <StringChar>
    (new         
         (*parser <StringHexChar>)
         (*parser <StringMetaChar>)
         (*parser <StringLiteralChar>) ;(*pack (lambda (x) (list->string (list x))))
         (*disj 3)
         done))
         
(define <String>
    (new (*parser (char #\"))
         (*parser <StringChar>) *star
         (*parser (char #\"))
         (*caten 3)
         (*pack-with (lambda (x y z) (list->string y )))
         done))
         
(define <SymbolChar> 
  (new (*parser (range #\0 #\9))
	 (*parser (range #\a #\z))
	 (*parser (range #\A #\Z))
	 (*pack (lambda (n) (integer->char (+ (char->integer n) 32))))
	 (*parser (char #\!))
	 (*parser (char #\$))
	 (*parser (char #\^))
	 (*parser (char #\*))
	 (*parser (char #\-))
	 (*parser (char #\_))
	 (*parser (char #\=))
	 (*parser (char #\+))
	 (*parser (char #\<))
	 (*parser (char #\>))
	 (*parser (char #\?))
	 (*parser (char #\/))
	 (*disj 15)
	 done))
	 
(define <Symbol>
    (new (*parser <SymbolChar>)
         *plus
         (*pack (lambda (x) (string->symbol (list->string x))))
         done))
         
    
(define <InfixPrefixExtensionPrefix>
    (new (*parser (word "##"))
         (*parser (word "#%")) (*disj 2)
	 done))
	 
(define <InfixSymbol>
    (new (*parser <SymbolChar>)
         (*parser (char #\+))
         (*parser (char #\-))
         (*parser (char #\*))
         (*parser (char #\^))
         (*parser (char #\/))
         (*disj 5)
         *diff
         *plus
         (*pack (lambda (x) (string->symbol (list->string x))))
         done))
    

(define <PowerSymbol>
    (new (*parser (char #\^))
	 (*parser (char #\*))
	 (*parser (char #\*))
	 (*caten 2)
	 (*pack-with (lambda (x y) (list->string (list x y))))
	 (*disj 2)
	done))



                        
                      
(define <ProperList>
    (new (*parser (char #\())
         (*delayed (lambda() <Sexpr>)) *star
         (*parser (char #\)))
        (*caten 3)
        (*pack-with (lambda(x y z) y))
    done))
    
(define <ImproperList>
    (new (*parser (char #\())
         (*delayed (lambda() <Sexpr>)) *plus
         (*parser (char #\.))
         (*delayed (lambda() <Sexpr>))
         (*parser (char #\)))
         (*caten 5)
         (*pack-with (lambda (op lst dot el cl)  (append lst el)))
         done))

(define <Vector>
    (new (*parser (char #\#))
         (*parser (char #\())
         (*delayed (lambda() <Sexpr>)) *star
         (*parser (char #\)))
         (*caten 4)
         (*pack-with (lambda(x y z w) (list->vector z)))
         done))
         
(define <Quoted> 
    (new (*parser  (char #\'))
         (*delayed (lambda() <Sexpr>))
         (*caten 2)
         (*pack-with (lambda (x y) `',y))
        done))

(define <QuasiQuoted> 
    (new (*parser  (char #\`))
         (*delayed (lambda() <Sexpr>))
         (*caten 2)
         (*pack-with (lambda (x y) (list 'quasiquote y)))
         done))

(define <Unquoted> 
    (new (*parser (char #\,))
         (*delayed (lambda() <Sexpr>))
         (*caten 2)
         (*pack-with (lambda(x y) (list 'unquote y)))
         done))

(define <UnquoteAndSpliced>
    (^<skipped*> (new (*parser (word ",@"))
         (*delayed (lambda() <Sexpr>))
         (*caten 2)
         (*pack-with (lambda(x y) (list 'unquote-splicing y)))
         done)))
         

  



                 
(define <InfixPow>    (^<skippedfix*> (new 
         (*delayed (lambda () <InfixAtom>))
         (*parser (^<skipped*> <PowerSymbol>))
         (*delayed (lambda () <InfixAtom>))
         (*caten 2)
         (*pack-with (lambda(x y) y))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-right (lambda (num next) `(expt ,num  ,next)) (car (reverse (cons a lst)))  (reverse(cdr (reverse (cons a lst)))))))
         done)))

;; (define <InfixDiv> (^<skipped*>
;;     (new (*delayed (lambda () <InfixDiv>))
;;          
;;          (*delayed (lambda () <InfixDiv>))
;;          (*caten 2)
;;          (*pack-with (lambda(x y) (cons x y)))
;;           *star
;;          (*caten 2)
;;          (*pack-with (lambda(a lst) (fold-left (lambda (num next) `(/ ,num ,(cdr next))) a lst)))
;;          done)))
                
(define <DivMul> (^<skipped*>
    (new (*delayed (lambda () <InfixPow>))
         (*parser (skipped-char #\*))
         (*parser (skipped-char #\/))
         (*disj 2)
         (*delayed (lambda () <InfixPow>))
         (*caten 2)
         (*pack-with (lambda(x y) (cons x y)))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-left (lambda (num next) `(,(string->symbol (string (car next))) ,num ,(cdr next))) a lst)))
         done)))
         
;(define <DivMul> (^<skipped*> (new (*parser <InfixMul>) (*parser <InfixDiv>) (*disj 2) done)))

(define <InfixSub> (^<skipped*>
    (new (*delayed (lambda () <DivMul>))
         (*parser (skipped-char #\-))
         (*delayed (lambda () <DivMul>))
         (*caten 2)
         (*pack-with (lambda(fun num) (cons fun num)))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-left (lambda (num next) `(- ,num ,(cdr next))) a lst)))
         done)))
                
(define <AddSub> (^<skipped*>
    (new (*delayed (lambda () <DivMul>))
         (*parser (skipped-char #\+))
         (*parser (skipped-char #\-))
         (*disj 2)
         (*delayed (lambda () <DivMul>))
         (*caten 2)
         (*pack-with (lambda(fun num) (cons fun num)))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst)  (fold-left (lambda (num next) `(,(string->symbol (string (car next))) ,num ,(cdr next))) a lst)))
         done)))
                
;(define <AddSub> (^<skipped*> (new (*parser <InfixAdd>) (*parser <InfixSub>) (*disj 2) done)))

(define <ClassicExpression> (^<skippedfix*> (new (*parser <AddSub>) done)))

;; (define <InfixArgList> (new (*parser <ClassicExpression>)
;;                     (*parser (char #\,))
;;                     (*parser <ClassicExpression>)
;;                      (*caten 2) (*pack (lambda (x) (cadr x))) *star
;;                      (*parser <epsilon>)
;;                      (*disj 2)
;;                      (*caten 2)
;;                      (*pack-with (lambda (x y) `(,x ,@y)))
;;                      done))


(define <InfixArgList>
   (^<skippedfix*> (new (*parser <ClassicExpression>)
         (*parser (skipped-char #\,))
         (*parser <ClassicExpression>)
         (*caten 2)
         (*pack-with (lambda(x y) y))
         *star
         (*caten 2)
         (*pack-with (lambda(x y) `(,x ,@y)))
         done)))

     
(define <InfixSexprEscape>  (^<skippedfix*> (new (*parser <InfixPrefixExtensionPrefix> ) 
    (*delayed (lambda () <Sexpr>))
    (*caten 2)
    (*pack-with (lambda (x y) y))
    done)))
    
    

(define <terminalo>
    (^<skippedfix*> (new (*parser <Number>)
         (*parser <InfixSymbol>)
         (*parser (range #\0 #\9))
         *diff
         *not-followed-by
         (*delayed (lambda () <InfixSymbol>))
         (*delayed (lambda () <InfixSexprEscape>))
         (*disj 3)
         done)))
           


(define <InfixFuncall> 
    (^<skippedfix*> (new (*delayed (lambda() <InfixParen>))
         (*parser (skipped-char #\())
         (*delayed (lambda() <InfixArgList>))
         (*parser <epsilon>)
         (*disj 2)
         (*parser (skipped-char #\)))
         (*caten 3)
         (*pack-with (lambda (x y z) y))
         *star
         (*caten 2)
         (*pack-with (lambda (a lst) (fold-left (lambda (exp next) `(,exp ,@next)) a lst)))
         (*delayed (lambda() <InfixParen>))
         (*disj 2)
         done)))

                    

                    
(define <InfixParen> 
     (^<skippedfix*> (new (*parser (char #\-))
         (*parser <Number>)
         (*caten 2)
         (*pack-with (lambda (a b) (- b)))
         (*parser (char #\-))
         (*parser <DivMul>)
         (*caten 2)
         (*pack-with (lambda (a b) `(- ,b)))
         (*parser (skipped-char #\())
         (*delayed (lambda() <AddSub>))
         (*parser (skipped-char #\)))
         (*caten 3)
         (*pack-with (lambda (x y z) y))
         (*delayed (lambda() <terminalo>))
         (*disj 4)
         done)))
                     
                     
(define <InfixAtom>    
   (^<skippedfix*> (new    
         (*delayed (lambda () <Fun>))
         (*delayed (lambda() <InfixFuncall>))
         (*parser (skipped-char #\[))
         (*delayed (lambda() <AddandMin>))
         (*parser (skipped-char #\]))
         (*caten 3)
         (*pack-with (lambda(open exp close)exp))
         *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-left (lambda(exp next) `(vector-ref ,exp ,next)) a lst)))
         
        (*disj 2)
;;   
         done)))
         
(define <Fun>
   (new (*delayed (lambda() <InfixFuncall>))
         (*parser (skipped-char #\[))
         (*delayed (lambda() <AddSub>))
         (*parser (skipped-char #\]))
         (*caten 3)
         (*pack-with (lambda(open exp close)exp))
         *star
	 (*parser (skipped-char #\())
         (*delayed (lambda() <InfixArgList>))
         (*parser <epsilon>)
         (*disj 2)
         (*parser (skipped-char #\)))
         (*caten 3)
         (*pack-with (lambda (open exp close) exp))
         *star
         (*caten 3)
         (*pack-with (lambda (a lst flst) (fold-left (lambda(exp next) `(,exp ,@next)) (fold-left (lambda(exp2 next2) `(vector-ref ,exp2 ,next2)) a lst) flst)))
         done))
         
                   
(define <InfixExtension>
  (^<skippedfix*>
    (new (*parser <InfixPrefixExtensionPrefix>)
         (*parser  (^<skippedfix*> <AddSub>))
         (*caten 2)
         (*pack-with (lambda(x y) y))
         done)))
  
(define <Sexpr>
   (^<skipped*>
     (new 
          (*parser <Boolean>)           
          (*parser <Number>)
          (*parser <Symbol>)
          (*parser (range #\0 #\9))
          *diff
          *not-followed-by
          (*parser <Char>)
          (*parser <String>)
          (*parser <Symbol>)
          (*parser <ProperList>)
          (*parser <ImproperList>)
          (*parser <Vector>)
          (*parser <Quoted>)
          (*parser <QuasiQuoted>)
          (*parser <Unquoted>)
          (*parser <UnquoteAndSpliced>)
          (*parser <InfixExtension>)
          (*disj 13)
     done)))

     (define <sexpr-2> <Sexpr>)

;;;;;;;HW2
(define params-getter (lambda (lmd)
    (cond ((equal? 'lambda-simple (car lmd)) (cadr lmd))
	  ((equal? 'lambda-var (car lmd)) (list (cadr lmd)))
	  ((equal? 'lambda-opt (car lmd))  (append (cadr lmd) (list (caddr lmd))))
	  (else '()))))
	  

(define body-getter (lambda (lmd)
    (cond ((or (equal? 'lambda-simple (car lmd)) (equal? 'lambda-var (car lmd))) (caddr lmd))
	  (else (cadddr lmd)))))

(define make-begin
      (lambda (lst)
	    (cond ((= 0 (length lst)) `(const ,@(list (void))))
		  ((= 1 (length lst)) (car lst))
		  (else `(begin ,@lst)))))

(define not-contains-doubles?
        (letrec ((not-car-in-cdr? (lambda (a subl)
                        (cond ((null? subl) #t)
                              ((equal? a (car subl)) #f)
                              (else (not-car-in-cdr? a (cdr subl)))))))
        (lambda (input-list)
            (cond ((null? input-list) #t)
                ((not-car-in-cdr? (car input-list) (cdr input-list)) (not-contains-doubles? (cdr input-list)))
                (else #f)))))

(define *reserved-words*
'(and begin cond define do else if lambda
let let* letrec or quasiquote unquote
unquote-splicing quote set!))
     
(define const_?
    (lambda (c)
        (or (null? c) (vector? c) (boolean? c) (char? c) (number? c) (string? c) (quote? c))))
     
(define parse-quote 
    (lambda (q)
        `(const ,(cadr q))))
        
(define parse-const
    (lambda (c)
        (if (quote? c) (parse-quote c)
            `(const ,c))))

(define not-reserved?
    (letrec ((not-in-list? (lambda (x lst)
                (cond ((null? lst) #t)
                      ((equal? (car lst) x) #f)
                      (else (not-in-list? x (cdr lst)))))))
    (lambda (x)
        (not-in-list? x *reserved-words*))))
            
(define var?
    (lambda (v)
        (and (symbol? v) (not-reserved? v))))
        
        
(define parse-var
    (lambda (v)
        `(var ,v)))

(define if3?
    (lambda (sxpr) 
        (and (list? sxpr) (or (= 4 (length sxpr)) (= 3 (length sxpr)) ) (equal? 'if (car sxpr)) )))
        
        
(define parse-if3
     (lambda (sxpr)
        (if (= 4 (length sxpr))
            `(if3 ,(morgan (cadr sxpr)) ,(morgan (caddr sxpr)) ,(morgan (cadddr sxpr)))
            `(if3 ,(morgan (cadr sxpr)) ,(morgan (caddr sxpr)) ,`(const ,@(list (void)))))))
            
(define and? 
    (lambda (sxpr)
                (and (list? sxpr) (< 0 (length sxpr)) (equal? 'and (car sxpr)))))

(define parse-and
    (letrec ((rex (lambda (lst)
            (if (= 1 (length lst)) (morgan (car lst))
                `(if3 ,(morgan (car lst)) ,(rex (cdr lst)) ,(morgan #f))))))
    (lambda (sxpr)
        (if (= 1 (length sxpr)) (morgan #t)
            (rex (cdr sxpr))))))
              

            
(define applic?
    (lambda (sxpr)
        (and (list? sxpr) (< 0 (length sxpr)) (not-reserved? (car sxpr)))) )

(define parse-applic
    (lambda (sxpr)
        `(applic ,(morgan (car sxpr)) ,(map morgan (cdr sxpr)))))
    
            
(define or?
    (lambda (sxpr)
        (and (list? sxpr) (< 0 (length sxpr)) (equal? 'or (car sxpr)))))

(define parse-or
    (lambda (sxpr)
        (cond ((= 1 (length sxpr)) (morgan #f))
              ((= 2 (length sxpr)) (morgan (cadr sxpr)))
             (else `(or ,(map morgan (cdr sxpr)))))))
        
(define lambda-simple?
    (letrec ((proper-list-of-vars? (lambda (lst)
                (cond ((null? lst) #t)
                      ((var? (car lst)) (proper-list-of-vars? (cdr lst)))
                      (else #f)))))
    (lambda (sxpr)
        (and (list? sxpr) (< 2 (length sxpr)) (equal? 'lambda (car sxpr)) (list? (cadr sxpr)) (not-contains-doubles? (cadr sxpr)) (proper-list-of-vars? (cadr sxpr))))))

(define parse-lambda-simple
    (lambda (sxpr)
        `(lambda-simple ,(cadr sxpr) ,(morgan (make-begin (cddr sxpr))))))

(define lambda-opt?
    (letrec ((improper-list-of-vars? (lambda (lst)
                (cond ((null? (cdr lst)) #f)
                      ((and (var? (car lst)) (var? (cdr lst))) #t) 
                      ((and (var? (car lst)) (var? (cadr lst))) (improper-list-of-vars? (cdr lst)))
                      (else #f)))))
    (lambda (sxpr)
        (and (list? sxpr) (< 2 (length sxpr)) (equal? 'lambda (car sxpr)) (pair? (cadr sxpr)) (improper-list-of-vars? (cadr sxpr))))))

(define parse-lambda-opt
    (letrec ((pre-dot (lambda (lst)
                (if (var? (cdr lst)) (list (car lst))
                    (cons (car lst) (pre-dot (cdr lst))))))
             (post-dot (lambda (lst)
                (if (var? (cdr lst)) (cdr lst)
                    (post-dot (cdr lst))))))
    (lambda (sxpr)
        `(lambda-opt ,(pre-dot (cadr sxpr)) ,(post-dot (cadr sxpr)) ,(morgan (make-begin (cddr sxpr)))))))

(define lambda-var?
    (lambda (sxpr)
        (and (list? sxpr) (< 2 (length sxpr)) (equal? 'lambda (car sxpr)) (var? (cadr sxpr)))))

(define parse-lambda-var
    (lambda (sxpr)
        `(lambda-var ,(cadr sxpr) ,(morgan (make-begin (cddr sxpr))))))
        
(define def-reg?
    (lambda (sxpr)
        (and (list? sxpr) (= 3 (length sxpr)) (equal? 'define (car sxpr)) (var? (cadr sxpr)))))

(define parse-def-ref
    (lambda (sxpr)
        `(def ,(morgan (cadr sxpr)) ,(morgan (caddr sxpr)))))
        
(define def-mit?
    (letrec ((proper-list-of-vars? (lambda (lst)
                (cond ((null? lst) #t)
                      ((var? (car lst)) (proper-list-of-vars? (cdr lst)))
                      (else #f))))
            (improper-list-of-vars? (lambda (lst)
                (cond ((null? (cdr lst)) #f)
                      ((and (var? (car lst)) (var? (cdr lst))) #t) 
                      ((and (var? (car lst)) (var? (cadr lst))) (improper-list-of-vars? (cdr lst)))
                      (else #f)))))
    (lambda (sxpr) 
        (and (list? sxpr) (< 2 (length sxpr)) (equal? 'define (car sxpr)) (or (and (list? (cadr sxpr)) (< 0 (length (cadr sxpr))) (proper-list-of-vars? (cadr sxpr))) (and (pair? (cadr sxpr)) (improper-list-of-vars? (cadr sxpr))))))))
        


(define parse-def-mit
    (let ((var-lst (lambda (lst)
                (cadr lst)))
          (proc-name (lambda (lst)
                (morgan (car lst))))
          (proc-vars (lambda (lst)
                (cdr lst)))
          (proc-body (lambda (lst)
                (cddr lst))))
    (lambda (sxpr)
        `(def ,(proc-name (var-lst sxpr))  ,(morgan `(lambda ,(proc-vars (var-lst sxpr)) ,@(proc-body sxpr)))))))
        
 (define let?
    (letrec ((lop? (lambda (lst)
	      (cond ((null? lst) #t)
		    ((and (pair? (car lst)) (var? (caar lst))) (lop? (cdr lst)))
		    (else #f))))
            (proc-vars (lambda (lst)
		    (if (null? lst) '()
			 (cons (caar lst) (proc-vars (cdr lst)))))))
    (lambda (sxpr)
	  (and (list? sxpr) (< 2 (length sxpr)) (equal? 'let (car sxpr)) (list? (cadr sxpr)) (lop? (cadr sxpr)) (not-contains-doubles? (proc-vars (cadr sxpr))) ))))
	  
 (define parse-let
      (letrec ((proc-vars (lambda (lst)
		    (if (null? lst) '()
			 (cons (caar lst) (proc-vars (cdr lst))))))
		(proc-exps (lambda (lst)
		    (if (null? lst) '()
			  (cons (cadar lst) (proc-exps (cdr lst))))))
		(lambda-expr (lambda (sxpr) `(lambda ,(proc-vars (cadr sxpr)) ,@(cddr sxpr)))))
	(lambda (sxpr)
	    (morgan `( ,(lambda-expr sxpr) ,@(proc-exps (cadr sxpr)))))))
    
 (define let-star?
    (letrec ((lop? (lambda (lst)
	      (cond ((null? lst) #t)
		    ((and (pair? (car lst)) (var? (caar lst))) (lop? (cdr lst)))
		    (else #f)))))
    (lambda (sxpr)
	  (and (list? sxpr) (< 2 (length sxpr)) (equal? 'let* (car sxpr)) (list? (cadr sxpr)) (lop? (cadr sxpr))))))
	  
(define parse-let-star
    (letrec ;((args (lambda (sxpr) (cadr sxpr)))
	    ;(body (lambda (sxpr) (cddr sxpr)))
	    ((nested-let (lambda (args body) 
		    (if (= 1 (length args)) 
			  `(let ,args ,@body)
			  `(let ,(list (car args)) ,(nested-let (cdr args) body))))))
    (lambda (sxpr)
	  (if (= 0 (length (cadr sxpr))) (morgan `(let ,(list) ,@(cddr sxpr)))
	  (morgan (nested-let (cadr sxpr) (cddr sxpr)))))))
	  
(define set?
    (lambda (sxpr)
	(and (list? sxpr) (= 3 (length sxpr)) (equal? 'set! (car sxpr)) (var? (cadr sxpr)))))
	
(define parse-set
    (lambda (sxpr)
	`(set ,(morgan (cadr sxpr)) ,(morgan (caddr sxpr)))))
	  
(define letrec?
	(letrec ((lop? (lambda (lst)
	      (cond ((null? lst) #t)
		    ((and (pair? (car lst)) (var? (caar lst))) (lop? (cdr lst)))
		    (else #f)))))
    (lambda (sxpr)
	  (and (list? sxpr) (< 2 (length sxpr)) (equal? 'letrec (car sxpr)) (list? (cadr sxpr)) (lop? (cadr sxpr))))))

(define parse-letrec
	(letrec ((proc-vars (lambda (lst)
		    (if (null? lst) '()
			 (cons (caar lst) (proc-vars (cdr lst))))))
		(proc-exps (lambda (lst)
		    (if (null? lst) '()
			  (cons (cadar lst) (proc-exps (cdr lst))))))
		(proc-body (lambda (sxpr)
		      `(lambda ,(list) ,@(cddr sxpr))))
		(proc-whatever (lambda (sxpr)
		      `(,(proc-body sxpr) ))))
	(lambda (sxpr)
	      (morgan `(let ,(map (lambda (v) (list v #f)) (proc-vars (cadr sxpr)))
			    ,@(map (lambda (var val) `(set! ,var ,val)) (proc-vars (cadr sxpr)) (proc-exps (cadr sxpr)))
			     ,(proc-whatever sxpr))))))
			     
(define cond?
      (letrec ((rex (lambda (lst)
		  (cond ((and (= 1 (length lst)) (pair? (car lst))) #t)
			((and (pair? (car lst)) (not (equal? 'else (caar lst))) (rex (cdr lst))))
			(else #f)))))
     (lambda (sxpr)
	  (and (list? sxpr) (< 1 (length sxpr)) (equal? 'cond (car sxpr)) (< 0 (length (cdr sxpr))) (rex (cdr sxpr))))))
	  
(define parse-cond
	(letrec ((rex (lambda (lst)
		  (cond ((and (= 1 (length lst)) (equal? 'else (caar lst) ))  (make-begin (cdar lst)))
			(( = 1 (length lst)) `(if ,(caar lst) ,(make-begin (cdar lst) )))
			(else `(if ,(caar lst) ,(make-begin (cdar lst)) ,(rex (cdr lst))))))))
	(lambda (sxpr) 
	    (morgan (rex (cdr sxpr))))))

(define begin?
    (lambda (sxpr)
	(and (list? sxpr) (< 0 (length sxpr)) (equal? 'begin (car sxpr)))))

(define parse-begin
      (letrec ((rex (lambda (lst)
		  (cond ((null? lst) (list))
			((begin? (car lst)) (append (rex (cdr (car lst))) (rex (cdr lst))))
			(else (cons (morgan (car lst) ) (rex (cdr lst))))))))
    (lambda (sxpr)
	(cond ((= 1 (length sxpr)) `(const ,@(list (void))))
	      ((= 2 (length sxpr)) (morgan (cadr sxpr)))
	      (else `(seq ,(rex (cdr sxpr))))))))
	      
(define quasiquote?
    (lambda (sxpr)
	  (and (list? sxpr) (= 2 (length sxpr)) (equal? 'quasiquote (car sxpr)))))
	  
(define parse-quasiquote
    (lambda (sxpr)
	(morgan (expand-qq (cadr sxpr)))))
			  
        
(define def-to-letrec?
      (letrec ((define-in-body (lambda (lst)
			(cond ((null? lst) '())
                              ((equal? 'seq (car lst)) (define-in-body (cadr lst)))
                              ((and (list? (car lst)) (not (null? (car lst))) (equal? 'def (caar lst))) (cons (cdr (car lst)) (define-in-body (cdr lst))))
                              (else (define-in-body (cdr lst))))))
		)
      (lambda (sxpr)
	  (if (and (list? sxpr) (< 2 (length sxpr)) (or (equal? 'lambda-simple (car sxpr))
		  (equal? 'lambda-opt (car sxpr))
		  (equal? 'lambda-var (car sxpr))))        
	      (if (null? (define-in-body (body-getter sxpr))) #f
			#t) ;`(,(car sxpr) ,(cadr sxpr) (letrec ,(define-in-body (body sxpr)) ,(eliminated-body  (body sxpr)))))
	      #f))))
	      
(define parse-def-to-letrec
      (letrec ((define-in-body (lambda (lst)
			(cond ((null? lst) '())
                              ((equal? 'seq (car lst)) (define-in-body (cadr lst)))
                              ((and (list? (car lst)) (not (null? (car lst))) (equal? 'def (caar lst))) (cons (cons 'set (cdr (car lst))) (define-in-body (cdr lst))))
                              (else (define-in-body (cdr lst))))))
		(eliminated-body (lambda (lst) 
				(cond ((null? lst) '()) 
                                      ((equal? 'seq (car lst)) (cons 'seq (list (eliminated-body (cadr lst)))))
                                      ((and (list? (car lst)) (not (null? (car lst))) (equal? 'def (caar lst))) (cons `(set ,@(cdr (car lst))) (eliminated-body (cdr lst))))
				      (else (cons (car lst) (eliminated-body (cdr lst)))))))
                (listvars (lambda (lst) 
                            (cond ((null? lst) '())
                                  (else (cons (cadr (cadr (car lst))) (listvars (cdr lst)))))))
                 (header (lambda (sxpr) (if (equal? 'lambda-opt (car sxpr)) (list (car sxpr) (cadr sxpr) (caddr sxpr)) (list (car sxpr) (cadr sxpr)))))
                )
      (lambda (sxpr)
	  (eliminate-nested-defines   `(,@(header sxpr) (applic (lambda-simple ,(listvars (define-in-body (body-getter sxpr)))   ,(eliminated-body  (body-getter sxpr)))
                                                        ,(map (lambda (x) `(const #f))  (listvars (define-in-body (body-getter sxpr))))))))))
        
;; (define el-define-switch #f)
;; (define el-res "error1: expression not parsed") ;;issue to solve - if eliminate activated after regualr parse the result will be incorrect
;; (define el-res-set (lambda (sxpr)
;; 	     (set! el-res sxpr)))
;;   
;; DO NOT DELETE         
(define morgan
    (lambda (sxpr)
	;(begin (el-res-set sxpr)
	  (cond
		((const_? sxpr) (parse-const sxpr))
		((var? sxpr) (parse-var sxpr))
		((if3? sxpr) (parse-if3 sxpr))
		((and? sxpr) (parse-and sxpr))
		((or? sxpr) (parse-or sxpr))
		((lambda-simple? sxpr) (parse-lambda-simple sxpr))
		((lambda-opt? sxpr) (parse-lambda-opt sxpr))
		((lambda-var? sxpr) (parse-lambda-var sxpr))
		((def-reg? sxpr) (parse-def-ref sxpr))
		((def-mit? sxpr) (parse-def-mit sxpr))
		((set? sxpr) (parse-set sxpr))
		((let? sxpr) (parse-let sxpr))
		((let-star? sxpr) (parse-let-star sxpr))
		((letrec? sxpr) (parse-letrec sxpr))
		((cond? sxpr) (parse-cond sxpr))
		((begin? sxpr) (parse-begin sxpr))
		((applic? sxpr) (parse-applic sxpr))
		((quasiquote? sxpr) (parse-quasiquote sxpr))
		(else "ERROR"))))
		
(define parse (lambda (sxpr)
	 (morgan sxpr)))
              

;HW3

;; (define *test-expr*
;;     '(define my-even?
;; 	(lambda (e)
;; 	  (define even? (lambda (n) (or (zero? n) (odd? (- n 1)))))
;; 	  (define odd?
;; 	      (lambda (n) (and (positive? n) (even? (- n 1)))))
;; 	  (even? e))))

;;;;;;;;;;;;;;;;;;;;;;;;;DRAFT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (define def-to-letrec
;;       (letrec ((rex (lambda (lst)
;; 		  (cond ((null? lst) (list))
;; 			((begin? (car lst)) (append (rex (cdr (car lst))) (rex (cdr lst))))
;; 			(else (cons (car lst)  (rex (cdr lst)))))))
;; 	       (body (lambda (sxpr) (rex (make-begin (cddr sxpr)))))
;; 	       (define-in-body (lambda (lst)
;; 			(cond ((null? lst) '())
;; 			      ((def-reg? (car lst)) (cons (cdr (car lst)) (define-in-body (cdr lst))))
;; 			      ((def-mit? (car lst)) (cons 
;; 				      `( ,(car (cadr (car lst))) (lambda ,(cdr (cadr (car lst)))
;; 					  (cddr lst))) (define-in-body (cdr lst))))
;; 			      (else (define-in-body (cdr lst))))))
;; 		(eliminated-body (lambda (lst) 
;; 				(cond ((null? lst) '())
;; 				      ((or (def-reg? (car lst)) (def-mit? (car lst))) (eliminated-body (cdr lst)))
;; 				      (else (cons (car lst) (eliminated-body (cdr lst))))))))
;;       (lambda (sxpr)
;; 	  (if (or (lambda-simple? sxpr)
;; 		  (lambda-opt? sxpr) 
;; 		  (lambda-var? sxpr)
;; 		  (def-mit? sxpr) 
;; 		  (let? sxpr)
;; 		  (let-star? sxpr)
;; 		  (letrec? sxpr))
;; 	      (if (null? (define-in-body (body sxpr))) sxpr
;; 			`(,(car sxpr) ,(cadr sxpr) (letrec ,(define-in-body (body sxpr)) ,(eliminated-body  (body sxpr)))))
;; 	      sxpr))))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; 
;; 
;; (define def-el-no-idea 'lala)
;; (define pullswitch-el-define
;; 	(lambda ()
;; 	      (begin (set! el-define-switch #t) (set! def-el-no-idea (morgan el-res)) (set! el-res "error2: expression not parsed") (set! el-define-switch #f))))
;; 
;; 	      
;; (define eliminate-nested-defines
;; 	(lambda (obj)
;; 	      (begin (pullswitch-el-define) def-el-no-idea)))

(define eliminate-nested-defines (lambda (sxpr) 
            (cond ((null? sxpr) '())
                  ((def-to-letrec? sxpr) (parse-def-to-letrec sxpr))
                  ((list? sxpr) (cons (eliminate-nested-defines (car sxpr)) (eliminate-nested-defines (cdr sxpr))))
                  (else sxpr))))
	      
;; HW3- part 4


(define reduntunt-lambda-applic?
      (lambda (sxpr)
	    (and (list? sxpr) (= 3 (length sxpr)) (equal? 'applic (car sxpr)) ;applic content
	    (list? (cadr sxpr)) (= 3 (length (cadr sxpr))) (equal? 'lambda-simple (car (cadr sxpr))) ;lambda-simple content
	    (list? (cadr (cadr sxpr))) (= 0 (length (cadr (cadr sxpr)))) ;lambda-simple-params
	    (list? (caddr sxpr)) (= 0 (length (caddr sxpr)))))) 
	    
(define parse-reduntunt-lambda-applic
      (lambda (sxpr)
	  (remove-applic-lambda-nil (caddr (cadr sxpr)))))
	  

(define remove-applic-lambda-nil
      (lambda (sxpr)
	  (cond ((null? sxpr) '())
		((reduntunt-lambda-applic? sxpr) (parse-reduntunt-lambda-applic sxpr))
		((list? sxpr) (cons (remove-applic-lambda-nil (car sxpr)) (remove-applic-lambda-nil (cdr sxpr))))
		(else sxpr))))


;;HW3- part 5

(define bound-var? 
    (letrec ((v-in-sxpr (lambda (v sxpr)
		  (cond ((null? sxpr) #f)
			((list? sxpr) (or (v-in-sxpr v (car sxpr)) (v-in-sxpr v (cdr sxpr))))
			((equal? v sxpr) #t)
			(else #f))))
	    (v-not-param (lambda (v sxpr) (not (member v (params-getter sxpr)))))	      
	    (lambda? (lambda (v sxpr) (and (list? sxpr) (< 2 (length sxpr)) (or (and (v-not-param v sxpr) (equal? 'lambda-simple (car sxpr)))
					  (and (v-not-param v sxpr) (equal? 'lambda-var (car sxpr))) (and (v-not-param v sxpr) (equal? 'lambda-opt (car sxpr)))))))
	    (rex (lambda (v sxpr)
		  (cond ((null? sxpr) #f)
			((lambda? v sxpr) (v-in-sxpr v sxpr))
			((list? sxpr) (or (rex v (car sxpr)) (rex v (cdr sxpr))))
			(else #f)))))
    (lambda (v scope)
	(rex v scope))))
  
  
(define set-equal? (lambda (v sxpr) (and (list? sxpr) (= 3 (length sxpr)) (equal? 'set (car sxpr)) (equal? v (cadr (cadr sxpr))))))
  
(define has-set?   
(letrec ((v-param (lambda (v sxpr)   (member v (params-getter sxpr))))	      
	    (lambda? (lambda (v sxpr) (and (list? sxpr) (< 2 (length sxpr)) (or (and  (equal? 'lambda-simple (car sxpr)) (v-param v sxpr))
					  (and (equal? 'lambda-var (car sxpr)) (v-param v sxpr)) (and  (equal? 'lambda-opt (car sxpr)) (v-param v sxpr)))))))
      (lambda (v sxpr)
	    (cond ((null? sxpr) #f)
		  ((lambda? v sxpr) #f)
		  ((set-equal? v sxpr) #t)
		  ((list? sxpr) (or (has-set? v (car sxpr)) (has-set? v (cdr sxpr))))
		  (else #f)))))
		  
(define has-get?
(letrec ((v-param (lambda (v sxpr) (member v (params-getter sxpr))))	      
	    (lambda? (lambda (v sxpr) (and (list? sxpr) (< 2 (length sxpr)) (or (and (v-param v sxpr) (equal? 'lambda-simple (car sxpr)))
		(and (v-param v sxpr) (equal? 'lambda-var (car sxpr))) (and (v-param v sxpr) (equal? 'lambda-opt (car sxpr))))))))
    (lambda (v sxpr)
	   (cond ((null? sxpr) #f)
		((lambda? v sxpr)  #f)
		 ((set-equal? v sxpr) (has-get? v (caddr sxpr)))
		 ((and (list? sxpr) (= 2 (length sxpr)) (equal? 'var (car sxpr)) (equal? v (cadr sxpr))) #t)
		 ((list? sxpr) (or (has-get? v (car sxpr)) (has-get? v (cdr sxpr))))
		 (else #f)))))
		 
(define box-param?
     (lambda (v scope)
	  (and (bound-var? v scope) (has-set? v scope) (has-get? v scope))))
	  
(define list-of-box-params
    (letrec ((rex (lambda (sxpr lst)
		(cond ((null? lst) '())
		      ((box-param? (car lst) sxpr) (cons (car lst) (rex sxpr (cdr lst))))
		      (else (rex sxpr (cdr lst)))))))
    (lambda (scope list-of-vars)
	  (reverse (rex scope list-of-vars)))))
	  
(define readd-box-param
    (letrec ((v-param (lambda (v sxpr)  (member v (params-getter sxpr))))
	    (lambda-with-param? (lambda (v sxpr) (and (list? sxpr) (< 2 (length sxpr)) (or (and (v-param v sxpr) (equal? 'lambda-simple (car sxpr)))
					 (and (v-param v sxpr) (equal? 'lambda-var (car sxpr))) (and (v-param v sxpr) (equal? 'lambda-opt (car sxpr)))))))
	    (rex (lambda (v sxpr)
		(cond ((null? sxpr) '())
		      ((lambda-with-param? v sxpr) sxpr)
		      ((set-equal? v sxpr) `(box-set ,(cadr sxpr) ,(rex v (caddr sxpr))))
		      ((and (list? sxpr) (= 2 (length sxpr)) (equal? 'var (car sxpr)) (equal? v (cadr sxpr)))
					    `(box-get ,sxpr))
		      ((list? sxpr) (cons (rex v (car sxpr)) (rex v (cdr sxpr))))
		      (else sxpr)))))
    (lambda (v scope)
	(if (equal? 'seq (car scope)) 
		 `(seq ((set (var ,v) (box (var ,v))) ,@(rex v (cadr scope))))
		 `(seq ((set (var ,v) (box (var ,v))) ,(rex v  scope)))))))
		 
(define box-lambda-expr 
      (letrec ((header (lambda (sxpr) (if (equal? 'lambda-opt (car sxpr)) (list (car sxpr) (cadr sxpr) (caddr sxpr)) (list (car sxpr) (cadr sxpr)))))
	      (scope (lambda (sxpr) (if (equal? 'lambda-opt (car sxpr)) (cadddr sxpr) (caddr sxpr))))
	      (params (lambda (sxpr) (params-getter sxpr)))
	      (rex (lambda (scope box-params)
		    (cond ((null? box-params) scope)
			  (else (readd-box-param (car box-params) (rex scope (cdr box-params))))))))
	(lambda (sxpr)
	    
		`( ,@(header sxpr) ,@(list (box-set (rex (scope sxpr) (list-of-box-params (scope sxpr) (reverse (params sxpr))))))))))
		
(define box-set (lambda (sxpr)
	  (cond  ((null? sxpr) '())
		 ((and (list? sxpr) (< 2 (length sxpr)) (or (equal? 'lambda-opt (car sxpr)) (equal? 'lambda-simple (car sxpr)) (equal? 'lambda-var (car sxpr))))
				(box-lambda-expr sxpr))
		 ((list? sxpr) (cons (box-set (car sxpr)) (box-set (cdr sxpr))))
		 (else sxpr))))
		 
		 
;;HW3- part 6

;(lambda (a b c) (lambda (d e f) (..)))


(define index-slave 
      (letrec ((lambda? (lambda (sxpr) (and (list? sxpr) (< 2 (length sxpr)) (or (equal? 'lambda-simple (car sxpr))
					  (equal? 'lambda-var (car sxpr)) (equal? 'lambda-opt (car sxpr))))))
	      (header (lambda (sxpr) (if (equal? 'lambda-opt (car sxpr)) (list (car sxpr) (cadr sxpr) (caddr sxpr)) (list (car sxpr) (cadr sxpr))))))
      (lambda (v adress sxpr lst i)
	 (cond  ((null? sxpr) '())
		((lambda? sxpr) (append (header (enslave-sxpr sxpr)) (list (annotate-scope (body-getter (enslave-sxpr sxpr)) lst (+ i 1)))))
		
		((and (list? sxpr) (equal? 'var (car sxpr)) (equal? v (cadr sxpr))) adress)
		((list? sxpr) (cons (index-slave v adress (car sxpr) lst i) (index-slave v adress (cdr sxpr) lst i)))
		(else sxpr)))))
		
		
(define rename-vars
      (let ((buzz (lambda (qq) (cons (car qq) (cons (car (reverse (cdr qq))) (reverse (cdr (reverse (cdr qq))) ))))))
      (lambda (scope reversed-lst prefix lst i)
	    (cond ((null? reversed-lst) scope)
		  (else (index-slave (car reversed-lst) (buzz (append prefix (list (- (length reversed-lst) 1) (car reversed-lst))) )
			      (rename-vars scope (cdr reversed-lst) prefix lst i) lst i))))))
			

(define annotate-scope
      (lambda (scope reversed-lst i)
	  (rename-vars scope reversed-lst  `(bvar ,i) reversed-lst i)))

(define enslave-sxpr 
	  (let ((lambda? (lambda (sxpr) (and (list? sxpr) (< 2 (length sxpr)) (or (equal? 'lambda-simple (car sxpr)) (equal? 'lambda-var (car sxpr))
					   (equal? 'lambda-opt (car sxpr))))))
		(params (lambda (sxpr) (params-getter sxpr)))
		(header (lambda (sxpr) (if (equal? 'lambda-opt (car sxpr)) (list (car sxpr) (cadr sxpr) (caddr sxpr)) (list (car sxpr) (cadr sxpr))))))
	(lambda (sxpr)
	     (append (header sxpr) (list (rename-vars (body-getter sxpr) (reverse (params sxpr)) `(pvar) (reverse (params sxpr)) -1))) )))
	    
(define annotate-expression (lambda (sxpr)
	  (let ((lambda? (lambda (sxpr) (and (list? sxpr) (< 2 (length sxpr)) (or (equal? 'lambda-simple (car sxpr)) (equal? 'lambda-var (car sxpr))
					   (equal? 'lambda-opt (car sxpr)))))))
	  (cond ((null? sxpr) '())
		((and (lambda? sxpr) (< 0 (length (params-getter sxpr)))) (enslave-sxpr sxpr))
		((list? sxpr) (cons (annotate-expression (car sxpr)) (annotate-expression (cdr sxpr))))
		(else sxpr)))))
		
(define pe->lex-pe (lambda (sxpr)
      (letrec ((anot (annotate-expression sxpr))
	      (rex (lambda (sxpr)
		      (cond ((null? sxpr) '())
			    ((and (list? sxpr) (= 2 (length sxpr)) (equal? 'var (car sxpr))) (cons 'fvar (cdr sxpr)))
			    ((list? sxpr) (cons (rex (car sxpr)) (rex (cdr sxpr))))
			    (else sxpr)))))
	(rex anot))))
		      

;;HW3- part 7


(define hw3var-or-const?
    (lambda (sxpr) (and (list? sxpr) (< 0 (length sxpr)) (or (equal? 'var (car sxpr)) (equal? 'const (car sxpr))))))
   
   ;or
   
(define hw3if3?
    (lambda (sxpr) (and (list? sxpr) (< 0 (length sxpr)) (equal? 'if3 (car sxpr)))))
    
(define hw3seq?
    (lambda (sxpr) (and (list? sxpr) (< 0 (length sxpr)) (equal? 'seq (car sxpr)))))
    
(define hw3def?
    (lambda (sxpr) (and (list? sxpr) (< 0 (length sxpr)) (equal? 'def (car sxpr)))))
    
(define hw3lambda?
    (lambda (sxpr) (and (list? sxpr) (< 0 (length sxpr)) (or (equal? 'lambda-simple (car sxpr)) (equal? 'lambda-opt (car sxpr)) (equal? 'lambda-var (car sxpr))))))
    
(define hw3applic?
    (lambda (sxpr) (and (list? sxpr) (< 0 (length sxpr)) (equal? 'applic (car sxpr)))))
    
    



(define annotate-tc (lambda (sxpr) 
            (letrec ((header (lambda (sxpr) (if (equal? 'lambda-opt (car sxpr)) (list (car sxpr) (cadr sxpr) (caddr sxpr)) (list (car sxpr) (cadr sxpr)))))
		    (tc-map-last (lambda (lst tp?)
                                        (cond ((null? lst) '())
                                              ((= 1 (length lst)) (list (anotate (car lst) tp?)))
                                              (else (cons (anotate (car lst) #f) (tc-map-last (cdr lst) tp?))))))
                                            
                        (anotate (lambda (sxpr tp?)
                            (cond ((not (list? sxpr)) sxpr)
                                  ((hw3var-or-const? sxpr) sxpr)
                                  ((or? sxpr) `(or ,(tc-map-last (cadr sxpr) tp?)))
                                  ((hw3seq? sxpr) `(seq ,(tc-map-last (cadr sxpr) tp?)))
                                  ((hw3if3? sxpr) `(if3 ,(anotate (cadr sxpr) #f)  ,(anotate (caddr sxpr) tp?)  ,(anotate (cadddr sxpr) tp?)))
                                  ((hw3def? sxpr) `(def ,(cadr sxpr) ,(anotate (caddr sxpr) tp?)))
                                  ((hw3lambda? sxpr) `(,@(header sxpr) ,(anotate (body-getter sxpr) #t))) 
                                  ((and tp? (hw3applic? sxpr)) `(tc-applic ,(anotate (cadr sxpr) #f) ,(tc-map-last (caddr sxpr) #f)))
                                  ((hw3applic? sxpr) `(applic ,(anotate (cadr sxpr) #f) ,(tc-map-last (caddr sxpr) #f)))
                                   (else (map (lambda(e) (anotate e #f)) sxpr))))))
                        (anotate sxpr #f))))


;;proj           

(define print-index 0)                   
(define print-ret-val (lambda ()
    (begin (set!  print-index ( + 1 print-index))
    `(CMP (R0 ,p IMM(SOB_VOID)) ,@comm_del
      JUMP_EQ (,(string->symbol (string-append "NO_RET_VAL_" (number->string print-index)))) ,@comm_del
      PUSH (R0) ,@comm_del
      CALL(WRITE_SOB) ,@comm_del
      DROP(1) ,@comm_del
      PUSH (IMM(10)) ,@comm_del
      CALL(PUTCHAR) ,@comm_del
      DROP(1) ,@comm_del
      ,(string->symbol (string-append "NO_RET_VAL_" (number->string print-index))) ,@ass_label))))


(define file->string
  (lambda (in-file)
    (let ((in-port (open-input-file in-file)))
        (letrec ((run
            (lambda ()
                (let ((ch (read-char in-port)))
                    (if (eof-object? ch)
                        (begin
                            (close-input-port in-port)
                                '())
                        (cons ch (run)))))))
        (list->string
            (run))))))
            
(define list-sxprs
  (letrec ((rex (lambda (str)
	      (cond ((equal? str "") '())
		    (else (cons (cadr (car (test-string <Sexpr> str))) (rex (cadr (cadr (test-string <Sexpr> str))))))))))
  (lambda (str)
	 (rex str))))
	 
(define lib-function-mem-list
    (lambda (offset)
        `((append ,offset) (apply ,(+ 1 offset)) (<  ,(+ 2 offset)) (= ,(+ 3 offset)) (> ,(+ 4 offset)) (+ ,(+ 5 offset)) (/ ,(+ 6 offset))
          (* ,(+ 7 offset)) (- ,(+ 8 offset)) (boolean? ,(+ 9 offset)) (car ,(+ 10 offset)) (cdr ,(+ 11 offset)) (char->integer ,(+ 12 offset))
          (char? ,(+ 13 offset)) (cons ,(+ 14 offset)) (denominator ,(+ 15 offset)) (eq? ,(+ 16 offset)) (integer? ,(+ 17 offset)) (integer->char ,(+ 18 offset) )
          (list ,(+ 19 offset)) (make-string ,(+ 20 offset)) (make-vector ,(+ 21 offset)) (map ,(+ 22 offset)) (not ,(+ 23 offset)) (null? ,(+ 24 offset))
          (number? ,(+ 25 offset)) (numerator ,(+ 26 offset)) (pair? ,(+ 27 offset)) (procedure? ,(+ 28 offset)) (rational? ,(+ 29 offset)) (remainder ,(+ 30 offset))
          (set-car! ,(+ 31 offset)) (set-cdr! ,(+ 32 offset)) (string-length ,(+ 33 offset)) (string-ref ,(+ 34 offset)) (string-set! ,(+ 35 offset))
          (string->symbol ,(+ 36 offset)) (string? ,(+ 37 offset)) (symbol? ,(+ 38 offset)) (symbol->string ,(+ 39 offset)) (vector ,(+ 40 offset))
          (vector-length ,(+ 41 offset)) (vector-ref ,(+ 42 offset)) (vector-set! ,(+ 43 offset)) (vector? ,(+ 44 offset)) (zero? ,(+ 45 offset) )
          (bin-plus ,(+ 46 offset)) (bin-minus ,(+ 47 offset)) (bin-mul ,(+ 48 offset)) (bin-div ,(+ 49 offset))  (bin-eq ,(+ 50 offset))
          (bin-smaller ,(+ 51 offset)) (bin-bigger ,(+ 52 offset)) (fraction? ,(+ 53 offset)) (make-fraction ,(+ 54 offset)) 
          (bin-append ,(+ 55 offset)) 
)))
       
(define get-fvar-tbl
      (letrec ((rex (lambda (e)
    (cond 
      ((and (pair? e) (equal? 'fvar (car e))) `(,(cadr e)))  
      ((or (number? e) (string? e) (null? e) (null? e) (boolean? e)) `())
      ((pair? e)
	`( ,@(rex (car e)) ,@(rex (cdr e))))
      ((vector? e)
	`( ,@(apply append 
		      (map rex 
			  (vector->list e)))))
      ((symbol? e)
	`( ,@(rex (symbol->string e))))
)))

    (polish (lambda (lst i)
	      (cond ((null? lst) (lib-function-mem-list i ))
		    ((not (member (car lst) (cdr lst))) (cons `(,(car lst) ,i) (polish (cdr lst) (+ i 1))))
		    (else (polish (cdr lst) i)))))
      )

      (lambda (sxpr base-adress)
	    (polish (rex sxpr) base-adress))))
            
(define apply-all (lambda (lst)
      (cond ((null? lst) '())
	    (else (cons  (annotate-tc (pe->lex-pe (box-set (remove-applic-lambda-nil (eliminate-nested-defines (parse (car lst))))))) 
		    (apply-all (cdr lst)))))))
		    

(define const-tbl-base 1000)

(define foo
  (lambda (e)
    (cond 
      ((or (number? e) (string? e) (null? e) (null? e) (boolean? e)) `(,e))
      ((pair? e)
	`(,e ,@(foo (car e)) ,@(foo (cdr e))))
      ((vector? e)
	`(,e ,@(apply append 
		      (map foo 
			  (vector->list e)))))
      ((symbol? e)
	`(,e ,@(foo (symbol->string e))))
)))


        

(define get-const-tbl 
	(letrec ((cst (lambda (e) (foo e)))

		 (rex (lambda  (lst adress)
			  (cond ((null? lst) '())
				((null? (car lst)) (cons `(1 () (T_NIL)) (rex (cdr lst) (+ 1 adress))))
				((equal? #f (car lst)) (cons `(2 #f (T_BOOL 0)) (rex (cdr lst) (+ 2 adress))))
				((equal? #t (car lst)) (cons `(2 #t (T_BOOL 1)) (rex (cdr lst) (+ 2 adress))))
				((string? (car lst)) (cons `(,(+ 2 (length (string->list (car lst)))) ,(car lst) (T_STRING ,(length (string->list (car lst)))
							      ,@(map char->integer (string->list (car lst))))) 
							      (rex (cdr lst) (+ adress 2 (length (string->list (car lst)))))))
				((pair? (car lst)) (cons `(3 ,(car lst) (T_PAIR ,(car (car lst)),(cdr (car lst))))
							  (rex (cdr lst) (+ adress 3 ))))
				((equal? (void) (car lst)) (cons `(1 ,@(list (void)) (T_VOID)) (rex (cdr lst) (+ 1 adress))))
				((integer? (car lst)) (cons  `(2 ,(car lst) (T_INTEGER ,(car lst))) (rex (cdr lst) (+ 2 adress))))
				((rational? (car lst)) (cons `(3 ,(car lst) (T_FRAC ,(numerator (car lst)) ,(denominator (car lst))))  (rex (cdr lst) (+ 3 adress))))
				((char? (car lst)) (cons  `(2 ,(car lst) (T_CHAR ,(char->integer(car lst)))) (rex (cdr lst) (+ 2 adress))))
				((symbol? (car lst)) (cons `(2 ,(car lst) (T_SYMBOL ,(symbol->string (car lst)))) (rex (cdr lst) (+ 2 adress))))
				(else (rex (cdr lst) adress)))))
		(double-lst (lambda (lst)
			(cond ((null? lst) '())
			      ((not (member (car lst) (cdr lst))) (cons (car lst) (double-lst (cdr lst))))
			      (else  (double-lst (cdr lst))))))
		(adressed-lst (lambda (lst i)
			(cond ((null? lst) '())
			      (else (cons (cons i (cdr (car lst))) (adressed-lst (cdr lst) (+ i (caar lst))))))))
		(unpolished (lambda (e) (adressed-lst (reverse (double-lst (rex (cst e) 0) )) const-tbl-base)))
		(replace (lambda (item lst)
			    (cond ((null? lst) item)
				  ((and (symbol? item) (equal? (symbol->string item) (cadr (car lst)))) (caar lst))
				  ((equal? item (cadr (car lst))) (caar lst))
				  (else (replace item (cdr lst))))))
		(polish (lambda (lst e) 
			  (cond ((null? lst) '())
			        ((equal? 'T_SYMBOL (car (caddr (car lst)))) (cons `(,(car (car lst)) ,(cadr (car lst)) 
					    (T_SYMBOL ,(replace (cadr (caddr (car lst))) (unpolished e))))
					    (polish (cdr lst) e)))
				((equal? 'T_PAIR (car (caddr (car lst)))) (cons `(,(car (car lst)) ,(cadr (car lst)) 
					    (T_PAIR ,(replace (cadr (caddr (car lst))) (unpolished e)) ,(replace (caddr (caddr (car lst))) (unpolished e)))) 
					    (polish (cdr lst) e)))
			        (else (cons (car lst) (polish (cdr lst) e))))))
				)
		(lambda (e)		
		(polish (unpolished e) e))))
		
		
		
		
(define comm_del `(  ,(string->symbol ";") ,(string->symbol "\n")))
(define ass_label `(  ,(string->symbol ":") ,(string->symbol "\n")))
(define p (string->symbol ","))


	  

;; (define const-table '())
;; 
;; (define const-tbl (lambda (e)
;;         (cond ((null? e) '())
;;               ((and (list? e) (equal? 'const (car e)))
;;                     (cond ((pair?  (cadr e)) `(,e ,@(const-tbl (car (cadr e))) ,@(const-tbl (cdr (cadr e)))))
;;                           ((vector? (cadr e))
;;                                 `(,(cadr e) (const-tbl (vector->list (cadr e)))))
;;                         ; ((symbol? (cadr e))
;;                          ;       `(const ,(cadr e) ,@(const-tbl (symbol->string (cadr e)))))
;;                          (else (begin (set! const-table (cons (cadr e) const-table))  `(const ,(cadr e))))))
;;               ((list? e) (cons (const-tbl (car e)) (const-tbl (cdr e))))
;;               (else `(not-const ,e)))))
;;               
;; (define get-ctable (lambda (e)
;;     (begin (set! const-table '())
;;             (const-tbl e)
;;              (reverse const-table))))

(define global-symbol 0)
(define get-current-symbol (lambda ()  (string->symbol(string-append "gs" (number->string global-symbol)))))
(define get-new-symbol (lambda () (begin (set! global-symbol (+ 1 global-symbol)) (string->symbol(string-append "gs" (number->string global-symbol))))))
    
(define lookup-fvar
      (lambda (lst varname)
	  (cond ((null? lst) #f)
		((equal? varname (caar lst)) (car lst))
		(else (lookup-fvar (cdr lst) varname)))))
		
(define lookup-const
      (lambda (lst val)
	  (cond ((null? lst) #f)
		((equal? val (cadr (car lst))) (car lst))
		(else (lookup-const (cdr lst) val)))))
		
(define loop-for
  (lambda (init count body dir)
      `(MOV (R13 ,p ,count) ,@comm_del
	MOV (R12 ,p ,init) ,@comm_del
	,(string->symbol (string-append "L_loop_start_" (symbol->string (get-new-symbol)))) ,@ass_label
	CMP (R12 ,p R13) ,@comm_del
	JUMP_EQ (,(string->symbol (string-append "L_loop_end_" (symbol->string (get-current-symbol))))) ,@comm_del
	,@body
	,dir (R12 ,p IMM(1)) ,@comm_del
	JUMP (,(string->symbol (string-append "L_loop_start_" (symbol->string (get-current-symbol))))) ,@comm_del
	,(string->symbol (string-append "L_loop_end_" (symbol->string (get-current-symbol)))) ,@ass_label)))
	
            
(define code-gen-if 
(lambda (pe const-tbl fvar-tbl major)
    `(,@(code-gen (cadr pe) const-tbl fvar-tbl major)  
    CMP (IND(R0) ,p IND(SOB_FALSE)) ,@comm_del 
    JUMP_EQ (,(string->symbol (string-append "L_if3_else_" (symbol->string (get-new-symbol))))) ,@comm_del 
    ,@(code-gen (caddr pe) const-tbl fvar-tbl major) 
    JUMP (,(string->symbol (string-append "L_if3_exit_" (symbol->string (get-current-symbol))))) ,@comm_del 
    ,(string->symbol (string-append "L_if3_else_" (symbol->string (get-current-symbol)))) ,@ass_label 
    ,@(code-gen (cadddr pe) const-tbl fvar-tbl major) ,(string->symbol (string-append "L_if3_exit_" (symbol->string (get-current-symbol)))) ,@ass_label )))
    
    
(define code-gen-seq (lambda (pe const-tbl fvar-tbl major)
    (map (lambda (x) (code-gen x const-tbl fvar-tbl major)) (cadr pe))))
    
 (define or-symbol 0)   
 
(define code-gen-or 
    (letrec (
    (rex (lambda (lst const-tbl fvar-tbl major)
	      (cond ((null? lst) '())
		    (else (append
	      `(,@(code-gen (car lst) const-tbl fvar-tbl major) 
		  CMP (IND(R0) ,p IND(SOB_FALSE)) ,@comm_del 
		  JUMP_NE(,(string->symbol(string-append "L_or_exit_" (number->string or-symbol)))) ,@comm_del)
		  (rex (cdr lst) const-tbl fvar-tbl major ))
        )))))
    (lambda (pe const-tbl fvar-tbl major) (begin (set! or-symbol (+ 1 or-symbol)) `(,@(rex (reverse (cdr (reverse (cadr pe)))) const-tbl fvar-tbl major)  
    ,@(code-gen (car (reverse (cadr pe))) const-tbl fvar-tbl major) ,(string->symbol(string-append "L_or_exit_" (number->string or-symbol)))
    ,@ass_label)))))
    
(define fvar?
      (lambda (pe)
	   (and (list? pe) (< 1 (length pe)) (equal? 'fvar (car pe)))))
    
(define code-gen-fvar 
    (lambda (pe const-tbl fvar-tbl major)
	  `(MOV (R0 ,p IND(,(cadr (lookup-fvar fvar-tbl (cadr pe))))) ,@comm_del )))
	  
(define set-fvar?
      (lambda (pe)
	  (and (list? pe) (< 2 (length pe)) (equal? 'set (car pe)) (fvar? (cadr pe)))  ))
	  
;; (define code-gen-set-var
;;     (lambda (pe const-tbl fvar-tbl)
;; 	  `(,@(code-gen (cddr pe) const-tbl fvar-tbl) MOV(IND(,(cadr (lookup-fvar fvar-tbl (cadr (cadr pe)))))) ,@comm_del
;; 		  MOV(R0 ,p IMM(SOB_VOID)) ,@comm_del))) 
		  
(define def-fvar?
      (lambda (pe)
	  (and (list? pe) (< 2 (length pe)) (equal? 'def (car pe)) (fvar? (cadr pe)))  ))
	  
(define code-gen-def-var
    (lambda (pe const-tbl fvar-tbl major)
	  `(// FREE VAR: ,(cadr (cadr pe)) ,@comm_del
	      ,@(code-gen (caddr pe) const-tbl fvar-tbl major) 
		  MOV(IND(,(cadr (lookup-fvar fvar-tbl (cadr (cadr pe))))) ,p R0) ,@comm_del
		  MOV(R0 ,p IMM(SOB_VOID)) ,@comm_del
		  ))) 
		  
(define pconst? (lambda (pe) (and (list? pe) (< 1 (length pe)) (equal? 'const (car pe)))))

(define code-gen-const
    (lambda (pe const-tbl fvar-tbl major)
	  `(MOV (R0 ,p IMM(,(car (lookup-const const-tbl (cadr pe) )))) ,@comm_del)))
	  
(define code-gen-applic
    (letrec ((rex (lambda (lst const-tbl fvar-tbl major) 
		(cond ((null? lst) '())
		      (else (append `(,@(code-gen (car lst) const-tbl fvar-tbl major) PUSH (R0) ,@comm_del) (rex (cdr lst) const-tbl fvar-tbl major)))))))
    (lambda (pe const-tbl fvar-tbl major)
	  `(,@(rex (reverse (caddr pe))  const-tbl fvar-tbl major) PUSH (IMM(,(length (caddr pe)))) ,@comm_del
			    ,@(code-gen (cadr pe) const-tbl fvar-tbl major)
			    CMP (INDD (R0 ,p 0)  ,p IMM(T_CLOSURE)) ,@comm_del
			    JUMP_NE (L_ERROR_CANNOT_APPLY_NON_CLOS) ,@comm_del 
			    PUSH (INDD (R0 ,p 1)) ,@comm_del 
			    CALLA (INDD (R0 ,p 2)) ,@comm_del
			    DROP(1) ,@comm_del 
			    POP(R1) ,@comm_del 
			    DROP(R1) ,@comm_del))))
			    
(define pe-lambda-simple? (lambda (pe)
    (and (list? pe) (< 1 (length pe)) (equal? 'lambda-simple (car pe)))))
    
(define cgen-lambda-simple 
    (lambda (pe const-tbl fvar-tbl major)
        `(MOV (R1 ,p FPARG(0)) ,@comm_del 
          PUSH (IMM(,(+ 1 major))) ,@comm_del 
          CALL (MALLOC) ,@comm_del 
          DROP(1) ,@comm_del 
          MOV (R2 ,p R0) ,@comm_del 
          ,@(loop-for (string->symbol "IMM(0)") (string->symbol (string-append "IMM(" (number->string major) ")"))
		`(MOV (R14 ,p R12) ,@comm_del 
		  ADD (R14 ,p IMM(1)) ,@comm_del 
		  MOV (INDD (R2 ,p R14) ,p (INDD (R1 ,p R12))) ,@comm_del) 'ADD) 
	  MOV (R3  ,p FPARG(1)) ,@comm_del 
	  PUSH (R3) ,@comm_del 
	  CALL (MALLOC) ,@comm_del 
	  DROP(1) ,@comm_del 
	  MOV (INDD (R2 ,p 0) ,p R0) ,@comm_del 
	  ,@(loop-for (string->symbol "IMM(0)") 'R3
		 `(MOV (R14 ,p R12) ,@comm_del 
		   ADD (R14 ,p IMM(2)) ,@comm_del 
		   MOV (R15 ,p INDD (R2 ,p 0)) ,@comm_del
		   MOV (INDD (R15 ,p R12) ,p FPARG(R14)) ,@comm_del) 'ADD) 
          PUSH (IMM(3)) ,@comm_del
	  CALL (MALLOC) ,@comm_del
	  DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p T_CLOSURE) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p R2) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL (,(string->symbol(string-append "L_CLOSURE_BODY_" (symbol->string (get-new-symbol)))))) ,@comm_del
          JUMP (,(string->symbol(string-append "L_CLOSURE_EXIT_" (symbol->string (get-current-symbol))))) ,@comm_del
          ,(string->symbol(string-append "L_CLOSURE_BODY_" (symbol->string (get-current-symbol)))) ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(,(length (cadr pe)))) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          ,@(code-gen (caddr pe) const-tbl fvar-tbl (+ 1 major))
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          ,(string->symbol(string-append "L_CLOSURE_EXIT_" (symbol->string (get-current-symbol)))) ,@ass_label)))
          
(define pe-lambda-opt? (lambda (pe)
    (and (list? pe) (< 1 (length pe)) (equal? 'lambda-opt (car pe)))))          
    
(define cgen-lambda-opt
    (lambda (pe const-tbl fvar-tbl major)
        `(MOV (R1 ,p FPARG(0)) ,@comm_del 
          PUSH (IMM(,(+ 1 major))) ,@comm_del 
          CALL (MALLOC) ,@comm_del 
          DROP(1) ,@comm_del 
          MOV (R2 ,p R0) ,@comm_del 
          ,@(loop-for (string->symbol "IMM(0)") (string->symbol (string-append "IMM(" (number->string major) ")"))
		`(MOV (R14 ,p R12) ,@comm_del 
		  ADD (R14 ,p IMM(1)) ,@comm_del 
		  MOV (INDD (R2 ,p R14) ,p (INDD (R1 ,p R12))) ,@comm_del) 'ADD) 
	  MOV (R3  ,p FPARG(1)) ,@comm_del 
	  PUSH (R3) ,@comm_del 
	  CALL (MALLOC) ,@comm_del 
	  DROP(1) ,@comm_del 
	  MOV (INDD (R2 ,p 0) ,p R0) ,@comm_del 
	  ,@(loop-for (string->symbol "IMM(0)") 'R3
		 `(MOV (R14 ,p R12) ,@comm_del 
		   ADD (R14 ,p IMM(2)) ,@comm_del 
		   MOV (R15 ,p INDD (R2 ,p 0)) ,@comm_del
		   MOV (INDD (R15 ,p R12) ,p FPARG(R14)) ,@comm_del) 'ADD) 
          PUSH (IMM(3)) ,@comm_del
	  CALL (MALLOC) ,@comm_del
	  DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p T_CLOSURE) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p R2) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL (,(string->symbol(string-append "L_CLOSURE_BODY_" (symbol->string (get-new-symbol)))))) ,@comm_del
          JUMP (,(string->symbol(string-append "L_CLOSURE_EXIT_" (symbol->string (get-current-symbol))))) ,@comm_del
          ,(string->symbol(string-append "L_CLOSURE_BODY_" (symbol->string (get-current-symbol)))) ,@ass_label

          ; fix stack
         PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R1 ,p IMM(,const-tbl-base)) ,@comm_del
          MOV (R8 ,p IMM(,(length (cadr pe)))) ,@comm_del
          MOV (R9 ,p FPARG(1)) ,@comm_del
          MOV (R10 ,p IMM(1 + R9)) ,@comm_del
          ,(string->symbol(string-append "L_OPT_LOOP_"   (symbol->string (get-current-symbol)))) ,@ass_label
          CMP (R10 ,p IMM(1 + R8)) ,@comm_del
          JUMP_EQ (,(string->symbol(string-append "L_OPT_LOOP_AFT_"   (symbol->string (get-current-symbol))))) ,@comm_del
          PUSH (R1) ,@comm_del
          PUSH (FPARG(R10)) ,@comm_del
          CALL (MAKE_SOB_PAIR) ,@comm_del
          DROP(2) ,@comm_del
          MOV (R1 ,p R0) ,@comm_del
          DECR (R10) ,@comm_del
          JUMP ( ,(string->symbol(string-append "L_OPT_LOOP_"   (symbol->string (get-current-symbol)))))  ,@comm_del
          ,(string->symbol(string-append "L_OPT_LOOP_AFT_"   (symbol->string (get-current-symbol)))) ,@ass_label
          MOV (FPARG(1) ,p IMM(,(length (cadr pe)) + 1)) ,@comm_del
          MOV (FPARG(2 + R8) ,p R1) ,@comm_del
          ,@(code-gen (cadddr pe) const-tbl fvar-tbl (+ 1 major)) 
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          ,(string->symbol(string-append "L_CLOSURE_EXIT_" (symbol->string (get-current-symbol)))) ,@ass_label)))
	  
(define pe-lambda-var? (lambda (pe)
    (and (list? pe) (< 1 (length pe)) (equal? 'lambda-var (car pe)))))  
    
(define cgen-lambda-var
    (lambda (pe const-tbl fvar-tbl major)
        `(MOV (R1 ,p FPARG(0)) ,@comm_del 
          PUSH (IMM(,(+ 1 major))) ,@comm_del 
          CALL (MALLOC) ,@comm_del 
          DROP(1) ,@comm_del 
          MOV (R2 ,p R0) ,@comm_del 
          ,@(loop-for (string->symbol "IMM(0)") (string->symbol (string-append "IMM(" (number->string major) ")"))
		`(MOV (R14 ,p R12) ,@comm_del 
		  ADD (R14 ,p IMM(1)) ,@comm_del 
		  MOV (INDD (R2 ,p R14) ,p (INDD (R1 ,p R12))) ,@comm_del) 'ADD) 
	  MOV (R3  ,p FPARG(1)) ,@comm_del 
	  PUSH (R3) ,@comm_del 
	  CALL (MALLOC) ,@comm_del 
	  DROP(1) ,@comm_del 
	  MOV (INDD (R2 ,p 0) ,p R0) ,@comm_del 
	  ,@(loop-for (string->symbol "IMM(0)") 'R3
		 `(MOV (R14 ,p R12) ,@comm_del 
		   ADD (R14 ,p IMM(2)) ,@comm_del 
		   MOV (R15 ,p INDD (R2 ,p 0)) ,@comm_del
		   MOV (INDD (R15 ,p R12) ,p FPARG(R14)) ,@comm_del) 'ADD) 
          PUSH (IMM(3)) ,@comm_del
	  CALL (MALLOC) ,@comm_del
	  DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p T_CLOSURE) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p R2) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL (,(string->symbol(string-append "L_CLOSURE_BODY_" (symbol->string (get-new-symbol)))))) ,@comm_del
          JUMP (,(string->symbol(string-append "L_CLOSURE_EXIT_" (symbol->string (get-current-symbol))))) ,@comm_del
          ,(string->symbol(string-append "L_CLOSURE_BODY_" (symbol->string (get-current-symbol)))) ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R1 ,p IMM(,const-tbl-base)) ,@comm_del
          MOV (R9 ,p FPARG(1)) ,@comm_del
          MOV (R10 ,p IMM(1 + R9)) ,@comm_del
          ,(string->symbol(string-append "L_VAR_LOOP_"   (symbol->string (get-current-symbol)))) ,@ass_label
          CMP (R10 ,p IMM(1)) ,@comm_del
          JUMP_EQ (,(string->symbol(string-append "L_VAR_LOOP_AFT_"   (symbol->string (get-current-symbol))))) ,@comm_del
          PUSH (R1) ,@comm_del
          PUSH (FPARG(R10)) ,@comm_del
          CALL (MAKE_SOB_PAIR) ,@comm_del
          DROP(2) ,@comm_del
          MOV (R1 ,p R0) ,@comm_del
          DECR (R10) ,@comm_del
          JUMP ( ,(string->symbol(string-append "L_VAR_LOOP_"   (symbol->string (get-current-symbol)))))  ,@comm_del
          ,(string->symbol(string-append "L_VAR_LOOP_AFT_"   (symbol->string (get-current-symbol)))) ,@ass_label
          MOV(FPARG(1) ,p IMM(1)) ,@comm_del
          MOV(FPARG(2) ,p R1) ,@comm_del
          ,@(code-gen (caddr pe) const-tbl fvar-tbl (+ 1 major))
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          ,(string->symbol(string-append "L_CLOSURE_EXIT_" (symbol->string (get-current-symbol)))) ,@ass_label)))
          
          
    
(define pvar? (lambda (pe) (and (list? pe) (< 1 (length pe)) (equal? 'pvar (car pe)))))

(define code-gen-pvar
    (lambda (pe const-tbl fvar-tbl major)
        `(MOV(R0 ,p FPARG(,(+ 2 (caddr pe)))) ,@comm_del)))
        
(define set-pvar?
      (lambda (pe)
	  (and (list? pe) (< 2 (length pe)) (equal? 'set (car pe)) (pvar? (cadr pe)))  ))
	  
(define code-gen-set-pvar
    (lambda (pe const-tbl fvar-tbl major)
        `(,@(code-gen (caddr pe) const-tbl fvar-tbl major) MOV (FPARG (,(+ 2 (caddr (cadr pe))) ) ,p R0) ,@comm_del
            MOV (R0 ,p IMM(SOB_VOID)) ,@comm_del)))
            
(define box-get-pvar?
    (lambda (pe)
        (and (list? pe) (< 2 (length pe)) (equal? 'box-get (car pe)) (pvar? (cadr pe)))))
     
(define code-gen-box-get-pvar
    (lambda (pe const-tbl fvar-tbl major)
        `(MOV (R0 ,p FPARG (,(+ 2 (caddr (cadr pe))) )) ,@comm_del
          MOV (R0 ,p IND(R0)) ,@comm_del)))
          
(define bvar?  (lambda (pe) (and (list? pe) (< 1 (length pe)) (equal? 'bvar (car pe)))))

(define code-gen-bvar 
    (lambda (pe const-tbl fvar-tbl major)
        `(MOV (R0 ,p ) ,@comm_del 
          MOV (R0 ,p INDD(R0 ,p ,(caddr pe))) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p ,(cadddr pe))) ,@comm_del)))
 
(define tcapplic?
    (lambda (sxpr) (and (list? sxpr) (< 0 (length sxpr)) (equal? 'tc-applic (car sxpr))))) 
 
 
(define code-gen-tc-applic
    (letrec ((rex (lambda (lst const-tbl fvar-tbl major) 
		(cond ((null? lst) '())
		      (else (append `(,@(code-gen (car lst) const-tbl fvar-tbl major) PUSH (R0) ,@comm_del) (rex (cdr lst) const-tbl fvar-tbl major)))))))
    (lambda (pe const-tbl fvar-tbl major)
	  `(,@(rex (reverse (caddr pe))  const-tbl fvar-tbl major) PUSH (IMM(,(length (caddr pe)))) ,@comm_del
			    ,@(code-gen (cadr pe) const-tbl fvar-tbl major) 
			    CMP (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
			    JUMP_NE (L_ERROR_CANNOT_APPLY_NON_CLOS) ,@comm_del 
			    PUSH (INDD (R0 ,p 1)) ,@comm_del 
			    PUSH (FP) ,@comm_del 
			    PUSH (FPARG(-1)) ,@comm_del ;;retaddress
			    MOV (R1 ,p FPARG(-2)) ,@comm_del ;;save old fp
			    MOV (R2 ,p SP) ,@comm_del
			    SUB (R2 ,p FP) ,@comm_del
			    ,@(loop-for (string->symbol "IMM(0)") 'R2 
				  `(MOV (R14 ,p R12) ,@comm_del
				    ADD (R14 ,p FP) ,@comm_del
				    MOV (R15 ,p R12) ,@comm_del
				    ADD (R15 ,p R1) ,@comm_del
				    MOV (STACK (R15) ,p STACK (R14)) ,@comm_del) 'ADD)
			    MOV (R15  ,p R12) ,@comm_del
			    ADD (R15  ,p R1) ,@comm_del
			    MOV (SP ,p R15) ,@comm_del
			    MOV (FP ,p R1) ,@comm_del
			    MOV (R0 ,p INDD (R0 ,p 2))  ,@comm_del
			    JUMP (,(string->symbol "*R0"))  ,@comm_del ))))
				    
			    
			    
        
	  
(define code-gen (lambda (pe const-tbl fvar-tbl major)
    (cond ((hw3if3? pe) (code-gen-if pe  const-tbl fvar-tbl major))
          ((hw3seq? pe) (code-gen-seq pe const-tbl fvar-tbl major))
          ((or? pe) (code-gen-or pe const-tbl fvar-tbl major))
          ((fvar? pe) (code-gen-fvar pe const-tbl fvar-tbl major))
          ((set-fvar? pe) (code-gen-def-var pe const-tbl fvar-tbl major))
          ((def-fvar? pe) (code-gen-def-var pe const-tbl fvar-tbl major))
          ((pconst? pe) (code-gen-const pe const-tbl fvar-tbl major))
          ((hw3applic? pe) (code-gen-applic pe const-tbl fvar-tbl major))
          ((tcapplic? pe) (code-gen-tc-applic pe const-tbl fvar-tbl major))
          ((pvar? pe) (code-gen-pvar pe const-tbl fvar-tbl major))
          ((set-pvar? pe) (code-gen-set-pvar pe const-tbl fvar-tbl major))
          ((box-get-pvar? pe) (code-gen-box-get-pvar pe const-tbl fvar-tbl major))
          ((bvar? pe) (code-gen-bvar pe const-tbl fvar-tbl major))
          ((pe-lambda-simple? pe) (cgen-lambda-simple pe const-tbl fvar-tbl major))
          ((pe-lambda-opt? pe) (cgen-lambda-opt pe const-tbl fvar-tbl major))
          ((pe-lambda-var? pe) (cgen-lambda-var pe const-tbl fvar-tbl major))
        (else "ERROR"))))
        
        
(define fvar-tbl-offset
    (letrec ((rex (lambda (lst)
		    (cond ((= 1 (length lst)) (caar lst))
			  (else (rex (cdr lst)))))))
    (lambda (const-tbl) (+ 16 (rex const-tbl)))))
    
(define symbol-tbl-offset
      (letrec ((rex (lambda (lst)
		    (cond ((= 1 (length lst)) (cadr (car lst)))
			  (else (rex (cdr lst)))))))
    (lambda (fvar-tbl) (+ 16 (rex fvar-tbl)))))
    
(define root-const-tbl	
      (letrec ((rex (lambda (row loc offset)
		  (if (null? row) '()
		  (append `(MOV (IND(,(+ offset loc)) ,p  IMM(,(car row))) ,@comm_del) (rex (cdr row) loc (+ 1 offset)))))))			    
      (lambda (const-tbl)
	  (if (null? const-tbl) '()
	  (append (rex (caddr (car const-tbl)) (caar const-tbl) 0) (root-const-tbl (cdr const-tbl)))))))

	  ;(equal? 'T_SYMBOL (car (cadr (car lst))))
	  
	  
(define root-symbols
        (letrec ((lst-of-syms (lambda (lst)
                        (cond ((null? lst) '())
                              ((equal? 'T_SYMBOL (car (caddr (car lst)))) (cons (car lst) (lst-of-syms (cdr lst))))
                              (else (lst-of-syms (cdr lst))))))
                (rex (lambda (lst i)
                        (cond ((null? lst ) '())
                              ((< 1 (length lst)) (append 
                                    `(                                      MOV (IND (,i) ,p IMM(,(cadr (caddr (car lst))))) ,@comm_del
                                      MOV (IND (,(+ i 1)) ,p IMM(,(+ i 2)))  ,@comm_del) 
                                      (rex (cdr lst) (+ i 2))))
                              (else `(
                                      MOV (IND (,i) ,p IMM(,(cadr (caddr (car lst))))) ,@comm_del
                                      MOV (IND (,(+ i 1)) ,p IMM(,const-tbl-base))  ,@comm_del
                                      MOV (IND (IMM(800)) ,p IMM(,(+ i 1))) ,@comm_del ))))) )
                                      
        (lambda (const-tbl offset)
            (rex (lst-of-syms const-tbl) offset))))
            
        
;; (define root-fvar-tbl
;; 	(lambda (fvar-tbl const-tbl)
;; 	      (if (null? fvar-tbl) '()
;; 		  (append `(MOV (IND(,(cadr (car fvar-tbl))) ,p IMM(,(car (lookup-const const-tbl (caar fvar-tbl) )))) ,@comm_del)
;; 			(root-fvar-tbl (cdr fvar-tbl) const-tbl)))))

;;(root-fvar-tbl (get-fvar-tbl (scheme-parsed-code source) 
		  ;;(fvar-tbl-offset (get-const-tbl (scheme-code source)))) (get-const-tbl (scheme-code source)))
		  
;;;;;;;;;;;;;;;;;;;;;LIBRARY FUNCTIONS***********************


(define def-lib
    (lambda (wrapped-def lib-name fvar-tbl)
	  `(,@wrapped-def
		  MOV(IND(,(cadr (lookup-fvar fvar-tbl lib-name))) ,p R0) ,@comm_del
		  MOV(R0 ,p IMM(SOB_VOID)) ,@comm_del)))

;;46		  
(define lib-car (lambda (fvar-tbl)
    (def-lib
    `(JUMP (LMAKE_CAR_CLOS) ,@comm_del
      L_CAR_BODY ,@ass_label
      PUSH (FP) ,@comm_del
      MOV (FP ,p SP) ,@comm_del
      CMP (FPARG(1) ,p IMM(1)) ,@comm_del
      JUMP_NE (L_error_lambda_args_count) ,@comm_del
      MOV (R1 ,p FPARG(2)) ,@comm_del
      CMP (INDD(R1 ,p 0) ,p IMM(T_PAIR))  ,@comm_del
      JUMP_NE (L_incorrect_type) ,@comm_del
      MOV (R0 ,p INDD(R1 ,p 1)) ,@comm_del
      POP (FP) ,@comm_del
      RETURN ,@comm_del
      LMAKE_CAR_CLOS  ,@ass_label
      PUSH (IMM(3)) ,@comm_del
      CALL (MALLOC) ,@comm_del
      DROP(1) ,@comm_del
      MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
      MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
      MOV (INDD (R0 ,p 2) ,p LABEL(L_CAR_BODY)) ,@comm_del) 'car fvar-tbl)))
      
;;45
(define lib-cdr (lambda (fvar-tbl)
    (def-lib 
      `(JUMP (LMAKE_CDR_CLOS) ,@comm_del
        L_CDR_BODY ,@ass_label
        PUSH (FP) ,@comm_del
        MOV (FP ,p SP) ,@comm_del
        CMP (FPARG(1) ,p IMM(1)) ,@comm_del
        JUMP_NE (L_error_lambda_args_count) ,@comm_del
        MOV (R1 ,p FPARG(2)) ,@comm_del
        CMP (INDD(R1 ,p 0) ,p IMM(T_PAIR))  ,@comm_del
        JUMP_NE (L_incorrect_type) ,@comm_del
        MOV (R0 ,p INDD(R1 ,p 2)) ,@comm_del
        POP (FP) ,@comm_del
        RETURN ,@comm_del
        LMAKE_CDR_CLOS  ,@ass_label
        PUSH (IMM(3)) ,@comm_del
        CALL (MALLOC) ,@comm_del
        DROP(1) ,@comm_del
        MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
        MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
        MOV (INDD (R0 ,p 2) ,p LABEL(L_CDR_BODY)) ,@comm_del) 'cdr fvar-tbl)))

        
;;44
(define lib-cons (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_CONS_CLOS) ,@comm_del
          L_CONS_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(2)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          PUSH (IMM(3)) ,@comm_del
          CALL (MALLOC) ,@comm_del
          DROP (1) ,@comm_del
          MOV (INDD (R0  ,p 0)  ,p IMM(T_PAIR)) ,@comm_del
          MOV (INDD (R0  ,p 1)  ,p FPARG(2)) ,@comm_del
          MOV (INDD (R0  ,p 2)  ,p FPARG(3)) ,@comm_del
          POP(FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_CONS_CLOS ,@ass_label
          PUSH (IMM(3)) ,@comm_del
          CALL (MALLOC) ,@comm_del
          DROP (1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_CONS_BODY)) ,@comm_del) 'cons fvar-tbl)))
          
;;43
(define lib-numerator  (lambda (fvar-tbl)
      (def-lib
        `(JUMP (LMAKE_NUMERATOR_CLOS) ,@comm_del
          L_NUMERATOR_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD(R1 ,p 0) ,p IMM(T_INTEGER))  ,@comm_del
          JUMP_EQ (L_LIB_NUMERATOR_INTEGER) ,@comm_del
          CMP (INDD(R1 ,p 0) ,p IMM(T_FRAC))  ,@comm_del
          JUMP_NE (L_incorrect_type) ,@comm_del
          L_LIB_NUMERATOR_INTEGER ,@ass_label
          PUSH (IMM(2)) ,@comm_del
          CALL (MALLOC) ,@comm_del
          DROP (1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_INTEGER)) ,@comm_del 
          MOV (INDD (R0 ,p 1) ,p INDD(R1 ,p 1)) ,@comm_del 
          POP(FP) ,@comm_del 
          RETURN ,@comm_del 
          LMAKE_NUMERATOR_CLOS ,@ass_label
          PUSH (IMM(3)) ,@comm_del 
          CALL (MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_NUMERATOR_BODY)) ,@comm_del) 'numerator fvar-tbl)))
          
;;42
(define lib-denominator  (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_DENOMINATOR_CLOS) ,@comm_del
          L_DENOMINATOR_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          PUSH (IMM(2)) ,@comm_del
          CALL (MALLOC) ,@comm_del
          DROP (1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_INTEGER)) ,@comm_del 
          CMP (INDD (R1 ,p 0) ,p IMM(T_INTEGER)) ,@comm_del 
          JUMP_EQ (L_LIB_DENOMINATOR_INTEGER) ,@comm_del 
          CMP (INDD (R1 ,p 0) ,p IMM(T_FRAC)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p INDD (R1 ,p 2)) ,@comm_del
          JUMP (L_LIB_DENOMINATOR_INTEGER_AFTER) ,@comm_del
          L_LIB_DENOMINATOR_INTEGER ,@ass_label
          MOV (INDD (R0 ,p 1) ,p IMM(1)) ,@comm_del
          L_LIB_DENOMINATOR_INTEGER_AFTER ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_DENOMINATOR_CLOS ,@ass_label
          PUSH (IMM(3)) ,@comm_del
          CALL (MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_DENOMINATOR_BODY)) ,@comm_del) 'denominator fvar-tbl)))

;;41          
(define lib-eq? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_EQ_CLOS) ,@comm_del
          L_EQ_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(2)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          CMP (FPARG(2) ,p FPARG(3)) ,@comm_del
          JUMP_NE (L_EQ_RET_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (L_EQ_AFT_RET) ,@comm_del
          L_EQ_RET_FALSE ,@ass_label
          ;;compare types
          MOV (R1 ,p FPARG(2)) ,@comm_del
          MOV (R2 ,p FPARG(3)) ,@comm_del
          CMP (IND(R1) ,p IND(R2)) ,@comm_del
          JUMP_NE (EQ_NOT_EQUAL) ,@comm_del
          
          CMP (IND(R1) ,p IMM(T_INTEGER)) ,@comm_del
          JUMP_NE (COMPARE_FRACTIONS) ,@comm_del
          ;;compare integers
          CMP (INDD(R1 ,p 1) ,p INDD(R2 ,p 1)) ,@comm_del
          JUMP_NE(EQ_NOT_EQUAL) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (L_EQ_AFT_RET) ,@comm_del
          
          COMPARE_FRACTIONS ,@ass_label
          CMP (IND(R1) ,p IMM(T_FRAC)) ,@comm_del
          JUMP_NE(COMPARE_CHARS) ,@comm_del
          CMP (INDD(R1 ,p 1) ,p INDD(R2 ,p 1)) ,@comm_del
          JUMP_NE(EQ_NOT_EQUAL) ,@comm_del
          CMP (INDD(R1 ,p 2) ,p INDD(R2 ,p 2)) ,@comm_del
          JUMP_NE(EQ_NOT_EQUAL) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (L_EQ_AFT_RET) ,@comm_del
          
          COMPARE_CHARS ,@ass_label
          CMP (IND(R1) ,p IMM(T_CHAR)) ,@comm_del
          JUMP_NE(COMPARE_SYMBOLS) ,@comm_del
          CMP (INDD(R1 ,p 1) ,p INDD(R2 ,p 1)) ,@comm_del
          JUMP_NE(EQ_NOT_EQUAL) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (L_EQ_AFT_RET) ,@comm_del
          
          COMPARE_SYMBOLS ,@ass_label
          CMP (IND(R1) ,p IMM(T_SYMBOL)) ,@comm_del
          JUMP_NE(COMPARE_BOOLEANS) ,@comm_del
          CMP (INDD(R1 ,p 1) ,p INDD(R2 ,p 1)) ,@comm_del
          JUMP_NE(EQ_NOT_EQUAL) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (L_EQ_AFT_RET) ,@comm_del
          
          COMPARE_BOOLEANS ,@ass_label
          CMP (IND(R1) ,p IMM(T_BOOL)) ,@comm_del
          JUMP_NE(EQ_NOT_EQUAL) ,@comm_del
          CMP (INDD(R1 ,p 1) ,p INDD(R2 ,p 1)) ,@comm_del
          JUMP_NE(EQ_NOT_EQUAL) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (L_EQ_AFT_RET) ,@comm_del
          
          EQ_NOT_EQUAL ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          L_EQ_AFT_RET ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_EQ_CLOS ,@ass_label
          PUSH (IMM(3)) ,@comm_del
          CALL (MALLOC) ,@comm_del
          DROP (1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_EQ_BODY)) ,@comm_del) 'eq? fvar-tbl)))
          
;;40
(define lib-char-integer (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_CHAR_TO_INT_CLOS) ,@comm_del
          L_CHAR_TO_INT_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_CHAR)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          PUSH(IMM(2)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD(R0 ,p 0) ,p IMM(T_INTEGER)) ,@comm_del
          MOV (INDD(R0 ,p 1) ,p INDD(R1 ,p 1)) ,@comm_del
          POP(FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_CHAR_TO_INT_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_CHAR_TO_INT_BODY)) ,@comm_del) 'char->integer fvar-tbl)))
          
;;39
(define lib-integer-char (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_INT_TO_CHAR_CLOS) ,@comm_del
          L_INT_TO_CHAR_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_INTEGER)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          PUSH(IMM(2)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD(R0 ,p 0) ,p IMM(T_CHAR)) ,@comm_del
          MOV (INDD(R0 ,p 1) ,p INDD(R1 ,p 1)) ,@comm_del
          POP(FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_INT_TO_CHAR_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_INT_TO_CHAR_BODY)) ,@comm_del) 'integer->char fvar-tbl)))
          
;;38
(define lib-set-car (lambda (fvar-tbl)
    (def-lib 
      `(JUMP (LMAKE_SET_CAR_CLOS) ,@comm_del
        L_SET_CAR_BODY ,@ass_label
        PUSH(FP) ,@comm_del
        MOV (FP ,p SP) ,@comm_del
        CMP (FPARG(1) ,p IMM(2)) ,@comm_del
        JUMP_NE (L_error_lambda_args_count) ,@comm_del
        MOV (R1 ,p FPARG(2)) ,@comm_del
        CMP (INDD (R1 ,p 0) ,p IMM(T_PAIR)) ,@comm_del 
        JUMP_NE (L_incorrect_type) ,@comm_del
        MOV (INDD(R1 ,p 1),p FPARG(3)) ,@comm_del
        MOV (R0 ,p SOB_VOID) ,@comm_del
        POP(FP) ,@comm_del
        RETURN ,@comm_del
        LMAKE_SET_CAR_CLOS ,@ass_label
        PUSH(IMM(3)) ,@comm_del
        CALL(MALLOC) ,@comm_del
        DROP(1) ,@comm_del
        MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
        MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
        MOV (INDD (R0 ,p 2) ,p LABEL(L_SET_CAR_BODY)) ,@comm_del) 'set-car! fvar-tbl)))
        
;;37
(define lib-set-cdr (lambda (fvar-tbl)
    (def-lib
      `(JUMP (LMAKE_SET_CDR_CLOS) ,@comm_del
        L_SET_CDR_BODY ,@ass_label
        PUSH(FP) ,@comm_del
        MOV (FP ,p SP) ,@comm_del
        CMP (FPARG(1) ,p IMM(2)) ,@comm_del
        JUMP_NE (L_error_lambda_args_count) ,@comm_del
        MOV (R1 ,p FPARG(2)) ,@comm_del
        CMP (INDD (R1 ,p 0) ,p IMM(T_PAIR)) ,@comm_del 
        JUMP_NE (L_incorrect_type) ,@comm_del
        MOV (INDD(R1 ,p 2),p FPARG(3)) ,@comm_del
        MOV (R0 ,p SOB_VOID) ,@comm_del
        POP(FP) ,@comm_del
        RETURN ,@comm_del
        LMAKE_SET_CDR_CLOS ,@ass_label
        PUSH(IMM(3)) ,@comm_del
        CALL(MALLOC) ,@comm_del
        DROP(1) ,@comm_del
        MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
        MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
        MOV (INDD (R0 ,p 2) ,p LABEL(L_SET_CDR_BODY)) ,@comm_del) 'set-cdr! fvar-tbl)))
        
;;36
(define lib-string-set (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_STRING_SET_CLOS) ,@comm_del
          L_STRING_SET_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(3)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_STRING)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          CMP (INDD(FPARG(3) ,p 0) ,p IMM(T_INTEGER)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          CMP (INDD(FPARG(4) ,p 0) ,p IMM(T_CHAR)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          ADD (R1 ,p IMM(2)) ,@comm_del
          MOV (INDD (R1 ,p INDD (FPARG(3) ,p 1)) ,p INDD(FPARG(4) ,p 1)) ,@comm_del
          MOV (R0 ,p SOB_VOID) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_STRING_SET_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_STRING_SET_BODY)) ,@comm_del) 'string-set! fvar-tbl)))
          
;;35
(define lib-vector-set (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_VECTOR_SET_CLOS) ,@comm_del
          L_VECTOR_SET_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(3)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_VECTOR)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          CMP (INDD(FPARG(3) ,p 0) ,p IMM(T_INTEGER)) ,@comm_del 
          JUMP_NE (L_incorrect_type) ,@comm_del
          ADD (R1 ,p IMM(2)) ,@comm_del
          MOV (INDD (R1 ,p INDD (FPARG(3) ,p 1)) ,p INDD(FPARG(4) ,p 1)) ,@comm_del
          MOV (R0 ,p SOB_VOID) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_VECTOR_SET_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_STRING_SET_BODY)) ,@comm_del) 'vector-set! fvar-tbl)))
          
;;34
(define lib-char? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_CHAR_CLOS) ,@comm_del
          L_IS_CHAR_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_CHAR)) ,@comm_del 
          JUMP_NE (IS_CHAR_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_CHAR_AFT) ,@comm_del
          IS_CHAR_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_CHAR_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_CHAR_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_CHAR_BODY)) ,@comm_del) 'char? fvar-tbl)))
          
;;33
(define lib-integer? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_INT_CLOS) ,@comm_del
          L_IS_INT_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_INTEGER)) ,@comm_del 
          JUMP_NE (IS_INT_FRAC) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          IS_INT_FRAC ,@ass_label
          CMP (INDD (R1 ,p 0) ,p IMM(T_FRAC)) ,@comm_del 
          JUMP_NE (IS_INT_FALSE) ,@comm_del
          CMP (INDD (R1 ,p 2) ,p IMM(1)) ,@comm_del 
          JUMP_NE (IS_INT_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_INT_AFT) ,@comm_del
          IS_INT_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_INT_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_INT_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_INT_BODY)) ,@comm_del) 'integer? fvar-tbl)))
          
;;32
(define lib-pair? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_PAIR_CLOS) ,@comm_del
          L_IS_PAIR_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_PAIR)) ,@comm_del 
          JUMP_NE (IS_PAIR_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_PAIR_AFT) ,@comm_del
          IS_PAIR_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_PAIR_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_PAIR_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_PAIR_BODY)) ,@comm_del) 'pair? fvar-tbl)))
          
;;31
(define lib-fraction? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_FRAC_CLOS) ,@comm_del
          L_IS_FRAC_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_FRAC)) ,@comm_del 
          JUMP_NE (IS_FRAC_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_FRAC_AFT) ,@comm_del
          IS_FRAC_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_FRAC_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_FRAC_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_FRAC_BODY)) ,@comm_del) 'fraction? fvar-tbl)))
          
;;30
(define lib-procedure? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_PROC_CLOS) ,@comm_del
          L_IS_PROC_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del 
          JUMP_NE (IS_PROC_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_PROC_AFT) ,@comm_del
          IS_PROC_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_PROC_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_PROC_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_PROC_BODY)) ,@comm_del) 'procedure? fvar-tbl)))
          
;;29
(define lib-string? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_STR_CLOS) ,@comm_del
          L_IS_STR_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_STRING)) ,@comm_del 
          JUMP_NE (IS_STR_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_STR_AFT) ,@comm_del
          IS_STR_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_STR_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_STR_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_STR_BODY)) ,@comm_del) 'string? fvar-tbl)))    
          
;;28
(define lib-symbol? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_SYM_CLOS) ,@comm_del
          L_IS_SYM_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_SYMBOL)) ,@comm_del 
          JUMP_NE (IS_SYM_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_SYM_AFT) ,@comm_del
          IS_SYM_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_SYM_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_SYM_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_SYM_BODY)) ,@comm_del) 'symbol? fvar-tbl))) 
          
;;27
(define lib-vector? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_VEC_CLOS) ,@comm_del
          L_IS_VEC_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_VECTOR)) ,@comm_del 
          JUMP_NE (IS_VEC_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_VEC_AFT) ,@comm_del
          IS_VEC_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_VEC_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_VEC_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_VEC_BODY)) ,@comm_del) 'vector? fvar-tbl))) 

;;26
(define lib-apply (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_APPLY_CLOS) ,@comm_del
          L_APPLY_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV  (FP ,p SP) ,@comm_del
          PUSH (R1) ,@comm_del
          PUSH (R2) ,@comm_del
          PUSH (R3) ,@comm_del
          MOV (R0 ,p FPARG(4)) ,@comm_del
          PUSH (IMM(4)) ,@comm_del ;magic num
          LOOP_APPLY_PRMS ,@ass_label
          CMP (IND(R0) ,p IMM(,const-tbl-base)) ,@comm_del
          JUMP_EQ (LOOP_APPLY_PRMS_AFT) ,@comm_del
          PUSH (INDD (R0 ,p IMM(R1))) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p IMM(2))) ,@comm_del
          JUMP (LOOP_APPLY_PRMS) ,@comm_del
          LOOP_APPLY_PRMS_AFT ,@ass_label
          MOV (R1 ,p SP) ,@comm_del
          DECR (R1) ,@comm_del
          MOV (R2 ,p FP) ,@comm_del
          ADD (R2 ,p 4) ,@comm_del
          LOOP_APPLY_REVERSE ,@ass_label
          CMP (R1 ,p R2) ,@comm_del
          JUMP_LE (LOOP_APPLY_REVERSE_AFT) ,@comm_del
          MOV (R3 ,p STACK(R1)) ,@comm_del
          MOV (STACK(R1) ,p STACK(R2)) ,@comm_del
          MOV (STACK(R2) ,p R3) ,@comm_del
          DECR (R1) ,@comm_del
          INCR (R2) ,@comm_del
          JUMP (LOOP_APPLY_PRMS) ,@comm_del
          LOOP_APPLY_REVERSE_AFT ,@ass_label
          MOV (R1 ,p SP) ,@comm_del
          SUB (R1 ,p FP) ,@comm_del
          SUB (R1 ,p IMM(4)) ,@comm_del
          PUSH (R1) ,@comm_del
          PUSH (R1) ,@comm_del
          MOV (R2 ,p FPARG(3)) ,@comm_del
          PUSH (INDD (R2 ,p IMM(1))) ,@comm_del
          CALLA (INDD(R2 ,p IMM(2))) ,@comm_del
          DROP(1) ,@comm_del
          POP (R1) ,@comm_del
          DROP(R1) ,@comm_del
          DROP(2) ,@comm_del
          POP(R3) ,@comm_del
          POP(R2) ,@comm_del
          POP(R1) ,@comm_del
          POP(FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_APPLY_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_APPLY_BODY)) ,@comm_del) 'apply fvar-tbl))) 

;;32
(define lib-binary-plus (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_PLUS_BIN_CLOS) ,@comm_del
          L_PLUS_BIN_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(2)) ,@comm_del
          MOV (R1 ,p FPARG(3)) ,@comm_del
          CMP (IND(R0) ,p IMM(T_FRAC)) ,@comm_del
          JUMP_EQ (BIN_PLUS_FRAC) ,@comm_del
          CMP (IND(R1) ,p IMM(T_FRAC)) ,@comm_del
          JUMP_EQ (BIN_PLUS_FRAC) ,@comm_del
          MOV (R0 ,p  INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p  INDD(R1 ,p 1)) ,@comm_del
          ADD (R0 ,p R1) ,@comm_del
          PUSH (R0) ,@comm_del
          CALL (MAKE_SOB_INTEGER) ,@comm_del
          DROP(1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          
          BIN_PLUS_FRAC ,@ass_label
          MOV (R7 ,p R1) ,@comm_del
          
          CMP (IND(R0) ,p IMM(T_INTEGER)) ,@comm_del
          JUMP_NE (FIRST_IS_FRAC) ,@comm_del
          PUSH (INDD(R0 ,p 1)) ,@comm_del
          CALL (MAKE_SOB_FRAC) ,@comm_del
          DROP(1) ,@comm_del
          
          FIRST_IS_FRAC ,@ass_label
          MOV (R6 ,p R0) ,@comm_del
          CMP (IND(R7) ,p IMM(T_INTEGER)) ,@comm_del
          JUMP_NE (SECOND_IS_FRAC) ,@comm_del
          PUSH (INDD(R7 ,p 1)) ,@comm_del
          CALL (MAKE_SOB_FRAC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (R7 ,p R0) ,@comm_del
          
          SECOND_IS_FRAC ,@ass_label
          ;; api: arg2: first number numerator, arg3: first number denominator, arg4: second number numerator, arg5: second number denominator
          PUSH (INDD(R7 ,p 2)) ,@comm_del
          PUSH (INDD(R7 ,p 1)) ,@comm_del
          PUSH (INDD(R6 ,p 2)) ,@comm_del
          PUSH (INDD(R6 ,p 1)) ,@comm_del
          CALL (ADD_FRACTIONS) ,@comm_del
          DROP(4) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          
          LMAKE_PLUS_BIN_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_PLUS_BIN_BODY)) ,@comm_del) 'bin-plus fvar-tbl))) 
          
;;31
(define lib-binary-minus (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_MINUS_BIN_CLOS) ,@comm_del
          L_MINUS_BIN_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(2)) ,@comm_del
          MOV (R1 ,p FPARG(3)) ,@comm_del
          MOV (R0 ,p  INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p  INDD(R1 ,p 1)) ,@comm_del
          SUB (R0 ,p R1) ,@comm_del
          PUSH (R0) ,@comm_del
          CALL (MAKE_SOB_INTEGER) ,@comm_del
          DROP(1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_MINUS_BIN_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_MINUS_BIN_BODY)) ,@comm_del) 'bin-minus fvar-tbl))) 
          
;;30
(define lib-binary-mul (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_MUL_BIN_CLOS) ,@comm_del
          L_MUL_BIN_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(2)) ,@comm_del
          MOV (R1 ,p FPARG(3)) ,@comm_del
          CMP (IND(R0) ,p IMM(T_FRAC)) ,@comm_del
          JUMP_EQ (BIN_MUL_FRAC) ,@comm_del
          CMP (IND(R1) ,p IMM(T_FRAC)) ,@comm_del
          JUMP_EQ (BIN_MUL_FRAC) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          MUL (R0 ,p R1) ,@comm_del
          PUSH (R0) ,@comm_del
          CALL (MAKE_SOB_INTEGER) ,@comm_del
          DROP(1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          
          BIN_MUL_FRAC ,@ass_label
          MOV (R7 ,p R1) ,@comm_del
          
          CMP (IND(R0) ,p IMM(T_INTEGER)) ,@comm_del
          JUMP_NE (MUL_FIRST_IS_FRAC) ,@comm_del
          PUSH (INDD(R0 ,p 1)) ,@comm_del
          CALL (MAKE_SOB_FRAC) ,@comm_del
          DROP(1) ,@comm_del
          
          MUL_FIRST_IS_FRAC ,@ass_label
          MOV (R6 ,p R0) ,@comm_del
          CMP (IND(R7) ,p IMM(T_INTEGER)) ,@comm_del
          JUMP_NE (MUL_SECOND_IS_FRAC) ,@comm_del
          PUSH (INDD(R7 ,p 1)) ,@comm_del
          CALL (MAKE_SOB_FRAC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (R7 ,p R0) ,@comm_del
          
          MUL_SECOND_IS_FRAC ,@ass_label
          ;;new numerator
          MOV (R1 ,p INDD(R6 ,p 1)) ,@comm_del
          MUL (R1 ,p INDD(R7 ,p 1)) ,@comm_del
          
          ;;new denominator
          MOV (R2 ,p INDD(R6 ,p 2)) ,@comm_del
          MUL (R2 ,p INDD(R7 ,p 2)) ,@comm_del
          
          PUSH (R2) ,@comm_del
          PUSH (R1) ,@comm_del
          CALL(MAKE_SOB_FRAC) ,@comm_del
          DROP (2) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          
          
          LMAKE_MUL_BIN_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_MUL_BIN_BODY)) ,@comm_del) 'bin-mul fvar-tbl))) 
          
;;29
(define lib-binary-div (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_DIV_BIN_CLOS) ,@comm_del
          L_DIV_BIN_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(2)) ,@comm_del
          MOV (R1 ,p FPARG(3)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          DIV (R0 ,p R1) ,@comm_del
          PUSH (R0) ,@comm_del
          CALL (MAKE_SOB_INTEGER) ,@comm_del
          DROP(1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_DIV_BIN_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_DIV_BIN_BODY)) ,@comm_del) 'bin-div fvar-tbl)))
          
;;28
(define lib-remainder (lambda (fvar-tbl)
    (def-lib
        `(JUMP (L_MAKE_REMAINDER_CLOS) ,@comm_del
          L_REMAINDER_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(2)) ,@comm_del
          MOV (R1 ,p FPARG(3)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          LOOP_REMAINDER ,@ass_label
          CMP (R0 ,p R1) ,@comm_del
          JUMP_LT (LOOP_REMAINDER_AFT) ,@comm_del
          SUB(R0 ,p R1) ,@comm_del
          JUMP (LOOP_REMAINDER) ,@comm_del
          LOOP_REMAINDER_AFT ,@ass_label
          PUSH(R0) ,@comm_del
          CALL (MAKE_SOB_INTEGER) ,@comm_del
          DROP(1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          L_MAKE_REMAINDER_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_REMAINDER_BODY)) ,@comm_del) 'remainder fvar-tbl)))
          
;;27
(define lib-make-string (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_MAKE_STRING_CLOS) ,@comm_del
          L_MAKE_STRING_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(1)) ,@comm_del
          CMP (R0 ,p IMM(2)) ,@comm_del
          JUMP_EQ (MAKE_STRING_2_VAR) ,@comm_del
          MOV (R0 ,p FPARG(3)) ,@comm_del ;;one variable
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p IMM(0)) ,@comm_del
          MOV (R3 ,p R0) ,@comm_del
          JUMP (MAKE_STRING_STRING) ,@comm_del
          MAKE_STRING_2_VAR ,@ass_label
          MOV (R0 ,p FPARG(3)) ,@comm_del 
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p FPARG(4)) ,@comm_del 
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          MOV (R3 ,p R0) ,@comm_del
          MAKE_STRING_STRING ,@ass_label
          CMP (R0 ,p IMM(0)) ,@comm_del
          JUMP_EQ (MAKE_STRING_STRING_AFT) ,@comm_del
          PUSH(R1) ,@comm_del
          SUB (R0 ,p IMM(1)) ,@comm_del
          JUMP (MAKE_STRING_STRING) ,@comm_del
          MAKE_STRING_STRING_AFT ,@ass_label
          PUSH(R3) ,@comm_del
          CALL(MAKE_SOB_STRING) ,@comm_del
          ADD (R3 ,p IMM(1)) ,@comm_del
          DROP (R3) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_MAKE_STRING_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_MAKE_STRING_BODY)) ,@comm_del) 'make-string fvar-tbl)))
          
;;26
(define lib-make-vector (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_MAKE_VECTOR_CLOS) ,@comm_del
          L_MAKE_VECTOR_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(1)) ,@comm_del
          CMP (R0 ,p IMM(2)) ,@comm_del
          JUMP_EQ (MAKE_VECTOR_2_VAR) ,@comm_del
          PUSH (IMM(0)) ,@comm_del
          CALL (MAKE_SOB_INTEGER) ,@comm_del
          DROP (1) ,@comm_del
          MOV (R1 ,p R0) ,@comm_del
          MOV (R0 ,p FPARG(3)) ,@comm_del ;;one variable
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R3 ,p R0) ,@comm_del
          JUMP (MAKE_VECTOR_VECTOR) ,@comm_del
          MAKE_VECTOR_2_VAR ,@ass_label
          MOV (R0 ,p FPARG(3)) ,@comm_del 
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p FPARG(4)) ,@comm_del 
          MOV (R3 ,p R0) ,@comm_del
          MAKE_VECTOR_VECTOR ,@ass_label
          CMP (R0 ,p IMM(0)) ,@comm_del
          JUMP_EQ (MAKE_VECTOR_VECTOR_AFT) ,@comm_del
          PUSH(R1) ,@comm_del
          SUB (R0 ,p IMM(1)) ,@comm_del
          JUMP (MAKE_VECTOR_VECTOR) ,@comm_del
          MAKE_VECTOR_VECTOR_AFT ,@ass_label
          PUSH(R3) ,@comm_del
          CALL(MAKE_SOB_VECTOR) ,@comm_del
          ADD (R3 ,p IMM(1)) ,@comm_del
          DROP (R3) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_MAKE_VECTOR_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_MAKE_VECTOR_BODY)) ,@comm_del) 'make-vector fvar-tbl)))
          
;;25
(define lib-string-ref (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_STRING_REF_CLOS) ,@comm_del
          L_STRING_REF_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(3)) ,@comm_del
          MOV (R1 ,p FPARG(4)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          ADD (R1 ,p IMM(2)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p R1)) ,@comm_del
          PUSH (R0) ,@comm_del
          CALL (MAKE_SOB_CHAR) ,@comm_del
          DROP(1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_STRING_REF_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_STRING_REF_BODY)) ,@comm_del) 'string-ref fvar-tbl)))
          
;;24
(define lib-vector-ref (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_VECTOR_REF) ,@comm_del
          L_VECTOR_REF_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(3)) ,@comm_del
          MOV (R1 ,p FPARG(4)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          ADD (R1 ,p IMM(2)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p R1)) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_VECTOR_REF ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_VECTOR_REF_BODY)) ,@comm_del) 'vector-ref fvar-tbl)))
          
;;23
(define lib-zero? (lambda (fvar-tbl)
    (def-lib
	`(JUMP (LMAKE_IS_ZERO_CLOS) ,@comm_del
	  L_IS_ZERO_BODY ,@ass_label
	  PUSH (FP) ,@comm_del
	  MOV (FP ,p SP) ,@comm_del
	  CMP (FPARG(1) ,p IMM(1)) ,@comm_del
	  JUMP_NE (L_error_lambda_args_count) ,@comm_del
	  MOV (R1 ,p FPARG(2)) ,@comm_del
	  PUSH (R1) ,@comm_del
	  CALL(IS_SOB_INTEGER) ,@comm_del
	  DROP(1) ,@comm_del
	  CMP (R0 ,p IMM(1)) ,@comm_del
	  JUMP_NE (L_incorrect_type) ,@comm_del
	  CMP (INDD(R1 ,p 0) ,p IMM(T_INTEGER)) ,@comm_del
	  CMP (INDD(R1 ,p 1) ,p IMM(0)) ,@comm_del
	  JUMP_NE (IS_ZERO_FALSE) ,@comm_del
	  MOV (R0 ,p SOB_TRUE) ,@comm_del
	  JUMP (IS_ZERO_AFT) ,@comm_del
	  IS_ZERO_FALSE ,@ass_label
	  MOV (R0 ,p SOB_FALSE) ,@comm_del
	  IS_ZERO_AFT ,@ass_label
	  POP (FP) ,@comm_del
	  RETURN ,@comm_del
	  LMAKE_IS_ZERO_CLOS ,@ass_label
	  PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_ZERO_BODY)) ,@comm_del) 'zero? fvar-tbl)))

;;21          
(define lib-null? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_NULL_CLOS) ,@comm_del
          L_IS_NULL_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_NIL)) ,@comm_del 
          JUMP_NE (IS_NULL_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_NULL_AFT) ,@comm_del
          IS_NULL_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_NULL_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_NULL_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_NULL_BODY)) ,@comm_del) 'null? fvar-tbl)))
          
(define lib-make-fraction (lambda (fvar-tbl)
    (def-lib 
        `(JUMP (LMAKE_MAKE_FRAC_CLOS) ,@comm_del
          L_MAKE_FRAC_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p INDD (FPARG(3) ,p 1)) ,@comm_del
          PUSH (R0) ,@comm_del
          MOV (R0 ,p INDD (FPARG(2) ,p 1)) ,@comm_del
          PUSH (R0) ,@comm_del
          CALL (MAKE_SOB_FRAC) ,@comm_del
          DROP(2) ,@comm_del
          POP (FP) ,@comm_del        
          RETURN ,@comm_del
          LMAKE_MAKE_FRAC_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_MAKE_FRAC_BODY)) ,@comm_del) 'make-fraction fvar-tbl)))
                
(define lib-bin-bigger (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_BIN_BIGGER_CLOS) ,@comm_del
          L_BIN_BIGGER_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(3)) ,@comm_del
          MOV (R1 ,p FPARG(4)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          CMP (R0 ,p R1) ,@comm_del
          JUMP_GT (BIN_BIGGER_TRUE) ,@comm_del
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          JUMP (BIN_BIGGER_AFT) ,@comm_del
          BIN_BIGGER_TRUE ,@ass_label
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          BIN_BIGGER_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_BIN_BIGGER_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_BIN_BIGGER_BODY)) ,@comm_del) 'bin-bigger fvar-tbl)))
          
(define lib-bin-smaller (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_BIN_SMALLER_CLOS) ,@comm_del
          L_BIN_SMALLER_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(3)) ,@comm_del
          MOV (R1 ,p FPARG(4)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          CMP (R0 ,p R1) ,@comm_del
          JUMP_LT (BIN_SMALLER_TRUE) ,@comm_del
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          JUMP (BIN_SMALLER_AFT) ,@comm_del
          BIN_SMALLER_TRUE ,@ass_label
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          BIN_SMALLER_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_BIN_SMALLER_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_BIN_SMALLER_BODY)) ,@comm_del) 'bin-smaller fvar-tbl)))
          
(define lib-not (lambda (fvar-tbl)
    (def-lib
	`(JUMP (LMAKE_NOT_CLOS) ,@comm_del
	  L_NOT_BODY ,@ass_label
	  PUSH (FP) ,@comm_del
	  MOV (FP ,p SP) ,@comm_del
	  CMP (FPARG(1) ,p IMM(1)) ,@comm_del
	  JUMP_NE (L_error_lambda_args_count) ,@comm_del
	  MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (R1 ,p T_BOOL) ,@comm_del
          JUMP_NE (L_NOT_FALSE) ,@comm_del
          CMP (INDD (R0 ,p 1) ,p IMM(0)) ,@comm_del
          JUMP_NE (L_NOT_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (L_NOT_AFT) ,@comm_del
          L_NOT_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          L_NOT_AFT ,@ass_label
	  POP (FP) ,@comm_del
	  RETURN ,@comm_del
	  LMAKE_NOT_CLOS ,@ass_label
	  PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_NOT_BODY)) ,@comm_del) 'not fvar-tbl)))
          
          
(define lib-boolean? (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_IS_BOOL_CLOS) ,@comm_del
          L_IS_BOOL_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_NE (L_error_lambda_args_count) ,@comm_del
          MOV (R1 ,p FPARG(2)) ,@comm_del
          CMP (INDD (R1 ,p 0) ,p IMM(T_BOOL)) ,@comm_del 
          JUMP_NE (IS_BOOL_FALSE) ,@comm_del
          MOV (R0 ,p SOB_TRUE) ,@comm_del
          JUMP (IS_BOOL_AFT) ,@comm_del
          IS_BOOL_FALSE ,@ass_label
          MOV (R0 ,p SOB_FALSE) ,@comm_del
          IS_BOOL_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_IS_BOOL_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_IS_BOOL_BODY)) ,@comm_del) 'boolean? fvar-tbl)))
          
          
(define lib-string-length (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_STRING_LENGTH_CLOS) ,@comm_del
          L_STRING_LENGTH_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(2)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          PUSH (R0) ,@comm_del
          CALL (MAKE_SOB_INTEGER) ,@comm_del
          DROP (1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_STRING_LENGTH_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_STRING_LENGTH_BODY)) ,@comm_del) 'string-length fvar-tbl)))
          
(define lib-symbol-string (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_SYMBOL_STRING) ,@comm_del
          L_SYMBOL_STRING_BODY ,@ass_label
          PUSH(FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(2)) ,@comm_del
          MOV (R0 ,p INDD(R0 ,p 1)) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_SYMBOL_STRING ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_SYMBOL_STRING_BODY)) ,@comm_del) 'symbol->string fvar-tbl)))
          
(define lib-vector (lambda (fvar-tbl)
    (def-lib 
        `(JUMP (LMAKE_VECTOR_CLOS) ,@comm_del
          L_VECTOR_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          PUSH (R1) ,@comm_del
          PUSH (R2) ,@comm_del
          PUSH (R3) ,@comm_del
          MOV(R0 ,p FPARG(0)) ,@comm_del
	  MOV(R0 ,p FPARG(0)) ,@comm_del
	  ADD(R0 ,p IMM(2)) ,@comm_del
	  PUSH(R0) ,@comm_del
	  CALL(MALLOC) ,@comm_del
	  DROP(1) ,@comm_del
	  MOV(IND(R0) ,p IMM(T_VECTOR)) ,@comm_del
	  MOV(INDD(R0 ,p 1) ,p FPARG(0)) ,@comm_del
	  MOV(R1 ,p FP) ,@comm_del
	  MOV(R2 ,p FPARG(0)) ,@comm_del
	  ADD(R2 ,p IMM(3)) ,@comm_del
	  SUB(R1 ,p R2) ,@comm_del
	  MOV(R2 ,p R0) ,@comm_del
	  ADD(R2 ,p IMM(2)) ,@comm_del
	  MOV(R3 ,p FPARG(0)) ,@comm_del
	L_VEC_LOOP ,@ass_label
	  CMP(R3 ,p IMM(0)) ,@comm_del
	  JUMP_EQ(L_VEC_EXIT) ,@comm_del
	  MOV(IND(R2) ,p STACK(R1)) ,@comm_del
	  INCR(R1) ,@comm_del
	  INCR(R2) ,@comm_del
	  DECR(R3) ,@comm_del
	  JUMP(L_VEC_LOOP) ,@comm_del
	L_VEC_EXIT ,@ass_label
	  POP(R3) ,@comm_del
	  POP(R2) ,@comm_del
	  POP(R1) ,@comm_del
	  POP(FP) ,@comm_del
	  RETURN ,@comm_del
	  LMAKE_VECTOR_CLOS ,@ass_label
	  PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_VECTOR_BODY)) ,@comm_del) 'vector fvar-tbl)))

(define lib-vector-length (lambda (fvar-tbl)
    (def-lib
        `(JUMP (LMAKE_VECTOR_LEN_CLOS) ,@comm_del
          L_VEC_LEN_BODY ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p INDD(FPARG(2) ,p 1)) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          LMAKE_VECTOR_LEN_CLOS ,@ass_label
          PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_VEC_LEN_BODY)) ,@comm_del) 'vector-length fvar-tbl)))
          
          
          
 (define lib-string-symbol (lambda (fvar-tbl)
    (def-lib
	`(JUMP (LMAKE_STRING_SYMBOL_CLOS) ,@comm_del
	  L_STRING_SYMBOL_BODY ,@ass_label
	  PUSH (FP) ,@comm_del
	  MOV (FP ,p SP) ,@comm_del
	  MOV (R1 ,p FPARG(3)) ,@comm_del
	  MOV (R2 ,p IMM(,(symbol-tbl-offset fvar-tbl))) ,@comm_del
	  LOOP_STR_SYM_CMP ,@ass_label
	  ;;compare strings!
	  CMP (INDD(R1 ,p IMM(1)) ,p INDD(R2 ,p 1)) ,@comm_del
	  JUMP_NE (STRINGS_NOT_EQUAL) ,@comm_del
	  MOV (R3 ,p INDD(R1 ,p 1)) ,@comm_del
	  MOV (R4 ,p IMM(2)) ,@comm_del ;;index r4
	  ADD (R3 ,p IMM(2)) ,@comm_del ;;bound r3
	  LOOP_CMP_STR_INNER ,@ass_label
	  CMP (INDD(R1 ,p R4) ,p INDD(R2 ,p R4)) ,@comm_del
	  JUMP_NE (STRINGS_NOT_EQUAL) ,@comm_del
	  ADD (R4 ,p IMM(1)) ,@comm_del
	  CMP (R3 ,p R4) ,@comm_del
	  JUMP_NE (LOOP_CMP_STR_INNER) ,@comm_del
	  ;;strings equal
	  DROP(1) ,@comm_del
	  PUSH(IMM(2)) ,@comm_del
	  CALL(MALLOC) ,@comm_del ;;???
	  DROP(1) ,@comm_del
	  MOV (IND(R0) ,p T_SYMBOL) ,@comm_del
	  MOV (INDD(R0 ,p IMM(1)) ,p R2) ,@comm_del
	  POP (FP) ,@comm_del
	  RETURN ,@comm_del
	  JUMP (LMAKE_STRING_SYMBOL_CLOS) ,@comm_del
	  STRINGS_NOT_EQUAL ,@ass_label
	  MOV (R5 ,p R2) ,@comm_del
	  MOV (R2 ,p INDD(R5 ,p 1)) ,@comm_del ;;goto next link
	  CMP (R2 ,p IMM(,const-tbl-base)) ,@comm_del
	  JUMP_EQ (L_SYMBOL_NOT_EXISTS) ,@comm_del
	  JUMP (LOOP_STR_SYM_CMP) ,@comm_del
	  L_SYMBOL_NOT_EXISTS ,@ass_label
	  ;;create new symbol
	  MOV (R3 ,p (INDD(R1 ,p 1))) ,@comm_del
	  ADD (R3 ,p IMM(2)) ,@comm_del
	  MOV (R4 ,p R1) ,@comm_del
	  PUSH (R3) ,@comm_del
	  CALL (MALLOC) ,@comm_del
	  DROP(1) ,@comm_del
	  MOV (R2 ,p IND(IMM(800))) ,@comm_del
	  MOV (IND(IMM(800)) ,p R0) ,@comm_del
	  MOV (IND(R0) ,p R4) ,@comm_del
	  MOV (INDD(R0 ,p 1) ,p IMM(,const-tbl-base)) ,@comm_del
	  POP (FP) ,@comm_del
	  RETURN ,@comm_del
	  LMAKE_STRING_SYMBOL_CLOS ,@ass_label
	  PUSH(IMM(3)) ,@comm_del
          CALL(MALLOC) ,@comm_del
          DROP(1) ,@comm_del
          MOV (INDD (R0 ,p 0) ,p IMM(T_CLOSURE)) ,@comm_del
          MOV (INDD (R0 ,p 1) ,p IMM(666)) ,@comm_del
          MOV (INDD (R0 ,p 2) ,p LABEL(L_STRING_SYMBOL_BODY)) ,@comm_del) 'string->symbol fvar-tbl)))
	  
	  
	  

(define root-lib-defs (lambda (fvar-tbl)
        (append (lib-car fvar-tbl) (lib-cdr fvar-tbl) (lib-cons fvar-tbl) (lib-numerator fvar-tbl) (lib-denominator fvar-tbl) 
        (lib-eq? fvar-tbl) (lib-char-integer fvar-tbl) (lib-integer-char fvar-tbl) (lib-set-car fvar-tbl) (lib-set-cdr fvar-tbl)
        (lib-string-set fvar-tbl) (lib-vector-set fvar-tbl) (lib-char? fvar-tbl) (lib-integer? fvar-tbl) (lib-pair? fvar-tbl) 
        (lib-fraction? fvar-tbl) (lib-procedure? fvar-tbl) (lib-string? fvar-tbl) (lib-symbol? fvar-tbl) (lib-vector? fvar-tbl)
        (lib-apply fvar-tbl) (lib-binary-plus fvar-tbl) (lib-binary-minus fvar-tbl) (lib-binary-mul fvar-tbl) (lib-binary-div fvar-tbl)
        (lib-remainder fvar-tbl) (lib-make-string fvar-tbl) (lib-make-vector fvar-tbl) (lib-string-ref fvar-tbl) (lib-vector-ref fvar-tbl)
        (lib-zero? fvar-tbl) (lib-null? fvar-tbl) (lib-make-fraction fvar-tbl) (lib-bin-bigger fvar-tbl) (lib-bin-smaller fvar-tbl)
        (lib-not fvar-tbl) (lib-boolean? fvar-tbl) (lib-string-length fvar-tbl) (lib-symbol-string fvar-tbl) (lib-vector fvar-tbl)
        (lib-vector-length fvar-tbl) (lib-string-symbol fvar-tbl))))
        
;;20
(define lib-equal
    '(define bin-eq (lambda (x y) (zero? (bin-minus x y)))))

;;19
(define lib-plus
    '(define + (lambda x 
	    (if (pair? x) (bin-plus (car x) (apply + (cdr x))) 0))))
	    
;;18
(define lib-mul
    '(define * (lambda x 
	    (if (pair? x) (bin-mul (car x) (apply * (cdr x))) 1))))
	    
;;17
(define lib-minus
    '(define - (lambda (x . y) 
        (if (pair? x) (+ x (* -1 (apply + y))) x))))
        
;;17
(define lib-number?
    '(define number? (lambda (x) (or (integer? x) (fraction? x)))))

;;16
(define lib-div 
    '(define / (lambda (x . y) 
        (if (pair? y) (* x (make-fraction (denominator (apply * y)) (numerator (apply * y)))) x))))
        
;;13
(define lib-bigger
    '(define > (lambda (x . y)
        (if (null? y) #t 
            (if (bin-bigger x (car y)) (apply > y) #f))))) 
            
;;12
(define lib-smaller
    '(define < (lambda (x . y)
        (if (null? y) #t 
            (if (bin-smaller x (car y)) (apply < y) #f)))))

;;10
(define lib-list
    '(define list (lambda x x)))
    
(define lib-bin-append
    '(define bin-append (lambda (lst1 lst2)
            (if (null? lst1) lst2
                (cons (car lst1) (bin-append (cdr lst1) lst2))))))
                
(define lib-append
    '(define append (lambda x (if (pair? x) (bin-append (car x) (apply append (cdr x))) (list)))))

(define lib-rational?
    '(define rational? number?))
    
(define lib-map
    '(define map (lambda (f lst)
        (if (null? lst) (list)
            (cons (f (car lst)) (map f (cdr lst)))))))
    
(define scheme-lib-defs
    (list lib-equal lib-plus lib-mul lib-minus lib-number? lib-div lib-bigger lib-smaller lib-list lib-bin-append lib-append lib-rational?
    lib-map))
    
    
   
      

;;;;;;;;;;;;;;;;;;;;;_________________***********************

(define fraction-typedef
        `(
        
        
          MAKE_SOB_FRAC ,@ass_label
          PUSH (FP) ,@comm_del        
          MOV (FP ,p SP) ,@comm_del
          PUSH (IMM(3)) ,@comm_del
          CALL (MALLOC) ,@comm_del
          DROP (1) ,@comm_del
          MOV (IND(R0) ,p IMM(T_FRAC)) ,@comm_del
          MOV (INDD(R0 ,p 1) ,p FPARG(1)) ,@comm_del
          CMP (FPARG(1) ,p IMM(1)) ,@comm_del
          JUMP_EQ (SOB_FRAC_INT) ,@comm_del
          MOV (INDD(R0 ,p 2) ,p FPARG(0)) ,@comm_del
          JUMP (SOB_FRAC_AFT) ,@comm_del
          SOB_FRAC_INT ,@ass_label
          MOV (INDD(R0 ,p 2) ,p IMM(1)) ,@comm_del
          SOB_FRAC_AFT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          
          IS_SOB_FRAC ,@ass_label
          PUSH (FP) ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R0 ,p FPARG(0)) ,@comm_del
          CMP (IND(R0) ,p IMM(T_FRAC)) ,@comm_del
          JUMP_EQ (IS_SOB_FRAC_TRUE) ,@comm_del
          MOV (R0 ,p IMM(0)) ,@comm_del
          JUMP(L_IS_SOB_FRAC_EXIT) ,@comm_del
          IS_SOB_FRAC_TRUE ,@ass_label
          MOV (R0 ,p IMM(1)) ,@comm_del
          L_IS_SOB_FRAC_EXIT ,@ass_label
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          
          WRITE_SOB_FRAC ,@ass_label
          PUSH (FP)  ,@comm_del
          MOV (FP ,p SP) ,@comm_del
          MOV (R1 ,p FPARG(0)) ,@comm_del
          MOV (R2 ,p INDD(R1 ,p 2)) ,@comm_del
          MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
          
            LOOP_GCD_WR ,@ass_label
            MOV (R3 ,p R1) ,@comm_del
            REM (R3 ,p R2) ,@comm_del
            CMP (R3 ,p IMM(0)) ,@comm_del
            JUMP_EQ (GCD_WR_AFT) ,@comm_del
            MOV (R1 ,p R2) ,@comm_del
            MOV (R2 ,p R3) ,@comm_del
            JUMP (LOOP_GCD_WR) ,@comm_del
            GCD_WR_AFT ,@ass_label
            
          MOV (R1 ,p FPARG(0)) ,@comm_del
          MOV (R3 ,p INDD(R1 ,p 1)) ,@comm_del
          DIV (R3 ,p R2) ,@comm_del
          MOV (R4 ,p INDD(R1 ,p 2)) ,@comm_del
          DIV (R4 ,p R2) ,@comm_del
      
          PUSH (R3) ,@comm_del
          CALL (WRITE_INTEGER) ,@comm_del
          DROP(1) ,@comm_del
          PUSH (IMM(47)) ,@comm_del 
          CALL (PUTCHAR) ,@comm_del
          DROP (1) ,@comm_del
          PUSH (R4) ,@comm_del
          CALL (WRITE_INTEGER) ,@comm_del
          DROP(1) ,@comm_del
          POP (FP) ,@comm_del
          RETURN ,@comm_del
          ))
          
(define gcd
    `(GCD ,@ass_label
      PUSH (FP)  ,@comm_del
      MOV (FP ,p SP) ,@comm_del
      MOV (R1 ,p FPARG(2)) ,@comm_del
      MOV (R2 ,p FPARG(3)) ,@comm_del
      MOV (R1 ,p INDD(R1 ,p 1)) ,@comm_del
      MOV (R2 ,p INDD(R2 ,p 2)) ,@comm_del
      LOOP_GCD ,@ass_label
      MOV (R3 ,p R1) ,@comm_del
      REM (R3 ,p R2) ,@comm_del
      CMP (R3 ,p IMM(0)) ,@comm_del
      JUMP_EQ (GCD_AFT) ,@comm_del
      MOV (R1 ,p R2) ,@comm_del
      MOV (R2 ,p R3) ,@comm_del
      JUMP (LOOP_GCD) ,@comm_del
      GCD_AFT ,@ass_label
      PUSH (R2) ,@comm_del
      CALL (MAKE_SOB_INTEGER) ,@comm_del
      DROP(1) ,@comm_del
      POP(FP),@comm_del
      RETURN ,@comm_del))
      
(define lcm
    `(LCM ,@ass_label
      PUSH (FP)  ,@comm_del
      MOV (FP ,p SP) ,@comm_del
      MOV (R4 ,p FPARG(2)) ,@comm_del
      MOV (R5 ,p FPARG(3)) ,@comm_del
      MOV (R4 ,p INDD(R4 ,p 1)) ,@comm_del
      MOV (R5 ,p INDD(R5 ,p 2)) ,@comm_del
      PUSH (R2) ,@comm_del
      PUSH (R1) ,@comm_del
      CALL (GCD) ,@comm_del
      DROP(2) ,@comm_del
      MUL (R4 ,p R5) ,@comm_del
      DIV (R4 ,p R0) ,@comm_del
      PUSH (R4) ,@comm_del
      CALL (MAKE_SOB_INTEGER) ,@comm_del
      DROP(1) ,@comm_del
      POP(FP),@comm_del
      RETURN ,@comm_del))
      
(define addFractions ;; api: arg2: first number numerator, arg3: first number denominator, arg4: second number numerator, arg5: second number denominator
    `(ADD_FRACTIONS ,@ass_label
      PUSH (FP)  ,@comm_del
      MOV (FP ,p SP) ,@comm_del
      PUSH (FPARG(5)) ,@comm_del
      PUSH (FPARG(3)) ,@comm_del
      CALL (LCM) ,@comm_del
      ;;calc first scalar
      MOV (R1 ,p R0) ,@comm_del 
      DIV (R1 ,p FPARG(3)) ,@comm_del 
      ;;calc first new numerator
      MOV (R2 ,p FPARG(2)) ,@comm_del 
      MUL (R2 ,p R1) ,@comm_del 
      ;;calc second scalar
      MOV (R3 ,p R0) ,@comm_del 
      DIV (R3 ,p FPARG(5)) ,@comm_del 
      ;;calc second new numerator
      MOV (R4 ,p FPARG(4)) ,@comm_del 
      MUL (R4 ,p FPARG(5)) ,@comm_del 
      
      ;;calc added numerator
      ADD (R4 ,p R3) ,@comm_del 
      PUSH(R0) ,@comm_del 
      PUSH(R4) ,@comm_del 
      CALL (MAKE_SOB_FRAC) ,@comm_del 
      DROP(2) ,@comm_del 
      POP(FP),@comm_del
      RETURN ,@comm_del))
      

      
      
       
          
(define prolog (lambda (mem_size)
     `(,(string->symbol "#define DO_SHOW 1") ,(string->symbol "\n")
       ,(string->symbol "#include <stdio.h>") ,(string->symbol "\n")
       ,(string->symbol "#include <stdlib.h>") ,(string->symbol "\n")
       ,(string->symbol "#include \"arch/cisc.h\"") ,(string->symbol "\n")
       ,(string->symbol "#include \"info.h\"") ,(string->symbol "\n")
       int main ,(string->symbol "() \n")
       {
            START_MACHINE ,@comm_del
            JUMP (CONTINUE) ,@comm_del
            ,(string->symbol "#define")T_FRAC 451794 ,(string->symbol "\n")
            ,(string->symbol "#define") SOB_TRUE 1 ,(string->symbol "\n")
            ,(string->symbol "#define") SOB_FALSE 3 ,(string->symbol "\n")
            ,(string->symbol "#define") SOB_VOID 5 ,(string->symbol "\n")
            ,(string->symbol "#define") SOB_NIL 6 ,(string->symbol "\n")
            ,(string->symbol "#include \"arch/char.lib\"") ,(string->symbol "\n")
            ,(string->symbol "#include \"arch/io.lib\"") ,(string->symbol "\n")
            ,(string->symbol "#include \"arch/math.lib\"") ,(string->symbol "\n")
            ,(string->symbol "#include \"arch/string.lib\"") ,(string->symbol "\n")
            ,(string->symbol "#include \"arch/system.lib\"") ,(string->symbol "\n")
            ,(string->symbol "#include \"arch/scheme.lib\"") ,(string->symbol "\n")        
            ,@gcd
            ,@lcm
            ,@fraction-typedef
            ,@addFractions
            CONTINUE ,@ass_label
            PUSH (,mem_size) ,@comm_del
            CALL (MALLOC) ,@comm_del
            DROP(1) ,@comm_del
            MOV (IND(1) ,p IMM(T_BOOL)) ,@comm_del
            MOV (IND(2) ,p IMM(1)) ,@comm_del
            MOV (IND(3) ,p IMM(T_BOOL)) ,@comm_del
            MOV (IND(4) ,p IMM(0)) ,@comm_del
            MOV (IND(5) ,p IMM(T_VOID)) ,@comm_del
            MOV (IND(6) ,p IMM(T_NIL))  ,@comm_del
            )))
            
(define epilog 
      `(JUMP (COMPILER_END) ,@comm_del
	L_ERROR_CANNOT_APPLY_NON_CLOS ,@ass_label
	fprintf(stderr ,p ,(string->symbol "\"") ERROR_CANNOT_APPLY_NON_CLOS ,(string->symbol "\"")) ,@comm_del
	JUMP (COMPILER_END) ,@comm_del
	L_incorrect_type ,@ass_label
	fprintf(stderr ,p ,(string->symbol "\"") ERROR_incorrect_type ,(string->symbol "\"")) ,@comm_del
	JUMP (COMPILER_END) ,@comm_del
	L_error_lambda_args_count ,@ass_label
	fprintf(stderr ,p ,(string->symbol "\"") error_lambda_args_count ,(string->symbol "\"")) ,@comm_del
	COMPILER_END ,@ass_label
	STOP_MACHINE ,@comm_del
	return 0 ,@comm_del
	}))
	

(define mem-comp-size 
    (letrec ((lst-of-syms (lambda (lst)
                        (cond ((null? lst) '())
                              ((equal? 'T_SYMBOL (car (caddr (car lst)))) (cons (car lst) (lst-of-syms (cdr lst))))
                              (else (lst-of-syms (cdr lst)))))))
        (lambda (const-tbl sym-tbl-offset)
                (+ 16 sym-tbl-offset (* 2 (length (lst-of-syms const-tbl)))))))
                    

        
	   
(define generate-file
	(letrec ((scheme-code (lambda (source) (append 
	;scheme-lib-defs 
	(list-sxprs (file->string source)))))
		(scheme-parsed-code (lambda (source)  (apply-all (scheme-code source)))))
	(lambda (source)
	  (append 
	  (list (prolog (mem-comp-size (get-const-tbl (scheme-code source)) (symbol-tbl-offset  (get-fvar-tbl (scheme-parsed-code source) 
		  (fvar-tbl-offset (get-const-tbl (scheme-code source))))))))
	  (list (root-const-tbl (get-const-tbl (scheme-code source))) )
	  (list (root-symbols (get-const-tbl (scheme-code source)) (symbol-tbl-offset  (get-fvar-tbl (scheme-parsed-code source) 
		  (fvar-tbl-offset (get-const-tbl (scheme-code source)))))))
          (list (root-lib-defs (get-fvar-tbl (scheme-parsed-code source) 
		  (fvar-tbl-offset (get-const-tbl (scheme-code source))))))
	  (map (lambda (x) (append (code-gen x (get-const-tbl (scheme-code source)) (get-fvar-tbl (scheme-parsed-code source) 
		  (fvar-tbl-offset (get-const-tbl (scheme-code source)))) 0) (print-ret-val))) (scheme-parsed-code source) ) (list epilog)))))
		  
(define xen     
      (letrec 
	       ((rex (lambda (lst)
			(cond ((null? lst) '())
			      (else (append (car lst) (rex (cdr lst))))))))
      (lambda (source) (rex (generate-file source)))))
      
      
(define code->string
    (letrec ((rex (lambda (item b)
		(cond ((null? item) ")")
		      ((list? item) (string-append b (rex (car item) "(")  (rex (cdr item) " ")))
		      ;((char? item) (string-append " " (list->string (list item)) " "))
		      ((symbol? item) (string-append  (symbol->string item) ))
		      ((number? item) (string-append  (number->string item) ))
		      (else "")))))
    (lambda (code)
	(cond ((null? code) "")
	      (else (string-append (rex (car code) "(") " " (code->string (cdr code))))))))
      
 (define compile-scheme-file
     (lambda (source target)	 
        (call-with-output-file target
        (lambda (output-port)
(display (code->string (xen source)) output-port)))))
