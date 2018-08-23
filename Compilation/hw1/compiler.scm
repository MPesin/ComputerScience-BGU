;TOMER & MICHAEL


(define <Boolean>
    (new (*parser (char #\#))
	 (*parser (char #\t))
	 (*parser (char #\f))
	 (*disj 2)
	 (*caten 2)
	 (*pack-with (lambda  (x y) (list->string (list x y))))
	 done))

(define <CharPrefix>
  (new (*parser (char #\#))
	(*parser (char #\\))
	(*caten 2)
	(*pack-with (lambda  (x y) (list->string (list x y))))
	done))
	
(define <VisibleSimpleChar>
  (new (*parser (range #\! #\~))
	(*pack (lambda(ch) (list->string `(,ch))))
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
         (*guard (lambda (n) (not (integer? n))))
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
       (*pack-with
	(lambda (++ n) 
	  n))
       (*parser (char #\-))
       (*parser <Natural>)
       (*caten 2)
       (*pack-with
	(lambda (-- n) (- n)))
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
    (new (*parser  <any-char>)
	(*guard (lambda(ch)
	    (not (equal? ch #\\))))
	done))
    
(define <StringMetaChar>
    (new (*parser (char #\\))
         (*parser (char #\\))
         (*parser (char #\"))
         (*parser (char #\t))
         (*parser (char #\n))
         (*parser (char #\r))
         (*disj 5)
         (*caten 2)
         (*pack-with (lambda (x y) (list->string (list x y))))
         done))
         
(define <StringHexChar>
    (new (*parser (char #\\))
         (*parser <HexChar>) *star
         (*caten 2)
         (*pack-with (lambda (x y) (list->string (cons x y))))
         done))
         
(define <StringChar>
    (new         
         (*parser <StringHexChar>)
         (*parser <StringMetaChar>)
         (*parser <StringLiteralChar>) (*pack (lambda (x) (list->string (list x))))
         (*disj 3)
         done))
         
(define <String>
    (new (*parser (char #\"))
         (*parser <StringChar>) *star
         (*parser (char #\"))
         (*caten 3)
         (*pack-with (lambda (x y z) (string-append (list->string (list x)) y (list->string (list z)))))
         done))
         
(define <SymbolChar> 
    (new (*parser (range (integer->char 48) (integer->char 57)))
	 (*parser (range (integer->char 65) (integer->char 90)))
	 (*parser (range (integer->char 97) (integer->char 122)))
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
        (*parser <SymbolChar>) *star
        (*caten 2)
        (*pack-with 
            (lambda (x y)
                (list->string (append (list x) y))))
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
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



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
	    (lambda (x y z) y))
	   done))))

(define ^<skipped*> (^^<wrapped> (star <skip>)))

(define skipped-char (lambda (ch)
                        (^<skipped*> (char ch))))
                        
                      
(define <ProperList>
    (new (*parser (char #\())
         (*delayed (lambda() <Sexpr>)) *star
         (*parser (char #\)))
        (*caten 3)
        (*pack-with (lambda(b1 lst b2)
                        lst))
    done))
    
(define <ImproperList>
    (new (*parser (char #\())
         (*delayed (lambda() <Sexpr>)) *plus
         (*parser (char #\.))
         (*delayed (lambda() <Sexpr>))
         (*parser (char #\)))
         (*caten 5)
         (*pack-with (lambda (op lst dot el cl)
                        (append lst el)))
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
         
         


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define <InfixAtom>    
        (^<skipped*> (new (*delayed (lambda() <InfixFuncall>))
         (*parser (skipped-char #\[))
         (*delayed (lambda() <AddSub>))
         (*parser (skipped-char #\]))
         (*caten 3)
         (*pack-with (lambda(open exp close)exp))
         *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-left (lambda(exp next) `(vector-ref ,exp ,next)) a lst)))
         done)))
                   

                 
(define <InfixPow>    (^<skipped*> (new 
         (*delayed (lambda () <InfixAtom>))
         (*parser (^<skipped*> <PowerSymbol>))
         (*delayed (lambda () <InfixAtom>))
         (*caten 2)
         (*pack-with (lambda(x y) y))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-right (lambda(num next) `(expt ,num  ,next)) (car (reverse (cons a lst)))  (reverse(cdr (reverse (cons a lst)))))))
         done)))

(define <InfixDiv> (^<skipped*>
    (new (*delayed (lambda () <InfixDiv>))
         (*parser (skipped-char #\/))
         (*delayed (lambda () <InfixDiv>))
         (*caten 2)
         (*pack-with (lambda(x y) (cons x y)))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-left (lambda(num next) `(/ ,num ,(cdr next))) a lst)))
         done)))
                
(define <InfixMul>(^<skipped*>
    (new (*delayed (lambda () <InfixPow>))
         (*parser (skipped-char #\*))
         (*delayed (lambda () <InfixPow>))
         (*caten 2)
         (*pack-with (lambda(x y) (cons x y)))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-left (lambda(num next) `(* ,num ,(cdr next))) a lst)))
         done)))
         
(define <DivMul> (new (*parser <InfixMul>) (*parser <InfixDiv>) (*disj 2) done))

(define <InfixSub> (^<skipped*>
    (new (*delayed (lambda () <DivMul>))
         (*parser (skipped-char #\-))
         (*delayed (lambda () <DivMul>))
         (*caten 2)
         (*pack-with (lambda(fun num) (cons fun num)))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst) (fold-left (lambda(num next) `(- ,num ,(cdr next))) a lst)))
         done)))
                
(define <InfixAdd> (^<skipped*>
    (new (*delayed (lambda () <DivMul>))
         (*parser (skipped-char #\+))
         (*delayed (lambda () <DivMul>))
         (*caten 2)
         (*pack-with (lambda(fun num) (cons fun num)))
          *star
         (*caten 2)
         (*pack-with (lambda(a lst)  (fold-left (lambda(num next) `(+ ,num ,(cdr next))) a lst)))
         done)))
                
(define <AddSub> (new (*parser <InfixAdd>) (*parser <InfixSub>) (*disj 2) done))

(define <ClassicExpression> (new (*parser <AddSub>) (*parser <InfixSymbol>) (*disj 2) done))

(define <InfixArgList> (new (*parser <ClassicExpression>)
                    (*parser (char #\,))
                    (*parser <ClassicExpression>)
                     (*caten 2) (*pack (lambda (x) (cadr x))) *star
                     (*parser <epsilon>)
                     (*disj 2)
                     (*caten 2)
                     (*pack-with (lambda (x y) `(,x ,@y)))
                     done))


     
(define <InfixSexprEscape> (new (*parser <InfixPrefixExtensionPrefix> ) 
    (*parser (*delayed (lambda () <Sexpr>))) 
    (*caten 2)
    (*pack-with (lambda (x y) '(,x ,y)))
    done))

(define <final>
    (^<skipped*>(new (*parser <Number>)
         (*parser <InfixSymbol>)
         (*parser <InfixSexprEscape>)
         (*disj 3)
         done)))
           
(define <Bracket>
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
         (*pack-with (lambda (open exp close) exp))
         (*delayed (lambda() <final>))
         (*disj 4)
         done)))



(define <InfixFuncall> ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;done
    (^<skipped*>(new (*delayed (lambda() <Bracket>))
         (*parser (skipped-char #\())
         (*delayed (lambda() <InfixArgList>))
         (*parser <epsilon>)
         (*disj 2)
         (*parser (skipped-char #\)))
         (*caten 3)
         (*pack-with (lambda (open exp close) exp))
         *star
         (*caten 2)
         (*pack-with (lambda (a lst) (fold-left (lambda(exp next) `(,exp ,@next)) a lst)))
         (*delayed (lambda() <Bracket>))
         (*disj 2)
         done)))

                    

                    
(define <InfixParen> 
    (new (*parser (char #\()) 
    (*parser <ClassicExpression>) 
    (*parser (char #\))) 
    (*caten 3) 
    (*pack-with (lambda (x y z) (list y)))
    done))

                     
                    

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