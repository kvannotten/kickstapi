require 'json'

module Kickstapi
  class Project
    attr_accessor :id, :name, :url, :creator, :about, 
                  :pledged, :goal, :currency, :percentage_funded, :backers, 
                  :status, :end_date
                  
    def to_hash
      hash = {}
      self.instance_variables.each do |var|
        sym = var.to_s.gsub /@/, ''
        hash[sym.to_sym] = self.instance_variable_get var
      end
      hash
    end
    
    def to_json(*a)
      self.to_hash.to_json
    end
  end
end
