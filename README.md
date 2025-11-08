# Wasmi specific Wast Tests

This repo contains two sets of Wast (`.wast`) tests:

1. Wasmi specific Wast tests, found under the `tests` folder.
2. Wast tests from the official Wasm spec testsuite that have been modified to work with Wasmi.

In particular this repository contains the following subsets of the official Wasm spec testsuite:

1. `proposals/memory64`
    - This has been modified to remove references from Wasm proposals unsupported by Wasmi such as the `exceptions` and `function-references` proposal.
    - At the time of writing this the Wasm spec testsuite is about to be moved over to Wasm 3.0 while Wasmi does not even support all of Wasm 2.0.
      Therefore, for a subset of the Wasm spec testsuite features we rely on this fork to provide the proper tests that can be consumed by Wasmi.

## Wasmi Test Module

Similar to the Wasm spec testsuite the Wasmi tests also require a specific test module setup.
The Wasmi test module (exported as `"wasmitest"`) requires the following function definitions used to test host function calls.

See below for their definitions in WebAssembly Text (Wat) format:

```wasm
(func (export "identity-0"))

(func (export "identity-1") (param i64) (result i64)
    (local.get 0)
)

(func (export "identity-2") (param i64 i64) (result i64 i64)
    (local.get 0)
)

(func (export "offset-1") (param i64) (result i64)
    (i64.add (local.get 0) (i64.const 1))
)

(func (export "offset-2") (param i64 i64) (result i64 i64)
    (i64.add (local.get 0) (i64.const 1))
    (i64.add (local.get 1) (i64.const 2))
)

(func (export "sum-3") (param i64 i64 i64) (result i64)
    (i64.add
        (local.get 0)
        (i64.add
            (local.get 1)
            (local.get 2)
        )
    )
)

(func (export "iota-3") (param i64) (result i64 i64 i64)
    (i64.add (local.get 0) (i64.const 1))
    (i64.add (local.get 0) (i64.const 2))
    (i64.add (local.get 0) (i64.const 3))
)
```
