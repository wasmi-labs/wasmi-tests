(module
    ;; Regression test that finds if `i32.and` is evaluated using short-circuiting logic
    ;; when it has been fused into Wasmi's `br.i32.and` due to the `if`. This is an incorrect.
    ;; For example: `(1 & 2) == 0` and `(1 != 0) && (2 != 0) == 1` evaluate differently.
    (func (export "i32.and") (param i32 i32) (result i32)
        (if (result i32)
            (i32.and
                (local.get 0)
                (local.get 1)
            )
            (then (i32.const 1))
            (else (i32.const 0))
        )
    )
)
(assert_return (invoke "i32.and" (i32.const 1) (i32.const 2)) (i32.const 0))
