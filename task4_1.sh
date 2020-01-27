#!/bin/bash
resultFileName='task4_1.out'

# remove if already exist
[ -e $resultFileName ] && rm -f $resultFileName

cpuInfo=$(lscpu | awk '/^Model name:/{print $3 " " $4 " " $5}')
memTotl=$(cat /proc/meminfo | awk '/^MemTotal:/{printf "%1.0f\n",  $2 / 1024}')
motherMan=$(dmidecode -s baseboard-manufacturer)
motherProductName=$(dmidecode -s baseboard-product-name)
motherInfo=$([[ $motherMan || $motherProductName ]] && echo $motherMan "" $motherProductName || echo "Unknown")
serialNumber=$(dmidecode -s system-serial-number)
echo --- Hardware ---  >> $resultFileName
echo CPU: $cpuInfo >> $resultFileName
echo RAM: $memTotl MB >> $resultFileName 
echo Motherboard: $motherInfo >> $resultFileName
echo System Serial Number: $serialNumber >> $resultFileName
echo --- System --- >> $resultFileName

distribution=$(cat /etc/*-release | awk '/DISTRIB_DESCRIPTION/' | cut -d\= -f2- | tr -d '"')
kernelVersion=$(uname -r)
installationDate=$(dumpe2fs $(mount | grep 'on / ' | awk '{print $1}') | awk '/Filesystem created/' | xargs |cut -d\  -f3-)
uptime=$(uptime | awk -F'( |,|:)+' '{if ($7~/^day/) {d=$6;} else {d=0}} {print d,"days"}')
users=$(users | wc -w)
processes=$(ps aux | wc -l)
echo OS Distribution: $distribution >> $resultFileName
echo Kernel version: $kernelVersion >> $resultFileName
echo Installation date: $installationDate >> $resultFileName
echo Hostname: $HOSTNAME >> $resultFileName
echo Uptime: $uptime >> $resultFileName
echo Processes running: $processes >> $resultFileName
echo Users logged in: $users >> $resultFileName

echo --- Network --- >> $resultFileName
iterator=1
for interface in $(ip -o link show | awk -F ': ' '{print $2}')
do
    info=$(ip  addr show $interface | grep "inet\b"  | awk '{print $2}')
    echo  "#$iterator $interface: $info" >> $resultFileName
    iterator=$(($iterator+1))
done

exit 0