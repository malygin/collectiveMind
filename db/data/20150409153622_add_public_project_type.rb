class AddPublicProjectType < SeedMigration::Migration
  def up
    Core::ProjectType.find_by(name: 'Бизнес').update(code: 'business')
    Core::ProjectType.create name: 'Общественная', code: 'public', custom_fields: true
  end

  def down
    Core::ProjectType.find_by(name: 'Общественная').destroy
  end
end
