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
; COMP 314 Assignment #1
; 2014-03-04

;BNF For Arithmetic expression with infix notation.
;AE stands for Arithmetic Expression
;
;<AE> ::= <num>
;       | (<AE> + <AE>)
;       | (<AE> - <AE>)
;       | (<AE> * <AE>)
;       | (<AE> / <AE>)
;       | (<AE> ^ <AE>)
;       | (with (<id> <AE>) <AE>)
;       | <id>
;       | (fun (<id>) <AE>)
;       | (AE AE)


; Type definition for our AE. It represents the BNF defined.
;
; These types are used in parse function, which acceps S-expressions
; and returns the types we defined here.
;
; The data types are prefixed with ae- so that they are not confused
; with the builtin racket functions.
(define-type AE 
  [ae-num (n number?)]
  [ae-id (s symbol?)]
  [ae-add (lhs AE?)
       (rhs AE?)] 
  [ae-sub (lhs AE?)
       (rhs AE?)]
  [ae-mul (lhs AE?)
       (rhs AE?)]
  [ae-div (lhs AE?)
       (rhs AE?)]
  [ae-expt (lhs AE?)
       (rhs AE?)]
  [ae-with (name ae-id?)
           (named-expr AE?)
           (body AE?)]
  [ae-app (fun-name symbol?) (arg AE?)]
  )

; Data structure to hold the definition of functions
(define-type FunDef
  [fundef (fun-name symbol?)
          (arg-name symbol?)
          (body AE?)])

; Deferred substitution data structure. The fields are;
;  - mtSub: empty substutition.
;  - aSub: a substitutition that holds name, value, and the
;    a reference to the rest of the repository

(define-type DefrdSub 
  [mtSub]
  [aSub (name symbol?) (value number?) (ds DefrdSub?)])

;; parse: S-exp --> AE
;;
;; Converts S-expressions into AEs
(define (parse sexp) 
  (cond
    [(number? sexp) (ae-num sexp)] 
    [(symbol? sexp) (ae-id sexp)]
    [(list? sexp)
     (case (second sexp)
       [(+) (ae-add (parse (first sexp))
                 (parse (third sexp)))] 
       [(-) (ae-sub (parse (first sexp))
                 (parse (third sexp)))]
       [(*) (ae-mul (parse (first sexp))
                 (parse (third sexp)))]
       [(/) (ae-div (parse (first sexp))
                 (parse (third sexp)))]
       [(^) (ae-expt (parse (first sexp))
                 (parse (third sexp)))]
       ; The above code looked for infix characters and parsed it.
       ; This part parses prefix notation.
       [else
        (cond
          [(equal? (first sexp) 'with)
            (ae-with (ae-id (first (second sexp)))
                     (parse (second (second sexp)))
                     (parse (third sexp)))]
          [(symbol? (first sexp)) (ae-app (first sexp) (parse (second sexp)))]
          [else
            (error 'parse "syntax error. cannot parse following S-expression: ~a" sexp)]
          )
        ])]
    ))


;; unparse: AE --> S-exp
;;
;; Prints back the S-expression from our AE.
;; We should expect the same s-expression applied to
;; parse after we apply `unparse` again.
;;
;; See the test cases for examples.
(define (unparse an-ae)
  (type-case AE an-ae
    [ae-num (n) n]
    [ae-id (id) id]
    [ae-add (l r) (list (unparse l) '+ (unparse r))]
    [ae-sub (l r) (list (unparse l) '- (unparse r))]
    [ae-mul (l r) (list (unparse l) '* (unparse r))]
    [ae-div (l r) (list (unparse l) '/ (unparse r))]
    [ae-expt (l r) (list (unparse l) '^ (unparse r))]
    [ae-with (id named-expr body) '(with (id (unparse named-expr)
                                             (unparse body)))]
    [else
     (error 'unparse "undefined AST: ~a" an-ae)]
    ))


(test (unparse (parse '3)) 3)
(test (unparse (parse '(4 + 2))) '(4 + 2))
(test (unparse (parse '(4 / 2))) '(4 / 2))
(test (unparse (parse '(4 * 2))) '(4 * 2))
(test (unparse (parse '(4 - 2))) '(4 - 2))
(test (unparse (parse '(4 ^ 2))) '(4 ^ 2))
(test (unparse (parse '(3 + 4))) '(3 + 4))

(test (unparse (parse '((4 + 2) + 1))) '((4 + 2) + 1))
(test (unparse (parse '((4 / 2) + 1))) '((4 / 2) + 1))
(test (unparse (parse '((3 - 4) - 7))) '((3 - 4) - 7))

(test (unparse (parse '(((25 / 5) ^ 2) - (((12 - 6) / 3) * 2))))
      '(((25 / 5) ^ 2) - (((12 - 6) / 3) * 2))
      )

;; unparse: AE --> S-exp
;;
;; Prints back the S-expression from our AE.
;;
;; Similar to unparse, but it outputs prefix notation.
(define (unparse-prefix an-ae)
  (type-case AE an-ae
    [ae-num (n) n]
    [ae-id (id) id]
    [ae-add (l r) (list '+ (unparse-prefix l) (unparse-prefix r))]
    [ae-sub (l r) (list '- (unparse-prefix l) (unparse-prefix r))]
    [ae-mul (l r) (list '* (unparse-prefix l) (unparse-prefix r))]
    [ae-div (l r) (list '/ (unparse-prefix l) (unparse-prefix r))]
    [ae-expt (l r) (list '^ (unparse-prefix l) (unparse-prefix r))]
    [ae-with (id named-expr body) '(with (id (unparse named-expr)
                                             (unparse body)))]
    [else
        (error 'unparse-prefix "undefined AST: ~a" an-ae)]
    ))

(test (unparse-prefix (parse '3)) 3)
(test (unparse-prefix (parse '(4 + 2))) '(+ 4 2))
(test (unparse-prefix (parse '(4 / 2))) '(/ 4 2))
(test (unparse-prefix (parse '(4 * 2))) '(* 4 2))
(test (unparse-prefix (parse '(4 - 2))) '(- 4 2))
(test (unparse-prefix (parse '(4 ^ 2))) '(^ 4 2))
(test (unparse-prefix (parse '(3 + 4))) '(+ 3 4))

(test (unparse-prefix (parse '((4 + 2) + 1))) '(+ (+ 4 2) 1))
(test (unparse-prefix (parse '((4 / 2) + 1))) '(+ (/ 4 2) 1))
(test (unparse-prefix (parse '((3 - 4) - 7))) '(- (- 3 4) 7))

;; lookup-fundef: smybol (listof fundef) -> fundef
;;
;; Look up function definition in the list and return
;; the function if it's found

(define (lookup-fundef fun-name fundefs)
  (cond
    [(empty? fundefs) (error 'lookup-fundef "function ~a not found" fun-name)]
    [(symbol=? fun-name (fundef-fun-name (first fundefs))) (first fundefs)]
    [else
     (lookup-fundef fun-name (rest fundefs))]))

; lookup: symbol DefrdSub -> number
(define (lookup name ds)
  (type-case DefrdSub ds
    [mtSub () (error 'lookup "no binding for identifier ~a" name)]
    [aSub (bound-name bound-value rest-ds)
          (if (symbol=? bound-name name)
              bound-value
              (lookup name rest-ds))]))

;; subst : AE symbol AE -> AE
;; substitutes second argument with third argument in first argument,
;; as per the rules of substitution; the resulting expression contains
;; no free instances of the second argument

(define (subst expr sub-id val)
  (type-case AE expr
    [ae-num (n) expr]
    [ae-id (id)
           (if (symbol=? id sub-id)
               val
               expr)]
    [ae-add (lhs rhs)
            (ae-add (subst lhs sub-id val)
                    (subst rhs sub-id val))]
    [ae-sub (lhs rhs)
            (ae-sub (subst lhs sub-id val)
                    (subst rhs sub-id val))]
    [ae-mul (lhs rhs)
            (ae-mul (subst lhs sub-id val)
                    (subst rhs sub-id val))]
    [ae-div (lhs rhs)
            (ae-div (subst lhs sub-id val)
                    (subst rhs sub-id val))]
    [ae-expt (lhs rhs)
            (ae-expt (subst lhs sub-id val)
                     (subst rhs sub-id val))]
    [ae-with (bound-id named-expr bound-body)
             (if (symbol=? (ae-id-s bound-id) sub-id)
                 (ae-with bound-id
                          (subst named-expr sub-id val)
                          bound-body)
                 (ae-with bound-id
                          (subst named-expr sub-id val)
                          (subst bound-body sub-id val)))]
    [ae-app (fun-name arg-expr)
            (ae-app fun-name
                    (subst arg-expr sub-id val))]
    ;[else
    ; (error 'subst "undefined AST: ~a" expr)]
))

; FIXME: Write seperate test cases. This is OK for now as we included
; a lot of tests in `calc` function call. However, it is good to
; add seperate tests for substitution.

;; calc: AE (listof fundef) DefrdSubs --> number
;;
;; Calculates AEs and returns a number. This is a basic
;; function that interprets the meaning of our AE
;;
;; After adding function definitions and applications, this function
;; can be considered an interpreter.

(define (calc an-ae [fundefs empty] [ds (mtSub)])
  (type-case AE an-ae
    [ae-num (n) n]
    [ae-add (l r) (+ (calc l fundefs ds) (calc r fundefs ds))] 
    [ae-sub (l r) (- (calc l fundefs ds) (calc r fundefs ds))]
    [ae-mul (l r) (* (calc l fundefs ds) (calc r fundefs ds))]
    [ae-div (l r) (/ (calc l fundefs ds) (calc r fundefs ds))]
    [ae-expt (l r) (expt (calc l fundefs ds) (calc r fundefs ds))]
    [ae-with (bound-id named-expr bound-body)
             (calc bound-body fundefs
                   (aSub (ae-id-s bound-id) (calc named-expr fundefs ds) ds))]
    [ae-app (fun-name arg-expr)
            ; get the function definition from fundefs
            (local ([define the-fun-def (lookup-fundef fun-name fundefs)])
              (calc (fundef-body the-fun-def)
                    fundefs
                    (aSub (fundef-arg-name the-fun-def)
                          (calc arg-expr fundefs ds)
                          (mtSub))))]
    [ae-id (s) (lookup s ds)]
    )
  )

(test (calc (parse '3)) 3)
(test (calc (parse '(4 + 2))) 6)
(test (calc (parse '(4 / 2))) 2)
(test (calc (parse '(4 * 2))) 8)
(test (calc (parse '(4 - 2))) 2)
(test (calc (parse '(4 ^ 2))) 16)
(test (calc (parse '(3 + 4))) 7)

(test (calc (parse '((4 + 2) + 1))) 7)
(test (calc (parse '((4 / 2) + 1))) 3)
(test (calc (parse '((3 - 4) - 7))) -8)

(test (calc (parse '(((25 / 5) ^ 2) - (((12 - 6) / 3) * 2)))) 21)

(test (calc (parse '5)) 5)
(test (calc (parse '(5 + 5))) 10)
(test (calc (parse '(with (x (5 + 5)) (x + x)))) 20)
(test (calc (parse '(with (x 5) (x + x)))) 10)
(test (calc (parse '(with (x (5 + 5)) (with (y (x - 3)) (y + y))))) 14)
(test (calc (parse '(with (x 5) (with (y (x - 3)) (y + y))))) 4)
(test (calc (parse '(with (x 5) (x + (with (x 3) 10))))) 15)
(test (calc (parse '(with (x 5) (x + (with (x 3) x))))) 8)
(test (calc (parse '(with (x 5) (x + (with (y 3) x))))) 10)
(test (calc (parse '(with (x 5) (with (y x) y)))) 5)
(test (calc (parse '(with (x 5) (with (x x) x)))) 5)


(test (calc (parse '(double (double 5)))
          (list (fundef 'double
                        'n
                        (ae-add (ae-id 'n) (ae-id 'n))))) 20)

(define add-one (fundef 'add-one
                        'n
                        (parse '(1 + n))))
(define ae-functions (list add-one))

(define program '(with (x (1 + 2))
                       (with (y (x + 2))
                             ((add-one x) + (add-one y)))))

(test (calc (parse program) ae-functions) 10)