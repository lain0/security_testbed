make start:
	rm -f tmp/pids/server.pid && docker-compose up

make bash:
	docker-compose run app bash
