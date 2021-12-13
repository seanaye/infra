resource "digitalocean_droplet" "strapi" {
  image  = "docker-20-04"
  name   = "strapi"
  region = "tor1"
  size   = "s-1vcpu-1gb"
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
      "cd infra/packages/strapi-config",
      "docker-compose up -d"
    ]
  }
}

resource "digitalocean_record" "content" {
  domain = digitalocean_domain.default.name
  type   = "A"
  name   = "content"
  value  = digitalocean_droplet.strapi.ipv4_address
}
