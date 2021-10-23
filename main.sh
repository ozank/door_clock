#!/bin/bash

#Kapi saati için ana kodlar


#Konumu al fonksiyonu
# CloudMQQT ve OwnTracks kullanilarak guncel komutu alma

konumu_al () {
konumum=$(mosquitto_sub -h farmer.cloudmqtt.com -p 10085 -u ttrenipy -P oA3j4GOS5zHv -t owntracks/ttrenipy/ozi -C 1 -F '%J' | jq -r .payload.inregions) 
}

#Calisma klasorunu degistir
cd /home/chip/door_clock/

#Mevcut IP adresini log dosyasına kaydet
ip -4 a show wlan0 >>ip_log.md 
#commit to git repo
git commit -am "ip changed"
git push

#Main loop

while true
do

konumu_al
#echo $konumum

# Ofisteyim loopu #########

while [[ $konumum == *ofis* ]];
do
#echo $konumum

#Tekrar konum al
konumu_al 

#sleep one minute
sleep 60

#hala ofisteysen bash'deki seconds değişkenini sıfırla
SECONDS=0

done
################



#Ofiste değilim kapı tıklanmasını bekliyorum
./cift_tiklama.py

# Kapi tıklandı pozisyonu guncelle 
konumu_al 

#konuma göre akrep hareketi icin dakika hesapla
case "$konumum" in

*ofis*)  
	pozisyon=0
    ;;
*bolum*)
	pozisyon=60
    ;;
*kampus*)  
	pozisyon=120
    ;;
*ankara*)  
	pozisyon=180
    ;;
*) 
	pozisyon=240
    ;;
esac

#Deneme icin bir deger ata
#SECONDS=10800

#Sureye göre dakika hesapla logaritmik
dakika=$(( SECONDS/60 ))

if [[ $dakika -le 6 ]]
then
    sure=$(echo "$dakika+30" | bc -l)

elif [[ $dakika -le 60 ]] 
then
    sure=$(echo "5*l($dakika/6)/l(10)+35" | bc -l)

elif [[ $dakika -le 600 ]] 
then
    sure=$(echo "5*l($dakika/60)/l(10)+40" | bc -l)

elif [[ $dakika -le 6000 ]] 
then
    sure=$(echo "5*l($dakika/600)/l(10)+45" | bc -l)

elif [[ $dakika -le 60000 ]] 
then
    sure=$(echo "5*l($dakika/6000)/l(10)+50" | bc -l)

else
    sure=55

fi 

#toplam_dakika=pozisyon+sure
#tam tur (12 saat) 1600 adım
#tam tur (12 saat) 1692 adım

#ceyrek adim 1 saat 540 adim
#ceyrek adim 12 saat 6400 adim

adim=$(echo "scale=0; ($pozisyon+$sure)*6400/720" | bc -l)

#round to multiple of 8
adim=$(echo "scale=0; $adim/8" | bc -l)
adim=$(echo "scale=0; $adim*8" | bc -l)

#echo $sure
#echo $adim
#echo $SECONDS

#turn clockwise, wait, and come back CCW
#./git_gel.sh $adim 

#turn clockwise, wait, and come backe in CW
./git_git.sh $adim 

#Kapi vurus log dosyasini guncelle
date >> time_log.md
echo "$konumum" >> time_log.md
echo "$dakika" >> time_log.md

#commit to git repo
git commit -am "door event"
git push

#wait 10sec for next round
sleep 10

done	
