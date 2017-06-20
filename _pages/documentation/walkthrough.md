---
layout: page
title: Tock Walkthrough
subtitle: From boot to blink
description:
  An end-to-end walkthrough of how Tock boots and runs a simple app.  Reviews
  the responsibilities of each crate, the system call interface and the
  user-level library.
permalink: /documentation/walkthrough/
---

* Will be replaced
{:toc}

Let's walk through an example of Tock running a notorious embedded application:
blink. The app simply toggles an LED every 500ms. The code for the application
itself is pretty simple:

```c
#define LED 0

int main(void) {
    gpio_enable_output(LED);

    while(1) {
      gpio_toggle(LED);
      delay_ms(500);
    }
}
```

First we make sure the GPIO pin connected to the LED (which is connected to
GPIO pin 0) is enabled as an output (line #4). Then, in an infinite loop, we
toggle the LED and wait for 500ms.

Under the hood, the kernel initializes the chip, board and peripherals, protects
most of the memory from the untrusted hands of the application, and sets up an
asynchronous timer allowing it to go to sleep during the delay, transparently
to the application. So let's dive in and see how this all works.

# The boot sequence

We start by going through the steps required to run the first line of
application code above. This involves initializing the chip (clocks,
controllers, etc), setting up the board (specifically initializing high-level
drivers and providing them with access to hardware resources) and process
initialization.

The ARM Cortex-M boot sequence is fairly minimal, especially since the CPU can
execute code directly from embedded flash. The CPU expects a _vector table_ at
the very beginning of flash (literally address 0). The vector table contains
function pointers to handlers for the various hardware interrupts and an
initial stack pointer value:

![ARM Cortex-M4 Vector Table](/assets/img/cortex-m4-vectors.png "ARM Cortex-M4
Vector Table (Cortex-M4 Devices Generic User Guide Figure2-2)")

When the CPU powers on, it simply loads the first word into the stack pointer
(SP) register, and the second word into the program counter (PC) register. From
there we can run arbitrary C/Rust code.

In Tock, the chip-specific crate[^sam4l-crate] sets up the vector table by
defining values in the `.vectors`[^vectors] section and relies on the
board-specific crate[^hail-crate] to place that section appropriately using it's linker
script:

[^sam4l-crate]: [SAM4L crate](https://github.com/helena-project/tock/tree/master/chips/sam4l)
[^vectors]: [SAM4L Vector Table](https://github.com/helena-project/tock/blob/master/chips/sam4l/src/lib.rs#L68)
[^hail-crate]: [Hail Crate](https://github.com/helena-project/tock/tree/master/boards/hail)

```rust
// Exposed by the linker script or board-specific crate
extern {
    // _estack is not really a function
    fn _estack();

    // Defined by platform
    fn reset_handler();
}

#[link_section=".vectors"]
#[no_mangle] // Ensures that the symbol is kept until the final binary
pub static BASE_VECTORS: [unsafe extern fn(); 256] = [
    /* Initial Stack */ _estack,
    /* Reset */         reset_handler,
    /* NMI */           unhandled_interrupt,
    /* Hard Fault */    hard_fault_handler,
    /* ... */
    /* SVC */           cortexm4::svc_handler,
    /* ... */
    /* SysTick */       systick_handler
    /* ... */
];
```

Since `reset_handler` is defined in the board-specific crate, that's where
we'll start executing.  However, the first thing it calls is the chip's
initialization function (e.g. `sam4l::init()`). Chip initialization copies the
data section from flash to RAM, zeroes out the BSS section, and accounts for
any chip errata.

We're already running code written in Rust, but it's fairly C-like Rust:

```rust
pub unsafe fn init() {
    // Relocate data segment.
    let mut pdest = &mut _srelocate as *mut u32;
    let pend = &mut _erelocate as *mut u32;
    let mut psrc = &_etext as *const u32;

    if psrc != pdest {
        while (pdest as *const u32) < pend {
            *pdest = *psrc;
            pdest = pdest.offset(1);
            psrc = psrc.offset(1);
        }
    }

    // Clear the zero segment (BSS)
    let pzero = &_ezero as *const u32;
    pdest = &mut _szero as *mut u32;

    while (pdest as *const u32) < pzero {
        *pdest = 0;
        pdest = pdest.offset(1);
    }
}
```

Next, `reset_handler` chooses a clock source for the CPU and initializes
controllers and drivers. This code starts to look more "Rusty". Isolation units
in the Tock kernel, including drivers and virtualization layers, are called
_capsules_. The [design document](/documentation/design) goes into more detail
about capsules but, importantly for us, capsules often have circular
dependencies on each other, and those are set up in the board initialization.

Since our application uses a hardware alarm controller to sleep between
blinking the LED, let's look specifically at how that stack is setup in the
kernel. The full-stack includes a hardware alarm driver (for the SAM4L's AST
controller), a virtual alarm capsule (which virtualizes the alarm for use by
multiple capsules in the kernel) and a `TimerDriver` that exposes a virtualized
timer to applications through a system call interface:

```rust
let ast = &sam4l::ast::AST;

let mux_alarm = static_init!(
    MuxAlarm<'static, sam4l::ast::Ast>,
    MuxAlarm::new(&sam4l::ast::AST),
    16);
ast.set_client(mux_alarm);

let virtual_alarm1 = static_init!(
    VirtualMuxAlarm<'static, sam4l::ast::Ast>,
    VirtualMuxAlarm::new(mux_alarm),
    24);
let timer = static_init!(
    TimerDriver<'static, VirtualMuxAlarm<'static, sam4l::ast::Ast>>,
    TimerDriver::new(virtual_alarm1, kernel::Container::create()),
    12);
virtual_alarm1.set_client(timer);
```

> The `static_init!` macro creates and initializes variables in static memory,
while getting around some restrictions on static initialization in Rust (e.g.
constructors have to be `const` functions).

Above, we're initializing a new component for each level of the stack in static
memory, passing it a reference to the component below and also setting it as
the client of the same component. This works because all of the components
implement both the `time::Alarm` and `time::Client` traits and because capsules
use immutable references to `self`.

Finally, the `TimerDriver` is stored in the board's struct, which is passed to
the kernel's main function (the scheduler):

```rust
let hail = Hail {
    /* .. */
    timer: timer,
    /* .. */
};

/* ... */

kernel::main(&hail, &mut chip, load_processes(), &hail.ipc);
```

We also passed the result of `load_processes()` to `kernel::main`. This is a
board-specific functions that reads process headers from flash, populates a
list of structures to represent them, and initializes each of their data
segments, global offset tables and stacks into memory.

# The scheduler

`kernel::main` is the scheduler for Tock. It runs in a loop, where each
iteration invokes events on capsules in response to hardware interrupts that
have occurred, runs any processes that are either in the running state or have
pending callbacks, and servicing systems calls from process by, again, invoking
events on the appropriate capsules.

## Capsule scheduler

Capsules invoked in response to either hardware interrupts (e.g. a hardware
timer firing) or system calls.

The chip definition determines which capsules to call in response to interrupts
in the `service_pending_interrupts` method[^service-interrupts]:

```rust
while let Some(interrupt) = iq.dequeue() {
    match interrupt {
        ASTALARM => ast::AST.handle_interrupt(),
        USART2 => usart::USART2.handle_interrupt(),
        /* ... */
    }
}
```

[^service-interrupts]: [`service_pending_interrupts` for SAM4L](https://github.com/helena-project/tock/blob/master/chips/sam4l/src/chip.rs#L70)

The board definition specifies which system call number is associated with a
particular capsule in the `with_driver` method[^with-driver]:

```rust
fn with_driver<F, R>(&mut self, driver_num: usize, f: F) -> R
        where F: FnOnce(Option<&kernel::Driver>) -> R {

        match driver_num {
            0 => f(Some(self.console)),
            /* ... */
            3 => f(Some(self.timer)),
            /* ... */
        }
    }
```

Capsules that service system calls must conform to the `Driver` trait, which
requires them to implement three methods (`allow`, `command`, and `subscribe`)
corresponding to three of the five system calls processes can invoke. The other
two (`memop` and `yield`) are handled directly by the scheduler.

[^with-driver]: [`with_driver` for Hail](https://github.com/helena-project/tock/blob/master/boards/hail/src/main.rs#L93)

## Process scheduler

Processes in Tock run using a callback-based event system. Processes can
request to be notified of certain events by drivers by passing a callback
functions to driver through `subscribe` system calls. The process must later
invoke the `yield` system call to tell the scheduler to schedule its next
pending callback or block the process until one is available.

A callback is just an instruction address in the process and three arguments
(passed via registers). When a process is first created, the kernel enqueues a
default `start` callback pointing to the processes `_start` function which, by
default, is defined in the `libtock` user library that the process links to
statically, and simply sets up a stack and calls `main`.

So, in the case of our blink app, once the chip and board are initialized and
our blink process is loaded, the first thing the scheduler does is invoke the
`start` callback.

# Deconstructing blink's `main` function

Recall our simple blink app:

```c
#define LED 0

int main(void) {
    gpio_enable_output(LED);

    while(1) {
      gpio_toggle(LED);
      delay_ms(500);
    }
}
```

The app is composed of calls to three library functions: `gpio_enable_output`,
`gpio_toggle` and `delay_ms`. The first two are just wrappers around the
`command` system call, which ask the GPIO driver to perform quick, synchronous
operations.

`delay_ms`, on the other hand, is more complex and involves four of the five
system calls. Let's follow `delay_ms` end-to-end to get a picture of the
interaction between processes, capsules, and the hardware works.

```rust
static void delay_cb(int unused0, int unused1, int unused2,
    void* userdata) {
  *((bool*)userdata) = true;
}

void delay_ms(uint32_t ms) {
  bool cond = false;
  
  // subscribe(3, 0, delay_cb, &cond);
  timer_subscribe(delay_cb, &cond);

  // command(3, 0, ms);
  timer_oneshot(ms);

  yield_for(&cond);
}
```

_Note: `timer_subscribe` and `timer_onshot` are simple wrappers around
`subscribe` and `command`. The code above shows the exact calls made in
comments._

At a high level, `delay_ms` sets its callback for the timer driver to
`delay_cb` (which simply sets a condition variable), instructs the timer driver
to start a oneshot timer lasting `ms` milliseconds, then continuously invokes
`yield` until the condition variable is set.

## Subscribe

Subscribe takes a driver number, sub-driver number, a callback function
pointers and an arbitrary user-data value to pass back to the callback as the
last parameter.

When a process calls `subscribe`, a system call instruction is invoked
which traps to the scheduler. The scheduler uses the driver number to figure
out which driver the process wants to forward the subscribe request to. In this
case, Hail maps driver number `3` to the timer driver. The scheduler
wraps the function pointer and user-data into an opaque `Callback` type and
passes it to the timer driver's `subscribe` method.

Because `Callback` is opaque, the timer driver cannot access the function
pointer or user-data directly, protecting the process from a buggy or malicious
driver switching into arbitrary code in the process or corrupting (or leaking)
the user-data value.

In the case of the timer driver, subscribe stores the `Callback` for later in a
process specific data structure[^timer-subscribe]:

```rust
fn subscribe(&self, _: usize, callback: Callback) -> isize {
    self.app_timer
        .enter(callback.app_id(), |td, _allocator| {
            td.callback = Some(callback);
            0
    })
    .unwrap_or(-1)
}
```

[^timer-subscribe]: [Timer driver `subscribe`](https://github.com/helena-project/tock/blob/master/capsules/src/timer.rs#L65)

## Command

Command takes a driver number, sub-driver number and an integer argument. In
the case of `timer_oneshot`, the argument specifies in how many milliseconds
in the future the timer should go off.

Similar to `subscribe`, when a process calls `command`, a system call
instruction is invoked, trapping to the scheduler, which figures out which
driver to forward the `command` to by looking up the driver number.

The scheduler the simply calls the driver's `command` method with the
sub-driver number, argument and the process identifier. The timer driver's
oneshot command stores both the current absolute time and the interval in the
process-specific data structure. If the underlying alarm is already armed it
checks if it needs to reset which is the next time in needs to fire (since this
interval might come sooner than those set previously by other processes).
Alternatively, it simply arms the alarm to fire when the interval expires.

```rust
fn command(&self, cmd: usize, ms: usize, caller_id: AppId) -> isize {
    self.app_timer.enter(caller_id, |td, _alloc| {
        match cmd_type {
            0 /* Oneshot */ => {
                td.t0 = self.alarm.now();
                td.interval = interval;

                // Repeat if cmd_type was 1
                td.repeating = false;
                if self.alarm.is_armed() {
                    self.reset_active_timer();
                    0
                } else {
                    self.alarm.set_alarm(td.t0.wrapping_add(td.interval));
                    0
                }
            },
            /* impls for repeating, stop ... */
            _ => -1
        }
    }).unwrap_or(-3)
}
```

## Yield

Finally, `yield` tells the scheduler to block the process until a callback is
ready to run. When that happens, the scheduler switches to the process and
jumps to the callback's function pointer, passing the user-data captured by the
subscribe call as well as arguments from the driver. The callback runs in a new
stack frame in the process, as though `yield` had called it directly. When it
returns, it returns to the point where `yield` was called.

This allows us to write the `yield_for` function, which continues to yield
until a particular callback has completed:

```c
void yield_for(bool *cond) {
  while(!*cond) {
    yield();  
  }
}
```

# Closing the loop with the hardware

At this point, the timer driver has set up a hardware timer to fire in 500
milliseconds and the blink app is blocked waiting for a callback to come in
from the timer driver. Until there is a hardware event (i.e. the alarm firing),
there is nothing for the system to do, so the scheduler puts the CPU to sleep
at the end of the event loop iteration.

When the alarm fires, the CPU is woken back up and the scheduler continues
where it left off. First, it calls `service_pending_interrupts` which asks the
chip crate to check which hardware interrupt occured (in this case the
`ASTALARM`). Recall that for the SAM4L, that method looks something like this:

```rust
match interrupt {
    /* ... */
    ASTALARM => ast::AST.handle_interrupt(),
    /* ... */
```

The chip sees that the alarm has fired and calls the `ast`'s `handle_interrupt`
method (AST stands for "Asynchronous Timer" and is the name of the SAM4L's
alarm controller).

This method passes marks the interrupt handled and passes the event up to it's
client (the one we set up in the board initialization) through the
`time::Client` trait's `fired` method.

In our case, the direct client is a virtualization layer that allows multiple
capsules to share the same hardware alarm. That, in turn, uses the same trait
to call our timer driver.

The timer driver's `time::Client#fired` method looks through the process
specific data structures to see which process's timers have expired---we know
that there is as least one, but there may be more than one.

The timer driver then schedules each process's `Callback` by calling it's
`schedule` method, which enqueues the `Callback` in the process's callback
queue (part of the process data structure created in `load_processes`).

Finally, the timer driver returns to the virtualization layer, which returns to
the AST capsule, which returns to the scheduler. The scheduler now sees that
the blink app's process has a pending callback. It invokes the callback by
switching to the process and jumping to the callback's function pointer.

In our case, this function is the blink app's `delay_cb`, which simply sets the
condition variable `yield_for` is waiting on. `yield for` can return, and thus
`delay_ms` returns. And we're done!

