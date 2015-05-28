class Technique::Store < ActiveRecord::Base
  belongs_to :technique_list_project
  belongs_to :user
end
