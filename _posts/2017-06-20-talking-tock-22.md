---
title: Talking Tock 22
subtitle: RustConf tutorial preview and SITP retreat
author: aalevy
authors: alevy
---

This is the 22st post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Tutorial @ RustConf

We'll be running a Tock tutorial at RustConf 2017 in Portland on August 18th.
We're still hammering out the details, but at a high level, it will be similar
to the SenSys tutorial in Delft with more focus on programming and using Tock
specifically with Rust.

[Sign up]({{ "/events/rustconf2017" | relative_url }}) to recieve e-mail
updates with more details and when registration opens.

## Recap: Secure Internet of Things Project Retreat

Several of the Tock contributors attended a
[retreat](http://iot.stanford.edu/retreat17/index.html) for the [Secure
Internet of Things Project](http://iot.stanford.edu) last week in sunny Santa
Cruz. We got to share our work with colleagues from Stanford, UC Berkeley and
University of Michigan as well as folks from Google (including friend of the
project @domrizzo), Intel, Nest, Ford, ARM and others. Our own @alevy and
@adkinsjd gave presentations about Tock
([slides](http://iot.stanford.edu/retreat17/sitp17-tock.pdf)) and Signpost
([slides](http://iot.stanford.edu/retreat17/sitp17-signpost.pdf)),
repsectively.

Is was great fun despite the incessant talk of Bitcoin and other
cryptocurrencies now unavoidable within a 100 mile radius of San Francisco.

## Pull Requests

### Merged

  * @bradjc `static_init!` cleanup in imix
  * @ppannuto fixed version issues with userland style tool uncrustify
  * @ppanuto marked inputs and outputs for extended ASM correctly in low-level
    libtock functions
  * @shaneleonard's imixv2 support with tock-bootloader
  * @brghena updated the ADC reference document to reflect the changes to ADC
    HIL.
  * @alevy upgraded Rust nightly version which addressed incorrect LLVM output
    on Cortex-M0s

### Proposed

  * @bradjc started creating a nonvolatile storage interface.
  * @petar implemented variable clock selection for the SAM4L ADC continuous
    mode.

[#409]: https://github.com/helena-project/tock/pull/409
[#421]: https://github.com/helena-project/tock/pull/421
[#422]: https://github.com/helena-project/tock/pull/422
[#423]: https://github.com/helena-project/tock/pull/423
[#424]: https://github.com/helena-project/tock/pull/424
[#425]: https://github.com/helena-project/tock/pull/425
[#426]: https://github.com/helena-project/tock/pull/426
