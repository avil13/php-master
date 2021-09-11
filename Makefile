# Makefile for Docker Nginx PHP Composer MySQL

include .env

# MySQL
MYSQL_DUMPS_DIR=data/db/dumps

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  sh                 Bash interface in workspace"
	@echo "  add                Add site"
	@echo "  up                 Create and start containers"
	@echo "  stop               Stop and clear all services"
	@echo "  logs               Follow log output"
	@echo "  mysql-dump         Create backup of all databases"
	@echo "  mysql-restore      Restore backup of all databases"
	@echo "  rm                 Remove containet"
	@echo "  clean              Clean directories for reset all"

init:
	$(shell pwd)
	@echo "  test                Test application"
	@docker exec -it php bash

sh:
	@docker exec -it php bash

add:
	./add_site.sh

rm:
	@docker stop $(docker ps -a -q)
	@docker rm $(docker ps -a -q)

clean:
	@rm -Rf data/db/mysql/*
	@rm -Rf etc/ssl/*
	@rm -Rf etc/nginx/conf.d/*
	@rm -Rf www/*

docker-start:
	@docker-compose up

up:
	@docker-compose up -d

stop:
	@docker-compose down -vlogs

ps:
	@docker ps

logs:
	@docker-compose logs -f

mysql-dump:
	@mkdir -p $(MYSQL_DUMPS_DIR)
	@docker exec $(shell docker-compose ps -q mysqldb) mysqldump --all-databases -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" > $(MYSQL_DUMPS_DIR)/db.sql 2>/dev/null
	@make resetOwner

mysql-restore:
	@docker exec -i $(shell docker-compose ps -q mysqldb) mysql -u"$(MYSQL_ROOT_USER)" -p"$(MYSQL_ROOT_PASSWORD)" < $(MYSQL_DUMPS_DIR)/db.sql 2>/dev/null

.PHONY: help
