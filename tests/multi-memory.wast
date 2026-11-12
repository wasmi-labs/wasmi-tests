;; Regression test for wasmi PR #2051.
;;
;; `memory.grow` only refreshed the cached `(memory 0)` for index 0, so growing it through
;; an aliasing import left the cache pointing at the freed buffer with its old length.
(module $M (memory (export "mem") 1 2))
(register "M" $M)
(module
  (import "M" "mem" (memory $m0 1 2))
  (import "M" "mem" (memory $m1 1 2))
  (func (export "grow-via-alias") (param $ptr i32) (param $value i32) (result i32)
    (drop (memory.grow $m1 (i32.const 1)))
    (i32.store8 $m0 (local.get $ptr) (local.get $value))
    (i32.load8_u $m1 (local.get $ptr))
  )
)
(assert_return (invoke "grow-via-alias" (i32.const 65536) (i32.const 42)) (i32.const 42))
