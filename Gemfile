source 'http://rubygems.org'

gem 'rails', '3.2.14'
gem 'mysql2', '0.3.13'

# gem 'jquery-rails' # We use rails.js 1.4 to be compatible with Malmö Assets 2.0's jQuery 1.4
gem 'haml', '4.0.3'
gem "paperclip", '3.4.2'

gem 'rake', '10.0.4'
gem 'uglifier', '2.1.1'
gem "therubyracer", '0.11.4'
gem 'cocaine', '0.5.1'

# gem 'net-ldap', '= 0.2.2'
gem 'net-ldap', '0.3.1' # There is a bug in net-ldap v.0.3.1: https://github.com/ruby-ldap/ruby-net-ldap/issues/30
gem 'bcrypt-ruby', '3.0.1'

group :development do
  gem 'sqlite3'
  gem 'haml-rails', '0.4'
  gem 'quiet_assets'
  gem 'thin'
end

group  :staging, :test, :production do
  gem 'dalli', '2.6.4'
end

group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'therubyracer', '0.11.4', require: 'v8'
end

gem 'capistrano', '2.15.4'
gem 'capistrano-ext', '1.2.1'
