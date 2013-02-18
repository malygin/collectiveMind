class Core::Project < ActiveRecord::Base
  attr_accessible :desc, :name, :short_desc, :status
end
