# Kickstapi  [![Build Status](https://travis-ci.org/kvannotten/kickstapi.png?branch=master)](https://travis-ci.org/kvannotten/kickstapi) [![Gem Version](https://badge.fury.io/rb/kickstapi.svg)](http://badge.fury.io/rb/kickstapi)

This gem scrapes Kickstarter to create an API that facilitates the creation of applications querying Kickstarter.

Note that this library is not created not endorsed by Kickstarter

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

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
