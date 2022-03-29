---
layout: page
title: Hardware
subtitle: TockOS Hardware
description: Hardware platforms supported by TockOS
permalink: /hardware/
---
Tock supports a growing number of hardware platforms.

<!-- npm i -g markdown-toc; markdown-toc -i hardware.md -->

<!-- toc -->

- [Stable](#stable)
  * [nRF52 Family](#nrf52-family)
  * [Hail & imix](#hail--imix)
    + [Hail](#hail)
    + [imix](#imix)
    + [Hail & imix Comparison](#hail--imix-comparison)
- [Developmental](#developmental)
  * [STM Family](#stm-family)
    + [STM32 Discovery](#stm32-discovery)
    + [Nucleo f446re](#nucleo-f446re)
    + [Nucleo f429zi](#nucleo-f429zi)
  * [Aconno](#aconno)
  * [TI Launch XL](#ti-launch-xl)
  * [ESP32 Family](#esp32-family)
- [Experimental](#experimental)
  * [SiFive HiFive1](#sifive-hifive1)
  * [OpenTitan](#opentitan)
  * [Arty e21](#arty-e21)
- [Deprecated](#deprecated)
  * [nRF51-DK (deprecated)](#nrf51-dk-deprecated)

<!-- tocstop -->

If you are interested in adding support for a new board, we have a
[guide to porting](https://github.com/tock/tock/blob/master/doc/Porting.md).
While there are a set of minimum requirements to merge a new board
([gpio, timer, uart](https://github.com/tock/tock/blob/master/doc/Porting.md#adding-a-platform-to-tock-repository)),
please feel free [to reach out](https://www.tockos.org/community/)
earlier in the process with draft PRs, issues, questions, etc as you are
getting started!

---

# Stable

These are the most mature boards in Tock, which have a large number of
peripherals implemented and have generally seen a reasonable amount of testing
and use by the community.

## nRF52 Family

An enhancement of the highly popular nRF51XXX family, Nordic Semiconductor
recently released the nRF52 family of SoCs. These boards include Bluetooth 5,
Bluetooth mesh, NFC, and ANT. The first was the nRF52832, which is available on
the [nRF52 DK][nrf52832]. More recently, they released the nRF52840, which adds
802.15.4 and in turn Thread and Zigbee support, which is available on the
[nRF52840 DK][nrf52840]. This is also available in a minimalist form factor
(no debugging, pin headers, etc) as the [nRF52840 Dongle][nrf52840-dongle].

| [nRF52840 Dongle with nRF52840 SoC][tock-nrf52840-dongle] | [nRF52840 DK with nRF52840 SoC][tock-nrf52840-dk] | [nRF52 DK with nRF52832 SoC][tock-nrf52-dk] |
|-----------------------------------------------------------|---------------------------------------------------|---------------------------------------------|
| ![nRF52840 Dongle](/assets/img/nRF52840-Dongle.png)       | ![nRF52840 DK](/assets/img/nRF52840-DK.png)       | ![nRF52 DK](/assets/img/nRF52-DK.png)       |

__Where to get it:__
 - nrf52840 Dongle from [Nordic distributors][nrf52840-dongle-hw]
 - nrf52840 DK from [Nordic distributors][nrf52840dk-hw]
 - nrf52 DK from [Nordic distributors][nrf52dk-hw]

[nrf52832]: https://www.nordicsemi.com/?sc_itemid=%7BF2C2DBF4-4D5C-4EAD-9F3D-CFD0276B300B%7D
[nrf52840]: https://www.nordicsemi.com/Software-and-Tools/Development-Kits/nRF52840-DK
[nrf52840-dongle]: https://www.nordicsemi.com/Software-and-tools/Development-Kits/nRF52840-Dongle
[nrf52dk-hw]: https://www.nordicsemi.com/About-us/BuyOnline?search_token=nRF52-DK&series_token=nRF52832
[nrf52840dk-hw]: https://www.nordicsemi.com/About-us/BuyOnline?search_token=nrf52840-DK&series_token=nRF52840
[nrf52840-dongle-hw]: https://www.nordicsemi.com/About-us/BuyOnline?search_token=nRF52840DONGLE&series_token=nRF52840
[tock-nrf52840-dongle]: https://github.com/tock/tock/tree/master/boards/nordic/nrf52840_dongle
[tock-nrf52840-dk]: https://github.com/tock/tock/tree/master/boards/nordic/nrf52840dk
[tock-nrf52-dk]: https://github.com/tock/tock/tree/master/boards/nordic/nrf52dk


## Hail & imix

Hail and imix were the first two platforms supported by Tock. They were
designed as a common basis for Tock development.  They have specific features
that make Tock development easier: e.g. a common set of sensors, radios, and
the ability to measure power draw easily. Both Hail and imix were designed at
Universities for our own purposes, but we're able to make them available with
small-run productions funded with grad student rent money. This means they're
not as cheap as they could be. Sorry!

### [Hail](https://github.com/tock/tock/tree/master/boards/hail)

Hail is a Particle Photon sized development board for Tock. You can learn more
on the [introducing hail](../blog/2017/introducing-hail/) post, or buy one
below.

{% include hail_buy.html %}

### [imix](https://github.com/tock/tock/tree/master/boards/imix)

![Imix on a table](/assets/img/imix-v2.1.png)

imix is a "kitchen sink" development board for Tock with a SAM4L MCU, two
wireless radios, a hardware random number generator, and a sensor suite.
See the [GitHub page](https://github.com/helena-project/imix) for more
information.

imix will be available in the coming weeks. Sign up below to be notified by e-mail
when it is available for purchase or contact [Amit](mailto:amit@amitlevy.com) if you
want one sooner.

<div id="mc_embed_signup">
<form action="https://tockos.us14.list-manage.com/subscribe/post?u=3ab7c13c2409f58a1553f170a&amp;id=e9dd44c1a1" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
<div id="mc_embed_signup_scroll">
<h3>Sign up for notifications on imix availability</h3>
<div class="mc-field-group">
<label for="mce-EMAIL">Email Address  <span class="asterisk">*</span>
</label>
<input type="email" value="" name="EMAIL" class="required email" id="mce-EMAIL">
</div>
<div class="mc-field-group">
<label for="mce-FNAME">First Name </label>
<input type="text" value="" name="FNAME" class="" id="mce-FNAME">
</div>
<div class="mc-field-group">
<label for="mce-LNAME">Last Name </label>
<input type="text" value="" name="LNAME" class="" id="mce-LNAME">
</div>
<div id="mce-responses" class="clear">
<div class="response" id="mce-error-response" style="display:none"></div>
<div class="response" id="mce-success-response" style="display:none"></div>
</div> 
<div style="position: absolute; left: -5000px;" aria-hidden="true"><input type="text" name="b_3ab7c13c2409f58a1553f170a_e9dd44c1a1" tabindex="-1" value=""></div>
<div class="clear"><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div>
</div>
</form>
</div>

### Hail & imix Comparison

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

---

# Developmental

These are the newest boards to Tock. They may have some rough edges or
incomplete peripheral implementations beyond the core set.

## STM Family

### [STM32 Discovery](https://github.com/tock/tock/tree/master/boards/stm32f3discovery)

<table markdown="1">
<tr markdown="1">
<td markdown="1">
 - Chip: STM32F303VCT6
 - Basics:
   - Eight user LEDs: LD3/10 (red), LD4/9 (blue), LD5/8 (orange) and LD6/7 (green)
   - One user button
 - Sensors:
   - Accelerometer
   - Gyroscope
   - e-Compass (3-axis digital accelerometer with a 3-axis digital magnetic sensor)
 - Extras:
   - USB connection
   - On-board debugger/programmer
</td>
<td markdown="1">
![Image of Discovery Kit](https://www.st.com/bin/ecommerce/api/image.PF254044.en.feature-description-include-personalized-no-cpn-medium.jpg)
</td>
</tr>
</table>

__Where to get it:__ [ST distributors][discovery-hw]

[discovery-hw]: https://www.st.com/en/evaluation-tools/stm32f3discovery.html#sample-and-buy

### [Nucleo f446re](https://github.com/tock/tock/tree/master/boards/nucleo_f446re)

<table markdown="1">
<tr markdown="1">
<td markdown="1">
 - Chip: STM32F446RE
 - Basics:
   - 1 user LED
   - 1 user button
 - Sensors:
   - Available with expansion boards
 - Extras:
   - USB connection
   - On-board debugger/programmer
   - Extensible via Arduino™ Uno V3 connectivity support or ST morpho headers
</td>
<td markdown="1">
![Image of Nucleo f446re](https://www.st.com/bin/ecommerce/api/image.PF262063.en.feature-description-include-personalized-no-cpn-large.jpg)
</td>
</tr>
</table>

__Where to get it:__ [ST or distributors][f446re-hw]

[f446re-hw]: https://www.st.com/en/evaluation-tools/nucleo-f446re.html#sample-and-buy

### [Nucleo f429zi](https://github.com/tock/tock/tree/master/boards/nucleo_f429zi)

<table markdown="1">
<tr markdown="1">
<td markdown="1">
 - Chip: STM32F429ZI
 - Basics:
   - 3 user LEDs
   - 2 user buttons
 - Sensors:
   - Available with expansion boards
 - I/O:
   - Ethernet
 - Extras:
   - USB connection
   - On-board debugger/programmer
   - Extensible via Arduino™ Uno V3 connectivity support or ST morpho headers
</td>
<td markdown="1">
![Image of Nucleo f446re](https://www.st.com/bin/ecommerce/api/image.PF262637.en.feature-description-include-personalized-no-cpn-medium.jpg)
</td>
</tr>
</table>

__Where to get it:__ [ST distributors][f429zi-hw]

[f429zi-hw]: https://www.st.com/en/evaluation-tools/nucleo-f429zi.html#sample-and-buy

## [Aconno](https://github.com/tock/tock/tree/master/boards/acd52832)

A peripheral-rich platform based on the nrf52 family.

 - Chip: nRF52832
 - Basics:
   - One (two?) user LEDs
   - One (two?) user buttons
 - Sensors:
   - Accelerometer
   - Gyroscope
   - Magnetometer
   - Temperature
   - Ambient light
 - I/O:
   - IR LED
   - 5-way joystick
   - BLE Radio (nrf52832)
   - NFC
   - Buzzer
   - Relay
 - Extras:
   - USB connection

__Where to get it:__ [Aconno][aconno]

[aconno]: https://aconno.de/products/acd52832/


## [TI Launch XL](https://github.com/tock/tock/tree/master/boards/launchxl)

A newer addition to TI's LaunchPad family of development boards.

 - Chip: CC26X2R
 - Basics:
   - Two user LEDs
   - Two user buttons
 - Sensors:
   - None on board, but many availble via BoosterPack
 - I/O:
   - BLE
   - 802.15.4 (Thread/Zigbee)
 - Extras:
   - USB connection

__Where to get it:__ [TI or distributors][launchxl-hw]

[launchxl-hw]: http://www.ti.com/tool/LAUNCHXL-CC26X2R1#buy

## ESP32 Family

### [ESP32-C3-DevKitM-1](https://github.com/tock/tock/tree/master/boards/esp32-c3-devkitM-1)

[ESP32-C3-DevKitM-1](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/hw-reference/esp32c3/user-guide-devkitm-1.html) is an entry-level development board based on [ESP32-C3-MINI-1](https://www.espressif.com/sites/default/files/documentation/esp32-c3-mini-1_datasheet_en.pdf), a small-sized 2.4 GHz Wi-Fi (802.11 b/g/n) and Bluetooth® 5 module built around the ESP32-C3 series of SoCs, RISC-V single-core microprocessor.

<table markdown="1">
<tr markdown="1">
<td markdown="1">
 - Chip: ESP32-C3
 - Basics:
   - RGB LED
 - I/O:
   - Wi-Fi
   - Bluetooth LE
 - Extras:
   - USB-to-UART Bridge
</td>
<td markdown="1">
![Image of ESP32-C3-DevKitM-1](https://docs.espressif.com/projects/esp-idf/en/latest/esp32c3/_images/esp32-c3-devkitm-1-v1-isometric.png)
</td>
</tr>
</table>

__Where to get it:__ [Espressif distributors](https://www.espressif.com/en/products/devkits)

---

# Experimental

These are special cases, boards that Tock is experimenting with or hardware
platforms that may not yet themselves be stable or mature.

## [SiFive HiFive1](https://github.com/tock/tock/tree/master/boards/hifive1)

Some of the first commercially available Risc-V hardware, the HiFive1 platform
is iterating quickly. Tock is very interested in Risc-V support and is working
with various platform vendors to quickly iterate on designs for deeply embedded
platforms.

__Where to get it:__ [Crowdsupply][hifive1-revB-hw]*

_*Note: Tock only supports the Rev B_

[hifive1-revB-hw]: https://www.crowdsupply.com/sifive/hifive1-rev-b

## [OpenTitan](https://github.com/tock/tock/tree/master/boards/opentitan)

A new silicon root of trust, for details, please see the repository.

## [Arty e21](https://github.com/tock/tock/tree/master/boards/arty-e21)

An FPGA-based platform with large I/O potential and a vast array of timers.
The board is a Arduino-compatible footprint, enabling additional expansion.

__Where to get it:__ [Digilent or distributors][arty-hw]

[arty-hw]: https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board-for-makers-and-hobbyists/

---

# Deprecated

These are boards previously supported by Tock. They may have been deprecated
because the manufacturer quit making them or there was no longer any active
developers interested in maintaining them. Generally, we willing to resurrect
a deprecated board if someone is willing to take ownership of the platform,
however please [reach out to us first](https://www.tockos.org/community/).

## nRF51-DK (deprecated)

> **Note:** Tock has largely deprecated efforts around the nrf51 in favor of
> the nRF52.

![NRF51 Development Kit](/assets/img/nrf51dk.jpg)

The [Nordic nRF Development
Kit](https://www.nordicsemi.com/eng/Products/nRF51-DK) is Nordic
Semiconductor's development board for the popular Blutooth Low Energy SoC, the
NRF51. Both imix and Hail include this chip in addition to the SAM4L.






