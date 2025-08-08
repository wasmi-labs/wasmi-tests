;; Identity

(module
    (func (export "i32.sdiv(x,1)") (param i32) (result i32)
        (i32.div_s (local.get 0) (i32.const 1))
    )
)
(assert_return (invoke "i32.sdiv(x,1)" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,1)" (i32.const 1)) (i32.const 1))
(assert_return (invoke "i32.sdiv(x,1)" (i32.const -1)) (i32.const -1))
(assert_return (invoke "i32.sdiv(x,1)" (i32.const 42)) (i32.const 42))
(assert_return (invoke "i32.sdiv(x,1)" (i32.const 0x7FFF_FFFF)) (i32.const 0x7FFF_FFFF))
(assert_return (invoke "i32.sdiv(x,1)" (i32.const 0x8000_0000)) (i32.const 0x8000_0000))

;; Negate

(module
    (func (export "i32.sdiv(x,-1)") (param i32) (result i32)
        (i32.div_s (local.get 0) (i32.const -1))
    )
)
(assert_return (invoke "i32.sdiv(x,-1)" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,-1)" (i32.const 1)) (i32.const -1))
(assert_return (invoke "i32.sdiv(x,-1)" (i32.const -1)) (i32.const 1))
(assert_return (invoke "i32.sdiv(x,-1)" (i32.const 42)) (i32.const -42))
(assert_return (invoke "i32.sdiv(x,-1)" (i32.const 0x7FFF_FFFF)) (i32.const 0x8000_0001))
(assert_trap   (invoke "i32.sdiv(x,-1)" (i32.const 0x8000_0000)) "integer overflow")

;; Neutral

(module
    (func (export "i32.sdiv(x,x)") (param i32) (result i32)
        (i32.div_s (local.get 0) (local.get 0))
    )
)
(assert_trap   (invoke "i32.sdiv(x,x)" (i32.const 0)) "divide by zero")
(assert_return (invoke "i32.sdiv(x,x)" (i32.const 1)) (i32.const 1))
(assert_return (invoke "i32.sdiv(x,x)" (i32.const -1)) (i32.const 1))
(assert_return (invoke "i32.sdiv(x,x)" (i32.const 42)) (i32.const 1))
(assert_return (invoke "i32.sdiv(x,x)" (i32.const 0x7FFF_FFFF)) (i32.const 1))
(assert_return (invoke "i32.sdiv(x,x)" (i32.const 0x8000_0000)) (i32.const 1))

;; Divide by Power-of-Two

(module
    (func (export "i32.sdiv(x,2)") (param i32) (result i32)
        (i32.div_s (local.get 0) (i32.const 2))
    )
)
(assert_return (invoke "i32.sdiv(x,2)" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,2)" (i32.const 1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,2)" (i32.const -1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,2)" (i32.const 42)) (i32.const 21))
(assert_return (invoke "i32.sdiv(x,2)" (i32.const 0x7FFF_FFFF)) (i32.const 0x3FFF_FFFF))
(assert_return (invoke "i32.sdiv(x,2)" (i32.const 0x8000_0000)) (i32.const 0xC000_0000))

;; Divide by `i32::MIN`

(module
    (func (export "i32.sdiv(x,min)") (param i32) (result i32)
        (i32.div_s (local.get 0) (i32.const 0x8000_0000))
    )
)
(assert_return (invoke "i32.sdiv(x,min)" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,min)" (i32.const 1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,min)" (i32.const -1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,min)" (i32.const 42)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,min)" (i32.const 0x7FFF_FFFF)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,min)" (i32.const 0x8000_0000)) (i32.const 1))

;; Divide Zero

(module
    (func (export "i32.sdiv(0,x)") (param i32) (result i32)
        (i32.div_s (i32.const 0) (local.get 0))
    )
)
(assert_trap   (invoke "i32.sdiv(0,x)" (i32.const 0)) "divide by zero")
(assert_return (invoke "i32.sdiv(0,x)" (i32.const 1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(0,x)" (i32.const -1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(0,x)" (i32.const 42)) (i32.const 0))
(assert_return (invoke "i32.sdiv(0,x)" (i32.const 0x7FFF_FFFF)) (i32.const 0))
(assert_return (invoke "i32.sdiv(0,x)" (i32.const 0x8000_0000)) (i32.const 0))

;; Divide `i32::MAX`

(module
    (func (export "i32.sdiv(max,x)") (param i32) (result i32)
        (i32.div_s (i32.const 0x7FFF_FFFF) (local.get 0))
    )
)
(assert_trap   (invoke "i32.sdiv(max,x)" (i32.const 0)) "divide by zero")
(assert_return (invoke "i32.sdiv(max,x)" (i32.const 1)) (i32.const 0x7FFF_FFFF))
(assert_return (invoke "i32.sdiv(max,x)" (i32.const -1)) (i32.const 0x8000_0001))
(assert_return (invoke "i32.sdiv(max,x)" (i32.const 42)) (i32.const 51130563)) ;; i32::MAX / 42
(assert_return (invoke "i32.sdiv(max,x)" (i32.const 0x7FFF_FFFF)) (i32.const 1))
(assert_return (invoke "i32.sdiv(max,x)" (i32.const 0x8000_0000)) (i32.const 0))

;; Small `rhs` immediate

(module
    (func (export "i32.sdiv(x,10)") (param i32) (result i32)
        (i32.div_s (local.get 0) (i32.const 10))
    )
)
(assert_return (invoke "i32.sdiv(x,10)" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,10)" (i32.const 1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,10)" (i32.const -1)) (i32.const 0))
(assert_return (invoke "i32.sdiv(x,10)" (i32.const 42)) (i32.const 4))
(assert_return (invoke "i32.sdiv(x,10)" (i32.const 0x7FFF_FFFF)) (i32.const 214748364))
(assert_return (invoke "i32.sdiv(x,10)" (i32.const 0x8000_0000)) (i32.const -214748364))

;; Small `lhs` immediate

(module
    (func (export "i32.sdiv(100,x)") (param i32) (result i32)
        (i32.div_s (i32.const 100) (local.get 0))
    )
)
(assert_trap   (invoke "i32.sdiv(100,x)" (i32.const 0)) "divide by zero")
(assert_return (invoke "i32.sdiv(100,x)" (i32.const 1)) (i32.const 100))
(assert_return (invoke "i32.sdiv(100,x)" (i32.const -1)) (i32.const -100))
(assert_return (invoke "i32.sdiv(100,x)" (i32.const 42)) (i32.const 2))
(assert_return (invoke "i32.sdiv(100,x)" (i32.const 100)) (i32.const 1))
(assert_return (invoke "i32.sdiv(100,x)" (i32.const 0x7FFF_FFFF)) (i32.const 0))
(assert_return (invoke "i32.sdiv(100,x)" (i32.const 0x8000_0000)) (i32.const 0))

;; ;; Constant Folding

(module
    (func (export "i32.sdiv(0,0)") (result i32)
        (i32.div_s (i32.const 0) (i32.const 0))
    )
)
(assert_trap (invoke "i32.sdiv(0,0)") "divide by zero")

(module
    (func (export "i32.sdiv(0,1)") (result i32)
        (i32.div_s (i32.const 0) (i32.const 1))
    )
)
(assert_return (invoke "i32.sdiv(0,1)") (i32.const 0))

(module
    (func (export "i32.sdiv(0,1)") (result i32)
        (i32.div_s (i32.const 0) (i32.const 1))
    )
)
(assert_return (invoke "i32.sdiv(0,1)") (i32.const 0))

(module
    (func (export "i32.sdiv(1,0)") (result i32)
        (i32.div_s (i32.const 1) (i32.const 0))
    )
)
(assert_trap (invoke "i32.sdiv(1,0)") "divide by zero")

(module
    (func (export "i32.sdiv(1,1)") (result i32)
        (i32.div_s (i32.const 1) (i32.const 1))
    )
)
(assert_return (invoke "i32.sdiv(1,1)") (i32.const 1))

(module
    (func (export "i32.sdiv(3,-1)") (result i32)
        (i32.div_s (i32.const 3) (i32.const -1))
    )
)
(assert_return (invoke "i32.sdiv(3,-1)") (i32.const -3))

(module
    (func (export "i32.sdiv(-1,3)") (result i32)
        (i32.div_s (i32.const -1) (i32.const 3))
    )
)
(assert_return (invoke "i32.sdiv(-1,3)") (i32.const 0))

(module
    (func (export "i32.sdiv(12,4)") (result i32)
        (i32.div_s (i32.const 12) (i32.const 4))
    )
)
(assert_return (invoke "i32.sdiv(12,4)") (i32.const 3))

(module
    (func (export "i32.sdiv(-12,-3)") (result i32)
        (i32.div_s (i32.const -12) (i32.const -3))
    )
)
(assert_return (invoke "i32.sdiv(-12,-3)") (i32.const 4))

(module
    (func (export "i32.sdiv(min,-1)") (result i32)
        (i32.div_s (i32.const 0x8000_0000) (i32.const -1))
    )
)
(assert_trap (invoke "i32.sdiv(min,-1)") "integer overflow")

(module
    (func (export "i32.sdiv(max,-1)") (result i32)
        (i32.div_s (i32.const 0x7FFF_FFFF) (i32.const -1))
    )
)
(assert_return (invoke "i32.sdiv(max,-1)") (i32.const 0x8000_0001))
