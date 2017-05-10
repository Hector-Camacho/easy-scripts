#!/bin/bash

# ------------------------- Actualizando sistema ----------------------- 
echo "[+] Actualizando sistema..."
sudo apt-get update
sudo apt-get -y upgrade

# ------------------------- Instalando ambiente para odoo -------------- 
echo "[+] Instalando pip ipdb odoorpc"
sudo apt-get -y install python-pip
sudo pip install odoorpc
sudo pip install ipdb

echo "[+] Instalando git"
sudo apt-get -y install git git-core

# -------------------------- Instalando odoo --------------------------- 
echo "[+] Clonando odoo comunity en dentro de la carpeta dev-odoo"
mkdir dev-odoo	
cd dev-odoo		
git clone https://github.com/odoo/odoo.git

echo "[+] Instalando postgresql"
sudo apt-get install -y postgresql postgresql-contrib

echo "[+] Creando usuario de postgreSQL"
sudo su - postgres -c "createuser -s $USER"

echo "[+] Instalando requerimientos de odoo"
sudo apt-get install libxml2-dev libxslt-dev libevent-dev libsasl2-dev libldap2-dev
sudo pip install -r requirements.txt 
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less

echo "[+] Ejecutando odoo"
./odoo.py --save --stop-after-init
./odoo.py
