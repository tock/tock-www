---
layout: page
title: TockWorld 2022
description: Proposed agenda for TockWorld 2022
permalink: /tockworld22/agenda
---

TockWorld 2022 will take place at Northwestern University in Chicago on July
19th & 20th. Day 1 welcomes everyone to hear talks and participate in
discussions. Day 2 also welcomes everyone, but will be organized around smaller
group discussions focused on governance.

In addition to normal presentations on the development in and around Tock, this
TockWorld will have focused discussions on the future of the Tock roject and
strategies for fostering a sustainable community around the project.

* TOC
{:toc}

# Location

Ford Motor Company Engineering Design Center – Room 1.350  
2133 Sheridan Road  
Evanston, IL 60201  
<https://goo.gl/maps/oqXDkttiUqczgDBe7>

There's an entrance to the building on Sheridan road, and you'll need to go up
one floor to get to room 1.350.

# Food 

There will be breakfast available both mornings, arriving sometime between 8:00
and 9:00 am. We'll also have coffee, tea, snacks, and lunches on both days.

The lunch on the second day is boxed, so you can take it with you if you need to
leave immediately. For anyone interested, we can go get dinner in downtown
Evanston (a 15 minute walk away) on Tuesday evening at one or more places,
depending on what food you want.

# Schedule

## Tuesday

  |  Time |  Topic                                               | Speaker       |
  | ----- |------------------------------------------------------| ------------- |
  |  8:00 |  _Breakfast_                                         |               |
  |  9:30 |  [State of Tock](#state-of-tock)                     | Amit & Hudson |
  | 10:45 |  _Break_                                             |               |
  | 11:00 |  [OpenTitan](#opentitan)                             | Dom Rizzo (Virtual)  |
  | 11:30 |  [Teaching Tock](#teaching-tock)                     | Alexandru     |
  | 12:00 |  _Lunch_                                             |               |
  | 13:00 |  [Execution Bounds](#execution-bounds)               | Hudson        |
  | 13:30 |  [Ti50](#ti50)                                       | Alyssa        |
  | 14:00 |  [Repurposable Devices](#repurposable-devices)       | Brad          |
  | 14:30 |  _Break_                                             |               |
  | 15:00 |  [Development Focus Areas](#discussions-vision--development-focus-areas) | Lead: Brad    |
  | 16:00 |  _Break_                                             |               |
  | 16:30 |  [Community Development](#community-development)     | Lead: Amit    |

## Wednesday

  | Time  |  Topic              |
  | ----- | ------------------- |
  |  8:00 |  _Breakfast_        |
  |  9:00 |  Who is Tock for?   |
  | 11:00 |  Project Governance |
  | 12:00 |  _Lunch_            |


# Session details

## State of Tock

_Speakers: Amit & Hudson_

_[Slides](/assets/tockworld22/state-of-tock.pdf)_

- The Big Picture
- Since 2.0
- Progress on Code Size
- Towards stable Rust


## OpenTitan

_Speaker: Dominic Rizzo_

## Teaching Tock

_Speaker: Alexandru Radovic_

## Execution Bounds

_Speaker: Hudson Ayers_

## Ti50

_Speaker: Alyssa Haroldsen_

## Repurposable Devices

_Speaker: Brad Campbell_

_[Slides](/assets/tockworld22/2022-07-19_tockworld5_repurposable.pptx)_

## Discussions: Vision & Development Focus Areas

- Where do we want the project to go in the next 3-5 years?
- Where is effort being spent?
- What are the current pain points?

_Discussion Groups_

- Code Size
- Pluggable/blocking syscalls
- [Connectivity](/assets/tockworld22/connectivity.pptx)
- Testing
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

## Community development

- What do we want to community to look like in 3-5 years
  - What would long term sustainability look like?
- How can we build a more stable community around Tock?
- Who are the right audiences?
- Documentation and other materials? Events? Hardware platforms?
  Staffing? Governance? Online communication tools?

