(module
    ;; Regression test asserting that `select` does not push twice in case of
    ;; an `i32.const 0` conditional and temporary operands (via `i32.wrap_i64`).
    (func (export "select.consteval.result") (param i64) (result f32)
        f32.const 0
        f32.const 0
        (drop
            (select
                (i32.wrap_i64 (local.get 0)) ;; case: true
                (i32.wrap_i64 (local.get 0)) ;; case: fase
                i32.const 0                  ;; condition (false)
            )
        )
        f32.add
    )
)

(assert_return
    (invoke "select.consteval.result" (i64.const 42))
    (f32.const 0)
)

(module
    ;; Regression test asserting that a `select` fused with a zero test of its
    ;; condition tests the slot operand and not the dropped comparison result.
    ;; See: https://github.com/wasmi-labs/wasmi/issues/2046
    ;; All `select`s yield 10 if their condition holds and 20 otherwise.
    (func (export "select.fuse.eqz") (param $cond i32) (result i32)
        (select (i32.const 10) (i32.const 20) (i32.eqz (local.get $cond)))
    )
    (func (export "select.fuse.eq_0") (param $cond i32) (result i32)
        (select (i32.const 10) (i32.const 20) (i32.eq (local.get $cond) (i32.const 0)))
    )
    (func (export "select.fuse.ne_0") (param $cond i32) (result i32)
        (select (i32.const 10) (i32.const 20) (i32.ne (local.get $cond) (i32.const 0)))
    )
    (func (export "select.fuse.ne_0_lhs") (param $cond i32) (result i32)
        (select (i32.const 10) (i32.const 20) (i32.ne (i32.const 0) (local.get $cond)))
    )
    (func (export "select.fuse.eqz_eqz") (param $cond i32) (result i32)
        (select (i32.const 10) (i32.const 20) (i32.eqz (i32.eqz (local.get $cond))))
    )
    (func (export "select.fuse.eqz_computed") (param $cond i32) (result i32)
        (select (i32.const 10) (i32.const 20) (i32.eqz (i32.add (local.get $cond) (i32.const 1))))
    )
)

(assert_return
    (invoke "select.fuse.eqz" (i32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.eqz" (i32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eqz" (i32.const -1))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eqz" (i32.const 9))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eq_0" (i32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.eq_0" (i32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eq_0" (i32.const -1))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eq_0" (i32.const 9))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.ne_0" (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.ne_0" (i32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.ne_0" (i32.const -1))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.ne_0" (i32.const 9))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.ne_0_lhs" (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.ne_0_lhs" (i32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.ne_0_lhs" (i32.const -1))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.ne_0_lhs" (i32.const 9))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.eqz_eqz" (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eqz_eqz" (i32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.eqz_eqz" (i32.const -1))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.eqz_eqz" (i32.const 9))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.eqz_computed" (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eqz_computed" (i32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "select.fuse.eqz_computed" (i32.const -1))
    (i32.const 10)
)
(assert_return
    (invoke "select.fuse.eqz_computed" (i32.const 9))
    (i32.const 20)
)
