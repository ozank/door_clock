#!/bin/bash

# single argument step 
# go to initial position,in clockwise direction, wait and come back

delay=0.003
cycles=$1

# Define input outputs
#sudo su  # instead run the code using root

# LCD_D4 - DIRECTION  
echo 100 > /sys/class/gpio/export

# LCD_D6 - STEP
echo 102 > /sys/class/gpio/export

# LCD_D10 - SLEEP
echo 106 > /sys/class/gpio/export

# LCD_D12 - RESET
echo 108 > /sys/class/gpio/export

# LCD_D14 - MS3
echo 110 > /sys/class/gpio/export

# LCD_D18 - MS2
echo 114 > /sys/class/gpio/export

# LCD_D20 - MS1
echo 116 > /sys/class/gpio/export

#LCD_D22 - ENABLE
echo 118 > /sys/class/gpio/export 

echo out > /sys/class/gpio/gpio100/direction
echo out > /sys/class/gpio/gpio102/direction
echo out > /sys/class/gpio/gpio106/direction
echo out > /sys/class/gpio/gpio108/direction
echo out > /sys/class/gpio/gpio110/direction
echo out > /sys/class/gpio/gpio114/direction
echo out > /sys/class/gpio/gpio116/direction
echo out > /sys/class/gpio/gpio118/direction

#Set Step Size
# 0 0 0 tam adim
# 1  0 0 yarim adim  (132.5 adim 1 saat), 1600 adim 12 saat?
# 0 1 0 ceyrek adim (530 adim 1 saat)

echo 1 > /sys/class/gpio/gpio110/value
echo 0 > /sys/class/gpio/gpio114/value
echo 0 > /sys/class/gpio/gpio116/value

#SET  RESET AND ENABLE
echo 1 > /sys/class/gpio/gpio106/value
echo 1 > /sys/class/gpio/gpio108/value


#ENABLE (0'da enable olur)
echo 0 > /sys/class/gpio/gpio118/value

#wait for initialization
sleep 0.1 

#Set direction (clockwise direction)
echo 0 > /sys/class/gpio/gpio100/value

for (( i=1; i<=$cycles; i++ ))
do

	echo 0 > /sys/class/gpio/gpio102/value
	sleep $delay
	echo 1 > /sys/class/gpio/gpio102/value
	sleep $delay
done

#wait for other direction
sleep 10
 
#Set direction (clockwise direction)
echo 1 > /sys/class/gpio/gpio100/value

for (( i=1; i<=$cycles; i++ ))
do

	echo 0 > /sys/class/gpio/gpio102/value
	sleep $delay
	echo 1 > /sys/class/gpio/gpio102/value
	sleep $delay
done

#disable yapmadan önce biraz bekle
sleep 1

#DISABLE
echo 1 > /sys/class/gpio/gpio118/value

echo 100 > /sys/class/gpio/unexport
echo 102 > /sys/class/gpio/unexport
echo 106 > /sys/class/gpio/unexport
echo 108 > /sys/class/gpio/unexport
echo 110 > /sys/class/gpio/unexport
echo 114 > /sys/class/gpio/unexport
echo 116 > /sys/class/gpio/unexport
echo 118 > /sys/class/gpio/unexport

exit 1

