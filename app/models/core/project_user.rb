class Core::ProjectUser < ActiveRecord::Base
  belongs_to :core_project, class_name: 'Core::Project', foreign_key: 'project_id'
  belongs_to :user

  validates :user_id, :project_id, presence: true

  scope :by_project, ->(pr) { where(project_id: pr) }
  scope :by_type, -> (type) { where type_user: type }

  TYPE_USER = {
      0 => 'Оргкомитет',
      1 => 'Методолог',
      2 => 'Модератор',
      3 => 'Приглашенный эксперт',
      4 => 'Рядовые участники'
  }.freeze
end
