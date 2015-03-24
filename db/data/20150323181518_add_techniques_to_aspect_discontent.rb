class AddTechniquesToAspectDiscontent < SeedMigration::Migration
  def up
    Technique::List.create name: 'Простой мастер', stage: 'collect_info_posts', code: 'simple'
    Technique::List.create name: 'Подробный мастер', stage: 'collect_info_posts', code: 'detailed'

    Technique::List.create name: 'Простой мастер', stage: 'discontent_posts', code: 'simple'
    Technique::List.create name: 'Подробный мастер', stage: 'discontent_posts', code: 'detailed'
  end

  def down
    Technique::List.destroy_all
  end
end
