---
title: Talking Tock 65
subtitle: Unsafe Documentation in the Core Tock Kernel
authors: bradjc
---

Tock's [core kernel crate](https://github.com/tock/tock/tree/master/kernel)
now enforces two [Clippy](https://github.com/rust-lang/rust-clippy) lints
related to `unsafe` code:

```
#![deny(clippy::missing_safety_doc)]
#![deny(clippy::undocumented_unsafe_blocks)]
```

Denying these lints is a major step forward towards better `unsafe` code
handling in Tock.

## `clippy::missing_safety_doc`

This [lint](https://rust-lang.github.io/rust-clippy/master/index.html#missing_safety_doc)
enforces that all functions have a `# Safety` section documenting
the caller's responsibilities to ensure that calling the function does
not result in undefined behavior.

## `clippy::undocumented_unsafe_blocks`

This [lint](https://rust-lang.github.io/rust-clippy/master/index.html#undocumented_unsafe_blocks)
enforces that all uses of `unsafe` have a comment starting with `SAFETY:` to document
how the particular use of `unsafe` meets all requirements of using the unsafe operation
without encountering undefined behavior.

## Experience Updating the Crate

Enabling these lints took several months. For each use of the `unsafe` 
keyword, addressing the comments requires:

1. Determining if the `unsafe` use is correct.
2. If so, determining what the correct documentation is.

### Determining if the `unsafe` use is correct

Determining if any `unsafe` use is correct includes some subtle complexity.
There are three types of `unsafe`, and determining which category each
`unsafe` falls into when there is no documentation is difficult. The three
categories are:

1. This is a correct, valid, and necessary use of `unsafe`. If this is code
   that _uses_ `unsafe`, the operation is required to implement Tock
   functionality. If this is code that _provides_ an `unsafe` interface, the
   interface does have Rust safety implications and is necessary to provide.
2. This `unsafe` can be implemented safely. The code uses `unsafe`, but could
   be re-written to avoid using an `unsafe` interface.
3. This `unsafe` is not relevant to Rust safety, and should not be marked
   `unsafe`. A function was marked `unsafe` but there are no Rust safety or
   soundness concerns with calling the function.

Having to think through and write out safety documentation is critical to
separating these three categories. However, over time, Tock accumulated
enough `unsafe` usage that it became difficult to tell these categories
apart. This requires multiple experienced Tock developers to reason about 1)
why the `unsafe` is there in the first place, and 2) if it should remain.

Category (1) is the expected case when thinking about `unsafe` in Rust. This
is the code that benefits from the two Clippy lints as documentation makes it
clear how to use the code safely or why the `unsafe` use is safe. Determining
that `unsafe` code is truly required, however, requires understanding Rust's
requirements and Tock's objectives, making this difficult to reason about.

Category (2) is unexpected, as Rust should seemingly discourage `unsafe` use.
However, without strong review protocols (and these clippy lints enforced),
it is fairly easy to unnecessarily use an `unsafe` interface when a safe one
would have been sufficient. However, it is not always obvious when there is a
safe alternative. The overhead of having to write a safety comment is one
incentive to find a safe alternative.

Category (3) is particularly challenging, as OS code can often 
"feel" unsafe. Certain functions might seem risky to use (e.g., creating a
struct to manage interrupts), or should only be used in certain cases
(e.g., printing CPU state). Marking them as `unsafe` is a catch-all way to
signal this riskiness. However, this muddles the meaning of `unsafe`, making
it very difficult to separate code which has actual undefined behavior
implications from code that is only intended for specific uses.
Retroactively determining that the code is not relevant for Rust safety is
challenging as in an OS there can be subtle implications for low-level
functions.

After determining the category the correct remedy becomes clear. In many cases
we removed the `unsafe` keyword from functions that were actually in
Category (3). Some of these functions actually needed to require a
[Capability](https://docs.tockos.org/kernel/capabilities/) instead of being
marked `unsafe`. Others were intended for only a specific context
(e.g., during a system panic), and we added a required argument to indicate
that restriction (e.g., adding `&core::panic::PanicInfo` as an argument).

`unsafe` uses determined to be in Category (2) are the most satisfying as the
`unsafe` can be removed.

Finally, addressing `unsafe` use in Category (1) requires writing the correct
safety documentation.

### Determining what the correct documentation is

This can be unexpectedly difficult because of the intricacies of soundness and
safety in Rust. Likely the most straightforward case is when the unsafe use
is limited to `unsafe` Rust standard library APIs, which have clear
documented requirements that can be checked or reiterated.

The more difficult case is when the safety requirements relate to larger
properties of how Tock as an operating system functions, and how that
operation can affect things like memory safety. For example, when Tock runs a
userspace process it must still ensure that memory owned by Rust continues to
meet the memory guarantees Rust requires. Ensuring this is a higher-level
safety concern not directly related to specific standard library APIs.

### Example of Detected Issues

Here are some examples of `unsafe` use in the three categories
that had to be handled to enable these lints.

- **Category (1)**: Documenting valid `unsafe` uses:
  - [PR #5145](https://github.com/tock/tock/pull/5145): Our `CapabilityPtr`
    has safety requirements that are now expressed.
  - [PR #5207](https://github.com/tock/tock/pull/5207): Creating a new process
    has requirements on the memory allocated for the process.
- **Category (2)**: Fixing unnecessary `unsafe` uses:
  - [PR #5044](https://github.com/tock/tock/pull/5044): instead of the unsafe
    `new_unchecked()` API, because the function returns a `Result` anyway,
    using `new()` is fine.
  - [PR #5146](https://github.com/tock/tock/pull/5146): an unsafe `from_raw_parts()`
    call can be replaced with a normal Rust slice operation.
- **Category (3)**: Removing `unsafe` from safe code:
  - [PR #4993](https://github.com/tock/tock/pull/4993):
    `with_interrupts_disabled()` is safe. While running code with interrupts disabled
    could be risky, it does not have any memory safety or soundness concerns.
  - [PR #4996](https://github.com/tock/tock/pull/4996):
    `Scheduler::execute_kernel_work()` is safe. While the scheduler is core to an OS,
    and choosing what to run when can have system implications, running kernel
    work has no inherent Rust safety or soundness concerns.

Additionally, we found cases where Tock was unsound because of improper
`unsafe` use. In these cases, requiring the documentation makes the soundness
issue apparent because it becomes clear that explaining how the use of the
`unsafe` operation meets the requirements is impossible.

- [PR #5142](https://github.com/tock/tock/pull/5142): The `CapabilityPtr` constructor
  requires that the pointer is valid to access in a specific range. However, in one memop
  operation the range we provided was not safely accessible.
- [PR #4793](https://github.com/tock/tock/pull/4793) and
  [PR #4798](https://github.com/tock/tock/pull/4798): when creating a new process, we were
  instantiating structs in uninitialized memory without marking them as `MaybeUninit`.

## Lessons Learned from Enabling these Lints

Having to articulate the safety requirements or why using an `unsafe` API is
safe forces reasoning about whether it actually _is_ safe. This reduces
unnecessary `unsafe` usage.

In hindsight, we should have started the project with these lints enabled
(or, well, enforced them manually ourselves before the lints were added).
Fixing them after the fact is much more difficult as the context and thought
process from the when the code was written is difficult to recreate.

This further reinforces a challenge with using Rust: the compiler only
provides a single way to restrict code, the `unsafe` keyword. However, Tock
often wants to restrict code in a multitude of ways, not just with respect to
Rust memory safety. Re-using `unsafe` for multiple purposes is wrong, and
Tock should continue to avoid doing this. Adding other restriction
mechanisms, like Capabilities and strict crate-scoping in Cargo, are much
better to address the other times when code should be restricted. Muddling
multiple issues with a single keyword results in mistakes, as it isn't clear
from reading the code _which_ use of "`unsafe`" a particular instance is:
does this have real soundness concerns or is this API just limited use? And
if it is limited, why?

Writing `unsafe` documentation is a balancing act. It must be clear and
sufficient. However, overly verbose documentation is burdensome to a future
reader who needs to understand it. Similarly, documenting an `unsafe`
requires addressing all `unsafe` APIs within the block, which Rust allows to
be arbitrarily large (up to containing an entire function definition). To
help with guidance on writing this documentation, we have created some
[documentation on how to write `unsafe` comments](https://github.com/tock/tock/blob/master/doc/CodeReview.md#unsafe-code)
in Tock.

## Next Steps

The kernel crate is the first step, but ultimately Tock must enable these
Clippy lints for the entire code base. This is challenging as understanding,
addressing, and documenting/removing `unsafe` code, once it is in the code
base, is extremely difficult.

One tool that would assist is a tool that can automatically recognize all of
the safety requirements needed for any particular `unsafe` code block. It is
not always obvious to someone not intimately familiar with Rust safety and
the standard library exactly which operations are in fact `unsafe`.
