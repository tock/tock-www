---
title: Talking Tock 18
subtitle: SenSys tutorial, MPU improvements and a warm welcome
author: aalevy
authors: alevy
---

This is the 18th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

We bombarded ourselves this week with two continuous-sampling ADC
implementations for the SAM4L (OK, @brghena has been working on one of them for
a while), a SPI-slave implementation, MPU bugs and bug-fixes, a Lua runtime and
merging of @bradjc's long-standing accelerometer virtualization pull-request.
We officially welcomed @petarpenkov, @mog96, @bbbert and @ptcrews to the team.
They are from Stanford [CURIS](http://curis.stanford.edu/) students doing
research on Tock this summer and have already proposed two really high quality
pull requests.  And, as the last update mentioned, the SenSys tutorial is
happening this fall, and we're starting to hammer out the details.

@ppannuto, @brghena and @alevy found and finally addressed (almost completely)
a long standing issue with how process memory had to be organized due to MPU
constraints on the Cortex-M (PRs [#375] and [#384]). The problem had been that
the MPU requires regions to be aligned to their size, which has to be padded to
a power-of-two. So, if you had 18kB process, the region covering it had to be
padded to 32kB and it's base address had to be 32kB aligned. This resulted in
really large padding between processes and basically put a relatively low limit
on how large processes could be. The fix uses MPU subregions when necessary to
allow the base to be aligned at a finer granularity (basically 1/8th of the
next largest power of two), which in practice means that a 18kB process only
needs to be padded to 20kB (instead of 32kB) and the base address aligned to
8kB.


## Tutorial at SenSys

Our proposal was accepted to host a tutorial at SenSys 2017 (the ACM Conference
on Embedded Networked Sensor Systems) in Delft, The Netherlands on November
5th! You can sign up for updates and to be notified when registration opens
[here]({{ "/events/sensys2017" | relative_url}}). But, meanwhile, the cliffnotes.

### What will the tutorial cover?

The agenda for the tutorial is not yet finalized, but it will be 4-hours in the
afternoon, and will cover:

  - Introduction to Tock goals and design
  - Introduction to hail and imix hardware platforms
  - Hands-on Writing processes
  - Introduction to Rust
  - A hands-on tour of the kernel
  - Hands-on excercise Writing new drivers and system calls

### Is this tutorial right for me?

That's for you (or whoever is paying your registration fee) to decide.

The tutorial is geared towards the research community (particularly the sensor
networks community) and will therefore focus on using Tock in that context.
This means that the excercises we'll use will involve radios and sensors and
we'll tailor them to what we think the sensor network community would find most
useful.

## Pull Requests

### Merged

  * ([#359]) @bradjc upstreamed the LTC294X driver from Signpost

  * ([#238]) @bradjc's long-standing 9dof accelerometer virtualization pull-request was
    merged! There is still some discussion around the exact best way to
    virtualize drivers more generally, but this is definitely a step in the
    right direction.

  * ([#380]) @bradjc renamed fxos8700cq to be consistent with other driver naming.

  * ([#378]) @alevy added Lua userland support and a minimal example Lua app.

  * ([#375]) @alevy added MPU subregions for the text segment, allowing the text segment
    to be aligned at finer granularity than exactly its size.

  * ([#377]) @ppannuto updated MPU tests and added system calls to gather process memory
    information from userland.

### Proposed

  * ([#384]) @alevy generalized MPU subregions support to data, GOT and IPC sections.

  * ([#383]) @petarpenkov implemented ADC continuous sampling for the SAM4L with
    variable clocks.

  * ([#381]) @bbbert implented a SPI slave with DMA for the SAM4L.

[#359]: https://github.com/helena-project/tock/pull/359
[#238]: https://github.com/helena-project/tock/pull/238
[#380]: https://github.com/helena-project/tock/pull/380
[#378]: https://github.com/helena-project/tock/pull/378
[#375]: https://github.com/helena-project/tock/pull/375
[#377]: https://github.com/helena-project/tock/pull/377
[#384]: https://github.com/helena-project/tock/pull/384
[#383]: https://github.com/helena-project/tock/pull/383
[#381]: https://github.com/helena-project/tock/pull/381
