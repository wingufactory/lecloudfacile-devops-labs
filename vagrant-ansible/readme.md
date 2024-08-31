## Prépration de l'environnement de travail

* Pour faire ce tutoriel il faut au minimum un pc avec 4 giga de ram voir plus.

* Pour dérouler tous les labs de cette formation il faudra au préalable provisionner les machines en suivant ce tutoriel.

* Ce tutoriel va provisionner des machines dans virtualbox en utilisant le langage infra as code vagrant.

* Ci-dessous la liste des machines avec leurs @ip  qui seront provisionnées:

```yaml
* Liste des serveurs et leurs @ip
ansible: 192.168.10.1
target:  192.168.10.2
```

## Installation des outils


* Télécharger et installer virtualbox: [ICI](https://www.virtualbox.org/wiki/Downloads)

* Télécharger et installer Vagrant: [ICI](https://www.vagrantup.com/downloads.html)

* Télécharger et installer git: [ICI](https://git-scm.com/downloads)

* Créer un répertoire de travail dans votre Bureau exemple: Labs_Ansible


## Provision des machines

* Lancer la commande pour provisionner les machines

```yaml
$ vagrant up
```

## Actions sur le serveur ansible

* Connecter via ssh au serveur ansible

```yaml
$ vagrant ssh ansible
```

* Générer la clé privé et la clé publique, ne pas mettre de mot de passe, cliquer sur entrer

```yaml
$ sudo su - ansible
$ ssh-keygen
```

* Exemple

```yaml
ansible@ansible:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ansible/.ssh/id_rsa):
Created directory '/home/ansible/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ansible/.ssh/id_rsa.
Your public key has been saved in /home/ansible/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:xa1DmIcVujuyJJCiSC4zajyb9O+fpL4m93IE/zy6qbQ ansible@ansible
The key's randomart image is:
+---[RSA 2048]----+
|          o.     |
|         B .     |
|        = = .    |
|   . .   = .     |
|..o   o S o      |
|=. .   o . .     |
|Bo  ..+.=        |
|+*o..*++o=       |
|ooo.BEOBo .      |
+----[SHA256]-----+
```

* Récupérer le contenu de la clé publique, la clé sera par la suite copier sur les serveurs cibles

```yaml
$ cat .ssh/id_rsa.pub
```

* Exemple

```yaml
ansible@ansible:~$ cat .ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3SaX41+Oydn/eXDguEow1FuA1HBTCFnd7gWK//osQHxC2q7hwOAg39Re1jePZx2UCIpHHzKZeDAHCJnojM2NEYkYcEDzuGSdmNj0aKGRhMldKh60ekQLUOfnx/PV9PGfoEVx+45tObZnVVovIiOFUSm9xQcpB1yJ246MpHmqGLUFvcBfq7kjFtYc3nyoFJuheuG75YE0jeXgPy4a6/uyH5HHGQ36rge8wC3Ae3El4s5Duy3d38SzwFq8e9oTAU3cF+aZcLXh2/fO78Hmlx+7lp1LtK9JURBMDMTEwcP/63qMF+EcPoEdwW1mjx/3IKoPYGGZCE4gEYOux8xkiUvg7 ansible@ansible
```

## Actions sur les serveurs cibles: target

*  Se positionner dans le répertoire formation-ansible/Lab1-preparation-envs, clique droit, ensuite cliquer sur «Git bash here»

*  Se connecter au serveur  <server-cible>: target  ( remplacer <server-cible> par target pour configurer le serveur target )

```yaml
$ vagrant ssh <server-cible>
$ sudo su - ansible
```

* Copier le contenu de la clé publique récupéré à partir de serveur ansible dans /home/ansible/.ssh/authorized_keys, puis sauvegarder le fichier.

```yaml
$ vi  .ssh/authorized_keys

```

## Test de connexion à partir de serveur ansible

* Tester la connexion vers le serveur <server-cible> ( exemple ici pour target <server_cible_ip>: 192.168.10.2 )

```yaml
$ ssh -i .ssh/id_rsa ansible@<server_cible_ip>
```

* Exemple

```yaml
ansible@ansible:~$ ssh -i .ssh/id_rsa ansible@192.168.10.2
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-69-generic x86_64)
...
Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

ansible@target:~$
ansible@target:~$ exit
```

* Créer un fichier hosts et copier le contenu ci-dessous dans le fichier hosts puis sauvegarder (!!! cette action à faire une seule fois !!!)


```yaml
$ vi hosts
```

```yaml
## à copier dans le fichier hosts
[target]
myhost ansible_host=192.168.10.2

```

* Tester le ping ansible vers le serveur cible, ( ici remplacer <server_cible> par target )

```yaml
$ ansible -i hosts <server_cible> -m ping
```

* Exemple
```yaml
ansible@ansible:~$ ansible -i hosts target -m ping
web | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

