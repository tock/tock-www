---
layout: default
---

# Programmable IoT starts at the edge

## An embedded operating system designed for running multiple concurrent, mutually distrustful applications on low-memory and low-power microcontrollers.

<div id="features">
### Features

  * {:.security}
  
    Safely use drivers and kernel extensions from third parties

  * {:.memory}

    Run processes reliably with minimal resource overhead

  * {:.lowpower}

    Automatic low power operation
</div>

<div id="applications">
### What can you use Tock for?

  * #### Sensor Networks

    ![Signpost modular city-scale sensing platform]({{ site.url }}/assets/img/signpost.png)

    The [Signpost] is a modular city-scale sensing platform that provides power
    and connectivity for a diverse set of sensing modules. Signpost is built
    around Tock, and uses multiprogramming to let researchers to build
    applications run experiments.

  * #### Security critical devices

    ![USB authentication key]({{ site.url }}/assets/img/usb-authkey.png)

    Security critical devices, like TPMs and USB authentication fobs, are
    actually multiprogramming environments running applications written by
    different people. Tock guarantees that untrusted components can't leak
    secrets even if they are buggy or crash.

  * #### Wearables

    ![Smart sports watch]({{ site.url }}/assets/img/running-watch.png)

    Tock enables consumer IoT devices, like sports watches or fitness trackers,
    that run need to run for months on small batteries and low-memory
    microcontrollers to support third-party apps just like on PC-grade
    operating systems.
</div>

### Safety

### Reliability

### Low-power

```c
int main() {
  while(1) {
    led_toggle(0);
    delay_ms(5000);
  }
}
```

[Signpost]: https://github.com/lab11/signpost "Signpost is a modular city-scale sensing platform"
