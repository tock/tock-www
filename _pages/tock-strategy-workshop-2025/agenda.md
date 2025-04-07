---
layout: page
title: Tock Strategy Workshop 2025
description: Agenda from Tock Strategy Workshop 2025
permalink: /tock-strategy-workshop-2025/agenda
---

# Tock Strategy Workshop

Date: March 27, 2025
Time:
  - 11:00-15:00 Pacific
  - 13:00-17:00 Central
  - 14:00-18:00 Eastern
  - 20:00-24:00 EEST

Location: Virtual on Zoom

## Agenda

The goal of this workshop is to gather information on and plan for project-wide goals. For each topic, we aim to centralize and synthesize requirements, desires, and constraints. We will aim to conclude with a rough plan for what to work towards, to be refined asynchronously.

Each topic below will take up roughly 45-60 minutes. We'll aim to take breaks in between.

Times below in Pacific time.

### 11:00 - Rust Userland
Lead: Amit
Scribe: Brad

- Presentation (@jrvanwhy): past, current, potential future of libtock-rs
- Use cases:
    - Pluton
    - OxidOS
    - Google(s)
    - zeroRISC
    - Networking
- Technical direction(s)


### 12:00 - Inter Process Communication (IPC)
Lead: Branden
Scribe: Phil

Note from @alevy 
> The design spectrum here are things like whether userspace processes are fate sharing, where there is copying, whether capsules should be able to respond to IPC, etc

**Context**
 - We're going to focus on future designs here, not on what currently exists in Tock. Pretend nothing exists and we were creating something new from scratch: what would it look like?
 - Multiple mechanisms are possible, although it might be better to have one flexible mechanism

**Use cases** (gather ideas)
 - Userland services
     - Networking (Thread and Ethernet)
         - Create an endpoint for each application registered
         - Direct off-board messages to proper application
         - Queue application messages to send off-board
         - Bonus: configuration requests and notifications
         - Registering with service, but not necessarily call/response. Messages either way
     - MCTP with true asynchrony, message passing
     - Nonvolatile memory manager service
     - Large "app library" as a service. RPC style
     - Singleshot use case
     - Client/server oriented. Multiple clients
 - Application coordination
     - Decompose larger project into separated tasks, composed as needed
 - Multi-core systems
     - Tunneling messages between them in a transparent manner

**Design requirements** (apply to use cases)
 - Directing communication
     - Patterns: unicast, multicast, broadcast
         - Applications with multiple services advertised
     - Authentication requirements
         - YES
         - We could implement our own policies if given some details like a TBF header
         - Identifying whether applications are valid users
         - Tying entire request to server ID is valuable
     - Discovery
     - Dealing with application lifetimes (particularly in the shared memory context)
         - Connect with timeout
         - Would like to typically do message passing so messages do get sent
         - Hard references to shared memory might delay application restarting
     - Fate sharing
         - Undesirable if avoidable
         - We could be okay with less graceful recovery (device reboot) if needed
         - Partitioning clients is valuable (if client A crashes, client B talking to same service C is unaffected)
         - Gracefully recover from IPC failures would be great
         - Fail open. Let the system struggle onwards
     - Registration confirmation
     - Reasoning about multiple clients
     - Generic interface for a service, which could be an app or a kernel driver
         - +1
         - Useful for testing too
         - Useful for networking to later move interfaces, but have apps still work
     - RPC requirement
         - RPC always returns a response (acknowledgement, or value)
         - Shared memory needs a return for synchronizing memory access
         - Message passing could be used for RPC anyways, but is it a first-class citizen?
         - RPC protocol may be enforced and we might not have a choice anyways
 - Communication mechanism
     - Message sizes and frequency
     - Performance requirements
         - Streaming data where you control _when_ copying happens
             - Maybe some control over whether it's a weak or storng reference
         - Less overhead the better for networking, but devices are already so weak
     - Types of data (any need other than "array of bytes")
     - Zero copy requirement?
         - Copying would be problematic
         - Need message passing AND shared memory
             - Usually copying, but occasionally sharing for large data
         - Sharing should be a part of the communication semantics
     - Multiple buffers for communication for flexibility
 - Architectural considerations
     - i.e, ARMv8 MPU allows for easier memory sharing
     - Varied alignment requirements, lengths, and number of regions
         - Makes it hard to write applications that work for all of them
         - Page tables, with 4k boundaries
     - Making good use of MPU regions would be great, for multiple services


**Alternative IPC implementation**




### 13:00 - Dynamic Process Loading
Lead: Brad
Scribe: Amit Levy

Major Topics
- Installing new process binaries at runtime
- Running processes from memory with PIC support
- Non-XIP platforms

Questions
- How do we make libtock-rs apps easy to run?
- What changes (if any) do we need in the kernel?
- What types of relocations should we target?


### 14:00 - Testing, reliability, verification
Lead: Amit
Scribe: Branden

* Treadmill status and near-term plan
* Other testing infrastructure
* Verification efforts
* Downstream needs/requirements


---


## Notes

Attendees:
 * Leon Schuermann (Core)
 * Branden Ghena (Core)
 * Amit Levy (Core)
 * Alexandru Radovici (Core & OxidOS)
 * Ryan Torok (zeroRISC)
 * Brad Campbell (Core)
 * Kat Fox (zeroRISC)
 * Bobby Reynolds (Microsoft/Pluton)
 * Hussain Miyaziwala (Microsoft/Pluton)
 * Phil Levis (Core)
 * Johnathan Van Why (Core)
 * Lawrence Esswood (Google)
 * Pat Pannuto (Core)
 * Tyler Potyondy (Network WG)
 * Eric Mugnier (UCSD)
 * Vivien Rindisbacher (UCSD)
 * Eugene Shamis (AMD)
 * Benjamin Prevor

Representation from Tock Core working group, OxidOS Automotive, Microsoft, zeroRISC, and AMD.

### Rust Userland

- libtock-rs pre 2019: Virtually unusable
  - Couldn't access memory
  - Return types very large
  - Not sound
- libtock-rs since 2019: Robust foundation
  - Complete redesign, libtock-rs now sound
  - However, many features and other benefits no longer included

#### Ongoing Projects
- Unit Test Redesign
  - Design example: https://github.com/tock/libtock-rs/blob/master/unittest/src/kernel_data.rs
  - Many drawbacks to current design. Redesign in progress but unfinished.
- Pin-based Allow and Subscribe
  - https://github.com/tock/libtock-rs/issues/494
  - Current allow/subscribe design requires a closure
  - We believe that a sound design based on `Pin` can work
    - Initial attempts increase code size
    - Unclear what the right tradeoff is
    - Maybe we support both the current design and Pin
      - Can libtock-rs libraries be written to support either without duplication
- Other
  - Dynamic memory allocator
  - Integration tests with real hardware and treadmill/hardware-ci
  - Improve type inference in the closure-based API

- async
  - current design is asynchronous, not as powerful as futures in Rust
  - attempted futures implementations had a large increase in code size (30-50%)

#### What are the needs?

**Bobby and Hussain**
- nonvolatile memory store
  -  with wear leveling and encryption
  -  write logic both in Rust and as an app
- many crypto syscalls added in libtock-rs
- using IPC
- app is currently fully synchronous - don't need async APIs
  - no current timeout logic
  - maybe would use in the future?
- Would place more value in soundness guarantees
- Timeouts in libtock-rs
  - Currently issue a request and start a timer, see what happens first
  - Widely used in OpenSK as well
  - maybe libtock-rs could make this easier with a library or abstraction
- code size is a concern, but not top concern compared to soundess and ergonomics/easy of use for developer efficiency
  - 30-50% overhead would be a lot to consider, but we'd at least think about the tradeoff

**Alex**
- customers (or students) switching to Rust
    - they read documentation from rust-embedded and embassy
    - they don't understand why they can't do the same thing
    - they want to use crates.io
        - sure would be nice to be able to use existing libraries from crates.io!
- same async for libtock-rs as with "normal" rust would be very helpful
- number of apps is an issue.
    - want to run 10-15+ apps on armv7
- want to run multiple tasks in "parallel" in a single app using normal rust async primitives
- for education want to run more than 3 apps
- tock is async to the core, however not nicely exposed in libtock-rs
- libtock-c can do async, but it is not easy/nice
    - want node.js post async/await
- potential vision
    - core libtock-rs layer
    - libtock-rs-async layer
    - then rust futures layer
    - key: layers are swappable and reusable
    - key: no code size impact for those who don't want full async

**Lawrence**
- code size pressure very different between chips
    - some 10-20 kB for code, some have MBs
- async would be great when feasible
- an async version with callbacks but using `Pin` might be helpful too
    - nested closures somewhat awkward, particularly when porting existing code

**Networking-WG**
- want to ensure that any new kernel interfaces can be implemented soundly in libtock-rs
    - e.g.: porting the 15.4 driver
- how do we deal with interfaces that help with libtock-c performance but maybe cannot be implemented soundly in libtock-rs

**Ryan**
- one issue: OT hardware not always async when tock expects it
    - had to pass allow-ed buffer deep in the kernel
    - allow-ed buffers might be overlapping or not aligned
- would new libtock-rs APIs (e.g. using pin) help with allow buffer guarantees?
- it would be helpful to have richer types in the kernel related to allow-ed buffers
    - eg alignment


#### Other questions

- how important is code size?
- how important is it to have safe layers (ie can't use `unsafe`)?
    - many things are likely much easier to implement if using unsafe in more layers
    - atomic buffer swapping is helpful for streaming incoming data
        - can't implement in today's libtock-rs
    - embedded rust using unsafe extensively for performance
    - hard to audit if every subsystem must use unsafe
        - auditing a couple uses of unsafe is probably fine
    - votes
        - important = 1
        - fairly important = 1



### Inter Process Communication (IPC)

* Branden: Talking about inter-process communication/IPC. We've had an implementation since the beginning, for a long time, based on shared memory. In the networking working group we've been exploring something different, being able to share buffers in services.

* Branden: Rather than bash on the current design, let's talk about what we'd like a future design to look like. Multiple mechanisms, a flexible mechanism, use cases, requirements.

* Branden: Use cases first, then requirements. First use case from networking is a userland service. E.g., Thread or Ethernet that wants to get information from the kernel, then share this with other applications. Data comes in off board and is distributed to other applications. Applications can share data with the service and it uses it to send data. There's also configuration, etc.

* Branden: other use cases?

* Amit: Kat implemented the IPC PR, so let's hear her thoughts.

* Kate: Use case is networking protocols where multiple applications want to act independently. You want true asynchrony, messages flying back and forth. A closer to a message passing mechanism, rather than subscribing to these callbacks, might be nice. Zero copy buffers are also very good for this kind of stuff, for bigger networking packets certainly.

* Branden: Round 2: does your use case need zero copy?

* Leon: This came up, we have an Ethernet implementation, there's also a memory leak in it. Using Tock's process isolation for dividing up responsibilities, also for security.

* Amit: Are the use cases, Kat and Leon, are they client-server, a service is handing multiple clients, each of which is issuing one request, or more general message passing?

* Leon: For Ethernet, it can be client/server, but not call/response. Need to be able to receive and send.

* Branden: But other applications register first.

* Amit: So it's only important that the clients discover the service.

* Leon: Yes.

* Kate: Use cases I've seen are client/server. There are of course exceptions. There needs to be some kind of undirected mechanism.

* Brad: We have a couple of use cases that have come up. Being able to decompose a larger project into multiple apps, each with their own task, we can then compose them as needed. System call restrictions allow us you bound what each application can do, but they need to share data. Also, if you have a large stack, you can include it in every app, but that's a big code size cost to every app. So being able to break it out into a separate app is useful.

* Lawrence: Client-server, single-shot, is our common use case. Connect, request, get a response, close, is typical.

* Amit: Why close the connection? Is it semantically important?

* Lawrence: In case the other side goes down.

* Hussain: Multiple use cases. All are client-server. All of them are multiple clients using the same service. Shared library over RPC resonates a lot with us. Refactoring high impact code so lots of apps don't have to link it in. We care about creature comforts. Reasoning about multiple clients, synchronization concerns across clients, e.g. buffer management across multiple clients. One of the things that has been hard has been decoupling request/response from buffer sharing. Multiple buffers per client/server connection is important. A data payload here, metadata here, places constraint on client on where they place data. Flexibility gains from multiple buffers. Overall structure works, plus or minus creature comforts and soundness of multiple clients/synchronization.

* Branden: Do all of your use cases look like one service app, with multiple clients talking to it?

* Hussain: Yes.

* Leon: Just to follow up, it sounds like you are using the current interface. One tricky thing is it doesn't copy, but does do memory sharing. It seems hard to have a sound interface that has that property. If we added copying, would the performance impact matter?

* Bobby: Yes, it would be a problem. But not cycles, rather the amount of memory required. Nonvolatile memory storage. There's an in-memory cache of data. We have a service to turn that into a properly managed store. Having systems require us to have copies of the tens of kB of data would be a problem.

* Leon: How about moving memory?

* Bobby: That could work. Adding guardrails, more soundness in the presence of multiple accessors, that would be doable.

* Leon: Issue we have had, current interface requires apps to do copies if you want stable data, due to context switching and preemption.

* Lawrence: We need both message passing and shared memory. 99% of the time message passing, but every now or then we need shared memory for a large payload that won't even fit in memory. So message passing where you can share handles. Either on its own would be insufficient. But message passing has such fault tolerance benefits it's a better mechanism most of the time.

* Branden: Do we have performance targets.

* Ryan: I can imagine streaming data. E.g., a stream of blocks of data, doing transformations. Controlling where copies happen can have large performance implications. Imagine you have a client server interface. Suppose we say default is you have a weak reference, but you can upgrade it to a strong reference, where I have my own copy, do changes in place.

* Branden: Leon, for the network interfaces, what are we thinking in terms of performance.

* Leon: Context switching already has an overhead, weak processors. For 10Mbps or 100Mpbs we can't keep up. Extraneous copies cost, so avoiding them is good. These applications are delay and loss tolerant, though. So our constraints and needs aren't that strict.

* Branden: How about authentication? Do you need to know an app is who they say they are?

* Hussain: Yes.

* Lawrence: We would be happy to be able to look into the TBF header so we can make our own decisions, something like what's the TBF header ID?

* Bobby: In our use case, adding a GUID into the header, lets the server affirmatively know the GUID of the client making the request, we can make a policy around that.

* Amit: So just an identifier, layering stuff on top of that would be OK?

* Lawrence: Yes, we trust the TBF.

* Branden: Do clients need to be able to check the server?

* Bobby: From a threat modeling perspective. Compromised application tries to pretend? Some way to affirmatively tie identifier to service, based on the TBF header.

* Amit: Here's an alternative. Rather than asking to connect to a service based on a GUID or service, you could ask to connect to an interface. You know it'll be interpreted the way you want, but doesn't provide authentication.

* Bobby: Win32 COM to Tock? (laughter)

* Leon: Boot time and crashing, current approach falls down now. What kind of guarantees do you want when you have failures, e.g., an application or service starts after yours.

* Lawrence: We have timeouts. “Not here” versus “not responding” is different.

* Leon: We talked about weak and strong references. If an app holds a strong reference to a buffer from another application, that application crashes, what do you do?

* Lawrence: We'd like to avoid cascading failures, which is why we use message passing. But we are willing to tolerate issues of shared memory, inability to restart in place, because buffers are still being used. Don't see a good way to work around that, without crashing the other application.

* Amit: Do other people feel the same about fate sharing?

* Bobby: Some scenarios where we're OK with less graceful recovery. We can reliability, we like it. Devices have to reboot, that's OK. Partitioning clients is important. Being able to continue when one client crashes is important. But if the IPC service crashes, causing other things to crash is OK, we can find other ways to deal with it.

* Lawrence: Back when we were thinking about access control policies. Disentangling what is an application versus what is a service, is important to us. Whatever mechanism gets designed there, we need to keep these separate, application and service.

* Kat: It would be nice to have something that is fail open. If something does fail, you can continue in a degraded state. If one client goes down, it doesn't force everything to go down.

* Bobby: There are times when a particular service can work better in the kernel, otherwise where it can be better as a service. Different use cases.

* Lawrence: We do have some kernel endpoints to our services, applications are agnostic whether a service is in the kernel or an application, we do this in part because there are times we want the kernel to tunnel to another processor.

* Bobby: Our client side API bindings can do this. Sometimes it goes through IPC. Sometimes a system call tunneled out of the device. Sometimes a locally linked version on the device.

* Amit: Having to decide early on if it's in the kernel or userspace is difficult. E.g. Thread will always be an application, probably, but other IP services can be in the kernel.

* Branden: Let's follow up on RPC. Only Brad mentioned it. Does anyone else need remote function calls, or is it just passing data back and forth.

* Amit: An RPC call is always waiting or a response. Functions return.

* Bobby: Data sharing though a memory buffer or what have you. With shared memory there has to be some kind of a return, just for synchronization.

* Leon: Often you put RPC on top of message passing. So the question is whether want to define an RPC mechanism.

* Lawrence: Our use cases are ad-hoc RPC, but we don't get to control the protocol (enforced on us by existing design) so if Tock had one we couldn't use it.

* Bobby: Zero-copy with shared memory or moved memory. It's hard to imagine how these aren't tied together. The synchronization needs to be tied to the message passing. Completely divorcing the two, sharing is independent of IPC live cycle, I would want to think through how that is achieved, without the kernel being aware of the protocol or the semantics.

* Branden: Remaining things: weird architectural considerations? E.g., ARMv7 vs ARMv8, greatly different MPU.

* Lawrence: We have a wide variety of platforms with huge differences in alignment and size. Writing transportable software that runs them…

* Branden: Just copy! (laughter)

* Bobby: MPU through page tables, the 4kB granularity is very wasteful. It's a big pain point.

* Amit: There are these constraints. It would be nice to not pay the cost of the LCD everywhere, without losing portability.

* Kat: Multiple services, many IPC endpoints, it would be good to use MPU regions well, especially on deeply embedded systems. They can be a limiting resource.

* Branden: One more item: probing Lawrence. Is there anything from your needs we didn't cover? You have the most complex requirements.

* Lawrence: We covered it. Multiple ports, shared memory and message passing. We are using our own layer, existing approach caused us to put too many layers. I can drop the pre-shared memory one, it's pretty mature. I'll look into it. I'm also happy to migrate away from it, as longs as the new version has similar things. We want resilience against failure. Message passing whenever possible.  We have a shared memory mechanism which is aside from our IPC, because of how to hooks into allow(). There is an interface within the kernel, if you send a handle, creating one on the other side too. There's something of a lifetime divorce, sending a message with a handle, destruction isn't an IPC, it's a system call by the process saying I've finished using it.

* Pat: Bobby also dropped that they implemented their own IPC too. Is there something we're missing?

* Bobby: Wouldn't go so far to say we've rolled our own, have just patched the existing one to make it a bit more sound.

* Lawrence: One more about sharing. Our approach has a new grant access mechanism, we've shared the idea but not code. This is PRef, existing in Tock-CHERI. We were using it for a variety of things, turned out to be more flexible, just started using it. It's a user buffer, you check each time you use it.


### Dynamic Process Loading


#### Background

- Very close to having support upstream to be able to take a new binary, load into flash, and start running, without having to disrupt anything else
    - Right now, just for Cortex-M as a jumping off point
- Initial TRD for supporting non-XIP platforms as first class
    - Still relatively slim
- How do we run applications that don't have the kind of PIC support that GCC + thumb currently supports?
    - Issue for RISC-V and also libtock-rs

#### Discussion

- Brad: usability. Just make libtock-rs easier to start with (without having to deal with modifying static locations)
- Lawrence: many use cases
    - Truly static text
    - Both not XIP but also ropi-rwpi (moving text and data independently)
    - And standard PIC (moving both together)
    - Standard PIC not so hard to get working generally for Cortex-M & RISC-V
    - rwpi-ropi in GCC for possible, libtock-rs possible but harder
- Kat:
    - Curious about support for rwpi-ropi in Rust. Specifically use of register-relative relocation doesn't seem to work with Rust core.
    - Lawrence response: yeah, you need to not use those bits of core. _Need_ a dynamic linker though, to e.g. patch up vtables with static pointers.
- Ryan: In an XIP scenario, if we're not concerned about PIC, are there other concerns with dynamic loading
    - Brad: that should work today except the dynamic app loader would need to actually respect those addresses
- Lawrence: a debugging story, for one. A lot of applications will be bundled, but not all.
    - Leon: Are you willing to pre-allocate memory?
    - Lawrence: Yes, happy to overallocate for the debugging scenario
- Kat: Application lifecycle. E.g., a setup phase vs normal running phase.
    - Brad: Separate application code vs. kernel letting the app know which boot number this is?
    - Kat: Either could work
- Ryan: _*Code size*_. Might have more applications than are able to fit on the chip at once.
    - Can get a lot of that without PIC support
    - But PIC would make the memory fragmentation problem go away more.
- Johnathan: Pitched for OpenTitan years ago, tockloader to relocate on-demand. Might be an issue for signature checking.
    - OpenTitan took a different road using ePIC, but that has turned out to be very very complicated
    - Ryan: don't necessarily have to come up with the same infrastructure for signing as OpenTitan at the firmware-level.
- Lawrence: would be unable to get any authentication onto the untrusted core.
- Amit: Any other uses where code size or memory are a use case for dynamic loading?
    - Lawrence: no.
    - Hussain: There is a need to be able to swap applications in and out because of really constrained memory sizes
        - Lawrence: swapping vs. dynamic loading?
        - Hussain: Yes, this is exactly the question internally.
        - Lawerence + Amit + Ryan: relocation is very different from virtual memory, since once an application is running there are static pointers.
- Pat: had a hack at some point that allowed you to do some fully suspending/unsuspending just works out of the box.
    - Lawrence: indeed the arch crates already have code to save process state
- Kat: lifecycles would be useful.
    - Lawrence: also useful for the kernel/capsules to be able to know when a process is, e.g., going to restart/exit
    - Alex: have to implement something similar for low power modes. Need to inform applications that the system needs to go into low power.
- Kat: application has a constant offset between text & data
    - Lawrence: yes, have this implemented for both RISC-V & Cortex-M
    - Brad: what support does this need from the kernel?
    - Lawrence: kernel needs to know where into the allocated region should the copy happen? The rest is in crt0 in userspace
- Pat: "mixed-critically platforms"
    - E.g. signpost, some applications have higher access.
- Amit: how much of a problem would tying data and text together?
    - Lawrence: only one CPU needs them to be separate, mostly colocating is fine
    - Alex: moving them together is a problem in many use cases
    - Johnathan: all platforms I've seen have ~5x flash than RAM, so unaffordable
    - Ryan: yes, more problematic on discrete OpenTitan.
- Brad: why not just have the application do the memcpy of itself itself?
    - Lawrence: how does _that_ code get to run? E.g. even if that code doesn't need relocation, it may be non-executable in place
    - Johnathan: Unless you're using a reloc model that loads into RAM, overwriting flash is a problem.
- Brad: say we added a new TBF header for relocation, would that be helpful?
    - E.g. a common way to express to the kernel that a particular application is compiled in a way that needs a specific kind of relocation
    - Kat: Yes, that would be very useful.
- Amit: (questions)
    - Lawrence: your losing efficiency with ropi-rwpi
    - Kat: Added benefits for deployment of ropi-rwpi might be worth the efficiency overhead.
    - Lawrence: For the time being, ropi-rwpi is hard enough that standard PIC is the way to go.


### Testing, reliability, verification

 - Amit: Lost a couple of industry folks for this (time constraints), but gained some others, and some verification people. Will share notes

Topic List:
* Treadmill status and near-term plan
* Other testing infrastructure
* Verification efforts
* Downstream needs/requirements

#### Treadmill
- Amit: Treadmill overview. Gives access to a shell connected to a target hardware platform. For example, right now has nRF52 dev kits, some STM32 boards, an FPGA that can run OpenTitan. Soon to be expanded to more. Potential use cases include remote development, especially for rare hardware platforms. The primary use case though is for CI tests that run on the hardware itself. For example, checking that a UART interface or a Networking stack still actually works properly. Right now Treadmill has some relatively simple tests we took from userspace that we typically use for releases. It now runs on each PR. Ben has been adding multi-board tests, particularly for networking (BLE, Thread, USB). The near-term plan is to keep going in that direction and expand the deployment with more sites and more boards. Also we want to make it more accessible to write additional tests.
- Leon: The platform we have right now has three layers. The base is the Treadmill platform, which is not Tock specific and not aware of testing. On top of this is a testing framework Ben has been developing which is driving boards, doing communication, asserting things. The level above that is the test strategy layer, which based on events like a PR runs certain tests, possibly based on which code has actually changed. All of these layers need work, but they are independent. So an outcome of this session is todos on all of these layers

#### Other Testing Infrastructure
- Amit: Johnathan mentioned unit testing in libtock-rs
- Amit: And we have some emulated platforms (LiteX) which have some tests that run on it from CI (QEMU is also an option)
- Amit: We also have some unit tests in the kernel itself which run with `cargo test` on a host platform.
- Amit: For the most part, we haven't written a ton of tests though...
- Brad: Yeah. For unit tests that can run on Host in the normal Rust framework, that seems to work pretty well. Utility style code sometimes has those tests and they're easy to run.
- Brad: For more interesting tests that need hardware, capsules will sometimes have tests. With enough use of static variables, they aren't too bad to write. But it's always been tricky to run them, as they just need to go in `main.rs` and get commented in/out. We made duplicate "configuration board" files just for doing testing like this, and there's an nRF example of this.
- Brad: Example of the nRF52840dk configuration board that runs through all of the nrf52840 integration tests: https://github.com/tock/tock/blob/master/boards/configurations/nrf52840dk/nrf52840dk-test-kernel/src/main.rs#L89
- Brad: So, it's possible but you need to be pretty motivated
- Leon: Right now we don't run kernel tests in CI. I couldn't think of a good way to run all these tests in an automated fashion
- Leon: For unit tests, I ran into an issue with trying to write PMP unit tests. They run on the host environment, which doesn't match our target environment. For example, native machine word sizes are different. Which hurts especially code which reasons about pointers and pointer arithmetic
- Brad: For integration tests, we're talking about capsules/tests, right? That should be easy to run in CI. It's just flash the kernel and see what gets printed.
- Leon: So one configuration board for each test?
- Brad: Right now we have one configuration board for all of the tests.
- Amit: For hardware agnostic unit tests, those should work trivially in capsules and the kernel, since both of those are hardware agnostic. And we indeed have unit tests in each of those kinds of crates. It doesn't work in boards, arch, or chips though. There are a bunch of tests existing, but I don't think we write them often. I don't recall the last PR that updated or added a test
- Leon: The same problems exist. We want that capsule to be platform independent, but the code does sometimes make assumptions.
- Amit: We could test that by compiling the test for x86-32bit.
- Leon: I did try that, but I spend a bunch of time fighting it unsuccessfully
- Amit: Now that we've got 64-bit platforms upstream, any assumptions are indeed bugs

#### Verification Efforts
- Vivian: Recently work has been verifying the ARM MPU implementation. There are several layers to that. The model of the hardware. We've also been making sure that the MPU configurations coming out of that code actually enforce process isolation. For example, there was a bug we found where a region sometimes allowed a process to read/write grant memory. A logic bug. Then there's also bringing that back to the process abstraction. The process struct stores pointers and memory layouts. So when the process uses the syscall interface, we should be checking those bounds. So we're verifying that those checks are correct and that the MPU configuration for the process is in agreement with those bounds.
- Vivian: Challenges are interior mutability. Process uses cell and mapcell, which is a challenge for verification working. We have limited ability to reason about what's inside a cell. Mapcell works though. So we shoved things into mapcells instead, to check stuff. But that can propagate all over and get annoying
- Phil: What's challenging about going inside a cell? That's pretty core to Tock design
- Vivian: I'm not 100% sure, but I think there's something about the Rust semantics where we can't reason about what's inside a cell from outside of it. In processStandard, all the breaks are separate cells. But to verify anything interesting, you need an invariant about how those values relate to each other and to the MPU. But in flux we can't reason about what's inside a cell from a global perspective.
- Amit: You've found some pretty subtle bugs so far, which we very problematic! On cortex-m so far. Can you say 1) at a high-level what you found and 2) a characteristic of that code that's making verification useful there
- Vivian: Three types of bugs we've seen. Logic bugs where the intention is there but there's a mistake. That's particularly true with sizes and alignment implementations. So that stuff is just really hard, and Rust isn't helping you get it right. The second class is missed checks. There is stuff in the ARMv6 assembly where code probably got added and went wrong. The last class is integer overflows. That's sort of a missed check. But there are subtle arithmetic bugs that can come up from dependencies of interfaces. An integer overflow in the MPU context could enable all subregions. So these classic bugs turn into safety bugs.
- Amit: Some of the issues are in assembly, which Rust won't catch clearly and is hard to test. Overlapping with that, it's the kind of bug which is hard to test for. Because it's one of those "all the stars align" circumstances. Rather than a positive test that confirms something works normally. And integer overflow is about the contract between hardware and firmware, so the meaning of some value to hardware is different from expected.
- Vivian: On the tests, it be extremely difficult to test some of these, because any single bit could mess things up.
- Tyler: To elaborate a little more, as we've been discussing these bugs. A lot of the MPU bugs have a theme of higher-level invariants that aren't encoded in the type system but we're making assumptions about how these functions are interacting. So it's up to us as the developers to uphold it. For example, we allocate something and spit out numbers, but then assume the MPU is updated to match. So the way they're thinking about how to verify these things could also inform us about how to design our interfaces to avoid these too.
- Leon: How do we make these sustainable. If I have a function in the MPU we have some preconditions and assertions and some annotations to the code, then some automated tool that checks it. So how can we make sure not to break that contract with our changes upstream? And once we have these assertions, how do we make sure the assertions don't _stop_ us from making changes in the future, even if we're not experts?
- Tyler: As in, how do we upstream this?
- Eric: That's a great research question. You could integrate verified code as a crate and at least know which subset of tock is verified. For the whole kernel, that's incredibly difficult. It's a really hard problem.
- Amit: There's a subset that's nontrivial of verifying code for which bugs would lead to memory safety or soundness issues. And that seems important and also ideally confined enough that if you do change that code it should be worth reverifying. It shouldn't change often. There are also certain types of verification which are for important semantic features, but not necessarily features of soundness. For example, the virtual timer. Hopefully a capsule can't use it for memory safety breaking. But it's easy to write buggy virtual timer code that doesn't work as you want it to. That's a different kind of thing that's valuable in a different way. We don't know how to write robust good tests for that.
- Eric: On the timers. Tyler kept complaining about bugs in the timer, and I wanted to try verification on it. I knew it was self-contained. So we made some preliminary efforts and tried to verify the linked list. But it turns out to be very complicated, as it needed a LOT of annotation making the code unreadable. Veris (the tool) needs to keep track of permission of who can modify things. And this state we tried to integrate into the timer, but it required a LOT of effort. So that project ended up sitting for a while. So our goals are first, can we make the linked list readable still with annotations. And second, can we retrofit cell verification into the timer to verify certain qualities of the timer all the way up to the syscall interface.

#### Downstream Needs
- Amit: What's the feeling on what's most valuable to focus on, for various kinds of testing? What's most useful to verify?
- Amit: Secondly, what kinds of tools or frameworks would be useful so that downstream can test and/or verify things more effectively?
- Alex: We need to be able to write unit tests and integration tests simply.
- Amit: Hardware agnostic or for specific hardware?
- Alex: Hardware agnostic right now. We're certifying things out-of-context, so kernel without the chips crate. We need to write a lot of unit tests. Integration tests are more difficult
- Amit: What's missing in terms of infrastructure for that unit testing?
- Alex: A fake kernel. We need to fake grants and kernel and everything. Simulating when it works or doesn't work. And Tock has a lot of tightly coupled stuff
- Amit: So they're focused on one capsule, but not on one function.
- Alex: Function level and component level. But without fakes, you can't test the command function. You need to supply everything. ProcessID and grants. And you want to test for processes recently killed for example. And you have to prove that it works for all the requirements you have. Positive and negative tests for that. Then there are architecture tests, where I do the whole thing, but I need to isolate the kernel bugs from capsule bugs.
- Kat: The testing we want to see would be a capsule-level testing framework. We found that the core kernel is solid and doesn't need to be modified downstream, but capsules change a ton downstream.
- Kat: The other thing that would be really nice is drivers that are getting external inputs. If we could fuzz those, that would be great. Gives us good targets for verification.
- Amit: On the hardware testing side or verification side? Anything there?
- Alex: We will need to do this, but we're not there yet. A client who wants a safety-critical application will have to test with hardware-in-the-loop.
- Leon: We're doing very simple hardware-in-the-loop testing right now. Just GPIO. What will these tests look like?
- Alex: You need to run everything and prove that it works, and prove that if hardware misbehaves things still work.
- Leon: Is that just external components?
- Alex: For example, if the button that starts the car has a mechanical defect, or shorts. The hardware still needs to work properly. So you can do this automatically or even manually for difficult things. But you have to sign off that you actually ran that test, with details of a harness and setup and whether it passed/failed and how. You need to show that you have a preparation for that. For aerospace you have to formally prove. You don't need a certified compiler, but you have to prove that the binary code matches what the source code does. We're still a few years away in the Rust ecosystem. I don't know about security certification, but the requirements seem similar
- Amit: For hardware testing, I'm wondering if writing tests as part of CI or nightly or whatever, if an expansion of the tests or the hardware, would be useful for those goals?
- Alex: The thing that would be most helpful is the framework, not the doing it. Every provider is going to have to run tests and generate documentation on their own. Tock wouldn't want to do this. But the framework that they can use is more useful.
- Leon: So my concerns, are that if there is a way to simultaneously improve the coverage of our tests while improving the framework for your tests, that would be nice. But right now we're just doing whatever we think is easier or best, we don't have the industry experience about exactly how the tests should be performed or what the harnesses should look like
- Alex: I can connect you to people with AUTOSAR experience
- Alex: For us, in the short term, what's most important is testing everything that's not related to hardware. We added some fakes for our own tests, and upstreamed some functions for our testing.
- Kat: I agree with hardware-in-the-loop frameworks. Having stuff upstream is great, but with a framework everyone downstream could contribute tests to upstream. We'd write tests for the parts we're actively using anyways.
- Kat: If it's possible for cargo fuzz integration into that. That would be great for last bug catching before shipping.


