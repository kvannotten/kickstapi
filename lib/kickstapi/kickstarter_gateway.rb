require 'mechanize'
require 'json'

module Kickstapi
  class KickstarterGateway

    def projects_with_name(filter, offset = 1)
      search_url = "http://www.kickstarter.com/projects/search?page=#{offset}utf8=%E2%9C%93&term=#{URI::encode filter}"

      projects = []
      should_page = true
      
      agent.get(search_url) do |page|
        page.search("div.project-card-tall").each do |project|
          p = Hash.new(0)
          
          bb_card = project.search("h6.project-title")
          bb_card_link = bb_card.search("a").first

          p[:name] = bb_card_link.content
          p[:url] = "https://www.kickstarter.com#{bb_card_link.attributes["href"].value.split('?').first}"
          p[:id] = JSON.parse(project.attributes["data-project"])["id"].to_i 
          p[:creator] = project.search("div.project-card-content > p.project-byline").text.gsub(/\n|by/, '')

          projects << p 
        end
        should_page = projects.count > 0
      end

      [projects, should_page]
    end

    def project_by_url(url)
      project = {}
      agent.get(url) do |page|
        project[:name] = page.search(%Q{//div[contains(@class, 'NS_projects__header')]/h2[contains(@class,'mb1')]/a}).first.text
        project[:creator] = page.search(%Q{//p[contains(@class, 'h5 mb0 mobile-hide')]/b/a}).first.text
        project[:url] = url
        project[:id] = page.search('div').select { |div| div[:class] =~ /^Project\d+/ }.map { |div| div[:class].to_s }.uniq.first.scan(/(\d+)/).flatten.first.to_i
        project[:backers] = page.search(%Q{//data[@itemprop='Project[backers_count]']}).first.attributes["data-value"].value.to_i
        project[:pledged] = page.search(%Q{//data[@itemprop='Project[pledged]']}).first.attributes["data-value"].value.to_f
        project[:goal] = page.search(%Q{//div[@id='pledged']}).first.attributes['data-goal'].value.to_f
        project[:currency] = page.search(%Q{//data[@itemprop='Project[pledged]']}).first.attributes["data-currency"].value
        project[:percentage_funded] = page.search(%Q{//div[@id='pledged']}).first.attributes['data-percent-raised'].value.to_f * 100
        project[:end_date] = DateTime.parse page.search(%Q{//span[@id='project_duration_data']}).first.attributes['data-end_time'].value
        project[:hours_left] = page.search(%Q{//span[@id='project_duration_data']}).first.attributes['data-hours-remaining'].value.to_f
        project[:rewards] = parse_rewards(page.search(%Q{//div[@class='NS_projects__rewards_list']}).first)
      end
      project
    end

    def projects_by_username(username)
      projects = []
      source_url = "https://www.kickstarter.com/profile/#{username}"

      agent.get(source_url) do |page|
        page.search("a.project_item").each do |item|
          project = {}
          
          project[:name] = item.search("div.project_name").text.gsub(/\n/, '')
          project[:id] = :not_loaded
          project[:url] = "https://kickstarter.com#{item.attributes["href"].value}"
          project[:creator] = :not_loaded

          projects << project
        end
      end

      projects
    end

    private 

    def agent
      @agent ||= Mechanize.new
    end

    def parse_rewards(rewards)
      rewards_list = []
      rewards.search("li.NS-projects-reward").each do |reward|
        rewards_hash = {}

        rewards_hash[:price] = reward.search("h5.mb1 > span.money").text[1..-1].gsub(/[,.]/, '').to_f
        rewards_hash[:backers] = reward.search("p.backers-limits > span.backers-wrap > span.num-backers").text.to_i
        rewards_hash[:description] = reward.search("div.desc > p").text
        rewards_hash[:delivery_date] = DateTime.parse reward.search("div.delivery-date > time").text

        rewards_list << rewards_hash
      end
      rewards_list
    end

  end
end
