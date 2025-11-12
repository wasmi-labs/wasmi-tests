(module
    ;; Regression test that finds if `i64.and` is evaluated using short-circuiting logic
    ;; when it has been fused into Wasmi's `br.i64.and` due to the `if`. This is an incorrect.
    ;; For example: `(1 & 2) == 0` and `(1 != 0) && (2 != 0) == 1` evaluate differently.
    (func (export "i64.and") (param i64 i64) (result i32)
        (if (result i32)
            (i64.ne
                (i64.and
                    (local.get 0)
                    (local.get 1)
                )
                (i64.const 0)
            )
            (then (i32.const 1))
            (else (i32.const 0))
        )
    )
)
(assert_return (invoke "i64.and" (i64.const 1) (i64.const 2)) (i32.const 0))
