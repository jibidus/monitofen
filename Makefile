build:
	docker build -t okovision .

start:
	docker run --rm -p 8080:80 okovision

bash:
	docker run --rm -it -p 8080:80 okovision bash