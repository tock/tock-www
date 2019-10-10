---
title: Talking Tock 52
subtitle: Version 1.4
author: bradjc
authors: bradjc
---

Announcing Tock 1.4!

The Tock team just released Tock 1.4, the latest milestone-based release of
Tock! The details can be found in the [release
notes](https://github.com/tock/tock/releases/tag/release-1.4) and the [tracking
issue](https://github.com/tock/tock/issues/1327).

The main changes include HIL redesigns of the following interfaces:

- GPIO
- UART
- Timer

These new HIL interfaces enable chips to better expose their capabilities, as
well as provide a more consistent interface for users of the HILs.

Additionally, Tock continues to grow, and this release contains preliminary
support for RISC-V platforms as well as a couple new hardware platforms.
