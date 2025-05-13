## Building a Vagrant Box with Packer

This guide describes how to build a `.box` image for VirtualBox 
based on Debian using [Packer](https://developer.hashicorp.com/packer).

---

### Requirements

- [Packer 1.10.0+](https://developer.hashicorp.com/packer/install)
- [VirtualBox v7.1.8+](https://download.virtualbox.org/virtualbox/7.1.8/)
- [VBoxGuestAdditions_7.1.8.iso](https://download.virtualbox.org/virtualbox/7.1.8/VBoxGuestAdditions_7.1.8.iso)
- [debian-12.10.0-amd64-netinst.iso](https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-12.10.0-amd64-netinst.iso)

> ⚠️ VirtualBox and VBoxGuestAdditions versions must match exactly!

---

### Input variables

Defined in `build.pkr.hcl`:

- `debian_iso` — Debian ISO file name
- `debian_iso_checksum` — SHA256 checksum of the ISO
- `ga_iso` — Guest Additions ISO file name
- `vm_name` — name of the VirtualBox VM and output `.box` file

---

### Build steps

Run from the directory containing `build.pkr.hcl`:

```bash
packer init .
packer build .
