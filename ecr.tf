resource "aws_ecr_repository" "sonarqube" {
  name = "sonarqube"

  tags {
      Name = "${var.prefix}-ecr-sonarqube"
  }
}

resource "aws_ecr_lifecycle_policy" "sonarqube-policy" {
  repository = "${aws_ecr_repository.sonarqube.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 3014 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}