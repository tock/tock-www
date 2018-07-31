---
title: Memory-Mapped Registers in Tock
authors: brghena
excerpt: >
  Microcontrollers typically use memory-mapped I/O interfaces to control
  hardware peripherals. Driver code uses these memory-mapped registers and
  fields to interact with the peripheral while providing a higher-level interface
  to the rest of the system. This post describes how Tock deals with register
  memory maps and a new tool that can automatically generate memory maps for many
  ARM microcontrollers.
---

1. TOC
{:toc}

Microcontrollers typically use [memory-mapped
I/O](https://en.wikipedia.org/wiki/Memory-mapped_I/O) interfaces to
control hardware peripherals such as external interfaces (e.g. UART or
ADC) as well as internal features (e.g. timers or power states). Each memory
address for interacting with a specific peripheral is known as a *register*.
Each register has a number of *fields*: a set of one or more
bits that can be read to indicate or written to activate one logical ability
in the peripheral. Driver code uses these memory-mapped registers and fields to
interact with the peripheral while providing a higher-level interface to the
rest of the system.

Mistakes in memory maps are a real concern in embedded software. Mistakenly
writing to an unintended bit could, in the best case, fail to have to the expected
effect. Worse, it could have an entirely unexpected effect in the
low-level hardware. For instance, in the SAM4L UART control register, the bit
adjacent to disabling the receiver instead enables the transmitter. Debugging
mistakes in memory maps can be difficult and frustrating. This post
describes how Tock deals with register memory maps and a new tool that can
automatically generate memory maps for many ARM microcontrollers.

## Tock Registers

The first way that Tock avoids possible mistakes in peripheral memory map
interactions is to encapsulate them in a defined type, the
[Tock Register Interface](https://github.com/tock/tock/tree/master/libraries/tock-register-interface),
that is capable of providing compile-time checks.

First, the register interface has a particular way to define registers and
fields within them. Each register is marked as `ReadOnly`, `WriteOnly`,
or `ReadWrite`, which matches the way the hardware exposes them. Then
drivers are only able to use functions (such as `read` or `write`)
corresponding to the capabilities of a register when accessing it.

For example, here's a snippet from the SAM4L USART registers, which defines the
Control Register (`cr`) and Mode Register (`mr`), both of which are 32-bit
registers.

```rust
struct UsartRegisters {
    // Control register: 32-bits, write-only
    cr: WriteOnly<u32, Control::Register>,
    // Mode register: 32-bits, read-write
    mr: ReadWrite<u32, Mode::Register>,
    ...
}
```

Next, each register's fields are defined with their offsets within the
register and their lengths (both in bits). If the values for a field have
names, those are also included.

For example, here are a subset of the fields for the SAM4L USART mode register.
The `OFFSET` specification is the bit location of the start of the field in the
32-bit register. The `NUMBITS` specification is the length of the field. While
the `CLK0` and `FILTER` fields are only a single bit and can either be
activated or not, the `MODE` register has several specified states which the
UART can be in.

```rust
register_bitfields! [u32
    Mode [
        FILTER        OFFSET(28)  NUMBITS(1) [],
        CLKO          OFFSET(18)  NUMBITS(1) [],
        MODE          OFFSET(0)   NUMBITS(4) [
            NORMAL        = 0b0000,
            RS485         = 0b0001,
            HARD_HAND     = 0b0010,
            MODEM         = 0b0011,
            ISO7816_T0    = 0b0100,
            ISO7816_T1    = 0b0110,
            IRDA          = 0b1000,
            LIN_MASTER    = 0b1010,
            LIN_SLAVE     = 0b1011,
            SPI_MASTER    = 0b1110,
            SPI_SLAVE     = 0b1111
        ]
    ],
    ...
]
```

Putting these together, a driver uses the fields to access peripheral
registers. Whereas before, a write to the UART mode register may have looked
like:

```rust
usart.registers.mr.write((0b0000 << 0)
                  + (0b1 << 18) + (0b1 << 28));
```

With the Tock Registers Interface it looks like:

```rust
usart.registers.mr.write(Mode::MODE::NORMAL
                  + Mode::CLKO::SET + Mode::FILTER::SET);
```

The really cool bit about the registers system is that it prevents mistakes
when used in a driver. For instance if you meant to write to the mode register,
but mistakenly specified `cr` (the control register), the code would no longer
compile.

```rust
error[E0308]: mismatched types
   --> tock/chips/sam4l/src/usart.rs:940:13
    |
940 | /             Mode::MODE::NORMAL + Mode::CLK0::SET
941 | |                 + Mode::FILTER::SET,
    | |___________________________________^
            expected struct `usart::Control::Register`,
            found struct `usart::Mode::Register`
```

## SVD Files

One particular pain point with the register system has been authoring these
register definitions. Each peripheral has several registers, each of which can
have up to 32 fields. For ARM microcontrollers, however, this problem has
already been addressed with
[SVD files](http://arm-software.github.io/CMSIS_5/SVD/html/index.html).

A `System View Description` file is a formal description of the registers for
each peripheral in a ARM microcontroller. They are created and maintained by
the company that made the chip. A collection of SVD files for dozens of chips
by manufacturers like STMicroelectronics, Texas Instruments, and Nordic
Semiconductor are available in the python package
[cmsis-svd](https://github.com/posborne/cmsis-svd).

## Automatic Generation

The standard format of SVD files allows them to be parsed in order to generate
register fields. Using this, [Stefan Hölzl](https://github.com/stefanhoelzl)
created a new Tock tool, `svd2regs`, in (gh#877). `svd2regs` parses the SVD
file for a microcontroller and generates the Tock register interface code for a
specified register.

We're really excited about `svd2regs` because it reduces the effort for Tock to
support a new chip. One of the more tedious parts of adding peripheral drivers
is the creation of its registers structures, which is now automated, reducing
the possibility for human-error in transcription.

## Comparison to `svd2rust`

Tock's register interface is not the only effort to add compile-time
checking and access control to memory-mapped registers.
[`svd2rust`](https://github.com/japaric/svd2rust) also automatically generates
register maps in Rust from SVD files. The
[register system](https://docs.rs/svd2rust/0.12.1/svd2rust/) is very
similar in capability to the Tock register interface, especially for SVDs with
enumerated values.

One notable difference between the two interfaces is that `svd2rust` relies on
closures to guarantee compile-time checks, while Tock does not. For example,
here is LED blink code written using both interfaces. The example is taken from
the [STM32F042 repo](https://github.com/therealprof/stm32f042/blob/master/examples/blinky.rs).

Example with the Tock register interface:

```rust
fn main() {
    let rcc_regs: &RccRegisters = &*RCC_BASE;
    let gpioa_regs: &GpioaRegisters = &*GPIOA_BASE;

    /* Enable clock for SYSCFG, else everything will
     * behave funky! */
    rcc_regs.apb2enr.modify(APB2ENR::SYSCFGEN::SET);

    /* Enable clock for GPIO Port A */
    rcc_regs.ahbenr.modify(AHBENR::IOPAEN::SET);

    /* (Re-)configure PA1 as output */
    gpioa_regs.moder.modify(MODER::MODER1::SET);

    loop {
        /* Turn PA1 on a million times in a row */
        for _ in 0..1_000_000 {
            gpioa_regs.bsrr.write(BSRR::BS1::SET);
        }
        /* Then turn PA1 off a million times in a row */
        for _ in 0..1_000_000 {
            gpioa_regs.bsrr.write(BSRR::BR1::SET);
        }
    }
}
```

Example with `svd2rust` structs:

```rust
fn main() {
    if let Some(p) = stm32f042::Peripherals::take() {
        let rcc = p.RCC;
        let gpioa = p.GPIOA;

        /* Enable clock for SYSCFG, else everything will
         * behave funky! */
        rcc.apb2enr.modify(|_, w| w.syscfgen().set_bit());

        /* Enable clock for GPIO Port A */
        rcc.ahbenr.modify(|_, w| w.iopaen().set_bit());

        /* (Re-)configure PA1 as output */
        gpioa.moder.modify(|_, w| unsafe { w.moder1().bits(1) });

        loop {
            /* Turn PA1 on a million times in a row */
            for _ in 0..1_000_000 {
                gpioa.bsrr.write(|w| w.bs1().set_bit());
            }
            /* Then turn PA1 off a million times in a row */
            for _ in 0..1_000_000 {
                gpioa.bsrr.write(|w| w.br1().set_bit());
            }
        }
    }
}
```

We also designed the Tock register system to be a little more human readable
and compact. As an example, the resulting code from `svd2regs` for the
STM32F042 clock registers (RCC) is 322 lines of code whereas the resulting
code from `svd2rust` is 7713 lines in length. The big difference between the
two is that `svd2rust` places function definitions directly inline in the code,
whereas Tock hides them behind the `register_bitfields!` macro.
