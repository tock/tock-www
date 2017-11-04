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

## Location

The tutorial will be co-located with other tutorials and workshops at TU Delft
Faculty of Technology, Policy and Management at Jaffalaan 5.

<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2456.2276874268014!2d4.368095715788242!3d52.00272887971946!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47c5b593129f6993%3A0xc3e6dc47b6c95bba!2sTU+Delft+Faculty+of+Technology%2C+Policy+and+Management!5e0!3m2!1sen!2snl!4v1509771675388" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>

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
