---
title: Talking Tock 53
subtitle: Key-Value Store Updates
authors: bradjc
---

With [TicKV](https://github.com/tock/tock/tree/master/libraries/tickv), Tock
supports running a key-value store on top of flash storage. Recently, the stack
has been updated with a new interface trait and interface for userspace.

The basic `KV` trait looks roughly like the following:

```rust
pub trait KV {
    /// Retrieve a value from the store.
    fn get(&self, key: [u8], value: [u8]) -> Result<(), ([u8], [u8], ErrorCode)>;

    /// Insert a key-value object into the store. Overwrite if needed.
    fn set(&self, key: [u8], value: [u8]) -> Result<(), ([u8], [u8], ErrorCode)>;

    /// Insert a key-value object into the store if it doesn't exist.
    fn add(&self, key: [u8], value: [u8]) -> Result<(), ([u8], [u8], ErrorCode)>;

    /// Modify a key-value object into the store if it already exists.
    fn update(&self, key: [u8], value: [u8]) -> Result<(), ([u8], [u8], ErrorCode)>;

    /// Remove a key-value object from the store.
    fn update(&self, key: [u8]) -> Result<(), ([u8], ErrorCode)>;
}
```

Tock also supports a permissions layer where all KV operations require
permissions to complete. This allows for restricting applications and which KV
objects they can access.

For more information, see [TicKV on Tock Book](https://book.tockos.org/tickv).
