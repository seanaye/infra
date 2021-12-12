resource "digitalocean_droplet" "minecraft" {
  image  = "docker-20-04"
  name   = "minecraft"
  region = "tor1"
  size   = "s-4vcpu-8gb-amd"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir minecraft && cd minecraft",
      "export PATH=$PATH:/usr/bin",
      "sudo apt update",
      "sudo apt install -y wget",
      "wget https://raw.githubusercontent.com/seanaye/minecraft-server/main/docker-compose.yml",
      "docker-compose up -d"
    ]
  }
}

