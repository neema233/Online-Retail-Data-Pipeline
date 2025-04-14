terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# access secrets stored in secret manager
data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "terraform-creds"
}

/*json decode to parse the secret*/
locals {
  terraform-creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

#Store the arn of the KMS key to be used for encrypting the redshift cluster

data "aws_secretsmanager_secret_version" "encryptioncreds" {
  secret_id = "RedshiftClusterEncryptionKeySecret"
}
locals {
  RedshiftClusterEncryptionKeySecret = jsondecode(
    data.aws_secretsmanager_secret_version.encryptioncreds.secret_string
  )
}

# Create an encrypted Amazon Redshift cluster
resource "aws_redshift_cluster" "dw_cluster" {
  cluster_identifier = "tf-example-redshift-cluster"
  database_name      = "dev"
  master_username    = local.terraform-creds.username
  master_password    = local.terraform-creds.password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  publicly_accessible = "false"

}