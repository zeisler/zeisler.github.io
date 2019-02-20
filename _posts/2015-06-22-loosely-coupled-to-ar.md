---
layout: post
title: Loosely Coupled to ActiveRecord
description: 
category: rails
email_sign_up: true
comments: true
tags: testing refactoring ruby rails active record
---


Rails ActiveRecord ORM is a great abstraction on top of SQL, but littering it throughout your code can lead to issues. The amount of methods from inheriting from AR is extensive and many of those are added at run time after a round trip to the database. So it is best not to add to this API with your own decorator methods or business logic. Anything you add to AR should follow it's responsibility of querying the database. I would like focus on how to narrow the API, but also extend behavior.

Let's take a very simple example and build upon it. We have a User class that has attributes first_name and last_name. You might start by adding a method to concat these together with a full_name.

{% highlight ruby %}

class User < ActiveRecord::Base
	
  def full_name
    "#{first_name} #{last_name}"
  end
	
end

{% endhighlight %}

This method is for some specific use case, maybe to go into an ERB template, but what happen when you want that to have a middle name one place or you want the last name first? These changes go cascading throughout the system it would be better to make a decorator for a specific use case.

### Delegator Pattern

{% highlight ruby %}

class UserForDisplay < SimpleDelegator
	
  def full_name
    "#{first_name} #{last_name}"
  end
	
end

UserForDisplay.new(user).full_name

{% endhighlight %}

The AR is passed into the decorator, using Ruby's [SimpleDelegator](http://ruby-doc.org/stdlib-2.1.0/libdoc/delegate/rdoc/SimpleDelegator.html), and now is extended to have extra attributes. There can be drawbacks to this approach, the first being that `UserForDisplay` now has the entire API of the AR model plus it's own additional methods. It's generally best to limit your API instead of expanding it. The benefits are that you can use it in your current use case with modifying the User class, isolating the API expansion.

### Explicit Delegation

{% highlight ruby %}

class UserForDisplay

  def initialize(user: user)
    @user = user
  end
  
  extend Forwardable
  def_delegators :user, :first_name, :last_name
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  private
  attr_reader :user
	
end

UserForDisplay.new(user).full_name

{% endhighlight %}

With this method the display class only has the API that is needed for the use case. This is done using Ruby's [Forwadable](http://ruby-doc.org/stdlib-2.1.0/libdoc/forwardable/rdoc/Forwardable.html). It can be more work, but in the long run keeping your API's as small as possible makes changes lower down in the AR models easier because the AR API is limited only what is needed.


###Value Object
 
{% highlight ruby %}

class UserForDisplay

  def self.create(user: user)
    DisplayUser.new(first_name: user.first_name, 
                    last_name:  user.last_name)
  end
  
  class Value
  
    attr_reader :first_name, :last_name
    
    def initialize(first_name:, last_name:)
      @first_name, @last_name = first_name, last_name
    end
    
    def full_name
      "#{first_name} #{last_name}"
    end
    
  end
	
end

UserForDisplay.create(user).full_name

{% endhighlight %}

This has the benefit being able to exist without having an ActiveRecord instance present, i.e. while writing tests. You are drastically reducing the surface of the API away from ActiveRecord. You can see directly what methods are defined there is no meta programming and it can be used with out running rails or talking to a database. 

I have only focused on how to deal with one record instance at a time and have not even touched on how to contain the class methods for returning collections of record, but that will have to wait for another time.






