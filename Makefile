test:
	bundle exec rspec

lint:
	bundle exec rubocop
	bundle exec rails_best_practices .

security:
	bundle exec bundle-audit

import:
	rails measures:fetch

deploy-crontab:
	bundle exec whenever --update-crontab
