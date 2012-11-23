class ExpertNews::Post < ActiveRecord::Base
  attr_accessible :anons, :content, :title, :user
  belongs_to :user
end
