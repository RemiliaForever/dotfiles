online ?= 0

remotes := ryzen surface deck console vm
.PHONY: local $(remotes)

command = switch
ifneq ($(online), 1)
	command += --offline
endif
build := nice -n 19 nixos-rebuild $(command) --flake path:$(shell pwd)


local:
	rm -f hostname.nix
	ln -s ./hosts/$$(uname -n | cut -d- -f 2)/hostname.nix ./
	sudo $(build)
	rm hostname.nix

$(remotes):
	rm -f hostname.nix
	ln -s ./hosts/$@/hostname.nix ./
	$(build) --use-remote-sudo --target-host $@
	rm hostname.nix

update:
	nix flake update
