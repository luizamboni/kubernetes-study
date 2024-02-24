locals {
    cluster_name = "eks_cluster_1"
    vpc_id = "vpc-9d271ffa"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.40"
    }
  }
}

data "aws_subnet" "one" {
  vpc_id = local.vpc_id
  availability_zone = "us-east-1a"
}

data "aws_subnet" "two" {
  vpc_id = local.vpc_id
  availability_zone = "us-east-1b"
}


output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}