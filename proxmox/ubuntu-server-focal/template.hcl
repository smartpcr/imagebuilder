# Ubuntu Server Focal
# 20.04 LTS

variable "proxmox_api" {
  type = object({
    url = string
    token_id = string
    token_secret = sensitive(string)
  })
  description = "Proxmox API credentials"
}

variable "proxmox_vm" {
  type = object({
    node = string
    vmid = number
    name = string
    cores = number
    memory = number
    disk_size = number
    network = string
    template = string
  })
  default = {
    cores = 2
    memory = 4096
    disk_size = 32
    network = "vmbr0"
    template = "ubuntu-server-focal"
  }
  description = "Proxmox VM configuration"
}

source "proxmox" "ubuntu-server-focal" {
  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api.url}"
  username = "${var.proxmox_api.token_id}"
  token = "${var.proxmox_api.token_secret}"
  # (Optional) Skip TLS Verification
  # insecure_skip_tls_verify = true

  # VM General Settings
  node = "${var.proxmox_vm.node}"
  vm_id = "${var.proxmox_vm.vmid}"
  vm_name = "${var.proxmox_vm.name}"
  template_description = "Ubuntu Server Focal Image"

  # VM OS Settings
  # (Option 1) Local ISO File
  # iso_file = "local:iso/ubuntu-20.04.2-live-server-amd64.iso"
  # - or -
  # (Option 2) Download ISO
  # iso_url = "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso"
  # iso_checksum = "f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  iso_storage_pool = "local"
  unmount_iso = true

  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"

  disks {
      disk_size = "${var.proxmox_vm.disk_size}G"
      format = "qcow2"
      storage_pool = "local-lvm"
      storage_pool_type = "lvm"
      type = "virtio"
  }

  # VM CPU Settings
  cores = "${var.proxmox_vm.cores}"

  # VM Memory Settings
  memory = "${var.proxmox_vm.memory}"

  # VM Network Settings
  network_adapters {
      model = "virtio"
      bridge = "${var.proxmox_vm.network}"
      firewall = "false"
  }

  # VM Cloud-Init Settings
  cloud_init = true
  cloud_init_storage_pool = "local-lvm"

  # ubuntu answer file
  http_directory = "http"
  http_content = {
    "autoinstall/user-data" = file("${path.module}/user-data")
    "autoinstall/meta-data" = file("${path.module}/meta-data")
  }

  boot = "c"
  boot_wait = "5s"

  ssh_username = "ubuntu"

  # (Option 1) Add your Password here
  # ssh_password = "your-password"
  # - or -
  # (Option 2) Add your Private SSH KEY file here
  # ssh_private_key_file = "~/.ssh/id_rsa"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {
  name = "ubuntu-server-focal"
  sources = ["source.proxmox.ubuntu-server-focal"]

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
  provisioner "file" {
    source = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
  provisioner "shell" {
    inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
  }

  # Add additional provisioning scripts here
  # ...
}