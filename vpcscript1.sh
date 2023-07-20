#!/bin/bash

# Create VPC
vpc_id=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text)

# Create Internet Gateway
gateway_id=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)

# Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway --internet-gateway-id $gateway_id --vpc-id $vpc_id

# Create Subnet
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text)

# Create Route Table
route_table_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.RouteTableId' --output text)

# Associate Subnet with Route Table
aws ec2 associate-route-table --route-table-id $route_table_id --subnet-id $subnet_id

# Create Route to Internet Gateway
aws ec2 create-route --route-table-id $route_table_id --destination-cidr-block 0.0.0.0/0 --gateway-id $gateway_id

# Allocate Elastic IP Address
eip_allocation_id=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)

# Associate Elastic IP Address with Network Interface
eni_id=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$vpc_id" "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].NetworkInterfaces[].NetworkInterfaceId' --output text)
aws ec2 associate-address --instance-id $eni_id --allocation-id $eip_allocation_id

echo "VPC created with ID: $vpc_id"
echo "Elastic IP allocated with ID: $eip_allocation_id"
