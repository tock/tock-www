---
title: Talking Tock 17
subtitle: Rust + Lua userlands, Hail shipped and an upcoming tutorial
author: aalevy
authors: alevy
---

This is the 17th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

Has it really been over a month since our last update? Yes... it has. And it's
been an eventful one! Between the contributors we submitted papers to
[SenSys](http://sensys.acm.org/2017/) and
[SOSP](https://www.sigops.org/sosp/sosp17/) (some related to Tock, some less
so). We also submitted a proposal for a Tock tutorial at SenSys which was
accepted! It will take place in Delft, The Netherlands in early November.
Details forthcoming.

Meanwhile, the first batch of Hail development boards shipped to people who
pre-ordered them. There is still enough in stock to dip into this first batch
so go ahead and buy one (or 10) [here]({{ "/hardware/hail" | relative_url }}).
Just before Hail shipped, attendees of RustFest in Kiev got a preview of the
board and operating system thanks to Florian (@skade) and Andrew (@HoverBear).
The feedback from RustFest as well as some initial feedback from people who
pre-ordered has been really useful. Keep it coming!

There has also been some external development that we are really excited about.
LLVM 4.0 was [merged](https://github.com/rust-lang/rust/pull/40123) into Rust,
openning the door for using ROPI/RWPI relocations in Rust, which has been a
[barrier to Rust userland support]({% post_url 2016-08-12-dynamic-loading
%}#drawbacks). Following a [small
patch](https://github.com/rust-lang/rust/pull/41560) turning on support in
Rust, this feature is now available, and we've begun initial support for Rust
userland in Tock. The remaining known barrier is a linker that supports all
these relocations, but that too is getting [resolved
upstream](https://reviews.llvm.org/rL303337) in LLVM's LLD linker.

## Non-C Userland

We've begin working on two non-C userland runtimes for Tock: one for Rust and
one for Lua.

The Lua userland turned out to be reasonably straightforward to embed in a Tock
process, although it has so far proven to have fairly large memory and code
overhead, so there is still some work to be done tweaking and optimizing that.

The Rust runtime is being hosted in a separate
[repository](https://github.com/helena-project/libtock-rs). Thanks to the LLVM
upgrade in Rust, we're able to compile Rust source to object code with
relocations that support our userland memory model, however, the only available
linker that supports, specifically, the data segment relocation (called
RWPI--Read-Write Position Independence) is the ARM proprietary linker, which we
don't want to rely on. Fortunately, this only means we can use global variables
just yet, so we've been able to make some progress none-the-less. Moreover,
support for RWPI relocations should be landing in LLD (LLVM's linker) soon.

## Pull Requests

### Merged

  * ([#372]) @ppannuto added support for printing compile configuration in the
    build system when `V=1`.

  * ([#374]) @ppannuto Removed the unused `disable-redzone` option in our
    target specifications.

  * ([#366]) @bradjc replaced the use of a timer for a built-in data-ready
    interrupt in the fxos8700cq accelerometer driver.

  * ([#368]) @bradjc updated the memory map and other documentation.

### Proposed

  * ([#369]) @ppannuto began the process of converting the NRF51's crt1.c to
    Rust.  This involves the slightly more tedious task of bumping the Rust
    nightly version we use.

  * ([#367]) @ppannuto added support for the kernel reading attributes
    currently only accessible to the bootloader.

  * ([#365]) @shaneleonard has made a new version of the imix hardware, which
    involves some changes to pinouts. He added support for the new board in the
    kernel as well as changes to make it work with the Tock bootloader.

  * ([#371]) @brghena added continuous sampling support to the ADC, which turns
    out to beg for some bigger changes in the ADC HIL as well as the DMA
    interface.

  * ([#359], [#360], [#361]) @bradjc is upstreaming capsules for the MAX17205
    and LTC294X battery fuel gauge ICS and PCA9544a I2C multiplexer from
    Signpost

[#359]: https://github.com/helena-project/tock/pull/359
[#360]: https://github.com/helena-project/tock/pull/360
[#361]: https://github.com/helena-project/tock/pull/361
[#365]: https://github.com/helena-project/tock/pull/365
[#366]: https://github.com/helena-project/tock/pull/366
[#367]: https://github.com/helena-project/tock/pull/367
[#368]: https://github.com/helena-project/tock/pull/368
[#369]: https://github.com/helena-project/tock/pull/369
[#371]: https://github.com/helena-project/tock/pull/371
[#372]: https://github.com/helena-project/tock/pull/372
[#374]: https://github.com/helena-project/tock/pull/374
