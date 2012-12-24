class Concept::FinalVoiting < ActiveRecord::Base
  attr_accessible  :score, :user
  belongs_to :user
  belongs_to :forecast_task

end
