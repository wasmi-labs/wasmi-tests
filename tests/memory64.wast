;; Regression test for wasmi PR #1964.
;;
;; A memory64 declared with the largest allowed maximum (2^48 pages) must still
;; translate in-bounds constant-address accesses to real load/store ops. The
;; translator previously sized the max via `max << page_size_log2` in u64, which
;; overflows to 0 for max == 2^48, folding every non-zero constant address into
;; an unconditional MemoryOutOfBounds trap at translation time.
(module
  (memory i64 1 0x1000000000000) ;; min 1 page, max 2^48 pages
  (func (export "max_size_access") (result i64)
    (i64.store (i64.const 8) (i64.const 42))
    (i64.load (i64.const 8))
  )
)
(assert_return (invoke "max_size_access") (i64.const 42))
