---
title: Talking Tock 50
subtitle:
author: aalevy
authors: alevy
---

This is the 50th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#1130) docs: Collection of small updates
  * (gh#1128) Kernel doctests
  * (gh#1046) Refactor debug.rs to not be implemented as a kernel process
  * (gh#1127) Launchxl Alarm Bug: Fix issue of board main.rs calling wrong rtc
  * (gh#1119) Adds RTC, AON, PRCM driver to CC26x2
  * (gh#1045) capsules: add virtual_uart
  * (gh#1124) libraries: match example values in documentation
  * (gh#1122) capsules: add reset function to nrf serialization
  * (gh#838) **Starting the Bluetooth Low Energy design doc**
  * (gh#1120) kernel: debug: fix print
  * (gh#1073) **uart: remove `initialize` from the UART HIL**
  * (gh#1117) doc: clean up the README a bit
  * (gh#1068) **Add bors integration for merging PRs**
  * (gh#1012) **Components**
  * (gh#1108) Instructions for flashing processes on launchxl
  * (gh#1114) Fix `in_exposed_bounds` security vulnerability
  * (gh#1106) Updates to tock-registers for publishing
  * (gh#1004) mcp230xx: support more versions of the chip
  * (gh#1098) Replace trivial implementations of Default with (gh#)
  * (gh#1105) refactor: s/regs/registers
  * (gh#1059) Optional cell cc26xx
  * (gh#1109) kernel: remove the need for &mut Process
  * (gh#1032) **Specify units for ADC HIL**
  * (gh#1110) Small grammar fixes
  * (gh#1102) Use OpenOCD for Launchxl build and sanitize
  * (gh#1089) **Make most of `kernel` crate-visible only, rather than public.**
  * (gh#1062) Optional cell nrf52
  * (gh#1060) Optional cell tm4c129x
  * (gh#1097) Assign proper gpio pins to nRF52-DK

### Proposed

  * (gh#1129) Fix virtual_uart receive semantics
  * (gh#1126) **New MPU Interface**
  * (gh#1125) nrf51: update radio to new register interface
  * (gh#1123) nrf51: update clock to new register interface
  * (gh#1121) Kernel: comments and `mut` removal
  * (gh#1115) Move architecture-dependent debugging print code to arch/cortex-m
  * (gh#1113) **Move architecture-dependent syscall code to arch/cortex-m**
  * (gh#1111) Kernel: Move `PROCS` array to `Kernel` struct
  * (gh#1107) **[WIP] UART + SPI HIL generic lifetimes**
  * (gh#1104) capsules: add buzzer driver
  * (gh#1103) capsules: add virtual_pwm
