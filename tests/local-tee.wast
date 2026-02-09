(module
    (func (export "local.tee.same") (param i32) (result i32)
        (local.tee 0 (local.get 0))
    )
    (func (export "local.tee.same.drop") (param i32)
        (drop (local.tee 0 (local.get 0)))
    )
)

(assert_return
    (invoke "local.tee.same" (i32.const 0)) (i32.const 0)
)
(assert_return
    (invoke "local.tee.same" (i32.const 1)) (i32.const 1)
)

(assert_return
    (invoke "local.tee.same.drop" (i32.const 0))
)
(assert_return
    (invoke "local.tee.same.drop" (i32.const 1))
)

(module
    (global (;0;) (mut i32) (i32.const 42))
    (func (export "incorrect-merged-copies") (result i32)
        (local (;0;) i32)
        (local (;1;) i32)
        (local (;2;) i32)
        (local (;3;) i32)
        (global.get 0)
        (local.set 1
            (local.get 3)
        )
        (local.tee 2)
        (local.tee 0)
    )
)

(assert_return
    (invoke "incorrect-merged-copies")
    (i32.const 42)
)
