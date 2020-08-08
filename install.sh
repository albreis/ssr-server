#!/bin/bash
sudo add-apt-repository ppa:certbot/certbot --force-yes;
sudo apt update;
sudo apt install nginx nodejs redis-server python-certbot-nginx php php-fpm composer -y;
sudo npm install -g pm2;
composer require phpseclib/phpseclib;
composer require vlucas/phpdotenv;