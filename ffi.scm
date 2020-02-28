(load-shared-object "./target/debug/libchez_ffi.so")


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
