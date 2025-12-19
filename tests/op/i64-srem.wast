(module
    (func (export "i64.rem_s(x, -1)") (param i64) (result i64)
        (i64.rem_s
            (local.get 0)
            (i64.const -1)
        ) ;; ~error: unexpected integer-overflow
    )
)
(assert_return (invoke "i64.rem_s(x, -1)" (i64.const -9223372036854775808)) (i64.const 0))
