The ablity to writing end-to-end browser tests is really amazing. Tools like [Capybara](https://github.com/jnicklas/capybara) and [phantomjs](http://phantomjs.org/) provide an easy way to test from the users prospective. When I started using these tools firstly I really didn't like how long they took run. I thought then if we could just make these tools faster they would be the best option to test a web app. Then I ran into other issues where sometimes these tests would be unreliable, failing at random times making me feel uncertian whether it was just the test's flakiness or the new feature I just added. So I would end up adding `sleep`  to give them a better chance of passing and sometimes I would end up deleting them because they were wasting me time. 

If you've found a way to make these test 99.99% reliable let me know, but let assume that this is just make lack of skill with the tools. When a failure happens what type of information do you get and how does this help you fix the failure? 

You may of had text change that caused a failure that you were using as an anchor to say you've landed on the right page. Even if the behavior has not changed a failure presents, which can be annoying, but you change the text to the new copy and you're good to go.

A sign of a good test it's ablity to pin-point the place of failure so that it can be fixed. When an end-to-end test fails it could be any where in the stack and finding where the error is can be difficult. This it true especially in web frameworks like Rails, but this isn't even the worst reason why relying on end-to-end test is a bad idea.

You will need to write an exponitional amount of tests to test all cases with end-to-end or even integration tests. You don't have the time to write all those let alone run them. So you won't do it and you will have severly poor test coverage as a result. You will also be afraid to refactor and add slow to add new features. 

Interwoven and coupled code that is hard to reason about and change is the result of end-to-end tests because there is a lack of design pressure that is put there when testing code in isolation. I have found the solution is to write isolated tests where tests run in less than a minute. Tests become fast and reliable. Interaction between other parts of the system can be done with interfaces/contracts. This along with TDD this creates code that is easier to change and extend. TDD puts presure on the design because you will feel the pain when code has too many dependencies.

Does this mean we should through away browser testing all toghether? No, it provide can valuable feedback, but it should not be the first tests you write. Write the inner core of your application in isolation and test everything well. Then when your ready use browser testing as a tool to test the user interaction. Make these tests seperate from the core test suite. When working within the core of your app you can make changes without fear and run your tests in less than a minute. Then from time to time run the tests that exercise your view and user interactions.

Your thoughts and feedback are welcome.

##References
###J. B. Rainsberger
Integrated Tests are a Scam 
* [Talk](https://vimeo.com/80533536)
* [blog](http://blog.thecodewhisperer.com/2010/10/16/integrated-tests-are-a-scam)

###Google

[Just Say no to More end-to-end tests](http://googletesting.blogspot.co.uk/2015/04/just-say-no-to-more-end-to-end-tests.html)