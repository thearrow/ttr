Tasting Table Restaurants
=====
Server/Database: Ruby on Rails + MySQL

Client: Steroids.js/Phonegap Hybrid Mobile App


One-Time Dev Setup
-----
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


Each Dev Session:
-----
1. `cd ttr` (navigate to project folder on your machine)
2. `git pull` (pull latest changes from github)
3. `vagrant up` (launch the vagrant vm)
4. `vagrant ssh` (log in to the vagrant vm)
5. `cd /vagrant` (navigate to the project folder on the vm)
6. `bundle exec rake db:migrate` and/or `bundle exec rake db:seed` to run db changes/fixtures
7. `rails s` (run the rails server on the vm)
8. Open a web browser on your local machine pointed at `0.0.0.0:3000`
9. To view the admin interface, go to `0.0.0.0:3000/admin` and login with `admin@example.com:password`

or
5. `steroids login` to log in to your AppGyver account

Any changes you make to the local project files using your favorite editor are instantly shared with the vm.

When you're finished, `exit` then `vagrant halt` shuts down the vm but keeps it on your hard drive. (quick `vagrant up` next time).
`exit` then `vagrant destroy` shuts down the vm and deletes it from your hard drive.