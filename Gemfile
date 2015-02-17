source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.0'

gem 'foreman'
gem 'thin'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'compass'
gem 'compass-rails'
gem 'therubyracer'
gem 'websocket-rails', git: 'https://github.com/samhane/websocket-rails.git'
gem 'cloudinary'
#@todo загрузка файлов через аякс, используется где гем?
gem 'remotipart', '~> 1.2'
gem 'pg'
#@todo вроде тоже не нужен
#gem 'activerecord-postgresql-adapter'
gem 'russian'
# @todo а это крутая штука, но нужна ли она? Можно заменить на bootstrap-editable-rails
gem 'bootstrap-x-editable-rails'
#@todo а этот гем используется?
gem 'selectize-rails'
#@todo посмотреть, может заменить чем нужно
gem 'rails3-jquery-autocomplete'
gem 'pg_search'
gem 'devise'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-ui-sass-rails'
#@todo нужен? или заменить на cloudinary?
gem 'paperclip'
#@todo нужен?
gem 'aws-sdk'
#@todo ставить авто размер для textarea, гем старый
gem 'autosize-rails'
gem 'highcharts-rails', '~> 3.0.0'
gem 'json'
#@todo обновить?
gem 'will_paginate', '~> 3.0.0'
gem 'devise_lastseenable'
gem 'memcachier'
gem 'dalli'
#@todo можно писать erb в haml, нужен еще?
gem 'settingslogic'
gem 'bootstrap-wysihtml5-rails'
#@todo нужен? делать запросы по rest
gem 'rest-client'
#@todo он только для 1.9 рубей, удаляем
#gem 'magic_encoding'
gem 'similar_text'
gem 'breadcrumbs_on_rails'
#@todo несколько редакторов?
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'historyjs-rails'
gem 'seed_migration'
gem 'resque'
gem 'resque_mailer'
gem 'resque-scheduler'
gem 'resque-status'
#@todo оба шедулера нужны?
gem 'rufus-scheduler', '< 3.0.0'
gem 'bugsnag'

group :development, :test do
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  # @todo думаю тоже не нужен, фактори хватит
  #gem 'faker'
  #@todo удалить? Давно не обновлялся, и он только для 3 рельсы и вроде ничего не делает
  #gem 'grizzled-rails-logger'
end

group :development do
  gem 'spring'
  gem 'rubocop'
  gem 'ruby-prof'
  gem 'rspec-prof'
  gem 'brakeman', require: false
  gem 'rails_best_practices'
  gem 'guard-livereload'
  gem 'lol_dba'
  gem 'yard'
  gem 'rubycritic'
  gem 'traceroute'
  # @todo нужно держать этот гем тут? Есть сайт, его должно хватить
  #gem 'html2haml' #, '1.0.0'
end

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm', '>=3.7.3'
  gem 'heroku-deflater'
end

group :test do
  gem 'rspec'
  gem 'spork'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'database_cleaner'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'headless'
  #@todo им еще будем пользоваться?
  #gem 'codeclimate-test-reporter', require: nil
  # @todo селениум тоже нужен?
  #gem 'selenium-webdriver', '~> 2.41.0'
  #gem 'webdriver-user-agent'
end
