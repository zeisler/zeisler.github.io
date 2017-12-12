---
layout: post
title: Refactoring Towards Immutable Objects in Ruby [Video]
description: 
category: Refactoring
tags: [mutable ruby refactoring video]
comments: true
email_sign_up: true
---

Learn how to refactor from a mutable object into an immutable one while still being able to make changes to state. 
I’ll start with an Account class and show how you would let it emit new objects instead of changing the previous one.
 I walk step by step through the refactor process and talk about its possible advantages.

<iframe width="560" height="315" src="https://www.youtube.com/embed/IIG8oDf4iz8" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>

{% highlight ruby %}
class Account
  attr_reader :name, :balance

  def initialize(balance:, name:)
    @balance = balance
    @name    = name
  end

  def deposited(amount)
    updated(balance: @balance + amount)
  end

  def withdrawn(amount)
    updated(balance: @balance - amount)
  end

  private

  def updated(balance: balance, name: name)
    Account.new(balance: balance, name: name)
  end
end

account = Account.new(balance: 100, name: "Checking")
account2 = account.deposited(100)
account3 = account2.withdrawn(99)
puts account.balance
puts account3.balance
{% endhighlight %}

[Retweet Post](https://twitter.com/intent/retweet?tweet_id=940461542880854016)
