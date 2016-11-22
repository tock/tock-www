---
title: Talking Tock Week 9
author: aalevy
authors: alevy
excerpt: >
  This is the ninth post in a weekly (well... in theory) series tracking the
  development of Tock, a safe multi-tasking operating system for
  microcontrollers.
---

_We're making imix, the development board we've been using to build Tock,
available through Crowd Supply. [Sign
up](https://www.crowdsupply.com/helena-project/imix) to get updates on our
crowd funding campaign!_

This is the ninth post in a weekly (well... in theory) series tracking the
development of Tock, a safe multi-tasking operating system for
microcontrollers.

We paused our reports for even longer than normal, but it doesn't mean we've
stopped working. Last week, we
[demoed](http://dl.acm.org/citation.cfm?id=2996539&CFID=865195251&CFTOKEN=19552591)
Tock and [imix](https://github.com/helena-project/imix) at ACM Conference on
Embedded Networked Sensor Systems (SenSys). We finished up a bunch of
oustanding tasks coming up to the demo.

Inter-process communication has been merged. The [pull
request](https://github.com/helena-project/tock/pull/160) includes an
explanation of how to use it and how it's implemented and next we'll add
documentation to do the same.

@bradjc added an LPS25HB pressure sensor driver, TSL2561 light sensor driver
and a driver to do I2C communication directly from processes.

@amilich and @KMarshland added a process API for sending and receiving raw
802.15.4 packets including.

