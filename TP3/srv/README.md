# Compte rendu TP3 
---

**idcard :**

Script idcard -> https://github.com/HyouKash/Tp-Linux/blob/master/TP3/srv/idcard/idcard.sh 

Output : 

```bash
hyouka@node1:~$ sudo bash idcard.sh
Machine name : node1.tp1.linux
Os name -> Ubuntu and kernel version -> Linux5.13.0-19-generic
Ip : 10.0.2.15
Used ram 432M / 1,9G Total Ram
Disque : 2,8 Go left
Top 5 processes by RAM usage : 
- /usr/lib/xorg/Xorg
- xfwm4
- /usr/bin/python3
- xfdesktop
- /usr/lib/x86_64-linux-gnu/xfce4/panel/wrapper-2.0
Listening ports :
- 53 : systemd-r
- 631 : cupsd
- 1402 : sshd
- 14023 : vsftpd
Random Cat : https://cdn2.thecatapi.com/images/6t9.jpg
```

**Youtube-dl :**

Script yt-dl -> https://github.com/HyouKash/Tp-Linux/blob/master/TP3/srv/yt/yt.sh

Output : 

Si les dossier downloads et /var/log/yt sont présents ->

```bash
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=jjs27jXL0Zs&ab_channel=REDD%C3%A9fis
Video https://www.youtube.com/watch?v=jjs27jXL0Zs was downloaded.
File Path : /srv/yt/downloads/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE
```

Si il en manque un (exemple le dossier downloads) ->

```bash
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ ls
yt.sh
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=jjs27jXL0Zs&ab_channel=REDD%C3%A9fis
Dossier downloads manquant, error..
```

Si il y a une erreur et que la vidéo n'existe pas ->
```bash
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=fegfegeahahaha
Video link is bad, retry..
```
Le fichier de log après plusieurs DL:
```bash
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ cat /var/log/yt/download.log
[11/19/21 09:18:28] Video https://www.youtube.com/watch?v=jjs27jXL0Zs was downloaded. File Path : /srv/yt/downloads/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE
[11/19/21 09:20:28] Video https://www.youtube.com/watch?v=BEhmgN6_k5A was downloaded. File Path : /srv/yt/downloads/Sardoche réagit au niveau MONSTRUEUX de MV sur LoL au Zevent/Sardoche réagit au niveau MONSTRUEUX de MV sur LoL au Zevent
[11/19/21 09:21:05] Video https://www.youtube.com/watch?v=fegfege_k5A has an error : ERROR: Video unavailable
[11/19/21 09:24:16] Video https://www.youtube.com/watch?v=Y9N0G9Ib1oE was downloaded. File Path : /srv/yt/downloads/cette esquive de fou ! - MV #missclick?/cette esquive de fou ! - MV #missclick?
```
**Youtube-dl Service :**

Script yt-dl V2 -> https://github.com/HyouKash/Tp-Linux/blob/master/TP3/srv/yt-v2/yt-v2.sh

Le service : 
```bash
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ cat /etc/systemd/system/yt.service
[Unit]
Description= Youtube DL Service

[Service]
ExecStart=sudo bash /home/hyouka/Tp-Linux/TP3/srv/yt-v2/yt-v2.sh

[Install]
WantedBy=multi-user.target
```

Je le lance

```bash
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ sudo systemctl start yt
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ sudo systemctl status yt
● yt.service - Youtube DL Service
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-11-19 10:29:01 CET; 4s ago
   Main PID: 33374 (sudo)
      Tasks: 3 (limit: 1092)
     Memory: 1.5M
     CGroup: /system.slice/yt.service
             ├─33374 /usr/bin/sudo bash /home/hyouka/Tp-Linux/TP3/srv/yt-v2/yt-v2.sh
             ├─33375 bash /home/hyouka/Tp-Linux/TP3/srv/yt-v2/yt-v2.sh
             └─33381 sleep 5

nov. 19 10:29:01 hyouka-VirtualBox systemd[1]: Started Youtube DL Service.
nov. 19 10:29:01 hyouka-VirtualBox sudo[33374]:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/bash /home/hyouka/Tp-Linux/TP3/srv/yt-v2/yt-v2.sh
nov. 19 10:29:01 hyouka-VirtualBox sudo[33374]: pam_unix(sudo:session): session opened for user root by (uid=0)
```

Le script tourne, je mets maintenant des liens bons et mauvais, puis je vais dans mes logs

```bash
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ echo "https://www.youtube.com/watch?v=HH1up9t5l9Y&ab_channel=ypn0" >> file.txt
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ echo "https://www.youtube.com/watch?v=9mFiytre93Y&ab_channel=hypn0" >> file.txt 
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ cat file.txt 
https://www.youtube.com/watch?v=9mFiytre93Y&ab_channel=hypn0
```

Le premier lien a été téléchargé et est donc supprimé
Les logs ->

```bash
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ tail -f /var/log/yt/download.log 
[11/19/21 10:48:36] Video https://www.youtube.com/watch?v=HH1up9t5l9Y&ab_channel=hypn0 was downloaded. File Path : /srv/yt/downloads/Does Aphelios need a team to 1v5 every game? (1v5 Pentakill)/Does Aphelios need a team to 1v5 every game? (1v5 Pentakill)
[11/19/21 10:52:08] Video https://www.youtube.com/watch?v=9mFiytre93Y&ab_channel=hypn0 was downloaded. File Path : /srv/yt/downloads/Is Aphelios really that OP when ahead?/Is Aphelios really that OP when ahead?
```

le service -> 

```bash
hyouka@hyouka-VirtualBox:~/Tp-Linux/TP3/srv/yt-v2$ sudo systemctl status yt
● yt.service - Youtube DL Service
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-11-19 10:46:09 CET; 6min ago
   Main PID: 36305 (sudo)
      Tasks: 3 (limit: 1092)
     Memory: 22.2M
     CGroup: /system.slice/yt.service
             ├─36305 /usr/bin/sudo bash home/hyouka/Tp-Linux/TP3/srv/yt-v2/yt-v2.sh
             ├─36306 bash home/hyouka/Tp-Linux/TP3/srv/yt-v2/yt-v2.sh
             └─36488 sleep 5

nov. 19 10:48:34 hyouka-VirtualBox sudo[36306]: Video https://www.youtube.com/watch?v=HH1up9t5l9Y&ab_channel=hypn0 was downloaded.
nov. 19 10:48:36 hyouka-VirtualBox sudo[36306]: File Path : /srv/yt/downloads/Does Aphelios need a team to 1v5 every game? (1v5 Pentakill)/Does Aphelios need a team to 1v5 every game? (1v5 Pentakill)
nov. 19 10:48:36 hyouka-VirtualBox sudo[36384]:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/echo [11/19/21 10:48:36] Video https://www.youtube.com/watch?v=HH1up9t5l9Y&ab_channel=hypn0 was downloaded. File Path : /srv/>
nov. 19 10:48:36 hyouka-VirtualBox sudo[36384]: pam_unix(sudo:session): session opened for user root by (uid=0)
nov. 19 10:48:36 hyouka-VirtualBox sudo[36384]: pam_unix(sudo:session): session closed for user root
nov. 19 10:52:06 hyouka-VirtualBox sudo[36306]: Video https://www.youtube.com/watch?v=9mFiytre93Y&ab_channel=hypn0 was downloaded.
nov. 19 10:52:08 hyouka-VirtualBox sudo[36306]: File Path : /srv/yt/downloads/Is Aphelios really that OP when ahead?/Is Aphelios really that OP when ahead?
nov. 19 10:52:08 hyouka-VirtualBox sudo[36438]:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/echo [11/19/21 10:52:08] Video https://www.youtube.com/watch?v=9mFiytre93Y&ab_channel=hypn0 was downloaded. File Path : /srv/>
nov. 19 10:52:08 hyouka-VirtualBox sudo[36438]: pam_unix(sudo:session): session opened for user root by (uid=0)
nov. 19 10:52:08 hyouka-VirtualBox sudo[36438]: pam_unix(sudo:session): session closed for user root
```

**BONUS**

Asciinema du service YT

[![asciicast](https://asciinema.org/a/69trmQs0BgvniukVHPd4J54BS.svg)](https://asciinema.org/a/69trmQs0BgvniukVHPd4J54BS)

Les fonctions bonus : 

- check si les fichiers sont bien présents
- check si l'url donnée est bonne et renvoie bien vers une video
- check les dependencies (jq, youtube-dl, python, etc..)
