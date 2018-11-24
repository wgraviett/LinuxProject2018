#!/bin/bash
CurrentIP=$(ifconfig | grep "inet" | grep -v "inet6" | grep -v "inet 127.0.0.1" | tr -s"" " " | cut -d " " -f3 | grep "192." | cut -d "." -f1,2,3)
CurrentIPLastOctet=$(ifconfig | grep "inet" | grep -v "inet6" | grep -v "inet 127.0.0.1" | tr -s"" " " | cut -d " " -f3 | grep "192." | cut -d "." -f4)

echo $CurrentIP #finds Current IP
echo " Locating Nodes on network..."
IPPingLocatorLimit=0
for ((i=1; i<255; i++)) #Check all class C IP address to see available machines.
do
	if [ $i -ne $CurrentIPLastOctet ] #Skips Master Host Ping/ssh.
	then
	if [ $IPPingLocatorLimit -ne 2 ] ##used to pause after two are detected. 
	then
	$(ping -c 1 $CurrentIP.$i > /dev/null) #verifies active nodes, CurrentIP variable holds 3 octets of ip address, this allows for the for loop to cycle 1 to 255 for any class C address such as 192.168.1.x, or 192.168.2.x
	if [ $? -eq 0 ] #If node is active, then ssh and receive data. 
	then
		echo " Found: $CurrentIP.$i"
		echo " Connecting over ssh"
		ssh -t root@$CurrentIP.$i " $(< projectContents.sh)" >> data.txt
		let "IPPingLocatorLimit++" #used to count active nodes
		if [ $IPPingLocatorLimit -ne 2 ] #if 2 nodes have not been found yet, continue
		then
			echo " Locating additional nodes..."
		fi
	fi
fi
fi
done

echo " Information collected and saved to data.txt"
echo " SSH to Amazon Instance"
ssh -t -i "/home/user1/projectkey.pem" ec2-user@ec2-18-212-123-108.compute-1.amazonaws.com " $(< CheckDockerInstalled.sh)" #Checks for docker installed, if not then it installs.
$(scp -i "/home/user1/projectkey.pem" /home/user1/LinuxProject2018/data.txt ec2-user@ec2-18-212-123-108.compute-1.amazonaws.com:/var/website) #Transfer latest node information to remote web server on AWS instance. 
echo "Docker Install verified and latest node information updated to 18.212.123.108:8080/data.txt"


