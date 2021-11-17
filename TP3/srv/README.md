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
File Path : /srv/yt/downloads/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE.mp4

hyouka@node1:~/Tp-Linux/TP3/srv/yt$ cd downloads/
hyouka@node1:~/Tp-Linux/TP3/srv/yt/downloads$ ls
"SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE"
tomfox@node1:~/Tp-Linux/TP3/srv/yt/downloads$ cd "SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE"/
hyouka@node1:~/Tp-Linux/TP3/srv/yt/downloads/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE$ ls
description  "SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE.mp4"
```

Si il en manque un (exemple le dossier downloads) ->

```bash
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ ls
yt.sh
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=jjs27jXL0Zs&ab_channel=REDD%C3%A9fis
Dossier downloads manquant, error..
```

Le fichier de log :
```bash
hyouka@node1:~/Tp-Linux/TP3/srv/yt$ cat /var/log/yt/download.log
[11/17/21 14:16:07] Video https://www.youtube.com/watch?v=jjs27jXL0Zs was downloaded. File Path : /srv/yt/downloads/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE/SI LA VIDÉO DURE 1 SECONDE LA VIDÉO S'ARRÊTE.mp4
[11/17/21 14:34:08] Video https://www.youtube.com/watch?v=Hy5PxbaVdKQ was downloaded. File Path : /srv/yt/downloads/vidéo de 1 seconde./vidéo de 1 seconde.mp4
```
