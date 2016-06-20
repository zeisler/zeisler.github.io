---
layout: post
title: Managing Global State In The Context of a Web Request 
description: How to create and managing global state for the for the life of a request in ruby.
category: 
tags: [ruby, threads, web, rails]
---

I’m going to be talking about the global state in the context of a web request. When a request comes in it will be running within a thread. That thread exists for the life of the request. If you want to store some state in the context of that thread you can use thread local variables. 

{% highlight ruby %}
 Thread.current["name"] = "A"
{% endhighlight %}

[ruby-doc.org](http://ruby-doc.org/core-2.3.1/Thread.html#method-i-5B-5D)

Then, anywhere within that request the key, "name" can be accessed and in another request "name" can have a different value without effecting any other threads/requests. A real example of why you would want to do this is logging. When you have a request id that gets generated per request it would be helpful to have that as context whenever logging some bit of info. So that you can know what log entry has to do with which request.

This is the way Rails and other web frameworks have accomplished this task. It uses a piece of Rack middleware to set a thread local variable to then be retrieved whenever a logging event occurs.

See [ActionDispatch::RequestId](https://github.com/rails/rails/blob/51a759a745b065b335a0c8f49439118ac8e04586/actionpack/lib/action_dispatch/middleware/request_id.rb#L19) and
[ActiveSupport::TaggedLogging](https://github.com/rails/rails/blob/52ce6ece8c8f74064bb64e0a0b1ddd83092718e1/activesupport/lib/active_support/tagged_logging.rb)

This solution works great for most common use cases, but if you spin up your own threads in a request the thread local variable state will not transfer to child spawned threads. The state will need to be copied to the new thread instance in order to retain the same logging context as the parent thread. It’s usually helpful when 'Things Just Work'™ and you or a team of developers do not need to remember to add special code that only applies to your specific stack. Besides that, in code that you don’t own like third party Gems, you can’t go in and change their code directly.  In comes Thread Inheritable Attributes, it provides an API to set thread local variables that then get inherited by any child spawned threads. Problem solved. 


{% highlight ruby %}
require "thread/inheritable_attributes"

Thread.current.set_inheritable_attribute(:request_id, SecureRandom.uuid)

thread = Thread.new {
          Thread.current.get_inheritable_attribute(:request_id)
        }
thread.join
thread.value
  #=> "80f58e0f-0564-487d-8f92-4cff8237af24"
{% endhighlight %}

This Gem is production ready. Used in multiple production environments since the beginning of 2016 without issues.

[Github Repo](https://github.com/zeisler/thread-inheritable_attributes)

**Update 2016-6-20**

In the context of a multi-threaded web server anything stored on `Thread.current#[]` could hang around to subsequent requests. This is because some multi-threaded web server will reuse a thread after a request is complete.
I have made [request_store](https://github.com/steveklabnik/request_store) is an optional dependency. It will clear it's state at the end of a request. Unless your are manually reinitializing or clearing the state in your own Rack Middleware (at the start of a request) it is recommended that you also include the request_store gem.

-------

To learn more about Threads in Ruby I highly recommend the book ["Working with Ruby Threads" - by Jesse Storimer](https://pragprog.com/book/jsthreads/working-with-ruby-threads) 

-------
