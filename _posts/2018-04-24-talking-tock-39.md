---
title: Talking Tock 39
subtitle:
author: aalevy
authors: alevy
---

This is the 39th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#857) Ensure userland stack starts 8-byte aligned
  * (gh#878) Double initial process stack size from 64 to 128 bytes
  * (gh#879) Perform moving the stack pointer in userspace last in `_start`
  * (gh#882) Fine tune kernel linker script to error if relocation is too large
  * (gh#883) Simplify `make doc`
  * (gh#884) Build the SenSys course board in Travis
  * (gh#885) Make `sleep` a method of the chip trait so it can be chip-specific
  * (gh#887) Add `scb` to Cortex-M3 crate
  * (gh#890) cc26xx: remove unnecessary dependency to cortex-m4 crate
  * (gh#891) cc26xx: correct the selection of LF clock source
  * (gh#896) Use portable invocation of bash in shell scripts
  * (gh#900) Avoid concurrent PeripheralManager instances
  * (gh#901) Improve error messages for `ip_sense` app

### Proposed

  * (gh#894) Nrf52 UART Receive
  * (gh#895) **Critical fix to Hail clock wakeup and minor overhaul of alarm virtualization stack**
  * (gh#898) Nrf52/uart support longer messages than 255 characters

