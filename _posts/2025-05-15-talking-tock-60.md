---
title: Talking Tock 60
subtitle: x86 Architecture Support
authors: bradjc
---

With [PR #4385](https://github.com/tock/tock/pull/4385) merged, Tock is now
compatible with x86-based platforms! For now, this is only for 32-bit
architectures (e.g., i486). Upstream Tock supports a QEMU version of the Q35
machine type.

Trying It Out
-------------

You can use the Tock port with QEMU following the [instructions here]
(https://github.com/tock/tock/tree/master/boards/qemu_i486_q35). After you
install QEMU, you can:

```
cd tock/boards/qemu_i486_q35
make run
```

to get the kernel booted in QEMU.
