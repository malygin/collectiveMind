class Technique::Skill < ActiveRecord::Base
  belongs_to :technique_list
  belongs_to :skill
end
