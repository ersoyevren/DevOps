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

## Part 2 - Terraform Remote State (Remote backend)

- A `backend` in Terraform determines how tfstate file is loaded/stored and how an operation such as apply is executed. This abstraction enables non-local file state storage, remote execution, etc. By default, Terraform uses the "local" backend, which is the normal behavior of Terraform you're used to.

- Go to the AWS console and attach ``DynamoDBFullAccess`` policy to the existing role.

![state-locking](state-locking.png)

- Create a new folder named  `s3-backend` and a file named `backend.tf`. 

```txt
    s3-backend
       └── backend.tf
    terraform-aws
       ├── oliver.tfvars
       ├── main.tf
       └── variables.tf

```

- Go to the `s3-backend` folder and create a file name `backend.tf`. Add the followings.

```bash
cd .. && mkdir s3-backend && cd s3-backend && touch backend.tf
```

```go
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "tf-remote-s3-bucket-james-changehere"

  force_destroy = true # Normally it must be false. Because if we delete s3 mistakenly, we lost all of the states.
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mybackend" {
  bucket = aws_s3_bucket.tf-remote-state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_backend_s3" {
  bucket = aws_s3_bucket.tf-remote-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf-remote-state-lock" {
  hash_key = "LockID"
  name     = "tf-s3-app-lock"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}
```

- Run the commands below.

```bash
terraform init   

terraform apply
```

- We have created a S3 bucket and a Dynamodb table. Now associate S3 bucket with the Dynamodb table.

- Go to the `main.tf` file make the changes.

```go
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
  }
  backend "s3" {
    bucket = "tf-remote-s3-bucket-oliver-changehere"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }
}
```

- Go to the `terraform-aws` directoy and run the commands below. First try to terraform apply command.

```bash
- cd ../terraform-aws
```

```bash
terraform apply  

terraform init  

terraform apply
```

- Because of using S3 bucket for backend, run `terraform init` again. It will ask you to copy the existing tfstate file to s3. yes.

- Go to the AWS console and check the S3 bucket and tfstate file. tfstate file is copied from local to S3 backend.

- Go to the `main.tf` file add the followings and check the versioning on AWS S3 console.

```go
output "s3-arn-1" {
  value = aws_s3_bucket.tf-s3["fredo"].arn
  }
```

```bash
terraform apply
```

- Go to the `main.tf` file make the changes (add another output).

```go
  output "s3-arn-2" {
      value = aws_s3_bucket.tf-s3["santino"].arn
  }
```

- Open a new terminal. Write `terraform apply` in the both terminal. Try to run the command in both terminals at the same time.

- We do not get an error in the terminal that we run `terraform apply` command for the first time, but we get an error in the terminal we run later.

- Now you can try to run the same command with the second terminal. Check the Dynamo DB table and items.

- Destroy all resources. (Run the command in the `terraform-aws` and `s3-backend` folders.)

```bash
terraform destroy   
cd ../s3-backend/
terraform destroy
```

- Do not forget to delete ami and snapshot from the AWS console.