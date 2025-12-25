(module
    (func (export "test") (param i32) (result i32)
        (local.get 0) ;; actual return value
        (loop $continue (result i32)
            (if (result i32)
                (i32.eq (local.get 0) (i32.const -1))
                (then (i32.const 0))
                (else
                    (local.set 0 (i32.const -1))
                    (br $continue)
                )
            )
        )
        (drop) ;; drop results from `loop`
    )
)

(assert_return (invoke "test" (i32.const 0)) (i32.const 0))
(assert_return (invoke "test" (i32.const 1)) (i32.const 1))
