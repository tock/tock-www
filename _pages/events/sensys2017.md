---
layout: page
title: Tock Tutorial @ SenSys 2017
subtitle: SenSys Tock Tutorial, Sunday, November 5th in Delft
description: >
  A Tock tutorial for the sensor-networks community, co-located with SenSys
  2017.
permalink: /events/sensys2017
---

The Tock operating system is a secure, embedded kernel for sensor network and
Internet of Things systems using Cortex-M micro controllers. Written in the
Rust language, it supports kernel extensions in Rust as well as multiple
concurrent applications written in C, Rust, or Lua. This tutorial will give an
introduction to programming in Tock as well as an overview of its architecture.
Attendees will write a user-land networking application in C as well as a
kernel extension in Rust. Attendees will be provided hardware kits, which they
may optionally purchase as part of the registration fee.

You can register now through the SenSys [registration
page](http://sensys.acm.org/2017/registration/).  During registration, select
"Workshop or Tutorial", then select "Tock Operating System Tutorial" from the
drop-down menu titled "Which Workshop or Tutorial".


## Prerequisites

Please bring a laptop to use during the tutorial and download the
[Tock VM](http://www.scs.stanford.edu/~alevy/Tock.ova) in advance.
If you prefer to develop natively, please finish the Tock
[Getting Started](https://github.com/helena-project/tock/blob/master/doc/Getting_Started.md)
guide so that everything is downloaded in advance.

## Schedule and Agenda

- **13:00-14:00** Lunch
- **14:00-17:30** Tock Tutorial
  - Part 1: Intro to Tock, development environment, and hardware
  - Part 2: Userland programming in Tock
     - Sycall interface
     - Synchronous & Asychronous Programming
     - Inter-Process Communication
  - Part 3: Kernel Hacking
     - From boot to board
     - Building a basic capsule (driver)
