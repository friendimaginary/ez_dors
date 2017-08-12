#! /bin/bash

echo -e "\n\n\n"
echo "Hello. I am about to configure RStudio Server for you, on what  I assume "
echo "is an Ubuntu 16.04 LTS droplet running in Digital Ocean. This script may "
echo "work in other circumstances, but that is how it was written and tested. "

wait 2

echo -e "\n\n\nFor the purposes of configuring git, can I get your name?"
echo -e "You can leave it blank or say 'Jon Snow' if you don't trust me.\n"
read -p "Name:" git_name

echo read -p "Please enter the number to validate :" mynum
echo -e "\nFor the purposes of configuring git, can I get your email address?"
echo -e "You can leave it blank or say 'snow@thewall.not_a_real.tld if you don't trust me.\n"
read -p "Email:" git_email


if [ expr length "$(echo $git_email)" < 1 ]
  then git_email = "snow@thewall.not_a_real.tld"
fi

if [expr length "$(echo $git_name)" < 1 ]
  then git_name = "Jon Snow"
fi

git config --global user.name  $git_name
git config --global user.email $git_email

echo -e "\n\n\nThanks. Here is your git config:"
echo ""
cat .gitconfig
echo -e "\n\n\n"

wait 2
echo -e "Now, pick a username and password to use for RStudio.\n"

read -p "username:" rstudio_user
read -p "password:" rstudio_pass

useradd -m $rstudio_user
echo "$rstudio_user:$rstudio_pass" | chpasswd

echo -e "\n\nThat should do it.\n\nNow we're ready to install and update packages.\n\n"

read -p "Press key to continue.. " -n1 -s

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

gdebi --n rstudio-server-1.0.153-amd64.deb

dpkg --configure -a
apt update
apt -y full-upgrade -f
apt -y autoremove

echo -e "\n\n\nYou should now be able to login to the Rstudio Server by point a web browser at your IP address."
echo -e "\nHere's an example:\n\thttp://123.45.67.89:8787."
echo -e "\nHere's your IP addres info, as well:"
curl ipinfo.io
echo -e "\n\n\n"


