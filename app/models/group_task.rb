class GroupTask < ActiveRecord::Base
  belongs_to :group
  has_many :users, class_name: 'GroupTaskUser'
  attr_accessible :name, :description, :group_id

  validates :name, :description, presence: true
end
