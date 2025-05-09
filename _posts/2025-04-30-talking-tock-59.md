---
title: Talking Tock 59
subtitle: Runtime process loading support
authors: bradjc
---

With [PR #3941](https://github.com/tock/tock/pull/3941) merged, the Tock kernel
now supports dynamically loading userspace apps at runtime. New apps can be
installed on a board without restarting Tock or affecting any existing
applications.

Loading new applications requires a privileged userspace loading application
that is responsible for fetching the new application (in [TBF format]
(https://book.tockos.org/doc/tock_binary_format)), sending it to the kernel to
be stored in flash, and then asking the kernel to execute the new application.
Once stored on the board, the application is loaded using the same process and
policies as all applications that were installed when the kernel originally
booted.

High-Level Architecture
-----------------------

The loading application runs in userspace and uses a system call interface to
send new applications to the kernel. A capsule provides the system call
interface and a kernel capsule (`DynamicStore`) saves the application to the
internal nonvolatile storage while ensuring that the storing the application to
flash is done correctly and safely. The `DynamicLoad` capsule is responsible
for loading the app to a running process, subject to any policies the kernel
may have for starting new processes.

```text
┌────────────────────────────────────────────────────┐
│                                                    │
│             Userspace Application                  │
│                                                    │
└────────────────────────────────────────────────────┘
─────────────────Syscall 0x10001──────────────────────
┌────────────────────────────────────────────────────┐
│                                                    │ Conventional
│               AppLoader Capsule                    │ Capsule
│                                                    │
└────────────────────────────────────────────────────┘
 trait DynamicBinaryStore    trait DynamicProcessLoad
┌────────────────────────┐  ┌────────────────────────┐
│                        │  │                        │ Kernel
│     DynamicStore       │  │      DynamicLoad       │ Capsules
│                        │  │                        │
└────────────────────────┘  └────────────────────────┘
```

Limitations
-----------

Currently the dynamic loader is only implemented for Cortex-M platforms that
have internal executable flash and use the standard TBF layout for applications
in flash. This implementation detail is based on how applications must be
stored for MPU alignment restrictions.

However, the `DynamicBinaryStore` interface is designed to be more general, and
a new implementation could support different underlying storage platforms and
MPU restrictions while keeping the same architecture.
