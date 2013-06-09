set :rails_env, "staging"
set :deploy_to, "/var/www/nursing-homes/staging"
set :bundle_without, [:development, :production, :test]
set :bundle_dir, ""
set :bundle_flags, ""
