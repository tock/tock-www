---
layout: page
title: Hardware
subtitle: TockOS Development Hardware
description: Hardware platforms that support TockOS
permalink: /hardware/
---

Tock supports a number of hardware platforms.

## Hail

Hail is a Particle Photon sized development board for Tock. You can learn more
on the [introducing hail](../blog/2017/introducing-hail/) post, or buy one
below.

{% include hail_buy.html %}

## imix

![Imix on a table](/assets/img/imix-on-table.jpg)

imix is a "kitchen sink" development board for Tock with a SAM4L MCU, two
wireless radios, a hardware random number generator, and a sensor suite.
See the [GitHub page](https://github.com/helena-project/imix) for more
information.

## imix & Hail Comparison

|                             | imix                    | Hail            |
|-----------------------------|-------------------------|-----------------|
| Microcontroller             | Sam4l                   | Sam4l           |
| Sensors                     |                         |                 |
| ‣ Accelerometer             | ✓                       | ✓               |
| ‣ Temperature/Humidity      | ✓                       | ✓               |
| ‣ Light                     | ✓                       | ✓               |
| ‣ Accelerometer             | ✓                       | ✓               |
| Radios                      |                         |                 |
| ‣ BLE                       | ✓                       | ✓               |
| ‣ 802.15.4                  | ✓                       |                 |
| Other Features              |                         |                 |
| ‣ Buttons                   | 1 user, 1 reset         | 1 user, 1 reset |
| ‣ LEDs                      | 3                       | 1 blue, 1 RGB   |
| ‣ Hardware RNG              | ✓                       |                 |
| ‣ USB Host                  | ✓                       | pins only       |
| ‣ Independent Power Domains | ✓                       |                 |
| Programming                 | USB or JTAG             | USB or JTAG     |
| Form Factor                 | Custom, Arduino Headers | Particle Photon |
| Size                        | 2.45" x 4"              | 0.8" x 1.44"    |
| Price                       | $100                    | $60             |

## nRF51-DK

![NRF51 Development Kit](/assets/img/nrf51dk.jpg)

The [Nordic nRF Development
Kit](https://www.nordicsemi.com/eng/Products/nRF51-DK) is Nordic
Semiconductor's development board for the popular Blutooth Low Energy SoC, the
NRF51. Both imix and Hail include this chip in addition to the SAM4L.
