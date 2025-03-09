online ?= 0

remotes := $(notdir $(wildcard ./hosts/*))
.PHONY: local $(remotes)

command = switch
ifneq ($(online), 1)
	command += --offline
endif
build := nice -n 19 nixos-rebuild $(command) --flake path:$(shell pwd)


local:
	sudo $(build)

$(remotes):
	$(build) --use-remote-sudo --target-host $@

update:
	nix flake update
