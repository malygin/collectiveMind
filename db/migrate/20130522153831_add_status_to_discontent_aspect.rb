class AddStatusToDiscontentAspect < ActiveRecord::Migration
  def change
  	add_column :discontent_aspects, :status, :integer, :default => 0
  end
end
