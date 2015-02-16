class ChangeQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :project_id, :integer
    add_column :questions, :status, :integer
    add_column :questions, :post_id, :integer
    add_column :questions, :parent_post_type, :string
    add_column :questions, :hint, :text
    rename_column :questions, :text, :content
    change_column :questions, :content, :text

    add_column :answers, :style, :integer
    add_column :answers, :status, :integer
    rename_column :answers, :text, :content
    change_column :answers, :content, :text
  end
end
