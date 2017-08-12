#! /bin/bash

dpkg --configure -a
apt update
apt -y full-upgrade -f
apt -y autoremove
add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
add-apt-repository -y ppa:certbot/certbot
apt update
apt -y full-upgrade
apt -y autoremove

apt -y install r-base r-base-dev r-recommended gdebi-core build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev apache2 apache2-bin python-certbot-apache

echo -e '## set default CRAN mirror\noptions( repos = c(CRAN="https://cloud.r-project.org/") )\n' >> /usr/lib/R/library/base/R/Rprofile

curl -LO https://download2.rstudio.org/rstudio-server-1.0.153-amd64.deb
md5sum rstudio-server-1.0.153-amd64.deb| grep b8df8478e446851dbe0ce893d32e3e67

echo -e "\n\n\nIf the md5 doesn't match, abort with Ctrl-C. Otherwise:\n\n"
read -p "Press key to continue.. " -n1 -s

gdebi rstudio-server-1.0.153-amd64.deb


