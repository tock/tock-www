---
title: Talking Tock 28
subtitle: Recapping the last couple months
author: aalevy
authors: alevy
---

This is the 28th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

How long has it been since our last update? Nearly two months??? Well, ain't
nobody getting paid to post these, and I've been busy. Since our last update we
ran a training at RustConf, the students working with us over the summer made a
lot of progress towards a [Thread](http://threadgroup.org) implementation and
our paper was accepted to SOSP '17. Exciting stuff!

1. TOC
{:toc}

## Niklas Speaking at RustFest

If you're attending [RustFest](http://zurich.rustfest.eu/) in Zurich this weekend, be sure to go see our
own @niklasad1 give a talk on his master's thesis work (with @frenicth) on
porting Tock to the NRF51 and implementing a pure Rust Bluetooth Low Energy
stack.

His talk is on Saturday after lunch at 2:30pm.

## RustConf Training

There was an incredible turnout for the Tock training at RustConf. After a few
last minute sign-ups, we ended up with a 30-person room at capacity. From our
informal survey of the room (a more formal one coming), there were folks from
big companies (like Mozilla and Intel), small companies (like Helium), and no
companies. It was a really great meeting all of you, and thanks for turning
up!

We went over the general design of Tock, then worked with [Hails]({{
  "/hardware/hail" | relative_url }}) to write a capsule that sampled
accelerometer data and a userland application in Rust. All the training
materials are available in the main Tock repo
<https://github.com/helena-project/tock/tree/master/doc/courses/rustconf>

We'll be running similar tutorials (though more geared for academics) at SOSP
and SenSys, and James Munns will be running an embedded Rust workshop at
RustFest next weekend with some overlap. So if you weren't able to attend
RustConf, there will be other opportunities!

## Thread/6lowpan Progress

Hubert Teo (@bbbert), Paul Crews (@ptcrews) and Mateo Garcia (@mog96) are three
Stanford students who worked over the summer to implement 6lowpan and Thread
support for Tock. Briefly, 6lowpan is a standard for tunneling IPv6 packets
over the low-power 802.15.4 wireless radio standard (the same one used in
ZigBee). It's a fairly common standard in wireless sensor networks in
academia, and has also been picking up steam in home automation recently
thanks to the Thread group standardizing a set bunch of related protocols
around 6lowpan for network configuration (if you're working on Thread
professionally and are reading this, when are we getting an OnHub router that
supports Thread??).

Implementing full support for Thread turns out be a pretty big task
since it involves a handful of different protocols as well as some low-level
802.15.4 features that hadn't been implemented for the RF233 driver in Tock. It
also took some effort to get a test rig up since there isn't any commercially
available hardware that supports Thread natively just yet.

Nonetheless, the students did a really impressive job. As of the end of the
summer, Tock has support for 6lowpan compression and decompression, support for
packet fragmentation (pending a pull request being merged), most of the Thread
security layer, and support for parsing network provisioning messages.

Their end of the summer [write-up]({{
  "/assets/papers/tock-os_thread-protocol-impementation-status_2017-08-31.pdf"
  }}) gives more details on their implementation effort and includes a really
nice summary of the Thread/6lowpan stack.

## SOSP Paper

We just submitted the camera-ready (i.e. final version) of a paper we wrote
detailing the design and implementation of Tock for SOSP (Symposium on
Operating Systems Principles). You can [read the full
paper](/assets/papers/tock-sosp2017.pdf). We also posted a summary
[yesterday]({% post_url 2017-09-25-sosp-paper %}).

## Pull Requests

There has, of course, been plenty of regular work going on, too. The numbers of
pull requests merged and proposed is a bit overwhelming, so I broke them into
categories this time.

### Merged

#### Thread/6lowpan

  * (gh#524) @bbbert implemented ieee802154 data frame encoding & decoding
  * (gh#578) @bbbert implemented ieee802154 mac security
  * (gh#589) @bbbert fixed the interrupt handling flow for the rf233 radio driver
  * (gh#588) @mog96 implemented encoding and decoding for Thread's TLV mesh link establishment messages
  * (gh#607) @bbbert virtualized the ieee802154 radio layer

#### NRF5x Port

  * (gh#583) @niklasad1 added error messages when using program option for nrf5x boards
  * (gh#585) @niklasad1 refactored much of the nrf51 and nrf52 code into a common nrf5x crate
  * (gh#615) @JayKickliter implemented a SPI master adaptation driver for the NRF52

#### Towards Tock 1.0

  * (gh#560) @alevy changed the console driver to require a `command` to trigger a transaction
  * (gh#573) @alevy added an ambient light sensor HIL
  * (gh#586) @alevy Fix elf2tbf to use a dynamically generated text-region base address
  * (gh#582) @niklasad1 implemented generic interfaces for humidity and temperature sensors

#### Userland

  * (gh#556) @bradjc made Bluetooth Low Energy environment sensing a userland service
  * (gh#584) @shaneleonard created a unit testing framework for processes

#### Administrativia

  * (gh#568) @ppannuto made sure GCC version is checked in kernel build
  * (gh#577) @alevy removed `imixv1` board from the tree
  * (gh#569) @phil-levis added support for the kernel to allocate regions of flash memory for storage
  * (gh#591) @ppannuto added some more comments to the Hail board
  * (gh#606) @JayKickliter added automatic conversion of `process:Error` to `ReturnCode`
  * (gh#609) @bradjc added a pull request template
  * (gh#611) @ppannuto added a style section to the CONTRIBUTING document
  * (gh#612) @bradjc added `and_then()` methods to `TakeCell` and `MapCell`
  * (gh#620) @bradjc update us to a recent version of `rustc`
  * (gh#624) @alevy renamed `Container` to `Grant` to match documentation and paper

### Proposed

#### Thread/6lowpan

  * (gh#581) @ptcrews implemented 6lowpan fragmentation

#### Towards Tock 1.0

  * (gh#599) @alevy proposed a standardization of some system call interfaces for Tock 1.0
  * (gh#623) @niklasad1 proposed a generic user-level interface for Bluetooth Low Energy

#### Administrativia

  * (gh#614) @phil-levis proposed a generical virtualization layer for kernel interfaces

