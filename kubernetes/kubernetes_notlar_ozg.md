(https://github.com/aytitech/k8sfundamentals)

# 2. Neden Kubernetes öğrenmeniz gerekiyor?
## Neden Gerekli?


![image](https://user-images.githubusercontent.com/103413194/184480504-2fa58959-b8d6-410d-81e7-d989a4415fd9.png)

# 7. Container orchestration
Örnek üzerinden gidelim:
Birden fazla microservice’in çalıştığı bir docker environment’ı düşünelim. Her bir microservice bir docker container içerisinde çalıştığını ve uygulamamızı kullanıcılara açtığımızı düşünelim. Uygulamamız, şuan tek bir sunucu üzerinde koşuyor ve sunucu üzerinde güncelleme yaptığımızda sistemde kesintiler oluşmaya başlayacaktır.

Bu sorunumuzu çözmek adına, yeni bir sunucu kiralayıp, aynı docker environment’ını kurgulayıp (clonelayıp), bir de **load balancer** kurarak dağıtık bir mimariye geçiş yaptık. Buna rağmen, docker container’lar kendiliğinden kapanıyor ve bu duruma manuel müdahale etmemiz gerekir. Daha fazla trafik aldığımız için, 2 sunucu daha kiraladık. 2 sunucu daha, 2 sunucu daha..

Tüm bu sunucuları **manuel yönetmeye devam ediyoruz.** Zamanla DevOps süreçlerine manuel müdahaleden dolayı çok fazla zaman harcamaya başladık, geriye kalan işlere zaman kalmadı.

Peki bu durumu çözecek durum nedir? Cevap -> **Container Orchestration!**

Tüm sistem konfigürasyonlarını ayarlayıp, bu karar mekanizmasını bir orkestra şefine emanet edebiliriz. İşte bu şef **Kubernetes’tir!**

Diğer alternatifler -> Docker Swarm, Apache H2o

# 8. Kubernetes tarihçesi

* Google tarafından geliştirilen Orchestration sistemi.
* Google, çok uzun yıllardır Linux containerlar kullanıyor. Tüm bu containerları yönetmek için **Borg** adında bir platform geliştirmiş. Fakat, zamanla hatalar çıkmış ve yeni bir platform ihtiyacı duyulmuş ve **Omega** platformu geliştirilmiş.
* 2013 yılında 3 Google mühendisi open-source bir şekilde GitHub üzerinde Kubernetes reposunu açtı. _Kubernetes: Deniz dümencisi_ _(k8s)_
* 2014 senesinde proje, Google tarafından CNCF’e bağışlandı. (Cloud Native Computing Foundation)

# 9. Kubernetes nedir?

![image](https://user-images.githubusercontent.com/103413194/184481185-ad8ddc2f-9f47-4bc0-a262-0b373742d0dc.png)


* Declarative (_beyan temelli yapılandırma_), Container orchestration platformu.
* Proje, hiç bir şirkete bağlı değil, bir vakıf tarafından yönetilmektedir.
* Ücretsizdir. Rakip firmalarda **open-source**’dur.
* Bu kadar popüler olmasının sebebi, platformun tasarımı ve çözüm yaklaşımı.
* Semantic versioning izler (_x.y.z. -> x: major, y: minor, z: patch_) ve her 4 ayda bir minor version çıkartır.
* Her ay patch version yayınlar.
* Bir kubernetes platformu en fazla 1 yıl kullanılır, 1 yıldan sonra güncellemek gerekmektedir.

![image](https://user-images.githubusercontent.com/103413194/185373779-418bfaef-5059-4a97-a17d-8db62e2c5a53.png)

### Kubernetes Tasarımı ve Yaklaşımı

Birden fazla geliştirilebilir modüllerden oluşmaktadır. Bu modüllerin hepsinin bir görevi vardır ve tüm modüller kendi görevlerine odaklanır. İhtiyaç halinde bu modüller veya yeni modüller geliştirilebilir. (extendable)

K8s, “_Şunu yap, daha sonra şunu yap_” gibi adım adım ne yapmamız gerektiğini söylemek yerine _**(imperative yöntem);** “Ben şöyle bir şey istiyorum” **(declarative yöntem)**_ yaklaşımı sunmaktadır. **Nasıl yapılacağını tarif etmiyor, ne istediğimizi söylüyoruz.**

* Imperative yöntem, bize zaman kaybettirir, tüm adımları tasarlamak zorunda kalırız.
* Declarative yöntem’de ise sadece ne istediğimizi söylüyoruz ve sonuca bakıyoruz.

Kubernetes bize ondan istediğimizi soruyor, biz söylüyoruz ve bizim istediklerimizin dışına çıkmıyor. Örneğin, **Desired State (Deklara Edilen Durum - \_İstekler gibi düşünebiliriz**\_**)** şu şekilde olsun:

* Berksafran/k8s:latest isimli imaj yaratıp, 10 containerla çalıştır. Dış dünyaya 80 portunu aç ve ben bu service’e bir güncelleme geçtiğimde aynı anda 2 task üzerinde yürüt ve 10sn beklensin.

Kubernetes, 9 container çalışır durumda kalırsa hemen bir container daha ayağa kaldırır ve isteklerimize göre platformu **optimize eder.** Bu bizi, çok büyük bir işten kurtarıyor. _(Docker’da manuel olarak ayağa kaldırıyorduk, hatırlayın.)_

# 10. Kubernetes komponentleri - 1

K8s, **microservice mimarisi dikkate alınarak** oluşturulmuştur.

![image](https://user-images.githubusercontent.com/103413194/184483333-38e7d509-1fa2-411c-98f8-c54ad561add0.png)

![image](https://user-images.githubusercontent.com/103413194/185374477-782ceb4a-348f-4127-95ea-3c378765dd4c.png)

### **Control Plane** (Master Nodes)

Aşağıdaki, 4 component k8s yönetim kısmını oluşturur ve **master-node** üzerinde çalışır.

* **Master-node** -> Yönetim modullerinin çalıştığı yerdir.
* **Worker-node** -> İş yükünün çalıştığı yerdir.
* 
![image](https://user-images.githubusercontent.com/103413194/185374576-5c7a0c72-1657-45b4-b2c9-ea9b2adaa419.png)

![image](https://user-images.githubusercontent.com/103413194/185374611-6ced7136-d3c6-43d0-bcb2-c460e3152b09.png)

**Master-node**
* **kube-apiserver** **(api) –>** K8s’in beyni, **ana haberleşme merkezi, giriş noktasıdır**. Bir nev-i **Gateway** diyebiliriz. Tüm **componentler** ve **node**’lar, **kube-apiserver** üzerinden iletişim kurar. Ayrıca, dış dünya ile platform arasındaki iletişimi de **kube-apiserver** sağlar. Bu denli herkesle iletişim kurabilen **tek componenttir**. **Authentication ve Authorization** görevini üstlenir.
* **etcd** **->** K8s’in tüm cluster verisi, metada bilgileri ve Kubernetes platformunda oluşturulan componentlerin ve objelerin bilgileri burada tutulur. Bir nevi **Arşiv odası.** etcd, **key-value** şeklinde dataları tutar. Diğer componentler, etdc ile **direkt haberleşemezler.** Bu iletişimi, **kube-apiserver** aracılığıyla yaparlar.
* **kube-scheduler (sched) ->** K8s’i çalışma planlamasının yapıldığı yer. Yeni oluşturulan ya da bir node ataması yapılmamış Pod’ları izler ve üzerinde çalışacakları bir **node** seçer. (_Pod = container_) Bu seçimi yaparken, CPU, Ram vb. çeşitli parametreleri değerlendirir ve **bir seçme algoritması sayesinde pod için en uygun node’un hangisi olduğuna karar verir.**
* **kube-controller-manager (c-m) ->** K8s’in kontrollerinin yapıldığı yapıdır. **Mevcut durum ile istenilen durum arasında fark olup olmadığını denetler.** Örneğin; siz 3 cluster istediniz ve k8s bunu gerçekleştirdi. Fakat bir sorun oldu ve 2 container kaldı. kube-controller, burada devreye girer ve hemen bir cluster daha ayağa kaldırır. Tek bir binary olarak derlense de içerisinde bir çok controller barındırır:
  * Node Controller,
  * Job Controller,
  * Service Account & Token Controller,
  * Endpoints Controller.

### **Worker Nodes**

Containerlarımızın çalıştığı yerlerdir. Container veya Docker gibi container’lar çalıştırır. Her worker node’da **3 temel component** bulunur:

1. **Container runtime ->** Varsayılan olarak Docker’dır. Ama çeşitli sebeplerden dolayı **Docker’dan Containerd‘ye** geçmiştir. Docker ve containerd arasında fark yok nedebilecek kadar azdır. Hatta Docker kendi içerisinde de containerd kullanır. Diğer desteklenen container çeşidi **CRI-O’dur.**

3. **kubelet ->** API Server aracılığıyla etcd’yi kontrol eder ve sched tarafından bulunduğu node üzerinde çalışması gereken podları yaratır. Containerd’ye haber gönderir ve belirlenen özelliklerde bir container çalışmasını sağlar.

5. **kube-proxy ->** Nodelar üstünde ağ kurallarını ve trafik akışını yönetir. Pod’larla olan iletişime izin verir, izler.

Tüm bunların dışında GUI hizmeti sağlayan vb. pluginler de kurulmaktadır.

# 13. Kubectl kurulumu

Tüm komutlar, kube-apiserver üzerinden verilir. Bu komutlar 3 şekilde verilebilir:

1. **REST Api** aracılığıyla (terminalden curl olarak vb.),
2. **Kubernetes GUI** (Dashboard, Lens, Octant) üzerinden,
3. **Kubectl** aracılığıyla (CLI).

## Kubectl Kurulumu

* Homebrew ile aşağıdaki komutu yazıyoruz. (kubernetes.io’da farklı kurulumlar mevcut)

```
brew install kubectl
```

* Test için `kubectl version` yazabilirsiniz. (Server bağlantısı yapılmadığı için o kısımda hata alınabilir, normaldir.)

## Kubernetes Kurulumu

### Hangi version’u kuracağız?

* En light-weight version için -> **minikube**, **Docker Desktop (Single Node K8s Cluster)**
* Diğer seçenekler -> **kubeadm, kubespray**
* Cloud çözümler -> **Azure Kubernetes Service (AKS), Google Kubernetes Engine, Amazon EKS**

### Docker Desktop

* Docker Desktop, Single Node Kubernetes Cluster ayağa kaldırmaya imkan tanıyor. Bu durum, **başka bir araca duymadan Kubernetes üzerinde işlem yapabilme yeteneği kazandırıyor.** Ama tavsiye olarak **minikube kullanılmasıdır!**
* Docker Desktop içerisinde K8s kurulumu için, Settings > Kubernetes’e gidip install etmeniz gerekiyor.

### :large\_blue\_diamond: Minikube

* Bir çok addon ile gelebiliyor. Tek bir komut ile cluster’ı durdurup, çalıştırabiliyoruz.

```
brew install minikube
```

* **minikube kullanabilmek için sistemde Docker yüklü olması gerekiyor.** Çünkü, Minikube background’da Docker’ı kullanacaktır. VirtualBox gibi bir çok tool’u da background olarak kullanabiliriz.
* Test için `minikube status`

#### **Minikube üzerinde K8s Cluster Kurulumu**

Varsayılan olarak Docker’ı background’da kullanır.

```shell
minikube start

minikube start --driver=virtualbox # VirtualBox background'ında çalıştırmak için.
```

Test için

```shell
minikube status
kubectl get nodes
```

**Kubernetes cluster’ı ve içeriğini (tüm podları) silmek için**

```shell
minikube delete
```

**Kubernetes cluster’ını durdurmak için**

```shell
minikube stop
```

## :warning::warning:\[WIP] kubeadm Kurulumu

\-> Kubernetes cluster’ı oluşturmamızı sağlayan başka bir platformdur. minikube’e göre daha gelişmiştir. Rassbery Pi üzerinde de çalışabilir :)

> **Buraya yazılacak diğer tutorial’lar:**
>
> * Google Cloud Platform’unda Kurulum,
> * AWS'de Kurulum,
> * Azure'da Kurulum.

## Play-with-kubernetes Kurulumu

* Eğer cloud için kredi kartınızı vermek istemiyorsanız ya da hızlıca bazı denemeler yapmak istiyorsanız, **play-with-kubernetes** tam size göre.
* 4 saatlik kullanım sınırı var. 4 saat sonra sistem sıfırlanıyor, ayarlar gidiyor.
* Browser based çalışır.
* Toplam max 5 tane node oluşturabiliyorsunuz.

## Tools

* **Lens -->** Kubernetes için çok iyi hazırlanmış bir yönetim tool'u.
* **kubectx -->** Hızlı config/context geçişi için.
* **Krew -->** kubectl için plugin-set'leri

# 22. Kubectl config

## Kubectl

* kubectl ile mevcut cluster’ı yönetimini **config** dosyası üzerinden yapmamız gerekir. Minikube gibi tool’lar config dosyalarını otomatik olarak oluşturur.
* **Default config** dosyasına `nano ~/.kube/config` yazarak ulaşabiliriz.
* VSCode’da açmak için

```
 cd ~/.kube 
 code .
```

* **context ->** Cluster ile user bilgilerini birleştirerek context bilgisini oluşturur. “_Bu cluster’a bu user’la bağlanacağım._” anlamına geliyor.

![image](https://user-images.githubusercontent.com/103413194/184497762-3d8df7c7-13e4-45be-b315-ac1378f9e184.png)


### Kubectl Config Komutları

**`kubectl config`**

–> Config ayarlarının düzenlenmesini sağlayan komuttur.

**`kubectl config get-contexts`**

–> Kubectl baktığı config dosyasındaki mevcut contextleri listeler. Mevcut olan contexin basinda yildiz var.

#### **Current Context**

Current sütununda minikube’un yanında bir yıldız (\*) işareti görünür. Bunun anlamı: birden fazla context tanımlansa da **o an kullanılan context** anlamına gelir. Yapacağımız tüm işlemleri bu context’in içerisinde gerçekleşecektir.

**`kubectl config current-context`**

–> Kubectl baktığı config dosyasındaki current context’i verir.

**`kubectl config use-context <contextName>`**

–> Current context’i contextName olarak belirtilen context’i ile değiştirir.

ÖR: `kubectl config use-context docker-desktop` –> docker-desktop context’ine geçer.

# 23. Kubectl kullanımı

**`kubectl`** 

bize kubectl ile kullanabilecegimiz komutlari veriyor.

## Kubectl Kullanım Komutları

* kubectl’de komutlar belli bir şemayla tasarlanmıştır:

```
 kubectl <fiil> <object> ​
 
 # <fiil> = get, delete, edit, apply 
 # <object> = pod
```

* kubectl’de aksi belirtilmedikçe tüm komutlar **config’de yazılan namespace’ler** üzerinde uygulanır. Config’de namespace belirtilmediyse, **default namespace** geçerlidir.

### `kubectl cluster-info`

–> Üzerinde işlem yaptığımız **cluster** ile ilgili bilgileri öğreneceğimiz komut.

### `kubectl get pods`

–> **Default namespace**‘deki pod’ları getirir.

### `kubectl get pods testpod`

–> **testpod** isimli pod’u getirir.

### **`kubectl get pods -n kube-system`**

–> **kube-system** isimli namespace’de tanımlanmış pod’ları getirir.

### `kubectl get pods -A`

–> **Tüm namespacelerdeki** pod’ları getirir.

### `kubectl get pods -A -o <wide|yaml|json>`

–> **Tüm namespacelerdeki** pod’ları **istenilen output formatında** getirir.

```shell
# jq -> json query pluginin kur.
# brew install jq

kubectl get pods -A -o json | jq -r ".items[].spec.containers[].name"
```

### `kubectl apply --help`

–> **apply** komutunun nasıl kullanılacağı ile ilgili bilgi verir. Ama `kubectl pod –-help` yazsak, bu pod ile ilgili **bilgi vermez.** Bunun yerine aşağıdaki **explain** komutu kullanılmalıdır.

### `kubectl explain pod`

\--> **pod** objesinin ne olduğunu, hangi field’ları aldığını gösterir.

\--> Çıkan output'ta **Version** ile hangi namespace’e ait olduğunu anlayabiliriz.

### `kubectl get pods`<mark style="color:red;">`-w`</mark>

\--> kubectl'i izleme (watch) moduna alır ve değişimlerin canlı olarak izlenmesini sağlar.

### `kubectl get all`<mark style="color:red;">`-A`</mark>

\--> Sistemde çalışan **tüm object'lerin durumunu** gösterir.

### `kubectl exec -it <podName> -c <containerName> -- bash`

\--> Pod içerisinde çalışan bir container'a bash ile bağlanmak için.

## Hızlı Kubectl Config Değiştirme

Hızlıca config değiştirmek için aşağıdaki bash scriptten yararlanabiliriz:

{% code title="change.sh" %}
```bash
#! /bin/bash

CLUSTER=$1

if [ -z "$1" ]
  then
    echo -e "\n##### No argument supplied. Please select one of these configs. #####"
    ls  ~/.kube |grep config- | cut -d "-" -f 2
    echo -e "\n"
    #array=($(ls -d * |grep config_))
    read -p 'Please set config file: ' config
    cp -r ~/.kube/config_$config ~/.kube/config
    echo -e '\n'
    kubectl cluster-info |grep -v "To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'."
    kubectl config get-contexts
    kubectl get node -o wide |head -n 4
else
  cp -r ~/.kube/config-$CLUSTER ~/.kube/config
  if [ $? -ne 0 ];
  then
  exit 1
  fi
  echo -e '\n'
#  kubectl cluster-info |grep -v "To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'."
  kubectl config get-contexts
  echo -e '\n'
  kubectl get node -o wide |head -n 4
  echo -e '\n'
fi
```
{% endcode %}

Kullanım:

\--> Config dosyası `config-minikube` şeklinde oluşturulmalıdır. Script çalıştırırken config prefix'i ekliyor.

```
./change.sh <configName>

./change.sh minikube
```


# 24. Pod


## Pod Nedir?

* K8s üzerinde koşturduğumuz, çalıştırdığımız, deploy ettiğimiz şeylere **Kubernetes Object** denir.
* **En temel object Pod‘dur.**
* K8s’den önce hep docker container ile çalıştık. **K8s’de ise biz, direkt olarak container oluşturmayız.** K8s Dünya’sında oluşturabileceğimiz, yönetebileceğimiz **en küçük birim Pod’dur.**
* Pod’lar **bir veya birden** fazla container barındırabilir. **Best Practice için her bir pod bir tek container barındırır.**
* Her pod’un **unique bir ID’si (uid)** vardır ve **unique bir IP’si** vardır. Api-server, bu uid ve IP’yi **etcd’ye kaydeder.** Scheduler ise herhangi bir podun node ile ilişkisi kurulmadığını görürse, o podu çalıştırması için **uygun bir worker node** seçer ve bu bilgiyi pod tanımına ekler. Pod içerisinde çalışan **kubelet** servisi bu pod tanımını görür ve ilgili container’ı çalıştırır.
* Aynı pod içerisindeki containerlar aynı node üzerinde çalıştırılır ve bu containerlar localhost üzerinden haberleşir.
* **`kubectl run`** şeklinde pod oluşturulur.

# 25. Pod oluşturma

```shell
kubectl run firstpod --image=nginx --restart=Never --port=80 --labels="app=frontend" 

# Output: pod/firstpod created
```

* `–restart` -> Eğer pod içerisindeki container bir sebepten ötürü durursa, tekrar çalıştırılmaması için `Never` yazdık.

### Tanımlanan Podları Gösterme

```shell
kubectl get pods -o wide

# -o wide --> Daha geniş table gösterimi için.
```

### Bir Object’in Detaylarını Görmek

```shell
kubectl describe <object> <objectName>

kubectl describe pods first-pod
```

* `first-pod` podu ile ilgili tüm bilgileri getirir.
* Bilgiler içerisinde **Events**‘e dikkat. Pod’un tarihçesi, neler olmuş, k8s neler yapmış görebiliriz.
  * Önce Scheduler node ataması yapar,
  * kubelet container image’ı pull’lamış,
  * kubelet pod oluşturulmuş.

### Pod Loglarını Görmek

```shell
kubectl logs <podName>

kubectl logs first-pod
```

**Logları Canlı Olarak (Realtime) Görmek**

```shell
kubectl logs -f <podName>
```

### Pod İçerisinde Komut Çalıştırma

```
kubectl exec <podName> -- <command>

kubectl exec first-pod -- ls /
```

### Pod İçerisindeki Container’a Bağlanma

```shell
kubectl exec -it <podName> -- <shellName>

kubectl exec -it first-pod -- /bin/sh
```

**Eğer 1 Pod içerisinde 1'den fazla container varsa:**

```
kubectl exec -it <podName> -c <containerName> -- <bash|/bin/sh>
```

\-> Bağlandıktan sonra kullanabileceğimiz bazı komutlar:

```shell
hostname #pod ismini verir.
printenv #Pod env variables'ları getirir.
```

\--> Eğer bir pod içerisinde birden fazla container varsa, istediğimiz container'a bağlanmak için:

```
kubectl exec -it <podName> -c <containerName> -- /bin/sh
```

### Pod’u Silme

```shell
kubectl delete pods <podName>
```

\-> Silme işlemi yaparken dikkat! Çünkü, confirm almıyor. **Direkt siliyor!** Özellikle production’da dikkat!

## YAML

* k8s, declarative yöntem olarak **YAML** veya **JSON** destekler.
* **`---` (üç tire) koyarak bir YAML dosyası içerisinde birden fazla object belirletebiliriz.**

_k8sfundamentals/pod/objectbasetemplate.yaml dosyasını açtık._

```yaml
apiVersion:
kind:
metadata:
spec:
```

* Her türlü object oluşturulurken; **apiVersion, kind ve metadata** olmak zorundadır.
* **`kind`** –> Hangi object türünü oluşturmak istiyorsak buraya yazarız. ÖR: `pod`
* **`apiVersion`** –> Oluşturmak istediğimiz object’in hangi API üzerinde ya da endpoint üzerinde sunulduğunu gösterir.
* **`metadata`** –> Object ile ilgili unique bilgileri tanımladığımız yerdir. ÖR: `namespace`, `annotation` vb.
* **`spec`** –> Oluşturmak istediğimiz object’in özelliklerini belirttiğimiz yerdir. Her object için gireceğimiz bilgiler farklıdır. Burada yazacağımız tanımları, dokümantasyondan bakabiliriz.

### apiVersion’u Nereden Bulacağız?

1. Dokümantasyona bakabiliriz.
2. kubectl aracılığıyla öğrenebiliriz:

```shell
kubectl explain pods
```

Yukarıdaki explain komutunu yazarak pod’un özelliklerini öğrenebiliriz.

–> `Versions` karşısında yazan bizim `apiVersion`umuzdur.

### metadata ve spec Yazımı

> _Aşağıdaki yaml’ı k8sfundamentals/pod/pod1.yaml dosyasında görebilirsin._

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: first-pod 	# Pod'un ismi
	labels:			# Atayacağımız etiketleri yazabiliriz.
		app: front-end  # app = front-end label'i oluşturduk.
spec:	
	containers: 			# Container tanımlamaları yapıyoruz.
	- name: nginx			# Container ismi
		image: nginx:latest
		ports:
		- containerPort: 80 # Container'e dışarıdan erişilecek port
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: firstpod
  labels:
    app: frontend
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

### K8s’e YAML Dosyasını Declare Etme

```shell
kubectl apply -f pod1.yaml
```

* pod1.yaml dosyasını al ve burada tanımlanan object’i benim için oluştur.
* `kubectl describe pods firstpod` ile oluşturulan pod’un tüm özellikleri görüntülenir.
* YAML yöntemi kullanmak pipeline’da yaratmakta kullanılabilir.
* :thumbsup: **Declarative Yöntem Avantajı** –> Imperative yöntemle bir pod tanımladığımızda, bir özelliğini update etmek istediğimizde “Already exists.” hatası alırız. Ama declarative olarak YAML’ı değiştirip, update etmek isteseydik ve apply komutunu kullansaydık “pod configured” success mesajını alırız.

### Declare Edilen YAML Dosyasını Durdurma

```shell
kubectl delete -f pod1.yaml
```

### Kubectl ile Pod’ları Direkt Değiştirmek (Edit)

```shell
kubectl edit pods <podName>
```

* Herhangi tanımlanmış bir pod’un özelliklerini direkt değiştirmek için kullanılır.
* `i`tuşuna basarak `INSERT`moduna geçip, editleme yaparız.
* CMD + C ile çıkıp, `:wq` ile VIM’den çıkabiliriz.
* Pod’un editlendiği mesajını görürüz.
* Tercih edilen bir yöntem değildir, YAML + `kubectl apply` tercih edilmelidir.

## 28. Pod Yaşam Döngüsü

* **Pending** –> Pod oluşturmak için bir YAML dosyası yazdığımızda, YAML dosyasında yazan configlerle varsayılanlar harmanlanır ve etcd’ye kaydolur.
* **Creating** –> kube-sched, etcd’yi sürekli izler ve herhangi bir node’a atanmamış pod görülürse devreye girer ve en uygun node’u seçer ve node bilgisini ekler. Eğer bu aşamada takılı kalıyorsa, **uygun bir node bulunamadığı anlamına gelir.**
  * etcd’yi sürekli izler ve bulunduğu node’a atanmış podları tespit eder. Buna göre containerları oluşturmak için image’leri download eder. Eğer image bulunamazsa veya repodan çekilemezse **ImagePullBackOff** durumuna geçer.
  * Eğer image doğru bir şekilde çekilir ve containerlar oluşmaya başlarsa Pod **Running** durumuna geçer.

> _Burada bir S verelim.. Container’ların çalışma mantığından bahsedelim:_

* Container imagelarında sürekli çalışması gereken bir uygulama bulunur. Bu uygulama çalıştığı sürece container da çalışır durumdadır. Uygulama 3 şekilde çalışmasını sonlandırır:
  1. Uygulama tüm görevlerini tamamlar ve hatasız kapanır.
  2. Kullanıcı veya sistem kapanma sinyali gönderir ve hatasız kapanır.
  3. Hata verir, çöker, kapanır.

> _Döngüye geri dönelim.._

* Container uygulamasının durmasına karşılık, Pod içerisinde bir **RestartPolicy** tanımlanır ve 3 değer alır:
  * **`Always`** -> Kubelet bu container’ı yeniden başlatır.
  * **`Never`** -> Kubelet bu container’ı yeniden **başlatmaz**.
  * **`On-failure`** -> Kubelet sadece container hata alınca başlatır.\
* **Succeeded** -> Pod başarıyla oluşturulmuşsa bu duruma geçer.
* **Failed** -> Pod başarıyla oluşturulmamışsa bu duruma geçer.
* **Completed** -> Pod başarıyla oluşturulup, çalıştırılır ve hatasız kapanırsa bu duruma geçer.
* :warning: **CrashLookBackOff** -> Pod oluşturulup sık sık kapanıyorsa ve RestartPolicy’den dolayı sürekli yeniden başlatılmaya çalışılıyorsa, k8s bunu algılar ve bu podu bu state’e getirir. Bu state de olan **podlar incelenmelidir.**

# 29. Pod yaşam döngüsü uygulama

**kubectl get pods -w**
canli olarak degisimi izliyoruz.

![image](https://user-images.githubusercontent.com/103413194/184527496-98829e3e-888f-40b3-a775-a7746c89c413.png)


-c komutu ile 

# 30. Çoklu container pod

### **Neden 2 uygulamayı aynı container’a koymuyoruz?**

–> Cevap: İzolasyon. 2 uygulama izole çalışsın. Eğer bu izolasyonu sağlamazsanız, yatay scaling yapamazsınız. Bu durumu çoklamak gerektiğinde ve 2. containeri aldığımızda 2 tane MySQL, 2 tane Wordpress olacak ki bu iyi bir şey değil.

:ok\_hand: Bu sebeple **1 Pod = 1 Container = 1 uygulama** olmalıdır! Diğer senaryolar **Anti-Pattern** olur.


### Peki, neden pod’lar neden multi-container’a izin veriyor?

–> Cevap: Bazı uygulamalar bütünleşik (bağımlı) çalışır. Yani ana uygulama çalıştığında çalışmalı, durduğunda durmalıdır. Bu tür durumlarda bir pod içerisine birden fazla container koyabiliriz.

–> Bir pod içerisindeki 2 container için network gerekmez, localhost üzerinden çalışabilir.

\-> Eğer multi-container’a sahip pod varsa ve bu containerlardan birine bağlanmak istersek:

```shell
kubectl exec -it <podName> -c <containerName> -- /bin/sh
```

# 31. Çoklu container pod uygulama

```
apiVersion: v1
kind: Pod
metadata:
  name: multicontainer
spec:
  containers:
  - name: webcontainer
    image: nginx
    ports:
      - containerPort: 80
    volumeMounts:
    - name: sharedvolume
      mountPath: /usr/share/nginx/html
  - name: sidecarcontainer
    image: busybox
    command: ["/bin/sh"]
    args: ["-c", "while true; do wget -O /var/log/index.html https://raw.githubusercontent.com/ozgurozturknet/hello-world/master/index.html; sleep 15; done"]
    volumeMounts:
    - name: sharedvolume
      mountPath: /var/log
  volumes:
  - name: sharedvolume
    emptyDir: {}
```
# 32. Init container

### Init Container ile bir Pod içerisinde birden fazla Container Çalıştırma

Go’daki `init()` komutu gibi ilk çalışan container’dır. Örneğin, uygulama container’ın başlayabilmesi için bazı config dosyalarını fetch etmesi gerekir. Bu işlemi init container içerisinde yapabiliriz.

1. Uygulama container’ı başlatılmadan önce **Init Container** ilk olarak çalışır.
2. Init Container yapması gerekenleri yapar ve kapanır.
3. Uygulama container’ı, Init Container kapandıktan sonra çalışmaya başlar. **Init Container kapanmadan uygulama container’ı başlamaz.**
**Ornek**: Uygulama containerin ihtiyacı olan bazı config dosyalarının son güncel halinin uygulama başlamadan sisteme çekilmesi gerekiyor. Bu durumda ilk önce init container ile çekme işini halledip daha sonra ana uygulama başlar.

```
apiVersion: v1
kind: Pod
metadata:
  name: initcontainerpod
spec:
  containers:
  - name: appcontainer
    image: busybox
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: initcontainer
    image: busybox
    command: ['sh', '-c', "until nslookup myservice; do echo waiting for myservice; sleep 2; done"]
```

# 33. Label ve selector

## Label Nedir?

* Label -> Etiket
* Selector -> Etiket Seçme

**Örnek:** `example.com/tier:front-end` –>`example.com/` = Prefix (optional) `tier` = **key**, `front-end` = **value**

* `kubernetes.io/`ve `k8s.io/` Kubernetes core bileşenler için ayrılmıştır, kullanılamazdır.
* Tire, alt çizgi, noktalar içerebilir.
* Türkçe karakter kullanılamaz.
* **Service, deployment, pods gibi objectler arası bağ kurmak için kullanılır.**

# 34. Label ve selector uygulama

* Label tanımı **metadata** tarafında yapılır. Aynı object’e birden fazla label ekleyebiliriz. bir poddaki anahtara iki value atayamayız.
* Label, gruplandırma ve tanımlama imkanı verir. CLI tarafında listelemekte kolaylaşır.

### Selector - Label’lara göre Object Listelemek

* İçerisinde örneğin “app” key’ine sahip objectleri listelemek için:

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: pod8
  labels:
    app: berk # app key burada. berk ise value'su.
    tier: backend # tier başka bir key, backend value'su.
```
![image](https://user-images.githubusercontent.com/103413194/184532721-92694678-8432-4a93-9c87-2947a57f9b36.png)

labels ları kullanarak arama yapabiliyoruz.
---
obje oluştururken yamlın içinde obje yamlarının arasında --- koyarsak yeni bir obje oluşturabiliriz.


![image](https://user-images.githubusercontent.com/103413194/184532768-38c3193e-f8bb-4596-a6db-22dad5388287.png)



![image](https://user-images.githubusercontent.com/103413194/184532830-49eb35f0-1a38-41b1-83df-daa6592d2fe4.png)


```shell
kubectl get pods -l <keyword> --show-labels

## Equality based Syntax'i ile listeleme

kubectl get pods -l "app" --show-labels

kubectl get pods -l "app=firstapp" --show-labels

kubectl get pods -l "app=firstapp, tier=front-end" --show-labels

# app key'i firstapp olan, tier'ı front-end olmayanlar:
kubectl get pods -l "app=firstapp, tier!=front-end" --show-labels

# app anahtarı olan ve tier'ı front-end olan objectler:
kubectl get pods -l "app, tier=front-end" --show-labels

## Set based ile Listeleme

# App'i firstapp olan objectler:
kubectl get pods -l "app in (firstapp)" --show-labels

# app'i sorgula ve içerisinde "firstapp" olmayanları getir:
kubectl get pods -l "app, app notin (firstapp)" --show-labels

kubectl get pods -l "app in (firstapp, secondapp)" --show-labels

# app anahtarına sahip olmayanları listele
kubectl get pods -l "!app" --show-labels

# app olarak firstapp atanmış, tier keyine frontend değeri atanmamışları getir:
kubectl get pods -l "app in (firstapp), tier notin (frontend)" --show-labels
```

* İlk syntax’ta (equality based) bir sonuç bulunamazken, 2. syntax (set based selector) sonuç gelir:

```yaml
kubectl get pods -l "app=firstapp, app=secondapp" --show-labels # Sonuç yok!
kubectl get pods -l "app in (firstapp, secondapp)" --show-labels # Sonuç var :)
```

### Komutla label ekleme

```shell
kubectl label pods <podName> <label>

kubectl label pods pod1 app=front-end
```

### Komutla label silme

Sonuna - (tire) koymak gerekiyor. Sil anlamına gelir.

```
kubectl label pods pod1 app-
```

### Komutla label güncelleme

```shell
kubectl label --overwrite pods <podName> <label>

kubectl label --overwrite pods pod9 team=team3
```

### Komutla toplu label ekleme

Tüm objectlere bu label eklenir.

```
kubectl label pods --all foo=bar
```

## Objectler Arasında Label İlişkisi

* NŞA’da kube-sched kendi algoritmasına göre bir node seçimi yapar. Eğer bunu manuel hale getirmek istersek, aşağıdaki örnekte olduğu gibi `hddtype: ssd` label’ına sahip node’u seçmesini sağlayabiliriz. Böylece, pod ile node arasında label’lar aracılığıyla bir ilişki kurmuş oluruz.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod11
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
  nodeSelector:
    hddtype: ssd
```

> _minikube cluster’ı içerisindeki tek node’a `hddtype: ssd` label’ı ekleyebiliriz. Bunu ekledikten sonra yukarıdaki pod “Pending” durumundan, “Running” durumuna geçecektir. (Aradığı node’u buldu çünkü_ :smile: _)_

```shell
kubectl label nodes minikube hddtype=ssd
```

# 35. Annotation

* Aynı label gibi davranır ve **metadata** altına yazılır.
* Label’lar 2 object arasında ilişki kurmak için kullanıldığından hassas bilgi sınıfına girer. (Label'lar bir durumu tetikleyebilir). Bu sebeple, label olarak kullanamayacağımız ama önemli bilgileri **Annotation** sayesinde kayıt altına alabiliriz.
* **example.com/notification-email:admin@k8s.com**
  * example.com –> Prefix (optional)
  * notification-email –> Key
  * admin@k8s.com –> Value

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: annotationpod
  annotations:
    owner: "Ozgur OZTURK"
    notification-email: "admin@k8sfundamentals.com"
    releasedate: "01.01.2021"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  containers:
  - name: annotationcontainer
    image: nginx
    ports:
    - containerPort: 80
```

### Komutla Annotation ekleme

```shell
kubectl annotate pods annotationpod foo=bar

kubectl annotate pods annotationpod foo- # Siler.
```
# 36. Namespace

* 10 farklı ekibin tek bir **file server** kullandığı bir senaryo düşünelim:
  * Bir kişinin yarattığı bir dosyayı başkası overwrite edebilir ya da isim çakışmasına sebep olabilir,
  * Sadece Team 1’in görmesi gereken dosyaları ayırmakta zorlanabilirim, sürekli dosya ayarları yapmam gerekir.
  * Bunun çözümü için, her ekibe özel bir klasör yaratabilir ve permissionlarını ekip üyelerine göre düzenleyebiliriz.
* Yukarıdaki örnekteki **fileserver**’ı **k8s clusterı**, **namespace’leri** ise burada her ekibe açılmış **klasörler** olarak düşünebiliriz.
* **Namespace’lerde birer k8s object’idir. Tanımlarken (özellikle YAML) dosyasında buna göre tanımlama yapılmalıdır.**
* Namespace’lerin birbirinden bağımsız ve benzersiz olması gerekir. **Namespace’ler birbiri içerisine yerleştirilemez.**
* Her k8s oluşturulduğunda ise 4 default namespace oluşturulur. (_default, kube-node-lease, kube-public, kube-system_)

### Namespace Listeleme

* Varsayılan olarak tüm işlemler ve objectler **default namespace** altında işlenir. `kubectl get pods`yazdığımızda herhangi bir namespace belirtmediğimiz için, `default namespace` altındaki podları getirir.

```shell
kubectl get pods --namespace <namespaceName>
kubectl get pods -n <namespaceName>

# Tüm namespace'lerdeki podları listelemek için:
kubectl get pods --all-namespaces
```

### Namespace Oluşturma

```shell
kubectl create namespace <namespaceName>

kubectl get namespaces
```

#### YAML dosyası kullanarak Namespace oluşturma

```yaml
apiVersion: v1
kind: Namespace # development isminde bir namespace oluşturulur.
metadata:
  name: development # namespace'e isim veriyoruz.
---
apiVersion: v1
kind: Pod
metadata:
  namespace: development # oluşturduğumuz namespace altında podu tanımlıyoruz.
  name: namespacepod
spec:
  containers:
  - name: namespacecontainer
    image: nginx:latest
    ports:
    - containerPort: 80
```

Bir namespace içinde çalışan Pod’u yaratırken ve bu poda bağlanırken; kısacası bu podlar üzerinde herhangi bir işlem yaparken **namespace** belirtilmek zorundadır. Belirtilmezse, k8s ilgili podu **default namespace** altında aramaya başlayacaktır.

### Varsayılan Namespace’i Değiştirmek

```
kubectl config set-context --current --namespace=<namespaceName>
```

### Namespace’i Silmek

:warning: **DİKKAT!** **Namespace silerken confirmation istenmeyecektir. Namespace altındaki tüm objectlerde silinecektir!**

```
kubectl delete namespaces <namespaceName>
```

# 37. Deployment

K8s kültüründe “Singleton (Tekil) Pod”lar genellikle yaratılmaz. Bunları yöneten üst seviye object’ler yaratırız ve bu podlar bu objectler tarafından yönetilir. (ÖR: Deployment)

**Peki, neden yaratmıyoruz?**

Örneğin, bir frontend object’ini bir pod içerisindeki container’la deploy ettiğimizi düşünelim. Eğer bu container’da hata meydana gelirse ve bizim RestartPolicy’miz “Always veya On-failure” ise kube-sched containerı yeniden başlatarak kurtarır ve çalışmasına devam ettirir. Fakat, **sorun node üzerinde çıkarsa, kube-sched, “Ben bunu gidip başka bir worker-node’da çalıştırayım” demez!**

Peki buna çözüm olarak 3 node tanımladık, önlerine de bir load balancer koyduk. Eğer birine bir şey olursa diğerleri online olmaya devam edeceği için sorunu çözmüş olduk. **AMA..** Uygulamayı geliştirdiğimizi düşünelim. Tek tek tüm nodelardaki container image’larını yenilemek zorunda kalacağız. Label eklemek istesek, hepsine eklememiz gerekir. **Yani, işler karmaşıklaştı.**

**ÇÖZÜM: “Deployment” Object**

* Deployment, bir veya birden fazla pod’u için bizim belirlediğimiz **desired state**’i sürekli **current state**‘e getirmeye çalışan bir object tipidir. Deployment’lar içerisindeki **deployment-controller** ile current state’i desired state’e getirmek için gerekli aksiyonları alır.
* Deployment object’i ile örneğin yukarıdaki image update etme işlemini tüm nodelarda kolaylıkla yapabiliriz.
* Deployment’a işlemler sırasında nasıl davranması gerektiğini de (**Rollout**) parametre ile belirtebiliriz.
* **Deployment’ta yapılan yeni işlemlerde hata alırsak, bunu eski haline tek bir komutla döndürebiliriz.**
* :warning: :warning: :warning: Örneğin, deployment oluştururken **replica** tanımı yaparsak, k8s cluster’ı her zaman o kadar replika’yı canlı tutmaya çalışacaktır. Siz manuel olarak deployment’ın oluşturduğu pod’lardan birini silseniz de, arka tarafta yeni bir pod ayağa kaldırılacaktır. İşte bu sebeple biz **Singleton Pod** yaratmıyoruz. Yani, manuel ya da yaml ile direkt pod yaratmıyoruz ki bu optimizasyonu k8s’e bırakıyoruz.
* Tek bir pod yaratacak bile olsanız, bunu deployment ile yaratmalısınız! (k8s resmi önerisi)

# 38. Deployment uygulama
### Komut ile Deployment Oluşturma

```shell
kubectl create deployment <deploymentName> --image=<imageName> --replicas=<replicasNumber>

kubectl create deployment <deploymentName> --image=nginx:latest --replicas=2

kubectl get deployment
# Tüm deployment ready kolonuna dikkat!
```

### Deployment’taki image’ı Update etme

```shell
kubectl set image deployment/<deploymentName> <containerName>=<yeniImage>

kubectl set image deployment/firstdeployment nginx=httpd
```

* Default strateji olarak, önce bir pod’u yeniler, sonra diğerini, sonra diğerini. Bunu değiştirebiliriz.

### Deployment Replicas’ını Değiştirme

```shell
kubectl scale deployment <deploymentName> --replicas=<yeniReplicaSayısı>
```

### Deployment Silme

```shell
kubectl delete deployments <deploymentName>
```

### **YAML ile Deployment Oluşturma**

1. Herhangi bir pod oluşturacak yaml dosyasındaki **`metadata`** altında kalan komutları kopyala:

```yaml
# podexample.yaml

apiVersion: v1
kind: Pod
metadata:
  name: examplepod
  labels:
    app: frontend
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

1. Deployment oluşturacak yaml dosyasında **`template`** kısmının altına yapıştır. _(Indent’lere dikkat!)_
2. **pod template içerisinden `name` alanını sil.**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: firstdeployment
  labels:
    team: development
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend # template içerisindeki pod'la eşleşmesi için kullanılacak label.
  template:	    # Oluşturulacak podların özelliklerini belirttiğimiz alan.
    metadata:
      labels:
        app: frontend # deployment ile eşleşen pod'un label'i.
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80 # dışarı açılacak port.
```

* Her deployment’ta **en az bir tane** `selector` tanımı olmalıdır.
* **Birden fazla deployment yaratacaksanız, farklı label’lar kullanmak zorundasınız.** Yoksa deploymentlar hangi podların kendine ait olduğunu karıştırabilir. **Ayrıca, aynı labelları kullanan singleton bir pod’da yaratmak sakıncalıdır!**

# 39. ReplicaSet

K8s’de x sayıda pod oluşturan ve bunları yöneten object türü aslında **deployment değildir.** **ReplicaSet**, tüm bu işleri üstlenir. Biz deployment’a istediğimiz derived state’i söylediğimizde, deployments object’i bir ReplicaSet object’i oluşturur ve tüm bu görevleri ReplicaSet gerçekleştirir.

K8s ilk çıktığında **Replication-controller** adında bir object’imiz vardı. Halen var ama kullanılmıyor.

```shell
kubectl get replicaset # Aktif ReplicaSet'leri listeler.
```

Bir deployment tanımlıyken, üzerinde bir değişiklik yaptığımızda; deployment **yeni bir ReplicaSet** oluşturur ve bu ReplicaSet yeni podları oluşturmaya başlar. Bir yandan da eski podlar silinir. **Fakat replicaset silinmez.**

### Deployment üzerinde yapılan değişiklikleri geri alma

```shell
kubectl rollout undo deployment <deploymentName>
```

Bu durumda ise eski deployment yeniden oluşturulur ve eski ReplicaSet önceki podları oluşturmaya başlar. İşte bu sebeple, tüm bu işlemleri **manuel yönetmemek adına** bizler direkt ReplicaSet oluşturmaz, işlemlerimize deployment oluşturarak devam ederiz.

—> **Deployment > ReplicaSet > Pods**

* ReplicaSet, YAML olarak oluşturulmak istendiğinde **tamamen deployment ile aynı şekilde oluşturulur. Sadece kind kısmına ReplicaSet yazılır.**
Replicaset yaml da image da yaptığımız bir değişikliği var olan podlara uygulamaz. Ancak yeni pod oluşturacaksa yeni image dan oluşturur. Bunun için deployment objesini kullanıyoruz.

# 40. Rollout ve Rollback

Rollout ve Rollback kavramları, **deploment’ın** güncellemesi esnasında devreye girer, anlam kazanır.

**YAML** ile deployment tanımlaması yaparken **`strategy`** olarak 2 tip seçilir:

### Rollout Strategy - **`Recreate`**

```shell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rcdeployment
  labels:
    team: development
spec:
  replicas: 3
  selector:
    matchLabels:
      app: recreate 
  strategy:
    type: Recreate # recreate === Rollout strategy
```

* “_Ben bu deployment’ta bir değişiklik yaparsam, öncelikle tüm podları sil, sonrasında yenilerini oluştur._” Bu yöntem daha çok **hardcore migration** yapıldığında kullanılır.

Uygulamamızın yeni versionuyla eski versionunun birlikte çalışması **sakıncalı** ise bu yöntem seçilir. ****&#x20;

**Örneğin,** bir RabbitMQ consumer'ımız olduğunu varsayalım. Böyle bir uygulamada eski version ve yeni version'un birlikte çalışması genellikle tercih edilen bir durum değildir. Bu sebeple, strategy olarak `recreate` tercih edilmelidir.

### Rollback Strategy - **`RollingUpdate`**

```shell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rolldeployment
  labels:
    team: development
spec:
  replicas: 10
  selector:
    matchLabels:
      app: rolling
  strategy:
    type: RollingUpdate # Rollback Strategy
    rollingUpdate:
      maxUnavailable: 2 # Güncelleme esnasında aynı anda kaç pod silineceği
      maxSurge: 2 # Güncelleme esnasında toplam aktif max pod sayısı
  template:
  ...
```

* Eğer YAML dosyasında strategy belirtmezseniz, **default olarak RollingUpdate seçilir.** **maxUnavailable ve maxSurge** değerleri ise default **%25’dir.**
* RollingUpdate, Create’in tam tersidir. “Ben bir değişiklik yaptığım zaman, hepsini silip; yenilerini **oluşturma**.” Bu strateji’de önemli 2 parametre vardır:
  * **`maxUnavailable`** –> En fazla burada yazılan sayı kadar pod’u sil. Bir güncellemeye başlandığı anda en fazla x kadar pod silinecek sayısı. (%20 de yazabiliriz.)
  * **`maxSurge`** –> Güncelleme geçiş sırasında sistemde toplamda kaç **max aktif pod’un olması gerektiği sayıdır.**

**Örnek**

Bir deployment ayağa kaldırdığımızı düşünelim. Image = nginx olsun. Aşağıdaki komut ile varolan deployment üzerinde güncelleme yapalım. nginx image'ı yerine httpd-alphine image'ının olmasını isteyelim:

```shell
kubectl set image deployment rolldeployment nginx=httpd-alphine --record=true
```

* `--record=true` parametresi bizim için tüm güncelleme aşamalarını kaydeder. Özellikle, bir önceki duruma geri dönmek istediğimizde işe yarar.

### Yapılan değişikliklerin listelenmesi

```shell
# rolldeployment = deploymentName
# tüm değişiklik listesi getirilir.
kubectl rollout history deployment rolldeployment 

# nelerin değiştiğini spesifik olarak görmek için:
kubectl rollout history deployment rolldeployment --revision=2
```

### Yapılan değişikliklerin geri alınması

```shell
# rolldeployment = deploymentName
# Bir önceki duruma geri dönmek için:
kubectl rollout undo deployment rolldeployment

# Spesifik bir revision'a geri dönmek için:
kubectl rollout undo deployment rolldeployment --to-revision=1
```

### Canlı olarak deployment güncellemeyi izlemek

```shell
# rolldeployment = deploymentName
kubectl rollout status deployment rolldeployment -w 
```

### Deployment güncellemesi esnasında pause’lamak

Güncelleme esnasında bir problem çıktı ve geri de dönmek istemiyorsak, ayrıca sorunun nereden kaynaklandığını da tespit etmek istiyorsak kullanılır.

```shell
# rolldeployment = deploymentName
kubectl rollout pause deployment rolldeployment
```

### Pause’lanan deployment güncellemesini devam ettirmek

```shell
kubectl rollout resume deployment rolldeployment
```

# 41. Kubernetes ağ altyapısı
## K8s Temel Ağ Altyapısı

Aşağıdaki üç kural dahilinde K8s network yapısı ele alınmıştır (_olmazsa olmazdır_):

1. K8s kurulumda pod’lara ip dağıtılması için bir **IP adres aralığı** (`--pod-network-cidr`) belirlenir.
2. K8s’te her pod bu cidr bloğundan atanacak **unique bir IP adresine sahip olur.**
3. **Aynı cluster içerisindeki Pod’lar** default olarak birbirleriyle herhangi **bir kısıtlama olmadan ve NAT (Network Address Translation) olmadan haberleşebilir.**

![image](https://user-images.githubusercontent.com/103413194/184542131-0cb8a680-1b6f-4524-a257-e51c82735701.png)

* K8s içerisindeki containerlar 3 tür haberleşmeye maruz bırakılır:
  1. Bir container k8s dışındaki bir IP ile haberleşir,
  2. Bir container kendi node içerisindeki başka bir container’la haberleşir,
  3. Bir container farklı bir node içerisindeki başka bir container’la haberleşir.
* İlk 2 senaryoda sorun yok ama 3. senaryo’da NAT konusunda problem yaşanır. Bu sebeple k8s containerların birbiri ile haberleşme konusunda **Container Network Interface (CNI)** projesini devreye almıştır.
* **CNI, yanlızca containerların ağ bağlantısıyla ve containerlar silindiğinde containerlara ayrılan kaynakların drop edilmesiyle ilgilenir.**
* **K8s ise ağ haberleşme konusunda CNI standartlarını kabul etti ve herkesin kendi seçeceği CNI pluginlerinden birini seçmesine izin verdi.** Aşağıdaki adreslerden en uygun olan CNI pluginini seçebilirsiniz:

{% embed url="https://github.com/containernetworking/cni" %}

{% embed url="https://kubernetes.io/docs/concepts/cluster-administration/networking" %}

**Container’ların “Dış Dünya” ile haberleşmesi konusunu ele aldık. Peki, “Dış Dünya”, Container’lar ile nasıl haberleşecek?**

Cevap: **Service** object’i.

# 42. Service

* K8s network tarafını ele alan objecttir.

### Service Objecti Çıkış Senaryosu

1 Frontend (React), 1 Backend (Go) oluşan bir sistemimiz olduğunu düşünelim:

* Her iki uygulama için **birer deployment** yazdık ve **3’er pod** tanımlanmasını sağladık.
* 3 Frontend poduna dış dünyadan nasıl erişim sağlayacağım?
* Frontend’den gelen istek backend’de işlenmeli. Burada çok bir problem yok. Çünkü, her pod’un bir IP adresi var ve K8s içerisindeki her pod birbiriyle bu IP adresleri sayesinde haberleşebilir.
* Bu haberleşmeyi sağlayabilmek için; Frontend podlarının Backend podlarının IP adreslerini **bilmeleri gerekir.** Bunu çözmek için, frontend deployment’ına tüm backend podlarının IP adreslerini yazdım. Fakat, pod’lar güncellenebilir, değişebilir ve bu güncellemeler esnasında **yeni bir IP adresi alabilir. Yeni oluşan IP adreslerini tekrar Frontend deployment’ında tanımlamam gerekir.**

İşte tüm bu durumları çözmek için **Service** objecti yaratırız. **K8s, Pod’lara kendi IP adreslerini ve bir dizi Pod için tek bir DNS adı verir ve bunlar arasında yük dengeler.**

## Service Tipleri

### **ClusterIP** (Container’lar Arası)

–> Bir ClusterIP service’i yaratıp, bunu label’lar sayesinde podlarla ilişkilendirebiliriz. Bu objecti yarattığımız zaman, Cluster içerisindeki tüm podların çözebileceği unique bir DNS adrese sahip olur. Ayrıca, her k8s kurulumunda sanal bir IP range’e sahip olur. (Ör: 10.0.100.0/16)

–> ClusterIP service objecti yaratıldığı zaman, bu object’e bu IP aralığından **bir IP atanır** ve **ismiyle bu IP adresi Cluster’ın DNS mekanizmasına kaydedilir.** Bu IP adresi **Virtual (Sanal) bir IP adresidir.**

–> Kube-proxy tarafından tüm node’lardaki IP Table’a bu IP adresi eklenir. Bu IP adresine gelen her trafik Round Troppin algoritmasıyla Pod’lara yönlendirilir. Bu durum bizim 2 sıkıntımızı çözer:

1. Ben Frontend node’larına bu IP adresini tanımlayıp (ismine de `backend`dersem), Backend’e gitmen gerektiği zaman bu IP adresini kullan diyebilirim. (**Selector = app:backend**) Tek tek her seferinde Frontend podlarına Backend podlarının IP adreslerini eklemek zorunda kalmam!

:tada: :tada: **Özetle: ClusterIP Service’i Container’ları arasındaki haberleşmeyi, Service Discovery ve Load Balancing görevi üstlenerek çözer!**\\

***

### NodePort Service (Dış Dünya -> Container)

–> Bu service tipi, **Cluster dışından gelen bağlantıları** çözmek için kullanılır.

–> `NodePort` key’i kullanılır.

![image](https://user-images.githubusercontent.com/103413194/184542656-4e79bd34-d1b9-45f4-8f32-bcfcb5abdeb1.png)

### LoadBalancer Service (Cloud Service’leri İçin)

–> Bu service tipi, sadece Agent K8s, Google K8s Engine gibi yerlerde kullanılır.

![image](https://user-images.githubusercontent.com/103413194/184542671-6ec1f693-7ba1-433d-b471-31f9eacd1f9c.png)



### ExternalName Service (Şuan için gereksiz.)


# 43. Service uygulama

### Cluster IP Örneği

```shell
apiVersion: v1
kind: Service
metadata:
  name: backend # Service ismi
spec:
  type: ClusterIP # Service tipi
  selector:
    app: backend # Hangi podla ile eşleşeceği (pod'daki labella aynı)
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000
```

Herhangi bir object, cluster içerisinde oluşan `clusterIP:5000` e istek attığında karşılık bulacaktır.

**Önemli Not:** Service’lerin ismi oluşturulduğunda şu formatta olur: `serviceName.namespaceName.svc.cluster.domain`

Eğer aynı namespace’de başka bir object bu servise gitmek istese core DNS çözümlemesi sayesinde direkt `backend` yazabilir. Başka bir namespaceden herhangi bir object ise ancak yukarıdaki **uzun ismi** kullanarak bu servise ulaşmalıdır.

### NodePort Örneği

* Unutulmamalıdır ki, tüm oluşan NodePort servislerinin de **ClusterIP’si** mevcuttur. Yani, içeriden bu ClusterIP kullanılarak bu servisle konuşulabilir.
* **`minikube service –url <serviceName>`** ile minikube kullanırken tunnel açabiliriz. Çünkü, biz normalde bu worker node’un içerisine dışardan erişemiyoruz. _Bu tamamen minikube ile alakalıdır._

```shell
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### Load Balancer Örneği

Google Cloud Service, Azure üzerinde oluşturulan cluster’larda çalışacak bir servistir.

```shell
apiVersion: v1
kind: Service
metadata:
  name: frontendlb
spec:
  type: LoadBalancer
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### Imperative Olarak Service Oluşturma

```shell
kubectl delete service <serviceName>

# ClusterIP Service yaratmak
kubectl expose deployment backend --type=ClusterIP --name=backend

kubectl expose deployment backend --type=NodePort --name=backend
```

### Endpoint Nedir?

Nasıl deployment’lar aslında ReplicaSet oluşturduysa, Service objectleride arka planda birer Endpoint oluşturur. Service’lerimize gelen isteklerin nereye yönleneceği Endpoint’ler ile belirlenir.

```shell
kubectl get endpoints
```

Bir pod silindiğinde yeni oluşacak pod için, yeni bir endpoint oluşturulur.
	
# 44. Liveness probes

Eğer container çalışmassa kubelet contaınerı kapatıp tekrar kuruyor. Fakat ayakta olmasına rağmen containerin görevini yerine getirmiyorsa kubelet bunu göremiyor. Doğal olarak containeri kapatıp yeniden açmayı denemiyor. Bu durumda liveless probes ile çözebiliyoruz.
	
![image](https://user-images.githubusercontent.com/103413194/185057781-f4ca40d9-de1c-462d-a10f-df0d72ad7481.png)


* http get request gönderelim.
* eğer 200 ve üzeri cevap dönerse başarılı!
* dönmezse kubelet container'ı yeniden başlatacak.

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-http
spec:
  containers:
  - name: liveness
    image: k8s.gcr.io/liveness
    args:
    - /server
    livenessProbe:
      httpGet:	# get request'i gönderiyoruz.
        path: /healthz # path tanımı
        port: 8080 # port tanımı
        httpHeaders: # get request'imize header eklemek istersek
        - name: Custom-Header
          value: Awesome
      initialDelaySeconds: 3 # uygulama hemen ayağa kalkmayabilir,
      											 # çalıştıktan x sn sonra isteği gönder.
      periodSeconds: 3 # kaç sn'de bir bu istek gönderilecek. 
      								 # (healthcheck test sürekli yapılır.)
```
🎉 uygulama içerisinde komut çalıştıralım.
🎉 eğer exit -1 sonucu alınırsa container baştan başlatılır.

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec
spec:
  containers:
  - name: liveness
    image: k8s.gcr.io/busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
    livenessProbe:
      exec:  			# komut çalıştırılır.
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
---
# tcp connection yaratalım. Eğer başarılıysa devam eder, yoksa 
# container baştan başlatılır.
apiVersion: v1
kind: Pod
metadata:
  name: goproxy
  labels:
    app: goproxy
spec:
  containers:
  - name: goproxy
    image: k8s.gcr.io/goproxy:0.1
    ports:
    - containerPort: 8080
    livenessProbe:	# tcp connection yaratılır.
      tcpSocket:
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 20
```
	
# 45. Readiness probes

Deployment ıle yeni imagelar ayaga kaldırdım. Bunlar oluşunca service-load balancer a baglanacak ve internet sıtemden gelen requestlere cevap verecek. eger contaıner calısıyorsa fakat ınternet sıtemı sunmaya hazır degılse ne olacak? veya load balancer servisinden trafik almaya hazır olduğunu nasıl anlayacağım. 

![image](https://user-images.githubusercontent.com/103413194/185067925-5fb05741-3fbe-4546-bd3b-db3a2e2b2a46.png)

![image](https://user-images.githubusercontent.com/103413194/185068817-857270fc-a4cb-4805-a353-393b53592f1b.png)

	
#### **Örnek Senaryo**

3 podumuz ve 1 LoadBalancer service’imiz var. Bir güncelleme yaptık; yeni bir image oluşturduk. Eski podlar devreden çıktı, yenileri alındı. Yenileri alındığından itibaren LoadBalancer gelen trafiği yönlendirmeye başlayacaktır. Peki, benim uygulamalarım ilk açıldığında bir yere bağlanıp bir data çekip, bunu işliyor ve sonra çalışmaya başlıyorsa? Bu süre zarfında gelen requestler doğru cevaplanamayacaktır. Kısacası, uygulamamız çalışıyor ama hizmet sunmaya hazır değil.

–> **Kubelet,** bir containerın ne zaman trafiği kabul etmeye (Initial status) hazır olduğunu bilmek için **Readiness Probes** kullanır. Bir Poddaki tüm container’lar Readiness Probes kontrolünden onay alırsa **Service Pod’un arkasına eklenir.**

Yukarıdaki örnekte, yeni image’lar oluşturulurken eski Pod’lar hemen **terminate** edilmez. Çünkü, içerisinde daha önceden alınmış istekler ve bu istekleri işlemek için yürütülen işlemler olabilir. Bu sebeple, k8s önce bu Pod’un service ile ilişkisini keser ve yeni istekler almasını engeller. İçerideki mevcut isteklerinde sonlanmasını bekler.

`terminationGracePeriodSconds: 30` –> Mevcut işlemler biter, 30 sn bekler ve kapanır. (_30sn default ayardır, gayet yeterlidir._)

**–> Readiness ile Liveness arasındaki fark, Readiness ilk çalışma anını baz alırken, Liveness sürekli çalışıp çalışmadığını kontrol eder.**

> Örneğin; Backend’in ilk açılışta MongoDB’ye bağlanması için geçen bir süre vardır. MongoDB bağlantısı sağlandıktan sonraPod’un arkasına Service eklenmesi mantıklıdır. **Bu sebeple, burada readiness’i kullanabiliriz.**

Aynı Liveness’ta olduğu gibi 3 farklı yöntem vardır:

* **http/get**, **tcp connection** ve **command çalıştırma**.

```shell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    team: development
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: ozgurozturknet/k8s:blue
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /healthcheck
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready	# Bu endpoint'e istek atılır, OK dönerse uygulama çalıştırılır.
            port: 80
          initialDelaySeconds: 20 # Başlangıçtan 20 sn gecikmeden sonra ilk kontrol yapılır.
          periodSeconds: 3 # 3sn'de bir denemeye devam eder.
          terminationGracePeriodSconds: 50 # Yukarıda yazıldı açıklaması.
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
	
# 46. Resource limits
	
* Containerimızı bir namespacenin içine kurduk. Eğer containerin memory ve cpu suna bir sınırlama getirmezsek namespace simizin tüm kaynağını kullanacaktır. 
* Bundan dolayı request(istenilen) ve limits(kullanabileceği son seviye) kriterleri belirleriz. Eğer memory belırlenen limite gelirse bunu gecemiyeceğinden yeniden pod oluşturulacaktır.

* Pod’ların CPU ve Memory kısıtlamalarını yönetmemizi sağlar. Aksini belirtmediğimiz sürece K8s üzerinde çalıştığı makinenin CPU ve Memory’sini %100 kullanabilir. Bu durum bir sorun oluşturur. Bu sebeple Pod’ların ne kadar CPU ve Memory kullanacağını belirtebiliriz.

### CPU Tanımı

![](<.gitbook/assets/image (25).png>)

### Memory Tanımı

![](.gitbook/assets/image-20211230020644173.png)

### YAML Dosyasında Tanım

```shell
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: requestlimit
  name: requestlimit
spec:
  containers:
  - name: requestlimit
    image: ozgurozturknet/stress
    resources:
      requests: # Podun çalışması için en az gereken gereksinim
        memory: "64M"	# Bu podu en az 64M 250m (yani çeyrek core)
        cpu: "250m" # = Çeyrek CPU core = "0.25"
      limits: # Podun çalışması için en fazla gereken limit
        memory: "256M"
        cpu: "0.5" # = "Yarım CPU Core" = "500m"
```

–> Eğer gereksinimler sağlanamazsa **container oluşturulamaz.**

–> Memory, CPU’ya göre farklı çalışıyor. K8s içerisinde memory’nin limitlerden fazla değer istediğinde engellemesi gibi bir durum yok. Eğer memory, limitlerden fazlasına ihtiyaç duyarsa “OOMKilled” durumuna geçerek pod restart edilir.

> **Araştırma konusu:** Bir pod’un limitlerini ve min. gereksinimlerini neye göre belirlemeliyiz?


# 47. Environment variable

Environment variables uygulamamızın kodu dışında bulunur, uygulamamızın çalıştığı yerde kullanilabilir. Uygulamalarımızın yapılandırmasını kodundan ayırmak için kullanılabilir, bu da uygulamalarımızın farklı ortamlara kolayca dağıtılmasını sağlar. Node.js uygulamalarında, ortam değişkenleri process.env genel değişkeni aracılığıyla kullanılabilir. .Env dosyası hiçbir zaman kaynak kodu deposunda olmamalıdır.
Environment variables ımage hard code olarak gömmeyız. container oluştururken env bölümü altında bunları tanımlarız.
	
Örneğin, bir node.js sunucusu oluşturduğumuzu ve veritabanı bilgilerini sunucu dosyaları içerisinde sakladığımızı düşünelim. Eğer, sunucu dosyalarından oluşturduğumuz container image’ı başka birisinin eline geçerse büyük bir güvenlik açığı meydana gelir. Bu sebeple **Environment Variables** kullanmamız gerekir.

### YAML Tanımlaması

```shell
apiVersion: v1
kind: Pod
metadata:
  name: envpod
  labels:
    app: frontend
spec:
  containers:
  - name: envpod
    image: ozgurozturknet/env:latest
    ports:
    - containerPort: 80
    env:
      - name: USER   # önce name'ini giriyoruz.
        value: "Ozgur"  # sonra value'sunu giriyoruz.
      - name: database
        value: "testdb.example.com"
```

### Pod içinde tanımlanmış Env. Var.’ları Görmek

```shell
kubectl exec <podName> -- printenv
```

## Port-Forward (Local -> Pod)

–> Kendi local sunucularımızdan istediğimiz k8s cluster’ı içerisindeki object’lere direkt ulaşabilmek için **port-forward** açabiliriz. Bu object’i test etmek için en iyi yöntemlerden biridir.

```shell
kubectl port-forward <objectType>/<podName> <localMachinePort>:<podPort>

kubectl port-forward pod/envpod 8080:80
# Benim cihazımdaki 8080 portuna gelen tüm istekleri,bu podun 80 portuna gönder.

curl 127.0.0.1:8080
# Test için yazabilirsin.
```

_CMD + C yapıldığında port-forwarding sona erer.
	
![image](https://user-images.githubusercontent.com/103413194/185083812-facb0cc7-243f-48fe-a061-7dd0d9debde4.png)


# 48. Volume

* Container’ın dosyaları container varolduğu sürece bir dosya içerisinde tutulur. Eğer container silinirse, bu dosyalarda birlikte silinir. Her yeni bir container yaratıldığında, container’a ait dosyalar yeniden yaratılır. (Stateless kavramı)
* Bazı containerlarda bu dosyaların silinmemesi (tutulması) gerekebilir. İşte bu durumda **Ephemeral (Geçici) Volume kavramı** devreye giriyor. (Stateful kavramı) Örneğin; DB container’ında data kayıplarına uğramamak için **volume** kurgusu yapılmalıdır.
* Ephemeral Volume’ler aynı pod içerisindeki tüm containerlara aynı anda bağlanabilir.
* Diğer bir amaç ise aynı pod içerisindeki birden fazla container’ın ortak kullanabileceği bir alan yaratmaktır.

> Ephemeral Volume’lerde Pod silinirse tüm veriler kaybolur. Fakat, container silinip tekrar yaratılırsa Pod’a bir şey olmadığı sürece veriler saklanır.

2 tip Ephemeral Volume vardır:

### emptyDir Volume

![image](https://user-images.githubusercontent.com/103413194/185383714-92c1418f-77e3-4e3f-9c2d-bd76462e6b23.png)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: emptydir
spec:
  containers:
  - name: frontend
    image: ozgurozturknet/k8s:blue
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /healthcheck
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
    volumeMounts:
    - name: cache-vol # volume ile bağlantı sağlamak için.
      mountPath: /cache # volume içerisindeki hangi dosya?
  - name: sidecar
    image: busybox
    command: ["/bin/sh"]
    args: ["-c", "sleep 3600"]
    volumeMounts:
    - name: cache-vol
      mountPath: /tmp/log # volume içerisindeki hangi dosya?
  volumes:
  - name: cache-vol # Önce volume'ü oluşturur sonra container'lara tanımlarız.
    emptyDir: {}
```

### hostPath Volume

* Çok nadir durumlarda kullanılır, kullanılırken dikkat edilmelidir.
* emptyDir’da volume klasörü pod içerisinde yaratılırken, hostPath’te volume klasörü worker node içerisinde yaratılır.
* 3 farklı tip’te kullanılır:
  * **Directory** –> Worker node üzerinde zaten var olan klasörler için kullanılır.
  * **DirectoryOrCreate** –> Zaten var olan klasörler ya da bu klasör yoksa yaratılması için kullanılır.
  * **FileOrCreate** –> Klasör değil! Tek bir dosya için kullanılır. Yoksa yaratılır.

![image](https://user-images.githubusercontent.com/103413194/185383793-0d817b3c-5765-4752-bb27-9ef27613e2ca.png)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hostpath
spec:
  containers:
  - name: hostpathcontainer
    image: ozgurozturknet/k8s:blue
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /healthcheck
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
    volumeMounts:
    - name: directory-vol
      mountPath: /dir1
    - name: dircreate-vol
      mountPath: /cache
    - name: file-vol
      mountPath: /cache/config.json       
  volumes:
  - name: directory-vol
    hostPath:
      path: /tmp
      type: Directory
  - name: dircreate-vol
    hostPath:
      path: /cache
      type: DirectoryOrCreate
  - name: file-vol
    hostPath:
      path: /cache/config.json
      type: FileOrCreate
```

## 49. Secret

* Hassas bilgileri (DB User, Pass vb.) Environment Variables içerisinde saklayabilsekte, bu yöntem ideal olmayabilir.
* Secret object’i sayesinde bu hassas bilgileri uygulamanın object tanımlarını yaptığımız YAML dosyalarından ayırıyoruz ve ayrı olarak yönetebiliyoruz.
* Token, username, password vb. tüm bilgileri secret içerisinde saklamak her zaman daha güvenli ve esnektir.
	
![image](https://user-images.githubusercontent.com/103413194/184618725-f653c641-e11b-45c8-b744-28d1d5e02f00.png)

![image](https://user-images.githubusercontent.com/103413194/184619377-38df4602-a948-42a8-8ef7-825dfe7faa74.png)
	
![image](https://user-images.githubusercontent.com/103413194/184619600-669203cd-ad0e-4a93-9fe9-bfba71961697.png)
	
![image](https://user-images.githubusercontent.com/103413194/184632990-f37a5574-b3a8-48b8-9eae-8bfc96d5847e.png)


* Birinci dosyanın yerine 2. dosyayı yazmış oluyoruz. Amaç hassas bilgileri korumak.
* 
### Declarative Secret Oluşturma


* Atayacağımız secret ile oluşturacağımız pod’lar **aynı namespace üzerinde olmalıdır.**
* 8 farklı tipte secret oluşturabiliriz. **`Opaque`** generic bir type’dır ve hemen hemen her hassas datamızı bu tipi kullanarak saklayabiliriz.
* 
	
![image](https://user-images.githubusercontent.com/103413194/184633752-04949cc4-0157-429f-90dd-68245a71eeee.png)

dosyayı nereden aldığını görüyoruz.

Örnek bir secret.yaml dosyası:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
stringData:		# Hassas data'ları stringData altına yazıyoruz.
  db_server: db.example.com
  db_username: admin
  db_password: P@ssw0rd!
```
stringData kısmını Data olarak da oluşturabiliriz. Fakat tanımlama farklı olur.

Secret içerisindeki dataları görmek için:

```shell
kubectl describe secrets <secretName>
```

### Imperative Secret Oluşturma

```shell
kubectl create secret generic <secretName> --from-literal=db_server=db.example.com --from-literal=db_username=admin
```

:warning: Buradaki `generic` demek yaml’da yazdığımız `Opaque` ‘a denk gelmektedir.

–> Eğer CLI üzerinde hassas verileri girmek istemiyorsak, her bir veriyi ayrı bir `.txt` dosyasına girip; `–from-file=db_server=server.txt` komutunu çalıştırabiliriz. `.txt` yerine `.json`da kullanabiliriz. O zaman `–from-file=config.json` yazmalıyız.
	
```shell
kubectl create secret generic <secretName> --from-file=db_server=server.txt --from-file=db_username=username.txt --from-file=db_password=password.txt
```
```shell
kubectl create secret generic <secretName> --from-file=config.json
```
burada config.json key in adı ve dosyanın içindeki de value sı oluyor.

Json örneği:
```yaml
{
   "apiKey": "6bba108d4b2212f2c30c71dfa279e1f77cc5c3b2",
}
```

### Pod’dan Secret’ı Okuma

–> Oluşturduğumuz Secret’ları Pod’a aktarmak için 2 yöntem vardır:

​ **Volume olarak aktarma** ve **Env variable olarak aktarma**

Her iki yöntemi de aşağıdaki YAML dosyasında bulabilirsiniz:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secretpodvolume
spec:
  containers:
  - name: secretcontainer
    image: ozgurozturknet/k8s:blue
    volumeMounts: # 2) Oluşturulan secret'lı volume'ü pod'a dahil ediyoruz.
    - name: secret-vol
      mountPath: /secret # 3) Uygulama içerisinde /secret klasörü volume'e dahil olmuştur. 
      # Artık uygulama içerisinden bu dosyaya ulaşıp, değerleri okuyabiliriz.
  volumes:				# 1) Önce volume'ü oluşturuyoruz ve secret'ı volume'e dahil ediyoruz.
  - name: secret-vol
    secret:
      secretName: mysecret3 
      # Bu pod'un içerisine exec ile girdiğimizde root altında secret klasörü göreceğiz. Buradaki dosyaların ismi "KEY", içindeki değerler "VALUE"dur. 
---
apiVersion: v1
kind: Pod
metadata:
  name: secretpodenv
spec:
  containers:
  - name: secretcontainer
    image: ozgurozturknet/k8s:blue
    env:	# Tüm secretları pod içerisinde env. variable olarak tanımlayabiliriz.
    # Bu yöntemde, tüm secretları ve değerlerini tek tek tanımladık.
      - name: username
        valueFrom:
          secretKeyRef:
            name: mysecret3 # mysecret3 isimli secret'ın "db_username" key'li değerini al.
            key: db_username
      - name: password
        valueFrom:
          secretKeyRef:
            name: mysecret3
            key: db_password
      - name: server
        valueFrom:
          secretKeyRef:
            name: mysecret3
            key: db_server
---
apiVersion: v1
kind: Pod
metadata:
  name: secretpodenvall
spec:
  containers:
  - name: secretcontainer
    image: ozgurozturknet/k8s:blue
    envFrom: # 2. yöntemle aynı, sadece tek fark tüm secretları tek bir seferde tanımlıyoruz.
    - secretRef:
        name: mysecret3
```

**Pod’lardaki Tüm Env Variable’ları Görmek**

```shell
kubectl exec <podName> -- printenv
```

# 50. ConfigMap

* ConfigMap’ler Secret objectleriyle tamamen aynı mantıkta çalışır. Tek farkı; Secret’lar etcd üzerinde base64 ile encoded edilerek encrypted bir şekilde saklanır. ConfigMap’ler ise encrypted edilmez ve bu sebeple hassas datalar içermemelidir.
* Pod içerisine **Volume** veya **Env. Variables** olarak tanımlayabiliriz.
* Oluşturulma yöntemleri Secret ile aynı olduğundan yukarıdaki komutlar geçerlidir.

![image](https://user-images.githubusercontent.com/103413194/184618994-d77e558b-7a55-4c96-b6b5-9caece1dbd17.png)


![image](https://user-images.githubusercontent.com/103413194/184619084-3bb761bc-e73a-4f90-82cf-23978c7c4cbb.png)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfigmap
data: # Key-Value şeklinde girilmelidir.
  db_server: "db.example.com"
  database: "mydatabase"
  site.settings: | # Birden fazla satır yazımı için "|" kullanılır.
    color=blue
    padding:25px
---
apiVersion: v1
kind: Pod
metadata:
  name: configmappod
spec:
  containers:
  - name: configmapcontainer
    image: ozgurozturknet/k8s:blue
    env:
      - name: DB_SERVER
        valueFrom:
          configMapKeyRef:
            name: myconfigmap
            key: db_server
      - name: DATABASE
        valueFrom:
          configMapKeyRef:
            name: myconfigmap
            key: database
    volumeMounts:
      - name: config-vol
        mountPath: "/config"
        readOnly: true
  volumes:
    - name: config-vol
      configMap:
        name: myconfigmap
```

### :small\_orange\_diamond::small\_blue\_diamond: `config.yaml` Dosyasından ConfigMap Oluşturma

Uygulamamız içerisinde kullanılmak üzere her bir environment için (QA, SIT ve PROD) `config.qa.yaml` ya da `config.prod.json` dosyamızın olduğunu düşünelim. CI/CD içerisinde bu environmentlara göre çalışacak doğru config dosyamızdan ConfigMap nasıl oluşturabiliriz?

```json
// config.json
{
  "name": "Berko",
  "surName": "Safran",
  "email": "berk@safran.com",
  "apiKey": "6bba108d4b2212f2c30c71dfa279e1f77cc5c3b2",
  "text": ["test", "deneme", "bir", "ki", 3, true]
}
```

1.  Kubectl aracılığıyla config.json dosyamızdan ConfigMap object’i oluşturalım.

    **Eğer bir CI/CD üzerinde çalıştırıyor ve logları takip edeceksek;**

```shell
# --dry-run normalde deprecated, fakat hala eski versionlarda kullanılıyor.
kubectl create configmap xyzconfig --from-file ${configFile} -o yaml --dry-run | kubectl apply -f -

# yeni hali --dry-run="client"
kubectl create configmap berkconfig --from-file config.json -o yaml --dry-run="client" | kubectl apply -f -

# Sondaki "-" (dash) çıkan pipe'ın ilk tarafından çıkan output'u alır.
```

* Yukarıdaki komutu çalıştırdığımızda kubectl config.json dosyasını alır; bize `kubectl apply` komutunu kullanabileceğimiz bir ConfigMap YAML dosyası içeriğini oluşturur ve bu içeriği **`–dry-run`** seçeneğinden dolayı **output olarak ekrana basar.**
* Gelen output’u alıp (bash “pipe | ” ile) `kubectl apply` komutu ile cluster’ımıza gönderiyoruz ve ConfigMap tanıtımını yapıyoruz.

**Eğer logları okumadan direkt config.json dosyasından bir ConfigMap yaratmak istiyorsak;**

```shell
# config.json yerine bir çok formatta dosya kullanabiliriz: ÖR: yaml
kubectl create configmap <configName> --from-file config.json
```

2\. Şimdi Pod’u oluştururken ConfigMap’imizdeki değerleri Pod içerisinde yer alan bir klasördeki bir dosyaya aktarmamız ve bunu “volume” mantığında bir dosya içerisinde saklamamız gerekiyor.

* “volumes” kısmında volume’ümüzü ve configMap’imizi tanımlayalım.
* Pod içerisindeki “volumeMounts” kısmında ise tanımladığımız bu volume’ü pod’umuza tanıtalım.
  * **`mountPath`** kısmında configMap içerisinde yer alan dosyanın, Pod içerisinde hangi klasör altına kopyalanacağı ve yeni isminin ne olacağını belirtebiliriz.
  * **`subPath`** ile configMap içerisindeki dosyanın (ÖR: `config.json`) ismini vermemiz gerekiyor. Böylelikle Pod yaratılırken “Bu dosyanın ismi değişecek.” demiş oluyoruz.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmappod4
spec:
  containers:
  - name: configmapcontainer
    image: ozgurozturknet/k8s:blue
    volumeMounts:
      - name: config-vol
        mountPath: "/config/newconfig.json"
        subPath: "config.json"
        readOnly: true
  volumes:
    - name: config-vol
      configMap:
        name: test-config # Bu ConfigMap içerisinde config.json dosyası vardır.
```

#### **Volumes’ün farklı yazımı**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmappod
spec:
  containers:
  - name: configmapcontainer
    image: ozgurozturknet/k8s:blue
    volumeMounts:
      - name: config-vol
        mountPath: "/config/newconfig.json"
        subPath: "config.json"
        readOnly: true
  volumes:
    - name: config-vol
      projected:
        sources:
        - configMap:
            name: test-config
            items:
              - key: config.json
                path: config.json
```

# 51. Node Affinity
	
![image](https://user-images.githubusercontent.com/103413194/184653159-07ee616e-bf58-4a44-9b72-ef6f7c81f2bb.png)

```
apiVersion: v1
kind: Pod
metadata:
  name: nodeaffinitypod1
spec:
  containers:
  - name: nodeaffinity1
    image: ozgurozturknet/k8s
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: app
            operator: In #In, NotIn, Exists, DoesNotExist
            values:
            - blue
---
apiVersion: v1
kind: Pod
metadata:
  name: nodeaffinitypod2
spec:
  containers:
  - name: nodeaffinity2
    image: ozgurozturknet/k8s
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: app
            operator: In
            values:
            - blue
      - weight: 2
        preference:
          matchExpressions:
          - key: app
            operator: In
            values:
            - red
---
apiVersion: v1
kind: Pod
metadata:
  name: nodeaffinitypod3
spec:
  containers:
  - name: nodeaffinity3
    image: ozgurozturknet/k8s
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: app
            operator: Exists #In, NotIn, Exists, DoesNotExist
```

affinity pod un altındaki spec kısmında olusturulur. 

**requiredDuringSchedulingIgnoredDuringExecution**
* podaffinity de amaç belirlenen (örneğin key: app ve values: blue) anahtarı nodun labelında arar. varsa o nodun altında podu oluşturur yoksa oluşturmaz.

* operator de ise node selector den ayrışmamızı ve daha fazla iş yapabilmemizi sağlıyor. 

* operatorde #In, NotIn, Exists, DoesNotExist
Örneğin operatorde **In**  yazıyorsa (key: app ve values: blue) labela sahıp node da schedule edıyor.
Örneğin operatorde **NotIn** yazıyorsa (key: app ve values: blue) labela **sahip olmayan** node da schedule edıyor. buna unaffinity denir.
Örneğin operatorde **Exists** yazıyorsa (key: app ) labela da olmasi yeterli olacakti.
Örneğin operatorde **Exists** yazıyorsa (key: app ) labela da olmamasi gerekir.
	
**preferredDuringSchedulingIgnoredDuringExecution:**
* weight degerine göre öncelik oluşuyor. Weight 1 ile 100 arasında değer alıyor. değeri yüksek olan oluşuyor.

* Yukarıdaki yaml dosyasından yola çıkarsak pod, weight 2 deki key ve value değerlerini sağlayan node da oluşturulacak eğer böyle bir node yoksa weight 1 deki key ve value değerlerine bakacak. Eğer onu da bulamazsa herhangi bir node da oluşturacak.


**preferredDuringSchedulingIgnoredDuringExecution:** ifadesinin içindeki IgnoreDuringExecution aslında pod oluşturulduktan sonra nodeworker daki label değişse de pod un çalışmaya devam etmesi anlamına geliyor.

👌 Yaml dosyasında 1. pod sadece key ve value değerini sağlıyorsa oluşacak. 2. pod her kriterlere göre her halükarda oluşacak ve 3. pod operator kısmı Exist olarak tanımlı olduğu için nodeworker da label da key:app olarak tanımlıysa oluşacak.
	
👌 Bu durumda sadece 2. pod oluşur.
	
![image](https://user-images.githubusercontent.com/103413194/185093686-6228bc7c-a606-45a0-a4d6-3c3360f298c9.png)

komutunu yazarsam 1. ve 3. pod da çalışacaktır.
	
# 52. Pod Affinity
	
Eğer biz podu hangi kriterlere sahip node üzerinde oluşturmamızı belirleyeceksek nodeaffinity yi kullanırız. Fakat eğer biz pod u oluştururken diğer podları da kriter olarak kabul ediyorsak o zaman podaffinity i kullanmalıyız.
	
![image](https://user-images.githubusercontent.com/103413194/185098987-e3adcd6a-5ac3-431a-a869-6e723370a8b5.png)

👌 Bu kurgudan yola çıkarsak, frondend ve database  farklı AZ lerde oluşmuş. bu ücretlendirilen bir durum. Bunun çözümü olarak database hangi AZ de ise  worknode ve frondend orada oluştur.
	
![image](https://user-images.githubusercontent.com/103413194/185099636-569f3766-a29f-48f2-b147-68e2dc852eec.png)

```
apiVersion: v1
kind: Pod
metadata:
  name: frontendpod
  labels:
    app: frontend
    deployment: test
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: cachepod
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - frontend
        topologyKey: kubernetes.io/hostname
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        podAffinityTerm:
          labelSelector:
            matchExpressions:
            - key: color
              operator: In
              values:
              - blue
          topologyKey: kubernetes.io/hostname
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
            - key: deployment
              operator: In
              values:
              - prod
          topologyKey: topology.kubernetes.io/zone
  containers:
  - name: cachecontainer
    image: redis:6-alpine
```

* pod frontendpod da topologkey e bakıldıgında hostnamesi(nodeworker) aynı olan yerde çalıştırılacak.
	
* podantıaffınıty de ise şunu diyoruz: key:deployment ve value:prod olan zone içerisinde çalıştırma. başka bir yerde çalıştır.
	
# 53. Taint ve Toleration
	
taint ve toleration kavramları node ların pod seçmesini sağlamaktadır.

```
kubectl taint nodes <node-name> key=value:taint-effect
kubectl taint nodes minikube platform=production:NoSchedule
```
	
`kubectl taint nodes minikube platform- `
komutu ile tainte silebiliyorum

Taint tanımlanırken dikkat edilmesi gereken 2 şey vardır biri key-value lerin düzgün yazılıp yazılmadığı diğeri ise taint effect in istenilen şekilde kullanılıp kulanılmadığıdır..

**Taint effect’in 3 farklı türü vardır.**
	
Bunlar: **1. NoSchedule, 2.PreferNoSchedule ve 3. NoExecute**

👌 1. **NoSchedule** da tolerationu node un taint i ile uyuşmayan podlar o poda sokulmaz.

👌 2. **PreferNoSchedule** da ise bu durum kesin değildir. Yani tolerationu node un taintine uyuşmayan podlar node a dahil edilmemeye çalışılsa da bu garanti edilmez.

👌 3. **NoExecute**  da içinde bulunan podlar içinde taint toleration uyuşmazlığı varsa o podlar dışarı atılır. Örneğin Node 1 in tainti mavi yapılmadan önce A B C D podları node 1 in içinde olsaydı, taintin mavi yapılması işleminden sonra node1 in içinde sadece D podu kalacaktı. Diğer podlar dışarı atılacaktı.

![image](https://user-images.githubusercontent.com/103413194/185172448-6fa12340-a00b-4c0a-93a2-e45975b0e35f.png)

burada bir tane container nginx imajından ve terminate edildiğinde container tekrar başlatılmayacak.
	
![image](https://user-images.githubusercontent.com/103413194/185168147-acce9937-d961-4028-b872-7cc8d05bfbf7.png)

**Not1** : Bir pod u istedigimiz node da calıştırmak istiyorsak o zaman node da ki key ve value değerlerini operator e yazılacak değişkeni de dikkate alarak node ve podaffinity ile halledebiliriz. Bu node larda başka podlarda çalışabilir. key ve value değerleri farklı olan. affinity ile aslında bir pod un nerede ve hangi kriterlere göre schedule edileceği belirlenir.

**Not2** : Eğer node un içinde benim belirlediğim kriterlere göre pod konumlandırmak istiyorsam o zaman taint ve toleration kullanmalıyım.

```
apiVersion: v1
kind: Pod
metadata:
  name: toleratedpod1
  labels:
    env: test
spec:
  containers:
  - name: toleratedcontainer1
    image: ozgurozturknet/k8s
  tolerations:
  - key: "platform"
    operator: "Equal"
    value: "production"
    effect: "NoSchedule"
---
apiVersion: v1
kind: Pod
metadata:
  name: toleratedpod2
  labels:
    env: test
spec:
  containers:
  - name: toleratedcontainer2
    image: ozgurozturknet/k8s
  tolerations:
  - key: "platform"
    operator: "Exists"
    effect: "NoSchedule"
	
```

![image](https://user-images.githubusercontent.com/103413194/185174451-884f2dda-5f47-4631-9554-33ba0cb521a0.png)

* yani color=blue uyuşmayan schedule etme ve aynı zamanda buna uymayan podları da sil.
	
# 54. DaemonSet
	
bu obje loglari vb. dışarıya aktarmak veya takip etmek istediğim loglar veya monitor için genellikle kullanılır.

![image](https://user-images.githubusercontent.com/103413194/185180637-61d8ebcb-dff6-4b4b-ab89-963cef452ebb.png)

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: logdaemonset
  labels:
    app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      # this toleration is to have the daemonset runnable on master nodes
      # remove it if your masters can't run pods
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/docker/containers
          readOnly: true
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/docker/containers
```
	
`minikube node add`
komutuyla yeni bir node ekleyebiliyoruz.
	
# 55. Persistent Volume ve Persistent Volume Claim
	
🗼 Clusterımızın dışında bir volume oluşturup onu podumuza baglamamız gerekiyor ki volumemızın yaşam süresi poddan uzun olsun.

![image](https://user-images.githubusercontent.com/103413194/185192393-99e3f9fc-bca5-4445-b746-cb2015c70267.png)

![image](https://user-images.githubusercontent.com/103413194/185193226-270fd520-10eb-440f-b000-f171334d22a5.png)

![image](https://user-images.githubusercontent.com/103413194/185193347-e0f7b539-5de1-4f76-a878-525c4bfd1e06.png)
	
persistentvolume de volume ile işimiz bitince ona nasıl davranacağımızı belirliyoruz. **3 secenek var.**

**1. Retain :** volume aynı şekilde kalıyor. içindeki dosyaları manuel olarak başka bir yere taşıyabiliyoruz.

**2. Recycle:** volume kalıyor ama içindeki dosyalar siliniyor. Doğal olarak veriye ulaşamıyoruz ama volume alanını tekrar kullanabiliyoruz.

**3. Delete:** volume tamamen siliyor.
	
**Not :** Volume oluşturdum. Fakat direk buna pod bağlayamıyorum. bunun için bir tane de persistent volume claim oluşturuyorum.
	
![image](https://user-images.githubusercontent.com/103413194/185195832-de1ad1ad-d1d4-412a-a87a-0b910a645c8c.png)

peki podu volume nasıl bağlayacagız.


![image](https://user-images.githubusercontent.com/103413194/185196490-477246cc-16b0-489b-a78d-6a2cde80afb2.png)

	
# 56. PV ve PVC uygulama
	
```
apiVersion: v1
kind: PersistentVolume
metadata:
   name: mysqlpv
   labels:
     app: mysql
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    path: /
    server: 10.255.255.10
  ```
	
Burada bir tane persistvolume oluşturuyoruz. bunu aslında sıstem kurucu oluşturuyor.
	
Daha sonra bir tane persistentvolumeclaim oluşturuyoruz.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysqlclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5Gi
  storageClassName: ""
  selector:
    matchLabels:
      app: "mysql"
 ```
	
Burada matchlabels uzeridnen bound oluyor. bunu şu şekilde görebiliyoruz.

![image](https://user-images.githubusercontent.com/103413194/185210487-7a18408d-f288-469b-94f0-fb90ffb2e945.png)

peki bunu poda nasıl bağlayacağız.
	
```
apiVersion: v1
kind: Secret
metadata:
  name: mysqlsecret
type: Opaque
stringData:
  password: P@ssw0rd!
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysqldeployment
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          ports:
            - containerPort: 3306
          volumeMounts:
            - mountPath: "/var/lib/mysql"
              name: mysqlvolume
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysqlsecret
                  key: password
      volumes:
        - name: mysqlvolume
          persistentVolumeClaim:
            claimName: mysqlclaim
```

# 57. Storage class

* Dinamik olarak bir volume ihtiyacim var. Persistentvolume olusturmak ve storage ayarlamak zor ve statik bir durum. Bunun yerine dinamik ve kolay bir volume ihtiyacimiz var. Bunu storage class olarak adlandiriyoruz.

![image](https://user-images.githubusercontent.com/103413194/185395610-4db0bb37-2f0d-4153-9a0f-dfa182fcdba0.png)

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standarddisk
parameters:
  cachingmode: ReadOnly
  kind: Managed
  storageaccounttype: StandardSSD_LRS
provisioner: kubernetes.io/azure-disk
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

sc adli dosyayi olusturuyoruz ve standarddisk adinda bir storageclasses olustu.

![image](https://user-images.githubusercontent.com/103413194/185396959-e9e1faf5-9778-432d-851d-c7645607f476.png)

Resimdeki **waitforfirstconsumer**, volume herhangi bir yere baglanana kadar olusturulmayacak demektir. **immediate** ise PVC olusturulunca hemen olusuyor.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysqlclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5Gi
  storageClassName: "standarddisk"
```
* Bu sekilde bir tane PVC olusturuyorum. onceki PVC den farki StorageClassName yi kullaniyorum ve olusturdugum standarddisk e bagliyorum.


```
apiVersion: v1
kind: Secret
metadata:
  name: mysqlsecret
type: Opaque
stringData:
  password: P@ssw0rd!
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysqldeployment
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql
          ports:
            - containerPort: 3306
          volumeMounts:
            - mountPath: "/var/lib/mysql"
              name: mysqlvolume
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysqlsecret
                  key: password
      volumes:
        - name: mysqlvolume
          persistentVolumeClaim:
            claimName: mysqlclaim
```

**ACIKLAMA** : Burada mysqlclaim adinda bir volumeden olusturulmak uzere bir volume(pv) talep ediyoruz. Bu volume mysqlvolume adinda "/var/lib/mysql" dosyasinin aldinta mountPath oluyor.

![image](https://user-images.githubusercontent.com/103413194/185399494-ee9abe78-f4f0-4f86-953d-7e745b024c06.png)


resimde de goruldugu uzere mysqlclaim bound oluyor pvc-... adindaki pv ye. resmin alt tarafinda da pv nin ozellikleri gorunuyor.


# 58. StatefulSet

## Kubernetes statefulset nedir? Neden böyle bir yapıya ihtiyaç duyulmuştur?

* Deployment ve ReplicationController durum bilgisi olmayan uygulamalarda kullanılır. StatefulSet, durum bilgisi olan uygulamaları yönetmek için kullanılan iş yükü API nesnesidir. Bir Pod setinin dağıtımını ve ölçeklendirmesini yönetir ve bu Pod'ların sıralanması ve benzersizliği hakkında garantiler sağlar. StatefulSet aynı zamanda bir denetleyicidir ancak Deployment’tan farklı olarak ReplicaSet oluşturmaz, benzersiz bir adlandırma kuralıyla Pod'u kendisi oluşturur. Bu nedenle bir StatefulSet'i önceki bir sürüme geri alamazsınız. Yalnızca Statefulset'i silebilir veya büyütebilir/azaltabilirsiniz.

* StatefulSets, Pod'larının kimliği ve sıralaması için sıralı bir dizin kullanır. Varsayılan olarak, StatefulSet Pod'ları oluşturuldukları sırada deploy eder ve ters sırada sonlandırılır.

![image](https://user-images.githubusercontent.com/103413194/185422538-ff4876cd-46f6-4252-a285-d3c1e78b571e.png)

![image](https://user-images.githubusercontent.com/103413194/185423573-96b49b0c-f23e-4c24-980a-f2ac21bb1c7a.png)

![image](https://user-images.githubusercontent.com/103413194/185423738-1e23baab-69ae-4792-a5ca-0711e22e5e10.png)


```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: cassandra
  name: cassandra
spec:
  clusterIP: None
  ports:
  - port: 9042
  selector:
    app: cassandra
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: cassandra
  labels:
    app: cassandra
spec:
  serviceName: cassandra
  replicas: 3
  selector:
    matchLabels:
      app: cassandra
  template:
    metadata:
      labels:
        app: cassandra
    spec:
      terminationGracePeriodSeconds: 1800
      containers:
      - name: cassandra
        image: gcr.io/google-samples/cassandra:v13
        imagePullPolicy: Always
        ports:
        - containerPort: 7000
          name: intra-node
        - containerPort: 7001
          name: tls-intra-node
        - containerPort: 7199
          name: jmx
        - containerPort: 9042
          name: cql
        resources:
          limits:
            cpu: "500m"
            memory: 1Gi
          requests:
            cpu: "500m"
            memory: 1Gi
        securityContext:
          capabilities:
            add:
              - IPC_LOCK
        lifecycle:
          preStop:
            exec:
              command: 
              - /bin/sh
              - -c
              - nodetool drain
        env:
          - name: MAX_HEAP_SIZE
            value: 512M
          - name: HEAP_NEWSIZE
            value: 100M
          - name: CASSANDRA_SEEDS
            value: "cassandra-0.cassandra.default.svc.cluster.local"
          - name: CASSANDRA_CLUSTER_NAME
            value: "K8Demo"
          - name: CASSANDRA_DC
            value: "DC1-K8Demo"
          - name: CASSANDRA_RACK
            value: "Rack1-K8Demo"
          - name: POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
        readinessProbe:
          exec:
            command:
            - /bin/bash
            - -c
            - /ready-probe.sh
          initialDelaySeconds: 15
          timeoutSeconds: 5
        volumeMounts:
        - name: cassandra-data
          mountPath: /cassandra_data
  volumeClaimTemplates:
  - metadata:
      name: cassandra-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: standard
      resources:
        requests:
          storage: 1Gi
	  
```
**Not**: Burada ClusterIp kismi none birakiliyor. Deployment ayrilan en buyuk ozellik.

↪️ `Bir container olusturup onun icinden statefulset imize ping atabiliriz. Yani buradaki cassandra ya ulasabiliriz.

`ping cassandra` komutu bizi cassandra lardan birine load balancer ile yonlendirecek.
`ping cassandra-1.cassandra` komutu ile de direk o containera ping atabiliriz.


# 59. Job
Bir pod veya podlar isini yapip kapanmasi gerektigini dusunelim. Bu durumda singlepod calistiramayiz. Cunku isini bitirmediyse tekrar calistirilmaz. deployment calistiramiyiz cunku kapandigi zaman tekrar calismaya basliyor. burada job isini bitirdiginde podlar silinmez. Cunku biz log kayitlarini kullanmak isteyebiliriz.

![image](https://user-images.githubusercontent.com/103413194/185429450-e11fa6c7-347b-41bb-a9c4-7b097bd6cdf1.png)

* Joblar genellikle 2 amac icin kullanilir. birincisi bir gorev dogrultusunda toplayacagi bilgiyi toplayip kapanabilir.
* 2. si bir bucketta islenmesi gereken bir durum oldugunda joblari kullaniriz.

```
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  parallelism: 2
  completions: 10
  backoffLimit: 5
  activeDeadlineSeconds: 100
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never #OnFailure 
```

↪️ completions ile toplam kac pod olusturmak istedigimizi

↪️ parallelism ile de bunu kacar kacar yapacagimizi belirtiyoruz. ilk once 2 pod acilacak isini yaptiktan sonra kapanacak daha sonra 2 pod daha acilacak toplam 10 pod olana kadar bu islem devam edecek.

↪️ backoffLimit da ise toplam kac hata alirsak bu islem iptal edilsin.

↪️ activeDeadlineSeconds de ise 100 saniye icinde islem tamamlanmassa iptal edilsin.


🔖 bu podlar isleri bittigi zaman silinmiyor. Bir zaman sonra ciddi bir yuk olusturuyorlar. bunun icin bunlari manuel olarak silmeliyiz.

`kubectl delete job.batch pi` 

komutuyla silebiliriz.




# 60. CronJob

🔖 Bir uygulamayı ya da sistemin bir özelliğini her dakika, her saat, her gün ya da belirlediğin zamanlarda çalıştırsın gibi özellikleri vardır. Örneğin her saat başı sisteminizdeki işlemci kullanımını bir log dosyasına koydurabilirsiniz, ya da yazdığınız bir uygulama var her saat başı o uygulamayı çalıştırmayı yapabilirsiniz. Uygulamanın kendisine bir thread tarzı birşey yapmadan halletmiş olursunuz.

🔖 Crontab linux işletim sistemlerinde zamana bağlı otomatik iş yapmak için bir uygulamadır. Crone Job olarak da anılır. 

![image](https://user-images.githubusercontent.com/103413194/185432121-7514cefb-2ef6-439e-93fc-79611745eeef.png)

```
apiVersion: batch/v1beta1 # not stable until kubernetes 1.21.
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
#
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * *
#
# https://crontab.guru/  ## linkten bu tabloya bakilabilir.

```
![image](https://user-images.githubusercontent.com/103413194/185539837-28cc4dae-706c-4bea-af04-5f4a15097ff9.png)

her iki saatte bir calis anlamina geliyor.

# 61. Authentication
* Kubernetes de kimlik olusturma ve kimlik dogrulama isi cluster disindan halledilecek sekilde tasarlanmistir. yani bir pod veya servis olusturur gibi kullanici olusturamayiz* 
![image](https://user-images.githubusercontent.com/103413194/185541338-9ef67b08-e532-4016-a4d4-c5582cec46cd.png)

buradaki sertifikalardan birini kubeapi de belirleyip kullaniriz.
kimlik dogrulama bu sekilde yapilabilir. fakat yetkilendirme icin de farkli islemler yapmaliyiz.
bir ornekle aciklayacak olursak:
developer adminle gorusup clusterlara ulasmak istiyor. adminde bir sertifika icin private key ve csr  istiyor.

![image](https://user-images.githubusercontent.com/103413194/185541936-347def58-a69d-4eae-b184-796ff2255b82.png)

biz bu sekilde private key imizi olusturuyoruz. daha sonra bu anahtari kullanarak bir srr hazirlamam gerekiyor. 

![image](https://user-images.githubusercontent.com/103413194/185542197-65476545-7755-45d1-a97b-314171fe9793.png)

burada olusturdugum csr dosyasini kubernetes admine gonderecegim ve diger isleri o halledecek.

**Key ve CSR oluşturma**
```
$ openssl genrsa -out ozgurozturk.key 2048 

$ openssl req -new -key ozgurozturk.key -out ozgurozturk.csr -subj "/CN=ozgur@ozgurozturk.net/O=DevTeam"
```

**CertificateSigningRequest oluşturma**
admin olarak asagidaki yaml dosyasini terminalde calistiriyoruz.

```
$ cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ozgurozturk
spec:
  groups:
  - system:authenticated
  request: $(cat ozgurozturk.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF
```

bu sekilde bir tane scr objem olustu.

daha sonra bunu admin olarak onaylamam gerekiyor.

**CSR onaylama ve crt'yi alma**

```
$ kubectl get csr

$ kubectl certificate approve ozgurozturk

$ kubectl get csr ozgurozturk -o jsonpath='{.status.certificate}' | base64 -d >> ozgurozturk.crt 
```
buradaki son komutu girerek crt uzantili bir sertifikam olusturuluyor.

daha sonra developer bu sertifikayi aldi ve minikube altina kaydetti. Developer bu sertifikayla config ayarlarina baglanip sertifikayi tanimlamasi gerekiyor.

```
$ kubectl config set-credentials ozgur@ozgurozturk.net --client-certificate=ozgurozturk.crt --client-key=ozgurozturk.key

```
bu komutla csr olusturduk.
simdi bunu minikube cluster ile iliskilendirmem gerekiyor. bunun icin bir context olusturmam gerekiyor.

```
$ kubectl config set-context ozgurozturk-context --cluster=minikube --user=ozgur@ozgurozturk.net

```
↪️ context, bir user ve onunla iliskili bir clusterin bir araya gelmesidir.

```

$ kubectl config use-context ozgurozturk-context
```

bu sekilde de ozgurozturk olarak clustere baglanabilirim.

Her kullanici varsayilan olarak sifir yetkiyle gelir. ama hic bir islem yapamaz. kullanicimiz authentication oldu ama auto kisitli.

# 62. Role Based Access Control
https://medium.com/devopsturkiye/kubernetes-role-base-access-and-cluster-role-binding-9210c1d9b50a

Kubernetes içerisinde yetkilendirme için çeşitli yöntemler bulunmaktadır. Role Based Access Control (RBAC) bunlardan biridir. Örneğin belirli bir service account için resource listeleme,silme,değiştime işlemi için yetki verip bu resource’ları yönetebiliriz.
RBAC, yetki ve rollerin tanimlanmasi, ve bu tanimlanmis yetki ve rollerin kimligi dogrulanmis objelere atanmasi prensibine gore calistir.

![image](https://user-images.githubusercontent.com/103413194/185735083-42a1d70e-c593-4a3e-b0eb-ba37919feaad.png)


RBAC için 3 önemli bileşeni vardır;

Subject: Kullanıcılar, gruplar veya service accountları temsil eder.
Resource: Üzerinde yetkilendirme yapılacak kubernetes api objelerini temsil eder. (Pods, services, configMap etc)
Verbs: Yapılacak işlemi temsil eder.
Note: Role namespace bazında çalışır.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"] # "services", "endpoints", "pods", "pods/log" etc.
  verbs: ["get", "watch", "list"] # "get", "list", "watch", "post", "put", "create", "update", "patch", "delete"
 ```

ClusterRole: ClusterRole belirli bir namespace için değil tüm kümedeki kaynaklara izin verir ve uygular. Yani tüm kubernetes altındaki tüm namespaceler için yetkilendirilmiş oluruz.

Note: ClusterRole ise cluster bazında çalışır. Tüm Cluster içinde yetkili olur.

Service Account: Podlar tarafından kullanılır ve ilgili podun yetkilerini belirler.


![image](https://user-images.githubusercontent.com/103413194/185735854-c9971397-bd6d-4087-b257-f65d002c8c1a.png)


Ornegin default namespace podlari okuyup listeleyebilecek bir rol olustururum. daha sonra olusturdugum ozgru@ozturk.net kullanicisina baglarim.

**simdiye kadar gordugumuz tum objeler namespace nin altinda olusturuldu. Fakat clusterRole namespacenin altinda olusturulmaz. ayrica nodeler ve bir kac tane daha obje namespacenin altinda olusturulmaz.**
Dogal olarak clusterRole namespace disindaki objelerde islem yapmak icinde kullanilir.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: secret-reader
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list"]
```

Burada olusturdugumuz rolleri ayrica binding etmemiz gerekiyor.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: ozgur@ozgurozturk.net # "name" is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```
Burada hangi rolu kime binding edecegimizi belirliyoruz. burada ozgur@ozgurozturk.net userine pod-reader rolunu baglamak istiyoruz.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-secrets-global
subjects:
- kind: Group
  name: DevTeam # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```
clusterbinding de rolebinding ile ayni. sadece farki cluster seviyesinde bu islemi yapiyoruz.

Rolleri olusturup baglayabilmek icin admin user da olmaliyiz.

# 63. Service Account

![image](https://user-images.githubusercontent.com/103413194/185736597-d08643fb-201a-4407-a1c5-8011ff88a684.png)

deploy edilen uygulamalarinda kupeapi ile gorusmesi gerekiyor ve cluster uzerinde islemler yapabilmesi gerekiyor. 
service accountlar service objesi olarak olusturabildigimiz tek hesap turudur. 

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: testsa
  namespace: default
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: podread
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: testsarolebinding
  namespace: default
subjects:
- kind: ServiceAccount
  name: testsa
  apiGroup: ""
roleRef:
  kind: Role
  name: podread
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: Pod
metadata:
  name: testpod
  namespace: default
spec:
  serviceAccountName: testsa
  containers:
  - name: testcontainer
    image: ozgurozturknet/k8s:latest
    ports:
    - containerPort: 80
 ```
 

# 64. Ingress

* Uygulamalarımızın dış dünyaya erişebilmesi/dış dünyadan erişilebilmesi için kullandığımız yapıdır.

**Örnek Senaryo**

![image](https://user-images.githubusercontent.com/103413194/185862726-fa7d089d-528c-42be-9f8b-ec8454907b36.png)

Azure gibi bir cloud service kullandığımızı varsayalım. Servisin içerisine bir LoadBalancer service’ı tanımlayalım. Azure, bizim adımıza bu LoadBalancer servisine bir IP atıyor ve bu IP’ye gelen tüm istekler bu LoadBalancer tarafından karşılanıyor. Biz de bu IP adresi ile DNS sayesinde domainimizi eşleştirerek, kullanıcıların kolay bir şekilde erişmesini sağlayalım.

Aynı k8s cluster içerisinde bir tane daha app ve aynı servisleri tanımladığımızı düşünelim. Hatta abartalım 2, 3, 4 derken her bir LoadBalancer için **Azure’a ekstradan para ödemem ve ayarlarını manuel yapmam gerekiyor.**

**Örnek Senaryo - 2**

![image](https://user-images.githubusercontent.com/103413194/185862854-54d059d4-2460-4fbc-8366-e880123bc42a.png)


Bu örnekte ise; kullanıcı **example.com**‘a girdiğinde A uygulaması; **example.com/contact**’a girdiğinde ise B uygulaması çalışsın. Bu durumu, DNS’te **/contact** path’i tanımlayamadığımız için LoadBalancer ile kurgulama şansımız yoktur. Fakat, bizim bir gateway gibi çalışan; kullanıcıyı her halükarda karşılayan bir load balancer’a ihtiyacım var.

İşte bu 2 örnekte/sorunu da **Ingress Controller ve Ingress Object** ile çözüyoruz:

## Ingress Controller ve Ingress Object

![image](https://user-images.githubusercontent.com/103413194/185862999-3756d143-8da5-41d2-95f7-2b3b2d840e2a.png)

* **Ingress Controller**, Nginx, Traefik, KrakenD gibi kullanabileceğimiz bir load balancer uygulamasına denir. Bu uygulamalardan birini seçip; k8s cluster’ımıza deploy edebilir ve LoadBalancer servisini kurarak dışarıya expose edebiliriz. Böylelikle, uygulamamız **public bir IP**’e sahip oluyor ve userlar ile tamamen bu IP üzerinden iletişim kurabiliriz.
* **Peki, gelen istekleri nasıl yönlendiriyoruz?** İşte bu esnada **Ingress Object**‘leri devreye giriyor. (_YAML dosyalarında tanımlanan yapılar_) Ingress Controller’larda yapacağımız konfigürasyonlarla Ingress Object’lerimizi ve Ingress Controller’ların gelen requestlere karşı nasıl davranması gerektiğini belirleyebiliriz.
* **Load balancing, SSL termination ve path-name based routing** gibi özelliklere sahiptir.

## Local’de Ingress Uygulama

### 1) minikube’ü Ayarlama

* Ingress’i çalıştırmak için minikube driver’ını değiştirmemiz gerekmektedir;
  * Windows için **Hyper-V**, macOS ve linux için **VirtualBox** seçebiliriz. Seçmeden önce kurulum yapmayı unutmayalım.

```shell
minikube start --driver=hyperv
```

### 2) Ingress Controller Seçimi ve Kurulumu

*   Biz nginx ile devam edeceğiz. Her ingress controller’ın kurulumu farklıdır. Kurulum detaylarını uygulamanın kendi web sitesinden öğrenebilirsiniz.

    **Kurulum detayları –>** https://kubernetes.github.io/ingress-nginx/deploy/
* minikube, yoğun olarak kullanılan nginx gibi bazı ingress controller’ı daha hızlı aktif edebilmek adına addon olarak sunmaktadır.

```shell
minikube addons enable ingress # ingress addonunu aktif eder.
minikube addons list # tüm addon'ları listeler.
```

* :point\_right: **Nginx** kurulduğu zaman kendisine **ingress-nginx** adında bir **namespace yaratır.**

```shell
# ingress-nginx namespace'ine ait tüm objectlerini listelemek için:
kubectl get all -n ingress-nginx 
```

### 3) Ingress Uygulamalarımızı Deploy Etmek

* **blueapp, greenapp, todoapp** için hem podlarımızı hem de servicelerimizi yaratan yaml dosyamızı deploy edelim.
* **Tüm service’lerin ClusterIP tipinde birer service olduğunu unutmayalım.**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blueapp
  labels:
    app: blue
spec:
  replicas: 2
  selector:
    matchLabels:
      app: blue
  template:
    metadata:
      labels:
        app: blue
    spec:
      containers:
      - name: blueapp
        image: ozgurozturknet/k8s:blue
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /healthcheck
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 3
---
apiVersion: v1
kind: Service
metadata:
  name: bluesvc
spec:
  selector:
    app: blue
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: greenapp
  labels:
    app: green
spec:
  replicas: 2
  selector:
    matchLabels:
      app: green
  template:
    metadata:
      labels:
        app: green
    spec:
      containers:
      - name: greenapp
        image: ozgurozturknet/k8s:green
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /healthcheck
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 3
---
apiVersion: v1
kind: Service
metadata:
  name: greensvc
spec:
  selector:
    app: green
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: todoapp
  labels:
    app: todo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: todo
  template:
    metadata:
      labels:
        app: todo
    spec:
      containers:
      - name: todoapp
        image: ozgurozturknet/samplewebapp:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: todosvc
spec:
  selector:
    app: todo
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### 4) Ingress Object’lerini Deploy Etme ve Ayarlama

* Load balancer için gerekli olan Ingress Controller’ımızı Nginx olarak seçtik ve kurduk.
* Her bir app için gerekli olan ClusterIP tipinde servislerimizi de kurduktan sonra, sıra kullanıcıların **example.com/a** yazdığında A service’ine gitmesi için gerekli **Ingress object’lerimizi** de deploy etmeye geldi.

> _**Araştırma Konusu:** –> Layer 7 nedir? Ne işe yarar?_

**blue, green app’ler için Ingress Object tanımlaması:**

* `pathType` kısmı `exact`veya `Prefix` olarak 2 şekilde ayarlanabilir. Detaylı bilgi için: https://kubernetes.io/docs/concepts/services-networking/ingress/

```shell
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: appingress
  annotations:
  # Nginx üzerinde ayarlar, annotations üzerinden yapılır.
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - host: k8sfundamentals.com
      http:
        paths:
          - path: /blue
            pathType: Prefix 
            backend:
              service:
                name: bluesvc
                port:
                  number: 80
          - path: /green
            pathType: Prefix
            backend:
              service:
                name: greensvc
                port:
                  number: 80
```

* Farklı bir `path` kullanarak hazırlanan Ingress Objecti:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: todoingress
spec:
  rules:
    - host: todoapp.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: todosvc
                port:
                  number: 80
```

### 5) Tanımlanan Ingress Object’leri test etme:

```yaml
kubectl get ingress
```

* Eğer URL’ler ile simüle etmek istersek, **hosts** dosyasını editlememiz gerekir.

