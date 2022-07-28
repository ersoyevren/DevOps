# Hands-on Terraform-03 : Terraform Data Sources, Remote Backend and Provisioners.

Purpose of the this hands-on training is to give students the knowledge of terraform data sources, remote backend and provisioners in Terraform.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Use terraform data sources.
- Create a remote backend.
- Use terraform provisioners.

## Outline

- Part 1 - Terraform Data Sources

- Part 2 - Remote Backend

- Part 3 - Terraform Provisioners

## Part 1 - Terraform Data Sources

- `Data sources` allow data to be fetched or computed for use elsewhere in Terraform configuration.

- Go to the `AWS console and create an image` from your EC2. Select your instance and from actions click image and templates and then give a name for ami `my-ami` and click create. 

# It will take some time. go to the next steps.

- Go to the `variables.tf` file and comment the variable `ec2-ami`.

- Go to the `main.tf` file make the changes in order.

```go
data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf_ami.id
  instance_type = var.ec2-type
  key_name      = "mk"
  tags = {
    Name = "${local.mytag}-this is from my-ami"
  }
}
```

```bash
terraform plan
```

```bash
terraform apply
```

- Check EC2 instance's ami id.

- You can see which data sources can be used with a resource in the documentation of terraform. For example EBS snapshot.

```bash
terraform destroy
```

