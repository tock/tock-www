---
title: Including External Libraries in Processes
author: ppannuto
authors: ppannuto
desc: >
  Tock can be a little particular about how things are built. Specifically, it
  requires flags to correctly build position independent code and prefers to
  build for all supported architectures to create TABs. This makes including
  external libraries a bit tricky.
---

Tock can be a little particular about how things are built, specifically Tock
requires flags to correctly build [position independent code][pic] and prefers
to build for all supported architectures to create [TABs][tab].

To make things a little easier, Tock supplies `userland/TockLibrary.mk` that
will do a lot of the heavy lifting for you.

## Building Libraries Dynamically

Sometimes you'll have a library that you're working on that's seeing heavy,
frequent development. In this case, you would likely prefer that this library
is checked and rebuilt as needed every time you compile your application.
`libtock` is set up this way.

First, inside the library folder, you'll need to create a Makefile:

```make
TOCK_USERLAND_BASE_DIR ?= ..
LIBNAME := libtock
$(LIBNAME)_DIR := $(TOCK_USERLAND_BASE_DIR)/$(LIBNAME)

# List all C and Assembly files
$(LIBNAME)_SRCS  := $(wildcard $($(LIBNAME)_DIR)/*.c) $(wildcard $($(LIBNAME)_DIR)/*.s)

include $(TOCK_USERLAND_BASE_DIR)/TockLibrary.mk
```

The required variables are:

  - `TOCK_USERLAND_BASE_DIR` - Path to Tock's `userland/` folder
  - `LIBNAME` - The name for this library
  - `$(LIBNAME)_DIR` - Path to this library
  - `$(LIBNAME)_SRCS` - All of the source files to be built

Then simply `include $(TOCK_USERLAND_BASE_DIR)/TockLibrary.mk` and Tock will
take care of the rest!

In applications that use this library, you simply need to include the library
Makefile:

```make
include $(TOCK_USERLAND_BASE_DIR)/libtock/Makefile
```

With this setup, you can run `make` in the library directory to simply build
the library, or you can run `make` in any application that `include`'s this
library and the library will automatically rebuild as needed.

The `libtock` Makefile is included by the global `AppMakefile.mk` for you, as
every Tock application leverages `libtock`.

## Pre-built / External Libraries

Often you'll want to pull in an external library that's pretty stable, and it's
not worth having everyone build the library. In that case, you can simply point
Tock at the prebuilt archives using the `EXTERN_LIBS` variable. The
[ble-env-sense][ble-app] does this with `libnrfserialization`:

```make
# External libraries used
EXTERN_LIBS += $(TOCK_USERLAND_BASE_DIR)/libnrfserialization
```

In this case, `EXTERN_LIBS` expects a list of _folders_, where each folder
contains a `build` directory, with an archive for all supported `TOCK_ARCHS`,
i.e.:

    $ tree
    ├── build
    │   ├── cortex-m0
    │   │   └── libnrfserialization.a
    │   └── cortex-m4
    │       └── libnrfserialization.a

_Note:_ The library name _must_ match the folder name.

In addition, if there are any header (`.h`) files in the library root, or a
`include/` folder within the library, the Tock build system will automatically
add those to the C/C++ compiler's search path.

If your external library has additional build rules that need to be handled,
the Tock build system will automatically `include` Makefile.app if it is
present.

Finally, to make all this easier, external libraries can use the same
`TockLibrary.mk` as regular libraries. In fact, you can switch between a
pre-built and a runtime built library simply by switching between

```make
# Dynamic build
include $(TOCK_USERLAND_BASE_DIR)/libtock/Makefile
# Use prebuilt archive (do not build)
EXTERN_LIBS += $(TOCK_USERLAND_BASE_DIR)/libtock
```

in your application Makefile (but be sure to commit the built `.a`'s if you
change to the prebuilt approach).

For more details or other customizations, you can read all about the
[Tock Userland Compilation Environment][comp-env].


[pic]: https://github.com/helena-project/tock/blob/master/doc/Compilation.md#position-independent-code
[tab]: https://github.com/helena-project/tock/blob/master/doc/Compilation.md#tock-application-bundle
[ble-app]: https://github.com/helena-project/tock/blob/master/userland/examples/ble-env-sense/Makefile
[comp-env]: https://github.com/helena-project/tock/blob/master/doc/Compilation.md#tock-userland-compilation-environment
