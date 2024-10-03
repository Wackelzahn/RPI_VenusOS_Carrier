# RpiVenusCarrierSetup  
<br>
  
> [!WARNING]
> All files provided in this Repositorie were tested to work with the RpiVenusCarrier (Testversion).  
> The files may not work on other HW environments.
<br>

## Configuration

1) Burn latest firmware (tested with Venus OS 3.50~25) on SD card and start your RPI in the Carrier environment.
5) Connect via VictronConnect (Bluetooth) and assign IP Address or leave on Auto if you know how to reach your RPI 
   Example:
   
   >  IP   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -192.168.1.3  
   >  Netmask	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  -255.255.255.0  
   >  Gateway	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  -192.168.1.1  
   >   Nameserver	  -192.168.1.1   

6)	Connect remote from your computer by typing into your browser. For the example above, it would be:
	  `http://192.168.1.3/`
7)	In the Venus OS GUI go to "Settings", "General", "Access Level" and (press long time right arrow) enter "Superuser"
8)	Set root (Superuser) Password!
9) 	Enable SSH on LAN
10)  Login with a Terminal `ssh root@192.168.1.3` (e.g. https://bitvise.com/ or https://Putty.org)  

  
12)  Now that you have access to the RPI, download the latest installation file from this repo [RpiVenusCarrier](latest/RpiVenusCarrier.tar.gz) and move it to `/home/root` on your RPI (e.g. with Bitvise SFTP client)
13)  unpack the tar file to `/data` on the RPI:
     ```
     tar -xvzf ./RpiVenusCarrier.tar.gz -C /data
     ```

15) Run the setup script
    ```
    /data/RpiVenusCarrier/RpiVenusCarrierSetup.sh
    ```
16) After the completion of the script, RPI will reboot. You may check the log file `/etc/venus/RpiVenusCarrierLog.txt`
17) Finish!  
20) You may check the functionality.
    Reconnect via ssh. Check with the command if both can0 and can1 are running.
      ```
      dmesg | grep can
      ```  
        
	  Alternatively check in the Venus GUI, go to SETTINGS and SERIVCES. can0 and can1 should be up and running.  
    Check under SETTINGS, I/O if digital Inputs are up and running. Configure to your like.
    Check under SETTINGS, RELAY if Relays are up and running. Configure to your like.
    Check under SETTINGS, I/O if analog Inputs are up and running. Configure to your like.
        Picture [Front...](Pictures/Test_Carrier_Front.jpg)  shows a connected LM331 on Channel 0:4, activate and check the Device list for working temperature).


**finish**
<br>
<br>

## Venus OS Firmware update  


>[!Note]
> All files are deleted after a Firmware update of Venus OS, except the ones on `/data`.
> Also the `root` PW is being reset! It is therfore recommended to install ssh keys (which will be retained) for authentication and access to your Venus machine.

### Steps to be done after FW update to regain all functionality of the RpiVenusCarrier[^1]
- none, the configuration is re-written automatically through `/data/rc.local` and the machine is once rebooting.
- <br>   
**finish**  
<br> 

## Issues  
- By trial and error it was found that dtoverlay=spi1-1cs (to select only one CS on spi1) is for some reason not working. Interface can1 is only recognized on CS0 with all three CS activated -> spi1-3cs (which makes use also for GPIO16 and GPIO17 and those pins are therefore not usable (unless you have another SPI device connected) for other GPIO purposes any more.  
<br>

## Thank you  
Special Thanks to Rob Duthie who helped to get the Analog Inputs working. See.. [link](https://communityarchive.victronenergy.com/articles/38710/victron-raspi-hat.html)  
<br>  

> [!NOTE]
> The RpiVenusCarrier has been tested with an old single can version of the HW carrier board hw3.9, temporarily soldered a second Waveshare RS485 CAN HAT to SPI1-0. See here [Back...](Pictures/Test_Carrier_back.jpg).  
> Final Version hw5.4 will have mcp2518FD on board and requires different overlay and setting in config.txt.  
<br>
<br>

## ToDo  

- [ ] Gerber file upload of new HW revision 5.4.
- [ ] Manufacture, test and update README according new can interface mcp2518FD.




[^1]: There are quite some discussions in various forums on how to implement proper data/setting retention after a re-start/firmware update. For the RpiVenusCarrier solution, this guide from Victron was followed [link](https://www.victronenergy.com/live/ccgx:root_access) It is important to note that after a FW-update the rootfs partition is read only. You may only write/copy/remove/configure through `/data/rc.local` once you have regained writing rights. 

