#!/bin/bash
wasLow=false
while true;do
    batteryLevel=$(cat /sys/class/power_supply/BAT0/capacity)
    isCharging=$(cat /sys/class/power_supply/ACAD/online)  

    if [[ "$batteryLevel" -le 20 && "$wasLow" = false && "$isCharging" -eq 0 ]];then
	notify-send -u critical "Battery low" "Your battery is lesser than 20%"
	wasLow=true
    fi
    
    if [[ "$batteryLevel" -ge 25 && "$wasLow" = true ]];then
	wasLow=false
    fi

    if [[ "$wasLow" = true && "$isCharging" -eq 1 ]];then
	swaync-client --close-latest
    fi 
    sleep 300
done
