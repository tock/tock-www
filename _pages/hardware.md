---
layout: page
title: Hardware
subtitle: TockOS Development Hardware
description: Hardware platforms that support TockOS
permalink: /hardware/
---

Tock supports a growing number of hardware platforms.

We mostly use one of two development platforms---Hail and imix---designed as a
common basis for Tock development. If you're contributing to Tock, it would be
useful (though not necessary) to have one of these. They have specific features
that make Tock development easier: e.g. a common set of sensors, radios and the
ability to measure power consumption easily. Both Hail and imix were designed
at Universities for our own purposes, but we're able to make them available
with small-run productions funded with grad student rent money. This means
they're not as cheap as they could be. Sorry!

## Hail

Hail is a Particle Photon sized development board for Tock. You can learn more
on the [introducing hail](../blog/2017/introducing-hail/) post, or buy one
below.

{% include hail_buy.html %}

## imix

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

## nRF52

[Adafruit Feather nRF52 Bluefruit LE - nRF52832](https://www.adafruit.com/product/3406)
