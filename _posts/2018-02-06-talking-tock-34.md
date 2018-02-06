---
title: Talking Tock 34
subtitle: Registers, Review process & Releases
author: aalevy
authors: alevy
---

This is the 34th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

{% include notice.html content="We're presenting Tock at the Linux Foundation's
OpenIoT summit in Portland in March! Check out the event website for [details
and
registration](https://events.linuxfoundation.org/events/elc-openiot-north-america-2018/program/schedule/)."
%}

1. TOC
{:toc}

## Code Review Process

As Tock supports more chips and services, changes to core interfaces or
capsules will increasingly trigger bugs or integration problems. In order to
allow development to continue smoothly while avoiding breaking everyone's code,
we recently agreed on a process (gh#736) by which changes to the main Tock happen. Of
course, this process is not set in stone, and may change as problems or issues
arise.

### Core Team

Borrowing from how the Rust team structures development, we've established a
core team that is responsible for sheperding the development of Tock. In
practice, the core team are people with commit access to the main repository
and operate by consensus. The members of the core team are:

 * Niklas Adolfsson (@niklasad1)
 * Hudson Ayers - (@hudson-ayers)
 * Brad Campbell - (@bradjc)
 * Branden Ghena - (@brghena)
 * Daniel Giffin - (@daniel-scs)
 * Philip Levis - (@phil-levis)
 * Amit Levy - (@alevy)
 * Olaf Landsiedel - (@olafland)
 * Pat Pannuto - (@ppannuto)

The core team reflects people who actively contribute to Tock and is
representative of the teams at the institutions who work on and rely on Tock.
As the ecosystem evolves, we expect the make-up of the core team to evolve as
well.

### Pull-Requests

Any pull request against the master branch is reviewed by the Tock core team.
Pull requests fall into one of two categories:

 * **Upkeep** pull requests involve minor changes to existing implementations.
   Examples of upkeep requests involve bug fixes, documentation (that isn't
   specification), or minor reimplementations of existing modules.

 * **Significant** pull requests involve new modules, significant
   re-implementations, new traits, or changes to the build system.

Whether a pull request is upkeep or significant is based not only on the
magnitude of the change but also what sort of code is changed. For example, bug
fixes that are considered upkeep for a non-critical capsule might be considered
significant for kernel code, because the kernel code affects everything and has
more potential edge cases.

Upkeep pull requests can be merged by any member of the core team. That person
is responsible for the merge and backing out the merge if needed. This is the
roughly process we've used for all pull-requests until now.

Significant pull requests require review by the entire core team. Each core
team member is expected to respond within one week. There are three possible
responses:

 * **Accept**, which means the pull request should be accepted (perhaps with
   some minor tweaks, as per comments).
 * **No Comment**, which means the pull request is fine but the member does not
   promote it.
 * **Discuss**, which means the pull request needs to be discussed by the core
   team before considering merging it.

A significant pull-request can be merged after a week, provided at least two
core team members accepted it and there are no outstanding requests to discuss
it.

### Rolling Releases

Periodic stable releases make it easier for users to install and track
changes to Tock. Our intention is to release approximately every two months, at
the beginning of even months. One week before the intended release date, all
new pull requests are put on hold, and everyone uses/tests the software using
the established testing process. Bug fixes for the release are marked as such
(in the title) and applied quickly. Once the release is ready, the core team
makes a branch with the release number and pull request reviews restart.

Release branches are named 'release-version-mon-year'. For example,
'release-0.1-Feb-2018'.

For the time being, releases don't necessarily backwards compatibility. We will
likely use semver-like semantics in the version of each release, though. For
example, all release marked `1.x` will _probably_ comply with the `1.0` binary
ABI.

## Register and Bitfield Macros

There is a new way to define memory mapped I/O (MMIO) registers in Tock. It is
intended as the full, unifying replacement for all of the other redundant
register interfaces currently in use.

There are three types for working wit MMIO registers: `ReadWrite`, `ReadOnly`,
and `WriteOnly`, providing read-write, read-only, and write-only functionality,
respectively. Defining a set of registers is similar to the C-style approach,
where each register is a field in a packed struct:

```rust
use common::regs::{ReadOnly, ReadWrite, WriteOnly};

#[repr(C, packed)]
struct Registers {
    cr: ReadWrite<u8, Control::Register>,
    s: ReadOnly<u8, InterruptFlags::Register>
    byte0: ReadWrite<u8>,
    byte1: ReadWrite<u8>,
    short: ReadWrite<u16>,
    word: ReadWrite<u32>
    // Etc.
}
```

The first parameter to each register type is its width (`u8`, `u16`, `u32`) and
the second constrains the register to only use fields from a certain bitfield
group.

Bitfields are defined through the `register_bitfields!` macro:

```rust
register_bitfields! [
    u8,

    Control [
        RANGE OFFSET(4) NUMBITS(3) [
            VeryHigh = 0,
            High = 1,
            Low = 2
        ],
        EN  OFFSET(3) NUMBITS(1) [],
        INT OFFSET(2) NUMBITS(1) []
    ],
    InterruptFlags [
        UNDES   10,
        TXEMPTY  9,
        NSSR     8,
        OVRES    3,
        MODF     2,
        TDRE     1,
        RDRF     0
    ]
]
```

The first parameter to `register_bitfields!` is the register width. Each
subsequent parameter is register name and it's associated bitfields, declared as
`name OFFSET(shift) NUMBITS(num) [ /* optional values */ ]`.

For example, the `Control` register, defined above, has a `RANGE` field at
offset-bit 4 and size 3-bits which can take on values including `VeryHigh`,
`High` and `Low`. The syntax is simpler for cases such as the `InterruptFlags`
register defined above, where each field is a single bit and only the offset is
necessary.

This interface helps the compiler catch some common types of bugs via type checking.

If you define the bitfields for eg a control register, you can give them a
descriptive group name like `Control`. This group of bitfields will only work
with a register of the type `ReadWrite<_, Control>` (or `ReadOnly/WriteOnly`,
etc). For instance, if we have the bitfields and registers as defined above,

```rust
// This line compiles, because CR and regs.cr are both
// associated with the `Control` group of bitfields.
regs.cr.modify(Control::RANGE.val(1));

// This line will not compile, because CR is associated
// with the Control group, but regs.s is associated
// with the Status group.
regs.s.modify(Control::RANGE.val(1));
```

## Pull Requests

### Merged

  * (gh#736) Code review process document & establishing a "core team"
  * (gh#658) New register and bitfield interface

### Proposed

  * (gh#739) Cortex-M3 architecture crate
  * (gh#740) Fix scan buffer cut-off in Bluetooth Low Energy driver

