---
title: Talking Tock 45
subtitle:
authors: alevy
---

This is the 45th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#958) **Remove innactive core team members**
  * (gh#942) Implement flash HIL for NRF52 NVMC
  * (gh#964) Explicit arch for cortex-m0 build in userland
  * (gh#947) **Iterate through debug app in grants**
  * (gh#974) sam4l: spi: do not enable without disable
  * (gh#955) **Re-evaluate what is `pub` in kernel crate**
  * (gh#936) **UART HIL changes**

### Proposed

  * (gh#975) **Add Trait-based capabilities to kernel**
  * (gh#976) Hide sensitive constructors in the kernel
  * (gh#977) Move `main` to main.rs in kernel crate
  * (gh#978) Add driver for the mx25r6435f flash chip
  * (gh#979) Fix USART SPI callback in SAM4L
