(module
    (func (export "fused(i32.and,select)") (param i32 i32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.and
                (local.get 0)
                (local.get 1)
            )
        )
    )
)
(assert_return
    (invoke "fused(i32.and,select)" (i32.const 0) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,select)" (i32.const 0) (i32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,select)" (i32.const 1) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,select)" (i32.const 1) (i32.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(i32.and,i32.eqz,select)") (param i32 i32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (i32.and
                    (local.get 0)
                    (local.get 1)
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,select)" (i32.const 0) (i32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,select)" (i32.const 0) (i32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,select)" (i32.const 1) (i32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,select)" (i32.const 1) (i32.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(i32.and,i32.eqz,i32.eqz,select)") (param i32 i32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (i32.eqz
                    (i32.and
                        (local.get 0)
                        (local.get 1)
                    )
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,i32.eqz,select)" (i32.const 0) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,i32.eqz,select)" (i32.const 0) (i32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,i32.eqz,select)" (i32.const 1) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,i32.eqz,i32.eqz,select)" (i32.const 1) (i32.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(i32.and,i32.nez,select)") (param i32 i32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.ne
                (i32.and
                    (local.get 0)
                    (local.get 1)
                )
                (i32.const 0)
            )
        )
    )
)
(assert_return
    (invoke "fused(i32.and,i32.nez,select)" (i32.const 0) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,i32.nez,select)" (i32.const 0) (i32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,i32.nez,select)" (i32.const 1) (i32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i32.and,i32.nez,select)" (i32.const 1) (i32.const 1))
    (i32.const 10)
)
