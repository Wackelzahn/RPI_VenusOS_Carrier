# Raspberry Pi 4b Venus OS Carrier

## Configuration

1)	Burn latest firmware (tested with Venus OS 3.50~25) on SD card 
2)  Copy these files to the sd-card "overlays" folder:

    
     > MCP2515.dtbo  [right click, save link as...](Files/mcp2515.dtbo)  
     > MCP3208.dtbo  [right click, save link as...](Files/mcp3208.dtbo)  
	
3)  Put the SD card inside RPI, power-up.
4) Connect via VictronConnect (Bluetooth) and assign IP Address or leave on Auto if you know how to reach your RPI 
   Example:
   
   >  IP   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -192.168.1.3  
   >  Netmask	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  -255.255.255.0  
   >  Gateway	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  -192.168.1.1  
   >   Nameserver	  -192.168.1.1   

7)	Connect remote from your computer by typing into your browser (example):
	  `http://192.168.1.3/`
5)	In the Venus OS GUI go to SETTINGS, GENERAL, ACCESS LEVEL and (press long time right arrow) to enter SUPERUSER
6)	Set root (Superuser) Password, e.g. roots1
7) 	Enable SSH on LAN
8)  Login with a Terminal 'ssh root@192.168.1.3' (e.g. https://bitvise.com/)
9)  Edit the file: 
		`nano /u-boot/config.txt`
	  append at the end of the file:
	```
	  dtoverlay=spi1-3cs
	  dtoverlay=mcp2515,spi1-0,oscillator=12000000,speed=2000000,interrupt=24
	  dtoverlay=mcp2515,spi0-0,oscillator=12000000,speed=2000000,interrupt=25
	  dtoverlay=mcp3208:spi0-1-present
	```
	  end the editor with "Ctrl+x" and confirm "y" to safe the file.
	
10) Copy the file "dbus-adc.conf" from rep to RPI /etc/venus with Bitvise SFTP (or similar program). Confirm to overwrite the file. 
11) Reboot RPI by entering the command "reboot".
12) Reconnect via ssh. Check with the command
      ```
      dmesg | grep can
      ```
      if both can0 and can1 are running.  
	  Alternatively check in the Venus GUI, go to SETTINGS and SERIVCES. can0 and can1 should be up and running.  
         Check under SETTINGS, I/O if analog Inputs are up and running. Configure to your like.  
        Picture [right click, save link as...](Pictures/Test Carrier Front.jpg)  shows a connected LM331 on Channel 0:4, activate and check the Device list for working temperature).
14)	Proceed with the installation of **SetupHelper[^2]**
  
	having root access through SHL or WinCP, 
	- Download: https://github.com/kwindrem/SetupHelper/archive/latest.tar.gz (e.g. to your Laptop)
	- Copy this tar file via WinCP/Bitvise to `/home/root` destination
	- Untar from `/home/root`
  	  ``` 
	  tar -xzf ./SetupHelper-latest.tar.gz -C /data  
	  ```  
 	- move  
	  ```  
   	  mv /data/SetupHelper-latest /data/SetupHelper  
	- run the setup:  
	  ```
   	  /data/SetupHelper/setup  
   	  ```  
	- confirm (i) for install and activate, confirm "y" to restart the GUI

15)	Proceed with the installation of **RpiGpioSetup[^3]**

	- In the GUI, go to "settings", "Package manager" and "Inactive packages". Scroll down to "RpiGpioSetup" and add RpiGpioSetup (proceed).
	- Go one step back and go to "Active packages" and "RpiGpioSetup", download and proceed but do not install!
	- Copy (e.g. Bitvise SFTP) the (to your like) modified file "gpio_list" to /data/RpiGpioSetup/FileSets. confirm the "overwrite".
	- Copy the file "VenusGpioOverlay.dtbo" (personal modified version) to /data/RpiGpioSetup/FileSets/VersionIndependent. Confirm the "overwrite".
	- run setup of RpiGpioSetup -> /data/RpiGpioSetup/setup
      install and activate (i)
		  choose (n) to not install the alternate GPIO assignement.
		  confirm (y) to reboot the system.
		
16) Install "RpiTemperature", through SetupHelper.

finish

> [!NOTE]
> The RPI Venus Carrier has been tested with my old single can version of the carrier board with temporarily soldered a second little Waveshare RS485 CAN HAT to SPI1-0. See picture.
> Final Version will have mcp2518FD on board and requires different overlay and setting in config.txt.

By trial and error I found that dtoverlay=spi1-1cs is for some reason not working (which uses only CS-GPIOpin18). Interface can1 is only recognized with spi1-3cs (which makes use also for GPIO16 and GPIO17 and those pins are therefore not usable (unless you have another SPI device connected) for other GPIO purposes any more.
Digital I/O's are not working by just update the gpio_list. Yust updating the gpio_list makes only the relais working. In this case assigned to GPIO2 and GPIO3.
Digital Inputs need a custom overlay. The overlay provided in RpiGpioSetup is assigning Gpio16 and GPIO19 which collides with can1 interface preventing can1 to run. 
That is why a custom "VenusGpioOverlay.dtbo" was compiled and the original overlay needs to be replaced during the installation process of RpiGpioSetup (In this case Input pin assignements for 16, 19 and 26 was removed in the overlay).



<!-- COMMENT -->
<!-- TO DO: add more details about me later -->

## Retaining settings after Firmware update
All settings are retained after a Firmware update, except the Anlaog Inputs. To be re-installed like above 
- add the line "dtoverlay=mcp3208:spi0-1-present" to config.txt again.
- copy and override the file "dbus-adc.conf" in /etc/venus again.
finish

## ToDo
- [x] #739
- [ ] https://github.com/octo-org/octo-repo/issues/740
- [ ] Add delight to the experience when all tasks are complete :tada:

Still need to figure out how to retain the Analog Inputs after Firmware update :)

[^1] : https://bitvise.com/
[^2]: https://github.com/kwindrem/SetupHelper
[^3]: https://github.com/kwindrem/RpiGpioSetup
