SERVICE_NAME=crud-databases
CXX = g++
CXXFLAGS= --std=c++11
BIN = bin/

# MONGODB CPP
PATH_SRC_MONGODB_CPP = databases/nosql/mongodb/cpp
FILENAME_BIN_MONGODB_CPP = crud_mongodb_cpp

# MONGODB PYTHON
PATH_SRC_MONGODB_PYTHON = databases/nosql/mongodb/python

build:
	@docker-compose build

build-mongodb-c++:
	docker-compose run --rm ${SERVICE_NAME} $(CXX) $(CXXFLAGS) $(PATH_SRC_MONGODB_CPP)/crud.cc -o $(BIN)/$(FILENAME_BIN_MONGODB_CPP) -I/usr/local/include/mongocxx/v_noabi -I/usr/local/include/bsoncxx/v_noabi -L/usr/local/lib -lmongocxx -lbsoncxx -Wl,-rpath,/usr/local/lib

build-no-cache:
	@docker-compose build --no-cache

shell:
	@docker-compose exec ${SERVICE_NAME} bash

up:
	@docker-compose up

run-mongodb-c++:
	@docker-compose run --rm ${SERVICE_NAME} $(BIN)/$(FILENAME_BIN_MONGODB_CPP)

run-mongodb-python:
	@docker-compose run --rm ${SERVICE_NAME} python $(PATH_SRC_MONGODB_PYTHON)/crud.py

up-silent:
	@docker-compose up -d ${SERVICE_NAME}



