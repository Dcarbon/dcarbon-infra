resource "local_file" "write-output" {
  filename = "output_private.json"
  content = jsonencode({
    VPC = {
      ID              = module.vpc.main-vpc-id
      CIDR_BLOCK      = module.vpc.main-vpc-cidr
      PUBLIC_SUBNETS  = module.vpc.main-public-subnets
      PRIVATE_SUBNETS = module.vpc.main-private-subnets
      WAF_ID          = module.ip-web-acl.web-acl-arn
    }
  })
}