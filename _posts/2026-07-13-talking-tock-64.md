---
title: Talking Tock 64
subtitle: Correctly Initializing Uninit Structs
authors: bradjc
---

Tock needs to allocate data structures in unitialized memory. This is
particularly necessary to create new processes, as Tock dynamically allocates
the process control block (PCB) in process memory. Rust provides the
[`MaybeUninit`](https://doc.rust-lang.org/stable/core/mem/union.MaybeUninit.html) tool to
enable creating types in uninitialized memory. This is a necessary feature,
but when using it for the PCB, construction requires
[field-by-field initialization](https://doc.rust-lang.org/beta/core/mem/union.MaybeUninit.html#initializing-a-struct-field-by-field)
to avoid constructing an entire PCB in memory on the stack before writing it
to the process's allocated memory.

One challenge with doing field-by-field struct initialization is that _every_
field in the struct **must** be initialized before calling
`MaybeUninit::assume_init()`, or the assume init call is unsafe. For small
structs (say, fewer than five fields), it is fairly straightforward
to ensure during code review that all fields have been initialized. However, for something like
Tock's standard PCB, and its ~25 fields, it can be easy to miss an uninitialized field during code review. When a new field is added to the PCB struct, that
field _must_ be initialized as well everywhere the struct is created. Because we've told the compiler the memory is `MaybeUninit`, Rust will not generate an error if a field is not initialized, but the program will be unsound.

To ensure a compiler error is generated if not every field of a struct is
initialized in a `MaybeUninit` use case, we created the `init_uninit_struct!()`
macro. This allows for field-by-field initialization to look like a
normal struct creation. For example, consider this simple process control
block struct:

```rust
struct ProcessControlBlock {
    process_id: usize,
    state: ProcessState,
}
```

When we create the PCB in uninitialized memory like this:

```rust
// Get pointer to where memory has been allocated for this new process.
let process_memory: *mut u8 = allocate_process_memory();
// Cast the pointer to an uninitialized pointer to the PCB.
let process_control_block_memory_location: *mut MaybeUninit<ProcessControlBlock> =
    process_memory.cast();
// Get a reference to the PCB we can initialize.
let process_uninit: &mut MaybeUninit<ProcessControlBlock> =
    unsafe { &mut *process_control_block_memory_location };
```

We can use `init_uninit_struct!()` to populate all fields like this:

```rust
unsafe {
    init_uninit_struct!(process_uninit => ProcessControlBlock {
        process_id: 1,
        state: ProcessState::Unstarted,
    )};
}
```

Notice the syntax looks like a normal struct initialization. However, the
macro is actually creating code like the following, initializing the struct
field-by-field:

```rust
let process_uptr = process_uninit.as_mut_ptr();

unsafe {
    (&raw mut (*process_uptr).process_id).write(1);
    (&raw mut (*process_uptr).state).write(ProcessState::Unstarted);
}
```

The reason this is useful is because the macro is simultaneously creating
a "shadow" construction of the `ProcessControlBlock` struct with normal Rust
syntax. This instantiation of `ProcessControlBlock` is removed by the
compiler before actually creating it in the real program, but, crucially, not
before the compiler pass that verifies all fields in the struct are
initialized. That way, if any fields are not set in the field-by-field
initialization, Rust compilation will fail!

The "shadow" construction looks something like this:

```rust
if false {
    let _: ProcessControlBlock {
        process_id: todo!(),
        state: todo!(),
    };
}
```

This ensures it is both checked for all fields, but doesn't cause any
borrow-checker errors.

After the construction, we can then call assume init knowing that every field
is initialized, and that any fields added in the future will be initialized
as well:

```rust
let process = unsafe { process_uninit.assume_init_mut() };
```

## Macro Implementation

See the
[Tock source code](https://github.com/tock/tock/blob/884171dfdc889a333f31e10b739efcfd95a1d795/kernel/src/utilities/helpers.rs#L163)
for the implementation.
