class Technique::ListProject < ActiveRecord::Base
  belongs_to :core_project
  belongs_to :technique_list

  validates :core_project_id, :technique_list_id, presence: true
end
