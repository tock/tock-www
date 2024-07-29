---
title: Talking Tock 41
subtitle:
authors: alevy
---

This is the 41st post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#871) **elf2tbf rewrite and conversion to elf2tab**
  * (gh#855) **Construct BLE AdvData payload in userland**
  * (gh#914) Move `transmit_domplete` callback in SAM4L USART to fix missed bytes
  * (gh#916) Timer updates to the NRF52 in preparation for BLE connections
  * (gh#903) **6LoWPAN and initial IP stack**
  * (gh#917) Expose NRF5x PPI interface for use in radio
  * (gh#919) rustdoc "nits"
  * (gh#888) **USB bulk transfers for SAM4L**
  * (gh#920) Port SAM4L CRC to new register interface
  * (gh#921) Keep track of dropped callbacks for each process
  * (gh#910) **Improve Systick precision**
  * (gh#922) Correct timing issues in CC26xx RTC
  * (gh#923) Port systick to new register interface in Cortex-M3/4 crates


### Proposed

  * (gh#915) BLE connection driver for the NRF52
  * (gh#913) I2C (TWIM) support for the NRF51

