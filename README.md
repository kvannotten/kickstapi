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
projects = Kickstapi.search_projects "Planetary Annihilation"

# lets take the first project
project = projects.first

# we can then perform the following methods on it
project.name
project.url
project.about
project.creator
project.pledged
project.percentage_funded
project.backers
project.status

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
