class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :group
      t.string :string
      t.string :faculty
      t.string :string
      t.boolean :validate
      t.date :dateRegistration
      t.date :dateActivation
      t.date :dateLastEnter
      t.string :vkid

      t.timestamps
    end
  end
end
