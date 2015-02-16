class CreateHelpPosts < ActiveRecord::Migration
  def change
    create_table :help_posts do |t|
      t.text :content
      t.integer :stage
      t.boolean :mini
      t.integer :style


      t.timestamps
    end
  end
end
