class ChangeContentNameToTextPostAspect < ActiveRecord::Migration
  def change
    change_column :concept_post_aspects, :name,  :text
    change_column :concept_post_aspects, :content,  :text
    change_column :plan_post_aspects, :name,  :text
    change_column :plan_post_aspects, :content,  :text
  end
end
