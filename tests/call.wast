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
    (func (export "call-identity-0")
        (call $identity-0)
    )
)
(assert_return
    (invoke "call-identity-0")
)

(module
    (import "wasmitest" "identity-1" (func $identity-1 (param i64) (result i64)))
    (func (export "call-identity-1") (param i64) (result i64)
        (call $identity-1
            (local.get 0)
        )
    )
)
(assert_return
    (invoke "call-identity-1" (i64.const 0))
    (i64.const 0)
)
(assert_return
    (invoke "call-identity-1" (i64.const 1))
    (i64.const 1)
)
(assert_return
    (invoke "call-identity-1" (i64.const -1))
    (i64.const -1)
)

(module
    (import "wasmitest" "identity-2" (func $identity-2 (param i64 i64) (result i64 i64)))
    (func (export "call-identity-2") (param i64 i64) (result i64 i64)
        (call $identity-2
            (local.get 0)
            (local.get 1)
        )
    )
)
(assert_return
    (invoke "call-identity-2" (i64.const 0) (i64.const 0))
    (i64.const 0) (i64.const 0)
)
(assert_return
    (invoke "call-identity-2" (i64.const 0) (i64.const 1))
    (i64.const 0) (i64.const 1)
)
(assert_return
    (invoke "call-identity-2" (i64.const 1) (i64.const 0))
    (i64.const 1) (i64.const 0)
)
(assert_return
    (invoke "call-identity-2" (i64.const 1) (i64.const 1))
    (i64.const 1) (i64.const 1)
)

(module
    (import "wasmitest" "offset-1" (func $offset-1 (param i64) (result i64)))
    (func (export "call-offset-1") (param i64) (result i64)
        (call $offset-1
            (local.get 0)
        )
    )
)
(assert_return
    (invoke "call-offset-1" (i64.const 0))
    (i64.const 1)
)
(assert_return
    (invoke "call-offset-1" (i64.const 1))
    (i64.const 2)
)
(assert_return
    (invoke "call-offset-1" (i64.const -1))
    (i64.const 0)
)

(module
    (import "wasmitest" "offset-2" (func $offset-2 (param i64 i64) (result i64 i64)))
    (func (export "call-offset-2") (param i64 i64) (result i64 i64)
        (call $offset-2
            (local.get 0)
            (local.get 1)
        )
    )
)
(assert_return
    (invoke "call-offset-2" (i64.const 0) (i64.const 0))
    (i64.const 1) (i64.const 2)
)
(assert_return
    (invoke "call-offset-2" (i64.const 0) (i64.const 1))
    (i64.const 1) (i64.const 3)
)
(assert_return
    (invoke "call-offset-2" (i64.const 1) (i64.const 0))
    (i64.const 2) (i64.const 2)
)
(assert_return
    (invoke "call-offset-2" (i64.const 1) (i64.const 1))
    (i64.const 2) (i64.const 3)
)

(module
    (import "wasmitest" "sum-3" (func $sum-3 (param i64 i64 i64) (result i64)))
    (func (export "call-sum-3") (param i64 i64 i64) (result i64)
        (call $sum-3
            (local.get 0)
            (local.get 1)
            (local.get 2)
        )
    )
)
(assert_return
    (invoke "call-sum-3" (i64.const 0) (i64.const 0) (i64.const 0))
    (i64.const 0)
)
(assert_return
    (invoke "call-sum-3" (i64.const 1) (i64.const 2) (i64.const 3))
    (i64.const 6)
)
(assert_return
    (invoke "call-sum-3" (i64.const -1) (i64.const 0) (i64.const 1))
    (i64.const 0)
)
(assert_return
    (invoke "call-sum-3" (i64.const -1) (i64.const -1) (i64.const -1))
    (i64.const -3)
)

(module
    (import "wasmitest" "iota-3" (func $iota-3 (param i64) (result i64 i64 i64)))
    (func (export "call-iota-3") (param i64) (result i64 i64 i64)
        (call $iota-3
            (local.get 0)
        )
    )
)
(assert_return
    (invoke "call-iota-3" (i64.const 0))
    (i64.const 1) (i64.const 2) (i64.const 3)
)
(assert_return
    (invoke "call-iota-3" (i64.const 100))
    (i64.const 101) (i64.const 102) (i64.const 103)
)
(assert_return
    (invoke "call-iota-3" (i64.const -3))
    (i64.const -2) (i64.const -1) (i64.const 0)
)
