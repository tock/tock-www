---
layout: page
title: Features
permalink: /features
---

## Safety

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

## Reliability

Embedded applications, whether for sensor networks, IoT devices, or security
focused, need to be highly reliable. If they crash, there is usually no way for
a human to fix them in the field.

The Tock kernel uses an event driven execution model that uses no heap
allocation, so the kernel won't run out of memory. Applications can manage their
memory however they want, but are scheduled preemptively and decoupled from the
kernel such that the system can keep going if an application crashes or
restarts.

[Learn More](/documentation/design)

## Seamless Low-power

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

