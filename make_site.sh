#!/bin/bash

# Reset
off='\033[0m'             # Text Reset
# Regular Colors
red='\033[0;31m'          # Red
green='\033[0;32m'        # Green
yellow='\033[0;33m'       # Yellow
blue='\033[0;34m'         # Blue
purple='\033[0;35m'       # Purple
cyan='\033[0;36m'         # Cyan

# # # # # # # # # # # # # # # # # #

# folders
ROOT=$(pwd)
WWW="$ROOT/www"
NGINX="$ROOT/etc/nginx"
SSL="$ROOT/etc/ssl"

# TEXT
DESCRIPTION="Это скрипт для добавления сайта. \
\n- добавляет новую директорию в 'www'\
\n- добавляет конфиг в 'etc/nginx/confg.d'\
\n- создает локальный сертификат в 'etc/ssl'\n\n\
Для начала работы введите название сайта например 'example.loc'\n"

DOMAIN_READ_DESC="Пожалуйста, введите название домена:"

QUESTION="Добавляем сайт"

# WAARNING
NOT_GOOD="${red} Сайт, не был добавлен${off}"
EMPTY_DOMAIN="${red} Вы ввели пустой домен${off}"
DIR_EXISTS="${red} Такая папка уже есть${off}"

OK="$green [OK] $off"

ADD_FOLDER="${green}Создаем директорию${off}"
ADD_NGINX_CONFIG="${green}Создаем конфиг nginx${off}"
ADD_SSL="${green}Создаем сертификат${off}"

# # # # # # # # # # # # # # # # # #

function __AddFolder {
  local DIR="$WWW/$1"

  echo -e $ADD_FOLDER
  echo -e -n $DIR

  if [[ -d "$DIR" ]]; then
    echo -e $DIR_EXISTS
    exit 1
  fi

  mkdir -p "$DIR/public"
  echo '<?php phpinfo();' > "$DIR/public/index.php"

  echo -e $OK
}

function __AddNginxConfig {
  local CONFIG_FILE="$NGINX/conf.d/$1.conf"

  echo -e $ADD_NGINX_CONFIG
  echo -e -n $CONFIG_FILE

  export NGINX_HOST=$1

  envsubst '$NGINX_HOST' < $NGINX/template.conf > $CONFIG_FILE

  echo -e $OK
}

function __AddSsl {
  echo -e $ADD_SSL
  local DOMAIN_NAME=$1

  cd $SSL

  echo `openssl req -x509 -out ${DOMAIN_NAME}.crt -keyout ${DOMAIN_NAME}.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=${DOMAIN_NAME}' -extensions EXT -config <( \
   printf "[dn]\nCN=${DOMAIN_NAME}\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:${DOMAIN_NAME}\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")`

  echo -e $OK
}

function __AddNewSite {
  __AddFolder $1
  __AddNginxConfig $1
  __AddSsl $1
}

# # # # # # # # # # # # # # # # # #

echo -e $DESCRIPTION
echo -e $DOMAIN_READ_DESC

read DOMAIN

if [ -z "$DOMAIN" ]; then
  echo -e $EMPTY_DOMAIN
  exit 1
fi

echo -en "$QUESTION '${green}${DOMAIN}${off}'? [y/N]: "
read item
case "$item" in
  y|Y) __AddNewSite "$DOMAIN" ;;
  *) echo -e $NOT_GOOD ;;
esac
