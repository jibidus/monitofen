source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 5.6', '>= 5.6.4'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6.0.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4', '>= 5.4.3'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11', '>= 2.11.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Postgresql adapter
gem 'pg'

# Pretty prints Ruby objects in colors
gem "awesome_print", "~> 1.8"

# Create and deploy cron jobs
gem "whenever", "~> 1.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'cypress-rails'
  gem 'factory_bot_rails', '~> 6.2', '>= 6.2.0'
  gem 'factory_trace'
  gem 'rspec-rails', '~> 4.0.2'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.2.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "bundle-audit", "~> 0.1.0"
  gem 'guard-rspec', require: false
  gem "rails_best_practices", "~> 1.20"
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.36.0'
  gem 'database_cleaner-active_record'
  gem 'rspec-collection_matchers'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '>= 5.0.0'
  # Mock HTTP requests
  gem 'webmock', '>= 3.10.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem

gem "nokogiri", "~> 1.13.2"

gem "require_all", "~> 3.0"

gem 'sendgrid-ruby'

gem "model_validator", ">= 1.3.0"

gem "unicorn", "~> 6.0", platform: :ruby

gem "sprockets-rails"

platforms :x64_mingw do
  gem 'tzinfo-data'
  gem 'wdm', '>= 0.1.0'
end
