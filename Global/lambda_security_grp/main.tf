resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Allow inbound traffic from specific IPs for lambda"
  vpc_id      = "vpc-0e7af0207628f5e2d"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.132.72.151/32", "10.132.72.152/32"] # Replace with your IP
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.132.72.151/32", "10.132.72.152/32"] # Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}