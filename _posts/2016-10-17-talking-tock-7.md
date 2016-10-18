---
title: Talking Tock Week 7
author: aalevy
authors: alevy
---

This is the seventh post in a weekly series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## Imix

The second revision of Imix board are back from the factory with a bunch of
hardware fixes. We are working out some final hardware nits, writing drivers
for the sensors (which are slightly different than the ones on the Firestorm)
and working out the details with Stanford administration of how to distribute
them. But everything is on track to be released by early November.

## HIL Reviews

We made inroads on updates to the HIL traits.

  * @phil-levis finalized an ADC HIL proposal, which @nealjack and @bradjc have
    implemented for the SAM4L (still in a pull request until they do some more
    validation).

  * @bradjc's I2C HIL has progressed significantly and only waiting on a few
    fixes to the I2C slave implementation to merge.

  * @alevy and @bradjc implemented and merged the discussed changes to the I2C HIL

  * @bradjc added support for using GPIO as a chip select on the SAM4L. This
    ended requiring a change to the SPI HIL where the the chip select type is
    associated to the SPI trait (blog post forthcoming just for that? Yes, I
    think so).

## NRF51 Port

  * @KMarshland implemented the Alarm trait for the NRF51's RTC controller
    which, unlike the Timer controller, can operate while the core is asleep.

  * @amilich implemented the UART trait for the NRF51.

The result of both of these changes is that the NRF51 can successfully run a
base set of applications for on Tock.

## Userland Changes

  * @alevy refactored libtock to remove board specific dependencies as much as
    possible, separating driver interfaces into separate modules.

  * @ppannuto made aesthetic improvements to the userland make system as well
    as functional changes that make sure changes are tracked more accurately.

## Interprocess communication (IPC): 30m (Amit)

We've begun prototyping an IPC system that would allow processes to expose
driver-like functionality. @alevy has
[implemented](https://github.com/alevy/tock/commit/5c12a4ab50883bb70d5e54c62ad8fc608c92a91e)
a first version and [described
it](https://groups.google.com/forum/#!topic/tock-dev/2-P6IhRTtdM) on the
mailing list.  The IPC system leverages the same system calls as other drivers
in the kernel, with some additional restrictions due to size and alignment
requirements of the ARM MPU.

