---
title: Talking Tock 62
subtitle: Sound static global variables in Tock
authors: bradjc
---

In specific contexts Tock uses global `static mut` variables to share state
among components. The most ubiquitous use of this sharing state between the
main execution context and the `panic!()` handler. When a Tock board panics, it
needs to access resources used by the main kernel, including the list of
processes, a reference to the MCU state, and a tool for formatting process
printing data. Because panic is an exception, we need a global variable
to access those resources.

This has been historically unsound in Tock as we have used `static mut`
variables to share this state. Accessing this state in multiple threads
(i.e., from the main execution and from an interrupt service routine) could
result in mutable aliasing and data races.

To resolve this, we have introduced a new type called `SingleThreadValue` that
guarantees it will only every be accessed by a single thread of execution. With
that guarantee, we can implement the `Sync` trait for the type, allowing it to
be used as a global variable.

```rust
static VAL: SingleThreadValue<GlobalStateForPanics> =
    SingleThreadValue::new(GlobalStateForPanics::new());
```

Accessing `GlobalStateForPanics` can now fail if the accessing thread is
different than the thread that created it. The `.get()` function therefore
returns an option:

```rust
impl SingleThreadValue<T> {
	fn get(&self) -> Option<T>;
}
```

The contained value is not mutable, so for objects that need to be modified the
contained value should be in a cell type, such as a `MapCell`.

```rust
static VAL: SingleThreadValue<MapCell<Resource>> = SingleThreadValue::new(MapCell::new(resource));
```

And then to store a value:

```rust
VAL.get().map(|val| {
	val.put(my_resource);
});
```


`SingleThreadValue` Internals
-----------------------------

To provide its guarantee that the value contained by `SingleThreadValue`
is only ever accessed from a single thread, initializing a `SingleThreadValue`
is a two step process:

1. `SingleThreadValue::new()` creates a new instance of `SingleThreadValue`.
   This instance is not active because it is not bound to a thread. Any attempts
   to use the contained value will fail.

2. `SingleThreadValue::bind_to_thread()` binds the value to the thread that
   called `bind_to_thread()`. This binding means that only this thread can
   access the contained value. Any attempt to access the value from a different
   thread will fail.

After these two steps the value can be soundly used as a global value by the
thread that bound it.

Ensuring `bind_to_thread()` is Safe
-----------------------------------

After a `SingleThreadValue` is bound, accessing it is safe. However, two threads
could potentially attempt to bind the value at the same time. To ensure this
happens safely, we use atomic instructions to ensure only one thread can bind
the value.

However, not all platforms provide suitable atomic instructions. For these
platforms, we provide `bind_to_thread_unsafe()` which is an `unsafe` function
as the caller has to ensure that it is not possible for this to be called
simultaneously from multiple threads. Boards can ensure this by only calling it
from their `main()` function and never from an interrupt context.
