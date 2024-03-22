---
layout: page
title: CPS-IoT 2024 Tock Tutorial
description: Tutorial Page
permalink: /cps-iot-2024
---

## Rapid Prototyping for Cyber-Physical Systems and IoT Applications with the Tock Embedded Operating System

We will be holding a half-day tutorial at [CPS-IoT Week](https://cps-iot-week2024.ie.cuhk.edu.hk/index.php) on the Tock Operating System. This tutorial will take place on Monday, May 13, 2024 ([agenda]({% link _pages/cps-iot-2024/agenda.md %})).

## Who is this tutorial for?

This tutorial is for researchers and industry stakeholders interested in any combination of embedded operating systems, wireless sensor networking, IoT, Rust, or simply hacking on a project for an afternoon. We assume no prior knowledge in Tock and will provide a detailed guide to assist participants in the tutorial.

## What is Tock?

Tock is a secure, multi-programmable embedded operating system. The core kernel is written in Rust, a new type-safe systems language. Developers can dynamically load processes written in any language, which Tock isolates using the memory protection unit (MPU) or equivalent hardware typically available on microcontroller-class devices. Tock is designed and implemented by collaborators at Stanford, University of Virginia, Princeton, and UC San Diego, with additional developers at Chalmers, Google, Western Digital, HP Labs, MIT, NASA Ames, and others in industry. To learn more about our operating system, you can find additional documentation both [here](https://tockos.org/documentation) or in the [tock book](https://book.tockos.org).

## Tutorial Goals

The goal of the tutorial is to introduce the OS to researchers in the CPS-IoT community, get them started writing applications, and make them familiar with the kernel. The tutorial will provide small hardware kits (further nodes supported by Tock can be purchased online). The emphasis of the tutorial will be for Tock’s potential as a platform for easing, accelerating, and enhancing research and prototyping of CPS and IoT systems and applications.

Tock provides a unique advantage for CPS and IoT research as the operating system by default provides process isolation and memory safety for the core kernel. As such, researchers can spend more time on CPS and IoT research rather than time spent configuring the MPU or radio drivers. Moreover, the Tock kernel provides the advantages of a modern type-safe language while still providing the freedom to develop user applications in C.

Having a modern, secure OS platform has the potential to help coalesce the CPS-IoT community around a set of shared important research problems. We think Tock has the potential to be such an OS/platform and would like to provide a tutorial to help colleagues and fellow researchers in learning to use it.

## Tutorial Overview

In this tutorial, participants will create a wireless sensor network application using Tock and [OpenThread](https://openthread.io). To participate in this tutorial, please register for the RUSTIC tutorial. We will provide participants with additional instructions and details as we approach the conference.
