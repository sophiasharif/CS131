#lang racket

(define num-compare
  (lambda (n1 n2)
    (if (= n1 n2)
        n1
        '(if % ,n1 ,n2))))

(define expr-compare
  (lambda (x y)
    (if (and (number? x) (number? y))
        (num-compare x y)
        #f)))     
