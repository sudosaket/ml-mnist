source env.sh

cd ${APP_NAME}

ks delete ${KS_ENV} -c tfserving
kubectl get pods -n ${NAMESPACE}

JOB=tf-${APP_NAME}job
ks delete ${KS_ENV} -c ${JOB} 

ks delete ${KS_ENV} -c nfs-volume
kubectl get pv -n ${NAMESPACE}
kubectl get pvc -n ${NAMESPACE}

ks delete ${KS_ENV} -c nfs-server

ks delete ${KS_ENV} -c centraldashboard
ks delete ${KS_ENV} -c tf-job-operator
kubectl get pods -n ${NAMESPACE}

ks env rm ${KS_ENV}
kubectl delete namespace ${NAMESPACE} 

cd ..
rm -rf ${APP_NAME}