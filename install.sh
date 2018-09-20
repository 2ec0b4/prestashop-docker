#!/usr/bin/env bash

VERSION=1.7.4.2

if [ ! -f "prestashop_$VERSION.zip" ]; then
	echo "File does not exist, download it"
    wget -O "prestashop_$VERSION.zip" "https://github.com/PrestaShop/PrestaShop/releases/download/$VERSION/prestashop_$VERSION.zip"
fi

echo "Unzip archive"
unzip -o "prestashop_$VERSION.zip"
unzip -o prestashop.zip -d "prestashop_$VERSION"

rm -f Install_PrestaShop.html index.php prestashop.zip "prestashop_$VERSION/INSTALL.txt" "prestashop_$VERSION/LICENCES"

cp Dockerfile "prestashop_$VERSION/Dockerfile"
cp docker-compose.yml "prestashop_$VERSION/docker-compose.yml"
cp PrestaShop.gitignore "prestashop_$VERSION/.gitignore"

cd "prestashop_$VERSION/"

echo ""

read -e -p "DB prefix: " -i "ps_" DB_PREFIX
sed -i.bak "s/DB_PREFIX: ps_/DB_PREFIX: $DB_PREFIX/g" docker-compose.yml;

read -e -p "Admin folder: " -i "ps-administration" PS_FOLDER_ADMIN
sed -i.bak "s/PS_FOLDER_ADMIN: ps-administration/PS_FOLDER_ADMIN: $PS_FOLDER_ADMIN/g" docker-compose.yml;

read -e -p "Admin email: " -i "demo@prestashop.com" ADMIN_MAIL
sed -i.bak "s/ADMIN_MAIL: demo@prestashop.com/ADMIN_MAIL: $ADMIN_MAIL/g" docker-compose.yml;

read -e -p "Admin password: " -i "prestashop_demo" ADMIN_PASSWD
sed -i.bak "s/ADMIN_PASSWD: prestashop_demo/ADMIN_PASSWD: $ADMIN_PASSWD/g" docker-compose.yml;

rm docker-compose.yml.bak

wget -O composer.json "https://raw.githubusercontent.com/PrestaShop/PrestaShop/$VERSION/composer.json"
