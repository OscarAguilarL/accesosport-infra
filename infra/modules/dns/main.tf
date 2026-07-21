resource "aws_route53_zone" "main" {
  name = "accesosport.com"

  tags = {
    Project = var.project
  }
}

# ── A Records ────────────────────────────────────────────────────────────────

resource "aws_route53_record" "a_apex" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "accesosport.com"
  type    = "A"
  ttl     = 300
  records = [var.ec2_public_ip]
}

resource "aws_route53_record" "a_www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.accesosport.com"
  type    = "A"
  ttl     = 300
  records = [var.ec2_public_ip]
}

resource "aws_route53_record" "a_api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.accesosport.com"
  type    = "A"
  ttl     = 300
  records = [var.ec2_public_ip]
}

resource "aws_route53_record" "a_staging" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "staging.accesosport.com"
  type    = "A"
  ttl     = 300
  records = [var.ec2_public_ip]
}

resource "aws_route53_record" "a_staging_api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "staging-api.accesosport.com"
  type    = "A"
  ttl     = 300
  records = [var.ec2_public_ip]
}

# ── MX Records ───────────────────────────────────────────────────────────────

resource "aws_route53_record" "mx_zoho" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "accesosport.com"
  type    = "MX"
  ttl     = 600
  records = [
    "10 mx.zoho.com",
    "20 mx2.zoho.com",
    "50 mx3.zoho.com",
  ]
}

# Feedback loop de Amazon SES para el subdominio de Resend
resource "aws_route53_record" "mx_ses" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "send.send.accesosport.com"
  type    = "MX"
  ttl     = 3600
  records = ["10 feedback-smtp.us-east-1.amazonses.com"]
}

# ── TXT Records ──────────────────────────────────────────────────────────────

# SPF Zoho + verificación de dominio Zoho (mismo name → un solo resource)
resource "aws_route53_record" "txt_apex" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "accesosport.com"
  type    = "TXT"
  ttl     = 3600
  records = [
    "v=spf1 include:zohomail.com ~all",
    "zoho-verification=zb38585162.zmverify.zoho.com",
  ]
}

resource "aws_route53_record" "txt_dkim_zoho" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "zmail._domainkey.accesosport.com"
  type    = "TXT"
  ttl     = 600
  records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCE6ZqjwCyE96FyP3lr+PubCH7Qa6UwlIds3S1epFDKqRnSJbmtPHkoc9DuLMsXAE6lOSV+9QrtSKV43Oa4kSiurtv1N0mnzUw3G9oZA7HxIBUJbrbHwoomqjODBEa1Uc3kVdYs6VsFYeuk7bW2ec7CRG8u3LUIgnYm7S+JpHODYQIDAQAB"]
}

resource "aws_route53_record" "txt_dkim_resend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "resend._domainkey.send.accesosport.com"
  type    = "TXT"
  ttl     = 3600
  records = ["p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDfCJOI5emw5TRyK6F0OeN7eox0A4B1ePAgkAMy/ulEOdUUm2jLNAuYSvJbBrlPVN8tW4htNBwCFuyZ4AsQRXmjuqRj8Zdgw+4PquJGfKYPiyo9Ga5UU6Z9eX3Ws1c6LHLk9yg5D34IR8uvBnunCyFWE6JBJsgcz0H+QC4NYNUsAQIDAQAB"]
}

resource "aws_route53_record" "txt_spf_ses" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "send.send.accesosport.com"
  type    = "TXT"
  ttl     = 3600
  records = ["v=spf1 include:amazonses.com ~all"]
}
