require "kickstapi/version"
require "kickstapi/project"

require 'open-uri'
require 'mechanize'

module Kickstapi
  def self.get_agent
    @agent ||= Mechanize.new
  end
  
  def self.search_projects filter = ""
    search_url = "http://www.kickstarter.com/projects/search?utf8=%E2%9C%93&term=#{URI::encode filter}"

    projects = []
    Kickstapi.get_agent.get(search_url) do |page|
      page.search("div.project-card").each do |project|
        p = Project.new
        bb_card = project.search("h2.bbcard_name")
        bb_card_link = bb_card.search("a").first

        p.name = bb_card_link.content
        p.url = bb_card_link.attributes["href"].value

        bb_card_author = bb_card.search("span").first
        p.creator =  bb_card_author.content.gsub(/\nby\n/, '').gsub(/\n/, '')
        p.about = project.search("p.bbcard_blurb").first.content.strip
        
        if project.search(".project-failed").first.nil? then
          p.pledged = project.search("strong.project-pledged-amount").first.content.gsub(/\n/, '').gsub(/pledged/, '')
          p.percentage_funded = project.search("strong.project-pledged-percent").first.content.gsub(/\n/, '').gsub(/funded/, '')
          p.backers = project.search("li.middle").first.search("strong").first.content.gsub(/\n/, '')
          p.status = project.search("li.last").first.search("strong").first.content 
        else
          p.status = "Failed"
        end
        projects << p
      end
    end

    projects
  end
  
end
