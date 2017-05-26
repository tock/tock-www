---
title: Talking Tock Week 3
authors: alevy
---

This is the third post in a weekly series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## What's new in Tock?

  * Tock is officially buildable entirely with Cargo.

  * @phil-levis has a pull-request open with a serious overhaul of the NRF51
    port, supporting most basic functionality to run Tock on an NRF51
    development kit---GPIO input and output and timers, with UART in the works.

## Tracking long-term progress

### Imix platform

@shaneleonard is working on a development board based on the
<a href="https://web.archive.org/web/20160828042208/http://storm.rocks/firestorm.html" data-proofer-ignore>Firestorm</a>
that will be widely available
(details to come). It is particularly amenable to Tock development since it
exposes many more internal pins for debugging as well as facilitating
power-measurement of individual components.

### Native Bluetooth Low-Energy Stack

@phil-levis is leading a port of the Mynewt project's open source BLE stack for
the NRF51 and NRF52 to Tock. Initially, we will run Mynewt as a process with the
radio hardware registers exposed to it using the MPU. We will then slowly
port layers of the library into Rust drivers in the kernel.

### Programming apps at runtime

@KBaichoo has finished a block store abstraction that respects the alignment
rules of the ARM Cortex-M memory protection unit. The next step is build a layer
on top that gets contiguous blocks of storage sized for an app and program it.
