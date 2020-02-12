---
title: "OpenSK: Built by Google, Powered by Tock"
subtitle: Announcing the release of OpenSK by Google!
author: ppannuto
authors: ppannuto
---

[Google has released OpenSK][gblog], an open-source implementation for security
keys. [OpenSK is an application][opensk-gh], designed to run on top of Tock.
Today, it targets the Nordic nrf52 chip dongle.

We are excited to see real-world, security-conscious applications deployed on
Tock. We're also excited for future efforts in this space, in particular the
emerging [Tock on OpenTitan][tock-ot] effort. If you are interested in getting
involved, get in touch with the [emerging Tock/OpenTitan working group][tock-ot-wg].

In the meantime, check out OpenSK in action!

<video width="100%" controls>
<source src="/assets/2020/02/opensk_demo.mp4" type="video/mp4">
Video of WebAuthn demo with OpenSK on nrf52 dongle, running on Tock.
</video>

[gblog]: https://security.googleblog.com/2020/01/say-hello-to-opensk-fully-open-source.html
[opensk-gh]: https://github.com/google/OpenSK
[tock-ot]: https://github.com/tock/tock/tree/master/boards/opentitan
[tock-ot-wg]: https://github.com/tock/tock/pull/1594
