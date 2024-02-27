#lang racket

(define expr-compare
  (lambda (x y)
    (cond

      ; no difference
      [(equal? x y) x]

      ; bool
      [(and (boolean? x) (boolean? y)) (if x '% '(not %))]

      ; lists of the same length -- IMPLEMENT
      [(and (list? x) (list? y) (= (length x) (length y))) #f]

      ; different
      [else `(if % ,x ,y)])))

