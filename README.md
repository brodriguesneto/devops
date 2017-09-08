# DevOps Deploy Time Series API

Este projeto tem como objetivo o estudo de caso de um sistema distribuído utilizando o Kubernetes como plataforma.
Esta aplicação expõe uma API REST e recebe um JSON como payload, por exemplo:

```json
{
	"component": "postman",
	"version": "v0.1.2",
	"author": "Boaventura Rodrigues Neto",
	"status": "Success"
}
``` 

Alimentando uma base de dados Redis para acompanhamento do intervalo de tempo entre deploys e seus status.

### Requisitos

Este projeto foi desenvolvido localmente em um sistema macOS 10.12 tendo como requisitos as seguintes ferramentas:

[__VirtualBox__]

[__Homebrew__]

[__Docker for Mac__]

[__Postman__]

### Preparando o ambiente

Instale o kubectl:

```sh
brew install kubectl
```

Instale o minikube:

```sh
brew cask install minikube
```

Inicie o minikube:

```sh
minikube start
```
Habilite o Heapster no minikube:

```sh
minikube addons enable heapster
```

### Fazendo o deploy no Kubernetes

Vamos subir o Redis como "reliable singleton", subir a aplicação devops em um deploy com 3 réplicas e testar o seu funcionamento.

### Redis

Criando o volume persistente:

```sh
kubectl create -f redis-volume.yaml
```

Reivindicando o volume persistente:

```sh
kubectl create -f redis-volumeclaim.yaml
```

Criando o conjunto de réplicas do Redis

```sh
kubectl create -f redis-rs.yaml
```

Expondo o Redis como serviço internamente no Kubernetes

```sh
kubectl create -f redis-service.yaml
```

### DevOps

Fazendo o deploy da aplicação devops:

```sh
kubectl create -f devops-deployment.yaml
```

Criando o serviço para acesso externo:

```sh
kubectl create -f devops-service.yaml
```

Acessando a homepage da aplicação devops:

```sh
minikube service devops
```

### Testando

Exponha a porta 4567 via localhost:

```sh
DEVOPS_POD=$(kubectl get pod -l run=devops -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $DEVOPS_POD 4567:4567
```
Abra o Postman, importe a coleção DevOps.postman_collection.json.
Utilize a funcionalidade Runs e execute "Run DevOps" algumas vezes.

Vá até o navegador de Internet com a homepage da aplicação e adicione o caminho /api/v1/, exemplo:

```javascript
http://{{ip}}:{{port}}/api/v1/
````

Onde ip e port são fornecidos pelo comando ```minkube service devops```, anteriormente executado.

### Visualizando o Kubernetes

Em um terminal execute:

```sh
kubectl proxy
```

Acesse:

```javascript
http://localhost:8001/ui
```

### Roadmap

#### [] Implementar export no formato CSV
#### [] Alterar a solução de persistência para um banco mais apropriado para time series como o InfluxDB.
#### [] Adicionar atorização e autenticação na aplicação e no banco de dados.
#### [] Implementar visualização em time series como a solução Cronograf.
#### [] Implementar CI/CD para o build da imagem do Docker com Jenkins.
#### [] Implementar teste automatizado com RSpec.
#### [] Criar namespaces no Kubernetes para os ambientes dev, staging e prod, para o Continuous Deployment.
#### [] Implementar solução de log aggregator como Graylog ou Fluentd.

[__VirtualBox__]: https://www.virtualbox.org/
[__Homebrew__]: https://brew.sh/
[__Docker for Mac__]: https://docs.docker.com/docker-for-mac/install/
[__Redis__]: https://redis.io/
[__Postman__]: https://www.getpostman.com/