(module
    (func (export "fused(i64.ge_s)") (param i64 i64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i64.ge_s
                    (local.get 0)
                    (local.get 1)
                )
            )
        )
        (i32.const 20) ;; case: false
    )
)
(assert_return
    (invoke "fused(i64.ge_s)" (i64.const 0) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.ge_s)" (i64.const 0) (i64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.ge_s)" (i64.const 1) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.ge_s)" (i64.const 1) (i64.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(i64.ge_s,i32.eqz)") (param i64 i64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.eqz
                    (i64.ge_s
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
    (invoke "fused(i64.ge_s,i32.eqz)" (i64.const 0) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.eqz)" (i64.const 0) (i64.const 1))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.eqz)" (i64.const 1) (i64.const 0))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.eqz)" (i64.const 1) (i64.const 1))
    (i32.const 20)
)

(module
    (func (export "fused(i64.ge_s,i32.eqz,i32.eqz)") (param i64 i64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.eqz
                    (i32.eqz
                        (i64.ge_s
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
    (invoke "fused(i64.ge_s,i32.eqz,i32.eqz)" (i64.const 0) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.eqz,i32.eqz)" (i64.const 0) (i64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.eqz,i32.eqz)" (i64.const 1) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.eqz,i32.eqz)" (i64.const 1) (i64.const 1))
    (i32.const 10)
)

(module
    (func (export "fused(i64.ge_s,i32.nez)") (param i64 i64) (result i32)
        (drop
            (br_if 0
                (i32.const 10) ;; case: true
                (i32.ne
                    (i64.ge_s
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
    (invoke "fused(i64.ge_s,i32.nez)" (i64.const 0) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.nez)" (i64.const 0) (i64.const 1))
    (i32.const 20)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.nez)" (i64.const 1) (i64.const 0))
    (i32.const 10)
)
(assert_return
    (invoke "fused(i64.ge_s,i32.nez)" (i64.const 1) (i64.const 1))
    (i32.const 10)
)

