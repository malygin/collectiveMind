class FixAspectTechniqCode < SeedMigration::Migration
  def up
    Technique::List.where(stage: 'aspects').update_all(stage: 'aspect_posts')
  end

  def down
    Technique::List.where(stage: 'aspect_posts').update_all(stage: 'aspects')
  end
end
