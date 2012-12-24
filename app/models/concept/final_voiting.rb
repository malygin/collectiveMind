class Concept::FinalVoiting < ActiveRecord::Base
  attr_accessible  :score
  belongs_to :user
  belongs_to :forecast_task

end
