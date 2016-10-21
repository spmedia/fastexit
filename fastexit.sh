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
#title			:FastExit
#description		:This script will make it super easy to run a Tor Exit Node.
#author			:TorWorld A Project Under The CryptoWorld Foundation.
#contributors		:SPMedia
#date			:10-20-2016
#version		:0.0.1 Alpha
#os			:Debian/Ubuntu
#usage			:bash fastexit.sh
#notes			:If you have any problems feel free to email us: security[at]torworld.org
#===============================================================================================================================================

# Getting Codename of the OS
flavor=`lsb_release -cs`

# Installing dependencies for Tor
read -p "We need to get the dependecies for Tor (y,n) " REPLY

if [ "${REPLY,,}" == "y" ]; then

   echo deb http://deb.torproject.org/torproject.org $flavor main >> /etc/apt/sources.list.d/torproject.list

   echo deb-src http://deb.torproject.org/torproject.org $flavor main >> /etc/apt/sources.list.d/torproject.list

   gpg --keyserver keys.gnupg.net --recv 886DDD89

   gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

fi

# Updating / Upgrading System
read -p "We need to update/upgrade the system (y,n ) " REPLY

if [ "${REPLY,,}" == "y" ]; then

   apt-get update

   apt-get dist-upgrade

fi

# Installing Tor
read -p "Do you want to install Tor? (MAKE SURE YOU'RE 100% SURE ABOUT THIS!) (y,n) " REPLY

if [ "${REPLY,,}" == "y" ]; then

   apt-get install tor

   echo "Getting status of Tor.."

   service tor status

   echo "Stopping Tor service..."

   service tor stop

fi

# Customizing Torrc to suit Exit
# Nickname for Exit
read -p "Enter your desired Nickname for your Exit: "  Name
echo "Nickname $Name" > /etc/tor/torrc

# DirPort for Exit
read -p "Enter what port number you want DirPort to look at: " DirPort
echo "DirPort $DirPort" >> /etc/tor/torrc

# ORPort for Exit
read -p "Enter what port number you want ORPort to look at: " ORPort
echo "ORPort $ORPort" >> /etc/tor/torrc

## Advanced ExitPolicy Tor Exit Setup. Updated 10/20/16. This policy will help cut down on crimeware/malware/ransomware from using your Tor Exit Node/Server.
# Exit Policy for Exit
echo "Loading in our Exit Policies.."

echo "ExitPolicy reject 31.11.43.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 37.139.49.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 37.9.53.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 46.151.48.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 46.151.52.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 46.243.140.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 46.243.142.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 46.29.248.0/21:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 46.8.255.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 81.94.43.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 85.93.0.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 85.93.5.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 85.121.39.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 85.239.149.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.194.254.0/23:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.195.120.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.195.121.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.195.254.0/23:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.207.4.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.207.7.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.209.12.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.212.124.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.212.220.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.213.126.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.217.10.0/23:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.220.101.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.220.163.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.220.35.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.220.62.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.223.89.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.225.216.0/22:*" >> /etc/tor/torrc

echo "ExitPolicy reject 91.226.97.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.229.210.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.230.110.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.230.252.0/23:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.235.2.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.236.213.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.236.74.0/23:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.237.198.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.238.82.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.239.238.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.240.128.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.240.163.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.242.217.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 91.243.115.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 93.171.205.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 95.182.79.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 141.136.16.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 141.136.27.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 176.97.116.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.103.252.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.106.92.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.106.94.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.112.102.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.112.103.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.112.80.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.112.81.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.127.24.0/22:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.130.4.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.130.6.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.130.7.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 185.137.219.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.154.20.0/22:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.35.136.0/22:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.75.56.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 188.247.135.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 188.247.230.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 188.247.232.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 193.0.129.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 193.104.41.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 193.107.16.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 193.138.244.0/22:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 193.189.116.0/23:*" >> /etc/tor/torrc

echo "ExitPolicy reject 194.1.152.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 194.110.160.0/22:*" >> /etc/tor/torrc

echo "ExitPolicy reject 194.29.185.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 194.50.116.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 194.31.59.0/24:*"	>> /etc/tor/torrc

echo "ExitPolicy reject 195.182.57.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 195.190.13.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 195.191.56.0/23:*" >> /etc/tor/torrc

echo "ExitPolicy reject 195.20.141.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 195.225.176.0/22:*" >> /etc/tor/torrc

echo "ExitPolicy reject 195.88.190.0/23:*" >> /etc/tor/torrc

echo "ExitPolicy reject 204.225.16.0/20:*" >> /etc/tor/torrc

echo "ExitPolicy reject 212.56.214.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 213.183.58.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 5.8.37.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 5.101.218.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 5.101.221.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 37.18.42.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 37.230.212.0/23:*" >> /etc/tor/torrc

echo "ExitPolicy reject 46.243.173.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 79.110.17.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 79.110.18.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 79.110.19.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 79.110.25.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 93.179.89.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 93.179.90.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 93.179.91.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 141.101.132.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 141.101.201.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 179.61.200.0/23:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.2.32.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.46.84.0/22:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.50.250.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 185.50.251.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 188.72.96.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 188.72.126.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 188.72.127.0/24:*" >> /etc/tor/torrc

echo "ExitPolicy reject 191.101.54.0/23:*" >> /etc/tor/torrc

echo "ExitPolicy reject 31.28.27.7/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 83.217.8.155/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 86.104.134.144/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 91.108.176.118/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 91.108.176.129/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 91.230.211.26/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 91.230.211.139/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 91.230.211.206/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 93.170.128.136/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 93.170.130.147/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 93.170.131.108/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 109.237.111.168/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 212.47.195.238/32:*" >> /etc/tor/torrc

echo "ExitPolicy reject 217.69.139.160:*" >> /etc/tor/torrc

echo "ExitPolicy reject 147.67.119.102:*" >> /etc/tor/torrc

echo "ExitPolicy reject 62.67.194.130:*" >> /etc/tor/torrc

echo "ExitPolicy reject 176.9.220.168:*" >> /etc/tor/torrc

echo "ExitPolicy reject 82.165.37.26:*" >> /etc/tor/torrc

echo "ExitPolicy reject 184.107.100.67:*" >> /etc/tor/torrc

echo "ExitPolicy accept *:20-21"     >> /etc/tor/torrc
echo "ExitPolicy accept *:43"        >> /etc/tor/torrc
echo "ExitPolicy accept *:53"        >> /etc/tor/torrc
echo "ExitPolicy accept *:80"        >> /etc/tor/torrc
echo "ExitPolicy accept *:110"       >> /etc/tor/torrc
echo "ExitPolicy accept *:143"       >> /etc/tor/torrc
echo "ExitPolicy accept *:220"       >> /etc/tor/torrc
echo "ExitPolicy accept *:443"       >> /etc/tor/torrc
echo "ExitPolicy accept *:873"       >> /etc/tor/torrc
echo "ExitPolicy accept *:989-990"   >> /etc/tor/torrc
echo "ExitPolicy accept *:991"       >> /etc/tor/torrc
echo "ExitPolicy accept *:992"       >> /etc/tor/torrc
echo "ExitPolicy accept *:993"       >> /etc/tor/torrc
echo "ExitPolicy accept *:995"       >> /etc/tor/torrc
echo "ExitPolicy accept *:1194"      >> /etc/tor/torrc
echo "ExitPolicy accept *:1293"      >> /etc/tor/torrc
echo "ExitPolicy accept *:3690"      >> /etc/tor/torrc
echo "ExitPolicy accept *:4321"      >> /etc/tor/torrc
echo "ExitPolicy accept *:5222-5223" >> /etc/tor/torrc
echo "ExitPolicy accept *:5228"      >> /etc/tor/torrc
echo "ExitPolicy accept *:9418"      >> /etc/tor/torrc
echo "ExitPolicy accept *:11371"     >> /etc/tor/torrc
echo "ExitPolicy accept *:64738"     >> /etc/tor/torrc
echo "ExitPolicy reject *:*"         >> /etc/tor/torrc


# Contact Info for Exit
read -p "Enter your contact info for your Exit: " Info
echo "ContactInfo $Info" >> /etc/tor/torrc

# Restarting Tor service
echo "Restarting the Tor service..."
service tor restart
