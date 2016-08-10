---
title: Dynamic Code Loading on a MCU
authors:
  - brghena
  - alevy
---

In Tock, we use position independent code (PIC) to enable loading
multiple applications. In PIC, all branches and jumps are PC-relative
rather than absolute, allowing code to be placed at any address in
Flash. All references to the data section are indirected through the
Global Offset Table (GOT). Rather than access data at an absolute
address, first the address of the data is loaded from a hard-coded
offset into the GOT, and then the data is accessed at that address. This
allows the OS to simply relocate all addresses in the GOT at load time
based on the actual location of SRAM rather than fixing various
instructions throughout the code. The address of the GOT itself is
stored in a PIC base register which is set by the OS before switching to
application code and is different for each application.

While PIC handles the majority of addressing issues, it does not fix
everything. Data members which are themselves pointers are assigned a
value by the compiler rather than indirecting through the GOT. For
example, take the statement:

```c
  char* str = "Hello";
```

The address of `"Hello"` is stored in the data section (as the value of
`str`) and is not relocated like elements of the GOT. In order to solve
this issue, we collect the addresses of necessary relocations (such as
the address of `"Hello"`) from the ELF and append them to the binary.
Tock can then fix each address at load time based on the actual location
of the application’s text and data segments. Since the application is
already compiled as PIC, remaining fixes will only exist in the data
segment, making the process of applying relocations simple.

Combining these two solutions together, we reach the Tock application
format. Each application binary is compiled as position independent
code, has a relocation section appended to it, and begins with a header
structure containing the size and location of the text, data, GOT, and
relocation segments as well as an entry point for the app. The app is
able to be loaded into any flash and SRAM addresses with the recurring
cost of additional load instructions for the indirection through the GOT
and the one-time cost of several simple data address relocations at
application load time.

When receiving an application binary, Tock assigns space in flash and
SRAM for it, loads the data segment into SRAM, fixes up addresses stored
in the GOT, walks the relocation section fixing up additional items in
the data section, sets the process PC to the entry point of the
application, and enqueues the newly created processes to be run.
Applications can be received through many methods including 802.15.4 and
BLE, but the currently implemented system for Tock receives application
binaries over a UART serial connection.
