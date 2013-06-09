set :rails_env, "production"
set :deploy_to, "/var/www/nursing-homes/production"
set :bundle_without, [:development, :test, :staging]
set :bundle_dir, ""
set :bundle_flags, ""
