online ?= 0

remotes := $(notdir $(wildcard ./hosts/*))
.PHONY: local $(remotes)

param = -a -H koumakan-$@ --build-host ryzen path:$(shell pwd)
#ifneq ($(online), 1)
#	param += -- --option substitute false
#endif
param_remote = --target-host $@ -o build/$@ $(param)


local:
	nh os switch $(param)

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
