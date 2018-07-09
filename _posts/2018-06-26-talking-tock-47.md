---
title: Talking Tock 47
subtitle:
author: aalevy
authors: alevy
---

This is the 47th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#984) **Move register interface to it's own crate**
  * (gh#987) **Move userland to libtock-c repo**
  * (gh#991) Remove `volatile_read`s from ring buffer
  * (gh#991) **Remove `volatile_read`s from ring buffer**
  * (gh#992) Document process isolation and memory protection
  * (gh#993) **Use LLVM's LLD to link the kernel**
  * (gh#996) Port Cortex-M to `StaticRef`
  * (gh#1001) Add a note that nRF51 is no longer recommended
  * (gh#1015) Capsules `Remove old commented out code`
  * (gh#1019) regs/macro.rs: add optional conversion from value into bit field enum member
  * (gh#1021) Fix broken link
  * (gh#1023) docs: document the usage of an RTT-backed console.
  * (gh#1028) Capsules quick fixes
  * (gh#1029) Remove asm from kernel
  * (gh#1030) tools: fix build-all-docs script

### Proposed

  * (gh#1009) Move userland docs to libtock-c
  * (gh#1010) **Add function that enables FPU for cortex-m4 MCUs**
  * (gh#1011) arch: scb register map fix
  * (gh#1012) Components
  * (gh#1014) kernel: move cells to their own crate
  * (gh#1016) nrf51: use staticref
  * (gh#1017) ek: convert to staticref
  * (gh#1018) cc26xx: use staticref
  * (gh#1020) Courses: Remove from repo and specify commit to view them
  * (gh#1024) Use several nice newish Rust features
  * (gh#1025) **adc: remove `initialize()` from HIL**
  * (gh#1026) Ensure symbols reach the linker with `#[used]`
  * (gh#1027) Remove unused feature declarations
  * (gh#1031) Use LLVM tools

