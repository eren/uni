#lang plai

;Copyright (C) 2014  Eren Türkay <turkay.eren@gmail.com>
;
;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.
;
;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;
;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;02110-1301, USA.

; Istanbul Bilgi University
; Department of Computer Science
; 
; COMP 314 Assignment #3
; 2014-04-07

;<FWAE> ::= <num>
;       | (<FWAE> + <FWAE>)
;       | (with (<id> <FWAE>) <FWAE>)
;       | <id>
;       | (fun (<id>) <FWAE>)
;       | (FWAE FWAE)

(define-type FWAE 
  [ae-num (n number?)]
  [ae-id (s symbol?)]
  [ae-add (lhs FWAE?)
       (rhs FWAE?)] 
  [ae-with (name ae-id?)
           (named-expr FWAE?)
           (body FWAE?)]
  [ae-fun (param symbol?) (body FWAE?)]
  [ae-app (fun-expr FWAE?) (arg-expr FWAE?)]
  )

(define-type DefrdSub
  [mtSub]
  [aSub (name symbol?) (value FWAE-Value?) (ds DefrdSub?)])

(define-type FWAE-Value 
  [numV (n number?)] 
  [closureV (param symbol?)
            (body FWAE?)
            (ds DefrdSub?)])

; lookup: symbol DefrdSub -> FWAE-Value
(define (lookup name ds)
  (type-case DefrdSub ds
    [mtSub () (error 'lookup "no binding for identifier ~a" name)]
    [aSub (bound-name bound-value rest-ds)
          (if (symbol=? bound-name name)
              bound-value
              (lookup name rest-ds))]))

;; parse: S-exp --> FWAE
;;
;; Converts S-expressions into FWAEs. We use infix notation just
;; for fun. Parsing infix can look a little bit tricky, sorry for
;; this.
(define (parse sexp) 
  (cond
    [(number? sexp) (ae-num sexp)] 
    [(symbol? sexp) (ae-id sexp)]
    [(list? sexp)
     (case (second sexp)
       [(+) (ae-add (parse (first sexp))
                 (parse (third sexp)))] 
       ; The above code looked for infix characters and parsed it.
       ; This part looks for symbols in prefix.
       [else
        (cond
          [(equal? (first sexp) 'with)
           ; Convert {with {var named} body} to {{fun {var} body} named}
           ;
           ; This should normally be done with preprocessor on
           ; the code before parsing but the book does not give example.
           ; Instead convert this with statement while constructing AST.
           ;
           ; I can call this a neat hack :)
           ;
           ; See: Exercise 6.3.1 Implement a pre-processor that performs
           ; this translation. Page 45 of PLAI first edition.
           (ae-app
            (ae-fun (first (second sexp)) (parse (third sexp)))
            (parse (second (second sexp))))]
            ;(ae-with (ae-id (first (second sexp)))
            ;         (parse (second (second sexp)))
            ;         (parse (third sexp)))]
          
          [(equal? (first sexp) 'fun)
           (ae-fun (first (second sexp)) (parse (third sexp)))]
          
          ; Look for function application. This application could be done with
          ; anonymous function definition ((fun (x) ...) VALUE) or with symbols:
          ; (x 1).
          [(or (symbol? (first sexp)) (list? (first sexp)))
           (ae-app (parse (first sexp)) (parse (second sexp)))]
          
          [else
            (error 'parse "syntax error. cannot parse following S-expression: ~a" sexp)]
          )
        ])]
    ))

; add-numbers: numV numV -> numV
;
; Helper function for adding numbers.
(define (add-numbers x y)
  (numV (+ (numV-n x) (numV-n y))))

;; interp : FWAE DefrdSub -> FWAE

;; evaluates FWAE expressions by reducing them to their corresponding values
;; return values are either num or fun

(define (interp expr [ds (mtSub)])
  (type-case FWAE expr
    [ae-num (n) (numV n)]
    [ae-add (l r) (add-numbers (interp l ds) (interp r ds))]
    [ae-id (v) (lookup v ds)]
    [ae-fun (bound-id bound-body) (closureV bound-id bound-body ds)]
    [ae-app (fun-expr arg-expr)
            (local ([define fun-val (interp fun-expr ds)])
              (interp (closureV-body fun-val)
                      (aSub (closureV-param fun-val)
                            (interp arg-expr ds)
                            (closureV-ds fun-val))))]
    [else
     (error 'interp "undefined")]
    ))

; basic arithmatic test.
(test (interp (parse '3)) (numV 3))
(test (interp (parse '(4 + 2))) (numV 6))
(test (interp (parse '(3 + 4))) (numV 7))
(test (interp (parse '((4 + 2) + 1))) (numV 7))

(test (interp (parse '(((25 + 5) + 2) + (((12 + 6) + 3) + 2)))) (numV 55))

; test static scopes, make sure that we do not accidentally use
; dynamic scoping.
(test (interp (parse '((with (x 5) (fun (y) (x + y))) 1))) (numV 6))
(test (interp (parse '((with (x 5) (with (x 1) (fun (y) (x + y)))) 1))) (numV 2))
(test (interp (parse '((with (x 5) (fun (y) (with (x 2) (x + y)))) 1))) (numV 3))

; apply anonymous function
(test (interp (parse '((fun (x) (x + 1)) -1))) (numV 0))

; function as a parameter to another function. The first function
; applies the function in the parameter.
(test (interp (parse
               '((fun (x) (x 1)) (fun (y) (y + 1)))))
      (numV 2))