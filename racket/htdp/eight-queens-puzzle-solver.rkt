#lang racket

;=====
; Eren Turkay, March 2010
;=====

(require htdp/testing)

;; BoardRow is a vector containing:
;; - 'q
;; - #t
;; - #f
;;
;; 'q represents that there is a queen placed.
;; #t represents that it is available to place queens
;; #f represents that the area is thretened by a queen.


;; Board is a vector of BoardRow


;; build-null-board: Number -> Board
;; 
;; Creates a null board n x n with every field is available (#t)
;; 
;; Example:
;; 1 -> (vector (vector #t))
;; 2 -> (vector (vector #t #t) (vector #t #t))
;; 3 -> (vector (vector #t #t #t) (vector #t #t #t) (vector #t #t #t))

(check-expect (build-null-board 1) (vector (vector #t)))
(check-expect (build-null-board 2) (vector (vector #t #t) (vector #t #t)))
(check-expect (build-null-board 3) (vector (vector #t #t #t) (vector #t #t #t) (vector #t #t #t)))

;(define (build-null-board n)
;  (local
;    (
;     (define (inner iterator acc)
;       (cond
;         ((= iterator 0) ...)
;         (else
;          (inner (... iterator) (vector-append acc ...))
;          )))
;     )
;    (inner n #())
;    )
;  )

(define (build-null-board n)
  (local
    (
     (define (inner iterator acc)
       (cond
         ((= iterator 0) acc)
         (else
          (inner (sub1 iterator) (vector-append acc (vector (build-vector n
                                                                          (lambda (x) true)))))
          )))
     )
     (inner n #())
     )
  )

;; get-threatened-positions: Number Number Number -> (listof (listof Number)
;; 
;; Returns a list of pairs which are to be marked as #f. 
;;  
;; Example:
;; 3 0 0 -> '((0 1) (0 2) (1 0) (2 0) (1 1) (2 2))
;; 4 0 0 -> '((0 1) (0 2) (0 3) (1 0) (2 0) (3 0) (1 1) (2 2) (3 3))
;; 3 1 1 -> '((1 0) (1 2) (0 1) (2 1) (2 2) (0 0) (0 2) (2 0))
;; 4 1 1 -> '((1 0) (1 2) (1 3) (0 1) (2 1) (3 1) (2 2) (3 3) (0 0) (0 2) (2 0))

;; I use it inside foldr to count how many times I iterated, and the data in the
;; accumulator.
(define-struct iterator (count data))

(check-expect (get-threatened-positions 3 0 0) '((0 1) (0 2) (1 0) (2 0) (1 1) (2 2)))
(check-expect (get-threatened-positions 4 0 0) '((0 1) (0 2) (0 3) (1 0) (2 0) (3 0) (1 1) (2 2) (3 3)))
(check-expect (get-threatened-positions 3 1 1) '((1 0) (1 2) (0 1) (2 1) (2 2) (0 0) (0 2) (2 0)))

(check-expect (get-threatened-positions 4 1 1) '((1 0) (1 2) (1 3) (0 1) (2 1) (3 1) (2 2) (3 3) (0 0) (0 2) (2 0)))


(define (get-threatened-positions board-count i j)
  (local
    [
     ; I just iterate over the row. If the iterator count is the same as what I am
     ; looking for, I just omit it.
     ;
     ; I know these lines are hairy but I could not find a better way to do it
    (define (get-horizontal)
      (foldl (lambda (item acc)
             (if (= (iterator-count acc) j)
                 (make-iterator (add1 (iterator-count acc)) (iterator-data acc))
                 (make-iterator (add1 (iterator-count acc))
                                (append (iterator-data acc)
                                        (list (list i (iterator-count acc)))))))
             (make-iterator 0 '())
             (build-list board-count (lambda (x) x))
             ))
    
    (define (get-vertical)
      (foldl (lambda (item acc)
               (if (= (iterator-count acc) i)
                   (make-iterator (add1 (iterator-count acc)) (iterator-data acc))
                   (make-iterator (add1 (iterator-count acc))
                                  (append (iterator-data acc)
                                          (list (list (iterator-count acc) j))))))
             (make-iterator 0 '())
             (build-list board-count (lambda (x) x))
             ))
    
    (define (get-left-diagonal type diagonal-i diagonal-j acc)
      (cond
        ((<= diagonal-i -1) acc)
        ((>= diagonal-i board-count) acc)
        ((<= diagonal-j -1) acc)
        ((>= diagonal-j board-count) acc)
        (else
         (if (equal? type "above")
             (get-left-diagonal type (add1 diagonal-i)
                           (add1 diagonal-j)
                           (append acc (list (list diagonal-i diagonal-j))))
             (get-left-diagonal type (sub1 diagonal-i)
                           (sub1 diagonal-j)
                           (append acc (list (list diagonal-i diagonal-j))))
             ))))
    
       (define (get-right-diagonal type diagonal-i diagonal-j acc)
      (cond
        ((<= diagonal-i -1) acc)
        ((>= diagonal-i board-count) acc)
        ((<= diagonal-j -1) acc)
        ((>= diagonal-j board-count) acc)
        (else
         (if (equal? type "above")
             (get-right-diagonal type (sub1 diagonal-i)
                           (add1 diagonal-j)
                           (append acc (list (list diagonal-i diagonal-j))))
             (get-right-diagonal type (add1 diagonal-i)
                           (sub1 diagonal-j)
                           (append acc (list (list diagonal-i diagonal-j))))
             ))))
    
       ]
    
    ; append all the stuff to each other.
    (append 
     (iterator-data (get-horizontal))
     (iterator-data (get-vertical))
     
     (get-left-diagonal "above" (add1 i) (add1 j) empty)
     (get-left-diagonal "below" (sub1 i) (sub1 j) empty)
     
     (get-right-diagonal "above" (sub1 i) (add1 j) empty)
     (get-right-diagonal "below" (add1 i) (sub1 j) empty))
    ))


;; place-queen: Board Number Number -> Board
;; 
;; Places a queen to indices i,j and it places #f to its horizontal,vertical and
;; diagonal line.
;; 
;; Example:
;; (build-null-board 3) 0 0 -> #(
;;                               #('q #f #f)
;;                               #(#f #f #t)
;;                               #(#f #t #f))
;; 
;; (build-null-board 3) 1 1 -> #(
;;                               #(#f #f #f)
;;                               #(#f 'q #f)
;;                               #(#f #f #f))
;;  
;; #( #(#t #f #f)
;;    #(#f #f 'q) 
;;    #(#t #t #f))
;; 
;; 0
;; 0
;; 
;; -->
;; 
;; #( #('q #f #f)
;;    #(#f #f 'q)
;;    #(#f #t #f))


(check-expect (place-queen (build-null-board 3) 0 0)
              '#(#(q #f #f) #(#f #f #t) #(#f #t #f)))

(check-expect (place-queen (build-null-board 3) 1 1)
              '#(#(#f #f #f) #(#f q #f) #(#f #f #f)))

(check-expect (place-queen (build-null-board 3) 1 2)
             '#(#(#t #f #f)
                #(#f #f q)
                #(#t #f #f)))

(check-expect (place-queen (place-queen (build-null-board 3) 1 2) 0 0)
              '#(#(q #f #f) #(#f #f q) #(#f #f #f)))
              

(define (place-queen board i j)
  (let
      ; copy the board that is got from function.
      ; I will change it via (vector-set!) and return it
      [(output (vector-map vector-copy board))
       ; item we are referring to. If the item is false, we know that
       ; we cannot place the queen there. Therefore, we should return false
       (item (vector-ref (vector-ref board i) j))
       ]
    
    (if (equal? item #f)
        #f
        (begin
          
          ; set the queen
          (vector-set! (vector-ref output i) j 'q)
          ; set the positions that it is threatening
          (for-each (lambda (item)
                      ; (car item) is column
                      ; (cadr item) is row
                      (vector-set! (vector-ref output (car item)) (cadr item) #f))
                    (get-threatened-positions (vector-length board) i j))
          ; I modified the output. Now return it.
          output))))
 
;; get-available-positions: Board -> (listof Number) or empty
;; 
;; Returns available positions in the board, which are marked with #t. If there is
;; nothing available, it returns empty
;; 
;; Example:
;; (build-null-board 2) -> '((0 0) (0 1) (1 0) (1 1))
;; '#(#(q #f #f) #(#f #f #f) #(#f #f #f))) -> empty

(check-expect (get-available-positions (build-null-board 2))
              '((0 0) (0 1) (1 0) (1 1)))

(check-expect (get-available-positions '#(#(q #f #f) #(#f #f #f) #(#f #f #f)))
              empty)

(check-expect (get-available-positions '#(#('q #f #f #f)
                                          #(#f #f #f #f)
                                          #(#t #t #f #f)))
              '((2 0) (2 1)))

(define (get-available-positions board)
  (local
    [
     (define (find-in-row column-number row-number row acc)
       (cond
         ((empty? row) acc)
         (else
          (if (equal? (first row) #t)
              (find-in-row column-number (add1 row-number) (rest row) (append acc (list (list column-number row-number))))
              (find-in-row column-number (add1 row-number) (rest row) acc))
          )))
     
     (define (find-in-columns column-number1 column acc)
       (cond
         ((empty? column) acc)
         (else
          (find-in-columns (add1 column-number1)
                           (rest column)
                           (append acc (find-in-row column-number1 0 (vector->list (first column)) empty)))
          )))
     
     ]
    (find-in-columns 0 (vector->list board) empty)
    ))

;; generate-possible-boards: Board -> (listof Board)
;;
;; Places queens to the available positions and returns the board seperately.
;; 
;; Example:
;;
;; (build-null-board 2) -->
;; '(#(#(q #f) #(#f #f))
;;  #(#(#f q) #(#f #f))
;;  #(#(#f #f) #(q #f))
;;  #(#(#f #f) #(#f q)))
;; 
;; '#(#(#t #f) #(#f #t)) -->
;; '(#(#(q #f) #(#f #f)) #(#(#f #f) #(#f q)))

(check-expect (generate-possible-boards (build-null-board 2))
              '(#(#(q #f) #(#f #f))
                #(#(#f q) #(#f #f))
                #(#(#f #f) #(q #f))
                #(#(#f #f) #(#f q))))

(check-expect (generate-possible-boards '#(#(#t #f) #(#f #t)))
              '(#(#(q #f) #(#f #f)) #(#(#f #f) #(#f q))))


;(define (generate-possible-boards board)
;  (local
;    (
;     (define (inner board possible-routes accc)
;       (cond
;         ((empty? possible-routes) ...)
;         (else
;          ...board
;          ...(first possible-routes)
;          (inner board (rest possible-routes) (append acc ...)))))
;     )
;    (inner board (get-available-positions board) empty)
;    )
;  )

(define (generate-possible-boards board)
  (local
    (
     (define (inner board possible-routes acc)
     (cond
       ((empty? possible-routes) acc)
       (else
        (inner board (rest possible-routes)
               (append acc (list (place-queen board
                                             (first (first possible-routes))
                                             (cadr (first possible-routes)))))
               ))))
     )
    (inner board (get-available-positions board) empty)))


;; check-queen: Board Number -> Board/false
;; 
;; Controls if we have placed all the queens. If not, it looks for
;; available positions. If it cannot find it, returns false, else it looks for
;; boards possible other combinations and calls check-queens.
;;
;; Example:
;; 
;; (build-null-board 2) 0 -> (build-null-board 2)
;; '#(#(#f #f) #(#f #f)) 1 -> #f

(check-expect (check-queen (build-null-board 2) 0)
              (build-null-board 2))

(check-expect (check-queen '#(#(#f #f) #(#f #f)) 1) #f)

; let's try to place 4 queens in 4x4 board.
(check-expect (check-queen (build-null-board 4) 4)
              '#(#(#f q #f #f) #(#f #f #f q) #(q #f #f #f) #(#f #f q #f)))

(check-expect (check-queen (build-null-board 3) 3) #f)
(check-expect (check-queen (build-null-board 2) 1)
              '#(#(q #f) #(#f #f)))
(check-expect (check-queen (build-null-board 2) 2) #f)

(define (check-queen board queen-to-place)
  (cond
    ((= queen-to-place 0) board)
    (else
     ; if we cannot find available positions. We cannot go further.
     (if (empty? (get-available-positions board))
         #f
         (check-queens (generate-possible-boards board)
                       queen-to-place)
         ))))

(define (check-queens listof-boards queen-to-place)
  (cond
    ((empty? listof-boards) #f)
    (else
     (let
         ((answer (check-queen (first listof-boards) (sub1 queen-to-place))))
       (if (vector? answer)
           answer
           (check-queens (rest listof-boards) queen-to-place))))))


(generate-report)