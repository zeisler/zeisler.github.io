---
layout: post
title: The Power of Ruby Structs
category: Ruby
comments: true
email_sign_up: true
tags: ruby objects
published: true
image:
  alt: Ruby String.new(:name)
  link: /images/blog/struct-new.png
---

I invite you to explore beyond ActiveRecord models and into the world of PORO (Plain Old Ruby Objects). These are the building block of any Object Oriented Language and especially Ruby. I’m going to focus on Value Objects, which holders of some collection of data or attributes. The collection could model a person, an account, an address, or more abstractly an error, and many more. You should keep in mind as a general principle that these objects should have a well-defined purpose or identity and contain no more information than what is needed.

A simple and common way to pass around a collection of attributes is with a Hash. It's flexible for taking any number of key-value pairs created with ease and manipulatable. It can be passed back and forth between objects. So why would want to use anything else? The ability to decouple different parts of the code and get a quicker understanding of objects being passed around. All the of these also can lead to better truthful tests. For example, if there is one part of the code responsible for populating a Hash, that represents a person and another part that takes it as an input. If you were testing those two parts in isolation, you'd have one test that asserts that object 1 emmets the correct Hash. You'd commonly copy and paste that person Hash into the next test of object 2. The test would pass all is good. Then a feature request comes along that requires changing the key name in the person Hash and because it was a copy and paste job object 2 test still passes, but then you run it in production and things are broken. If you would have instead used a defined object like a Struct changing its interface would have given you feedback in all the place it was used. This sets up an interface object between any interacting objects.

The simplest way to get started, and which also happens to be the most flexible, is with an initializer and attr_readers.

## Handwritten Version

{% highlight ruby %}
class Person
  attr_reader :name, :age

  def initialize(name:, age:)
    @name = name
    @age  = age
  end
end

person = Person.new(name: "Dave", age: 29)
puts person.name
#=> "Dave"
{% endhighlight %}

With this version, you are in control of everything, and you can see exactly what is happening, nothing is hidden behind some particular DSL. If you want to make a keyword optional def initialize(name:, age: nil) you can add a default argument of nil or any other value that makes sense as a default.

## Struct

The next Ruby construct I want to talk about is [`Struct`](https://ruby-doc.org/core-2.5.1/Struct.html). It removes some of the boilerplate necessary in the handwritten version.

{% highlight ruby %}
Person = Struct.new(:name, :age)
Person.new("Dave", 29)
{% endhighlight %}

Wow, that's a lot less code! In the past, I've passed on using Struct because it only supported positional arguments, which I find less clear and harder to refactor in the future.

### With Keyword Arguments

But a new feature is available `keyword_init: true`.

{% highlight ruby %}
Person = Struct.new(:name, :age, keyword_init: true)
Person.new(name: "Dave", age: 29)
{% endhighlight %}

Sadly we lose the feature of required keywords, they all work as being optional.

{% highlight ruby %}
person = Person.new(age: 29)
puts person
#=> nil
{% endhighlight %}

Then again we gain a lot of other features, all of which are possible in the Handwritten version, but with a whole lot less code. I'm going to go through some more included features and show you how to add these feature in the Handwritten version.

### Inspectable
{% highlight ruby %}
puts Person.new(name: "Dave", age: 29)
#=> #<struct Person name="Dave", age=29>
{% endhighlight %}

Compare that to our handwritten version `#<Person:0x00007fe0650913f0>`. Not very readable or useful in most cases. Of course, there is a way to overwrite this string representation by defining your own `#to_s`.

{% highlight ruby %}
class Person
  attr_reader :name, :age

  def initialize(name:, age:) ... end

  def to_s
    "#<Person name=#{name.inspect}, age=#{age.inspect}>"
  end
end
{% endhighlight %}

Results in:

{% highlight ruby %}
#<Person name="Dave", age=29>
{% endhighlight %}

### Enumerable

#### Each

Yields the value of each struct member in order.

{% highlight ruby %}
joe = Person.new(name: "Dave", age: 29)
joe.each {|x| puts(x) }
#=> "Dave"
#=> 29
{% endhighlight %}

The Handwritten version would require you to write a conversion method `#to_h`.

{% highlight ruby %}
class Person
  attr_reader :name, :age

  def initialize(name:, age:) ... end

  def to_h
    { name: name, age: age }
  end
end
{% endhighlight %}

From there you could call `#to_h` and that would enable you to invoke all enumerable methods or to include the Enumerable module and also define an `#each` method if want direct access to call these methods.

{% highlight ruby %}
class Person
  include Enumerable
  attr_reader :name, :age

  def initialize(name:, age:) ... end

  def to_h ... end

  def each
    to_h.each(yield)
  end
end
{% endhighlight %}

The `#each` method delegates to the hash version of the object. You could also refactor that to use the `Forwardable` module.

#### Each Pair

Yields the name and value of each struct member in order.

{% highlight ruby %}
Person = Person.new(:name, :address, :zip, keyword_init: true)
joe = Person.new(name: "Joe Smith", address: "123 Maple, Anytown NC", zip: 12345)
joe.each_pair {|name, value| puts("#{name} => #{value}") }
#=> name => Joe Smith
#=> address => 123 Maple, Anytown NC
#=> zip => 12345
{% endhighlight %}

### Equality


Here's an example from the Ruby documentation showing how the comparison works with Structs.

{% highlight ruby %}
Customer = Struct.new(:name, :address, :zip)
joe   = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
joejr = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
jane  = Customer.new("Jane Doe", "456 Elm, Anytown NC", 12345)
joe == joejr   #=> true
joe == jane    #=> false
{% endhighlight %}

This is how you would add that feature to your own handwritten object by defining the spaceship operator `#<=>` and including the `Comparable` module.

{% highlight ruby %}
class Person
  include Comparable
  attr_reader :name, :age

  def initialize(name:, age:) ... end

  def to_h ... end

  def <=>(other)
    to_h <=> other.to_h
  end
end
{% endhighlight %}

### Adding Methods
{% highlight ruby %}
Customer = Struct.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end
Customer.new("Dave", "123 Main").greeting  #=> "Hello Dave!
{% endhighlight %}

This is the recommended way to customize a struct. Subclassing an anonymous struct creates an extra anonymous class that will never be used.

### Members

Here is a bonus trick. If ever have a larger set of data and you want to selectively pull from it without individually referencing each key `#members` could be useful.


 If I try to put more than what this struct expect I get an argument error. (Remember that keywords and hashes are interchangeable)

{% highlight ruby %}
Person.new(name: "Dave", age: 28, address: "1001 S Main St")
#=> unknown keywords: address (ArgumentError)
{% endhighlight %}

So here is the brute force method of only inputting the attributes that are relevant.

{% highlight ruby %}
person_hash = { name: "Dave", age: 28, address: "1001 S Main St" }
Person.new(name: person_hash[:name], age: person_hash[:age])
{% endhighlight %}

In most simple cases you'll want to use this approach even though it more verbose than the next example.

And now the dynamic method.

{% highlight ruby %}
person_hash = { name: "Dave", age: 28, address: "1001 S Main St"}
Person.new(person_hash.select{|k,_| Person.members.include?(k)})
{% endhighlight %}

You can do the same thing with the Handwritten version by grabbing the method proc and getting its parameters.

{% highlight ruby %}
members = Person.instance_method(:initialize).parameters.map(&:last)
puts members
#=> name
    age

Person.new(person_hash.select{|k,_| members.include?(k)})
{% endhighlight %}

It works, but who wants to see that kind of code in their project?

If you have any thoughts on Ruby Structs or the handwriting versio feel free to leave a comment.
