;; Finding 2: the fused `copy + br_if` operator reads a stale register when the
;; fused comparison takes its input from a stack slot.
;;
;; `i32.eqz (local.get x)` translates to `I32Eq_Rsi { lhs: <slot of x>, rhs: 0 }` whose
;; result is the accumulator register. When this is fused, the comparison is dropped, so
;; `x` only lives in its slot -- the accumulator no longer holds `x`. The fused op still
;; reads the condition from the (now stale) register instead of the slot, so the branch
;; decision becomes independent of `x`.
;;
;; Each module returns one value for `x == 0` and another for `x != 0`. An implementation
;; that ignores `x` (reads the stale register) cannot satisfy both assertions at once,
;; regardless of what the stale register happens to contain.

(module
    (func (export "eqz") (param i32) (result i32)
        (drop
            (br_if 0
                (i32.const 10)
                (i32.eqz (local.get 0))))   ;; take branch iff x == 0
        (i32.const 20)))
(assert_return (invoke "eqz" (i32.const 0)) (i32.const 10)) ;; x == 0 -> taken
(assert_return (invoke "eqz" (i32.const 7)) (i32.const 20)) ;; x != 0 -> not taken

(module
    (func (export "nez") (param i32) (result i32)
        (drop
            (br_if 0
                (i32.const 10)
                (i32.ne (local.get 0) (i32.const 0))))  ;; take branch iff x != 0
        (i32.const 20)))
(assert_return (invoke "nez" (i32.const 7)) (i32.const 10)) ;; x != 0 -> taken
(assert_return (invoke "nez" (i32.const 0)) (i32.const 20)) ;; x == 0 -> not taken
