class Technique::ListProject < ActiveRecord::Base
  belongs_to :core_project, class_name: 'Core::Project'
  belongs_to :technique_list, class_name: 'Technique::List'

  validates :project_id, :technique_list_id, presence: true
end
