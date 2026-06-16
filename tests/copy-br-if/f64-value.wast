;; Finding 3: `select_f64_copy_branch_eqz_op` is a copy-paste of the f32 variant.
;;
;; It asserts `ValType::F32`, maps the value with `f32::from`, and emits `f32_*` ops for an
;; f64 branch-param value -- truncating the f64 to 32 bits (and tripping a `debug_assert`).
;;
;; The buggy f64 `eqz` selector is only reached when the fusion resolves to `Eqz`. Because
;; the `Eqz`/`Nez` direction mapping is itself being fixed (Finding 1), the two modules
;; below cover both routings so the f64 `eqz` path is exercised whichever way the mapping
;; resolves:
;;   - `eq` (i32.eqz):     reaches the f64 `eqz` selector *after* the direction fix.
;;   - `ne` (i32.ne x 0):  reaches the f64 `eqz` selector *before* the direction fix.
;; The expected values also encode the correct branch direction.

(module
    (func (export "eq") (param i32 i32) (result f64)
        (drop
            (br_if 0
                (f64.const 1.5)         ;; f64 branch param value
                (i32.eqz (i32.add (local.get 0) (local.get 1)))))  ;; take branch iff (a + b) == 0
        (f64.const 2.5)))
(assert_return (invoke "eq" (i32.const 1) (i32.const -1)) (f64.const 1.5)) ;; sum == 0 -> taken
(assert_return (invoke "eq" (i32.const 3) (i32.const 4)) (f64.const 2.5))  ;; sum != 0 -> not taken

(module
    (func (export "ne") (param i32 i32) (result f64)
        (drop
            (br_if 0
                (f64.const 1.5)
                (i32.ne (i32.add (local.get 0) (local.get 1)) (i32.const 0))))  ;; take branch iff (a + b) != 0
        (f64.const 2.5)))
(assert_return (invoke "ne" (i32.const 3) (i32.const 4)) (f64.const 1.5)) ;; sum != 0 -> taken
(assert_return (invoke "ne" (i32.const 1) (i32.const -1)) (f64.const 2.5)) ;; sum == 0 -> not taken
