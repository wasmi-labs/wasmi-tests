;; Regression test for wasmi PR #1964.
;;
;; A memory64 declared with the largest allowed maximum (2^48 pages) must still
;; translate in-bounds constant-address accesses to real load/store ops. The
;; translator previously sized the max via `max << page_size_log2` in u64, which
;; overflows to 0 for max == 2^48, folding every non-zero constant address into
;; an unconditional MemoryOutOfBounds trap at translation time.
;;
;; Regression test for wasmi PR #2053.
;;
;; Growing that memory panicked since its maximum byte size (2^64) overflowed u64.
(module
  (memory i64 1 0x1000000000000) ;; min 1 page, max 2^48 pages
  (func (export "max_size_access") (result i64)
    (i64.store (i64.const 8) (i64.const 42))
    (i64.load (i64.const 8))
  )
  (func (export "grow") (param $delta i64) (result i64)
    (memory.grow (local.get $delta))
  )
)
(assert_return (invoke "max_size_access") (i64.const 42))
(assert_return (invoke "grow" (i64.const 1)) (i64.const 1))
(assert_return (invoke "grow" (i64.const 1)) (i64.const 2))
