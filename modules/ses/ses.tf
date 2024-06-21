resource "aws_ses_domain_identity" "ses-domain" {
  domain = var.DOMAIN
}

resource "aws_ses_domain_dkim" "domain-dkim" {
  domain = join("", aws_ses_domain_identity.ses-domain.*.domain)
}