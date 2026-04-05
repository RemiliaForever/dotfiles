HOST ?= $@

remotes := $(notdir $(wildcard ./hosts/*))
.PHONY: local $(remotes)

param = . -a $(args)
param_remote = -H koumakan-$@ --target-host $(HOST) -o build/$@ $(param)

local:
	nh os switch $(param)

wsl:
	sudo nix run .#nixosConfigurations.koumakan-wsl-arm64.config.system.build.tarballBuilder

$(remotes):
	nh os switch $(param_remote)


renice:
	for r in $$(seq 1 3); do \
		for j in $$(seq 1 32); do \
			pids=$$(ps -u nixbld$$j -o pid=); \
			if [ -n "$$pids" ]; then \
				echo "Renicing nixbld$$j: $$pids"; \
				sudo renice -n 19 -p $$pids || true; \
			fi; \
		done; \
		sleep 5; \
	done

update:
	nix flake update
