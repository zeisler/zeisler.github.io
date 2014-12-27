---
title: Long Distance Wireless Network
date: 2012-08-1
tags: Network DYI
layout: post
---

[![wifiproject](/images/blog/wifiproject.jpg)][wifi]

My project was to network two building, a house and a guest house
located on a farm. Cable Internet is available at the main house,
which is along a main road. Only DSL Internet is available at the
guest house and is too slow to be considered. First I talked to the
cable company if they would bring a cable connection to the guest house. They did a
survey and came back with a quote of $4,000 to run it underground or $2,500
to run it along the power lines. This was a charge that I was
unwilling to pay and knew there must be cheaper option. A wifi connection would be difficult because there is no
line of slight between the two houses because of a wooded area and an
elevation change.

Even with these challenges I bought some equipment to see if I could get a signal. The first product I tired was a set of EnGenuis Long range Outdoor wireless, in
the end I was unhappy with this product, while I may of gotten a bad
unit, the unit would repeatedly crash when ever it was connected to by wireless
and needed to be manually reset by pulling the cord from
the power injector. I returned them both to amazon and instead
ordered two products from Ubiquiti. The first one was Nanostation LOCO
M2 Outdoor MIMI 2×2 802.11g/n. This comes with an 8dBi dual-polarity
gain antenna and has power over Ethernet. Poe is great for outdoors
deployment because only one cable has to be run to the device and it
can extend up to 300ft. I ran 200ft of cable from the guest house into
a strip of trees and climbed about 50ft and mounted the unit. I
mounted it to the trunk of the tree clearing branches giving a good
open view to send out a signal. From in the tree there was still no
line of sight to the main house but there was an open field then a
thin strip of trees before the main house. I decided to buy a Ubiquiti
Networks NanoStation M2 2.4GHz 802.11n 2×2 MIMO that comes with a 14
dBi dual polarity antenna to mount on the main house, a more powerful
unit to make of for it’s lack of height. It may have just worked fine
with another LOCO M2, but I didn’t want to take any more chances
because I was a month into the project already.

I really liked the AirOS software it has lot of good features you'll
need to do some searching to figure out how all the features work because
there is little documentation with the device. Check out the wiki
page for AirOS located on Ubiquiti’s website. One great feature is you
can test changes before applying them, putting change in effect for
2 minutes and then defaulting back to the previous settings. Use this
feature especially if the unit is mounted 50ft in a tree. If for some
reason changes are made and something makes the unit inaccessible it
will have to be manually reset.

The unit at the main house was setup as an Access Point, unit 2 in the
tree was setup as a Station. I made the SSID the same as the unit 1 AP
and set the Lock to AP MAC to the mac address of the unit 1. Also set
both units are set to Network bridge mode, where unit 1 is connected
to a Linksys router that is connected to the cable modem. My
connection results were as follows:
{% highlight ruby %}
Horizontal / Vertical: -64  /  -63  dBm
Noise Floor: -102 dBm
Transmit CCQ: 97.7 %
TX/RX Rate: 120.0 Mbps  /  120.0 Mbps
{% endhighlight %}
I am able to receive the same Internet speed form both houses using SpeedTest.net, which in low peak hours I get 24Mbps down and 4Mbps up. There has been no drops in connection and it has been running nonstop for two days. I am very happy with the Nanostation products and would recommend using them in similarly situations.

**Update 5/3/2013**

I have had the system up and running with the only issue being in a spliced connection I made on the 200ft run. It was not sealed well causing the connection to stop working. I repaired the connection and everything has been working since.

[wifi]: /image/blog/wifiproject.jpg
