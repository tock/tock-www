---
title: Talking Tock 57
subtitle: Cargo Build System for the Kernel
authors: bradjc
---

With [pull request #4075](https://github.com/tock/tock/pull/4075) merged, Tock
now supports using standard `cargo` commands directly when compiling the kernel
for any Tock board. For example, you can now build the kernel for the nRF52840dk
by simply:

```
$ cd tock/boards/nordic/nrf52840dk
$ cargo build
```

Other commands, such as `cargo test` or `cargo clippy`, as well as plugins, such
as `cargo bloat`, should all work as they would in any Rust project as well.


Supporting Cargo in Tock
------------------------

The main challenge with using `cargo` directly for Tock is the series of
specific build flags we use when running `rustc`. Our Makefile infrastructure
was designed to help set all of those flags. To replace that mechanism, we are
now using `.cargo/config.toml` files for each board. These configuration files
can specify the same flags we previously set in the Makefile.

The primary setting that must be set per-board is the compilation target. As
such, each board's `.cargo/config.toml` file primarily looks like:

```toml
# Licensed under the Apache License, Version 2.0 or the MIT License.
# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright Tock Contributors 2024.

[build]
target = "thumbv7em-none-eabi"
```

The other flags we need (for example setting the relocation model with `-C
relocation-model=static`) we do not want to include in the board's
`.cargo/config.toml` file as we would have to copy them for each board. Instead,
we store additional configuration in the `boards/cargo` directory in a series of
`.toml` files. Each board can then choose which config files are appropriate
(for example, we include some flags on RISC-V boards but not on Cortex-M
boards). We accomplish this using the
[config-include](https://doc.rust-lang.org/cargo/reference/unstable.html#config-include)
feature.

For the nRF52840dk, the full `.cargo/config.toml` file looks like:

```toml
# Licensed under the Apache License, Version 2.0 or the MIT License.
# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright Tock Contributors 2024.

include = [
  "../../../cargo/tock_flags.toml",
  "../../../cargo/unstable_flags.toml",
]

[build]
target = "thumbv7em-none-eabi"

[unstable]
config-include = true
```


Nightly Features
----------------

This approach does use three cargo features which are currently only available
on the nightly version of cargo.

1. `config-include`: This feature allows us to select specific `config.toml`
   files to include on a per-board basis.
2. `trim-paths`: This feature re-writes file paths that are stored in the
   resulting binary to remove host-specific path names and help with
   reproducible builds.
3. `cargo config get`: This feature retrieves the current active configuration
   and all settings.

To compile a board with the stable version of Rust these features have to be
avoided. The `boards/hail` board is an example of compiling on stable Rust.


The Role of Make
----------------

This change does not completely remove Make and Makefiles from building Tock
boards. However, the role of Make has shifted. It now serves two primary goals:

1. Helping with initial setup and ensuring the user has the correct tools
   installed (e.g., rustup, the Rust target, etc.). It also can print helpful
   debugging information.
2. Creating `.bin` files and flashing the board. The Makefile has targets for
   running `objcopy` and `objdump`.

In addition, running `make` still works as before to build the kernel.


Out-of-tree Boards
------------------

This change should help simplify maintaining an out-of-tree Tock board. Rather
than needing a copy of the `Makefile.common` file, boards can now simply point
to the `boards/cargo/*.toml` configuration files and use `cargo build` directly.


Drawbacks to Using Cargo
------------------------

Despite Cargo being the defacto build system for Rust, making this change in
Tock still required two attempts at a PR
([#4054](https://github.com/tock/tock/pull/4054) and
[#4075](https://github.com/tock/tock/pull/4075)) and 182 discussion posts on
Github. The main reason for that is Cargo is still has limitations that make it
not the ideal match for Tock. Ultimately, the benefits outweigh the
disadvantages, however, we still document here the limitations with using Cargo.

1.  Build configuration files must be stored in hidden folders. Cargo requires
    that build configurations files are stored in `.cargo/config.toml` files,
    which mean they are largely hidden from the user. With an embedded operating
    system, we rely on build configuration being set correctly, and this build
    information is just as critical to correctly building the OS as the source
    code is. Because of this, we have resisted using any hidden files in our
    build system. Hidden files are sometimes not searched by default and can be
    excluded from copy operations, making the Tock build system more difficult
    to inspect. Also, having the files be hidden implies they are optional or do
    not need to be modified per-board, which is incorrect.

    We mitigate this issue by making the `.cargo/config.toml` file in each board
    as minimal as possible and putting all of the configuration flags (except
    for setting the `target`) in `.toml` files that are in `boards/cargo`. Each
    board's `config.toml` is mostly just pulling in configuration files which
    are both well documented and not hidden.

2.  Command-line `RUSTFLAGS` replace flags set in Cargo configurations. If the
    user sets `RUSTFLAGS` manually as an environment variable, Cargo will not
    include any of the `rustflags` set in the configuration `.toml` files. That
    this is a replace operation rather than an append operation is often
    surprising to developers more familiar with C- and Make-style build systems
    which typically append flags.

    This behavior is potentially problematic for Tock for two reasons. 1)
    Errantly setting the `RUSTFLAGS` environment variable on the command line
    causes all of Tock's built-in configuration to be ignored. A user may not
    even realize this has happened. Or, a user may be following a guide which
    suggests setting `RUSTFLAGS` not realizing that it disables all other
    `rustflags`. This might create surprising behavior that would be very
    challenging to debug for new users who are not familiar with cargo and
    Tock's build system. 2) It makes it difficult to simply append a new flag
    (say during development) while keeping the existing flags intact.

    To help mitigate these downsides, we add a sentinel flag called
    `cfg_tock_buildflagssentinel` in our many `.toml` file. Then, in `build.rs`
    we check that the flag is in fact set. If it isn't then something is amiss
    about the build flags being used and we print an error to the user. For
    users who want to override the build flags, then can simply set the sentinel
    flag as well.
