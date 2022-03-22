# Redis Proxy Test

- create persistent volume
	- kubectl apply -f redis-pv.yml
- create stateful set
	- kubectl apply -f redis-sts.yml
- create service
	- kubectl apply -f redis-svc.yml

- create redis-cluster-proxy
	- kubectl apply -f redis-cluster-proxy.yml


origin: https://github.com/llmgo/redis-sts
