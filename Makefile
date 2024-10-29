build := nixos-rebuild switch --flake path:. --use-remote-sudo
#build := nixos-rebuild switch --upgrade-all --flake path:. --use-remote-sudo
#build := nixos-rebuild switch --upgrade-all --flake path:. --use-remote-sudo --option substituters ""

.PHONY: local surface vm

local:
	rm -f hostname.nix
	ln -s ./hosts/$$(uname -n | cut -d- -f 2)/hostname.nix ./
	$(build) --target-host remilia@localhost
	rm hostname.nix

surface:
	rm -f hostname.nix
	ln -s ./hosts/surface/hostname.nix ./
	$(build) --target-host remilia@172.17.10.4
	rm hostname.nix

vm:
	rm -f hostname.nix
	ln -s ./hosts/vm/hostname.nix ./
	$(build) --target-host remilia@172.17.8.134
	rm hostname.nix
