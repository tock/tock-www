---
title: Talking Tock 10
author: aalevy
authors: alevy
---

This is the tenth post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

## Pull Requests

### Merged

  * @brghena implemented a raw [SD card interface](https://github.com/helena-project/tock/pull/283)
  over SPI (as opposed to SDIO) including a capsule for interfacing in the
  kernel and one for exposing a system call interface to applications.

  * @daniel-scs finished fixing a
    [README](https://github.com/helena-project/tock/pull/281/) for imix that
    includes instructions for debugging, programming applications and getting
    console output.

  * @daniel-scs made
    [additional](https://github.com/helena-project/tock/pull/285)
    [changes](https://github.com/helena-project/tock/pull/286) fixing errors in
    the documentation.

  * @phil-levis wrote a [TRD for 802.15.4 radios](https://github.com/helena-project/tock/pull/287).

  * @alevy's [TRD for GPIO](https://github.com/helena-project/tock/pull/278) was merged.

  * @alevy added system-call level virtualization to the
    [ADC](https://github.com/helena-project/tock/pull/288).

  * @alevy fixed a bug in the [timer driver](https://github.com/helena-project/tock/pull/291)
  that resulted in applicaiton timers scheduled to fire within microseconds of
  each other were not firing.

### Proposed

  * @ppannuto proposed a work-in-progress [change](https://github.com/helena-project/tock/pull/289/)
  moving the application stack to the bottom of application memory.

## imix

The crowd campaign for imix was unsuccessful, but we're continuing to fix the
remaining bugs. Our most blockig issue has been one where turning on peripheral
chips, like the RF233 radio or auditable RNG resulted in brown-outs of the main
chip. @shaneleonard and @kwantam have been able to [identify the
problem](https://github.com/helena-project/imix/issues/12) and have a [fixed
revision](https://github.com/helena-project/imix/issues/12) on the way.

## Community

We deployed BotBot (formerly at https://bot.tockos.org) to log our [IRC
channel](https://kiwiirc.com/client/irc.freenode.net/tock). It's open and
public and we're hoping this makes IRC a more welcoming medium to come talk to
us.
