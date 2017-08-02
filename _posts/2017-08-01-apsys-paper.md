---
title: Compile-time Safety is for Everybody!
author: aalevy
authors: alevy
---

We just submitted the camera-ready version for a [short
paper](/assets/papers/rust-kernel-apsys2017.pdf) on building kernels in Rust
that will appear in APSys 2017 (Asia Pacific Workshop on Systems) next month.
We're really excited about to be able to share this paper because it clarifies
some important misconceptions about our evaluation of Rust from our previous
work.

<div style="background-color: white; border: 1px solid #ccc; color: #000; box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.7); display: inline-block; margin: 0 auto; text-align: left; padding: 16px;">
Come to our [training session at RustConf](/events/rustconf2017) this month!  We
will show you how to build and run Tock on real hardware, and how to write
kernel extensions and applications in Rust!
</div>


Specifically, a workshop paper we published nearly two years ago, title
"Ownership is Theft", has been
[discussed](https://www.reddit.com/r/rust/comments/3nbt2d/ownership_is_theft_experiences_building_an/)
[extensively](https://www.reddit.com/r/rust/comments/655816/ownership_is_theft_experiences_building_an/)
in the Rust community. It reported on challenges we ran into early on building
Tock in Rust and, maybe as a result, many took it as a warning against using
Rust for kernel development. It may also have been the result of the incendiary
title. No regrets![^proudhon]

[^proudhon]: Even Pierre-Joseph Proudhon's original slogan, "Property is Theft!",
             was criticized in hind-sight as being self-refuting. Just as
             that slogan remains valuable in understanding early anti-capitalist thought, our
             workshop paper gives a glimpse into initial attempts to use a
             linear-type-based language for low-level kernel development. The two are
             basically the same.

We've since understood how to work around those issues, in large part thanks to
help from the Rust community. This let us continue making significant progress
on Tock, including the beginnings of a deployment this month of the Signpost
city-scale sensor network, which runs Tock.

## The Promise

One of Tock's main design goals is to bring extremely fine-grained isolation to
low-power (think <100uA on average), low-memory (think <64kB of RAM) systems.
For example, Tock lets embedded programmers mix their own code and library code
from hardware vendors or the open source community without having to completely
trust every line of code. Do you have an accelerometer and encryption module
sitting on the same communication bus? Want to make sure the fancy step counter
library you're using doesn't have access to your encryption keys? Tock can help
with that!

So what's the problem?

Well, most operating systems assume that all kernel code is trusted. In part,
this is because they rely on hardware enforced memory protection, and the process
abstraction in particular, to provide isolation.

Unfortunately, the process is a heavy-weight abstraction: each process has at
least a stack and some kernel data structures. and switching between virtual
address spaces is costly. So, hardware enforced memory protection doesn't "scale
down"[^process-exceptions].

[^process-exceptions]: There are some success stories using this approach. Two
                       examples are OKL4---a L4 microkernel that ships in
                       Qualcomm wireless modems as well as the iOS secure
                       enclave---and Android, where most OS services are
                       implemented in services (although it still runs on top of
                       the monolothic Linux kernel). Both of those are for
                       "small" systems, but still systems with many orders of
                       magnitude more memory and processing power than they
                       typical microcontroller Tock targets.


There have also been a number of research systems that attempted to replace
hardware enforced isolation with _language_ enforced isolation. Most notably,
Spin used Modula-3 to allow applications to extend the kernel and Singularity
used Sing\# (a variant of C\#) to replace hardware enforcement completely with
type-safety (notably, the entire system runs in privileged hardware mode). But
all of these systems have used garbage-collected languages. There are various
issues with garbage collection in the kernel, but most importantly, it generally
a relatively large and complicated runtime that must be completely trusted.

When we started working on Tock, we realized that Rust provided an incredibly
promising opportunity. Rust is the first "mainstream"[^mainstream] language to
enforce type-safety strictly without relying on runtime memory management, by
using affine types (more on that later). Moreover, Rust's compilation model is
basically identical to C, so it's relatively easy to control things like memory
layout. This meant that it's possible to build a kernel that allows extremely
fine-grained isolation _at almost no cost_ and including only  _**a minimal
trusted computing base (TCB)**_.

[^mainstream]: People might mean different things by mainstream, and Rust may or
               may not fit into those definitions. Here, I just mean that it's
               well maintained enough to be a reasonable choice for a project
               that intends to last a while.

## The Problem

Rust uses a concept called *ownership* (an affine type
system) to determine at *compile time* when memory should
be freed. The benefit of ownership is that it prevents mutable aliasing of
values, so it addresses associated issues with both concurrency and memory
management. The problem with ownership is that it prevents mutable aliasing of
values... which is something we often _want_ in kernels. More on that in a
bit.

One of the key things we missed when we wrote "Ownership is Theft" is that
preventing mutable alisases is not _just_ about concurrency, but also imperative
for preserving type-safety. For example, consider Rust’s `enum` types which
allow multiple distinct types to share the same memory, similar to unions in
C. In this example, the `enum` can be either a 32-bit unsigned number, or a
mutable reference (pointer) to a 32-bit unsigned number:

```rust
// Rust
enum NumOrPointer {
  Num(u32),
  Pointer(&mut u32)
}
```

```c
// Equivalent C
union NumOrPointer {
  uint32_t Num;
  uint32_t* Pointer;
};

```

But unlike unions in C, a Rust `enum` is type safe. The language ensures that it is
impossible to access a `NumOrPointer` as a `Num` when the compiler thinks it is
a `Pointer`, and vice-versa.

Having two mutable references to the same memory could violate
`NumOrPointer`'s safety and would allow code to construct
arbitrary pointers and access any memory. Suppose that the
`NumOrPointer` is currently a `Pointer`. If one of
the references is to a `Pointer` but the other can change it
to a `Num`, then it can create an arbitrary pointer:

```rust
// Rust
// n.b. will not compile
let external : &mut NumOrPointer;
match external {
  Pointer(internal) => {
    // This would violate safety and
    // write to memory at 0xdeadbeef
    *external = Num(0xdeadbeef);
    *internal = 12345;  // Kaboom
  },
  //...
}
```

```c
// Equivalent C
// compiles without warning
union NumOrPointer* external;
uint32_t* numptr = &external->Num;
*numptr = 0xdeadbeef;
*external->Pointer = 12345;
```

But operating system kernels depend heavily on callbacks and other event-driven
programming mechanisms. Often, multiple components must both be able to mutate a
shared data structure. Consider, for example, the random number generator
software stack as shown in the [figure below](#rngimg). `RNG` provides an
abstraction of an underlying hardware random number generator, such as Intel’s
RDRAND/RDSEED or a TRNG on an ARM processor.

![Software architecture for a system call interface to a hardware random
number generator: both `RNG` and the system call interface
need references to `SimpleRng`.](/assets/2017/08/rng.png){:#rngimg}

`SimpleRng` sits between `RNG` and the system call
layer. It translates between userspace system calls and the
`RNG` interface. It calls into `RNG` when a
process requests random numbers and calls back to the system call layer
when random numbers are ready to deliver to the process. A natural way
of structuring this stack is for both the system call layer and
`RNG` to have a reference to `SimpleRng`

```rust
pub struct SimpleRNG {
  busy: bool,
  // ...
}

impl SimpleRng {
  fn command(&mut self) {
    self.busy = true;
    // ...
  }
  fn deliver(&mut self, rand: u32) {
    self.busy = false;
  }
}

impl SysCallDispatcher {
  fn dispatch(&mut self, num: u32) {
    match num {
      // ...
      43 => self.simple_rng.command(),
    }
  }
}

impl RNG {
  fn done(&mut self, rand: u32) {
    self.simple_rng.deliver(rand);
  }
}
```

Rust’s ownership model does not allow both structures to have a mutable
reference to `SimpleRng` (the reference must be mutable because `command` marks
`SimpleRNG` as `busy`, and `deliver_rand` marks it as not `busy`, mutating the
internal state of the `SimpleRNG` object).

## The Solution: Interior Mutability

It turns out there are _certain instances_ where it's perfectly safe to have
mutability doesn't _only_ have to happen through unique references to preserve
type-safety. In fact, in _most_ cases in a kernel, we don't directly share
constructs like `enum`. Rust has a notion of container types that have what's
called "interior mutability". Interior mutability is basically the ability to
bypass the single-mutable-reference rule, in a controlled manner[^subtle].

The Rust core and standard libraries have a number of types like this: `Cell`,
`RefCell` and `Mutex`, to name a few. In all of these cases, users can use
shared references (`&`) to mutate the value. These container types are safe
because they either copy values in and out entirely (`Cell`) or enforce some for
of mutual exclusion (`RefCell` and `Mutex`).

In Tock we use these ubiquitously. Except in rare cases, all of our components
use shared references to `self` and each other, and pushing all mutability to
the "leaves" of data structures. For example, the `SimpleRng` example above,
which had a simple boolean field marking if it's currently busy, would actually looks like this:

```rust
pub struct SimpleRng {
  busy: Cell<bool>,
  // ...
}

impl Syscall for SimpleRng {
  fn command(&self) {
    // ...
    self.busy.set(true);
  }
}
```

Both the RNG and the system call dispatcher hold a shared reference to the same
SimpleRng. Normally, this would mean that calls from either would not be able to
modify `SimpleRNG`'s internal state. However, `Cell` allows the command method
to set busy to be true even though `&self` is a shared reference.

[^subtle]: There is a subtle point here, which is that without constructs like
           `enum`s, it might be possible to relax the ownership model in many
           cases without sacrificing type-safety. In our previous paper, we
           didn't consider how pervasive `enum` (and enum-like constructs) are
           in Rust or how unweildy the language would get without them, so we
           had proposed a language modification. We no longer believe that's
           either necessary or desirable.


## The Result

Using this architecture, it is possible to achieve a minimal trusted computing
base (TCB) without sacrificing performance or memory. In Tock, the TCB includes
about 1000 lines out of 6000 lines of our own code, in addition to the Rust core
library (and really only a small subset of it that we actually use).

Moreover, we've managed to use the type system to enforce isolation at
granularities that are not possible with hardware isolation alone. See [the
paper](/assets/papers/rust-kernel-apsys2017.pdf) for some examples that show,
e.g., how we give untrusted components direct access to DMA hardware registers
but still enforce that they cannot access arbitrary memory.

---

Does this make you want to build embedded systems using Rust and Tock? Come to
our [training session at RustConf](/events/rustconf2017) this month!

