;; Regression test for wasmi issue #2062. (Only detectable under Miri.)
;;
;; The cached `(memory 0)` pointer was derived from a `&mut [u8]` which got invalidated by
;; any access that is not lowered to the `(memory 0)` fast path, e.g. stores with offsets
;; above `u16::MAX` or `memory.fill`, so subsequent fast path accesses were UB.
(module
  (memory 2)
  (func (export "store-offset32") (param $ptr i32) (param $value i32) (result i32)
    (i32.store offset=65536 (local.get $ptr) (local.get $value))
    (i32.load (i32.add (local.get $ptr) (i32.const 65536)))
  )
  (func (export "fill") (param $ptr i32) (param $value i32) (result i32)
    (memory.fill (local.get $ptr) (local.get $value) (i32.const 1))
    (i32.load8_u (local.get $ptr))
  )
)
(assert_return (invoke "store-offset32" (i32.const 0) (i32.const 7)) (i32.const 7))
(assert_return (invoke "fill" (i32.const 1) (i32.const 42)) (i32.const 42))

;; Stores whose `ptr` and `value` alias the same register panicked during translation
;; if they could not use the `(memory 0)` fast path, e.g. offsets above `u16::MAX`.
(module
  (memory 2)
  (func (export "store-aliased") (param i32) (result i32)
    (i32.add (local.get 0) (i32.const 1))
    local.tee 0
    local.get 0
    i32.store offset=65536
    (i32.load offset=65536 (local.get 0))
  )
  (func (export "store8-aliased") (param i32) (result i32)
    (i32.add (local.get 0) (i32.const 1))
    local.tee 0
    local.get 0
    i32.store8 offset=65536
    (i32.load8_u offset=65536 (local.get 0))
  )
  (func (export "store16-aliased") (param i32) (result i32)
    (i32.add (local.get 0) (i32.const 1))
    local.tee 0
    local.get 0
    i32.store16 offset=65536
    (i32.load16_u offset=65536 (local.get 0))
  )
)
(assert_return (invoke "store-aliased" (i32.const 1)) (i32.const 2))
(assert_return (invoke "store8-aliased" (i32.const 2)) (i32.const 3))
(assert_return (invoke "store16-aliased" (i32.const 3)) (i32.const 4))
