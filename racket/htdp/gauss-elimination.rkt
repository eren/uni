;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname Eren_Turkay_gauss) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
; =======================
; Eren Türkay, March 2011
; =======================

; a Gauss is a list defined as:
; (list
;  (list Number Number Number Number)
;  (...)
;  (...)
; )
; 
; where Number is the coefficient of the variables in
; the equation and which should have at least 2 elements.
; The last number is the result of an equation.

(define GaussTest (list
                   '(2 2 3 10)
                   '(2 5 12 31)
                   '(4 1 -2 1)))

(define GaussTestResult (list
                         '(2 2 3 10)
                         '(  3 9 21)
                         '(    1 2)))

(define GaussTest1 (list
                    '(2 3 3 8)
                    '(2 3 -2 3)
                    '(4 -2 2 4)))

(define GaussTest1Result (list
                          (list  2  3  3  8)
                          (list    -8 -4 -12)
                          (list        -5 -5)))



; subtract: (listof Number) (listof Number) -> (listof Number)
; Subtracts the first from the second, item by item
;
; Example:
; '(3 4 5 6) '(3 4 5 6) -> '(0 0 0 0)
; '(3 6 9 12) '(2 4 6 8) -> '(-1 -2 -3 -4)
; '(2 2 3 10) '(2 5 12 31) -> '(0 3 9 21)
 

(check-expect (subtract '(3 4 5 6) '(3 4 5 6)) '(0 0 0 0))
(check-expect (subtract '(3 6 9 12) '(2 4 6 8)) '(-1 -2 -3 -4))
(check-expect (subtract '(2 2 3 10) '(2 5 12 31)) '(0 3 9 21))


;(define (subtract first-list second-list)
;  (cond
;    ((empty? ...) ...)
;    (else
;     ..first-list
;     ..second-list
;     (subtract ... ...))))

(define (subtract first-list second-list)
  (cond
    ((empty? first-list) empty)
    (else
     (cons (- (first second-list) (first first-list))
           (subtract (rest first-list) (rest second-list))))))

; subtract-until-zero: (listof Number) (listof Number) -> (listof Number)
; Subtracts the first from the second, item by item, as many times as necessary
; to obtain 0 in the first position. It also controls if subtracting results in
; the decrement in the second list. If -5 is substracted from 5, it results in
; bigger number, which is 10. When encountered, it multiples the whole list by -1
; so that the number gets decremented. In this way, equation is preserved as well, 
; because all the coefficients are multipled.
;
; Additionally, it drops the prefixing zero so that it helps to triangulate the list
;
; Example:
; '(3 4 5 6) '(3 4 5 6') -> '(0 0 0)
; '(5 10 10 10) (15 10 10 10) -> '(-20 -20 -20)
; '(150 234 1 5) (150 234 1 5) -> '(0 0 0)
; '(-5 -1 -1 -1) (5 -1 -1 -1) -> '(-2 -2 -2)

(check-expect (subtract-until-zero '(3 4 5 6) '(3 4 5 6)) '(0 0 0))
(check-expect (subtract-until-zero '(5 10 10 10) '(15 10 10 10)) '(-20 -20 -20))
(check-expect (subtract-until-zero '(150 234 1 5) '(150 234 1 5)) '(0 0 0))
(check-expect (subtract-until-zero '(-5 -1 -1 -1) '(5 -1 -1 -1)) '(-2 -2 -2))
(check-expect (subtract-until-zero '(3 9 21) '(-3 -8 -19)) '(1 2))


;(define (subtract-until-zero first-list second-list)
;  (cond
;    ((empty? ...) ...)
;    (else
;     ..first-list
;     ..second-list
;     (subtract ... ...))))


(define (subtract-until-zero first-list second-list)
  (let ([a (first first-list)]
        [b (first second-list)])
    
    (cond
      ; control whether subtracting first yields smaller number. If not,
      ; multiply the first list by -1 and call the function again.
      [(or (and (positive? b) (> (- b a) b))
           (and (negative? b) (< (- b a) b)))
       (subtract-until-zero (map (lambda (x) (* -1 x)) first-list) second-list)]
      
      ; eliminate the prefixing zero so that it helps to triangulate easily.
      [(= (first second-list) 0) (rest second-list)]
      
      [else
       (subtract-until-zero first-list (subtract first-list second-list))])
    ))

; triangulate: Gauss -> Gauss
; Consumes a rectangular representation of a system of equations and produces
; a triangular version according the Gaussian algorithm.
; 
; Example:
; (list             (list  
;  '(2 2 3 10)         '(2 2 3 10) 
;  '(2 5 12 31) ->     '(  3 9 21)
;  '(4 1 -2 1))        '(    1  2))

(check-expect (triangulate GaussTest) GaussTestResult)
(check-expect (triangulate GaussTest1) GaussTest1Result)

;(define (triangulate gauss-list)
;  (cond
;    ((empty? ...) ...)
;    (else
;     ..gauss
;     (gauss-list gauss))))

(define (triangulate gauss)
  (cond
    ((= (length (first gauss)) 2) gauss)
    ((= (first (first gauss)) 0)       
     ; the first item in the first list should not be zero
     ; switch them and call the function again.
     (triangulate (append (remove (first gauss) gauss) (list (first gauss)))))
    (else         
     (cons (first gauss) (triangulate (map (lambda (x)
                                             (subtract-until-zero (first gauss) x))
                                           (rest gauss))))
     )))

; evaluate: (listof Number) (listof Number) -> (listof Number)
; Evaluates the rest of the left-hand side of an equation and 
; subtracts the sum from the right-hand side. 
; 
; Example:
; '(9 21) '(2) -> 3
; '(1 4) '(4) -> 0
; '(10 5 40) '(1 2) -> 20
; '(2 4 6 30) '(1 2 3) -> 2

;(define (evaluate equation solver) ...equation ..solver)

(check-expect (evaluate '(9 21) '(2)) 3)
(check-expect (evaluate '(1 4) '(4)) 0)
(check-expect (evaluate '(10 5 40) '(1 2)) 20)
(check-expect (evaluate '(2 4 6 30) '(1 2 3)) 2)
(check-expect (evaluate '(2 2 3 10) '(2 1)) 4)

(define (evaluate equation solver)
  (local
    ; multiply each value in solver in the equation, and add them.
    [(define (evaluate-add eq solv)
      (cond
        ((empty? solv) 0)
        (else
         (+ (* (first eq) (first solv))
            (evaluate-add (rest eq) (rest solv))))))]
    ; substract the result from left-hand side
    (- (first (reverse equation)) (evaluate-add equation solver))))

; divide: (listof Number) -> (listof Number)
; Divides the last element with the first element of the list.
; It is used to find a solution of the equation.
; 
; Example:
; '(2 6) -> '(3)
; '(1 1) -> '(1)
; '(5 0) -> '(0)
 
; (define (divide a-list) ...alist)

(check-expect (divide '(2 6)) '(3))
(check-expect (divide '(1 1)) '(1))
(check-expect (divide '(1 5)) '(5))

(define (divide a-list)
  (list (/ (first (rest a-list)) (first a-list))))


; solve: Gauss -> (listof numbers)
; Solves the gauss triangle, appends the solutions into the list and returns.
; 
; Example:
; 
; GaussTest -> '(1 1 2)
; GaussTest1 -> '(1 1 1)

(check-expect (solve GaussTest) '(1 1 2))
(check-expect (solve GaussTest1) '(1 1 1))

(define (solve gauss)
  (foldr (lambda (equation solver-set)
           (cond
             ((empty? solver-set) (append (divide equation) solver-set))
             (else
              (append (list (/ (evaluate (rest equation) solver-set) (first equation)))
                      solver-set 
                      ))))
         empty
         (triangulate gauss)))

           