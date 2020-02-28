(load-shared-object "./target/debug/libchez_ffi.so")

(define addition
  (foreign-procedure "addition" (unsigned-32 unsigned-32) unsigned-32))

(addition 12 14)
