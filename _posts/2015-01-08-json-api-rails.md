---
layout: post
title: Isolating from Rails with a json Api
description:
category:
tags: []
---


This is a method I have come up with separate from the framework, rails, in making a json api. First why do you want to separate from rails? Rails changes and it deprecates api leaving difficult upgrade path for projects. Isolating from the framework also gives increased speed in testing. Rails takes time to load up and this will slow down the feedback cycle. The other perk is that the framework can swapped out for another with little effort. You may come to the conclusion that you don't need Rails and move to something like Sinatra, although you most likely won't.

Here is what a controller looks like:

{% highlight ruby %}
class CompaniesController < Controller

  def search
    present -> do
      Api::Company.new(user: current_user, request_params: params).search
    end
  end

  def show
    present -> do
      Api::Company.new(user: current_user, request_params: params).get
    end
  end

  def create_or_update
    present -> do
      Api::Company.new(user: current_user, request_params: params).create_or_update
    end
  end

  def list_roles
    present -> do
      Api::Company.new(user: current_user, request_params: params).list_roles
    end
  end

end
{% endhighlight %}

Present is called and passed a proc and inside the proc there are the business logic classes that get passed the current_user, and params. All of these object will return another object that responded to the methods :response and :status. The response is the json body and the status is the http status. 

{% highlight ruby %}
def present(api_action)
  api_action.call = response_status
  render json: response_status.response, status: response_status.status
end
{% endhighlight %}

Method present, which located in the parent controller class, calls the proc and delegates the response and status to the Rails render.

Here is a simple example of inside a business logic class.

{% highlight ruby %}
module Api
  class ZipCodes
    include ControllerInterface

    def get
      response = ZipCode.search(request_params.zip_code).map do |record|
        ZipCodeResponse.new(record)
      end
      ResponseStatus.new(response: response, status: :ok)
    end

    class ZipCodeResponse
      attr_reader :zip_code, :state_name

      def initialize(record)
        @zip_code   = record.zip_code
        @state_name = record.state_name
      end
    end

  end
end
{% endhighlight %}

Here we have a zip codes class that has the back-end responsible for suppling a form on the front-end so when a user start entering a zip code it gives them list of matching zip codes. This class has the responsibilities of mapping attributes from the active record model to the response, delegating the search query to the model (a perfect place for SQL to live) and interfacing to the controller's present method by return an object that responds to :response and :status. You might say but the class is not isolated from Rails because it has an ActiveRecord model ZipCode. In Testing this I would create a separate model test for the search method and once it's tested I can be certain about what it will return so in creating a test for this class I would stub out the result to return an array of objects that respond to zip_code and state_name. But unless you have contract test at every layer of your stack things can get messy. Things can get out sync for example if the column name zip_code changed to code the test would not know it. This leaves you with unit tests passing and production code failing and a very sad day.

So I have described how to isolate from the Rails controller and now I will tell you my trick for isolating from the ActiveRecord model. I view AR differently than the rest of the Rails framework, even if I move away form Rails I can keep AR. I created a gem called [ActiveMocker](https://github.com/zeisler/active_mocker/), which at it's core is shell of the AR model that can be loaded without connecting to a database or starting up Rails. It keeps the database column names and methods in sync with the real AR model. So in my example of stubing out the result of ZipCode#search I use its AM counterpart along with [Rspec's verify double](https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles) feature to create an automatic contract of api between my Api::ZipCodes class and my AR ZipCode model.

Here is what the test looks like. I am not going to go into much detail of how AM works for that take a look at the [docs](https://github.com/zeisler/active_mocker/).

{% highlight ruby %}
require 'spec_helper'
require 'api/zip_codes'
require 'mocks/zip_codes_mock'

RSpec.describe Api::ZipCodes, active_mocker:true do
  describe 'get' do
    subject{  described_class.new(request_params: request_params).get }
    let(:request_params){ {zip_code: '123'} }
    before do
      allow(ZipCode).to receive(:search){
      [ZipCode.new(zip_code: '1234567', state_name: 'AL'),
       ZipCode.new(zip_code: '1234678', state_name: 'AK')]}
    end

    it 'returns an array of search results' do
      expect(subject.response.to_hash).to eq(
      [{zip_code: '1234567', state_name: 'AL'},
       {zip_code: '1234678', state_name: 'AK'}])
    end

    it 'returns a rails status code' do
      expect(subject.status).to eq(:ok)
    end
  end
end
{% endhighlight %}

The end result of this kind of testing is that your test will run super fast and you will get test failures if your models changes because your ActiveMocker version will to. In the project I use this in there are 600 test that can run in 3.5 seconds on my year old MacBook Pro. They could even run faster but we are also loading in CSVs in a few cases to populate the mocks with real reference data.

Happy Hacking!