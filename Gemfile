# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.5'
#ruby '2.5.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'sqlite3'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# WARNING: ver2.1.0以上ではsasscが必要、ec2との環境差分でプリコンパイルできないので明示的に2.0とする
gem 'activeadmin', '= 2.0'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'cocoon'
gem 'devise'
# NOTE: .envに記載した環境変数を認識させるために必要
gem 'dotenv-rails'
gem 'jquery-rails'
gem 'kaminari', '~> 1.1.1'
gem 'omniauth'
gem 'omniauth-github'
gem 'paranoia', '~>2.2'
gem 'payjp'
gem 'pry-byebug', group: :development
# NOTE: 検索機能
gem 'ransack'
# NOTE: マークダウン記法適用
gem 'redcarpet'
gem 'refile', require: 'refile/rails', github: 'manfe/refile'
gem 'refile-mini_magick'
# NOTE: シンタックスハイライト適用
gem 'rouge'
# NOTE: crontabを扱いやすくする
gem 'whenever', require: false

gem 'json'
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'mysql2'
#gem 'sassc', '~> 2.2'
