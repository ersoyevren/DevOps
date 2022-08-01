# Hands-on Docker-01 : Installing Docker on Amazon Linux 2 AWS EC2 Instance

Purpose of the this hands-on training is to teach the students how to install Docker on on Amazon Linux 2 EC2 instance.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install Docker on Amazon Linux 2 EC2 instance

- configure a Cloudformation template for creating a Docker machine

## Outline

- Part 1 - Launch Amazon Linux 2 EC2 Instance and Connect with SSH

- Part 2 - Install Docker on Amazon Linux 2 EC2 Instance

- Part 3 - Configure a Cloudformation Template for a Docker machine

## Part 1 - Launch Amazon Linux 2 EC2 Instance and Connect with SSH

- Launch an EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH connections.

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

