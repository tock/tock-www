---
layout: default
css: /assets/css/landing.css
---

<div class="hero">
# Programmable IoT starts at the edge

## An embedded operating system designed for running multiple concurrent, mutually distrustful applications on low-memory and low-power microcontrollers.

<div style="background-color: white; color: #000; box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.7); display: inline-block; margin: 0 auto; text-align: left; padding: 16px;">
We'll be giving tutorials this summer and fall. For registration and details head over to the event pages:

  * [RustConf 2017](/events/rustconf2017) (August 18th, Portland, OR)

  * [SenSys 2017](/events/sensys2017) (November 5th, Delft, The Netherlands)

</div>

{:.links}
 * [Get started](/documentation/getting-started){:.button}
 * [Join the community](/community){:.button}

{:.features}
  * {:.extensible}
    ### Extensible
    Safely use drivers and kernel extensions from third parties

  * {:.reliable}
    ### Reliable
    Run processes reliably with minimal resource overhead

  * {:.lowpower}
    ### Low-power
    Automatic low power operation

 [Learn More](/features){:.button}

</div>

{:#applications}
  * <div>
    #### Sensor Networks

    The [Signpost] is a modular city-scale sensing platform that provides power
    and connectivity for a diverse set of sensing modules. Signpost is built
    around Tock, and uses multiprogramming to let researchers to build
    applications run experiments.
    </div>

    ![Signpost modular city-scale sensing platform]({{ site.baseurl }}/assets/img/signpost.png)

  * <div>
    #### Security critical devices

    Security critical devices, like TPMs and USB authentication fobs, are
    actually multiprogramming environments running applications written by
    different people. Tock guarantees that untrusted components can't leak
    secrets even if they are buggy or crash.
    </div>

    ![USB authentication key]({{ site.baseurl }}/assets/img/usb-authkey.png)

  * <div>
    #### Wearables

    Tock enables consumer IoT devices, like sports watches or fitness trackers,
    that run need to run for months on small batteries and low-memory
    microcontrollers to support third-party apps just like on PC-grade
    operating systems.
    </div>

    ![Smart sports watch]({{ site.baseurl }}/assets/img/running-watch.png)

[Signpost]: https://github.com/lab11/signpost "Signpost is a modular city-scale sensing platform"
