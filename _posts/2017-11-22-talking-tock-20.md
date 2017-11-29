---
title: Talking Tock 30
subtitle: 
author: aalevy
authors: alevy
---

This is the 30th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

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

