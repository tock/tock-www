---
layout: page
title: TockWorld 5 - Testing Discussion
description: Testing Discussion at TockWorld 5
permalink: /tockworld5/testing
---

# Testing Discussion Group

- There are four broad categories of testing:
- Real HW testing
  - `What is it?` "Closest to Production"; Verifies HW behavior, external runnner with hardware support, slow, high setup and maintenance cost
  - `Status?` Prototypes for limited boards (nrf52840dk, hail) launching soon
  - `Open Questions?` Will want to test both portability of applications (i.e., basic UART/SPI/I2C userspace applicationsrrun unmodified on all platforms) and platform-specific bounds (i.e., maximum transfer lengths).
  - `Next Steps:` Opportunistic development; desired, but not critical-path
- Virtual HW testing
  - `What is it?` QEMU / Verilator; software simulations of specific hardware
  - `Status?` Highly experimental; hardware emulation is a fast-moving space that we will continue to experiment with; opportunistic development
  - `Open Questions?` Platform vs. Chip simulation? How much would we need to maintain in practice?
  - `Next Steps:` Opportunistic development; desired, but not critical-path
- Host Emulation HIL
  - `What is it?` Tock kernel and processes as host processes; `Chip` layer shimmed out; IPC/mmap etc to make it seem like one HW platform; Fast
  - `Status?` Some preliminary implementations in downstream; 
  - `Open Questions?` How hard will test runners be to implement in pratice? This will probably support only one host OS, okay?
  - `Next Steps:` This is likely to follow unit testing, as the mock infrastructure lessons will help shape this
- Unit Testing
  - `What is it?` Module-level tests of public-facing functionality
  - `Status?` Largely non-existent; "cargo test" already runs in CI, but runs almost no tests
  - `Open Questions?` Ergonomics and infrastructure; what is the right mocking and test library structure?
  - `Next Steps:` Draft PRs with a few, simple canonical examples; also explore code coverage integration(?)