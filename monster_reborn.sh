#!/bin/bash
VERDE='\033[0;32m'
NC='\033[0m' # No Color

# ------------------------- Bienvenida --------------------------------
echo "${VERDE}[+]${NC} ¿Volviste a destrozar todo tu sistema? No te preocupes, yo instalo todo por ti."
echo -n "¿Cual es tu nombre de tu cuenta de usuario en Github?  >"
read nombre
echo -n "¿Cual es el email de tu cuenta de usuario en Github  >"
read usuario

# ------------------------- Actualizando sistema ----------------------- 
echo "${VERDE}[+]${NC} Actualizando sistema..."
sudo apt-get update
sudo apt-get -y upgrade

# ------------------------- Instalando ambiente de desarrollo para odoo -------------- 
echo "${VERDE}[+]${NC} Instalando herramientas de desarrollo"
sudo apt-get -y install python-pip
sudo pip install odoorpc
sudo pip install ipdb
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install -y sublime-text-installer
sudo apt-get install -y terminator
sudo apt-get install -y pylint python-flake8

echo "${VERDE}[+]${NC} Instalando git"
sudo apt-get -y install git git-core

echo "${VERDE}[+]${NC} Configurando globales"
git config --global user.name $nombre
git config --global user.email $email

# -------------------------- Instalando odoo --------------------------- 
echo "${VERDE}[+]${NC} Instalando postgresql"
sudo apt-get install -y postgresql postgresql-contrib

echo "${VERDE}[+]${NC} Creando usuario de postgreSQL"
sudo su - postgres -c "createuser -s $USER"

echo "${VERDE}[+]${NC} Instalando requerimientos de odoo"
sudo apt-get install libxml2-dev libxslt-dev libevent-dev libsasl2-dev libldap2-dev
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less

# ---------------------------- Instalando Transport Management System
echo "${VERDE}[+]${NC} Instalando postgis para TMS"
sudo apt-get install -y postgis postgresql-9.5-postgis-2.2

echo "${VERDE}[+]${NC} Creando extenciones en tempalte1 para postgis"
sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" template1

echo "${VERDE}[+]${NC} Clonando enterprise"
mkdir jarsa
cd jarsa
git clone https://github.com/Jarsa-dev/enterprise

echo "${VERDE}[+]${NC} Clonando geospatial"
git clone https://github.com/OCA/geospatial

echo "${VERDE}[+]${NC} Clonando operating unit"
git clone http://github.com/Jarsa-dev/operating-unit

echo "${VERDE}[+]${NC} Clonando TMS desde Jarsa"
git clone http://github.com/Jarsa/transport-management-system

echo "${VERDE}[+]${NC} Configurando remotos para TMS"
cd transport-management-system
git remote rename origin jarsa
git remote add jarsa-dev http://github.com/Jarsa-dev/transport-management-system

echo "${VERDE}[+]${NC} Instalando requerimientos para TMS"
sudo pip install -r requirements.txt
cd ..
echo "${VERDE}[+]${NC} Clonando odoo comunity en dentro de la carpeta dev-odoo"
git clone https://github.com/odoo/odoo.git
sudo pip install -r requirements.txt 

echo "${VERDE}[+]${NC} Creando archivo .openserver"
./odoo.py --save --stop-after-init
