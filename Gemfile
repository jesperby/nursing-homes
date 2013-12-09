source 'http://rubygems.org'

gem 'rails', '3.2.16'
gem 'mysql2', '0.3.14'

gem 'jquery-rails', '3.0.4'
gem 'haml', '4.0.4'
gem "paperclip", '3.5.2'

gem 'uglifier', '2.3.2'

# gem 'net-ldap', '= 0.2.2' # Check 0.5.0 on Github
gem 'net-ldap', '0.3.1' # There is a bug in net-ldap v.0.3.1: https://github.com/ruby-ldap/ruby-net-ldap/issues/30
gem 'bcrypt-ruby', '3.1.2'

group :development do
  gem 'sqlite3'
  gem 'haml-rails'
  gem 'quiet_assets'
  gem 'thin'
end

group  :staging, :test, :production do
  gem 'dalli', '2.6.4'
end

group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'therubyracer', '0.12.0', require: 'v8'
end

gem 'capistrano', '~> 2.15.5'
gem 'capistrano-ext', '1.2.1'
