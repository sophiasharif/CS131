#lang racket

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
      [else `(if % ,(rename-args x (car x-dict-stack)) ,(rename-args y (car y-dict-stack)))])))

; element-wise compare of lists (which are either quotes, lambdas, or if statements)
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
      [(and (lambda? car-x) (lambda? car-y)) (lambda-compare x y)]

      ; type mismatch or quote
      [(or
        (xor (lambda? car-x) (lambda? car-y))       
        (xor (if? car-x) (if? car-y))
        (or (quote? car-x) (quote? car-y)))
       `(if % ,(rename-args x (car x-dict-stack)) ,(rename-args y (car y-dict-stack)))]
      
      ; if statement, list, cons, quote
      [else (element-compare x y)]
      )))

(define (element-compare x y)
  (if (eqv? x `()) `() (cons (expr-compare (car x) (car y)) (element-compare (cdr x) (cdr y)))))


(define x-dict-stack (list (make-hash)))
(define y-dict-stack (list (make-hash)))

(define (lambda-compare x y)
  
  ; update param dicts
  (create-param-dict (cadr x) (cadr y))
  
  (let* (
        [decl (if (and (eqv? (car x) 'lambda) (eqv? (car y) 'lambda)) 'lambda 'λ)]      
        [x-param-dict (car x-dict-stack)]
        [y-param-dict (car y-dict-stack)]
        ;[x-params (rename-args (cadr x) x-param-dict)]
        ;[y-params (rename-args (cadr y) y-param-dict)]
        ;[x-body (rename-args (caddr x) x-param-dict)]
        ;[y-body (rename-args (caddr y) y-param-dict)]
        [res (list decl (expr-compare (cadr x) (cadr y)) (expr-compare (caddr x) (caddr y)))]
        )
  
     ; pop dicts off the stack
    (set! x-dict-stack (cdr x-dict-stack))
    (set! y-dict-stack (cdr y-dict-stack))
    (write x-dict-stack) (newline)
    (write y-dict-stack) (newline)
    res ))

(define (create-param-dict x-params y-params)
  (let* ([x-param-dict (hash-copy (car x-dict-stack))]
        [y-param-dict (hash-copy (car y-dict-stack))]
        [handle-params
         (lambda (a b)
           (let ([new-param (string->symbol (string-append (symbol->string a) "!" (symbol->string b)))])
             (if
              (eqv? a b)
              (and (hash-set! x-param-dict a a) (hash-set! y-param-dict b b))
              (and (hash-set! x-param-dict a new-param) (hash-set! y-param-dict b new-param))
             )))])
    (map handle-params x-params y-params)

    ; update stacks of dicts
    (set! x-dict-stack (cons x-param-dict x-dict-stack))
    (write x-dict-stack) (newline)
    (set! y-dict-stack (cons y-param-dict y-dict-stack))
    (write y-dict-stack) (newline)))


(define (rename-args expr dict)
  (if (list? expr)
      (map (lambda (x) (rename-args x dict)) expr)
      (hash-ref dict expr expr)
      ))


  
(expr-compare '((lambda (a) a) c) '((lambda (b) b) d))
