---
layout: post
title: Custom Collections with scopes
category: Ruby
comments: true
email_sign_up: true
type: video
tags: [ruby rails active_record]
---
[ActiveRecord Scopes][] can be nice to use and a useful way to think about data. 
Chaining methods together in logical filters to get the desired results without having to think about the structure of the data.
ActiveRecord is tided to doing database queries, but to do that you must have a database. Have you ever wanted use this kind of syntax on a set of custom in-memory objects or an array of hashes?
Now let's not let ActiveRecord have all the fun we can do the same thing in plain old Ruby and I'll show you how.

Here I've got an ActiveRecord Person, notice that it is singular because in ActiveRecord a Class represent a collection of people and a single person.
We can't very well just create new collections because the source is a single database instance.
{% ruby collection_scopes/people_active_record.rb %}

In our Ruby world why not have many different collections instance we are not limited by a single database.
So in this example I have made a distinction between a collection of People and a single person. 

The People class, defined below, is going to represent the 
definition of collection of persons. Here I stub out some methods that I will define later just to get the shape of what the
classes interface is going to look like.
{% ruby collection_scopes/people_stub_methods.rb %}

Here is a person with the attributes of age and height. I set the `#to_s` method so that when the objects are sent to `#puts`
it displays more than just the object id, but lists out the attributes.

{% ruby collection_scopes/person.rb %}

I create the initializer so that it sets the collection array to an `attr_reader :to_a`. This will allow conversion of this object into a simple
array if need. First let's start with the create method. For this to have chainable methods ie. `People#adults#tall` each
method call needs to return a new instance of a People collection. Here I've filled out the operation needed to return
the desired result using `#reject` and `#select` on the Array of Persons. 
{% ruby collection_scopes/people.rb %}

Here I've created an array that will be used as the input into our new `People` class.
{% ruby collection_scopes/person_array.rb %}

{% ruby collection_scopes/people_example.rb %}

Check out the [ActiveEnumerable][] Gem for a DSL to do the same thing and a whole lot more ActiveRecord query like methods on custom Ruby Collections.

[ActiveRecord Scopes]: http://guides.rubyonrails.org/active_record_querying.html#scopes
[ActiveEnumerable]: https://github.com/zeisler/active_enumerable
