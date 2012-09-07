class AddNegativeToFrustrationComments < ActiveRecord::Migration
  def change
    add_column :frustration_comments, :negative, :boolean,  :default => true
  end
end
