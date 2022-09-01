# Hands-on Ansible-03 : Using facts, vars, secrets and dynamic inventory

Purpose of the this hands-on training is to give students the knowledge of ansible facts gathering,  working with secret values and using dynamic inventory.

## Learning Outcomes

At the end of this hands-on training, students will be able to;

- Explain how and what facts gathering and how to use it in the playbook
- Learn how to deal with secret values with ansible-vault
- Explain what is dynamic inventory
- Explain how to use dynamic inventory with EC2 plugin.

## Outline

- Part 1 - Install Ansible

- Part 2 - Ansible Facts

- Part 3 - Working with sensitive data

- Part 4 - Working with dynamic inventory

## Part 1 - Install Ansible


- Spin-up 3 Amazon Linux 2 instances and name them as:
    1. control node
    2. node1 ----> (SSH PORT 22, HTTP PORT 80)
    3. node2 ----> (SSH PORT 22, HTTP PORT 80)


- Connect to the control node via SSH and run the following commands.

```bash
sudo yum update -y
sudo amazon-linux-extras install ansible2
```

### Confirm Installation

- To confirm the successful installation of Ansible, run the following command.

```bash
$ ansible --version
```
Stdout:
```
ansible 2.9.12
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/ec2-user/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.18 (default, Aug 27 2020, 21:22:52) [GCC 7.3.1 20180712 (Red Hat 7.3.1-9)]
```
- Explain the lines above:
    1. Version Number of Ansible
    2. Path for the Ansible Config File
    3. Modules are searched in this order
    4. Ansible's Python Module path
    5. Ansible's executable file path
    6. Ansible's Python version with GNU Compiler Collection for Red Hat

### Configure Ansible on the Control Node

- Connect to the control node for building a basic inventory.

- Edit ```/etc/ansible/hosts``` file by appending the connection information of the remote systems to be managed.

- Along with the hands-on, public or private IPs can be used.

```bash
$ sudo su
$ cd /etc/ansible
$ ls
$ vim hosts
[webservers]
node1 ansible_host=<node1_ip> ansible_user=ec2-user

[dbservers]
node2 ansible_host=<node2_ip> ansible_user=ec2-user

[all:vars]
ansible_ssh_private_key_file=/home/ec2-user/<pem file>
```

- Explain what ```ansible_host```, ```ansible_user``` and ansible_ssh_key_file parameters are. For this reason visit the Ansible's [inventory parameters web site](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters).

- Explain what an ```alias``` (node1 and node2) is and where we use it.

- Explain what ```[webservers] and [all:vars]``` expressions are. Elaborate the concepts of [group name](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#inventory-basics-formats-hosts-and-groups), [group variables](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#assigning-a-variable-to-many-machines-group-variables) and [default groups](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#default-groups). 

- Visit the above links for helping to understand the subject. 

- Copy your pem file to the /home/ec2-user directory. First, go to your pem file directory on your local PC and run the following command.

```bash
$ scp -i <pem file> <pem file> ec2-user@<public DNS name of Control Node>:/home/ec2-user
```
- Check if the file is transferred to the remote machine. 

- As an alternative way, create a file on the control node with the same name as the <pem file> in ```/etc/ansible``` directory. 

- Then copy the content of the pem file and paste it in the newly created pem file on the control node.

- To make sure that all our hosts are reachable, we will run various ad-hoc commands that use the ping module.

```bash
$ chmod 400 <pem file>
```

```bash
$ ansible all -m ping -o
```
# ansible -m ping \!node1:\!node2 -o
# bu sekilde node 1 ve 2  haric diger hostlara ping atiyor. burada node1 ve 2 nin yerine grup adi da yazabilirdik.

## Part 2 - Ansible Facts

- Gathering Facts:

```bash
$ ansible node1 -m setup
ansible node1 -m gather_facts
# bu iki komut ayni islevi yapiyor. target node larin meta datasini (bilgilerini)gorebiliyoruz.
ansible node1 -m setup | grep ansible_os_family
#specifik bilgiye bu sekilde ulasabiliyorum.
```
```
ec2-34-201-69-79.compute-1.amazonaws.com | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.31.20.246"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::88c:37ff:fe8f:3b71"
        ],
        "ansible_apparmor": {
            "status": "disabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "08/24/2006",
        "ansible_bios_vendor": "Xen",
        "ansible_bios_version": "4.2.amazon",
        "ansible_board_asset_tag": "NA",
        "ansible_board_name": "NA",
        "ansible_board_serial": "NA",
```
- create a playbook named "facts.yml"

```yml
- name: show facts
  hosts: all
  tasks:
    - name: print facts
      debug:
        var: ansible_facts
# ?? debug yapilan islemleri cikti olarak terminale yazdirabiliyoruz?
var: ansible_facts bunun yerine msg:"{{ansible_fact}}" kullanabiliyoruz.
```
- run the play book

```bash
$ ansible-playbook facts.yml
```

- create a playbook named "ipaddress.yml"

```yml
- hosts: all
  tasks:
  - name: show IP address
    debug:
      msg: >
       This host uses IP address {{ ansible_facts.default_ipv4.address }}

```
- run the playbook

```bash
ansible-playbook ipaddress.yml 
```

