---
title: Talking Tock 43
subtitle: Changing clocks, bootloader re-write and cleanups
author: aalevy
authors: alevy
---

This is the 43rd post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## A Tock-based Bootloader

@bradjc mixed some [existing
pieces](https://github.com/thejpster/tockloader-proto-rs) with some
good-old-fashion [elbow grease](https://github.com/tock/tock-bootloader/pull/9)
to rewrite the bootloader we use for the SAM4L (Hail and imix boards) using
Tock! Better yet, most of the code is completely portable and can be used for
any chip ported to Tock that has a UART, flash and GPIO implementation.

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#933) **Dynamically Change System Clock on SAM4L**
  * (gh#913) I2C (TWIM) support for the nRF51
  * (gh#950) Remove lingering size argument from `static_init!`
  * (gh#948) Check app state before scheduling
  * (gh#946) Don't silently drop IPC tasks
  * (gh#953) Rename `xfer` to `transefer`
  * (gh#954) Reconfigure how cells are exported
  * (gh#956) Remove `load` function from kernel
  * (gh#949) Add richer cell types
  * (gh#944) Add nrf528240-dk board
  * (gh#935) Move deferred call mechanism to kernel crate
  * (gh#962) Move cortex-m specific code to `arch/`

### Proposed

  * (gh#947) Iterate through debug app in grants
  * (gh#952) **Use elf2tab from crates.io**
  * (gh#955) "Reevaluate" what is exported `pub` in the kernel crate
  * (gh#957) Add a capsule that can restart all processes
  * (gh#958) **Remove innactive core team members**
  * (gh#963) Remove Makefile-app
  * (gh#964) Explicit arch for cortex-m0 build in userland
  * (gh#965) Port nRF52 i2c to new register interface
  * (gh#966) Port nRF52 spi to new register interface
  * (gh#967) Remove bitfield dependency from nRF52
  * (gh#968) Port nRF5x timer to new register interface
  * (gh#969) Port nRF5x rtc to new register interface

