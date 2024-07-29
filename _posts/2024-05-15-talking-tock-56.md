---
title: Talking Tock 56
subtitle: New libtock-c Design
authors: bradjc
---

With [pull request #370](https://github.com/tock/libtock-c/pull/370) merged,
`libtock-c` now has a new, consistent format for the library API. This is a
major usability upgrade for writing libtock-c apps.

The major high-level changes are:

- A consistent naming format for functions.
- A clear separation of asynchronous and synchronous library functions.
- Low-level functions for all driver-specific syscalls.
- Namespacing for all functions and types.


Example of the New Format
-------------------------

To illustrate the changes, let's use reading a temperature sensor as an example.

Before, we would roughly have three functions in `libtock/temperature.c`:

```c
// Call the temperature driver read command syscall.
int temperature_read();
// Take a temperature reading with `upcall` called when the measurement is ready.
int temperature_read_async(subscribe_upcall upcall);
// Take a reading synchronously and store in `temperature`.
int temperature_read_sync(uint32_t* temperature);
```

These would be named slightly differently driver-to-driver, and to use the async
version the caller would need to keep track of the upcall arguments.

After the re-write, our interface looks like this:

```c
// In libtock/sensors/syscalls/temperature_syscalls.c:
returncode_t libtock_temperature_command_read_temperature();

// In libtock/sensors/temperature.c:
typedef void (*libtock_temperature_callback)(returncode_t, int);
returncode_t libtock_temperature_read(libtock_temperature_callback cb);

// In libtock-sync/sensors/temperature.c:
returncode_t libtocksync_temperature_read(uint32_t* temperature);
```

There are separate libraries for asynchronous and synchronous APIs, all
functions are namespaced, and the asynchronous functions have specific callbacks
with arguments that are suitable for the specific driver.


Library Design Overview
-----------------------

The [development
guide](https://github.com/tock/libtock-c/blob/master/doc/guide.md) describes the
full format for libtock-c going forward. The major points are:

- All system calls (i.e., command, allow, subscribe) for a particular driver get
  a dedicated function.
- All callbacks use a driver-specific function signature with only relevant
  arguments (instead of the generic `upcall` arguments).
- `libtock` does _not_ call `yield()`. Only `libtock-sync` can use `yield()`.
  This makes separating asynchronous and synchronous code much more
  straightforward.
- `libtock` drivers do not store internal state. All state is maintained by the
  user of the library. `libtock-sync` _does_ store internal state, as it is
  typically necessary to provide a synchronous interface. The exception is the
  `libtock/services` folder. The services in this folder may use internal state
  when necessary. However, `yield()` is still prohibited.
- All functions in `libtock` are prefaced with `libtock_` and all functions in
  `libtock-sync` are prefaced with `libtocksync_`.
