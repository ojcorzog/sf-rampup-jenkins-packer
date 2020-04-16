# Jenkins server creation
## Packer Jenkins AMI build:
Execute
```
packer build jenkins_ami.json
```

## Terraform infrastructure creation
Execute
```
./plan.sh jenkins_server
```
```
./apply.sh jenkins_server
```

## Configure any aditional necessary options in jenkins

Install required plugins or tools that were not included in the AMI build. (Revisit Ansible script to include necessary updates)

Create security credentials for GitHub ans AWS.

## Create the Jenkins pipeline in blueocean using the jenkins file provided under /jenkins

Also remeber configure the github webhook and slack integration if necessary.



# Setting up AWS EKS (Hosted Kubernetes)

Execute from the terraform/eks_cluster/scripts folder 
```
./plan.sh ../../eks_cluster
./apply.sh ../../eks_cluster
```
## Configure kubectl
Backup existing config for kubectl if necessary:

```
mv config config_original
```
Add new configuration to connect to the new eks cluster
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
Deploy the test app if required:
On the kubernetes folder
```
kubectl create -f sf-rampup-service.yml 
kubectl apply -f sf-rampup-deployment.yml
```

## Test the app 
Get the public ip from 
```
kubectl get svc
```

Example:
http://a6846b954ba2743148a6e51fcdc1add4-250584378.us-east-1.elb.amazonaws.com:8080/api/users

## Destroy
Make sure all the resources created by Kubernetes are removed (LoadBalancers, Security groups), and issue:
```
kubectl delete -f deployment.yml
kubectl delete svc --all

./destroy.sh ../../eks_cluster
```
# ECR authentication token
The token expires every 10 hours so it needs either to be run manually or to be configured as a cronjob

execute under kubernetes/scripts
```
./ecr_credentials_cron.sh
```
To check the secret exists
```
kubectl describe secret us-east-1-ecr-registry 
```

# Kubernetes dashboard

Just for fun, execute on the kubernetes/dashboard folder:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f admin-user.yml  
kubectl apply -f role-binding.yml
```

To get the auth token 
```
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
````
Go to the dashboard url:

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login
