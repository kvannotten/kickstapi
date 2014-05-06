require 'json'
require 'kickstapi/ghostly'

module Kickstapi
  class Project
    include Ghostly

    attr_accessor :id, :name, :url, :creator
    lazy_accessor :about,  :pledged, :goal, 
                  :currency, :percentage_funded, :backers, 
                  :status, :end_date, :hours_left,
                  :rewards
                  
    def initialize(attributes = {})
      complete(attributes)
    end

    def complete(attributes)
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def rewards=(rewards)
      @rewards = []
      rewards.each do |reward|
        @rewards << Kickstapi::Reward.new(reward)  
      end
    end

    def to_s
      inspect
    end

    def ==(other)
      other.is_a?(Project) && other.id == id
    end

    def to_hash
      hash = {}
      self.instance_variables.each do |var|
        sym = var.to_s.gsub(/@/, '')
        hash[sym.to_sym] = self.instance_variable_get var
      end
      hash
    end
    
    def to_json(*a)
      self.to_hash.to_json
    end
  end
end
