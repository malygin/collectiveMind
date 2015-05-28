class CreateNovations < ActiveRecord::Migration
  def change
    create_table :novation_posts do |t|
      t.string :title
      t.integer :user_id
      t.integer :number_views, default: 0
      t.integer :status, default: 0
      t.integer :project_id
      t.text :actions_desc
      t.text :actions_ground
      t.text :actors
      t.text :tools
      t.text :impact_group
      t.text :impact_env

      t.timestamps null: false
    end

    create_table :novation_comments do |t|
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

    create_table :novation_comment_votings do |t|
      t.integer :user_id
      t.integer :comment_id
      t.boolean :against, default: true

      t.timestamps null: false
    end

    create_table :novation_notes do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id
      t.integer :type_field

      t.timestamps null: false
    end

    create_table :novation_post_concepts do |t|
      t.integer :post_id
      t.integer :concept_post_id
      t.integer :status, default: 0

      t.timestamps null: false
    end

    create_table :novation_post_votings do |t|
      t.integer :user_id
      t.integer :post_id
      t.boolean :against

      t.timestamps null: false
    end

    create_table :novation_votings do |t|
      t.integer :user_id
      t.integer :novation_post_id

      t.timestamps null: false
    end

  end
end
