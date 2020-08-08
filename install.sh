#!/bin/bash
sudo add-apt-repository ppa:certbot/certbot --force-yes;
sudo apt update;
sudo apt install nginx nodejs redis-server python-certbot-nginx php php-fpm -y;
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;";
php composer-setup.php;
php -r "unlink('composer-setup.php');";
sudo mv composer.phar /usr/bin/composer;
sudo npm install -g pm2;
composer require phpseclib/phpseclib;
composer require vlucas/phpdotenv;
read -p  "Digite o domínio do seu servidor SSR:" domain;
sudo rm -f /etc/nginx/sites-enabled/$domain.conf;
sudo cp -f sample/server.conf /etc/nginx/sites-enabled/$domain.conf;
sudo sed -i "s/{domain}/$domain/g" /etc/nginx/sites-enabled/$domain.conf;
sudo sed -i "s~{wroot}~$PWD~g" /etc/nginx/sites-enabled/$domain.conf;
sudo nginx -s reload;
sudo certbot --nginx --noninteractive --agree-tos -d $domain -m 'contato@albreis.com.br';