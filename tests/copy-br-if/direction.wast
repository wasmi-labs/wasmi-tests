;; Finding 1: the fused `copy + br_if` operator uses the wrong branch condition.
;;
;; `try_fuse_copy_branch_eqz` currently maps
;;   `i32.eq x 0` (`I32Eq{rhs:0}`)    -> `Nez`
;;   `i32.ne x 0` (`I32NotEq{rhs:0}`) -> `Eqz`
;; which is inverted. The correct mapping (after dropping the fused comparison and
;; reading its input `x` directly) is:
;;   `i32.eq x 0` -> `Eqz`   (branch iff x == 0)
;;   `i32.ne x 0` -> `Nez`   (branch iff x != 0)
;;
;; The comparison input here is produced in a register (`i32.add` result), so the
;; condition *location* read by the fused op is already correct (`_Rri`); only the
;; branch *direction* is under test. With the current inverted mapping every
;; assertion below returns the opposite value.

(module
    (func (export "eqz") (param i32 i32) (result i32)
        (drop
            (br_if 0
                (i32.const 10)          ;; branch param: returned when the branch is taken
                (i32.eqz                ;; condition: take branch iff (a + b) == 0
                    (i32.add (local.get 0) (local.get 1)))))
        (i32.const 20)))                ;; returned when the branch is NOT taken
(assert_return (invoke "eqz" (i32.const 1) (i32.const -1)) (i32.const 10)) ;; sum == 0 -> taken
(assert_return (invoke "eqz" (i32.const 0) (i32.const 0)) (i32.const 10))  ;; sum == 0 -> taken
(assert_return (invoke "eqz" (i32.const 3) (i32.const 4)) (i32.const 20))  ;; sum != 0 -> not taken

(module
    (func (export "nez") (param i32 i32) (result i32)
        (drop
            (br_if 0
                (i32.const 10)
                (i32.ne                 ;; condition: take branch iff (a + b) != 0
                    (i32.add (local.get 0) (local.get 1))
                    (i32.const 0))))
        (i32.const 20)))
(assert_return (invoke "nez" (i32.const 3) (i32.const 4)) (i32.const 10))  ;; sum != 0 -> taken
(assert_return (invoke "nez" (i32.const 1) (i32.const -1)) (i32.const 20)) ;; sum == 0 -> not taken
(assert_return (invoke "nez" (i32.const 0) (i32.const 0)) (i32.const 20))  ;; sum == 0 -> not taken
