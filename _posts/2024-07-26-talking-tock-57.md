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
