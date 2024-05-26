
# export the vpc id
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# export the internet gateway
output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway.id
}

# export the public subnet az1 id
output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

# export the public subnet az2 id
output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

# export the private app subnet az1 id
output "private_app_subnet_az1_id" {
  value = aws_subnet.private_subnet_az1.id
}

# export the private app subnet az2 id
output "private_app_subnet_az2_id" {
  value = aws_subnet.private_subnet_az2.id
}



# export the first availability zone
output "availability_zone_1" {
  value = data.aws_availability_zones.available_zones.names[0]
}

# export the second availability zone
output "availability_zone_2" {
  value = data.aws_availability_zones.available_zones.names[1]
}

#export the NAT Gateway1

output "nat_gateway_subnet1"{
  value = aws_nat_gateway.nat_gateway_subnet1.id
}

#export the NAT Gateway2

output "nat_gateway_subnet2"{
  value = aws_nat_gateway.nat_gateway_subnet2.id
}

# export the elastic ip 1 of NAT Gateway1

output "elasticIP_one" {
  value = aws_eip.elasticIP_one.id
}

# export the elastic ip 2 of NAT Gateway2

output "elasticIP_two" {
  value = aws_eip.elasticIP_two.id
}