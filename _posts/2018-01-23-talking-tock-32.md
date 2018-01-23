---
title: Talking Tock 32
subtitle: More flexible relocation, STM32 & Teensy repos
author: aalevy
authors: alevy
---

This is the 32nd post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Moving process loading and relocation to userland

Tock processes do not have a fixed location in flash and RAM---the bootloader
or kernel might (and does) re-arrange processes to, for example, make room for
a new process or add resources to an existing one. To deal with this, processes
need to be compiled with a particular [PIC strategy]({% post_url
2016-08-12-dynamic-loading %}) and, until recently, the kernel included a
loader that with this by having a loader that copied appropriate sections to
RAM and relocated sections such as the Global Offset Table and data relocation
sections.

This resulted in _a lot_ of dependency between the kernel and the particular
toolchain used to compile and link a process. In turn, this makes it tricky to
support userland processes that want/need to use different strategies. Finally,
it adds a signficant amount of fairly brittle code that has to be trusted.

As of gh#714, the loading and relocation logic has been moved _entirely_ to a
userspace library. Incidentally, this also makes the kernel 100% compliant to
the system call ABI we decided on for 1.0, since it no longer relies on a
custom TBF header to manage relocation meta-data.

The biggest downside processes with the same loading scheme each have their own
copy of the code in flash. Anecdotally, the code is ~240B, and the savings in
the kernel (which requires more checks to ensure safety) make up for a few
processes already.

## STM32 & Teensy Development Underway

We've moved development of STM32-based ports of Tock to its [own
repo](https://github.com/tock/tock-stm32) which already has support for the
STM32F1, and pending support for the STM32F4.

We've also moved Teensy development into a similar [shared
repository](https://github.com/tock/tock-teensy). There is already fairly
extensive support for the Teensy 3.6 (based on the mk66 microcontroller) as
well as pending work on the Teensy 3.2.

Head on over if you're able and interested in contributing to those ports, or
if you just want to follow along or use them!

## Proposals

  * (gh#731) Don't generate asm listing in debug target

## Pull Requests

### Merged

  * (gh#728) Update libc++ to 2.5.0.20170421
  * (gh#714) Move process relocation to userland
  * (gh#713) Add MPU & SysTick support for NRF52
  * (gh#730) userland: add gitignore for libg++ build artifacts
  * (gh#729) Cleanup userland_generic.ld
  * (gh#733) Remove un-necessary comment
  * (gh#732) doc: add out of tree documentation

### Older, but revigorated

  * (gh#684) [ieee802154] CCM\* implementation
  * (gh#692) Low Power MAC Protocol (X-MAC)
