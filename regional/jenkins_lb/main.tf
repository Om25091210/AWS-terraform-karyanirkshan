# Create a Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "jenkins-terraform-target-group"
  protocol    = "HTTP"
  port        = 8080
  vpc_id      = "vpc-0e7af0207628f5e2d" //VPC ID
  target_type = "instance"
  health_check {
    path = "/login" # Replace with the actual health check path on your server (Where we get 200 status code)
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5
    interval = 30
  }
}

# Create an Application Load Balancer (ALB)
resource "aws_lb" "app_lb" {
  name               = "jenkins-terraform-app-lb"
  load_balancer_type = "application"
  security_groups    = ["sg-0a74c448816021bc7"]
  subnets            = ["subnet-0810d7e6db90ac418","subnet-00c49b555ed0bc3eb"] //one public ap-south-1a and one private ap-south-1b
}

# Create a Listener for the Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Attach EC2 instance to Target Group
resource "aws_lb_target_group_attachment" "ec2_attachment_1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = "i-04f9caaa88f8fd4ea"
  port             = 8080
}