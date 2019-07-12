---
title: Talking Tock 26
subtitle: NRF52, external clock bugs and C bugs
author: aalevy
authors: alevy
---

This is the 26th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## RustConf Training

Have you been following Tock? If you're reading this, I'm guessing the answer
is yes. Are you within flying distance of Portland, OR? Again, the answer is
yes. Join us for a Tock training colocated with RustConf 2017 on August 17th in
Portland!

Register on the RustConf website (formerly at http://rustconf.com/register.html).
Just remember you need to register for the Tock training regardless of if you
register for the rest of the conference. All the proceeds from the training go towards funding RustBridge, so it's win-win-win.

![Win/Win is number four and number five is win/win/win. The important
difference here is with win/win/win, we all win. Me too. I win for having
successfully mediated a conflict at
work.](/assets/2017/07/michael-scott-win-win-win.jpg "Win/Win is number four and number five is win/win/win. The important difference here is with win/win/win, we all win. Me too. I win for having successfully mediated a conflict at work.")

See you in Portland!

## Pull Requests

### Merged

  * @ppannuto fixed an annoying usability behavior in `make format`
  * @adkinsjd ensured that I2C is enabled in the LTC294X coulomb counter driver
  * @brghena ensured Cargo and Xargo are using the right version of `rustc`
  * @shaneleonard corrected a pin assignment on imix
  * @warner fixed a shell script bug in `list_boards.sh`
  * @alevy reimplemented virtual timers using a linked list instead of a heap
  * @adkinsjd disabled I2C slave during master transfers, if not done I2C master
    transfers don't work
  * @ppannuto fixed shell script equality operator
  * @niklasad1 added support for the NRF52 and NRF52 development kit in a series
    of PRs
  * @niklasad1 implemented BLE scanning for the NRF51
  * @bbbert corrected offset and lengths to fix off-by-one-byte bug in RF233
  * @bradjc added a virtual flash capsule
  * @shaneleonard added submodule power configuration to imix
  * @ppannuto fixed return value of `_sbrk` in userland to match libc expectation
  * @bradjc added cmake as a development dependency in the docs (might be required
    to build libssh for Cargo/Xargo)

### Proposed

  * @brghena added support for variable system clock initialization
  * @niklasad1 added BLE support to the NRF52
