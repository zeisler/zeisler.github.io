---
layout: default
title: "Using ActiveEnumerable"
description: ""
---------------

I've grown accustomed to using the ActiveRecord API for querying the
database. I was working on a project that had a large JSON structure. I 
really wanted to have methods `where` (with `not` and `or`), `find_by`, and `scopes`
at my disposal. All the methods that come with Ruby's Enumerable are 
 extremely powerful and I use them all the time, but there is also 
something that is readable and familiar in the ActiveRecord API. 
