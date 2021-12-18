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

resource "digitalocean_spaces_bucket" "objects" {
  name = "seanaye"
  region = "nyc3"
  acl = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
    allowed_origins = ["https://content.seanaye.ca", "http://localhost:3000"]
    max_age_seconds = 3000
  }
}

resource "digitalocean_certificate" "cert" {
  name = "cdn-cert"
  type = "lets_encrypt"
  domains = ["cdn.seanaye.ca"]
}

resource "digitalocean_cdn" "cdn" {
  origin = digitalocean_spaces_bucket.objects.bucket_domain_name
  custom_domain = "cdn.seanaye.ca"
  certificate_name = digitalocean_certificate.cert.name
} 

resource "digitalocean_project" "personal" {
  name = "Personal"
  description = "personal content site and resources"
  purpose = "Website or blog"
  resources = [digitalocean_droplet.strapi.urn, digitalocean_spaces_bucket.objects.urn]
}

