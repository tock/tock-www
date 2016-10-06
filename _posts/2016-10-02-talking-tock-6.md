---
title: Talking Tock Week 6
author: aalevy
authors: alevy
---

This is the sixth post in a weekly series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## HIL updates

Towards our goal releasing a stable enough version in early November to
distribute, we're working on revising the hardware interface layer (HIL) traits
that glue chip-specific capsules (like a UART) with portable capsules (like a
console).

@alevy posted a proposed revision of time related HIL traits---`Alarm` and
`Timer`---to the [mailing
list](https://groups.google.com/forum/#!topic/tock-dev/-aAu9oVYhVA). The
`Alarm` trait lets a client set an alarm for a particular value of a wrapping
counter. The `Timer` trait lets clients get a notification after a certain
number of cycles has elapsed. We currently use Alarm for the TimerDriver (which
acts like the Timer trait but for user space) as well as for virtualizing in
the kernel since it is more accurate to virtualize.

@emosenkis proposed a a HIL trait for intrfacing with flash controllers.

@bradjc is working on extending the I2C HIL traits as part of his work on I2C
slave support for the SAM4L (more details below).

## I2C device driver

Until recently, Tock only had an implementation for the master side of the I2C
interface. Our platform has a few I2C sensors, so that was the most important.
The Signpost project, however, requires the SAM4L to be an I2C slave as well.
@bradjc has been working on implementing both sides of the interface including
pretty significant changes to the HIL to make this reasonably clean.

