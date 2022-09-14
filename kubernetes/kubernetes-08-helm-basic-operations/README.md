# Hands-on Kubernetes-08: Helm Basics

The purpose of this hands-on training is to give students the knowledge of basic operations of Helm.

## Learning Outcomes

At the end of this hands-on training, students will be able to;

- Learn basic operations of Helm

- Learn how to create Helm Chart

- Learn how to use AWS S3 as helm repo

## Outline

- Part 1 - Setting up the Kubernetes Cluster

- Part 2 - Basic Operations with Helm

- Part 3 - Creating Helm chart

- Part 4 - The Chart Repository

- Part 5 - Set up a Helm v3 chart repository in Github

## Part 1 - Setting up the Kubernetes Cluster

- Launch a Kubernetes Cluster of Ubuntu 20.04 with two nodes (one master, one worker) using the [Cloudformation Template to Create Kubernetes Cluster](../kubernetes-02-basic-operations/cfn-template-to-create-k8s-cluster.yml). *Note: Once the master node is up and running, the worker node automatically joins the cluster.*

>*Note: If you have a problem with the Kubernetes cluster, you can use this link for the lesson.*
>https://www.katacoda.com/courses/kubernetes/playground

- Check if Kubernetes is running and nodes are ready.

```bash
kubectl cluster-info
kubectl get node
```

## Part 2 - Basic Operations with Helm

### [Three Big Concepts](https://helm.sh/docs/intro/using_helm/)

- A `Chart` is a Helm package. It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster. Think of it like the Kubernetes equivalent of a Homebrew formula, an Apt dpkg, or a Yum RPM file.

- A `Repository` is the place where charts can be collected and shared. It's like Perl's CPAN archive or the Fedora Package Database, but for Kubernetes packages.

- A `Release` is an instance of a chart running in a Kubernetes cluster. One chart can often be installed many times into the same cluster. And each time it is installed, a new release is created. Consider a MySQL chart. If we want two databases running in your cluster, we can install that chart twice. Each one will have its own release, which will in turn have its own release name.

- With these concepts in mind, we can now explain Helm like this:

**Helm installs charts into Kubernetes, creating a new release for each installation. And to find new charts, we can search Helm chart repositories.**

* Install Helm [version 3+](https://github.com/helm/helm/releases) on Jenkins Server. [Introduction to Helm](https://helm.sh/docs/intro/). [Helm Installation](https://helm.sh/docs/intro/install/).

```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
```

### helm search: Finding Charts

- Helm comes with a powerful search command. It can be used to search two different types of sources:

- `helm search hub` searches the Artifact Hub, which lists helm charts from dozens of different repositories.

- `helm search repo` searches the repositories that we have added to your local helm client (with helm repo add). This search is done over local data, and no public network connection is needed.

- We can find publicly available charts by running helm search hub:

```bash
helm search hub
```

- Searches for all wordpress charts on Artifact Hub.

```bash
helm search hub wordpress
```

- We can add the repository using the following command.

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

- Using helm search repo, we can find the names of the charts in repositories we have already added:

```bash
helm search repo bitnami
```

- If you want to download and look at the files for a published chart, without installing it, you can do so with `helm pull chartrepo/chartname`.

```bash
helm pull bitnami/mysql
tar -xvf mysql-*.tgz
```

- Type the `helm install command` to install a chart.

```bash
helm repo update
helm install mysql-release bitnami/mysql
```

- We get a simple idea of the features of this MySQL chart by running `helm show chart bitnami/mysql`. Or we could run `helm show all bitnami/mysql` to get all information about the chart.

```bash
helm show chart bitnami/mysql
helm show all bitnami/mysql
```

- Whenever we install a chart, a new release is created. So one chart can be installed multiple times into the same cluster. And each can be independently managed and upgraded.

- Install a new release with bitnami/wordpress chart.

```bash
helm install my-release \
  --set wordpressUsername=admin \
  --set wordpressPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    bitnami/wordpress
```

- It's easy to see what has been released using Helm.

```bash
helm list
```

- Uninstall a release.

```bash
helm uninstall my-release
helm uninstall mysql-release
```

## Part 3 - Creating Helm chart

- Create a new chart with following command.

```bash
helm create clarus-chart
```

- See the files of clarus-chart.

```bash
ls clarus-chart
```

- Remove the files from `templates` folder.

```bash
rm -rf clarus-chart/templates/*
```

- Create a `configmap.yaml` file under `clarus-chart/templates` folder with following content.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: clarus-chart-config
data:
  myvalue: "Hello World"
```

- Install the clarus-chart.

```bash
helm install helm-demo clarus-chart
```

- The output is similar to:

```bash
NAME: helm-demo
LAST DEPLOYED: Mon Dec  6 11:39:46 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

- List the releases.

```bash
helm ls
```

- Let's see the configmap.

```bash
kubectl get cm
kubectl describe cm clarus-chart-config
```

- Remove the release.

```bash
helm uninstall helm-demo
```

- Let's create our own values and use it within the template. Update the `clarus-chart/values.yaml` as below.

```yaml
course: DevOps
```

- Edit the clarus-chart/templates/configmap.yaml as below.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: clarus-chart-config
data:
  myvalue: "clarus-chart configmap example"
  course: {{ .Values.course }}
``` 

- Let's see how the values are getting substituted with the `dry-run` option.

```bash
helm install --debug --dry-run mydryrun clarus-chart
```

- Install the clarus-chart.

```bash
helm install myvalue clarus-chart
```

- Check the values that got deployed with the following command.

```bash
helm get manifest myvalue
```

- Remove the release.

```bash
helm uninstall myvalue
```

- Let's change the default value from the values.yaml file when the release is getting released.

```bash
helm install --debug --dry-run setflag clarus-chart --set course=AWS
```

### Predefined Values

- Values that are supplied via a values.yaml file (or via the --set flag) are accessible from the .Values object in a template. But there are other pre-defined pieces of data you can access in your templates. For example:

  - Release.Name: The name of the release (not the chart)
  - Release.Namespace: The namespace the chart was released to.

- These values are pre-defined, are available to every template, and cannot be overridden. As with all values, the names are case sensitive.

- Edit the clarus-chart/templates/configmap.yaml as below.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
data:
  myvalue: "clarus-chart configmap example"
  course: {{ .Values.course }}
``` 

- Let's see how the values are getting substituted with the `dry-run` option.

```bash
helm install --debug --dry-run builtin-object clarus-chart
```

- Let's try more examples to get more clarity. Update the `clarus-chart/values.yaml` as below.

```yaml
course: DevOps
lesson:
  topic: helm
```

- So far, we've seen how to place information into a template. But that information is placed into the template unmodified. Sometimes we want to transform the supplied data in a way that makes it more useful to us.

- Helm has over 60 available functions. Some of them are defined by the [Go template language](https://pkg.go.dev/text/template) itself. Most of the others are part of the [Sprig template](https://masterminds.github.io/sprig/) library. Let's see some functions.

- Update the `clarus-chart/templates/configmap.yaml` as below.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
data:
  myvalue: "clarus-chart configmap example"
  course: {{ quote .Values.course }}
  topic: {{ upper .Values.lesson.topic }}
  time: {{ now | date "2006.01.02" | quote }} 
```

 Let's see how the values are getting substituted with the `dry-run` option.

```bash
helm install --debug --dry-run morevalues clarus-chart
```

- **now** function shows the current date/time.

- **date** function formats a date.

### Helm Notes:

- In this part, we are going to look at Helm's tool for providing instructions to your chart users. At the end of a `helm install` or `helm upgrade`, Helm can print out a block of helpful information for users. This information is highly customizable using templates.

- To add installation notes to your chart, simply create a `clarus-chart/NOTES.txt` file. This file is plain text, but it is processed like a template and has all the normal template functions and objects available.

- Let's create a simple `NOTES.txt` file under `clarus-chart/templates` folder.

```txt
Thank you for installing {{ .Chart.Name }}.

Your release is named {{ .Release.Name }}.

To learn more about the release, try:

  $ helm status {{ .Release.Name }}
  $ helm get all {{ .Release.Name }}
```

- Let's run our helm chart.

```bash
helm install notes-demo clarus-chart
```

- Using NOTES.txt this way is a great way to give your users detailed information about how to use their newly installed chart. Creating a NOTES.txt file is strongly recommended, though it is not required.

- Remove the release.

```bash
helm uninstall notes-demo
```
