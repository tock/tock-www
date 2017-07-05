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

    ![Signpost modular city-scale sensing platform]({{ site.baseurl }}/assets/img/full-res/signpost.png)

    The [Signpost] is a modular city-scale sensing platform that provides power
    and connectivity for a diverse set of sensing modules. Signpost is built
    around Tock, and uses multiprogramming to let researchers to build
    applications run experiments.

  * #### Security critical devices

    ![USB authentication key]({{ site.baseurl }}/assets/img/full-res/usb-authkey.png)

    Security critical devices, like TPMs and USB authentication fobs, are
    actually multiprogramming environments running applications written by
    different people. Tock guarantees that untrusted components can't leak
    secrets even if they are buggy or crash.

  * #### Wearables

    ![Smart sports watch]({{ site.baseurl }}/assets/img/full-res/running-watch.png)

    Tock enables consumer IoT devices, like sports watches or fitness trackers,
    that run need to run for months on small batteries and low-memory
    microcontrollers to support third-party apps just like on PC-grade
    operating systems.
</div>

### Safety

Tock takes advantage of hardware-protection mechanisms available on recent
microcontrollers and the type-safety features of the Rust programming language
to provide a multiprogramming environment that offers isolation of software
faults.

Kernel components are isolated at compile-time using Rust's type and module
systems. As a result, sensor drivers, virtualization layers, networking stacks
and other components can only access resources they are allowed to, even if they
operate on the same bus or share state with other components. For example, two
drivers for peripherals on the same I2C bus can only talk to their respective
peripherals.

[Learn More](/documentation/design)

### Reliability

Embedded applications, whether for sensor networks, IoT devices, or security
focused, need to be highly reliable. If they crash, there is usually no way for
a human to fix them in the field.

The Tock kernel uses an event driven execution model that uses no heap
allocation, so the kernel won't run out of memory. Applications can manage their
memory however they want, but are scheduled preemptively and decoupled from the
kernel such that the system can keep going if an application crashes or
restarts.

[Learn More](/documentation/design)

### Seamless Low-power

Tock-based systems can run on battery for months or years, or from energy
harvesting sources like solar indefinitely. The Tock kernel and drivers
seamlessly put the hardware into the lowest possible sleep state based on
application requirements. No explicit power-management is required from the
application! Even naive apps like this blink app sleep as low as 5&mu;A<sup>\*</sup>:

```c
int main() {
  while(1) {
    led_toggle(0);
    delay_ms(5000);
  }
}
```

<small>\* As measure on the imix development board. Actual current draw depends
on the microcontroller and board.</small>

[Signpost]: https://github.com/lab11/signpost "Signpost is a modular city-scale sensing platform"
