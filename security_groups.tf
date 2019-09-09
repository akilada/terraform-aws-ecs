resource "aws_security_group" "sg_ecs_lb" {
  name        = "ecs-elb-security-group"
  description = "ECS ELB cccess controls"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix}-sg-ecs-lb"
  }
}

resource "aws_security_group" "sg_ecs_tasks" {
  name        = "ecs-tasks-security-group"
  description = "Allow inbound access from the ELB only"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.app_port}"
    to_port         = "${var.app_port}"
    security_groups = ["${aws_security_group.sg_ecs_lb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix}-sg-ecs-tasks"
  }
}

resource "aws_security_group" "sg_ecs_rds" {
  name        = "${var.prefix}-postgres"
  description = "PostgreSQL access controls"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port = "${var.rds_port}"
    to_port   = "${var.rds_port}"
    protocol  = "tcp"

    cidr_blocks = [
      "${var.vpc_cidr}",
    ] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix}-sg-ecs-rds"
  }
}

resource "aws_security_group" "sg_vpn" {
  name        = "${var.prefix}-vpn"
  description = "VPN access controls"
  vpc_id      = "${aws_vpc.vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 943
        to_port = 943
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 1194
        to_port = 1194
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.prefix}-sg-vpn"
    }
}