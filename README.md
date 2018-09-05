# KNX-Administration
This web application belongs to the bachelor thesis "Web-Frontend für KNX-basierte Home Automation-Installationen mit ereignisgesteuerter Aktualisierung über WebSockets" by Tim Kohlstadt. The application can be used to manage all connected KNX devices belonging to a KNX bus.

## System dependencies
* Ruby Version: 2.5.1

* Rails Version: 5.2.1

## Configuration
XML

### Install Ruby
```
\curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install ruby-2.5.1
rvm --default use ruby-2.5.1
gem update --system
```

### Install Rails
```
gem install rails
```

### Install Bundles
```
cd /path/to/knx_administration
gem install bundler
bundle update
bundle install
```

## Setup your database in the project
```
sudo nano /path/to/knx_administration/config/database.yml
```

Please change the username, the password and the path to your socket in the default settings at the top of the file.
(Line 16, 17, 18)

## Database creation
```
rails db:create
```

## Database initialization
```
rails db:migrate
```

## How to run the application
SEEDS=0/1: Define if seeds should be used or not<br/>
HOST_IP=own_ip_address: Set own ip address
```
SEEDS=1 HOST_IP=10.200.73.1 rails s
```

## How to run the test suite
```
rails test
```

## Login
URL:				<http://localhost:3000/de/my/users/sign_in>

Example user:		'admin'

Example password:	'123456'

## Author
Tim Kohlstadt, tim.kohlstadt@student.hs-rm.de
