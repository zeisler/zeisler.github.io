---
layout: post
title: Lambda + Ruby = Podcast [tutorial]
category: Ruby
comments: true
email_sign_up: true
tags: ruby AWS Podcast Lambda
image:
  alt: Podcasting with Ruby On Lambda
  link: /assets/aws-lambda-podcast-in-ruby/lambda-ruby-podcast.svg
---

As of [Nov 29, 2018](https://aws.amazon.com/about-aws/whats-new/2018/11/aws-lambda-supports-ruby/) you can write server-less
functions with Ruby! You can now use your favorite Ruby tools and libraries when developing lambda functions. 

In case your not familiar with lambda here is how <a href="https://docs.aws.amazon.com/lambda/latest/dg/welcome.html" target="_blank">amazon</a> describes it.

> "AWS Lambda is a compute service that lets you run code without provisioning or managing servers. AWS Lambda executes your code only when needed and scales automatically, from a few requests per day to thousands per second. You pay only for the compute time you consume - there is no charge when your code is not running. With AWS Lambda, you can run code for virtually any type of application or backend service - all with zero administration. AWS Lambda runs your code on a high-availability compute infrastructure and performs all of the administration of the compute resources, including server and operating system maintenance, capacity provisioning and automatic scaling, code monitoring and logging."

Let's give this a try and build something. I'm going to show you how to build a podcast feed using plain Ruby in the Lambda service. I will also use S3 to host the podcast mp3s.

### Create Function
Create an account with <a href="https://aws.amazon.com/s3" target="_blank">AWS</a>, if you have amazon shopping account you can use the same login. 

Now let's setup the Lambda function. Open up the <a href="https://aws.amazon.com/lambda/" target="_blank">Lambda Console</a>. 

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/create-lambda-function" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* Click "Create Function"
* Give the function a name "music-podcast"
* Select runtime "Ruby 2.5"
* Click create function (this will take a moment)

### Add code for Function

This code will be triggered later when uploading new episodes. When run it generates feed.xml file and saves it to your s3 bucket.

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/add-code-for-lambda" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* <a href="/assets/aws-lambda-podcast-in-ruby/lambda_function.rb">Download function</a> code and copy/paste into online editor. Replace the contents of `lambda_function.rb` with what was downloaded.
* Click orange "Save" button.

### Create S3 Bucket

Open up the <a href="https://s3.console.aws.amazon.com/s3" target="_blank">S3 Console</a>.

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/create-s3-bucket" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

Create a public S3 bucket for hosting the podcast files.
* Name it `music-podcast`
* Use the same Region as the lambda function.
* Allow public access
* Use default storage option.

### Connect S3 Trigger

Create a trigger for the function to run every time an object is uploaded into the bucket "music-podcast/episodes".
This way we can rebuild the feed.xml when new files are added without any additional steps.

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/set-s3-trigger" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* In the designer pane scroll down to S3.
* In the pane select bucket `music-podcast`
* Add a Prefix of `episodes/` to watch for changes within this directory.

#### Give Function S3 rights to bucket

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/add-s3-right-to-lambda" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* Click on your function `music-podcast` within the Designer pane.
* Scroll past your code to a pane labeled "Execution role"
* Click link "View the music-podcast-role-xxxxxxx". This will open up IAM.
* From IAM click the blue button "Attach policies"
* In the search box type "s3"
* Check "AmazonS3FullAccess"
* Click Attach policy.

### Create S3 user with rights to upload to bucket

The lambda function code is going to need a user credentials in order to read from the bucket to get the episode files and then to post back the `feed.xml`. 

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/create-iam-user-s3" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* Go to <a href="https://aws.amazon.com/iam" target="_blank">IAM</a>
* Click Users
* Add User
* User name of `podcaster`
* Only click "Programmatic access"
* Click "Next: Permissions"
* Click "Attach existing policies directly"
* Search "s3" and check it.
* Click through steps and create user.
* Make sure to copy down the "Access key ID" and the "Secret access key". You can add it to the 
<a href="/assets/aws-lambda-podcast-in-ruby/secrets.yml" download="secrets.yml">secrets.yml</a>
next we will upload that to our function.

### Create secrets.yml in Lambda Console

Let give your function a way to access those newly created credentials.

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/create-secret-in-lambda" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* Create a new file in your lambda function "secrets.yml"
* Paste in the contents that you copied from the last step.
* Click save.


### Setup The Podcast

To have a podcast you must have some recordings preferable in mp3 format. Let's assume that you don't have them yet, but you need some filler episodes to test this out. So I'm going to use some [Classical Music](http://www.amclassical.com/piano/) license under Creative Commons.
* [Beethoven: Für Elise](http://www.amclassical.com/mp3/amclassical_beethoven_fur_elise.mp3)
* [Joplin: The Entertainer Rag](http://www.amclassical.com/mp3/amclassical_joplin_the_entertainer_rag.mp3)
* [Bach: Two-part Invention in C minor](http://www.amclassical.com/mp3/amclassical_twopart_invention_in_c_minor.mp3)

Each directory will represent a episode number with the mp3 and some metadata in it.
```
/music-podcast/episodes/1
  ↳ audio.mp3
     metadata.json
/music-podcast/episodes/2
  ↳ audio.mp3
     metadata.json
/music-podcast/episodes/3
  ↳ audio.mp3
     metadata.json
```

The <a href="/assets/aws-lambda-podcast-in-ruby/metadata.json" download="metadata.json">JSON metadata</a> will look something like this..
{% highlight json %}
{
    "title": "Episode 1: Beethoven: Für Elise",
    "description": "Beethoven: Für Elise",
    "published": "2019-05-01"
}
{% endhighlight %}

If you don't want to create your own download my <a href="/assets/aws-lambda-podcast-in-ruby/episodes.zip" download="episodes.zip">example episodes</a> to get started. 

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/upload-episodes-to-s3" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* Upload the episodes directory to the root of the music-podcast bucket.
* Make sure to set it as *public*

### Public Feed URL

Shortly after you will see the `feed.xml` appear in the root of the bucket. 
<a href="/assets/aws-lambda-podcast-in-ruby/feed.xml" download="feed.xml">
Here is what mine looks like.
</a>

Get the public url to publish.

{% include video.html path="/assets/aws-lambda-podcast-in-ruby/public-feed-s3-url" img="/assets/aws-lambda-podcast-in-ruby/lambda-ruby-isometric-black@2x.png" %}

* Click on the bucket `music-podcast` and then `feed.xml`
* Scroll to the bottom and copy the link under "Object URL"

### All Done!

You can play around, add a few other episodes, edit the metadata and see the feed re-built.

Let me know in the comments what you think you might build with Lambda using Ruby.
