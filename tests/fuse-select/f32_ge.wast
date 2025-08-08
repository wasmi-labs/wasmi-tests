(module
    (func (export "fused(f32.ge,select)") (param f32 f32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (f32.ge
                (local.get 0)
                (local.get 1)
            )
        )
    )
)
(assert_return
    (invoke "fused(f32.ge,select)" (f32.const 0) (f32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,select)" (f32.const 0) (f32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,select)" (f32.const 1) (f32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,select)" (f32.const 1) (f32.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(f32.ge,i32.eqz,select)") (param f32 f32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (f32.ge
                    (local.get 0)
                    (local.get 1)
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,select)" (f32.const 0) (f32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,select)" (f32.const 0) (f32.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,select)" (f32.const 1) (f32.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,select)" (f32.const 1) (f32.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(f32.ge,i32.eqz,i32.eqz,select)") (param f32 f32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (i32.eqz
                    (f32.ge
                        (local.get 0)
                        (local.get 1)
                    )
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz,select)" (f32.const 0) (f32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz,select)" (f32.const 0) (f32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz,select)" (f32.const 1) (f32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz,select)" (f32.const 1) (f32.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(f32.ge,i32.nez,select)") (param f32 f32) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.ne
                (f32.ge
                    (local.get 0)
                    (local.get 1)
                )
                (i32.const 0)
            )
        )
    )
)
(assert_return
    (invoke "fused(f32.ge,i32.nez,select)" (f32.const 0) (f32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez,select)" (f32.const 0) (f32.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez,select)" (f32.const 1) (f32.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez,select)" (f32.const 1) (f32.const 1))
    (i32.const 10)
)
