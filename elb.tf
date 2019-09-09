resource "aws_elb" "sonarqube_elb" {
  name               = "sonarqube-elb"

  security_groups    = ["${aws_security_group.sg_ecs_lb.id}"]
  subnets            = ["${aws_subnet.private_subnet.*.id}"]
  internal           = true

  listener {
    instance_port     = "${var.app_port}"
    instance_protocol = "http"
    lb_port           = "${var.app_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:9000/"
    interval            = 30
  }

  #instances                   = [""]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.prefix}-sonarqube-elb"
  }
}