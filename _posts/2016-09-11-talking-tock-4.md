---
title: Talking Tock Week 4
authors: alevy
---

This is the forth post in a weekly series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## What's new in Tock?

  * We started a [mailing
    list](https://groups.google.com/forum/#!forum/tock-dev) for people working
    on Tock or ports of Tock to various chips and platforms.

  * The mailing list has been inaugurated with a discussion of [faster
    interrupt
    handling](https://groups.google.com/forum/#!topic/tock-dev/fPzYev4rvnI),
    [LLVM changes that make Rust processes
    feasible](https://groups.google.com/forum/#!topic/tock-dev/fPzYev4rvnI) and
    a [directory tree
    restructure](https://groups.google.com/forum/#!topic/tock-dev/7d-FdWP6Zu0)

  * @TethysSvensson did a complete pass cleaning up the source with `rustfmt`.

  * @emosenkis replaced instances of the unstable
    `volatile_load`/`volatile_store` calls with their stable variants
    `write_volatile`/`read_volatile`.

  * @alevy implemented a minimal driver for a Synposis USB IP (so far it only
    does enough setup to register as device on a Linux host).

  * @bradjc has been making progress on sensor drivers for the
    [Signpost](https://github.com/lab11/signpost) project.

