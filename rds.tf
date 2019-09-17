resource "aws_db_subnet_group" "sonarqube_postgres_subnet_group" {
  name        = "postgres_subnet_group_sonarqube"
  description = "Sonarqube PostgreSQL subnet group"
  subnet_ids  = ["${aws_subnet.data_subnet.*.id}"]

  tags {
    Name = "${var.prefix}-rds-sonarqube-subnet-group"
  }
}

resource "aws_db_instance" "sonarqube_postgres" {
  identifier             = "rdssonarqube"
  name                   = "rdssonarqube"
  vpc_security_group_ids = ["${aws_security_group.sg_ecs_rds.id}"]

  multi_az             = true
  db_subnet_group_name = "${aws_db_subnet_group.sonarqube_postgres_subnet_group.name}"

  allocated_storage = 40
  instance_class    = "db.t2.micro"
  storage_type      = "gp2"

  storage_encrypted   = false
  skip_final_snapshot = false

  engine         = "postgres"
  engine_version = "9.6.11"

  username = "sonarqube"
  password = "temporary120Password"

  skip_final_snapshot = true
  provisioner "local-exec" {
    command = "bash -c 'DBPASS=$$(env LC_CTYPE=C LC_ALL=C tr -dc A-Za-z0-9_ < /dev/urandom | head -c 16 | xargs) && echo $${DBPASS} >> ${self.name}.passwd && aws --region ${var.aws_region} rds modify-db-instance --db-instance-identifier ${self.id} --master-user-password $${DBPASS} --apply-immediately'"
  }

  tags {
    Name = "${var.prefix}-rds-sonarqube"
  }
}