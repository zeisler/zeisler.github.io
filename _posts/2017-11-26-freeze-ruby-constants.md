---
layout: post
title: Freeze Ruby Constants
description:
category: ruby
tags: [ruby best-practices]
comments: true
email_sign_up: true
---

An intro video to Ruby constants their enforcement pitfalls and how to fix them and why you should care in your code.

<iframe width="560" height="315" src="https://www.youtube.com/embed/7-gTux21c_U?rel=0" frameborder="0" allowfullscreen></iframe>

> In computer programming, a constant is a value that cannot be altered by the program during normal execution, i.e., the value is constant. - [Wikipedia](https://en.wikipedia.org/wiki/Constant_(computer_programming))

This is what happens in Ruby when redefining a constant with another object. 

{% highlight ruby %}
A_CONST = :first_value 
A_CONST = :new_value 
{% endhighlight %}

It outputs a warning.

{% highlight ruby %}
warning: already initialized constant A_CONST
{% endhighlight %}

If you’re not paying attention to warnings in Ruby then enforcing constants is not possible. I would recommend that you listen to this warning and fix them when they come up. 

If the constant is attempted to be reassigned dynamically for example with a method this is not just a warning, but a syntax error.

{% highlight ruby %}
def hello
  A_CONST = 2
end
SyntaxError: dynamic constant assignment
A_CONST = 2
         ^
{% endhighlight %}

It can still be done dynamically it just needs different syntax, but this will also produce a runtime warning.
{% highlight ruby %}
Object.const_set(:A_CONST, 3)
warning: already initialized constant A_CONST
warning: previous definition of A_CONST was here
{% endhighlight %}

## When Warnings Are Not Enough

{% highlight ruby %}
COMPANY_OWNER = "Dustin Zeisler"
{% endhighlight %}

What happens when some code is written while not paying attention and does a destructive action on the String? 
{% highlight ruby %}
COMPANY_OWNER.gsub!("i", "")
#=> "Dustn Zesler"
COMPANY_OWNER
#=> "Dustn Zesler"
{% endhighlight %}

The String object is still technically the same object, so no Ruby warnings will happen. This does not meet the expectation of what a constant value should be. Is there anything that we can do about it? Glad you asked this is where `#freeze` comes in.

{% highlight ruby %}
COMPANY_OWNER = "Dustin Zeisler".freeze

COMPANY_OWNER.frozen?
#=> true

COMPANY_OWNER.gsub!("i", "")
RuntimeError: can't modify frozen String
{% endhighlight %}

If this is not a common mistake you feel you are going to make it also has performance improvements, see [www.sitepoint.com/unraveling-string-key-performance-ruby-2-2](https://www.sitepoint.com/unraveling-string-key-performance-ruby-2-2).

### Note: Alternative for String#freeze
----------
> With the release of Ruby 2.3, strings can be frozen by default without the use of #freeze. By adding the following magic comment at the top of a file all string literals will default to frozen.
- [til.hashrocket.com](https://til.hashrocket.com/posts/7b306cafde-defaulting-to-frozen-string-literals)
{% highlight ruby %}
# frozen_string_literal: true
{% endhighlight %} 

----------


Other common mutable objects in Ruby are Hash and Array. If these objects are being set as a constant I would recommend also freezing them.

There is no built-in way to unfreeze an object, but if you really want to here is a [StackOverflow](https://stackoverflow.com/a/35633368/3251319) post on how to do it.

If you like this sort of thing subscribe to get new posts delivered directly to your inbox.

