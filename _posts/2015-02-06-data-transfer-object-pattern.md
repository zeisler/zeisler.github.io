---
title: Data Transfer Object Pattern
date: 2015-02-06
tags: testing programming patterns
layout: post
comments: true
tags: ruby objects
---


I have been discovering a new design pattern that leads to well designed interface and loosely coupled test. This design, as with many patterns, is not best in all cases but I found it very helpful on multiple occasions. I find the cases where it works best is when there is a [deterministic algorithm](http://en.wikipedia.org/wiki/Deterministic_algorithm).

It's best to start out with a class that has a single focus then give it one public method named `call`. All internal logic will be in the private methods. The method call will return and instance of a response class that is publicly defined with-in the class. This object will have no logic, but that which defines it's data structure. This is called a [Data Transfer Object
](http://martinfowler.com/eaaCatalog/dataTransferObject.html) or a [ValueObject
](http://martinfowler.com/bliki/ValueObject.html). It's main purpose will be to define an outline of data for other dependent classes to consume. In its base form it can be a plain Ruby object with `attr_accessors` values (I also use the [Virtus](https://github.com/solnic/virtus) gem). It can be represented as a `Hash`, but it should not first be a `Hash` because it will lose all definition as an interface. Keep the object definition hard rather than soft so that when it changes it will effect dependent code. Because this response class is public, it can be used with stub data when testing another object that depends on this initial class. This skips any expensive computation and object setup that should already be tested.

<blockquote><p>Tests run fastest when they execute the least code and the volume of external code that a test invokes is directly related to your design. An application constructed of tightly coupled, dependent-laden objects is like a tapestry where pulling on one thread drags the entire rug along. When tightly coupled objects are tested, a test of one object runs code in many others. ...would then create a large network of objects, any of which might break in a maddeningly confusing way.</p>- Sandi Metz, Practical OO Design in Ruby, page 204</blockquote>

{% highlight ruby %}
class ExpensiveComputation
  def initialize(setup)
    @setup = setup
  end

  def call
    Response.new(attr_a: compute_a, attr_b: compute_b)
  end

  class Response
    attr_accessor :attr_a, :attr_b

    def initialize(attr_a:, attr_b:)
      @attr_a = attr_a
      @attr_b = attr_b
    end
  end

  private

  def compute_a
    #logic
  end

  def compute_b
    #logic
  end
end
{% endhighlight %}

Using RSpec I would do the following

{% highlight ruby %}
RSpec.describe OtherClass do

  before do
    allow_any_instance_of(ExpensiveComputation).to receive(:call)
    .and_return(ExpensiveComputation::Response.new(attr_a: 12_000, attr_b: false))
  end

end
{% endhighlight %}

And make sure you turn on [Rspec's verify double](https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles) feature, this will ensure that stubbing out the class's call method will not create mock drift and take heed Sandi Metz warning in this case.

<blockquote><p>You have created an alternate universe, one in which tests cheerfully report that all is well despite the fact that the application is manifestly incorrect. The possibility of creating this universe is what causes some to warn that stubbing (and mocking) makes for brittle tests. However, as is always true, the fault here is with the programmer, not the tool. Writing better code requires understanding the root cause of this problem, which in turn necessitates a closer look at its components.</p>- Sandi Metz, Practical OO Design in Ruby, page 211</blockquote>

The two alternatives to this approach are to stub a method on the dependent class and dependency injection. I will go over why these both can lead to either more testing or a lack of testing.

### Stubbing the dependent class's method
{% highlight ruby %}
class OtherClass
  def expensive_calculation_dependency
    ExpensiveComputation.new.call
  end
end
{% endhighlight %}

{% highlight ruby %}
RSpec.describe OtherClass do
  subject{ described_class.new }

  before do
    allow(subject).to receive(:expensive_calculation_dependency)
    .and_return(ExpensiveComputation::Response.new(attr_a: 12_000, attr_b: false))
  end
end
{% endhighlight %}

In this case I know that the data structure coming from the `ExpensiveComputation`'s `Response` class is stubbed correctly, but what I have missed is the interface to `ExpensiveComputation`. See, I have forgotten to given the needed arguments to `ExpensiveComputation`'s initializer. Because I have not tested the link to the classes interface, but instead stubbed over it, I get "test-passing-code-failing".

### Dependency Injection
{% highlight ruby %}
class OtherClass
  attr_reader :expensive_computation

  def initialize(expensive_computation: ExpensiveComputation)
    @expensive_computation = expensive_computation
  end


  def expensive_calculation_dependency
    expensive_computation.new.call
  end
end
{% endhighlight %}

{% highlight ruby %}
RSpec.describe OtherClass do
  before do
    class ExpensiveComputationDouble
      def initialize(*)
      end

      def call
        ExpensiveComputation::Response.new(attr_a: 12_000, attr_b: false)
      end
    end
  end

  subject{ described_class.new(expensive_computation: ExpensiveComputationDouble) }
end
{% endhighlight %}

Now I have a double that represents the interface of `ExpensiveComputation`. What happens when the interface changes? Sadly, this is another case of "test-passing-code-failing". The solution to this is to create a test that defines `ExpensiveComputation`'s interface and test both the real object and the fake. While this may be the right choice for some cases ,I find it to be extra unnecessary code.

###The Class as the interface
The solution is to use the class's definition as the interface. To accomplish this, it's best that the initializer do no work but only setup instance variables so that it can be initialized easily with sub data. Use the data transfer pattern or just stub methods on the instance using RSpec verify double feature. Limitations of RSpec verify feature is that it does not verify method parameters. With this its good to use the real initializer to do most of the work and only take parameters in the instances methods, if absolutely necessary. This is good design principal for OO anyways.

I have only been using this pattern for a short time am interested in knowing what others experiences are with the Data Transfer Object pattern.


#### Additional Info
[Values in Object Systems by Dirk Riehle](http://dirkriehle.com/computer-science/research/1998/ubilab-tr-1998-10-1.html)
