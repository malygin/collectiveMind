class CreateEstimatePosts < ActiveRecord::Migration
  def change
    create_table :estimate_posts do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content
      t.integer :oppsh1
      t.integer :oppsh2
      t.integer :oppsh3
      t.text :oppsh
      t.integer :ozpshf1
      t.integer :ozpshf2
      t.integer :ozpshf3
      t.text :ozpshf
      t.integer :ozpshs1
      t.integer :ozpshs2
      t.integer :ozpshs3
      t.text :ozpshs
      t.integer :onpsh1
      t.integer :onpsh2
      t.integer :onpsh3
      t.text :onpsh
      t.integer :nepr1
      t.integer :nepr2
      t.integer :nepr3
      t.integer :nepr4
      t.text :nepr

      t.timestamps
    end
    add_index :estimate_posts, :user_id

    add_index :estimate_posts, :created_at
    add_index :estimate_posts, :post_id
  end
end
