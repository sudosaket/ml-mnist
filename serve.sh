# Start TF serving on the trained results

# Note that `tfserving's modelPath` is set to `tfmnistjob's TF_EXPORT_DIR` so
# that tf serving pod automatically picks up the training results when training
# is completed.

#1. Read variables
source env.sh

cd ${APP_NAME}

#2. Create namespace if not present

ks generate tf-serving tfserving --name=${APP_NAME}

# Set tf serving job specific environment params
ks param set tfserving modelPath ${NFS_MODEL_PATH}
ks param set tfserving modelStorageType nfs
ks param set tfserving nfsPVC ${NFS_PVC_NAME}

# Deploy and start serving
ks apply ${KS_ENV} -c tfserving
