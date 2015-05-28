class AddContentToUserAnswers < ActiveRecord::Migration
  def change
    add_column :collect_info_user_answers, :content, :text
  end
end
