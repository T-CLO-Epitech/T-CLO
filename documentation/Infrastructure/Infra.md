<div align="center">

# 🌥️ Terracloud - Schéma Réseau

**Infrastructure Azure - IaaS & PaaS**

---

</div>

## 📐 Architecture Réseau Caas

![Schéma Réseau Terracloud](../image/Schema_Infra_Iaas.png)

---

## 📋 Informations Infrastructure

| Paramètre            | Valeur         |
|----------------------|----------------|
| **Région Azure 1**   | West Europe    |
| **Région Azure 2**   | France Central |
| **Resource Group**   | rg-terracloud  |
| **Subnet Public**    | -              |
| **Subnet Private 1** | 10.10.0.0 /16  |
| **Subnet Private 2** | 10.20.0.0 /16  |


## 🎨 Légende

 Couleur | Liens                                    |
|---------|------------------------------------------|
| 🔵 Bleu | Liens entre machines et réseaux virtuels |
| 🔴 Rouge | Liens réseau public                      |
| 🟣 Violet | Liens entre deux réseaux privé           |


---

</div>

## 📐 Architecture Réseau IaaS

![Schéma Réseau Terracloud](../image/Schema_Infra_Caas.png)

---

## 📋 Informations Infrastructure

| Paramètre            | Valeur         |
|----------------------|----------------|
| **Région Azure 2**   | France Central |
| **Resource Group**   | rg-terracloud  |
| **Subnet Public**    | -              |
| **Subnet Private 1** | 10.10.0.0 /16  |

---

## 🎨 Légende

 Couleur | Liens                                    |
|---------|------------------------------------------|
| 🔵 Bleu | Liens entre machines et réseaux virtuels |
| 🔴 Rouge | Liens réseau public                      |


---

<div align="center">

**Projet Terracloud - Infrastructure as Code**

</div>