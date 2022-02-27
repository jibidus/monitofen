help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

start:
	bundle exec rails s

test: test-back test-front test-e2e ## Test application (backend and frontend)

test-back: ## Test backend
	FB_TRACE=1 bundle exec rspec

test-front: ## Test frontend
	yarn test

test-front-watch: ## Test frontend in watch mode
	yarn test --watch

test-front-coverage: ## Test frontend with coverage
	yarn test --coverage --passWithNoTests

test-e2e:
	bundle exec rake cypress:run

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

import: ## Import measurements from boiler

deploy: ## Deploy last version locally
	rails measurements:import
	git pull --rebase
	bundle install
	yarn install --frozen-lockfile
	bundle exec whenever --update-crontab
	rails db:migrate db:validate
	rails assets:precompile
	sudo service unicorn_monitofen stop
	sudo service unicorn_monitofen start
	echo "🎉 Deployment successful!"

docker-build:
	docker-compose build

docker-start:
	docker-compose up

docker-db-setup:
	docker-compose exec web rails db:setup

docker-import:
	docker-compose exec web rails measurements:reset measurements:import

docker-stop:
	docker-compose down

docker-cleanup:
	docker-compose down --volume --rmi local