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

Given a feature that is not too complex testing-first could slow down pushing to production. In the short term this may feel like a negative, but in the long run it will end up taking longer than compared to test-first. For example when changes are needed or bugs need fixing you will have lost context of the feature. Causing you to have to debug and remember what the code was doing. Finding bugs later results in a slow feedback cycle that is inefficient. Comparing that with test-first, bugs can be found quickly in a short feedback cycle before they become bugs in production.With a more complex feature testing first will almost always make you faster, in  the long term and the short term. If a feature has parts A, B and C once you get to C you may of created a regression in part A. The only way you know this is to back track and manually test part A again, slowing you down. When you have a failure you will not necessarily know where the source of the issue is, causing you to debug the problem. If you created good tests in the first place a failing test will point you to the problem allowing you to fix it faster.##2. Writing tests later is just as goodIt is much harder to have quality test coverage when you add tests after the fact. Test coverage is more than 'did this line execute' because one line can have many scenarios. In TDD you write a test that fails and only write enough production code to make that test pass even if it's just returning the result you are expecting. Then when you write the next test scenario the code will need to become only as complex as needed to pass that test, and so on, leaving all sequential scenarios to have test coverage. If you don’t focus on testing at the codes inception you will write code that is not as easy to test. Testing puts pressure on design to make it isolated where writing code without test constraints will lead to highly coupled designs. Resulting in code that is hard to change and tests that are slow to run because it involve many parts of the system at once.##3. It makes programming more complicated

* The best way for me to learn a new language or framework is to do it by TDD. It removes the magic from what is happening. Even better is to pair with someone while doing TDD.
 
* It helps me focus on the single thing that I am trying to solve and I receive rapid repeatable feedback once I have completed a task. * In my experience TDD, done with care, will reduce complicated code. I've seen a lot more cases of code that was not test driven that was hard to understand. 
##4. It's not necessary to test plumbingOne example is a business logic class that needs to be initialized and passed its dependencies in a controller. I would ask the following questions: What is the cost of not testing the code? What will the costs be if the code fails? How likely is a failure? I think all code needs at least some basic test coverage, but at some points it's matter of [ROI](https://en.wikipedia.org/wiki/Return_on_investment). If you know the parts of your system are well tested the integration points may only need [happy paths](https://en.wikipedia.org/wiki/Happy_path) or [smoke tests](https://en.wikipedia.org/wiki/Smoke_testing_(software)). To know your code is well tested create contract tests that don't test the actual integration but tests the interface against each side of the integration.

##5. Changing the system requires re-writing tests

Once you have a large number of tests, some have argued changing the system requires re-writing some or all of your tests. If you were using TDD you would make those changes after you write new tests, avoiding this problem. If your system is so woven together where making one change causes cascading test failures you have a design failure. I would suggest becoming more familiar with object-oriented principles like [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)).

####I would love to continue this discussion and hear what your experiences are.