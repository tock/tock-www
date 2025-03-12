---
layout: page
title: MobiSys 2025 Tock Tutorial
description: Tutorial Page
permalink: /events/mobisys25
---

## Tock, Secure Root-of-Trust, and IoT

We will be holding a full-day tutorial at [MobiSys](https://www.sigmobile.org/mobisys/2025/)
on the Tock Operating System. This event will take place on June 27, 2025.

The goal of this tutorial is to provide members of the mobile systems and
computing community a contemporary guide to the foundations of security for
modern computational systems.

The event is divided into four semi-independent sessions. The first session
invites __TBD: lightning talks? posters? what do we want to solicit?__

Each of the subsequent technical sessions is a mixture of educational content
and hands-on hardware experience. Over the course of the day, we will develop
an end-to-end system which dynamically deploys signed, verified applications
onto edge, microcontroller-class devices where the application will generate a
stream of tamper-proof sensor readings for a cloud endpoint.

While participants are encouraged to attend for the full day, each session aims
to be sufficiently standalone to allow "drop-ins" for different portions of the
event.

### Call For Lightning Introduction Talks

We encourage participants to submit one slide introducing themselves and their
research area. During the first session of the tutorial we will invite
participants who submitted a slide to introduce themselves, their background,
and their interest in secure IoT operating systems. Our goal is to get better
sense of the participants in the tutorial so we can facilitate a more
interactive tutorial and adapt some of the content based on participant interest
and background.

Please submit your slide **here** in either `.pdf` or `.pptx` form.

If capacity for the tutorial is reached priority will be given to participants
who have submitted an introduction slide.

---

__Times are estimates for planning flow Pat just made up for the moment.__

<style>
.session {
  background: #cfe2ff;
}
.break {
  background: #ffe8a3;
}
</style>

<table>
<tr class="session">
  <th colspan="2">[1hr] Session 0: Welcome, Getting Started, &amp; Lightning Talks</th>
</tr>
<tr class="session">
  <td colspan="2" style="text-align: right;">
  <small><i>Chair:
  <a href="https://patpannuto.com">Pat Pannuto</a>,
  <a href="https://ucsd.edu">UC San Diego</a>
  </i></small>
  </td>
</tr>
<tr>
  <td>
  8:45
  </td>
  <td>
  (10m) Welcome, Intro to Tock, and Overview of the Day
  </td>
</tr>
<tr>
  <td>
  8:55
  </td>
  <td>
  (5m) Setting up your development environment
  <ul>
    <li>Get folks started on this.</li>
    <li>Work independently on these (high-latency, low-interaction) steps during the rest of the session.</li>
  </ul>
  </td>
</tr>
<tr>
  <td>
  9:00
  </td>
  <td>
  (45m) Introduction Lightning Talks
  <ul>
    <li>1 slide / person, 2 minutes</li>
    <li>Tell us a bit about who you are and what your research area or background is.</li>
    <li>Interactive at all?</li>
  </ul>
  </td>
</tr>
<tr class="break">
 <td>9:45</td>
 <td>(10m) Coffee Break</td>
</tr>
</table>


<table>
<tr class="session">
  <th colspan="2">[2hr] Session 1: Roots of Trust</th>
</tr>
<tr class="session">
  <td colspan="2" style="text-align: right;">
  <small><i>Chair:
  <a href="https://www.linkedin.com/in/katfox">Kat Fox</a>,
  <a href="https://www.zerorisc.com/">ZeroRisc</a>
  </i></small>
  </td>
</tr>
<tr>
  <td>
  10:00
  </td>
  <td>
  (50m+10m) A Primer on Roots of Trust
  <ul>
    <li>What is a RoT?</li>
    <li>Examples of RoTs you use already? (Directly, e.g. SecureEnclave; Indirectly, e.g. cloud)</li>
    <li>Top-Down: What does RoT provide platform, app developers? Why does mobile/edge computing care about RoT?</li>
    <li>Bottom-Up: What is required to act as a RoT? From HW? SW?</li>
    <li>Demo??</li>
    <li>Open challenges / concerns / problems for RoT / security ecosystem around them?</li>
  </ul>
  <ul>
    <li>Q&A</li>
  </ul>
  </td>
</tr>
<tr>
  <td>
  11:00
  </td>
  <td>
  (25m+5m) TockOS as firmware for RoT
  <ul>
    <li>What is Tock (quickly; avoid re-hash of Session 0 Intro)? Who is using Tock as part of RoT solution today?</li>
    <li>What parts of "what defines a RoT" does Tock provide?</li>
    <li>What does Tock provide above and beyond bare metal / minimal RoT firmware?</li>
    <li>Understand trust boundaries, relationships? What "parts of Tock" are "parts of the RoT"?</li>
    <li>What does a mobile developer, edge device developer gain from RoT+Tock? Transition to hands-on component?</li>
  </ul>
  </td>
</tr>
<tr>
  <td>
  11:30
  </td>
  <td>
  (30m) Interactive Session
  <ul>
    <li>Maybe: Turn nrf52840dk into a U2F token?</li>
  </ul>
  </td>
</tr>
<tr class="break">
 <td>12:00</td>
 <td>[1h] Lunch</td>
</tr>
</table>


<table>
<tr class="session">
  <th colspan="2">[1hr45m] Session 2: Dynamic Applications and Security-by-Policy</th>
</tr>
<tr class="session">
  <td colspan="2" style="text-align: right;">
  <small><i>Chair:
  Viswajith Govinda Rajan,
  <a href="https://www.virginia.edu/">University of Virginia</a>
  </i></small>
  </td>
</tr>
<tr>
  <td>
  13:00
  </td>
  <td>
  (20m+10m) A Policy-Based Approach to Secure and Flexible Platform Deisgn
  <ul>
    <li>Dynamic app loading—what's different on embedded, different concerns on RoT platform, especially with mixed use cases?</li>
    <li>App identity in Tock (mabye sig's / enforcement etc too)?</li>
    <li>OS/platform policy approach, runtime flexibility, etc; some dive into the implementation</li>
    <li>Specific examples, maybe use as transition to hands-on part?</li>
  </ul>
  <ul>
    <li>Q&A</li>
  </ul>
  </td>
</tr>
<tr>
  <td>
  13:30
  </td>
  <td>
  (75m) Interactive Session
  <ol>
    <li>Basic interaction with multiple, static processes on Tock</li>
    <li>Process loading example [how to "get" other apps? in-binary, DFU USB, Thread?]</li>
    <li>Policy enforcement for dynamic apps</li>
    <li>Example of security / attacker scenario Tock protects against</li>
  </ol>
  </td>
</tr>
<tr class="break">
 <td>14:45</td>
 <td>[15m] Coffee Break</td>
</tr>
</table>


<table>
<tr class="session">
  <th colspan="2">[1hr45m] Session 3: Networking and End-to-End Integration</th>
</tr>
<tr class="session">
  <td colspan="2" style="text-align: right;">
  <small><i>Chair:
  Tyler Potyondy,
  <a href="https://www.ucsd.edu/">UC San Diego</a>
  </i></small>
  </td>
</tr>
<tr>
  <td>
  15:00
  </td>
  <td>
  (10m+5m) Thread Networking Primer
  <ul>
    <li>What networking options does Tock provide?</li>
    <li>What is thread, why focus on it?</li>
    <li>How does thread work, how does Tock implement Thread?</li>
    <li>What can we do with Thread?</li>
    <li>How do Tock apps share a Thread network connection?</li>
  </ul>
  </td>
</tr>
<tr>
  <td>
  15:45
  </td>
  <td>
  (30m) Interactive Session
  <ol>
    <li>Basic interaction with Thread networking on Tock</li>
    <li>Running multiple processes which all use Thread</li>
  </ol>
  </td>
</tr>
<tr>
  <td>
  16:15
  </td>
  <td>
  (10m+5m) End-to-end Examples / Security in distributed environments
  <ul>
    <li>What does trust look like across multiple endpoints? Edge, mobile, cloud?</li>
    <li>Scenario: Deploy app to collect trusted data</li>
    <li>(walk through security model/steps to): Get new app loaded on (semi-?)trusted(?) platform [maybe Signpost as motivating example?]</li>
    <li>(walk through security model/steps to): Have the app create authenticated sensor measurements, sent over untrusted network, to trusted cloud endpoint</li>
  </ul>
  </td>
</tr>
<tr>
  <td>
  16:30
  </td>
  <td>
  (30m) Interactive Session (Implement scenarios above)
  <ol>
    <li>Remote-load of a trusted app</li>
    <li>Demonstrate e2e signed data to cloud endpoint</li>
  </ol>
  </td>
</tr>
<tr class="break">
 <td>17:00</td>
 <td>Wrap-up, feedback, etc</td>
</tr>
</table>
