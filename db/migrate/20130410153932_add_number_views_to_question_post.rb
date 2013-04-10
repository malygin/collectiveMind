class AddNumberViewsToQuestionPost < ActiveRecord::Migration
  def change
    add_column :question_posts, :number_views, :integer, :default => 0
  end
end
