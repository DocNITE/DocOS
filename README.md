<div align="center">

## DocOS - Yet Another Pseudo DotFiles

This is simple project, based on [ZaneyOS](https://zaney.org/zaneyos/).

</div>

> **This project has a [Wiki](https://zaney.org/zaneyos/) from original repo! Please read it to find out information on subjects that you may need to learn more about!**

### ⬇️ Install

Run this command to ensure Git & Vim are installed:

```
nix-shell -p git vim
```

Clone this repo & enter it:

```
git clone https://gitlab.com/DocNITE/doc-os.git docos
cd docos
```

- *You should stay in this folder for the rest of the install*

**🪧🪧🪧 Edit options.nix 🪧🪧🪧**

Generate your hardware.nix like so:

```
nixos-generate-config --show-hardware-config > hardware.nix
```

Run this to enable flakes and install the flake replacing hostname with whatever you put in the options.nix file:

```
NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#hostname
```

This Flake's user will have the password be set for them as *password*. If you want to change it run a command replacing password with whatever you want to be your password. You then need to copy the output that it gives you like below into your hashedPassword in the system.nix file.

```
  mkpasswd -m sha-512 password

$6$YdPBODxytqUWXCYL$AHW1U9C6Qqkf6PZJI54jxFcPVm2sm/XWq3Z1qa94PFYz0FF.za9gl5WZL/z/g4nFLQ94SSEzMg5GMzMjJ6Vd7.
```

Now when you want to rebuild the configuration you have access to an alias called flake-rebuild that will rebuild the flake based of the flakeDir variable you set in options.nix!

Hope you enjoy!

### Updating

#### Add packages/edit config:

After some changes in `.nix` files you should update your config with:

```
flake-rebuild
```

#### Update packages/flake

If you want update all packages, you should write:

```
flake-update
```

If it is done, you also should update flake

```
sudo nixos-rebuild switch --flake .
```

And here you go, you updated all configuration!
