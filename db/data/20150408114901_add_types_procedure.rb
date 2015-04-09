class AddTypesProcedure < SeedMigration::Migration
  def up
    Core::ProjectType.create name: 'Бизнес', code: 'business'
  end

  def down
    Core::ProjectType.find_by(name: 'Бизнес').destroy
    ActiveRecord::Base.connection.reset_pk_sequence! 'core_project_types'
  end
end
