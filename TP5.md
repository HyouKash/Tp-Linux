# Compte rendu TP5

---

## Setup DB : 

➜ **1. Install MariaDB :**

Install
```
[hyouka@db ~]$ sudo dnf install mariadb-server
[...]
Complete!
[hyouka@db ~]$ sudo systemctl start mariadb
[hyouka@db ~]$ systemctl status mariadb
● mariadb.service - MariaDB 10.3 database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-11-25 10:59:37 CET; 7s ago
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
  Process: 4956 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
  Process: 4886 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
  Process: 4862 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
 Main PID: 4924 (mysqld)
   Status: "Taking your SQL requests now..."
    Tasks: 30 (limit: 11407)
   Memory: 67.4M
   CGroup: /system.slice/mariadb.service
           └─4924 /usr/libexec/mysqld --basedir=/usr

Nov 25 10:59:37 db.tp5.linux systemd[1]: Starting MariaDB 10.3 database server...
Nov 25 10:59:37 db.tp5.linux mysql-prepare-db-dir[4886]: Database MariaDB is probably initialized in /var/lib/mysql already, nothing is done.
Nov 25 10:59:37 db.tp5.linux mysql-prepare-db-dir[4886]: If this is not the case, make sure the /var/lib/mysql is empty before running mysql-prepare-db-dir.
Nov 25 10:59:37 db.tp5.linux mysqld[4924]: 2021-11-25 10:59:37 0 [Note] /usr/libexec/mysqld (mysqld 10.3.28-MariaDB) starting as process 4924 ...
Nov 25 10:59:37 db.tp5.linux systemd[1]: Started MariaDB 10.3 database server.
```
Le service

```bash 
[hyouka@db ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.

[hyouka@db ~]$ sudo ss -ltnp | grep mysql
LISTEN 0      80                 *:3306            *:*    users:(("mysqld",pid=4924,fd=21))

[hyouka@db ~]$ ps -aux  | grep mysql
mysql       4924  0.0  4.7 1296832 88752 ?       Ssl  10:59   0:00 /usr/libexec/mysqld --basedir=/usr
```

Firewall

```bash 
[hyouka@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[hyouka@db ~]$ sudo firewall-cmd --reload
success
```

➜ **2. Conf MariaDB :**

```bash 
[hyouka@db ~]$ mysql_secure_installation
[...]
Enter current password for root (enter for none): 
OK, successfully used password, moving on...
```
1. Nous faisons entrer n'ayant aucun mot de passe associé à root.
```
Set root password? [Y/n] Y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!
 ```
2. Nous mettons un mot de passe à root (solide pour la sécurité).
 ```
Remove anonymous users? [Y/n] Y
 ... Success!
```
3. On enlève l'utilisateur anonymous, afin que personne autre que nous ne puissent y accéder.
```
Disallow root login remotely? [Y/n] Y
 ... Success!
```
4. On la désactive pour que personne n'essaye de se connecter à root à distance, et puisse forcebrute la db.
```
Remove test database and access to it? [Y/n] Y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!
```
5. On l'enlève, elle ne nous sert à rien.
```
Reload privilege tables now? [Y/n] Y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```
6. Pour finir, on accepte que nos changements sur les tables prennent directement effet.

➜ **Préparation de la base en vue de l'utilisation par NextCloud :**

```
[hyouka@db ~]$ sudo mysql -u root -p 
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 20
Server version: 10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'nextcloud'@'10.5.1.11' IDENTIFIED BY '***';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.5.1.11';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.001 sec)
```

➜ **3. Test :**

```bash
[hyouka@web ~]$ dnf provides mysql
Rocky Linux 8 - AppStream                                                                                                                                                                                   5.5 MB/s | 8.2 MB     00:01    
Rocky Linux 8 - BaseOS                                                                                                                                                                                      4.6 MB/s | 3.5 MB     00:00    
Rocky Linux 8 - Extras                                                                                                                                                                                       20 kB/s |  10 kB     00:00    
mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64 : MySQL client programs and shared libraries
Repo        : appstream
Matched from:
Provide    : mysql = 8.0.26-1.module+el8.4.0+652+6de068a7

[hyouka@web ~]$ sudo dnf install mysql
[...]
Complete!
```

Tester la connexion : 

```bash 
[hyouka@web ~]$ mysql -h 10.5.1.12 -P 3306 -u nextcloud -p -D nextcloud
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.5.5-10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW TABLES;
Empty set (0.00 sec)
```

## II. Setup Web : 

```
[hyouka@web ~]$ sudo dnf install httpd
[...]
Complete!
```
```
[hyouka@web ~]$ sudo systemctl start httpd
[hyouka@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-11-25 12:18:13 CET; 3s ago
     Docs: man:httpd.service(8)
 Main PID: 2486 (httpd)
   Status: "Started, listening on: port 80"
    Tasks: 213 (limit: 11407)
   Memory: 24.8M
   CGroup: /system.slice/httpd.service
           ├─2486 /usr/sbin/httpd -DFOREGROUND
           ├─2487 /usr/sbin/httpd -DFOREGROUND
           ├─2488 /usr/sbin/httpd -DFOREGROUND
           ├─2489 /usr/sbin/httpd -DFOREGROUND
           └─2490 /usr/sbin/httpd -DFOREGROUND

Nov 25 12:18:13 web.tp5.linux systemd[1]: Starting The Apache HTTP Server...
Nov 25 12:18:13 web.tp5.linux systemd[1]: Started The Apache HTTP Server.
Nov 25 12:18:14 web.tp5.linux httpd[2486]: Server configured, listening on: port 80

[hyouka@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.

[hyouka@web ~]$ ps -aux | grep httpd
root        2486  0.0  0.5 280220 11112 ?        Ss   12:18   0:00 /usr/sbin/httpd -DFOREGROUND
apache      2487  0.0  0.4 294104  8280 ?        S    12:18   0:00 /usr/sbin/httpd -DFOREGROUND
apache      2488  0.0  0.7 1483020 14060 ?       Sl   12:18   0:00 /usr/sbin/httpd -DFOREGROUND
apache      2489  0.0  0.6 1351892 12012 ?       Sl   12:18   0:00 /usr/sbin/httpd -DFOREGROUND
apache      2490  0.0  0.6 1351892 12012 ?       Sl   12:18   0:00 /usr/sbin/httpd -DFOREGROUND

[hyouka@web ~]$ sudo ss -ltnp | grep httpd
LISTEN 0      128                *:80              *:*    users:(("httpd",pid=2490,fd=4),("httpd",pid=2489,fd=4),("httpd",pid=2488,fd=4),("httpd",pid=2486,fd=4))
```
L'utilisareur est Apache.

Un premier test : 

```bash 
[hyouka@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[hyouka@web ~]$ sudo firewall-cmd --reload
success

❯ curl 10.5.1.12
<!doctype html>
<html>
[...]
```
(La version web marche aussi)

**B. PHP :**

```bash 
[hyouka@web ~]$ sudo dnf install epel-release
[...]
Complete!

[hyouka@web ~]$ sudo dnf update
[...]
Complete!

[hyouka@web ~]$ sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm                                                                 
[...]
Complete!

[hyouka@web ~]$ sudo dnf module enable php:remi-7.4
[...]
Complete!

[hyouka@web ~]$ sudo dnf install zip unzip libxml2 openssl php74-php php74-php-ctype php74-php-curl php74-php-gd php74-php-iconv php74-php-json php74-php-libxml php74-php-mbstring php74-php-openssl php74-php-posix php74-php-session php74-php-xml php74-php-zip php74-php-zlib php74-php-pdo php74-php-mysqlnd php74-php-intl php74-php-bcmath php74-php-gmp                         
[...]
Complete!
```

➜ **2. Conf Apache :**

```bash 
[hyouka@dweb ~]$ cat /etc/httpd/conf/httpd.conf | grep conf.d
# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
```

**Créer un VirtualHost qui accueillera NextCloud :**

```bash
[hyouka@web conf.d]$ cat website.conf 
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/html/  

  ServerName  web.tp5.linux  

  <Directory /var/www/nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>

[hyouka@web conf.d]$ sudo systemctl restart httpd
```

Configurer la racine web : 

```bash 
[hyouka@web ~]$ sudo mkdir -p /var/www/nextcloud/html
[hyouka@web ~]$ cd /var/www
[hyouka@web www]$ sudo chown -R apache:apache nextcloud/
[hyouka@web www]$ ls -la
[...]
drwxr-xr-x.  3 apache apache   18 Nov 25 22:34 nextcloud
```

Configurer PHP : 

```bash 
[hyouka@web www]$ cat /etc/opt/remi/php74/php.ini | grep Paris
date.timezone = "Europe/Paris"
```

**3. Install NextCloud :**

```bash 
[hyouka@web www]$ cd
[hyouka@web ~]$ curl -SLO https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  148M  100  148M    0     0  3408k      0  0:00:44  0:00:44 --:--:-- 3823k
[hyouka@web ~]$ ls
nextcloud-21.0.1.zip
```

Ranger la chambre : 

```bash 
[hyouka@web ~]$ unzip nextcloud-21.0.1.zip
[hyouka@web ~]$ ls
nextcloud  nextcloud-21.0.1.zip
[hyouka@web ~]$ sudo mv nextcloud/* /var/www/nextcloud/html/
[sudo] password for hyouka: 
[hyouka@web html]$ sudo chown -R apache:apache var/www/nextcloud
[hyouka@web nextcloud]$ sudo systemctl restart httpd
```

**4. Test :**

```bash 
❯ cat /etc/hosts | grep web
10.5.1.11 web.tp5.linux
```

Tester l'accès à NextCloud et finaliser son install' : 

Site qui fonctionne : 

![](https://i.imgur.com/I1BCvnk.png)


Db qui marche bien :

```
[hyouka@web ~]$ mysql -h 10.5.1.12 -P 3306 -u nextcloud -p -D nextcloud
Enter password: 

[...]

mysql> SHOW TABLES;
+-----------------------------+
| Tables_in_nextcloud         |
+-----------------------------+
| oc_accounts                 |
| oc_accounts_data            |
| oc_activity                 |
| oc_activity_mq              |
| oc_addressbookchanges       |
| oc_addressbooks             |
[...]
77 rows in set (0.00 sec)
```

## Bonus : 

HTTPS : 

```
[hyouka@web ~]$ sudo openssl req -new -x509 -days 365 -nodes -out /etc/ssl/certs/webserver.crt -keyout /etc/ssl/private/webserver.key
Generating a RSA private key
.+++++
............+++++
writing new private key to '/etc/ssl/private/mailserver.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:FR
State or Province Name (full name) []:Aquitaine
Locality Name (eg, city) [Default City]:Bordeaux
Organization Name (eg, company) [Default Company Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:web.tp5.linux
Email Address []:HyouKaV1@protonmail.com

[hyouka@web ~]$ sudo chmod 440 /etc/ssl/private/webserver.key

[hyouka@web ~]$ cat /etc/httpd/conf.d/website.conf
<VirtualHost *:443>
  DocumentRoot /var/www/nextcloud/html/  
  SSLEngine on
  SSLCertificateFile /etc/ssl/certs/webserver.crt
  SSLCertificateKeyFile /etc/ssl/private/webserver.key
  ServerName  web.tp5.linux  

  <Directory /var/www/nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>

[hyouka@web ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[hyouka@web ~]$ sudo firewall-cmd --reload
success
[hyouka@web ~]$ sudo systemctl restart httpd
```

![](https://i.imgur.com/WBER5nO.png)


Maintenant on s'occupe de la redirection, voici à quoi ressemble la conf : 

```
[hyouka@web ~]$ cat /etc/httpd/conf.d/website.conf
<VirtualHost *:80>
  Redirect permanent / https://web.tp5.linux/
</VirtualHost>

<VirtualHost *:443>
  DocumentRoot /var/www/nextcloud/html/  
  SSLEngine on
  SSLCertificateFile /etc/ssl/certs/webserver.crt
  SSLCertificateKeyFile /etc/ssl/private/webserver.key
  ServerName  web.tp5.linux  

  <Directory /var/www/nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

Reverse Proxy : 

Le deuxième serveur web a bien accès à la db (même procédure que précedemment).

On configure le reverse proxy (nginx) : 

```bash 
[hyouka@rp conf.d]$ cat reverseproxy.conf
upstream backend_servers {
    ip_hash;
    server web1.tp5.linux;
    server web2.tp5.linux;
}

server {
    listen 80;
    server_name web.tp5.linux;
    location / {
                proxy_pass https://backend_servers/;
                proxy_set_header HOST $host;
        }
}
```

Avec ses 2 hosts : 

```bash 
[hyouka@rp conf.d]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.5.1.11   web1.tp5.linux
10.5.1.13   web2.tp5.linux
```

Le rp redirige vers l'un ou l'autre.
