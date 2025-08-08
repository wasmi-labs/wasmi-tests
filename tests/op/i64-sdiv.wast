;; Identity

(module
    (func (export "i64.sdiv(x,1)") (param i64) (result i64)
        (i64.div_s (local.get 0) (i64.const 1))
    )
)
(assert_return (invoke "i64.sdiv(x,1)" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,1)" (i64.const 1)) (i64.const 1))
(assert_return (invoke "i64.sdiv(x,1)" (i64.const -1)) (i64.const -1))
(assert_return (invoke "i64.sdiv(x,1)" (i64.const 42)) (i64.const 42))
(assert_return (invoke "i64.sdiv(x,1)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 0x7FFF_FFFF_FFFF_FFFF))
(assert_return (invoke "i64.sdiv(x,1)" (i64.const 0x8000_0000_0000_0000)) (i64.const 0x8000_0000_0000_0000))

;; Negate

(module
    (func (export "i64.sdiv(x,-1)") (param i64) (result i64)
        (i64.div_s (local.get 0) (i64.const -1))
    )
)
(assert_return (invoke "i64.sdiv(x,-1)" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,-1)" (i64.const 1)) (i64.const -1))
(assert_return (invoke "i64.sdiv(x,-1)" (i64.const -1)) (i64.const 1))
(assert_return (invoke "i64.sdiv(x,-1)" (i64.const 42)) (i64.const -42))
(assert_return (invoke "i64.sdiv(x,-1)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 0x8000_0000_0000_0001))
(assert_trap   (invoke "i64.sdiv(x,-1)" (i64.const 0x8000_0000_0000_0000)) "integer overflow")

;; Neutral

(module
    (func (export "i64.sdiv(x,x)") (param i64) (result i64)
        (i64.div_s (local.get 0) (local.get 0))
    )
)
(assert_trap   (invoke "i64.sdiv(x,x)" (i64.const 0)) "divide by zero")
(assert_return (invoke "i64.sdiv(x,x)" (i64.const 1)) (i64.const 1))
(assert_return (invoke "i64.sdiv(x,x)" (i64.const -1)) (i64.const 1))
(assert_return (invoke "i64.sdiv(x,x)" (i64.const 42)) (i64.const 1))
(assert_return (invoke "i64.sdiv(x,x)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 1))
(assert_return (invoke "i64.sdiv(x,x)" (i64.const 0x8000_0000_0000_0000)) (i64.const 1))

;; Divide by Power-of-Two

(module
    (func (export "i64.sdiv(x,2)") (param i64) (result i64)
        (i64.div_s (local.get 0) (i64.const 2))
    )
)
(assert_return (invoke "i64.sdiv(x,2)" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,2)" (i64.const 1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,2)" (i64.const -1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,2)" (i64.const 42)) (i64.const 21))
(assert_return (invoke "i64.sdiv(x,2)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 0x3FFF_FFFF_FFFF_FFFF))
(assert_return (invoke "i64.sdiv(x,2)" (i64.const 0x8000_0000_0000_0000)) (i64.const 0xC000_0000_0000_0000))

;; Divide by `i64::MIN`

(module
    (func (export "i64.sdiv(x,min)") (param i64) (result i64)
        (i64.div_s (local.get 0) (i64.const 0x8000_0000_0000_0000))
    )
)
(assert_return (invoke "i64.sdiv(x,min)" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,min)" (i64.const 1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,min)" (i64.const -1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,min)" (i64.const 42)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,min)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,min)" (i64.const 0x8000_0000_0000_0000)) (i64.const 1))

;; Divide Zero

(module
    (func (export "i64.sdiv(0,x)") (param i64) (result i64)
        (i64.div_s (i64.const 0) (local.get 0))
    )
)
(assert_trap   (invoke "i64.sdiv(0,x)" (i64.const 0)) "divide by zero")
(assert_return (invoke "i64.sdiv(0,x)" (i64.const 1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(0,x)" (i64.const -1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(0,x)" (i64.const 42)) (i64.const 0))
(assert_return (invoke "i64.sdiv(0,x)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 0))
(assert_return (invoke "i64.sdiv(0,x)" (i64.const 0x8000_0000_0000_0000)) (i64.const 0))

;; Divide `i64::MAX`

(module
    (func (export "i64.sdiv(max,x)") (param i64) (result i64)
        (i64.div_s (i64.const 0x7FFF_FFFF_FFFF_FFFF) (local.get 0))
    )
)
(assert_trap   (invoke "i64.sdiv(max,x)" (i64.const 0)) "divide by zero")
(assert_return (invoke "i64.sdiv(max,x)" (i64.const 1)) (i64.const 0x7FFF_FFFF_FFFF_FFFF))
(assert_return (invoke "i64.sdiv(max,x)" (i64.const -1)) (i64.const 0x8000_0000_0000_0001))
(assert_return (invoke "i64.sdiv(max,x)" (i64.const 42)) (i64.const 219604096115589900)) ;; i64::MAX / 42
(assert_return (invoke "i64.sdiv(max,x)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 1))
(assert_return (invoke "i64.sdiv(max,x)" (i64.const 0x8000_0000_0000_0000)) (i64.const 0))

;; Small `rhs` immediate

(module
    (func (export "i64.sdiv(x,10)") (param i64) (result i64)
        (i64.div_s (local.get 0) (i64.const 10))
    )
)
(assert_return (invoke "i64.sdiv(x,10)" (i64.const 0)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,10)" (i64.const 1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,10)" (i64.const -1)) (i64.const 0))
(assert_return (invoke "i64.sdiv(x,10)" (i64.const 42)) (i64.const 4))
(assert_return (invoke "i64.sdiv(x,10)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 922337203685477580))
(assert_return (invoke "i64.sdiv(x,10)" (i64.const 0x8000_0000_0000_0000)) (i64.const -922337203685477580))

;; Small `lhs` immediate

(module
    (func (export "i64.sdiv(100,x)") (param i64) (result i64)
        (i64.div_s (i64.const 100) (local.get 0))
    )
)
(assert_trap   (invoke "i64.sdiv(100,x)" (i64.const 0)) "divide by zero")
(assert_return (invoke "i64.sdiv(100,x)" (i64.const 1)) (i64.const 100))
(assert_return (invoke "i64.sdiv(100,x)" (i64.const -1)) (i64.const -100))
(assert_return (invoke "i64.sdiv(100,x)" (i64.const 42)) (i64.const 2))
(assert_return (invoke "i64.sdiv(100,x)" (i64.const 100)) (i64.const 1))
(assert_return (invoke "i64.sdiv(100,x)" (i64.const 0x7FFF_FFFF_FFFF_FFFF)) (i64.const 0))
(assert_return (invoke "i64.sdiv(100,x)" (i64.const 0x8000_0000_0000_0000)) (i64.const 0))

;; ;; Constant Folding

(module
    (func (export "i64.sdiv(0,0)") (result i64)
        (i64.div_s (i64.const 0) (i64.const 0))
    )
)
(assert_trap (invoke "i64.sdiv(0,0)") "divide by zero")

(module
    (func (export "i64.sdiv(0,1)") (result i64)
        (i64.div_s (i64.const 0) (i64.const 1))
    )
)
(assert_return (invoke "i64.sdiv(0,1)") (i64.const 0))

(module
    (func (export "i64.sdiv(0,1)") (result i64)
        (i64.div_s (i64.const 0) (i64.const 1))
    )
)
(assert_return (invoke "i64.sdiv(0,1)") (i64.const 0))

(module
    (func (export "i64.sdiv(1,0)") (result i64)
        (i64.div_s (i64.const 1) (i64.const 0))
    )
)
(assert_trap (invoke "i64.sdiv(1,0)") "divide by zero")

(module
    (func (export "i64.sdiv(1,1)") (result i64)
        (i64.div_s (i64.const 1) (i64.const 1))
    )
)
(assert_return (invoke "i64.sdiv(1,1)") (i64.const 1))

(module
    (func (export "i64.sdiv(3,-1)") (result i64)
        (i64.div_s (i64.const 3) (i64.const -1))
    )
)
(assert_return (invoke "i64.sdiv(3,-1)") (i64.const -3))

(module
    (func (export "i64.sdiv(-1,3)") (result i64)
        (i64.div_s (i64.const -1) (i64.const 3))
    )
)
(assert_return (invoke "i64.sdiv(-1,3)") (i64.const 0))

(module
    (func (export "i64.sdiv(12,4)") (result i64)
        (i64.div_s (i64.const 12) (i64.const 4))
    )
)
(assert_return (invoke "i64.sdiv(12,4)") (i64.const 3))

(module
    (func (export "i64.sdiv(-12,-3)") (result i64)
        (i64.div_s (i64.const -12) (i64.const -3))
    )
)
(assert_return (invoke "i64.sdiv(-12,-3)") (i64.const 4))

(module
    (func (export "i64.sdiv(min,-1)") (result i64)
        (i64.div_s (i64.const 0x8000_0000_0000_0000) (i64.const -1))
    )
)
(assert_trap (invoke "i64.sdiv(min,-1)") "integer overflow")

(module
    (func (export "i64.sdiv(max,-1)") (result i64)
        (i64.div_s (i64.const 0x7FFF_FFFF_FFFF_FFFF) (i64.const -1))
    )
)
(assert_return (invoke "i64.sdiv(max,-1)") (i64.const 0x8000_0000_0000_0001))
