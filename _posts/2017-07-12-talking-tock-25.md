---
title: Talking Tock 25
subtitle: Towards 1.0, new design coming and a new paper
authors: alevy
---

This is the 25th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

## The Case for Writing a Kernel in Rust

Ok, this one is a teaser. A short paper we wrote about why you should write a
kernel in Rust was accepted to ACM Asia-Pacific Workshop on Systems (APSys). It
is a sort of follow on to the much discussed "Ownership is Theft" we published
a couple years ago, and discusses some of the solutions we found (or were found
for us) to problems raised in that paper, as well as describes how using Rust
allows an incredibly small trusted computing base for a safe kernel.

Stay tuned for a write-up on the paper, and the paper itself, when we've
addressed comments from the reviewers.

## Website redesign

The Tock website is getting a new look! You can check out the draft version
here: <https://redesign--tockosorg.netlify.com/>. It should work reasonably
well on mobile, though still working out a few kinks. Feedback is welcome, and
if you're have mad CSS/HTML/Jekyll/design skillz and want to contribute, we'd
also welcome your help (@alevy did this version, and he still writes CSS like
it's the blink tag exists). The website repo is at
<https://github.com/helena-project/tock-www>.

## Towards Tock 1.0

We're gearing up to release a 1.0 version of Tock. As of our most recent
discussions, the 1.0 version will focus on low power and binary
stability---meaning applications compiled for a 1.0 system call interface
should work on any kernel that claims a 1.0 system call interface, regardless
of the version of libtock you use. The goal is to make it possible to start
distributing .tab files (archives of compiled Tock binaries) in a meaningful
way, as well as to support more runtime libraries (e.g. the Rust and Lua
runtimes).

We won't be able to stabalize _every_ driver's system call interface, but we
plan to cover the basics: timers, debug console, LEDs, buttons, GPIOs and
handful of high-level sensor drivers (accelerometer/magnetometer, light,
temperature, pressure, etc). Notably absent are 802.15.4 and BLE radios.
Support for those exist, but they are still very much in progress, and we think
it's important to get those right before commiting to interface stability.

Kernel interfaces (the HIL) _will not_ be stabilized in this version. They are
becoming more and more stable, but still seeing reasonably significant changes
as we find previous versions insufficient to support more advanced features
like low power and clock management. If you are (or want to) developing ports
of Tock for different chips or board, this is good and bad. It's bad because it
means you have to stay up to date with changes by talking to us through the
mailing list and IRC (wait is that bad or actually good?), and good because it
means if you find places where the interfaces fall short there is still plenty
of room to make changes.

## Pull Requests

### Merged

  * @shaneleonard Fixed a pin misassignment on the new imix board
  * @enzuru fixed an issue where the Xargo version wasn't being validated
  * @bbbert fixed two bugs in the SAM4L SPI slave implementation
  * @ppannuto fixed sam4l power scaling
  * @ppannuto fixed `make fmt` in userland

### Proposed

  * @ppannuto fixed an annoying usability behavior in `make format`
  * @niklasad1 ported Tock to the NRF52 (and NRF52DK)
  * @shaneleonard implemented dynamic power configuration for imix
  * @bbbert & @ptcrews took a first stab at implementing 6lowpan
    compression/decompression
