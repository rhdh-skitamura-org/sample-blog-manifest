resource "aws_subnet" "rds_subnet_1" {
  vpc_id            = data.terraform_remote_state.eks.outputs.vpc_id
  cidr_block        = local.rds_subnet_1.cidr_block
  availability_zone = data.terraform_remote_state.eks.outputs.azs[0]
  tags = {
    Name = local.rds_subnet_1.name
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id            = data.terraform_remote_state.eks.outputs.vpc_id
  cidr_block        = local.rds_subnet_1.cidr_block
  availability_zone = data.terraform_remote_state.eks.outputs.azs[1]
  tags = {
    Name = local.rds_subnet_2.name
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = local.subnet_group.name
  subnet_ids = ["${aws_subnet.rds_subnet_1.id}", "${aws_subnet.rds_subnet_2.id}"]
  tags = {
    Name = local.subnet_group.name
  }
}

resource "aws_security_group" "db-sg" {
  name   = local.security_group.name
  vpc_id = data.terraform_remote_state.eks.outputs.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.eks.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.security_group.name
  }
}

resource "aws_db_instance" "db" {
  identifier             = local.rds.identifier 
  allocated_storage      = local.rds.allocated_storage
  storage_type           = local.rds.storage_type
  engine                 = local.rds.engine
  engine_version         = local.rds.engine_version
  instance_class         = local.rds.instance_class
  db_name                = local.rds.db_name
  username               = local.rds.username
  password               = local.rds.password
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot    = true
}

output "db_instance_endpoint" {
  value = aws_db_instance.db.endpoint
}

