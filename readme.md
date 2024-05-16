# Build Base Images

This directory contains tooling for building base images for use as nodes in the Kubernetes cluster. [Packer](https://www.packer.io) is used for building these images.

## Prerequisites

### Hypervisor

The images may be built using one of the following hypervisor:

| OS | Builder |
|----|---------|
| Linux | [QEMU](https://www.qemu.org) |
| Windows | Microsoft Hyper-V |

### Tools

- [Packer](https://www.packer.io/intro/getting-started/install.html)
- [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html) version >= 2.8.0
- [goss](https://github.com/YaleUniversity/packer-provisioner-goss)

The program `hack/image-tools.sh` can be used to download and install the goss plug-in.