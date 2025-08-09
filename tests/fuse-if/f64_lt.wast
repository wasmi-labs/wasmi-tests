(module
    (func (export "fused(f64.lt)") (param f64 f64) (result i32)
        (if (result i32)
            (f64.lt
                (local.get 0)
                (local.get 1)
            )
            (then (i32.const 10)) ;; case: true
            (else (i32.const 20)) ;; case: false
        )
    )
)
(assert_return
    (invoke "fused(f64.lt)" (f64.const 0) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt)" (f64.const 0) (f64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.lt)" (f64.const 1) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt)" (f64.const 1) (f64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt)" (f64.const 1) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt)" (f64.const nan) (f64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(f64.lt,i32.eqz)") (param f64 f64) (result i32)
        (if (result i32)
            (i32.eqz
                (f64.lt
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
    (invoke "fused(f64.lt,i32.eqz)" (f64.const 0) (f64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz)" (f64.const 0) (f64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz)" (f64.const 1) (f64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz)" (f64.const 1) (f64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz)" (f64.const 1) (f64.const nan))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz)" (f64.const nan) (f64.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(f64.lt,i32.eqz,i32.eqz)") (param f64 f64) (result i32)
        (if (result i32)
            (i32.eqz
                (i32.eqz
                    (f64.lt
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
    (invoke "fused(f64.lt,i32.eqz,i32.eqz)" (f64.const 0) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz,i32.eqz)" (f64.const 0) (f64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz,i32.eqz)" (f64.const 1) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz,i32.eqz)" (f64.const 1) (f64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz,i32.eqz)" (f64.const 1) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.eqz,i32.eqz)" (f64.const nan) (f64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(f64.lt,i32.nez)") (param f64 f64) (result i32)
        (if (result i32)
            (i32.ne
                (f64.lt
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
    (invoke "fused(f64.lt,i32.nez)" (f64.const 0) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.nez)" (f64.const 0) (f64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(f64.lt,i32.nez)" (f64.const 1) (f64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.nez)" (f64.const 1) (f64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.nez)" (f64.const 1) (f64.const nan))
    (i32.const 20)
)
(assert_return
    (invoke "fused(f64.lt,i32.nez)" (f64.const nan) (f64.const 1))
    (i32.const 20)
)

