#lang racket

(define x-dict-stack (list (make-hash)))
(define y-dict-stack (list (make-hash)))

(define (return-different x y) `(if % ,(rename-args x (car x-dict-stack)) ,(rename-args y (car y-dict-stack))))

(define expr-compare
  (lambda (x y)
    (cond

      ; no difference
      [(equal? (rename-args x (car x-dict-stack)) (rename-args y (car y-dict-stack))) (rename-args x (car x-dict-stack))]

      ; bool
      [(and (boolean? x) (boolean? y)) (if x '% '(not %))]

      ; lists of the same length
      [(and (list? x) (list? y) (= (length x) (length y))) (list-compare x y)]

      ; different otherise
      [else (return-different x y)])))

(define (list-compare x y)
  (let* (
        [car-x (car x)]
        [car-y (car y)]
        [lambda? (lambda (x) (member x '(lambda λ)))]
        [quote?  (lambda (x) (eqv? x 'quote))]
        [if?  (lambda (x) (eqv? x 'if))]
        [xor (lambda (x y) (or (and x (not y)) (and (not x) y)))]
        )

    (cond

      ; both lambda
      [(and (lambda? car-x) (lambda? car-y))
       (if (not (= (length (cadr x)) (length (cadr y)))) ; check number of params is equal
           (return-different x y) 
           (lambda-compare x y))]

      ; type mismatch or quote
      [(or
        (xor (lambda? car-x) (lambda? car-y))       
        (xor (if? car-x) (if? car-y))
        (or (quote? car-x) (quote? car-y)))
        (return-different x y)]
      
      ; if statement, list, cons, quote
      [else (element-compare x y)]
      )))

(define (element-compare x y) (if (eqv? x `()) `() (cons (expr-compare (car x) (car y)) (element-compare (cdr x) (cdr y)))))

(define (lambda-compare x y)
  
  (update-param-dicts (cadr x) (cadr y))
  
  (let* ([decl (if (and (eqv? (car x) 'lambda) (eqv? (car y) 'lambda)) 'lambda 'λ)]      
        [res (list decl (expr-compare (cadr x) (cadr y)) (expr-compare (caddr x) (caddr y)))])
  
     ; pop dicts off the stack
    (set! x-dict-stack (cdr x-dict-stack))
    (set! y-dict-stack (cdr y-dict-stack))

    res))

(define (update-param-dicts x-params y-params)
  (let* (   
        ; get most recent param dicts off the stack
        [x-param-dict (hash-copy (car x-dict-stack))]
        [y-param-dict (hash-copy (car y-dict-stack))]

        ; mapping function
        [handle-params
         (lambda (a b)
           (let ([new-param (string->symbol (string-append (symbol->string a) "!" (symbol->string b)))])
             (if (eqv? a b)
              (and (hash-set! x-param-dict a a) (hash-set! y-param-dict b b))
              (and (hash-set! x-param-dict a new-param) (hash-set! y-param-dict b new-param)))))])

    ; push param dicts onto the stack
    (map handle-params x-params y-params)

    ; update stacks of dicts
    (set! x-dict-stack (cons x-param-dict x-dict-stack))
    (set! y-dict-stack (cons y-param-dict y-dict-stack))))

(define (rename-args expr dict)
  (if (list? expr)
      (map (lambda (x) (rename-args x dict)) expr)
      (hash-ref dict expr expr)))

(define (test-expr-compare x y) 
  (and (eqv? (eval x) (eval `(let ([% #t]) ,(expr-compare x y))))
       (eqv? (eval y) (eval `(let ([% #f]) ,(expr-compare x y))))))