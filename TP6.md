# Compte rendu TP6

---

# Partie 1 : Préparation de la machine backup.tp6.linux

**I. Ajout de disque :**

```bash 
[hyouka@backup ~]$ lsblk | grep sdb
sdb           8:16   0    8G  0 disk
``` 

**II. Partitioning :**

```bash 
[hyouka@backup ~]$ sudo pvcreate /dev/sdb
[sudo] password for hyouka: 
  Physical volume "/dev/sdb" successfully created.
[hyouka@backup ~]$ sudo pvs | grep sdb
  /dev/sdb      lvm2 ---   8.00g 8.00g
[hyouka@backup ~]$ sudo pvdisplay
  "/dev/sdb" is a new physical volume of "8.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name               
  PV Size               8.00 GiB
  [...]
  PV UUID               agVrp3-9H9D-PWZ4-uTLP-kWKP-Xtq3-kxdtF3
  
[hyouka@backup ~]$ sudo vgcreate backup /dev/sdb
  Volume group "backup" successfully created
[hyouka@backup ~]$ sudo vgs | grep backup
  backup   1   0   0 wz--n- <8.00g <8.00g
[hyouka@backup ~]$ sudo vgdisplay
  --- Volume group ---
  VG Name               backup
  System ID             
  [...]
  VG UUID               4NfyJF-fdVF-dCv2-l373-vELJ-LVM3-QzVjxw
  
[hyouka@backup ~]$ sudo lvcreate -l 100%FREE backup -n l_backup
  Logical volume "l_backup" created.   
[hyouka@backup ~]$ sudo lvs | grep l_backup
  l_backup backup -wi-a-----  <8.00g                                                    
[hyouka@backup ~]$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/backup/l_backup
  LV Name                l_backup
  VG Name                backup
  LV UUID                0wrgQX-u0Zz-Qr9N-FqfP-OpPT-GKJh-BdAq5e
  LV Write Access        read/write
  LV Creation host, time backup.tp6.linux, 2021-11-30 11:16:43 +0100
  LV Status              available
  # open                 0
  LV Size                <8.00 GiB
  Current LE             2047
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2
```

```bash
[hyouka@backup ~]$ sudo mkfs -t ext4 /dev/backup/l_backup
mke2fs 1.45.6 (20-Mar-2020)
Creating filesystem with 2096128 4k blocks and 524288 inodes
Filesystem UUID: a57330e8-4af9-43aa-aeda-42d4658a4a63
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

```bash 
[hyouka@backup /]$ sudo mkdir backup
[hyouka@backup /]$ sudo mount /dev/backup/l_backup /backup/
[hyouka@backup /]$ sudo chown hyouka:hyouka backup/
[hyouka@backup /]$ ls -la | grep backup
drwxr-xr-x.   2 hyouka hyouka 4096 Nov 30 12:00 backup
[hyouka@backup /]$ echo "test" > backup/test.txt
[hyouka@backup /]$ cat /backup/test.txt
test

[hyouka@backup ~]$ sudo vi /etc/fstab
[hyouka@backup ~]$ cat /etc/fstab | grep backup
/dev/backup/l_backup /backup ext4 defaults 0 0
[hyouka@backup ~]$ sudo umount /backup
[hyouka@backup ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /backup does not contain SELinux labels.
       You just mounted an file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/backup                  : successfully mounted
```

# Partie 2 : Setup du serveur NFS sur backup.tp6.linux

```bash 
[hyouka@backup ~]$ mkdir /backup/web.tp6.linux
[hyouka@backup ~]$ mkdir /backup/db.tp6.linux 
[hyouka@backup ~]$ ls -la /backup/
total 12
drwxr-xr-x.  4 hyouka hyouka 4096 Nov 30 12:09 .
dr-xr-xr-x. 18 root   root    238 Nov 30 12:02 ..
drwxrwxr-x.  2 hyouka hyouka 4096 Nov 30 12:09 db.tp6.linux
drwxrwxr-x.  2 hyouka hyouka 4096 Nov 30 12:09 web.tp6.linux
```

```bash 
[hyouka@backup ~]$ sudo dnf install nfs-utils
Last metadata expiration check: 1:13:32 ago on Tue 30 Nov 2021 10:57:05 AM CET.
[...]
Complete!
```

```bash 
[hyouka@backup ~]$ cat /etc/idmapd.conf | grep Domain
Domain = tp6.linux
[hyouka@backup ~]$ cat /etc/exports
/backup/web.tp6.linux 10.5.1.11(rw,no_root_squash)
/backup/db.tp6.linux 10.5.1.12(rw,no_root_squash)
```
L'option rw permet d'exporter en lecture-écriture

L'option no_root_squash spécifie que le root de la machine sur laquelle le répertoire est monté a les droits de root sur le répertoire

```bash 
[hyouka@backup ~]$ sudo systemctl start nfs-server
[hyouka@backup ~]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
[hyouka@backup ~]$ systemctl status nfs-server
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disabled)
  Drop-In: /run/systemd/generator/nfs-server.service.d
           └─order-with-mounts.conf
   Active: active (exited) since Tue 2021-11-30 12:20:06 CET; 21s ago
 Main PID: 3473 (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 11407)
   Memory: 0B
   CGroup: /system.slice/nfs-server.service

Nov 30 12:20:06 backup.tp6.linux systemd[1]: Starting NFS server and services...
Nov 30 12:20:06 backup.tp6.linux systemd[1]: Started NFS server and services.
```

```bash 
[hyouka@backup ~]$ sudo firewall-cmd --add-port=2049/tcp --permanent
success
[hyouka@backup ~]$ sudo firewall-cmd --reload
success
[hyouka@backup ~]$ sudo ss -ltnp | grep 2049
LISTEN 0      64           0.0.0.0:2049       0.0.0.0:*                                                             
LISTEN 0      64              [::]:2049          [::]:*
```

# Partie 3 : Setup des clients NFS : web.tp6.linux et db.tp6.linux

```bash 
[hyouka@web1 ~]$ sudo dnf install nfs-utils
Last metadata expiration check: 1 day, 7:25:47 ago on Fri 26 Nov 2021 09:35:59 AM CET.
[...]
Complete!
```

```bash 
[hyouka@web1 ~]$ sudo mkdir /srv/backup
[hyouka@web1 ~]$ cd /srv/backup/
[hyouka@web1 srv]$ sudo chown hyouka:hyouka /srv/backup/
[hyouka@web1 srv]$ ls -la
total 0
drwxr-xr-x.  3 root   root    20 Nov 27 17:03 .
dr-xr-xr-x. 17 root   root   224 Nov 23 10:55 ..
drwxr-xr-x.  2 hyouka hyouka   6 Nov 27 17:03 backup

[hyouka@web1 srv]$ cat /etc/idmapd.conf | grep Domain
Domain = tp6.linux

[hyouka@web1 srv]$ sudo mount -t nfs 10.5.1.13:/backup/web.tp6.linux /srv/backup
```

```bash 
[tomfox@web1 srv]$ df -h backup
Filesystem                       Size  Used Avail Use% Mounted on
10.5.1.13:/backup/web.tp6.linux  7.9G   36M  7.4G   1% /srv/backup
[hyouka@web1 srv]$ ls -la
total 4
drwxr-xr-x.  3 root   root     20 Nov 27 17:03 .
dr-xr-xr-x. 17 root   root    224 Nov 23 10:55 ..
drwxrwxr-x.  2 hyouka hyouka 4096 Nov 30  2021 backup
```

```bash 
[hyouka@web1 srv]$ sudo umount /srv/backup
[hyouka@web1 srv]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount.nfs: timeout set for Sat Nov 27 17:50:31 2021
mount.nfs: trying text-based options 'vers=4.2,addr=10.5.1.13,clientaddr=10.5.1.11'
/srv/backup              : successfully mounted
[hyouka@web1 srv]$ cat /etc/fstab | grep backup
10.5.1.13:/backup/web.tp6.linux/ /srv/backup nfs defaults 0 0
```

