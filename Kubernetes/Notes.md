# Kubernetes Quick Notes

## What is K8s ?
- It is a container orchestration tool use to orchestrate the deployment and management  of these thousands of cointainers in the clustered environment using declarative object configuration files. 

- Kubernetes Architecture
    - `Cluster` -  Set of kubernetes nodes or worker nodes where my application runs.
    - `Master` -  Manages the cluster and its information(perfomed actuall orchestration).

    Components of K8s
    - `API server` -  Frontend of K8s. 
    - `etcd`     -  key-value storage to store cluster information.
    - `Scheduler` -  Distributing the work or containers across multiple nodes.
    - `Container Runtime` -  Underline software used to run the containers. (docker)
    - `Controller` -  Brain behind Orchestration (watches the health of K8 cluster and bring up the nodes which are down)
    - `kublet` -  Agent running on the each node in the cluster. Resposible for container running   on node as expected.


## Pods in K8s
- In K8s, a pod is smallest object and a single instance of a running container.
- A docker container is encapsulated under a pod.
- Pods having one-to-one relation with you container running thr application.
- To scale up, create new pods.
- To scale down, delete existing pods.
- Do not add additional container to you existing pod if you want to scale your application.

- Pods can have one or more container running the application (if application needs some helper container to run along).
- conatiner dies, helper also dies. (Tightly coupled).

- In general and good practice to have one container in one pod.


### How to deploy Pods?
- `kubectl run nginx --image nginx`

### List the available pods
- `kubectl get pods`

### To create a deployment using imperative command, use kubectl create:
- `kubectl create deployment nginx --image=nginx`

-------------------------------------------------------------------------------------------

# Pods using YAML based config files:
- In K8s, we create kubernetes objects like pods, deployments services, replicas using YAML files as a input.
- Sample `pod_defination.yml`

```
apiVersion:v1                                           kind        |       Version
kind: Pod                                           ---------------------------------   
metadata:                                               POD         |       v1
    name: my-app                                        Service     |       v1
    label:                                              Replica Set |      apps/v1 
        app: myapp                                      Deployment  |      apps/v1     
        type: front-end                                
spec: 
    containers:
        - name: nginx-container
          image: nginx
```

## How to create pod from the above example yml file?
- `kubectl create -f  pod_defination.yml`

## Create a pod-defination YAML file using kubectl run command
- `kubectl run <pod_name> --image=<image_name> --dry-rum=client -o yaml` 
-  It will create a YAML fole for a pod which we want to create

## Detailed Information about Pods
- `kubectl describe pod <pod_name>`


# Replica Set in K8s
- Replica set's purpose is to maintain the set of replicas needed to run oour application.
- If application needs 5 replicas of a container, it will run 5 replicas.
- Anyhow one replica dies, it will automatically spin up another replica for you.

## Create a Replica Set
- `kubectl create -f replicaset-def.yml`          
- `replicaset-def.yml` - YAML config file for replica set

## List existing Replica set
- `kubectl get replicaset`

## Delete Replica set
- `kubectl delete replicaset <replicaset_name>`      
- This also deletes the underlined pods.

## Scale the replicas in the replica set
- `kubectl scale -f <replicaset_def_file.yml>`
- `kubectl scale -replicas=6 -f <replicaset_def_file.yml>`


## Example YAML config replicaset file
    apiVersion: apps/v1
    kind: ReplicaSet
    metadata:
    name: replicaset-1
    spec:
    replicas: 2
    selector:
        matchLabels:
        tier: frontend
    template:
        metadata:
        labels:
            tier: frontend
        spec:
        containers:
        - name: nginx
            image: nginx



# Deployments in K8s
- Provides updates on Pods and Replicasets

## Use cases
- Create a Deployment to rollout a ReplicaSet. 
- Declare the new state of the Pods. 
- Rollback to an earlier Deployment revision.
- Scale up the Deployment to facilitate more load.
- Pause the rollout of a Deployment.
- Use the status of the Deployment. 
- Clean up older ReplicaSets.

----------------
Hierarchy order
----------------

`Containers ---> Pods ---> Replicasets ---> Deployments`


## Create a deployment
- `kubectl create -f deployment-def.yml` 

## Sample deployment.yml file

``` yaml
apiVersion: apps/v1
kind: deployment
metadata:
  name: deployment-1
spec:
  replicas: 2
  selector:
    matchLabels:
      name: busybox-pod
  template:
    metadata:
      labels:
        name: busybox-pod
    spec:
      containers:
      - name: busybox-container
        image: busybox888
        command:
        - sh
        - "-c"
        - echo Hello Kubernetes! && sleep 3600

```
# Updates and Rollbacks in Deployments 
## Types of Upgrades:
- `Recreate` - Destroy all existing pods and recreates it will newer version (not recommended).
- `Rolling update` is the default upgrading strategy(take one pod at a time and upgrade it as another is geeting destroyed)

## Upgrade
- `kubectl apply -f <deployment.yml>`                         
(Edit newer image name in the file).
- `kubectl set image deployments/<depl_name> <image_name>=<new_image_name>`

## Rollback
- `kubectl rollout undo deployments/<deployment_name>`

## Rollout status
- `kubectl rollout status deployments/<deployment_name>`

## Rollout history
- `kubectl rollout history deployments/<deployment_name>`

## Why rollback?
- Suppose you encounter any issue or missing update while upgrading your application and its is not working well for the end users, there we can perform rollback and bring application into the older state.



# Networking in K8s
- In K8s, IPs are assigned to a Pod.
- Unfortunately, K8s does not implement any netorking solution on its own. We explicitly need to set the networking solution.
- Rules withe setup networking in K8s
    - All pods/containers can communicate to one another without NAT.
    - All nodes can communicate with all containers and vice-versa without NAT.

# Services in K8s
- Service is a method for exposing a network application that is running as one or more Pods in your cluster.

## Services are of 3 types:
    - Nodeport
    - ClusterIP
    - Load Balancer



---

# Kubernetes Update and Project Videos – Your Essential Guide
## Uncover additional insights through the videos listed below:

### Kubernetes Update Videos - 

1. Kubernetes v1.27 Update
Kubernetes Update 1.27: Chill Vibes Edition – Exploring the Latest Enhancements
https://www.youtube.com/watch?v=rUFgZuIp1mY

2. Kubernetes v1.28 Update
Kubernetes Update 1.28: Planternetes Edition – Exploring the Latest Enhancements
https://www.youtube.com/watch?v=mRlBtYc-HSk

3. Kubernetes v1.29 Update
Exploring Kubernetes 1.29 Updates – Mandala Universe
https://www.youtube.com/watch?v=yCkQgKVwSVU

Kubernetes Project Videos -
1. Special Interest Groups (SIGs) in Kubernetes
Kubernetes SIGs: What They Are and How They Work
https://www.youtube.com/watch?v=EoKuPoFXY-k&t=2s

2. Kubernetes Enhancement Proposals (KEPs) Unveiled
What are Kubernetes Enhancement Proposals (KEPs)?
https://www.youtube.com/watch?v=B810TDzTQsQ







