# Immutable Infrastructure for Crypto-DevOps
by: Coleman Word

(303) 875-2836

_Work in Progress_


# Full Disclosure:

I normally use Hashistack's Terraform and Packer with either Google Cloud Platform(Kubernetes Engine, Compute Engine, Functioins) OR Amazon Web Services(Elastic Compute, Elastic Container, Cloud Formation, Lambda) with the standard virtual private cloud networking. 

This challenge was a learning lesson for me since I normally would have connected my repo via either cloud repositorise API and then used serverless functions to automate deployments based on event triggers. 

I'm still getting used to Ansible, and should have a good handle on it within the next few weeks, but I thought you should know that this was the first time I've used it with Atomic Hosts and AWS.

I may start a project using my normal workflow to demonstrate how I normally automate CI/CD with Kubernetes and Lambda/Functions. 

## RESOURCES 
### People:

Kelsey Hightower @kelseyhightower

Carter Morgan @_askcarter

Adrian Cockcroft @adrianco
Gundega Dekena @pytonc


### Books:

Kubernetes: Up and Running, Kelsey Hightower The definitive book on Kubernetes. This has been a great resource while making this course.

Building Microservices: Defining Fine-Grained Systems This is the book Kelsey reads before giving talks about microservices. It’s that good.
Articles

Martin Fowler on the Pros and Cons of Microservices

12-Fractured Apps - One of Carters favorites articles where Kelsey breaks down problems with many modern apps and how 12-factor app methodology solves those technical woes.

Tim O’Reilly, "Open Data: Small Pieces Loosely Joined" For the history nerds: Quite possibly the first article about 
Microservices Architecture (before it even had a name).

### Videos:

Adrian Cockroft "The Evolution of Microservices"

Adrian Cockroft "The State of the Art in Microservices" (docker specific)

Martin Fowler "Microservices" at goto

Craig McLuckie "The Next Chapter in Native Cloud Computing" on cloud-native computing as being: container-packaged, dynamically-scheduled, and microservices-oriented

### The Go Programming Language:
https://golang.org/

### Docker:
We use Docker to package, distribute, and run our application.
https://www.docker.com/

### Kubernetes:
Once we have an application, we use Kubernetes to handle the heavy lifting of managing, deploying, and scaling our application.
http://kubernetes.io/

## The Twelve Factors
_I will update codebase and provide links under each factor by 6/8/18_

### I. Codebase
One codebase tracked in revision control, many deploys
- https://github.com/coleman-word/Atomic-DevOps/

### II. Dependencies
Explicitly declare and isolate dependencies

### III. Config
Store config in the environment

### IV. Backing services
Treat backing services as attached resources

### V. Build, release, run
Strictly separate build and run stages

### VI. Processes
Execute the app as one or more stateless processes

### VII. Port binding
Export services via port binding

### VIII. Concurrency
Scale out via the process model

### IX. Disposability
Maximize robustness with fast startup and graceful shutdown

### X. Dev/prod parity
Keep development, staging, and production as similar as possible

### XI. Logs
Treat logs as event streams

### XII. Admin processes
Run admin/management tasks as one-off processes


# WORKFLOW

## CLONE THIS REPOSITORY
`git clone https://github.com/coleman-word/Atomic-DevOps.git`

## INSTALL REQUIRED PACKAGES
`sudo pip install ansible`
`sudo pip install terraform`
`sudo pip install aws-cli`

## NAVIGATE TO THE TERRIFORM DIRECTORY
`cd Atomic-DevOps/terraform/aws`

## CONFIGURE AWS
`aws configure`

![](https://github.com/coleman-word/Atomic-DevOps/blob/master/images/aws-auth.png)

## INITIALIZE TERRAFORM
`terraform init`

![](https://github.com/coleman-word/Atomic-DevOps/blob/master/images/terraform-init.png)

## BUILD THE TERRAFORM CLUSTER
`terraform apply`

![](https://github.com/coleman-word/Atomic-DevOps/blob/master/images/terraform-init2.png)

![](https://github.com/coleman-word/Atomic-DevOps/blob/master/images/terraform-init3.png)

## CHECK YOUR DEPOLOYMENTS

https://console.aws.amazon.com/ec2/v2/home?region=us-east-1

![](https://github.com/coleman-word/Atomic-DevOps/blob/master/images/aws-update.png)

![](https://github.com/coleman-word/Atomic-DevOps/blob/master/images/infrastructure.png)

# Ansible Playbooks

Now that we have our infrastructure set up, its time to utilize ansible-playbooks to automate our Kubernetes deployments. 

But first, let’s ensure we can communicate via ssh with our nodes.

'''ansible -i inventory/hosts -m ping all'''

![](https://github.com/coleman-word/Atomic-DevOps/blob/master/images/ping-pong.png)

Success!
Moving On..
## Kubernetes Setup

![](Immutable%20Infrastructure%20for%20Crypto-DevOps/IMG_1950.PNG)

## Set Kubernetes Facts
```
---
# vim: set ft=ansible:
#
# This role sets up some facts related kubernetes that can be used by other
# roles as a dependency.  The initial target is the `kubernetes_setup` role.
#
- name: Get kubernetes version
  import_role:
    name: rpm_version
  vars:
    rv_rpms: kubernetes-node

- name: Define kube 1.5 vars
  when:
    - g_atomic_host is defined
    - g_atomic_host['kubernetes-node'] is defined
    - g_atomic_host['kubernetes-node'] | version_compare('1.6', '<')
  set_fact:
    kube_maj_ver: "1.5"
    kube_apiserver: "registry.access.redhat.com/rhel7/kubernetes-apiserver"
    kube_controller_manager: "registry.access.redhat.com/rhel7/kubernetes-controller-mgr"
    kube_scheduler: "registry.access.redhat.com/rhel7/kubernetes-scheduler"
    kube_system_containers: false
    kubectl_path: "/usr/bin/kubectl"

- name: Define kube 1.6 images
  when:
    - g_atomic_host is defined
    - g_atomic_host['kubernetes-node'] is defined
    - g_atomic_host['kubernetes-node'] | version_compare('1.6', '>=')
  set_fact:
    kube_maj_ver: "1.6"
    kube_apiserver: "registry.fedoraproject.org/f26/kubernetes-apiserver"
    kube_controller_manager: "registry.fedoraproject.org/f26/kubernetes-controller-manager"
    kube_scheduler: "registry.fedoraproject.org/f26/kubernetes-scheduler"
    kube_system_containers: false
    kubectl_path: "/usr/bin/kubectl"

- name: Define kube 1.9 master nodes, worker nodes and etcd images
  when: (ansible_distribution == "Fedora" and ansible_distribution_major_version > '26') or
        (ansible_distribution == "CentOSDev") or
        (g_atomic_host is not defined) or
        (g_atomic_host['kubernetes-node'] is not defined)
  set_fact:
    kube_maj_ver: "1.9"
    kube_apiserver: "registry.fedoraproject.org/f27/kubernetes-apiserver"
    kube_controller_manager: "registry.fedoraproject.org/f27/kubernetes-controller-manager"
    kube_scheduler: "registry.fedoraproject.org/f27/kubernetes-scheduler"
    kube_kubelet: "registry.fedoraproject.org/f27/kubernetes-kubelet"
    kube_proxy: "registry.fedoraproject.org/f27/kubernetes-proxy"
    etcd: "registry.fedoraproject.org/f27/etcd"
    kube_system_containers: true
    kubeconfig_path: "/etc/kubernetes/kubelet.kubeconfig"
    kubectl_path: "/usr/local/bin/kubectl"
```

## Setup Kubernetes
```
---
# vim: set ft=ansible:
#
# This role sets up kubernetes apiserver, controller-mgr, and scheduler pods.
# It requires that the `kubernetes_set_fact` role be run before it can be
# successfully used.
#
- name: Fail if kube_system_containers is not defined
  when: kube_system_containers is not defined
  fail:
    msg: |
      This role requires that the `kubernetes_set_fact` role is run
      before it can be used.

- when: kube_system_containers
  block:
    - name: Pull k8s and etcd images from the registry
      command: "atomic pull --storage ostree {{ item }}"
      register: atomic_pull
      retries: 6
      delay: 10
      until: atomic_pull|success
      with_items:
        - "{{ kube_apiserver }}"
        - "{{ kube_controller_manager }}"
        - "{{ kube_scheduler }}"
        - "{{ kube_kubelet }}"
        - "{{ kube_proxy }}"
        - "{{ etcd }}"

    - name: Install etcd + k8s system containers
      command: "atomic install --system --system-package=no {{ item }}"
      with_items:
        - "--name etcd {{ etcd }}"
        - "--name kube-apiserver {{ kube_apiserver }}"
        - "--name kube-controller-manager {{ kube_controller_manager }}"
        - "--name kube-scheduler {{ kube_scheduler }}"
        - "--name kubelet {{ kube_kubelet }}"
        - "--name kube-proxy {{ kube_proxy }}"

    # Work around https://bugzilla.redhat.com/show_bug.cgi?id=1544175
    - name: Add the necessary line for the kubelet to start
      lineinfile:
        dest: /etc/tmpfiles.d/kubelet.conf
        regexp: "^d   /var/lib/kubelet.*"
        line: "d   /var/lib/kubelet - - - - -"
      register: kubelet

    - when: kubelet|changed
      name: Re-create tmpfiles
      command: systemd-tmpfiles --create /etc/tmpfiles.d/kubelet.conf

    # Start etcd a little early to allow it to get setup + ready
    - name: Start etcd
      service:
        name: 'etcd'
        state: 'started'
        enabled: true

    - name: Edit /etc/kubernetes/apiserver
      replace:
        dest: "/etc/kubernetes/apiserver"
        regexp: "^KUBE_ADMISSION_CONTROL=.*$"
        replace: 'KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"'

    # Start apiserver to get it primed
    - name: Start apiserver
      service:
        name: 'kube-apiserver'
        state: 'started'
        enabled: true

    - name: Copy kubelet.kubeconfig file
      copy:
        src: roles/kubernetes_setup/files/kubelet.kubeconfig
        dest: "{{ kubeconfig_path }}"
        owner: root
        group: root
        mode: 0644

    - name: Add args to /etc/kubernetes/kubelet
      lineinfile:
        dest: /etc/kubernetes/kubelet
        backup: true
        backrefs: true
        regexp: '(^KUBELET_ARGS=\".*)\"\s*$'
        line: '\1 --kubeconfig={{ kubeconfig_path }} --register-node=true"'

    # Start the rest of the services
    - name: Start kubernetes services
      service:
        name: "{{ item }}"
        state: "started"
        enabled: true
      with_items:
        - "kubelet"
        - "kube-proxy"
        - "kube-controller-manager"
        - "kube-scheduler"

- when: not kube_system_containers
  block:
    - name: pull kubernetes api-server, controller-mgr, scheduler
      command: docker pull {{ item }}
      register: docker_pull
      retries: 6
      delay: 10
      until: docker_pull|success
      with_items:
        - "{{ kube_apiserver }}"
        - "{{ kube_controller_manager }}"
        - "{{ kube_scheduler }}"
        

    - name: make db directory
      file:
        path: /etc/kubernetes/manifests
        state: directory
        mode: 0755

    - name: template out apiserver, controller-manager, and scheduler pods
      template:
        src: roles/kubernetes_setup/files/{{ item }}.j2
        dest: /etc/kubernetes/manifests/{{ item }}.json
        owner: root
        group: root
        mode: 0644
      with_items:
        - apiserver-pod
        - controller-mgr-pod
        - scheduler-pod

    - name: add kubelet args
      lineinfile:
        dest: /etc/kubernetes/kubelet
        backup: true
        backrefs: true
        regexp: '(^KUBELET_ARGS=\".*)\"\s*$'
        line: '\1 --register-node=true --pod-manifest-path=/etc/kubernetes/manifests/"'

    - name: start etcd, kube-proxy, kubelet
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      with_items:
        - etcd
        - kubelet
        - kube-proxy

- name: test etcd
  command: curl http://localhost:2379/version

```
## Deploy Playbook

''' ansible-playbook kube.yml '''

This will configure and deploy services to your cluster, in addition to deploying Ethereum-Go to your worker nodes!

## COMING SOON

Ansible Playbooks to deploy Ethereum-Go containers on Kubernetes with:
-Cockpit
-Podman
-Buildah
-Skopeo

All secured by OS-Tree deployments, cyptographic verification, and SELinux.


