help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: test-back test-front ## Test application (backend and frontend)

test-back: ## Test backend
	FB_TRACE=1 bundle exec rspec

test-front: ## Test frontend
	yarn test

test-front-watch: ## Test frontend in watch mode
	yarn test --watch

test-front-coverage: ## Test frontend with coverage
	yarn test --coverage --passWithNoTests

lint: lint-back lint-front ## Check file format, smell code, conventions…

lint-back: ## Lint backend files
	bundle exec rubocop
	bundle exec rails_best_practices .

lint-back-fix: ## Fix backend violations when possible
	bundle exec rubocop -a

lint-front: ## Lint frontend files
	yarn eslint "app/javascript/**"

lint-front-fix: ## Fix backend violations when possible
	yarn eslint --fix "app/javascript/**"

security: ## Check security alerts in gems
	bundle exec bundle-audit

import: ## Import measures from boiler
	rails measures:import

deploy: ## Deploy last version locally
	git pull --rebase
	bundle install
	yarn install --frozen-lockfile
	bundle exec whenever --update-crontab
	rails db:migrate db:validate
	rails assets:precompile
	sudo service unicorn_monitofen stop
	sudo service unicorn_monitofen start
	echo "🎉 Deployment successful!"

docker-rebuild:
	docker image build --no-cache -t monitofen .

docker-start:
	docker image build -t monitofen .
	docker run --rm -it -v `pwd`:/monitofen:cached -p 3000:3000 monitofen