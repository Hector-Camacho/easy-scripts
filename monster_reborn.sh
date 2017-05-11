#!/bin/bash
VERDE='\033[0;32m'
NC='\033[0m' # No Color

# ------------------------- Bienvenida --------------------------------
echo "${VERDE}[+]${NC} ¿Volviste a destrozar todo tu sistema? No te preocupes, yo instalo todo por ti."
echo -n "¿Cual es tu nombre de tu cuenta de usuario en Github? > "
read nombre
echo -n "¿Cual es el email de tu cuenta de usuario en Github > "
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
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install -y sublime-text-installer
sudo apt-get install -y terminator
sudo apt-get install -y pylint python-flake8

echo "${VERDE}[+]${NC} Instalando git"
sudo apt-get -y install git git-core

echo "${VERDE}[+]${NC} Configurando globales"
git config --global user.name $nombre
git config --global user.email $email

# ---------------------------- Instalando google chrome
echo "${VERDE}[+]${NC} Instalando google chrome ${VERDE}[+]${NC}"
sudo apt-get install -y libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
sudo apt-get install -f


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

# ---------------------------- Instalando Postig para tms
echo "${VERDE}[+]${NC} Instalando postgis para TMS ${VERDE}[+]${NC}"
sudo apt-get install -y postgis postgresql-9.5-postgis-2.2
echo "${VERDE}[+]${NC} Creando extenciones en tempalte1 para postgis ${VERDE}[+]${NC}"
sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" template1

# ---------------------------- Clonando enterprise
echo "${VERDE}[+]${NC} Clonando enterprise ${VERDE}[+]${NC}"
mkdir jarsa
cd jarsa
git clone https://github.com/Jarsa-dev/enterprise
cd enterprise
enterprise="			$PWD"","
cd ..
echo $enterprise

# ---------------------------- Clonando geospatial
echo "${VERDE}[+]${NC} Clonando geospatial ${VERDE}[+]${NC}"
git clone -b 9.0 https://github.com/OCA/geospatial
cd geospatial
geospatial="			$PWD"","
cd ..

# ---------------------------- Clonando operating unit
echo "${VERDE}[+]${NC} Clonando operating unit ${VERDE}[+]${NC}"
git clone -b 9.0 http://github.com/Jarsa-dev/operating-unit
cd operating-unit
operating_unit="			$PWD"","
cd ..

# ---------------------------- Clonando, Configurando e Instalando ambiente para TMS
echo "${VERDE}[+]${NC} Clonando TMS desde Jarsa ${VERDE}[+]${NC}"
git clone http://github.com/Jarsa/transport-management-system

echo "${VERDE}[+]${NC} Configurando remotos para TMS ${VERDE}[+]${NC}"
cd transport-management-system
TMS="			$PWD"","
git remote rename origin jarsa
git remote add jarsa-dev http://github.com/Jarsa-dev/transport-management-system
echo "${VERDE}[+]${NC} Instalando requerimientos para TMS ${VERDE}[+]${NC}"
sudo pip install -r requirements.txt
cd ..

echo "${VERDE}[+]${NC} Clonando odoo 9.0 comunity en dentro de la carpeta dev-odoo ${VERDE}[+]${NC}"
git clone -b 9.0 https://github.com/odoo/odoo.git
cd odoo
sudo pip install -r requirements.txt

echo "${VERDE}[+]${NC} Creando archivo .openserver ${VERDE}[+]${NC}"
./odoo.py --save --stop-after-init

echo "${VERDE}[+]${NC} Añadiendo lineas al archivo .openerp_serverrc ${VERDE}[+]${NC}"
cd 
sed -i "3i $TMS" .openerp_serverrc
sed -i "3i $operating_unit" .openerp_serverrc
sed -i "3i $geospatial" .openerp_serverrc
sed -i "3i $enterprise" .openerp_serverrc
