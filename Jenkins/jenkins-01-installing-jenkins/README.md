# Hands-on Jenkins-01 : Installing Jenkins on Amazon Linux 2 EC2 Instance

Purpose of the this hands-on training is to learn how to install Jenkins Server on Amazon Linux 2 EC2 instance and build simple jobs.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install and configure Jenkins Server on Amazon Linux 2 EC2 instance using `yum` repo.

- install plugins

- create view

- create simple Free Style jobs

- create simple Pipeline jobs

- create simple Pipeline with jenkinsfile


## Outline

- Part 1 - Installing Jenkins Server on Amazon Linux 2 with `yum` Repo

- Part 2 - Getting familiar with Jenkins Dashboard

- Part 3 - Installing Plugins

- Part 4 - Creating a view

- Part 5 - Creating First Jenkins Job

- Part 6 - Creating a Simple Pipeline with Jenkins

- Part 7 - Creating a Jenkins Pipeline with Jenkinsfile

## Part 1 - Installing Jenkins Server on Amazon Linux 2 with `yum` Repo

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH and TCP 8080 ports.

- Connect to the instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Install `Java 11 openjdk` Java Development Kit.

```bash
sudo amazon-linux-extras install java-openjdk11 -y
```

- Check the java version.

```bash
java -version
```

- Install Git

```bash
sudo yum install git -y
```

- Add Jenkins repo to the `yum` repository.

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
```

- Import a key file from Jenkins-CI to enable installation from the package.

```bash
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
```

- Enable the EPEL repository for Amazon EC2 instance.

```bash
sudo amazon-linux-extras install epel -y
```

- Install Jenkins.

```bash
sudo yum install jenkins -y
```

- Start Jenkins service.

```bash
sudo systemctl start jenkins
```

- Enable Jenkins service so that Jenkins service can restart automatically after reboots.

```bash
sudo systemctl enable jenkins
```

- Check if the Jenkins service is up and running.

```bash
sudo systemctl status jenkins
```

- Get the initial administrative password.

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
- Open your browser, get your ec2 instance Public IPv4 DNS and paste it at address bar with 8080. 
"http://[ec2-public-dns-name]:8080"

- Enter the temporary password to unlock the Jenkins.

- Install suggested plugins.

- Create first admin user (call-jenkins:Call-jenkins1234).

- Check the URL, then save and finish the installation.

## Part 2 - Getting familiar with Jenkins Dashboard

- Explain `Jenkins` dashboard.

- Explain `Items` options.

- Explain `Manage Jenkins` dashboard.

- Explain other Jenkins terminology.

## Part 3 - Installing Plugins

- Follow `Manage Jenkins` -> `Manage Plugins` path and install the plugins (install without restart):

  -  `AnsiColor`
    
  -  `Copy Artifact`

  -  `Deploy to container`

## Part 4 - Creating a view

- Click `My Views` on the left menu items or click `+` on the jobs tabs.

- Select `New View`

- Give a name like `my view`

- Select `List View` option

- Select `OK` option


