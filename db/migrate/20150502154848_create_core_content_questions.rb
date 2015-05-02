class CreateCoreContentQuestions < ActiveRecord::Migration
  def change
    create_table :core_content_questions do |t|
      t.integer :project_id
      t.text :content
      t.string :post_type

      t.timestamps null: false
    end
  end
end
