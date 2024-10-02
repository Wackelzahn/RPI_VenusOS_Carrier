#!/bin/bash


source "/data/RpiVenusCarrier/Files/RpiVenusCarrierFunctions"

# Test program to call functions
	echo "---- RpiVenusCarrierSetup ----"
	echo "------------------------------"

	
echo "checking log file existance..."

	if checkLogFile
		then
			echo $(date) >> $log
			echo "log file existing. It seems Setup was performed before." 2>&1 | tee -a $log
			echo "- a re-install will purge the log file." 2>&1 | tee -a $log
			echo "- the machine will perform an automated reboot at the end of the installation." 2>&1 | tee -a $log
			echo "  Continue (y/n)? " 2>&1 | tee -a $log
			if yesNo
				then
					rpiVenusCarrierCreateLog
					#rpiVenusCarrierRcLocal
					rpiVenusCarrierManualSetup
					rpiVenusCarrierSetup
					rpiVenusCarrierReboot
				else
					echo "chosen not! to re-install" 2>&1 | tee -a $log
					echo "good bye.." 2>&1 | tee -a $log
			fi
					
		else	
			echo "log file does not exist. Initial Setup."
			echo "- the program will make the machine reboot after Setup." 
			echo "  Continue (y/n)? " 
			if yesNo
				then
				
					rpiVenusCarrierCreateLog
					rpiVenusCarrierManualSetup
					#rpiVenusCarrierRcLocal
					rpiVenusCarrierSetup
					rpiVenusCarrierReboot
				else
					echo "good bye.."
			fi
	fi




 

