---
title: End-To-End Tests Suck
date: 2015-06-06
tags: testing TDD integration isolated
layout: post
comments: true
email_sign_up: true
---
End-to-end testing, if you let it, will suck the life out of you. Tools like [Capybara](https://github.com/jnicklas/capybara) and [PhantomJs](http://phantomjs.org/) provide an easy way to test from the user's prospective. When I started using these tools initially I didn't like how long they took to run. I thought then that if we could just make these tools faster they would be the best option to test a web app. Then I ran into other issues where sometimes these tests would be unreliable, failing at random times, making me feel uncertain of whether it was just the test's flakiness or the new feature I had just added. So I would end up adding `sleep` to give them a better chance of passing and sometimes I would end up deleting them because they were wasting my time. 

If you've found a way to make these test 99.99% reliable let me know, but even if we assume this is my lack of skill with the tools there are many reason why they can hurt you. When a failure happens, what type of information do you get and how does this help you fix the failure? 

You may have had text change that caused a failure that you were using as an anchor to say you've landed on the right page. Even if the behavior has not changed a failure presents, which can be annoying, but you change the text to the new copy and you're good to go.

A sign of a good test is its ability to pinpoint the place of failure so that it can be fixed. When an end-to-end test fails the reason could be anywhere in the stack. This it true especially in web frameworks like Rails, but this isn't even the worst reason why relying on end-to-end test is a bad idea.

You will need to write an exponential amount of tests to test all cases with end-to-end or even integration tests. You don't have the time to write all of those let alone run them. So you won't do it and you will have severally poor test coverage as a result. You will also be afraid to refactor and slow to add new features. Interwoven and coupled code that is hard to reason about and change is the result of end-to-end tests because there is a lack of positive design pressure. 

I have found the solution is to write isolated tests where tests run in less than a minute. Making your test suite fast and reliable. Interaction between other parts of the system can be done with interfaces/contracts. This along with TDD creates code that is easier to change and extend. TDD puts pressure on the design because you will feel the pain when code has too many dependencies.

Does this mean we should throw away browser testing all together? No, it can provide valuable feedback, but it should not be the first tests you write. Write the inner core of your application in isolation and test everything well. When you're ready to create the UI use browser testing as a tool for to test user interaction. This will greatly reduce the amount of tests because the core is so well tested you can focus on 'happy paths'. When working within the core of your app you can make changes without fear and run your tests in less than a minute. Then from time-to-time run another test suite that exercises your view and user interactions.

Your thoughts and feedback are welcome.

##References

####J. B. Rainsberger

Integrated Tests are a Scam 

* [Talk](https://vimeo.com/80533536)
* [blog](http://blog.thecodewhisperer.com/2010/10/16/integrated-tests-are-a-scam)

####Google

[Just Say no to More end-to-end tests](http://googletesting.blogspot.co.uk/2015/04/just-say-no-to-more-end-to-end-tests.html)

