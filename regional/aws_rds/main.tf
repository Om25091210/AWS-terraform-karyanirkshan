# Fetch all private subnets from the default VPC
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0e7af0207628f5e2d"]
  }
    tags = {
      "kubernetes.io/role/internal-elb" = 1
    }
}


# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = "vpc-0e7af0207628f5e2d"

  # Example Ingress Rule (adjust based on your network needs)
  ingress {
    from_port   = 5432  # Default MySQL/MariaDB port
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0","152.58.59.235/32","192.168.152.65/32"]  # Replace with your VPC CIDR or the CIDR of your Lambda security group
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all egress traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create RDS Instance from Snapshot
resource "aws_db_instance" "rds_from_snapshot" {
  allocated_storage      = 20 # Example, modify as needed
  engine                 = "postgres" # Replace with your database engine
  engine_version         = "14.9" # Replace with your database version

  instance_class         = "db.t4g.micro" # Replace with your desired instance class
  //name                   = "my-rds-from-snapshot" # Replace with your desired RDS instance name
  snapshot_identifier    = "arn:aws:rds:ap-south-1:851725390204:snapshot:karyanirikshan-staging-database-gaurav" # Replace with your snapshot ARN
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true  # Change to 'false' for final snapshot in production

  # Optional settings (adjust based on your requirements)
  multi_az                 = false
  publicly_accessible    = false
  storage_type = "gp2"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "main"
  subnet_ids = ["subnet-0425390e66208ccb4",  "subnet-00c49b555ed0bc3eb"]

  tags = {
    Name = "My DB subnet group"
  }
}


# Output RDS Endpoint
output "rds_endpoint" {
  value = aws_db_instance.rds_from_snapshot.address
}