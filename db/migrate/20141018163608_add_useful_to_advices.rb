class AddUsefulToAdvices < ActiveRecord::Migration
  def change
    add_column :advices, :useful, :boolean
  end
end
