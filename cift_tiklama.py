#!/usr/bin/python
import time
import CHIP_IO.GPIO as GPIO

#GPIO.cleanup()

GPIO.setup("XIO-P0", GPIO.IN)

tiklatma_sayisi = 0

# handle the button event
def kapi_tiklatma (pin):
    global tiklatma_sayisi
    # turn LED on
    print('kapi tiklatildi')
    tiklatma_sayisi += 1
    print(tiklatma_sayisi)
    #bir daha tiklatma icin biraz bekle
    time.sleep(0.1)

GPIO.add_event_detect("XIO-P0", GPIO.FALLING, callback=kapi_tiklatma)


try:
    while True :
        if (tiklatma_sayisi >= 2 ):
            GPIO.cleanup("XIO-P0")
            exit()
        pass
except:
    GPIO.cleanup("XIO-P0")

