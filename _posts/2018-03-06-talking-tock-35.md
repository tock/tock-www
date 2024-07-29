---
title: Talking Tock 35
subtitle: 1.0, Rust userland, and New Supported Boards
authors: alevy
---

This is the 35th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

{% include notice.html content="We're presenting Tock at the Linux Foundation's
OpenIoT summit in Portland in March! Check out the event website for [details
and
registration](https://events.linuxfoundation.org/events/elc-openiot-north-america-2018/program/schedule/)."
%}

1. TOC
{:toc}

## 1.0 Kernel Released

We silently tag our first rolling release of the Tock kernel in February. If
you're building applications with Tock or porting to a new board, and want to be
immune from updating your code everyday, you can work from that tag. We'll also
upload binary kernel images for the supported board sometime soon.

This first release includes ports to the nRF52 development kit and Hail and
imix, based on the Atmel SAM4L. It also includes system call drivers that comply
with the 1.0 system call ABI for process loading and:

 * Alarm
 * Console
 * LEDs
 * Buttons
 * GPIO
 * ADC
 * Ambient Temperature
 * Humidity
 * Luminance

## Rust Userland

@torfmaster and @Woyten have been reviving the [Rust userland
library](https://github.com/tock/libtock-rs). It had gone stale due to changes
in both Rust nightly as well as how processes are loaded by the Tock kernel. But
they've done a herculean effort to port the library and get applications back up
and working!

There is still some work left to be done to support things like global variables
and, in particular, trait objects, but now that there are some users there is
also reason to push on this.

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#658) **New register and bitfield interface**
  * (gh#736) **Code review process document & establishing a "core team"**
  * (gh#684) **ieee802154 CCM\* implementation and new symmetric encryption HIL**
  * (gh#740) Fix cut off buffer in NRF52 Bluetooth Low Energy scanning
  * (gh#743) Remove extraneous AES test
  * (gh#744) Remove transmute and constify register pointers in the Sam4l's AES driver
  * (gh#739) **Cortex-M3 architecture crate**
  * (gh#746) Add IPC support to NRF52
  * (gh#749) Don't use block\_size in the key context for symmetric encryption HIL
  * (gh#749) Enable graphical debugging in VSCode
  * (gh#753) Do not ignore errors setting GAP data
  * (gh#754) Fix function name typo in libtock
  * (gh#755) Fix documentation compilation
  * (gh#724) Port Sam4l DAC to new register macro
  * (gh#751) Port Sam4l AES to new register interface
  * (gh#759) Build docs on netlify rather than travis
  * (gh#758) Work around RF233 radio race condition (issue gh#617)
  * (gh#762) Flush debug buffer if needed before panic'ing
  * (gh#757) Update MAC layer to default to IEEE 802.15.4-2006 instead of IEEE 802.15.4-2015
  * (gh#769) Fix rustdoc deprecations in nrf51
  * (gh#770) Require docs for hail, imix crates
  * (gh#767) Move panic logic into kernel crate
  * (gh#768) Enable rust lint for nrf5x docs
  * (gh#772) Avoid use of now deprecated `#[repr(packed)]`
  * (gh#773) Passive voice was removed from PR template
  * (gh#775) Remove old and unused nrf51 codegen script
  * (gh#774) Make boards from older courses compile again
  * (gh#776) Hail: descriptive/consistent names in panic

### Proposed

  * (gh#757) **Add ability to deactivate subscribed callback in system call interface**
  * (gh#747) **Port to the TI launchxl-cc26x2**
  * (gh#750) **Port to the TI EK-TM4C1294XL evaluation kit**
  * (gh#760) **MMIO Interface with automatic peripheral clock management**
  * (gh#761) Configured Sam4l deep-sleep while using I2C
  * (gh#766) Port Sam4l USART to new register interface

