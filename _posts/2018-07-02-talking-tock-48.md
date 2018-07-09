---
title: Talking Tock 48
subtitle:
author: aalevy
authors: alevy
---

This is the 48th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#1006) A directory for crates
  * (gh#1029) kernel: remove asm
  * (gh#1028) Capsules quick fixes
  * (gh#978) capsules: add mx25r6435f flash chip
  * (gh#1054) kernel: must export symbols used by other crates
  * (gh#1024) Use several nice newish Rust features
  * (gh#1050) Updates RNG HIL to include lifetime, set_client
  * (gh#1025) **adc: remove `initialize()` from HIL**
  * (gh#1021) Fix broken link
  * (gh#1041) kernel: spin tbf header to its own file
  * (gh#1038) tools: remove all uses of `sed`
  * (gh#1037) launchxl: update readme with tockloader support
  * (gh#1020) Courses: Remove from repo and specify commit to view them
  * (gh#1026) Ensure symbols reach the linker with `(gh#)
  * (gh#1036) kernel: allow multiple LEDs for panic blinks
  * (gh#1034) Add Features to OptionalCell
  * (gh#1027) Remove unused feature declarations
  * (gh#997) Update Nightly (June 2018)
  * (gh#1014) kernel: move cells to their own crate
  * (gh#1009) Move userland docs to libtock-c
  * (gh#1033) Typo in mutable_references.md
  * (gh#1011) arch: scb register map fix
  * (gh#1018) cc26xx: use staticref
  * (gh#1017) ek: convert to staticref
  * (gh#1016) nrf51: use staticref
  * (gh#1019) regs/macro.rs: add optional conversion from value into bit field enum member
  * (gh#993) **Use LLVM LLD linker**
  * (gh#1030) tools: fix build-all-docs script

### Proposed

  * (gh#1065) Repair the 6LoWPAN IPv6 tx/rx kernel test
  * (gh#1064)[RFC] Extension trait for numeric cells
  * (gh#1063) Optional cell nrf5x
  * (gh#1062) Optional cell nrf52
  * (gh#1061) Optional cell nrf51
  * (gh#1060) Optional cell tm4c129x
  * (gh#1059) Optional cell cc26xx
  * (gh#1058) Optional cell sam4l
  * (gh#1057) Optional cell capsules
  * (gh#1056) Optional cell enhancements
  * (gh#1055) Travis: Include one debug build
  * (gh#1053) nrf51: Update uart to new regs interface
  * (gh#1051) cortex-m4: move hardfault handler to arch
  * (gh#1049) **Add `ReturnCode`s to UART HIL, change `abort` policy**
  * (gh#1046) Refactor debug.rs to not be implemented as a kernel process
  * (gh#1045) capsules: add virtual_uart
  * (gh#1044) kernel: make HAVE_WORK a member variable
  * (gh#1040) capsules: add analog_sensors.rs
  * (gh#1039) nrf52: add adc driver
  * (gh#1032) **ADC HIL updates**
