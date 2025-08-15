update:
	git fetch

update-force:
	git fetch --all
	git reset --hard origin/main

rebuild:
	sudo nix run nix-darwin -- switch --flake .#m3max