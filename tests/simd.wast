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

(module
    (func (export "(i8x16.shuffle x c)") (param i32) (result v128)
        (i32x4.splat (local.get 0))
        (v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff)
        (i8x16.shuffle 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30)
    )

    (func (export "(i8x16.shuffle c x)") (param i32) (result v128)
        (v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff)
        (i32x4.splat (local.get 0))
        (i8x16.shuffle 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30)
    )

    (func (export "(i8x16.shuffle c c)") (result v128)
        (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
        (v128.const i32x4 0xffffffff 0xffffffff 0xffffffff 0xffffffff)
        (i8x16.shuffle 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30)
    )
)
(assert_return
    (invoke "(i8x16.shuffle c x)" (i32.const 0))
    (v128.const i32x4 -1 -1 0 0)
)
(assert_return
    (invoke "(i8x16.shuffle x c)" (i32.const 0))
    (v128.const i32x4 0 0 -1 -1)
)
(assert_return
    (invoke "(i8x16.shuffle c c)")
    (v128.const i32x4 0 0 -1 -1)
)
