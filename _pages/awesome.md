---
layout: page
title: Awesome Tock
description: Community projects built with and around the Tock embedded operating system
permalink: /awesome/
---

Tock is more than a kernel. This is a curated list of independently developed
products, ports, applications, tools, and research from across the Tock
community. Projects within each category are listed alphabetically, not by
preference.

## Systems and deployments

Products and real-world systems that put Tock to work.

  * [Signpost](https://github.com/lab11/signpost) is a modular, city-scale
    sensing platform that uses Tock to safely run independent sensing
    applications in the field.
  * [SmartClip](https://github.com/Samir-Rashid/smartclip) is an open-source,
    low-power wearable computing testbed that supports Tock and the Thread
    protocol.
  * [Tock on Titan](https://github.com/google/tock-on-titan) contains Google's
    ports of Tock to the embedded controllers used in the Titan security
    ecosystem (this repository is now read only).

## Hardware and board ports

Community support for running Tock on more chips and boards.

  * [OpenSK HiFive](https://github.com/ljrk0/OpenSK_HiFive) is an initial port
    of the OpenSK and Tock security-key firmware to the RISC-V SiFive HiFive
    platform.
  * [Out-of-tree Tock for Raspberry Pi Pico](https://github.com/potto216/tockos_oot_raspberry_pi_pico)
    provides a standalone Raspberry Pi Pico board and RP2040 chip crate,
    including userspace SPI support and direct UART support.

## Applications and experiments

Things to run, learn from, take apart, and build on.

  * [Retro Platformer for Tock](https://github.com/seanflynn1107/retro-platformer-tock)
    is a 2D platform game written in C for Tock on the nRF52840 DK with an
    SH1106 OLED display.
  * [Tock DSP](https://github.com/mdclyburn/tock-dsp) explores audio digital
    signal processing on Tock (This is an incompatible fork of the Tock OS project).
  * [Tock Ping](https://github.com/mog96/tock-ping) is a Linux bridge for
    testing Tock's 6LoWPAN and IEEE 802.15.4 stack with IPv6 traffic.

## Developer tools

Community utilities that make developing and testing Tock easier.

  * [Tock Configurator](https://github.com/OxidosAutomotive/tock-configurator)
    is a Rust-based tool for configuring Tock for supported boards.
  * [Tock Docker](https://github.com/george-hopkins/tock-docker) provides a
    containerized environment for getting a Tock development toolchain up and
    running.
  * [Tock Test Harness](https://github.com/goodoomoodoo/tock-test-harness) is a
    test runner for exercising Tock systems.

## Research and verification

Projects examining, extending, and reasoning about Tock's design.

  * [Lightweight Tock Verification](https://github.com/Samir-Rashid/osfc24-tockos-lightweight-verification)
    contains artifacts for exploring lightweight firmware verification with
    Tock.
  * [Omniglot Tock](https://github.com/omniglot-rs/omniglot-tock) is a RISC-V
    PMP-based Tock runtime for the Omniglot project.
  * [Tock Veri-ASM](https://github.com/PLSysSec/tock-veri-asm) contains
    research code for reasoning about inline assembly in Tock.

## Contributing

We welcome source-available community work that helps people understand, use,
or extend Tock. A project can be established or experimental, as long as its
description makes that clear. If something is missing or out of date, please
[open an issue](https://github.com/tock/tock-www/issues/new) or
[send a pull request](https://github.com/tock/tock-www).
