build:
	docker build -t okovision .

start:
	docker-compose up

stop:
	docker-compose down --volumes

bash:
	docker-compose run okovision bash