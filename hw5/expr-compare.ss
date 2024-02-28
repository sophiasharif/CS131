#lang racket

(define expr-compare
  (lambda (x y)
    (cond

      ; no difference
      [(equal? x y) x]

      ; bool
      [(and (boolean? x) (boolean? y)) (if x '% '(not %))]

      ; lists of the same length
      [(and (list? x) (list? y) (= (length x) (length y))) (list-compare x y)]

      ; different otherise
      [else `(if % ,x ,y)])))

; element-wise compare of lists (which are either quotes, lambdas, or if statements)
(define (list-compare x y)
  (let (
        [car-x (car x)]
        [car-y (car y)]
        [lambda? (lambda (x) (member x '(lambda λ)))]
        [quote?  (lambda (x) (eqv? x 'quote))]
        [if?  (lambda (x) (eqv? x 'if))]
        [xor (lambda (x y) (or (and x (not y)) (and (not x) y)))]
        )

    (cond

      ; both lambda
      [(and (lambda? car-x) (lambda? car-y)) (lambda-compare x y)]

      ; type mismatch or quote
      [(or
        (xor (lambda? car-x) (lambda? car-y))       
        (xor (if? car-x) (if? car-y))
        (or (quote? car-x) (quote? car-y)))
       `(if % ,x ,y)]
      
      ; if statement, list, cons, quote
      [else (element-compare x y)]
      )))

(define (element-compare x y)
  (if (eqv? x `()) `() (cons (expr-compare (car x) (car y)) (element-compare (cdr x) (cdr y)))))

(define (lambda-compare x y)
  (let* (
        [decl (if (and (eqv? (car x) 'lambda) (eqv? (car y) 'lambda)) 'lambda 'λ)]      
        [param-dicts (create-param-dict (cadr x) (cadr y))]
        [x-param-dict (car param-dicts)]
        [y-param-dict (cadr param-dicts)]
        [x-params (rename-args (cadr x) x-param-dict)] ; DELETE
        [y-params (rename-args (cadr y) y-param-dict)] ; DELETE
        [x-body (rename-args (caddr x) x-param-dict)]
        [y-body (rename-args (caddr y) y-param-dict)]
        )
    
    ; replace identifiers with proper format -- IMPLEMENT
    ;(write x-param-dict) (newline)
    ;(write y-param-dict) (newline)
    ;(write (cadr x)) (newline)
    ;(write x-params) (newline)
    ;(write (cadr y)) (newline)
    ;(write y-params) (newline)
    ;(write (caddr x)) (newline)
    ;(write x-body) (newline)
    ;(write (caddr y)) (newline)
    ;(write y-body) (newline)
  
    
    (list decl (expr-compare x-params y-params) (expr-compare x-body y-body)))
  )

(define (create-param-dict x-params y-params)
  (let* ([x-param-dict (make-hash)]
        [y-param-dict (make-hash)]
        [handle-params
         (lambda (a b)
           (let ([new-param (string->symbol (string-append (symbol->string a) "!" (symbol->string b)))])
             (if
              (eqv? a b)
              (and (hash-set! x-param-dict a a) (hash-set! y-param-dict b b))
              (and (hash-set! x-param-dict a new-param) (hash-set! y-param-dict b new-param))
             )))])
    (map handle-params x-params y-params)
    `(,x-param-dict ,y-param-dict)
    ))


(define (rename-args expr dict)
  (if (list? expr)
      (map (lambda (x) (rename-args x dict)) expr)
      (hash-ref dict expr expr)
      ))


  
;(expr-compare '((lambda (a) a) c) '((lambda (b) b) d))
