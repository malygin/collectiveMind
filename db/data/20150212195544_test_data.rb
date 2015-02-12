class TestData < SeedMigration::Migration
  def up
    require 'factory_girl'
    Dir[Rails.root.join('spec/factories/*.rb')].each { |f| require f }

    FactoryGirl.create :prime_admin, email: 'test@gmail.com', password: 'pascal2003'
    FactoryGirl.create :core_project
  end

  def down
  end
end
