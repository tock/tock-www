---
layout: page
title: Getting Started
description: Tock Getting Started
permalink: /documentation/getting-started/
---


Tock is an embedded operating system designed for running multiple concurrent, mutually
distrustful applications on Cortex-M based embedded platforms. Tock's design
centers around protection, both from potentially malicious applications and
from device drivers. Tock uses two mechanisms to protect different components
of the operating system. First, the kernel and device drivers are written in
Rust, a systems programming language that provides compile-time memory safety,
type safety and strict aliasing. Tock uses Rust to protect the kernel (e.g. the
scheduler and hardware abstraction layer) from platform specific device drivers
as well as isolate device drivers from each other. Second, Tock uses memory
protection units to isolate applications from each other and the kernel.


Learn More
----------

How would you like to get started?

### Use Tock

First, follow our [getting started guide](https://github.com/helena-project/tock/blob/master/doc/Getting_Started.md) to setup
your system to compile Tock and Tock applications.

Then head to the [hardware page](/hardware)
to learn about the hardware platforms Tock supports. Also check out the
[tutorials](https://github.com/helena-project/tock/blob/master/doc/tutorials) to get started running apps with TockOS.


### Develop Tock

Read our [getting started guide](https://github.com/helena-project/tock/blob/master/doc/Getting_Started.md) to get the correct
version of the Rust compiler, then look through the `/kernel`, `/capsules`,
`/chips`, and `/boards` directories.

We're happy to accept pull requests and look forward to seeing how Tock grows.


### Learn How Tock Works

Both the design and implementation of Tock are documented in the
[docs](https://github.com/helena-project/tock/blob/master/doc) folder. Read through the guides there to learn about the kernel,
Tock's use of Rust, the build system, and applications.


### Keep Up To Date

Check out the [blog](/blog) where the **Talking Tock**
post series highlights what's new in Tock and follow
[@talkingtock](https://twitter.com/talkingtock) on Twitter.

You can also browse and subscribe to our [email
group](https://groups.google.com/forum/#!forum/tock-dev) to see discussions on
Tock development.
