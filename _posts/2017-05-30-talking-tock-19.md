---
title: Talking Tock 19
subtitle: High-Speed ADC and LLVM bugs
author: aalevy
authors: alevy
---

This is the 19th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

> We're giving a tutorial co-located with [SenSys
> 2017](http://sensys.acm.org/2017) Novenmber 5th in Delft, The Netherlands.
> Go [here]({{ "/events/sensys2017" | relative_url }}) for details and to sign
> up to recieve an e-mail when registration opens.

1. TOC
{:toc}

## Continuous ADC Sampling

@brghena has spent the last month or so implementing continuous ADC sampling in
order to support high-speed aquisition of audio signals in Signpost
applications.

In particular, a [pending
application](https://github.com/lab11/signpost/pull/46) for Signpost by
@longle2718 that provides classification of audio events. For example,
detecting bird songs, gunshots, etc. In order to do the classification, it
first needs a source of audio recorded at a high enough data rate to
distinguish high-frequency noises. Audio applications commonly need samples at
44.1 kHz.

The original ADC implementation is only capable of 1-2 kHz sampling with high
jitter between samples. The [new ADC
continuous](https://github.com/helena-project/tock/blob/master/doc/reference/trd102-adc.md#3-adccontinuous)
implementation is capable of low-jitter sampling up to 180 kHz, which will
allow it to provide for the needs of the audio classification application.

## LLVM bugs: action and reaction

Following a [relatively](https://github.com/helena-project/tock/pull/367)
[deep](https://github.com/helena-project/tock/pull/369)
[rabbit-hole](https://github.com/helena-project/tock/issues/370) over the last
couple weeks, we ended up running into two LLVM bugs on Cortex-M0 (thumbv6)
targets that temporarily blocked our progress.

The first was an unsupported relocation in LLVM 3.9 that had already [been
found](https://github.com/japaric/f3/issues/42) by @japaric and resolved by the
upgrade to LLVM 4.0 in Rust.

However, upgrading to newer versions of Rust proved challanging as well. LLVM
4.0 changed how it compiles switch expressions (`match` expressions in Rust)
for Cortex-M0 and had a regression that resulted in [completely buggy
  assembly](https://github.com/rust-lang/rust/issues/42248). This has since
been resolved upstream in LLVM, and will likely be backported to Rust soon.
In the meantime, forcing LLVM not to inline the particular problematic case
in the Tock NRF51-DK board setup gets around this bug.


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

## Hail

Itching to start using and developing for Tock? There are still Hail
development boards, the main board used for Tock development, available in
stock. Check them out [here]({{ "/hardware/hail" | relative_url }}).

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
