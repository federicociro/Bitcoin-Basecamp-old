#!/bin/bash

script_loc=$(pwd)

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Clone Mempool Repository
sudo git clone https://github.com/antonilol/mempool.git /opt/mempool
#sudo git clone https://github.com/mempool/mempool /opt/mempool
cd mempool

# Checkout the latest release
cd /opt/mempool
sudo git checkout cookie
#latestrelease=$(curl -s https://api.github.com/repos/mempool/mempool/releases/latest|grep tag_name|head -1|cut -d '"' -f4)
#sudo git checkout $latestrelease

# Install NPM
sudo apt update
sudo apt install -y npm

# Create a database and grant privileges (db, user and password = mempool)
if ! sudo mysql -e "use mempool" ; then 
    sudo mysql -e "create database mempool; grant all privileges on mempool.* to 'mempool'@'%' identified by 'mempool';" ; 
fi

# Build and configure Mempool Backend
cd backend
sudo npm install
sudo npm run build

# Copy configuration file
sudo cp $script_loc/../config/etc/mempool/mempool-config.json /opt/mempool/backend/mempool-config.json
sudo chmod 600 /opt/mempool/backend/mempool-config.json
sudo cp $script_loc/../config/etc/nginx/sites-available/mempool.conf /etc/nginx/sites-available/mempool.conf
sudo ln -s /etc/nginx/sites-available/mempool.conf /etc/nginx/sites-enabled/

# Copy frontend to /var/www folder
sudo rsync -av --delete /home/mempool/mempool/frontend/dist/mempool/ /var/www/mempool/
sudo chown -R www-data:www-data /var/www/mempool

# Restart nginx to apply the new configuration
sudo systemctl restart nginx