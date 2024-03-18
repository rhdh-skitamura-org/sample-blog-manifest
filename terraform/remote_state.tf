data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "skitamura-terraform-tfstate"
    key    = "component:default/eks-sample-004/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
