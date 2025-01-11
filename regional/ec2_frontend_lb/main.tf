# Create a Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "frontend-doc-tf-target-group"
  protocol    = "HTTP"
  port        = 3000
  vpc_id      = "vpc-0e7af0207628f5e2d" //VPC ID
  target_type = "instance"
  health_check {
    path = "/" # Replace with the actual health check path on your server (Where we get 200 status code)
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5
    interval = 30
  }
}

# Create an Application Load Balancer (ALB)
resource "aws_lb" "app_lb" {
  name               = "frontend-doc-tf-app-lb"
  load_balancer_type = "application"
  security_groups    = ["sg-0dd60e6ae38d08185"]
  subnets            = ["subnet-0810d7e6db90ac418","subnet-00c49b555ed0bc3eb"] //one public ap-south-1a and one private ap-south-1b
}

# Create a Target Group for Lambda
resource "aws_lb_target_group" "lambda_target_group" {
  name        = "karyanirkshan-tf-lambda"
  vpc_id      = "vpc-0e7af0207628f5e2d" #VPC ID
  target_type = "lambda"
  health_check {
      path = "/"
      protocol = "HTTP"
      timeout = 5
      interval = 31
    }
}

# Create a Listener for the Load Balancer - Lambda Target Group
resource "aws_lb_listener" "http_listener_lambda" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 8000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda_target_group.arn
  }
}


resource "aws_lambda_permission" "allow_lb" {
    statement_id  = "AllowExecutionFromALB"
    action        = "lambda:InvokeFunction"
    function_name = "karyanirkshan-tf-lammbda"
    principal     = "elasticloadbalancing.amazonaws.com"
    source_arn    = "arn:aws:elasticloadbalancing:ap-south-1:851725390204:loadbalancer/app/frontend-doc-tf-app-lb/9db11310524acdfe"//aws_lb.app_lb.arn 
    depends_on    = [aws_lb_target_group.lambda_target_group]
}


# Attach Lambda Function to Lambda Target Group
# resource "aws_lb_target_group_attachment" "lambda_attachment" {
#   target_group_arn = aws_lb_target_group.lambda_target_group.arn
#   target_id        = "arn:aws:lambda:ap-south-1:851725390204:function:karyanirkshan-tf-lammbda" # Replace with your Lambda ARN
#   depends_on = [aws_lambda_permission.allow_lb]
# }

# Create a Listener for the Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# # Create a Listener for the Load Balancer - HTTP:8000 - Redirect to Lambda URL
# resource "aws_lb_listener" "redirect_listener" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 8000
#   protocol          = "HTTP"


#   default_action {
#     type = "redirect"

#     redirect {
#       protocol = "HTTPS"
#       port = "443"
#       host = "yhrcpjawrlvnedxyhnm257nx6q0qtihb.lambda-url.ap-south-1.on.aws"
#       status_code = "HTTP_301"
#     }
#   }
# }

# Attach EC2 instance to Target Group
resource "aws_lb_target_group_attachment" "ec2_attachment_1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = "i-04f9caaa88f8fd4ea"
  port             = 3000
}