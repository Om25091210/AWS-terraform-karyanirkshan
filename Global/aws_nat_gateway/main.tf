# NAT Gateway for the public subnet
resource "aws_eip" "nat_gateway" {
  associate_with_private_ip = "10.0.0.5"
}
resource "aws_nat_gateway" "terraform-lab-ngw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = "subnet-0810d7e6db90ac418"

  tags = {
    Name = "terraform-lab-ngw"
  }
}
