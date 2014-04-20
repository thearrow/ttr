# Tasting Table Restaurants

## About

####Server
[Admin Interface](http://ttrestaurants.herokuapp.com/)

[JSON API](http://ttrestaurants.herokuapp.com/restaurants)

Ruby on Rails app with admin interface and JSON API. Administrators can enter information about restaurants and this data is pulled into the mobile app via the API.

Built With:
- [rails_admin](https://github.com/sferik/rails_admin)
- [geokit_rails](https://github.com/geokit/geokit-rails)
- [memcached](http://memcached.org/)
- [UrbanAirship](http://urbanairship.com/)
- Hosted on [Heroku](http://heroku.com)

####Mobile App
[Online App Demo](https://share.appgyver.com/?id=5345&hash=d349bc95f71feb3c50618dc0e3bfa2e681fc294ecd3638e7091f0daea79d67d4&device_type=iphone)

Cross-platform (iOS and Android) mobile app that displays the information about restaurants pulled from the server.

Built With:
- [Steroids.js](http://www.appgyver.com/steroids)
- [AngularJS](https://angularjs.org/)
- [Topcoat](http://topcoat.io/)
- [Hammer.js](http://eightmedia.github.io/hammer.js/)
- [Google Maps API](https://developers.google.com/maps/)

---

## Deployment

#### Server (Rails) Configuration
- Deploy like any other Rails app with a MySQL Database. Memcached is optional.
- Environment variables UA_APP_KEY, UA_APP_SECRET, UA_MASTER_SECRET must be set to corresponding UrbanAirship keys. You can get these keys by creating a new PRODUCTION app at urbanairship.com and configuring it with the appropriate apple push certificates. The free plan is limited to 1,000,000 pushes/month.

#### Client (Steroids.js) Configuration
- Make sure Line #10 of `/mobileapp/app/models/places.coffee` has the correct address of the rails server you set up above.
- Run `steroids deploy` inside `/mobileapp`
- Log in to [AppGyver Cloud Services](https://cloud.appgyver.com)
- Follow their guides for configuring iOS and Android build settings, including specifying the UrbanAirship keys and app icons (included in `/mobileapp/icons` and `/mobileapp/splashscreens`).

---

## Development

#### Vagrant Setup (Optional)
If you have trouble getting vagrant working, or you already have the dependencies installed, feel free to run the app locally!
This is a bit of downloading & installing (~500MB between VirtualBox and the VM image).
But I think it's worth it to have an automated, uniform dev environment across our team (and any TT devs later).

This process installs the following on a fresh Ubuntu 12.04 VM:
git, rvm, ruby, python, nodejs, steroids.js, mysql.
Then all the gems required for the project are installed.
Then the mysql database is created & configured.

1. [Download and install Git](http://git-scm.com/downloads)
2. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. [Download and install Vagrant](http://downloads.vagrantup.com/)
4. Clone the git repo: `git clone git@github.com:thearrow/ttr.git`
5. `cd ttr`
6. `vagrant plugin install vagrant-berkshelf`
7. `vagrant up`
8. If `vagrant up` did not provision the box (install all the dependencies), run: `vagrant provision`
(Provisioning might take forever...and may appear to hang... go do something else and leave it be.)

#### Example Vagrant Workflow
1. `cd ttr` (navigate to project folder on your machine)
2. `git pull` (pull latest changes from github)
3. `vagrant up` (launch the vagrant vm)
4. `vagrant ssh` (log in to the vagrant vm)
5. `cd /vagrant` (navigate to the project folder on the vm)

#### Server (Rails) Development
1. `bundle exec rake db:migrate` and/or `bundle exec rake db:seed` to run db changes/fixtures
2. `rails s` (run the rails server on the vm)
3. Open a web browser on your local machine pointed at `0.0.0.0:3000`
4. To view the admin interface login with `admin@example.com:password`

#### Client (Steroids.js) Development
1. `cd mobileapp`
2. `steroids login` (only once)
3. `steroids connect --debug`
- If developing in the vagrant environment:
  1. Copy and paste the url (like `http://127.0.0.1:4567/__appgyver/connect/qrcode.html?qrCodeData=appgyver...`) to your local browser
  2. Replace the `appgyver=...` with `appgyver%3A%2F%2F%3Fips%3D%255B%2522{YOUR MACHINE'S IP ADDRESS}%2522%255D%26port%3D4567`
     where {YOUR MACHINE'S IP ADDRESS} is it's LAN IP like mine was 192.168.0.14
  3. Download the AppGyver Scanner app on your phone and scan the QR code displayed in step 6.

In /mobileapp/app/models/restaurant.js the uri of the api needs to be updated to either your local machine's ip or the heroku address (later).
Any changes you make to the local project files using your favorite editor are instantly shared with the vm.
When you're finished, `exit` then `vagrant halt` shuts down the vm but keeps it on your hard drive. (quick `vagrant up` next time).
`exit` then `vagrant destroy` shuts down the vm and deletes it from your hard drive.


