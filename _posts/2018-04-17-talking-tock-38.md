---
title: Talking Tock 38
subtitle:
author: aalevy
authors: alevy
---

This is the 38th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#829) Allow direct use of FieldValue mask
  * (gh#836) nRF52: convert register `matches` to `is_set`
  * (gh#841) Fix typo in `format_all.sh`
  * (gh#839) Port nRF5x AES to new register interface
  * (gh#842) Port nRF5x RNG to new register interface
  * (gh#843) Disable lps25hb interrup after use
  * (gh#846) Update getting started
  * (gh#845) Fix usart sleep in panic on SAM4L
  * (gh#849) Add hail scripts for jlink + gdb debugging
  * (gh#848) sam4l: convert usart panic state to atomic
  * (gh#853) Add check for correct usage of override
  * (gh#840) Port NRF5x temperature driver to new register interface
  * (gh#844) Port SAM4L watchdog timer to new register interface
  * (gh#813) Port nRF52 radio to new register interface
  * (gh#858) Port nRF52 UICR2 to new register interface
  * (gh#865) Enable `debug_gpio` macro on nRF5x
  * (gh#861) Add support for NVMC in nRF52
  * (gh#862) Use feature gates to differentiate between nRF51/2
  * (gh#863) Unify naming in cortex-m4 architecture crate
  * (gh#830) **Support for UART on launchxl**
  * (gh#850) **Move kernel stack to bottom of SRAM**
  * (gh#852) Example app that communicates over BLE with WitEnergy power meter
  * (gh#870) Remove unnecessary unwrap in grant module
  * (gh#867) Fix and supress overflow warnings in nRF5x-FICR
  * (gh#854) **Enforce userland `STACK_SIZE` at compile-time**
  * (gh#822) **Always set process RAM to at least a minimum length**
  * (gh#880) Remove skips in rustfmt
  * (gh#872) Fix off-by-one BLE scanning bug
  * (gh#869) Improve error handling for SAM4L flash driver


### Proposed

  * (gh#837) **Support for SAM4L analog comparator**
  * (gh#838) **Bluetooth Low Energy design document**
  * (gh#851) **Add receive callback to console system call driver**
  * (gh#855) **Construct BLE advertisement data in userspace**
  * (gh#857) Ensure userland stack starts 8-byte aligned
  * (gh#859) Word-align section binaries in userspace
  * (gh#871) **Rewrite elf2tbf into elf2tab (and get rid of separate TAB generation)**
  * (gh#873) Simplify BLE capsule
  * (gh#877) Add svd2regs tool to generate registers from SVD files
  * (gh#878) Double initial process stack size from 64 to 128 bytes
  * (gh#879) Perform moving the stack pointer in userspace last in `_start`
  * (gh#881) **Update to Rust nightly 2018-04-02**
  * (gh#882) Fine tune kernel linker script to error if relocation is too large
  * (gh#883) Simplify `make doc`
  * (gh#884) Build the SenSys course board in Travis
  * (gh#885) Make `sleep` a method of the chip trait so it can be chip-specific
  * (gh#886) **Charge the process for its Process struct in the kernel**
  * (gh#887) Add `scb` to Cortex-M3 crate
  * (gh#888) Bulk USB transfers for SAM4L

