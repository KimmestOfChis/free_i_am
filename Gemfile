# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "bcrypt", "~> 3.1", ">= 3.1.12"
gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.7", ">= 7.0.7.2"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "pry-rails", "~> 0.3.9"
gem "rubocop", "~> 1.56", require: false
gem "rubocop-performance", "~> 1.11", require: false
gem "rubocop-rails", "~> 2.11", require: false
gem "rubocop-rspec", "~> 2.2", require: false
gem 'active_model_serializers', '~> 0.10.12'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "shoulda-matchers"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
