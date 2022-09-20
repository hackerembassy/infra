.PHONY: remake-tf-config 
remake-tf-config:
	nix build .#terraform-config -Lv --offline --out-link ./terraform/config.tf.json

.PHONY: build-local
build:
	sudo nixos-rebuild switch --flake . -L

.PHONY: deploy
deploy/%:
	# $(MAKE) send-secrets/$*
	deploy -s .\#$* --ssh-user root -- -L

.PHONY: send-secrets
send-secrets/%:
	YOLO=YES scripts/send-secrets.sh $*

