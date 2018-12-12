#1. Read variables
source env.sh

#2. Create namespace if not present
kubectl create namespace ${NAMESPACE}

#3. Initialize the ksonnet app and create ksonnet environment
ks init ${APP_NAME}
cd ${APP_NAME}
ks env add ${KS_ENV}
ks env set ${KS_ENV} --namespace ${NAMESPACE}

#4. Add Ksonnet registries for adding prototypes. Prototypes are ksonnet templates

## Public registry that contains the official kubeflow components
ks registry add kubeflow github.com/kubeflow/kubeflow/tree/v0.3.0-rc.3/kubeflow

## Private registry that contains ${APP_NAME} example components
ks registry add mypkgs ../pkg

#5. Install necessary packages from registries

ks pkg install kubeflow/core
ks pkg install kubeflow/tf-serving

ks pkg install mypkgs/nfs-server
ks pkg install mypkgs/nfs-volume
ks pkg install mypkgs/tf-mnistjob

#6. Deploy kubeflow core components to K8s cluster.

ks generate tf-job-operator tf-job-operator
ks apply ${KS_ENV} -c tf-job-operator 

#7. Deploy NFS server in the k8s cluster **(Optional step)**

# If you have already setup a NFS server, you can skip this step and proceed to
# step 8. Set `NFS_SERVER_IP`to ip of your NFS server
NFS_SERVER_IP=`kubectl -n ${NAMESPACE} get svc/nfs-server  --output=jsonpath={.spec.clusterIP}`
if [[ -z "$NFS_SERVER_IP" ]]; then
    ks generate nfs-server nfs-server
    ks apply ${KS_ENV} -c nfs-server
fi

#8. Deploy NFS PV/PVC in the k8s cluster **(Optional step)**

# If you have already created NFS PersistentVolume and PersistentVolumeClaim,
# you can skip this step and proceed to step 9.
NFS_SERVER_IP=`kubectl -n ${NAMESPACE} get svc/nfs-server  --output=jsonpath={.spec.clusterIP}`
ks generate nfs-volume nfs-volume  --name=${NFS_PVC_NAME}  --nfs_server_ip=${NFS_SERVER_IP}
ks apply ${KS_ENV} -c nfs-volume

#### Installation is complete now ####

kubectl get pods -n ${NAMESPACE}
kubectl get pvc -n ${NAMESPACE}