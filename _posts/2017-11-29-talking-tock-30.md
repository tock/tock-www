---
title: Talking Tock 30
subtitle: A world tour, docs and so many contributors
author: aalevy
authors: alevy
---

This is the 30th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Generated Docs

Are now posted to <https://docs.tockos.org> automatically!

## World Tour

We literally went around the world in November!

First, we went to Shanghai to attend [SOSP
'17](https://www.sigops.org/sosp/sosp17/). We gave a tutorial the day before
the conference and presented a [paper](/assets/papers/tock-sosp2017.pdf) on
Tock on the second day.  Next, we were in Delft for [SenSys
'17](http://sensys.acm.org/2017/). We gave _another_ tutorial there, and
presented demos for Tock and Signpost.

## A Growing Community

There are now a growing number of active contributors from a variety of
institutions using Tock for a bunch of reasons. I'm going to try my best to
keep an account of what folks are doing and update here. But I'll probably miss
some.

A brief overview:

  * Researchers at U.C. Berkeley are continuing to work on and deploy Signpost.

  * There are a number of ongoing projects at Stanford:

    * 6lowpan/Thread support

    * A low power MAC for 802.15.4

    * Dynamic clock management for the SAM4L

    * Support for the Teensy board

  * Students at Chalmers University are starting to work on power-aware process
    scheduling and potentially native support for connection-oriented Bluetooth
    Low Energy on the NRF52.

  * @niklasad1 continues to improve BLE advertising on the NRF52, including
    currently advertising from unique addresses from each application.

  * Some folks from the community have begun working on ports to the STM32
    series of microcontrollers.

  * @JayKickliter and @Vagabond having been adding support for various
    controllers to the NRF52 for some, as of yet, undisclosed project.

## Pull Requests

### Merged

  * Changes to kernel `debug!` semantics (remove some metadata by default)
  * Improvements to SAM4L Flash driver's state machine
  * Update Rust nightly
  * 6lowpan changes and fixes
  * Replace queue-based interrupt handling with NVIC registers
  * NRF52 I2C driver
  * Use LLVM's size optimizations
  * Imix getting started fixes
  * Convert nrf51 startup to Rust (using corrode)
  * Add RomID support to Max17025
  * Fix sensors app for NRF5x
  * Add the NRF51 serialization capsule to imix
  * Add imix test app
  * Fixes to ELF2TBF
  * Rustdocs posted automatically to <https://docs.tockos.org/>
  * Generalize nrf5x GPIOTE to work with variable number of channels in NRF51 vs NRF52
  * Remove unsafe from capsules and enforce through crate feature
  * Add write\_read to I2CMasterSlaveDriver

### Proposed

  * Support for STM32F1
  * Low power mac protocol (X-MAC)
  * Implement start() and stop() for rf233
  * FICR support in NRF52
  * Change the List datastructure to allow trait objects as items
  * CCM\* implementation for ieee802154 driver

