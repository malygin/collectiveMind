class CreateCommentsForAspect < ActiveRecord::Migration
  def change
    create_table :core_aspect_comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id
      t.boolean :useful
      t.boolean :censored, default: false
      t.integer :comment_id
      t.boolean :discuss_status
      t.boolean :approve_status
      t.string :image
      t.boolean "isFile"

      t.timestamps null: false
    end

    create_table :core_aspect_comment_votings do |t|
      t.integer :user_id
      t.integer :comment_id
      t.boolean :against, default: true

      t.timestamps null: false
    end


    create_table :core_aspect_post_votings do |t|
      t.integer :user_id
      t.integer :post_id
      t.boolean :against

      t.timestamps null: false
    end
  end
end
