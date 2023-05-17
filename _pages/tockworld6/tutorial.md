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

The tutorial will provide hands-on experience with three aspects of Tock: the
kernel, mutually distrustful applications, and secure systems. Each participant
will have their own embedded development board to use and prototype with.

The final session will have participants develop a security-focused application:
either a HTOP security key fob or a physical security wireless sensor.

Tock extensively uses [Rust](https://www.rust-lang.org/) to

## Details

- Date: Wednesday, July 26, 2023
- Location: [Rice Hall](https://goo.gl/maps/uVcsA4eVU11HmwXA7), University of Virginia
- Time: 10 am - 4 pm

## Registration

Registration will open soon!

## Schedule

|  Time |  Topic                                               |
| ----- |------------------------------------------------------|
|  8:30 |  Arrival and Check-in                                |
| 10:00 |  Welcome and Overview of Tutorial                    |
| 10:15 |  Introduction to Tock                                |
| 10:45 |  Tutorial Lesson 1                                   |
| 12:00 |  Lunch Break                                         |
|  1:00 |  Tutorial Lesson 2                                   |
|  2:15 |  Break                                               |
|  2:30 |  Tutorial Lesson 3                                   |
|  3:45 |  Wrap Up                                             |

## Hardware

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

The tutorial will be organized around three specific sessions with dedicated
topics.

### Session 1: Kernel Capsules

In this session we will modify and customize the Tock kernel by developing our
own capsule. This will introduce the Tock threat model and how Tock's
architecture helps minimize potentially buggy code in the Tock kernel. As Tock
is written in Rust, this session will introduce the subset of Rust (i.e. no
dynamic memory allocation) used in the kernel, as well as some Rust programming
concepts.

### Session 2: Userland Applications

The Tock operating system exposes a system call interface between kernelspace
and userspace, and in this session we will explore developing applications that
run on top of Tock. Consistent with other operating systems, Tock considers
applications interdependently of the kernel, and as such applications can be
written in any programming language. We will explore both applications written
in C as well as in Rust. Importantly, the Tock kernel guarantees (as part of the
thread model) that applications cannot maliciously affect other applications
or the kernel. To demonstrate this, we will write intentionally malicious apps
and demonstrate continued system robustness.

### Session 3: System Demo

Building on the first two sessions, in the third session we will build
realistic, security-focused devices using Tock. One option will be to develop a
security USB key which can be used for secure logins with one time passwords.
The other option will be to build a sensor node capable of reliably monitoring
indoor physical security.
