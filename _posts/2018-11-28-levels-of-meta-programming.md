---
layout: post
title: Levels of Meta-programming in Ruby
category: Ruby
comments: true
email_sign_up: true
tags: [ruby meta-programming]
published: false
---

I use meta-programming very carefully and rarely, but I generally like this one because you can clearly see the methods and it can be searched for easily while still having one symbol as the lookup reducing duplication and typos. I will refer to this as **level 1 meta programming**.

This is in contrast to what I think you might be referencing:

**meta-programming level 3**

{% highlight ruby %}
class Position

  def method_missing(meth)
    row.fetch(meth){ super }
  end
  
end
{% endhighlight %}

{% highlight ruby %}
Position = Struct.new(:job_type, : code, :department, keyword_init: true) do
  #... code 
end
{% endhighlight %}

While this is concise you can't search for the method; you can't inspect the methods in an pry session. This is completely run-time dependent you throw methods at it and it will either succeed or fail.

Another slightly improved way is this:

**meta-programming level 2**

{% highlight ruby %}
class Position

  [:job_type, : code, :department].each do |meth|
    define_method(meth) { row.fetch(__method__, nil) }
  end

end
{% endhighlight %}

This pattern lets you predefine the methods at compile time allowing you to inspect methods in a pry session, but does not allow you to as easily search for the methods with `def job_type_code`. You can search for just `job_type_code`, but you'll find more than just methods, so this way is less precise.

**meta-programming level 0**

{% highlight ruby %}
class Position
  def job_type
     row.fetch(:job_type, nil)
  end
  
  def code
    row.fetch(:code, nil)
  end
  
  def department
    row.fetch(:department, nil)
  end
end
{% endhighlight %}

Level 0 has no magic the max duplication and is fully searchable and inspectable. It's easy to understand, but at the cost of duplication and possible errors.

Level 1, which is the middle ground I've come to between levels 0 and 2. It fully searchable and inspectable, but it reduces duplication at a reasonable cost.

In this table I have scored each level of abstraction by three important metrics, a higher number means it has more of that metric, which is good for searchable and inspectable, but sometimes not so good for duplication. (With 5 being the highest)

|-------------------+---------------+---------------+---------------|
| meta programming 	| searchable 	| inspectable 	| duplication 	|
|-------------------+---------------+---------------+---------------|
| level 3          	| 0          	| 0           	| 0           	|
| level 2          	| 1          	| 5           	| 1           	|
| level 1          	| 5          	| 5           	| 3           	|
| level 0          	| 5          	| 5           	| 4           	|


{% highlight ruby %}

Postion = Struct.new(:name, :address, keyword_init: true) do
  def greeting
    "Hello #{name}!"
  end
end
{% endhighlight %}
