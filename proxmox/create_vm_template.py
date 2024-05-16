import subprocess


def create_image(id, memory, name, net0, cores, sockets, virtio0):
    command = [
        "qm", "create", str(id),
        "-memory", str(memory),
        "--name", name,
        "--net0", net0,
        "--cores", str(cores),
        "--sockets", str(sockets),
        "--virtio0", virtio0
    ]
    subprocess.run(command, check=True)


create_image(8000, 2048, "ubuntu-cloud", "virtio,bridge=vmbr0", 2, 1, "local-lvm:32")
