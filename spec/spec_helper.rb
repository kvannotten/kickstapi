require 'simplecov'
require 'rspec/its'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kickstapi'
