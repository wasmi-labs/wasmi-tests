(module
    ;; This yielded a translation error.
    (func (export "br-table-branch-slots-match") (param i32) (param i32)
        (block $exit (result i32)
            (local.get 0)
            (loop $continue (param i32)
                (local.get 0)
                (br_table $continue $exit $continue)
            )
            (unreachable)
        )
        (unreachable)
    )
)
