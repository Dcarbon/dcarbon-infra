output "domain-verification-token" {
  value = aws_ses_domain_identity.ses-domain.*.domain
}

output "ses-dkim-tokens" {
  value = aws_ses_domain_dkim.domain-dkim.dkim_tokens
}