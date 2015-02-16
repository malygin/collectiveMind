class AdditionalSampleData < SeedMigration::Migration
  def up
    require 'factory_girl'
    Dir[Rails.root.join('spec/factories/*.rb')].each { |f| require f }

    project = Core::Project.create!(name: 'Стратегия развития ДО в СГУ на 2012-2013 год', type_access: 2)

    project.aspects.create! content: 'Социальные'
    project.aspects.create! content: 'Технологические'
    project.aspects.create! content: 'Брендинг'
    project.aspects.create! content: 'Учеба'
    project.aspects.create! content: 'Новые профессии'
    project.aspects.create! content: 'Создание профессионалов'
    User.create!(name: 'Сергей',
                 surname: 'Кириллов',
                 email: 'admin@mass-decision.ru',
                 login: 'admin',
                 password: 'adminpassword',
                 password_confirmation: 'adminpassword',
                 type_user: 1)


    30.times do
      FactoryGirl.create :user
    end
  end

  def down
    Core::Project.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence! 'core_projects'
    project.aspects.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence! 'core_aspects'
    User.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence! 'users'
  end
end
