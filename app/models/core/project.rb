class Core::Project < ActiveRecord::Base
  attr_accessible :desc, :name, :short_desc, :status, :type_access, :url_logo

  has_many :life_tape_posts, :class_name => "LifeTape::Post"
  has_many :aspects, :class_name => "Discontent::Aspect"
end
