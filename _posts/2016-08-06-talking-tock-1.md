---
title: Talking Tock Week 1
---

This is the first post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

## What's new in Tock?

  * @idolf fixed the `static_init!` to only allocate as much static memory as
    needed.

  * @yuriks Upgraded Tock to Rust nightly version 2016-07-29, catching us up by
    over 7 months worth of nightly versions.

  * @KBaichoo implemented a driver for the SAM4L's flash controller, which is a
    step towards replacing apps at runtime.

  * @phil-levis made significant progress on the NRF51822 port, implementing
    support for the real time counter and GPIO interrupts.

  * @utkarshapets contributed a UART driver for the NRF51822.

  * @alevy removed dependencies on the deprecated `NUM_PROCS` variables in the
    SPI and BLE drivers, and fixed dependencies in th kernel such that the
    platform crate is the root of compilation.

## Progress report

  * Switching from a complicated home-baked Makefil build system to Cargo. This
    will not only clean up the build system significantly but, more
    importantly, allow porting to other chips and platforms out of tree.

  * A native BLE stack for the NRF51822 (based on the Mynewt project).

  * Runtime programming of apps. As a next step, @KBaichoo is working on a
    block store abstraction for the flash that allocates storage space in a way
    that respects requirements of the MPU.

