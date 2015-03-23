class Technique::ListProject < ActiveRecord::Base
  belongs_to :core_project
  belongs_to :technique_list
end
