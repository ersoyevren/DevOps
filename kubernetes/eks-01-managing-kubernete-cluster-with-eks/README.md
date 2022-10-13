b # Hands-on EKS-01 : Creating and Managing Kubernetes Cluster with AWS EKS

Purpose of this hands-on training is to give students the knowledge of how to use AWS Elastic Kubernetes Service


## Learning Outcomes

At the end of this hands-on training, students will be able to;

- Learn to Create and Manage EKS Cluster with Worker Nodes

## Outline

- Part 1 - Creating the Kubernetes Cluster on EKS

- Part 2 - Creating a kubeconfig file

- Part 3 - Adding Worker Nodes to the Cluster

- Part 4 - Configuring Cluster Autoscaler

- Part 5 - Deploying a Sample Application

## Prerequisites

- Launch an AWS EC2 instance of Amazon Linux 2 AMI with security group allowing SSH.

- Connect to the instance with SSH.

- Update the installed packages and package cache on your instance.

```bash
sudo yum update -y
```

- Download the Amazon EKS vended kubectl binary.

```bash
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
```

- Apply execute permissions to the binary.

```bash
chmod +x ./kubectl
```

- Copy the binary to a folder in your PATH. If you have already installed a version of kubectl, then we recommend creating a $HOME/bin/kubectl and ensuring that $HOME/bin comes first in your $PATH.

```bash
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
#kubectl kopyaladik daha sonra da pathe ekledik.
```

- (Optional) Add the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.

```bash
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
#makineyi tekrar run ettigimizde usteki komutu girmemize gerek kalmiyor.
```

- After you install kubectl , you can verify its version with the following command:

```bash
kubectl version --short --client
```

- Configure AWS credentials. Or you can attach `AWS IAM Role` to your EC2 instance.

```bash
aws configure
```

- aws configuration

```bash
$ aws configure
  AWS Access Key ID [None]: xxxxxxx
  AWS Secret Access Key [None]: xxxxxxxx
  Default region name [None]: us-east-1
  Default output format [None]: json
  #bunlari nasil olusturuyorduk.
```

- Verify that you can see your cluster listed, when authenticated

```bash
$ aws eks list-clusters
{
  "clusters": []
}
```

## Part 1 - Creating the Kubernetes Cluster on EKS

1. Direct the students to AWS EKS Service webpage. 

2. Give general description about the page and *****the pricing***** of the services.

- https://aws.amazon.com/eks/pricing/

3. Select ```Cluster``` on the left-hand menu and click on "Create cluster" button. You will be directed to the ```Configure cluster``` page:

    - Give general descriptions about the page and the steps of creating the cluster.

    - Fill the ```Name``` and ```Kubernetes version``` fields. (Ex: MyCluster, 1.21)

        <i>Mention the durations for minor version support and the approximate release frequency.</i>

    - On the ```Cluster Service Role``` field; give general description about why we need this role. 

    - Create EKS Cluster Role with ```EKS - Cluster``` use case and ```AmazonEKSClusterPolicy```.
                
        - EKS Cluster Role :                                                                                              
           - use case   :  ```EKS - Cluster``` 
           - permissions: ```AmazonEKSClusterPolicy```.

    - Select the recently created role, back on the ```Cluster Service Role``` field.

    - Proceed to the ```Secrets Encryption``` field. 
    
    - Activate the field, give general description about ```KMS Service``` and describe where we use those keys and give an example about a possible key.

    - Deactivate back the ```Secrets Encryption``` field and keep it as is.

    - Proceed to the next step (Specify Networking).

4. On the ```Specify Networking``` page's ```Networking field```:

    - Select the default VPC and all public subnets.

        <i>Explain the necessity of using dedicated VPC for the cluster.</i>

    - Select default VPC security or create one with SSH connection and https. 

        <i>Explain the necessity of using dedicated Securitygroup for the cluster.</i>

    - Proceed to ```Cluster Endpoint Access``` field.

    - Give general description about the options on the field.

    - Explain ```Advanced Settings```.

    - Select ```Public and Private``` option on the field.

    - Proceed to the next step (Configure Logging).

5. On the ```Configure Logging``` page:

    - Give general descriptions about the logging options.

    - Proceed to the final step (Review and create).

6. On the ```Review and create``` page:

    - Create the cluster.


## Part 2 - Creating a kubeconfig file

1. Give general descriptions about what ```config file``` is.

2. Verify that you can see your cluster listed, when authenticated

```bash
$ aws eks list-clusters
{
  "clusters": [
    "my-cluster"
  ]
}
```

3. Show the content of the $HOME directory including hidden files and folders. If there is a ```.kube``` directory, show what it has inside.  

4. Run the command
```bash
aws eks --region <us-east-1> update-kubeconfig --name <cluster_name>
``` 

5. Explain what the above command does.

6. Then run the command on your terminal
```bash
kubectl get svc
```
You should see the output below
```bash
NAME             TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
svc/kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   1m
```
7. Run the command below to show that there is no node for now.
```bash
kubectl get node
```
8. Show again the content of the $HOME directory including hidden files and folders. Find the ```config``` file inside ```.kube``` directory. Then show the content of the file.


