class FillSkills < SeedMigration::Migration
  def up
    ['Умение находить ошибки, противоречия и нестыковки', 'Умение анализировать', 'Умение работать в группе',
     'Умение агрегировать (строить системы)', 'Умение классифицировать'].each do |skill|
      Skill.create name: skill
    end
  end

  def down
    Skill.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence! 'skills'
  end
end
