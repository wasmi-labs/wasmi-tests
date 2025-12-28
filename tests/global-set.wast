(module
    (global $gext (mut externref) (ref.null extern))
    (func (export "global.set(ref.null extern)")
        (global.set $gext (ref.null extern))
    )

    (global $gfun (mut funcref) (ref.null func))
    (func (export "global.set(ref.null func)")
        (global.set $gfun (ref.null func))
    )
)

(assert_return (invoke "global.set(ref.null extern)"))
(assert_return (invoke "global.set(ref.null func)"))
