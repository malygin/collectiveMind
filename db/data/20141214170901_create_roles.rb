class CreateRoles < SeedMigration::Migration
  def up
    Role.create name: 'Пользователь', code: 1
    Role.create name: 'Модератор', code: 2
    Role.create name: 'Создатель', code: 3
  end

  def down
    Role.destroy_all
  end
end
