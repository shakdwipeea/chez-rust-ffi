(load-shared-object "./target/debug/libchez_ffi.so")


;; Integers

(define addition
  (foreign-procedure "addition" (unsigned-32 unsigned-32) unsigned-32))

(addition 12 14)


;; Strings

(define count-characters
  (foreign-procedure "count_characters" (string) unsigned-32))

(count-characters "Hello rust!")
