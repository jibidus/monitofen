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
echo "export SECRET_KEY_BASE=\"$(rails secret)\"" >> ~/.bashrc
source ~/.bashrc
```

2. Init db

```bash
cd ~/monitofen
rails db:setup
```

3. Setup crontab (with `crontab -e`):

```
0 5 * * 1,3,5 cd ~/monitofen && rails measures:fetch[http://192.168.1.XXX:YYYY]
```

# How to import boiler measures manually?

```shell
rails measures:fetch[<boiler url>]
```

Where boiler url is `http://hostname:port` (ex: `http://192.168.1.10:8080`).

# Where to see logs?

```
~/monitofen/logs/production.log
```

# TODO

- [ ] PI: test schedule file importation
- [ ] Gems: add and configure following gems:
  * Brakeman
  * Bundler-audit
  * Awesome_print
  * Whenever
- [ ] PI: notify in case of error
- [ ] Install [Rubocop](https://github.com/rubocop-hq/rubocop)
- [ ] Study [Sublim plugins](https://mattbrictson.com/sublime-text-3-recommendations)

# Get measures

List available measures:

```bash
http GET http://192.168.1.23:8080/logfiles/pelletronic/
```

Download 1 CSV file:

```bash
curl -C GET http://192.168.1.23:8080/logfiles/pelletronic/touch_20201027.csv
```

- First column is date
- 2nd column is hour
- other columns title are translated in titles.csv (can be downloaded like CSV files)


# Login

```
curl 'http://192.168.1.23:8080/index.cgi' \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: max-age=0' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Origin: http://192.168.1.23:8080' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Referer: http://192.168.1.23:8080/login.cgi' \
  -H 'Accept-Language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cookie: language=fr' \
  --data-raw 'username=P0060B5_35EB44&password=0k0fen&language=fr&submit=Acc%C3%A8s' \
  --compressed \
  --insecure \
  -c cookies.txt
```

Note: this will save session cookie in cookies.txt

# Get data

```
curl 'http://192.168.1.23:8080/?action=get&attr=1' \
  -H 'Accept-Language: fr' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-raw '["CAPPL:LOCAL.L_aussentemperatur_ist","CAPPL:FA[0].L_kesselstatus","CAPPL:FA[0].L_kesseltemperatur","CAPPL:FA[0].L_kesseltemperatur_soll_anzeige","CAPPL:LOCAL.L_ke_brennerkontakt_1","CAPPL:LOCAL.L_weather_clouds","CAPPL:LOCAL.L_weather[0]","CAPPL:LOCAL.weather_config","CAPPL:LOCAL.L_fernwartung_datum_zeit_sek","CAPPL:LOCAL.L_zaehler_fehler"]' \
  -b cookies.txt
```

Session cookie will be retrieved from cookies.txt

# Get warnings

```
curl 'http://192.168.1.23:8080/?action=get&attr=1' \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'Accept-Language: fr' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Origin: http://192.168.1.23:8080' \
  -H 'Referer: http://192.168.1.23:8080/' \
  --data-raw '["CAPPL:LOCAL.L_fernwartung_datum_zeit_sek","CAPPL:LOCAL.L_fehlerlog[0].code","CAPPL:LOCAL.L_fehlerlog[0].date","CAPPL:LOCAL.L_fehlerlog[1].code","CAPPL:LOCAL.L_fehlerlog[1].date","CAPPL:LOCAL.L_fehlerlog[2].code","CAPPL:LOCAL.L_fehlerlog[2].date","CAPPL:LOCAL.L_fehlerlog[3].code","CAPPL:LOCAL.L_fehlerlog[3].date","CAPPL:LOCAL.L_fehlerlog[4].code","CAPPL:LOCAL.L_fehlerlog[4].date","CAPPL:LOCAL.L_fehlerlog[5].code","CAPPL:LOCAL.L_fehlerlog[5].date","CAPPL:LOCAL.L_fehlerlog[6].code","CAPPL:LOCAL.L_fehlerlog[6].date","CAPPL:LOCAL.L_fehlerlog[7].code","CAPPL:LOCAL.L_fehlerlog[7].date","CAPPL:LOCAL.L_fehlerlog[8].code","CAPPL:LOCAL.L_fehlerlog[8].date","CAPPL:LOCAL.L_fehlerlog[9].code","CAPPL:LOCAL.L_fehlerlog[9].date","CAPPL:LOCAL.L_fehlerlog[10].code","CAPPL:LOCAL.L_fehlerlog[10].date","CAPPL:LOCAL.L_fehlerlog[11].code","CAPPL:LOCAL.L_fehlerlog[11].date","CAPPL:LOCAL.L_fehlerlog[12].code","CAPPL:LOCAL.L_fehlerlog[12].date","CAPPL:LOCAL.L_fehlerlog[13].code","CAPPL:LOCAL.L_fehlerlog[13].date","CAPPL:LOCAL.L_fehlerlog[14].code","CAPPL:LOCAL.L_fehlerlog[14].date","CAPPL:LOCAL.L_fehlerlog[15].code","CAPPL:LOCAL.L_fehlerlog[15].date","CAPPL:LOCAL.L_fehlerlog[16].code","CAPPL:LOCAL.L_fehlerlog[16].date","CAPPL:LOCAL.L_fehlerlog[17].code","CAPPL:LOCAL.L_fehlerlog[17].date","CAPPL:LOCAL.L_fehlerlog[18].code","CAPPL:LOCAL.L_fehlerlog[18].date","CAPPL:LOCAL.L_fehlerlog[19].code","CAPPL:LOCAL.L_fehlerlog[19].date","CAPPL:LOCAL.L_weather_clouds","CAPPL:LOCAL.L_weather[0]","CAPPL:LOCAL.weather_config","CAPPL:LOCAL.L_zaehler_fehler"]' \
  --compressed \
  --insecure \
  -b cookies.txt
```

Response:
```
[
	{ // code of line #19
		name: "CAPPL:LOCAL.L_fehlerlog[19].code",
		value: "504501207"
		…
	},
	{ // date of line #19
		name: "CAPPL:LOCAL.L_fehlerlog[19].date",
		value: "1603716437.966000",
		…
	},
	…
]

- value is the date computed like this:
```
d = new Date
d.setTime((value + date.value.getTimezoneOffset() * 60) * 1E3);

- Status is based on `parseInt(code.value.substr(6, 1))`, which is the index of `[, "C", "Q", "G"]`

- `parseInt(code.value.substr(4, 2))` is parameter (`%n`) of `MsgText[e]` (see `language.js`), where `e = g + "," + j, with `g = parseInt(e.substr(0, 1))` and `j = parseInt(e.substr(1, 3))` (ex: `e="5,45"`)

# i18n

```
"5,45": "PE %n Ecluse CF / granulés présents ? [5045]"
```

```
curl 'http://192.168.1.23:8080/lang/language.cgi' \
  -H 'Connection: keep-alive' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Accept: */*' \
  -H 'Referer: http://192.168.1.23:8080/' \
  -H 'Accept-Language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cookie: language=fr; pksession=52501' \
  --compressed \
  --insecure
```


# Known issues

`bundle install` failed in ffi: install `ffi`manually with `gem install ffi -- --disable-system-libffi`
