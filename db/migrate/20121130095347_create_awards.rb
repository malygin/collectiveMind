class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.string :url
      t.text :desc

      t.timestamps
    end
  end
end
