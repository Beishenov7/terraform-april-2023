resource "aws_vpc" "group1" {
  cidr_block = var.cidr_vpc
}

resource "aws_subnet" "group1_public1" {
  vpc_id     = aws_vpc.group1.id
  cidr_block = var.cidr_public1
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

}

resource "aws_subnet" "group1_public2" {
  vpc_id     = aws_vpc.group1.id
  map_public_ip_on_launch = true
  cidr_block = var.cidr_public2
  availability_zone = "${var.region}b"

}

resource "aws_subnet" "group1_public3" {
  vpc_id     = aws_vpc.group1.id
  map_public_ip_on_launch = true
  cidr_block = var.cidr_public3
  availability_zone = "${var.region}c"

}

resource "aws_subnet" "group1_private1" {
  vpc_id     = aws_vpc.group1.id
  cidr_block = var.cidr_private1
  availability_zone = "${var.region}a"

}

resource "aws_subnet" "group1_private2" {
  vpc_id     = aws_vpc.group1.id
  cidr_block = var.cidr_private2
  availability_zone = "${var.region}b"

}

resource "aws_subnet" "group1_private3" {
  vpc_id     = aws_vpc.group1.id
  cidr_block = var.cidr_private3
  availability_zone = "${var.region}c"
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.group1.id
}

resource "aws_route_table" "r" {
   vpc_id = aws_vpc.group1.id

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.group1_public1.id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.group1_public2.id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.group1_public3.id
  route_table_id = aws_route_table.r.id
}