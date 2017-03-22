---
title: Talking Tock Week 5
author: aalevy
authors: alevy
---

This is the fifth post in a weekly series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

Recently, these updates have been closer to semi-weekly at best, but at least
that means there's plenty to talk about.

## HIL updates

Towards our goal releasing a stable enough version in early November to
distribute, we're working on revising the hardware interface layer (HIL) traits
that glue chip-specific capsules (like a UART) with portable capsules (like a
console).

We've begun discussing the UART on the [mailing
list](https://groups.google.com/d/topic/tock-dev/Inl2rtoKPfw/discussion) and
@brghena has started prototyping these changes in the [uart-async
branch](https://github.com/helena-project/tock/blob/66f7794e078f024499e397cf6e0b4fce010f9b08/kernel/src/hil/uart.rs).
The high-level take aways from the discussion is that it's important to remove
any synchronous calls from the trait and add the ability to receive more than
one byte at a time. We'll also introduce a new `Buffer` type that wraps
statically allocated slices to specifically allow slicing buffers with out
losing the ability to exchange the new slice for a reference to the entire
buffer.

We also started discussing the GPIO trait in our weekly calls.
We're still resolving some basic questions like how to handle different chip
semantics for enabling read and write simultaneously and separating pin control
from configuration. @bradjc has begun
[prototyping](https://github.com/helena-project/tock/pull/112) some of the
changes.

## Virtual SPI

@bradjc [added](https://github.com/helena-project/tock/pull/108) a virtual SPI
capsule that controls the chip select lines for an entire bus and interleaves
SPI transactions to different peripherals. It's mostly modeled after the
virtual I2C capsule.

Offline, we've discussed some issues that arise with peripheral drivers that
may need more control over when their chip select line is de-asserted. The
solution to that will likely be to simply have another option for a
slightly-less virtualized capsule. Specifically, clients will be able to "lock"
the bus until a high level transaction is completed, but will mean peripheral
drivers on the same bus will have to trust each other to "unlock" the bus at
some point.

## Directory restructure

We
[discussed](https://groups.google.com/d/topic/tock-dev/7d-FdWP6Zu0/discussion)
then [implemented](https://github.com/helena-project/tock/pull/113) directory
structure changes to make it easier and more sensible to navigate despite
including several logical crates. In the process, we took the opportunity to
combine several crates (`common`, `hil`, `support` and `main` are now all in
the `kernel` crate), rename the `platforms` folder to `boards` (which is less
ambiguous) as well as finally switch over completely to a Cargo based build
system for the kernel.)

Similarly, we reorganized the user-land library and apps folder into a single
`userland` directory and simplified the build system for apps significantly.
First, the user-level library is compiled into a static library which can be
included as is in any app so it should be easier to build apps out-of-tree.
Second, the Makefile build system has been simplified to a single Makefile that
apps include, while the application's Makefile can compile sources in object
files however it wants, as long as those object files end up in the `OBJS`
variable.

## `s/wait/yield/g`

The simpler build system for applications turned out to be more robust and
revealed a naming conflict between Tock's `int wait(void)` system call and the
POSIX `pid_t wait(int*)` call in libc. We
[decided](https://github.com/helena-project/tock/pull/116) to rename `wait` to
`yield` throughout Tock.
