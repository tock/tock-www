---
title: Talking Tock 46
subtitle: 1.2 released
authors: alevy
---

This is the 46th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Tock 1.2 Released

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#976) Hide sensitive constructors in kernel
  * (gh#1000) Remove duplicates from nRF52's `Cargo.lock`
  * (gh#977) Move main to `sched.rs` for clarity
  * (gh#990) Port nRF52 to using `StaticRef`
  * (gh#998) Update tutorials
  * (gh#979) Fix USART SPI callback in SAM4L
  * (gh#989) Port all of SAM4L to using `StaticRef`

### Proposed

  * (gh#984) **Move register interface to it's own crate**
  * (gh#987) **Move userland to libtock-c repo**
  * (gh#991) Remove `volatile_read`s from ring buffer
  * (gh#991) **Remove `volatile_read`s from ring buffer**
  * (gh#992) Document process isolation and memory protection
  * (gh#993) **Use LLVM's LLD to link the kernel**
  * (gh#996) Port Cortex-M to `StaticRef`
  * (gh#997) Update `rustc` nightly
  * (gh#1001) Add a note that nRF51 is no longer recommended
