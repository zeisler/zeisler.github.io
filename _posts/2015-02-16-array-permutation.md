---
title: Array Permutation
date: 2015-02-16
tags: ruby array
layout: post
comments: true
email_sign_up: true
---

When invoked with a block, yield all permutations of length n of the elements of the array, then return the array itself.

If n is not specified, yield all permutations of all elements.

The implementation makes no guarantees about the order in which the permutations are yielded.

If no block is given, an Enumerator is returned instead.

Examples:
{% highlight ruby %}
a = [1, 2, 3]
a.permutation.to_a    #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
a.permutation(1).to_a #=> [[1],[2],[3]]
a.permutation(2).to_a #=> [[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]]
a.permutation(3).to_a #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
a.permutation(0).to_a #=> [[]] # one permutation of length 0
a.permutation(4).to_a #=> []   # no permutations of length 4
{% endhighlight %}

[Ruby Docs](http://ruby-doc.org/core-2.2.0/Array.html#method-i-permutation)

I have had a few times where I wanted to test something where I need all combination of items. Thinking of those combination by your self can be cumbersome.

Here is contrived example where we have `#add` that takes two arguments. Since permutation will return an Enumerator we can each through the permutations. This lazy operation is helpful because to calculate all of these permutations before hand is time consuming and if the exception fails on the first iteration or somewhere in the middle that is known right way instead of waiting for all permutations to be calculated and then getting failures.
{% highlight ruby %}
def add(arg1, arg2)
  arg1 * arg2
end
{% endhighlight %}
{% highlight ruby %}
it do
  (1..1000).to_a.permutation(2).each do |p|
    expect(add(*p)).to eq p.inject(&:*)
  end
end
{% endhighlight %}

Note that I am using `*p`, called splat, makes the array items into arguments for the method. Also `p.inject(&:*)`, called symbol to proc, will call `*` on each element in the array by the sum of that last iteration.