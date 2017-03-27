---
title: Talking Tock 14
subtitle: Hail release, TABs, timer bugs and hardware CRC.
author: aalevy
authors: alevy
---

This is the fourteenth post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## Hail released!

This week @bradjc, @brghena and @ppannuto [released Hail]({% post_url
2017-03-23-introducing-hail %}): an open source IoT development board that
supports Tock! Hail is designed to be a very low-friction way to get started
using and creating Tock applications. Simply plug in the Hail module over USB
and use the [tockloader](https://github.com/helena-project/tockloader) utility
to load and run applications. Pre-order one today on our [hardware page]({{
  "/hardware" | relative_url }})

## Tock Application Bundles (TABs)

To support ease-of-use and distributable applications, @bradjc and @brghena
introduced an application bundle format called "Tock Application Bundle", or
`.tab` files. A TAB is a standalone file for an application that can be flashed
onto any board that supports Tock, and removes the need for the board to be
specified when the application is compiled. A TAB has enough information to be
flashed on many or all Tock compatible boards, and the correct binary is chosen
when the application is flashed and not when it is compiled. You can read more
about TABs in [the
documentation](https://github.com/helena-project/tock/blob/master/doc/Compilation.md#tock-application-bundle)

## Tock Pull Requests

There was a bunch of activity this week, and all of the new pull requests were
merged. As a result, we're straying from our typical two section format and
just listing the great work people finished this week!

  * @daniel-scs merged his [CRC driver](https://github.com/helena-project/tock/pull/303) for the SAM4L, as well as [addressed](https://github.com/helena-project/tock/pull/313) style
    issues and typos in TRD1 document.

  * @brghena [Clarified which versions](https://github.com/helena-project/tock/pull/336)
    of programs are required throughout the Tock documentation.

  * @bradjc & @brghena [Introduced](https://github.com/helena-project/tock/pull/325)
    Tock Application Bundles (TABs)

  * @bradjc [Modified](https://github.com/helena-project/tock/pull/332) the
    Hail board configuration to use all available memory for apps. He also
    [removed the stale](https://github.com/helena-project/tock/pull/324)
    `blink_sync` app from examples.

  * @alevy fixed nasty bugs in both the
    [NRF51](https://github.com/helena-project/tock/pull/334) and
    [SAM4L](https://github.com/helena-project/tock/pull/333) timers that cause
    short delays to be missed. He also updated the build system to
    [force a particular Rust toolchain version](https://github.com/helena-project/tock/pull/322).

  * @phil-levis continued the steady work on the RF233, including
    [support for 64-bit addresses](https://github.com/helena-project/tock/pull/323) and an
    [interface cleanup](https://github.com/helena-project/tock/pull/317).

