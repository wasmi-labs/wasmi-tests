;; Regression guard: a non-fused `copy + br_if` must branch on the *real* condition operand.
;;
;; When the condition is not a fusable `i32.{eq,ne}` against 0, no comparison is fused, so the
;; fused-copy fallback is used. That fallback must still read the condition from its actual
;; location (a slot, or the accumulator) rather than assuming a register. A bug that hardcoded
;; the register condition in the fallback made the `slot` case below ignore `x`.

;; condition is a local (slot) -> non-fused, condition must be read from the slot
(module
    (func (export "slot") (param i32) (result i32)
        (drop (br_if 0 (i32.const 10) (local.get 0)))   ;; take branch iff x != 0
        (i32.const 20)))
(assert_return (invoke "slot" (i32.const 0)) (i32.const 20)) ;; x == 0 -> not taken
(assert_return (invoke "slot" (i32.const 1)) (i32.const 10)) ;; x != 0 -> taken
(assert_return (invoke "slot" (i32.const 7)) (i32.const 10)) ;; x != 0 -> taken

;; condition is a register value (`i32.add` result, not a comparison) -> non-fused, read from register
(module
    (func (export "reg") (param i32 i32) (result i32)
        (drop (br_if 0 (i32.const 10) (i32.add (local.get 0) (local.get 1))))  ;; take branch iff (a + b) != 0
        (i32.const 20)))
(assert_return (invoke "reg" (i32.const 0) (i32.const 0)) (i32.const 20))  ;; sum == 0 -> not taken
(assert_return (invoke "reg" (i32.const 1) (i32.const 2)) (i32.const 10))  ;; sum != 0 -> taken
(assert_return (invoke "reg" (i32.const 5) (i32.const -5)) (i32.const 20)) ;; sum == 0 -> not taken
