class SetUpdatedAtValues < ActiveRecord::Migration
  def up
    User.connection.execute("update users set type_user = 2 where expert = 'true'")
    User.connection.execute("update users set type_user = 3 where jury = 'true'")
    User.connection.execute("update users set type_user = 6 where admin = 'true'")
    User.connection.execute("update users set type_user = 1 where id = 1")
    User.connection.execute("update users set type_user = 7 where id = 3000")
  end

  def down
  end
end
