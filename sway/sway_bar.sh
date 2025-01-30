#!/bin/local/bin/bash

date_time=$(date +'%Y-%m-%d %X')
battery_status=$(sysctl hw.acpi.battery.life | cut -d":" -f2 | xargs)
vol_level=$(echo "`mixer vol.volume | cut -d"=" -f2 | cut -d":" -f1` * 100" | bc)

echo "Vol: $vol_level | Bat: $battery_status% | $date_time"
