Kubernetes and Rails
===


## Rails
A simple project to URL shortener inside the folder url-shortener

If you haven't rails installed yet, install it globally
```shell
gem install rails
```

Then, enter in the project directory
```shell
cd url-shortener
```

After that, install the dependencies
```shell
bundle install
```

Finally, run the app.
```shell
rails s
```


## Kubernetes

To deploy Kubernetes on AWS with this project, you must have an `.env` file with your AWS credentials like the one below in this folder's root.

```
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Than you can run:

```shell
make plan # to check deployment plan
make deploy # to deploy
make destroy # to destroy
```

After that, you must configure your `kubectl` with the created cluster data.
```shell
aws eks update-kubeconfig --name "my-eks" 
```

Now, we create a echoserver to test ingress with the aws-load-balancer-controller.

```shell
kubectl apply -f infra/terraform/totorial/k8s/echoserver.yaml 
```

If it was successful an loadbacancer will be created on demand for the ingress.
Now we have to wait that loadBalancer has a endpoint to create a CNAME registry pointing to it.
In my case the cname will be `echo.4developments.net.` because my registered domain is `4developments.net` but you have to adapt and create your own.

```shell
curl http://echo.4developments.net
```


### Using k3d
```shell
k3d cluster delete mycluster

# to use ingress
# you have to forwards http traffic from localhost:80 to the Ingress controller
k3d cluster create mycluster \
    --api-port 6550 \
    --port "80:80@loadbalancer"   \
    --agents 2


k3d kubeconfig merge mycluster
```
if you need to delete old cluster config
```shell
kubectl config get-clusters
kubectl config delete-cluster CLUSTER_NAME
```
Some basic commands for helping debug
```shell
# to see nodes health
kubectl get nodes 

# getting first pod name (you will need to filter to be more specific)
kubectl $(kubectl get pods -ojson | jq -r '.items[0].metadata.name')

# binding ports in a pod
kubectl port-forward $(kubectl get pods -ojson | jq -r '.items[0].metadata.name') 8080:3000

# tail logs from a specific pod (the first one here)
kubectl logs -f $(kubectl get pods -ojson | jq -r '.items[0].metadata.name')
```

Applying a manifest for deploy a service using loadbalancer ingress in k3d
```shell
kubectl apply -f deployment.yaml
```

