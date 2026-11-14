;; Operators after the final `end` of a function body must be rejected
;; without reaching the translator.

;; [end, nop]
(assert_malformed
    (module binary
        "\00asm" "\01\00\00\00"
        "\01\04\01\60\00\00"          ;; type section: [] -> []
        "\03\02\01\00"                ;; function section: 1 function of type 0
        "\0a\05\01\03\00\0b\01"       ;; code section
    )
    "operators remaining after end of function"
)

;; [end, block, end]
(assert_malformed
    (module binary
        "\00asm" "\01\00\00\00"
        "\01\04\01\60\00\00"
        "\03\02\01\00"
        "\0a\07\01\05\00\0b\02\40\0b"
    )
    "operators remaining after end of function"
)

;; [end, block, nop, end]
(assert_malformed
    (module binary
        "\00asm" "\01\00\00\00"
        "\01\04\01\60\00\00"
        "\03\02\01\00"
        "\0a\08\01\06\00\0b\02\40\01\0b"
    )
    "operators remaining after end of function"
)
