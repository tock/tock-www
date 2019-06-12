---
title: Talking Tock 11
author: aalevy
authors: alevy
---

This is the eleventh post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

## Tock In-Person

In the last two weeks we had two great in-person meetings. First, some of us
met at University of Michigan to tag-along to a workshop on
[Signpost](https://github.com/lab11/signpost), a modular city-scale sensing
platform that uses Tock under-the-hood. Next, some of us met at Stanford for a
Tock focused meeting. I forgot to snap some pictures to share even though I
intended to. But trust me, both meetings happened.

The Signpost meeting was particularly exciting because about 15 new programmers
built some Tock apps to run on Signpost. As the signpost platform matures, look
for new exciting announcements around hardware and platform availability, as well
as some new Tock primitives surrounding distributed programming and multicore
resource sharing that are in early discussion stages from the project.

## NRF51 Progress

@niklasad1 and @frenicth from Chalmers University have been making steady
progress on support for the NRF51. So far they have upstreamed support for the
temperature sensor and random number generator. Even more exciting, though,
they have prototyped support for the Bluetooth Low Energy advertising directly
in the Tock kernel! This will be one of only a
[small](https://mynewt.apache.org/)
[number](https://github.com/pauloborges/blessed) of open-source
(down-to-the-metal) Bluetooth Low Energy stacks and the only one in Rust.

Some cleanup and testing is still needed, but here's a
screenshot of the NRF51 development kit advertising from Tock to my phone:

![Advertising BLE in Tock](/assets/2017/03/ble.jpg "Advertising BLE in Tock")

## Pull Requests

### Merged

  * @brghena added [tracking of the minimum stack pointer](https://github.com/helena-project/tock/pull/296)
    ever observed in a userland process for debugging.

  * @frenicth [fixed `panic!`](https://github.com/helena-project/tock/pull/295) in the nrf51-dk.

  * @ppannuto fixed [MPU regions sizing](https://github.com/helena-project/tock/pull/297), [moved process stack](https://github.com/helena-project/tock/pull/289) below data and GOT
    sections so an MPU error will occur on a stack overflow and did some [C re-formatting](https://github.com/helena-project/tock/pull/301) for consistency

  * @niklasad1 and @frenicth added support for the NRF51's [temperature sensor](https://github.com/helena-project/tock/pull/306)
    and [random number generator](https://github.com/helena-project/tock/pull/308).
    They also implemented support for the [AES-CCM](https://github.com/helena-project/tock/pull/307),
    but we're waiting on upstreaming that until we have a better sense of how
    encryption hardware should be generalized across MCUs.

### Proposed

  * @phil-levis added support for [RF233 acks](https://github.com/helena-project/tock/pull/293)

  * @daniel-scs implemented support for the [SAM4L CRC controller](https://github.com/helena-project/tock/pull/303)
    and shared an early version through a pull request.
