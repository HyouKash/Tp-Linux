usage() {
	echo "Usage: yt.sh [options...] <url>"
	echo " -q <quality> (best,worst,bestvideo,worstvideo,bestaudio,worstaudio)"
	echo " -o <directory> output file"
	exit
}

if [[ $1 == "-h" || $(($# % 2)) == 0 ]];then
	usage
fi	

if ! command -v youtube-dl &> /dev/null; then
	echo "Install youtube-dl"
	exit
fi	

if ! command -v python &> /dev/null; then   
        echo "Install python"
	exit
fi

if [[ -d downloads && -d /var/log/yt ]]; then
        titlename=$(youtube-dl -e "${!#}" 2>&1)
        if [[ ! ${!#} =~ "https://www.youtube.com/watch" ]]; then
                echo "Video link is bad, retry.."
                sudo echo "[$(date "+%D %T")] Invalid format ${!#}" >> /var/log/yt/download.log
                exit
	elif [[ $titlename =~ "ERROR" ]]; then
		echo "Video not found"
		exit
	else
	downloadpath="downloads/"
		if [[ $1 == "-o" ]]; then
			downloadpath=$2
		fi
		mkdir ${downloadpath}"${titlename}"
		if [[ $1 == "-q" ]]; then
			cd "${downloadpath}${titlename}" && youtube-dl -q -f "$2/mp4" -o "${titlename}.mp4" "${!#}" 2>/dev/null
			youtube-dl --get-description "${!#}" > description 
		else	
                	cd "${downloadpath}${titlename}" && youtube-dl -q -f mp4 -o "${titlename}.mp4" "${!#}" 2>/dev/null
			youtube-dl --get-description "${!#}" > description
		fi	
                echo "Video ${!#} was downloaded."
                echo "File Path : ${downloadpath}${titlename}"/"${titlename}.mp4"
                sudo echo "[$(date "+%D %T")] Video $1 was downloaded. File Path : ${downloadpath}${titlename}/${titlename}.mp4" >> /var/log/yt/download.log
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
