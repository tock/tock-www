---
layout: page
title: About
subtitle: About
desc: About the Tock embedded operating system
permalink: /about/
---

Embedded operating systems are traditionally been limited to libraries that
abstract hardware and implement common utilities. These systems provide only
limited mechanisms, if any, to ensure the safety of drivers or isolate
applications. Instead, developers must assume that all code is equally
trustworthy and bug free. As embedded systems strive to provide additional
features, developers draw on third-party source code for libraries, drivers and
applications. Incorporating this external code safely is difficult in memory
constrained, low power embedded microcontrollers that lack virtual memory.
Processes, for example, require per-component stacks. On a 16-64 kB
microcontroller, this can be prohibitive.

Tock is a safe, multitasking operating system for memory constrained devices.
Tock is written in Rust, a type-safe systems language with no runtime or
garbage collector. Tock uses the Rust type system to enforce safety of
components, called capsules, in a single-threaded event-driven kernel. In
addition, Tock uses remaining memory to support processes written in any
language. To support safe event-driven code that responds to requests from
processes, Tock introduces two new abstractions: memory containers and memory
grants.

