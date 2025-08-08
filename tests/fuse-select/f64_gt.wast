(module
    (func (export "fused(f64.gt,select)") (param f64 f64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (f64.gt
                (local.get 0)
                (local.get 1)
            )
        )
    )
)
(assert_return
    (invoke "fused(f64.gt,select)" (f64.const 0) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.gt,select)" (f64.const 0) (f64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.gt,select)" (f64.const 1) (f64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.gt,select)" (f64.const 1) (f64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(f64.gt,i32.eqz,select)") (param f64 f64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (f64.gt
                    (local.get 0)
                    (local.get 1)
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,select)" (f64.const 0) (f64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,select)" (f64.const 0) (f64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,select)" (f64.const 1) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,select)" (f64.const 1) (f64.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(f64.gt,i32.eqz,i32.eqz,select)") (param f64 f64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.eqz
                (i32.eqz
                    (f64.gt
                        (local.get 0)
                        (local.get 1)
                    )
                )
            )
        )
    )
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,i32.eqz,select)" (f64.const 0) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,i32.eqz,select)" (f64.const 0) (f64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,i32.eqz,select)" (f64.const 1) (f64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.gt,i32.eqz,i32.eqz,select)" (f64.const 1) (f64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(f64.gt,i32.nez,select)") (param f64 f64) (result i32)
        (select
            (i32.const 10) ;; case: true
            (i32.const 20) ;; case: false
            (i32.ne
                (f64.gt
                    (local.get 0)
                    (local.get 1)
                )
                (i32.const 0)
            )
        )
    )
)
(assert_return
    (invoke "fused(f64.gt,i32.nez,select)" (f64.const 0) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.gt,i32.nez,select)" (f64.const 0) (f64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.gt,i32.nez,select)" (f64.const 1) (f64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.gt,i32.nez,select)" (f64.const 1) (f64.const 1))
    (i32.const 20)
)
