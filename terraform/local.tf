locals {
  private_subnet_1 = {
    name = "rds-subnet-1"
    cidr = 
  }

  private_subnet_2 = {
    name = "rds-subnet-2"
    cidr = 10.0.192.0/20
  }

  subnet_group = {
    name = "subnet_group"
  }

  security_group = {
    name = "rds-secruity-group"
  }

  rds = {
    identifier        = "sample-blog-db"
    allocated_storage = 20
    storage_type      = "gp3"
    engine            = "mysql"
    engine_version    = "8.0"
    instance_class    = "db.t3.micro"
    db_name           = "sampleblog"
    username          = "sampleblog"
    password          = "sampleblog"
  }
}
