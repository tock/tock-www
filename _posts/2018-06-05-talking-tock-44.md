---
title: Talking Tock 44
subtitle: External elf2tab and Tock coming to Shenzhen
authors: alevy
---

This is the 44th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## We're coming to Shenzhen!

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#965) Port nRF52 i2c to new register interface
  * (gh#968) Port nRF5x timer to new register interface
  * (gh#966) Port nRF52 spi to new register interface
  * (gh#969) Port nRF5x rtc to new register interface
  * (gh#967) Remove bitfield dependency from nRF52
  * (gh#964) Explicit arch for cortex-m0 build in userland
  * (gh#963) Remove Makefile-app
  * (gh#952) **Use elf2tab from crates.io**
  * (gh#942) Implement flash hil for nrf52 nvmc

### Proposed

  * (gh#972) Fix SPI's use of DMA in SAM4L and add fractional division for
    USART baud rate

