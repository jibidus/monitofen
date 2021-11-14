# How to run Monitofen with a Docker 🐳?

1. Run `make docker-start` where `http://[boiler_url]` is the http base url to your boiler (ex: `http://192.168.1.2:80`).

2. Setup database with `make docker-db-setup`

Now, you can:

- Browse `http://localhost:3000` to see fake data on last 3 days.
- Or import real measures from your boiler with `make docker-import` before.

Note: `make docker-cleanup` can be useful to cleanup all docker images.

# How to install Monitofen on Raspberry Pi OS Lite 🍓?

## Overview

This setup will install the following components:

- PostgreSQL (service `postgresql`)
- Nginx (service `nginx`)
- Unicorn (service `unicorn_monitofen`)
- rvm
- git
- the Monitofen app
- a cron to import new measures every day

## Step by step

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
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install git postgresql postgresql-contrib libpq-dev nodejs nginx
sudo npm install --global yarn

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

cp infra-files/ ~/.monitofen_profile
# => Complete ~/.monitofen_profile

echo "[[ -r ~/.monitofen_profile ]] && . ~/.monitofen_profile" >> ~/.bashrc
echo "[[ -r ~/.monitofen_profile ]] && . ~/.monitofen_profile" >> ~/.bash_profile
source ~/.monitofen_profile

# Unicorn
mkdir -p shared/pids shared/sockets shared/log
sudo cp infra-files/init.d-unicorn_monitofen /etc/init.d/unicorn_monitofen
sudo chmod 755 /etc/init.d/unicorn_monitofen
sudo update-rc.d unicorn_monitofen defaults

# Nginx
sudo cp infra-files/nginx-config /etc/nginx/sites-available/default
sudo service nginx restart
```

2. Init db

```bash
cd ~/monitofen
rails db:setup
```

3. It's finished, you can now browse the raspberry on default http port (80)

# How to restart services

`Nginx` (with service named `nginx`) exposes `Unicorn` socket (with service named `unicorn_monitofen`), which runs rails app behind.

- use `systemctl restart nginx` to restart service.

# Where are logs?

There are many logs:

- `~/monitofen/logs/production.log`: application logs
- `/var/log/nginx/*.log`: nginx logs

You can also read service logs:

```
journalctl -fu nginx
```
