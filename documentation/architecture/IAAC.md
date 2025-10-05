# L'infrastructure

## IAAC

High availability setup

```mermaid
architecture-beta
    group azure(cloud)[azure]

    service db(database)[Database] in azure
    service lb(disk)[Load Balancer] in azure
    service vm1(server)[VM1] in azure
    service vm2(server)[VM2] in azure
    service user(person)[User]
    service consul(consul)[Consul] in azure
    lb:R -- L:vm1
    lb:R -- L:vm2
    vm1:R -- L:db
    vm2:R -- L:db
    user:R -- L:lb
```
## Terraform

***SANS LB***
![alt text](image.png)

# La CI

## IAAC

### Dev

#### ON Pull Request TO Dev
```mermaid
stateDiagram-v2
    direction LR
    [*] --> Lint
    Lint --> Terraform_Apply
    Terraform_Apply --> Ansible
    Ansible --> StressTest
    StressTest --> Terraform_Destroy
    Terraform_Destroy --> [*]
```

Les PR vers "dev" passent une serie de tests


#### ON Pull Request FROM DEV TO MAIN
```mermaid
stateDiagram-v2
    direction LR
    [*] --> docker_test_prod
    docker_test_prod --> [*]
```

Quand on veux merge "dev" vers "main" un test qui lance le docker compose de prod est lancé

### Prod
#### ON Push TO Main
```mermaid
stateDiagram-v2
    direction LR
    [*] --> Build_and_push_to_docker_hub
    Build_and_push_to_docker_hub -->  [*]
```

Une fois que dev est merge dans main, on push l'image de l'application sur Dockerhub afin d'accelerer la mise en production en evitant le build
#### Deploy (auto)
```mermaid
stateDiagram-v2
    direction LR
    [*] --> Terraform_Apply
    Terraform_Apply --> Ansible
    Ansible -->  [*]

```
A la création du TAG, on deploie l'infrastructure de prod
#### Destroy (manual)
```mermaid
    stateDiagram-v2
    direction LR
    [*] --> Terraform_Destroy
    Terraform_Destroy --> [*]
```

Cette action est à executer quand on souhaite detruire la prod 