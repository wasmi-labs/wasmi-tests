(module
    (func (export "(i8x16.splat 1)") (result v128)
        (i8x16.splat (i32.const 1))
    )

    (func (export "(i16x8.splat 1)") (result v128)
        (i16x8.splat (i32.const 1))
    )

    (func (export "(i32x4.splat 1)") (result v128)
        (i32x4.splat (i32.const 1))
    )

    (func (export "(i64x2.splat 1)") (result v128)
        (i64x2.splat (i64.const 1))
    )
)

(assert_return (invoke "(i8x16.splat 1)") (v128.const i8x16 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
(assert_return (invoke "(i16x8.splat 1)") (v128.const i16x8 1 1 1 1 1 1 1 1))
(assert_return (invoke "(i32x4.splat 1)") (v128.const i32x4 1 1 1 1))
(assert_return (invoke "(i64x2.splat 1)") (v128.const i64x2 1 1))
