class AddDetailedDescriptionToAspects < ActiveRecord::Migration
  def change
    add_column :core_aspects, :detailed_description, :text
  end
end
