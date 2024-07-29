---
title: Talking Tock 12
authors: alevy
---

This is the twelfth post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

## Academic paper season

As many of the Tock developers gear up to submit a couple of Tock-related
academic papers, our development clip has slowed a bit. This will likely last
until late April, but we'll still have weekly updates. They'll just be a bit
shorter.

## Signpost

@longle2718 ported an acoustic event detection
library (which he originally used for bird
song detection on Android) to Tock for the Signpost audio module. It's
currently [waiting on some guidance](https://github.com/lab11/signpost/pull/46)
to fix build issues, but involves an FFT, some clever math and should be very
cool when it's done!

## NRF51 and AES

@niklasad1 spent the week working on a driver and HIL interface for the NRF51
AES controller. The AES controller only supports ECB mode (which is insecure
for streams), but he's worked out a way to use that controller in other block
cipher modes (e.g. counter mode). A conversation formerly at
http://bot.tockos.org/tockbot/tock/msg/445/ had some details.

## TRDs (Tock Reference Documents)

We want to make Tock as accessible to read, understand and contribute to. In
that spirit, we're inheriting the practice of writing reference documents from
the TinyOS community. We call them (drum roll...) _Tock Reference Documents_,
or TRDs. Each TRD explains a specific interface in the kernel, the motivation
behind its design and expected implementation details.  We've begun to write a
few as well as an overview of the TRD structure and process
[here](https://github.com/helena-project/tock/blob/master/doc/reference/trd1-trds.md).

## Tock Pull Requests

### Merged

  * @phil-levis added support for [hardware
    acks](https://github.com/helena-project/tock/pull/293) in the RF233 driver.

  * @brghena [extracted a math
    library](https://github.com/helena-project/tock/pull/312) from the kernel
    for general use

### Proposed

  * @daniel-scs [rewrote TRD1](https://github.com/helena-project/tock/pull/313)
    after some final discussions on the mailing list.

