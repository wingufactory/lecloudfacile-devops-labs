
# **Automatisation AWS avec Terraform et Ansible**  

Ce lab montre comment utiliser **Terraform** pour provisionner des ressources AWS, puis **Ansible** pour configurer une instance EC2 nouvellement créée. Nous utiliserons également **AWS CLI** pour configurer l'accès et vérifier l'état des ressources.

---

## **1. Pré-requis**  

Avant de commencer, assurez-vous d’avoir :  
✔️ Un compte AWS actif  
✔️ **AWS CLI** installé et configuré  
✔️ **Terraform** installé  
✔️ **Ansible** installé  
✔️ Une **clé SSH** pour accéder à l’instance EC2  

---

## **2. Étapes du déploiement**  

### **1️⃣ Nettoyage de l’état Terraform (si nécessaire)**  
```bash
rm .terraform/terraform.tfstate # au cas où un état Terraform existerait déjà
```
Si un état Terraform existe, nous le supprimons pour éviter des conflits avec une précédente exécution.

---

### **2️⃣ Configuration d'AWS CLI**  
```bash
aws configure
```
➡️ Cette commande permet de configurer l’accès à AWS en définissant :  
- `AWS Access Key ID`  
- `AWS Secret Access Key`  
- `Default region name`  
- `Default output format`  

Cela est nécessaire pour que **Terraform et Ansible** puissent interagir avec AWS.

---

### **3️⃣ Vérification des instances EC2 existantes**  
```bash
aws ec2 describe-instances --filters Name=instance-state-name
aws ec2 describe-instances --filters Name=instance-state-name,Values=running
```
➡️ Ces commandes permettent de **lister les instances EC2** et de vérifier si des machines sont déjà en cours d’exécution.

---

### **4️⃣ Création d’un bucket S3 pour stocker le backend Terraform**  
```bash
aws s3api create-bucket --bucket terraformstatebucketsy2424
aws s3api list-buckets
```
➡️ Terraform utilise un **backend distant** pour stocker l’état de l’infrastructure.  
Nous créons ici un **bucket S3** qui servira à stocker cet état, évitant ainsi toute perte de données.

---

### **5️⃣ Initialisation de Terraform**  
```bash
terraform init
```
➡️ Cette commande :  
- Télécharge les **providers** spécifiés dans `providers.tf`.  
- Configure le **backend distant** défini dans `backend.tf`.  

---

### **6️⃣ Planification du déploiement**  
```bash
terraform plan
```
➡️ Cette commande affiche un **aperçu des modifications** que Terraform va appliquer.  
Elle permet de **vérifier** la configuration avant le déploiement.

---

### **7️⃣ Application du déploiement Terraform**  
```bash
terraform apply
```
➡️ Terraform **provisionne les ressources AWS** définies dans les fichiers :  
- `instances.tf` : création des instances EC2  
- `networks.tf` : création du VPC, sous-réseaux et passerelles  
- `security_groups.tf` : définition des règles de pare-feu  
- `alb.tf` : configuration du load balancer  

🚀 **Une fois terminé, Terraform affiche les sorties définies dans `output.tf`**, notamment l'IP de la VM créé et l'url du LoadBalancer.

---

### **8️⃣ Configuration de l’instance avec Ansible**  
```bash
ansible -a "cat /var/lib/jenkins/secrets/initialAdminPassword" tag_Name_jenkins_master_tf -u ec2-user -b
```
➡️ Cette commande utilise **Ansible** pour récupérer le mot de passe initial de Jenkins sur l’instance EC2 en exécutant la commande `cat` à distance.

📌 **Explication des paramètres** :  
- `-a "cat /var/lib/jenkins/secrets/initialAdminPassword"` : Exécute la commande sur l’instance.  
- `tag_Name_jenkins_master_tf` : Désigne l’instance ciblée par **son tag AWS**.  
- `-u ec2-user` : Utilise l’utilisateur `ec2-user` pour la connexion.  
- `-b` : Exécute la commande avec **sudo** (become).  

---

### **9️⃣ Connexion à l’instance EC2 via SSH**  
```bash
ssh -i ~/.ssh/id_jdc ec2-user@JenkinsPublicIP
```
➡️ **Connexion manuelle** à l’instance **via SSH** pour effectuer des vérifications.  
- `~/.ssh/id_jdc` : Chemin de la **clé privée SSH**.  
- `JenkinsPublicIP` : Adresse IP publique de l’instance (fournie par Terraform).  

---

### **🔟 Suppression de l’infrastructure AWS**  
```bash
terraform destroy --auto-approve
```
➡️ Cette commande **supprime toutes les ressources** créées par Terraform, évitant des coûts inutiles.  

📌 **L’option `--auto-approve` permet de bypasser la confirmation manuelle**.  

---

## **3. Structure du dépôt Git**  

Le répertoire contient les fichiers suivants :  

```
terraform-ansible-aws/
├── alb.tf                 # Configuration du Load Balancer AWS
├── ansible.cfg            # Configuration Ansible
├── ansible_templates      # Répertoire contenant les fichiers Ansible
│   ├── inventory_aws/     # Inventaire dynamique des ressources AWS
│   │   └── tf_aws_ec2.yml # Inventaire AWS pour Ansible
│   └── jenkins-master-sample.yml # Playbook pour configurer Jenkins
├── backend.tf             # Définition du backend distant Terraform (S3)
├── instances.tf           # Définition des instances EC2
├── networks.tf            # Configuration du réseau AWS (VPC, Subnet)
├── output.tf              # Variables de sortie (IP publiques, DNS, etc.)
├── providers.tf           # Déclaration des providers (AWS)
├── readme.md              # Ce fichier
├── security_groups.tf     # Configuration des règles de sécurité (SG)
└── variables.tf           # Déclaration des variables Terraform
```

---

## **4. Conclusion**  

Ce lab permet de **découvrir comment combiner AWS CLI, Terraform et Ansible** pour :  
✅ **Provisionner des ressources AWS avec Terraform**  
✅ **Configurer automatiquement l’infrastructure avec Ansible**  
✅ **Automatiser les connexions et la gestion des accès**  
✅ **Détruire proprement les ressources une fois le test terminé**  

🚀 **Prêt à tester ? Exécutez ces commandes et observez l’automatisation en action !**