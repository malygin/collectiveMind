class AddPostIdToCoreContentUserAnswers < ActiveRecord::Migration
  def change
    add_column :core_content_user_answers, :post_id, :integer
  end
end
