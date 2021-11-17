#!/usr/bin/env bash

if [[ -d downloads && -d /var/log/yt ]]; then
        titlename=`youtube-dl -e $1`
        echo "Video $1 was downloaded."
        mkdir downloads/"${titlename}"
        cd "downloads/${titlename}" && youtube-dl -q -f mp4 -o "${titlename}.mp4" $1 2>/dev/null
        youtube-dl -q --write-description --skip-download --youtube-skip-dash-manifest -o downloads/"${titlename}"/"desc" $1 2>/dev/null
        mv downloads/"${titlename}"/desc.description downloads/"${titlename}"/description
        echo File Path : /srv/yt/downloads/"${titlename}"/"${titlename}"
        sudo echo "[`date "+%D %T"`] Video $1 was downloaded. File Path : /srv/yt/downloads/"${titlename}"/"${titlename}"" >> /var/log/yt/download.log
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
