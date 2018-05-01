---
title: Talking Tock 40
subtitle: Release 1.1, Rust upgrade, svd2regs
author: aalevy
authors: alevy
---

This is the 40 post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## 1.1 Kernel Released

The April rolling release (version 1.1) has been tagged and pushed. The most
significant improvements in this release are a new, more readable and less
error prone regiter interface and a resource ownership based clock manager for
the SAM4L. With both of these used now nearly ubiquitously in the kernel, SAM4L
based boards automatically go to deep sleep when there are no active
peripherals.

Ports to the nRF52 development kit and Hail and imix, based on the Atmel SAM4L,
are considered stable and are backwards compatible with 1.0. An initial port to
the CC26xx series of platforms is included but not yet stable. The stabilized
system call ABI does not include any new peripherals since 1.0.

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#895) **Critical fix to Hail clock wakeup and minor overhaul of alarm virtualization stack**
  * (gh#837) **Support for SAM4L analog comparator**
  * (gh#851) **Add receive callback to console system call driver**
  * (gh#859) Word-align section binaries in userspace
  * (gh#873) Simplify BLE capsule
  * (gh#877) **Add svd2regs tool to generate registers from SVD files**
  * (gh#881) **Update to Rust nightly 2018-04-02**
  * (gh#882) Fine tune kernel linker script to error if relocation is too large
  * (gh#884) Build the SenSys course board in Travis
  * (gh#885) Make `sleep` a method of the chip trait so it can be chip-specific
  * (gh#886) **Charge the process for its Process struct in the kernel**
  * (gh#894) Nrf52 UART Receive
  * (gh#898) Nrf52/uart support longer messages than 255 characters


### Proposed

  * (gh#903) 6LoWPAN and initial IP stack
  * (gh#910) Improve systick precision
  * (gh#902) Allow recursive access to peripherals

## Final review period

  * (gh#871) elf2tbf rewrite and conversion to elf2tab
  * (gh#855) Construct BLE AdvData payload in userland
