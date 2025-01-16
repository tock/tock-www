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
kernel. Emerging platforms, for example hardware with CHERI support, complicate
this further. With [pull request #4174](https://github.com/tock/tock/pull/4174)
merged, Tock has taken a step to improve this by adding `CapabilityPtr`, a type
within the kernel to clearly express when data within the kernel is a pointer.

The `CapabilityPtr` Type
------------------------

Fundamentally this type stores a pointer to memory. The name "capability"
signifies this type also captures the validity of that pointer and whether the
holder of the pointer can actually use the pointer to access memory.

Traditionally, a pointer in `unsafe` Rust always has the capability to be
dereferenced. That is, the hardware will access the referenced memory.
`CapabilityPtr` expands this abstraction, and enables software to track whether
hardware will permit the memory access, if the hardware has such restrictions.

Support for CHERI
-----------------

The primary driver for adding the `CapabilityPtr` type is the
[CHERI](https://www.cl.cam.ac.uk/research/security/ctsrd/cheri/) extension for
hardware architectures. With CHERI, hardware can track whether a pointer can be
dereferenced. The metadata for that tracking is stored alongside the pointer
address in hardware registers. With the `CapabilityPtr` type, Tock now has a
mechanism to represent data that is larger than the machine's `usize` yet still
represents a single register.

Adding `CapabilityPtr` is only a first step towards support for CHERI in Tock.
Additional pull requests will fill in the remaining support needed in the Tock
kernel for this hardware support.
