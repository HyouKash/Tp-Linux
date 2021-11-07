# TP2 Explorer et manipuler le système

**Intro** : 

➜ **Nommer la machine**
```bash
hyouka@hyouka:~$ sudo hostname node1.tp1.linux
```
Quand on relance un terminal : ctrl + alt + T
```bash   
hyouka@node1:~$ hostname
node1.tp1.linux
```
On change maintenant le /etc/hostname
```bash
hyouka@node1:~$ echo "node1.tp1.linux" | sudo tee /etc/hostname    hyouka@node1:~$ cat /etc/hostname
node1.tp1.linux
```   
node1.tp1.linux se situe bien dans le /etc/hostname

➜ **Config réseau**
```bash
hyouka@node1:~$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=63 time=22.8 ms
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 23.097/23.192/23.287/0.095 ms
```

On arrive bien à ping 1.1.1.1
```bash 
hyouka@node1:~$ ping ynov.com
PING ynov.com (92.243.16.143) 56(84) bytes of data.
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=1 ttl=63     time=21.4 ms
--- ynov.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 22.423/27.056/31.690/4.633 ms
```
On arrive bien à ping ynov.com

```bash
    ping 192.168.56.102
    PING 192.168.56.102 (192.168.56.102) 56(84) octets de données.
    64 octets de 192.168.56.102 : icmp_seq=1 ttl=64 temps=0.531 ms
    64 octets de 192.168.56.102 : icmp_seq=2 ttl=64 temps=0.495 ms
    --- statistiques ping 192.168.56.102 ---
    2 paquets transmis, 2 reçus, 0% packet loss, time 1006ms
    rtt min/avg/max/mdev = 0.495/0.513/0.531/0.018 ms
```
On arrive bien à ping la machine depuis notre pc

**SSH :**

➜ **Installation**
```bash 
hyouka@node1:~$ sudo apt install openssh-server
```

➜ **Lancement du service SSH**
```bash 
hyouka@node1:~$ systemctl start sshd
hyouka@node1:~$ systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: e>
     Active: active (running) since Mon 2021-10-25 11:26:10 CEST; 2min 15s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 2617 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 2618 (sshd)
      Tasks: 1 (limit: 2314)
     Memory: 1.0M
        CPU: 10ms
     CGroup: /system.slice/ssh.service
             └─2618 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

oct. 25 11:26:10 node1.tp1.linux systemd[1]: Starting OpenBSD Secure Shell serv>
oct. 25 11:26:10 node1.tp1.linux sshd[2618]: Server listening on 0.0.0.0 port 2>
oct. 25 11:26:10 node1.tp1.linux sshd[2618]: Server listening on :: port 22.
oct. 25 11:26:10 node1.tp1.linux systemd[1]: Started OpenBSD Secure Shell serve>
```

➜ **Etude du service SSH**

```bash 
hyouka@node1:~$ ps -aux | grep sshd
root        2618  0.0  0.3  13132  6892 ?        Ss   11:26   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

hyouka@node1:~$ sudo ss -l | grep ssh
u_str LISTEN 0      4096         /run/user/1000/gnupg/S.gpg-agent.ssh 19128                           * 0           
u_str LISTEN 0      10                     /run/user/1000/keyring/ssh 19755                           * 0           
tcp   LISTEN 0      128                                       0.0.0.0:ssh                       0.0.0.0:*           
tcp   LISTEN 0      128                                          [::]:ssh                          [::]:*

hyouka@node1:~$ journalctl | grep sshd
oct. 19 12:40:50 hyouka useradd[1581]: new user: name=sshd, UID=123, GID=65534, home=/run/sshd, shell=/usr/sbin/nologin, from=none
oct. 19 12:40:50 hyouka usermod[1589]: change user 'sshd' password
oct. 19 12:40:50 hyouka chage[1596]: changed password expiry for sshd
```
On se connecte au serveur en SSH

```bash 
ssh hyouka@192.168.56.102
hyouka@192.168.56.102's password:
hyouka@node1:~$ 
``` 

➜ **Modification de la configuration du serveur**

```bash 
hyouka@node1:/etc/ssh$ cat sshd_config
#	$OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

Port 1402

hyouka@node1:/etc/ssh$ systemctl restart sshd
```

Le nouveau port est 1402

```bash 
hyouka@node1:~$ sudo ss -l | grep 1402
tcp   LISTEN 0      128                                       0.0.0.0:1402                      0.0.0.0:*           
tcp   LISTEN 0      128                                          [::]:1402                         [::]:*
```

Pour me connecter au serveur en SSH maintenant : 
```bash 
ssh hyouka@192.168.56.102 -p 1402
hyouka@192.168.56.102's password: 
hyouka@node1:~$ 
```

**FTP :**

➜ **Installation du serveur**
```bash 
hyouka@node1:~$ sudo apt install vsftpd
```

➜ **Lancement du service FTP**
```bash 
hyouka@node1:~$ systemctl start vsftpd
hyouka@node1:~$ systemctl status vsftpd
● vsftpd.service - vsftpd FTP server
     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 12:05:58 CEST; 2min 21s ago
    Process: 1704 ExecStartPre=/bin/mkdir -p /var/run/vsftpd/empty (code=exited, status=0/SUCCESS)
   Main PID: 1705 (vsftpd)
      Tasks: 1 (limit: 2314)
     Memory: 680.0K
        CPU: 2ms
     CGroup: /system.slice/vsftpd.service
             └─1705 /usr/sbin/vsftpd /etc/vsftpd.conf

oct. 25 12:05:58 node1.tp1.linux systemd[1]: Starting vsftpd FTP server...
oct. 25 12:05:58 node1.tp1.linux systemd[1]: Started vsftpd FTP server.
```

➜ **Etude du service FTP**

Le status est au dessus
```bash 
hyouka@node1:~$ ps -aux | grep vsftpd
root        1705  0.0  0.1   8668  3808 ?        Ss   12:05   0:00 /usr/sbin/vsftpd /etc/vsftpd.conf

hyouka@node1:~$ sudo ss -l | grep ftp
tcp   LISTEN 0      32                                              *:ftp                             *:*

hyouka@node1:~$ journalctl | grep vsftpd
oct. 25 12:05:56 node1.tp1.linux sudo[1552]:   hyouka : TTY=pts/0 ; PWD=/home/hyouka ; USER=root ; COMMAND=/usr/bin/apt install vsftpd

hyouka@node1:~$ sudo cat /var/log/vsftpd.log
Mon Oct 25 12:27:10 2021 [pid 2315] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 12:27:19 2021 [pid 2314] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
```
➜ **Upload et Download**

Pour download d'un ftp à sa machine personnelle

```bash 
❯ ftp 192.168.56.102
Connected to 192.168.56.102.
Name (192.168.56.102:hyouka): hyouka
230 Login successful.
ftp> ls
drwxr-xr-x    2 1000     1000         4096 Oct 19 11:33 Desktop
drwxr-xr-x    2 1000     1000         4096 Oct 19 11:33 Documents
drwxr-xr-x    2 1000     1000         4096 Oct 25 12:45 Downloads
drwxr-xr-x    2 1000     1000         4096 Oct 19 11:33 Music
drwxr-xr-x    2 1000     1000         4096 Oct 19 11:33 Pictures
drwxr-xr-x    2 1000     1000         4096 Oct 19 11:33 Public
drwxr-xr-x    2 1000     1000         4096 Oct 19 11:34 Templates
drwxr-xr-x    2 1000     1000         4096 Oct 19 11:33 Videos
ftp> cd Downloads
250 Directory successfully changed.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-rw-r--    1 1000     1000            6 Oct 25 12:45 test.txt
226 Directory send OK.
ftp> get test.txt
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for test.txt (6 bytes).
226 Transfer complete.
6 bytes received in 9,6e-05 seconds (61 kbytes/s)
```
Le test.txt se trouve bien dans mon home

Maintenant on upload de sa machine au serveur ftp (On change les permissions dans la config du vsftpd.config)

```bash 
hyouka@node1:~$ cat /etc/vsftpd.conf
write_enable=YES
```
On a donc la perm d'écrire, via filezilla je vais upload un fichier de mon home à la machine

```bash 
hyouka@node1:~$ sudo cat /var/log/vsftpd.log
Mon Oct 25 12:27:10 2021 [pid 2315] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 12:27:19 2021 [pid 2314] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 12:39:25 2021 [pid 2435] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 12:39:34 2021 [pid 2434] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 12:46:00 2021 [pid 2436] [hyouka] OK DOWNLOAD: Client "::ffff:192.168.56.1", "/home/hyouka/Downloads/test.txt", 6 bytes, 5.20Kbyte/sec
Mon Oct 25 12:48:23 2021 [pid 2450] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 12:48:33 2021 [pid 2449] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 12:52:44 2021 [pid 2507] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 12:52:51 2021 [pid 2506] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 12:59:00 2021 [pid 2524] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 12:59:01 2021 [pid 2523] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 12:59:59 2021 [pid 2527] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 12:59:59 2021 [pid 2526] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 13:45:08 2021 [pid 1447] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 13:45:10 2021 [pid 1446] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 13:45:54 2021 [pid 1456] CONNECT: Client "::ffff:192.168.56.1"
Mon Oct 25 13:45:54 2021 [pid 1455] [hyouka] OK LOGIN: Client "::ffff:192.168.56.1"
Mon Oct 25 13:45:54 2021 [pid 1457] [hyouka] OK UPLOAD: Client "::ffff:192.168.56.1", "/home/hyouka/Downloads/pass.txt", 153 bytes, 471.34Kbyte/sec
```

➜ **Modification de la configuration du serveur**

```bash 
hyouka@node1:~$ sudo nano /etc/vsftpd.conf
hyouka@node1:~$ cat /etc/vsftpd.conf
Example config file /etc/vsftpd.conf
#
# The default compiled in settings are fairly paranoid. This sample file
# loosens things up a bit, to make the ftp daemon more usable.
# Please see vsftpd.conf.5 for all compiled in defaults.
#
# READ THIS: This example file is NOT an exhaustive list of vsftpd options.
# Please read the vsftpd.conf.5 manual page to get a full idea of vsftpd's
# capabilities.
#
#
# Run standalone?  vsftpd can run either from an inetd or as a standalone
# daemon started from an initscript.
listen=NO
listen_port=14023
hyouka@node1:~$ systemctl restart vsftpd.service
```

Quand j'essaye de me co au ftp avec le nouveau port

```bash 
ftp 192.168.56.102 14023
Connected to 192.168.56.102.
220 (vsFTPd 3.0.3)
Name (192.168.56.102:hyouka): hyouka
331 Please specify the password.
Password: 
230 Login successful.
``` 

**Création de votre propre service :**

➜ **Jouer avec netcat**
La VM :
```bash 
hyouka@node1:~$ nc -l 7777
```
Mon pc : 
```bash 
ncat 192.168.56.102 7777
```
Les deux arrivent bien à discuter ensemble
```bash
monpc
lavm
```
La VM stock les messages dans listening.txt

```bash 
La VM :

hyouka@node1:~$ nc -l 7777 >> listening.txt

Ma machine :

ncat 192.168.56.102 7777
```

➜ **Un service basé sur netcat**

```bash 
hyouka@node1:~$ sudo nano /etc/systemd/system/chat_tp2.service  
hyouka@node1:~$ cat /etc/systemd/system/chat_tp2.service
[Unit]
Description=Little chat service (TP2)

[Service]
ExecStart=/usr/bin/nc -l 7777

[Install]
WantedBy=multi-user.target

hyouka@node1:~$ sudo systemctl daemon-reload
hyouka@node1:~$ systemctl start chat_tp2
hyouka@node1:~$ systemctl status chat_tp2
● chat_tp2.service - Little chat service (TP2)
     Loaded: loaded (/etc/systemd/system/chat_tp2.service; disabled; vendor pre>
     Active: active (running) since Mon 2021-10-25 14:16:24 CEST; 2min 41s ago
   Main PID: 2050 (nc)
      Tasks: 1 (limit: 2314)
     Memory: 248.0K
        CPU: 2ms
     CGroup: /system.slice/chat_tp2.service
             └─2050 /usr/bin/nc -l 7777

oct. 25 14:16:24 node1.tp1.linux systemd[1]: Started Little chat service (TP2).
oct. 25 14:16:41 node1.tp1.linux nc[2050]: salut
oct. 25 14:17:13 node1.tp1.linux nc[2050]: hello

hyouka@node1:~$ sudo ss -l | grep 7777
tcp   LISTEN 0      1                                         0.0.0.0:7777                      0.0.0.0:*
```
Tâche finale : 
```bash
hyouka@node1:~$ journalctl -xe -u chat_tp2
-- Journal begins at Tue 2021-10-19 11:33:08 CEST, ends at Mon 2021-10-25 14:17>
oct. 25 14:16:24 node1.tp1.linux systemd[1]: Started Little chat service (TP2).
░░ Subject: A start job for unit chat_tp2.service has finished successfully
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░ 
░░ A start job for unit chat_tp2.service has finished successfully.
░░ 
░░ The job identifier is 2330.
oct. 25 14:16:41 node1.tp1.linux nc[2050]: salut
oct. 25 14:17:13 node1.tp1.linux nc[2050]: hello

hyouka@node1:~$ journalctl -xe -u chat_tp2 -f
-- Journal begins at Tue 2021-10-19 11:33:08 CEST. --
oct. 25 14:16:24 node1.tp1.linux systemd[1]: Started Little chat service (TP2).
░░ Subject: A start job for unit chat_tp2.service has finished successfully
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░ 
░░ A start job for unit chat_tp2.service has finished successfully.
░░ 
░░ The job identifier is 2330.
oct. 25 14:16:41 node1.tp1.linux nc[2050]: salut
oct. 25 14:17:13 node1.tp1.linux nc[2050]: hello
oct. 25 14:20:40 node1.tp1.linux nc[2050]: check
```

Voilà tout marche.
