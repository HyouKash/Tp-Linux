if [[ -d downloads && -d /var/log/yt ]]; then
        titlename=$(youtube-dl -e "$1" 2>&1)
        if [[ $titlename =~ "ERROR" ]]; then
                echo "Video link is bad, retry.."
                sudo echo "[$(date "+%D %T")] Video $1 has an error : $titlename" >> /var/log/yt/download.log
                exit
        else
                mkdir downloads/"${titlename}"
                cd "downloads/${titlename}" && youtube-dl -q -f mp4 -o "${titlename}.mp4" "$1" 2>/dev/null
                echo "Video $1 was downloaded."
                youtube-dl -q --write-description --skip-download --youtube-skip-dash-manifest -o "desc" "$1" 2>/dev/null
                mv desc.description description
                echo File Path : /srv/yt/downloads/"${titlename}"/"${titlename}"
                sudo echo "[$(date "+%D %T")] Video $1 was downloaded. File Path : /srv/yt/downloads/""${titlename}""/""${titlename}""" >> /var/log/yt/download.log
        fi
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
