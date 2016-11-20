#!/usr/bin/env bash
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
# contributors     :KsaRedFx, SPMedia, Lunar
# date             :10-20-2016
# version          :0.0.5 Alpha
# os               :Debian/Ubuntu
# usage            :bash fastexit.sh
# notes            :If you have any problems feel free to email us: security[at]torworld.org
#===============================================================================================================================================

# Checking if lsb_release is Installed
if [ ! -x  /usr/bin/lsb_release ]; then
    echo -e "\033[31mLsb_release Command Not Found\e[0m"
    echo -e "\033[34mInstalling lsb-release, Please Wait...\e[0m"
    apt-get install lsb-release
fi

# Checking if wget is Installed
if [ ! -x  /usr/bin/wget ]; then
    echo -e "\033[31mwget Command Not Found\e[0m"
    echo -e "\033[34mInstalling wget, Please Wait...\e[0m"
    apt-get install wget
fi

# Checking if curl is Installed
if [ ! -x  /usr/bin/curl ]; then
    echo -e "\033[31mcurl Command Not Found\e[0m"
    echo -e "\033[34mInstalling curl, Please Wait...\e[0m"
    apt-get install curl
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
    wget -4 https://nginx.org/keys/nginx_signing.key
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
  wget -4 https://github.com/torworld/fastexit-website-template/archive/master.tar.gz -O - | tar -xz -C /usr/share/nginx/html/  && mv /usr/share/nginx/html/fastexit-website-template-master/* /usr/share/nginx/html/
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

## Advanced ExitPolicy Tor Exit Setup. This policy will help cut down on crimeware/malware/ransomware from using your Tor Exit Node/Server.
# Exit Policy for Exit
echo "Loading in our Exit Policies.."
curl -s "https://raw.githubusercontent.com/torworld/fastexit/master/exitpolicy.txt" >> /etc/tor/torrc

# Contact Info for Exit
read -p "Enter your contact info for your Exit: " Info
echo "ContactInfo $Info" >> /etc/tor/torrc

# Restarting Tor service
echo "Restarting the Tor service..."
service tor restart

# Restarting Nginx service
echo "Restarting the Nginx service..."
service nginx restart

# Installing TorARM
read -p "Would you like to install Tor ARM to help monitor your Exit? (Y/N)" REPLY
if [ "${REPLY,,}" == "y" ]; then
   apt-get install tor-arm
   echo "Fixing the Tor RC to allow Tor ARM"
   echo "DisableDebuggerAttachment 0" >> /etc/tor/torrc
   echo "To start TorARM just type: "arm""
fi
