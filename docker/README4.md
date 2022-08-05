# Hands-on Docker-04 : Docker Networking

Purpose of the this hands-on training is to give the student understanding to networking in Docker.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- list available networks in Docker.

- create a network in Docker.

- inspect properties of a network in Docker.

- connect a container to a network.

- explain default network bridge configuration.

- configure user-defined network bridge.

- ping containers within same network.

- can bind containers to specific ports.

- delete Docker networks.

## Outline

- Part 1 - Launch a Docker Machine Instance and Connect with SSH

- Part 2 - Default Network Bridge in Docker

- Part 3 - User-defined Network Bridge in Docker

- Part 4 - Container Networking

## Part 1 - Launch a Docker Machine Instance and Connect with SSH

- Launch a Docker machine on Amazon Linux 2 AMI with security group allowing SSH connections using the [Cloudformation Template for Docker Machine Installation](../docker-01-installing-on-ec2-linux2/docker-installation-template.yml).

- Connect to your instance with SSH.

```bash
ssh -i .ssh/call-training.pem ec2-user@ec2-3-133-106-98.us-east-2.compute.amazonaws.com
```

## Part 2 - Default Network Bridge in Docker

- Check if the docker service is up and running.

```bash
systemctl status docker
```

- List all networks available in Docker, and explain types of networks.

```bash
docker network ls
```

- Run two `alpine` containers with interactive shell, in detached mode, name the container as `clarus1st` and `clarus2nd`, and add command to run alpine shell. Here, explain what the detached mode means.

```bash
docker container run -dit --name clarus1st alpine ash
docker container run -dit --name clarus2nd alpine ash
```
```bash
#-dit container exit edilince arka tarafta calismaya devam ediyor.
```
- Show the list of running containers on Docker machine.

```bash
docker ps
```

- Show the details of `bridge` network, and explain properties (subnet, ips) and why containers are in the default network bridge.

```bash
docker network inspect bridge | less
```

- Get the IP of `clarus2st` container.

```bash
docker container inspect clarus2nd | grep IPAddress
```
```bash
#grep IPAddress komutu ile clarus2nd containerin da ip adresini ariyor.
```
- Connect to the `clarus1st` container.

```bash
docker container attach clarus1st
```

- Show the details of network interface configuration of `clarus1st` container.

```bash
ifconfig
```

- Open an other terminal and connect your ec2 instance. Show the details of network interface configuration of ec2 instance.

```bash
ifconfig
```

- Compare with two configurations.

- In the `clarus1st` container ping google.com four times to check internet connection.

```bash
ping -c 4 google.com
```

- Ping `clarus2nd`container by its IP four times to show the connection.

```bash
ping -c 4 172.17.0.3
```

- Try to ping `clarus2nd`container by its name, should face with bad address. Explain why failed (due to default bridge configuration not works with container names)

```bash
ping -c 4 clarus2nd
```

- Disconnect from `clarus1st` without stopping it (CTRL + p + q).

- Stop and delete the containers

```bash
docker container stop clarus1st clarus2nd
docker container rm clarus1st clarus2nd
```

