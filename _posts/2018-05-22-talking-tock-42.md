---
title: Talking Tock 42
subtitle: Bootloader, restarting processes and changing clocks
authors: alevy
---

This is the 42nd post in a series tracking the development of Tock, a safe
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

  * (gh#923) Update Cortex-M systick to new register interface
  * (gh#924) Detect RF233 CHANNEL_ACCESS_FAILURE (max CSMA retry) failures
  * (gh#926) Remove unneeded type qualifier from RF233
  * (gh#928) Build lst file in separate make target
  * (gh#929) Fix protected register access bugs on SAM4L
  * (gh#937) Remove redundant rustfmt.toml
  * (gh#934) Fix comment formatting
  * (gh#940) Remove unused `pub` qualifiers
  * (gh#945) Add `soundness.md` document
  * (gh#943) Add `receive_abort` to UART HIL
  * (gh#938) Nrf51822Serialization/capsule `map -> map_or`
  * (gh#931) Make IPC optional for boards


### Proposed

  * (gh#933) Dynamically Change System Clock on SAM4L
  * (gh#935) Move deferred call mechanism to kernel crate
  * (gh#936) **UART HIL Changes**
  * (gh#941) **Allow kernel to restart processes**
  * (gh#942) Implement flash HIL for NRF52 NVMC controller
  * (gh#944) Add nrf52840-DK board

