resource "aws_vpc" "roboshop_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.common_tags,{
    Name = var.project_name
  },var.vpc_tgas)
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.roboshop_vpc.id
  tags = merge(
    var.common_tags,
    {
    Name = var.project_name
  },
  var.igw_tags
  )
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_block)
  vpc_id = aws_vpc.roboshop_vpc.id
  cidr_block = var.public_subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,{
        Name = var.public_subnet_tags[count.index]
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_block)
  vpc_id = aws_vpc.roboshop_vpc.id
  cidr_block = var.private_subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.zones.names[count.index]

  tags = merge(
    var.common_tags,{
        Name = var.private_subnet_tags[count.index]
    }
  )
}

resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnet_cidr_block)
  vpc_id = aws_vpc.roboshop_vpc.id
  cidr_block = var.database_subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.zones.names[count.index]

  tags = merge(
    var.common_tags,{
        Name = var.database_subnet_tags[count.index]
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.roboshop_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = merge(var.common_tags,var.public_route_table_tags)
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_block)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.roboshop_vpc.id
  tags = merge(var.common_tags,var.private_route_table_tags)
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_block)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.roboshop_vpc.id
  tags = merge(var.common_tags,var.database_route_table_tags)
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr_block)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    var.common_tags,
    {
    Name = var.project_name
  },
  var.aws_nat_gateway_tags
  )
 
  depends_on = [ aws_internet_gateway.gateway ]

}

resource "aws_db_subnet_group" "db_group" {
  name       = var.roboshop_db_subnet_group
  subnet_ids = aws_subnet.database_subnet[*].id

  tags = {
    Name = "${var.project_name}_db_subnet_group"
  } 
}





