(module
    (func (export "fused(i64.or,i64.eqz)") (param i64 i64) (result i32)
        (if (result i32)
            (i64.eqz
                (i64.or
                    (local.get 0)
                    (local.get 1)
                )
            )
            (then (i32.const 10)) ;; case: true
            (else (i32.const 20)) ;; case: false
        )
    )
)
(assert_return
    (invoke "fused(i64.or,i64.eqz)" (i64.const 0) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.or,i64.eqz)" (i64.const 0) (i64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.or,i64.eqz)" (i64.const 1) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.or,i64.eqz)" (i64.const 1) (i64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(i64.or,i64.eqz,i64.eqz)") (param i64 i64) (result i32)
        (if (result i32)
            (i32.eqz
                (i64.eqz
                    (i64.or
                        (local.get 0)
                        (local.get 1)
                    )
                )
            )
            (then (i32.const 10)) ;; case: true
            (else (i32.const 20)) ;; case: false
        )
    )
)
(assert_return
    (invoke "fused(i64.or,i64.eqz,i64.eqz)" (i64.const 0) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.or,i64.eqz,i64.eqz)" (i64.const 0) (i64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.or,i64.eqz,i64.eqz)" (i64.const 1) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.or,i64.eqz,i64.eqz)" (i64.const 1) (i64.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(i64.or,i64.nez)") (param i64 i64) (result i32)
        (if (result i32)
            (i64.ne
                (i64.or
                    (local.get 0)
                    (local.get 1)
                )
                (i64.const 0)
            )
            (then (i32.const 10)) ;; case: true
            (else (i32.const 20)) ;; case: false
        )
    )
)
(assert_return
    (invoke "fused(i64.or,i64.nez)" (i64.const 0) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.or,i64.nez)" (i64.const 0) (i64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.or,i64.nez)" (i64.const 1) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.or,i64.nez)" (i64.const 1) (i64.const 1))
    (i32.const 10)
)
