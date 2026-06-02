(module
    (func
        (local i64 v128)
        (drop
            (select
                (i64x2.splat (local.get 0))
                (v128.const i64x2 0 0)
                (i32.const 1)
            )
        )
    )
)
