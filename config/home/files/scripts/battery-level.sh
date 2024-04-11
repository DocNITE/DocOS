check_battery_level() {
  battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')
  if $battery_level -le 20
  then
      notify-send -u critical "Battery low" "Battery level is ${battery_level}%!"
  fi
}

while :
do
    check_battery_level
    sleep 300
done
