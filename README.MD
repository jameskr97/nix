![Header](./.github/banner.png)

<hr>

```bash
# check `Makefile` for operations
# clone this repository
git clone https://github.com/jameskr/dotfiles $HOME/.config/nix
# install determinate nix:
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
# activate this repository:
sudo nix run nix-darwin -- switch --flake .#m3max`\

# command with extra-experimental-features 
sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake .#m3max
```