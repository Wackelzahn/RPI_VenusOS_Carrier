#!/bin/bash
# Setup and configure RpiVenusCarrierSetup (dual can bus interface, Digital Outputs(Relays), Digital Inputs and Analog Inputs)

# 1. Check if already installed. Use log file in /etc/venus to check if previously created.
# A Firmware-upddate would erase the log file and therefore if log file not there -> new installation will be done. 

log="/etc/venus/RpiVenusCarrierLog.txt"
answer2=false

if [ -e $log ]
then 
    echo $(date) | tee -a $log
    echo "A log file from previous piVenusCarrierSetup installation has been detected.." | tee -a $log
    echo "RpiVenusCarrierSetup has been previously installed!" | tee -a $log
    read -p "Re-Install (y/n) ?" answer
    case ${answer:0:1} in
        y|Y )
        echo "yes"
        answer2=true
        ;;
        * )
        echo "no"
        answer2=false
        ;;
    esac
else 
    answer2=true
fi

if [ "$answer2" = true ];
    then 

        touch -c /etc/venus/RpiVenusCarrierLog.txt 2>&1 > $log
        echo $(date) > $log
        echo "Initial Installation" |tee -a $log
        
        # 2. mv overlays to /u-boot/overlays
        # if existing simply overwrite
        echo "Step 1. Copy Overlays" |tee -a $log
        cp /data/RpiVenusCarrier/Files/mcp2515.dtbo /u-boot/overlays 2>&1 | tee -a $log
        cp /data/RpiVenusCarrier/Files/mcp3208.dtbo /u-boot/overlays 2>&1 | tee -a $log
        # 3. mv dbus-adc.conf and gpio_list to /etc/venus
        echo "Step 2. Copy config files" |tee -a $log
        cp /data/RpiVenusCarrier/Files/gpio_list /etc/venus 2>&1 | tee -a $log
        cp /data/RpiVenusCarrier/Files/dbus-adc.conf /etc/venus 2>&1 |tee -a $log

        # 5. Append to config.txt.
        # to check if already existing, preventing multiple entires.
        echo "Step 3, Adding HW Overlays to config.txt" |tee -a $log

        if ! grep -q dtoverlay=spi1-3cs /u-boot/config.txt;
            then 
                echo "  no spi overlay" |tee -a $log
                echo "  Overlay for spi1 is being added" |tee -a $log
                echo "dtoverlay=spi1-3cs" >> /u-boot/config.txt
            else 
                echo "  spi overlay already there" |tee -a $log
                echo "  >o.k.<" |tee -a $log
        fi

        if ! grep -q dtoverlay=mcp2515,spi1-0,oscillator=12000000,speed=2000000,interrupt=24 /u-boot/config.txt;
            then 
                echo "  no can0 overlay" |tee -a $log
                echo "  Overlay for can0 is being added" |tee -a $log
                echo "dtoverlay=mcp2515,spi1-0,oscillator=12000000,speed=2000000,interrupt=24" >> /u-boot/config.txt
            else 
                echo "  can0 overlay already there" |tee -a $log
                echo "  >o.k.<" |tee -a $log
        fi

        if ! grep -q dtoverlay=mcp2515,spi0-0,oscillator=12000000,speed=2000000,interrupt=25 /u-boot/config.txt;
            then 
                echo "  no can0 overlay" |tee -a $log
                echo "  Overlay for can1 is being added" |tee -a $log
                echo "dtoverlay=mcp2515,spi0-0,oscillator=12000000,speed=2000000,interrupt=25" >> /u-boot/config.txt
            else 
                echo "  can1 overlay already there" |tee -a $log
                echo "  >o.k.<" |tee -a $log
        fi

        if ! grep -q dtoverlay=mcp3208:spi0-1-present /u-boot/config.txt;
            then 
                echo "  no analog overlay" |tee -a $log
                echo "  Overlay for analog is being added" |tee -a $log
                echo "dtoverlay=mcp3208:spi0-1-present" >> /u-boot/config.txt
            else 
                echo "  analog overlay already there" |tee -a $log
                echo "  >o.k.<" |tee -a $log
        fi

        if ! grep -q gpio=5,6,13=pu /u-boot/config.txt;
            then 
                echo "  no gpio input config pull up" |tee -a $log
                echo "  gpio 5,6,13 pull up is being added" |tee -a $log
                echo "gpio=5,6,13=pu" >> /u-boot/config.txt
            else 
                echo "  gpio input config pull up already there" |tee -a $log
                echo "  >o.k.<" |tee -a $log
        fi

        if ! grep -q gpio=5,6,13=ip /u-boot/config.txt;
            then 
                echo "  no gpio input definition" |tee -a $log
                echo "  gpio 5,6,13 input definition is being added" |tee -a $log
                echo "gpio=5,6,13=ip" >> /u-boot/config.txt
            else 
                echo "  gpio 5,6,13 input definition already there" |tee -a $log
                echo "  >o.k.<" |tee -a $log
        fi



        echo "Installation finished!" |tee -a $log
        echo ".. going for reboot .." |tee -a $log
        reboot
    else 
    echo "No Re-installation, Exit" | tee -a $log 
fi





#cat <<DasEnde >> log.txt
#dtoverlay=spi1-3cs
#dtoverlay=mcp2515,spi1-0,oscillator=12000000,speed=2000000,interrupt=24
#dtoverlay=mcp2515,spi0-0,oscillator=12000000,speed=2000000,interrupt=25
#dtoverlay=mcp3208:spi0-1-present
#DasEnde


# 6. reboot
# finish


