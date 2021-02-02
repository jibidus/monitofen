test:
	bundle exec rspec

lint:
	bundle exec rubocop

import:
	rails measures:fetch[$MONITOFEN_BOILER_URL]

