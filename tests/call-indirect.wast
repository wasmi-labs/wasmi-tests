(module
    ;; We define this module to check if Wasmi's expected test module setup was successful.
    (import "wasmitest" "identity-0" (func $identity-0))
    (import "wasmitest" "identity-1" (func $identity-1 (param i64) (result i64)))
    (import "wasmitest" "identity-2" (func $identity-2 (param i64 i64) (result i64 i64)))
    (import "wasmitest" "offset-1" (func $offset-1 (param i64) (result i64)))
    (import "wasmitest" "offset-2" (func $offset-2 (param i64 i64) (result i64 i64)))
    (import "wasmitest" "sum-3" (func $sum-3 (param i64 i64 i64) (result i64)))
    (import "wasmitest" "iota-3" (func $iota-3 (param i64) (result i64 i64 i64)))

    (table funcref
        (elem
            $identity-0 ;; 0
            $identity-1 ;; 1
            $identity-2 ;; 2
            $offset-1   ;; 3
            $offset-2   ;; 4
            $sum-3      ;; 5
            $iota-3     ;; 6
        )
    )
)

(module
    (type $ty (func))
    (import "wasmitest" "identity-0" (func $identity-0))
    (table $t funcref (elem $identity-0))
    (func (export "call-identity-0") (type $ty)
        (call_indirect $t (type $ty)
            (i32.const 0) ;; index
        )
    )
)
(assert_return
    (invoke "call-identity-0")
)

(module
    (type $ty (func (param i64) (result i64)))
    (import "wasmitest" "identity-1" (func $identity-1 (type $ty)))
    (table $t funcref (elem $identity-1))
    (func (export "call-identity-1") (type $ty)
        (call_indirect $t (type $ty)
            (local.get 0)
            (i32.const 0) ;; index
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
    (type $ty (func (param i64 i64) (result i64 i64)))
    (import "wasmitest" "identity-2" (func $identity-2 (type $ty)))
    (table $t funcref (elem $identity-2))
    (func (export "call-identity-2") (type $ty)
        (call_indirect $t (type $ty)
            (local.get 0)
            (local.get 1)
            (i32.const 0) ;; index
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
    (type $ty (func (param i64) (result i64)))
    (import "wasmitest" "offset-1" (func $offset-1 (type $ty)))
    (table $t funcref (elem $offset-1))
    (func (export "call-offset-1") (type $ty)
        (call_indirect $t (type $ty)
            (local.get 0)
            (i32.const 0) ;; index
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
    (type $ty (func (param i64 i64) (result i64 i64)))
    (import "wasmitest" "offset-2" (func $offset-2 (type $ty)))
    (table $t funcref (elem $offset-2))
    (func (export "call-offset-2") (type $ty)
        (call_indirect $t (type $ty)
            (local.get 0)
            (local.get 1)
            (i32.const 0) ;; index
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
    (type $ty (func (param i64 i64 i64) (result i64)))
    (import "wasmitest" "sum-3" (func $sum-3 (type $ty)))
    (table $t funcref (elem $sum-3))
    (func (export "call-sum-3") (type $ty)
        (call_indirect $t (type $ty)
            (local.get 0)
            (local.get 1)
            (local.get 2)
            (i32.const 0) ;; index
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
    (type $ty (func (param i64) (result i64 i64 i64)))
    (import "wasmitest" "iota-3" (func $iota-3 (type $ty)))
    (table $t funcref (elem $iota-3))
    (func (export "call-iota-3") (type $ty)
        (call_indirect $t (type $ty)
            (local.get 0)
            (i32.const 0) ;; index
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
