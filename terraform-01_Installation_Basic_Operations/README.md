# Hands-on Terraform-01 : Terraform Installation and Basic Operations:

Purpose of the this hands-on training is to give students the knowledge of basic operations in Terraform.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Install Terraform

- Build AWS Infrastructure with Terraform

## Outline

- Part 1 - Install Terraform

- Part 2 - Build AWS Infrastructure with Terraform

## Part 1 - Install Terraform

- Launch an EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH connections.

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
$ sudo yum update -y
```

- Install yum-config-manager to manage your repositories.

```bash
$ sudo yum install -y yum-utils
```
- Use yum-config-manager to add the official HashiCorp Linux repository to the directory of /etc/yum.repos.d.

```bash
$ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

- Install Terraform.

```bash
$ sudo yum -y install terraform
```

- Verify that the installation

```bash
$ terraform version
```
- list Terraform's available subcommands.

```bash
$ terraform -help
Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
The most common, useful commands are shown first, followed by
less common or more advanced commands. If you are just getting
started with Terraform, stick with the common commands. For the
other commands, please read the help and docs before usage.

Common commands:
    apply              Builds or changes infrastructure
...

```

- Add any subcommand to terraform -help to learn more about what it does and available options.

```bash
$ terraform -help apply
or
$ terraform apply -help
```

