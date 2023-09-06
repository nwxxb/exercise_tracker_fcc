# frozen_string_literal: true

source "https://rubygems.org"

gem 'dotenv'
gem 'puma'
gem 'rack', '~> 2.2'
gem 'shotgun3'
gem 'sinatra'

group :development, :test do
  gem 'pry'
  gem 'pry-remote'
  gem 'ripper-tags', require: false
  gem 'rubocop', '~> 1.54', require: false
  gem 'rubocop-rspec', '~> 2.22', require: false
end

group :test do
  gem 'rack-test', '~> 2.1'
  gem 'rspec'
end
