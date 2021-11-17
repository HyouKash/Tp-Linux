#!/usr/bin/env bash

if [[ -d downloads  && -d /var/log/yt ]]; then
        titlename=`youtube-dl --get-filename -o "%(title)s.%(ext)s" $1`
        echo "Video $1 was downloaded."
        mkdir downloads/"${titlename::-4}"
        youtube-dl -q -o downloads/"${titlename::-4}"/"%(title)s.%(ext)s" $1 2>/dev/null
        youtube-dl -q --write-description --skip-download --youtube-skip-dash-manifest -o downloads/"${titlename::-4}"/"desc" $1 2>/dev/null
        mv downloads/"${titlename::-4}"/desc.description downloads/"${titlename::-4}"/description
        echo File Path : /srv/yt/downloads/"${titlename::-4}"/"${titlename}"
        sudo echo "[`date "+%D %T"`] Video $1 was downloaded. File Path : /srv/yt/downloads/"${titlename::-4}"/"${titlename}"" >> /var/log/yt/download.log
else
        echo "Dossier manquant, error.."
        exit
fi
