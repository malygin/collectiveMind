class Concept::Forecast < ActiveRecord::Base
  attr_accessible :position
  belongs_to :user
  belongs_to :forecast_task
end
