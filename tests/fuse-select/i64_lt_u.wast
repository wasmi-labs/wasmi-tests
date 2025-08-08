(module
    (func (export "fused(i64.lt_u,select)") (param i64 i64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i64.lt_u
                (local.get 0)
                (local.get 1)
            )
        )
    )
)
(assert_return
    (invoke "fused(i64.lt_u,select)" (i64.const 0) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.lt_u,select)" (i64.const 0) (i64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.lt_u,select)" (i64.const 1) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.lt_u,select)" (i64.const 1) (i64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(i64.lt_u,i32.eqz,select)") (param i64 i64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (i64.lt_u
                    (local.get 0)
                    (local.get 1)
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,select)" (i64.const 0) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,select)" (i64.const 0) (i64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,select)" (i64.const 1) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,select)" (i64.const 1) (i64.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(i64.lt_u,i32.eqz,i32.eqz,select)") (param i64 i64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (i32.eqz
                    (i64.lt_u
                        (local.get 0)
                        (local.get 1)
                    )
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,i32.eqz,select)" (i64.const 0) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,i32.eqz,select)" (i64.const 0) (i64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,i32.eqz,select)" (i64.const 1) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.eqz,i32.eqz,select)" (i64.const 1) (i64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(i64.lt_u,i32.nez,select)") (param i64 i64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.ne
                (i64.lt_u
                    (local.get 0)
                    (local.get 1)
                )
                (i32.const 0)
            )
        )
    )
)
(assert_return
    (invoke "fused(i64.lt_u,i32.nez,select)" (i64.const 0) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.nez,select)" (i64.const 0) (i64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.nez,select)" (i64.const 1) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.lt_u,i32.nez,select)" (i64.const 1) (i64.const 1))
    (i32.const 20)
)
