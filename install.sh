#!/bin/bash
sudo apt update;
sudo apt install nginx nodejs redis-server -y;
read -p  "Digite o domínio do seu site:" domain;
read -p "Digite o dominio do seu app no firebase:" app;
read -p "Digite a porta que seu app vai rodar:" port;
# Configurações do NGINX
sudo rm -f /etc/nginx/sites-enabled/$app.conf;
sudo cp -f sample/nginx.conf /etc/nginx/sites-enabled/$app.conf;
sudo sed -i "s/{domain}/$domain/g" /etc/nginx/sites-enabled/$app.conf;
sudo sed -i "s/{app}/$app/g" /etc/nginx/sites-enabled/$app.conf;
sudo sed -i "s/{port}/$port/g" /etc/nginx/sites-enabled/$app.conf;
sudo nginx -s reload;
# Configurações NPM
sudo mkdir -p /var/www/$app;
sudo rm -f /var/www/$app/package.json;
sudo cp -f sample/package.json /var/www/$app/package.json;
sudo sed -i "s/{app}/$app/g" /var/www/$app/package.json;
# Configurações do servidor NodeJS
sudo rm -f /var/www/$app/index.mjs;
sudo cp -f sample/index.mjs /var/www/$app/index.mjs;
sudo sed -i "s/{app}/$app/g" /var/www/$app/index.mjs;
sudo sed -i "s/{port}/$port/g" /var/www/$app/index.mjs;
# Vai para a raiz do app
cd /var/www/$app;
# Instala dependências do app
npm install;
# Inicia o servidor em background
pm2 start node -- /var/www/$app/index.mjs;