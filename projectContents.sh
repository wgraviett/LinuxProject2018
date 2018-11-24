#!/bin/bash
echo -n "1:Node name: ";hostname;echo -n "2:Distribution: "; cat /etc/*-release | sed '2!d'; echo -n "3: Architecture: "; arch; echo -n "4: Interface Devices: "; ifconfig| grep "enp"| tr ":" " " | cut -d " " -f1 | tr "\n" ","; printf "\n"; echo -n "5: IP Address: "; ifconfig | grep "inet" | grep -v "inet6" | grep -v "inet 127.0.0.1" | tr -s "" " " | cut -d " " -f3 |tr "\n" ","; printf "\n"; echo -n "6: Users Logged into the System: "; who | tr -s"" " " | cut -d " " -f1 | tr "\n" ","; printf "\n"; echo -n "7:HDD Total Space: "; fdisk -l | grep "Disk /dev/sda" | cut -d ":" -f2 | cut -d "," -f1; echo -n "8: HDD Used Space";  df -h | grep "/dev/sd" | tr -s"" " " | cut -d " " -f3; echo -n "9:Total Memory: "; free -h | grep "Mem:" | tr -s"" " " | cut -d " " -f2; echo -n "10: Free Memory: "; free -h | grep "Mem:" | tr -s"" " " | cut -d " " -f4; echo -n "11:Number of user accounts created after installation:"; awk -F ":" '{ if ($3 >= 1000 && $3 <= 6000 ) print $0}' /etc/passwd | wc -l; echo -n "12: Number of users that were able to logg into the system from installation time:"; lastlog | grep -v "**Never logged in**" | grep -v "Latest" | wc -l; echo -n "13: Total number of user groups: "; cat /etc/group | wc -l; echo -n "14: System Uptime: "; uptime | cut -d" " -f2; echo -n "15:Processor:"; less /proc/cpuinfo | grep "model name" | cut -d":" -f2; printf "\n"
