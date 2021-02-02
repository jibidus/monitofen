[![Build Status](https://travis-ci.com/jibidus/monitofen.svg?branch=main)](https://travis-ci.com/jibidus/monitofen)

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  yarn add vue-turbolinks
* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# How to install on Raspberry Pi OS Lite

0. Setup Raspberry

```bash
# Generate ssh key
ssh-keygen -t ed25519 -C "your_email@example.com"
# Copy public key in clipboard
cat ~/.ssh/<public key> | pbcopy

# password: raspberry
ssh -o PubkeyAuthentication=no pi@192.168.1.XXX
# Start ssh server on startup in section "Interface Options"
sudo raspi-config
mkdir ~/.ssh
chmod 700 ~/.ssh
# Add public key from clipboard
vi ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

1. Install dependencies

```shell
sudo apt-get update
sudo apt-get full-upgrade
sudo apt-get install git postgresql postgresql-contrib libpq-dev

sudo su - postgtes
createuser pi -P --interactive

# Note: you may have to fetch a public key (see output in case of error)
curl -L https://get.rvm.io | bash -s stable --ruby
source ~/.bashrc

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
# Setup ssh key to access git repository
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/<ssh pub key>

cd ~/
git clone git@github.com:jibidus/monitofen.git

cd monitofen
rvm install ruby-2.7.2
bundle insall

echo '# Monifofen config' >> ~/.bashrc
echo 'export RAILS_ENV=production' >> ~/.bashrc
echo 'export MONITOFEN_DB_HOST="localhost"' >> ~/.bashrc
echo 'export MONITOFEN_DB_USERNAME="pi"' >> ~/.bashrc
echo 'export MONITOFEN_DB_PASSWORD="<pg_password>"' >> ~/.bashrc
echo 'export MONITOFEN_DB_NAME="monitofen"' >> ~/.bashrc
echo 'export MONITOFEN_BOILER_BASE_URL="<boiler base url (ex:http://192.168.1.2:80)>"' >> ~/.bashrc
echo "export SECRET_KEY_BASE=\"$(rails secret)\"" >> ~/.bashrc
source ~/.bashrc
```

2. Init db

```bash
cd ~/monitofen
rails db:setup
```

3. Setup crontab

```
make deploy-crontab
```

# How to import boiler measures manually?

```shell
rails measures:fetch
```

Where boiler url is `http://hostname:port` (ex: `http://192.168.1.10:8080`).

# How to pretty print object in rails console?

Use [ap](https://github.com/awesome-print/awesome_print):

```ruby
ap Metric.take
```

# Where to see logs?

```
~/monitofen/logs/production.log
```

# TODO

- [ ] PI: test schedule file importation
- [ ] PI: notify in case of error
- [ ] Automate deployment
