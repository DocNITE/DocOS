#!/bin/bash

# Guide:
# $1: laptop|monitor - what you want change,
#	laptop screen or monitor
#
# $2 disable|enable - want disable or enable
#     laptop screen
#
# $3 none|bottom|auto - position align, 
#     where you want place your screen
#
# Example usage:
# $ sh laptop-display-off.sh laptop enable bottom

# Constants
_LD_LAPTOP_NAME="eDP-1"
_LD_LAPTOP_SCALE="1.60"
_LD_MONITOR_NAME="HDMI-A-1"
_LD_MONITOR_SCALE="1"

# Variables
_ld_scr="eDP-1"
_ld_scale="1"
_ld_pos="auto"

if [ "$1" = "laptop" ]; then
  _ld_scr=$_LD_LAPTOP_NAME
  _ld_scale=$_LD_LAPTOP_SCALE
elif [ "$1" = "monitor" ]; then
  _ld_scr=$_LD_MONITOR_NAME
  _ld_scale=$_LD_MONITOR_SCALE
fi

# Now checks what should we want configure
if [ "$#" -ge 3 ] && [ "$3" = "bottom" ]; then
  if [ $_ld_scr = $_LD_LAPTOP_NAME ]; then
    _ld_pos="160x1080"
  fi
fi

# If $2 doesnt exist, we should exit
if [ "$#" -lt 2 ]; then
  echo "ERROR: Skiped argument '2' for enable|disable screen!"
  exit 1 
fi

if [ "$2" = "disable" ]; then
  hyprctl keyword monitor "$_ld_scr, disable"
elif [ "$2" = "enable" ]; then
  hyprctl keyword monitor "$_ld_scr, preferred, $_ld_pos, $_ld_scale"
fi

echo "Monitor $_ld_scr succesfully changed!"
