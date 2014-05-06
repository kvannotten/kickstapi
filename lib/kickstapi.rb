require "kickstapi/version"
require "kickstapi/project"
require "kickstapi/kickstarter_gateway"
require "kickstapi/project_mapper"
require "kickstapi/ghostly"

require 'open-uri'
require 'mechanize'

module Kickstapi
  def self.find_projects_with_filter(filter)
    gw = Kickstapi::KickstarterGateway.new
    mapper = Kickstapi::ProjectMapper.new(gateway: gw)

    mapper.projects_by_filter filter: filter
  end

  def self.find_project_by_url(url)
    gw = Kickstapi::KickstarterGateway.new
    mapper = Kickstapi::ProjectMapper.new(gateway: gw)

    mapper.project_by_url(url: url)
  end

end
