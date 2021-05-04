## CloudFlare
variable "cf_email" {
  type        = string
  default     = "andreyka001@gmail.com"
  description = "Cloudflare email"
}
variable "cf_zone_id" {
  type        = string
  default     = "37b9d5d7d208341f4417d6cba59cd80c" #"dev-ops.live"
  description = "CF zone id"
}

provider "cloudflare" {
  email   = var.cloudflare.email
  #api_key = var.cloudflare.api_key
  api_key = file("~/keys/cf_dns_token")
}

resource "cloudflare_record" "dns-record" {
  for_each = var.hosts
  zone_id  = var.cf_zone_id
  name     = each.value.hostname
  value    = aws_instance.host[each.key].public_ip
  type     = "A"
  ttl      = 1
  proxied  = false
}
