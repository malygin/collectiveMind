class UpdateAward < ActiveRecord::Migration
  def change
    remove_column :awards, :created_at
    remove_column :awards, :updated_at
    add_column :user_awards, :position, :integer


  end
end
