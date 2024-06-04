---
title: Analyzing Binary Size Bloat in Tock
subtitle: 
author: folkert
authors: folkert
---

_This article is cross-posted from Tweede Golf's blog_

[Tock](https://tockos.org) is a powerful and secure embedded operating system. While Tock was designed with resource constraints in mind, years of additional features, generalizing to more platforms, and security improvements have brought resource, and in particular, code size bloat.

A _lot_ of code-size bloat. In 2018, when Tock was first released, a minimal kernel required ~7KB for code. Today, the default build for most platforms is easily over 100KB. This is a big problem for resource-sensitive applications--where a platform may only have a couple 100KB of executable flash or must execute from memory.

We (Folkert and Dion from Tweede Golf) recently worked on a project that explores where all of this extra code size is spent, how much of it is fundamental to the design of Tock, and how Tock could adapt to support more platforms with stricter code size constraints. 

## Baseline

Let's first establish a baseline. We pick the [NRF52840DK](POINTER), a development board for the popular [NRF52840](POINTER) from [Nordic Semiconductors](POINTER). It is one of the main development boards in the Tock community and is pretty representative of many embedded applications. It helps that we also happened to have a few lying around. Our exploration is based off of a recent tip-version of Tock (commit `41aafdca37e6961af3ae19742edcdf40cd8e8d1a`). The total size of the kernel for this version is

```shell
$ cd boards/nordic/nrf52840dk/
$ make
   text	   data	    bss	    dec	    hex	filename
 196610	     36	  34464	 231110	  386c6	...
```

The text section (where executable code lives) is almost 200kb! That's a lot...

## A Stripped-Down Board 

OK, most of that 200KB is from peripheral drivers, including  a full 6lowpan/802.15.4 stack, Bluetooth, as well as a number of subsystems for debugging, like a process console. Because Tock separates the kernel from applications, which can be loaded dynamically, the drivers a board configures are compiled in regardless of whether any application actually ever uses them.

So let's start by just removing superfluous components to get to a stripped-down board. Initially we'll only consider the kernel, so anything related to processes can also go. For a minimal functional program, we'll leave in logic for a serial port (UART) and to print a message. This ends up removing about 150KB of code.

| commit | size of .text (kb) |
| ----- | ---------- |
| [`439cfc4caaf12f656c4f9a5e9cf7bffd47da709e`](https://github.com/tweedegolf/tock/commit/439cfc4caaf12f656c4f9a5e9cf7bffd47da709e) | 45.1 |

Impressive! But 45KB is still a lot for a system that does very little. Getting rid of debug functionality in the `panic!` handler saves another 20KB:


| commit | size of .text (kb) |
| ----- | ---------- |
| [`fa97bb11f3f406e3893c814a674f79776a4dfb8b`](https://github.com/tweedegolf/tock/commit/fa97bb11f3f406e3893c814a674f79776a4dfb8b) | 24.6 |


We now have a barebones version of Tock that can run processes and supports a minimal set of functionality--just printing to the console.


## Let's Pretend We Don't Want Processes

We can go furher by getting rid of the process loading and scheduling infrastructure and, instead, implement a very simple timed-print inside the kernel itself.

Just removing processes entirely (by setting `NUM_PROCS` to 0 and letting code elimination do its magic) and implementing a simple kernel application, we cut the code size down by another 50%: 

| commit | size of .text (kb) |
| ----- | ---------- |
| [`57174fbd560b9f0495f136b7ddb1c63644a9fd41`](https://github.com/tweedegolf/tock/commit/57174fbd560b9f0495f136b7ddb1c63644a9fd41) | 12.3 |

Since our kernel now only uses the serial driver and timer infrastructure in one place, we can further get rid of the virtualization layers for both, which cost ~4KB in this case:

| commit | size of .text (kb) |
| ----- | ---------- |
| [`952641f4553b80a749fde14d914b6aeeffbbdeb7`](https://github.com/tweedegolf/tock/commit/952641f4553b80a749fde14d914b6aeeffbbdeb7) |  8.2 |

Finally, we can remove ~1.5KB of extraneous padding in the linker script which is only useful when allocating flash for a persistent storage driver:

| commit | size of .text (kb) |
| ----- | ---------- |
| [`395222c24f975f7a47cc86f761b6013eedb0f4f7`](https://github.com/tweedegolf/tock/commit/395222c24f975f7a47cc86f761b6013eedb0f4f7) |  6.8 |

We're now down to a more respectable size for a minimal kernel.

---

At this point we ran out of things we knew we could remove. We can check with `cargo bloat` what the remaining functions in the binary are, and whether we think they make sense. In this case, the report looks pretty reasonable: there is no more formatting or obvious debugging code on a function level.

```
> make cargobloat
File  .text   Size             Crate Name
0.3%  31.5% 2.0KiB        nrf52840dk nrf52840dk::start
0.3%  30.0% 1.9KiB            kernel <kernel::kernel::Kernel>::kernel_loop::<nrf52840dk::Platform, nrf52::chip::NRF52<nrf52840::interrupt_servi...
0.1%   5.9%   378B compiler_builtins compiler_builtins::int::specialized_div_rem::u64_div_rem
0.0%   4.7%   306B             nrf52 <nrf52::uart::Uarte>::handle_interrupt
0.0%   2.2%   140B             nrf52 init
0.0%   2.1%   138B compiler_builtins compiler_builtins::mem::memcpy
0.0%   1.6%   104B        nrf52840dk <nrf52840dk::hello_world::HelloWorld<nrf5x::rtc::Rtc, nrf52::uart::Uarte> as kernel::hil::time::AlarmClien...
0.0%   1.5%    98B compiler_builtins compiler_builtins::mem::memset
0.0%   1.1%    72B           cortexm <cortexm::systick::SysTick as kernel::platform::scheduler_timer::SchedulerTimer>::get_remaining_us
0.0%   1.0%    64B             nrf5x <nrf5x::rtc::Rtc as kernel::hil::time::Alarm>::set_alarm
0.0%   0.7%    44B           cortexm <cortexm::nvic::Nvic>::enable
0.0%   0.7%    42B             nrf5x <nrf5x::timer::TimerAlarm>::handle_interrupt
0.0%   0.6%    40B           cortexm cortexm::nvic::has_pending
0.0%   0.6%    40B compiler_builtins <u64 as compiler_builtins::int::shift::Ashl>::ashl
0.0%   0.6%    38B             nrf52 <nrf52::uart::Uarte>::set_tx_dma_pointer_to_buffer
0.0%   0.6%    36B             nrf5x <nrf5x::pinmux::Pinmux>::new
0.0%   0.5%    34B            kernel <kernel::collections::list::List<kernel::scheduler::round_robin::RoundRobinProcessNode>>::push_tail
0.0%   0.5%    32B         [Unknown] main
0.0%   0.4%    28B         cortexv7m cortexv7m::hard_fault_handler_arm_v7m_kernel
0.0%   0.4%    26B compiler_builtins compiler_builtins::arm::__aeabi_memset4
```

### Expensive division

The only thing that really caught our attention is the compiler builtins. In particular, the 64-bit integer division is quite large. The target we use has no instruction for this operation, so it is implemented entirely in software. 

```
File  .text   Size             Crate Name
0.1%   5.9%   378B compiler_builtins compiler_builtins::int::specialized_div_rem::u64_div_rem
0.0%   2.1%   138B compiler_builtins compiler_builtins::mem::memcpy
0.0%   1.5%    98B compiler_builtins compiler_builtins::mem::memset
0.0%   0.6%    40B compiler_builtins <u64 as compiler_builtins::int::shift::Ashl>::ashl
0.0%   0.4%    26B compiler_builtins compiler_builtins::arm::__aeabi_memset4
```

This operation is used to convert between microseconds (for humans) and native ticks (for computers). For instance:

    hertz * us / 1_000_000

It might be worth it to actually write this as a subtracting loop, something like: 


```rust
pub fn micros_to_ticks(freq: u32, micros: u32) -> u32 {
    let mut remaining = freq as u64 * micros as u64;

    let mut accum = 0;

    let mut num = 1_000_000_000u32;
    let mut fac = 1_000u32;

    while fac > 0 {
        while let Some(new) = remaining.checked_sub(num as u64) {
            remaining = new;
            accum += fac;
        }

        num /= 10;
        fac /= 10;
    }

    accum
}
```

### GPIO pin initialization

Because `start` is the biggest function, we had a look at its source code to see if there is anything we can cut out. After some trial and error, we found that the initialization of GPIO pins uses a lot of instructions.

| commit | size of .text | size of `nrf52840dk::start`  |
| -- | -- | -- |
| [`d915dc33718688f21c44265aca10891ac9a4805e`](https://github.com/tweedegolf/tock/commit/d915dc33718688f21c44265aca10891ac9a4805e) | 8822B | 2100B |
| [`f893f60346b7a07bbd4bddd21dfe8eff11a36c12`](https://github.com/tweedegolf/tock/commit/f893f60346b7a07bbd4bddd21dfe8eff11a36c12) | 7574B  |  940B |

This "solution" in the final commit is incorrect, but it shows there is potential here: even for a small binary the gains are substantial.

The problem is that the initialization cannot occur in a const, so all the pins need to be set up at runtime.

## With processes

In practice, Tock will of course run processes. So while the previous experiment is useful to learn how small the kernel could be, it is not realistic.

When we bump the number of processes from zero to one, the binary gets a lot bigger again. Cargo bloat shows that there is formatting code in the binary.

```
File  .text   Size             Crate Name
0.1%   3.6%    812B              core <&mut cortexm::mpu::CortexMConfig<8: usize> as core::fmt::Display>::fmt
0.0%   1.5%    328B              core <core::fmt::Formatter>::pad_integral
0.0%   1.3%    288B              core <core::fmt::Formatter>::write_fmt
0.0%   1.0%    222B              core <core::fmt::Formatter>::pad
```

However, it is not immediately obvious what the root cause is. We could do some searching through the disassembly to track down callers to those formatting functions, but in this case there is a simpler way. 

By default `cargo bloat` cuts lines off so they fit in your terminal. 

```
File  .text    Size             Crate Name
0.4%  19.6%  4.3KiB        nrf52840dk nrf52840dk::start
0.2%   8.6%  1.9KiB            kernel <kernel::kernel::Kernel>::kernel_loop::<nrf52840dk::Platform, nrf52::chip::NRF52<nrf52840::interrupt_serv...
0.1%   7.7%  1.7KiB            kernel <kernel::process_standard::ProcessStandard<nrf52::chip::NRF52<nrf52840::interrupt_service::Nrf52840Defaul...
0.1%   3.6%    812B              core <&mut cortexm::mpu::CortexMConfig<8: usize> as core::fmt::Display>::fmt
```

To get the full name of functions, we need to pass 

```
> CARGO_BLOAT_FLAGS=-w make cargobloat

File  .text    Size             Crate Name
0.4%  19.6%  4.3KiB        nrf52840dk nrf52840dk::start
0.2%   8.6%  1.9KiB            kernel <kernel::kernel::Kernel>::kernel_loop::<nrf52840dk::Platform, nrf52::chip::NRF52<nrf52840::interrupt_service::Nrf52840DefaultPeripherals>, 1: u8>
0.1%   7.7%  1.7KiB            kernel <kernel::process_standard::ProcessStandard<nrf52::chip::NRF52<nrf52840::interrupt_service::Nrf52840DefaultPeripherals>> as kernel::process::Process>::print_full_process
```

Now we find a large function with "print" in its name. Suspicious!

```rust
fn print_full_process(&self, writer: &mut dyn Write) {
    // Disable the printing to save bytes! The precious bytes!
    if !config::CONFIG.debug_panics {
        return;
    }

    // ...
}
``` 

We can easily remove all the formatting code by turning this into an `if true`. Dead code elimination will just remove the rest of this function's body.

The commit below bumps the number of processes to one and removes the debug info:

| commit | size of .text (kb) |
| -- | -- |
| with one process | 22.8 |
| [`6ee2198a58b7ef6e3251803509cf4e66b65a6587`](https://github.com/tweedegolf/tock/commit/6ee2198a58b7ef6e3251803509cf4e66b65a6587) | 16.8 |


## Memmove

Next we decided to use the C blinky application as our benchmark, and made some modifications to the code so memmove is not included.

| commit | size of .text (kb) |
| -- | -- |
| [`24fac24a2fa0adfebb968188e9b1d56027886d2e`](https://github.com/tweedegolf/tock/commit/24fac24a2fa0adfebb968188e9b1d56027886d2e) | 20.1 |
| [`10afc491f124ebe9cef64e8b26bd23d209656b78`](https://github.com/tweedegolf/tock/commit/10afc491f124ebe9cef64e8b26bd23d209656b78) | 19.8 | 

The memmove story is interesting. It turns out that code like

```rust
if dst != src {
    slice[dst] = slice[src]
}
```

is actually emitted as a `memmove`, even though all conditions for a `memcpy` are satisfied. 

- [zullip thread](https://rust-lang.zulipchat.com/#narrow/stream/405744-wg-binary-size/topic/memmove.20instead.20of.20memcopy)
- [llvm issue](https://github.com/llvm/llvm-project/issues/86499)

This is unfortunate because `memmove` is slower and also much bigger than `memcpy` (which is often included anyway).

## Takeaways

So now we know where Tock's code size bloat comes from, and how Tock could adapt to support more platforms with stricter code size constraints:

* The peripheral initialization is very expensive, so ideally the user has more fine-grained control over what is included.
* The panic handler itself is not that big, but it pulls in a large amount of `fmt::Debug` code to print the error.
* Finally reducing the number of processes to zero means that certain loops can be eliminated entirely, leading to dead code elimination.
