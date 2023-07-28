#!/bin/bash
info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)

if [ "$1" == "" ]; then
    echo "$info"

elif [ "$1" == "info" ]; then
    life=$(echo "$info" | grep "time to" | tr -s " ")
    dunstify -r 1094 "Battery Info" "$life"

elif [ "$1" == "bar" ]; then
    percent=$(echo "$info" | grep percent | grep -E [0-9]+ -o)

    if [ $(echo "$info" | grep -cE "state:\s*discharging") == "1" ]; then
        case $((percent/20)) in
            0) echo -n %{F#ff2222} ;;
            1) echo -n   ;;
            2) echo -n   ;;
            3) echo -n   ;;
            4) echo -n   ;;
            5) echo -n   ;;
        esac
    else
        echo -n 
    fi
    echo "  $percent%"
else
    echo "Invalid argument"
fi
