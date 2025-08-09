(module
    (func (export "fused(f32.ge)") (param f32 f32) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (f32.ge
                    (local.get 0)
                    (local.get 1)
                )
            )
        )
        (i32.const 20) ;; case: false
    )
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const 0.0) (f32.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const 0.0) (f32.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const 0.0) (f32.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const 1.0) (f32.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const 1.0) (f32.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const 1.0) (f32.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const nan) (f32.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const nan) (f32.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge)" (f32.const nan) (f32.const nan))
    (i32.const 20)
)

(module
    (func (export "fused(f32.ge,i32.eqz)") (param f32 f32) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.eqz
                    (f32.ge
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
    (invoke "fused(f32.ge,i32.eqz)" (f32.const 0.0) (f32.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const 0.0) (f32.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const 0.0) (f32.const nan))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const 1.0) (f32.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const 1.0) (f32.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const 1.0) (f32.const nan))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const nan) (f32.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const nan) (f32.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz)" (f32.const nan) (f32.const nan))
    (i32.const 10)
)

(module
    (func (export "fused(f32.ge,i32.eqz,i32.eqz)") (param f32 f32) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
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
        (i32.const 20) ;; case: false
    )
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const 0.0) (f32.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const 0.0) (f32.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const 0.0) (f32.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const 1.0) (f32.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const 1.0) (f32.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const 1.0) (f32.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const nan) (f32.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const nan) (f32.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.eqz,i32.eqz)" (f32.const nan) (f32.const nan))
    (i32.const 20)
)

(module
    (func (export "fused(f32.ge,i32.nez)") (param f32 f32) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.ne
                    (f32.ge
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
    (invoke "fused(f32.ge,i32.nez)" (f32.const 0.0) (f32.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const 0.0) (f32.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const 0.0) (f32.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const 1.0) (f32.const 0.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const 1.0) (f32.const 1.0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const 1.0) (f32.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const nan) (f32.const 0.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const nan) (f32.const 1.0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f32.ge,i32.nez)" (f32.const nan) (f32.const nan))
    (i32.const 20)
)
