---
layout: post
title: Geo-location search with Google maps
description:
category:
tags: [rails api]
---
Provides a Google maps search of nearest FFL government data.

I had originally made this app in PHP and MySQL and it took me two weeks, but decided to see how fast I could get it done in Rails. I was able to get everything done in three days this time around. This was because I am a lot more experienced developer and Rails is a lot more productive than writing it from scratch PHP code.

I started with a CSV of Geo-encoded addresses. My first hang up was creating a seed file. In Rails with individual create statements it wraps each one in a transaction which is a save point for rolling back the database. As you can imagine this can be very slow for the amount of data I was dealing with, 68,000 rows. So I pulled out 1000 rows at a time from the CSV started a transaction, wrote some raw SQL in insert it into the database. This way if there was an error I would only have to look at that block of 1000 and wouldn't cause the whole data set to roll back.


[Demo](http://ffl-locator.herokuapp.com)
 |
[Github](https://github.com/zeisler/ffl_locator)
[![Site](/images/blog/ffl-locator.png)](http://ffl-locator.herokuapp.com)


