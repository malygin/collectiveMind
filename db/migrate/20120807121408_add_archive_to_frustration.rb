class AddArchiveToFrustration < ActiveRecord::Migration
  def change
    add_column :frustrations, :archive, :boolean, :default => false
  end
end
