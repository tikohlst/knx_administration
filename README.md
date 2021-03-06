# KNX-Administration

This web application belongs to the bachelor thesis "Web-Frontend für KNX-
basierte Home Automation-Installationen mit ereignisgesteuerter Aktualisierung
über WebSockets" by Tim Kohlstadt. The application can be used to manage all
connected KNX devices belonging to a KNX bus. The [RheinMain University of
Applied Sciences](https://www.hs-rm.de/de/) is currently using this web
application to diagnose and manage their KNX and EnOcean actuators and sensors
in several auditoriums. However, the communication of this web application with
the KNX devices is fundamentally based on the RubyGem "knx4r" by Prof. Dr.
Heinz Werntges, which hasn't been published yet.

## System dependencies

* Ruby: 2.7.1
* Rails: ~> 6.0
* Redis: 4.2.1 (<https://redis.io/topics/quickstart>)

## Configuration

Set actors, sensors and devices in:

```
/config/knx_config.xml
```

### Install Ruby

```
\curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install ruby-2.7.1
rvm --default use ruby-2.7.1
gem update --system
```

### Install Bundles

```
cd /path/to/knx_administration
export RAILS_ENV=production HOST_IP=own_ip_address KNX_CONNECTION=0
gem install --local knx4r-0.8.11.gem
gem install bundler
bundle config set without 'development'
bundle
```

## Setup your database in the project

Change the path to your socket in the default settings (line 12) and the
username in the production settings (line 47):

```
nano config/database.yml
```

Generate a new secret key and write it together with your database password in
the credentials:

```
rm config/credentials.yml.enc
bin/rails secret
EDITOR=vim bundle exec rails credentials:edit --environment production
```

```
secret_key_base: new_generated_key
production:
  mysql:
    password: own_database_password

test:
  mysql:
    password: own_test_database_password
```

Or set an environment variable:
http://guides.rubyonrails.org/configuring.html#configuring-a-database

## Database creation

```
bundle exec rails db:create
```

## Database initialization

```
bundle exec rails db:migrate
SEEDS=1 bundle exec rails db:seed
```

## Precompile assets

```
bundle exec rails assets:precompile
```

## How to run the application

Run redis and the puma webserver:

```
redis-server &
export RAILS_SERVE_STATIC_FILES=1
KNX_CONNECTION=1 bundle exec rails s
```

## Login

URL: <http://localhost:3000/en/login>

Example user: 'admin'

Example password: '123456'

![Login screen](/Screenshot_login_screen.png?raw=true "Login screen")

![Lighting widgets](/Screenshot_lighting_widgets.png?raw=true "Lighting widgets")

## How to run the test suite

Run normal tests:

```
RAILS_ENV=test bin/rails test
```

Run system tests:

```
RAILS_ENV=test bin/rails test:system
```

Run normal and system tests together:

```
RAILS_ENV=test bin/rails test:system test
```

## License

KNX-Administration is licensed under the MIT license. See [LICENSE-file](./LICENSE) for details.

## Copyright

Copyright (c) 2020 [Tim Kohlstadt](mailto:info@tikohlst.de).
