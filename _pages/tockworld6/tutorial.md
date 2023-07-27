---
layout: page
title: Tock Tutorial 2023
description: Tutorial to learn how to Tock.
permalink: /tockworld6/tutorial
---

Welcome to the 2023 Tock Tutorial! This one-day, in-person workshop will teach
how to use the [Tock operating system](https://www.tockos.org/) for secure and
reliable embedded systems.

Tock is a new operating system for embedded microcontrollers with a focus on
safety and security. The kernel is written entirely in Rust, and the OS supports
multiple independent applications which execute isolated from the rest of the
system. Tock is being used for [security key
fobs](https://www.tockos.org/blog/2020/hello-opensk/), [root of trust
silicon](https://github.com/google/tock-on-titan), wireless sensor nodes,
[automotive ECUs](https://oxidos.io/), and other security-focused devices.

### Tutorial Overview

<img src="/assets/img/tock_tutorial_sensys17_01.jpg" width="23%">
<img src="/assets/img/tock_tutorial_sensys17_02.jpg" width="23%">
<img src="/assets/img/tock_tutorial_sosp17.jpg" width="23%">

The tutorial will provide hands-on experience with three aspects of Tock: the
kernel, mutually distrustful applications, and secure systems. Each participant
will have their own embedded development board to use and prototype with.

The final session will have participants develop a security-focused application:
either a HTOP security key fob or a physical security wireless sensor.

Tock is an open-source project [led by a
consortium](https://github.com/tock/tock/tree/master/doc/wg/core) of developers
from academia and industry. Tock extensively uses
[Rust](https://www.rust-lang.org/) to increase system robustness and minimize
the amount of untrusted code in the kernel. If you are interested in Rust this
tutorial will introduce you to a mature Rust project focused on embedded
programming. If you are _not_ interested in Rust, the tutorial will also include
application-level development in C.

## Details

- Date: Wednesday, July 26, 2023
- Location: [Rice Hall](https://goo.gl/maps/uVcsA4eVU11HmwXA7), University of Virginia
- Room: Rice 130 (Lecture hall on main floor)
- Time: 10 am - 4 pm

[Metered parking](https://goo.gl/maps/eU1oYfHDfA9noXVg7)

## Registration

Registration is available [here](https://www.eventbrite.com/e/tock-tutorial-2023-tickets-641499280617)!

## Schedule

_Note, schedule is subject to change._

|  Time |  Topic                                               |
| ----- |------------------------------------------------------|
|  9:30 |  Arrival and Check-in                                |
| 10:00 |  Welcome and Overview of Tutorial                    |
| 10:15 |  [Introduction to Tock](/assets/tockworld6/tock_overview.pdf) - [(pptx)](/assets/tockworld6/tock_overview.pptx) |
| 10:45 |  Tutorial Lesson 1                                   |
| 12:00 |  Lunch Break                                         |
|  1:00 |  Tutorial Lesson 2                                   |
|  2:15 |  Break                                               |
|  2:30 |  Tutorial Lesson 3                                   |
|  3:45 |  Wrap Up                                             |

The tutorial itself can be found at: [https://book.tockos.org/key-overview.html](https://book.tockos.org/key-overview.html)

## Hardware

<img src="/assets/img/nRF52840-DK.webp" width="35%" style="float:right;">
The tutorial is a hands-on experience where we will develop on real hardware.
Tock supports numerous hardware platforms, but for the tutorial we will use
platforms based on the Nordic nRF52840 microcontroller. Specifically, we will
use the [nRF52840
DK](https://www.nordicsemi.com/Products/Development-hardware/nrf52840-dk) board
([mouser](https://www.mouser.com/ProductDetail/Nordic-Semiconductor/nRF52840-DK?qs=F5EMLAvA7IA76ZLjlwrwMw%3D%3D),
[digikey](https://www.digikey.com/en/products/detail/nordic-semiconductor-asa/NRF52840-DK/8593726)).

We encourage you to bring your own nRF52840-DK board so you can continue using
Tock after the tutorial. Otherwise, we will have hardware boards available at
the tutorial you can borrow.

## Tutorial Sessions

The tutorial will be organized around three steps in one overarching theme: the
creation of a USB security key.

### Session 1: HOTP Application

We will start by using and improving a userspace application that implements an
HOTP security token. Consistent with other operating systems, Tock considers
applications interdependently of the kernel, and as such applications can be
written in any programming language (although we'll use C for this tutorial).
Importantly, the Tock kernel guarantees (as part of the thread model) that
applications cannot maliciously affect other applications or the kernel. 


### Session 2: Encryption Oracle Capsule

In this session we will improve our security key by developing our own kernel
capsule which is capable of encrypting and decrypting HOTP secrets. This will
introduce the Tock threat model and how Tock's architecture helps minimize
potentially buggy code in the Tock kernel. As Tock is written in Rust, this
session will introduce the subset of Rust (i.e. no dynamic memory allocation)
used in the kernel, as well as some Rust programming concepts.

### Session 3: Access Control

Building on the first two sessions, in the third session we will implement
access control in Tock to limit which applications can run on our USB security
key and ensure that only allowed apps have access to the encryption oracle
capsule we developed.

