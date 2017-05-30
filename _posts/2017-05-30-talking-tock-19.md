---
title: Talking Tock 18
subtitle:
author: aalevy
authors: alevy
---

This is the 19th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Continuous ADC Sampling

Makes use of continuous ADC sampling on the SAM4L in order to provide an ADC
interface to userland capable of providing samples at a set frequency. There
are also two example applications adc and adc\_continuous which give examples of
the synchronous and asynchronous ADC interfaces provided to userland.

This should (finally) address the needs of lab11/signpost#46 for Signpost.

### Features

  * Specified ADC channels. Like GPIO, the ADC capsule is now initialized with a list of valid ADC channels.
  * Ability to continuously collect single samples at frequencies from 1 to 10000 Hz.
  * Ability to continuously collect buffers of samples at frequencies from 23 Hz to 187000 Hz.
  * Application interface for requesting a single buffer-full of samples at any frequency.
  * Application interface for requesting continuous double-buffered samples at any frequency.

## LLVM bugs: action and reaction

<https://github.com/japaric/f3/issues/42>

<https://github.com/rust-lang/rust/issues/42248>


## Pull Requests

### Merged

  * ([#384]) @alevy generalized MPU subregions support to data, GOT and IPC sections.

  * ([#386]) @bradjc added documentation to the IPC capsule.

  * ([#282]) @alevy wrote a reference document (TRD) for the Time HIL.

  * ([#387]) @bradjc cleaned up most userland compile time warnings.

  * ([#400]) @bradjc fixed kernel imports to use public kernel path when possible.

  * ([#370]) @ppannuto upgraded the Rust nightly version (special thanks to
    @japaric for helping behind the scenes).

  * ([#393], [#394]) @niklasad1 and @alevy fixed compilation issues on NRF51-DK due to Rust nightly upgrade.

  * ([#371]) @brghena added continuous ADC sampling (including at high frequency)
    to the ADC HIL and implemented it for the SAM4L.

  * ([#399], [#402]) @bradjc made process specific state more standardized across
    capsules and updated the error codes returned from various system call
    drivers.

### Proposed

  * ([#396]) @bradjc TBF version 2
  * ([#397]) @bradjc wrote an IPC tutorial
  * ([#398]) @brghena began updating the ADC reference document to reflect the changes to ADC HIL.

[#282]: https://github.com/helena-project/tock/pull/282
[#370]: https://github.com/helena-project/tock/pull/370
[#371]: https://github.com/helena-project/tock/pull/371
[#382]: https://github.com/helena-project/tock/pull/382
[#384]: https://github.com/helena-project/tock/pull/384
[#386]: https://github.com/helena-project/tock/pull/386
[#387]: https://github.com/helena-project/tock/pull/387
[#393]: https://github.com/helena-project/tock/pull/393
[#394]: https://github.com/helena-project/tock/pull/394
[#396]: https://github.com/helena-project/tock/pull/396
[#397]: https://github.com/helena-project/tock/pull/397
[#398]: https://github.com/helena-project/tock/pull/398
[#399]: https://github.com/helena-project/tock/pull/399
[#400]: https://github.com/helena-project/tock/pull/400
[#402]: https://github.com/helena-project/tock/pull/400
