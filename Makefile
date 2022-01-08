# Makefile for Docker Nginx PHP MySQL

include .env

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "\033[0;32m sh    \033[0m	Bash interface in workspace"
	@echo "\033[0;32m add   \033[0m	Add site"
	@echo "\033[0;32m up    \033[0m	Create and start containers [docker]"
	@echo "\033[0;32m down  \033[0m	Stop and clear all services [docker]"
	@echo "\033[0;32m ps    \033[0m	List containers             [docker]"
	@echo "\033[0;32m rm    \033[0m	Remove containers           [docker]"
	@echo "\033[0;32m rmall \033[0m	Remove all images           [docker]"
	@echo "\033[0;32m logs  \033[0m	Follow log output           [docker]"
	@echo "\033[0;32m clean \033[0m	Clean directories for reset all"

init:
	$(shell pwd)
	@echo "  test                Test application"
	@docker exec -it php bash

sh:
	@docker exec -it php bash

add:
	./add_site.sh

rm:
	@docker-compose down --rmi local

rmall:
	@docker stop $(docker ps -a -q)
	@docker rm $(docker ps -a -q)

up:
	@docker-compose up -d

down:
	@docker-compose down

ps:
	@docker ps

logs:
	@docker-compose logs -f

clean:
	@rm -Rf data/db/mysql/*
	@rm -Rf etc/ssl/*
	@rm -Rf etc/nginx/conf.d/*
	@rm -Rf www/*

.PHONY: help
