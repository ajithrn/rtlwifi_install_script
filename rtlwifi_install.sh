#!/bin/sh
# $0 rtlwifi install script Extended, $1 Name of the card
# Author: Ajith R N (https://github.com/ajithrn)
# Version: 1.0.0
# https://github.com/ajithrn/rtlwifi_install_script
# LICENSE: GPL V3.0

#variables 
RED='\033[0;31m'
GREEN='\033[0;32m' 
BROWN='\033[0;33m' 
BLUE='\033[0;34m' 
PURPLE='\033[0;35m' 
CYAN='\033[0;36m' 
NC='\033[0m' #No Color

echo
echo "  ${PURPLE}Script to install rtlwifi drivers Ubuntu 18.04+${NC}"
echo "  ${BLUE}Created by ajith_rn for Right Click Solutions Thodupuzha, +91-9961278999${NC}"
echo 

#install essential softwares
while true; do
  echo "${CYAN}Do you wish to install essential softwares? Y/N${NC}"
  read yn
  case $yn in
      [Yy]* )  sudo apt-get install linux-headers-generic build-essential git; break;;
      [Nn]* )  break;;
      * ) echo "  Please answer yes or no."
       echo;;
  esac
done

#get driver name
echo "${CYAN}Enter the wireless card Name (default: rtl8723de): ${NC}"
read cardName
cardName=${cardName:-rtl8723de} #set dafault value to rtl8723de if user enter none
echo 
echo "  ${BLUE}Your Card is: $cardName${NC}"
echo 
cd ~/Desktop #move working directory to desktop
rm -rf rtlwifi_new #remove if the folder is already exist

#Sorce selection Normal and Extended for some cards
echo "${CYAN}Select the driver source"
echo "  1.Regular(default)"
echo "  2.Extended${NC}"
read repoSource
repoSource=${repoSource:-1} #set dafault value to 1 if user enter none
if [ $repoSource -eq 2 ] 
then
  echo 
  echo "  ${BLUE}You Selected Extended rtlwifi Drivers${NC}"
  echo 
  git clone --branch extended https://github.com/lwfinger/rtlwifi_new.git
else
  echo 
  echo "  ${BLUE}You Selected Regular rtlwifi Drivers${NC}"
  echo 
  git clone https://github.com/lwfinger/rtlwifi_new.git
fi

#Make and install scripts
cd rtlwifi_new 
make -j8
sudo make install
sudo modprobe -r $cardName
sudo modprobe $cardName
#check if the installation is success
if sudo modprobe $cardName ; then
  echo 
  echo "  ${GREEN}Driver Installation Completed!${NC}"
else  
  echo 
  echo "  ${RED}Driver installation failed!${NC}"
  echo 
  echo "  ${BLUE}Please re-run the script and select the exteneded source, still getting error consider reebot to bios and turn off secure boot then try again.  ${NC}"
  echo 
  echo "Cleaning up and exiting."
  cd ../
  rm -rf rtlwifi_new
  exit
fi

# ask to change wifi antena if there is low range
while true; do
  echo 
  echo "${CYAN}Do you wish to change the default antena? Y/N${NC}"
  read yn
  case $yn in
      [Yy]* )  
        sudo echo "options rtl8723be ant_sel=2" > /etc/modprobe.d/50-$cardName.conf
        echo "  ${GREEN}Antena Configuration completed!${NC}"
        break;;
      [Nn]* )  break;;
      * ) echo "  Please answer yes or no."
       echo;;
  esac
done

echo 
echo "  ${BLUE}Reboot the system to complete the installation!${NC}"
echo 
echo "Press ENTER to exit"
cd ../
rm -rf rtlwifi_new
read junk