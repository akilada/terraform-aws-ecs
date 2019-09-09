resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
      Name  = "${var.prefix}-vpc"
  } 
}

resource "aws_internet_gateway" "internet" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_subnet" "public_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id                  = "${aws_vpc.vpc.id}"
    cidr_block              = "${cidrsubnet(var.vpc_cidr, var.subnet_address_bits, var.public_subnets_address_offset + count.index)}"
    availability_zone       = "${element(var.availability_zones, count.index)}"

    tags {
        Name = "${var.prefix}-public-subnet-${count.index}"
    }
}

resource "aws_subnet" "private_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id            = "${aws_vpc.vpc.id}"
    cidr_block        = "${cidrsubnet(var.vpc_cidr, var.subnet_address_bits, var.private_subnets_address_offset + count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"

    tags {
        Name = "${var.prefix}-private-subnet-${count.index}"
    }

}

resource "aws_subnet" "data_subnet" {
    count = "${length(var.availability_zones)}"

    vpc_id            = "${aws_vpc.vpc.id}"
    cidr_block        = "${cidrsubnet(var.vpc_cidr, var.subnet_address_bits, var.data_subnets_address_offset + count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"

    tags {
        Name = "${var.prefix}-data-subnet-${count.index}"
    }

}

resource "aws_route_table" "default_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name   = "${var.prefix}-default-route-table"
  }
}

resource "aws_route" "public_default" {
  route_table_id            = "${element(aws_route_table.default_route_table.*.id, count.index)}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet.id}"
}

resource "aws_eip" "nat_gateway" {
    vpc   = true

    # lifecycle {
    #     prevent_destroy = false
    # }

    tags {
        Name   = "${var.prefix}-nat-gateway-eip"
    }
}

resource "aws_nat_gateway" "internet" {
  allocation_id = "${aws_eip.nat_gateway.id}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, 0)}"

    tags {
        Name   = "${var.prefix}-nat-gateway"
    }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name   = "${var.prefix}-private-route-table"
  }
}

resource "aws_route" "private_default" {
  route_table_id            = "${element(aws_route_table.private_route_table.*.id, count.index)}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.internet.id}"
}

resource "aws_route_table_association" "public_subnet" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.default_route_table.id}"
}

resource "aws_route_table_association" "private_subnet" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "data_subnet" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.data_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}