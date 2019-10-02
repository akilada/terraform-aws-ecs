resource "aws_lb_target_group" "sonarqube_lb_targetgroup" {
  name                 = "sonarqube-ecs-lb-targetgroup"
  port                 = 9000
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = "${module.vpc-data.vpc_id}"
  deregistration_delay = 120

  health_check {
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "sonarqube-elb"
  }
}

resource "aws_lb" "sonarqube_lb" {
  name               = "sonarqube-lb"
  subnets            = ["${aws_subnet.private_subnet.*.id}"]
  load_balancer_type = "application"
  internal           = true

  security_groups    = ["${aws_security_group.sonarqube_elb_sg.id}"]

  tags = {
    Name = "sonarqube-elb"
  }
}

resource "aws_lb_listener" "sonarqube-lb-listener" {
  load_balancer_arn = "${aws_lb.sonarqube_lb.id}"
  port              = "9000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.sonarqube_lb_targetgroup.id}"
    type             = "forward"
  }
}