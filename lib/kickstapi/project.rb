module Kickstapi
  class Project
    attr_accessor :id, :name, :url, :creator, :about, 
                  :pledged, :currency, :percentage_funded, :backers, 
                  :status, :end_date
  end
end