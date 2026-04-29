---
title: Talking Tock 63
subtitle: Safe DMA in Tock
authors: bradjc
---

[Direct Memory Access](https://en.wikipedia.org/wiki/Direct_memory_access)
(DMA) is a critical feature for increasing performance and reducing energy
consumption in embedded contexts. However, from a memory-safety perspective,
allowing a hardware peripheral to modify memory in a way that the compiler
cannot reason about requires special care to ensure the soundness
requirements expected by the compiler are maintained. 

With [#4702](https://github.com/tock/tock/pull/4702) merged, Tock provides two
core mechanisms, a trait called `DmaFence`, and a struct called `DmaSlice`,
to enable safely using DMA peripherals with Rust code. Together, these
abstractions effectively allow DMA drivers to "hand over" memory to the DMA
hardware, and then "retrieve" that memory when the DMA operation is finished.
These operations then ensure that Rust does not make any assumptions about
the contents of that memory when it effectively "owned" by the DMA hardware.

Platforms that support DMA must implement `DmaFence` which uses
hardware-specific operations to ensure that memory writes are visible to DMA
(during the "hand over" phase) and then back to Rust (during the "retrieve"
phase).

```rust
/// `DmaFence` enables releasing memory from Rust to the DMA hardware,
/// and then re-acquiring the memory.
/// 
/// Trait is unsafe because upper-level soundness guarantees must
/// assume the trait is implemented correctly for a specific hardware
/// architecture.
pub unsafe trait DmaFence {
	/// Release memory from any assumptions the Rust compiler may
	/// make about the memory.
	///
	/// Must ensure that all writes to `buf` have finished and will
	/// be visible to the DMA hardware.
    fn release<T>(self, buf: *mut [T]);

    /// Retrieve the memory from the DMA hardware.
    ///
    /// Must ensure all DMA writes have finished and are visible
    /// to Rust.
    fn acquire<T>(self, buf: *mut [T]);
}
```

Then peripherals that use DMA must use a `DmaSlice` variant to handle slices
that are being used by DMA. This is an example of creating a DMA manager that
correctly uses `DmaSlice` (specifically `DmaSubSliceMut`) to hold the buffer
while the DMA is active, and uses the `DmaFence` to soundly hand over and
retrieve memory to/from the DMA hardware.

```rust
struct PeripheralDma {
    /// Holding place for the DMA buffer while DMA in progress.
    dma_buf: MapCell<DmaSubSliceMut<'static, u8>>,
}

impl PeripheralDma {
    pub fn start_dma(&self, buf: SubSliceMut<'static, u8>) -> Result<(), ()> {
        if self.dma_pending() { return Err(()); }

        // To create a DmaFence we must trust the implementation.
        //
        // # Safety
        //
        // The architecture-provided version is correct for the nRF52.
        let fence = unsafe { cortexm4f::dma_fence::CortexMDmaFence::new() };

        // Create DmaSlice for the TX buffer. This ensures that we can soundly
        // share it with the DMA hardware.
        let dma_slice = DmaSubSliceMut::new_static(buf, fence);

        // Provide the DmaSlice buffer to the hardware DMA engine.
        dma.set_buffer(tx_dma_slice);

        // Save the DmaSlice while the DMA operation executes.
        //
        // Nothing is allowed to use this buffer while the DMA hardware is
        // active.
        self.dma_buf.replace(tx_dma_slice);

        // Start the TX DMA operation
        dma.start();

        Ok(())
    }

    pub fn stop_dma(&self) -> Option<SubSliceMut<'static, u8>> {
        // End the DMA operation so it is safe to retrieve the buffer.
        dma.stop();

        self.tx_dma_buf.take().map(|dma_slice| {
            // To create a DmaFence we must trust the implementation.
            //
            // # Safety
            //
            // The architecture-provided version is correct for the nRF52.
            let fence = unsafe { cortexm4f::dma_fence::CortexMDmaFence::new() };

            // Retrieve the underlying buffer now that we have finished the DMA
            // operation.
            //
            // # Safety
            //
            // We must ensure that the DMA hardware no longer has any access to
            // this buffer. We ensure that by calling `dma.stop()` before taking
            // the dma slice back.
            let buf = unsafe { dma_slice.take(fence) };

            buf
        })
    }

    pub fn dma_pending(&self) -> bool {
        self.dma_buf.is_some()
    }
}
```
