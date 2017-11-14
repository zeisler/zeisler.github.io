---
layout: post
title: Refactoring with Hash Defaults
description: 
category: refactoring
tags: [ruby hash refactoring]
comments: true
email_sign_up: true
---

I'm going to give you a primer on how to set default values when accessing non-existing keys. Then I'll give you some advice on how this could improve your code.

## Set default in the initializer

{% highlight ruby %}
h = Hash.new(:key_not_found)
h[:cat] 
#=> :key_not_found
{% endhighlight %}

## Set default on an instance

{% highlight ruby %}
h = { fish: 100 }
h.default
#=> nil
h.default = :default_key
h[:fish]
#=> 100

h[:dog]
#=> :default_key
{% endhighlight %}

Be aware if this is exposed as public API it may not do what end users are expecting, so either keep the hash with defaults set isolated or be very sure you think about the issues it could cause.

Side note don't depend on using `nil` as an indicator of a key not being present because if the value it's self is `nil` then your code has miss understood the meaning.

{% highlight ruby %}
h = { dog: nil }
h[:dog]
#=> nil
{% endhighlight %}

If you need to know if a key is realy present use `Hash#key?`.

{% highlight ruby %}
h = { dog: nil }
h.key?(:dog)
#=> true
{% endhighlight %}

That feels better.

### What about setting a proc
You can set the default to a proc, but that's not what you would want a proc for.

{% highlight ruby %}
h.default = proc do |hash, key|
  hash[key] = key + key
end
h[2]       #=> #<Proc:0x401b3948@-:6>
{% endhighlight %}

### default_proc
The first option looks the most natural to Ruby.

{% highlight ruby %}
# Option 1
Hash.new {|h,k| h[k] = k+k }
# Option 2
h.default_proc = proc do |hash, key|
  hash[key] = key + key
end
h[2]       #=> 4
h["cat"]   #=> "catcat"
{% endhighlight %}

## Why do you want to do this?
You can read this stuff for yourself in the Ruby documentation, but what I want to bring you is knowledge in how to apply these tools in your own code. 

### Refactor case statement to data structure.

Let's say we've got a method that returns the sales tax for a certain state. We know there is no sales tax in Oregon and that sales tax is higher in California and were making the assumption about the rest of the US.

{% highlight ruby %}
def sales_tax
  case state
  when "OR"
    0
  when "CA"
    0.10
  else
    0.05
  end
end
{% endhighlight %}

Moving things away from conditionals can make adding new branches easier. In some sense, this is removing branch logic from your code and you can think of the hash as data that your code uses as an input. If you're following a test-driven approach every line in your code should have test coverage, but you won't always test every possible out come from a data source.

So, let's put into practice what we just learned and see how it can help us refactor.

{% highlight ruby %}
SALES_TAX = Hash.new(0.05).merge!(
  { 
    "OR" => 0, 
    "CA" => 0.10 
  }
).freeze
SALES_TAX["CA"]
# => 0.1
SALES_TAX["NV"]
# => 0.05
{% endhighlight %}

Nice, we've setup a frozen constant that works the same as the case statement in the previous code.

An alternative to this is to keep the else condition, or better use `#fetch` with a default, but still move the specific cases into a data structure.

{% highlight ruby %}
SALES_TAX = { 
  "OR" => 0, 
  "CA" => 0.10 
}.freeze
  
def sales_tax
  SALES_TAX.fetch(state, 0.05)
end
{% endhighlight %}

This hash could get large and when it does you might want to move it to a YAML file. The goal here is to reducing churn of the Ruby file and separating data from logic. If you can make Ruby files unchanging it makes them more stable. When the data needs changing it can be changed independently of the code. If the YAML file was changing all the time I might consider moving that to a database leading to no churn in the repository.

The best solution depends on the use case. I give you the tools it's your responsibility to use them wisely. 

Code responsibly!

_Post edited 2017-11-14 to address [Reddit comments](https://www.reddit.com/r/ruby/comments/7cp207/refactoring_with_hash_defaults/)_