#!/bin/bash

# Initialize blueetooth ibeacon
#sudo su

#other alternatives
# Talking with a phone over bluetooth
#http://dotnet.work/2016/02/detecting-smartphone-via-bluetooth-on-linux-raspberry-pi-2/



# Define ibeacon
# https://medium.com/@bhargavshah2011/converting-raspberry-pi-3-into-beacon-f01b3169e12f
hcitool cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 17 6F FA 9D 2E B1 44 EA B4 34 57 30 C2 41 D6 1A 00 01 00 01 C8

sleep 0.5
#Start Broadcasting
hcitool cmd 0x08 0x000A 01

#Stop Broadcasting if required
#hcitool cmd 0x08 0x000A 00
