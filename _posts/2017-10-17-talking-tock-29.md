---
title: Talking Tock 29
subtitle: 1.0 release, imix and more
author: aalevy
authors: alevy
---

This is the 29th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Tock 1.0

We [announced]({% post_url 2017-10-09-talking-1-0-release %}) version 1.0 of
the Tock system call ABI. It includes the binary format of processes on flash,
the semantics and behavior of the five system calls, and the driver interface
exposed through system calls for a basic set of portable interfaces.

The goal is to be able to write cross-platform processes that will run on any
Tock kernel that is 1.0 compliant. For this version, stability means that those
interfaces will not change until, at least, the next major version. In other
words, if you write a process to that uses only the stable drivers and it
doesn't work as expected, it's either a bug in the kernel or a bug in the
userland library (and we appreciate [bug reports
&hearts;](http://github.com/helena-project/tock/issues/new)).

## imix

Remember [imix]({{"/hardware" | relative_url}}#imix)? It's a development board
we've been using for Tock at Stanford and Berkeley (formerly Michigan),
specifically for working on BLE, 802.15.4 and power management. It's similar to
[Hail]({{"/hardware/hail" | relative_url }}) with the addition of an RF233
802.15.4 radio, separate power domains for each radio, the MCU, sensors and an
external RNG, and as many headers as possible to make power measurement and
debugging easier.

Well, it's finally ready for prime time. We're confident enough in version 2.1
that we made enough for others too this time. The fab just shipped the boards
last night and they'll be debuted at the SOSP tutorial at the end of the month.

## Pull Requests

### Merged

#### Thread/6lowpan

  * (gh#581) @ptcrews implemented 6lowpan fragmentation
  * (gh#581) @alevy added an example app that sends sensor data over 802.15.4

#### Tock 1.0

  * (gh#599) @alevy standardized the system call interfaces for Tock 1.0
  * (gh#638) @bradjc added additional documentation for Tock 1.0
  * (gh#639) @alevy stabilized `_start` API for processes
  * (gh#646) @alevy documented and stabilized the Tock Binary Format (TBF)
  * (gh#623) @niklasad1 added a  generic user-level interface for Bluetooth Low Energy
  * (gh#628) @ppannuto documented how to create a userland library

#### Build System

  * (gh#650) @ppannuto added error reporting when rustfmt is misconfigured
  * (gh#653) @ppannuto made sure rustfmt is installed correctly
  * (gh#640) @ppannuto fixed discrepancy between GNU and BSD sed

#### Miscellenia

  * (gh#648) @hudson-ayers updated imix "Getting Started"
  * (gh#652) @adkinsjd added support for reading the MAX17205 ROM ID

### Proposed

#### Thread/6lowpan

  * (gh#642) @daniel-scs proposed a change to the AES HIL that better supports
    802.15.4 encryption.

  * (gh#649) @ppannuto used corrode to port the nrf5x startup code from C to Rust
  * (gh#657) @ppannuto proposed a way to deal with errata in specific chip versions

