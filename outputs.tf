output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnets_cidr" {
  value = "${zipmap(aws_subnet.public_subnet.*.id,aws_subnet.public_subnet.*.cidr_block)}"
}

output "public_subnets_az" {
  value = "${zipmap(aws_subnet.public_subnet.*.id, aws_subnet.public_subnet.*.availability_zone)}"
}

output "private_subnets_cidr" {
  value = "${zipmap(aws_subnet.private_subnet.*.id,aws_subnet.private_subnet.*.cidr_block)}"
}

output "private_subnets_az" {
  value = "${zipmap(aws_subnet.private_subnet.*.id, aws_subnet.private_subnet.*.availability_zone)}"
}

output "data_subnets_cidr" {
  value = "${zipmap(aws_subnet.data_subnet.*.id,aws_subnet.data_subnet.*.cidr_block)}"
}

output "data_subnets_az" {
  value = "${zipmap(aws_subnet.data_subnet.*.id, aws_subnet.data_subnet.*.availability_zone)}"
}

output "ecs_iam_role" {
  value = "${aws_iam_role.ecs_task_execution_role.name}"
}

output "sg_ecs_lb" {
  value = "${aws_security_group.sg_ecs_lb.id}"
}

output "sg_ecs_tasks" {
  value = "${aws_security_group.sg_ecs_tasks.id}"
}

output "sg_ecs_rds" {
  value = "${aws_security_group.sg_ecs_rds.id}"
}

output "sg_vpn" {
  value = "${aws_security_group.sg_vpn.id}"
}


