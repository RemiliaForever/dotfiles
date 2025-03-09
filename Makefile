online ?= 0

remotes := $(notdir $(wildcard ./hosts/*))
.PHONY: local $(remotes)

command = switch
ifneq ($(online), 1)
	command += --offline
endif
build := nixos-rebuild $(command) --flake path:$(shell pwd)


local:
	sudo $(build)

$(remotes):
	$(build) --use-remote-sudo --target-host $@

renice:
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done
	sleep 5
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done
	sleep 5
	for i in $$(seq 1 32); do sudo renice 20 --pid `ps --no-heading -o tid --user nixbld$$i`; done

update:
	nix flake update
