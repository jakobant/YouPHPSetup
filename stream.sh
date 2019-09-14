

sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev php7.2-xml zlib1g-dev
sudo mkdir ~/build
cd ~/build
sudo git clone git://github.com/arut/nginx-rtmp-module.git
sudo wget http://nginx.org/download/nginx-1.13.8.tar.gz
sudo tar xzf nginx-1.13.8.tar.gz
cd nginx-1.13.8
sudo ./configure --with-http_ssl_module --with-http_stub_status_module --add-module=../nginx-rtmp-module
sudo make
sudo make install
sudo mkdir /usr/local/nginx/ssl/
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/nginx/ssl/nginx.key -out /usr/local/nginx/ssl/nginx.crt
sudo /etc/init.d/apache2 restart
sudo mkdir /HLS
sudo mkdir /HLS/live
sudo mkdir /HLS/rec
sudo chmod 777 /HLS/rec


sudo cp ~/build/nginx-rtmp-module/stat.xsl /usr/local/nginx/html
sudo mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.old

sudo cp org.conf /usr/local/nginx/conf/
cd /usr/local/nginx/conf/
#sudo wget https://raw.githubusercontent.com/DanielnetoDotCom/YouPHPTube/master/plugin/Live/install/nginx.conf -O org.conf
LIP=$(hostname -I|awk '{print $1}')
more org.conf|sed "s/\\[YouPHPTubeURL\\]/${LIP}\\/YouPHPTube/g" |sudo tee nginx.conf

echo "Append to live chat config"
echo '{"button_title":"LIVE","server":"rtmp://'$LIP'/live","playerServer":"https://'$LIP':8080/live","stats":"http://'$LIP':8080/stats"}'
