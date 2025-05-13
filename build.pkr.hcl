# build.pkr.hcl — Debian 12.10 → VirtualBox 7.1.8 → Vagrant .box

packer {
  required_plugins {
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = ">= 1.1.2"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.1.5"
    }
  }
}

variable "debian_iso" {
  type    = string
  default = "debian-12.10.0-amd64-netinst.iso"
}

variable "debian_iso_checksum" {
  type    = string
  default = "sha256:ee8d8579128977d7dc39d48f43aec5ab06b7f09e1f40a9d98f2a9d149221704a"
}

variable "ga_iso" {
  type    = string
  default = "VBoxGuestAdditions_7.1.8.iso"
}

variable "vm_name" {
  type    = string
  default = "debian12.10"
}

source "virtualbox-iso" "debian" {
  guest_os_type        = "Debian_64"
  iso_url              = var.debian_iso
  iso_checksum         = var.debian_iso_checksum
  iso_interface        = "sata"
  hard_drive_interface = "sata"
  sata_port_count      = 2

  vm_name              = var.vm_name
  disk_size            = 40960
  headless             = true

  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -h now"
  ssh_username         = "vagrant"
  ssh_password         = "vagrant"
  ssh_timeout          = "5m"

  http_directory       = "."
  boot_wait            = "5s"

  boot_command = [
    "<wait><esc><wait>",
    "auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/preseed.cfg",
    "<enter>"
  ]

  vboxmanage = [
    ["storagectl", "{{.Name}}", "--name", "IDE Controller", "--remove"],
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--nested-hw-virt", "on"],
    ["modifyvm", "{{.Name}}", "--ioapic", "on"],
    ["modifyvm", "{{.Name}}", "--rtcuseutc", "on"],
    ["modifyvm", "{{.Name}}", "--usb", "off"],
    ["modifyvm", "{{.Name}}", "--audio", "none"],
    ["modifyvm", "{{.Name}}", "--uart1", "off"],
    ["modifyvm", "{{.Name}}", "--uart2", "off"],
    ["modifyvm", "{{.Name}}", "--mouse", "ps2"],
    ["storageattach", "{{.Name}}", "--storagectl", "SATA Controller",
      "--port", "0", "--device", "0", "--type", "hdd",
      "--nonrotational", "on"]
  ]
}

build {
  name    = var.vm_name
  sources = ["source.virtualbox-iso.debian"]

  provisioner "file" {
    source      = var.ga_iso
    destination = "/home/vagrant/VBoxGuestAdditions"
  }

  provisioner "shell" {
    script = "setup.sh"
    execute_command = "echo '${ssh_password}' | {{ .Vars }} sudo -S -E bash -c '{{ .Path }}'"
  }

  provisioner "shell" {
    script = "cleanup.sh"
    execute_command = "echo '${ssh_password}' | {{ .Vars }} sudo -S -E bash -c '{{ .Path }}'"
  }

  post-processor "vagrant" {
    output              = "${var.vm_name}.box"
    keep_input_artifact = true
  }
}
