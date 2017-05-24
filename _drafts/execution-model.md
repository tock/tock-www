---
title: Execution Model
authors: alevy
---

## Capsules

The kernel executes capsules cooperatively. The kernel scheduler is
event-driven and the entire kernel shares a single stack.  `fig:concurrency`
illustrates the execution model in the kernel.  Events are generated from
asynchronous hardware interrupts, such as a timer expiring or a physical button
being pressed, or from system calls in a running process. Capsules interact
with each other directly through function calls or share state variables.

Capsules cannot generate new events and instead interact with the rest of the
kernel directly through normal control flow. This has two benefits. First, it
reduces overhead since using events would require each interaction between
capsules to go through the event scheduler. With simple functions, the
interactions compile to a few instructions are or completely inlined away.
Second, Tock can statically allocate the event queue since the number of events
is known at compile-time. Similar to how TinyOS manages its task queue, this
prevents faulty capsules from enqueueing many events, filling the queue, and
harming dependability by exhausting the queue resource.

## Processes


Tock processes are hardware isolated concurrent executions of programs,
similar to processes in other systems~\cite{osprinciples-ch2-1}. They have a logical
region of memory that includes their stack, heap, and static variables, and is
independent from the kernel and other processes. Separate stacks allow the
kernel to schedule them preemptively---all kernel events are given higher
priority than processes while a round-robin scheduler switches between active
processes. Processes interact with the kernel through a system call
interface and with each other using an IPC mechanism.

While similar to processes in systems such as Linux, Tock processes
differ in two important ways. First, because MCUs only support
absolute physical addresses, Tock does not provide the illusion of
infinite memory through virtual memory nor do processes share code through
shared libraries.
Second, the system call API to the kernel is non-blocking.

Processes have two main advantages over capsules. First, because they
are hardware isolated rather than sandboxed by a type-system, they can
be written in any language. As a result, they are convenient for
working with and incorporating existing libraries written in other
languages (such as C). Second, they are preemptively scheduled so can
safely execute long-running computations, such as encryption or signal
processing.

Memory protection units provide relatively high granularity of access control.
They can set read/write/execute bits on regions of memory as small as 32 bytes.
For example, this allows processes using IPC to directly share memory regions
as small as 32 bytes. In principle, processes could be given access to certain
memory mapped I/O registers by the kernel to enable low-latency direct hardware
access. However, for peripherals we have considered so far, such as the
Bluetooth Low Energy transceiver of the Nordic nRF51, it is not possible to do
so without exposing side-channel memory access through DMA registers\@.
Finer-grained MPUs or I/O register interfaces designed for this functionality
might eventually make this possible.
