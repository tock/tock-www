---
title: Talking Tock 37
subtitle:
authors: alevy
---

This is the 37th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#801) **Upgrade to rustc nightly 2018-03-07**
  * (gh#766) Port Sam4l USART to new register interface
  * (gh#784) Port SAM4L WDT to new regs interface
  * (gh#797) Port NRF51 UART to new regs interface
  * (gh#802) TRNG support for CC26xx + Launchxl
  * (gh#807) Port SAM4L GPIO to new regs interface
  * (gh#815) Remove old header files from userland
  * (gh#816) Add missing driver numbers
  * (gh#816) Add missing driver numbers
  * (gh#760) **MMIO Interface with automatic peripheral clock management**
  * (gh#810) Refactor ble advertising to capsule & kernel hil
  * (gh#802) launchxl: TRNG support
  * (gh#796) Port CC26xx to use new register interface
  * (gh#802) RTC support for launchxl
  * (gh#824) cc26xx: Return expected value for get\_alarm in rtc
  * (gh#825) cc26xx: fix sw\_reset check in trng
  * (gh#761) sam4l: Low power I2C
  * (gh#827) kernel: split register matches to any and all

### Proposed

  * (gh#813) Port NRF52 Radio to New Register Interface
  * (gh#819) Fix Process Loading with App State Section
  * (gh#821) Peripheral Manager Derive
  * (gh#822) **Always set process RAM to at least minimum length**
  * (gh#829) Allow direct use of FieldValue mask
  * (gh#830) **launchxl: basic uart support**

### Approval period

  * (gh#750) **Port to the TI EK-TM4C1294XL evaluation kit**
