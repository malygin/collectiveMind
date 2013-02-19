class Core::Project < ActiveRecord::Base
  attr_accessible :desc, :name, :short_desc, :status, :type_access, :url_logo
end
