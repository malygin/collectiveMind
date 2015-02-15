class RenamePrimaryKey < ActiveRecord::Migration
  def change
    execute "ALTER TABLE core_aspects DROP CONSTRAINT discontent_aspects_pkey;"
    execute "ALTER TABLE core_aspects ADD PRIMARY KEY (id);"

  end
end
