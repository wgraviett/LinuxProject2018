#!/bin/bash
if ! [ -x "$(command -v docker)" ]; then #check if docker installed
	echo " Docker not installed. Now installing"
	sudo yum install -y docker #installing docker
	sudo service docker start #Starting Docker
	sudo mkdir /var/website #Create location for website files
	sudo docker run -dit --name my-apache-app -p 8080:80 -v /var/website/:/usr/local/apache2/htdocs/ httpd:2.4 #Setting up apache container
else
	echo " Docker already installed. Updating file" #indicates docker installed

fi

