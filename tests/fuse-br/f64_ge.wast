(module
    (func (export "fused(f64.ge)") (param f64 f64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (f64.ge
                    (local.get 0)
                    (local.get 1)
                )
            )
        )
        (i32.const 20) ;; case: false
    )
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const 0.0) (f64.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const 0.0) (f64.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const 0.0) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const 1.0) (f64.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const 1.0) (f64.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const 1.0) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const nan) (f64.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const nan) (f64.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge)" (f64.const nan) (f64.const nan))
    (i32.const 20)
)

(module
    (func (export "fused(f64.ge,i32.eqz)") (param f64 f64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.eqz
                    (f64.ge
                        (local.get 0)
                        (local.get 1)
                    )
                )
            )
        )
        (i32.const 20) ;; case: false
    )
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const 0.0) (f64.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const 0.0) (f64.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const 0.0) (f64.const nan))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const 1.0) (f64.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const 1.0) (f64.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const 1.0) (f64.const nan))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const nan) (f64.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const nan) (f64.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz)" (f64.const nan) (f64.const nan))
    (i32.const 10)
)

(module
    (func (export "fused(f64.ge,i32.eqz,i32.eqz)") (param f64 f64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.eqz
                    (i32.eqz
                        (f64.ge
                            (local.get 0)
                            (local.get 1)
                        )
                    )
                )
            )
        )
        (i32.const 20) ;; case: false
    )
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const 0.0) (f64.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const 0.0) (f64.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const 0.0) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const 1.0) (f64.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const 1.0) (f64.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const 1.0) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const nan) (f64.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const nan) (f64.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.eqz,i32.eqz)" (f64.const nan) (f64.const nan))
    (i32.const 20)
)

(module
    (func (export "fused(f64.ge,i32.nez)") (param f64 f64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.ne
                    (f64.ge
                        (local.get 0)
                        (local.get 1)
                    )
                    (i32.const 0)
                )
            )
        )
        (i32.const 20) ;; case: false
    )
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const 0.0) (f64.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const 0.0) (f64.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const 0.0) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const 1.0) (f64.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const 1.0) (f64.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const 1.0) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const nan) (f64.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const nan) (f64.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.ge,i32.nez)" (f64.const nan) (f64.const nan))
    (i32.const 20)
)
