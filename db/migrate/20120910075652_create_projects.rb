class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.datetime :begin1st
      t.datetime :end1st
      t.datetime :begin1stvote
      t.datetime :end1stvote

      t.timestamps
    end
  end
end
