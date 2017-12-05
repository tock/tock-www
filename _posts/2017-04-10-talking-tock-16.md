---
title: Talking Tock 16
subtitle: Papers, ports and pull requests
author: aalevy
authors: alevy
---

This is the sixteenth post in a series tracking the development of Tock, a
safe multi-tasking operating system for microcontrollers.

This week has been pretty quiet as we all put our heads down preparing
submissions for [SenSys](http://sensys.acm.org/2017/) and
[SOSP](https://www.sigops.org/sosp/sosp17/). Things will start picking back up
in a couple weeks, but for now your usual, although abrdiged, installment of
activity from the last week.

Some of the Tock developers will be at [IPSN](https://ipsn.acm.org/2017/) in
Pittsburgh next week. Say hello if you see them!

## More chips and platforms

There have been a fair bit of questions and offers of assistance porting Tock
to some readily available hardware platforms, particularly the STM32-based
discovery boards. The Tock team is all very supportive of such efforts. On the
side, we've begin playing around with @japaric's excellent
[tutorial](https://japaric.github.io/discovery) on bring up of the
[STMF3DISCOVERY](http://www.st.com/en/evaluation-tools/stm32f3discovery.html).

If you are interested in these efforts, please join the [_tock-dev_ mailing
list](https://groups.google.com/forum/#!forum/tock-dev) and/or chime in on [IRC
(#tock on freenode)](https://kiwiirc.com/client/irc.freenode.net/tock)

## Pull Requests

  * @alevy and @ppannuto fixed build failures in Travis CI related to the
    [userspace build system](https://github.com/helena-project/tock/pull/348)
    and [rustfmt](https://github.com/helena-project/tock/pull/347) version
    inconsistencies. The Travis CI problems, in particular, are totally
    unreplicable locally and seem most consistent with a file system issue of
    some sort on Travis, but a workaround works for now. The rustfmt version
    issues will likely resolve themselves in the long run as the rustfmt style
    guide is stabalized.

  * @alevy removed the now defunkt Firstorm platform (RIP) from the repository
    and replaced it with [Hail]({{ "/hardware/hail" | relative_url }}) as the
    default platform. Hail is not only active, but also available for purchase.
    Make sure to get yours!

  * @ppannuto fixed an
    [bug in the SAM4L I2C
    driver](https://github.com/helena-project/tock/pull/352) that has not yet
    manifested, but is bad just the same. He found it while trying to debug an
    [issue with multi-master I2C
    support](https://github.com/helena-project/tock/issues/351) on the SAM4L
    that is increasingly seeming like a hardware bug.

  * @daniel-scs [updated
    instructions](https://github.com/helena-project/tock/pull/350) for the imix
    platform to accurately show how to get console output on Linux.

