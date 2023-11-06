resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.component}-${var.env}-sbg"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.component}-${var.env}-sbg"
  }
}
##creating security group for RDS module
resource "aws_security_group" "SG" {
  name        = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.sg_subnet_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}


resource "aws_rds_cluster" "rds_cluster" {

  cluster_identifier      = "${var.component}-${var.env}"
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = data.aws_ssm_parameter.username.value
  master_password         = data.aws_ssm_parameter.password.value
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  kms_key_id              = var.kms_key_arn
  storage_encrypted       = true
  skip_final_snapshot     = true
  vpc_security_group_ids  = [ aws_security_group.SG.id]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${var.component}-${var.env}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.rds_cluster.cluster_identifier
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.rds_cluster.engine
  engine_version     = aws_rds_cluster.rds_cluster.engine_version
}


