<div align="center">

# 🌥️ Terracloud

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)

**Automatisation et déploiement d'infrastructure cloud sur Azure**

</div>

---

## 📋 À propos du projet

**Terracloud** est un projet axé sur le déploiement automatisé d'infrastructures cloud sur Microsoft Azure. Ce projet explore les pratiques DevOps et Infrastructure as Code (IaC).

### 🎯 Objectifs

- ⚙️ **Déploiement automatisé** : Mise en place d'une infrastructure Azure complète via Terraform
- 🐳 **Conteneurisation** : Orchestration des services avec Docker
- 🔧 **Configuration Management** : Automatisation des configurations avec Ansible
- 📊 **Analyse comparative** : Étude approfondie entre IaaS et PaaS (Platform as a Service)

### 🔍 Périmètre du projet

#### Infrastructure as a Service (IaaS)
Déploiement d'une infrastructure traditionnelle avec :
- Machines virtuelles Azure
- Réseaux virtuels et sous-réseaux
- Groupes de sécurité réseau
- Load balancers et ressources de stockage

#### Platform as a Service (PaaS)
Mise en œuvre d'une infrastructure plateforme avec :
- Azure Container Instances (ACI)

---

## 🛠️ Technologies utilisées

### Infrastructure as Code
- **Terraform** : Provisioning et gestion de l'infrastructure
- **Azure CLI** : Interactions avec Azure

### Conteneurisation & Orchestration
- **Docker** : Création et gestion des conteneurs
- **Docker Compose** : Orchestration multi-conteneurs

### Configuration Management
- **Ansible** : Automatisation des configurations
- **Ansible Playbooks** : Scripts de déploiement

### Cloud Provider
- **Microsoft Azure** : Plateforme cloud principale

### CI/CD & Automation
- **GitHub Actions** : Pipeline d'intégration et déploiement continu
- **GitHub Workflows** : Automatisation des tests et déploiement

---

## 📚 Documentation

Explorez notre documentation complète pour approfondir chaque aspect du projet :
### 🏛️ Architecture & Design

<table>
<tr>
<td width="100%">

#### 📐 [Architecture Détaillée](./documentation/Infrastructure/Infra.md)
Schémas de l'infrastructure Iaas et Caas

</td>
</table>

### 🚀 Installation du Projet
<table>
<tr>
<td width="100%">

#### 🛠️ [Guide d'Installation](./documentation/developpeur/doc-du-nouvel-arrivant.md)
Procédures pour installer et lancer le projet en local
</td>
</tr>
</table>


### ⚙️ Guides de Déploiement

<table>
<tr>
<td width="33%">

#### 🔷 [Terraform](./docs/terraform/README.md)
- Configuration des providers
- Modules personnalisés
- State management

</td>
<td width="33%">

#### 🐙 [GitHub](./docs/github/README.md)
- GitHub Actions workflows
- Gitflow branching strategy
- CI/CD pipelines

</td>
<td width="33%">

#### 🔧 [Ansible](./docs/ansible/README.md)
- Playbooks
- Inventaires
- Rôles et variables

</td>
</tr>
</table>

### 🔬 Études Comparatives
<table>
<tr>
<td width="100%">

#### ⚖️ [Comparatif IaaS vs PaaS](./documentation/comparatif/Comparatif.md)
Analyse approfondie incluant :
- **Performances** : Benchmarks et métriques
- **Coûts** : TCO et optimisation budgétaire
- **Opérations** : Maintenance et gestion quotidienne
- **Scalabilité** : Capacités d'évolution

</td>
</tr>
</table>

## 📂 Structure du projet

```
T-CLO/
├── 📁 .github/                      # GitHub Configuration
│   └── workflows/                   # GitHub Actions workflows
│       ├── terraform-ci.yml         # Pipeline Terraform
│       ├── docker-build.yml         # Pipeline Docker
│       ├── ansible-deploy.yml       # Pipeline Ansible
│       └── infra-tests.yml          # Tests d'infrastructure
│
├── 📁 ansible/                      # Configuration Management
│   ├── inventory.ini                # Inventaire des hôtes
│   ├── playbook.yml                 # Playbook principal
│   └── roles/                       # Rôles Ansible
│       ├── install-docker/          # Installation Docker
│       ├── deploy-webserver/        # Déploiement serveur web
│       ├── deploy-database/         # Déploiement base de données
│       ├── migration-database/      # Migration DB
│       ├── Create_monitoring/       # Configuration monitoring
│       ├── config-consul-backup/    # Backup Consul
│       └── group_vars/              # Variables globales
│
├── 📁 infra_iaas/                   # Infrastructure IaaS (Terraform)
│   ├── main.tf                      # Configuration principale
│   ├── variables.tf                 # Variables d'entrée
│   ├── outputs.tf                   # Sorties Terraform
│   ├── resources.tf                 # Ressources Azure
│   ├── provider.tf                  # Configuration provider Azure
│   ├── backend.tf                   # Configuration backend state
│   ├── dev.tfvars                   # Variables environnement dev
│   ├── prod.tfvars                  # Variables environnement prod
│   ├── makefile                     # Commandes automatisées
│   ├── modules/                     # Modules Terraform personnalisés
│   │   └── module1/
│   ├── inventory_dev.ini            # Inventaire Ansible dev
│   └── inventory_prod.ini           # Inventaire Ansible prod
│
├── 📁 infra_paas/                   # Infrastructure PaaS (Terraform)
│   ├── main.tf                      # Configuration principale App Service
│   ├── variables.tf                 # Variables d'entrée
│   ├── outputs.tf                   # Sorties Terraform
│   ├── provider.tf                  # Configuration provider Azure
│   ├── backend.tf                   # Configuration backend state
│   ├── dev.tfvars                   # Variables environnement dev
│   └── prod.tfvars                  # Variables environnement prod
│
├── 📁 sample-app-master/            # Application Laravel de démonstration
│   ├── app/                         # Code source Laravel
│   ├── docker-compose.yaml          # Orchestration locale
│   ├── docker-compose-prod.yaml     # Orchestration production
│   ├── Dockerfile                   # Image Docker application
│   ├── database/                    # Migrations et seeders
│   ├── routes/                      # Routes API et Web
│   └── tests/                       # Tests unitaires et feature
│
├── 📁 documentation/                # Documentation complète du projet
│   ├── architecture/                # Documents d'architecture
│   │   ├── Sommaire.md              # Index de la documentation
│   │   ├── IAAC.md                  # Infrastructure IaaS détaillée
│   │   ├── PAAC.md                  # Infrastructure PaaS détaillée
│   │   └── strategie-de-livraison.md # Stratégie CI/CD
│   ├── developpeur/                 # Guides développeurs
│   │   ├── doc-du-nouvel-arrivant.md # Onboarding
│   │   └── gitflow.md               # Workflow Git
│   └── exploitation/                # Documentation ops
│       └── exploitation.md          # Procédures opérationnelles
│
├── 📁 k6-stress-test/               # Tests de charge
│   └── stress_test.js               # Script de test K6
│
├── 📁 scripts/                      # Scripts utilitaires
│   ├── backup-consul.sh             # Backup automatique Consul
│   └── test.sh                      # Scripts de tests
│
├── 📄 docker-compose-consul.yml     # Consul pour service discovery
├── 📄 README.md                     # Documentation principale
└── 📄 README-CONSUL.md              # Documentation Consul
```
---
<div align="center">

**Projet Terracloud - Infrastructure as Code**

</div>