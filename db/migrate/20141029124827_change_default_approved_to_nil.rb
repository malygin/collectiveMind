class ChangeDefaultApprovedToNil < ActiveRecord::Migration
  def change
    change_column :advices, :approved, :boolean, default: nil
  end
end
