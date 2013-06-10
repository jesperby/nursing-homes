NursingHomes::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # App root if mounted in a subdir
  config.action_controller.relative_url_root = "/aldreboenden-test"

  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store, '127.0.0.1:11211', { namespace: "nursing-homes-test" }


  config.log_level = :info

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :scss

  # Generate digests for assets URLs
  config.assets.digest = true

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # ImageMagick resize. (Use "which convert" path)
  Paperclip.options[:command_path] = "/usr/bin/"

  # Rails 3.2 below

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

end
