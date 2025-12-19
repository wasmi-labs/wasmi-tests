(module
    (func (export "i32.rem_s(x, -1)") (param i32) (result i32)
        (i32.rem_s
            (local.get 0)
            (i32.const -1)
        ) ;; ~error: unexpected integer-overflow
    )
)
(assert_return (invoke "i32.rem_s(x, -1)" (i32.const -2147483648)) (i32.const 0))
