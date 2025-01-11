module "ec2_instance" {
  source  = "../../modules/ec2"

  name = "karyanirkshan-staging-instance"

  instance_type          = "t2.small"
  key_name               = "bitcrackers"
  monitoring             = false
  vpc_security_group_ids = ["sg-0c152074da7cba4a1"]
  subnet_id              = "subnet-0425390e66208ccb4"
  ami                    = "ami-0672c7f873aea0ae8" # Replace with your custom AMI ID
              
  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
