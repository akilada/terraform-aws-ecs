resource "aws_instance" "openvpn" {
    count                       = "${var.openvpn["host_count"]}"
    ami                         = "${var.openvpn["ami_image"]}"
    availability_zone           = "${var.openvpn["vpn_zone"]}"
    instance_type               = "${var.openvpn["type"]}"
    key_name                    = "${var.openvpn["key_name"]}"
    vpc_security_group_ids      = ["${aws_security_group.sg_vpn.id}"]
    subnet_id                   = "${element(aws_subnet.public_subnet.*.id, count.index)}"
    associate_public_ip_address = true
    source_dest_check           = false

    depends_on = ["aws_security_group.sg_vpn"]

    tags {
        Name        = "${var.prefix}-openvpn"
    }
}