#lang racket
(require (prefix-in F1- "../Fields/Fields1.rkt")
         "../ML-Helpers.rkt")
(require "EvaluationOrderSetup.rkt")
(provide
 (except-out (unprefix-out F1- "../Fields/Fields1.rkt")
             F1-#%let F1-#%lambda F1-#%app F1-#%func F1-#%reassign
             F1-#%id F1-#%module-begin F1-recap)
 (rename-out
  [my-app #%app]
  [my-mod #%module-begin]
  [my-wrapped-recap recap]
  [my-wrapped-print print]
  [strict-let #%let])
 #%id
 #%func
 #%lambda)


(define-syntax-rule (make-lazy expr)
  (wrap (lambda () expr)))
(define (evaluate-lazy-expr expr)
  (expr))
(define my-wrapped-print (make-lazy my-print))
(define my-wrapped-recap (make-lazy F1-recap))

(define-syntax-rule (strict-let ([id binding]) body ... last-body)
  (let ([id
         (let ([evaluated-binding binding])
           (make-lazy evaluated-binding))])
    body ... last-body))

(define-syntax-rule (my-mod body ...)
  (parameterized-mod-begin #:wrap make-lazy #:unwrap evaluate-lazy-expr
                           body ...))
