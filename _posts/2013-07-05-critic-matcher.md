---
layout: post
title: "Critic Matcher"
description: ""
category:
tags: []
---

First group project at [Portland Code School][school] has
shipped. Check it out [Critic Matcher][critic] on heroku or see the [Github repo][repo]. It lets you rate movies and find critics that agree with your taste.

This project pulls in Critic data from Rotten Tomato's API runs it through a ruby wrapper and into a Postgres DB. It then displays new movies for user to rate, takes those ratings puts them through a ranking algorithm and outputs a list of critic that match the rater's taste.

For this I wrote code to process user ratings data and pass it along to the ranking algorithm.  Along with the ranking algorithm I handled API data from Rotten Tomatoes and designed a data model to store that data. I not only worked on the backend, but also designed the frontend site to be responsive and look good on any device.

This was a team project where we followed agile development, TDD, and pair programming through out the development. The project comes with a test suit that is written MiniSpec.

**The frontend asset used were:**
* Twitter Bootstrap 2.0
* Font Awesome
* Movie Covers from Rotten Tomato's

![Critic Matcher Site](/images/blog/critic_matcher.png)

[school]: http://portlandcodeschool.com
[critic]: http://critic-critic.herokuapp.com
[repo]: https://github.com/ShaneDelmore/critic_critic
