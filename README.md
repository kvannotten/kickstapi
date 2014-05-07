# Kickstapi  [![Build Status](https://travis-ci.org/kvannotten/kickstapi.png?branch=master)](https://travis-ci.org/kvannotten/kickstapi) [![Gem Version](https://badge.fury.io/rb/kickstapi.png)](http://badge.fury.io/rb/kickstapi)

## General

This gem scrapes Kickstarter to create an API that facilitates the creation of applications querying Kickstarter. It does this by parsing the HTML on the website itself. 

Note that this library is not created nor endorsed by Kickstarter

## Remarks

Kickstarter offers an undocumented API, but recently added a disclaimer that it is against their ToS to use this API by third party applications. Regardless of this, I still want people to get access to Kickstart statistics in an easy way. So the only legal way to do this, is to parse the website itself, whom anyone is allowed visit. 

This means that sometimes Kickstarter can change things, which might break functionality. I've written the project in such a way that it separates the scraping concerns from the actual objects and the mapping thereof. This means, that when a change occurs, it has no effect on the end-user methods that the gem offers, and is merely a backend change. So update often!

## Installation

Add this line to your application's Gemfile:

    gem 'kickstapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kickstapi

## Usage

```ruby
require 'kickstapi'

# this gives you an array of Project objects containing 'Planetary Annihilation'
projects = Kickstapi.find_projects_with_filter "Planetary Annihilation"

# lets take the first project
project = projects.first

# we can then perform the following methods on it
project.name                    # returns the name of the project
project.id                      # returns the id of the project
project.url                     # returns the url of the project
project.creator                 # returns the name of the creator
# The methods above are always available, the methods below
# will be lazy loaded when requested (this requires an additional
# HTML request)
project.about                   # returns the about section
project.pledged                 # returns the total amount pledged
project.percentage_funded       # returns the percentage of funds that have been achieved so far
project.backers                 # returns the amount of backers
project.status                  # returns if the project is cancelled or succesful or still running
project.currency                # returns the currency type (USD, CAD, GBP, EUR, ...)
project.goal                    # returns the fund goal
project.end_date                # returns the date that the project (will) end(s)
project.hours_left              # returns how many hours are still left on the project

project.rewards                 # returns an array of rewards
reward = project.rewards.first
reward.price                    # returns the price of the reward
reward.backers                  # returns the amount of backers on this award level
reward.description              # returns the description of the award
reward.delivery_date             # returns the date the reward will be delivered

# you can also fetch projects by username
projects = Kickstapi.find_projects_by_username "kristofv"
# please note that when you do this, only the name and url fields
# are filled out, in order to fill out all the other fields
# you can force a request by fetching one of the lazy loaded
# fields or explicitly calling:
projects.first.load

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
