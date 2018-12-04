# Start the training job

#1. Read variables
source env.sh

cd ${APP_NAME}

# Set training job specific environment variables in `envs` variable(comma
# separated key-value pair). These key-value pairs are passed on to the
# training job when created.
ENV="TF_DATA_DIR=$TF_DATA_DIR,TF_EXPORT_DIR=$TF_EXPORT_DIR,TF_MODEL_DIR=$TF_MODEL_DIR"

JOB=tf-${APP_NAME}job
ks generate ${JOB} ${JOB}

# Set tf training job specific environment params
ks param set ${JOB} image ${IMAGE}
ks param set ${JOB} envs ${ENV}

# Deploy and start training
ks apply ${KS_ENV} -c ${JOB}

# Check that the container is up and running
kubectl get pods -n ${NAMESPACE} | grep ${JOB}
