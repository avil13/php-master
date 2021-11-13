# php-master
Simple docker-compose config to work with php.


An easy-to-use repository if you want to quickly try something in php.

Used by:

- php: 8.0
- mariadb: 10.5
- nginx
- phpmyadmin

You should already have docker and docker-compose.

# Project structure

- etc - folder with configs, including nginx
- www - folder with sites.
- add_site.sh - a script for quickly adding a new site folder to it, nginx config and generating an ssl certificate.

# Start

Anything you might need can be done with the `make` command.

## If you want to work with your hands

At the root of the project

```bash
# up the local container
docker-compose up -d
```
The default address is `http://0.0.0.0/`

You can add a domain in `/etc/hosts` (or analogs depending on the OS)

```
# Host addresses
127.0.0.1  localhost
::1        localhost ip6-localhost ip6-loopback
ff02::1    ip6-allnodes
ff02::2    ip6-allrouters

0.0.0.0    test.loc

```
test.loc - used for example and test work

# Adding a site

The script `add_site.sh` is used to add a new site.

After starting, it will create a folder with the domain name in `www` and a config to connect it to nginx and ssl certificate.

After creating the site, it is recommended to restart docker-compose to apply the config in nginx.

> By default, all generated files are in `.gitignore`. You will have to fix it yourself.

