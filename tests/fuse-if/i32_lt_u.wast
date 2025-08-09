(module
    (func (export "fused(i32.lt_u)") (param i32 i32) (result i32)
        (if (result i32)
            (i32.lt_u
                (local.get 0)
                (local.get 1)
            )
            (then (i32.const 10)) ;; case: true
            (else (i32.const 20)) ;; case: false
        )
    )
)
(assert_return
    (invoke "fused(i32.lt_u)" (i32.const 0) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.lt_u)" (i32.const 0) (i32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.lt_u)" (i32.const 1) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.lt_u)" (i32.const 1) (i32.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(i32.lt_u,i32.eqz)") (param i32 i32) (result i32)
        (if (result i32)
            (i32.eqz
                (i32.lt_u
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
    (invoke "fused(i32.lt_u,i32.eqz)" (i32.const 0) (i32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.eqz)" (i32.const 0) (i32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.eqz)" (i32.const 1) (i32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.eqz)" (i32.const 1) (i32.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(i32.lt_u,i32.eqz,i32.eqz)") (param i32 i32) (result i32)
        (if (result i32)
            (i32.eqz
                (i32.eqz
                    (i32.lt_u
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
    (invoke "fused(i32.lt_u,i32.eqz,i32.eqz)" (i32.const 0) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.eqz,i32.eqz)" (i32.const 0) (i32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.eqz,i32.eqz)" (i32.const 1) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.eqz,i32.eqz)" (i32.const 1) (i32.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(i32.lt_u,i32.nez)") (param i32 i32) (result i32)
        (if (result i32)
            (i32.ne
                (i32.lt_u
                    (local.get 0)
                    (local.get 1)
                )
                (i32.const 0)
            )
            (then (i32.const 10)) ;; case: true
            (else (i32.const 20)) ;; case: false
        )
    )
)
(assert_return
    (invoke "fused(i32.lt_u,i32.nez)" (i32.const 0) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.nez)" (i32.const 0) (i32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.nez)" (i32.const 1) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.lt_u,i32.nez)" (i32.const 1) (i32.const 1))
    (i32.const 20)
)
