sudo apt-get update
sudo apt-get -q -y install software-properties-common python-software-properties curl zip

echo =========INSTALLING GIT=========
sudo apt-get -q -y install git-core

echo =========INSTALLING RUBY 2.0 USING RVM=========
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
cd
curl -L https://get.rvm.io | bash -s stable --auto-dotfiles
echo source ~/.profile >> ~/.bash_profile
source .bash_profile
rvm install 2.0.0
rvm use 2.0.0 --default
ruby -v
gem install chef

echo =========INSTALLING PYTHON FOR STEROIDS.JS=========
sudo add-apt-repository ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get -q -y install python2.7

echo =========INSTALLING NODE.JS=========
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get -q -y install nodejs

echo =========INSTALLING STEROIDS.JS=========
sudo npm install steroids -g