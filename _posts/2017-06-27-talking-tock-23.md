---
title: Talking Tock 23
subtitle: Training at RustConf, virtual alarms and lots of new drivers
author: aalevy
authors: alevy
---

This is the 23rd post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## RustConf Training

Registration for the Tock training at RustConf [is
up](http://rustconf.com/register.html)! We're extremely excited to be running
alongside the other tutorials. It will be on Friday, in the afternoon.

## Pull Requests
### Merged

  * @alevy added virtual alarms to userland
  * @bradjc:
    - Add PCA9544a Capsule
    - auto generate documentation
    - MAX17205 driver
    - DAC driver
    - style fixes in debug.rs, sam4l clocks, sam4l crcu, sam4l helpers.rs,
      userland error names
    - nonvolatile storage interface
    - flash updates
    - fix nrf serialization library
  * @bbbert fixed a logic bug in the rf233 driver
  * @ppannuto:
    - Formatting for kernel and userland
    - Travis CI fixes

### Proposed

  * @bradjc implemented self-modification of process flash regions
  * @bradjc made improvements to the SAM4L AES driver
  * @bradjc created a BLE UART app
  * @niklasad1 implemented BLE scanning for the NRF51
  * @ppannuto added human-readable error code explanations

[#409]: https://github.com/helena-project/tock/pull/409
[#421]: https://github.com/helena-project/tock/pull/421
[#422]: https://github.com/helena-project/tock/pull/422
[#423]: https://github.com/helena-project/tock/pull/423
[#424]: https://github.com/helena-project/tock/pull/424
[#425]: https://github.com/helena-project/tock/pull/425
[#426]: https://github.com/helena-project/tock/pull/426
