---
title: Talking Tock 27
subtitle: USB, safety bug fixes and more
authors: alevy
---

This is the 27th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## Pull Requests

### Merged

  * @daniel-scs added driver for SAM4L's USBC and generic USB lib
  * @niklasad1 implemented BLE advertising and scanning for the NRF52
  * @bradjc made improvements/additions to the documentation in `doc/`
  * @daniel-scs merged back some of the changes from imixv1 to imix
  * @cbiffle fixed impl Drop bug for containers
  * @cbiffle remove use of Owned with enter & each for containers
  * @ppannuto removed circular references from NRF documentation
  * @alevy made pic information optional in `elf2tbf` through an argument
  * @ppannuto provided a target to build lst for kernel
  * @bradjc padded all TLV blocks to 4 in TBF header
  * @alevy removed `data_start_pointer` from `load_info` in process loading and init
  * @niklasad1 removed unused chip initialization from nRF5
  * @nealjack added a command to configure ltc294x model in userland driver

### Proposed

  * @hsiehju implemented Signbus in the tock kernel
  * @niklasad1 fixed minor issues with nrf52 GPIOs and AES-CTR
  * @bradjc fixed userland build system handling of files with spaces
  * @phil-levis updated linker script for embedding storage regions within kernel
  * @bbbert implemented data frame structs/encoding/decoding for ieee802154

