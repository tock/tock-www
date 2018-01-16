---
title: Talking Tock 33
subtitle: Baby's first GitHub org, networking and ports
author: aalevy
authors: alevy
---

This is the 31st post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Virtualizing Bluetooth Low Energy Advertisements

@niklasad1 wrote about his recent pull request adding a BLE advertising system
call interface for the nRF5x microcontrollers. Read [here]({% post_url
2018-01-09-ble-virtualization %}) about how Tock now supports several processes
advertising as completely different BLE devices on the same radio.

## Designing a Network Stack for 6lowpan

@hudson-ayers led an effort to write design document laying out how we should
build the Tock networking stack to support Thread and other 6lowpan-based
networks. The document is now merged into master, and work is ongoing to
implement it. Check out the document
[here](https://github.com/helena-project/tock/blob/master/doc/Networking_Stack.md)
for a good description of 6lowpan and an interesting overview of how to design a
flexible framework for it.

## Tock's Own GitHub organization

We'll slowly be migrating Tock-related repositories from the `helena-project`
GitHub organization to a new `tock` GitHub organization. We hope this will make
various Tock-related projects (e.g. the bootloader, out-of-tree ports) more
discoverable. It also gives us a bit more flexibility to give administrative
access to contributors who probably don't belong in same GitHub organization we
post all of our academic paper rejections.

For a bit of history, Tock had its beginning as an ambitious but modest
collaborative project between students and faculty at Stanford, U.C. Berkeley,
and University of Michigan, that collaborates on a handful of different Internet
of Things related projects. For the purposes of a mailing list name, we dubbed
our group Helena Project, and created a GitHub org where our projects lived,
including Tock. It's time to graduate the Tock project and recognize that it's
one with a community outside our little research group.

## Porting to new chips and boards

In the last couple months a few separate efforts have emerged to port Tock to
new chips and boards. We're all very excited about these efforts and want to
help support them as best we can.

We need to figure out if the best way for these efforts to happen is in the main
tree, in which case we need to get our hands on all of this hardware and set up
more rigorous testing for the core repository, or out-of-tree, in hardware
specific repositories.

### STM32 & Discovery Boards

The STM32 series of microcontrollers is a pretty popular choice. @george-hopkins
ported Tock to the STM32F1 sub-family, (gh#686). Others have since either added
to this effort or done their own ports for different sub-families.

While STM32 is a good candidate for a main family of chips to support, it has
its own complexities: sub-families have different overlapping hardware
interfaces in common, some chips have features Tock relies on (i.e. the MPU),
while others don't. There also isn't a _single_ board that's representative of
the whole family, so it's not clear which one we would go with off-the-bat.

For now it seems like the best way to not leave code in pull requests without
having answers straight away to all these questions is to setup an [independent
repository](https://github.com/tock/tock-stm32) that will host the ports.

### Teensy

@shaneleonard wrote a [port for the Teensy
3.6](https://github.com/shaneleonard/tock-teensy) to help teach an embedded
systems class at Stanford.

## RFCs

  * (gh#695) Meta-data attributes for bootloader, kernel and processes
  * (gh#716) Blutooth Low Energy Advertising System-Call Interface 
  * (gh#722) Features to stabilize for a 1.0 release

## Pull Requests

### Merged

  * (gh#710) Networking stack design document
  * (gh#718) Fix auto-format when using VSCode
  * (gh#719) Enable remaining GPIO pins on NRF52DK
  * (gh#720) Bump rustc and rustfmt nightly 
  * (gh#721) Fixes to NRF5X radio Configuration, BLE driver & libtock, and BLE tests
  * (gh#724) Semantic instead of lexical version comparison for xargo et al
  * (gh#725) Removes remnant of old instructions from nRF52-DK getting started guide
  * (gh#727) Clarify that `main`'s return value may change in documentation

### Proposed

  * (gh#714) Move process relocation to userland
  * (gh#713) Add MPU & SysTick support for NRF52

