class FixTechniquesStage < SeedMigration::Migration
  def up
    Technique::List.where(stage: 'collect_info_posts').update_all(stage: 'aspects')
  end

  def down
    Technique::List.where(stage: 'aspects').update_all(stage: 'collect_info_posts')
  end
end
