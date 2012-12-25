class Concept::Forecast < ActiveRecord::Base
  attr_accessible :position, :forecast_task
  belongs_to :user
  belongs_to :forecast_task
end
