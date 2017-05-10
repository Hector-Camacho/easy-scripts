#!/bin/bash
VERDE='\033[0;32m'
NC='\033[0m' # No Color

# ------------------------- Actualizando sistema ----------------------- 
echo "${VERDE}[+]${NC} Actualizando sistema..."
sudo apt-get update
sudo apt-get -y upgrade

# ------------------------- Instalando ambiente para odoo -------------- 
echo "${VERDE}[+]${NC} Instalando pip ipdb odoorpc"
sudo apt-get -y install python-pip
sudo pip install odoorpc
sudo pip install ipdb

echo "${VERDE}[+]${NC} Instalando git"
sudo apt-get -y install git git-core

# -------------------------- Instalando odoo --------------------------- 
echo "${VERDE}[+]${NC} Clonando odoo comunity en dentro de la carpeta dev-odoo"
mkdir dev-odoo	
cd dev-odoo		
git clone https://github.com/odoo/odoo.git

echo "${VERDE}[+]${NC} Instalando postgresql"
sudo apt-get install -y postgresql postgresql-contrib

echo "${VERDE}[+]${NC} Creando usuario de postgreSQL"
sudo su - postgres -c "createuser -s $USER"

echo "${VERDE}[+]${NC} Instalando requerimientos de odoo"
sudo apt-get install libxml2-dev libxslt-dev libevent-dev libsasl2-dev libldap2-dev
sudo pip install -r requirements.txt 
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less

echo "${VERDE}[+]${NC} Ejecutando odoo"
./odoo.py --save --stop-after-init
./odoo.py

# ---------------------------- Instalando ambiente para desarrollo ------
echo "${VERDE}[+]${NC} Instalando herramientas de desarrollo"
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer
sudo apt-get install terminator

