# Hands-on Kubernetes-06 : Kubernetes Volumes 

Purpose of this hands-on training is to give students the knowledge of Kubernetes Volumes.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Explain the need for persistent data management.

- Learn `Persistent Volumes` and `Persistent Volume Claims`.

## Outline

- Part 1 - Setting up the Kubernetes Cluster

- Part 2 - Kubernetes Volume Persistence

- Part 3 - Binding PV to PVC

- Part 4 - EmptyDir

## Part 1 - Setting up the Kubernetes Cluster

- Launch a Kubernetes Cluster of Ubuntu 20.04 with two nodes (one master, one worker) using the [Cloudformation Template to Create Kubernetes Cluster](../kubernetes-02-basic-operations/cfn-template-to-create-k8s-cluster.yml). *Note: Once the master node up and running, worker node automatically joins the cluster.*

>*Note: If you have problem with kubernetes cluster, you can use this link for lesson.*
>https://www.katacoda.com/courses/kubernetes/playground

- Check if Kubernetes is running and nodes are ready.

```bash
kubectl cluster-info
kubectl get no
```

## Part 2 - Kubernetes Volume Persistence

- Get the documentation of `PersistentVolume` and its fields. Explain the volumes, types of volumes in Kubernetes and how it differs from the Docker volumes. [Volumes in Kubernetes](https://kubernetes.io/docs/concepts/storage/volumes/)

```bash
kubectl explain pv
```

- Log into the `kube-worker-1` node, create a `pv-data` directory under home folder, also create an `index.html` file with `Welcome to Kubernetes persistence volume lesson` text and note down path of the `pv-data` folder.

```bash
mkdir pv-data && cd pv-data
echo "Welcome to Kubernetes persistence volume lesson" > index.html
ls
pwd
/home/ubuntu/pv-data
```

- Log into `kube-master` node and create a folder named volume-lessons.

```bash
!!
```

- Create a `clarus-pv.yaml` file using the following content with the volume type of `hostPath` to build a `PersistentVolume` and explain fields.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: clarus-pv-vol
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

- Create the PersistentVolume `clarus-pv-vol`.

```bash
kubectl apply -f clarus-pv.yaml
```

- View information about the `PersistentVolume` and notice that the `PersistentVolume` has a `STATUS` of available which means it has not been bound yet to a `PersistentVolumeClaim`.

```bash
kubectl get pv clarus-pv-vol
```

- Get the documentation of `PersistentVolumeClaim` and its fields.

```bash
kubectl explain pvc
```

- Create a `clarus-pv-claim.yaml` file using the following content to create a `PersistentVolumeClaim` and explain fields.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: clarus-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

- Create the PersistentVolumeClaim `clarus-pv-claim`.

```bash
kubectl apply -f clarus-pv-claim.yaml
```

> After we create the PersistentVolumeClaim, the Kubernetes control plane looks for a PersistentVolume that satisfies the claim's requirements. If the control plane finds a suitable `PersistentVolume` with the same `StorageClass`, it binds the claim to the volume. Look for details at [Persistent Volumes and Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#introduction)

- View information about the `PersistentVolumeClaim` and show that the `PersistentVolumeClaim` is bound to your PersistentVolume `clarus-pv-vol`.

```bash
kubectl get pvc clarus-pv-claim
```

- View information about the `PersistentVolume` and show that the PersistentVolume `STATUS` changed from Available to `Bound`.

```bash
kubectl get pv clarus-pv-vol
```

- Create a `clarus-pod.yaml` file that uses your PersistentVolumeClaim as a volume using the following content.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: clarus-pod
  labels:
    app: clarus-web 
spec:
  volumes:
    - name: clarus-pv-storage
      persistentVolumeClaim:
        claimName: clarus-pv-claim
  containers:
    - name: clarus-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: clarus-pv-storage
```

- Create the Pod `clarus-pod`.

```bash
kubectl apply -f clarus-pod.yaml
```

- Verify that the Pod is running.

```bash
kubectl get pod clarus-pod
```

- Open a shell to the container running in your Pod.

```bash
kubectl exec -it clarus-pod -- /bin/bash
```

- Verify that `nginx` is serving the `index.html` file from the `hostPath` volume.

```bash
curl http://localhost/
# bu sekilde sanki internetten baglandik gibi kontrol edebiliyoruz.
```

- Log into the `kube-worker-1` node, change the `index.html`.

```bash
cd pv-data
echo "Kubernetes Rocks!!!!" > index.html
```

- Log into the `kube-master` node, check if the change is in effect.

```bash
kubectl exec -it clarus-pod -- /bin/bash
curl http://localhost/
```

- Expose the clarus-pod pod as a new Kubernetes service on master.

```bash
kubectl expose pod clarus-pod --port=80 --type=NodePort
#expose ile podu servise bagliyoruz.
```

- List the services.

```bash
kubectl get svc
```

- Check the browser (`http://<public-workerNode-ip>:<node-port>`) that clarus-pod is running.

- Delete the `Pod`, the `PersistentVolumeClaim` and the `PersistentVolume`.

```bash
kubectl delete pod clarus-pod
kubectl delete pvc clarus-pv-claim
kubectl delete pv clarus-pv-vol
```

