---
title: Talking Tock Week 2
authors: alevy
---

This is the second post in a weekly series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

Have you seen our recent blog post explaining how we load applications in Tock
using relocatable code? Check it out [here]({% post_url
2016-08-12-dynamic-loading %}).

## What's new in Tock?

  * We have a twitter account!
  <a href="https://twitter.com/talkingtock" class="twitter-follow-button" data-show-count="false">
    Follow @talkingtock
  </a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

  * @KBaichoo made a buddy allocator that doesn't rely on the std crate. He'll
    use this as a layer for writing apps to flash at runtime. The main
    challenge the buddy allocator solves is to ensure that apps written to
    flash are aligned to boundaries that allow correct use of the MPU.

  * @phil-levis switched development of the NRF51 to the NRF51-DK since the
    evaluation kit is deprecated.

  * @alevy has a [pull request](https://github.com/helena-project/tock/pull/90)
    out to migrate to Cargo as the build system.

  * @shaneleonard has a first revision of a new development platform for Tock
    called [Imix](https://github.com/helena-project/imix).

## Tracking long-term progress

### Imix platform

@shaneleonard is working on a development board based on the
[Firestorm][firestorm] that will be widely available
(details to come). It is particularly amenable to Tock development since it
exposes many more internal pins for debugging as well as facilitating
power-measurement of individual components.

A first revision of the board came back last week and we've gotten basic code
running on it. That's helped find some hardware bugs we'll be fixing for the
next revision. Look for a final release early in the fall. For now, here it is
blinking!

![Imix blinking]({{ site.baseurl }}/assets/2016/08/imix_blinky.gif)

### Cargo-based build

A pull request is out to switch to a Cargo-based build system. We still need to
port the NRF code to the new build system and automate pulling in a nightly
build of libcore (probably using the [rust-libcore] crate).

This will allow others to develop ports of Tock out-of-tree.

### Native Bluetooth Low-Energy Stack

@phil-levis is leading a port of the Mynewt project's open source BLE stack for
the NRF51 and NRF52 to Tock. Initially, we will run Mynewt as a process with the
radio hardware registers exposed to it using the MPU. We will then slowly
port layers of the library into Rust drivers in the kernel.

### Programming apps at runtime

@KBaichoo has finished a block store abstraction that respects the alignment
rules of the ARM Cortex-M memory protection unit. The next step is build a layer
on top that gets contiguous blocks of storage sized for an app and program it.

[firestorm]: https://web.archive.org/web/20160828042208/http://storm.rocks/firestorm.html
