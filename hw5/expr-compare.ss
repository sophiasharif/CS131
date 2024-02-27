#lang racket

(define expr-compare
  (lambda (x y)
    (cond

      ; no difference
      [(equal? x y) x]

      ; bool
      [(and (boolean? x) (boolean? y)) (if x '% '(not %))]

      ; lists of the same length -- IMPLEMENT
      [(and (list? x) (list? y) (= (length x) (length y))) (list-compare x y)]

      ; different otherise
      [else `(if % ,x ,y)])))

; element-wise compare of lists (which are either quotes, lambdas, or if statements)
(define (list-compare x y)
  (let (
        [car-x (car x)]
        [car-y (car y)]
        [lambda? (lambda (x) (member x '(lambda λ)))]
        [quote?  (lambda (x) (equal? x 'quote))]
        [if?  (lambda (x) (equal? x 'if))]
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
  (if (equal? x `()) `() (cons (expr-compare (car x) (car y)) (element-compare (cdr x) (cdr y)))))

(define (lambda-compare x y)
  (let (
        [decl (if (and (equal? (car x) 'lambda) (equal? (car y) 'lambda)) 'lambda 'λ)]
        [x-params (cadr x)]
        [y-params (cadr y)]
        [x-body (caddr x)]
        [y-body (caddr y)]
        )
    
    ; replace identifiers with proper format -- IMPLEMENT
    
    (list decl (expr-compare x-params y-params) (expr-compare x-body y-body)))
  )
  