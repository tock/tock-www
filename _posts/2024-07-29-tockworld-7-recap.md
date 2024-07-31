---
title: TockWorld 7 Recap
authors:
  - alevy
---

![](/assets/2024/07/tockworld7-crowd.jpg){: style="float: left; width: 50%; padding-right: 1em"}
On June 26-28 we held the 7th annual Tock gathering in San Diego,
CA. This year combined a developer day, conference, and tutorials,
expanding the purpose and audience of TockWorld.

In terms of both participation and content, this was the most vibrant
and exciting TockWorld to-date. Participants came from all over the
world, including students, researchers, and practitioners, from
companies large and small. We had, for the first time, an array of
conference-style talks that shared experiences working with Tock,
deploying Tock, and expanding Tock to new domains and architectures.

To get the full experience, you'll just have to attend next time[^f1],
but what follows is a recap of the take aways from the developer day
and highlights from the exciting talks.

## Conference Highlights

The conference saw talks from users, developers and educators, as well as an excellent keynote on the socio-technical elements of software trust from [Florian Gilcher](https://skade.me) of [Ferrous Systems](https://ferrous-systems.com/).

### Keynote: tRust (Florian Gilcher)

[Slides](https://ferroussystems.hackmd.io/@skade/tockworld-7-keynote)

Our Keynote speaker, Florian Gilcher of Ferrous Systems, has spent a
career working in and around open source communities---in Ruby then in
Rust, including as a core group member. He gave a historical
perspective on the connection between social organizations around
technology and trust and the importance of building social trust.

I encourage looking at the slides (or convincing Florian to give this talk at your company or event!) for the all the interesting anecdotes and details.

### Tock on x86 (Bobby Reynolds)

Bobby Reynolds from Microsoft's Pluton team shared their reasons and
experience porting Tock to x86 for Pluton---Microsoft's
secure-root-of-trust hardware IP.

This talk included a bunch of detail on the motivation behind choosing
Tock for Pluton, including improved security posture through both use
of Rust, and the process isolation model, a clear portability story,
and modularity and concurrency.

#### What is Pluton?

Pluton is a HW Security Processor embedded on the CPU die and
co-designed with with silicon partners. The first version of the
next-gen Pluton running Tock is on the Ryzen AI 300 series CPUs from
AMD. PlutonOS is a Pluton-specific distribution of Tock developed by
Microsoft and shipped alongside Windows updates.

#### An x86 Port

Pluton on the Ryzen AI 300 is based on the original pentium (i586)
architecture, an architecture that we never considered for Tock given
the focus of x86 on systems with much more memory. In other respects, this Pluton variant is similar to other Tock targets: it has well under 1MB of SRAM and a bunch of non-standard, specialized peripherals.

The goal, and surprising outcome, of this port was to avoid any
upstream changes and just have the x86 port sit alongside other Tock
`arch` crates.

#### Challenges

Bobby shared that, nonetheless, there were a bunch of challenges
porting Tock to a quite different architecture than Cortex-M or RISC-V
including mapping Tock's current memory protection model to x86's
virtual memory, migrating system call invocation to be more
stack-based, and some subtleties of x86 interrupt handling that make
it less amenable to how interrupts are organized in upstream Tock.

### Bringing Tock to CHERI (Lawrence Esswood)

Lawrence Esswood from Google described an ongoing effort to use Tock
on CHERI-based hardware.

CHERI is an ISA extension that enables hardware enforced capabilities---a combined object and authority primitive in the hardware that, essentially, encodes access permissions in the pointer itself.

The port is for a RISCV-based CHERI architecture, currently running
primarily in emulation. The initial goal is to have version that
supports running "purecap" process binaries---meaning user-space
processes can _only_ use CHERI-based pointers; while the kernel will
remain "hybrid"---it uses CHERI capabilities instead of the MPU for
isolating applications, but the kernel itself is not bound by
capabilities for memory access.

While there have many details to "CHERIfy" Tock, one of the big
take aways from the talk was that only a small number of system calls
and libraries needed to be modified to support a quite different for
of buffer protection.

Since giving the talk, Lawrence [shared a
version](https://github.com/tock/tock-cheri) with the hope of
upstreaming major parts of CHERI support later this year.

### Tock on WebAssembly (Irina Nita)

Irina Nita, of OxidOS describe her port of Tock to run on WebAssembly for use in a development. The goal is to support a browser-based IDE for Tock along with a GUI for prototyping virtual hardware.

### Serial Multiplexing (Amalia Camilia Simion)

Amalia Camilia Simion from Politehnica Bucharest shared her work on
multiplexing serial devices in Tock and, in particular a new buffer
management interface in the kernel.

The key challenge for such a buffer interface is that it needs to
avoid dynamic memory allocation while dynamically adding headers and footers to buffers at different layers. Her new buffer management solution allows prepending and appending data without memory re-allocation. Total space for the buffer is pre-allocated during initializes, introducing headroom and tailroom beyond the initial payload.

## Developer Day

About 30 developers participated in the discussions, reports and
breakouts from the developer day, hailing from Princeton, UVA, UCSD,
Northwestern, Stanford, Google, Microsoft, OxidOS, UW, as well as
unaffiliated community contributors. We heard summaries of the year's
work from the core, networking, OpenTitan, documentation, libtock-c
and tools working groups. Those slides are all available from the
conference [agenda page](https://world.tockos.org/tockworld7#day1).

In addition, we had a number of very productive breakout sessions
focused on future development directions and a preview of
Treadmill---the in-development testing and remote development system.

### Non execute-in-place (XIP) platforms

In integrated settings---for example where a root-of-trust
microcontroller is on the same SoC as a more powerful application
core---there is often no persistent storage from which to execute code
directly. This may be, for example, because the SoC is too thin to fit
any flash storage. In such cases, Tock must be adapted to load code
(the kernel, processes) from persistent storage into RAM and execute
from their, raising several challenges and opportunities.

### Tock registers

This breakout focused on the [ongoing
effort](https://github.com/tock/tock/pull/4001/files) lead by
@jrvanwhy to revise Tock registers to be both more sound and more
ergonomic.

Downstream users raised a number of edge cases that would be good to
support in the library.

### Formal methods with Tock

This breakout gathered a number of developers either interested in or
engaged in formally verifying parts of Tock. In particular, one group at
Google had tried to do some verification using Kani with limited
success, primarily due to issues with Kani. UCSD is doing work with Flux
and Verus to verify portions of the Tock system call API and memory.

### Automated driver implementations

An idea raised in one of the discussions related to userspace
maintenance got its breakout to discuss the potential for automatically
generating userland bindings from specifications of a system call ABI in
the kernel.

### Panic-free kernel

This breakout discussed options towards a kernel with no `panic`. While
Tock generally tries to avoid explicit panics in the kernel, sometimes
that sneak in anyway, and sometimes they are hidden behind core language
features (e.g. slice operations).

### Multi-core

This breakout discussed adapting Tock to multi-MCU settings. A number
of use cases were raised: separate security domains on different MCUs;
applications that require enough performance to use two cores; SoCs
where Tock runs on some co-processor, but another core which runs some
different OS. One of main action items from this breakout included
revising and fixing IPC and finishing work on CoreLocal.

### CHERI

A small group of developers discussed using Tock in CHERI-enabled
hardware---CHERI is a hardware-based capability system that can provide
extremely fine grained and expressive memory protection. At least one
port currently exists, but a major blocker for significant upstream
support is support for CHERI in Rust itself (currently people using Rust
on CHERI have forked toolchains).


[^f1]: Or maybe we'll record the talks next time.
