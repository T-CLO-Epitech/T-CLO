<div align="center">

# ⚖️ Comparatif IaaS vs PaaS - Terracloud

**Infrastructure Azure - IaaS & PaaS**

---

</div>
---
## 💰 Analyse des Coûts

### Architecture IaaS
3 VM B1s (1 Core, 1GB RAM, 4GB storage)
1 LB

| Durée  | On demand | Saving Plan | Reservation |
|--------|-----------|-------------|-------------|
| 1 an    | 273 € | 184 € | 159 €|
| 3 ans   | 818 € | 370 € | 309 € |


### Architecture PaaS
1 Azure container apps (2 Core, 4GB RAM, 5GB storage)

| Durée | On demand | Saving Plan | Nombre de requêtes |
|-------|-----------|-------------|--------------------|
| 1 an  | 486 €     | 474 €       | 100 Millions       |
| 1 an  | 2 688 €   | 2 376 €     | 500 Millions       |
| 3 ans | 1 459 €   | 1 422 €     | 100 Millions       |
| 3 ans | 8 064 €   | 7 128 €     | 500 Millions       |


Lien du simulateur: https://azure.microsoft.com/en-us/pricing/calculator/


#### Coût de maintenance
- Mettre a jour l'os
- Mettre à jour les packages de l'application
- Support en cas de panne
- Suvis des CVE
 ####
- Un developpeur freelance 3 jour par mois.
- Un forfait deux semaines par an en cas de panne majeur.

- 500€/jour * 3 * 12 = 16500 €
- 500€/jour * 5 = 2500 €

#### Coût total IaaS

| Durée   | minimum  | maximum  | 
|---------|----------|----------|
| 1 an    | 19 159 € | 19 273 € |
| 3 ans   | 57 309 € | 57 818 € |

#### Coût total PaaS

| Durée   | minimum  | maximum  | 
|---------|----------|----------|
| 1 an    | 16 986 € | 19 188 € |
| 3 ans   | 17 959 € | 24 564 € |




---
## ✅ Avantages et Inconvénients


### IaaS

| Avantages                                                   | Inconvénients |
|-------------------------------------------------------------|---------------|
| Contrôle total sur l'OS et la configuration                 | Maintenance lourde (OS, sécurité, mises à jour)|
| Flexibilité maximale pour configurations custom             |Temps de déploiement long (15-20 min) |
| Portabilité facilitée (migration vers autres clouds)        |Coûts de maintenance élevés (~23 000 €/an) |
| Coût infrastructure faible à faible trafic (159-309 €)      |Scaling lent (3-5 minutes) |
| Adapté aux applications legacy nécessitant un OS spécifique |Sur-provisionnement nécessaire pour absorber les pics |
| Prédictibilité des coûts (coûts fixes mensuels)             |Gestion manuelle du monitoring et de l'auto-healing |
|                                                             |Expertise infrastructure requise |
||Responsabilité sécurité plus importante (patches, CVE)|


### PaaS

| Avantages | Inconvénients |
|-----------|---------------|
| Déploiement ultra-rapide (2-3 minutes)| Coût plus élevé à fort trafic (>500M requêtes)|
|Pas de maintenance infrastructure | Moins de contrôle sur l'infrastructure sous-jacente|
|Auto-scaling automatique et rapide (< 30 sec) |Vendor lock-in (dépendance à Azure) |
|Pay-per-use précis (optimisation coûts)|Complexité de migration vers autre cloud|
|Sécurité managée (patches automatiques)|Limitations sur certaines configurations avancées|
|Haute disponibilité native|Debugging limité au niveau conteneur|
|Monitoring et logging intégrés||


---
<div align="center">

**Projet Terracloud - Infrastructure as Code**

</div>