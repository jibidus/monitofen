# How to contribute?

## Prerequisites

- `ruby` 2.7.2 (see [.ruby-version](../.ruby-version))
- `bundler`
- `Node` 14.16.0
- `yarn`

## Setup dev env

```bash
gem install bundler
bundle install
npm install -g yarn
yarn install
```

## How to validate new dev?

`make test lint`

## Tips

### How to pretty print object in rails console?

Use [ap](https://github.com/awesome-print/awesome_print):

```ruby
ap Metric.take
```
