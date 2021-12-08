# Monitofen [![Build Status][ci-image]][ci] [![Code Climate][grade-image]][grade]

## What is monitofen?

Monitofen is used to **monitor** measures of an **Okofen boiler**.
Measures are imported daily and are exposed through a webapp.

## Why not using [Okovision](http://okovision.dronek.com)?

Because I did not manage to install it in a Docker container, and when I tried to contribute, I was discouraged by the lack of automated tests (among others).

It is unfortunate, since `Okovision` brings a lot of interesting features.

## What can I do with Monitofen?

- Daily import of measurements
- Visualize measures by selecting a day and a metric

## 🐳 How to test Monitofen?

See [Docker setup](doc/infra.md).

## How to install?

Here is a tutorial to [install Monitofen on Raspberry Pi OS Lite](doc/infra.md).

## How to deploy new version once installed?

```
make deploy
```

## How to import boiler measures manually from boiler url?

```shell
rails "measures:import[<boiler url>]"
```

Where boiler url is `http://hostname:port` (ex: `http://192.168.1.10:8080`).

Note: `[<boiler url>]` can be removed for the benefit of the `MONITOFEN_BOILER_BASE_URL` env var.

## How to import boiler measures manually from filesystem?

```shell
rails "measures:import[<measures file path>]"
```

## TODO

- [ ] s/Measure/Measurement
- [ ] Docker env: reduce docker image size (see https://github.com/progapandist/anycable_rails_demo/blob/master/.dockerdev/Dockerfile.multi)
- [ ] Docker env: test image & docker-compose
- [ ] Front: use kebab-case syntax for custom components in templates  
- [ ] Front: filter measures by time period
- [ ] Migrate to TypeScript
- [ ] Dev: front auto-reload
- [ ] Dev: move stats floating div on the right (and breakpoint on bottom right) 
- [ ] Vuetify dark theme
- [ ] Front tests: replace RSpec style by JUnit style
- [ ] i18n (metrics label, graph infos... start with all in english)
- [ ] Integrate linters with [reviewdog](https://github.com/reviewdog/reviewdog)
- [ ] Harmonize NodeJS versions (infra doc VS Dockerfile VS ci)
- [ ] Bug: measures importation when 1 file already imported (output is wrong)
- [ ] Bug: (chart) first hours of day are wrong ("Dev 7, 2021, 12:00:00am" instead of "Dev 7, 2021, 00:00:00am" or "Dev 6, 2021, 12:00:00am")
- [ ] Display measures units

## Additional documentation

- [how to contribute?](doc/dev.md)

[ci-image]: https://github.com/jibidus/monitofen/actions/workflows/ci.yml/badge.svg
[ci]: https://github.com/jibidus/monitofen/actions/workflows/ci.yml
[grade-image]: https://codeclimate.com/github/jibidus/monitofen/badges/gpa.svg
[grade]: https://codeclimate.com/github/jibidus/monitofen
