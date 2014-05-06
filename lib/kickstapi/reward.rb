module Kickstapi
  class Reward
    attr_accessor :price, :backers, :description,
                  :delivery_date

    def initialize(attributes={})
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
    end

  end
end
