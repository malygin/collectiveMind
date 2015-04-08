class AddTypesProcedure < SeedMigration::Migration
  def up
    Core::ProjectType.create name: 'Бизнес', custom_fields: {concept_posts: [:reality]}
  end

  def down
    Core::ProjectType.find_by(name: 'Бизнес').destroy
  end
end
