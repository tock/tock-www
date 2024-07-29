---
title: Talking Tock 55
subtitle: Tock Compiles on Stable Rust!
authors: bradjc
---

With [pull request #3802](https://github.com/tock/tock/pull/3802) merged, the
Tock kernel now compiles with the stable version of the Rust compiler! This has
been a [long-standing goal](https://github.com/tock/tock/issues/1654) to move
away from experimental nightly features and wait for crucial nightly features to
be stabilized.

For now, only Cortex-M based chips can compile with stable Rust. The
RISC-V-based boards still use a nightly feature in the crate that interacts with
RISC-V CSR registers. However, this still means that the key shared crates
(including the `kernel` and `capsules` crates) are fully compatible with the
stable compiler.

We plan to enable RISC-V boards to compile with the stable compiler in the
future as well.

Nightly Still Useful
--------------------

Despite this development, the main Tock repository will continue to compile most
(nearly all) boards on the nightly compiler. There are three main reasons for
this:

1. We use `-Z build-std=core` to compile our own core library with our
   optimizations, and this is a nightly feature.
2. We want to support `custom_test_frameworks` for boards, which is a nightly
   feature.
3. We want to be able to use Miri, which isn't stabilized.

Compiling With Stable Rust
--------------------------

To compile a Tock board with the stable compiler, add this variable to the
board's Makefile:

```
USE_STABLE_RUST=1
```

You may also need to create a `rust-toolchain.toml` file to specify the stable
compiler in the board's crate folder:

```
[toolchain]
channel = "stable"
components = ["llvm-tools", "rust-src", "rustfmt", "clippy"]
targets = ["thumbv6m-none-eabi", "thumbv7em-none-eabi", "thumbv7em-none-eabihf", "riscv32imc-unknown-none-elf", "riscv32imac-unknown-none-elf"]
```
