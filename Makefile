SERVICE_NAME=crud-databases

build:
	@docker-compose build

build-no-cache:
	@docker-compose build --no-cache

shell:
	@docker-compose exec ${SERVICE_NAME} bash

up:
	@docker-compose up

up-silent:
	@docker-compose up -d ${SERVICE_NAME}

