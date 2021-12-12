resource "digitalocean_project" "minecraft" {
  name = "Minecraft"
  description = "minecraft ftb"
  purpose = "Website or blog"
  resources = [digitalocean_droplet.minecraft.urn]
}

resource "digitalocean_project" "personal" {
  name = "Personal"
  description = "personal content site and resources"
  purpose = "Website or blog"
  resources = [digitalocean_droplet.minecraft.urn]
}


resource "digitalocean_project" "default" {
  name = "sean.aye2"
  description = "default project for shared resources"
  environment = "Development"
  purpose = "Other"
  resources = [digitalocean_domain.default.urn]
}

