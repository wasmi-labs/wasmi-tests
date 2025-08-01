# Wasmi specific Wast Tests

This repo contains two sets of Wast (`.wast`) tests:

1. Wasmi specific Wast tests, found under the `tests` folder.
2. Wast tests from the official Wasm spec testsuite that have been modified to work with Wasmi.

In particular this repository contains the following subsets of the official Wasm spec testsuite:

1. `proposals/memory64`
    - This has been modified to remove references from Wasm proposals unsupported by Wasmi such as the `exceptions` and `function-references` proposal.
    - At the time of writing this the Wasm spec testsuite is about to be moved over to Wasm 3.0 while Wasmi does not even support all of Wasm 2.0.
      Therefore, for a subset of the Wasm spec testsuite features we rely on this fork to provide the proper tests that can be consumed by Wasmi.
