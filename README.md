# Packer Templates
This repository contains a Packer template for building minimal
Vagrant boxes based on Debian for VirtualBox (amd64).
It focuses on reproducibility, fast setup, and clean structure.

Most ideas were adapted from [chef/bento](https://github.com/chef/bento).

## Differences from standard Debian
- single partition `/` ext4 (no LVM, no swap, no EFI)
- `root` account disabled (no password)
- `vagrant` user with SSH [HCL public key](https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub) and `NOPASSWD:ALL` sudo
- preinstalled VirtualBox Guest Additions
- `cdrom:` source removed from APT
- Temp files, `machine-id`, APT cache, and logs cleaned up

→ Build instructions in [manual.md](./manual.md).

Prebuilt boxes are available on [Vagrant Cloud](https://portal.cloud.hashicorp.com/vagrant/discover/akelbikhanov).
