---
layout: post
title: 5 Testing Myths
description: 
category: testing
tags: [testing, myths, testing, TDD, isolated]
comments: true
email_sign_up: true
---

In my experience TDD is a guiding principle that produces better code that is a joy to write. There are several arguments for why the tradeoffs are not worth the benefit; I would like to address some of them here.

##1. Testing first slows you down

<blockquote><p> In my humble opinion the value that separates amateurs from professionals is that velocity is a direct function of quality. The higher the quality, the faster you go. The only way to go fast is to go well. Novices believe that quality and velocity are inverse. They think that hacking is fast. They haven't yet recognized what professional developers know all to well: that even a little bit of hacking is slower than no hacking at all.
Every time you yield to the temptation to trade quality for speed, you slow down every time.
</p> - <a href="http://butunclebob.com/ArticleS.UncleBob.VehementMediocrity">UncleBob</a></blockquote>

Given a feature that is not too complex testing-first could slow down pushing to production. In the short term this may feel like a negative, but in the long run it will end up taking longer than compared to test-first. For example when changes are needed or bugs need fixing you will have lost context of the feature. Causing you to have to debug and remember what the code was doing. Finding bugs later results in a slow feedback cycle that is inefficient. Comparing that with test-first, bugs can be found quickly in a short feedback cycle before they become bugs in production.

* The best way for me to learn a new language or framework is to do it by TDD. It removes the magic from what is happening. Even better is to pair with someone while doing TDD.
 
* It helps me focus on the single thing that I am trying to solve and I receive rapid repeatable feedback once I have completed a task. 


##5. Changing the system requires re-writing tests

Once you have a large number of tests, some have argued changing the system requires re-writing some or all of your tests. If you were using TDD you would make those changes after you write new tests, avoiding this problem. If your system is so woven together where making one change causes cascading test failures you have a design failure. I would suggest becoming more familiar with object-oriented principles like [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)).

