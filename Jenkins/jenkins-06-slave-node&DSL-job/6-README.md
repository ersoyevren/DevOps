 # Hands-on Jenkins-06 : Slave Node Configuration and DSL Job

Purpose of the this hands-on training is to learn how to configure a slave node to Jenkins Server. 

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- configure a slave node

- run jobs on slave node.

- create job DSL

## Outline

- Part 1 - Slave Node Configuration

- Part 2 - Free Style Project on Slave Node

- Part 3 - Pipeline Project on Slave Node

- Part 4 - Jenkins Job DSL

## Part 1 - Slave Node Configuration

- Launch an instance on Amazon Linux 2 AMI with security group allowing SSH (port 22) as slave node.

- Connect to your instance with SSH.

- Install Java
  
```bash
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y
```

- Install Git
  
```bash
sudo yum install git -y
```

- **Configure ssh connection between master and slave nodes.**

- Go to the Jenkins Master server: 
  - Switch to "jenkins" user.

```bash
sudo su - jenkins -s /bin/bash
# bu kod ile jenkins in home directory ine geciyoruz.yani jenkins makinenin gozunden cli makineye geldik.
```

  - Generate a public and private key with keygen.

```bash
ssh-keygen
# burada bir tane key olusturuyoruz.
```
  - Press enter for every question to continue with default options. 

  - Check ".ssh" folder and see public(id_rsa.pub) and private keys(id_rsa). 

```bash
cd .ssh
ls
```
  - We need to copy public key to slave node.

```bash
cat id_rsa.pub
```
  - Select and copy all the codes in id_rsa.pub.

- Go to the /root/.ssh folder on the slave node instance.

```bash
sudo su
# sudo su ile agent makinede root kullaniciya geciyoruz. cunku controler agent root yetkisinde kullanacak.
cd /root/.ssh
# bu komut ile root un home direc. deki .ssh a geliyoruz.
```

- Open the "authorized_keys" file with an editor and paste the code that you copied from public key(id_rsa.pub). Save "authorized_keys" file.
# ls ile .ssh in altinda authorized_keys dosyasini goruyoruz. bunu editor ile aciyoruz. daha sonra controler jenkinsa gidip cat id_rsa.pub aciyoruz. icerigi kopyalayip agent taki vim ile actigimiz authorize_keys in bir alt satirina kopyaliyoruz.

- Get the slave node ip:

```bash
ifconfig
```
- Copy ip number.

- Go to the Jenkins Master server and test ssh connection.

```bash
ssh root@<slave-node-ip-number>
# jenkins uzerinden agent baglanacagimizi gorebiliyoruz. burada default olarak key var oldugu icin tekrar girmemize gerek yok.
exit
```

- **The second one is to copy agent file from Jenkins server to slave node.**

- Go to the "/root" folder on the slave node instance. Create a folder under "/root" and name it as "bin". Get agent file from Jenkins Master server.

```bash
mkdir bin
cd bin
wget http://<jenkins_master_ip>:8080/jnlpJars/slave.jar
# jenkins da bulunan slave.jar dosyasini agent e ekliyoruz.
```

- Go to Jenkins dashboard, click on "Manage Jenkins" from left hand menu.

- Select "Manage Nodes and Clouds"

- Click on "New Node" from left hand menu.

- Enter `SlaveNode-1` in "Node name" field and select `Permanent Agent`.

- Click `ok` button.

- Enter `This is a linux slave node for jenkins` in the description field.

- "Number of executors" is the maximum number of concurrent builds that Jenkins may perform on this node. Enter `2` in this field.

- An agent needs to have a directory dedicated to Jenkins. Specify the path to this directory on the agent. Enter `/usr/jenkins` in the "Remote root directory" field.

- Enter `Linux` in the "Labels" field.

- Select `Launch agent via execution of command on the master` from dropdown menu in the "Launch method" field.

- Enter `ssh -i /var/lib/jenkins/.ssh/<the_key_file> root@<slave_ip> java -jar /root/bin/slave.jar` in the "Launch command" field.
## ssh ile jenkinsin private key adresini yaziyoruz. daha sonra baglanacagimiz makinenin adresini yaziyoruz. son olarak da java -jar i belirtilen adresteki dosyayi calistirmasini istiyoruz.

- Select `Keep this agent online as much as possible` from dropdown menu in the "Availability" field.

- Click `Save`.

- Check the console logs in case of failure to launch agent node. If there is a approvement issue go to `Manage Jenkins`,  select the `In-process Script Approval`, `approve` the script.

- Go to Jenkins dashboard. Check master and slave nodes on the left hand menu. 

