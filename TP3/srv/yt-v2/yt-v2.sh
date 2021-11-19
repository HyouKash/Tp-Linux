path="home/hyouka/Tp-Linux/TP3/"

command -v python &>/dev/null
if [[ $? == 1 ]]; then                     
        echo "Installa python"
        exit
fi      

command -v youtube-dl &>/dev/null
if [[ $? == 1 ]]; then               
        echo "Install youtube-dl"
        exit
fi

while :
do
        if [[ -d ${path}srv/yt-v2/downloads && -d /var/log/yt ]]; then
                bypass=$(pwd)
                for i in $(cat ${path}srv/yt-v2/file.txt | xargs); do
                        if [[ $i =~ "https://www.youtube.com" ]]; then
                                sed -i '1d' ${path}srv/yt-v2/file.txt
                                titlename=$(youtube-dl -e "$i" 2>&1)
                                if [[ $titlename =~ "ERROR" ]]; then
                                        sudo echo "[$(date "+%D %T")] Video $i has an error : $titlename" >> /var/log/yt/download.log
                                else
                                        mkdir ${path}srv/yt-v2/downloads/"${titlename}"
                                        cd "${path}srv/yt-v2/downloads/${titlename}" && youtube-dl -q -f mp4 -o "${titlename}.mp4" "$i" 2>/dev/null
                                        echo "Video $i was downloaded."
                                        youtube-dl -q --write-description --skip-download --youtube-skip-dash-manifest -o "desc" "$i" 2>/dev/null
                                        mv desc.description description
                                        cd "$bypass" || exit
                                        echo File Path : /srv/yt/downloads/"${titlename}"/"${titlename}"
                                        sudo echo "[$(date "+%D %T")] Video $i was downloaded. File Path : /srv/yt/downloads/""${titlename}""/""${titlename}""" >> /var/log/yt/download.log
                                fi
                        else
                                sed -i '1d' ${path}srv/yt-v2/file.txt
                        fi
                done
        else
                if [[ -d /var/log/yt ]]; then
                        echo "Dossier downloads manquant, error.."                             
                        exit
                elif [[ -d ${path}srv/yt-v2/downloads ]]; then
                        echo "Dossier /var/log/yt/downloads.log manquant, error.."
                        exit
                else
                        echo "Dossier /var/log/yt ou downloads manquant, error.."
                        exit
                fi
        fi
        sleep 5
done
