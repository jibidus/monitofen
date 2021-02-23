[![Build Status](https://travis-ci.com/jibidus/monitofen.svg?branch=main)](https://travis-ci.com/jibidus/monitofen)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0f6afb0f6da8272fc532/test_coverage)](https://codeclimate.com/github/jibidus/monitofen/test_coverage)

:warning: Under development

# What is monitofen?

Monitofen is used to **monitor** measures of an **Okofen boiler**.
Measures are imported daily and are exposed through a webapp.

# Why not using [Okovision](http://okovision.dronek.com)?

Because I did not manage to install it in a Docker container, and when I tried to contribute, I was discouraged by the lack of automated tests (among others).

It is unfortunate, since `Okovision` brings a lot of interesting features.

# How to install on Raspberry Pi OS Lite?

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

echo '# Monifofen config' >> ~/.monitofen_profile
echo 'export RAILS_ENV=production' >> ~/.monitofen_profile
echo 'export MONITOFEN_DB_HOST="localhost"' >> ~/.monitofen_profile
echo 'export MONITOFEN_DB_USERNAME="pi"' >> ~/.monitofen_profile
echo 'export MONITOFEN_DB_PASSWORD="<pg_password>"' >> ~/.monitofen_profile
echo 'export MONITOFEN_DB_NAME="monitofen"' >> ~/.monitofen_profile
echo 'export MONITOFEN_BOILER_BASE_URL="<boiler base url (ex:http://192.168.1.2:80)>"' >> ~/.monitofen_profile
echo 'export SENDGRID_API_KEY="<send grid API key>"' >> ~/.monitofen_profile
echo "export SECRET_KEY_BASE=\"$(rails secret)\"" >> ~/.monitofen_profile

echo "[[ -r ~/.monitofen_profile ]] && . ~/.monitofen_profile" >> ~/.bashrc
echo "[[ -r ~/.monitofen_profile ]] && . ~/.monitofen_profile" >> ~/.bash_profile
source ~/.monitofen_profile
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
rails measures:import[<boiler url>]
```

Where boiler url is `http://hostname:port` (ex: `http://192.168.1.10:8080`).

Note: `[<boiler url>]` can be removed for the benefit of the `MONITOFEN_BOILER_BASE_URL` env var.

# How to pretty print object in rails console?

Use [ap](https://github.com/awesome-print/awesome_print):

```ruby
ap Metric.take
```

# Where are logs?

Logs are in the usual location for a rail application:

```
~/monitofen/logs/production.log
```

# TODO

- [ ] import: force importation of a given file
- [ ] Use https://github.com/djezzzl/factory_trace
