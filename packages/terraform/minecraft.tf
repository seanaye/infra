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
      "export PATH=$PATH:/usr/bin",
      "apt-get update",
      "apt-get install -y git-all",
      "git clone https://github.com/seanaye/infra.git",
      "cd infra/packages/minecraft",
      "docker-compose up -d"
    ]
  }
}

resource "digitalocean_record" "mc" {
  domain = digitalocean_domain.default.name
  type   = "A"
  name   = "mc"
  value  = digitalocean_droplet.minecraft.ipv4_address
}
