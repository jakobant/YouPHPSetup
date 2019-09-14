#!/bin/bash

'''
Based Info from :

https://github.com/YouPHPTube/YouPHPTube/
https://github.com/YouPHPTube/YouPHPTube/wiki/Set-up-my-own-Stream-Server
'''

MYSQL_PASS=l4kkr1s3rn4mm1

sudo apt-get install -y apache2 php libapache2-mod-php php-mysql php-curl php-gd php-intl mysql-server mysql-client ffmpeg git libimage-exiftool-perl curl vim php-mbstring php-gettext
cd /var/www/html 	
sudo git clone https://github.com/DanielnetoDotCom/YouPHPTube.git
cd /var/www/html
sudo git clone https://github.com/DanielnetoDotCom/YouPHPTube-Encoder.git
sudo apt-get install python
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
sudo a2enmod rewrite

sudo phpenmod mbstring
sudo systemctl restart apache2

echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASS}';" > /tmp/pass.txt
sudo mysql < /tmp/pass.txt

sudo bash -c 'cat << EOF > /etc/apache2/conf-enabled/www.conf
<Directory /var/www/>
          Options Indexes FollowSymLinks
          AllowOverride All
          Require all granted
</Directory>
EOF'
sudo a2enmod rewrite

sudo mkdir /var/www/html/YouPHPTube/videos
sudo chown www-data:www-data /var/www/html/YouPHPTube/videos
sudo chmod 755 /var/www/html/YouPHPTube/videos
sudo mkdir /var/www/html/YouPHPTube-Encoder/videos
sudo chown www-data:www-data /var/www/html/YouPHPTube-Encoder/videos
sudo chmod 755 /var/www/html/YouPHPTube-Encoder/videos 

sudo bash -c 'cat << EOF > /etc/php/7.2/apache2/conf.d/youtube.ini
post_max_size = 200M
upload_max_filesize = 1024M
max_execution_time = 14000
memory_limit = 768M
EOF'
sudo service apache2 restart
