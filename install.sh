#!/bin/bash
sudo add-apt-repository ppa:certbot/certbot --force-yes;
sudo apt update;
sudo apt install nginx nodejs redis-server python-certbot-nginx php php-fpm composer -y;
sudo npm install -g pm2;
composer require phpseclib/phpseclib;
composer require vlucas/phpdotenv;
read -p  "Digite o domínio do seu servidor SSR:" domain;
sudo rm -f /etc/nginx/sites-enabled/$domain.conf;
sudo cp -f sample/server.conf /etc/nginx/sites-enabled/$domain.conf;
sudo sed -i "s/{domain}/$domain/g" /etc/nginx/sites-enabled/$domain.conf;
sudo sed -i "s/{webroot}/$PWD/g" /etc/nginx/sites-enabled/$domain.conf;
sudo nginx -s reload;
sudo certbot --nginx --noninteractive --agree-tos -d $domain -m 'contato@albreis.com.br';