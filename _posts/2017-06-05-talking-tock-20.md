---
title: Talking Tock 20
subtitle: Low Power, USB and Bluetooth
authors: alevy
---

This is the 20th post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

> We're giving a tutorial co-located with [SenSys
> 2017](http://sensys.acm.org/2017) Novenmber 5th in Delft, The Netherlands.
> Go [here]({{ "/events/sensys2017" | relative_url }}) for details and to sign
> up to recieve an e-mail when registration opens.

1. TOC
{:toc}

## Low power operation

![Low power blink running on imix](/assets/2017/06/imix-lowpower.png "Low power blink running on imix")

Easy to write low power applications is one of the main design goals of Tock.
While we've basically built an architecture that should support it, we haven't
focused much yet on actually getting our development boards in to low power
modes. That changed this week, as we got the imix down to 7uA! Read about the
details [here]({% post_url 2017-06-05-low-power-1 %}).

## USB Enumeration for the SAM4L

@daniel-scs has been working for several months on supporting the SAM4L's USB
controller. He hit a huge milestone this past week managing to build enough
support to enumerate the device on Linux:

![SAM4L USB enumeration on Linux](/assets/2017/06/usb-enum-basic.png "SAM4L USB enumeration on Linux")

If you've dealt with bare-metal USB drivers, you probably know that enumeration
is a good deal of the way towards building a device, and we're all in awe of
@daniel-scs.

PR [#416] includes a few layers of abstraction geared towards building
more complete applications: a low-level HAL, a generic USB device interface and
a simple enumeration capsule.

## Bluetooth Low Energy Advertising

We've had support for using the NRF51's Bluetooth Low Energy capabilities over
a serial port for a while, but had not yet had support for BLE natively in Tock
(i.e. only when the NRF51 is running as a peripheral chip). @niklasad1
@frenicth's masters thesis work adds support for Bluetooth Low Energy
advertising to the NRF51 port of Tock.

![NRF51dk Temperature Reading over BLE](/assets/2017/06/ble-adv-temp.jpg "NRF51dk Temperature Reading over BLE")

The screenshot is an Android phone picking up on an advertisement running their
code on an NRF51DK. The manufaturer data field shown is an actual reading from
the NRF51's temperature sensor.

## Pull Requests

### Merged

  * ([#397]) @bradjc wrote an IPC tutorial
  * ([#406]) @bradjc added a MCP23008 GPIO extender capsule and GPIO Async driver
  * ([#417]) @daniel-scs Daniel fixed some comments on the SAM4L clocks


### Proposed
  * ([#409]) @niklasad1 and @frenicth are upstreaming their Bluetooth Low-Energy
    advertisement support for the NRF51.

  * ([#416]) @daniel-scs added USB enumeration to the SAM4L

  * ([#419]) @alevy added virtual alarms to userland

## Hail

Itching to start using and developing for Tock? There are still Hail
development boards, the main board used for Tock development, available in
stock. Check them out [here]({{ "/hardware/hail" | relative_url }}).

[#397]: https://github.com/helena-project/tock/pull/397
[#406]: https://github.com/helena-project/tock/pull/406
[#409]: https://github.com/helena-project/tock/pull/409
[#416]: https://github.com/helena-project/tock/pull/416
[#417]: https://github.com/helena-project/tock/pull/417
[#419]: https://github.com/helena-project/tock/pull/419
