[
    {
        "image": "${app_image}",
        "name": "sonarqube",
        "cpu": ${fargate_cpu},
        "memory": ${fargate_memory},
        "networkMode": "awsvpc",
        "secrets": [
            {
                "name": "SONARQUBE_JDBC_PASSWORD",
                "valueFrom": "${jdbc_password}"
            },
            {
                "name": "SONARQUBE_JDBC_USERNAME",
                "valueFrom": "${jdbc_username}"
            },
            {
                "name": "SONARQUBE_JDBC_URL",
                "valueFrom": "${jdbc_url}"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "secretOptions": null,
            "options": {
                "awslogs-group": "/ecs/sonarqube-fargate",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "ecs-sonarqube"
            }
        },
        "portMappings": [
            {
                "containerPort": ${app_port},
                "appPort": ${app_port}
            }
        ]
    }
]