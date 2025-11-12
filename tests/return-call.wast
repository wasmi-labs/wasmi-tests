(module
    ;; We define this module to check if Wasmi's expected test module setup was successful.
    (import "wasmitest" "identity-0" (func $identity-0))
    (import "wasmitest" "identity-1" (func $identity-1 (param i64) (result i64)))
    (import "wasmitest" "identity-2" (func $identity-2 (param i64 i64) (result i64 i64)))
    (import "wasmitest" "offset-1" (func $offset-1 (param i64) (result i64)))
    (import "wasmitest" "offset-2" (func $offset-2 (param i64 i64) (result i64 i64)))
    (import "wasmitest" "sum-3" (func $sum-3 (param i64 i64 i64) (result i64)))
    (import "wasmitest" "iota-3" (func $iota-3 (param i64) (result i64 i64 i64)))
)

(module
    (import "wasmitest" "identity-0" (func $identity-0))
    (func $tail (export "identity-0")
        (return_call $identity-0)
    )
    (func (export "nested-identity-0")
        (call $tail)
    )
)
(assert_return (invoke "identity-0"))
(assert_return (invoke "nested-identity-0"))

(module
    (import "wasmitest" "identity-1" (func $identity-1 (param i64) (result i64)))
    (func $tail (export "identity-1") (param i64) (result i64)
        (return_call $identity-1
            (local.get 0)
        )
    )
    (func (export "nested-identity-1") (param i64) (result i64)
        (call $tail
            (local.get 0)
        )
    )
)
(assert_return
    (invoke "identity-1" (i64.const 0))
    (i64.const 0)
)
(assert_return
    (invoke "identity-1" (i64.const 1))
    (i64.const 1)
)
(assert_return
    (invoke "identity-1" (i64.const -1))
    (i64.const -1)
)
(assert_return
    (invoke "nested-identity-1" (i64.const 0))
    (i64.const 0)
)
(assert_return
    (invoke "nested-identity-1" (i64.const 1))
    (i64.const 1)
)
(assert_return
    (invoke "nested-identity-1" (i64.const -1))
    (i64.const -1)
)

(module
    (import "wasmitest" "identity-2" (func $identity-2 (param i64 i64) (result i64 i64)))
    (func $tail (export "identity-2") (param i64 i64) (result i64 i64)
        (return_call $identity-2
            (local.get 0)
            (local.get 1)
        )
    )
    (func (export "nested-identity-2") (param i64 i64) (result i64 i64)
        (call $tail
            (local.get 0)
            (local.get 1)
        )
    )
)
(assert_return
    (invoke "identity-2" (i64.const 0) (i64.const 0))
    (i64.const 0) (i64.const 0)
)
(assert_return
    (invoke "identity-2" (i64.const 0) (i64.const 1))
    (i64.const 0) (i64.const 1)
)
(assert_return
    (invoke "identity-2" (i64.const 1) (i64.const 0))
    (i64.const 1) (i64.const 0)
)
(assert_return
    (invoke "identity-2" (i64.const 1) (i64.const 1))
    (i64.const 1) (i64.const 1)
)
(assert_return
    (invoke "nested-identity-2" (i64.const 0) (i64.const 0))
    (i64.const 0) (i64.const 0)
)
(assert_return
    (invoke "nested-identity-2" (i64.const 0) (i64.const 1))
    (i64.const 0) (i64.const 1)
)
(assert_return
    (invoke "nested-identity-2" (i64.const 1) (i64.const 0))
    (i64.const 1) (i64.const 0)
)
(assert_return
    (invoke "nested-identity-2" (i64.const 1) (i64.const 1))
    (i64.const 1) (i64.const 1)
)

(module
    (import "wasmitest" "offset-1" (func $offset-1 (param i64) (result i64)))
    (func $tail (export "offset-1") (param i64) (result i64)
        (return_call $offset-1
            (local.get 0)
        )
    )
    (func (export "nested-offset-1") (param i64) (result i64)
        (call $tail
            (local.get 0)
        )
    )
)
(assert_return
    (invoke "offset-1" (i64.const 0))
    (i64.const 1)
)
(assert_return
    (invoke "offset-1" (i64.const 1))
    (i64.const 2)
)
(assert_return
    (invoke "offset-1" (i64.const -1))
    (i64.const 0)
)
(assert_return
    (invoke "nested-offset-1" (i64.const 0))
    (i64.const 1)
)
(assert_return
    (invoke "nested-offset-1" (i64.const 1))
    (i64.const 2)
)
(assert_return
    (invoke "nested-offset-1" (i64.const -1))
    (i64.const 0)
)

(module
    (import "wasmitest" "offset-2" (func $offset-2 (param i64 i64) (result i64 i64)))
    (func $tail (export "offset-2") (param i64 i64) (result i64 i64)
        (return_call $offset-2
            (local.get 0)
            (local.get 1)
        )
    )
    (func (export "nested-offset-2") (param i64 i64) (result i64 i64)
        (call $tail
            (local.get 0)
            (local.get 1)
        )
    )
)
(assert_return
    (invoke "offset-2" (i64.const 0) (i64.const 0))
    (i64.const 1) (i64.const 2)
)
(assert_return
    (invoke "offset-2" (i64.const 0) (i64.const 1))
    (i64.const 1) (i64.const 3)
)
(assert_return
    (invoke "offset-2" (i64.const 1) (i64.const 0))
    (i64.const 2) (i64.const 2)
)
(assert_return
    (invoke "offset-2" (i64.const 1) (i64.const 1))
    (i64.const 2) (i64.const 3)
)
(assert_return
    (invoke "nested-offset-2" (i64.const 0) (i64.const 0))
    (i64.const 1) (i64.const 2)
)
(assert_return
    (invoke "nested-offset-2" (i64.const 0) (i64.const 1))
    (i64.const 1) (i64.const 3)
)
(assert_return
    (invoke "nested-offset-2" (i64.const 1) (i64.const 0))
    (i64.const 2) (i64.const 2)
)
(assert_return
    (invoke "nested-offset-2" (i64.const 1) (i64.const 1))
    (i64.const 2) (i64.const 3)
)

(module
    (import "wasmitest" "sum-3" (func $sum-3 (param i64 i64 i64) (result i64)))
    (func $tail (export "sum-3") (param i64 i64 i64) (result i64)
        (return_call $sum-3
            (local.get 0)
            (local.get 1)
            (local.get 2)
        )
    )
    (func (export "nested-sum-3") (param i64 i64 i64) (result i64)
        (call $tail
            (local.get 0)
            (local.get 1)
            (local.get 2)
        )
    )
)
(assert_return
    (invoke "sum-3" (i64.const 0) (i64.const 0) (i64.const 0))
    (i64.const 0)
)
(assert_return
    (invoke "sum-3" (i64.const 1) (i64.const 2) (i64.const 3))
    (i64.const 6)
)
(assert_return
    (invoke "sum-3" (i64.const -1) (i64.const 0) (i64.const 1))
    (i64.const 0)
)
(assert_return
    (invoke "sum-3" (i64.const -1) (i64.const -1) (i64.const -1))
    (i64.const -3)
)
(assert_return
    (invoke "nested-sum-3" (i64.const 0) (i64.const 0) (i64.const 0))
    (i64.const 0)
)
(assert_return
    (invoke "nested-sum-3" (i64.const 1) (i64.const 2) (i64.const 3))
    (i64.const 6)
)
(assert_return
    (invoke "nested-sum-3" (i64.const -1) (i64.const 0) (i64.const 1))
    (i64.const 0)
)
(assert_return
    (invoke "nested-sum-3" (i64.const -1) (i64.const -1) (i64.const -1))
    (i64.const -3)
)

(module
    (import "wasmitest" "iota-3" (func $iota-3 (param i64) (result i64 i64 i64)))
    (func $tail (export "iota-3") (param i64) (result i64 i64 i64)
        (return_call $iota-3
            (local.get 0)
        )
    )
    (func (export "nested-iota-3") (param i64) (result i64 i64 i64)
        (call $tail (local.get 0))
    )
)
(assert_return
    (invoke "iota-3" (i64.const 0))
    (i64.const 1) (i64.const 2) (i64.const 3)
)
(assert_return
    (invoke "iota-3" (i64.const 100))
    (i64.const 101) (i64.const 102) (i64.const 103)
)
(assert_return
    (invoke "iota-3" (i64.const -3))
    (i64.const -2) (i64.const -1) (i64.const 0)
)
(assert_return
    (invoke "nested-iota-3" (i64.const 0))
    (i64.const 1) (i64.const 2) (i64.const 3)
)
(assert_return
    (invoke "nested-iota-3" (i64.const 100))
    (i64.const 101) (i64.const 102) (i64.const 103)
)
(assert_return
    (invoke "nested-iota-3" (i64.const -3))
    (i64.const -2) (i64.const -1) (i64.const 0)
)

(module
    (func $is_even (export "is-even") (param $a i32) (result i32)
        (if (result i32)
            (i32.eqz (local.get $a))
            (then
                (i32.const 1)
            )
            (else
                (call $is_odd (i32.sub (local.get $a) (i32.const 1)))
            )
        )
    )
    (func $is_odd (export "is-odd") (param $a i32) (result i32)
        (if (result i32)
            (i32.eqz (local.get $a))
            (then
                (i32.const 0)
            )
            (else
                (call $is_even (i32.sub (local.get $a) (i32.const 1)))
            )
        )
    )
)
(assert_return (invoke "is-even" (i32.const 0)) (i32.const 1))
(assert_return (invoke "is-even" (i32.const 1)) (i32.const 0))
(assert_return (invoke "is-even" (i32.const 2)) (i32.const 1))
(assert_return (invoke "is-even" (i32.const 3)) (i32.const 0))
(assert_return (invoke "is-even" (i32.const 4)) (i32.const 1))
(assert_return (invoke "is-even" (i32.const 5)) (i32.const 0))
(assert_return (invoke "is-even" (i32.const 6)) (i32.const 1))
(assert_return (invoke "is-even" (i32.const 7)) (i32.const 0))
(assert_return (invoke "is-even" (i32.const 8)) (i32.const 1))
(assert_return (invoke "is-even" (i32.const 9)) (i32.const 0))

(assert_return (invoke "is-odd" (i32.const 0)) (i32.const 0))
(assert_return (invoke "is-odd" (i32.const 1)) (i32.const 1))
(assert_return (invoke "is-odd" (i32.const 2)) (i32.const 0))
(assert_return (invoke "is-odd" (i32.const 3)) (i32.const 1))
(assert_return (invoke "is-odd" (i32.const 4)) (i32.const 0))
(assert_return (invoke "is-odd" (i32.const 5)) (i32.const 1))
(assert_return (invoke "is-odd" (i32.const 6)) (i32.const 0))
(assert_return (invoke "is-odd" (i32.const 7)) (i32.const 1))
(assert_return (invoke "is-odd" (i32.const 8)) (i32.const 0))
(assert_return (invoke "is-odd" (i32.const 9)) (i32.const 1))

;; The exported functions call the imported identity host functions `n` times.
;; The host functions are supposed to be identity functions with fixed arity.
;;
;; After successful execution the exported functions returns 0.
(module
    (import "wasmitest" "identity-0" (func $identity-0))
    (import "wasmitest" "identity-1" (func $identity-1 (param i64) (result i64)))
    (import "wasmitest" "identity-2" (func $identity-2 (param i64 i64) (result i64 i64)))

    (func $forward-identity-0
        (return_call $identity-0)
    )
    (func $forward-identity-1 (param i64) (result i64)
        (return_call $identity-1 (local.get 0))
    )
    (func $forward-identity-2 (param i64 i64) (result i64 i64)
        (return_call $identity-2 (local.get 0) (local.get 1))
    )

    (func (export "n-times-identity-0") (param $n i64) (result i64)
        (loop $continue
            (if
                (i64.eqz (local.get $n))
                (then
                    (return (i64.const 0))
                )
            )
            (call $forward-identity-0)
            (local.set $n (i64.sub (local.get $n) (i64.const 1)))
            (br $continue)
        )
        (unreachable)
    )

    (func (export "n-times-identity-1") (param $n i64) (result i64)
        (loop $continue
            (if
                (i64.eqz (local.get $n))
                (then
                    (return (i64.const 0))
                )
            )
            (drop (call $forward-identity-1 (local.get $n)))
            (local.set $n (i64.sub (local.get $n) (i64.const 1)))
            (br $continue)
        )
        (unreachable)
    )

    (func (export "n-times-identity-2") (param $n i64) (result i64)
        (loop $continue
            (if
                (i64.eqz (local.get $n))
                (then
                    (return (i64.const 0))
                )
            )
            (call $forward-identity-2
                (local.get $n) (local.get $n)
            )
            ;; drop all return values from the host function call
            (drop) (drop)
            (local.set $n (i64.sub (local.get $n) (i64.const 1)))
            (br $continue)
        )
        (unreachable)
    )
)
(assert_return (invoke "n-times-identity-0" (i64.const  0)) (i64.const 0))
(assert_return (invoke "n-times-identity-0" (i64.const  1)) (i64.const 0))
(assert_return (invoke "n-times-identity-0" (i64.const 10)) (i64.const 0))
(assert_return (invoke "n-times-identity-1" (i64.const  0)) (i64.const 0))
(assert_return (invoke "n-times-identity-1" (i64.const  1)) (i64.const 0))
(assert_return (invoke "n-times-identity-1" (i64.const 10)) (i64.const 0))
(assert_return (invoke "n-times-identity-2" (i64.const  0)) (i64.const 0))
(assert_return (invoke "n-times-identity-2" (i64.const  1)) (i64.const 0))
(assert_return (invoke "n-times-identity-2" (i64.const 10)) (i64.const 0))
