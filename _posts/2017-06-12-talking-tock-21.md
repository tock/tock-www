---
title: Talking Tock 21
subtitle: Bluetooth, static initialization and userland code quality
author: aalevy
authors: alevy
---

This is the 21st post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

> We're giving a tutorial co-located with [SenSys
> 2017](http://sensys.acm.org/2017) Novenmber 5th in Delft, The Netherlands.
> Go [here]({{ "/events/sensys2017" | relative_url }}) for details and to sign
> up to recieve an e-mail when registration opens.

1. TOC
{:toc}

## Pull Requests

### Merged

  * ([#409]) @niklasad1 and @frenicth implemented Bluetooth Low Energy advertisement support for the NRF51.
  * ([#426]) @ppannuto added linting to userland C code
  * ([#424]) @niklasad1 refactored the NRF51's UART to avoid calls to transmute
  * ([#421]) @adkinsjd added coulomb counter helper functions in userland
  * ([#422]) @alevy removed requirement to explicitly state size in `static_init!`
  * ([#423]) @bradjc removed explicit sizes in calls to `static_init!` in Hail

### Proposed

  * ([#425]) @niklasad1 added synchronous wrappers to the userland AES library

## Hail

Itching to start using and developing for Tock? There are still Hail
development boards, the main board used for Tock development, available in
stock. Check them out [here]({{ "/hardware/hail" | relative_url }}).

[#409]: https://github.com/helena-project/tock/pull/409
[#421]: https://github.com/helena-project/tock/pull/421
[#422]: https://github.com/helena-project/tock/pull/422
[#423]: https://github.com/helena-project/tock/pull/423
[#424]: https://github.com/helena-project/tock/pull/424
[#425]: https://github.com/helena-project/tock/pull/425
[#426]: https://github.com/helena-project/tock/pull/426
