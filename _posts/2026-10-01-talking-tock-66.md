---
title: Talking Tock 66
subtitle: Tock Registers' register_map API
authors: jrvanwhy
---

tock-registers version 0.11 has been published on crates.io! This release
introduces register_map, the successor to register_structs. It is a complete
redesign, with a new syntax for specifying register layouts and a completely new
format for the generated code. It has the following improvements over
register_structs:

- It resolves the [reference-to-MMIO soundness
  issue](https://github.com/tock/tock-registers/issues/4).
- It supports unit-testing driver implementations.
- It better supports registers with non-pointer-sized addresses, such as x86 IO
  ports.
- It allows external crates to define new operations beyond "read" and "write".

The new design is documented in the README, rustdoc, and in the `docs/`,
`examples/`, and `tests/` directories of the [tock-registers
repository](https://github.com/tock/tock-registers). You can also reference
[pull request 11](https://github.com/tock/tock-registers/pull/11), which
introduced the design.

To make it easier to incrementally migrate code to register_map, this release
does not remove the earlier APIs. However, because register_structs is unsound,
it is immediately deprecated: please migrate code to register_map instead.

## What's Next?

The current roadmap for tock-registers is:

1. Delete register_structs and the other deprecated APIs from the codebase.
2. Use tock-registers from within the main tock repository, and iterate on the
   register_map API.
3. Once the register_map API seems stable, we will publish tock-registers 2.0.

The jump from release 0.11 to 2.0 is intentional: register_map is effectively
the second major iteration of tock-registers, and we did not feel that a 1.0
release would be suitable for it.
