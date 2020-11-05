# Script to install rtlwifi drivers for Ubuntu 18.04+


*This Script need active internet connection to run. Please make sure you are connected to internet via ethernet cable before run the script*

This is shell script to install the rtlwifi drivers for Ubuntu 18.04+ All the drivers are installed by this script is getting from [rtlwifi-linux/rtlwifi_new
](https://github.com/rtlwifi-linux/rtlwifi_new). You can check the repo ([rtlwifi-linux/rtlwifi_new
](https://github.com/rtlwifi-linux/rtlwifi_new)) if you want to know more about supported hardware.


## Get started

1. Open Termilal from Application Menu or use shortcut  `Ctrl+Alt+T`
2. Download the Script using following command in the terminal
    ```
    wget "https://raw.githubusercontent.com/ajithrn/rtlwifi_install_script/master/rtlwifi_install.sh"
    ```
3. Enable Permission to run the script by using following command in the terminal
    ```
    sudo chmod +x rtlwifi_install.sh
    ```
4. Run script by using following command in the terminal
    ```
    ./rtlwifi_install.sh
    ```
5. Follow the instructions on the terminal to continue and complete installation.


## Troubleshoot low Wifi range.

If you facing issues with Wifi range, the driver might have using wrong antenna. To test this, please run the following commands. (set 1)

```
DEVICE=$(iw dev | grep Interface | cut -d " " -f2)
sudo iw dev $DEVICE scan | egrep "SSID|signal|\(on"
```

If the signal for the AP to which you wish to connect is -60 or less, then you have this problem.
The fix is to supply the "ant_sel" option. Run the following commands. (set 2)

```
sudo su -
echo "options rtl8723de ant_sel=2" > /etc/modprobe.d/50-rtl8723de.conf
exit
```

If you have a different driver like rtl8723be, make the appropriate adjustments to the above command.

At this point, do a complete shutdown! The device may retain the old setting with a warm reboot. To be safe, do a power off. After the system come back up, rin the set 1 commands again. If The signals are now a lot stronger, you are done. If not, repeat command set 2 with "ant_sel=1".
