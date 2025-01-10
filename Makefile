COMMAND := switch --show-trace
build := nice -n 19 nixos-rebuild $(COMMAND) --flake path:$(shell pwd)

.PHONY: local surface vm

local:
	rm -f hostname.nix
	ln -s ./hosts/$$(uname -n | cut -d- -f 2)/hostname.nix ./
	sudo $(build)
	rm hostname.nix

surface:
	rm -f hostname.nix
	ln -s ./hosts/surface/hostname.nix ./
	$(build) --use-remote-sudo --target-host remilia@172.17.10.4
	rm hostname.nix

deck:
	rm -f hostname.nix
	ln -s ./hosts/deck/hostname.nix ./
	$(build) --use-remote-sudo --target-host remilia@172.17.10.6
	rm hostname.nix

vm:
	rm -f hostname.nix
	ln -s ./hosts/vm/hostname.nix ./
	$(build) --use-remote-sudo --target-host remilia@172.17.8.134
	rm hostname.nix


update:
	nix flake update
