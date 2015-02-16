class AddImageFieldToLifeTapeComments < ActiveRecord::Migration
  def change
    add_column :life_tape_comments, :image, :string
  end
end
