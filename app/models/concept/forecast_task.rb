class Concept::ForecastTask < ActiveRecord::Base
  attr_accessible :content, :description
  belongs_to :user
  has_many :voitings, :class_name => "Concept::FinalVoiting"
end
