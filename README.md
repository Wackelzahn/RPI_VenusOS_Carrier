# RpiVenusCarrierSetup  
<br>
  
> [!WARNING]
> All files provided in this Repositorie were tested to work with the Rpi_4b_Venus_OS_Carrier (Testversion).  
> The automated installation and configuration won't work on other HW environments.
<br>
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
10)  Login with a Terminal `ssh root@192.168.1.3` (e.g. https://bitvise.com/)
11)  Now that you have access to the RPI, download the latest instalation file [RpiVenusCarrier](latest/RpiVenusCarrier.tar.gz) and move it to `/home/root` on your RPI (e.g. with Bitvise SFTP client)
12)  unpack the tar file to `/data` on the RPI:
     ```
     tar -xzf ./RpiVenusCarrier.tar.gz -C /data
     ```
14)  Need to chnge the setup script to execute:
     ```  
     chmod 755 /data/RpiVenusCarrier/RpiVenusCarrierSetup.sh
     ```
     append at the end of the file:    
     ```  
	  dtoverlay=spi1-3cs
	  dtoverlay=mcp2515,spi1-0,oscillator=12000000,speed=2000000,interrupt=24
	  dtoverlay=mcp2515,spi0-0,oscillator=12000000,speed=2000000,interrupt=25
	  dtoverlay=mcp3208:spi0-1-present
      ```  
      end the editor with "Ctrl+x" and confirm "y" to safe the file.  
	
16) Copy the file [dbus-adc.conf](Files/dbus-adc.conf) to RPI `/etc/venus` with Bitvise SFTP (or similar program). Confirm to overwrite the file. 
17) Reboot RPI by entering the command  
    ```
    reboot
    ```  
18) Reconnect via ssh. Check with the command if both can0 and can1 are running.
      ```
      dmesg | grep can
      ```  
        
	  Alternatively check in the Venus GUI, go to SETTINGS and SERIVCES. can0 and can1 should be up and running.  
         Check under SETTINGS, I/O if analog Inputs are up and running. Configure to your like.  
        Picture [Front...](Pictures/Test_Carrier_Front.jpg)  shows a connected LM331 on Channel 0:4, activate and check the Device list for working temperature).
19)	Proceed with the installation of **SetupHelper[^2]**
  
	having root access through SHL or WinCP, 
	- Download: https://github.com/kwindrem/SetupHelper/archive/latest.tar.gz (e.g. to your Laptop)
	- Copy this tar file via WinCP/Bitvise to `/home/root` destination
	- In `/home/root` untar:  
  	  ``` 
	  tar -xzf ./SetupHelper-latest.tar.gz -C /data  
	  ```
     
 	  move
	  ```
		mv /data/SetupHelper-latest /data/SetupHelper  
	  ```
   
   	  run the setup:
	  ```
		/data/SetupHelper/setup  
   	  ```
	  confirm (i) for install and activate, confirm "y" to restart the GUI  

20)	Proceed with the installation of **RpiGpioSetup[^3]**

	- In the GUI, go to "Settings", "Package Manager"and "Inactive Packages". Scroll down to "RpiGpioSetup" and add RpiGpioSetup (proceed).
	- Go one step back and go to "Active Packages" and "RpiGpioSetup", download and proceed but do not install!
	- Copy the the file [gpio_list](Files/gpio_list) to `/data/RpiGpioSetup/FileSets`.  
	  Confirm the "overwrite".  
	- Copy the file [VenusGpioOverlay.dtbo](Files/VenusGpioOverlay.dtbo) to `/data/RpiGpioSetup/FileSets/VersionIndependent`.  
	  Confirm the "overwrite".
   
	- Run setup of RpiGpioSetup  
	  ```
 	  /data/RpiGpioSetup/setup
 	  ```  
      Install and activate (i), choose (n) to not install the alternate GPIO assignement.   
	  confirm (y) to reboot the system  
		
21) Install "RpiTemperature", through SetupHelper.

**finish**
<br>
<br>



> [!NOTE]
> The RPI Venus Carrier has been tested with an old single can version of the carrier board, temporarily soldered a second Waveshare RS485 CAN HAT to SPI1-0. See here [Back...](Pictures/Test_Carrier_back.jpg).  
> Final Version will have mcp2518FD on board and requires different overlay and setting in config.txt.
<br>


- By trial and error it was found that dtoverlay=spi1-1cs (to select only one CS on spi1) is for some reason not working. Interface can1 is only recognized on CS0 with all three CS activated -> spi1-3cs (which makes use also for GPIO16 and GPIO17 and those pins are therefore not usable (unless you have another SPI device connected) for other GPIO purposes any more.  
- Digital I/O's are not working by just update the gpio_list. Yust updating the gpio_list makes only the relays working. In this case assigned to GPIO2 and GPIO3.
- Digital Inputs need a custom overlay. The overlay provided in RpiGpioSetup is assigning Gpio16 and GPIO19 which collides with can1 interface preventing can1 to run. 
That is why a custom "VenusGpioOverlay.dtbo" was compiled and the original overlay needs to be replaced during the installation process of RpiGpioSetup (In this case Input pin assignements for 16, 19 and 26 was removed in the overlay).



<!-- COMMENT -->
<!-- TO DO: add more details about me later -->

## Retaining settings after Firmware update
All settings are retained after a Firmware update, except the Anlaog Inputs. To be re-installed:  
- add the line `dtoverlay=mcp3208:spi0-1-present` to config.txt again.  
- copy and override the file `dbus-adc.conf` in `/etc/venus` again.  
**finish**
  ##
  

Special Thanks to Rob Duthie who helped me to get the Analog Inputs working. See.. [link](https://communityarchive.victronenergy.com/articles/38710/victron-raspi-hat.html)

## ToDo
- [x] Make test version work.
- [ ] [#1](https://github.com/Wackelzahn/RPI_VenusOS_Carrier/issues/1) To figure out how to retain Analog Input configuration after FW update
- [x] [#2](https://github.com/Wackelzahn/RPI_VenusOS_Carrier/issues/2) Need to figure out why a simple install of gpio_list and RpiGpioOverlay.dtbo is not sufficient for making the digital Inputs work.
- [ ] Gerber file upload of new HW revision 5.3.  
- [ ] Manufacture, test and update README according new can interface mcp2518FD.
- [ ] Make a script for automated installation of all steps above (well, once I figure #1 and #2).



[^1]: https://bitvise.com/
[^2]: https://github.com/kwindrem/SetupHelper
[^3]: https://github.com/kwindrem/RpiGpioSetup
