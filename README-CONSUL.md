# Consule

## Obtenir le tfstate

Pour obtenir le tfstate:
```
curl http://37.59.113.68:8500/v1/kv/terraform/test
```

## Strategie de Backup

Un script est appelé par un cron qui va curl consul et zipper le json(tfstate) toute les X temps.

Pour l'instant cette procedure s'effectue sur la machine deployée sur azure. Mais de le futur prevoir un bucket pour 
ce stockage


