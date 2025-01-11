# Security Group for the Load Balancer
resource "aws_security_group" "load_balancer_sg" {
  name        = "jenkins-load-balancer-sg"
  description = "Allow traffic to the load balancer"
  vpc_id      = "vpc-0e7af0207628f5e2d" //vpc id here
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere; restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all egress traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

