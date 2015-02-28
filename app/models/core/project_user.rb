class Core::ProjectUser < ActiveRecord::Base
  belongs_to :core_project, class_name: 'Core::Project', foreign_key: 'project_id'
  belongs_to :user

  validates :user_id, :project_id, presence: true

  scope :by_project, ->(pr) { where(project_id: pr) }
  scope :by_type, -> (type) { where type_user: type }

  TYPE_USER = {
      0 => 'Владельцы',
      1 => 'Модераторы',
      2 => 'Эксперт',
      3 => 'Рядовые участники',
  }.freeze
end
