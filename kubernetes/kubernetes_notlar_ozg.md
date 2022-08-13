# ⛵ Nedir, Components, Nodes

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

![](<.gitbook/assets/Screen Shot 2021-12-12 at 18.26.50.png>)

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


![](<.gitbook/assets/Screen Shot 2021-12-12 at 19.23.15.png>)

### **Control Plane** (Master Nodes)

Aşağıdaki, 4 component k8s yönetim kısmını oluşturur ve **master-node** üzerinde çalışır.

* **Master-node** -> Yönetim modullerinin çalıştığı yerdir.
* **Worker-node** -> İş yükünün çalıştığı yerdir.
* 
![](<.gitbook/assets/Screen Shot 2022-07-19 at 12.17.04.png>)
![](<.gitbook/assets/Screen Shot 2021-12-12 at 18.48.28.png>)

* **kube-apiserver** **(api) –>** K8s’in beyni, **ana haberleşme merkezi, giriş noktasıdır**. Bir nev-i **Gateway** diyebiliriz. Tüm **componentler** ve **node**’lar, **kube-apiserver** üzerinden iletişim kurar. Ayrıca, dış dünya ile platform arasındaki iletişimi de **kube-apiserver** sağlar. Bu denli herkesle iletişim kurabilen **tek componenttir**. **Authentication ve Authorization** görevini üstlenir.

* **etcd** **->** K8s’in tüm cluster verisi, metada bilgileri ve Kubernetes platformunda oluşturulan componentlerin ve objelerin bilgileri burada tutulur. Bir nevi **Arşiv odası.** etcd, **key-value** şeklinde dataları tutar. Diğer componentler, etdc ile **direkt haberleşemezler.** Bu iletişimi, **kube-apiserver** aracılığıyla yaparlar.
* 
* **kube-scheduler (sched) ->** K8s’i çalışma planlamasının yapıldığı yer. Yeni oluşturulan ya da bir node ataması yapılmamış Pod’ları izler ve üzerinde çalışacakları bir **node** seçer. (_Pod = container_) Bu seçimi yaparken, CPU, Ram vb. çeşitli parametreleri değerlendirir ve **bir seçme algoritması sayesinde pod için en uygun node’un hangisi olduğuna karar verir.**
* 
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

![](<.gitbook/assets/Screen Shot 2021-12-12 at 23.53.55.png>)

![image](https://user-images.githubusercontent.com/103413194/184497612-6c6f651c-84b9-4b2b-87bc-f5b5653709a3.png)


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
    echo -e "######################################################################\n"
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

## Pod Yaşam Döngüsü

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
  * **`On-failure`** -> Kubelet sadece container hata alınca başlatır.\\
* **Succeeded** -> Pod başarıyla oluşturulmuşsa bu duruma geçer.
* **Failed** -> Pod başarıyla oluşturulmamışsa bu duruma geçer.
* **Completed** -> Pod başarıyla oluşturulup, çalıştırılır ve hatasız kapanırsa bu duruma geçer.
* :warning: **CrashLookBackOff** -> Pod oluşturulup sık sık kapanıyorsa ve RestartPolicy’den dolayı sürekli yeniden başlatılmaya çalışılıyorsa, k8s bunu algılar ve bu podu bu state’e getirir. Bu state de olan **podlar incelenmelidir.**

## Multi Container Pods

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

> _k8sfundamentals/podmulticontainer.yaml dosyası örneğine bakabilirsiniz._

### Init Container ile bir Pod içerisinde birden fazla Container Çalıştırma

Go’daki `init()` komutu gibi ilk çalışan container’dır. Örneğin, uygulama container’ın başlayabilmesi için bazı config dosyalarını fetch etmesi gerekir. Bu işlemi init container içerisinde yapabiliriz.

1. Uygulama container’ı başlatılmadan önce **Init Container** ilk olarak çalışır.
2. Init Container yapması gerekenleri yapar ve kapanır.
3. Uygulama container’ı, Init Container kapandıktan sonra çalışmaya başlar. **Init Container kapanmadan uygulama container’ı başlamaz.**

> _k8sfundamentals/podinitcontainer.yaml dosyası örneğine bakabilirsiniz._
