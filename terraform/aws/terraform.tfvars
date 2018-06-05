#Global Vars
aws_cluster_name = "gothereum"

#VPC Vars
aws_vpc_cidr_block = "10.250.192.0/18"
aws_cidr_subnets_private = ["10.250.192.0/20","10.250.208.0/20"]
aws_cidr_subnets_public = ["10.250.224.0/20","10.250.240.0/20"]
aws_avail_zones = ["eu-central-1a","eu-central-1b"]

#Bastion Host
aws_bastion_ami = "ami-223f535d"

aws_bastion_size = "t2.micro"


#Kubernetes Cluster

aws_kube_master_num = 3
aws_kube_master_size = "t2.micro"

aws_etcd_num = 3
aws_etcd_size = "t2.micro"

aws_kube_worker_num = 4
aws_kube_worker_size = "t2.micro"

aws_cluster_ami = "ami-223f535d"

#Settings AWS ELB

aws_elb_api_port = 6443
k8s_secure_api_port = 6443
kube_insecure_apiserver_address = "0.0.0.0"

default_tags = {
#  Env = "devtest"
#  Product = "kubernetes"
}
