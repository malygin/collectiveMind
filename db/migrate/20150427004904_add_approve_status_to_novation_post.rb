class AddApproveStatusToNovationPost < ActiveRecord::Migration
  def change
    add_column :novation_posts, :approve_status, :boolean
  end
end
