echo =========SETUP TTR PROJECT=========
cd /vagrant
bundle install
bundle exec rake db:create RAILS_ENV=development
bundle exec rake db:migrate RAILS_ENV=development
gem install rails --no-ri --no-rdoc