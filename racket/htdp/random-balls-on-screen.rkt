;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname random-balls-on-screen) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "htdp") (lib "universe.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.ss" "teachpack" "htdp") (lib "universe.ss" "teachpack" "2htdp")))))
; Constants

(define SCENE_WIDTH 600)
(define SCENE_HEIGHT 500)
(define EMPTY_SCENE (empty-scene SCENE_WIDTH SCENE_HEIGHT))


(define-struct ball (x y radius vx vy color mode))
; Ball is a struct with following properties:
;- x: Number. Interp. The x coordinate of the ball
;- y: Number. Interp. The y coordinate of the ball
;- radius: Number. Interp. The radius of the ball
;- vx: Number. Interp. The velocity of the ball in the x axes.
;- vy: Number. Interp. The velocity of the ball in the y axes.
;- color: String. Interp. The color of the ball
;- mode: Boolean. Interp. The state of the ball. True is moving, False is still.

; List-of-Balls is one of;
; - empty
; - (cons Ball List-of-Balls)
; Interp. a List-of-Balls represents a list of balls structure.

; a BallHit is one of;
; - "up"
; - "down"
; - "right"
; - "left"
; 
; It represents where the ball in the scene hit

; a SpeedState is one of;
; - "up"
; - "down"
;
; It represents that whether the speed of the ball will be increased or decreased


;(define (f List-Of-Balls)
;  (cond
;    [(empty? List-Of-Balls) ...]
;    [else
;     ... (first List-Of-Balls)
;     ... (f (rest List-Of-Balls))]))

; generate-random-ball-instance: Number Number -> Ball
; Purpose: Generates a ball instance with random color, radius, and speed. x and y
; coordinates are got from mouse position.
; 
; Example:
; - There is no example. Since it is random, we cannot give an example or test it.
 
; (define (generate-random-ball-instance x y) ...x ...y)

(define (generate-random-ball-instance x y)
  (make-ball x y
             (random 20)
             (random 20)
             (random 20)
             (make-color (random 255) (random 255) (random 255))
             #t))

; draw-ball: Ball -> Image
; Purpose: Gets the ball instance and returns an image containing a ball.
;
; Example:
; - If (make-ball 10 10 3 10 10 "red" #f) is given, it returns a red ball with radius 3
; - If (make-ball 10 10 6 10 10 "blue" #f) is given, it returns a blue ball with radius 6

;(define (draw-ball b)
;  ...(ball-radius b)
;  ...(ball-color b))
 
(check-expect (draw-ball (make-ball 10 10 3 10 10 "red" #f)) (circle 3 "solid" "red"))
(check-expect (draw-ball (make-ball 10 10 6 10 10 "blue" #f)) (circle 6 "solid" "blue"))

(define (draw-ball b)
  (circle (ball-radius b) "solid" (ball-color b)))

; draw-expr: List-of-Ball -> Scene
; Purpose. Gets the list of bals and places them into the scene.
;
; Example:
; - Since balls are generated randomly. I cannot give an example.


 
(define (draw-expr list-of-balls)
  (cond
    [(empty? list-of-balls) EMPTY_SCENE]
    [else
     (place-image (draw-ball (first list-of-balls))
                  (ball-x (first list-of-balls))
                  (ball-y (first list-of-balls))
                  (draw-expr (rest list-of-balls)))]))

; ball-hit=?: Ball BallHit -> Boolean
; Purpose: Determines if the ball hit the ground given in BallHit.
; 
; The position of the ball is calculeted on center.
; So we take ball radius into account when calculating because the ball should not go out of the screen.
; 
; Example:
; Let screen height and weight be 100, the radius of the ball 10;
; - If the ball with y 10, x 50 is given, and BAllHit is "up", it returns true
; - If the ball with y 90, x 50 is given, and BAllHit is "down", it returns true
; - If the ball with y 50, x 90 is given, and BAllHit is "right", it returns true
; - If the ball with y 50, x 10 is given, and BAllHit is "left", it returns true
; - If not, it returns #f

(check-expect (ball-hit=? (make-ball 4 100 4 9 9 "blue" #f) "left") #t)
(check-expect (ball-hit=? (make-ball (- SCENE_WIDTH 4) 100 4 9 9 "blue" #f) "right") #t)
(check-expect (ball-hit=? (make-ball 100 4 4 9 9 "blue" #f) "up") #t)
(check-expect (ball-hit=? (make-ball 100 (- SCENE_HEIGHT 4) 4 9 9 "blue" #f) "down") #t)
(check-expect (ball-hit=? (make-ball 100 (- SCENE_HEIGHT 4) 4 9 9 "blue" #f) "left") #f)
(check-expect (ball-hit=? (make-ball 50 50 4 9 9 "blue" #f) "down") #f)

(define (ball-hit=? b state)
  (cond
    [(and (<= (ball-y b) (ball-radius b)) (string=? state "up")) #t]
    [(and (>= (ball-y b) (- SCENE_HEIGHT (ball-radius b))) (string=? state "down")) #t]
    [(and (<= (ball-x b) (ball-radius b)) (string=? state "left")) #t]
    [(and (>= (ball-x b) (- SCENE_WIDTH (ball-radius b))) (string=? state "right")) #t]
    [else #f]))

; mouse-expr: List-of-Balls Number Number MouseEvent -> List-of-Balls
; Purpose: Creates a new random Ball instance and adds it to List-of-Balls. The ball's x and y 
; coordinates are got from mouse's position.
; 
; Example:
; - If mouse is clicked on 100,50, it will create a ball instance with x/y coordinates 100,50.
; Since it will be random, we cannot give another example, nor we can test it.

(define (mouse-expr b x y me)
  (cond
    [(mouse=? me "button-up") (cons (generate-random-ball-instance x y) b)]
    [else b]))

; change-ball-pos: Ball -> Ball
; Purpose: Controls the ball as to whether it reached to the end, and changes the 
; direction of the ball.
; 
; Example:
;  - If the ball is going up and hit to the upper edge, it changes vy to go down
;  - If the ball is going down and hit the lower edge, it changes vy to go up
;  - If the ball is going rigt and hit the right edge, it changes vx to go left
;  - If the ball is going left and hit the left edge, it changes vx to go right

 
;(define (change-ball-pos b)
;  (cond
;    [(ball-hit=? b "up") ...b]
;    [(ball-hit=? b "down") ...b]
;    [(ball-hit=? b "right") ...b]
;    [(ball-hit=? b "left") ...b]
;    [else ...b]))

(check-expect (change-ball-pos (make-ball 5 100 5 -9 9 "blue" #f)) ; hit left
              (make-ball 14 100 5 9 9 "blue" #f))

(check-expect (change-ball-pos (make-ball (- SCENE_WIDTH 5) 100 5 9 9 "blue" #f)) ; hit right
              (make-ball (- SCENE_WIDTH 5 9) 100 5 -9 9 "blue" #f))
             
(check-expect (change-ball-pos (make-ball 100 5 5 9 -9 "blue" #f)) ; hit up
              (make-ball 100 14 5 9 9 "blue" #f))

(check-expect (change-ball-pos (make-ball 100 (- SCENE_HEIGHT 5) 5 9 9 "blue" #f)) ; hit down
              (make-ball 100 (- SCENE_HEIGHT 5 9) 5 9 -9 "blue" #f))

(check-expect (change-ball-pos (make-ball 100 100 5 10 10 "blue" #f))
              (make-ball 110 110 5 10 10 "blue" #f))

(define (change-ball-pos b)
  (cond
    [(ball-hit=? b "up") (make-ball (ball-x b)
                                    (+ (* -1 (ball-vy b)) (ball-y b))
                                    (ball-radius b)
                                    (ball-vx b)
                                    (* -1 (ball-vy b))
                                    (ball-color b)
                                    (ball-mode b))]


    [(ball-hit=? b "down") (make-ball (ball-x b)
                                    (+ (* -1 (ball-vy b)) (ball-y b))
                                    (ball-radius b)
                                    (ball-vx b)
                                    (* -1 (ball-vy b))
                                    (ball-color b)
                                    (ball-mode b))]
     

    [(ball-hit=? b "right") (make-ball (+ (* -1 (ball-vx b)) (ball-x b))
                                    (ball-y b)
                                    (ball-radius b)
                                    (* -1 (ball-vx b))
                                    (ball-vy b)
                                    (ball-color b)
                                    (ball-mode b))]
     
    [(ball-hit=? b "left") (make-ball (+ (* -1 (ball-vx b)) (ball-x b))
                                    (ball-y b)
                                    (ball-radius b)
                                    (* -1 (ball-vx b))
                                    (ball-vy b)
                                    (ball-color b)
                                    (ball-mode b))]
     
    [else (make-ball (+ (ball-vx b) (ball-x b))
                     (+ (ball-vy b) (ball-y b))
                     (ball-radius b)
                     (ball-vx b)
                     (ball-vy b)
                     (ball-color b)
                     (ball-mode b))]))

; tick-expr: List-of-Balls -> List-of-Balls
; Purpose: Iterates through the List-of-Balls, changes their position and re-constructs the List-of-Balls.


(define (tick-expr list-of-balls)
  (cond
    [(empty? list-of-balls) empty]
    [else
     (cons (change-ball-pos (first list-of-balls)) (tick-expr (rest list-of-balls)))]))
       

(define (init i)
  (big-bang i
            (on-tick tick-expr)
            (to-draw draw-expr)
            (on-mouse mouse-expr)))

(init empty)