# Hands-on Terraform-02 : Terraform Commands, Variables, Conditionals, Loops:

Purpose of the this hands-on training is to give students the knowledge of terraform commands, variables, conditionals and loops in Terraform.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Use terraform commands, variables, conditionals and loops.

## Outline

- Part 1 - Terraform Commands

- Part 2 - Variables

- Part 3: Conditionals and Loops

## Part -1: Terraform Commands

-  Create a directory ("terraform-aws") for the new configuration and change into the directory.

```bash
$ mkdir terraform-aws && cd terraform-aws && touch main.tf
```

- Create a file named `main.tf` for the configuration code and copy and paste the following content. 

```go
provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  key_name      = "oliver"    # write your pem file without .pem extension>
  tags = {
    "Name" = "tf-ec2"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "oliver-tf-test-bucket-addwhateveryouwant"
}
```

- Run the command `terraform plan` and `terraform apply`.

```bash
terraform plan

terraform apply
```

### Validate command.

- Go to the terminal and run `terraform validate`. It validates the Terraform files syntactically correct and internally consistent.  

```bash
terraform validate
```

- Go to `main.tf` file and delete last curly bracket "}" and key_name's last letter (key_nam). And Go to terminal and run the command `terraform validate`. After taking the errors correct them. Then run the command again.

```bash
$ terraform validate 

Error: Argument or block definition required

  on tf-example.tf line 20, in resource "aws_s3_bucket" "tf-s3":

An argument or block definition is required here.

$ terraform validate 

Error: Unsupported argument

  on tf-example.tf line 9, in resource "aws_instance" "tf-example-ec2":
   9:     key_nam      = "mk"

An argument named "key_nam" is not expected here. Did you mean "key_name"?

$ terraform validate 
Success! The configuration is valid.
```

- Go to `main.tf` file and copy the EC2 instance block and paste it. And Go to terminal and run the command `terraform validate`. After taking the errors correct them. Then run the command again.

```bash
$ terraform validate 
│ Error: Duplicate resource "aws_instance" configuration
│ 
│   on main.tf line 24:
│   24: resource "aws_instance" "tf-ec2" {
│ 
│ A aws_instance resource named "tf-ec2" was already declared at main.tf:15,1-33. Resource names must be unique per type in
│ each module.
```

- Go to `main.tf` file and delete the second EC2 instance.

### fmt command.

- Go to `main.tf` file and add random indentations. Then go to terminal and run the command `terraform fmt`. "terraform fmt" command reformat your configuration file in the standard style.

```bash
terraform fmt
```

- Now, show `main.tf` file. It was formatted again.

### terraform console

- Go to the terminal and run `terraform console`.This command provides an interactive command-line console for evaluating and experimenting with expressions. This is useful for testing interpolations before using them in configurations, and for interacting with any values currently saved in state. You can see the attributes of resources in tfstate file and check built in functions before you write in your configuration file. 

- Lets create a file under the terraform-aws directory and name it `cloud` and paste `hello devops engineers`.

```bash
echo "hello devops" > cloud
```

Run the following commands.

```bash
terraform console
> aws_instance.tf-ec2
> aws_instance.tf-ec2.private_ip
> min (1,2,3)
> lower("HELLO")
> file("${path.module}/cloud")
> aws_s3_bucket.tf-s3
> aws_s3_bucket.tf-s3.bucket
> exit or (ctrl+c)
```

### show command.

- Go to the terminal and run `terraform show`.

 You can see tfstate file or plan in the terminal. It is more readable than `terraform.tfstate`.

```bash
terraform show
```

### graph command.

- Go to the terminal and run `terraform graph`. It creates a visual graph of Terraform resources. The output of "terraform graph" command is in the DOT format, which can easily be converted to an image by making use of dot provided by GraphViz.

- Copy the output and paste it to the `https://dreampuf.github.io/GraphvizOnline`. Then display it. If you want to display this output in your local, you can download graphviz (`sudo yum install graphviz`) and take a `graph.svg` with the command `terraform graph | dot -Tsvg > graph.svg`.

```bash
terraform graph  #.dot formatinda cikti veriyor.
```

### output command.

- Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use.

- Now add the followings to the `main.tf` file.  Then run the commands `terraform apply or terraform refresh` and `terraform output`. `terraform output` command is used for reading an output from a state file. It reads an output variable from a Terraform state file and prints the value. With no additional arguments, output will display all the outputs for the (parent) root module.  If NAME is not specified, all outputs are printed.

```go
output "tf_example_public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf_example_s3_meta" {
  value = aws_s3_bucket.tf-s3.region
}
```

```bash
terraform apply
terraform output
terraform output -json
terraform output tf_example_public_ip
```

### terraform apply -refresh-only command.

- The `terraform apply -refresh-only` command is used to update the state file with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to update the state file. First, check the current state of your resources with `terraform state list`. Then go to the AWS console and delete your S3 bucket `oliver-tf-test-bucket-addwhateveryouwant`. Display the state list again and refresh the state. Run the following commands.

```bash
$ terraform state list
aws_instance.tf-example-ec2
aws_s3_bucket.tf-example-s3

$ terraform apply -refresh-only

$ terraform state list
aws_instance.tf-example-ec2
```

- Now, you can see the differences between files `terraform.tfstate` and `terraform.tfstate.backup`. From tfstate file S3 bucket is deleted but in backup file you can see the S3 bucket.

- Run terraform apply -auto-approve and create S3 bucket again.

```bash
terraform apply -auto-approve
```

> ### Notes: 
> - `terraform refresh` command is deprecated, because its default behavior is unsafe if you have misconfigured credentials for any of your providers. 
> - It is not recommend using it because it provides no opportunity to review the effects of the operation before updating the state. 
> - You shouldn't typically need to use this command, because Terraform automatically performs the same refreshing actions as a part of creating a plan in both the `terraform plan` and `terraform apply` commands.
> - Use `terraform apply -refresh-only` command instead of it.

-  Go to the `main.tf` file and make the changes. We will change the ami id with the Ubuntu instance. Also change the value of EC2 instance tag and name of the S3 bucket.

```go
resource "aws_instance" "tf-ec2" {
    # ami           = "ami-0742b4e673072066f"
    ami           = "ami-042e8287309f5df03"
    instance_type = "t2.micro" 
    key_name      = "mk"    #<pem file>
    tags = {
      # Name = "tf-ec2"
      Name = "tf-ec2-ubuntu"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = "oliver-tf-bucket-addwhateveryouwant-new"
  #bucket = "oliver-tf-bucket-addwhateveryouwant"
}
```

- Run the command `terraform apply` and check the AWS console, the old S3 bucket and EC2 were destroyed and terraform created new ones.

```bash
terraform apply
```

- Make the new changes in the `main.tf` file.

```go
output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}
```

- Run the command `terraform apply -refresh=false`.

```bash
$ terraform apply -refresh=false

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:

Terraform will perform the following actions:

Plan: 0 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + tf_example_private_ip = "172.31.22.95"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

```bash
terraform destroy
```