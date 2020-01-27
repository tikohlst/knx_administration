# KNX-Administration

This web application belongs to the bachelor thesis "Web-Frontend für KNX-
basierte Home Automation-Installationen mit ereignisgesteuerter Aktualisierung
über WebSockets" by Tim Kohlstadt. The application can be used to manage all
connected KNX devices belonging to a KNX bus. However, the communication of
this web application with the KNX devices is fundamentally based on the RubyGem
"knx4r" by Prof. Dr. Heinz Werntges, which hasn't been published yet.

## System dependencies

* Ruby Version: 2.5.1
* Rails Version: 5.2.1
* Redis Version: 4.0.9 (<https://redis.io/topics/quickstart>)

## Configuration

Set actors, sensors and devices in:

```
/config/knx_config.xml
```

### Install Ruby

```
\curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install ruby-2.5.1
rvm --default use ruby-2.5.1
gem update --system
```

### Install Bundles

```
cd /path/to/knx_administration
export RAILS_ENV=production HOST_IP=own_ip_address KNX_CONNECTION=0
gem install --local knx4r-0.8.11.gem
gem install bundler
bundle --without development
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
EDITOR=nano KNX_ADMINISTRATION_DATABASE_PASSWORD=1 bundle exec rails credentials:edit
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
KNX_CONNECTION=1 bundle exec rails s
```

## Login

URL: <http://localhost:3000/en/login>

Example user: 'admin'

Example password: '123456'

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

KNX-Administration is developed by
[Tim Kohlstadt](mailto:tim.kohlstadt@student.hs-rm.de). It is released under
the [MIT](./LICENSE) License.
