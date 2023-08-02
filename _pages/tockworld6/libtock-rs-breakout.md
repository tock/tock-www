---
layout: page
title: TockWorld 6 - libtock-rs Breakout Discussion
description: libtock-rs Breakout Discussion at TockWorld 6
permalink: /tockworld6/libtock-rs-breakout
---

# `libtock-rs` Breakout Discussion Group

## History of and motivation behind `libtock-rs`

- Initial thought for Tock's userland: shouldn't matter what the language is, so
  let's just use C! Then came a Lua userland.
- Developers choose Tock for Rust and safety, but then forcing developers to use
  C feels like a mismatch.
- libtock-rs had (essentially) two starts:
  1. Initial version by two contributors from the Internet

	 However, the vision of what we wanted from a Rust userland was different
     from theirs (essentially an Arduino-like runtime), so the contributors
     stopped working on it
  2. Rewrite of `libtock-rs` by Johnathan

     Focused on safety, soundness & lightweight nature.
- `libtock-rs` has additional challenges compared to the `libtock-c` userland,
  e.g. stricter semantics around sharing and unsharing a buffer, which
  implicitly defines access control for the kernel & userspace.

## Needs from a Rust userland

General:
- Developer don't want to write security-critical code in C
  - Made seemingly worse by the fact that Tock is already using upstream for its
    kernel.
	
Acute needs from present developers:
- Missing functionality around swapping buffers. `libtock-rs` requires the full
  `allow`, `command`, `unallow` cycle and can't atomically swap out one buffer
  for another.


## State of libtock-rs

Users, boards & driver support:
- Current "production" users
  - Ti50(?)
  - OpenSK
- Support for many boards, both ARM & RISC-V.
- During the switch to Tock 2.0 we rewrote all libtock-c example apps and
  userspace driver abstractions. However, at that time, `libtock-rs` was not
  ready for Tock 2.0. Up to this point, we rewrote only a few `libtock-rs`
  drivers & apps.
- It seems that Johnathan only ported the system call drivers which were
  actually required by OpenTitan.

Limitations:
- Does not support waiting on multiple asynchronous operations simultaneously.
  - Johnathan was very up-front about this restriction. Given the resource and
     safety constraints, this seemed to be the only option.
- No relocatable app support (fixed flash & address)

  Compared to `libtock-c`'s PIC support for ARM, where the userspace library /
  the app loader (e.g., Tockloader) needs to be kept in-sync with the board's
  app start address, this is much more restrictive:

  - Flash placement: needs to know size of other binaries and layout ahead of
    time.
  - RAM placement: depends on other apps and the kernel's moving `_sappmem`
    symbol.

  Update on relocatable apps with LLVM: things are moving on the RISC-V side (as
  part of the OpenTitan efforts)
- Kernel docs assume C userland in many places, don't treat Rust userland as a
  first-class citizen.
- No heap support(?)
- General feeling of inability to help

Implementation state: the overall design is fully implemented, but the testing
apparatus is not complete.

## Moving forward
- Establish a `libtock-rs` working group?
- More momentum behind reviewing PRs
- Rewrite tutorial in libtock-rs[e]
- Everyone (in the core team) should try it[e]
- Release testing & CI with libtock-rs[e]
- Next Tock release should announce support[e]
- Build system needs work

[e] = easy, low-effort tasks

Take-away after presenting these outcomes: assign every core-team member a driver
to port!
