(load-shared-object "./target/debug/libchez_ffi.so")

(import (ffi))

;; Integers

(define addition
  (foreign-procedure "addition" (unsigned-32 unsigned-32) unsigned-32))

(addition 12 14)


;; String args

(define count-characters
  (foreign-procedure "count_characters" (string) unsigned-32))


(count-characters "Hello World!")


;; String returns

(define ptr->string
  (lambda (ptr)
    (let loop ((i 0)
	       (chs '()))
      (let ((ch (foreign-ref 'char ptr i)))
	(cond
	 ((char=? ch #\nul) (list->string (reverse chs)))
	 (else (loop (+ i 1)
		     (cons ch chs))))))))

(define song_generate
  (foreign-procedure "theme_song_generate" (unsigned-8) uptr))

(define song_free
  (foreign-procedure "theme_song_free" (uptr) void))

(define print-song
  (lambda ()
    (let ((s (song_generate 4)))
      (display (ptr->string s))
      (newline)
      (song_free s))))

;; Slice arguments

(define sum_even
  (foreign-procedure "sum_of_even" ((* unsigned-32) size_t) unsigned-32))

;; ;; scheme helpers

(define-collection-lambdas unsigned-32)

;; convert scheme integer list to c pointers
(define (u32-list->ptr xs)
  (let ((ptr (make-foreign-array unsigned-32 (length xs)))
	(len (length xs)))
    (map (lambda (val i)
	   (ftype-set! unsigned-32 () ptr i val))
	 xs
	 (iota len))
    ptr))

(define arr (list 1 2 3 4 5 6 7))

(define ptr (make-foreign-array uptr (length arr)))
(define len (length arr))

(define a (u32-list->ptr arr))

;; get the list back
;; (unsigned-32-pointer-map (lambda (ptr) (read-unsigned-32 ptr))
;; 			 (make-array-pointer (length arr)
;; 					     a
;; 					     'unsigned-32))

(sum_even (u32-list->ptr arr) (length arr))


;; Tuples

(define-foreign-struct tuple
  ((x unsigned-32)
   (y unsigned-32)))

;; the caller must provide an extra (* ftype) argument before all other arguments to receive the
;; result.
(define flip
  (foreign-procedure "flip_things_around" ((& tuple)) (& tuple)))

(define a (make-foreign-object tuple))
(define t1 (flip a (make-tuple 12 13)))

(ftype-pointer->sexpr a)

;; Using rust opaque objects

(define-ftype db uptr)

(define db_new (foreign-procedure "zip_code_database_new" () db))
(define db_free (foreign-procedure "zip_code_database_free" (db) void))
(define db_populate (foreign-procedure "zip_code_database_populate" (db) void))
(define db_ref (foreign-procedure "zip_code_database_population_of" (db string) unsigned-32))

(define run
  (lambda ()
    (define db (db_new))
    
    (begin (db_populate db)
	   (db_ref db "90210")
	   (db_ref db "20500")
	   (db_free db))))

(run)
