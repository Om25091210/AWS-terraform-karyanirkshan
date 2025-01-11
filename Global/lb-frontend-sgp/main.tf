resource "aws_security_group" "frontend-karyanirkshan-lb_sg" {
  name        = "frontend-karyanirkshan-lb-sg"
  description = "Allow inbound traffic from specific IPs for ec2"
  vpc_id      = "vpc-0e7af0207628f5e2d"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP
  }
  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["49.43.27.89/32"] # Replace with your IP
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}