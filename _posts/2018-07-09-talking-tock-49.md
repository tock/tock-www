---
title: Talking Tock 49
subtitle:
authors: alevy
---

This is the 49th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#1064) Replace `NumCell` with `NumericCellExt` for `Cell` tock-libraries
  * (gh#1044) **kernel: make HAVE\_WORK a member variable**
  * (gh#1071) Add a Nix-shell script
  * (gh#1070) Revert "Optional cell sam4l"
  * (gh#1058) Optional cell sam4l
  * (gh#1066) Rng lifetimes
  * (gh#1067) doc: use consistent language for unused arguments
  * (gh#1055) Travis: Include one debug build
  * (gh#1062) Optional cell nrf52
  * (gh#1060) Optional cell tm4c129x
  * (gh#1097) Assign proper gpio pins to nRF52-DK
  * (gh#1094) Fix flashing problem on `nRF51DK` & `nRF52DK`
  * (gh#1100) Fix bad use of optioncell introduced by (gh#1057)
  * (gh#1057) Optional Cell capsules
  * (gh#1099) [tock-cells] Fix unit tests embedded in rustdocs
  * (gh#1063) Optional cell nrf5x
  * (gh#1092) tock-regs: Add conditional 64bit support
  * (gh#1061) Optional cell nrf51
  * (gh#1053) nrf51: Update uart to new regs interface
  * (gh#1096) sam4l: fixup master from conflicting PRs
  * (gh#1056) Optional cell enhancements
  * (gh#1095) doc: Clean up tock-regs README a bit
  * (gh#1086) Add rule for running CI tests locally
  * (gh#1091) **kernel: use as\_ptr() in appslice**
  * (gh#1090) **use rustfmt::skip tool attribute**
  * (gh#1031) **Use LLVM Tools**
  * (gh#1085) travis: disallow warnings in CI builds
  * (gh#1032) **Specify units for ADC HIL**
  * (gh#1065) Repair the 6LoWPAN IPv6 tx/rx kernel test
  * (gh#1051) cortex-m4: move hardfault handler to arch
  * (gh#1080) Replace Default implementation with derived Default in RNG capsule
  * (gh#1077) Remove wildcard imports
  * (gh#1039) nrf52: add adc driver


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
