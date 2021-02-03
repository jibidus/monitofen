help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: ## Test application
	bundle exec rspec

lint: ## Check file format, smell code, conventions…
	bundle exec rubocop
	bundle exec rails_best_practices .

security: ## Check security alerts in gems
	bundle exec bundle-audit

import: ## Import measures from boiler
	rails measures:fetch

deploy-crontab: ## Deploy scheduled job to crontab
	bundle exec whenever --update-crontab
