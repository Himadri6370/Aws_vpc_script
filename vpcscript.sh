#!/bin/bash
id=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query Vpc.VpcId --output text)
aws ec2 create-subnet --vpc-id $id --cidr-block 10.0.1.0/24
ig_id=$(aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text)
aws ec2 attach-internet-gateway --vpc-id $id --internet-gateway-id $ig_id
rt_id=$(aws ec2 create-route-table --vpc-id $id --query RouteTable.RouteTableId --output text)
aws ec2 create-route --route-table-id $rt_id --destination-cidr-block 0.0.0.0/0 --gateway-id $ig_id
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$id" --query "Subnets[*].{ID:SubnetId,CIDR:CidrBlock}"
echo "$id"
echo "$ig_id"
echo "$rt_id"
