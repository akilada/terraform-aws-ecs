
data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "SecretsManagerReadWrite" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_iam_policy" "AmazonEC2ContainerServiceforEC2Role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_role" "ecs_task_execution_role" {
    name    = "ecsTaskExecutionRole"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com" ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_ssm_policy" {
  name        = "ecs-ssm-policy"
  role        = "${aws_iam_role.ecs_task_execution_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
    policy_arn  = "${data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn}"
    role        = "${aws_iam_role.ecs_task_execution_role.name}"
}

resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite" {
    policy_arn  = "${data.aws_iam_policy.SecretsManagerReadWrite.arn}"
    role        = "${aws_iam_role.ecs_task_execution_role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role" {
    policy_arn  = "${data.aws_iam_policy.AmazonEC2ContainerServiceforEC2Role.arn}"
    role        = "${aws_iam_role.ecs_task_execution_role.name}"
}