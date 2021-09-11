#!/bin/bash

# Reset
off='\033[0m'             # Text Reset
# Regular Colors
red='\033[0;31m'          # Red
green='\033[0;32m'        # Green
yellow='\033[0;33m'       # Yellow

# # # # # # # # # # # # # # # # # #

# folders
ROOT=$(pwd)
WWW="$ROOT/www"
NGINX="$ROOT/etc/nginx"
SSL="$ROOT/etc/ssl"

# TEXT
DESCRIPTION="This is a script for adding a site. \
\n- Adds a new directory to the 'www'\
\n- Adds config to 'etc/nginx/confg.d'\
\n- Creates a local certificate in 'etc/ssl'.\n\n
To get started, enter the name of the site e.g. 'example.loc'.\n"

DOMAIN_READ_DESC="Please enter the domain name:"

QUESTION="Adding a site"

# WAARNING
NOT_GOOD="${red} Site was not added${off}"
EMPTY_DOMAIN="${red} You entered an empty domain${off}"
DIR_EXISTS="${red} Such a folder already exists${off}"

OK="$green [OK] $off"

ADD_FOLDER="${green}Creating the directory${off}"
ADD_NGINX_CONFIG="${green}Creating the nginx config${off}"
ADD_SSL="${green}Creating the certificate${off}"

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
