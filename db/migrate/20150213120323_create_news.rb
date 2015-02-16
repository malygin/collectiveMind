class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :body
      t.references :project, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
