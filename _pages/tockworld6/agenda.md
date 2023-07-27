---
layout: page
title: TockWorld 6
description: Agenda for TockWorld 6
permalink: /tockworld6/agenda
---

TockWorld 6 will take place at the University of Virginia in Charlottesville, VA
on July 26-28, 2023.


The first day will be a Tock Training Workshop, the second day will be focused
on technical development of Tock OS, and the third day will be focused on the
ongoing management and governance of the Tock project.


* TOC
{:toc}

# Location

[Thornton Hall E303](https://goo.gl/maps/n7yzTvKhDfHmbUEWA) (upstairs in the SE
corner of Thornton Hall).

<img src="/assets/img/thornton_e_map.png" width="50%">

# Schedule

<style type="text/css" scoped>
.break {
  background-color: #fae88e;
}
.confirmed {
//  background-color: #7dbd8a;
}
.unconfirmed {
//  background-color: #ed4d45;
  background-color: #ffdcd9;
}
.coreproblem {
//  background-color: #ffdcd9;
}
</style>

## Wednesday, July 26, 2023: Training Workshop

- Location: [Rice Hall](https://goo.gl/maps/HrEhb71s7iD7DuaUA), Room 130. 85 Engineer's Way, Charlottesville, VA 22903

**[Please see the dedicated tutorial webpage for details and registration.](tutorial.html)**

## Thursday, July 27, 2023: TockWorld Discussion Day 1

- Location: [Thornton Hall](https://goo.gl/maps/r7PXDBwENYmRzCk3A), Room E303

<table style="width: 100%;">
<tr><th style="width: 15%;">Time</th><th style="width: 60%;">Topic</th><th style="width: 25%;">Speaker(s)</th></tr>
<tr class="break"><td>8:30</td><td colspan="2"><i>Breakfast</i></td></tr>
<tr class="coreproblem"><td>9:15</td><td>
  The State of Tock [<a href="/assets/tockworld6/state-of-tock.pdf">slides</a>]
  <ul>
  <li>The Big Picture</li>
  <li>Since TockWorld 5</li>
  <li>Coming Soon: The Tock Foundataion</li>
  </ul>
  </td><td>Amit Levy</td></tr>
<tr class="confirmed"><td>9:45</td><td>
  Kernel soundness, size, and ergonomics
  <ul>
  <li><tt>ufmt</tt> in the kernel</li>
  <li>Adding blocking command syscall</li>
  <li>Implementing zerocopy APIs</li>
  <li>Results of a small async runtime experiment</li>
  <li>Improving MMIO soundness</li>
  </ul>
  </td><td>Alyssa Haroldsen</td></tr>
<tr><td rowspan="6">10:30</td>
  <td colspan="2" style="text-align: center;"><strong>The Current and Future State of Networking</strong></td>
  </tr>
  <tr class="confirmed"><td>Thread &amp; 802.15.4 [<a href="/assets/tockworld6/Tock-World-2023-Thread-Networking.pdf">slides</a>]</td><td>Tyler Potyondy</td></tr>
  <tr class="coreproblem"><td>Other Wireless PHYs: LoRa, BLE [<a href="/assets/tockworld6/lora_and_ble.pdf">slides</a>]</td><td>Branden/Pat</td></tr>
  <tr class="confirmed"><td>Ethernet</td><td>Leon Schuermann and Cristian Cirstea</td></tr>
  <tr class="confirmed"><td>Other Wired PHYs: CAN, etc</td><td>Alexandru (or students)</td></tr>
  <tr class="coreproblem"><td colspan="2">Open discussion re: networking</td></tr>
<tr class="break"><td>12:00</td><td colspan="2"><i>Lunch</i></td></tr>
<tr class="coreproblem"><td>13:00</td><td>
  A Check-In on Development Focus Areas
  <ul>
  <li>Code Size</li>
  <li>Pluggable/blocking syscalls</li>
  <li>Connectivity</li>
  <li>Testing</li>
  </ul>
  </td><td>Hudson Ayers</td></tr>
  <tr class="coreproblem">
    <td>13:30</td>
    <td>
      Discussions: Vision & Development Focus Areas
      <ul>
        <li>Where do we want the project to go in the next 3-5 years?</li>
        <li>Where is effort being spent?</li>
        <li>What are the current pain points?</li>
        <ul style="font-size: 80%;">
          <li>
            <strong>Open Forum: Challenges &amp; Future Focus Pitches</strong><br />
            <ul>
              <li>Networking</li>
              <li>Blocking Commands</li>
              <li>Goals and Future</li>
              <li>libtock-rs</li>
              <li>[Technical Debt and Documentation](/tockworld6/techdebt)</li>
              <li>Scheduler and Interrupt Priority</li>
            </ul>
          </li>
        </ul>
      </ul>
      <i>Ad-Hoc Breakout Sessions</i>
    </td>
    <td>Brad Campbell</td>
  </tr>
<tr class="break"><td>15:15</td><td colspan="2"><i>Break</i></td></tr>
<tr class="coreproblem"><td>15:30</td><td>Regroup &amp; Synthesis of Breakouts</td><td>Tock Core Team</td></tr>
<tr class="break"><td>16:00</td><td colspan="2"><i>Day 1 End</i></td></tr>
</table>

## Friday, July 28, 2023: TockWorld Discussion Day 2

- Location: [Thornton Hall](https://goo.gl/maps/r7PXDBwENYmRzCk3A), Room E303

<table style="width: 100%;">
<tr><th style="width: 15%;">Time</th><th style="width: 60%;">Topic</th><th style="width: 25%;">Speaker(s)</th></tr>
<tr class="break"><td>8:30</td><td colspan="2"><i>Breakfast</i></td></tr>
<tr class="confirmed"><td>9:15</td><td>Tock+Google</td><td>Alyssa Haroldsen</td></tr>
<tr class="confirmed"><td>9:45</td><td>Tock+OxidOS</td><td>Alexadru Radovici</td></tr>
<tr class="confirmed"><td>10:15</td><td>Tock+OpenTitan</td><td>Dominic Rizzo <small><i>(remote; 7:30 local)</i></small></td></tr>
<tr class="confirmed"><td>10:45</td><td>OpenTitan Update</td><td>Leon Schuermann</td></tr>
<tr class="confirmed"><td>11:15</td><td>Open discussion re: downstream users</td><td>Tock Core Team</td></tr>
<tr class="break"><td>12:00</td><td colspan="2"><i>Lunch</i></td></tr>
<tr class="break"><td>12:30</td><td colspan="2"><i>Walking tour of UVA</i></td></tr>
<tr class="coreproblem"><td>13:00</td><td>
  Community Development and The Tock Foundation
  <ul>
  <li><a href="/assets/tockworld5/community.pptx">Notes from TockWorld5</a></li>
  </ul>
  </td><td>Tock POSE Team</td></tr>
<tr class="coreproblem"><td>16:45</td><td>Summary &amp; Final Thoughts</td><td>Amit Levy</td></tr>
<tr class="break"><td>17:00</td><td colspan="2"><i>Go catch flights, see you next year!</i></td></tr>
</table>


# Attendees

- Amit Levy
- Pat Pannuto
- Branden Ghena
- Brad Campbell
- Hudson Ayers
- Alyssa Haroldsen
- Alexandru Radovici
- Arun Thomas
- Leon Schuermann
- Alexandru Vochescu
- Alphan Ulusoy
- Tyler Potyondy
- Viswajith Govinda Rajan
- Ioan-Cristian Cirstea
- Cristiana Andrei
- Cosmin Radu



# Logistics

## Food

> _If you have any allergens or dietary restrictions,
> [please let Brad know in advance](mailto:bradjc@virginia.edu?subject=TockWorld2023-Food)._
> There will be vegetarian options at all meals.


A light breakfast and coffee service will be provided each morning of the main
workshop.

Lunch will be provided each afternoon. Dinners will generally be on your own.

We may try to organize a group dinner one evening if folks are interested.

## Travel

There are few options for getting to Charlottesville, VA.

**Airplane**

Airport options:

- [CHO](http://www.gocho.com/): Small airport in Charlottesville just north of
  UVA. Delta, American, and United all have flights from LGA, ATL, IAD, CLT, and
  PHL.
- [RIC](https://flyrichmond.com/): Airport in Richmond, VA about a 75 minute
  drive from Charlottesville.
- [IAD](https://www.flydulles.com/): Dulles International Airport in northern
  Virginia. About a [two hour drive](https://goo.gl/maps/1atgrL6AmtP16Nid7) to
  Charlottesville.


**Train**

Charlottesville has an [Amtrak station](https://www.amtrak.com/stations/cvs)
right downtown served by two Amtrak lines.

You can also fly into washington area airports and connect down via Amtrak.
There are usually 3-4 trains daily between WAS and CVS.

The most convenient airport is DCO, which is a [30 minute Metro ride][dco-was]
to the Amtrak station. You can also fly into IAD, but that is closer to
[a 1h15m Metro connection][iad-was]. Similarly, you can take commuter rail
from BWI, which is also [about a 1h15m trip][bwi-was] to WAS Union Station.

**Car**

Charlottesville is a 2.5 hour drive from DC, 1 hour drive from Richmond, 3.5
hour drive from Raleigh-Durham, 4.25 hour drive from Philadelphia, or 6 hour
drive from NYC.

## Hotel

**Close/Downtown**

There are several hotels near UVA and downtown. This is not a comprehensive
list, just the hotels we typically book when hosting visitors:

- [Oakhurst Inn](https://oakhurstinn.com/): Boutique, more historic hotel with
  rooms in renovated houses. Cool if you are into that. Very close to
  engineering (3 minute walk).
- [Draftsman](https://www.marriott.com/en-us/hotels/choak-the-draftsman-charlottesville-university-autograph-collection-hotel/overview/):
  New hotel on Main Street pretty close to engineering.
- [Quirk Hotel](https://www.quirkhotels.com/hotels/charlottesville): New
  boutique hotel on Main Street. Cool rooftop.
- [Omni](https://www.omnihotels.com/hotels/charlottesville): Upscale hotel right
  on the Downtown Mall. 30 minute walk, 10 minute bike/scooter, 7 minute drive
  to engineering.
- [Forum Hotel](https://forumhotelcharlottesville.com): Brand new hotel attached
  to the UVA business school. You can check out what all the hype is about.

**Close But Not Walkable**

There are many options that are close driving distance, here are just a couple:

- [Hyatt
  Place](https://www.hyatt.com/en-US/hotel/virginia/hyatt-place-charlottesville/chozc/):
  Near Stonefield, one of those psuedo-downtowns with stores and restaurants.
  Tesla Supercharger in the parking lot.
- [Courtyard by
  Marriot](https://www.marriott.com/en-us/hotels/choch-courtyard-charlottesville/overview/):
  On US-29, free airport shuttle to CHO.
- [Holiday Inn
  (South)](https://www.ihg.com/holidayinn/hotels/us/en/charlottesville/choso/hoteldetail):
  Sorta walkable to 5th Street Station.

**Have Money to Spend**

Charlottesville also caters to those who need to spend money before it expires:

- [Keswick Hall](http://keswick.com/): Newly renovated luxury hotel on a golf
  course.
- [Boar's Head](https://www.boarsheadresort.com/): Golf and tennis club with a
  spa and hotel not to far from UVA.



[dco-was]: https://www.google.com/maps/dir/Ronald+Reagan+Washington+National+Airport+(DCA),+Ronald+Reagan+Washington+National+Airport+Access+Road,+Arlington,+VA/WASHINGTON+D.C.+AMTRAK+STATION,+50+Massachusetts+Ave+NE,+Washington,+DC+20002/@38.8762876,-77.0595009,14z/data=!3m2!4b1!5s0x89b7b826ca5d1dab:0x7edf0a3ada1943bc!4m14!4m13!1m5!1m1!1s0x89b7b731402fe095:0x4168af016d076bad!2m2!1d-77.0402315!2d38.851242!1m5!1m1!1s0x89b7b82ee7324417:0xe93853cae66c0fa2!2m2!1d-77.006903!2d38.8973386!3e3?entry=ttu
[iad-was]: https://www.google.com/maps/dir/IAD+-+Washington+Dulles+Intl+Airport+(IAD),+Saarinen+Circle,+Dulles,+VA/WASHINGTON+D.C.+AMTRAK+STATION,+50+Massachusetts+Ave+NE,+Washington,+DC+20002/@38.9135062,-77.3880212,11z/data=!3m2!4b1!5s0x89b7b826ca5d1dab:0x7edf0a3ada1943bc!4m14!4m13!1m5!1m1!1s0x89b64740174eb057:0x8e01cb201080601d!2m2!1d-77.4482522!2d38.9528647!1m5!1m1!1s0x89b7b82ee7324417:0xe93853cae66c0fa2!2m2!1d-77.006903!2d38.8973386!3e3?entry=ttu
[bwi-was]: https://www.google.com/maps/dir/Baltimore%2FWashington+International+Thurgood+Marshall+Airport+(BWI)+(BWI),+Friendship+Road,+Baltimore,+MD/WASHINGTON+D.C.+AMTRAK+STATION,+50+Massachusetts+Ave+NE,+Washington,+DC+20002/@38.9132872,-77.5034039,10z/data=!3m1!5s0x89b7b826ca5d1dab:0x7edf0a3ada1943bc!4m14!4m13!1m5!1m1!1s0x89b7e2fcbbc2e00b:0x150cfa971740!2m2!1d-76.6683889!2d39.1775715!1m5!1m1!1s0x89b7b82ee7324417:0xe93853cae66c0fa2!2m2!1d-77.006903!2d38.8973386!3e3?entry=ttu
