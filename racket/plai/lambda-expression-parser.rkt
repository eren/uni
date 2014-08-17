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
; COMP 314 Assignment #2
; 2014-03-08



; Finding free and bound varibles is done over sets.
;
; Instead of implementing our set functions, use internal
; racket functions.
; 
(require racket/set)



;BNF for lambda expressions
;
;<LAMBDA> ::= <symbol>
;       | (λ <symbol> <LAMBDA>)
;       | (<LAMBDA> <LAMBDA>)

; Type definition for lambda expressions. There are 3 types:
; 
; - Lambda symbol
; - Lambda function definition
; - Lambda function application
;
; This represents our abstract syntax tree.
(define-type lambda-expression
  [λ-ident (i symbol?)]
  [λ-def (s symbol?)
         (body lambda-expression?)] 
  [λ-app (left lambda-expression?)
         (right lambda-expression?)]
  )

;; parse: S-exp --> lambda-expression
;;
;; Converts S-expressions into lambda-expressions.
(define (parse sexp) 
  (cond
    [(symbol? sexp) (λ-ident sexp)] 
    [(list? sexp)
     (cond
       ; Condition for λ function definition. First we expect
       ; the symbol λ, second an arbitrary symbol, third a lambda
       ; expression. The last lambda expression is recursively parsed.
       ;
       ; (λ x x)
       ; (λ x (λ y y))
       ;
       ; etc...
       [(and (equal? 'λ (first sexp))
             (symbol? (second sexp)))
        (λ-def (second sexp) (parse (third sexp)))]
       
       ; Condition for λ function application. We expect a list in
       ; first argument. The second argument may be a symbol (which
       ; the function is applied to), or a lambda function (list)
       ;
       ; So, in summary, we are looking for a pair. We recursively
       ; parse each pair
       [(pair? sexp)
        (λ-app (parse (first sexp)) (parse (second sexp)))
        ]
       
       ; end of inner cond
       )
     ; end of (list? sexp)
     ]   
    ; end of outer cond
    )
  )

(test (parse 'x)
      (λ-ident 'x)
      )
(test (parse '(λ x x))
      (λ-def 'x (λ-ident 'x))
      )
(test (parse '(λ x x))
      (λ-def 'x (λ-ident 'x))
      )
(test (parse '((λ x x) x))
      (λ-app (λ-def 'x (λ-ident 'x)) (λ-ident 'x))
      )
(test (parse '((λ x x) (λ y y)))
      (λ-app (λ-def 'x (λ-ident 'x)) (λ-def 'y (λ-ident 'y)))
      )
(test (parse '(λ f (λ x (f x))))
      (λ-def 'f (λ-def 'x (λ-app (λ-ident 'f) (λ-ident 'x))))
      )


; find-free-identifiers: lambda-expression -> (setof symbol)
;
; Finds the free identifiers in lambda expression and returns
; them as a set.
(define (find-free-identifiers l-exp)
  (type-case lambda-expression l-exp
    ; By definition, a lambda identifier alone is free.
    [λ-ident (s) (set s)]
    
    ; The free identifiers of lambda application
    ; is the union set of free identifiers of both lambda expressions
    [λ-app (l r) (set-union (find-free-identifiers l)
                            (find-free-identifiers r))]
    
    ; The free identifier of a lambda function definition is the 
    ; set of free identifiers of the body with the symbol of the
    ; definition substracted from free identifiers.
    [λ-def (s body) (set-subtract (find-free-identifiers body)
                                   (set s))]
    )
  )

(test (find-free-identifiers (parse 'x))
      (set 'x)
      )
(test (find-free-identifiers (parse '(λ x y)))
      (set 'y)
      )
(test (find-free-identifiers (parse '(λ f (λ x (f x)))))
      (set)
      )
(test (find-free-identifiers (parse '(λ x (λ y ((λ z a) b)))))
      (set 'a 'b)
      )


;(define-type lambda-expression
;  [λ-ident (i symbol?)]
;  [λ-def (s symbol?)
;         (body lambda-expression?)] 
;  [λ-app (left lambda-expression?)
;         (right lambda-expression?)]
;  )

; naive-substitute: symbol lambda-expression lamda-expression -> lambda-expression
;
; Substitutes the lambda-expression associated with symbol in
; the latter lambda-expression
;
; This is a naive substitute as written in the assignment.
; There are ill cases with this function but it will be fixed
; later.
(define (naive-substitute for what where)
  (type-case lambda-expression where
    [λ-ident (symbol)
             [if (equal? symbol for) what where]]
    [λ-def (symbol body)
           (λ-def symbol (naive-substitute for what body))]
    [λ-app (left right)
           (λ-app (naive-substitute for what left)
                  (naive-substitute for what right))]
    ))

(test (naive-substitute 'x (parse 'z) (parse 'y))
      (λ-ident 'y)
      )
(test (naive-substitute 'x (parse '(λ z z)) (parse '(λ x x)))
      (λ-def 'x (λ-def 'z (λ-ident 'z)))
      )

; WARNING: This is an ill-case in naive-substituton. The meaning of
; the lambda expression is changed. First it was an identity function
; now it changes to constant function.
(test (naive-substitute 'x (parse 'y) (parse '(λ x x)))
      (λ-def 'x (λ-ident 'y))
      )


; naive-beta-transform: lambda-expression -> lambda-expression
;
; Applies beta transformation over lambda function application. It has
; nothing to do with definition or plain identifier.

(define (naive-beta-transform l-exp)
  (type-case lambda-expression l-exp
    [λ-app (left right)
           (if (λ-def? left)
               (naive-substitute
                (λ-def-s left)
                right
                (λ-def-body left))
               l-exp)]
    [else l-exp]))

; begin with the basics. We have nothing to do with identifier
; or lambda definition. It should be returned as-is
(test (naive-beta-transform (parse 'x))
      (λ-ident 'x)
      )
(test (naive-beta-transform (parse '(λ x (λ z z))))
      (λ-def 'x (λ-def 'z (λ-ident 'z)))
      )

; lets apply some expressions
(test (naive-beta-transform (parse '((λ x z) y)))
      (λ-ident 'z)
      )

(test (naive-beta-transform (parse '((λ x x) y)))
      (λ-ident 'y)
      )

; WARNING: does not work on nested applications because of
; the expectation of lambda application with left side as
; lambda definition.
;
; For example:
;
; (((λ f (λ x (f x))) (λ q q)) w)
;
; with this expression,  (λ q q) should be applied to w.
; Since this is an identity function, the result should be
; w.
;
; As the left side of the whole expression is λ-app, the expression
; is returned as-is.
