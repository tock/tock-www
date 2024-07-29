---
title: Talking Tock 36
subtitle: Defining registers, paper season and un-broken links
authors: alevy
---

This is the 36th post in a series tracking the development of Tock, a safe
multi-tasking operating system for microcontrollers.

{% include notice.html content="We're presenting Tock _today_ at the Linux Foundation's
OpenIoT summit in Portland! Check out the [event website for details](http://sched.co/DYLt)."
%}

1. TOC
{:toc}

## Porting to New Register Interface

As we've discussed [previously]({% post_url 2018-02-06-talking-tock-34 %}#register-and-bitfield-macros), @shaneleonard introduced a new interface for defining structs to model memory mapped I/O registers. In the last couple weeks there has been a concerted effort to port the SAM4L, NRF52 and ports to new chips to this interface.

If you maintain a port of Tock, give this new interface a short! There are now plenty of examples to work from. It's not mandatory---you can still define registers however you like---but we think it's much more readable and easier to get right.

## SenSys Push

It's paper writing season again. The submission deadline for SenSys 2018 (this time held in Shenzen, China, which is pretty exciting!) is in early April, and many frequent Tock contributors are burrying their heads to write up research results on time.

This means two things. First, there might be a slow down in major code contributions over the next couple months. Two, there should be some exciting new features just in time for the next rolling release! I don't want to steal any valor from the papers themselves, but I can share that the roadmap includes 6lowpan/[Thread](https://www.threadgroup.org) edge-device support, automatic clock management on the SAM4L, and a standardized interface for BLE advertising.

## Pull Requests

_Bolded pull requests were marked "P-Significant"_

### Merged

  * (gh#757) **Add ability to deactivate subscribed callback in system call interface**
  * (gh#747) **Port to the TI launchxl-cc26x2**
  * (gh#782) Port SAM4L AST (timers) to new regs interface
  * (gh#785) Port SAM4L TRNG to new regs interface
  * (gh#793) Update URL for tockloader
  * (gh#794) Fix style and details in documentation
  * (gh#780) RTC support for launchxl
  * (gh#790) Port SAM4L BSCIF to new regs interface
  * (gh#791) Port SAM4L ADC to new regs interface
  * (gh#799) Fix build-system bug with xargo 3.11
  * (gh#800) Make documentation build on netlify more readable
  * (gh#787) Port SAM4L BPM to new regs interface
  * (gh#796) Port CC26xx to new regs interface
  * (gh#803) Fixing broken links in capsule documentation
  * (gh#804) Fix broken links
  * (gh#781) Fix NRF5x clock register inconsistencies
  * (gh#751) Port SAM4L AES to new regs interface
  * (gh#779) Fix warnings for rustdoc
  * (gh#806) Remove unused peripheral registers module in NRF
  * (gh#805) Remove duplicate temperature sensor driver in nrf51
  * (gh#783) Port SAM4L DMA to new regs interface
  * (gh#808) Implement From for FieldValue in register interface

### Proposed

  * (gh#766) Port Sam4l USART to new register interface
  * (gh#784) Port SAM4L WDT to new regs interface
  * (gh#797) Port NRF51 UART to new regs interface
  * (gh#801) **Upgrade to rustc nightly 2018-03-07**
  * (gh#802) TRNG support for CC26xx + Launchxl
  * (gh#807) Port SAM4L GPIO to new regs interface

### Approval period

  * (gh#750) **Port to the TI EK-TM4C1294XL evaluation kit**
  * (gh#760) **MMIO Interface with automatic peripheral clock management**
