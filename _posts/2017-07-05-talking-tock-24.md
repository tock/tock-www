---
title: Talking Tock 24
subtitle: uAs during sleep, ADC clocks and too many PRs to count
author: aalevy
authors: alevy
---

This is the 24th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}


Maybe it's just some remaining pent-up excitement after taking a break to write
papers a couple months ago. Or maybe it's just the bright sun keeping us in our
windowless labs[^1]. But the last few weeks have seen a notable uptick in
activity on the Tock repo. As we march forward towards a deployment of the
Signpost sensor network, and gear up for tutorials at [RustConf] and [SenSys],
we've been knocking off features.

The theme this week is managing both low-power sleep and clock choices in the
kernel.

[^1]: I actually have southern facing windows by my desk, so it's probably not that
[RustConf]: /events/rustconf2017
[SenSys]: /events/sensys2017

## Low Power is close!

One of the main features Signpost needs from Tock is low-power operation. In
particular, it's the responsibility of the kernel to enter into the lowest
power state it sleeps (i.e. whenever there are no active events to run).

Our initial goal is to run typical applications have Tock enter the SAM4L's
deep-sleep state, which consumes ~5&mu;A with full RAM retention. In this
state, effectively the only things that can wake the CPU up are the
asynchronous timer (AST), certain pin interrupts (EIC), and an I2C device
(TWIS). But this matches typical sensor network applications: they'll sample
some sensors, transform the data in some way and potentially send some network
packets, then go to sleep for a certain amount of time (i.e. to be woken up by
a timer).

We now have basic functionality in place to support this, and are now working
on implementing the accounting in each each low-level chip-specific driver. So
far, it seems that the implementations are fairly straight forward.

You can read more about our current strategy for managing sleep states in
[yesterday's post]({% post_url 2017-07-04-low-power %})

## ADC Clock Management

An ADC (Analog to Digital Converter) is a hardware controller that converts a
continous analog signal, with infinite granularity, into a digital one that can
be processed by a computer. ADCs typically operate in one of two modes: a
single-shot mode that captures a single analog reading, and a continuous mode
that captures an analog signal over time. For example, audio is often encoded
as a 44kHz analog signal, meaning the analog value from a microphone needs to
be captured every 22&muS;.

In order to support a wide range of continuous ADC intervals, an application
needs to be able choose different clock sources for the ADC controller. For
example, on the SAM4L, the main system clock struggles to provide sampling at
frequencies sloware than 23Hz. On the other hand, the choice of clocks is very
hardware specific (microcontrollers don't have a standard set of clocks) so
it's better if applications don't have to choose clocks explicitly, but let the
kernel (particularly hardware-specific drivers) choose the optimal clock based
on the requested interval.

@petarpenkov implemented this capability for the SAM4L. Upon request for
continuous sampling at a given frequency, the slowest clock that can provide
this frequency is chosen. This effectively incorporates the RCSYS and RC32K
clocks working at a maximum of approximately 3600Hz and 1000Hz, respectively.

## Pull Requests

### Merged

  * @shaneleonard fixed SAM4L's GPIO configure(None) to explicitly set to GPIO
  * @bradjc added a BLE uart app
  * @adkinsjd added a yield_for_timeout userland library function
  * @bradjc updated comments and documentation for the button driver
  * @ppannuto update build system treatment of formatted files to only run formatting on modified files
  * @petarpenkov merged ADC Continuous interfaces
  * @ppannuto added human readable error code explanations in userland
  * @bbbert fixed imix binary path in build system
  * @bbbert fixed a logic bug in the RF233 driver
  * @bradjc implemented an AES driver for the SAM4L
  * @bradjc fixed packet ordering issue in the NRF serialization library
  * @niklasad1 fixed Getting Started documentation to reflect the correct version of rustc
  * @alevy started on changes towards low power:
    - Added calls to enable deep sleep on the cortex-m4
    - Added `prepare_for_sleep` method to the Chip trait and implemented it on the SAM4L
    - Fixed button driver to only enable pin interrupts when needed

### Proposed

  * @alevy made some unmerged changes for low power operation:
    - USART clock management
    - I2C clock management
  * @bbbert fixed two bugs in the SAM4L SPI slave implementation
  * @ppannuto fixed an annoying usability behavior in `make format`
  * @enzuru fixed an issue where the Xargo version wasn't being validated
