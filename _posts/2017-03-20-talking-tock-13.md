---
title: Talking Tock 13
author: aalevy
authors: alevy
---

This is the thirteenth post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## Signpost

@alevy wrote a [test app](https://github.com/lab11/signpost/pull/47) for the
Signpost storage module with support for FAT file-systems on an SD Card. The
goal is to implement a remote file system over I2C for other modules such that
SD Cards can be easily read from the Edison on the controller or other laptops
or desktops.

## Tock Pull Requests

### Merged

  * @alevy added a
    [CONTRIBUTING](https://github.com/helena-project/tock/blob/master/CONTRIBUTING.md)
    document to help codify our contribution process.

  * @daniel-scs's TRD1 changes are
    [merged and official](https://github.com/helena-project/tock/pull/313)!

  * @phil-levis expanded the
    [RF233 interface](https://github.com/helena-project/tock/pull/317) by, e.g.
    separating out traits for data and control.

  * @szechy fixed some GitHub
    [markdown bugs](https://github.com/helena-project/tock/pull/318) all over
    our TRDs. Thanks Colin!

### Proposed

  * @nikalasad1 added support for encryption/decryption in
    [AES in counter mode](https://github.com/helena-project/tock/pull/316/files)
    on top of the NRF51's AES in ECB mode.

  * @daniel-scs [rewrote TRD1](https://github.com/helena-project/tock/pull/313)
    after some final discussions on the mailing list.

