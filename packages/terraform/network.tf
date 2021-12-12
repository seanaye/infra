resource "digitalocean_domain" "default" {
  ip_address = null
  name = "seanaye.ca"
}

resource "digitalocean_record" "mc" {
  domain = digitalocean_domain.default.name
  type   = "A"
  name   = "mc"
  value  = digitalocean_droplet.minecraft.ipv4_address
}

resource "digitalocean_record" "improvmxtxt" {
  domain = digitalocean_domain.default.name
  type = "TXT"
  name = "@"
  value = "v=spf1 include:spf.improvmx.com ~all"
}


resource "digitalocean_record" "improvmx2" {
  domain = digitalocean_domain.default.name
  type = "MX"
  name = "@"
  priority = 20
  value = "mx2.improvmx.com."
}

resource "digitalocean_record" "improvmx1" {
  domain = digitalocean_domain.default.name
  type = "MX"
  name = "@"
  priority = 10
  value = "mx1.improvmx.com."
}

resource "digitalocean_record" "ns3" {
  domain = digitalocean_domain.default.name
  type = "NS"
  name = "@"
  value = "ns3.digitalocean.com."
}

resource "digitalocean_record" "ns2" {
  domain = digitalocean_domain.default.name
  type = "NS"
  name = "@"
  value = "ns2.digitalocean.com."
}

resource "digitalocean_record" "ns1" {
  domain = digitalocean_domain.default.name
  type = "NS"
  name = "@"
  value = "ns1.digitalocean.com."
}
