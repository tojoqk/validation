(defpackage #:coalton-validation/applicative
  (:use #:coalton
        #:coalton-prelude)
  (:shadow #:let)
  (:export #:apply #:let))

(in-package #:coalton-validation/applicative)

(named-readtables:in-readtable coalton:coalton)

(coalton-toplevel
  (declare <*> (Applicative :f => :f (:a -> :b) -> :f :a -> :f :b))
  (define <*> (liftA2 id)))

(cl:defmacro apply (f cl:&rest args)
  `(op->l <*> (pure ,f) ,@args))

(cl:defmacro let ((cl:&rest bindings) cl:&body body)
  `(apply (fn ,(cl:mapcar #'cl:first bindings)
            ,@body)
          ,@(cl:mapcar #'cl:second bindings)))

(cl:defmacro op->l (op x y cl:&rest args)
  (cl:cond
    ((cl:null args) `(,op ,x ,y))
    ((cl:null (cl:cdr args))
     `(,op (,op ,x ,y) ,(cl:car args)))
    (cl:t
     `(op->l ,op
             (,op ,x ,y)
             ,(cl:car args)
             ,(cl:cadr args)
             ,@(cl:cddr args)))))