---
title: Talking Tock 66
subtitle: RISC-V 64-bit Support on Tock
authors: bradjc
---

With [PR #4906](https://github.com/tock/tock/pull/4906) merged, we are
announcing preliminary support for 64-bit Tock! Specifically, Tock runs on
RISC-V 64-bit `rv64imac` platforms.

Tock 64-bit support involves three major pieces:

1. Low-level RISC-V specific assembly code no longer assumes 32-bit registers.
   This is most relevant for register stacking and unstacking. All Tock
   initialization and exception handlers that are written in assembly for RISC-V
   now use register-sized loads and stores where necessary.
2. There is now a defined system call ABI for RISC-V 64-bit. This specifies
   how data is encoded in the interface between the kernel and userspace.
3. There is an upstream QEMU-based board targeting a RISC-V 64-bit core to help
   with testing.

## Supporting Register-Sized Loads and Stores

The way RISC-V is designed, there are relatively few differences between the
`rv32i` and `rv64i` architectures. This discourages duplicating the low-level
architecture-specific code, and we decided it was better to have a single
`riscv` crate that supports both.

This is mostly straightforward, with the exception of stacking and unstacking
registers. With 32-bit registers on `rv32i`, the relevant assembly
instructions are store word (`sw`) and load word (`lw`). With 64-bit
registers on `rv64i`, the relevant assembly instructions are store
double (`sd`) and load double (`ld`). There is no toolchain-provided
pseudoinstruction for store/load register-sized data.

To avoid clumsy `cfg` blocks for each architecture, we developed our [own assembly
pseudoinstructions](https://github.com/tock/tock/blob/master/arch/riscv/src/pseudo_instructions.rs)
using assembly macros. These look like this:

```rust
#[cfg(target_arch = "riscv32")]
#[macro_export]
macro_rules! xlen_macros[() => [r"
    .macro sx src, dest
        sw \src, \dest
    .endm
    .macro lx dest, src
        lw \dest, \src
    .endm
"]];

#[cfg(target_arch = "riscv64")]
#[macro_export]
macro_rules! xlen_macros[() => [r"
    .macro sx src, dest
        sd \src, \dest
    .endm
    .macro lx dest, src
        ld \dest, \src
    .endm
"]];
```

This provides the instructions `sx` and `lx` which will convert to
register-sized loads and stores on `rv32i` and `rv64i`. We used "x" to refer
to the loads and stores being `XLEN` bits.

Using these in Rust assembly blocks looks (roughly) like this:

```rust
#[unsafe(naked)]
pub extern "C" fn start() -> ! {
    core::arch::naked_asm!(
        xlen_macros!(),
        "
    // Store register s0 on the stack.
    sx s0, 0(sp)
        "
    );
}
```

## RISC-V 64-bit System Call Interface

The [draft TRD for RISC-V 64-bit](https://github.com/tock/tock/blob/master/doc/reference/trd-riscv64.md)
specifies how Tock system calls map to registers for 64-bit platforms.
The specification largely matches our existing
[system call TRD](https://book.tockos.org/trd/trd104-syscalls) to avoid
complexity from different ABIs.

There are two differences that are somewhat noteworthy, however, that we
describe more here.

### New Syscall Return Value Variants

When a system call returns to userspace the return value is encoded based on
the specific variant being returned. This allows system calls to return
different data types. For example one system call may return just an
`ErrorCode`, and another might return an `ErrorCode` and an additional `u32`
value. Those are differentiated by a known list of return value variants so
userspace can correctly decode the return type.

Since the 32-bit ABI was defined we have identified new return variants that
were not originally included. For example, the allow family of system calls
returns a pointer and a length. For 32-bit platforms we re-use the "Success
with 2 `u32`" return variant as both pointers and lengths are 32-bits.
However, semantically, that isn't quite right, because knowing that the first
value is actually a pointer conveys different semantics than knowing it is
just any 32-bit value. Rather than re-use variants for cases like these for
the 64-bit ABI, we defined new return variants that properly separate these
use cases that differentiate pointers and addresses from arbitrary 32-bit or
64-bit data.

### Compatibility with Tock's 32-bit ABI

Obviously RISC-V 64-bit chips have double the bits in registers compared to 
their 32-bit versions. This means using the same number of registers, Tock
could exchange double the amount of data between userspace and the kernel
for any given system call. Our 64-bit ABI intentionally avoids doing this.

Instead, the 64-bit ABI tries to mimic the 32-bit ABI as closely as possible.
For example, the 64-bit ABI for the command system call is still limited to
a 32-bit command number, and two additional 32-bit values.

We made this decision to avoid fragmenting our capsule ecosystem. Without this
restriction, and using the full 64 bits for 64-bit platforms, a single
command call implemented in a `SyscallDriver` capsule could convey 128 bits
of information. If a capsule took advantage of all 128 bits, or even 65 bits,
it would be impossible for that capsule to ever work on a 32-bit platform.

The exception is for subscribe, allow, and memop system calls that use
pointers. Because pointers are nearly always register sized (or importantly
for this purpose, larger than 32-bits), they must use the entire register.
Therefore, all system calls that operate on pointers are register-sized.

These two properties result in an important implication. All system calls
referring to buffers or lengths of buffers MUST be communicated via the allow
system call. Because a buffer on a 64-bit system could be longer than 2^32,
the length of an operation cannot be guaranteed to fit in a command argument.
Therefore, all capsules must only use the allow system call to communicate
buffer lengths or how many bytes of a buffer to use.

## 64-bit Tock Next Steps

Currently the RISC-V 64-bit ABI is a draft. We do not currently (as of October
2026) guarantee stability for the 64-bit ABI.

If you have a 64-bit RISC-V platform and want to port Tock, we would be
interested. With more testing and experience we will be more comfortable with
our current design and implementation and plan to eventually stabilize 64-bit
support.
