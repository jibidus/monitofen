help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: ## Test application
	bundle exec rspec

lint: ## Check file format, smell code, conventions…
	bundle exec rubocop
	bundle exec rails_best_practices .

lint-fix: ## Fix violations when possible
	bundle exec rubocop -a

security: ## Check security alerts in gems
	bundle exec bundle-audit

import: ## Import measures from boiler
	rails measures:import

deploy: ## Deploy last version locally
	git pull --rebase
	bundle install
	bundle exec whenever --update-crontab
	rails db:migrate
