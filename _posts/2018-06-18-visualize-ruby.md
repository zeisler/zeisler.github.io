---
layout: post
title: Visualize Ruby with Flowcharts
category: Ruby
comments: true
email_sign_up: true
tags: [ruby flowcharts]
---

See Ruby control flow and methods calls as flow charts. 
Helps developers better understand code and explain it to the non-technical. By using the DSL you already know, Ruby.

Play around with a live [Ruby editor demo](https://visualize-ruby.herokuapp.com) and see the flow chart being formed on the right.

[![Visualize Ruby Demo](/images/visualize_ruby_demo.png)](https://visualize-ruby.herokuapp.com/)

Write a Ruby class and see method interactions.
[![Visualize Ruby Demo](/images/visualize_ruby_demo_class.png)](https://visualize-ruby.herokuapp.com/)
Works with procedural code and bare methods. 
This is experimental project and does not support all types of code.

Under the hood this is using [GraphViz](http://www.graphviz.org/) and [parser gem](https://github.com/whitequark/parser). 
[Parser](https://github.com/whitequark/parser) is used to transform the code to an [AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree) 
and based on each type converts those to [GraphViz](http://www.graphviz.org/) nodes and edges to create the flow chart.

It's open source, [visualize_ruby](https://github.com/zeisler/visualize_ruby). Feedback and pull-request are welcome.

<div class="joining">
If you like this blog and my code and would like to work with me, I am currently open to joining/enhancing your software team. 
If your interested
<mailto:> 
<a href="mailto:dustinzeisler@gmail.com?subject=Interested in your skills">Email me</a> at dustinzeisler@gmail.com
</div>
