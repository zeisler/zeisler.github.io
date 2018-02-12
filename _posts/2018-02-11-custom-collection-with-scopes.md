---
layout: post
title: Custom Ruby Scopes [Video]
category: Ruby
comments: true
email_sign_up: true
type: video
tags: [ruby rails active_record video]
video_link: https://youtu.be/dqU3IhYpyRc
---

[ActiveRecord Scopes][] can be nice to use and a useful way to think about data. 
Chaining methods together in logical filters to get the desired results without having to think about the structure of the data.
ActiveRecord is tided to doing database queries, but to do that you must have a database. Have you ever wanted use this kind of syntax on a set of custom in-memory objects or an array of hashes?
Now let's not let ActiveRecord have all the fun we can do the same thing in plain old Ruby and I'll show you how.

<iframe width="560" height="315" src="https://www.youtube.com/embed/dqU3IhYpyRc" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>


Here I've got an ActiveRecord Person, notice that it is singular because in ActiveRecord a Class represent a collection of people and a single person.
We can't very well just create new collections because the source is a single database instance.

{% highlight ruby %}
class Person < ActiveRecord::Base
  scope :minors, -> {...}

  scope :adults, -> {...}

  scope :tall, -> {...}

  scope :short, -> {...}
end

Person.tall.minors
# => <Relations ...>
{% endhighlight %}

In our Ruby world why not have many different collections instance we are not limited by a single database.
So in this example I have made a distinction between a collection of People and a single person. 

The People class, defined below, is going to represent the 
definition of collection of persons. Here I stub out some methods that I will define later just to get the shape of what the
classes interface is going to look like.

{% highlight ruby %}
class People
  def minors; end
  def adults; end
  def tall;   end
  def short;  end
end
{% endhighlight %}

Here is a person with the attributes of age and height. I set the `#to_s` method so that when the objects are sent to `#puts`
it displays more than just the object id, but lists out the attributes.

{% highlight ruby %}
class Person
  attr_reader :height, :age

  def initialize(age:, height:)
    @age    = age
    @height = height
  end

  def to_s
    "<#Person age: #{age}, height: #{height}>"
  end
end
{% endhighlight %}

I create the initializer so that it sets the collection array to an `attr_reader :to_a`. This will allow conversion of this object into a simple
array if need. First let's start with the create method. For this to have chainable methods ie. `People#adults#tall` each
method call needs to return a new instance of a People collection. Here I've filled out the operation needed to return
the desired result using `#reject` and `#select` on the Array of Persons. 

{% highlight ruby %}
class People
  attr_reader :to_a

  def initialize(collection = [])
    @to_a = collection
  end

  def minors
    create to_a.select { |person| person.age < 19 }
  end

  def adults
    create to_a.reject { |person| minors.to_a.include?(person) }
  end

  def tall
    create to_a.select { |person| person.height >= 5 }
  end

  private

  def create(collection)
    self.class.new(collection)
  end
end
{% endhighlight %}

Here I've created an array that will be used as the input into our new `People` class.

{% highlight ruby %}
person_array = [
  Person.new(
    age: 10, height: 4
  ),
  Person.new(
    age: 19, height: 4
  ),
  Person.new(
    age: 45, height: 6
  ),
  Person.new(
    age: 16, height: 5
  ),
  Person.new(
    age: 32, height: 5
  ),
]
{% endhighlight %}

{% highlight ruby %}
tall_people = People.new(person_array).tall
puts tall_people.to_a
# => [<#Person age: 45, height: 6>
#     <#Person age: 16, height: 5>
#     <#Person age: 32, height: 5>]
puts tall_people.minors.to_a
#=> [<#Person age: 16, height: 5>]
{% endhighlight %}

Check out the [ActiveEnumerable][] Gem for a DSL to do the same thing and a whole lot more ActiveRecord query like methods on custom Ruby Collections.

[ActiveRecord Scopes]: http://guides.rubyonrails.org/active_record_querying.html#scopes
[ActiveEnumerable]: https://github.com/zeisler/active_enumerable
