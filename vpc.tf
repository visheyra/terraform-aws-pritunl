module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"

  name = "${var.name}-vpn"
  cidr = "${var.vpc_cidr}"

  azs = ["${var.az}"]
  private_subnets = ["${var.private_subnet_cidr}"]
  public_subnets = ["${var.public_subnet_cidr}"]
  enable_nat_gateway = true
}