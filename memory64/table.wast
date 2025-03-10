;; Same as above but with i64 address types

(module (table i64 0 funcref))
(module (table i64 1 funcref))
(module (table i64 0 0 funcref))
(module (table i64 0 1 funcref))
(module (table i64 1 256 funcref))
(module (table i64 0 65536 funcref))
(module (table i64 0 0xffff_ffff funcref))

(module (table i64 0 funcref) (table i64 0 funcref))
(module (table (import "spectest" "table64") i64 0 funcref) (table i64 0 funcref))

(assert_invalid
  (module (table i64 1 0 funcref))
  "size minimum must not be greater than maximum"
)
(assert_invalid
  (module (table i64 0xffff_ffff 0 funcref))
  "size minimum must not be greater than maximum"
)
