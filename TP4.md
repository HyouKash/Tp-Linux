# Compte rendu TP4

---

## II. Checklist : 

➜ **Définir une IP à la VM :**

```bash
[hyouka@localhost ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
TYPE=Ethernet
NAME=enp0s8
DEVICE=enp0s8
BOOTPROTO=static
IPADDR=192.168.56.37
NETMASK=255.255.255.0
ONBOOT=yes
[hyouka@localhost ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:81:8d:10 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 85481sec preferred_lft 85481sec
    inet6 fe80::a00:27ff:fe81:8d10/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:8c:d0:9c brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.37/24 brd 192.168.56.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe8c:d09c/64 scope link 
       valid_lft forever preferred_lft forever
```

➜ **Connexion SSH :**

```bash 
[hyouka@localhost ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2021-11-23 11:16:01 CET; 17min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 855 (sshd)
    Tasks: 1 (limit: 11394)
   Memory: 3.9M
   CGroup: /system.slice/sshd.service
           └─855 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cbc,aes128-gcm@openssh.com,aes128-ctr,aes128-cbc -oMACs=hmac-sha2-256-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-12>

Nov 23 11:16:01 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Nov 23 11:16:01 localhost.localdomain sshd[855]: Server listening on 0.0.0.0 port 22.
Nov 23 11:16:01 localhost.localdomain sshd[855]: Server listening on :: port 22.
Nov 23 11:16:01 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
Nov 23 11:27:01 localhost.localdomain sshd[1549]: Accepted password for hyouka from 192.168.56.1 port 54646 ssh2
Nov 23 11:27:01 localhost.localdomain sshd[1549]: pam_unix(sshd:session): session opened for user hyouka by (uid=0)
```

Sur ma machine : 

```bash 
❯ cat id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1ItfC+9vXD8tWJe+4xCDw/6MLN2Md4QQ6j68zDthbyY9GXc/ixSRwcDpawz5jgH+QNkOregj0a2Xl5yvq+Hfi3FMYA2UqyLBKPnnXi/RauT8EMp2q5xFTJmU5jtU7IYy9nZZ0iBzbGlBQJRad4U1BMhr0SgmPF98WYQeYJU50fUL4BDJE54lo8jCknk89H5tYhY84BQP5sTQgwd4V3U/sWwnwu/leR8U/GnvE6obKq8Ei3fxNr7pcKXBFCwceK4YsQoDUp+QOhEJqXHx/TvyGQ6eV2Hoot0UajoPVAIGUtA9DYd6j6KJELCNCWxyBMKluuHoU5YbsJgtDKm+fgTaf88WrNUD9hYfHGvbsTVHpqTuYLjuQFhxkpua6GLAx8wb3RTgRPBjjYSnLW75mReb3iE8BskGKbe7qoX5RnAU5TuQdo2PmFlcrGcmRytKs0YEBIaweT/kXkYnLWeIKFqTdu2dlSIwWy59cHSirVnA9z7KiQLrYvtE9hoLiBPP/6I0= hyouka@revshell

❯ ssh-copy-id -i ~/.ssh/id_rsa.pub hyouka@192.168.56.37
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/hyouka/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
hyouka@192.168.56.37's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'hyouka@192.168.56.37'"
and check to make sure that only the key(s) you wanted were added.

❯ ssh hyouka@192.168.56.37
```

Sur la VM : 

```bash 
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Tue Nov 23 11:27:01 2021 from 192.168.56.1

[hyouka@localhost ~]$ cat .ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1ItfC+9vXD8tWJe+4xCDw/6MLN2Md4QQ6j68zDthbyY9GXc/ixSRwcDpawz5jgH+QNkOregj0a2Xl5yvq+Hfi3FMYA2UqyLBKPnnXi/RauT8EMp2q5xFTJmU5jtU7IYy9nZZ0iBzbGlBQJRad4U1BMhr0SgmPF98WYQeYJU50fUL4BDJE54lo8jCknk89H5tYhY84BQP5sTQgwd4V3U/sWwnwu/leR8U/GnvE6obKq8Ei3fxNr7pcKXBFCwceK4YsQoDUp+QOhEJqXHx/TvyGQ6eV2Hoot0UajoPVAIGUtA9DYd6j6KJELCNCWxyBMKluuHoU5YbsJgtDKm+fgTaf88WrNUD9hYfHGvbsTVHpqTuYLjuQFhxkpua6GLAx8wb3RTgRPBjjYSnLW75mReb3iE8BskGKbe7qoX5RnAU5TuQdo2PmFlcrGcmRytKs0YEBIaweT/kXkYnLWeIKFqTdu2dlSIwWy59cHSirVnA9z7KiQLrYvtE9hoLiBPP/6I0= hyouka@revshell
```

➜ **Accès internet :**

```bash 
[hyouka@localhost ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=63 time=26.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=63 time=23.5 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=63 time=24.3 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 23.458/24.847/26.795/1.424 ms

[hyouka@localhost ~]$ ping google.com
PING google.com (142.250.201.174) 56(84) bytes of data.
64 bytes from par21s23-in-f14.1e100.net (142.250.201.174): icmp_seq=1 ttl=63 time=25.1 ms
64 bytes from par21s23-in-f14.1e100.net (142.250.201.174): icmp_seq=2 ttl=63 time=23.8 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 23.823/24.460/25.098/0.656 ms
```

➜ **Nommage de la machine :**

```bash 
[hyouka@node1 ~]$ cat /etc/hostname
node1.tp4.linux
[hyouka@node1 ~]$ hostname
node1.tp4.linux
```

## III. Mettre en place un service : 

```bash 
[hyouka@node1 ~]$ sudo dnf install nginx
[...]
Complete!

[hyouka@node1 ~]$ sudo systemctl start nginx
[hyouka@node1 ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2021-11-23 11:57:45 CET; 4s ago
  Process: 25624 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 25623 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 25621 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 25626 (nginx)
    Tasks: 2 (limit: 11394)
   Memory: 3.7M
   CGroup: /system.slice/nginx.service
           ├─25626 nginx: master process /usr/sbin/nginx
           └─25627 nginx: worker process

Nov 23 11:57:45 node1.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Nov 23 11:57:45 node1.tp4.linux nginx[25623]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Nov 23 11:57:45 node1.tp4.linux nginx[25623]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Nov 23 11:57:45 node1.tp4.linux systemd[1]: nginx.service: Failed to parse PID from file /run/nginx.pid: Invalid argument
Nov 23 11:57:45 node1.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.
```

Analyse NGINX : 

```bash 
[hyouka@node1 ~]$ ps -aux | grep nginx
root       25626  0.0  0.1 119192  2156 ?        Ss   11:57   0:00 nginx: master process /usr/sbin/nginx
nginx      25627  0.0  0.4 151820  7996 ?        S    11:57   0:00 nginx: worker process
hyouka     25639  0.0  0.0 221928  1088 pts/0    R+   12:00   0:00 grep --color=auto nginx

[hyouka@node1 ~]$ sudo ss -ltnp
State                 Recv-Q                Send-Q                               Local Address:Port                               Peer Address:Port               Process                                                                   
LISTEN                0                     128                                        0.0.0.0:80                                      0.0.0.0:*                   users:(("nginx",pid=25627,fd=8),("nginx",pid=25626,fd=8))                
LISTEN                0                     128                                        0.0.0.0:22                                      0.0.0.0:*                   users:(("sshd",pid=854,fd=5))                                            
LISTEN                0                     128                                           [::]:80                                         [::]:*                   users:(("nginx",pid=25627,fd=9),("nginx",pid=25626,fd=9))                
LISTEN                0                     128                                           [::]:22                                         [::]:*                   users:(("sshd",pid=854,fd=7))

[hyouka@node1 nginx]$ cat nginx.conf
[...]
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;
[...]    

[hyouka@node1 html]$ ls -la /usr/share/nginx/html/
-rw-r--r--. 1 root   root   3332 Jun 10 11:09 404.html
-rw-r--r--. 1 root   root   3404 Jun 10 11:09 50x.html
-rw-r--r--. 1 root   root   3429 Jun 10 11:09 index.html
-rw-r--r--. 1 root   root    368 Jun 10 11:09 nginx-logo.png
-rw-r--r--. 1 root   root   1800 Jun 10 11:09 poweredby.png
```

➜ **Visite du service web :**

```
[hyouka@node1 html]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[hyouka@node1 html]$ sudo firewall-cmd --reload
success

[hyouka@node1 html]$ curl http://192.168.56.37
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
[...]
</html>
```

➜ **Modif de la conf du serveur web :**

Changer le port d'écoute :
```bash 
[hyouka@node1 nginx]$ cat /etc/nginx/nginx.conf
[...]
    server {
        listen       8080 default_server;
        listen       [::]:8080 default_server;
        server_name  _;
        root         /usr/share/nginx/html;
[...]        
[hyouka@node1 nginx]$ systemctl restart nginx
[hyouka@node1 nginx]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2021-11-23 12:37:20 CET; 6min ago
  Process: 25930 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 25928 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 25926 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 25932 (nginx)
    Tasks: 2 (limit: 11394)
   Memory: 3.7M
   CGroup: /system.slice/nginx.service
           ├─25932 nginx: master process /usr/sbin/nginx
           └─25933 nginx: worker process

Nov 23 12:37:20 node1.tp4.linux systemd[1]: nginx.service: Succeeded.
Nov 23 12:37:20 node1.tp4.linux systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Nov 23 12:37:20 node1.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Nov 23 12:37:20 node1.tp4.linux nginx[25928]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Nov 23 12:37:20 node1.tp4.linux nginx[25928]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Nov 23 12:37:20 node1.tp4.linux systemd[1]: nginx.service: Failed to parse PID from file /run/nginx.pid: Invalid argument
Nov 23 12:37:20 node1.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.

[hyouka@node1 nginx]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[hyouka@node1 nginx]$sudo firewall-cmd --remove-port=80/tcp --permanent
success
[hyouka@node1 nginx]$ sudo firewall-cmd --reload
success

[hyouka@node1 nginx]$ sudo ss -ltpn | grep nginx
LISTEN 0      128          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=25933,fd=8),("nginx",pid=25932,fd=8))
LISTEN 0      128             [::]:8080         [::]:*    users:(("nginx",pid=25933,fd=9),("nginx",pid=25932,fd=9))

[hyouka@node1 nginx]$ curl http://192.168.56.37:8080
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
```

Changer l'utilisateur qui lance le service :
