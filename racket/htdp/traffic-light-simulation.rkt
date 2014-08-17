;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname traffic) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "htdp") (lib "universe.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "image.ss" "teachpack" "htdp") (lib "universe.ss" "teachpack" "2htdp")))))
; A TrafficLight shows one of three colors:
; – "red"
; – "green"
; – "yellow"
; interp. each element of TrafficLight represents which colored
; bulb is currently turned on

; Constants
(define SCENE_WIDTH 100)
(define SCENE_HEIGHT 50)
(define SCENE (empty-scene SCENE_WIDTH SCENE_HEIGHT))

(define BULB_X 20)
(define BULB_Y (/ SCENE_HEIGHT 2))

(define BULB_SPACE 5) ; the space between bulbs
(define BULB_RAD (* BULB_SPACE 2)) ; a bulb's radius

; In how many seconds the state of the bulb changes.
(define BULB_CHANGE_INTERVAL 2)

; defines two bulbs for each TrafficLight. The one will be off,
; which is outlined, the other one is on which is solid
(define BULB_RED_ON (circle BULB_RAD "solid" "red"))
(define BULB_RED_OFF (circle BULB_RAD "outline" "red"))
(define BULB_YELLOW_ON (circle BULB_RAD "solid" "yellow"))
(define BULB_YELLOW_OFF (circle BULB_RAD "outline" "yellow"))
(define BULB_GREEN_ON (circle BULB_RAD "solid" "green"))
(define BULB_GREEN_OFF (circle BULB_RAD "outline" "green"))


; traffic-light-next: TrafficLight -> TrafficLight
; purpose: given state "state", determine the next state of the traffic light
; If it cannot find the next state, it will start with "red"
; (define (traffic-light-next state) TrafficLight)
(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "green") "yellow")
(check-expect (traffic-light-next "yellow") "red")
(check-expect (traffic-light-next " ") "red")

(define (traffic-light-next state)
  (cond
    [(string=? "red" state) "green"]
    [(string=? "green" state) "yellow"]
    [(string=? "yellow" state) "red"]
    [else "red"]))


; bulb: TrafficLight TrafficLight -> Image
; purpose: render the c colored bulb of the traffic light when "on" is the current state
; (define (bulb c on) Image)
(check-expect (bulb "red" "red") BULB_RED_ON)
(check-expect (bulb "red" "yellow") BULB_RED_OFF)
(check-expect (bulb "green" "red") BULB_GREEN_OFF)
(check-expect (bulb "green" "green") BULB_GREEN_ON)

(define (bulb c on)
  (if (string=? on c) (circle BULB_RAD "solid" c) (circle BULB_RAD "outline" c)))

; traffic-render: TrafficLight -> Image
; place each lights on the scene while turns the light on defined in "state"
; (define (traffic-render state) Image)
(check-expect (traffic-render "red")
              (place-image
               BULB_RED_ON BULB_X BULB_Y
               (place-image BULB_YELLOW_OFF (+ BULB_X BULB_SPACE (* BULB_RAD 2)) BULB_Y
                            (place-image BULB_GREEN_OFF (+ BULB_X (* BULB_SPACE 2) (* BULB_RAD 4)) BULB_Y
                                         SCENE
                                         ))))
(check-expect (traffic-render "yellow")
              (place-image
               BULB_RED_OFF BULB_X BULB_Y
               (place-image BULB_YELLOW_ON (+ BULB_X BULB_SPACE (* BULB_RAD 2)) BULB_Y
                            (place-image BULB_GREEN_OFF (+ BULB_X (* BULB_SPACE 2) (* BULB_RAD 4)) BULB_Y
                                         SCENE
                                         ))))
(check-expect (traffic-render "green")
              (place-image
               BULB_RED_OFF BULB_X BULB_Y
               (place-image BULB_YELLOW_OFF (+ BULB_X BULB_SPACE (* BULB_RAD 2)) BULB_Y
                            (place-image BULB_GREEN_ON (+ BULB_X (* BULB_SPACE 2) (* BULB_RAD 4)) BULB_Y
                                         SCENE
                                         ))))                
(check-expect (traffic-render " ")
              (place-image
               BULB_RED_OFF BULB_X BULB_Y
               (place-image BULB_YELLOW_OFF (+ BULB_X BULB_SPACE (* BULB_RAD 2)) BULB_Y
                            (place-image BULB_GREEN_OFF (+ BULB_X (* BULB_SPACE 2) (* BULB_RAD 4)) BULB_Y
                                         SCENE
                                         ))))

(define (traffic-render state)
  (place-image 
   (bulb "red" state) BULB_X BULB_Y
   (place-image (bulb "yellow" state) (+ BULB_X BULB_SPACE (* BULB_RAD 2)) BULB_Y ; this is a bit complicated. I will simplfy this.
   (place-image (bulb "green" state) (+ BULB_X (* BULB_SPACE 2) (* BULB_RAD 4)) BULB_Y
   SCENE
  ))))

(define (traffic-light-simulation initial-state)
  (big-bang initial-state
            (on-tick traffic-light-next BULB_CHANGE_INTERVAL)
            (to-draw traffic-render))
  )

(traffic-light-simulation "red")