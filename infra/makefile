# Makefile pour Terraform

TF_DIR=.
TF=terraform
PLAN=plan.out

.PHONY: init validate fmt plan apply destroy output console import state workspace

init:
	@$(TF) init -var-file=dev.tfvars -backend-config="path=terraform/dev/$(shell git config user.name)

validate:
	@$(TF) validate -var-file=dev.tfvars

fmt:
	@$(TF) fmt -recursive

plan:
	@$(TF) plan -out=$(PLAN) -var-file=dev.tfvars

apply:
	@$(TF) apply  -var-file=dev.tfvars

destroy:
	@$(TF) destroy -var-file=dev.tfvars

output:
	@$(TF) output

console:
	@$(TF) console

state:
	@$(TF) state list

workspace-list:
	@$(TF) workspace list

workspace-select:
	@$(TF) workspace select $(name)

import:
	@$(TF) import $(resource) $(id)

#
# make init → initialise Terraform

# make validate → valide la config

# make fmt → formate les fichiers

# make plan → génère un plan dans plan.out

# make apply → applique le plan

# make destroy → détruit l’infra

# make output → affiche les outputs

# make state → liste l’état

# make workspace-list → liste les workspaces

# make workspace-select name=dev → change de workspace

# make import resource="aws_instance.my_vm" id="i-1234567890abcdef0"