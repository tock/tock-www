---
title: Tock Strategy Workshop
subtitle: Winter 2025
authors: alevy
---

In March 2025, we held a virtual strategy workshop marking about a
halfway point between TockWorld 7 and TockWorld 8. Our goal to discuss
project direction and focus areas for the coming months---where
efforts were best spent and where there might be good opportunities
for collaboration. We had a group of about 20 contributors and
stakeholders in the Tock project, including members of the working
groups and other contributors and stakeholders representing UC San
Diego, Princeton, OxidOS, Microsoft, Google, zeroRISC, and AMD.

There were four topic areas of focus:

- Rust Userland
- Inter-process Communication (IPC)
- Dynamic process loading
- Testing, reliability and verification

Each of the topics included sharing experiences, painpoints, and
downstream work, as well as discussion of future directions and
requirements both shared and unique to different stakeholder. In this
post, we aim to summarize the key takeaways from each topic and what
major projects to undertake in response.

## Rust Userland

@jrvanwhy gave a historical perspective on the current version of
Tock's main Rust userland library, libtock-rs. Earlier versions had
soundness and safety issues that the rearchitected, revised version
fixes. However, it lacks some ergonomic features, primarily support
for async Rust and interoperability with the vast async embedded Rust
ecosystem.

**Major Need**: Async support is critical for adoption across multiple
use cases - education, networking applications, and embedded services.

A key **technical Challenge** with async support is a significant
increase in code size: async "costs" around 30-50% in code size
increase according to some prototypes. This creates a tension between
ergonomics and real resource constraints in many scenarios. Notably,
though, the key drivers for async support are not also the most
resource constrained. Most importantly, they are unlikely to ever have
non-execute-in-place flash, so code size is not as important.

The **proposed solution** is a layered architecture with mostly
unchanged current libtock-rs as a base, an async version layered on
top, and futures on top of that. This should allow applications to opt
into async at the cost of code size overhead, but leave non-async
applications, or non-futures-based applications unscathed.

## Inter-Process Communication Redesign
- **Current State**: Existing shared memory interface is unsound and unergonomic; one contributor has developed a message passing interface that could serve as upstream starting point
- **Core Need**: Hybrid approach supporting both message passing (vast majority of use cases) and shared memory (for large payloads that won't fit in memory)
- **Must-Have Requirements**:
  - Authentication via TBF header identification
  - Zero-copy performance for networking workloads
  - Resilience against cascading failures
- **Nice-to-Have**: Multiple buffer support per connection, graceful failure recovery

## Dynamic Process Loading Progress
- **Current State**: Nearly complete for runtime binary loading without disrupting other processes
- **Immediate Need**: Position Independent Code (PIC) support, particularly for RISC-V and libtock-rs applications
- **Technical Strategy**: Standard PIC is the pragmatic near-term approach, while ROPI-RWPI remains longer-term due to LLVM toolchain limitations and upstream timeline
- **Use Cases**: Memory-constrained devices requiring application swapping, debugging scenarios, reduced memory fragmentation

## Testing & Verification Infrastructure
- **Current Progress**: Treadmill hardware-in-the-loop testing expanding; verification efforts finding real memory safety bugs in MPU implementation
- **Gaps**: Need capsule-level unit testing framework and better integration testing tools
- **Industry Requirements**: Certification needs require comprehensive testing frameworks, not just individual tests

## Calls to Action

### **High Priority**

1. **Complete Dynamic Process Loading**
   - Finalize PIC support for RISC-V platforms
   - Add TBF header support for relocation metadata
   - Target: Standard PIC working across major architectures

2. **IPC Foundation**
   - Evaluate existing message passing implementation as upstream candidate
   - Design hybrid message passing + shared memory architecture
   - Implement TBF header-based authentication
   - Focus on failure isolation between clients

3. **libtock-rs Async Support**
   - Complete Pin-based Allow/Subscribe design
   - Implement layered async architecture allowing opt-in overhead
   - Ensure compatibility with standard Rust async patterns

### **Medium Priority**

4. **Testing Infrastructure**
   - Expand Treadmill hardware targets and test coverage
   - Develop capsule-level unit testing framework with mocking support
   - Integrate automated fuzzing for driver interfaces

5. **libtock-rs Usability**
   - Improve timeout handling abstractions (widely requested)
   - Better crates.io ecosystem compatibility
   - Enhanced developer experience for newcomers

6. **Verification Sustainability**
   - Upstream MPU verification fixes discovered
   - Establish verification workflow for security-critical components
   - Address interior mutability challenges in verification tools

## Conclusion

The workshop revealed strong technical alignment on directions while
highlighting the need to balance competing constraints around
performance, usability, and resource limitations across diverse
deployment scenarios. This attempt at a new discussion proved to be an
incredibly productive and we hope to do more of these in the future!
