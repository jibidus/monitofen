# Monitofen [![Build Status][ci-image]][ci] [![Code Climate][grade-image]][grade]

## What is monitofen?

Monitofen is used to **monitor** measures of an **Okofen boiler**.
Measures are imported daily and are exposed through a webapp.

## Why not using [Okovision](http://okovision.dronek.com)?

Because I did not manage to install it in a Docker container, and when I tried to contribute, I was discouraged by the lack of automated tests (among others).

It is unfortunate, since `Okovision` brings a lot of interesting features.

## How to install?

Here is a tutorial to [install Monitofen on Raspberry Pi OS Lite](doc/infra.md).

## How to deploy new version?

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

- [ ] Front: use kebab-case syntax for custom components in templates
- [ ] Front: use kebab-case syntax for custom components in templates  
- [ ] Front: filter measures by time period
- [ ] Migrate to TypeScript
- [ ] Dev: front auto-reload
- [ ] Dev: move stats floating div on the right (and breakpoint on bottom right) 
- [ ] Vuetify dark theme
- [ ] Front tests: replace RSpec style by JUnit style
- [ ] Use https://github.com/djezzzl/factory_trace
- [ ] i18n

## Additional documentation

- [dev tips](doc/dev.md)

[ci-image]: https://github.com/jibidus/monitofen/actions/workflows/ci.yml/badge.svg
[ci]: https://github.com/jibidus/monitofen/actions/workflows/ci.yml
[grade-image]: https://codeclimate.com/github/jibidus/monitofen/badges/gpa.svg
[grade]: https://codeclimate.com/github/jibidus/monitofen
