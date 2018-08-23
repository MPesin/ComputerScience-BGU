;TOMER & MICHAEL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;    change filename to compiler.scm
(load "pc.scm")
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

(define <comment>
  (disj <line-comment>
	<sexpr-comment>))

(define <skip>
  (disj <comment>
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

(define skipped-char (lambda (ch)
                        (^<skipped*> (char ch))))

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
	 (*parser <HexUnicodeChar>)
         (*parser <VisibleSimpleChar>)
         (*parser <NamedChar>) (*pack (lambda (x) (list->string (list x))))
         (*disj 3)
         (*guard (lambda (n) (or (not (integer? n)) (< n 1114111))))
         (*pack (lambda (n) (if (integer? n) 
                                (integer->char n)
                                n)))
         (*caten 2)
         (*pack-with (lambda (x y) y))

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
<<<<<<< HEAD
	
<<<<<<< HEAD
(define <InfixAdd>
    (new (*parser <Number>) 
         (*parser (char #\+))
         (*parser <Number>) 
         (*caten 3)
         (*pack-with 
            (lambda (a b c)
                (if (equal? b #\+)
                    (list->string (list #\( #\+ #\space a #\space c #\))))))
         done))
         
=======
;; (define <InfixAdd>
;;     (new (*parser <Number>) 
;;          (*parser (char #\+))
;;          (*parser <Number>) 
;;          (*caten 3)
;;          (*pack-with 
;;             (lambda (a b c)
;;                 (if (equal? b #\+)
;;                     (list->string (list #\( #\+ #\space a #\space c #\))))))
;;          done))
>>>>>>> c98605564460af2601a5c7a67a20d355d64a8478
         
=======
>>>>>>> 21688ff83bcddd79a36878104aeaeaa386c90da4



                        
                      
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
         

  



                 
(define <InfixPow>    (^<skipped*> (new 
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

(define <ClassicExpression> (^<skipped*> (new (*parser <AddSub>) done)))

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
   (^<skipped*> (new (*parser <ClassicExpression>)
         (*parser (skipped-char #\,))
         (*parser <ClassicExpression>)
         (*caten 2)
         (*pack-with (lambda(x y) y))
         *star
         (*caten 2)
         (*pack-with (lambda(x y) `(,x ,@y)))
         done)))

     
(define <InfixSexprEscape>  (^<skipped*> (new (*parser <InfixPrefixExtensionPrefix> ) 
    (*parser (*delayed (lambda () <Sexpr>))) 
    (*caten 2)
    (*pack-with (lambda (x y) y))
    done)))

(define <terminalo>
    (^<skipped*> (new (*parser <Number>)
         (*parser <InfixSymbol>)
         (*parser <InfixSexprEscape>)
         (*disj 3)
         done)))
           


(define <InfixFuncall> 
    (^<skipped*> (new (*delayed (lambda() <InfixParen>))
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
     (^<skipped*> (new (*parser (char #\-))
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
        (^<skipped*> (new (*delayed (lambda() <InfixFuncall>))
         (*parser (skipped-char #\[))
         (*delayed (lambda() <AddSub>))
         (*parser (skipped-char #\])) 
         (*caten 3)
         (*pack-with (lambda(x y z) y))
         *star
         (*caten 2)
         (*pack-with (lambda(x y) (fold-left (lambda (exp nxt) `(vector-ref ,exp ,nxt)) x y)))
         done)))
                   
                   
(define <InfixExtension>
  (^<skipped*>
    (new (*parser <InfixPrefixExtensionPrefix>)
         (*parser  <AddSub>)
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

     (define <sexpr> <Sexpr>)
