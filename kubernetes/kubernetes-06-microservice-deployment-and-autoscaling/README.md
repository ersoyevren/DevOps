# Hands-on Kubernetes-04 : Deploying Microservices and Service Level Autoscaling

Purpose of the this hands-on training is to give students the knowledge of  Autoscaling and Microservices

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Understand deployment and management of microservices

- Explain the Kubernetes Autoscaling

- Explain Horizontal Pod Autoscaler Business Logic

- Understand the Need for Metric Server

## Outline

- Part 1 - Setting up the Kubernetes Cluster

- Part 2 - Outline of the Hands-on Setup

- Part 3 - Microservices

- Part 4 - Autoscaling in Kubernetes

## Part 1 - Setting up the Kubernetes Cluster

- Launch a Kubernetes Cluster of Ubuntu 20.04 with two nodes (one master, one worker) using the [Cloudformation Template to Create Kubernetes Cluster](../kubernetes-02-basic-operations/cfn-template-to-create-k8s-cluster.yml). *Note: Once the master node up and running, worker node automatically joins the cluster.*

>*Note: If you have problem with kubernetes cluster, you can use this link for lesson.*
>https://www.katacoda.com/courses/kubernetes/playground

- Check if Kubernetes is running and nodes are ready.

```bash
kubectl cluster-info
kubectl get no
```

## Part 2 - Outline of the Hands-on Setup

In this study, we will present an application that contains 2 unrelated sub-application. 

- First one is simple web&database application to hold the to-do-lists. This sub-application uses MongoDB to store to-do lists created through the web application. For the front-end web application layer, Node.JS is used. Thus, this sub-aplication has 2 microservices.
  
- Second one is used to demonstrate Horizontal Pod Autoscaler fuctionality based on the php-apache image.

- Create a `microservices` directory and `to-do` directory in the microservices directory and change directory.

```bash
mkdir microservices
cd microservices
mkdir to-do
cd to-do
```

### Steps of execution:

1. We will deploy the `to-do` app first and look at some key points.
2. And then deploy the `php-apache` app and highligts some important points.
3. The Autoscaling in Kubernetes will be  demonstrated as a last step.

## Part 3 - Microservices

- The MongoDB application will use a static volume provisioning with the help of persistent volume (PV) and persistent volume claim (PVC). 

- Create a `db-pv.yaml` file.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: db-pv-vol
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/home/ubuntu/pv-data"
```

- Create a `db-pvc.yaml` file.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-persistent-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 1Gi
```

- It will provision storage from `hostpath`.

- Let's create the MongoDB deployment yaml file (name it `db-deployment.yaml`) to see how the PVC is used. 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: db-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      name: mongo
  template:
    metadata:
      labels:
        name: mongo
        app: todoapp
    spec:
      containers:
      - image: mongo
        name: mongo
        ports:
        - containerPort: 27017
        volumeMounts:
          - name: mongo-storage
            mountPath: /data/db
      volumes:
        #- name: mongo-storage
        #  hostPath:
        #    path: /home/ubuntu/pv-data
        - name: mongo-storage
          persistentVolumeClaim:
            claimName: database-persistent-volume-claim
```

- The commented part directly uses the local hostpath for storage. Students can try it on their own later.

- Let's create the MongoDB `service` and name it `db-service.yaml`.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: db-service
  labels:
    name: mongo
    app: todoapp
spec:
  selector:
    name: mongo
  type: ClusterIP
  ports:
    - name: db
      port: 27017
      targetPort: 27017
```

- Note that a database has no direct exposure the outside world, so it's type is `ClusterIP`.

- Now, create the `web-deployment.yaml` for web application.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      name: web
  template:
    metadata:
      labels:
        name: web
        app: todoapp
    spec:
      containers: 
        - image: clarusway/todo
          imagePullPolicy: Always
          name: myweb
          ports: 
            - containerPort: 3000
          env:
            - name: "DBHOST"
              value: db-service
          resources:
            limits:
              memory: 500Mi
              cpu: 100m
            requests:
              memory: 250Mi
              cpu: 80m		  
```
- Note that this web app is connnected to MongoDB host/service via the `DBHOST` environment variable. What does `db-service:27017` mean here. How is the IP resolution handled?

- When should we use `imagePullPolicy: Always`. Explain the `image` pull policy shortly.

- This time, we create the `web-service.yaml` for front-end web application `service`.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
  labels:
    name: web
    app: todoapp
spec:
  selector:
    name: web 
  type: NodePort
  ports:
   - name: http
     port: 3000
     targetPort: 3000
     nodePort: 30001
     protocol: TCP

```

- What should be the type of the service? ClusterIP, NodePort or LoadBalancer?

- Let's deploy the to-do application.

```bash
cd ..
kubectl apply -f to-do
deployment.apps/db-deployment created
persistentvolume/db-pv-vol created
persistentvolumeclaim/database-persistent-volume-claim created
service/db-service created
deployment.apps/web-deployment created
service/web-service created
```
Note that we can use `directory` with `kubectl apply -f` command.

Check the persistent-volume and persistent-volume-claim.

```bash
$ kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                      STORAGECLASS   REASON   AGE
db-pv-vol   5Gi        RWO            Retain           Bound    default/database-persistent-volume-claim   manual                  23s

$ kubectl get pvc
NAME                               STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
database-persistent-volume-claim   Bound    db-pv-vol   5Gi        RWO            manual         56s
```

Check the pods.
```bash
$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
db-deployment-8597967796-q7x5s    1/1     Running   0          4m30s
web-deployment-658cc55dc8-2h2zc   1/1     Running   2          4m30s
```

Check the services.
```bash
$ kubectl get svc
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db-service    ClusterIP   10.105.0.75     <none>        27017/TCP        4m39s
kubernetes    ClusterIP   10.96.0.1       <none>        443/TCP          2d8h
web-service   NodePort    10.107.136.54   <none>        3000:30001/TCP   4m38s
```

- Note the `PORT(S)` difference between `db-service` and `web-service`. Why?

- We can visit http://<public-node-ip>:<node-port> and access the application. Note: Do not forget to open the Port <node-port> in the security group of your node instance.

- We see the home page. You can add to-do's.

### Deploy the second aplication

- Create a `php-apache` directory and change directory.

```bash
$ pwd
/home/ubuntu/microservices
```

```bash
mkdir php-apache
cd php-apache
```

- Create a `php-apache.yaml` file for second application.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  selector:
    matchLabels:
      run: php-apache
  replicas: 1
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
      - name: php-apache
        image: k8s.gcr.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: 500Mi
            cpu: 100m
          requests:
            memory: 250Mi
            cpu: 80m
---
apiVersion: v1
kind: Service
metadata:
  name: php-apache-service
  labels:
    run: php-apache
spec:
  ports:
  - port: 80
    nodePort: 30002
  selector:
    run: php-apache 
  type: NodePort	
```

Note how the `Deployment` and `Service` `yaml` files are merged in one file. 

Deploy this `php-apache` file.

```bash
$ kubectl apply -f . 
deployment.apps/php-apache created
service/php-apache-service created
```

Get the pods.
```bash
$ kubectl get po
NAME                              READY   STATUS    RESTARTS   AGE
db-deployment-8597967796-q7x5s    1/1     Running   0          17m
php-apache-7869bd4fb-xsvnh        1/1     Running   0          24s
web-deployment-658cc55dc8-2h2zc   1/1     Running   2          17m
```

Get the services.
```bash
$ kubectl get svc
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
db-service           ClusterIP   10.105.0.75     <none>        27017/TCP        17m
kubernetes           ClusterIP   10.96.0.1       <none>        443/TCP          2d9h
php-apache-service   NodePort    10.101.242.84   <none>        80:30002/TCP     35s
web-service          NodePort    10.107.136.54   <none>        3000:30001/TCP   17m
```

- Let's check what web app presents us.

- On opening browser (http://<public-node-ip>:<node-port>) we see

```text
OK!
```

- Alternatively, you can use;
```text
curl <public-worker node-ip>:<node-port>
OK!
```

- Do not forget to open the Port <node-port> in the security group of your node instance. 

