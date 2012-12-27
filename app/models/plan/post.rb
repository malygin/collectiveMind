class Plan::Post < ActiveRecord::Base
  attr_accessible :first_step, :goal, :number_views, :other_steps, :status, :user_id
end
