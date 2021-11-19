#!/usr/bin/env bash

if [[ -d downloads && -d /var/log/yt ]]; then
	bypass=`pwd`
	for i in `cat file.txt | xargs`; do
		if [[ $i =~ "https://www.youtube.com" ]]; then
			sed -i '1d' file.txt
        		titlename=`youtube-dl -e $i 2>&1`
			if [[ $titlename =~ "ERROR" ]]; then
				exit
			else
        			mkdir downloads/"${titlename}"
        			cd "downloads/${titlename}" && youtube-dl -q -f mp4 -o "${titlename}.mp4" $i 2>/dev/null
				echo "Video $i was downloaded."
				youtube-dl -q --write-description --skip-download --youtube-skip-dash-manifest -o "desc" $i 2>/dev/null
        			mv desc.description description
				cd $bypass
				echo File Path : /srv/yt/downloads/"${titlename}"/"${titlename}"
				sudo echo "[`date "+%D %T"`] Video $i was downloaded. File Path : /srv/yt/downloads/"${titlename}"/"${titlename}"" >> /var/log/yt/download.log
			fi
		else
			sed -i '1d' file.txt
		fi
	done
else
	if [[ -d /var/log/yt ]]; then
		echo "Dossier downloads manquant, error.."                             
                exit
	elif [[ -d downloads ]]; then
		echo "Dossier /var/log/yt/downloads.log manquant, error.."
		exit
	else
		echo "Dossier /var/log/yt ou downloads manquant, error.."
		exit
	fi	
fi
