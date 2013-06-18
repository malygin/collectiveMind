class AddAnonymToUser < ActiveRecord::Migration
  def change
  	 add_column :users, :nickname, :string
     add_column :core_projects, :secret2, :string
     add_column :core_projects, :secret3, :string
  	 add_column :users, :anonym, :boolean, :default => :false

  end
end
