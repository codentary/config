#!/bin/bash

intern=eDP-1
extern=DP-1

if xrandr | grep "$extern disconnected"; then
    xrandr --output "$extern" --off --output "$intern" --auto   # Turn laptop display on and external display off
else
    xrandr --output "$intern" --off --output "$extern" --auto   # Turn laptop display off and external display on
fi
