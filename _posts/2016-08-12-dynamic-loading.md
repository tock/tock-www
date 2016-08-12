---
title: Dynamic Code Loading on a MCU
authors:
  - brghena
  - alevy
desc:
  One key feature of Tock is the ability to load and run multiple applications
  simultaneously. Unfortunately, in the world of embedded systems virtual
  memory is not available. In Tock, we use an underappreciated variant of
  position independent code (PIC) to enable loading multiple applications
  without knowing their locations at compile time.
---

One key feature of Tock is the ability to load and run multiple applications
simultaneously. In a modern computer, the OS uses the Memory Management Unit
(MMU) to provide a virtual address space for each process. The code for each
process is written assuming that it is the only code in the world and that it
can place memory at any address it pleases. The MMU handles translating these
virtual addresses into a physical address in real memory, which is shared
between all processes. Unfortunately, in the world of embedded systems MMUs are
not available. Processors like the ARM Cortex-M series omit them since they are
power and area-hungry.

A common approach to handle this issue is to assign addresses to applications
at compile-time. For example, Application A can be placed at address 0x21000
and Application B can be placed at address 0x22000. This runs into problems
when Application A grows in size in the future. Moreover, with Tock we want to
be able to handle dynamically adding, updating, and removing applications at
run time. Assigning each an address in advance simply isn't possible.

In Tock, we use position independent code (PIC) [^1] to enable loading
multiple applications. In PIC, all branches and jumps are PC-relative
rather than absolute, allowing code to be placed at any address.
All references to the data section are indirected through the
Global Offset Table (GOT) [^2]. Rather than access data at an absolute
address, first the address of the data is loaded from a hard-coded
offset into the GOT, and then the data is accessed at that address. This
allows the OS to simply relocate all addresses in the GOT at load time
based on the actual location of SRAM rather than fixing various
instructions throughout the code. The address of the GOT itself is
stored in a PIC base register which is set by the OS before switching to
application code and is different for each application.
The ARM instruction set is optimized for PIC operation, allowing most code to
execute with little to no cost in number of instructions.

While PIC handles the majority of addressing issues, it does not fix
everything. Data members which are themselves pointers are assigned a
value by the compiler rather than indirecting through the GOT. For
example, take the statement:

```c
  const char* str = "Hello";
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
code [^3], has a relocation section appended to it [^4], and begins with a header
structure containing the size and location of the text, data, GOT, and
relocation segments as well as an entry point for the app [^5]. The app is
able to be loaded into any flash and SRAM addresses with no control-flow costs,
the recurring cost of additional load instructions when indirecting data
accesses through the GOT, and the one-time cost of several simple data address
relocations at application load time.

When receiving an application binary, Tock assigns space in flash and
SRAM for it, loads the data segment into SRAM, fixes up addresses stored
in the GOT [^6], walks the relocation section fixing up additional items in
the data section [^7], sets the process PC to the entry point of the
application, and enqueues the newly created processes to be run.
Applications can be received through many methods including wireless uploads
over protocols such as IEEE 802.15.4 and Bluetooth Low Energy,
but the currently implemented system for Tock receives application
binaries over a UART serial connection.

### Drawbacks

The main issue with this loading strategy is that it is not currently possible
for applications compiled with LLVM. LLVM does not support a dynamic PIC addressing scheme
like GCC's base-register. In many cases, encoding the location of the GOT in
the text segment works just fine, since it can always be when the code is
loaded into RAM. However, Tock executes applications directly from flash
where it is not practical to rewrite pointer dynamically.

A patch [^8] to add a base-register PIC strategy was sent to LLVM a while back
but it was never merged. Ironically, this means that although the Tock kernel
is written in Rust, for now it isn't possible to write applications in Rust.

### References

[^1]: [Position Independent Code (PIC) in shared libraries](http://eli.thegreenplace.net/2011/11/03/position-independent-code-pic-in-shared-libraries)

[^2]: [GOT in Tock Applications - August 2016](https://github.com/helena-project/tock/blob/a68d5a16b9567ba47681bba678f49ad82f4ff98e/apps/blink/loader.ld#L26)

[^3]: [GCC Compiler Flags for Tock Applications - August 2016](https://github.com/helena-project/tock/blob/be050f9ed1fdfe7cf77af06d397980925f6fbe9d/apps/Makefile.Common.mk#L22)

[^4]: [ELF to Tock Binary - August 2016](https://github.com/helena-project/tock/blob/a68d5a16b9567ba47681bba678f49ad82f4ff98e/tools/elf2tbf/src/main.rs#L86)

[^5]: [Tock Application Header - August 2016](https://github.com/helena-project/tock/blob/a68d5a16b9567ba47681bba678f49ad82f4ff98e/tools/elf2tbf/src/main.rs#L17)

[^6]: [Tock GOT Fixup - August 2016](https://github.com/helena-project/tock/blob/a68d5a16b9567ba47681bba678f49ad82f4ff98e/src/main/process.rs#L368)

[^7]: [Tock Relocations Fixup - August 2016](https://github.com/helena-project/tock/blob/a68d5a16b9567ba47681bba678f49ad82f4ff98e/src/main/process.rs#L378)

[^8]: [\[llvm-dev\]\[RFC\]\[ARM\] Add support for embedded position-independent code (ROPI/RWPI)](http://lists.llvm.org/pipermail/llvm-dev/2015-December/093022.html)
