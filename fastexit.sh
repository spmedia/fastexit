#!/bin/bash -
#===============================================================================================================================================
# (C) Copyright 2016 TorWorld (https://torworld.org) a project under the CryptoWorld Foundation (https://cryptoworld.is).
#
# Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#===============================================================================================================================================
# title            :FastExit
# description      :This script will make it super easy to run a Tor Exit Node.
# author           :TorWorld A Project Under The CryptoWorld Foundation.
# contributors     :KsaRedFx, SPMedia
# date             :10-20-2016
# version          :0.0.3 Alpha
# os               :Debian/Ubuntu
# usage            :bash fastexit.sh
# notes            :If you have any problems feel free to email us: security[at]torworld.org
#===============================================================================================================================================

# Checking if lsb_release is Installed
if [ ! -x  /usr/bin/lsb_release ]
then
    echo -e "\033[31mLsb_release Command Not Found\e[0m"
    echo -e "\033[34mInstalling lsb-release, Please Wait...\e[0m"
    apt-get install lsb-release
fi

# Checking if wget is Installed
if [ ! -x  /usr/bin/wget ]
then
    echo -e "\033[31mwget Command Not Found\e[0m"
    echo -e "\033[34mInstalling wget, Please Wait...\e[0m"
    apt-get install wget
fi

# Getting Codename of the OS
flavor=`lsb_release -cs`

# Getting actual Distro of the OS
system=`lsb_release -i | grep "Distributor ID:" | sed 's/Distributor ID://g' | sed 's/["]//g' | awk '{print tolower($1)}'`

# Installing dependencies for Tor
read -p "Do you want to fetch the core Tor dependencies? (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
   echo deb http://deb.torproject.org/torproject.org $flavor main > /etc/apt/sources.list.d/torproject.list
   echo deb-src http://deb.torproject.org/torproject.org $flavor main >> /etc/apt/sources.list.d/torproject.list
   gpg --keyserver keys.gnupg.net --recv 886DDD89
   gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
fi

# Installing dependencies for Nginx
read -p "Attention! You're about to install Tor, and have it configured for an Exit node.
Would you like to have us grab the Nginx dependencies as well?
We recommend Exit node runners to put up a web page stating this node is an Exit node.
This might help cut down on Abuse notices you might get. (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
    echo deb http://nginx.org/packages/$system/ $flavor nginx > /etc/apt/sources.list.d/tornginx.list
    echo deb-src http://nginx.org/packages/$system/ $flavor nginx >> /etc/apt/sources.list.d/tornginx.list
    wget https://nginx.org/keys/nginx_signing.key
    apt-key add nginx_signing.key
fi

# Updating / Upgrading System
read -p "Do you wish to upgrade system packages? (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
   apt-get update
   apt-get dist-upgrade
fi

# Installing Nginx
read -p "If you said "Y" on grabbing Nginx dependencies.
Then please press "Y" again to compelete the Installtion of Nginx. (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
  echo "Installing Nginx now.."
  apt-get install nginx
  service nginx status
  echo "Grabbing fastexit-website-template from GitHub.."
  wget https://github.com/torworld/fastexit-website-template/archive/master.tar.gz -O - | tar -xz -C /usr/share/nginx/html/  && mv /usr/share/nginx/html/fastexit-website-template-master/* /usr/share/nginx/html/
  echo "Removing temporary files/folders.."
  rm -rf /usr/share/nginx/html/fastexit-website-template-master*
fi

# Installing Tor
read -p "Do you wish to install Tor? (Make sure you're 100% certain you want to do this) (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
   apt-get install tor
   echo "Getting status of Tor.."
   service tor status
   echo "Stopping Tor service..."
   service tor stop
fi

# Customizing Tor RC file to suit your Exit
# Nickname for Exit
read -p "Enter your desired Exit nickname: "  Name
echo "Nickname $Name" > /etc/tor/torrc

# DirPort for Exit
echo "Attention! If you installed either "nginx" or another web engine.
Please use ports 9030 for DirPort, and 9001 for ORPort."
read -p "Enter your desired DirPort: (example: 80, 9030) " DirPort
echo "DirPort $DirPort" >> /etc/tor/torrc

# ORPort for Exit
read -p "Enter your desired ORPort: (example: 443, 9001) " ORPort
echo "ORPort $ORPort" >> /etc/tor/torrc

## Advanced ExitPolicy Tor Exit Setup. Updated 10/20/16. This policy will help cut down on crimeware/malware/ransomware from using your Tor Exit Node/Server.
# Exit Policy for Exit
echo "Loading in our Exit Policies.."
cat >> /etc/tor/torrc <<EOL
ExitPolicy reject 31.11.43.0/24:*
ExitPolicy reject 37.139.49.0/24:*
ExitPolicy reject 37.9.53.0/24:*
ExitPolicy reject 46.151.48.0/22:*
ExitPolicy reject 46.151.52.0/22:*
ExitPolicy reject 46.243.140.0/24:*
ExitPolicy reject 46.243.142.0/24:*
ExitPolicy reject 46.29.248.0/21:*
ExitPolicy reject 46.8.255.0/24:*
ExitPolicy reject 81.94.43.0/24:*
ExitPolicy reject 85.93.0.0/24:*
ExitPolicy reject 85.93.5.0/24:*
ExitPolicy reject 85.121.39.0/24:*
ExitPolicy reject 85.239.149.0/24:*
ExitPolicy reject 91.194.254.0/23:*
ExitPolicy reject 91.195.120.0/24:*
ExitPolicy reject 91.195.121.0/24:*
ExitPolicy reject 91.195.254.0/23:*
ExitPolicy reject 91.207.4.0/22:*
ExitPolicy reject 91.207.7.0/24:*
ExitPolicy reject 91.209.12.0/24:*
ExitPolicy reject 91.212.124.0/24:*
ExitPolicy reject 91.212.220.0/24:*
ExitPolicy reject 91.213.126.0/24:*
ExitPolicy reject 91.217.10.0/23:*
ExitPolicy reject 91.220.101.0/24:*
ExitPolicy reject 91.220.163.0/24:*
ExitPolicy reject 91.220.35.0/24:*
ExitPolicy reject 91.220.62.0/24:*
ExitPolicy reject 91.223.89.0/24:*
ExitPolicy reject 91.225.216.0/22:*
ExitPolicy reject 91.226.97.0/24:*
ExitPolicy reject 91.229.210.0/24:*
ExitPolicy reject 91.230.110.0/24:*
ExitPolicy reject 91.230.252.0/23:*
ExitPolicy reject 91.235.2.0/24:*
ExitPolicy reject 91.236.213.0/24:*
ExitPolicy reject 91.236.74.0/23:*
ExitPolicy reject 91.237.198.0/24:*
ExitPolicy reject 91.238.82.0/24:*
ExitPolicy reject 91.239.238.0/24:*
ExitPolicy reject 91.240.128.0/24:*
ExitPolicy reject 91.240.163.0/24:*
ExitPolicy reject 91.242.217.0/24:*
ExitPolicy reject 91.243.115.0/24:*
ExitPolicy reject 93.171.205.0/24:*
ExitPolicy reject 95.182.79.0/24:*
ExitPolicy reject 141.136.16.0/24:*
ExitPolicy reject 141.136.27.0/24:*
ExitPolicy reject 176.97.116.0/22:*
ExitPolicy reject 185.103.252.0/24:*
ExitPolicy reject 185.106.92.0/24:*
ExitPolicy reject 185.106.94.0/24:*
ExitPolicy reject 185.112.102.0/24:*
ExitPolicy reject 185.112.103.0/24:*
ExitPolicy reject 185.112.80.0/24:*
ExitPolicy reject 185.112.81.0/24:*
ExitPolicy reject 185.127.24.0/22:*
ExitPolicy reject 185.130.4.0/22:*
ExitPolicy reject 185.130.6.0/24:*
ExitPolicy reject 185.130.7.0/24:*
ExitPolicy reject 185.137.219.0/24:*
ExitPolicy reject 185.154.20.0/22:*
ExitPolicy reject 185.35.136.0/22:*
ExitPolicy reject 185.75.56.0/22:*
ExitPolicy reject 188.247.135.0/24:*
ExitPolicy reject 188.247.230.0/24:*
ExitPolicy reject 188.247.232.0/24:*
ExitPolicy reject 193.0.129.0/24:*
ExitPolicy reject 193.104.41.0/24:*
ExitPolicy reject 193.107.16.0/22:*
ExitPolicy reject 193.138.244.0/22:*
ExitPolicy reject 193.189.116.0/23:*
ExitPolicy reject 194.1.152.0/24:*
ExitPolicy reject 194.110.160.0/22:*
ExitPolicy reject 194.29.185.0/24:*
ExitPolicy reject 194.50.116.0/24:*
ExitPolicy reject 194.31.59.0/24:*
ExitPolicy reject 195.182.57.0/24:*
ExitPolicy reject 195.190.13.0/24:*
ExitPolicy reject 195.191.56.0/23:*
ExitPolicy reject 195.20.141.0/24:*
ExitPolicy reject 195.225.176.0/22:*
ExitPolicy reject 195.88.190.0/23:*
ExitPolicy reject 204.225.16.0/20:*
ExitPolicy reject 212.56.214.0/24:*
ExitPolicy reject 213.183.58.0/24:*
ExitPolicy reject 5.8.37.0/24:*
ExitPolicy reject 5.101.218.0/24:*
ExitPolicy reject 5.101.221.0/24:*
ExitPolicy reject 37.18.42.0/24:*
ExitPolicy reject 37.230.212.0/23:*
ExitPolicy reject 46.243.173.0/24:*
ExitPolicy reject 79.110.17.0/24:*
ExitPolicy reject 79.110.18.0/24:*
ExitPolicy reject 79.110.19.0/24:*
ExitPolicy reject 79.110.25.0/24:*
ExitPolicy reject 93.179.89.0/24:*
ExitPolicy reject 93.179.90.0/24:*
ExitPolicy reject 93.179.91.0/24:*
ExitPolicy reject 141.101.132.0/24:*
ExitPolicy reject 141.101.201.0/24:*
ExitPolicy reject 179.61.200.0/23:*
ExitPolicy reject 185.2.32.0/24:*
ExitPolicy reject 185.46.84.0/22:*
ExitPolicy reject 185.50.250.0/24:*
ExitPolicy reject 185.50.251.0/24:*
ExitPolicy reject 188.72.96.0/24:*
ExitPolicy reject 188.72.126.0/24:*
ExitPolicy reject 188.72.127.0/24:*
ExitPolicy reject 191.101.54.0/23:*
ExitPolicy reject 31.28.27.7/32:*
ExitPolicy reject 83.217.8.155/32:*
ExitPolicy reject 86.104.134.144/32:*
ExitPolicy reject 91.108.176.118/32:*
ExitPolicy reject 91.108.176.129/32:*
ExitPolicy reject 91.230.211.26/32:*
ExitPolicy reject 91.230.211.139/32:*
ExitPolicy reject 91.230.211.206/32:*
ExitPolicy reject 93.170.128.136/32:*
ExitPolicy reject 93.170.130.147/32:*
ExitPolicy reject 93.170.131.108/32:*
ExitPolicy reject 109.237.111.168/32:*
ExitPolicy reject 212.47.195.238/32:*
ExitPolicy reject 217.69.139.160:*
ExitPolicy reject 147.67.119.102:*
ExitPolicy reject 62.67.194.130:*
ExitPolicy reject 176.9.220.168:*
ExitPolicy reject 82.165.37.26:*
ExitPolicy reject 184.107.100.67:*
ExitPolicy accept *:20-21
ExitPolicy accept *:43
ExitPolicy accept *:53
ExitPolicy accept *:80
ExitPolicy accept *:110
ExitPolicy accept *:143
ExitPolicy accept *:220
ExitPolicy accept *:443
ExitPolicy accept *:873
ExitPolicy accept *:989-990
ExitPolicy accept *:991
ExitPolicy accept *:992
ExitPolicy accept *:993
ExitPolicy accept *:995
ExitPolicy accept *:1194
ExitPolicy accept *:1293
ExitPolicy accept *:3690
ExitPolicy accept *:4321
ExitPolicy accept *:5222-5223
ExitPolicy accept *:5228
ExitPolicy accept *:9418
ExitPolicy accept *:11371
ExitPolicy accept *:64738
ExitPolicy reject *:*
EOL

# Contact Info for Exit
read -p "Enter your contact info for your Exit: " Info
echo "ContactInfo $Info" >> /etc/tor/torrc

# Restarting Tor service
echo "Restarting the Tor service..."
service tor restart

# Restarting Nginx service
echo "Restarting the Nginx service..."
service nginx restart
