1. excecute packer build:

packer build jenkins_ami.json

2. execute ./plan.sh jenkins_server  and ./apply.sh jenkins_server

3. configure any aditional necessary options in jenkins

4. create the pipeline using the jenkins file provided under /jenkins


# Setting up AWS EKS (Hosted Kubernetes)

execute ./plan.sh ../../eks_cluster and ./apply.sh ../../eks_cluster

## Configure kubectl
```
terraform output kubeconfig > ~/.kube/config
aws eks --region us-east-1 update-kubeconfig --name terraform-eks-sf-rampup
```

## Configure config-map-auth-aws
```
terraform output config-map-aws-auth > config-map-aws-auth.yaml
kubectl apply -f config-map-aws-auth.yaml
```

## See nodes coming up
```
kubectl get nodes
```

## Destroy
Make sure all the resources created by Kubernetes are removed (LoadBalancers, Security groups), and issue:
```
./destroy.sh ../../eks_cluster
```
