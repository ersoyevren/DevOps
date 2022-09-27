# Hands-on Kubernetes-12 : Kubernetes Pod Scheduling

The purpose of this hands-on training is to give students the knowledge of pod scheduling.

## Learning Outcomes

At the end of this hands-on training, students will be able to;

- Learn to schedule a pod to a specific node.

## Outline

- Part 1 - Setting up the Kubernetes Cluster

- Part 2 - Scheduling Pods

- Part 3 - nodeName

- Part 4 - nodeSelector

- Part 5 - Node Affinity  

- Part 6 - Taints and Tolerations

## Part 1 - Setting up the Kubernetes Cluster

- Launch a Kubernetes Cluster of Ubuntu 20.04 with two nodes (one master, one worker). 

>*Note: If you have a problem with the Kubernetes cluster, you can use this link for the lesson.*
>https://www.katacoda.com/courses/kubernetes/playground

- Check if Kubernetes is running and nodes are ready.

```bash
kubectl cluster-info
kubectl get no
```

## Part 2 - Scheduling Pods

- In Kubernetes, scheduling refers to making sure that Pods are matched to Nodes so that Kubelet can run them.

- A scheduler watches for newly created Pods that have no Node assigned. For every Pod that the scheduler discovers, the scheduler becomes responsible for finding the best Node for that Pod to run on.

- kube-scheduler is the default scheduler for Kubernetes and runs as part of the control plane.

- For every newly created pod or other unscheduled pods, kube-scheduler selects an optimal node for them to run on. However, every container in pods has different requirements for resources and every pod also has different requirements. Therefore, existing nodes need to be filtered according to the specific scheduling requirements.

- In a cluster, Nodes that meet the scheduling requirements for a Pod are called feasible nodes. If none of the nodes are suitable, the Pod remains unscheduled until the scheduler is able to place it.

- We can constrain a Pod so that it can only run on a particular set of Node(s). There are several ways to do this. Let's start with nodeName.

## Part 3 - nodeName

- For this lesson, we have two instances. The one is the controlplane and the other one is the worker node. As a practice, kube-scheduler doesn't assign a pod to a controlplane. Let's see this.

- Create yaml file named `clarus-deploy.yaml` and explain its fields.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    environment: dev
spec:
  replicas: 15
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

- Create the deployment with `kubectl apply` command.

```bash
kubectl apply -f clarus-deploy.yaml
```

- List the pods and notice that all pods are assigned to the master node.

```bash
kubectl get po -o wide
```

- Delete the deployment.

```bash
kubectl delete -f clarus-deploy.yaml 
```

- For this lesson, we need two worker nodes. Instead of creating an addition node, we will use the controlplane node as both the controlplane and worker node. So, we will arrange a controlplane with the following command.

```bash
kubectl taint nodes kube-master node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes kube-master node-role.kubernetes.io/control-plane:NoSchedule-
#  Masternode olan taint i kaldiriyor. Bu sekilde master nodumuza da po ekleyebiliyoruz. eger taint eklemek istiyorsak sadece sonundaki - isaretini kaldiriyoruz ve bu komutla ekleyebiliyoruz.
```

- Create the clarus-deploy again.

```bash
kubectl apply -f clarus-deploy.yaml
```

- List the pods and notice that pods are assigned to both the master node and worker node.

```bash
kubectl get po -o wide
```

- Delete the deployment.

```bash
kubectl delete -f clarus-deploy.yaml 
```

- `nodeName` is the simplest form of node selection constraint, but due to its limitations, it is typically not used. nodeName is a field of PodSpec. If it is non-empty, the scheduler ignores the pod and the kubelet running on the named node tries to run the pod. Thus, if nodeName is provided in the PodSpec, it takes precedence over the other methods for node selection.

- Some of the limitations of using nodeName to select nodes are:

  - If the named node does not exist, the pod will not be run, and in some cases may be automatically deleted.
  - If the named node does not have the resources to accommodate the pod, the pod will fail and its reason will indicate why, for example, OutOfmemory or OutOfcpu.
  - Node names in cloud environments are not always predictable or stable.

- Let's try this. First list the names of nodes.

```bash
kubectl get no
```

- Update the clarus-deploy.yaml as below.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    environment: dev
spec:
  replicas: 15
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
      nodeName: kube-master  #just add this line 
```
`nodename olarak son satirda oldugu gibi ekleme yapabiliyoruz. bu onerilen bir durum degil. fakat taint olsa bile bir node da bu sekilde istedigimiz node pod ekleyebiliyoruz.`
- Create the clarus-deploy again.

```bash
kubectl apply -f clarus-deploy.yaml
```

- List the pods and notice that the pods are assigned to the only worker node.

```bash
kubectl get po -o wide
```

- Delete the deployment.

```bash
kubectl delete -f clarus-deploy.yaml 
```

