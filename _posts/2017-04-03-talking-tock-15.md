---
title: Talking Tock 15
subtitle: Cryptography, external libraries and document wrangling
author: aalevy
authors: alevy
---

This is the fifteenth post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

## Including External Libraries in Processes

TODO(ppannuto): a brief explanation of how they are included/built and should
be structured.

## Tock Pull Requests

Another successful week of merging all proposed pull requests. We're not sure
if it's the slightly reduced volume of PRs or just procrastinating from writing
papers, but either way it seems to be working!

  * @niklasad1 and @frenicth
    [added](https://github.com/helena-project/tock/pull/340)
    [support](https://github.com/helena-project/tock/pull/344) for
    encryption/decryption in AES in counter mode on top of the NRF51’s AES in
    ECB mode. The HIL for symmetric encryption is still in-flux, but good
    enough to merge for now. Next step will be to implement the same interface
    for the SAM4L (which has a built in counter-mode AES controller).

  * @ppannuto Made [consistent](https://github.com/helena-project/tock/pull/341)
    the signature for the `main` function in userland while fixing some
    [usability bugs](https://github.com/helena-project/tock/issues/338) in the
    process startup code. One important point from the discussion on the PR
    thread is that we decided to avoid explicitly adding support for various
    kinds of programming styles (e.g. an Arduino-style interface) since they
    are easy to build on top of our existing interface. We expect to see a few
    additional libraries for doing this on top of the core library in the
    future.

  * @ppannuto Added a standardized way of
    [including external libraries](https://github.com/helena-project/tock/pull/337)
    into userland apps in our build system. He also
    [conformed](https://github.com/helena-project/tock/pull/345) the core
    `libtock` library to this mechanism instead of special casing it.  This
    means it's virtually as easy to replace `libtock` with a different userland
    library as it is to use the one we provide.

  * @bradjc fixed up some inconsistent tables of contents in our documentation and
    [added a TravisCI check](https://github.com/helena-project/tock/pull/342)
    that verifies TOCs in markdown files in case such inconsistencies arise
    again.
