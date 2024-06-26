provider "aws" {
  region = "eu-west-1"
  
}

module "vpc" {
 source                          = "github.com/sb228516/XTIVIA/blob/master/vpc.tf"
    region                          = var.region
    project_name                    = var.project_name
    vpc_cidr                        = var.vpc_cidr
  

  # Details
  name            = "vpc_module_demo"
  cidr            =  "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway  = true
  single_nat_gateway  = false
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
