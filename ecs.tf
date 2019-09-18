data "template_file" "sonarqube_app" {
  template = "${file("./templates/ecs/sonarqube_definition.json.tpl")}"

  vars = {
    app_image      = "${aws_ecr_repository.sonarqube.repository_url}"
    app_port       = "${var.app_port}"
    jdbc_password  = "${data.aws_ssm_parameter.sonarqube_db_pass.arn}"
    jdbc_username  = "${data.aws_ssm_parameter.sonarqube_db_user.arn}"
    jdbc_url       = "jdbc:postgresql://${aws_db_instance.sonarqube_postgres.address}/sonarqube"
    aws_region     = "${var.aws_region}"
    fargate_cpu    = "${var.fargate_sonarqube_cpu}"
    fargate_memory = "${var.fargate_sonarqube_memory}"
    log_group      = "${aws_cloudwatch_log_group.sonarqube.name}"
  }

  depends_on       = ["aws_db_instance.sonarqube_postgres", "aws_cloudwatch_log_group.sonarqube"]
}

## Cloudwatch log group for sonarqube
resource "aws_cloudwatch_log_group" "sonarqube" {
  name  = "${var.fargate_sonarqube_log}"

  tags {
    Name = "${var.prefix}-ecs-svc-sonarqube"
    App  = "Sonarqube"
  }
  
}

## Sonarqube SSM lookup
data "aws_ssm_parameter" "sonarqube_db_pass" {
  name = "sonarqube_jdbc_password"
}

data "aws_ssm_parameter" "sonarqube_db_user" {
  name = "sonarqube_jdbc_username"
}

# data "aws_ssm_parameter" "sonarqube_db_url" {
#   name = "sonarqube_jdbc_url"
# }


resource "aws_ecs_cluster" "ecs_sonarqube" {
  name = "ecs-sonarqube"
}

#
# Sonarqube ECS Task definition
# 

resource "aws_ecs_task_definition" "ecs_task_sonarqube" {
    family                     = "sonarqube"

    container_definitions      = "${data.template_file.sonarqube_app.rendered}"
    execution_role_arn         = "${aws_iam_role.ecs_task_execution_role.name}"
    task_role_arn              = "${aws_iam_role.ecs_task_execution_role.name}"

    network_mode               = "awsvpc"

    requires_compatibilities   = ["FARGATE"]
    cpu                        = "${var.fargate_sonarqube_cpu}"
    memory                     = "${var.fargate_sonarqube_memory}"

    depends_on                 = ["aws_db_instance.sonarqube_postgres"]

    tags {
        Name = "${var.prefix}-ecs-task-sonarqube"
        App  = "Sonarqube"
    }
}

#
# Sonarqube ECS Service
#

resource "aws_ecs_service" "sonarqube_ecs_service" {
  name              = "sonarqube-ecs-svc"
  cluster           = "${aws_ecs_cluster.ecs_sonarqube.id}"
  task_definition   = "${aws_ecs_task_definition.ecs_task_sonarqube.arn}"
  desired_count     = 1
  launch_type       = "FARGATE"
  depends_on        = ["aws_ecs_task_definition.ecs_task_sonarqube", "aws_iam_role.ecs_task_execution_role", "aws_lb.sonarqube_lb" ]

  network_configuration {
    security_groups   = ["${aws_security_group.sg_ecs_tasks.id}"]
    subnets           = ["${aws_subnet.private_subnet.*.id}"]
    assign_public_ip  = false
  }
  
  load_balancer {
    target_group_arn  = "${aws_lb_target_group.sonarqube_lb_targetgroup.arn}"
    container_name    = "sonarqube"
    container_port    = "${var.sonarqube_port}"
  }

   tags {
     Name = "${var.prefix}-ecs-service-sonarqube"
     App  = "Sonarqube"
   }
}
