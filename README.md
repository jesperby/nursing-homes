# Nursing Homes
Nursing Homes, “Hitta & jämför äldreboenden”, is a Ruby on Rails based application that makes it easy for citizens to compare residential care for elderly.

For more information about the application, contact cwg@malmo.se.

## Dependencies
* Ruby >=1.9.3
* Ruby on Rails >=3.2
* MySQL or PostgreSQL
* LDAP for authentication
* ImageMagick
* Asset files from an [asset host](http://malmo.se/wag)
* The application is integrated with City of Malmö’s maps service, both for displaying objects on a map and for address lookup when adding and editing objects.

## Setup
Use `app_config.yml.example` and `database.yml.example` as templates for you own settings. Install the dependencies. Run the following to install the required Ruby Gems, create the database and start the application:

```shell
$ bundle install
$ rake db:schema:load
$ rails s
```

Note: Use only `rake db:schema:load` on an empty database, otherwise use `rake db:migrate`.

## Build and Deployment
The application is built and deployed using Capistrano. Deployment scripts are included in the source code. To set your deployment configuration:

1. Copy `config/deploy.yml.example` to `config/deploy.yml` and change the settings.
2. Edit `config/deploy.rb` and the environment files in the `config/deploy/` directory if needed.

Run the deployment script with one of the following command including the environment name:

```
$ cap staging deploy
$ cap production deploy
```

A database backup is performed on the server before deployment. Database migrations and `bundle` are run before the application i restarted.

## License
Released under AGPL version 3.

The `vendor` and `public/ckeditor` directories contains third party code that may be released under other licenses stated in the start of each file or separate license files.
