<div align="center">

# 🛠️ Guide d'Installation - Terracloud

**Infrastructure Azure - IaaS & PaaS**

---

</div>
---
Ce guide vous accompagne dans l'installation et la configuration de l'environnement de développement pour le projet Terracloud.


## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir :
- Un compte GitHub avec accès au repository
- Un compte Microsoft Azure (pour les déploiements)
- Droits administrateur sur votre machine
- Git installé sur votre système

---

## 1️⃣ Cloner le Repository

### Cloner le projet

```bash
git clone git@github.com:T-CLO-Epitech/T-CLO.git
```

### Accéder au répertoire du projet

```bash
 cd T-CLO
```

### Configurer Git
Afin que Terraform crée des environnements cohérents, vous devez configurer votre nom d’utilisateur Git dans votre IDE avec le même identifiant que sur GitHub.
Si vous ne le faites pas, l’infrastructure déployée par Terraform risque de ne pas être cohérente avec la CI.
```bash
 git config --global user.name "your-github-username" # ton username github
```
---

## 2️⃣ Installation de Terraform

### Linux (Ubuntu/Debian)

```bash
# Ajouter la clé GPG HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Ajouter le repository HashiCorp
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Mettre à jour et installer Terraform
sudo apt update && sudo apt install terraform
```

### Vérifier l'installation

```bash
 terraform --version
```

---

## 3️⃣ Installation d'Ansible


### Linux (Ubuntu/Debian)

#### Via le gestionnaire de paquets
```bash
 sudo apt update
sudo apt install ansible
```

#### Via pip (version la plus récente)
```bash
 sudo apt install python3-pip
pip3 install ansible
```

### Vérifier l'installation

```bash
 ansible --version
```

---

## 4️⃣ Configuration Supplémentaire

### Azure CLI

### Récuperer les secrets

```sh
 az login

# Set your subscription (replace with your Subscription ID)
az account set --subscription <YOUR_SUBSCRIPTION_ID>

# Create a Service Principal
az ad sp create-for-rbac \
  --name "github-actions-terraform" \
  --role="Contributor" \
  --scopes="/subscriptions/<YOUR_SUBSCRIPTION_ID>" \
  --sdk-auth
```
L'output de cette commande devra être ajouter dans les secret github au chapitre suivant.
exemple de l'output:
```
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "your-client-secret-here",
  "subscriptionId": "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy",
  "tenantId": "zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```
## Ajouter les secret pour la CI

Rendez vous dans les secret du repository, et ajouter les variables suivantes:

AZURE_CREDENTIALS # l'output du chapitre précédent
CI_SSH_KEY #La clef ssh de dev (format RSA) stockée dans infiscale
CI_SSH_KEY_PROD # La clef ssh de production (format RSA) stockée dans infiscale


## 5️⃣ Vérification de l'Installation

Exécutez les commandes suivantes pour vérifier que tout est correctement installé :

```bash
# Vérifier Git
git --version

# Vérifier Terraform
terraform --version

# Vérifier Ansible
ansible --version

# Vérifier Azure CLI
az --version

# Vérifier Docker (optionnel)
docker --version
```

---

## 6️⃣ Premiers Pas avec le Projet

### Initialiser Terraform

```bash
cd infra_iaas
terraform init 
```

### Valider la configuration Terraform

```bash
terraform validate
```

---
<div align="center">

**Projet Terracloud - Infrastructure as Code**

</div>