class Core::ProjectType < ActiveRecord::Base
  validates :name, :code, presence: true
end
