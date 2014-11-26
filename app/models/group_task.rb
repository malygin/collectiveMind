class GroupTask < ActiveRecord::Base
  belongs_to :group
  attr_accessible :name, :description, :group_id

  validates :name, :description, presence: true
end
