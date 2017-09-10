# DevOps Deploy Time Series API

Este projeto tem como objetivo o estudo de caso de um sistema distribuído utilizando o Kubernetes como plataforma.
Esta aplicação expõe uma [__API REST__] e recebe um [__JSON__] como payload, por exemplo:

```json
{
	"component": "postman",
	"version": "v0.1.2",
	"author": "Boaventura Rodrigues Neto",
	"status": "Success"
}
``` 

Alimentando uma base de dados [__Redis__] para acompanhamento do intervalo de tempo entre deploys e seus status.

### Requisitos

Este projeto foi desenvolvido localmente em um sistema macOS 10.12 tendo como requisitos as seguintes ferramentas:

[__VirtualBox__]

[__Homebrew__]

[__Docker for Mac__]

[__Postman__]

### Sobre o container Docker

A criação do container é feita utilizando a recomendação de seguir a order dos comandos visando colocar o conteúdo mais provável de alteração para o fim e juntando os comandos que alteram o conteúdo de maneira acentuada, de forma a minimizar o crescimento desnecessário da imagem.
O build da imagem está sendo feito automaticamente com a integração entre o __Github__ e o [__Docker Hub__], fazendo proveito deste facilidador para ter algo de [__CI__] desde já.
A aplicação está também passando por um processo de [__lint__] fazendo uso da ferramenta [__Rubocop__] com um hook no pre-commit do git. Caso queira fazer um fork deste projeto e não utilizar o Rubocop, você deve fazer o commit sem verificação: ```git commit --no-verify``` . 

### Preparando o ambiente

Primeiramente para interagir com o Kubernetes precisamos do kubectl, vamos instalá-lo:

```sh
brew install kubectl
```

O Kubernetes é implementado pelos mesmos princípios que habilitam o Google a executar bilhões de containers por semana, mas também é fantástico como ele poder fazer o ___scale down___ e ser executado em nossa estação de trabalho, através do [__Minikube__].

Instalando o minikube:

```sh
brew cask install minikube
```

Iniciando o minikube:

```sh
minikube start
```
O Minikube permite habilitar addons no cluster Kubernetes. O [__Heapster__] é um exemplo disso, vamos habilitá-lo para termos monitoria de performance do cluster:

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

Mesmo o último comando abrindo com sucesso a homepage a aplicação vai levar de 1 a 2min para estar online.

Exponha a porta 4567 via localhost:

```sh
DEVOPS_POD=$(kubectl get pod -l run=devops -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward $DEVOPS_POD 4567:4567
```
Abra o Postman, importe a coleção DevOps.postman_collection.json.
Utilize a funcionalidade Run e execute "Run DevOps" algumas vezes.

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
#### [] Deixar a aplicação mais resiliente com validação dos campos do payload etc.
#### [] Alterar a solução de persistência para um banco mais apropriado para time series como o InfluxDB.
#### [] Adicionar autorização e autenticação na aplicação e no banco de dados.
#### [] Implementar visualização em time series com a solução Cronograf.
#### [] Implementar CI/CD para o build da imagem do Docker com Jenkins.
#### [] Implementar teste automatizado com RSpec.
#### [] Criar namespaces no Kubernetes para os ambientes dev, staging e prod, para o Continuous Deployment.
#### [] Implementar solução de log aggregator como Graylog ou Fluentd.
#### [] Fazer deploy da solução em um provedor de computação em nuvem (pública).

[__VirtualBox__]: https://www.virtualbox.org/
[__Homebrew__]: https://brew.sh/
[__Docker for Mac__]: https://docs.docker.com/docker-for-mac/install/
[__Redis__]: https://redis.io/
[__Postman__]: https://www.getpostman.com/
[__lint__]: https://en.wikipedia.org/wiki/Lint_(software)
[__Rubocop__]: http://batsov.com/rubocop/
[__CI__]: https://en.wikipedia.org/wiki/Continuous_integration
[__API REST__]: https://en.wikipedia.org/wiki/Representational_state_transfer
[__JSON__]: http://www.json.org/
[__Docker Hub__]: https://hub.docker.com/r/brodriguesneto/devops/builds/
[__Minikube__]: https://kubernetes.io/docs/getting-started-guides/minikube/
[__Heapster__]: https://github.com/kubernetes/heapster