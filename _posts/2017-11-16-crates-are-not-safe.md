---
title: Crates.io Ecosystem Not Ready for Embedded Rust
authors: bradjc
---

As both Tock and the Rust ecosystem grow, we have been looking into using
community-provided crates on [crates.io](https://crates.io) to allow us to add
features to Tock. For example, we are exploring using the
[hmac](https://www.crates.io/crates/hmac) crate to support one of the networking
protocols we are adding. While this seems promising, we are running into two
major problems that are preventing us from using crates.io: `unsafe` and
`std::`.

## Crates are Mostly Unsafe

Tock's kernel is designed to be split into two parts: a minimal but trusted core
kernel and a much larger set of untrusted "capsules". The core kernel handles
loading applications and controlling memory-mapped IO registers, and as such
requires using `unsafe` code. The capsules, however, implement chip drivers and
other utilities, and are strictly bound by the Rust typesystem (i.e. no
`unsafe`). This divide allows us to maximize the safety guarantees of Rust while
still making a kernel possible.

This restriction on capsules has so far made it very difficult to use
community-developed crates. Following up on @joshtriplett's [analysis of
crates.io](https://twitter.com/josh_triplett/status/849089108727222275), we
surveyed all of the crates on crates.io and found that 34% (4216/12360) of the
crates use an `unsafe` block at least once. Of crates that have been downloaded
10k times or more, 55% (522/944) use `unsafe`. While these ratios are not
promising, it may be possible to work around the unsafe crates. The problem gets
worse, however, when we consider dependencies. Even if a crate itself does not
use `unsafe`, if one of its dependencies does, we still cannot use it. After
tracking required dependencies, 77% (9452/12360) of crates are unsafe (the
number rises to 78% (9624/12360) if optional dependencies are included). This
means that most of the 12,000-odd crates on crates.io are unsafe!

In Tock we mark the capsules crate with `#![forbid(unsafe_code)]` to ensure that
no `unsafe` code can creep in. To see if others are doing this as well, we also
scanned crates.io for the use of that flag. We found that only 0.2% (21/12360)
of crates explicitly disallow unsafe code. Because there is no way to use cargo
or the compiler to enforce that dependencies are safe (although we floated the
[idea](https://internals.rust-lang.org/t/pre-rfc-cargo-safety-rails/5535)), we
checked to see if any of those explicitly-safe crates have unsafe dependencies.
We found that all 21 crates have dependencies that use `unsafe`, making the
`#![forbid(unsafe_code)]` flag a bit misleading.

Of course, it is entirely possible that all uses of `unsafe` in crates.io are
valid, necessary, and actually safe. But validating this, particularly as crates
are updated, for all dependencies would be a significant challenge. It seems
that the Rust ecosystem needs a better mechanism for helping developers ensure
that the code they depend on cannot violate type safety.

## Usage of the Standard Library is Pervasive

The other challenge for Tock, as an embedded operating system, is the prevalent
use of the standard library on crates.io. Running on bare-metal and without a heap, Tock cannot use
`std::` and only has access to the libraries provided by `core::`. Any
dependency we would want to use for Tock needs to include `#![no_std]` so that
the compiler does not try to include the standard library. Again we surveyed all
of the crates on crates.io and found that 93% (11488/12360) of crates use the
standard library (i.e. do not have `#![no_std]`). When considering only crates
with 10k or more downloads, the ratio does not change (882/944). However, when
including required dependencies, the number increases to 97% (12023/12360).
This makes using any crates from crates.io on an embedded, memory-constrained platform nearly
impossible.

Because many of the standard library modules simply re-export from `core::`,
many of these crates actually use functionality that does not require `std::`.
These crates could be updated to not require `std`, but there does seem to be a sense that using `#![no_std]` is
[harmful](https://stackoverflow.com/questions/35951024/stdopsadd-or-coreopsadd#comment59560275_35951141)
as it makes it difficult for the crate to use non-core standard library features
in the future.

Cargo or the compiler could really help here. Since many features of the
standard library are simply from the `core::` crate, the compiler should be able
to make a transparent mapping. This would continue to make it easy for
developers to create libraries (they would not have to worry about core vs.
std), while also supporting more crates on embedded platforms.

## Are There Any Crates Tock Can Use?

From our analysis, we found that there are 109 crates on crates.io that do not
use `unsafe`, declare `#![no_std]`, and only use dependencies with the same
properties. Again looking at more popular crates with 10k or more downloads,
there are only 13 crates that qualify.

Currently, our approach is to avoid using any external crates. To continue to
provide the guarantee that capsules can contain untrusted code we need some
mechanism to ensure that capsule dependencies do not use `unsafe`, and it seems
that it is [contentious](https://internals.rust-lang.org/t/pre-rfc-cargo-safety-rails/5535) to
whether that type of feature belongs in the supported tools.
Even with that feature, the use of
`unsafe` appears to be too prevalent to make using crates.io feasible for Tock.
Of course, simply avoiding `unsafe` does not guarantee perfect code, but as we
noted in that Pre-RFC:

> While it's of course true that soundness/type violations are not the only
> source of bugs, but a caller can guarantee very strong properties about
> isolation if they know the callee cannot violate type safety (given the right
> software architecture of course).

It seems that as the community grows and the number of crates on crates.io
increases, Rust needs new or better mechanisms to ensure that the type-safety
promises made by the language actually hold in real-world code.
