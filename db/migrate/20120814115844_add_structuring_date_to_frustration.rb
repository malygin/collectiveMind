class AddStructuringDateToFrustration < ActiveRecord::Migration
  def change
    add_column :frustrations, :structuring_date, :datetime
  end
end
