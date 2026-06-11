;; Regression tests: cross-instance calls must track and restore the correct
;; instance when the called function returns.
;;
;; This tests all 4 call operators: `call`, `call_indirect`, `return_call`
;; and `return_call_indirect`. Each test group uses its own set of modules
;; with namespaced names so that the groups stay independent of each other.
;;
;; Common setup per test group: three modules, each with its own mutable
;; global holding a distinct value: A.$val = 1, B.$val = 2, C.$val = 3.
;;
;; Reading a module's own global after a cross-instance call has returned
;; observes whether the engine restored the correct instance.

;; ---------------------------------------------------------------------------
;; `call`
;;
;; Nested calls allow to observe instance restoration at intermediate call
;; depths, unlike tail calls.
;; ---------------------------------------------------------------------------

(module $call-A
    (global $val (mut i32) (i32.const 1))
    (func $g (export "g") (result i32)
        (global.get $val)
    )
    (func (export "g-via-internal-call") (result i32)
        ;; Internal call within A: must not disturb instance tracking.
        (call $g)
    )
)
(register "call-A" $call-A)

(module $call-B
    (import "call-A" "g" (func $g (result i32)))
    (import "call-A" "g-via-internal-call" (func $g-via-internal-call (result i32)))
    (global $val (mut i32) (i32.const 2))
    ;; Chain: B.f --call--> A.g
    (func (export "f") (result i32)
        (call $g)
    )
    ;; Chain: B.f-multi-hop --call--> A.g-via-internal-call --call--> A.$g
    (func (export "f-multi-hop") (result i32)
        (call $g-via-internal-call)
    )
    ;; Returns B's own global (= 2) after the cross-instance call to A.g has
    ;; returned. This observes instance restoration at an intermediate call
    ;; depth.
    (func (export "own-global-after-call") (result i32)
        (call $g)
        (drop)
        (global.get $val)
    )
)
(register "call-B" $call-B)

(module $call-C
    (import "call-B" "f" (func $f (result i32)))
    (import "call-B" "f-multi-hop" (func $f-multi-hop (result i32)))
    (import "call-B" "own-global-after-call" (func $f-own-global (result i32)))
    (global $val (mut i32) (i32.const 3))
    (global $tmp (mut i32) (i32.const 0))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $mid))
    ;; Returns the result of the call chain: A's global (= 1).
    ;;
    ;; Passes even with broken instance restoration since the calls
    ;; themselves switch to the callee instances correctly.
    (func (export "call-result") (result i32)
        (call $f)
    )
    ;; Returns C's own global (= 3) after the cross-instance call chain
    ;; has returned.
    ;;
    ;; A buggy engine restores B's (or A's) instance instead of C's and thus
    ;; reads the wrong global here.
    (func (export "own-global-after-call") (result i32)
        (call $f)
        (drop)
        (global.get $val)
    )
    ;; Same as `own-global-after-call` but with an additional internal call
    ;; hop inside A.
    (func (export "own-global-after-multi-hop") (result i32)
        (call $f-multi-hop)
        (drop)
        (global.get $val)
    )
    ;; Forwards B's own restoration check (= 2): B reads its own global after
    ;; its cross-instance call to A.g returned.
    (func (export "nested-own-global") (result i32)
        (call $f-own-global)
    )
    ;; Writes C's own global before the chain and reads it back afterwards.
    (func (export "own-global-roundtrip") (result i32)
        (global.set $tmp (i32.const 42))
        (call $f)
        (drop)
        (global.get $tmp)
    )
    ;; Chain: main --call_indirect--> C.$mid --call--> B.f --call--> A.g
    ;;
    ;; The frame of C.$mid is created by a same-instance indirect call and
    ;; thus carries no instance restoration obligation. This must not disturb
    ;; the restoration of C after the cross-instance calls have returned.
    (func $mid (result i32)
        (call $f)
    )
    (func (export "own-global-after-indirect-entry") (result i32)
        (call_indirect (type $ret-i32) (i32.const 0))
        (drop)
        (global.get $val)
    )
)

(assert_return (invoke $call-C "call-result") (i32.const 1))
(assert_return (invoke $call-C "own-global-after-call") (i32.const 3))
(assert_return (invoke $call-C "own-global-after-multi-hop") (i32.const 3))
(assert_return (invoke $call-C "nested-own-global") (i32.const 2))
(assert_return (invoke $call-C "own-global-roundtrip") (i32.const 42))
(assert_return (invoke $call-C "own-global-after-indirect-entry") (i32.const 3))

;; ---------------------------------------------------------------------------
;; `call_indirect`
;;
;; Mirrors the `call` test group but performs all calls via `call_indirect`.
;; ---------------------------------------------------------------------------

(module $call_indirect-A
    (global $val (mut i32) (i32.const 1))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $g))
    (func $g (export "g") (result i32)
        (global.get $val)
    )
    (func (export "g-via-internal-call") (result i32)
        ;; Same-instance indirect call within A: must not disturb instance
        ;; tracking.
        (call_indirect (type $ret-i32) (i32.const 0))
    )
)
(register "call_indirect-A" $call_indirect-A)

(module $call_indirect-B
    (import "call_indirect-A" "g" (func $g (result i32)))
    (import "call_indirect-A" "g-via-internal-call" (func $g-via-internal-call (result i32)))
    (global $val (mut i32) (i32.const 2))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $g $g-via-internal-call))
    ;; Chain: B.f --call_indirect--> A.g (via B's table)
    (func (export "f") (result i32)
        (call_indirect (type $ret-i32) (i32.const 0))
    )
    ;; Chain:
    ;;
    ;; B.f-multi-hop --call_indirect--> A.g-via-internal-call
    ;;               --call_indirect--> A.$g
    (func (export "f-multi-hop") (result i32)
        (call_indirect (type $ret-i32) (i32.const 1))
    )
    ;; Returns B's own global (= 2) after the cross-instance indirect call to
    ;; A.g has returned. This observes instance restoration at an intermediate
    ;; call depth.
    (func (export "own-global-after-call") (result i32)
        (call_indirect (type $ret-i32) (i32.const 0))
        (drop)
        (global.get $val)
    )
)
(register "call_indirect-B" $call_indirect-B)

(module $call_indirect-C
    (import "call_indirect-B" "f" (func $f (result i32)))
    (import "call_indirect-B" "f-multi-hop" (func $f-multi-hop (result i32)))
    (import "call_indirect-B" "own-global-after-call" (func $f-own-global (result i32)))
    (global $val (mut i32) (i32.const 3))
    (global $tmp (mut i32) (i32.const 0))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $mid $f $f-multi-hop $f-own-global))
    ;; Returns the result of the call chain: A's global (= 1).
    (func (export "call-result") (result i32)
        (call_indirect (type $ret-i32) (i32.const 1))
    )
    ;; Returns C's own global (= 3) after the cross-instance call chain
    ;; has returned.
    (func (export "own-global-after-call") (result i32)
        (call_indirect (type $ret-i32) (i32.const 1))
        (drop)
        (global.get $val)
    )
    ;; Same as `own-global-after-call` but with an additional same-instance
    ;; indirect call hop inside A.
    (func (export "own-global-after-multi-hop") (result i32)
        (call_indirect (type $ret-i32) (i32.const 2))
        (drop)
        (global.get $val)
    )
    ;; Forwards B's own restoration check (= 2): B reads its own global after
    ;; its cross-instance indirect call to A.g returned.
    (func (export "nested-own-global") (result i32)
        (call_indirect (type $ret-i32) (i32.const 3))
    )
    ;; Writes C's own global before the chain and reads it back afterwards.
    (func (export "own-global-roundtrip") (result i32)
        (global.set $tmp (i32.const 42))
        (call_indirect (type $ret-i32) (i32.const 1))
        (drop)
        (global.get $tmp)
    )
    ;; Chain:
    ;;
    ;; main --call_indirect--> C.$mid --call_indirect--> B.f
    ;;      --call_indirect--> A.g
    ;;
    ;; The frame of C.$mid is created by a same-instance indirect call and
    ;; thus carries no instance restoration obligation. This must not disturb
    ;; the restoration of C after the cross-instance calls have returned.
    (func $mid (result i32)
        (call_indirect (type $ret-i32) (i32.const 1))
    )
    (func (export "own-global-after-indirect-entry") (result i32)
        (call_indirect (type $ret-i32) (i32.const 0))
        (drop)
        (global.get $val)
    )
)

(assert_return (invoke $call_indirect-C "call-result") (i32.const 1))
(assert_return (invoke $call_indirect-C "own-global-after-call") (i32.const 3))
(assert_return (invoke $call_indirect-C "own-global-after-multi-hop") (i32.const 3))
(assert_return (invoke $call_indirect-C "nested-own-global") (i32.const 2))
(assert_return (invoke $call_indirect-C "own-global-roundtrip") (i32.const 42))
(assert_return (invoke $call_indirect-C "own-global-after-indirect-entry") (i32.const 3))

;; ---------------------------------------------------------------------------
;; `return_call`
;; ---------------------------------------------------------------------------

(module $return_call-A
    (global $val (mut i32) (i32.const 1))
    (func $g (export "g") (result i32)
        (global.get $val)
    )
    (func (export "g-via-internal-tail") (result i32)
        ;; Internal tail call within A: must carry over the instance
        ;; restoration obligation unchanged.
        (return_call $g)
    )
)
(register "return_call-A" $return_call-A)

(module $return_call-B
    (import "return_call-A" "g" (func $g (result i32)))
    (import "return_call-A" "g-via-internal-tail" (func $g-via-internal-tail (result i32)))
    (global $val (mut i32) (i32.const 2))
    ;; Chain: B.f --return_call--> A.g
    (func (export "f") (result i32)
        (return_call $g)
    )
    ;; Chain: B.f-multi-hop --return_call--> A.g-via-internal-tail --return_call--> A.$g
    (func (export "f-multi-hop") (result i32)
        (return_call $g-via-internal-tail)
    )
)
(register "return_call-B" $return_call-B)

(module $return_call-C
    (import "return_call-B" "f" (func $f (result i32)))
    (import "return_call-B" "f-multi-hop" (func $f-multi-hop (result i32)))
    (global $val (mut i32) (i32.const 3))
    (global $tmp (mut i32) (i32.const 0))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $mid))
    ;; Returns the result of the tail-call chain: A's global (= 1).
    ;;
    ;; Passes even with broken instance restoration since the tail call
    ;; itself switches to A's instance correctly.
    (func (export "tail-call-result") (result i32)
        (call $f)
    )
    ;; Returns C's own global (= 3) after the cross-instance tail-call chain
    ;; has returned.
    ;;
    ;; A buggy engine restores B's (or A's) instance instead of C's and thus
    ;; reads the wrong global here.
    (func (export "own-global-after-call") (result i32)
        (call $f)
        (drop)
        (global.get $val)
    )
    ;; Same as `own-global-after-call` but with an additional internal
    ;; tail-call hop inside A.
    (func (export "own-global-after-multi-hop") (result i32)
        (call $f-multi-hop)
        (drop)
        (global.get $val)
    )
    ;; Writes C's own global before the chain and reads it back afterwards.
    (func (export "own-global-roundtrip") (result i32)
        (global.set $tmp (i32.const 42))
        (call $f)
        (drop)
        (global.get $tmp)
    )
    ;; Chain: main --call_indirect--> C.$mid --return_call--> B.f --return_call--> A.g
    ;;
    ;; The frame of C.$mid is created by a same-instance indirect call and
    ;; thus carries no instance restoration obligation. The cross-instance
    ;; tail call to B.f must create this obligation, otherwise execution
    ;; resumes in `main` with the instance of A after A.g returned.
    (func $mid (result i32)
        (return_call $f)
    )
    (func (export "own-global-after-indirect-entry") (result i32)
        (call_indirect (type $ret-i32) (i32.const 0))
        (drop)
        (global.get $val)
    )
)

(assert_return (invoke $return_call-C "tail-call-result") (i32.const 1))
(assert_return (invoke $return_call-C "own-global-after-call") (i32.const 3))
(assert_return (invoke $return_call-C "own-global-after-multi-hop") (i32.const 3))
(assert_return (invoke $return_call-C "own-global-roundtrip") (i32.const 42))
(assert_return (invoke $return_call-C "own-global-after-indirect-entry") (i32.const 3))

;; ---------------------------------------------------------------------------
;; `return_call_indirect`
;;
;; Mirrors the `return_call` test group but performs all tail calls via
;; `return_call_indirect`.
;; ---------------------------------------------------------------------------

(module $return_call_indirect-A
    (global $val (mut i32) (i32.const 1))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $g))
    (func $g (export "g") (result i32)
        (global.get $val)
    )
    (func (export "g-via-internal-tail") (result i32)
        ;; Same-instance indirect tail call within A: must carry over the
        ;; instance restoration obligation unchanged.
        (return_call_indirect (type $ret-i32) (i32.const 0))
    )
)
(register "return_call_indirect-A" $return_call_indirect-A)

(module $return_call_indirect-B
    (import "return_call_indirect-A" "g" (func $g (result i32)))
    (import "return_call_indirect-A" "g-via-internal-tail" (func $g-via-internal-tail (result i32)))
    (global $val (mut i32) (i32.const 2))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $g $g-via-internal-tail))
    ;; Chain: B.f --return_call_indirect--> A.g (via B's table)
    (func (export "f") (result i32)
        (return_call_indirect (type $ret-i32) (i32.const 0))
    )
    ;; Chain:
    ;;
    ;; B.f-multi-hop --return_call_indirect--> A.g-via-internal-tail
    ;;               --return_call_indirect--> A.$g
    (func (export "f-multi-hop") (result i32)
        (return_call_indirect (type $ret-i32) (i32.const 1))
    )
)
(register "return_call_indirect-B" $return_call_indirect-B)

(module $return_call_indirect-C
    (import "return_call_indirect-B" "f" (func $f (result i32)))
    (import "return_call_indirect-B" "f-multi-hop" (func $f-multi-hop (result i32)))
    (global $val (mut i32) (i32.const 3))
    (global $tmp (mut i32) (i32.const 0))
    (type $ret-i32 (func (result i32)))
    (table funcref (elem $mid $f))
    ;; Returns the result of the tail-call chain: A's global (= 1).
    (func (export "tail-call-result") (result i32)
        (call $f)
    )
    ;; Returns C's own global (= 3) after the cross-instance tail-call chain
    ;; has returned.
    (func (export "own-global-after-call") (result i32)
        (call $f)
        (drop)
        (global.get $val)
    )
    ;; Same as `own-global-after-call` but with an additional same-instance
    ;; indirect tail-call hop inside A.
    (func (export "own-global-after-multi-hop") (result i32)
        (call $f-multi-hop)
        (drop)
        (global.get $val)
    )
    ;; Writes C's own global before the chain and reads it back afterwards.
    (func (export "own-global-roundtrip") (result i32)
        (global.set $tmp (i32.const 42))
        (call $f)
        (drop)
        (global.get $tmp)
    )
    ;; Chain:
    ;;
    ;; main --call_indirect--> C.$mid --return_call_indirect--> B.f
    ;;      --return_call_indirect--> A.g
    ;;
    ;; The frame of C.$mid is created by a same-instance indirect call and
    ;; thus carries no instance restoration obligation. The cross-instance
    ;; indirect tail call to B.f must create this obligation, otherwise
    ;; execution resumes in `main` with the instance of A after A.g returned.
    (func $mid (result i32)
        (return_call_indirect (type $ret-i32) (i32.const 1))
    )
    (func (export "own-global-after-indirect-entry") (result i32)
        (call_indirect (type $ret-i32) (i32.const 0))
        (drop)
        (global.get $val)
    )
)

(assert_return (invoke $return_call_indirect-C "tail-call-result") (i32.const 1))
(assert_return (invoke $return_call_indirect-C "own-global-after-call") (i32.const 3))
(assert_return (invoke $return_call_indirect-C "own-global-after-multi-hop") (i32.const 3))
(assert_return (invoke $return_call_indirect-C "own-global-roundtrip") (i32.const 42))
(assert_return (invoke $return_call_indirect-C "own-global-after-indirect-entry") (i32.const 3))
