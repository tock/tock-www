---
title: Talking Tock 51
subtitle: Slightly past due edition!
author: bradjc
authors: bradjc
---

Tock is (theoretically) no longer Cortex-M specific!

With ARM Cortex-M cores growing in popularity starting in 2010 or so, and ARM
cores widespread use in smartphones spurring rapid growth in toolchain
development, Tock was conceived as a new embedded operating system targeting 32
bit ARM Cortex-M microcontrollers. Over time, it has become clear that being
choosy about the platforms Tock supports has been wise, and not having to
support the long-tail of very constrained microcontrollers has enabled Tock
developers to explore what a more sophisticated embedded OS can be. As an
example of this, while the Cortex-M0 based nRF51822 MCU from Nordic is a
functional BLE SoC, its lack of features made it impossible to support Tock's
vision, and support for the chip was dropped and the code was moved out of the
Tock repository.

While ARM Cortex-M chips remain ubiquitous, growing competition and the feature
set of Tock are beginning to make other platforms also attractive as platforms
for Tock. To make this feasible, tracking issue gh#985 was opened exactly one
year ago to organize the effort to cleanly abstract the implementation details
specific to the Cortex-M architecture. The goal was to enable implementations
for other architectures to expand the platforms that Tock can support.

Through a series of pull requests (gh#962, gh#1029, gh#1111, gh#1113, gh#1115,
gh#1159, gh#1191, gh#1136, gh#1194, and gh#1315), slowly the kernel was updated
to create the interfaces necessary for multiple architecture support, as well as
to move all of the Cortex-M-specific details to the `/arch` folder.

This effort was intended to eventually enable support for the new
[RISC-V](https://riscv.org/) ISA and architecture that has been garnering much
excitement and industry support (gh#1135). The first signs of the move away from
Tock being Cortex-M specific are beginning to show up. gh#1317 recently added
the first RISC-V based platform to Tock. gh#1323 includes the first
implementation of the context-switching code needed to support Tock applications
on RISC-V platforms. Supporting RISC-V has highlighted areas where some Cortex-M
details still linger in the Tock kernel. gh#1318 updates the interface between
userspace and the kernel to remove some artifacts carried over from the Cortex-M
implementation.

As platforms like RISC-V grow on Tock we will continue to learn how Tock can
support multiple architectures. Areas like how interrupts should be managed
provide opportunities to explore as RISC-V provides a handful of new interrupt
controllers. Also, future RISC-V embedded chips may include more than two
privilege modes which may provide other possibilities for Tock.

More testing is still require to see if Tock really supports more architectures
than just Cortex-M, but so far the results are promising.
