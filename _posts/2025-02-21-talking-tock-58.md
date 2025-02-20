---
title: Talking Tock 58
subtitle: New pointer type in the kernel
authors: bradjc
---

Correctly expressing data types in Rust between userspace and the kernel with
correctly captured semantics is challenging as different hardware platforms
provide different data representations. The common example of this is 32-bit
platforms versus 64-bit platforms which store different sized types in registers
and therefore provide a different amount of data between userspace and the
kernel. Emerging platforms, for example hardware with [CHERI support](https://en.wikipedia.org/wiki/Capability_Hardware_Enhanced_RISC_Instructions), complicate
this further. With [pull request #4174](https://github.com/tock/tock/pull/4174)
merged, Tock has taken a step to improve this by adding `CapabilityPtr`, a type
within the kernel to clearly express when data within the kernel is a pointer.

The `CapabilityPtr` Type
------------------------

Fundamentally this type stores a pointer to memory. The name "capability"
signifies this type also captures the validity of that pointer and whether the
holder of the pointer can actually use the pointer to access memory.

Traditionally, a valid pointer in `unsafe` Rust always has the ability to be
dereferenced. That is, the hardware will (at least try to) access the referenced
memory. `CapabilityPtr` expands this abstraction, and enables software to track
whether hardware will permit the memory access, if the hardware has such
restrictions.

Support for CHERI
-----------------

The primary driver for adding the `CapabilityPtr` type is the
[CHERI](https://www.cl.cam.ac.uk/research/security/ctsrd/cheri/) extension for
hardware architectures. With CHERI, hardware can track whether a pointer can be
dereferenced. The metadata for that tracking is stored alongside the pointer
address in hardware registers which are larger than the platform's typical word size.
Tock is targeting a hybrid CHERI ABI which
supports both traditional pointers and pointers with the CHERI metadata. With
the `CapabilityPtr` type, Tock now has a mechanism to represent these pointers
with metadata that are larger than the machine's `usize`.

Adding `CapabilityPtr` is only a first step towards support for CHERI in Tock.
Additional pull requests will fill in the remaining support needed in the Tock
kernel for this hardware support.

