class AddSecretWordForCorProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :secret, :string

  end
end
