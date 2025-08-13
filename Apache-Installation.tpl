#!/bin/bash

sudo apt update -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Apache2 is installed and started successfully."

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
sudo unzip awscliv2.zip
sudo ./aws/install
sudo rm /var/www/html/index.html

echo "* * * * * root sudo aws s3 sync s3://marabuck /var/www/html" >> /etc/crontab
echo "for filename in \$(ls -1 /var/www/html); do mysql -u remuser -premuser -h 172.31.10.10 -e \"USE files; INSERT INTO file (name) VALUES ('\$filename');\"; done" > /home/ubuntu/sqlInsert.sh
sudo chmod 755 /home/ubuntu/sqlInsert.sh
echo "* * * * * root sudo /home/ubuntu/sqlInsert.sh" >> /etc/crontab
