# FCG fase 04 - Kubernetes local

Este diretorio sobe um ambiente Kubernetes local para a fase 04 usando Kind.

## Arquitetura

- Cluster Kind: `fcg-fase04-local`
- Namespace de infra: `fcg-infra`
- Namespaces de aplicacao: `fcg-users`, `fcg-payments`, `fcg-catalog`

A infra fica centralizada aqui porque localmente os tres microsservicos usam os mesmos servicos base. Na Azure, essa infra sera criada separadamente.

## O que sobe

Infra em `fcg-infra`:

- SQL Server 2022 com databases `fcg_user`, `fcg_payments` e `fcg_catalog`
- Kafka em modo KRaft
- MongoDB com database usado pelo payments
- Redis usado pelo catalog
- Elasticsearch com indice `games` criado pelo catalog no startup
- Seq
- Kafka UI
- RedisInsight
- Kibana

Aplicacoes:

- `fcg-users` em namespace proprio
- `fcg-payments` em namespace proprio
- `fcg-catalog` em namespace proprio

## Requisitos

Execute pelo WSL ou por um shell com acesso ao Docker:

- Docker
- Kind
- kubectl

Portas usadas no host:

| Uso | URL |
| --- | --- |
| Users API | `http://localhost:5050` |
| Payments API | `http://localhost:5054` |
| Catalog API | `http://localhost:5000` |
| Kafka UI | `http://localhost:8081` |
| Seq UI | `http://localhost:5342` |
| RedisInsight | `http://localhost:5540` |
| Elasticsearch | `http://localhost:9200` |
| Kibana | `http://localhost:5601` |
| Kubernetes API | `https://127.0.0.1:16443` |

## Subir tudo

```bash
cd fcg-orchestration/fase-04/k8s
bash up.sh
```

O script:

1. Cria o cluster Kind se ele nao existir.
2. Builda as imagens `fcg-users:local`, `fcg-payments:local` e `fcg-catalog:local`.
3. Carrega as imagens no Kind.
4. Cria secrets locais no Kubernetes.
5. Sobe a infra.
6. Inicializa os databases do SQL Server.
7. Sobe as tres aplicacoes.

Secrets podem ser sobrescritos por variaveis de ambiente:

```bash
FCG_LOCAL_SQL_PASSWORD='OutraSenha123!' \
FCG_LOCAL_SEQ_PASSWORD='OutraSenha123!' \
FCG_LOCAL_JWT_SECRET_KEY='uma-chave-local-com-mais-de-32-caracteres' \
bash up.sh
```

## Derrubar

Remover os namespaces e manter o cluster:

```bash
bash down.sh
```

Remover o cluster Kind inteiro:

```bash
bash down.sh --cluster
```

## Conferencia rapida

```bash
kubectl get ns
kubectl get pods -n fcg-infra
kubectl get pods -n fcg-users
kubectl get pods -n fcg-payments
kubectl get pods -n fcg-catalog
```

Health checks:

```bash
curl http://localhost:5050/health
curl http://localhost:5054/health
curl http://localhost:5000/health
```

Logs:

```bash
kubectl logs -n fcg-users deployment/fcg-users -f
kubectl logs -n fcg-payments deployment/fcg-payments -f
kubectl logs -n fcg-catalog deployment/fcg-catalog -f
kubectl logs -n fcg-infra deployment/kafka -f
kubectl logs -n fcg-infra deployment/sqlserver -f
```

Describe:

```bash
kubectl describe pod -n fcg-users -l app.kubernetes.io/name=fcg-users
kubectl describe pod -n fcg-payments -l app.kubernetes.io/name=fcg-payments
kubectl describe pod -n fcg-catalog -l app.kubernetes.io/name=fcg-catalog
```

Reiniciar deployments:

```bash
kubectl rollout restart deployment/fcg-users -n fcg-users
kubectl rollout restart deployment/fcg-payments -n fcg-payments
kubectl rollout restart deployment/fcg-catalog -n fcg-catalog
```

Ver services e portas:

```bash
kubectl get svc -A
kubectl get endpoints -A
```

Entrar em um pod:

```bash
kubectl exec -it -n fcg-infra deployment/sqlserver -- /bin/bash
kubectl exec -it -n fcg-infra deployment/kafka -- /bin/bash
```

## Subir uma aplicacao isolada

Cada repo possui `k8s/local` somente com manifests da propria aplicacao. Use esses scripts quando a infra ja estiver de pe:

```bash
cd fcg-users
bash k8s/local/up.sh

cd fcg-payments
bash k8s/local/up.sh

cd fcg-catalog
bash k8s/local/up.sh
```

## Troubleshooting

Se uma app nao fica ready:

```bash
kubectl get pods -n <namespace>
kubectl logs -n <namespace> deployment/<deployment>
kubectl describe pod -n <namespace> -l app.kubernetes.io/name=<app>
```

Se o SQL Server demora:

```bash
kubectl get pods -n fcg-infra -l app.kubernetes.io/name=sqlserver
kubectl logs -n fcg-infra deployment/sqlserver
kubectl logs -n fcg-infra job/sqlserver-init
```

Se precisar recriar tudo do zero:

```bash
bash down.sh --cluster
bash up.sh
```
