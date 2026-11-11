;; A 32-bit memory with 1-byte pages has at most `2^32 - 1` pages.
(module
  (memory 1 (pagesize 1))
  (func (export "grow") (param i32) (result i32) (memory.grow (local.get 0)))
  (func (export "size") (result i32) (memory.size))
)
(assert_return (invoke "grow" (i32.const -1)) (i32.const -1))
(assert_return (invoke "size") (i32.const 1))
