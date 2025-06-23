online ?= 0

remotes := $(notdir $(wildcard ./hosts/*))
.PHONY: local $(remotes)

param =
ifneq ($(online), 1)
	param += --option substitute false
endif
param += --flake path:$(shell pwd)
param_remote = $(param) --use-remote-sudo --target-host $@


local:
	sudo nixos-rebuild switch $(param)

$(remotes):
	nixos-rebuild switch $(param_remote)

renice:
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done
	sleep 5
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done
	sleep 5
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done

update:
	nix flake update
