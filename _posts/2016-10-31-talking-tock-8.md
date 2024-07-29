---
title: Talking Tock Week 8
authors: alevy
---

This is the eighth post in a weekly series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## Imix

We've sent out for production what we think is going the final version of imix.
It includes fixes to a variety of small electrical issues we found after
porting more of Tock to it. The final revision Will cost around $90 to produce
at medium-scale (100s) and we plan on making these available at cost (plus
whatever overhead) sometime in the next couple months.

## Drivers, Capsules and Interfaces

  * @bradjc merged several of their drivers from signpost upstream, including:

    - SI7021 temperature and humidity sensor

    - FM25CL FRAM storage

  * @bradjc's changes to the ADC are merged

  * We added an LED and Button driver similar to the GPIO driver to allow cross
    platform applications to use whichever buttons and LEDs are available.

  * @KBaichoo [fixed](https://github.com/helena-project/tock/pull/175) a gnarly
    bug in the SAM4L SPI controller capsule.


## Interprocess communication (IPC)

@alevy opened a [pull request](https://github.com/helena-project/tock/pull/160)
to begin merging work on an interprocess communication model based on the
existing system call interface.

