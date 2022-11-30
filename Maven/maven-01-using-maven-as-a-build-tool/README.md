# Hands-on Maven-01 : Using Maven As a Build Tool

Purpose of the this hands-on training is to teach the students how to use Maven with Java as a build tool.


## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install Maven and Java-11 on Amazon Linux 2 EC2 instance

- explain various build phases of a Java Application

- use Maven's clean, compile, package, install and site commands


## Outline

- Part 1 - Launch Amazon Linux 2 EC2 Instance with Cloudformation Template

- Part 2 - Generate a Java application using Maven's Archetype Plugin

- Part 3 - Run Maven Commands


## Part 1 - Launch Amazon Linux 2 EC2 Instance and Connect with SSH

- Launch an EC2 instance using ```maven-java-template.yml``` file located in this folder.
    - This template will create an EC2 instance with Java-11 and Maven.

- Connect to your instance with SSH.

- Check if you can see the Maven's binary directory under ```/home/ec2-user/```.

- Run the command below to check if Java is available.

```bash
java -version
```

- Cat ```~/.bash_profile``` file to check if Maven's path is correctly transferred. If not paste the necessary lines manually.

```
# Append the lines below into ~/.bash_profile file by making necessary changes.
M2_HOME=/home/ec2-user/<apache-maven-directory-with-its-version>
export PATH=$PATH:$M2_HOME/bin
```

- Run the command below to check if mvn commands are available.

```bash
mvn --version
```

- If not, run the command below and wait for the EC2 machine to get ready.

```bash
sudo reboot
```


## Part 2 - Generate a Java application using Maven's Archetype Plugin

- Run the command below to produce an outline of a Java project with Maven.

```bash
mvn archetype:generate -DgroupId=com.clarus.maven -DartifactId=maven-experiment -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

- Cd into the project folder.

- Run the command below to be able to use tree command.

```bash
sudo yum install -y tree
```

- Run the command below to show the directory structure of the project.

```bash
tree
```

- Go into the folder where App.java resides and ```cat``` the auto generated ```hello world``` application in Java.

- Replace the content of the App.java file with the content of the App.java file in this repo.

- Go into the project's root folder.

- Replace the content of the ```pom.xml``` file with the content of the pom.xml file in this repo.

- Since we've install Java-11 on the EC2 machine, uncomment the ```properties``` tag of the new pom.xml file.

- Explain that the ```maven.compiler.source``` property specifies the version of source code accepted and the ```maven.compiler.target``` generates class files compatible with the specified version of JVM.

- Explain that ```dependencyManagement``` section in the pom file will import multiple dependencies with compatible versions.  


