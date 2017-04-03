---
title: Talking Tock 15
subtitle: Cryptography, external libraries and document wrangling
author: aalevy
authors: alevy
---

This is the fifteenth post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

1. TOC
{:toc}

{::comment}
## Including External Libraries in Processes

TODO(ppannuto): a brief explanation of how they are included/built and should
be structured.
{:/comment}

## IRC and Mailing List

We've
[arranged](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/tock-dev/m1sGAUi5g5U/1hJYwUQfAgAJ)
with the organizers of [RustFest](http://2017.rustfest.eu/) for there to be a
few Hails available to check out at RustFest at the end of April.

@JayKickliter [chimmed in on
IRC](https://bot.tockos.org/tockbot/tock/2017-04-01/?msg=947&page=1) to ask
some questions about porting Tock to a new chip and board in an external
repository. It sounds like he's working on a port to another Cortex-M0 with
some exciting features. In the process, he's been compiling a list of questions
arising from the documentation, which we very much appreciate him sharing with
us.

## Hail Pre-sale

Presales for the [Hail platform]() are ongoing but going fast. The current
batch is in production and will ship in early May. There are still about 70
Hails remaining in this batch, so get them while their hot, lest you have to
wait for the next one. We plan to start supporting other platforms soon, but if
you're interested in playing around with Tock in all it's glory, Hail will
still your best bet since it's so feature packed. Pre-order one today on our
[hardware page]({{ "/hardware" | relative_url }})

## Pull Requests

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
