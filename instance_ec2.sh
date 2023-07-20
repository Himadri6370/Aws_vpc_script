#! /bin/bash
aws ec2 create-key-pair --key-name demo --query 'KeyMaterial' --output text > demo.pem
aws ec2 describe-key-pairs --key-name demo
aws ec2 create-security-group --group-name my-sg --description "securitygroup" --vpc-id vpc-0f518a35629cc1180
aws ec2 authorize-security-group-ingress --group-id sg-09727dcef0505dad4 --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 run-instances --image-id ami-0f5ee92e2d63afc18 --count 1 --instance-type t2.micro --key-name demo --security-group-ids sg-09727dcef0505dad4 --subnet-id subnet-0154732c539200300
