# 🎮 FCG.Orchestration - Orquestração de Infraestrutura

[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-K8s-326CE5.svg)](https://kubernetes.io/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC.svg)](https://www.terraform.io/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Arquitetura](#-arquitetura)
- [Componentes da Infraestrutura](#-componentes-da-infraestrutura)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Configuração e Execução](#-configuração-e-execução)
  - [Executando com Docker Compose](#-executando-com-docker-compose)
  - [Executando com Kubernetes (K8s)](#-executando-com-kubernetes-k8s)
- [Provisionamento de Infraestrutura (Terraform)](#-provisionamento-de-infraestrutura-terraform)
- [Monitoramento e Observabilidade](#-monitoramento-e-observabilidade)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Sobre o Projeto

**FCG.Orchestration** é o repositório responsável pela **orquestração completa da infraestrutura** do ecossistema de microserviços **FCG**. Este projeto centraliza toda a configuração de containers, serviços de mensageria, bancos de dados, cache e ferramentas de monitoramento necessárias para executar a plataforma em ambientes de desenvolvimento, homologação e produção.

### 🚀 Responsabilidade

Este repositório é responsável por:

- 🐳 **Orquestração de Containers** via Docker Compose
- ☸️ **Deployment em Kubernetes** com manifestos K8s
- 🏗️ **Provisionamento de Infraestrutura** na Azure via Terraform
- 📊 **Configuração de Observabilidade** com Seq (logs centralizados)
- 📨 **Setup de Mensageria** com Apache Kafka e Zookeeper
- 💾 **Gerenciamento de Bancos de Dados** SQL Server
- ⚡ **Configuração de Cache** com Redis
- 🔧 **Inicialização automatizada** de tópicos Kafka e schemas de banco

---

## 🏛️ Arquitetura

### Visão Geral do Ecossistema

```
┌─────────────────────────────────────────────────────────────────┐
│                        FCG.Orchestration                        │
│                  (Infraestrutura & Orquestração)                │
└────────────────────────────┬────────────────────────────────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
┌────────▼────────┐  ┌──────▼──────┐  ┌────────▼────────┐
│  FCG.Users      │  │FCG.Payments │  │  FCG.Catalog    │
│  API            │  │  API        │  │  API            │
│  (Port 5050)    │  │(Port 5060)  │  │  (Port 5070)    │
└────────┬────────┘  └──────┬──────┘  └────────┬────────┘
         │                  │                   │
         └──────────────────┼───────────────────┘
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
┌────────▼─────┐   ┌───────▼────────┐  ┌─────▼──────┐
│ SQL Server   │   │ Apache Kafka   │  │   Redis    │
│ (Port 1433)  │   │ (Port 9092)    │  │(Port 6379) │
└──────────────┘   └────────────────┘  └────────────┘
```

### Fluxo de Comunicação

```
┌──────────┐       ┌──────────┐       ┌──────────┐
│  Users   │──────▶│ Payments │──────▶│ Catalog  │
│   API    │       │   API    │       │   API    │
└────┬─────┘       └────┬─────┘       └────┬─────┘
     │                  │                   │
     │ user-created     │ payment-processed │
     └──────────────────┼───────────────────┘
                        │
                  ┌─────▼─────┐
                  │   Kafka   │
                  │  Topics   │
                  └───────────┘
```

---

## 🧩 Componentes da Infraestrutura

### Bancos de Dados

#### SQL Server 2022
- **Container:** `sqlserver-fcg`
- **Porta:** `1433`
- **Credenciais:**
  - Usuário: `sa`
  - Senha: `YourPassword123**`
- **Databases:**
  - `fcg_user` - Gerenciamento de usuários
  - `fcg_payment` - Transações financeiras e carteiras
  - `fcg_catalog` - Catálogo de jogos

**Health Check:** Verifica conexão a cada 10 segundos

### Cache & Performance

#### Redis 7
- **Container:** `fcg-redis`
- **Porta:** `6379`
- **Senha:** `CatalogApi`
- **Persistência:** AOF (Append Only File) habilitado
- **Uso:** Cache de catálogo de jogos, sessões

#### Redis Insight
- **Container:** `fcg-redis-insight`
- **Porta:** `5540`
- **Interface Web:** GUI para gerenciamento do Redis

### Mensageria

#### Apache Kafka 7.5.0
- **Container:** `kafka-fcg`
- **Portas:**
  - `9092` - Acesso externo (host)
  - `29092` - Comunicação interna (containers)
- **Listeners:**
  - `EXTERNAL://localhost:9092` - Clientes externos
  - `INTERNAL://kafka-fcg:29092` - Microserviços

#### Zookeeper 7.5.0
- **Container:** `zookeeper-fcg`
- **Porta:** `2181`
- **Função:** Coordenação do cluster Kafka

#### Kafka UI
- **Container:** `kafka-ui-fcg`
- **Porta:** `8081`
- **Acesso:** [http://localhost:8081](http://localhost:8081)
- **Funcionalidades:**
  - Visualização de tópicos
  - Monitoramento de mensagens
  - Gerenciamento de consumers
  - Inspeção de partições

### Tópicos Kafka (Criados Automaticamente)

| Tópico | Partições | Replicação | Descrição |
|--------|-----------|------------|-----------|
| `user-created` | 3 | 1 | Evento de criação de usuário |
| `order-placed` | 3 | 1 | Evento de pedido realizado |
| `payment-processed` | 3 | 1 | Evento de pagamento processado |

### Observabilidade

#### Seq
- **Container:** `seq-fcg`
- **Portas:**
  - `5341` - Ingestão de logs
  - `5342` - Interface Web
- **Acesso:** [http://localhost:5342](http://localhost:5342)
- **Credenciais:**
  - Usuário: `admin`
  - Senha: `YourPassword123**`
- **Função:** Centralização e análise de logs estruturados

### Microserviços

#### FCG.Users
- **Container:** `fcg-users`
- **Portas:**
  - `5050` - API HTTP
  - `5052` - Health Checks
- **Função:** Gerenciamento de usuários e autenticação JWT

#### FCG.Payments
- **Container:** `fcg-payments`
- **Portas:**
  - `5060` - API HTTP
  - `5062` - Health Checks
- **Função:** Processamento de pagamentos e carteiras digitais

#### FCG.Catalog
- **Container:** `fcg-catalog`
- **Portas:**
  - `5070` - API HTTP
  - `5072` - Health Checks
- **Função:** Gerenciamento de catálogo de jogos com cache Redis

#### FCG.Notifications
- **Container:** `fcg-notifications`
- **Função:** Envio de notificações via Azure Communication Services
- **Tipo:** Background Worker (sem porta exposta)

---

## 🛠️ Tecnologias Utilizadas

### Orquestração e Containers
- **Docker 24+** - Containerização
- **Docker Compose 2.20+** - Orquestração multi-container
- **Kubernetes 1.28+** - Orquestração em produção

### Infraestrutura como Código
- **Terraform 1.6+** - Provisionamento de recursos Azure
- **Azure Provider** - Integração com Azure Cloud

### Bancos de Dados e Cache
- **SQL Server 2022** - Banco relacional
- **Redis 7** - Cache in-memory

### Mensageria e Streaming
- **Apache Kafka 7.5.0** - Message Broker
- **Zookeeper 7.5.0** - Coordenação distribuída
- **Kafka UI** - Interface de gerenciamento

### Observabilidade
- **Seq** - Agregação e análise de logs
- **Serilog** - Logging estruturado

### Cloud Provider
- **Azure** - Plataforma cloud
- **Azure Container Registry (ACR)** - Registro de imagens Docker
- **Azure Communication Services** - Envio de e-mails

---

## ⚙️ Configuração e Execução

### Pré-requisitos

- ✅ **Docker Desktop** 24.0+ instalado
- ✅ **Docker Compose** 2.20+ instalado
- ✅ **Kubernetes** habilitado (Docker Desktop ou Minikube)
- ✅ **kubectl** CLI instalado
- ✅ **Terraform** 1.6+ instalado (para provisionamento Azure)
- ✅ Mínimo **8GB RAM** disponível
- ✅ Mínimo **20GB** de espaço em disco

---

## 🐳 Executando com Docker Compose

### 1️⃣ Clonar o Repositório

**Command Prompt:**
```cmd
git clone https://github.com/seu-usuario/FCG.Orchestration.git
cd FCG.Orchestration\docker
```

**Bash:**
```bash
git clone https://github.com/seu-usuario/FCG.Orchestration.git
cd FCG.Orchestration/docker
```

### 2️⃣ Verificar Configurações

Antes de iniciar, revise o arquivo [docker-compose.yml](docker/docker-compose.yml) e ajuste:
- Senhas (recomendado alterar em produção)
- Portas (caso haja conflito com serviços existentes)
- Recursos de memória (se necessário)

### 3️⃣ Iniciar a Infraestrutura

**Command Prompt:**
```cmd
cd docker
docker-compose up -d
```

**Bash:**
```bash
cd docker
docker-compose up -d
```

**Parâmetros:**
- `-d` - Executa em background (detached mode)

**Ordem de Inicialização:**
1. ✅ Zookeeper
2. ✅ Kafka
3. ✅ SQL Server (com health check)
4. ✅ Redis
5. ✅ Seq
6. ✅ Kafka Init (criação de tópicos)
7. ✅ Microserviços (Users, Payments, Catalog, Notifications)
8. ✅ UIs (Kafka UI, Redis Insight)

### 4️⃣ Verificar Status dos Containers

**Command Prompt:**
```cmd
docker ps
```

**Bash:**
```bash
docker ps
```

**Saída esperada:**
```
CONTAINER ID   IMAGE                                      STATUS         PORTS
abc123         fiapcr.azurecr.io/fcg-users:latest        Up 2 minutes   0.0.0.0:5050->8080/tcp
def456         fiapcr.azurecr.io/fcg-payments:latest     Up 2 minutes   0.0.0.0:5060->8080/tcp
ghi789         fiapcr.azurecr.io/fcg-catalog:latest      Up 2 minutes   0.0.0.0:5070->8080/tcp
jkl012         mcr.microsoft.com/mssql/server:2022       Up 3 minutes   0.0.0.0:1433->1433/tcp
mno345         confluentinc/cp-kafka:7.5.0               Up 3 minutes   0.0.0.0:9092->9092/tcp
pqr678         provectuslabs/kafka-ui:latest             Up 2 minutes   0.0.0.0:8081->8080/tcp
stu901         redis:7-alpine                             Up 3 minutes   0.0.0.0:6379->6379/tcp
vwx234         datalust/seq:latest                        Up 3 minutes   0.0.0.0:5342->80/tcp
```

### 5️⃣ Acessar os Serviços

#### APIs dos Microserviços

| Serviço | URL | Swagger |
|---------|-----|---------|
| **FCG.Users** | http://localhost:5050 | http://localhost:5050/swagger |
| **FCG.Payments** | http://localhost:5060 | http://localhost:5060/swagger |
| **FCG.Catalog** | http://localhost:5070 | http://localhost:5070/swagger |

#### Ferramentas de Gerenciamento

| Ferramenta | URL | Credenciais |
|------------|-----|-------------|
| **Kafka UI** | http://localhost:8081 | - |
| **Redis Insight** | http://localhost:5540 | - |
| **Seq (Logs)** | http://localhost:5342 | admin / YourPassword123** |

#### Bancos de Dados

| Serviço | Host | Porta | Credenciais |
|---------|------|-------|-------------|
| **SQL Server** | localhost | 1433 | sa / YourPassword123** |
| **Redis** | localhost | 6379 | senha: CatalogApi |

### 6️⃣ Verificar Logs

**Ver logs de todos os serviços:**
```cmd
docker-compose logs -f
```

**Ver logs de um serviço específico:**
```cmd
docker-compose logs -f fcg-users
docker-compose logs -f kafka
docker-compose logs -f sqlserver
```

**Ver logs centralizados no Seq:**
Acesse [http://localhost:5342](http://localhost:5342)

### 7️⃣ Parar a Infraestrutura

**Parar sem remover containers:**
```cmd
docker-compose stop
```

**Parar e remover containers:**
```cmd
docker-compose down
```

**Parar e remover containers + volumes (⚠️ apaga dados):**
```cmd
docker-compose down -v
```

### 8️⃣ Reiniciar um Serviço Específico

**Command Prompt:**
```cmd
docker-compose restart fcg-payments
```

**Bash:**
```bash
docker-compose restart fcg-payments
```

### 9️⃣ Executar Comandos dentro dos Containers

**Acessar o SQL Server:**
```cmd
docker exec -it sqlserver-fcg /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourPassword123**" -C
```

**Acessar o Redis CLI:**
```cmd
docker exec -it fcg-redis redis-cli -a CatalogApi
```

**Listar tópicos Kafka:**
```cmd
docker exec -it kafka-fcg kafka-topics --list --bootstrap-server localhost:9092
```

**Ver mensagens de um tópico Kafka:**
```cmd
docker exec -it kafka-fcg kafka-console-consumer --bootstrap-server localhost:9092 --topic user-created --from-beginning
```

---

## ☸️ Executando com Kubernetes (K8s)

### Pré-requisitos Kubernetes

- ✅ Cluster Kubernetes configurado (Docker Desktop, Minikube, AKS, etc.)
- ✅ `kubectl` instalado e configurado
- ✅ Contexto do cluster ativo

### 1 Verificar Cluster

**Command Prompt / Bash:**
```bash
kubectl cluster-info
kubectl get nodes
```

### 2 Criar Namespace

**Command Prompt / Bash:**
```bash
kubectl create namespace fcg-system
kubectl config set-context --current --namespace=fcg-system
```

**3 Aplicar**
```bash
kubectl apply -f k8s/ --recursive
```

### 4 Verificar Status dos Pods

**Command Prompt / Bash:**
```bash
kubectl get pods -n fcg-system
```

**Saída esperada:**
```
NAME                                READY   STATUS    RESTARTS   AGE
sqlserver-fcg-abc123               1/1     Running   0          3m
kafka-fcg-def456                   1/1     Running   0          3m
redis-fcg-ghi789                   1/1     Running   0          3m
fcg-users-jkl012                   1/1     Running   0          2m
fcg-payments-mno345                1/1     Running   0          2m
fcg-catalog-pqr678                 1/1     Running   0          2m
fcg-notifications-stu901           1/1     Running   0          2m
```

### 5 Verificar Services

**Command Prompt / Bash:**
```bash
kubectl get svc -n fcg-system
```

### 6 Acessar os Serviços

**Port-Forward para acessar localmente:**

```bash
# API Users
kubectl port-forward svc/fcg-users-service 5050:80 -n fcg-system

# API Payments
kubectl port-forward svc/fcg-payments-service 5060:80 -n fcg-system

# API Catalog
kubectl port-forward svc/fcg-catalog-service 5070:80 -n fcg-system

# Seq (Logs)
kubectl port-forward svc/seq-service 5342:80 -n fcg-system

# Kafka UI
kubectl port-forward svc/kafka-ui-service 8081:8080 -n fcg-system
```

### Remover Toda a Stack

**Command Prompt / Bash:**
```bash
kubectl delete namespace fcg-system
```

**⚠️ Atenção:** Isso remove todos os recursos, incluindo volumes persistentes!