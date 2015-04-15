class AddTechniquesToAspectDiscontent < SeedMigration::Migration
  def up
    Technique::List.create stage: 'aspects', code: 'simple'
    Technique::List.create stage: 'aspects', code: 'detailed'

    Technique::List.create stage: 'discontent_posts', code: 'simple'
    Technique::List.create stage: 'discontent_posts', code: 'detailed'
  end

  def down
    Technique::List.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence! 'technique_lists'
  end
end
