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
make play # to verify
make deploy # to deploy
make destroy # to destroy
```

After that, you must configure your `kubectl` with the created cluster data.
```shell
aws eks update-kubeconfig --name "eks_cluster_1"
```

So, now you can access this cluster through `kubectl`
```shell
kubectl get nodes
```