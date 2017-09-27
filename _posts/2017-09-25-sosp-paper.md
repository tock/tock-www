---
title: Modeling Threats on a 64 kB Computer
author: aalevy
authors: alevy
---

We just submitted the camera-ready (i.e. final version) of a paper we wrote
detailing the design and implementation of Tock for SOSP (Symposium on
Operating Systems Principles), one of the premier publication venues for
operating systems research. You can [read the full
paper](/assets/papers/tock-sosp2017.pdf). I think it's written accessibly
enough for most people who follow the project to get something out of it.

The paper goes through a fair bit of material: the goals of the OS, background
on embedded systems, implementation details, etc. Some of this is covered in
our [documentation](/documentation) or it will make its way there eventually.
But I wanted to highlight one particular topic we talk about in the paper: the
threat model that Tock identifies and defends against.

If you're building end-to-end embedded applications with Tock, understanding how
you can model threats is important to building a secure system. But even if you
don't intend on using Tock, starting to think about threats holistically in
embedded software is important. Maybe Tock's model can help get us started.

## Tock's Threat Model

"Threat model" is a technical term for the kinds of attacks and threats a
software (or really any) system might come under. The process of threat
modeling involves identifying stakeholders (users, system builders, app
developers, etc), their incentives, and their capabilities.

A threat model is _most_ meaningful when we talk about a specific application:
e.g., a Wordpress site with an administrator and a few writers, deployed in a
third-party datacenter. Of course, Tock is not an application, but an operating
system that's used to build applications. Moreover, it targets a fairly
diverse set of applications and deployment scenarios.

As a result, the goal of threat modeling in the Tock design is to set up
building blocks for threat modeling for a particular application. In this
sense, Tock departs pretty significantly from how embedded software is
typically viewed.

Normally, embedded applications are built monolithically---that is, the
hardware and software are designed together, and for the most part, all code in
the system has the ability to completely control the hardware.
Increasingly, that doesn't fit how embedded applications are actually built.

Specifically, our threat model identifies four different stakeholders: board
integrators, kernel component developers, application developers, and
end-users. Each is responsible for different parts of a complete system and has
different levels of trust in other stakeholders.

**Board integrators** combine a kernel with microcontroller-specific glue code,
drivers for attached peripherals, and communication-protocol implementations.
They decide which capabilities different kernel components have and probably
design and build the hardware platform itself. For something like a smartwatch,
these are the people who build and sell the watch.

**Kernel component developers** write most of the kernel functionality, such as
peripheral drivers and communication protocols. In practice, the "board
integrators", won't actually write most of the code. That's just usually
impractical these days. Instead, they'll likely draw on the open source
community or hardware vendors to write bits of the kernel. A vendor for an
accelerometer peripheral may supply a step counting library tuned for their
chip, or the open source community may develop a networking stack.  In Tock’s
threat model, we assume the source code for kernel components is available for
the board integrators to audit before compiling into the kernel (this isn't
always true, but it probably should be). However, it does not assume that
auditing will catch all bugs, and Tock limits the damage of a misbehaving
kernel component. In particular, kernel component developers are not trusted to
protect the secrecy and integrity of other system components. For example, they
cannot violate certain shared-resource restrictions, like performing
unauthorized accesses on peripherals, even if they are authorized to access
another peripheral on the same bus.

**Application developers** build actual end-user functionality using services
provided by the kernel. These are similar to the folks who write apps for
phones or desktops. They might be third-party companies who sell software to
end-users, they might be the end-users themselves, or they might be an open
source community. So board integrators cannot generally audit application code.
Even the developers may be completely unknown before deployment. Therefore we
model applications as malicious: they might attempt to block system progress,
to violate the secrecy or integrity of other applications or of the kernel, or
to exhaust other shared resources such as memory and communication buses.

**End-users** are the people who actually use the device. The person who wears
a smart watch is an end-user. Or the person maintaining a large sensor network.
But also other people with physical or remote access. The border agent who has
your USB security key for a couple hours is a sort of end-user. In general,
end-users can install, replace or update applications and can interact with the
system’s I/O ports in arbitrary ways. With the right kind of hardware support,
the end-user may not be trusted to obey security policies attached to sensitive
kernel data. For example, a security module on such a device could prevent a
master encryption key from leaking to end-users.

Tock provides mechanisms for enabling and protecting against each of these
stake-holders. Capsules in the kernel allow board integrators to pull in
somewhat untrusted software by limiting what that software can do, and
processes sandbox application code completely. Of course, mechanism is _not_
policy, and its up to the board integrator---the folks building something with
Tock---to use these mechanisms well.
