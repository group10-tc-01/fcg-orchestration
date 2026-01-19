# 🎮 FCG.Orchestration - Orquestração de Infraestrutura

[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-K8s-326CE5.svg)](https://kubernetes.io/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC.svg)](https://www.terraform.io/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Responsabilidades](#-responsabilidades)
- [Pré-requisitos](#-pré-requisitos)
- [Executando com Docker Compose](#-executando-com-docker-compose)
- [Executando com Kubernetes](#-executando-com-kubernetes)
- [Provisionamento com Terraform](#-provisionamento-com-terraform)
- [Componentes da Infraestrutura](#-componentes-da-infraestrutura)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Sobre o Projeto

**FCG.Orchestration** é o repositório centralizador da **infraestrutura completa** do ecossistema de microserviços FCG. Este projeto fornece toda a configuração necessária para executar a plataforma em diferentes ambientes através de múltiplas estratégias de orquestração.

## 🚀 Responsabilidades

Este repositório é **exclusivamente responsável** por:

### 📦 Orquestração e Deployment
- **Docker Compose**: Configuração completa para ambiente de desenvolvimento local
- **Kubernetes (K8s)**: Manifestos para deployment em clusters
- **Terraform**: Provisionamento automatizado de recursos na Azure Cloud

### 🏗️ Infraestrutura Base
- **Mensageria**: Apache Kafka com Zookeeper para comunicação assíncrona entre microserviços
- **Bancos de Dados**: SQL Server para persistência de dados dos microserviços
- **Observabilidade**: Seq para centralização e análise de logs estruturados

### ⚙️ Automação e Inicialização
- Scripts de inicialização automática de tópicos Kafka
- Jobs de criação de schemas de banco de dados
- Configuração de health checks para todos os serviços
- Setup de networking entre containers/pods

### 🔌 Integração de Microserviços
Este repositório orquestra os seguintes microserviços:
- **FCG.Users**: Gerenciamento de usuários e autenticação (porta 5050)
- **FCG.Payments**: Processamento de pagamentos e carteiras (porta 5062)
- **FCG.Catalog**: Catálogo de jogos 
- **FCG.Notifications**: Envio de notificações via Azure Communication Services

> **Importante**: Este repositório **NÃO contém código-fonte** dos microserviços. Apenas orquestra a execução das imagens Docker já buildadas.

---

## 📋 Pré-requisitos

### Para Docker Compose
- Docker Desktop 24.0+ ou Docker Engine + Docker Compose
- Mínimo 8GB RAM disponível
- Mínimo 20GB espaço em disco
- Git para clonar o repositório

### Para Kubernetes
- Cluster Kubernetes (Docker Desktop, Minikube, Kind ou AKS)
- kubectl CLI instalado e configurado
- Mínimo 12GB RAM disponível
- Contexto do cluster configurado

### Para Terraform (Opcional)
- Terraform 1.6+
- Azure CLI configurado
- Credenciais Azure com permissões adequadas
- Subscription ID da Azure

---

## 🐳 Executando com Docker Compose

### Visão Geral
O Docker Compose oferece a forma mais simples de executar toda a infraestrutura localmente para desenvolvimento.

### Passo 1: Clonar o Repositório

**Bash (Linux/Ubuntu):**
```bash
git clone https://github.com/seu-usuario/FCG.Orchestration.git
cd FCG.Orchestration/docker
```

### Passo 2: Iniciar Toda a Infraestrutura

**Bash:**
```bash
cd docker
docker-compose up -d
```

**Parâmetros:**
- `-d`: Executa em background (modo detached)

**Ordem de inicialização automática:**
1. Zookeeper → Kafka → Kafka Init (criação de tópicos)
2. SQL Server (aguarda health check)
3. Seq (logs)
4. Microserviços (Users, Payments, Catalog, Notifications)
5. UIs de gerenciamento (Kafka UI)

### Passo 3: Verificar Status

**Listar containers em execução:**
```bash
docker-compose ps
```

**Verificar logs em tempo real:**
```bash
# Todos os serviços
docker-compose logs -f

# Serviço específico
docker-compose logs -f fcg-users
docker-compose logs -f kafka
```

### Passo 4: Acessar os Serviços

#### APIs dos Microserviços

| Serviço | URL Base | Swagger UI | Health Check |
|---------|----------|------------|--------------|
| FCG.Users | http://localhost:5050 | http://localhost:5050/swagger | http://localhost:5052/health |
| FCG.Payments | http://localhost:5062 | http://localhost:5062/swagger | http://localhost:5062/health |
| FCG.Catalog | http://localhost:5072 | http://localhost:5072/swagger | http://localhost:5072/health |

#### Ferramentas de Gerenciamento

| Ferramenta | URL | Descrição |
|------------|-----|-----------|
| Kafka UI | http://localhost:8081 | Interface para gerenciar tópicos, mensagens e consumers |
| Seq | http://localhost:5342 | Logs centralizados (admin / YourPassword123**) |

#### Conexões Diretas

| Serviço | Host | Porta | Credenciais |
|---------|------|-------|-------------|
| SQL Server | localhost | 1433 | sa / YourPassword123** |
| Kafka Bootstrap | localhost | 9092 | - |

### Passo 5: Testar a Infraestrutura

**Verificar tópicos Kafka criados:**
```bash
docker exec -it kafka-fcg kafka-topics --list --bootstrap-server localhost:9092
```

**Saída esperada:**
```
user-created
order-placed
payment-processed
```

**Conectar ao SQL Server:**
```bash
docker exec -it sqlserver-fcg /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourPassword123**" -C
```

**Verificar databases:**
```sql
SELECT name FROM sys.databases;
GO
```

### Comandos Úteis

**Reiniciar um serviço específico:**
```bash
docker-compose restart fcg-payments
```

**Parar todos os serviços (mantém volumes):**
```bash
docker-compose stop
```

**Parar e remover containers:**
```bash
docker-compose down
```

**Parar e remover containers + volumes (⚠️ apaga dados):**
```bash
docker-compose down -v
```

**Rebuild e restart de um serviço:**
```bash
docker-compose up -d --build fcg-users
```

**Ver uso de recursos:**
```bash
docker stats
```

### Troubleshooting Docker Compose

**Problema: Porta já em uso**
```bash
# Verificar o que está usando a porta
sudo lsof -i :5050
# ou
sudo netstat -tlnp | grep :5050
```

**Problema: Container não inicia**
```bash
# Ver logs detalhados
docker-compose logs fcg-payments

# Ver eventos do container
docker events
```

**Problema: Banco de dados não conecta**
```bash
# Verificar health check do SQL Server
docker inspect sqlserver-fcg | grep -A 10 Health

# Testar conectividade
docker exec sqlserver-fcg /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourPassword123**" -Q "SELECT @@VERSION" -C
```

---

## ☸️ Executando com Kubernetes

### Visão Geral
O Kubernetes oferece orquestração avançada com alta disponibilidade, escalabilidade e recursos de produção.

### 🚀 Opção 1: Deploy Automatizado (Recomendado)

A forma mais rápida de fazer o deploy completo é usando o script automatizado:

**Bash:**
```bash
cd k8s
chmod +x deploy.sh
./deploy.sh
```

**O que o script faz automaticamente:**
1. ✅ Cria cluster Kind (se não existir)
2. ✅ Aplica namespace
3. ✅ Configura secrets e configmaps
4. ✅ Deploy do SQL Server e aguarda ficar pronto
5. ✅ Deploy do Kafka/Zookeeper e aguarda ficar pronto
6. ✅ Executa job de inicialização do banco
7. ✅ Deploy de todos os microserviços

**Verificar status após o deploy:**
```bash
kubectl get pods -n fcg-system -w
```

**Remover tudo rapidamente:**
```bash
cd k8s
chmod +x delete-all.sh
./delete-all.sh
```

---

### 📖 Opção 2: Deploy Manual (Passo a Passo)

Se preferir executar cada etapa manualmente para entender o processo:

#### Passo 1: Preparar o Cluster

**Verificar cluster ativo:**
```bash
kubectl cluster-info
kubectl get nodes
```

**Criar e configurar namespace:**
```bash
kubectl create namespace fcg-system
kubectl config set-context --current --namespace=fcg-system
```

#### Passo 2: Configurar Secrets (Obrigatório)

Antes do deploy, você **DEVE** configurar as secrets com suas credenciais reais.

**Editar o arquivo de secrets:**
```bash
cd k8s
nano 01-secrets.yaml  # ou vim, code, etc.
```

**Atualizar valores em base64:**
```bash
# Gerar senha do SQL Server
echo -n "SuaSenhaForte123!" | base64

# Gerar Connection String do Azure Communication Services
echo -n "endpoint=https://...;accesskey=..." | base64
```

**Aplicar secrets:**
```bash
kubectl apply -f 01-secrets.yaml
```

#### Passo 3: Deploy da Infraestrutura Base

**Aplicar manifestos na ordem correta:**

```bash
# 1. Namespace
kubectl apply -f 00-namespace.yaml

# 2. Secrets
kubectl apply -f 01-secrets.yaml

# 3. ConfigMaps
kubectl apply -f 02-configmaps.yaml

# 4. SQL Server
kubectl apply -f 03-sqlserver-deployment.yaml
kubectl apply -f 05-sqlserver-service.yaml

# 5. Aguardar SQL Server ficar ready
kubectl wait --for=condition=ready pod -l app=sqlserver --timeout=300s

# 6. Kafka e Zookeeper
kubectl apply -f 04-kafka-deployment.yaml
kubectl apply -f 06-kafka-service.yaml

# 7. Aguardar Kafka ficar ready
kubectl wait --for=condition=ready pod -l app=kafka --timeout=300s

# 8. Job de inicialização do SQL Server
kubectl apply -f 07-sqlserver-init-job.yaml

# Verificar sucesso do job
kubectl wait --for=condition=complete job/sqlserver-init-job --timeout=300s
```

#### Passo 4: Deploy dos Microserviços

```bash
cd 07-microservices

# Aplicar todos os microserviços
kubectl apply -f .

# Ou aplicar individualmente
kubectl apply -f fcg-users-deployment.yaml
kubectl apply -f fcg-users-service.yaml

kubectl apply -f fcg-payments-deployment.yaml
kubectl apply -f fcg-payments-service.yaml

kubectl apply -f fcg-catalog-deployment.yaml
kubectl apply -f fcg-catalog-service.yaml

kubectl apply -f fcg-notifications-deployment.yaml
kubectl apply -f fcg-notifications-service.yaml
```

#### Passo 5: Verificar Status do Deploy

**Verificar todos os pods:**
```bash
kubectl get pods -n fcg-system
```

**Saída esperada (todos em Running):**
```
NAME                                  READY   STATUS    RESTARTS   AGE
sqlserver-fcg-7d8f9c4b6-x9k2m        1/1     Running   0          5m
kafka-fcg-6b5c8d9f7-p3h8n            1/1     Running   0          4m
zookeeper-fcg-5c7d9f8b4-m2k5j        1/1     Running   0          4m
fcg-users-5f8c7b9d6-q4n7k            1/1     Running   0          2m
fcg-payments-7d9f8c6b5-w8j3m         1/1     Running   0          2m
fcg-catalog-6c8d9f7b5-t5k9n          1/1     Running   0          2m
fcg-notifications-8f9d7c6b4-r6m2p    1/1     Running   0          2m
```

**Verificar services:**
```bash
kubectl get svc -n fcg-system
```

**Verificar logs de um pod:**
```bash
# Listar pods
kubectl get pods -n fcg-system

# Ver logs
kubectl logs <pod-name> -n fcg-system -f

# Exemplo
kubectl logs fcg-users-5f8c7b9d6-q4n7k -n fcg-system -f
```

#### Passo 6: Acessar os Serviços

##### Opção A: Port Forwarding (Desenvolvimento/Testes)

**Acessar APIs localmente:**
```bash
# FCG.Users API
kubectl port-forward svc/fcg-users-service 5050:80 -n fcg-system

# FCG.Payments API
kubectl port-forward svc/fcg-payments-service 5062:80 -n fcg-system

# FCG.Catalog API
kubectl port-forward svc/fcg-catalog-service 5072:80 -n fcg-system

# Kafka UI
kubectl port-forward svc/kafka-ui-service 8081:8080 -n fcg-system

# Seq (Logs)
kubectl port-forward svc/seq-service 5342:80 -n fcg-system
```

**Acessar após port-forward:**
- FCG.Users: http://localhost:5050/swagger
- FCG.Payments: http://localhost:5062/swagger
- FCG.Catalog: http://localhost:5072/swagger
- Kafka UI: http://localhost:8081
- Seq: http://localhost:5342

---

### 🛠️ Comandos Úteis Kubernetes

**Descrever um recurso:**
```bash
kubectl describe pod <pod-name> -n fcg-system
kubectl describe svc fcg-users-service -n fcg-system
```

**Executar comandos em um pod:**
```bash
# Bash no container
kubectl exec -it <pod-name> -n fcg-system -- /bin/bash

# Comando direto
kubectl exec -it <pod-name> -n fcg-system -- ls -la
```

**Ver eventos do cluster:**
```bash
kubectl get events -n fcg-system --sort-by='.lastTimestamp'
```

**Restart de um deployment:**
```bash
kubectl rollout restart deployment/fcg-users -n fcg-system
```

**Ver histórico de deployments:**
```bash
kubectl rollout history deployment/fcg-users -n fcg-system
```

**Rollback de um deployment:**
```bash
kubectl rollout undo deployment/fcg-users -n fcg-system
```

---

### 🔧 Troubleshooting Kubernetes

**Problema: Pod não inicia (CrashLoopBackOff)**
```bash
# Ver logs do container que falhou
kubectl logs <pod-name> -n fcg-system --previous

# Descrever pod para ver eventos
kubectl describe pod <pod-name> -n fcg-system
```

**Problema: ImagePullBackOff**
```bash
# Verificar se a imagem existe no registry
kubectl describe pod <pod-name> -n fcg-system

# Verificar secrets do registry
kubectl get secrets -n fcg-system
```

**Problema: Service não conecta**
```bash
# Testar conectividade de dentro do cluster
kubectl run -it --rm debug --image=busybox --restart=Never -n fcg-system -- sh

# Dentro do pod de debug
nslookup fcg-users-service
wget -O- http://fcg-users-service:80/health
```

**Problema: Banco de dados não conecta**
```bash
# Port-forward do SQL Server
kubectl port-forward svc/sqlserver-service 1433:1433 -n fcg-system

# Testar com SQL Client local
sqlcmd -S localhost -U sa -P "YourPassword123**" -Q "SELECT @@VERSION"
```

---

### 🗑️ Remover Toda a Infraestrutura

**Opção 1: Script Automatizado (Rápido)**
```bash
cd k8s
./delete-all.sh
```

O script oferece opção de deletar também o cluster Kind.

**Opção 2: Manual**

**Remover apenas microserviços:**
```bash
kubectl delete -f 07-microservices/ -n fcg-system
```

**Remover toda a stack (⚠️ dados serão perdidos):**
```bash
kubectl delete namespace fcg-system
```

**Ou remover cada recurso individualmente:**
```bash
cd k8s
kubectl delete -f . --recursive
```
---

## 🧩 Componentes da Infraestrutura

### Bancos de Dados

#### SQL Server 2022
- **Porta**: 1433
- **Credenciais padrão**: sa / YourPassword123**
- **Databases**:
  - `fcg_user` - Gerenciamento de usuários
  - `fcg_payment` - Transações e carteiras
  - `fcg_catalog` - Catálogo de jogos
- **Health Check**: Verifica conexão a cada 10 segundos

### Mensageria

#### Apache Kafka 7.5.0
- **Portas**:
  - `9092` - Acesso externo
  - `29092` - Comunicação interna
- **Tópicos criados automaticamente**:
  - `user-created` - Eventos de criação de usuário
  - `order-placed` - Eventos de pedidos
  - `payment-processed` - Eventos de pagamento

#### Zookeeper 7.5.0
- **Porta**: 2181
- **Função**: Coordenação do cluster Kafka

#### Kafka UI
- **Porta**: 8081
- **Função**: Interface web para gerenciamento de tópicos e mensagens

### Observabilidade

#### Seq
- **Portas**:
  - `5341` - Ingestão de logs
  - `5342` - Interface web
- **Credenciais padrão**: admin / YourPassword123**
- **Função**: Logs estruturados centralizados

### Microserviços

| Microserviço | Porta HTTP | Porta Health | Função |
|--------------|-----------|--------------|---------|
| FCG.Users | 5050 | 5052 | Gerenciamento de usuários e autenticação JWT |
| FCG.Payments | 5062 | 5062 | Processamento de pagamentos e carteiras |
| FCG.Catalog | 5072 | 5072 | Catálogo de jogos  |
| FCG.Notifications | - | - | Envio de notificações (background worker) |



### Problemas Comuns

#### Docker Compose

**Porta já em uso:**
```bash
# Identificar processo usando a porta
sudo lsof -i :5050
sudo netstat -tlnp | grep :5050

# Parar o processo ou alterar porta no docker-compose.yml
```

**Container reiniciando constantemente:**
```bash
# Ver logs detalhados
docker logs <container-name> --tail 100

# Ver últimos eventos
docker events --filter 'container=<container-name>'
```

**Erro de conexão com banco de dados:**
```bash
# Verificar health check
docker inspect sqlserver-fcg | grep -A 10 Health

# Testar conexão manual
docker exec sqlserver-fcg /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourPassword123**" -Q "SELECT 1" -C
```

#### Kubernetes

**Pod em CrashLoopBackOff:**
```bash
# Ver logs do container que falhou
kubectl logs <pod-name> -n fcg-system --previous

# Descrever eventos do pod
kubectl describe pod <pod-name> -n fcg-system
```

**ImagePullBackOff:**
```bash
# Verificar configuração do registry
kubectl describe pod <pod-name> -n fcg-system

# Verificar secrets
kubectl get secrets -n fcg-system
```

**Service não conecta:**
```bash
# Debug de conectividade
kubectl run -it --rm debug --image=busybox --restart=Never -n fcg-system -- sh

# Testar DNS
nslookup fcg-users-service

# Testar conectividade HTTP
wget -O- http://fcg-users-service:80/health
```

---