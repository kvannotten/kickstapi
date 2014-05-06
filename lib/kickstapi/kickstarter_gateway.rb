require 'mechanize'
require 'json'

module Kickstapi
  class KickstarterGateway

    def projects_with_name(filter, offset = 1)
      search_url = "http://www.kickstarter.com/projects/search?page=#{offset}utf8=%E2%9C%93&term=#{URI::encode filter}"

      projects = []
      should_page = true
      
      agent.get(search_url) do |page|
        page.search("div.project-card-wrap").each do |project|
          p = Hash.new(0)
          
          bb_card = project.search("h2.bbcard_name")
          bb_card_link = bb_card.search("a").first

          p[:name] = bb_card_link.content
          p[:url] = "https://www.kickstarter.com#{bb_card_link.attributes["href"].value.split('?').first}"
          p[:id] = JSON.parse(project.attributes["data-project"])["id"].to_i 
          p[:creator] = project.search(".bbcard_name span").text.gsub(/\n|by/, '')

          projects << p 
        end
        should_page = projects.count > 0
      end

      [projects, should_page]
    end

    def project_by_url(url)
      project = {}
      agent.get(url) do |page|
        project[:name] = page.search(%Q{//h2[@class='mb1']//a}).text
        project[:creator] = page.search(%Q{//span[@class='creator']//a}).text
        project[:url] = url
        project[:id] = page.search('div').select { |div| div[:class] =~ /^Project\d+/ }.map { |div| div[:class].to_s }.uniq.first.scan(/(\d+)/).flatten.first.to_i
        project[:backers] = page.search(%Q{//data[@itemprop='Project[backers_count]']}).first.attributes["data-value"].value.to_i
        project[:pledged] = page.search(%Q{//data[@itemprop='Project[pledged]']}).first.attributes["data-value"].value.to_f
        project[:goal] = page.search(%Q{//div[@id='pledged']}).first.attributes['data-goal'].value.to_f
        project[:currency] = page.search(%Q{//data[@itemprop='Project[pledged]']}).first.attributes["data-currency"].value
        project[:percentage_funded] = page.search(%Q{//div[@id='pledged']}).first.attributes['data-percent-raised'].value.to_f * 100
        project[:end_date] = DateTime.parse page.search(%Q{//span[@id='project_duration_data']}).first.attributes['data-end_time'].value
        project[:hours_left] = page.search(%Q{//span[@id='project_duration_data']}).first.attributes['data-hours-remaining'].value.to_f
        project[:rewards] = parse_rewards(page.search(%Q{//ul[@id='what-you-get']}).first)
      end
      project
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
