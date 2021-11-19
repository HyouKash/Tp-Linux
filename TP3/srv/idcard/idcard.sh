if [ ! jq --version 2>&1 ]; then
	echo "Install jq"
	exit
fi	

hostname=$(hostname)
osname=$(grep '^NAME' /etc/os-release)
kernel=$(hostnamectl | grep Kernel | tr -d " ")
ip=$(hostname -I | awk '{print $1}')
tram=$(free -h | grep Mem | awk '{print $2}')
usedram=$(free -h | grep Mem | awk '{print $3}')
used=$(df -h | grep /dev/sda3 | awk '{print $4}')
procname=$(ps -aux --sort -%mem | head -n 6 | awk '{print "- " $11}' | tail -n 5)
nameports=$(lsof -i -P | grep LISTEN | uniq -w 20 | awk '{print "- " $9 " : " $1}' | tr ":" " " | awk '{print "- " $3 " : " $4}')
printcat=$(curl -s https://api.thecatapi.com/v1/images/search | jq -r ".[].url")
echo "Machine name : ${hostname}"
echo "Os name -> ${osname:6:-1} and kernel version -> ${kernel:7}"
echo "Ip : ${ip}"
echo "Used ram ${usedram::-1} / ${tram::-1} Total Ram"
echo "Disque : ${used::-1} Go left"
echo "Top 5 processes by RAM usage : "
echo "${procname}"
echo "Listening ports :"
echo "${nameports}"
echo "Random Cat : ${printcat}"
