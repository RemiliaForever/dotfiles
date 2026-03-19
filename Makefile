remotes := $(notdir $(wildcard ./hosts/*))
.PHONY: local $(remotes)

param = . -a $(args)
param_remote = -H koumakan-$@ --target-host $@ -o build/$@ $(param)

local:
	nh os switch $(param)

wsl:
	sudo nix run .#nixosConfigurations.koumakan-wsl-arm64.config.system.build.tarballBuilder

$(remotes):
	nh os switch $(param_remote)


renice:
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done
	sleep 5
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done
	sleep 5
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done

update:
	nix flake update
