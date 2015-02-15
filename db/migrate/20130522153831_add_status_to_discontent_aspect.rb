class AddStatusToDiscontentAspect < ActiveRecord::Migration
  def change
  	add_column :core_aspects, :status, :integer, :default => 0
  end
end
