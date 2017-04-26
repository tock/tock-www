---
layout: page
title: Hail
subtitle: "An Open Source IoT Development Board for Tock"
author: bradjc
authors: bradjc
desc: >
  Today we are introducing Hail, an IoT development board that supports
  Tock! Hail is designed to be a very low-friction way to get started using and
  creating Tock applications.
permalink: /hardware/hail/
image: /assets/img/hail_reva_isometric_1000x547.jpg
---

[Hail](https://github.com/lab11/hail) is an open source IoT development board
that supports Tock. It is designed to be a very low-friction way to get started
using and creating Tock applications. Simply plug in the Hail module over USB
and use the [tockloader](https://github.com/helena-project/tockloader) utility
to load and run applications.
Already have one? Head [here](https://github.com/helena-project/tock/tree/master/boards/hail)
for getting started instructions and to learn how to use your Hail.

{% include hail_buy.html %}

  

In just 1.2 in² Hail packs a lot of features: a 48 MHz Cortex-M4 microcontroller,
a Bluetooth Low Energy (BLE) radio, three sensors (temperature/humidity,
light, and acceleration), an RGB LED, a push-button, and USB programming.
It also matches the [Particle Photon](https://www.particle.io/products/hardware/photon-wifi-dev-kit)
form-factor, so it can be mounted to a carrier board or breadboard with 0.1" headers or
soldered directly on with the castellations.

![Hail Development Module Breadboard](/assets/img/hail_breadboard_1000x859.jpg)

## Tock Support

Hail is [fully supported](https://github.com/helena-project/tock/tree/master/boards/hail)
by Tock. This includes the [tutorials](https://github.com/helena-project/tock/tree/master/doc/tutorials)
that make it easy to get started with programming Tock applications.

## Comparison to imix

Like [imix](https://github.com/helena-project/imix), Hail is a prototyping
board for IoT and Tock development. However, while imix gives you complete flexibility
by fully pinning out internal and external signals, providing independent power domains,
including multiple radios, and supporting Arduino shields, Hail focuses on
making it easy to get started creating apps that use sensors and BLE communications.
Its compact size makes it portable, and the headers mean it can be integrated
as the controller and radio for other projects.

## Features & Specifications

<img src="/assets/img/hail_reva_noheaders_labeled.png" width="50%" style="margin-left: 25%;" alt="Hail Development Module Labeled">

- [SAM4L](http://www.atmel.com/products/microcontrollers/arm/sam4l.aspx) Cortex-M4
- [nRF51822](https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF51822) BLE Radio
- [SI7021](https://www.silabs.com/products/sensors/humidity-sensors/Pages/si7013-20-21.aspx) Temperature and Humidity Sensor
- [ISL29035](https://www.intersil.com/en/products/optoelectronics/ambient-light-sensors/light-to-digital-sensors/ISL29035.html) Light Sensor
- [FXOS8700CQ](http://www.nxp.com/products/sensors/6-axis-sensors/digital-sensor-3d-accelerometer-2g-4g-8g-plus-3d-magnetometer:FXOS8700CQ) 6-axis Accelerometer and Magnetometer
- RGB LED
- User push-button
- USB Programming
- Particle [Photon](https://www.particle.io/products/hardware/photon-wifi-dev-kit) Form-Factor and Pinout
