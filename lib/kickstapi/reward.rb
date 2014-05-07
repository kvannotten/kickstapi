module Kickstapi
  class Reward
    attr_accessor :price, :backers, :description,
                  :delivery_date

    def initialize(attributes={})
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
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
